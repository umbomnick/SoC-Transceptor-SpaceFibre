// =============================================================================
// Projeto CI Amazônia - Atividade de Digitais
// Módulo: Banco de Registradores 16x8 de Porta Única Hierárquico
// Especificação de Interface Acordada em Grupo:
//   - Célula Básica: d_flip_flop (FF-D estrutural)
//   - Dimensões: 16 registradores de 8 bits (endereço de 4 bits)
//   - Interface de Porta: Single-Port (uma porta de leitura, uma de escrita síncrona)
//   - Protocolo de Reset: Assíncrono Ativo-Baixo (rst_n)
//   - Estratégia de Leitura: Opção B - Leitura Síncrona Registrada (Estabilidade)
// =============================================================================

`timescale 1ns/1ps

module register_file (
    input  logic       clk,      // Sinal de Clock
    input  logic       rst_n,    // Reset Assíncrono Ativo-Baixo
    input  logic       we,       // Habilitação de Escrita (Write Enable)
    input  logic [3:0] w_addr,   // Endereço de Escrita (16 posições -> 4 bits)
    input  logic [7:0] w_data,   // Barramento de Dados de Entrada (8 bits)
    input  logic [3:0] r_addr,   // Endereço de Leitura (16 posições -> 4 bits)
    output logic [7:0] r_data    // Barramento de Dados de Saída Registrada (8 bits)
);

    // Matriz de sinais para os dados atuais (saídas Q dos Flip-Flops)
    logic [15:0][7:0] reg_q;

    // Matriz de sinais para os próximos estados (entradas D dos Flip-Flops)
    logic [15:0][7:0] next_state;

    // Lógica Combinacional de Escrita (Loopback de Retenção de Dados)
    always_comb begin
        for (int r = 0; r < 16; r++) begin
            if (we && (w_addr == r)) begin
                next_state[r] = w_data;       // Escreve o dado novo no registrador selecionado
            end else begin
                next_state[r] = reg_q[r];      // Realimenta (retém) o estado atual
            end
        end
    end

    // Instanciação Estrutural Hierárquica usando laços 'generate'
    // Instanciamos exatamente 16 x 8 = 128 Flip-Flops D
    genvar r_idx, b_idx;
    generate
        for (r_idx = 0; r_idx < 16; r_idx = r_idx + 1) begin : gen_registers
            for (b_idx = 0; b_idx < 8; b_idx = b_idx + 1) begin : gen_bits
                d_flip_flop ff_inst (
                    .clk(clk),
                    .rst_n(rst_n),
                    .d(next_state[r_idx][b_idx]),
                    .q(reg_q[r_idx][b_idx]),
                    .q_bar() // Saída invertida não utilizada
                );
            end
        end
    endgenerate

    // Seleção Combinacional do Dado de Leitura (Multiplexador 16:1)
    logic [7:0] selected_data;
    always_comb begin
        selected_data = reg_q[r_addr];
    end

    // Estratégia de Leitura: Opção B - Leitura Síncrona Registrada (Estabilidade)
    // Insere um registrador na saída para limpar quaisquer glitches combinacionais
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_data <= 8'h00; // Reseta o registrador de saída imediatamente
        end else begin
            r_data <= selected_data; // Amostra o dado na borda de subida do clock (latência de 1 ciclo)
        end
    end

endmodule
