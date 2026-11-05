// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/rxerr_counter.v
// Padrao : ECSS-E-ST-50-11C (Clausula 5.5.2.11)
// Funcao : Contador Leaky-Bucket de Erros RXERR para monitoramento de BER
// ============================================================================
`timescale 1ns / 1ps

module rxerr_counter #(
    parameter DEFAULT_THRESHOLD = 8,
    parameter DECAY_WORDS       = 16384  // Decaimento leaky-bucket em palavras recebidas
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        active_state,      // 1: FSM no estado Active
    input  wire        rx_word_tick,      // Pulso por palavra recebida em Active
    input  wire        rx_err_tick,       // Pulso de erro de recepcao
    input  wire        clear_cnt,         // Pulso de zeramento (LaneReset / saida de Active)
    input  wire [7:0]  error_threshold,   // Limite customizado (0 usa DEFAULT_THRESHOLD)
    output reg  [15:0] rxerr_cnt,
    output wire        threshold_exceeded
);

    localparam DW_W = $clog2(DECAY_WORDS);

    wire [7:0] effective_threshold = (error_threshold == 8'd0) ?
                                     DEFAULT_THRESHOLD[7:0] : error_threshold;

    assign threshold_exceeded = (rxerr_cnt >= {8'd0, effective_threshold}) &&
                                (rxerr_cnt > 16'd0);

    reg [DW_W-1:0] word_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rxerr_cnt <= 16'd0;
            word_cnt  <= {DW_W{1'b0}};
        end else if (clear_cnt) begin
            rxerr_cnt <= 16'd0;
            word_cnt  <= {DW_W{1'b0}};
        end else if (active_state) begin
            if (rx_err_tick) begin
                if (rxerr_cnt != 16'hFFFF)
                    rxerr_cnt <= rxerr_cnt + 16'd1;
            end else if (rx_word_tick) begin
                if (word_cnt == DECAY_WORDS[DW_W-1:0] - 1'b1) begin
                    word_cnt <= {DW_W{1'b0}};
                    if (rxerr_cnt > 16'd0)
                        rxerr_cnt <= rxerr_cnt - 16'd1;
                end else begin
                    word_cnt <= word_cnt + 1'b1;
                end
            end
        end
    end

endmodule
