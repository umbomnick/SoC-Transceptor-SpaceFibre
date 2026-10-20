// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: encoder_8b10b.v
// Padrão : ECSS-E-ST-50-11C
// Função : Top-Level do Codificador 8b/10b síncrono com controle de RD
// ============================================================================

module encoder_8b10b (
    input  wire       clk,      // Clock
    input  wire       rst_n,    // Reset assíncrono ativo baixo
    input  wire       kin,      // 0: Dado (D), 1: Controle (K)
    input  wire [7:0] din,      // Byte de entrada (HGF EDCBA)
    output reg  [9:0] dout      // Símbolo de 10 bits codificado {abcdei, fghj}
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
            rd_reg <= 1'b0; // RD- inicial
            dout   <= 10'b0;
        end else begin
            rd_reg <= rd_next;
            dout   <= {data_6b, data_4b};
        end
    end

endmodule
