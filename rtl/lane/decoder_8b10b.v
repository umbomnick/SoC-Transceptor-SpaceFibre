// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/decoder_8b10b.v
// Padrao : ECSS-E-ST-50-11C (Clausulas 5.3.2, 5.5.7 e Tabela 5-11)
// Funcao : Decodificador 8b/10b sincrono com rejeicao de K-codes nao usados
//          em SpaceFibre (K28.1, K28.4, K28.6, K23.7) e substituicao por K0.0
// ============================================================================
`timescale 1ns / 1ps

module decoder_8b10b #(
    parameter SPACEFIBRE_STRICT_K = 1  // 1: rejeita K28.1/K28.4/K28.6/K23.7 (Tabela 5-11)
)(
    input  wire       clk,        // Clock do receptor
    input  wire       rst_n,      // Reset assincrono ativo baixo
    input  wire [9:0] din,        // Simbolo de 10 bits recebido {abcdei, fghj}
    input  wire       hold,       // 1 = congela RD e suprime erro
    input  wire       rd_sync,    // 1 = 1o simbolo apos alinhamento define a RD inicial
    output reg  [7:0] dout,       // Byte decodificado (HGF EDCBA) ou K0.0 (8'h00) em erro
    output reg        kout,       // 0 = Dado (D), 1 = Controle (K)
    output reg        code_err,   // 1 = Simbolo de 10 bits invalido / K nao usado
    output reg        disp_err    // 1 = Erro de Running Disparity
);

    reg        rd_reg;
    wire [4:0] data_5b;
    wire       k_5b;
    wire       err_5b;
    wire       derr_5b;
    wire       rd_mid;

    wire [2:0] data_3b;
    wire       k_3b;
    wire       err_3b;
    wire       derr_3b;
    wire       rd_next;

    decoder_6b5b u_dec_6b5b (
        .din      (din[9:4]),
        .rd_in    (rd_reg),
        .dout     (data_5b),
        .k_out    (k_5b),
        .err_out  (err_5b),
        .disp_err (derr_5b),
        .rd_out   (rd_mid)
    );

    decoder_4b3b u_dec_4b3b (
        .din      (din[3:0]),
        .rd_mid   (rd_mid),
        .data_5b  (data_5b),
        .k_5b     (k_5b),
        .dout     (data_3b),
        .k_out    (k_3b),
        .err_out  (err_3b),
        .disp_err (derr_3b),
        .rd_final (rd_next)
    );

    wire [7:0] raw_byte = {data_3b, data_5b};
    wire       raw_k    = k_5b | k_3b;

    // ECSS Tabela 5-11: K28.1 (3C), K28.4 (9C), K28.6 (DC) e K23.7 (F7) nao sao usados
    wire unused_sf_k = SPACEFIBRE_STRICT_K && raw_k &&
                       ((raw_byte == 8'h3C) || (raw_byte == 8'h9C) ||
                        (raw_byte == 8'hDC) || (raw_byte == 8'hF7));

    wire raw_cerr = (err_5b | err_3b | unused_sf_k) & ~hold;
    wire raw_derr = (derr_5b | derr_3b) & ~(err_5b | err_3b) & ~hold & ~rd_sync;
    wire any_err  = raw_cerr | raw_derr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_reg   <= 1'b0;
            dout     <= 8'h00;
            kout     <= 1'b0;
            code_err <= 1'b0;
            disp_err <= 1'b0;
        end else begin
            if (!hold) rd_reg <= rd_next;
            // ECSS 5.5.7j/k (Tabela 5-8): substitui simbolo invalido por K0.0 (k=1, 8'h00)
            dout     <= any_err ? 8'h00 : raw_byte;
            kout     <= any_err ? 1'b1  : raw_k;
            code_err <= raw_cerr;
            disp_err <= raw_derr;
        end
    end

endmodule
