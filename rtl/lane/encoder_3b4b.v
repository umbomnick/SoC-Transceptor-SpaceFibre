// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/encoder_3b4b.v
// Padrao : ECSS-E-ST-50-11C (Tabela 5-2 / 8B/10B Widmer-Franaszek)
// Funcao : Codificacao 3B/4B (HGF -> fghj) com controle de disparidade
// ============================================================================
`timescale 1ns / 1ps

module encoder_3b4b (
    input  wire       kin,       // 0: Dados (D), 1: Controle (K)
    input  wire       rd_mid,    // Disparidade pos-5B/6B (0 = RD-, 1 = RD+)
    input  wire [2:0] data_in,   // HGF (bits [7:5])
    input  wire [4:0] data_5b,   // EDCBA (para a regra D.x.A7)
    output reg  [3:0] data_out,  // fghj
    output reg        rd_final   // RD apos o simbolo completo
);

    wire use_a7 = (!rd_mid && ((data_5b == 5'd17) || (data_5b == 5'd18) || (data_5b == 5'd20))) ||
                  ( rd_mid && ((data_5b == 5'd11) || (data_5b == 5'd13) || (data_5b == 5'd14)));

    // Em K28.y com RD- intermediaria (6b = 110000) os codigos y=1,2,5,6 sao complementados
    wire k_alt = kin && !rd_mid;

    always @(*) begin
        case (data_in)
            3'd0: begin data_out = rd_mid ? 4'b0100 : 4'b1011; rd_final = ~rd_mid; end
            3'd1: begin data_out = k_alt  ? 4'b0110 : 4'b1001; rd_final =  rd_mid; end
            3'd2: begin data_out = k_alt  ? 4'b1010 : 4'b0101; rd_final =  rd_mid; end
            3'd3: begin data_out = rd_mid ? 4'b0011 : 4'b1100; rd_final =  rd_mid; end
            3'd4: begin data_out = rd_mid ? 4'b0010 : 4'b1101; rd_final = ~rd_mid; end
            3'd5: begin data_out = k_alt  ? 4'b0101 : 4'b1010; rd_final =  rd_mid; end
            3'd6: begin data_out = k_alt  ? 4'b1001 : 4'b0110; rd_final =  rd_mid; end
            default: begin // 3'd7
                if (kin || use_a7) data_out = rd_mid ? 4'b1000 : 4'b0111;  // A7 / K.x.7
                else               data_out = rd_mid ? 4'b0001 : 4'b1110;  // P7
                rd_final = ~rd_mid;
            end
        endcase
    end
endmodule
