`timescale 1ns / 1ps

module tb_encoder_8b10b;

    reg        clk;
    reg        rst_n;
    reg        kin;
    reg  [7:0] din;
    wire [9:0] dout;

    // Instanciação do DUT (Device Under Test)
    encoder_8b10b dut (
        .clk   (clk),
        .rst_n (rst_n),
        .kin   (kin),
        .din   (din),
        .dout  (dout)
    );

    // Geração de clock: período de 20ns (50 MHz)
    always #10 clk = ~clk;

    initial begin
        // Geração do arquivo VCD para visualização no GTKWave
        $dumpfile("sims/encoder_8b10b.vcd");
        $dumpvars(0, tb_encoder_8b10b);

        // 1. Inicialização e Reset Assíncrono (ativo baixo)
        clk   = 0;
        rst_n = 0;
        kin   = 0;
        din   = 8'h00;

        #25;
        rst_n = 1; // Libera o reset, RD inicial = RD- (0)
        #15;

        // 2. Teste de Caracteres de Dados (D-Codes)
        $display("--- INICIANDO TESTE DO CODIFICADOR 8B/10B ---");
        
        // D00.0 (0x00)
        din = 8'h00; kin = 0;
        #20;
        $display("[D00.0] In: 0x%02X | Out: %b | RD: %b", din, dout, dut.rd_reg);

        // D01.0 (0x01)
        din = 8'h01; kin = 0;
        #20;
        $display("[D01.0] In: 0x%02X | Out: %b | RD: %b", din, dout, dut.rd_reg);

        // D12.5 (0xAC) - Exemplo clássico da norma ECSS-E-ST-50-11C
        din = 8'hAC; kin = 0;
        #20;
        $display("[D12.5] In: 0x%02X | Out: %b | RD: %b", din, dout, dut.rd_reg);

        // 3. Teste de Caractere de Controle Especial: Comma K28.5 (0xBC)
        din = 8'hBC; kin = 1;
        #20;
        $display("[K28.5] In: 0x%02X (COMMA) | Out: %b | RD: %b", din, dout, dut.rd_reg);

        // Volta para dado comum D21.2 (0x55)
        din = 8'h55; kin = 0;
        #20;
        $display("[D21.2] In: 0x%02X | Out: %b | RD: %b", din, dout, dut.rd_reg);

        #40;
        $display("--- SIMULACAO CONCLUIDA COM SUCESSO ---");
        $finish;
    end

endmodule