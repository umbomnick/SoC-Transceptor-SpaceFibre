// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/encoder_5b6b.v
// Padrao : ECSS-E-ST-50-11C (Tabela 5-1 / 8B/10B Widmer-Franaszek)
// Funcao : Codificacao combinacional dos 5 LSBs (EDCBA) em 6 bits (abcdei)
// ============================================================================
`timescale 1ns / 1ps

module encoder_5b6b (
    input  wire       kin,       // 0: Dados (D), 1: Controle (K)
    input  wire       rd_in,     // Disparidade continua atual: 0 = RD-, 1 = RD+
    input  wire [4:0] data_in,   // EDCBA (Bits [4:0] do caractere)
    output reg  [5:0] data_out,  // abcdei (6 bits codificados)
    output reg        rd_out     // Disparidade intermediaria
);
    wire [6:0] sel  = {kin, rd_in, data_in};
    wire [2:0] ones = data_out[0] + data_out[1] + data_out[2] +
                      data_out[3] + data_out[4] + data_out[5];

    always @(*) begin
        rd_out = (ones == 3'd4) ? 1'b1 : (ones == 3'd2) ? 1'b0 : rd_in;
    end

    always @(*) begin
        case (sel)
            // CARACTERES DE DADOS (kin = 0)
            7'b0_0_00000: data_out = 6'b100111;
            7'b0_1_00000: data_out = 6'b011000;
            7'b0_0_00001: data_out = 6'b011101;
            7'b0_1_00001: data_out = 6'b100010;
            7'b0_0_00010: data_out = 6'b101101;
            7'b0_1_00010: data_out = 6'b010010;
            7'b0_0_00011: data_out = 6'b110001;
            7'b0_1_00011: data_out = 6'b110001;
            7'b0_0_00100: data_out = 6'b110101;
            7'b0_1_00100: data_out = 6'b001010;
            7'b0_0_00101: data_out = 6'b101001;
            7'b0_1_00101: data_out = 6'b101001;
            7'b0_0_00110: data_out = 6'b011001;
            7'b0_1_00110: data_out = 6'b011001;
            7'b0_0_00111: data_out = 6'b111000;
            7'b0_1_00111: data_out = 6'b000111;
            7'b0_0_01000: data_out = 6'b111001;
            7'b0_1_01000: data_out = 6'b000110;
            7'b0_0_01001: data_out = 6'b100101;
            7'b0_1_01001: data_out = 6'b100101;
            7'b0_0_01010: data_out = 6'b010101;
            7'b0_1_01010: data_out = 6'b010101;
            7'b0_0_01011: data_out = 6'b110100;
            7'b0_1_01011: data_out = 6'b110100;
            7'b0_0_01100: data_out = 6'b001101;
            7'b0_1_01100: data_out = 6'b001101;
            7'b0_0_01101: data_out = 6'b101100;
            7'b0_1_01101: data_out = 6'b101100;
            7'b0_0_01110: data_out = 6'b011100;
            7'b0_1_01110: data_out = 6'b011100;
            7'b0_0_01111: data_out = 6'b010111;
            7'b0_1_01111: data_out = 6'b101000;
            7'b0_0_10000: data_out = 6'b011011;
            7'b0_1_10000: data_out = 6'b100100;
            7'b0_0_10001: data_out = 6'b100011;
            7'b0_1_10001: data_out = 6'b100011;
            7'b0_0_10010: data_out = 6'b010011;
            7'b0_1_10010: data_out = 6'b010011;
            7'b0_0_10011: data_out = 6'b110010;
            7'b0_1_10011: data_out = 6'b110010;
            7'b0_0_10100: data_out = 6'b001011;
            7'b0_1_10100: data_out = 6'b001011;
            7'b0_0_10101: data_out = 6'b101010;
            7'b0_1_10101: data_out = 6'b101010;
            7'b0_0_10110: data_out = 6'b011010;
            7'b0_1_10110: data_out = 6'b011010;
            7'b0_0_10111: data_out = 6'b111010;
            7'b0_1_10111: data_out = 6'b000101;
            7'b0_0_11000: data_out = 6'b110011;
            7'b0_1_11000: data_out = 6'b001100;
            7'b0_0_11001: data_out = 6'b100110;
            7'b0_1_11001: data_out = 6'b100110;
            7'b0_0_11010: data_out = 6'b010110;
            7'b0_1_11010: data_out = 6'b010110;
            7'b0_0_11011: data_out = 6'b110110;
            7'b0_1_11011: data_out = 6'b001001;
            7'b0_0_11100: data_out = 6'b001110;
            7'b0_1_11100: data_out = 6'b001110;
            7'b0_0_11101: data_out = 6'b101110;
            7'b0_1_11101: data_out = 6'b010001;
            7'b0_0_11110: data_out = 6'b011110;
            7'b0_1_11110: data_out = 6'b100001;
            7'b0_0_11111: data_out = 6'b101011;
            7'b0_1_11111: data_out = 6'b010100;

            // CARACTERES DE CONTROLE (kin = 1) - ECSS Tabela 5-11
            7'b1_0_10111: data_out = 6'b111010; // K23.7 (nao usado em SpaceFibre)
            7'b1_1_10111: data_out = 6'b000101;
            7'b1_0_11011: data_out = 6'b110110; // K27.7 (Fill)
            7'b1_1_11011: data_out = 6'b001001;
            7'b1_0_11100: data_out = 6'b001111; // K28.y
            7'b1_1_11100: data_out = 6'b110000;
            7'b1_0_11101: data_out = 6'b101110; // K29.7 (EOP)
            7'b1_1_11101: data_out = 6'b010001;
            7'b1_0_11110: data_out = 6'b011110; // K30.7 (EEP)
            7'b1_1_11110: data_out = 6'b100001;

            default:      data_out = 6'b000000;
        endcase
    end
endmodule
