// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: tb/tb_spacefibre_lane_top.v
// Padrao : ECSS-E-ST-50-11C
// Funcao : Testbench autoverificavel da Lane Layer (spacefibre_lane_top):
//          1. Reset inicial (Disabled, drivers desligados)
//          2. Handshake LISM completo (Wait -> Started -> Connecting -> Connected -> Active)
//             e troca de capacidades via INIT3
//          3. Transferencia de palavras de 32 bits + filtragem transparente de IDLE/SKIP
//          4. Inversao automatica de polaridade RX (Started -> InvertRxPolarity -> Active)
//          5. Perda de sinal (LossOfSignal -> ClearLine) e recuperacao automatica
// ============================================================================
`timescale 1ns / 1ps

module tb_spacefibre_lane_top;

    reg        clk = 1'b0;
    reg        rst_n = 1'b0;

    wire       line_driver_en;
    wire       line_rx_en;
    wire       cdr_en;
    wire       invert_rx_polarity;
    reg        loss_of_signal = 1'b1;
    wire [9:0] tx_10b_symbol;
    reg  [9:0] rx_10b_symbol = 10'd0;

    reg  [31:0] dl_tx_word    = 32'd0;
    reg  [3:0]  dl_tx_k_flags = 4'd0;
    reg         dl_tx_valid   = 1'b0;
    wire        dl_tx_ready;
    wire [31:0] dl_rx_word;
    wire [3:0]  dl_rx_k_flags;
    wire        dl_rx_valid;
    wire        dl_rx_err;
    wire        lane_active;
    wire [7:0]  far_end_capabilities;
    wire        far_end_caps_valid;

    reg        lane_start           = 1'b0;
    reg        auto_start           = 1'b0;
    reg        lane_reset           = 1'b0;
    reg        parallel_loopback_en = 1'b1;
    reg  [7:0] error_threshold      = 8'd8;
    wire [2:0] lane_state;
    wire [15:0] rxerr_count;
    wire       rx_polarity_status;

    reg        ext_inv_loop = 1'b0;
    always @(*) begin
        rx_10b_symbol = ext_inv_loop ? ~tx_10b_symbol : tx_10b_symbol;
    end

    integer test_count  = 0;
    integer error_count = 0;
    integer got_data    = 0;

    spacefibre_lane_top #(
        .DEFAULT_ERR_THRESHOLD (8),
        .TIMER_CLEAR_LIMIT     (16),
        .HANDSHAKE_WORDS       (16),
        .ABORT_WORDS           (8),
        .SKIP_PERIOD           (32)
    ) dut (
        .clk                   (clk),
        .rst_n                 (rst_n),
        .line_driver_en        (line_driver_en),
        .line_rx_en            (line_rx_en),
        .cdr_en                (cdr_en),
        .invert_rx_polarity    (invert_rx_polarity),
        .loss_of_signal        (loss_of_signal),
        .tx_10b_symbol         (tx_10b_symbol),
        .rx_10b_symbol         (rx_10b_symbol),
        .dl_tx_word            (dl_tx_word),
        .dl_tx_k_flags         (dl_tx_k_flags),
        .dl_tx_valid           (dl_tx_valid),
        .dl_tx_ready           (dl_tx_ready),
        .dl_rx_word            (dl_rx_word),
        .dl_rx_k_flags         (dl_rx_k_flags),
        .dl_rx_valid           (dl_rx_valid),
        .dl_rx_err             (dl_rx_err),
        .lane_active           (lane_active),
        .near_end_capabilities (8'h07),
        .far_end_capabilities  (far_end_capabilities),
        .far_end_caps_valid    (far_end_caps_valid),
        .lane_start            (lane_start),
        .auto_start            (auto_start),
        .lane_reset            (lane_reset),
        .parallel_loopback_en  (parallel_loopback_en),
        .error_threshold       (error_threshold),
        .lane_state            (lane_state),
        .rxerr_count           (rxerr_count),
        .rx_polarity_status    (rx_polarity_status)
    );

    always #4 clk = ~clk; // 125 MHz (8 ns)

    always @(posedge clk) begin
        if (rst_n && dl_rx_valid && !dl_rx_err && (dl_rx_word == 32'hCAFE_A55A))
            got_data <= got_data + 1;
    end

    task check_step(input cond, input [8*72-1:0] msg);
        begin
            test_count = test_count + 1;
            if (cond) $display("  [OK]   %0s", msg);
            else begin
                error_count = error_count + 1;
                $display("  [ERRO] %0s", msg);
            end
        end
    endtask

    integer w;
    initial begin
        if (!$test$plusargs("nodump")) begin
            $dumpfile("wave_lane_top.vcd");
            $dumpvars(0, tb_spacefibre_lane_top);
        end

        $display("==================================================================");
        $display(" TESTBENCH LANE LAYER ECSS-E-ST-50-11C (125 MHz)");
        $display("==================================================================");

        #20; rst_n = 1'b1;
        repeat (4) @(posedge clk); #1;

        // 1. Reset inicial
        check_step(lane_state === 3'd0 && !lane_active && !line_driver_en,
                   "Reset inicial: LISM em Disabled e drivers desligados");

        // 2. Handshake completo LISM em loopback paralelo
        loss_of_signal = 1'b0;
        @(negedge clk); lane_start = 1'b1; @(negedge clk); lane_start = 1'b0;
        w = 0;
        while ((w < 500) && !lane_active) begin @(posedge clk); w = w + 1; end
        check_step(lane_active && (lane_state === 3'd4),
                   "Handshake INIT1->INIT2->INIT3 concluido em Active");
        check_step(far_end_caps_valid && (far_end_capabilities === 8'h07),
                   "Capacidades remotas recebidas via INIT3 (0x07)");

        // 3. Trafego de palavras de 32 bits + insercao periodica de SKIP transparente
        dl_tx_word    = 32'hCAFE_A55A;
        dl_tx_k_flags = 4'b0000;
        dl_tx_valid   = 1'b1;
        repeat (200) @(posedge clk);
        dl_tx_valid   = 1'b0;
        repeat (40) @(posedge clk);
        check_step(lane_active && (got_data >= 30) && (rxerr_count == 16'd0),
                   "Palavras de 32 bits entregues integras + SKIP/IDLE filtrados");

        // 4. Inversao de polaridade RX no par diferencial externo
        parallel_loopback_en = 1'b0;
        ext_inv_loop         = 1'b1;
        @(negedge clk); lane_reset = 1'b1; @(negedge clk); lane_reset = 1'b0;
        repeat (25) @(posedge clk); // aguarda ClearLine -> Disabled
        @(negedge clk); lane_start = 1'b1; @(negedge clk); lane_start = 1'b0;
        w = 0;
        while ((w < 800) && !lane_active) begin @(posedge clk); w = w + 1; end
        check_step(lane_active && invert_rx_polarity && rx_polarity_status,
                   "Par diferencial invertido detectado (iINIT1) e corrigido em Active");

        // 5. Perda de sinal e recuperacao automatica
        loss_of_signal = 1'b1;
        repeat (4) @(posedge clk); #1;
        check_step(!lane_active && ((lane_state === 3'd5) || (lane_state === 3'd1)),
                   "Perda de sinal acionou LossOfSignal/ClearLine");
        ext_inv_loop   = 1'b0;
        loss_of_signal = 1'b0;
        w = 0;
        while ((w < 800) && !lane_active) begin @(posedge clk); w = w + 1; end
        check_step(lane_active && !invert_rx_polarity,
                   "Recuperacao automatica apos retorno do sinal (polaridade normal)");

        $display("------------------------------------------------------------------");
        if (error_count == 0)
            $display(" RESULTADO FINAL: [PASS] TODOS OS %0d TESTES DA LANE PASSARAM", test_count);
        else
            $display(" RESULTADO FINAL: [FAIL] %0d ERRO(S) EM %0d TESTES", error_count, test_count);
        $display("==================================================================");
        $finish;
    end

endmodule
