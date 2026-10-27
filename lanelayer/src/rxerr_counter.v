// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: rxerr_counter-v2.v
// Padrão : ECSS-E-ST-50-11C
// Função : Contador de Erros de Recepção (RXERR) para Monitoramento de BER
// ============================================================================

module rxerr_counter #(
    parameter DEFAULT_THRESHOLD = 8
)(
    input  wire        clk,                 // Clock do sistema (125 MHz)
    input  wire        rst_n,               // Reset assíncrono ativo baixo
    input  wire        active_state,        // 1: FSM no estado ST_ACTIVE
    input  wire        rx_err_tick,         // Pulso de erro de recepção (Code/Disp/LLCW)
    input  wire        clear_cnt,           // Pulso manual de zeramento do contador
    input  wire [7:0]  error_threshold,     // Limite customizado (0 usa DEFAULT_THRESHOLD)
    output reg  [15:0] rxerr_cnt,           // Valor acumulado do contador de erros
    output wire        threshold_exceeded   // 1: Limite de erros atingido/excedido
);

    wire [7:0] effective_threshold = (error_threshold == 8'd0) ? DEFAULT_THRESHOLD[7:0] : error_threshold;

    // Disparo combinacional: fica ativo enquanto o contador for >= limite efetivo
    assign threshold_exceeded = (rxerr_cnt >= effective_threshold) && (rxerr_cnt > 16'd0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rxerr_cnt <= 16'd0;
        end else if (clear_cnt) begin
            rxerr_cnt <= 16'd0;
        end else if (active_state && rx_err_tick) begin
            rxerr_cnt <= rxerr_cnt + 1'b1;
        end
    end

endmodule
