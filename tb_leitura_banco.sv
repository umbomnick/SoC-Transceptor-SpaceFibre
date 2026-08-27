// =============================================================================
// Projeto CI Amazonia - Atividade de Digitais
// Modulo: Testbench de Validação de Leitura (Dual-Port Asynchronous Read)
// Descrição: Testbench projetado para simular e verificar as portas de leitura 
//            A e B do Banco de Registradores de forma independente e assíncrona.
// =============================================================================

`timescale 1ns/1ps

module tb_leitura_banco;

    // Sinais de teste (entradas do DUT como reg/logic, saídas como wire/logic)
    logic         clk;
    logic         rst_n;
    logic         we;
    logic [3:0]   w_addr;
    logic [7:0]   w_data;
    logic [3:0]   r_addr_a;
    logic [7:0]   r_data_a;
    logic [3:0]   r_addr_b;
    logic [7:0]   r_data_b;

    // Instanciação do Dispositivo Sob Teste (DUT)
    // NOTA: Certifique-se de que o nome do seu bloco de topo no Quartus seja "banco_registradores_top"
    banco_registradores_top dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .we       (we),
        .w_addr   (w_addr),
        .w_data   (w_data),
        .r_addr_a (r_addr_a),
        .r_data_a (r_data_a),
        .r_addr_b (r_addr_b),
        .r_data_b (r_data_b)
    );

    // Geração de Clock (Período de 10ns -> Frequência de 100 MHz)
    always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end

    // Processo de Estímulos de Teste
    initial begin
        // --- 1. Inicialização dos Sinais ---
        rst_n    = 1'b0; // Ativa reset assíncrono imediatamente
        we       = 1'b0;
        w_addr   = 4'b0;
        w_data   = 8'b0;
        r_addr_a = 4'b0;
        r_addr_b = 4'b0;
        
        #15;
        rst_n    = 1'b1; // Libera o reset após 1.5 ciclos de clock
        #5;

        $display("=== INICIANDO TESTE DE LEITURA DO BANCO DE REGISTRADORES ===");

        // --- 2. Escrita de Valores de Teste em Registradores Específicos ---
        // Vamos escrever dados conhecidos para podermos ler depois
        
        // Escreve 8'hAA no Registrador 3
        @(posedge clk);
        we     = 1'b1;
        w_addr = 4'd3;
        w_data = 8'hAA;
        
        // Escreve 8'h55 no Registrador 8 (9º Registrador)
        @(posedge clk);
        w_addr = 4'd8;
        w_data = 8'h55;

        // Escreve 8'hF0 no Registrador 10 (11º Registrador)
        @(posedge clk);
        w_addr = 4'd10;
        w_data = 8'hF0;

        // Escreve 8'h0F no Registrador 15 (16º Registrador)
        @(posedge clk);
        w_addr = 4'd15;
        w_data = 8'h0F;

        // Finaliza ciclo de escrita
        @(posedge clk);
        we     = 1'b0;
        w_addr = 4'b0;
        w_data = 8'b0;
        #10;

        // --- 3. Teste de Leitura Assíncrona Combinacional (Porta A e B paralelas) ---
        $display("\n[TESTE 1] Leitura Simultânea de Reg3 e Reg8...");
        r_addr_a = 4'd3; // Aponta Porta A para o Registrador 3 (AA esperado)
        r_addr_b = 4'd8; // Aponta Porta B para o Registrador 8 (55 esperado)
        #2; // Aguarda tempo de propagação combinacional
        $display("Porta A (Reg3) lido: %h (Esperado: AA)", r_data_a);
        $display("Porta B (Reg8) lido: %h (Esperado: 55)", r_data_b);
        if (r_data_a == 8'hAA && r_data_b == 8'h55)
            $display("-> TESTE 1: SUCESSO!");
        else
            $display("-> TESTE 1: FALHOU!");

        $display("\n[TESTE 2] Leitura Simultânea de Reg10 e Reg15...");
        r_addr_a = 4'd10; // Aponta Porta A para o Registrador 10 (F0 esperado)
        r_addr_b = 4'd15; // Aponta Porta B para o Registrador 15 (0F esperado)
        #2;
        $display("Porta A (Reg10) lido: %h (Esperado: F0)", r_data_a);
        $display("Porta B (Reg15) lido: %h (Esperado: 0F)", r_data_b);
        if (r_data_a == 8'hF0 && r_data_b == 8'h0F)
            $display("-> TESTE 2: SUCESSO!");
        else
            $display("-> TESTE 2: FALHOU!");

        // --- 4. Provando que a Leitura é Combinacional (Assíncrona ao Clock) ---
        $display("\n[TESTE 3] Verificando Leitura Combinacional (Sem esperar a subida do Clock)...");
        #3; // Estamos no meio de um ciclo de clock estável
        r_addr_a = 4'd8;  // Mudança abrupta de endereço no meio do ciclo
        r_addr_b = 4'd3;
        #1; // Apenas 1ns depois, o dado já deve ter mudado
        $display("Mudança instantânea Porta A (Reg8): %h (Esperado: 55)", r_data_a);
        $display("Mudança instantânea Porta B (Reg3): %h (Esperado: AA)", r_data_b);
        if (r_data_a == 8'h55 && r_data_b == 8'hAA)
            $display("-> TESTE 3: SUCESSO! A leitura não depende da borda do clock.");
        else
            $display("-> TESTE 3: FALHOU! Houve latência indesejada na leitura.");

        // --- 5. Teste de Reset Assíncrono ---
        $display("\n[TESTE 4] Ativação de Reset Assíncrono...");
        rst_n = 1'b0; // Zera todos os registradores imediatamente
        #1;
        $display("Leitura pós-reset Porta A: %h (Esperado: 00)", r_data_a);
        $display("Leitura pós-reset Porta B: %h (Esperado: 00)", r_data_b);
        if (r_data_a == 8'h00 && r_data_b == 8'h00)
            $display("-> TESTE 4: SUCESSO! O reset assíncrono limpou o banco.");
        else
            $display("-> TESTE 4: FALHOU!");

        $display("\n================ SIMULAÇÃO FINALIZADA COMPLETA ================");
        $finish;
    end

endmodule
