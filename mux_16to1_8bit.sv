// =============================================================================
// Projeto CI Amazonia - Atividade de Digitais (Hierárquico)
// Modulo: Multiplexador de Leitura 16 para 1 (Largura: 8 bits)
// Descrição: Seleciona uma entre 16 entradas de 8 bits usando um seletor de 4 bits.
//            Desenvolvido com portas planas para compatibilidade perfeita com o 
//            editor gráfico do Quartus II (Block Diagram File - .bdf).
// =============================================================================

`timescale 1ns/1ps

module mux_16to1_8bit (
    input  logic [7:0] in00,  // Entrada do Registrador 0
    input  logic [7:0] in01,  // Entrada do Registrador 1
    input  logic [7:0] in02,  // Entrada do Registrador 2
    input  logic [7:0] in03,  // Entrada do Registrador 3
    input  logic [7:0] in04,  // Entrada do Registrador 4
    input  logic [7:0] in05,  // Entrada do Registrador 5
    input  logic [7:0] in06,  // Entrada do Registrador 6
    input  logic [7:0] in07,  // Entrada do Registrador 7
    input  logic [7:0] in08,  // Entrada do Registrador 8
    input  logic [7:0] in09,  // Entrada do Registrador 9
    input  logic [7:0] in10, // Entrada do Registrador 10
    input  logic [7:0] in11, // Entrada do Registrador 11
    input  logic [7:0] in12, // Entrada do Registrador 12
    input  logic [7:0] in13, // Entrada do Registrador 13
    input  logic [7:0] in14, // Entrada do Registrador 14
    input  logic [7:0] in15, // Entrada do Registrador 15
    input  logic [3:0] sel,  // Seletor de Endereço (4 bits)
    output logic [7:0] out   // Saída de Dados Selecionada (8 bits)
);

    always_comb begin
        case (sel)
            4'h0: out = in00;
            4'h1: out = in01;
            4'h2: out = in02;
            4'h3: out = in03;
            4'h4: out = in04;
            4'h5: out = in05;
            4'h6: out = in06;
            4'h7: out = in07;
            4'h8: out = in08;
            4'h9: out = in09;
            4'hA: out = in10;
            4'hB: out = in11;
            4'hC: out = in12;
            4'hD: out = in13;
            4'hE: out = in14;
            4'hF: out = in15;
            default: out = 8'h00;
        endcase
    end

endmodule
