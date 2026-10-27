// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: tb_spacefibre_lane_top.v
// Padrao : ECSS-E-ST-50-11C
// Funcao : Testbench Autoverificavel e Detalhado de Diagnostico (Top-Level)
// Versao : ASCII Limpo (7-bit) com Monitoramento Continuo de Estados e Sinais
// ============================================================================

`timescale 1ns / 1ps

module tb_spacefibre_lane_top;

    reg        clk;
    reg        rst_n;

    // Interface PHY
    wire       line_driver_en;
    wire       line_rx_en;
    wire       cdr_en;
    wire       invert_rx_polarity;
    reg        loss_of_signal;
    wire [9:0] tx_10b_symbol;
    reg  [9:0] rx_10b_symbol;

    // Interface Data Link / Multi-Lane
    reg  [31:0] dl_tx_word;
    reg  [3:0]  dl_tx_k_flags;
    reg         dl_tx_valid;
    wire [31:0] dl_rx_word;
    wire [3:0]  dl_rx_k_flags;
    wire        dl_rx_valid;
    wire        lane_active;
    wire [7:0]  far_end_capabilities;

    // Interface de Gestao (MIB)
    reg        lane_start;
    reg        auto_start;
    reg        lane_reset;
    reg        parallel_loopback_en;
    reg  [7:0] error_threshold;
    wire [2:0] lane_state;
    wire [15:0] rxerr_count;
    wire       rx_polarity_status;

    integer test_count  = 0;
    integer error_count = 0;
    integer cycle_count = 0;

    // Instanciacao do Top-Level (DUT)
    spacefibre_lane_top #(
        .DEFAULT_ERR_THRESHOLD(8),
        .TIMER_CLEAR_LIMIT(10)
    ) dut (
        .clk                 (clk),
        .rst_n               (rst_n),
        .line_driver_en      (line_driver_en),
        .line_rx_en          (line_rx_en),
        .cdr_en              (cdr_en),
        .invert_rx_polarity  (invert_rx_polarity),
        .loss_of_signal      (loss_of_signal),
        .tx_10b_symbol       (tx_10b_symbol),
        .rx_10b_symbol       (rx_10b_symbol),
        .dl_tx_word          (dl_tx_word),
        .dl_tx_k_flags       (dl_tx_k_flags),
        .dl_tx_valid         (dl_tx_valid),
        .dl_rx_word          (dl_rx_word),
        .dl_rx_k_flags       (dl_rx_k_flags),
        .dl_rx_valid         (dl_rx_valid),
        .lane_active         (lane_active),
        .far_end_capabilities(far_end_capabilities),
        .lane_start          (lane_start),
        .auto_start          (auto_start),
        .lane_reset          (lane_reset),
        .parallel_loopback_en(parallel_loopback_en),
        .error_threshold    (error_threshold),
        .lane_state          (lane_state),
        .rxerr_count         (rxerr_count),
        .rx_polarity_status  (rx_polarity_status)
    );

    // Gerador de Clock de 125 MHz (Periodo de 8 ns)
    always #4 clk = ~clk;

    // Contador global de ciclos de clock
    always @(posedge clk) begin
        if (rst_n) cycle_count <= cycle_count + 1;
    end

    // Tradutor de Codigo do Estado da FSM LISM para String Legivel
    function [143:0] get_state_name(input [2:0] st);
        case (st)
            3'd0: get_state_name = "ST_OFF (0)";
            3'd1: get_state_name = "ST_CLEAR_LINE (1)";
            3'd2: get_state_name = "ST_STARTED (2)";
            3'd3: get_state_name = "ST_CONNECTING (3)";
            3'd4: get_state_name = "ST_ACTIVE (4)";
            3'd5: get_state_name = "ST_RECOVERY (5)";
            default: get_state_name = "ST_DESCONHECIDO";
        endcase
    endfunction

    // Monitor em Tempo Real: Transicoes da FSM LISM
    reg [2:0] prev_state;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_state <= 3'd0;
        end else if (lane_state !== prev_state) begin
            $display("[MONITOR FSM] T=%0t ns (Ciclo %0d) | Mudanca de Estado: %s -> %s",
                     $time, cycle_count, get_state_name(prev_state), get_state_name(lane_state));
            $display("              Sinais em T: lane_active=%b | word_aligned=%b | line_driver_en=%b | tx_symbol=10'h%0h",
                     lane_active, dut.word_aligned, line_driver_en, tx_10b_symbol);
            prev_state <= lane_state;
        end
    end

    // Monitor em Tempo Real: Status de Alinhamento de Palavra
    reg prev_aligned;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_aligned <= 1'b0;
        end else if (dut.word_aligned !== prev_aligned) begin
            $display("[MONITOR ALIGN] T=%0t ns (Ciclo %0d) | word_aligned mudou para: %b | RX_Symbol=10'h%0h (Comma_Det=%b)",
                     $time, cycle_count, dut.word_aligned, dut.phy_rx_symbol, dut.comma_det);
            prev_aligned <= dut.word_aligned;
        end
    end

    initial begin
        $dumpfile("wave_lane_top.vcd");
        $dumpvars(0, tb_spacefibre_lane_top);

        clk                  = 1'b0;
        rst_n                = 1'b0;
        loss_of_signal       = 1'b1;
        rx_10b_symbol        = 10'b0;
        dl_tx_word           = 32'b0;
        dl_tx_k_flags        = 4'b0;
        dl_tx_valid          = 1'b0;
        lane_start           = 1'b0;
        auto_start           = 1'b0;
        lane_reset           = 1'b0;
        parallel_loopback_en = 1'b1; // Ativa Loopback Paralelo Interno
        error_threshold      = 8'd8;

        $display("==================================================================");
        $display(" TESTBENCH DETALHADO DE DIAGNOSTICO: SPACEFIBRE LANE TOP (ECSS)");
        $display("==================================================================");

        #20;
        rst_n = 1'b1;
        #10;

        // --------------------------------------------------------------------
        // TESTE 1: RESET INICIAL
        // --------------------------------------------------------------------
        $display("\n--- [PASSO 1] VERIFICACAO DE RESET INICIAL ---");
        test_count = test_count + 1;
        $display("Diagnostico Inicial: State=%s | Active=%b | DriverEn=%b",
                 get_state_name(lane_state), lane_active, line_driver_en);
        if (lane_state === 3'd0 && lane_active === 1'b0 && line_driver_en === 1'b0) begin
            $display("[OK] Teste 1: Reset verificado com sucesso. Sistema em ST_OFF.");
        end else begin
            $display("[ERRO] Teste 1: Falha no reset inicial do Top-Level.");
            error_count = error_count + 1;
        end

        // --------------------------------------------------------------------
        // TESTE 2: INICIALIZACAO E HANDSHAKE DA LANE
        // --------------------------------------------------------------------
        $display("\n--- [PASSO 2] SOLICITANDO INICIALIZACAO DA LANE (lane_start) ---");
        loss_of_signal = 1'b0; // Sinal presente da PHY
        lane_start     = 1'b1; // Pulso de partida
        $display("T=%0t ns | Pulso lane_start ativado (loss_of_signal=0)", $time);
        @(posedge clk); #1;
        lane_start     = 1'b0;
        $display("T=%0t ns | Pulso lane_start desativado", $time);

        $display("Aguardando transicao de estados da FSM ate ST_ACTIVE (Timeout: 100 ciclos)...");
        fork
            begin
                wait (lane_active === 1'b1);
            end
            begin
                repeat (100) @(posedge clk);
            end
        join_any
        disable fork;
        #1;

        test_count = test_count + 1;
        $display("Status Apos Aguardo: State=%s | lane_active=%b | word_aligned=%b",
                 get_state_name(lane_state), lane_active, dut.word_aligned);

        if (lane_state === 3'd4 && lane_active === 1'b1) begin
            $display("[OK] Teste 2: Inicializacao concluida com sucesso! Link estabilizado em ST_ACTIVE.");
        end else begin
            $display("[ERRO DIAGNOSTICO] Teste 2: Falha ao atingir ST_ACTIVE!");
            $display("                   Estado Parado = %s", get_state_name(lane_state));
            $display("                   Sinais Internos de Diagnostico:");
            $display("                   - lane_enabled_reg  = %b", dut.lane_enabled_reg);
            $display("                   - loss_of_signal    = %b", loss_of_signal);
            $display("                   - word_aligned      = %b", dut.word_aligned);
            $display("                   - tx_init_cmd       = %0d", dut.tx_init_cmd);
            $display("                   - enc_tx_byte       = 8'h%0h (k=%b)", dut.enc_tx_byte, dut.enc_tx_k);
            $display("                   - tx_10b_symbol     = 10'h%0h", tx_10b_symbol);
            $display("                   - phy_rx_symbol     = 10'h%0h", dut.phy_rx_symbol);
            error_count = error_count + 1;
        end

        // --------------------------------------------------------------------
        // TESTE 3: TRAFEGO DE DADOS EM LOOPBACK
        // --------------------------------------------------------------------
        $display("\n--- [PASSO 3] TESTANDO TRAFEGO DE DADOS EM LOOPBACK ---");
        dl_tx_word    = 32'h000000A5; // Byte D10.2
        dl_tx_k_flags = 4'b0000;
        dl_tx_valid   = 1'b1;
        $display("T=%0t ns | Transmitindo Dado 0x000000A5...", $time);
        @(posedge clk); #1;

        repeat (5) @(posedge clk); #1;

        test_count = test_count + 1;
        if (lane_active === 1'b1) begin
            $display("[OK] Teste 3: Link mantido em ST_ACTIVE durante transferencia de dados.");
            $display("             RX Word = 32'h%0h | RX Valid = %b", dl_rx_word, dl_rx_valid);
        end else begin
            $display("[ERRO DIAGNOSTICO] Teste 3: Link perdeu o estado ativo durante o trafego!");
            $display("                   State Atual = %s", get_state_name(lane_state));
            error_count = error_count + 1;
        end

        // --------------------------------------------------------------------
        // TESTE 4: INJECAO DE FALHA E RECUPERACAO AUTOMATICA
        // --------------------------------------------------------------------
        $display("\n--- [PASSO 4] INJETANDO FALHA: PERDA DE SINAL (loss_of_signal=1) ---");
        loss_of_signal = 1'b1;
        $display("T=%0t ns | loss_of_signal ativado em nivel alto", $time);
        @(posedge clk); #1;
        @(posedge clk); #1;

        test_count = test_count + 1;
        $display("Status Apos Perda de Sinal: State=%s | lane_active=%b",
                 get_state_name(lane_state), lane_active);

        if (lane_state === 3'd5 || lane_state === 3'd1) begin
            $display("[OK] Teste 4: Recuperacao acionada corretamente! FSM foi para %s.",
                     get_state_name(lane_state));
        end else begin
            $display("[ERRO DIAGNOSTICO] Teste 4: Falha na transicao de recuperacao!");
            error_count = error_count + 1;
        end

        #20;
        $display("\n==================================================================");
        if (error_count == 0) begin
            $display(" RESULTADO FINAL: [PASS] TODOS OS %0d TESTES PASSARAM COM SUCESSO!", test_count);
        end else begin
            $display(" RESULTADO FINAL: [FAIL] ENCONTRADOS %0d ERROS NO TOP-LEVEL.", error_count);
        end
        $display("==================================================================");

        $finish;
    end

endmodule
