// =============================================================================
// Projeto CI Amazônia - Atividade de Digitais
// Módulo: Flip-Flop D Disparado por Borda de Subida com Reset Assíncrono Ativo-Baixo
// =============================================================================

`timescale 1ns/1ps

module d_flip_flop (
    input  logic clk,     // Sinal de Clock síncrono (borda de subida)
    input  logic rst_n,   // Reset Assíncrono Ativo-Baixo
    input  logic d,       // Entrada de dados D
    output logic q,       // Saída Q
    output logic q_bar    // Saída invertida Q_bar
);

    // Lógica sequencial sensível à borda de subida do clock ou descida do reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 1'b0;    // Reset assíncrono: zera a saída Q imediatamente
        end else begin
            q <= d;       // Na borda de clock, amostra a entrada D
        end
    end

    // Saída invertida combinacional paralela
    assign q_bar = ~q;

endmodule
