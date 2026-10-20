// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: word_aligner-v3.v
// Padrão : ECSS-E-ST-50-11C
// Função : Alinhador de Palavras (Detector de Comma K28.5 / K28.7)
//          Sincroniza a fronteira dos 10 bits recebidos da PHY SerDes
// ============================================================================

module word_aligner (
    input  wire       clk,          // Clock de recepção (RX)
    input  wire       rst_n,        // Reset assíncrono ativo baixo
    input  wire       realign,      // Força busca de re-alinhamento (ativo alto)
    input  wire [9:0] din_10b,      // Palavra de 10 bits desalinhada vinda da PHY
    output reg  [9:0] dout_10b,     // Palavra de 10 bits alinhada para o decodificador
    output reg        word_aligned, // 1: Alinhado/Travado, 0: Desalinhado/Buscando
    output reg        comma_det     // Pulse 1 quando um caractere Comma é detectado
);

    reg [19:0] shift_reg;
    reg [3:0]  offset_reg;

    // Próxima janela de 20 bits incluindo o dado atual din_10b em tempo real combinacional
    wire [19:0] shift_reg_next = {shift_reg[9:0], din_10b};

    // Extração combinacional de candidatos para os 10 deslocamentos possíveis (0 a 9)
    wire [9:0] cand [0:9];
    wire [9:0] comma_match;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : GEN_CANDIDATES
            assign cand[i] = shift_reg_next[i + 9 : i];
            // Detecta K28.5 (0x0FA / 0x305) e K28.7 (0x0F8 / 0x307)
            assign comma_match[i] = (cand[i] == 10'h0FA) || (cand[i] == 10'h305) ||
                                    (cand[i] == 10'h0F8) || (cand[i] == 10'h307);
        end
    endgenerate

    // Encoder de prioridade para encontrar o primeiro offset com Comma válido
    reg [3:0] found_offset;
    reg       found_comma;

    always @(*) begin
        found_comma  = 1'b1;
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

    // Lógica de Trava e Seleção de Palavra Alinhada
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg    <= 20'b0;
            offset_reg   <= 4'd0;
            word_aligned <= 1'b0;
            dout_10b     <= 10'b0;
            comma_det    <= 1'b0;
        end else begin
            // Atualiza janela de amostragem de 20 bits
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
                // Mantém offset travado e gera a palavra alinhada usando cand de shift_reg_next
                dout_10b  <= cand[offset_reg];
                comma_det <= comma_match[offset_reg];
            end
        end
    end

endmodule
