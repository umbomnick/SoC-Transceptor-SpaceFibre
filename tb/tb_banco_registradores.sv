`timescale 1ns/1ps

module tb_banco_registradores;

    // =========================================================
    // Entradas do DUT
    // =========================================================

    logic        clk;
    logic        rst_n;
    logic        we;

    logic [3:0]  w_addr;
    logic [7:0]  w_data;

    logic [3:0]  r_addr_a;
    logic [3:0]  r_addr_b;

    // =========================================================
    // Saídas do DUT
    // =========================================================

    wire [7:0]  r_data_a;
    wire [7:0]  r_data_b;
    wire [15:0] we_dec;

    // =========================================================
    // DUT - nosso esquemático BDF
    // =========================================================

    banco_de_registadores_top dut (
        .w_addr   (w_addr),
        .we       (we),
        .w_data   (w_data),

        .r_addr_a (r_addr_a),
        .r_addr_b (r_addr_b),

        .clk      (clk),
        .rst_n    (rst_n),

        .r_data_a (r_data_a),
        .r_data_b (r_data_b),

        .we_dec   (we_dec)
    );

    // =========================================================
    // Geração do clock
    // Período = 10 ns
    // =========================================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // =========================================================
    // Estímulos
    // =========================================================

    initial begin

        // Valores iniciais
        rst_n    = 1'b0;
        we       = 1'b0;

        w_addr   = 4'd0;
        w_data   = 8'h00;

        r_addr_a = 4'd0;
        r_addr_b = 4'd0;

        // -----------------------------------------------------
        // RESET
        // -----------------------------------------------------

        #12;

        rst_n = 1'b1;

        #10;

        // -----------------------------------------------------
        // TESTE 1
        // Escrever AA no registrador 3
        // -----------------------------------------------------

        $display("==========================================");
        $display("TESTE 1 - Escrita no registrador 3");
        $display("==========================================");

        w_addr = 4'd3;
        w_data = 8'hAA;
        we     = 1'b1;

        // Aguarda uma borda de clock
        @(posedge clk);

        #1;

        we = 1'b0;

        // Ler registrador 3 pela porta A
        r_addr_a = 4'd3;

        #1;

        $display("Reg3 = %02h", r_data_a);

        if (r_data_a == 8'hAA)
            $display("TESTE 1: PASSOU");
        else
            $display("TESTE 1: FALHOU");

        // -----------------------------------------------------
        // TESTE 2
        // Escrever 55 no registrador 8
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("TESTE 2 - Escrita no registrador 8");
        $display("==========================================");

        w_addr = 4'd8;
        w_data = 8'h55;
        we     = 1'b1;

        @(posedge clk);

        #1;

        we = 1'b0;

        r_addr_a = 4'd8;

        #1;

        $display("Reg8 = %02h", r_data_a);

        if (r_data_a == 8'h55)
            $display("TESTE 2: PASSOU");
        else
            $display("TESTE 2: FALHOU");

        // -----------------------------------------------------
        // TESTE 3
        // Leitura simultânea pelas portas A e B
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("TESTE 3 - Leitura simultanea");
        $display("==========================================");

        r_addr_a = 4'd3;
        r_addr_b = 4'd8;

        #1;

        $display("Porta A - Reg3 = %02h", r_data_a);
        $display("Porta B - Reg8 = %02h", r_data_b);

        if ((r_data_a == 8'hAA) &&
            (r_data_b == 8'h55))
            $display("TESTE 3: PASSOU");
        else
            $display("TESTE 3: FALHOU");

        // -----------------------------------------------------
        // TESTE 4
        // Sobrescrever registrador 3
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("TESTE 4 - Sobrescrita do registrador 3");
        $display("==========================================");

        w_addr = 4'd3;
        w_data = 8'hF0;
        we     = 1'b1;

        @(posedge clk);

        #1;

        we = 1'b0;

        r_addr_a = 4'd3;

        #1;

        $display("Reg3 = %02h", r_data_a);

        if (r_data_a == 8'hF0)
            $display("TESTE 4: PASSOU");
        else
            $display("TESTE 4: FALHOU");

        // -----------------------------------------------------
        // TESTE 5
        // Verificar o decoder
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("TESTE 5 - Decoder");
        $display("==========================================");

        w_addr = 4'd5;
        we     = 1'b1;

        #1;

        $display("w_addr = %d", w_addr);
        $display("we_dec = %016b", we_dec);

        if (we_dec == 16'b0000_0000_0010_0000)
            $display("TESTE 5: PASSOU");
        else
            $display("TESTE 5: FALHOU");

        we = 1'b0;

        #10;

        // -----------------------------------------------------
        // FIM
        // -----------------------------------------------------

        $display("");
        $display("==========================================");
        $display("FIM DA SIMULACAO");
        $display("==========================================");

        $finish;

    end

endmodule