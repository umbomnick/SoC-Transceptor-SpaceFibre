// =============================================================================
// Projeto CI Amazonia - Atividade de Digitais (Hierárquico)
// Modulo: Decodificador de Endereços de Escrita (Decoder 4-to-16)
// Descrição: Recebe um endereço de escrita de 4 bits (w_addr) e um sinal
//            de habilitação de escrita (we). Ativa apenas a linha de controle
//            correspondente ao registrador selecionado.
// =============================================================================

`timescale 1ns/1ps

module decoder_4_to_16 (
    input  logic [3:0]  w_addr, // Endereço de escrita de 4 bits (seleciona 1 de 16)
    input  logic        we,     // Habilitação de escrita global (Write Enable)
    output logic [15:0] we_dec  // Sinais de escrita decodificados para os 16 registradores
);

    always_comb begin
        // Por padrão, nenhuma linha de escrita individual é ativada
        we_dec = 16'b0;
        
        // Se a habilitação global de escrita estiver ativa,
        // decodifica o endereço colocando '1' na linha correspondente
        if (we) begin
            we_dec[w_addr] = 1'b1;
        end
    end

endmodule
