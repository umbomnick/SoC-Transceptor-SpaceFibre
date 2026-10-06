// =============================================================================
// Projeto CI Amazonia - Atividade de Digitais (Hierárquico)
// Modulo: Multiplexador de Leitura 16 para 1 (Largura: 8 bits)
// Descrição: Seleciona uma entre 16 entradas de 8 bits usando um seletor de 4 bits.
//            Desenvolvido com portas planas para compatibilidade perfeita com o 
//            editor gráfico do Quartus II (Block Diagram File - .bdf).
// =============================================================================

`timescale 1ns/1ps

module mux_16to1_8bit (
    input  logic [7:0] in0,  // Entrada do Registrador 0
    input  logic [7:0] in1,  // Entrada do Registrador 1
    input  logic [7:0] in2,  // Entrada do Registrador 2
    input  logic [7:0] in3,  // Entrada do Registrador 3
    input  logic [7:0] in4,  // Entrada do Registrador 4
    input  logic [7:0] in5,  // Entrada do Registrador 5
    input  logic [7:0] in6,  // Entrada do Registrador 6
    input  logic [7:0] in7,  // Entrada do Registrador 7
    input  logic [7:0] in8,  // Entrada do Registrador 8
    input  logic [7:0] in9,  // Entrada do Registrador 9
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
            4'h0: out = in0;
            4'h1: out = in1;
            4'h2: out = in2;
            4'h3: out = in3;
            4'h4: out = in4;
            4'h5: out = in5;
            4'h6: out = in6;
            4'h7: out = in7;
            4'h8: out = in8;
            4'h9: out = in9;
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
