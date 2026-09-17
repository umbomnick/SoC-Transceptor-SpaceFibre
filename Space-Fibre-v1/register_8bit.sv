// =============================================================================
// Projeto CI Amazonia - Atividade de Digitais (Hierárquico)
// Modulo: Registrador de 8 Bits com Retenção Síncrona (register_8bit)
// Descrição: Agrupa 8 instâncias de d_flip_flop.sv com um multiplexador 2-para-1
//            para realizar a retenção de dados quando "we" é 0.
// =============================================================================

`timescale 1ns/1ps

module register_8bit (
    input  logic       clk,       // Clock síncrono
    input  logic       rst_n,     // Reset assíncrono ativo-baixo
    input  logic       we,        // Habilitação de escrita (Write Enable)
    input  logic [7:0] d_in,      // Barramento de dados de entrada
    output logic [7:0] q_out      // Barramento de dados de saída (retenção)
);

    // Fios internos para a entrada dos Flip-Flops D
    logic [7:0] next_d;

    // Instanciação estrutural de 8 Flip-Flops D com controle de carga (Mux)
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_block
            // Se we = 1, seleciona o dado novo d_in; se we = 0, realimenta q_out (retenção)
            assign next_d[i] = we ? d_in[i] : q_out[i];

            // Instanciação do d_flip_flop padrão do projeto
            d_flip_flop dff_inst (
                .clk   (clk),
                .rst_n (rst_n),
                .d     (next_d[i]),
                .q     (q_out[i]),
                .q_bar () // q_bar não é utilizada no barramento
            );
        end
    endgenerate

endmodule
