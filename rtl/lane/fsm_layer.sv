// =============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/fsm_layer.sv
// Padrao : ECSS-E-ST-50-11C (Clausula 5.5.2, Figura 5-29)
// Funcao : Maquina de Estados de Inicializacao da Lane (LISM) com os 10 estados
//          normativos: ClearLine, Disabled, Wait, Started, InvertRxPolarity,
//          Connecting, Connected, Active, PrepareStandby e LossOfSignal.
// =============================================================================
`timescale 1ns/1ps

module fsm_layer #(
    parameter integer TIMER_CLEAR_LIMIT  = 200,   // 2 us @ 100 MHz (ECSS 5.5.2.3b.1)
    parameter integer HANDSHAKE_WORDS    = 1023,  // Palavras sem erro em Started (ECSS Fig 5-29)
    parameter integer INIT_TIMEOUT_WORDS = 5000,  // Timeout de inicializacao em palavras (5.5.2.2)
    parameter integer ABORT_WORDS        = 32     // 32x STANDBY / LOST_SIGNAL (5.5.2.9 / 5.5.2.10)
)(
    input  logic       clk,
    input  logic       sys_rst_n,         // Reset sincronizado ativo baixo
    input  logic       lane_reset_req,    // Comando de LaneReset -> ClearLine

    // Controles MIB
    input  logic       lane_start_en,     // LaneStart retido/ativo
    input  logic       auto_start_en,     // AutoStart ativo

    // Status da PHY e Sincronizador RX
    input  logic       pll_lock,
    input  logic       loss_of_signal,    // NoSignal na entrada RX
    input  logic       rx_sync_ready,     // Receive Sync FSM em Ready (5.5.8)
    input  logic       ber_exceeded,      // RXERR counter excedeu limiar

    // Eventos por palavra TX e RX (1 pulso a cada 4 ciclos de simbolo)
    input  logic       tx_word_tick,      // Palavra TX consumida pelo serializador
    input  logic       rx_word_valid,     // Palavra RX entregue pelo Elastic Buffer
    input  logic       rx_word_err,       // Palavra RX e RXERR
    input  logic       rx_is_k28_7_comma, // Palavra RX inicia com K28.7 (nao-LLCW ou LLCW)
    input  logic       rx_cmd_valid,
    input  logic [3:0] rx_cmd_type,

    // Controles para PHY e datapath da Lane
    output logic       line_driver_en,
    output logic       line_rx_en,
    output logic       cdr_en,
    output logic       invert_rx_pol,     // Polaridade RX invertida (ECSS 5.5.2.6)
    output logic       pol_flip_pulse,    // Pulso de 1 ciclo ao inverter polaridade
    output logic [3:0] tx_llcw_cmd,       // Comando LLCW para transmissao (0 = nenhum)
    output logic       lane_active,

    // Diagnostico
    output logic [2:0] current_state_o,   // Codigo compacto 3 bits compativel com topo
    output logic [3:0] lism_state_ecss_o  // Codigo completo de 10 estados ECSS
);

    // Comandos LLCW (mesma codificacao de llcw_processor.v)
    localparam logic [3:0] CMD_NONE        = 4'd0,
                           CMD_INIT1       = 4'd1,
                           CMD_IINIT1      = 4'd2,
                           CMD_INIT2       = 4'd3,
                           CMD_IINIT2      = 4'd4,
                           CMD_INIT3       = 4'd5,
                           CMD_SKIP        = 4'd6,
                           CMD_IDLE        = 4'd7,
                           CMD_STANDBY     = 4'd8,
                           CMD_LOST_SIGNAL = 4'd9;

    // 10 estados normativos da LISM (ECSS-E-ST-50-11C Figura 5-29)
    typedef enum logic [3:0] {
        LISM_DISABLED        = 4'd0,
        LISM_CLEAR_LINE      = 4'd1,
        LISM_WAIT            = 4'd2,
        LISM_STARTED         = 4'd3,
        LISM_INVERT_RX_POL   = 4'd4,
        LISM_CONNECTING      = 4'd5,
        LISM_CONNECTED       = 4'd6,
        LISM_ACTIVE          = 4'd7,
        LISM_PREPARE_STANDBY = 4'd8,
        LISM_LOSS_OF_SIGNAL  = 4'd9
    } lism_state_e;

    lism_state_e state_reg, state_next;

    localparam int CLR_W   = (TIMER_CLEAR_LIMIT  > 1) ? $clog2(TIMER_CLEAR_LIMIT  + 1) : 1;
    localparam int HSK_W   = (HANDSHAKE_WORDS    > 1) ? $clog2(HANDSHAKE_WORDS    + 1) : 1;
    localparam int TMO_W   = (INIT_TIMEOUT_WORDS > 1) ? $clog2(INIT_TIMEOUT_WORDS + 1) : 1;
    localparam int ABORT_W = (ABORT_WORDS        > 1) ? $clog2(ABORT_WORDS        + 1) : 1;

    logic [CLR_W-1:0]   clr_cnt;
    logic [HSK_W-1:0]   good_word_cnt;
    logic               saw_init12;
    logic [TMO_W-1:0]   init_tmo_cnt;
    logic [ABORT_W-1:0] abort_tx_cnt;

    logic [1:0] cnt_iinit;
    logic [1:0] cnt_init2;
    logic [1:0] cnt_init3;
    logic [1:0] cnt_tx_init3;
    logic [1:0] cnt_standby;
    logic [1:0] cnt_lost_sig;

    wire clr_done       = (clr_cnt      >= CLR_W'(TIMER_CLEAR_LIMIT - 1));
    wire init_timed_out = (init_tmo_cnt >= TMO_W'(INIT_TIMEOUT_WORDS));
    wire abort_tx_done  = tx_word_tick && (abort_tx_cnt >= ABORT_W'(ABORT_WORDS - 1));

    wire rx_is_init1  = rx_cmd_valid && (rx_cmd_type == CMD_INIT1);
    wire rx_is_iinit1 = rx_cmd_valid && (rx_cmd_type == CMD_IINIT1);
    wire rx_is_init2  = rx_cmd_valid && (rx_cmd_type == CMD_INIT2);
    wire rx_is_iinit2 = rx_cmd_valid && (rx_cmd_type == CMD_IINIT2);
    wire rx_is_init3  = rx_cmd_valid && (rx_cmd_type == CMD_INIT3);
    wire rx_is_stby   = rx_cmd_valid && (rx_cmd_type == CMD_STANDBY);
    wire rx_is_los    = rx_cmd_valid && (rx_cmd_type == CMD_LOST_SIGNAL);

    wire rx_3x_iinit   = rx_word_valid && (rx_is_iinit1 || rx_is_iinit2) && (cnt_iinit    == 2'd2);
    wire rx_3x_init23  = rx_word_valid && (rx_is_init2  || rx_is_init3)  && (cnt_init2    == 2'd2);
    wire rx_3x_init3   = ((rx_word_valid && rx_is_init3 && (cnt_init3 == 2'd2)) || (cnt_init3 == 2'd3)) &&
                         ((cnt_tx_init3 == 2'd3) || (tx_word_tick && (cnt_tx_init3 == 2'd2)));
    wire rx_3x_standby = rx_word_valid && rx_is_stby                     && (cnt_standby  == 2'd2);
    wire rx_3x_los     = rx_word_valid && rx_is_los                      && (cnt_lost_sig == 2'd2);

    wire next_saw_init12 = saw_init12 || (rx_word_valid && !rx_word_err && (rx_is_init1 || rx_is_init2));
    wire hsk_words_ok    = rx_word_valid && !rx_word_err && rx_sync_ready &&
                           (good_word_cnt >= HSK_W'(HANDSHAKE_WORDS - 1)) && next_saw_init12;

    wire cdr_active_st = (state_reg == LISM_STARTED)        ||
                         (state_reg == LISM_INVERT_RX_POL)  ||
                         (state_reg == LISM_CONNECTING)     ||
                         (state_reg == LISM_CONNECTED)      ||
                         (state_reg == LISM_ACTIVE)         ||
                         (state_reg == LISM_PREPARE_STANDBY)||
                         (state_reg == LISM_LOSS_OF_SIGNAL);

    // Transicao de Estados (ECSS Figura 5-29)
    always_comb begin
        state_next = state_reg;

        if (lane_reset_req) begin
            state_next = LISM_CLEAR_LINE;
        end else if (cdr_active_st && (rx_3x_los || rx_3x_standby)) begin
            state_next = LISM_CLEAR_LINE;
        end else begin
            case (state_reg)
                LISM_CLEAR_LINE: begin
                    if (clr_done) state_next = LISM_DISABLED;
                end

                LISM_DISABLED: begin
                    if (lane_start_en || auto_start_en)
                        state_next = LISM_WAIT;
                end

                LISM_WAIT: begin
                    if (!lane_start_en && !auto_start_en)
                        state_next = LISM_DISABLED;
                    else if (pll_lock && (lane_start_en || !loss_of_signal))
                        state_next = LISM_STARTED;
                end

                LISM_STARTED: begin
                    if (!lane_start_en && !auto_start_en)
                        state_next = LISM_PREPARE_STANDBY;
                    else if (init_timed_out)
                        state_next = LISM_CLEAR_LINE;
                    else if (rx_3x_iinit)
                        state_next = LISM_INVERT_RX_POL;
                    else if (hsk_words_ok)
                        state_next = LISM_CONNECTING;
                end

                LISM_INVERT_RX_POL: begin
                    if (!lane_start_en && !auto_start_en)
                        state_next = LISM_PREPARE_STANDBY;
                    else if (loss_of_signal || init_timed_out)
                        state_next = LISM_CLEAR_LINE;
                    else if (hsk_words_ok)
                        state_next = LISM_CONNECTING;
                end

                LISM_CONNECTING: begin
                    if (!lane_start_en && !auto_start_en)
                        state_next = LISM_PREPARE_STANDBY;
                    else if (loss_of_signal || init_timed_out)
                        state_next = LISM_CLEAR_LINE;
                    else if (rx_3x_init23)
                        state_next = LISM_CONNECTED;
                end

                LISM_CONNECTED: begin
                    if (!lane_start_en && !auto_start_en)
                        state_next = LISM_PREPARE_STANDBY;
                    else if (loss_of_signal || init_timed_out)
                        state_next = LISM_CLEAR_LINE;
                    else if (rx_word_valid && !rx_word_err && rx_is_k28_7_comma)
                        state_next = LISM_CLEAR_LINE;
                    else if (rx_3x_init3)
                        state_next = LISM_ACTIVE;
                end

                LISM_ACTIVE: begin
                    if (!lane_start_en && !auto_start_en)
                        state_next = LISM_PREPARE_STANDBY;
                    else if (loss_of_signal || ber_exceeded || (rx_word_valid && (rx_is_init1 || rx_is_iinit1)))
                        state_next = LISM_LOSS_OF_SIGNAL;
                end

                LISM_PREPARE_STANDBY: begin
                    if (abort_tx_done)
                        state_next = LISM_CLEAR_LINE;
                end

                LISM_LOSS_OF_SIGNAL: begin
                    if (abort_tx_done)
                        state_next = LISM_CLEAR_LINE;
                end

                default: state_next = LISM_CLEAR_LINE;
            endcase
        end
    end

    // Contadores e registradores sincronos da LISM
    always_ff @(posedge clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            state_reg     <= LISM_DISABLED;
            clr_cnt       <= '0;
            good_word_cnt <= '0;
            saw_init12    <= 1'b0;
            init_tmo_cnt  <= '0;
            abort_tx_cnt  <= '0;
            invert_rx_pol <= 1'b0;
            pol_flip_pulse<= 1'b0;
            cnt_iinit     <= 2'd0;
            cnt_init2     <= 2'd0;
            cnt_init3     <= 2'd0;
            cnt_tx_init3  <= 2'd0;
            cnt_standby   <= 2'd0;
            cnt_lost_sig  <= 2'd0;
        end else begin
            state_reg      <= state_next;
            pol_flip_pulse <= 1'b0;

            // Polaridade RX (ECSS 5.5.2.3b.3 / 5.5.2.6)
            if (state_next == LISM_CLEAR_LINE) begin
                invert_rx_pol <= 1'b0;
            end else if ((state_reg == LISM_STARTED) && (state_next == LISM_INVERT_RX_POL)) begin
                invert_rx_pol  <= ~invert_rx_pol;
                pol_flip_pulse <= 1'b1;
            end

            // Timer de ClearLine (2 us)
            if (state_reg == LISM_CLEAR_LINE) begin
                if (!clr_done) clr_cnt <= clr_cnt + 1'b1;
            end else begin
                clr_cnt <= '0;
            end

            // Timeout de inicializacao (5000 palavras TX entre Started e Connected)
            if ((state_reg == LISM_STARTED) || (state_reg == LISM_INVERT_RX_POL) ||
                (state_reg == LISM_CONNECTING) || (state_reg == LISM_CONNECTED)) begin
                if (tx_word_tick && !init_timed_out)
                    init_tmo_cnt <= init_tmo_cnt + 1'b1;
            end else begin
                init_tmo_cnt <= '0;
            end

            // Contador de 1023 palavras validas sem erro em Started / InvertRxPolarity
            if ((state_reg != state_next) ||
                ((state_reg != LISM_STARTED) && (state_reg != LISM_INVERT_RX_POL))) begin
                good_word_cnt <= '0;
                saw_init12    <= 1'b0;
            end else if (rx_word_valid) begin
                if (rx_word_err || !rx_sync_ready) begin
                    good_word_cnt <= '0;
                    saw_init12    <= 1'b0;
                end else begin
                    if (good_word_cnt < HSK_W'(HANDSHAKE_WORDS))
                        good_word_cnt <= good_word_cnt + 1'b1;
                    if (rx_is_init1 || rx_is_init2)
                        saw_init12 <= 1'b1;
                end
            end

            // Contador de 32x STANDBY / LOST_SIGNAL
            if ((state_reg != state_next) ||
                ((state_reg != LISM_PREPARE_STANDBY) && (state_reg != LISM_LOSS_OF_SIGNAL))) begin
                abort_tx_cnt <= '0;
            end else if (tx_word_tick) begin
                abort_tx_cnt <= abort_tx_cnt + 1'b1;
            end

            // Contadores de 3x palavras consecutivas (ECSS Figura 5-29 / 5.5.2.11a.3)
            if (state_reg != state_next) begin
                cnt_iinit    <= 2'd0;
                cnt_init2    <= 2'd0;
                cnt_init3    <= 2'd0;
                cnt_tx_init3 <= 2'd0;
            end else begin
                if ((state_reg == LISM_CONNECTED) && tx_word_tick && (cnt_tx_init3 < 2'd3))
                    cnt_tx_init3 <= cnt_tx_init3 + 2'd1;

                if (rx_word_valid) begin
                    cnt_iinit <= (!rx_word_err && (rx_is_iinit1 || rx_is_iinit2)) ?
                                 ((cnt_iinit == 2'd3) ? 2'd3 : cnt_iinit + 2'd1) : 2'd0;
                    cnt_init2 <= (!rx_word_err && (rx_is_init2 || rx_is_init3)) ?
                                 ((cnt_init2 == 2'd3) ? 2'd3 : cnt_init2 + 2'd1) : 2'd0;
                    if (rx_word_err)
                        cnt_init3 <= 2'd0;
                    else if (rx_is_init3 && (cnt_init3 < 2'd3))
                        cnt_init3 <= cnt_init3 + 2'd1;
                end
            end

            if (!cdr_active_st) begin
                cnt_standby  <= 2'd0;
                cnt_lost_sig <= 2'd0;
            end else if (rx_word_valid) begin
                cnt_standby  <= (!rx_word_err && rx_is_stby) ?
                                ((cnt_standby  == 2'd3) ? 2'd3 : cnt_standby  + 2'd1) : 2'd0;
                cnt_lost_sig <= (!rx_word_err && rx_is_los) ?
                                ((cnt_lost_sig == 2'd3) ? 2'd3 : cnt_lost_sig + 2'd1) : 2'd0;
            end
        end
    end

    // Saidas combinacionais da LISM
    always_comb begin
        line_driver_en    = 1'b0;
        line_rx_en        = 1'b0;
        cdr_en            = 1'b0;
        tx_llcw_cmd       = CMD_NONE;
        lane_active       = 1'b0;
        lism_state_ecss_o = state_reg;

        case (state_reg)
            LISM_DISABLED: begin
                current_state_o = 3'd0;
            end
            LISM_CLEAR_LINE: begin
                current_state_o = 3'd1;
            end
            LISM_WAIT: begin
                line_rx_en      = 1'b1;
                current_state_o = 3'd6;
            end
            LISM_STARTED: begin
                line_driver_en  = 1'b1;
                line_rx_en      = 1'b1;
                cdr_en          = 1'b1;
                tx_llcw_cmd     = CMD_INIT1;
                current_state_o = 3'd2;
            end
            LISM_INVERT_RX_POL: begin
                line_driver_en  = 1'b1;
                line_rx_en      = 1'b1;
                cdr_en          = 1'b1;
                tx_llcw_cmd     = CMD_INIT1;
                current_state_o = 3'd7;
            end
            LISM_CONNECTING: begin
                line_driver_en  = 1'b1;
                line_rx_en      = 1'b1;
                cdr_en          = 1'b1;
                tx_llcw_cmd     = CMD_INIT2;
                current_state_o = 3'd3;
            end
            LISM_CONNECTED: begin
                line_driver_en  = 1'b1;
                line_rx_en      = 1'b1;
                cdr_en          = 1'b1;
                tx_llcw_cmd     = CMD_INIT3;
                current_state_o = 3'd3;
            end
            LISM_ACTIVE: begin
                line_driver_en  = 1'b1;
                line_rx_en      = 1'b1;
                cdr_en          = 1'b1;
                lane_active     = 1'b1;
                current_state_o = 3'd4;
            end
            LISM_PREPARE_STANDBY: begin
                line_driver_en  = 1'b1;
                line_rx_en      = 1'b1;
                cdr_en          = 1'b1;
                tx_llcw_cmd     = CMD_STANDBY;
                current_state_o = 3'd5;
            end
            LISM_LOSS_OF_SIGNAL: begin
                line_driver_en  = 1'b1;
                line_rx_en      = 1'b1;
                cdr_en          = 1'b1;
                tx_llcw_cmd     = CMD_LOST_SIGNAL;
                current_state_o = 3'd5;
            end
            default: begin
                current_state_o = 3'd0;
            end
        endcase
    end

endmodule
