// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: spacefibre_lane_top.v
// Padrao : ECSS-E-ST-50-11C
// Funcao : Top-Level da Camada de Lane (Lane Layer Top-Level Integration)
//          Integra a FSM LISM (fsm_layer), Word Aligner, Elastic Buffer, LLCW Processor,
//          Encoder/Decoder 8b/10b e Contador RXERR.
// ============================================================================

`timescale 1ns / 1ps

module spacefibre_lane_top #(
    parameter DEFAULT_ERR_THRESHOLD = 8,
    parameter TIMER_CLEAR_LIMIT     = 10
)(
    input  wire        clk,                 // Clock principal do sistema (125 MHz)
    input  wire        rst_n,               // Reset assincrono ativo baixo

    // ------------------------------------------------------------------------
    // 1. INTERFACE INFERIOR (PHY SerDes)
    // ------------------------------------------------------------------------
    output wire        line_driver_en,      // Habilita CML Line Driver (TX)
    output wire        line_rx_en,          // Habilita CML Line Receiver (RX)
    output wire        cdr_en,              // Habilita Clock and Data Recovery
    output wire        invert_rx_polarity,  // Habilita inversao de polaridade de recepcao
    input  wire        loss_of_signal,      // Indicador NoSignal / Perda de Sinal da PHY
    output wire [9:0]  tx_10b_symbol,       // Simbolo paralelo de 10 bits para o Serializador
    input  wire [9:0]  rx_10b_symbol,       // Simbolo paralelo de 10 bits do Desserializador

    // ------------------------------------------------------------------------
    // 2. INTERFACE SUPERIOR (Data Link / Multi-Lane Layer)
    // ------------------------------------------------------------------------
    input  wire [31:0] dl_tx_word,          // Palavra de 32 bits a transmitir
    input  wire [3:0]  dl_tx_k_flags,       // Flags K para a palavra TX {k3,k2,k1,k0}
    input  wire        dl_tx_valid,         // Pulso de validade da palavra TX
    output wire [31:0] dl_rx_word,          // Palavra de 32 bits alinhada recebida
    output wire [3:0]  dl_rx_k_flags,       // Flags K da palavra RX {k3,k2,k1,k0}
    output wire        dl_rx_valid,         // Pulso de validade da palavra RX
    output wire        lane_active,         // 1: Link no estado ST_ACTIVE (3'b100)
    output wire [7:0]  far_end_capabilities,// Capacidades da extremidade remota (INIT3)

    // ------------------------------------------------------------------------
    // 3. INTERFACE DE GESTAO (MIB - Management Information Base)
    // ------------------------------------------------------------------------
    input  wire        lane_start,          // Comando para iniciar a Lane
    input  wire        auto_start,          // Habilita auto-start ao detectar sinal
    input  wire        lane_reset,          // Reset por software da Lane
    input  wire        parallel_loopback_en,// Habilita Loopback Paralelo Interno
    input  wire [7:0]  error_threshold,     // Limite configuravel do contador RXERR
    output wire [2:0]  lane_state,          // Codigo do estado atual da FSM LISM
    output wire [15:0] rxerr_count,         // Leitura do contador de erros
    output wire        rx_polarity_status   // Status da inversao de polaridade ativa
);

    // Retention Register para o sinal de inicializacao da Lane (MIB)
    // Retention Register para o sinal de inicializacao da Lane (MIB)
    reg lane_enabled_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lane_enabled_reg <= 1'b0;
        end else if (lane_reset) begin
            lane_enabled_reg <= 1'b0;
        end else if (lane_start || (auto_start && !loss_of_signal)) begin
            lane_enabled_reg <= 1'b1;
        end
    end

    // Sinalizacao de Loopback Paralelo Interno
    wire [9:0] tx_10b_int;
    assign tx_10b_symbol = tx_10b_int;
    wire [9:0] phy_rx_symbol = parallel_loopback_en ? tx_10b_int : rx_10b_symbol;

    // Sinais internos de interconexao
    wire [9:0] aligned_rx_10b;
    wire       word_aligned;
    wire       comma_det;
    wire       realign_trigger;

    wire [9:0] eb_dout_10b;
    wire       eb_empty;
    wire       eb_full;
    wire [4:0] eb_fill_count;
    wire       skip_deleted;
    wire       skip_inserted;

    wire [7:0] dec_rx_byte;
    wire       dec_rx_k;
    wire       dec_code_err;
    wire       dec_disp_err;

    wire [7:0] enc_tx_byte;
    wire       enc_tx_k;

    wire        tx_send_cmd;
    wire [3:0]  tx_cmd_type;
    wire [31:0] tx_llcw_word;
    wire [3:0]  tx_llcw_k_flags;
    wire        tx_word_valid;

    wire        rx_cmd_valid;
    wire [3:0]  rx_cmd_type;
    wire        rx_llcw_err;

    wire        scramble_en;
    wire [1:0]  tx_init_cmd;

    // Validade do pipeline RX: o Elastic Buffer entrega dado 1 ciclo apos a leitura
    // e o decodificador registra mais 1 ciclo. Erros so contam com dado valido


    reg eb_out_valid, dec_out_valid;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            eb_out_valid  <= 1'b0;
            dec_out_valid <= 1'b0;
        end else if (lane_reset) begin
            eb_out_valid  <= 1'b0;
            dec_out_valid <= 1'b0;
        end else begin
            eb_out_valid  <= word_aligned && !eb_empty;
            dec_out_valid <= eb_out_valid && word_aligned;
        end
    end

// Expõe a saída através de um assign ou renomeia o fio de saída
wire dec_out_valid = dec_out_valid_reg;
    wire        rx_err_tick = (dec_out_valid && (dec_code_err || dec_disp_err)) || rx_llcw_err;
    wire        threshold_exceeded;

    // 1. Word Aligner
    word_aligner word_aligner_inst (
        .clk          (clk),
        .rst_n        (rst_n && !lane_reset),
        .realign      (realign_trigger),
        .din_10b      (phy_rx_symbol),
        .dout_10b     (aligned_rx_10b),
        .word_aligned (word_aligned),
        .comma_det    (comma_det)
    );

    // 2. Elastic Buffer
    elastic_buffer #(
        .DEPTH          (16),
        .HIGH_WATERMARK (12),
        .LOW_WATERMARK  (2)
    ) elastic_buffer_inst (
        .wr_clk        (clk),
        .rd_clk        (clk),
        .rst_n        (rst_n && !lane_reset),
        .wr_en        (word_aligned),
        .rd_en        (word_aligned),
        .din_10b      (aligned_rx_10b),
        .dout_10b     (eb_dout_10b),
        .empty        (eb_empty),
        .full         (eb_full),
        .fill_count   (eb_fill_count),
        .skip_deleted (skip_deleted),
        .skip_inserted(skip_inserted)
    );

    // 3. Decodificador 8b/10b
    decoder_8b10b decoder_inst (
        .clk      (clk),
        .rst_n    (rst_n && !lane_reset),
        .din      (eb_dout_10b),
        .dout     (dec_rx_byte),
        .kout     (dec_rx_k),
        .code_err (dec_code_err),
        .disp_err (dec_disp_err)
    );

    // 4. Codificador 8b/10b
    encoder_8b10b encoder_inst (
        .clk     (clk),
        .rst_n   (rst_n && !lane_reset),
        .din     (enc_tx_byte),
        .kin     (enc_tx_k),
        .dout    (tx_10b_int)
    );

    assign enc_tx_byte = tx_word_valid ? tx_llcw_word[7:0] : dl_tx_word[7:0];
    assign enc_tx_k    = tx_word_valid ? tx_llcw_k_flags[0] : dl_tx_k_flags[0];

    // 5. Processador LLCW
    llcw_processor llcw_proc_inst (
        .clk                 (clk),
        .rst_n               (rst_n && !lane_reset),
        .tx_send_cmd         (tx_send_cmd),
        .tx_cmd_type         (tx_cmd_type),
        .tx_capabilities_in  (8'hA5),
        .tx_llcw_word        (tx_llcw_word),
        .tx_llcw_k_flags     (tx_llcw_k_flags),
        .tx_word_valid       (tx_word_valid),
        .rx_word_in          (dl_rx_word),
        .rx_k_in             (dl_rx_k_flags),
        .rx_word_valid       (dl_rx_valid && dl_rx_k_flags[0]), // Apenas palavras iniciadas por K sao candidatas a LLCW
        .rx_cmd_valid        (rx_cmd_valid),
        .rx_cmd_type         (rx_cmd_type),
        .rx_capabilities_out (far_end_capabilities),
        .rx_llcw_err         (rx_llcw_err)
    );

    // 6. Contador de Erros RXERR
    rxerr_counter #(
        .DEFAULT_THRESHOLD(DEFAULT_ERR_THRESHOLD)
    ) rxerr_cnt_inst (
        .clk                (clk),
        .rst_n              (rst_n && !lane_reset),
        .active_state       (lane_active),
        .rx_err_tick        (rx_err_tick),
        .clear_cnt          (!lane_active), // Zera ao sair de ST_ACTIVE
        .error_threshold    (error_threshold),
        .rxerr_cnt          (rxerr_count),
        .threshold_exceeded (threshold_exceeded)
    );

    // 7. Maquina de Estados FSM LISM da Lane Layer (fsm_layer)
    fsm_layer #(
        .TIMER_CLEAR_LIMIT(TIMER_CLEAR_LIMIT)
    ) fsm_inst (
        .clk             (clk),
        .sys_rst_n       (rst_n && !lane_reset),
        .lane_enable     (lane_enabled_reg),
        .pll_lock        (1'b1), // Lock simulado da PHY
        .loss_of_signal  (loss_of_signal),
        .word_aligned    (word_aligned),
        .rx_init_seq     (1'b1), // Sequencia INIT simulada
        .code_violation  (threshold_exceeded),
        .line_driver_en  (line_driver_en),
        .cdr_en          (cdr_en),
        .scramble_en     (scramble_en),
        .tx_init_cmd     (tx_init_cmd),
        .lane_active     (lane_active),
        .current_state_o (lane_state)
    );

    // Mapeamento do comando INIT da FSM para o Processador LLCW
    // (tx_init_cmd: 00=None, 01=INIT1, 10=INIT2, 11=INIT3)
    assign tx_send_cmd = (tx_init_cmd != 2'b00);
    assign tx_cmd_type = (tx_init_cmd == 2'b01) ? 4'd1 :   // CMD_INIT1
                         (tx_init_cmd == 2'b10) ? 4'd3 :   // CMD_INIT2
                         (tx_init_cmd == 2'b11) ? 4'd5 :   // CMD_INIT3
                                                  4'd0;    // CMD_NONE

    assign line_rx_en         = line_driver_en;
    assign realign_trigger    = (lane_state == 3'b001); // Trigger em ST_CLEAR_LINE
    assign invert_rx_polarity = 1'b0;
    assign rx_polarity_status = invert_rx_polarity;

    assign dl_rx_word    = {24'b0, dec_rx_byte};
    assign dl_rx_k_flags = {3'b0, dec_rx_k};
    assign dl_rx_valid   = dec_out_valid;

endmodule
