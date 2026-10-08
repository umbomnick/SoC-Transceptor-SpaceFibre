// ============================================================================
// Projeto  : SoC Transceptor SpaceFibre (Data Link Layer - Framing)
// Arquivo  : rx_word_unpacker.sv
// Padrão   : ECSS-E-ST-50-11C (15 May 2019)
// Função   : Separa palavras de 32 bits da Lane Layer em símbolos; gera RXERR
// Cláusulas: 5.3.6
// ============================================================================

`timescale 1ns / 1ps

module rx_word_unpacker #(
    parameter int FIFO_AW = 2
) (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        link_up,

    // da Lane layer
    input  logic [31:0] rx_data,
    input  logic [3:0]  rx_ctrl,
    input  logic        rx_valid,
    input  logic        rx_err,
    output logic        rx_overflow,

    // para o rx_deframing
    output logic [7:0]  sym_data,
    output logic        sym_is_k,
    output logic        sym_valid
);

    localparam int DEPTH = 1 << FIFO_AW;
    localparam logic [35:0] RXERR_WORD = {4'b0001, 8'h00, 8'h00, 8'h00, spacefibre_pkg::K_RXERR};

    logic [35:0]      fifo [0:DEPTH-1];
    logic [FIFO_AW:0] wp, rp;
    logic [1:0]       idx;
    logic             lost;                    // palavra perdida: marcar a próxima
    logic [35:0]      head;

    logic empty, full;
    assign empty = (wp == rp);
    assign full  = ((wp - rp) == (FIFO_AW+1)'(DEPTH));
    assign head  = fifo[rp[FIFO_AW-1:0]];

    // saída combinacional do símbolo atual da palavra na cabeça do FIFO
    assign sym_valid = !empty;
    assign sym_data  = head[8*idx +: 8];
    assign sym_is_k  = head[32 + idx];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wp <= '0; rp <= '0; idx <= 2'd0; lost <= 1'b0; rx_overflow <= 1'b0;
        end else if (!link_up) begin
            wp <= '0; rp <= '0; idx <= 2'd0; lost <= 1'b0; rx_overflow <= 1'b0;
        end else begin
            rx_overflow <= 1'b0;
            // consumo: um símbolo por ciclo
            if (!empty) begin
                idx <= idx + 2'd1;
                if (idx == 2'd3) rp <= rp + 1'b1;
            end
            // escrita
            if (rx_valid) begin
                if (full && !(!empty && idx == 2'd3)) begin
                    lost        <= 1'b1;
                    rx_overflow <= 1'b1;
                end else begin
                    fifo[wp[FIFO_AW-1:0]] <= (rx_err || lost) ? RXERR_WORD : {rx_ctrl, rx_data};
                    wp   <= wp + 1'b1;
                    lost <= 1'b0;
                end
            end
        end
    end

endmodule