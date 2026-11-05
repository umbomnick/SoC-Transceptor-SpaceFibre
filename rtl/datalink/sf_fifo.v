// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/datalink/sf_fifo.v
// Padrao : ECSS-E-ST-50-11C
// Funcao : FIFO sincrona show-ahead (dout valido enquanto !empty)
// ============================================================================
`timescale 1ns / 1ps

module sf_fifo #(
    parameter W  = 9,   // largura da palavra
    parameter AW = 2    // log2(profundidade)
)(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         flush,
    input  wire         wr,
    input  wire [W-1:0] din,
    input  wire         rd,
    output wire [W-1:0] dout,
    output wire         empty,
    output wire         full
);
    reg [W-1:0] mem [0:(1<<AW)-1];
    reg [AW:0]  wp, rp;

    assign empty = (wp == rp);
    assign full  = (wp[AW] != rp[AW]) && (wp[AW-1:0] == rp[AW-1:0]);
    assign dout  = mem[rp[AW-1:0]];

    always @(posedge clk) begin
        if (wr && !full) mem[wp[AW-1:0]] <= din;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wp <= {(AW+1){1'b0}};
            rp <= {(AW+1){1'b0}};
        end else if (flush) begin
            wp <= {(AW+1){1'b0}};
            rp <= {(AW+1){1'b0}};
        end else begin
            if (wr && !full)  wp <= wp + 1'b1;
            if (rd && !empty) rp <= rp + 1'b1;
        end
    end
endmodule
