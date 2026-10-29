`timescale 1ns / 1ps

module testbench;

    // ------------------------------------------------------------------------
    // Sinais de Clock e Reset
    // ------------------------------------------------------------------------
    reg clk;
    reg rst_n;

    // ------------------------------------------------------------------------
    // Sinais de Entrada para a FSM
    // ------------------------------------------------------------------------
    reg lane_start;
    reg auto_start;
    reg lane_reset;
    reg rx_only;
    reg tx_only;
    reg no_signal;
    reg far_end_active;
    reg rx_err_pulse;
    reg word_tick;
    reg rx_init1;
    reg rx_init2;
    reg rx_init3;
    reg rx_standby;
    reg rx_lost_signal;
    reg rx_comma;

    // ------------------------------------------------------------------------
    // Sinais de Entrada para o Word Generator
    // ------------------------------------------------------------------------
    reg [7:0] capability_reg;

    // ------------------------------------------------------------------------
    // Sinais de Interligação FSM <-> Word Generator
    // ------------------------------------------------------------------------
    wire send_init1;
    wire send_init2;
    wire send_init3;
    wire send_standby;
    wire send_lost_signal;

    // ------------------------------------------------------------------------
    // Sinais de Saída Observáveis
    // ------------------------------------------------------------------------
    wire tx_enable;
    wire rx_enable;
    wire [3:0] current_state;
    wire [7:0] din_to_enc;
    wire       kin_to_enc;
    wire       word_done;

    // ------------------------------------------------------------------------
    // Instanciação da Máquina de Estados (LISM)[cite: 8]
    // ------------------------------------------------------------------------
    lane_init_fsm u_fsm (
        .clk              (clk),
        .rst_n            (rst_n),
        .lane_start       (lane_start),
        .auto_start       (auto_start),
        .lane_reset       (lane_reset),
        .rx_only          (rx_only),
        .tx_only          (tx_only),
        .no_signal        (no_signal),
        .far_end_active   (far_end_active),
        .rx_err_pulse     (rx_err_pulse),
        .word_tick        (word_tick),
        .rx_init1         (rx_init1),
        .rx_init2         (rx_init2),
        .rx_init3         (rx_init3),
        .rx_standby       (rx_standby),
        .rx_lost_signal   (rx_lost_signal),
        .rx_comma         (rx_comma),
        .tx_enable        (tx_enable),
        .rx_enable        (rx_enable),
        .send_init1       (send_init1),
        .send_init2       (send_init2),
        .send_init3       (send_init3),
        .send_standby     (send_standby),
        .send_lost_signal (send_lost_signal),
        .current_state    (current_state)
    );

    // ------------------------------------------------------------------------
    // Instanciação do Gerador de Palavras[cite: 8]
    // ------------------------------------------------------------------------
    lane_word_gen u_word_gen (
        .clk              (clk),
        .rst_n            (rst_n),
        .send_init1       (send_init1),
        .send_init2       (send_init2),
        .send_init3       (send_init3),
        .send_standby     (send_standby),
        .send_lost_signal (send_lost_signal),
        .capability_reg   (capability_reg),
        .din_to_enc       (din_to_enc),
        .kin_to_enc       (kin_to_enc),
        .word_done        (word_done)
    );

    // ------------------------------------------------------------------------
    // Geração de Clock (Período = 10ns -> 100MHz)
    // ------------------------------------------------------------------------
    always #5 clk = ~clk;

    // ------------------------------------------------------------------------
    // Geração de Word Tick (A cada 4 ciclos de clock = 1 palavra de 32 bits)[cite: 8]
    // ------------------------------------------------------------------------
    reg [1:0] tick_counter;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tick_counter <= 2'b0;
            word_tick <= 1'b0;
        end else begin
            tick_counter <= tick_counter + 1'b1;
            word_tick <= (tick_counter == 2'd3) ? 1'b1 : 1'b0;
        end
    end

    // ------------------------------------------------------------------------
    // Cenários de Teste (Estímulos)
    // ------------------------------------------------------------------------
    initial begin
        // Inicialização de ficheiro para o GTKWave[cite: 11]
        $dumpfile("lane_init.vcd");
        $dumpvars(0, testbench);

        // Estado Inicial
        clk = 0;
        rst_n = 0;
        lane_start = 0;
        auto_start = 0;
        lane_reset = 0;
        rx_only = 0;
        tx_only = 0;
        no_signal = 1;
        far_end_active = 0;
        rx_err_pulse = 0;
        rx_init1 = 0;
        rx_init2 = 0;
        rx_init3 = 0;
        rx_standby = 0;
        rx_lost_signal = 0;
        rx_comma = 0;
        capability_reg = 8'h0F; // Flags arbitrárias para INIT3[cite: 8]

        // Libertar Reset
        #20;
        rst_n = 1;
        
        // --------------------------------------------------------------------
        // Cenário 1: Inicialização Bem-Sucedida
        // --------------------------------------------------------------------
        $display("Iniciando Cenario 1: Handshake Completo");
        
        #40;
        // 1. Iniciar Ligação (FSM passa para WAIT)
        lane_start = 1; 
        
        #40;
        // 2. Sinal é detetado na linha (FSM passa para STARTED e envia INIT1)[cite: 8]
        no_signal = 0; 
        
        #80;
        // 3. Recebe INIT1 remoto (FSM passa para CONNECTING e envia INIT2)[cite: 8]
        rx_init1 = 1;
        #10 rx_init1 = 0; // Pulso

        #80;
        // 4. Recebe INIT2 remoto (FSM passa para CONNECTED e envia INIT3)[cite: 8]
        rx_init2 = 1;
        #10 rx_init2 = 0;

        #80;
        // 5. Recebe INIT3 remoto com parâmetros correspondentes (FSM passa para ACTIVE)[cite: 8]
        rx_init3 = 1;
        #10 rx_init3 = 0;
        
        #40;
        $display("Estado Esperado: ACTIVE (6) | Estado Atual: %d", current_state);

        // --------------------------------------------------------------------
        // Cenário 2: Perda de Sinal (Loss of Signal) a partir de ACTIVE
        // --------------------------------------------------------------------
        $display("Iniciando Cenario 2: Perda de Sinal");
        #100;
        // Deteta perda de sinal físico (FSM passa para LOSS_OF_SIGNAL)[cite: 8]
        no_signal = 1;
        
        #80;
        $display("Estado Esperado: LOSS_OF_SIGNAL (8) | Estado Atual: %d", current_state);
        
        // O gerador deve estar a enviar a palavra LOST_SIGNAL
        #40;

        // Forçar Reset da Lane para recomeçar
        lane_reset = 1;
        #20 lane_reset = 0;

        // Fim da Simulação
        #200;
        $display("Simulacao Concluida.");
        $finish;
    end

endmodule