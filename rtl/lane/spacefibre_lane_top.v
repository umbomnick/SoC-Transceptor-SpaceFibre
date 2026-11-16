// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/spacefibre_lane_top.v
// Padrao : ECSS-E-ST-50-11C (Clausula 5.5)
// Funcao : Top-Level da Lane Layer estritamente conforme fronteira ECSS:
//          - LISM de 10 estados (fsm_layer)
//          - Word Aligner + Sincronizador de 32 bits + Receive Sync FSM
//          - Elastic Buffer em nivel de palavra (SKIP a cada SKIP_PERIOD palavras)
//          - Processador LLCW (Tabela 5-3) e filtro de IDLE/SKIP
//          - Codec 8B/10B com verificacao estrita da Tabela 5-11 e K0.0
//          - Inversao automatica de polaridade RX (iINIT1 / iINIT2)
//          Nota: Scrambling e Framing pertencem exclusivamente a Data Link Layer.
// ============================================================================
`timescale 1ns / 1ps

module spacefibre_lane_top #(
    parameter DEFAULT_ERR_THRESHOLD = 8,
    parameter TIMER_CLEAR_LIMIT     = 200,
    parameter HANDSHAKE_WORDS       = 1023,
    parameter INIT_TIMEOUT_WORDS    = 5000,
    parameter ABORT_WORDS           = 32,
    parameter SKIP_PERIOD           = 5000,
    parameter INTERNAL_POLARITY_INV = 1
)(
    input  wire        clk,
    input  wire        rst_n,

    // 1. Interface Inferior (PHY SerDes - 1 simbolo de 10b por ciclo)
    output wire        line_driver_en,
    output wire        line_rx_en,
    output wire        cdr_en,
    output wire        invert_rx_polarity,
    input  wire        loss_of_signal,
    output wire [9:0]  tx_10b_symbol,
    input  wire [9:0]  rx_10b_symbol,

    // 2. Interface Superior (Data Link Layer - palavras de 32 bits)
    input  wire [31:0] dl_tx_word,
    input  wire [3:0]  dl_tx_k_flags,
    input  wire        dl_tx_valid,
    output wire        dl_tx_ready,
    output reg  [31:0] dl_rx_word,
    output reg  [3:0]  dl_rx_k_flags,
    output reg         dl_rx_valid,
    output reg         dl_rx_err,
    output wire        lane_active,
    input  wire [7:0]  near_end_capabilities,
    output wire [7:0]  far_end_capabilities,
    output wire        far_end_caps_valid,

    // 3. Interface de Gestao (MIB)
    input  wire        lane_start,
    input  wire        auto_start,
    input  wire        lane_reset,
    input  wire        parallel_loopback_en,
    input  wire [7:0]  error_threshold,
    output wire [2:0]  lane_state,
    output wire [15:0] rxerr_count,
    output wire        rx_polarity_status
);

    // Sincronizador de reset (assert assincrono, deassert sincrono)
    reg [1:0] rst_sync;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) rst_sync <= 2'b00;
        else        rst_sync <= {rst_sync[0], 1'b1};
    end
    wire rst_int_n = rst_sync[1];

    // Registrador de retencao para o comando LaneStart (compativel com pulso ou nivel)
    reg lane_enabled_reg;
    always @(posedge clk or negedge rst_int_n) begin
        if (!rst_int_n)       lane_enabled_reg <= 1'b0;
        else if (lane_reset)  lane_enabled_reg <= 1'b0;
        else if (lane_start)  lane_enabled_reg <= 1'b1;
    end

    // Loopback paralelo interno (ECSS 5.5.5c) e inversao digital de polaridade RX
    wire [9:0] tx_10b_int;
    assign tx_10b_symbol = tx_10b_int;

    wire [9:0] phy_rx_raw    = parallel_loopback_en ? tx_10b_int : rx_10b_symbol;
    wire       inv_pol_int;
    wire       pol_flip_pulse;
    wire [9:0] phy_rx_symbol = (INTERNAL_POLARITY_INV && inv_pol_int) ? ~phy_rx_raw : phy_rx_raw;

    assign invert_rx_polarity = inv_pol_int;
    assign rx_polarity_status = inv_pol_int;

    // ------------------------------------------------------------------------
    // Caminho RX: Word Aligner -> Decoder 8B/10B -> Word Sync -> Elastic Buffer -> LLCW
    // ------------------------------------------------------------------------
    wire [9:0] aligned_rx_10b;
    wire       word_aligned;
    wire       comma_det;
    wire       realign_req_sync;
    wire [3:0] lism_state_ecss;

    wire rx_path_inactive = !cdr_en || pol_flip_pulse;
    wire realign_trigger  = rx_path_inactive || realign_req_sync;

    word_aligner word_aligner_inst (
        .clk          (clk),
        .rst_n        (rst_int_n),
        .realign      (realign_trigger),
        .din_10b      (phy_rx_symbol),
        .dout_10b     (aligned_rx_10b),
        .word_aligned (word_aligned),
        .comma_det    (comma_det)
    );

    reg dec_in_valid;
    reg rx_rd_synced;
    always @(posedge clk or negedge rst_int_n) begin
        if (!rst_int_n) begin
            dec_in_valid <= 1'b0;
            rx_rd_synced <= 1'b0;
        end else if (!word_aligned || rx_path_inactive) begin
            dec_in_valid <= 1'b0;
            rx_rd_synced <= 1'b0;
        end else begin
            dec_in_valid <= 1'b1;
            if (dec_in_valid) rx_rd_synced <= 1'b1;
        end
    end

    wire [7:0] dec_rx_byte;
    wire       dec_rx_k;
    wire       dec_code_err;
    wire       dec_disp_err;

    decoder_8b10b #(
        .SPACEFIBRE_STRICT_K(1)
    ) decoder_inst (
        .clk      (clk),
        .rst_n    (rst_int_n),
        .din      (aligned_rx_10b),
        .hold     (!word_aligned),
        .rd_sync  (!rx_rd_synced),
        .dout     (dec_rx_byte),
        .kout     (dec_rx_k),
        .code_err (dec_code_err),
        .disp_err (dec_disp_err)
    );

    wire        ws_sync_ready;
    wire        ws_word_valid;
    wire [31:0] ws_word;
    wire [3:0]  ws_k;
    wire        ws_err;

    rx_word_sync u_rx_word_sync (
        .clk          (clk),
        .rst_n        (rst_int_n),
        .sync_reset   (!word_aligned || rx_path_inactive),
        .sym_valid    (dec_in_valid),
        .sym_byte     (dec_rx_byte),
        .sym_k        (dec_rx_k),
        .sym_err      (dec_code_err | dec_disp_err),
        .sync_ready   (ws_sync_ready),
        .realign_req  (realign_req_sync),
        .word_valid   (ws_word_valid),
        .word_out     (ws_word),
        .word_k_out   (ws_k),
        .word_err_out (ws_err)
    );

    wire        eb_dout_valid;
    wire [31:0] eb_dout_word;
    wire [3:0]  eb_dout_k;
    wire        eb_dout_err;
    wire        eb_empty, eb_full, skip_deleted, skip_inserted;
    wire [3:0]  eb_fill_count;

    elastic_buffer #(
        .DEPTH          (8),
        .HIGH_WATERMARK (6),
        .LOW_WATERMARK  (1),
        .START_LEVEL    (2)
    ) elastic_buffer_inst (
        .clk           (clk),
        .rst_n         (rst_int_n),
        .flush         (!word_aligned || rx_path_inactive),
        .wr_en         (ws_word_valid),
        .din_word      (ws_word),
        .din_k         (ws_k),
        .din_err       (ws_err),
        .dout_valid    (eb_dout_valid),
        .dout_word     (eb_dout_word),
        .dout_k        (eb_dout_k),
        .dout_err      (eb_dout_err),
        .empty         (eb_empty),
        .full          (eb_full),
        .fill_count    (eb_fill_count),
        .skip_deleted  (skip_deleted),
        .skip_inserted (skip_inserted)
    );

    // ------------------------------------------------------------------------
    // Processador LLCW + Filtro RX para Data Link Layer (ECSS 5.5.2.11b.8/9)
    // ------------------------------------------------------------------------
    wire [3:0]  lism_tx_cmd;
    wire        tx_send_llcw;
    wire [3:0]  tx_cmd_mux;
    wire [31:0] tx_llcw_word;
    wire [3:0]  tx_llcw_k_flags;
    wire        tx_llcw_valid;

    wire        rx_is_llcw_space;
    wire        rx_cmd_valid;
    wire [3:0]  rx_cmd_type;
    wire        rx_llcw_err;

    llcw_processor llcw_proc_inst (
        .clk                 (clk),
        .rst_n               (rst_int_n),
        .tx_send_cmd         (tx_send_llcw),
        .tx_cmd_type         (tx_cmd_mux),
        .tx_capabilities_in  (near_end_capabilities),
        .tx_reason_in        (8'h01),
        .tx_llcw_word        (tx_llcw_word),
        .tx_llcw_k_flags     (tx_llcw_k_flags),
        .tx_word_valid       (tx_llcw_valid),
        .rx_word_in          (eb_dout_word),
        .rx_k_in             (eb_dout_k),
        .rx_word_valid       (eb_dout_valid),
        .rx_word_err         (eb_dout_err),
        .rx_is_llcw_space    (rx_is_llcw_space),
        .rx_cmd_valid        (rx_cmd_valid),
        .rx_cmd_type         (rx_cmd_type),
        .rx_capabilities_out (far_end_capabilities),
        .rx_caps_valid       (far_end_caps_valid),
        .rx_llcw_err         (rx_llcw_err)
    );

    // ECSS 5.5.2.11b.8: apenas LOST_SIGNAL, STANDBY, INIT1 ou LLCW malformada geram RXERR em Active;
    // ECSS 5.5.2.11b.9: todas as demais LLCWs (INIT3 residual em voo, SKIP, IDLE) sao filtradas.
    wire rx_abort_llcw_act = lane_active && eb_dout_valid && !eb_dout_err &&
                             ((rx_cmd_valid && ((rx_cmd_type == 4'd1) || (rx_cmd_type == 4'd2) ||
                                                (rx_cmd_type == 4'd8) || (rx_cmd_type == 4'd9))) ||
                              rx_llcw_err);

    always @(posedge clk or negedge rst_int_n) begin
        if (!rst_int_n) begin
            dl_rx_word    <= 32'd0;
            dl_rx_k_flags <= 4'd0;
            dl_rx_valid   <= 1'b0;
            dl_rx_err     <= 1'b0;
        end else begin
            dl_rx_valid <= 1'b0;
            dl_rx_err   <= 1'b0;
            if (lane_active && eb_dout_valid) begin
                if (eb_dout_err || rx_abort_llcw_act) begin
                    dl_rx_valid   <= 1'b1;
                    dl_rx_err     <= 1'b1;
                    dl_rx_word    <= 32'h0000_0000;
                    dl_rx_k_flags <= 4'b0001;
                end else if (!rx_is_llcw_space) begin
                    dl_rx_valid   <= 1'b1;
                    dl_rx_err     <= 1'b0;
                    dl_rx_word    <= eb_dout_word;
                    dl_rx_k_flags <= eb_dout_k;
                end
            end
        end
    end

    // ------------------------------------------------------------------------
    // Contador RXERR e LISM (ECSS 5.5.2.11b.6)
    // ------------------------------------------------------------------------
    wire sym_err_tick       = dec_in_valid && (dec_code_err || dec_disp_err);
    wire rx_err_tick        = sym_err_tick || (lane_active && eb_dout_valid && rx_llcw_err);
    wire threshold_exceeded;

    rxerr_counter #(
        .DEFAULT_THRESHOLD(DEFAULT_ERR_THRESHOLD)
    ) rxerr_cnt_inst (
        .clk                (clk),
        .rst_n              (rst_int_n),
        .active_state       (lane_active),
        .rx_word_tick       (eb_dout_valid),
        .rx_err_tick        (rx_err_tick),
        .clear_cnt          (!lane_active || lane_reset),
        .error_threshold    (error_threshold),
        .rxerr_cnt          (rxerr_count),
        .threshold_exceeded (threshold_exceeded)
    );

    // Serializador TX de 32 bits -> 4 simbolos de 8B/10B + gerador periodico de SKIP
    localparam SKIP_W = (SKIP_PERIOD > 1) ? $clog2(SKIP_PERIOD) : 1;
    reg [1:0]        tx_sym_idx;
    reg [SKIP_W-1:0] skip_cnt;
    reg              skip_req;

    wire tx_word_boundary = (tx_sym_idx == 2'd3);
    wire tx_insert_skip   = lane_active && tx_word_boundary && skip_req;

    assign dl_tx_ready  = lane_active && tx_word_boundary && !skip_req;
    assign tx_send_llcw = (!lane_active && (lism_tx_cmd != 4'd0)) ||
                          tx_insert_skip ||
                          (lane_active && !dl_tx_valid);
    assign tx_cmd_mux   = (!lane_active) ? lism_tx_cmd :
                          tx_insert_skip ? 4'd6 :  // CMD_SKIP
                                           4'd7;   // CMD_IDLE (ECSS 5.5.4a)

    // Compatibilidade para diagnostico de TB legado
    wire [1:0] tx_init_cmd = (lism_tx_cmd == 4'd1) ? 2'b01 :
                             (lism_tx_cmd == 4'd3) ? 2'b10 :
                             (lism_tx_cmd == 4'd5) ? 2'b11 : 2'b00;

    reg [31:0] tx_cur_word;
    reg [3:0]  tx_cur_k;
    reg [7:0]  enc_tx_byte;
    reg        enc_tx_k;

    always @(posedge clk or negedge rst_int_n) begin
        if (!rst_int_n) begin
            tx_sym_idx  <= 2'd0;
            skip_cnt    <= {SKIP_W{1'b0}};
            skip_req    <= 1'b0;
            tx_cur_word <= 32'hCFCF_CEFC;
            tx_cur_k    <= 4'b0001;
            enc_tx_byte <= 8'h00;
            enc_tx_k    <= 1'b0;
        end else begin
            tx_sym_idx  <= tx_sym_idx + 2'd1;
            enc_tx_byte <= tx_cur_word[tx_sym_idx*8 +: 8];
            enc_tx_k    <= tx_cur_k[tx_sym_idx];

            if (!lane_active) begin
                skip_cnt <= {SKIP_W{1'b0}};
                skip_req <= 1'b0;
            end else if (tx_word_boundary) begin
                if (skip_req) begin
                    skip_req <= 1'b0;
                    skip_cnt <= {SKIP_W{1'b0}};
                end else if (skip_cnt >= (SKIP_PERIOD - 2)) begin
                    skip_req <= 1'b1;
                end else begin
                    skip_cnt <= skip_cnt + 1'b1;
                end
            end

            if (tx_word_boundary) begin
                if (tx_llcw_valid) begin
                    tx_cur_word <= tx_llcw_word;
                    tx_cur_k    <= tx_llcw_k_flags;
                end else if (lane_active && dl_tx_valid) begin
                    tx_cur_word <= dl_tx_word;
                    tx_cur_k    <= dl_tx_k_flags;
                end else begin
                    tx_cur_word <= 32'hCFCF_CEFC; // IDLE LLCW
                    tx_cur_k    <= 4'b0001;
                end
            end
        end
    end

    encoder_8b10b encoder_inst (
        .clk    (clk),
        .rst_n  (rst_int_n),
        .rd_rst (!line_driver_en),
        .din    (enc_tx_byte),
        .kin    (enc_tx_k),
        .dout   (tx_10b_int)
    );

    wire rx_is_k28_7_comma = eb_dout_k[0] && (eb_dout_word[7:0] == 8'hFC);

    fsm_layer #(
        .TIMER_CLEAR_LIMIT  (TIMER_CLEAR_LIMIT),
        .HANDSHAKE_WORDS    (HANDSHAKE_WORDS),
        .INIT_TIMEOUT_WORDS (INIT_TIMEOUT_WORDS),
        .ABORT_WORDS        (ABORT_WORDS)
    ) fsm_inst (
        .clk               (clk),
        .sys_rst_n         (rst_int_n),
        .lane_reset_req    (lane_reset),
        .lane_start_en     (lane_enabled_reg),
        .auto_start_en     (auto_start),
        .pll_lock          (1'b1),
        .loss_of_signal    (loss_of_signal),
        .rx_sync_ready     (ws_sync_ready),
        .ber_exceeded      (threshold_exceeded),
        .tx_word_tick      (tx_word_boundary),
        .rx_word_valid     (eb_dout_valid),
        .rx_word_err       (eb_dout_err),
        .rx_is_k28_7_comma (rx_is_k28_7_comma),
        .rx_cmd_valid      (rx_cmd_valid),
        .rx_cmd_type       (rx_cmd_type),
        .line_driver_en    (line_driver_en),
        .line_rx_en        (line_rx_en),
        .cdr_en            (cdr_en),
        .invert_rx_pol     (inv_pol_int),
        .pol_flip_pulse    (pol_flip_pulse),
        .tx_llcw_cmd       (lism_tx_cmd),
        .lane_active       (lane_active),
        .current_state_o   (lane_state),
        .lism_state_ecss_o (lism_state_ecss)
    );

endmodule
