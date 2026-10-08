// ============================================================================
// Projeto  : SoC Transceptor SpaceFibre (Data Link Layer - Framing)
// Arquivo  : tx_framing.sv
// Padrão   : ECSS-E-ST-50-11C (15 May 2019)
// Função   : Transmissor do enquadramento: quadros de dados e quadros idle
// Cláusulas: 5.3.5, 5.3.7, 5.3.8.2, 5.3.8.3, 5.7.6.1, 5.7.6.2.3, 5.7.6.3.1, 5.7.6.4
// ============================================================================

`timescale 1ns / 1ps

module tx_framing #(
    parameter logic [4:0] VC = 5'd0     // canal virtual deste framer (5.3.8.2e)
) (
    input  logic        tx_clk,
    input  logic        tx_rst_n,
    input  spacefibre_pkg::link_state_t link_state,
    input  logic        tx_en,          // 0 = segura (sem símbolo neste ciclo)

    // Camada superior
    input  logic [7:0]  tx_data_in,
    input  logic        tx_valid_in,
    input  logic        tx_last_in,     // último byte do PACOTE
    output logic        tx_ready_out,
    output logic        tx_abort_out,

    // Scrambler / codificador 8b/10b
    output logic [7:0]  tx_data_out,
    output logic        tx_is_k_char,   // 1: caractere de controle (K), 0: dado
    output logic        tx_valid_out
);

    localparam int MAXW = spacefibre_pkg::MAX_FRAME_WORDS;

    typedef enum logic [3:0] {
        ST_RESET   = 4'd0,
        ST_TRAIN   = 4'd1,
        ST_SIF     = 4'd2,   // início de quadro idle
        ST_IDLE    = 4'd3,   // palavras PRBS do quadro idle
        ST_SOF     = 4'd4,   // SDF
        ST_PAYLOAD = 4'd5,
        ST_EOP     = 4'd6,
        ST_FILL    = 4'd7,
        ST_EOF     = 4'd8    // EDF
    } state_t;

    state_t      state, next_state;
    logic [7:0]  sym_data;
    logic        sym_is_k;
    logic        sym_valid;
    logic        abort_nxt;
    logic        link_active;
    state_t      link_down_state;

    logic [1:0]  sym_idx;      // posição do símbolo na palavra (0 = sai primeiro)
    logic [6:0]  word_cnt;     // palavras de dados/PRBS já fechadas no quadro
    logic [6:0]  seq_cnt;      // Transmit Sequence Counter (5.7.6.3.1a)
    logic        seq_pol;      // Transmit Polarity Flag (5.7.6.3.1c); sem recuperação de erro fica em 0
    logic [15:0] crc;
    logic [15:0] prbs;         // gerador PRBS dos quadros idle
    logic        cont_pkt;     // quadro fechado no meio do pacote: reabrir
    logic        eop_pend;     // EOP não coube no quadro: vai no próximo
    logic        set_cont, set_eop;

    logic [23:0] prbs_nxt;
    logic [7:0]  sif_seq, sif_crc;
    logic [6:0]  seq_inc;
    logic        frame_full, word_end;

    assign prbs_nxt   = spacefibre_pkg::prbs_byte(prbs);
    assign seq_inc    = seq_cnt + 7'd1;
    assign sif_seq    = {seq_pol, seq_cnt};          // valor atual, sem incrementar (5.7.6.3.1i)
    assign sif_crc    = spacefibre_pkg::crc8_byte(
                          spacefibre_pkg::crc8_byte(
                            spacefibre_pkg::crc8_byte(8'h00, spacefibre_pkg::K_COMMA),
                            spacefibre_pkg::D_SIF),
                          sif_seq);
    assign word_end   = (sym_idx == 2'd3);
    assign frame_full = word_end && (word_cnt == 7'(MAXW - 1));

    assign link_active = (link_state == spacefibre_pkg::LINK_ACTIVE);
    always_comb begin
        if (link_state == spacefibre_pkg::LINK_TRAINING) link_down_state = ST_TRAIN;
        else                                             link_down_state = ST_RESET;
    end

    // ------------------------------------------------------------------
    // Próximo estado e símbolo a emitir
    // ------------------------------------------------------------------
    always_comb begin
        next_state   = state;
        sym_data     = 8'h00;
        sym_is_k     = 1'b0;
        sym_valid    = 1'b0;
        tx_ready_out = 1'b0;
        abort_nxt    = 1'b0;
        set_cont     = 1'b0;
        set_eop      = 1'b0;

        case (state)
            ST_RESET: begin
                if (link_state == spacefibre_pkg::LINK_TRAINING)
                    next_state = ST_TRAIN;
                else if (link_active)
                    next_state = ST_SIF;
            end

            ST_TRAIN: begin
                // Treinamento é feito pela Lane layer (INIT1/2/3, 5.3.10a): nada a emitir
                if (link_active)
                    next_state = ST_SIF;
                else if (link_state != spacefibre_pkg::LINK_TRAINING)
                    next_state = ST_RESET;
            end

            ST_SIF: begin
                if (!link_active) begin
                    next_state = link_down_state;
                end else begin
                    sym_valid = 1'b1;
                    case (sym_idx)
                        2'd0: begin sym_data = spacefibre_pkg::K_COMMA; sym_is_k = 1'b1; end
                        2'd1: sym_data = spacefibre_pkg::D_SIF;
                        2'd2: sym_data = sif_seq;
                        2'd3: begin
                            sym_data = sif_crc;
                            // quadro idle pode ter zero palavras (5.3.8.3b)
                            if (tx_valid_in) next_state = ST_SOF;
                            else             next_state = ST_IDLE;
                        end
                    endcase
                end
            end

            ST_IDLE: begin
                if (!link_active) begin
                    next_state = link_down_state;
                end else begin
                    sym_data  = prbs_nxt[7:0];
                    sym_valid = 1'b1;
                    if (word_end) begin
                        if (tx_valid_in)     next_state = ST_SOF;   // 5.3.8.3j
                        else if (frame_full) next_state = ST_SIF;   // 5.3.8.3k, l
                    end
                end
            end

            ST_SOF: begin
                if (!link_active) begin
                    abort_nxt  = cont_pkt | eop_pend;   // continuação já iniciada
                    next_state = link_down_state;
                end else begin
                    sym_valid = 1'b1;
                    case (sym_idx)
                        2'd0: begin sym_data = spacefibre_pkg::K_COMMA; sym_is_k = 1'b1; end
                        2'd1: sym_data = spacefibre_pkg::D_SDF;
                        2'd2: sym_data = {3'b000, VC};
                        2'd3: begin
                            sym_data = 8'h00;           // reservado = D0.0 (5.3.8.2f)
                            if (eop_pend) next_state = ST_EOP;
                            else          next_state = ST_PAYLOAD;
                        end
                    endcase
                end
            end

            ST_PAYLOAD: begin
                if (!link_active) begin
                    abort_nxt  = 1'b1;                  // 5.7.6.1c
                    next_state = link_down_state;
                end else begin
                    tx_ready_out = 1'b1;
                    if (tx_valid_in) begin
                        sym_data  = tx_data_in;
                        sym_valid = 1'b1;
                        if (tx_last_in) begin
                            if (frame_full) begin
                                set_eop    = 1'b1;      // EOP vai no próximo quadro
                                next_state = ST_EOF;
                            end else begin
                                next_state = ST_EOP;
                            end
                        end else if (frame_full) begin
                            set_cont   = 1'b1;          // pacote continua
                            next_state = ST_EOF;
                        end
                    end
                    // sem tx_valid_in: nenhum símbolo nesse ciclo
                end
            end

            ST_EOP: begin
                if (!link_active) begin
                    abort_nxt  = 1'b1;
                    next_state = link_down_state;
                end else begin
                    sym_data  = spacefibre_pkg::K_EOP;
                    sym_is_k  = 1'b1;
                    sym_valid = 1'b1;
                    if (word_end) next_state = ST_EOF;
                    else          next_state = ST_FILL;
                end
            end

            ST_FILL: begin
                if (!link_active) begin
                    abort_nxt  = 1'b1;
                    next_state = link_down_state;
                end else begin
                    sym_data  = spacefibre_pkg::K_FILL;
                    sym_is_k  = 1'b1;
                    sym_valid = 1'b1;
                    if (word_end) next_state = ST_EOF;
                end
            end

            ST_EOF: begin
                if (!link_active) begin
                    abort_nxt  = 1'b1;
                    next_state = link_down_state;
                end else begin
                    sym_valid = 1'b1;
                    case (sym_idx)
                        2'd0: begin sym_data = spacefibre_pkg::K_EDF; sym_is_k = 1'b1; end
                        // contador incrementado imediatamente antes do EDF (5.7.6.3.1h)
                        2'd1: sym_data = {seq_pol, seq_inc};
                        2'd2: sym_data = crc[7:0];                  // CRC_LS
                        2'd3: begin
                            sym_data = crc[15:8];                   // CRC_MS
                            if (cont_pkt || eop_pend || tx_valid_in) next_state = ST_SOF;
                            else                                     next_state = ST_SIF;
                        end
                    endcase
                end
            end

            default: next_state = ST_RESET;
        endcase

        // contrapressão: com o link ativo e tx_en = 0, nada muda neste ciclo
        if (!tx_en && link_active) begin
            next_state   = state;
            sym_valid    = 1'b0;
            sym_data     = 8'h00;
            sym_is_k     = 1'b0;
            tx_ready_out = 1'b0;
            abort_nxt    = 1'b0;
            set_cont     = 1'b0;
            set_eop      = 1'b0;
        end
    end

    // ------------------------------------------------------------------
    // Estado e saídas registradas
    // ------------------------------------------------------------------
    always_ff @(posedge tx_clk or negedge tx_rst_n) begin
        if (!tx_rst_n) begin
            state        <= ST_RESET;
            tx_data_out  <= 8'h00;
            tx_is_k_char <= 1'b0;
            tx_valid_out <= 1'b0;
            tx_abort_out <= 1'b0;
            sym_idx      <= 2'd0;
            word_cnt     <= 7'd0;
            seq_cnt      <= 7'd0;
            seq_pol      <= 1'b0;
            crc          <= spacefibre_pkg::CRC16_INIT;
            prbs         <= spacefibre_pkg::PRBS_SEED;
            cont_pkt     <= 1'b0;
            eop_pend     <= 1'b0;
        end else begin
            state        <= next_state;
            tx_data_out  <= sym_data;
            tx_is_k_char <= sym_is_k;
            tx_valid_out <= sym_valid;
            tx_abort_out <= abort_nxt;

            if (set_cont) cont_pkt <= 1'b1;
            if (set_eop)  eop_pend <= 1'b1;

            if ((next_state == ST_SOF || next_state == ST_SIF) && next_state != state) begin
                // início de quadro: palavra e contagem do zero
                crc      <= spacefibre_pkg::CRC16_INIT;
                sym_idx  <= 2'd0;
                word_cnt <= 7'd0;
            end else if (sym_valid) begin
                sym_idx <= sym_idx + 2'd1;
                if (word_end && (state == ST_PAYLOAD || state == ST_EOP ||
                                 state == ST_FILL    || state == ST_IDLE))
                    word_cnt <= word_cnt + 7'd1;
                // CRC: do comma do SDF até o SEQ_NUM do EDF (5.7.6.4b)
                if (!(state == ST_EOF && sym_idx >= 2'd2))
                    crc <= spacefibre_pkg::crc16_byte(crc, sym_data);
                if (state == ST_EOF && sym_idx == 2'd1)
                    seq_cnt <= seq_inc;          // módulo 128 (5.7.6.3.1b)
                if (state == ST_EOP)
                    eop_pend <= 1'b0;
                if (state == ST_SOF && sym_idx == 2'd3)
                    cont_pkt <= 1'b0;
            end

            // PRBS avança só quando um byte PRBS sai; não é re-semeado entre
            // quadros idle (5.7.6.2.3b)
            if (state == ST_IDLE && sym_valid)
                prbs <= prbs_nxt[23:8];

            // link reset: contador, polaridade e PRBS voltam ao início
            // (5.7.6.3.1d, 5.7.6.3.1e, 5.7.6.2.3d)
            if (next_state == ST_RESET || next_state == ST_TRAIN) begin
                sym_idx  <= 2'd0;
                word_cnt <= 7'd0;
                cont_pkt <= 1'b0;
                eop_pend <= 1'b0;
                seq_cnt  <= 7'd0;
                seq_pol  <= 1'b0;
                prbs     <= spacefibre_pkg::PRBS_SEED;
            end
        end
    end

endmodule