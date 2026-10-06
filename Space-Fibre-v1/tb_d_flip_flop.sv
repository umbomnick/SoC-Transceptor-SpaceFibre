// =============================================================================
// Projeto CI Amazonia - Atividade de Digitais
// Testbench para o Flip-Flop D
// Desenvolvedor: [Nome do Aluno / Notebook CI Amazonia]
// Data: 23 de Julho de 2026
// =============================================================================

`timescale 1ns/1ps

module tb_d_flip_flop;

    // Sinais para conexao com o DUT (Device Under Test)
    logic clk;
    logic rst_n;
    logic d;
    logic q;
    logic q_bar;

    // Instanciacao do Flip-Flop D
    d_flip_flop dut (
        .clk(clk),
        .rst_n(rst_n),
        .d(d),
        .q(q),
        .q_bar(q_bar)
    );

    // Canal para escrita dos dados de simulacao em arquivo de texto
    int fd;

    // Inicializacao dos sinais e geracao de estimulos
    initial begin
        // Abrir arquivo para registrar os dados de simulacao
        fd = $fopen("simulation_data.txt", "w");
        if (fd == 0) begin
            $display("Erro ao abrir arquivo para gravacao!");
            $finish;
        end
        // Cabecalho do arquivo CSV
        $fdisplay(fd, "time,clk,rst_n,d,q,q_bar");

        // Gravacao das formas de onda padrao VCD para o GTKWave
        $dumpfile("ondas.vcd");
        $dumpvars(0, tb_d_flip_flop);

        // --- Inicio dos Estimulos ---
        $display("Iniciando a simulacao do Flip-Flop D...");
        
        // Estado inicial
        clk   = 1'b0;
        rst_n = 1'b1; // Inativo
        d     = 1'b0;
        #2;

        // Caso 1: Ativacao do Reset Assincrono fora da borda do clock
        $display("[%0t ns] Ativando reset assincrono...", $time);
        rst_n = 1'b0;
        #8;
        
        // Caso 2: Liberacao do Reset
        $display("[%0t ns] Liberando reset assincrono...", $time);
        rst_n = 1'b1;
        #5;

        // Mudar D antes da borda do clock (D = 1, Clock ainda é 0)
        $display("[%0t ns] Mudando D para 1 (Clock esta em baixo)...", $time);
        d = 1'b1;
        #5;

        // Borda de subida 1 (Clock de 0 para 1) -> Q deve ir para 1
        $display("[%0t ns] Borda de subida 1 -> Q deve atualizar para 1...", $time);
        clk = 1'b1;
        #5;
        clk = 1'b0; // Borda de descida
        #5;

        // Caso 3: Hold Condition e mudancas em D fora do clock
        $display("[%0t ns] Mudando D com clock em baixo -> Saida Q nao deve mudar...", $time);
        d = 1'b0;
        #5;
        d = 1'b1;
        #5;

        // Borda de subida 2 -> Q deve se manter em 1 (pois D = 1)
        $display("[%0t ns] Borda de subida 2 -> Q deve reter o valor 1...", $time);
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #3;

        // Caso 4: Ativacao do Reset Assincrono com Clock em Baixo (Q deve cair para 0 imediatamente)
        $display("[%0t ns] Reset assincrono ativo no meio do ciclo -> Q deve cair para 0 IMEDIATAMENTE...", $time);
        rst_n = 1'b0;
        #4;
        rst_n = 1'b1; // Libera reset
        #8;

        // Borda de subida 3 (D = 1) -> Q deve ir para 1 novamente
        $display("[%0t ns] Borda de subida 3 -> Q deve ir para 1...", $time);
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;

        // Caso 5: Mudanca de D para 0 e amostragem na Borda 4
        $display("[%0t ns] Mudando D para 0...", $time);
        d = 1'b0;
        #10;

        $display("[%0t ns] Borda de subida 4 -> Q deve ir para 0...", $time);
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #15;

        $display("Simulacao concluida com sucesso.");
        $fclose(fd);
        $finish;
    end

    // Processo paralelo para gravar os estados a cada 1ns
    always begin
        // Escreve os sinais a cada passo de 1ns
        $fdisplay(fd, "%0d,%b,%b,%b,%b,%b", $time, clk, rst_n, d, q, q_bar);
        #1;
    end

endmodule
