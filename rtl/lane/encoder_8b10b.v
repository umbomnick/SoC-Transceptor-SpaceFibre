// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/encoder_8b10b.v
// Padrao : ECSS-E-ST-50-11C (Clausula 5.3.2)
// Funcao : Top-Level do Codificador 8b/10b sincrono com controle de RD
// ============================================================================
`timescale 1ns / 1ps

module encoder_8b10b (
    input  wire       clk,      // Clock
    input  wire       rst_n,    // Reset assincrono ativo baixo
    input  wire       rd_rst,   // Reinicia RD para negativa (RD-) quando TX desabilitado (5.3.2g)
    input  wire       kin,      // 0: Dado (D), 1: Controle (K)
    input  wire [7:0] din,      // Byte de entrada (HGF EDCBA)
    output reg  [9:0] dout      // Simbolo de 10 bits codificado {abcdei, fghj}
);

    reg        rd_reg;
    wire [5:0] data_6b;
    wire       rd_mid;
    wire [3:0] data_4b;
    wire       rd_next;

    encoder_5b6b u_enc_5b6b (
        .kin      (kin),
        .rd_in    (rd_reg),
        .data_in  (din[4:0]),
        .data_out (data_6b),
        .rd_out   (rd_mid)
    );

    encoder_3b4b u_enc_3b4b (
        .kin      (kin),
        .rd_mid   (rd_mid),
        .data_in  (din[7:5]),
        .data_5b  (din[4:0]),
        .data_out (data_4b),
        .rd_final (rd_next)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_reg <= 1'b0; // RD- inicial (ECSS 5.3.2g)
            dout   <= 10'b0;
        end else if (rd_rst) begin
            rd_reg <= 1'b0;
            dout   <= 10'b0;
        end else begin
            rd_reg <= rd_next;
            dout   <= {data_6b, data_4b};
        end
    end

endmodule
