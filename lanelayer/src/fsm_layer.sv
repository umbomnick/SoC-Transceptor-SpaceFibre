// =============================================================================
// Módulo: Máquina de Estados da Lane Layer (SpaceFibre / ECSS-E-ST-50-11C)
// Projeto: SoC Transceptor SpaceFibre (CI Amazônia / CTI Renato Archer)
// Nome do Módulo: fsm_layer
// Arquivo: fsm_layer.sv
// =============================================================================

`timescale 1ns/1ps

module fsm_layer #(
    parameter integer TIMER_CLEAR_LIMIT = 100
)(
    input  logic       clk,             // Clock paralelo de 125 MHz
    input  logic       sys_rst_n,       // Reset assíncrono ativo em nível baixo
    input  logic       lane_enable,     // Sinal de habilitação da Lane
    
    // Status vindos da PHY SerDes Analógica (ICD)
    input  logic       pll_lock,        // Trava do PLL (1.25 GHz)
    input  logic       loss_of_signal,  // Perda de sinal analógico no receptor
    
    // Status vindos do Decodificador 10b/8b (Lane Layer)
    input  logic       word_aligned,    // Alinhamento de palavra de 10 bits alcançado
    input  logic       rx_init_seq,     // Sequência de treinamento/inicialização recebida
    input  logic       code_violation,  // Violação de código ou disparidade 8b/10b
    
    // Controles para a PHY SerDes Analógica (ICD)
    output logic       line_driver_en,  // Habilitação do driver CML TX
    output logic       cdr_en,          // Habilitação do equalizador CTLE e CDR RX
    
    // Controles para o Scrambler e Framer (Lane Layer)
    output logic       scramble_en,     // Habilita embaralhamento de dados
    output logic [1:0] tx_init_cmd,     // Comando de envio de sequências INIT (00: None, 01: INIT1, 10: INIT2, 11: INIT3)
    output logic       lane_active,     // Sinaliza link ativo para a camada Data Link
    
    // Diagnóstico
    output logic [2:0] current_state_o  // Estado atual da FSM
);

    // Codificação dos estados da FSM (ECSS-E-ST-50-11C)
    typedef enum logic [2:0] {
        ST_OFF        = 3'b000,
        ST_CLEAR_LINE = 3'b001,
        ST_STARTED    = 3'b010,
        ST_CONNECTING = 3'b011,
        ST_ACTIVE     = 3'b100,
        ST_RECOVERY   = 3'b101
    } state_e;

    state_e state_reg, state_next;

    // Temporizador interno para estabilização da linha
    logic [6:0] timer_cnt;
    logic       timer_clear;
    logic       timer_done;

    always_ff @(posedge clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            timer_cnt <= 7'd0;
        end else if (timer_clear) begin
            timer_cnt <= 7'd0;
        end else if (timer_cnt < TIMER_CLEAR_LIMIT) begin
            timer_cnt <= timer_cnt + 1'b1;
        end
    end

    assign timer_done = (timer_cnt >= TIMER_CLEAR_LIMIT);

    // Registro de Estado Síncrono
    always_ff @(posedge clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            state_reg <= ST_OFF;
        end else begin
            state_reg <= state_next;
        end
    end

    // Lógica Combinacional de Transição de Estado
    always_comb begin
        state_next  = state_reg;
        timer_clear = 1'b0;

        case (state_reg)
            ST_OFF: begin
                timer_clear = 1'b1;
                if (lane_enable) begin
                    state_next = ST_CLEAR_LINE;
                end
            end

            ST_CLEAR_LINE: begin
                if (!lane_enable) begin
                    state_next = ST_OFF;
                end else if (pll_lock && !loss_of_signal && timer_done) begin
                    timer_clear = 1'b1;
                    state_next  = ST_STARTED;
                end
            end

            ST_STARTED: begin
                if (!lane_enable || loss_of_signal) begin
                    state_next = ST_RECOVERY;
                end else begin
                    state_next = ST_CONNECTING;
                end
            end

            ST_CONNECTING: begin
                if (!lane_enable || loss_of_signal) begin
                    state_next = ST_RECOVERY;
                end else if (word_aligned && rx_init_seq) begin
                    state_next = ST_ACTIVE;
                end
            end

            ST_ACTIVE: begin
                if (!lane_enable || loss_of_signal || code_violation) begin
                    state_next = ST_RECOVERY;
                end
            end

            ST_RECOVERY: begin
                timer_clear = 1'b1;
                state_next  = ST_CLEAR_LINE;
            end

            default: state_next = ST_OFF;
        endcase
    end

    // Saídas Combinacionais
    always_comb begin
        line_driver_en  = 1'b0;
        cdr_en          = 1'b0;
        scramble_en     = 1'b0;
        tx_init_cmd     = 2'b00;
        lane_active     = 1'b0;
        current_state_o = state_reg;

        case (state_reg)
            ST_OFF: begin
                line_driver_en = 1'b0;
                cdr_en         = 1'b0;
            end

            ST_CLEAR_LINE: begin
                line_driver_en = 1'b1;
                cdr_en         = 1'b1;
            end

            ST_STARTED: begin
                line_driver_en = 1'b1;
                cdr_en         = 1'b1;
                tx_init_cmd    = 2'b01; // Envia INIT1
            end

            ST_CONNECTING: begin
                line_driver_en = 1'b1;
                cdr_en         = 1'b1;
                tx_init_cmd    = 2'b10; // Envia INIT2/3
            end

            ST_ACTIVE: begin
                line_driver_en = 1'b1;
                cdr_en         = 1'b1;
                scramble_en    = 1'b1;
                lane_active    = 1'b1;
            end

            ST_RECOVERY: begin
                line_driver_en = 1'b1;
                cdr_en         = 1'b0;
            end

            default: ;
        endcase
    end

endmodule
