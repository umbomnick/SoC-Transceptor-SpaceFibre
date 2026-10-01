// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: encoder_3b4b.v
// Padrão : ECSS-E-ST-50-11C (Tabela 5-2)
// Função : Codificação combinacional dos 3 MSBs (HGF) em 4 bits (fghj)
// ============================================================================

module encoder_3b4b (
    input  wire       kin,       // 0: Dados (D), 1: Controle (K)
    input  wire       rd_mid,    // Disparidade contínua pós-5B/6B (0 = RD-, 1 = RD+)
    input  wire [2:0] data_in,   // HGF (Bits [7:5] do caractere)
    input  wire [4:0] data_5b,   // EDCBA (usado para desempate do Dxx.7 alternativo)
    output reg  [3:0] data_out,  // fghj (4 bits codificados)
    output reg        rd_final   // Disparidade final acumulada (novo RD)
);

    wire [4:0] sel = {kin, rd_mid, data_in};

    // Caso de exceção da norma para Dxx.7 com disparidade alternada
    wire alt7 = (data_5b == 5'd11) || (data_5b == 5'd13) || (data_5b == 5'd14);

    always @(*) begin
        case (sel)
            // ----------------------------------------------------------------
            // D/K.xx.0 (000)
            // ----------------------------------------------------------------
            5'b0_0_000, 5'b1_0_000: begin data_out = 4'b1011; rd_final = 1'b1; end
            5'b0_1_000, 5'b1_1_000: begin data_out = 4'b0100; rd_final = 1'b0; end

            // ----------------------------------------------------------------
            // D/K.xx.1 (001)
            // ----------------------------------------------------------------
            5'b0_0_001: begin data_out = 4'b1001; rd_final = 1'b0; end // Neutro
            5'b0_1_001: begin data_out = 4'b1001; rd_final = 1'b1; end // Neutro
            5'b1_0_001: begin data_out = 4'b0110; rd_final = 1'b1; end
            5'b1_1_001: begin data_out = 4'b1001; rd_final = 1'b0; end

            // ----------------------------------------------------------------
            // D/K.xx.2 (010)
            // ----------------------------------------------------------------
            5'b0_0_010: begin data_out = 4'b0101; rd_final = 1'b0; end // Neutro
            5'b0_1_010: begin data_out = 4'b0101; rd_final = 1'b1; end // Neutro
            5'b1_0_010: begin data_out = 4'b1010; rd_final = 1'b1; end
            5'b1_1_010: begin data_out = 4'b0101; rd_final = 1'b0; end

            // ----------------------------------------------------------------
            // D/K.xx.3 (011)
            // ----------------------------------------------------------------
            5'b0_0_011, 5'b1_0_011: begin data_out = 4'b1100; rd_final = 1'b0; end // Neutro
            5'b0_1_011, 5'b1_1_011: begin data_out = 4'b0011; rd_final = 1'b1; end // Neutro

            // ----------------------------------------------------------------
            // D/K.xx.4 (100)
            // ----------------------------------------------------------------
            5'b0_0_100, 5'b1_0_100: begin data_out = 4'b1101; rd_final = 1'b1; end
            5'b0_1_100, 5'b1_1_100: begin data_out = 4'b0010; rd_final = 1'b0; end

            // ----------------------------------------------------------------
            // D/K.xx.5 (101) - Base do Comma K28.5
            // ----------------------------------------------------------------
            5'b0_0_101: begin data_out = 4'b1010; rd_final = 1'b0; end // Neutro
            5'b0_1_101: begin data_out = 4'b1010; rd_final = 1'b1; end // Neutro
            5'b1_0_101: begin data_out = 4'b0101; rd_final = 1'b1; end
            5'b1_1_101: begin data_out = 4'b1010; rd_final = 1'b0; end

            // ----------------------------------------------------------------
            // D/K.xx.6 (110)
            // ----------------------------------------------------------------
            5'b0_0_110: begin data_out = 4'b0110; rd_final = 1'b0; end // Neutro
            5'b0_1_110: begin data_out = 4'b0110; rd_final = 1'b1; end // Neutro
            5'b1_0_110: begin data_out = 1'b0 ? 4'b0110 : 4'b1001; rd_final = 1'b1; end
            5'b1_1_110: begin data_out = 4'b0110; rd_final = 1'b0; end

            // ----------------------------------------------------------------
            // D/K.xx.7 (111)
            // ----------------------------------------------------------------
            5'b0_0_111: begin 
                data_out = alt7 ? 4'b0111 : 4'b1110; 
                rd_final = 1'b1; 
            end
            5'b0_1_111: begin 
                data_out = alt7 ? 4'b1000 : 4'b0001; 
                rd_final = 1'b0; 
            end
            5'b1_0_111: begin data_out = 4'b0111; rd_final = 1'b1; end
            5'b1_1_111: begin data_out = 4'b1000; rd_final = 1'b0; end

            default: begin
                data_out = 4'b0000;
                rd_final = rd_mid;
            end
        endcase
    end
endmodule