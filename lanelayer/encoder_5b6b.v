// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: encoder_5b6b-v4.v
// Padrão : ECSS-E-ST-50-11C (Tabela 5-1)
// Função : Codificação combinacional dos 5 LSBs (EDCBA) em 6 bits (abcdei)
// ============================================================================

module encoder_5b6b (
    input  wire       kin,       // 0: Dados (D), 1: Controle (K)
    input  wire       rd_in,     // Disparidade contínua atual: 0 = RD-, 1 = RD+
    input  wire [4:0] data_in,   // EDCBA (Bits [4:0] do caractere)
    output reg  [5:0] data_out,  // abcdei (6 bits codificados)
    output reg        rd_out     // Disparidade intermediária
);
    wire [6:0] sel = {kin, rd_in, data_in};

    always @(*) begin
        case (sel)
            // ----------------------------------------------------------------
            // CARACTERES DE DADOS (kin = 0) - Tabela 5-1
            // ----------------------------------------------------------------
            7'b0_0_00000: begin data_out = 6'b100111; rd_out = 1'b1; end
            7'b0_1_00000: begin data_out = 6'b011000; rd_out = 1'b0; end

            7'b0_0_00001: begin data_out = 6'b011101; rd_out = 1'b0; end
            7'b0_1_00001: begin data_out = 6'b100010; rd_out = 1'b1; end

            7'b0_0_00010: begin data_out = 6'b101101; rd_out = 1'b0; end
            7'b0_1_00010: begin data_out = 6'b010010; rd_out = 1'b1; end

            7'b0_0_00011: begin data_out = 6'b110001; rd_out = 1'b0; end
            7'b0_1_00011: begin data_out = 6'b110001; rd_out = 1'b1; end

            7'b0_0_00100: begin data_out = 6'b110101; rd_out = 1'b0; end
            7'b0_1_00100: begin data_out = 6'b001010; rd_out = 1'b1; end

            7'b0_0_00101: begin data_out = 6'b101001; rd_out = 1'b0; end
            7'b0_1_00101: begin data_out = 6'b101001; rd_out = 1'b1; end

            7'b0_0_00110: begin data_out = 6'b011001; rd_out = 1'b0; end
            7'b0_1_00110: begin data_out = 6'b011001; rd_out = 1'b1; end

            7'b0_0_00111: begin data_out = 6'b111000; rd_out = 1'b0; end
            7'b0_1_00111: begin data_out = 6'b000111; rd_out = 1'b1; end

            7'b0_0_01000: begin data_out = 6'b111001; rd_out = 1'b0; end
            7'b0_1_01000: begin data_out = 6'b000110; rd_out = 1'b1; end

            7'b0_0_01001: begin data_out = 6'b100101; rd_out = 1'b0; end
            7'b0_1_01001: begin data_out = 6'b100101; rd_out = 1'b1; end

            7'b0_0_01010: begin data_out = 6'b010101; rd_out = 1'b0; end
            7'b0_1_01010: begin data_out = 6'b010101; rd_out = 1'b1; end

            7'b0_0_01011: begin data_out = 6'b110100; rd_out = 1'b0; end
            7'b0_1_01011: begin data_out = 6'b110100; rd_out = 1'b1; end

            7'b0_0_01100: begin data_out = 6'b001101; rd_out = 1'b0; end
            7'b0_1_01100: begin data_out = 6'b001101; rd_out = 1'b1; end

            7'b0_0_01101: begin data_out = 6'b101100; rd_out = 1'b0; end
            7'b0_1_01101: begin data_out = 6'b101100; rd_out = 1'b1; end

            7'b0_0_01110: begin data_out = 6'b011100; rd_out = 1'b0; end
            7'b0_1_01110: begin data_out = 6'b011100; rd_out = 1'b1; end

            7'b0_0_01111: begin data_out = 6'b010111; rd_out = 1'b1; end
            7'b0_1_01111: begin data_out = 6'b101000; rd_out = 1'b0; end

            7'b0_0_10000: begin data_out = 6'b011011; rd_out = 1'b0; end
            7'b0_1_10000: begin data_out = 6'b100100; rd_out = 1'b1; end

            7'b0_0_10001: begin data_out = 6'b100011; rd_out = 1'b0; end
            7'b0_1_10001: begin data_out = 6'b100011; rd_out = 1'b1; end

            7'b0_0_10010: begin data_out = 6'b010011; rd_out = 1'b0; end
            7'b0_1_10010: begin data_out = 6'b010011; rd_out = 1'b1; end

            7'b0_0_10011: begin data_out = 6'b110010; rd_out = 1'b0; end
            7'b0_1_10011: begin data_out = 6'b110010; rd_out = 1'b1; end

            7'b0_0_10100: begin data_out = 6'b001011; rd_out = 1'b0; end
            7'b0_1_10100: begin data_out = 6'b001011; rd_out = 1'b1; end

            7'b0_0_10101: begin data_out = 6'b101010; rd_out = 1'b0; end
            7'b0_1_10101: begin data_out = 6'b101010; rd_out = 1'b1; end

            7'b0_0_10110: begin data_out = 6'b011010; rd_out = 1'b0; end
            7'b0_1_10110: begin data_out = 6'b011010; rd_out = 1'b1; end

            7'b0_0_10111: begin data_out = 6'b111010; rd_out = 1'b0; end
            7'b0_1_10111: begin data_out = 6'b000101; rd_out = 1'b1; end

            7'b0_0_11000: begin data_out = 6'b110011; rd_out = 1'b0; end
            7'b0_1_11000: begin data_out = 6'b001100; rd_out = 1'b1; end

            7'b0_0_11001: begin data_out = 6'b100110; rd_out = 1'b0; end
            7'b0_1_11001: begin data_out = 6'b100110; rd_out = 1'b1; end

            7'b0_0_11010: begin data_out = 6'b010110; rd_out = 1'b0; end
            7'b0_1_11010: begin data_out = 6'b010110; rd_out = 1'b1; end

            7'b0_0_11011: begin data_out = 6'b110110; rd_out = 1'b0; end
            7'b0_1_11011: begin data_out = 6'b001001; rd_out = 1'b1; end

            7'b0_0_11100: begin data_out = 6'b001110; rd_out = 1'b0; end
            7'b0_1_11100: begin data_out = 6'b001110; rd_out = 1'b1; end

            7'b0_0_11101: begin data_out = 6'b101110; rd_out = 1'b0; end
            7'b0_1_11101: begin data_out = 6'b010001; rd_out = 1'b1; end

            7'b0_0_11110: begin data_out = 6'b011110; rd_out = 1'b0; end
            7'b0_1_11110: begin data_out = 6'b100001; rd_out = 1'b1; end

            7'b0_0_11111: begin data_out = 6'b101011; rd_out = 1'b1; end
            7'b0_1_11111: begin data_out = 6'b010100; rd_out = 1'b0; end

            // ----------------------------------------------------------------
            // CARACTERES DE CONTROLE (kin = 1)
            // ----------------------------------------------------------------
            7'b1_0_10111: begin data_out = 6'b111010; rd_out = 1'b0; end
            7'b1_1_10111: begin data_out = 6'b000101; rd_out = 1'b1; end

            7'b1_0_11011: begin data_out = 6'b110110; rd_out = 1'b0; end
            7'b1_1_11011: begin data_out = 6'b001001; rd_out = 1'b1; end

            7'b1_0_11100: begin data_out = 6'b001111; rd_out = 1'b1; end
            7'b1_1_11100: begin data_out = 6'b110000; rd_out = 1'b0; end

            7'b1_0_11101: begin data_out = 6'b101110; rd_out = 1'b0; end
            7'b1_1_11101: begin data_out = 6'b010001; rd_out = 1'b1; end

            7'b1_0_11110: begin data_out = 6'b011110; rd_out = 1'b0; end
            7'b1_1_11110: begin data_out = 6'b100001; rd_out = 1'b1; end

            default: begin
                data_out = 6'b000000;
                rd_out   = rd_in;
            end
        endcase
    end
endmodule
