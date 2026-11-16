// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/word_aligner.v
// Padrao : ECSS-E-ST-50-11C (Clausula 5.5.6)
// Funcao : Alinhador de Simbolos de 10 bits (Detector de Comma K28.5 / K28.7)
// ============================================================================
`timescale 1ns / 1ps

module word_aligner (
    input  wire       clk,          // Clock de recepcao (RX)
    input  wire       rst_n,        // Reset assincrono ativo baixo
    input  wire       realign,      // Forca nova busca de alinhamento (LostSync / ClearLine)
    input  wire [9:0] din_10b,      // Simbolo de 10 bits desalinhado vindo da PHY
    output reg  [9:0] dout_10b,     // Simbolo de 10 bits alinhado para o decodificador
    output reg        word_aligned, // 1: Alinhado/Travado, 0: Buscando Comma
    output reg        comma_det     // 1 quando um Comma alinhado e entregue
);

    reg [19:0] shift_reg;
    reg [3:0]  offset_reg;

    wire [19:0] shift_reg_next = {shift_reg[9:0], din_10b};

    wire [9:0] cand [0:9];
    wire [9:0] comma_match;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : GEN_CANDIDATES
            assign cand[i] = shift_reg_next[i + 9 : i];
            // K28.5 (10'h0FA RD- / 10'h305 RD+) e K28.7 (10'h0F8 RD- / 10'h307 RD+)
            assign comma_match[i] = (cand[i] == 10'h0FA) || (cand[i] == 10'h305) ||
                                    (cand[i] == 10'h0F8) || (cand[i] == 10'h307);
        end
    endgenerate

    reg [3:0] found_offset;
    reg       found_comma;

    always @(*) begin
        found_comma = 1'b1;
        if      (comma_match[0]) found_offset = 4'd0;
        else if (comma_match[1]) found_offset = 4'd1;
        else if (comma_match[2]) found_offset = 4'd2;
        else if (comma_match[3]) found_offset = 4'd3;
        else if (comma_match[4]) found_offset = 4'd4;
        else if (comma_match[5]) found_offset = 4'd5;
        else if (comma_match[6]) found_offset = 4'd6;
        else if (comma_match[7]) found_offset = 4'd7;
        else if (comma_match[8]) found_offset = 4'd8;
        else if (comma_match[9]) found_offset = 4'd9;
        else begin
            found_offset = 4'd0;
            found_comma  = 1'b0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg    <= 20'b0;
            offset_reg   <= 4'd0;
            word_aligned <= 1'b0;
            dout_10b     <= 10'b0;
            comma_det    <= 1'b0;
        end else begin
            shift_reg <= shift_reg_next;

            if (realign) begin
                word_aligned <= 1'b0;
                dout_10b     <= 10'b0;
                comma_det    <= 1'b0;
            end else if (!word_aligned) begin
                if (found_comma) begin
                    word_aligned <= 1'b1;
                    offset_reg   <= found_offset;
                    dout_10b     <= cand[found_offset];
                    comma_det    <= 1'b1;
                end else begin
                    dout_10b  <= 10'b0;
                    comma_det <= 1'b0;
                end
            end else begin
                dout_10b  <= cand[offset_reg];
                comma_det <= comma_match[offset_reg];
            end
        end
    end

endmodule
