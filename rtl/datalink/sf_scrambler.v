// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/datalink/sf_scrambler.v
// Padrao : ECSS-E-ST-50-11C (Clausulas 5.7.6.2.1, 5.7.6.2.2 e 5.7.6.2.3,
//          Figuras 5-41, 5-42 e 5-43)
// Funcao : Scrambler / Descrambler de Dados e Gerador PRBS de Idle Frame
//          Polinomio Galois: G(x) = X^16 + X^5 + X^4 + X^3 + 1, semente 0xFFFF.
//          Processa 1 palavra de 32 bits combinacionalmente (LSB de Byte0 primeiro).
//          Caracteres K (EOP, EEP, Fill) preservam seu valor sem XOR (5.7.6.2.1c).
// ============================================================================
`timescale 1ns / 1ps

module sf_scrambler (
    input  wire [15:0] lfsr_in,      // Estado atual do LFSR (semente inicial = 16'hFFFF)
    input  wire [31:0] data_in,      // Palavra de entrada {Byte3, Byte2, Byte1, Byte0}
    input  wire [3:0]  k_in,         // Flags K por byte {k3, k2, k1, k0}
    input  wire        scramble_en,  // 1: aplica XOR nos bytes D (k_in[j] == 0)
    output reg  [31:0] prbs_word,    // Palavra PRBS pura de 32 bits (para Idle Frame)
    output wire [31:0] data_out,     // Palavra embaralhada / desembaralhada
    output reg  [15:0] lfsr_out      // Proximo estado do LFSR apos 32 passos
);

    integer b, bit_idx;
    reg [15:0] s;
    reg        fb;

    always @(*) begin
        s         = lfsr_in;
        prbs_word = 32'd0;
        for (b = 0; b < 4; b = b + 1) begin
            for (bit_idx = 0; bit_idx < 8; bit_idx = bit_idx + 1) begin
                fb = s[15];
                prbs_word[b*8 + bit_idx] = fb;
                // LFSR de Galois (Figura 5-41): taps em D3, D4, D5 com feedback D15
                s = {s[14:5], s[4] ^ fb, s[3] ^ fb, s[2] ^ fb, s[1:0], fb};
            end
        end
        lfsr_out = s;
    end

    assign data_out[7:0]   = (scramble_en && !k_in[0]) ? (data_in[7:0]   ^ prbs_word[7:0])   : data_in[7:0];
    assign data_out[15:8]  = (scramble_en && !k_in[1]) ? (data_in[15:8]  ^ prbs_word[15:8])  : data_in[15:8];
    assign data_out[23:16] = (scramble_en && !k_in[2]) ? (data_in[23:16] ^ prbs_word[23:16]) : data_in[23:16];
    assign data_out[31:24] = (scramble_en && !k_in[3]) ? (data_in[31:24] ^ prbs_word[31:24]) : data_in[31:24];

endmodule
