// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/datalink/sf_crc16.v
// Padrao : ECSS-E-ST-50-11C (Clausula 5.7.6.4, Figuras 5-42, 5-44 e 5-45)
// Funcao : Calculo combinacional do CRC-16 de quadros de dados SpaceFibre.
//          Polinomio ITU: G(x) = X^16 + X^12 + X^5 + 1, semente LFSR = 16'hFFFF.
//          Ordem de entrada: Byte0..Byte3, bit 0 (LSB) ate bit 7 (MSB).
//          Saida refletida conforme Figura 5-45: crc_val[k] = lfsr[15 - k],
//          onde EDF Byte2 = CRC_LS = crc_val[7:0], Byte3 = CRC_MS = crc_val[15:8].
// ============================================================================
`timescale 1ns / 1ps

// Passo de 32 bits (4 caracteres: SDF ou Data Word) sobre o estado interno do LFSR
module sf_crc16_word (
    input  wire [15:0] lfsr_in,
    input  wire [31:0] word_in,
    output reg  [15:0] lfsr_out
);
    integer b, i;
    reg [15:0] c;
    reg        fb;

    always @(*) begin
        c = lfsr_in;
        for (b = 0; b < 4; b = b + 1) begin
            for (i = 0; i < 8; i = i + 1) begin
                fb = c[15] ^ word_in[b*8 + i];
                c  = {c[14:12], c[11] ^ fb, c[10:5], c[4] ^ fb, c[3:0], fb};
            end
        end
        lfsr_out = c;
    end
endmodule

// Passo final de 16 bits (2 primeiros caracteres do EDF: Byte0=K28.0, Byte1=SEQ_NUM)
// entregando o valor refletido de 16 bits {CRC_MS, CRC_LS} pronto para o EDF
module sf_crc16_edf (
    input  wire [15:0] lfsr_in,
    input  wire [15:0] edf_hdr_in, // {SEQ_NUM[7:0], K28.0(8'h1C)}
    output wire [15:0] crc_val_out // {CRC_MS[7:0], CRC_LS[7:0]}
);
    integer b, i;
    reg [15:0] c;
    reg        fb;

    always @(*) begin
        c = lfsr_in;
        for (b = 0; b < 2; b = b + 1) begin
            for (i = 0; i < 8; i = i + 1) begin
                fb = c[15] ^ edf_hdr_in[b*8 + i];
                c  = {c[14:12], c[11] ^ fb, c[10:5], c[4] ^ fb, c[3:0], fb};
            end
        end
    end

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : GEN_REFLECT16
            assign crc_val_out[k] = c[15 - k];
        end
    endgenerate
endmodule
