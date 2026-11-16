// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/datalink/sf_crc8.v
// Padrao : ECSS-E-ST-50-11C (Clausula 5.7.6.5, Figuras 5-46 e 5-47)
// Funcao : Calculo combinacional do CRC-8 para palavras de controle (FCT, SIF, EBF).
//          Polinomio: G(x) = X^8 + X^2 + X + 1, semente = 8'h00.
//          Ordem de entrada: Byte0..Byte2, bit 0 (LSB) ate bit 7 (MSB).
//          Saida refletida conforme Figura 5-47: crc_out[k] = lfsr[7 - k].
// ============================================================================
`timescale 1ns / 1ps

module sf_crc8 (
    input  wire [7:0]  lfsr_in,   // 8'h00 para palavras isoladas (FCT, SIF)
    input  wire [23:0] data_24b,  // {Byte2, Byte1, Byte0}
    output reg  [7:0]  lfsr_out,  // Estado nao-refletido (para encadeamento em SBF..EBF)
    output wire [7:0]  crc_out    // Byte3 de CRC-8 refletido
);
    integer b, i;
    reg [7:0] c;
    reg       fb;

    always @(*) begin
        c = lfsr_in;
        for (b = 0; b < 3; b = b + 1) begin
            for (i = 0; i < 8; i = i + 1) begin
                fb = c[7] ^ data_24b[b*8 + i];
                c  = {c[6:2], c[1] ^ fb, c[0] ^ fb, fb};
            end
        end
        lfsr_out = c;
    end

    genvar k;
    generate
        for (k = 0; k < 8; k = k + 1) begin : GEN_REFLECT8
            assign crc_out[k] = lfsr_out[7 - k];
        end
    endgenerate
endmodule
