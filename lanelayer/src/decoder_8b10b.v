// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: decoder_8b10b.v
// Padrão : ECSS-E-ST-50-11C
// Função : Top-Level do Decodificador 8b/10b síncrono com detecção de erros
// ============================================================================

module decoder_8b10b (
    input  wire       clk,        // Clock do receptor
    input  wire       rst_n,      // Reset assíncrono ativo baixo
    input  wire [9:0] din,        // Símbolo de 10 bits recebido {abcdei, fghj}
    output reg  [7:0] dout,       // Byte decodificado (HGF EDCBA)
    output reg        kout,       // 0 = Dado (D), 1 = Controle (K)
    output reg        code_err,   // 1 = Símbolo de 10 bits inválido
    output reg        disp_err    // 1 = Erro de Running Disparity
);

    reg        rd_reg;
    wire [4:0] data_5b;
    wire       k_5b;
    wire       err_5b;
    wire       rd_mid;

    wire [2:0] data_3b;
    wire       k_3b;
    wire       err_3b;
    wire       rd_next;

    // Submódulo Decodificador 6B/5B
    decoder_6b5b u_dec_6b5b (
        .din      (din[9:4]),
        .rd_in    (rd_reg),
        .dout     (data_5b),
        .k_out    (k_5b),
        .err_out  (err_5b),
        .rd_out   (rd_mid)
    );

    // Submódulo Decodificador 4B/3B
    decoder_4b3b u_dec_4b3b (
        .din      (din[3:0]),
        .rd_mid   (rd_mid),
        .data_5b  (data_5b),
        .k_5b     (k_5b),
        .dout     (data_3b),
        .k_out    (k_3b),
        .err_out  (err_3b),
        .rd_final (rd_next)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_reg   <= 1'b0;       // Reset padrão: RD- inicial
            dout     <= 8'h00;
            kout     <= 1'b0;
            code_err <= 1'b0;
            disp_err <= 1'b0;
        end else begin
            rd_reg   <= rd_next;
            dout     <= {data_3b, data_5b};
            kout     <= k_5b | k_3b;
            code_err <= err_5b | err_3b;
            disp_err <= (err_5b | err_3b);
        end
    end

endmodule
