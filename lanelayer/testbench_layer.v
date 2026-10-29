`timescale 1ns / 1ps

module testbench;

    // Sinais de Clock e Reset
    reg clk;
    reg rst_n;

    // Entradas do Top-Level
    reg lane_start;
    reg auto_start;
    reg lane_reset;
    reg rx_only;
    reg tx_only;
    reg [7:0] capability_reg;
    reg no_signal;
    reg far_end_active;
    reg rx_err_pulse;
    reg rx_init1;
    reg rx_init2;
    reg rx_init3;
    reg rx_standby;
    reg rx_lost_signal;
    reg rx_comma;

    // Saídas do Top-Level
    wire tx_enable;
    wire rx_enable;
    wire [3:0] current_state;
    wire [9:0] tx_data_out;

    // Instanciação do Top-Level da Lane Layer
    lane_layer_top u_lane_top (
        .clk              (clk),
        .rst_n            (rst_n),
        .lane_start       (lane_start),
        .auto_start       (auto_start),
        .lane_reset       (lane_reset),
        .rx_only          (rx_only),
        .tx_only          (tx_only),
        .capability_reg   (capability_reg),
        .no_signal        (no_signal),
        .far_end_active   (far_end_active),
        .rx_err_pulse     (rx_err_pulse),
        .rx_init1         (rx_init1),
        .rx_init2         (rx_init2),
        .rx_init3         (rx_init3),
        .rx_standby       (rx_standby),
        .rx_lost_signal   (rx_lost_signal),
        .rx_comma         (rx_comma),
        .tx_enable        (tx_enable),
        .rx_enable        (rx_enable),
        .current_state    (current_state),
        .tx_data_out      (tx_data_out)
    );

    // Geração de Clock (10ns = 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Arquivo de saída para o GTKWave
        $dumpfile("wave_lane_top.vcd");
        $dumpvars(0, testbench);

        // Inicialização de Sinais
        clk = 0;
        rst_n = 0;
        lane_start = 0;
        auto_start = 0;
        lane_reset = 0;
        rx_only = 0;
        tx_only = 0;
        capability_reg = 8'h0F;
        no_signal = 1;
        far_end_active = 0;
        rx_err_pulse = 0;
        rx_init1 = 0;
        rx_init2 = 0;
        rx_init3 = 0;
        rx_standby = 0;
        rx_lost_signal = 0;
        rx_comma = 0;

        #20;
        rst_n = 1; // Libera o reset
        
        $display("Iniciando Cenario 1: Handshake LISM completo com saida 8b/10b");
        
        #40;
        lane_start = 1; 
        
        #40;
        no_signal = 0; 
        
        #120;
        rx_init1 = 1;
        #10 rx_init1 = 0;

        #120;
        rx_init2 = 1;
        #10 rx_init2 = 0;

        #120;
        rx_init3 = 1;
        #10 rx_init3 = 0;
        
        #80;
        $display("Estado Esperado: ACTIVE (6) | Estado Atual: %d", current_state);

        #100;
        no_signal = 1;
        
        #80;
        $display("Estado Esperado: LOSS_OF_SIGNAL (8) | Estado Atual: %d", current_state);
        
        #100;
        $display("Simulacao Concluida.");
        $finish;
    end
endmodule
