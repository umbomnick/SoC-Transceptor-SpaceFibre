// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: tb/tb_spacefibre_system.v
// Padrao : ECSS-E-ST-50-11C
// Funcao : Testbench autoverificavel do sistema integrado (Network + Data Link
//          + Lane) com DOIS nos ponto-a-ponto (compativel com RTL e GLS SKY130):
//
// Cenarios:
//   C1  Inicializacao ECSS (1023 palavras + INIT3 caps + FCTs iniciais)
//   C2  Pacote unico A->B
//   C3  Trafego bidirecional aleatorio (300+300 pacotes, 5..80 B, Scrambler ON)
//   C4  Backpressure prolongado no host B (creditos FCT esgotam e restauram)
//   C5  Roteamento ECSS: loopback, sem rota, mal roteado e Path Addressing (0x01/0x00)
//   C6  Injecao de erros de bit no canal A->B (CRC-16/CRC-8/8B10B + RXERR 5.5.7l)
//   C7  Perda de sinal em B no meio do trafego e recuperacao automatica (2 us ClearLine)
//   C8  Trafego limpo apos recuperacao (100+100 pacotes)
//   C9  Inversao de polaridade diferencial RXp/RXn no canal A->B (iINIT1 -> InvertRxPolarity)
// ============================================================================
`timescale 1ns / 1ps

module tb_spacefibre_system;

`ifndef PARAM_MAX_FRAME_BYTES
    `define PARAM_MAX_FRAME_BYTES 16
`endif

    localparam CLK_HALF  = 5;      // 100 MHz (10.0 ns; ou 125 MHz com +clk125)
    localparam CH_DELAY  = 3;      // atraso do canal em simbolos
    localparam ADDR_A    = 8'h20;
    localparam ADDR_B    = 8'h21;
    localparam ADDR_MIS  = 8'h30;
    localparam ADDR_NONE = 8'h55;

    reg clk = 1'b0;
    real half_period = 5.0;
    initial if ($test$plusargs("clk125")) half_period = 4.0;
    always #(half_period) clk = ~clk;

    reg rst_n = 1'b0;

    integer errors = 0;
    integer seed   = 1;
    initial if (!$value$plusargs("seed=%d", seed)) seed = 1;
    integer cycle  = 0;
    always @(posedge clk) cycle <= cycle + 1;

    // ------------------------------------------------------------------------
    // Sinais dos nos A e B
    // ------------------------------------------------------------------------
    wire       a_drv, b_drv, a_rxen, b_rxen, a_cdr, b_cdr, a_inv, b_inv;
    wire [9:0] a_tx10, b_tx10;
    reg  [9:0] a_rx10, b_rx10;
    wire       a_los, b_los;
    reg        force_los_b = 1'b0;
    reg        swap_pol_ab = 1'b0;

    reg  [7:0] a_htx_d, b_htx_d;  reg a_htx_f, b_htx_f, a_htx_v, b_htx_v;
    wire       a_htx_r, b_htx_r;
    wire [7:0] a_hrx_d, b_hrx_d;  wire a_hrx_f, b_hrx_f, a_hrx_v, b_hrx_v;
    reg        a_hrx_r, b_hrx_r;

    reg        a_start = 0, b_start = 0;
    reg        a_lreset = 0, b_lreset = 0;
    reg        cfg_we_a = 0, cfg_we_b = 0;
    reg  [1:0] cfg_idx = 0; reg cfg_valid = 0; reg [7:0] cfg_addr = 0; reg cfg_port = 0;

    wire [2:0]  a_state, b_state;
    wire        a_act, b_act, a_up, b_up;
    wire [3:0]  a_cred, b_cred;
    wire [15:0] a_rxerr, b_rxerr;
    wire [7:0]  a_txf, a_rxf, a_crc, a_seq, a_ferr, a_tl, a_tloc, a_rl, a_drop, a_mis, a_cap;
    wire [7:0]  b_txf, b_rxf, b_crc, b_seq, b_ferr, b_tl, b_tloc, b_rl, b_drop, b_mis, b_cap;

`ifdef GLS
    spacefibre_node_top dut_a (
`else
    spacefibre_node_top #(.MAX_FRAME_BYTES(`PARAM_MAX_FRAME_BYTES)) dut_a (
`endif
        .clk(clk), .rst_n(rst_n),
        .line_driver_en(a_drv), .line_rx_en(a_rxen), .cdr_en(a_cdr), .invert_rx_polarity(a_inv),
        .loss_of_signal(a_los), .tx_10b_symbol(a_tx10), .rx_10b_symbol(a_rx10),
        .h_tx_data(a_htx_d), .h_tx_flag(a_htx_f), .h_tx_valid(a_htx_v), .h_tx_ready(a_htx_r),
        .h_rx_data(a_hrx_d), .h_rx_flag(a_hrx_f), .h_rx_valid(a_hrx_v), .h_rx_ready(a_hrx_r),
        .lane_start(a_start), .auto_start(1'b0), .lane_reset(a_lreset), .parallel_loopback_en(1'b0),
        .error_threshold(8'd8), .node_addr(ADDR_A),
        .cfg_we(cfg_we_a), .cfg_idx(cfg_idx), .cfg_valid(cfg_valid), .cfg_addr(cfg_addr), .cfg_port(cfg_port),
        .lane_state(a_state), .lane_active(a_act), .rxerr_count(a_rxerr), .link_up(a_up), .tx_credit(a_cred),
        .far_end_capabilities(a_cap),
        .cnt_tx_frames(a_txf), .cnt_rx_frames(a_rxf), .cnt_crc_err(a_crc), .cnt_seq_err(a_seq),
        .cnt_frame_err(a_ferr), .cnt_tx_link(a_tl), .cnt_tx_local(a_tloc), .cnt_rx_link(a_rl),
        .cnt_drop(a_drop), .cnt_misroute(a_mis)
    );

`ifdef GLS
    spacefibre_node_top dut_b (
`else
    spacefibre_node_top #(.MAX_FRAME_BYTES(`PARAM_MAX_FRAME_BYTES)) dut_b (
`endif
        .clk(clk), .rst_n(rst_n),
        .line_driver_en(b_drv), .line_rx_en(b_rxen), .cdr_en(b_cdr), .invert_rx_polarity(b_inv),
        .loss_of_signal(b_los), .tx_10b_symbol(b_tx10), .rx_10b_symbol(b_rx10),
        .h_tx_data(b_htx_d), .h_tx_flag(b_htx_f), .h_tx_valid(b_htx_v), .h_tx_ready(b_htx_r),
        .h_rx_data(b_hrx_d), .h_rx_flag(b_hrx_f), .h_rx_valid(b_hrx_v), .h_rx_ready(b_hrx_r),
        .lane_start(b_start), .auto_start(1'b0), .lane_reset(b_lreset), .parallel_loopback_en(1'b0),
        .error_threshold(8'd8), .node_addr(ADDR_B),
        .cfg_we(cfg_we_b), .cfg_idx(cfg_idx), .cfg_valid(cfg_valid), .cfg_addr(cfg_addr), .cfg_port(cfg_port),
        .lane_state(b_state), .lane_active(b_act), .rxerr_count(b_rxerr), .link_up(b_up), .tx_credit(b_cred),
        .far_end_capabilities(b_cap),
        .cnt_tx_frames(b_txf), .cnt_rx_frames(b_rxf), .cnt_crc_err(b_crc), .cnt_seq_err(b_seq),
        .cnt_frame_err(b_ferr), .cnt_tx_link(b_tl), .cnt_tx_local(b_tloc), .cnt_rx_link(b_rl),
        .cnt_drop(b_drop), .cnt_misroute(b_mis)
    );

    // ------------------------------------------------------------------------
    // Canal ponto-a-ponto com atraso CH_DELAY, injecao de erro e troca RXp/RXn
    // ------------------------------------------------------------------------
    reg [9:0] ab_pipe [0:CH_DELAY-1];
    reg [9:0] ba_pipe [0:CH_DELAY-1];
    reg [9:0] flip_ab = 10'd0;
    integer   k;
    wire [9:0] a_wire_sym = swap_pol_ab ? ~a_tx10 : a_tx10;

    always @(posedge clk) begin
        ab_pipe[0] <= (a_drv ? a_wire_sym : 10'h000) ^ flip_ab;
        ba_pipe[0] <= (b_drv && !force_los_b) ? b_tx10 : 10'h000;
        for (k = 1; k < CH_DELAY; k = k + 1) begin
            ab_pipe[k] <= ab_pipe[k-1];
            ba_pipe[k] <= ba_pipe[k-1];
        end
    end
    always @(*) begin
        b_rx10 = force_los_b ? 10'h000 : ab_pipe[CH_DELAY-1];
        a_rx10 = ba_pipe[CH_DELAY-1];
    end
    assign b_los = !a_drv || force_los_b;
    assign a_los = !b_drv || force_los_b;

    // ------------------------------------------------------------------------
    // Geradores de pacotes deterministas + suporte a prefixo de Path Addressing
    // ------------------------------------------------------------------------
    function [7:0] pbyte(input [7:0] tag, input [15:0] seq, input [7:0] i);
        reg [15:0] x;
        begin
            x = {tag, i} ^ (seq * 16'd40503) ^ ({8'd0, i} * 16'd257);
            pbyte = x[15:8] ^ x[7:0];
        end
    endfunction

    localparam QN = 1024;
    reg [7:0]  qa_dest [0:QN-1]; reg [7:0] qa_len [0:QN-1]; reg [7:0] qa_tag [0:QN-1]; reg [15:0] qa_seq [0:QN-1];
    reg        qa_path [0:QN-1]; reg [7:0] qa_pbyte [0:QN-1];
    integer    qa_head = 0, qa_tail = 0;

    reg [7:0]  qb_dest [0:QN-1]; reg [7:0] qb_len [0:QN-1]; reg [7:0] qb_tag [0:QN-1]; reg [15:0] qb_seq [0:QN-1];
    integer    qb_head = 0, qb_tail = 0;

    reg [15:0] tx_seq_of [0:255];
    integer    sent_of   [0:255];
    integer    t;
    initial for (t = 0; t < 256; t = t + 1) begin tx_seq_of[t] = 0; sent_of[t] = 0; end

    task enqueue_a(input [7:0] dest, input [7:0] tag, input [7:0] len);
        begin
            qa_dest[qa_tail % QN]  = dest;
            qa_tag[qa_tail % QN]   = tag;
            qa_len[qa_tail % QN]   = len;
            qa_path[qa_tail % QN]  = 1'b0;
            qa_pbyte[qa_tail % QN] = 8'h00;
            qa_seq[qa_tail % QN]   = tx_seq_of[tag];
            tx_seq_of[tag] = tx_seq_of[tag] + 1;
            sent_of[tag]   = sent_of[tag] + 1;
            qa_tail = qa_tail + 1;
        end
    endtask

    // Envia com 1 byte de Path Addressing na frente (que sera removido em A!)
    task enqueue_a_path(input [7:0] path_b, input [7:0] dest, input [7:0] tag, input [7:0] len);
        begin
            qa_dest[qa_tail % QN]  = dest;
            qa_tag[qa_tail % QN]   = tag;
            qa_len[qa_tail % QN]   = len;
            qa_path[qa_tail % QN]  = 1'b1;
            qa_pbyte[qa_tail % QN] = path_b;
            qa_seq[qa_tail % QN]   = tx_seq_of[tag];
            tx_seq_of[tag] = tx_seq_of[tag] + 1;
            sent_of[tag]   = sent_of[tag] + 1;
            qa_tail = qa_tail + 1;
        end
    endtask

    task enqueue_b(input [7:0] dest, input [7:0] tag, input [7:0] len);
        begin
            qb_dest[qb_tail % QN] = dest;
            qb_tag[qb_tail % QN]  = tag;
            qb_len[qb_tail % QN]  = len;
            qb_seq[qb_tail % QN]  = tx_seq_of[tag];
            tx_seq_of[tag] = tx_seq_of[tag] + 1;
            sent_of[tag]   = sent_of[tag] + 1;
            qb_tail = qb_tail + 1;
        end
    endtask

    integer gap_pct   = 20;
    integer rdy_a_pct = 100, rdy_b_pct = 100;

    integer ia = 0;
    integer eff_ia;
    integer tot_len_a;
    always @(posedge clk) begin
        if (!rst_n) begin
            a_htx_v <= 1'b0; ia = 0;
        end else begin
            if (a_htx_v && a_htx_r) begin
                if (a_htx_f) begin qa_head = qa_head + 1; ia = 0; end
                else ia = ia + 1;
            end
            if (qa_head != qa_tail && ({$random(seed)} % 100) >= gap_pct) begin
                a_htx_v   <= 1'b1;
                tot_len_a  = qa_len[qa_head % QN] + (qa_path[qa_head % QN] ? 1 : 0);
                if (ia == tot_len_a) begin
                    a_htx_f <= 1'b1;
                    a_htx_d <= 8'h00;
                end else if (qa_path[qa_head % QN] && (ia == 0)) begin
                    a_htx_f <= 1'b0;
                    a_htx_d <= qa_pbyte[qa_head % QN];
                end else begin
                    a_htx_f <= 1'b0;
                    eff_ia   = qa_path[qa_head % QN] ? (ia - 1) : ia;
                    case (eff_ia)
                        0: a_htx_d <= qa_dest[qa_head % QN];
                        1: a_htx_d <= qa_tag[qa_head % QN];
                        2: a_htx_d <= qa_seq[qa_head % QN][15:8];
                        3: a_htx_d <= qa_seq[qa_head % QN][7:0];
                        4: a_htx_d <= qa_len[qa_head % QN];
                        default: a_htx_d <= pbyte(qa_tag[qa_head % QN], qa_seq[qa_head % QN], eff_ia[7:0]);
                    endcase
                end
            end else if (!(a_htx_v && !a_htx_r)) begin
                a_htx_v <= 1'b0;
            end
        end
    end

    integer ib = 0;
    always @(posedge clk) begin
        if (!rst_n) begin
            b_htx_v <= 1'b0; ib = 0;
        end else begin
            if (b_htx_v && b_htx_r) begin
                if (b_htx_f) begin qb_head = qb_head + 1; ib = 0; end
                else ib = ib + 1;
            end
            if (qb_head != qb_tail && ({$random(seed)} % 100) >= gap_pct) begin
                b_htx_v <= 1'b1;
                if (ib == qb_len[qb_head % QN]) begin
                    b_htx_f <= 1'b1;
                    b_htx_d <= 8'h00;
                end else begin
                    b_htx_f <= 1'b0;
                    case (ib)
                        0: b_htx_d <= qb_dest[qb_head % QN];
                        1: b_htx_d <= qb_tag[qb_head % QN];
                        2: b_htx_d <= qb_seq[qb_head % QN][15:8];
                        3: b_htx_d <= qb_seq[qb_head % QN][7:0];
                        4: b_htx_d <= qb_len[qb_head % QN];
                        default: b_htx_d <= pbyte(qb_tag[qb_head % QN], qb_seq[qb_head % QN], ib[7:0]);
                    endcase
                end
            end else if (!(b_htx_v && !b_htx_r)) begin
                b_htx_v <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        a_hrx_r <= ({$random(seed)} % 100) < rdy_a_pct;
        b_hrx_r <= ({$random(seed)} % 100) < rdy_b_pct;
    end

    // ------------------------------------------------------------------------
    // Scoreboards nos hosts A e B
    // ------------------------------------------------------------------------
    reg        allow_loss = 1'b0;
    reg [15:0] rx_exp_of  [0:255];
    integer    got_of     [0:255];
    integer    lost_of    [0:255];
    integer    trunc_a = 0, trunc_b = 0, bad = 0;
    initial for (t = 0; t < 256; t = t + 1) begin rx_exp_of[t] = 0; got_of[t] = 0; lost_of[t] = 0; end

    reg [7:0] rbuf_a [0:255]; integer ra = 0;
    reg [7:0] rbuf_b [0:255]; integer rb = 0;

    task automatic check_packet(input [7:0] who, input [7:0] my_addr, input integer n, input is_eep);
        reg [7:0] tag; reg [15:0] seq; integer i, ok;
        begin
            if (who == "A") begin tag = rbuf_a[1]; seq = {rbuf_a[2], rbuf_a[3]}; end
            else            begin tag = rbuf_b[1]; seq = {rbuf_b[2], rbuf_b[3]}; end
            if (is_eep) begin
                if (who == "A") trunc_a = trunc_a + 1; else trunc_b = trunc_b + 1;
                if (!allow_loss) begin
                    errors = errors + 1;
                    $display("[ERRO] %0s: EEP inesperado (tag=%h seq=%0d, %0d bytes) t=%0t", who, tag, seq, n, $time);
                end
            end else begin
                ok = (n >= 5);
                for (i = 0; ok && i < n; i = i + 1) begin
                    if (who == "A") begin
                        if (i == 0) ok = (rbuf_a[0] == my_addr);
                        else if (i == 4) ok = (rbuf_a[4] == n);
                        else if (i >= 5) ok = (rbuf_a[i] == pbyte(tag, seq, i[7:0]));
                    end else begin
                        if (i == 0) ok = (rbuf_b[0] == my_addr);
                        else if (i == 4) ok = (rbuf_b[4] == n);
                        else if (i >= 5) ok = (rbuf_b[i] == pbyte(tag, seq, i[7:0]));
                    end
                end
                if (!ok) begin
                    bad = bad + 1; errors = errors + 1;
                    $display("[ERRO] %0s: pacote CORROMPIDO entregue com EOP (tag=%h seq=%0d n=%0d) t=%0t", who, tag, seq, n, $time);
                end else if (seq < rx_exp_of[tag]) begin
                    errors = errors + 1;
                    $display("[ERRO] %0s: fora de ordem/duplicado tag=%h seq=%0d esperado=%0d", who, tag, seq, rx_exp_of[tag]);
                end else begin
                    if (seq > rx_exp_of[tag]) begin
                        lost_of[tag] = lost_of[tag] + (seq - rx_exp_of[tag]);
                        if (!allow_loss) begin
                            errors = errors + 1;
                            $display("[ERRO] %0s: %0d pacote(s) perdido(s) tag=%h antes de seq=%0d", who, seq - rx_exp_of[tag], tag, seq);
                        end
                    end
                    rx_exp_of[tag] = seq + 1;
                    got_of[tag]    = got_of[tag] + 1;
                end
            end
        end
    endtask

    always @(posedge clk) if (rst_n && a_hrx_v && a_hrx_r) begin
        if (a_hrx_f) begin check_packet("A", ADDR_A, ra, a_hrx_d[0]); ra = 0; end
        else begin if (ra < 256) rbuf_a[ra] = a_hrx_d; ra = ra + 1; end
    end
    always @(posedge clk) if (rst_n && b_hrx_v && b_hrx_r) begin
        if (b_hrx_f) begin check_packet("B", ADDR_B, rb, b_hrx_d[0]); rb = 0; end
        else begin if (rb < 256) rbuf_b[rb] = b_hrx_d; rb = rb + 1; end
    end

    task check(input cond, input [8*76-1:0] msg);
        begin
            if (cond) $display("  [OK]   %0s", msg);
            else begin errors = errors + 1; $display("  [ERRO] %0s", msg); end
        end
    endtask

    task drain(input integer max_cycles);
        integer c, quiet;
        begin
            c = 0; quiet = 0;
            while (c < max_cycles && quiet < 300) begin
                @(posedge clk);
                c = c + 1;
                if (qa_head == qa_tail && qb_head == qb_tail && !a_htx_v && !b_htx_v &&
                    !a_hrx_v && !b_hrx_v) quiet = quiet + 1;
                else quiet = 0;
            end
            if (quiet < 300) begin
                errors = errors + 1;
                $display("  [ERRO] timeout drenando trafego (qa=%0d/%0d qb=%0d/%0d a_cred=%0d b_cred=%0d)",
                         qa_head, qa_tail, qb_head, qb_tail, a_cred, b_cred);
            end
        end
    endtask

    task wait_link(input integer max_cycles, output integer took);
        integer c;
        begin
            c = 0;
            while (c < max_cycles && !(a_up && b_up && a_cred == 4 && b_cred == 4)) begin
                @(posedge clk); c = c + 1;
            end
            took = c;
        end
    endtask

    task cfg_route(input which, input [1:0] idx, input v, input [7:0] addr, input port);
        begin
            @(negedge clk);
            cfg_idx = idx; cfg_valid = v; cfg_addr = addr; cfg_port = port;
            if (which) cfg_we_b = 1'b1; else cfg_we_a = 1'b1;
            @(negedge clk);
            cfg_we_a = 1'b0; cfg_we_b = 1'b0;
        end
    endtask

    integer took, n, i, tot_sent, tot_got, tot_lost, d0, d1, d2, d3;
    reg [7:0] crc0, fe0; reg [15:0] rxe0;

    initial begin
        if (!$test$plusargs("nodump")) begin
            $dumpfile("wave_system.vcd");
            $dumpvars(1, tb_spacefibre_system);
        end

        a_htx_d = 0; a_htx_f = 0; b_htx_d = 0; b_htx_f = 0;
        a_hrx_r = 1; b_hrx_r = 1;
        $display("==================================================================");
        $display(" TESTBENCH DE SISTEMA ECSS-E-ST-50-11C (2 nos, MAX_FRAME=%0d B)", `PARAM_MAX_FRAME_BYTES);
        $display("==================================================================");
        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        repeat (5) @(posedge clk);

        cfg_route(0, 2'd0, 1, ADDR_B,   1);   // A: 0x21 -> LINK
        cfg_route(0, 2'd1, 1, ADDR_MIS, 1);   // A: 0x30 -> LINK (B descarta)
        cfg_route(1, 2'd0, 1, ADDR_A,   1);   // B: 0x20 -> LINK

        // ---------------- C1 ----------------
        $display("\n--- C1: inicializacao ECSS do link (1023 palavras + INIT3 + FCTs) ---");
        @(negedge clk); a_start = 1; b_start = 1; @(negedge clk); a_start = 0; b_start = 0;
        wait_link(10000, took);
        check(a_act && b_act, "Lanes A e B em Active apos handshake ECSS de 1023 palavras");
        check(a_up && b_up,   "Data Link link_up nos dois nos (SDF/EDF/SIF/FCT operacionais)");
        check(a_cap[2] && b_cap[2], "Capacidade DataScrambled negociada via INIT3 nos dois lados");
        check(a_cred == 4 && b_cred == 4, "Creditos iniciais = RX_FRAMES (4) via FCT normativo");
        $display("         link pronto em %0d ciclos", took);

        // ---------------- C2 ----------------
        $display("\n--- C2: pacote unico A->B ---");
        enqueue_a(ADDR_B, 8'hA1, 8'd10);
        drain(5000);
        check(got_of[8'hA1] == 1, "B recebeu 1 pacote integro de A (EOP K29.7 + Fill K27.7 + CRC-16)");
        check(b_rl == 1 && a_tl == 1, "Contadores de pacotes (A tx_link=1, B rx_link=1)");

        // ---------------- C3 ----------------
        $display("\n--- C3: trafego bidirecional aleatorio (300 pacotes por sentido) ---");
        gap_pct = 15; rdy_a_pct = 85; rdy_b_pct = 85;
        for (n = 0; n < 300; n = n + 1) begin
            enqueue_a(ADDR_B, 8'hA1, 5 + {$random(seed)} % 76);
            enqueue_b(ADDR_A, 8'hB1, 5 + {$random(seed)} % 76);
        end
        drain(300000);
        check(got_of[8'hA1] == sent_of[8'hA1], "A->B: todos os pacotes entregues, integros e em ordem");
        check(got_of[8'hB1] == sent_of[8'hB1], "B->A: todos os pacotes entregues, integros e em ordem");
        check(a_crc == 0 && b_crc == 0 && a_ferr == 0 && b_ferr == 0, "Sem erros de CRC-16/CRC-8/quadro");
        check(a_seq == 0 && b_seq == 0, "Sem erros de sequencia (SEQ_NUM modulo-128)");
        check(a_rxerr == 0 && b_rxerr == 0, "RXERR (8B/10B) = 0 nos dois nos");
        $display("         quadros: A tx=%0d rx=%0d | B tx=%0d rx=%0d (mod 256)", a_txf, a_rxf, b_txf, b_rxf);

        // ---------------- C4 ----------------
        $display("\n--- C4: backpressure prolongado no host B ---");
        rdy_b_pct = 0; gap_pct = 0;
        for (n = 0; n < 20; n = n + 1) enqueue_a(ADDR_B, 8'hA1, 8'd64);
        repeat (5000) @(posedge clk);
        check((`PARAM_MAX_FRAME_BYTES > 64) ? (qa_head == qa_tail || a_cred < 4) : (a_cred == 0),
              "Creditos FCT de A retidos/esgotados enquanto B nao consome");
        if (`PARAM_MAX_FRAME_BYTES <= 64)
            check(qa_head != qa_tail, "Fonte de A retida por controle de fluxo FCT (sem descarte)");
        rdy_b_pct = 100;
        drain(100000);
        check(got_of[8'hA1] == sent_of[8'hA1], "Todos os pacotes entregues apos liberar o host B");
        repeat (200) @(posedge clk);
        check(a_cred == 4, "Creditos FCT de A restaurados (4)");

        // ---------------- C5 ----------------
        $display("\n--- C5: roteamento Logical + Path Addressing (ECSS 5.8.3) ---");
        d0 = a_tloc; d1 = a_drop; d2 = b_mis;
        enqueue_a(ADDR_A,    8'hAA, 8'd12);         // loopback local logico
        enqueue_a_path(8'h00, ADDR_A, 8'hAA, 8'd14);// Path 0x00 (Local) com header deletion
        enqueue_a(ADDR_NONE, 8'hA5, 8'd12);         // sem rota -> descarte em A
        enqueue_a(ADDR_MIS,  8'hA3, 8'd12);         // vai ao link, B descarta
        enqueue_a_path(8'h01, ADDR_B, 8'hA1, 8'd16);// Path 0x01 (Link) com header deletion -> B!
        enqueue_a(ADDR_A,    8'hAA, 8'd30);         // loopback local
        for (n = 0; n < 5; n = n + 1) enqueue_b(ADDR_A, 8'hB1, 8'd40);
        drain(40000);
        check(got_of[8'hAA] == 3, "Loopback local (Logico + Path 0x00): 3 pacotes entregues a A");
        check(a_tloc - d0 == 3, "cnt_tx_local de A = +3");
        check(a_drop - d1 == 1 && got_of[8'hA5] == 0, "Endereco sem rota descartado em A (cnt_drop +1)");
        check(b_mis - d2 == 1 && got_of[8'hA3] == 0, "Endereco mal roteado descartado em B (cnt_misroute +1)");
        check(got_of[8'hA1] == sent_of[8'hA1] && got_of[8'hB1] == sent_of[8'hB1],
              "Path Addressing 0x01 + fluxos normais entregues integros");

        // ---------------- C6 ----------------
        $display("\n--- C6: injecao de erros de bit no canal A->B ---");
        allow_loss = 1'b1;
        crc0 = b_crc; fe0 = b_ferr; rxe0 = b_rxerr;
        rdy_b_pct = 100; gap_pct = 5;
        for (n = 0; n < 60; n = n + 1) enqueue_a(ADDR_B, 8'hA1, 20 + {$random(seed)} % 60);
        for (i = 0; i < 3; i = i + 1) begin
            repeat (300 + {$random(seed)} % 200) @(posedge clk);
            @(negedge clk); flip_ab = 10'b0000100000 >> i; @(negedge clk); flip_ab = 10'd0;
        end
        drain(120000);
        check(bad == 0, "Nenhum pacote corrompido entregue com EOP");
        check((b_crc != crc0) || (b_ferr != fe0) || (b_rxerr != rxe0),
              "Erros detectados pela Lane/Data Link (8B10B RXERR / CRC / quadro)");
        check(b_act && a_act && a_up && b_up, "Link permanece ativo (erros abaixo do limiar)");
        $display("         B: crc_err=%0d frame_err=%0d rxerr=%0d | perdidos A1=%0d | truncados(EEP) B=%0d",
                 b_crc - crc0, b_ferr - fe0, b_rxerr, lost_of[8'hA1], trunc_b);

        // ---------------- C7 ----------------
        $display("\n--- C7: perda de sinal em B e recuperacao automatica ECSS ---");
        gap_pct = 10;
        for (n = 0; n < 80; n = n + 1) begin
            enqueue_a(ADDR_B, 8'hA1, 5 + {$random(seed)} % 76);
            enqueue_b(ADDR_A, 8'hB1, 5 + {$random(seed)} % 76);
        end
        repeat (1500) @(posedge clk);
        force_los_b = 1'b1;
        repeat (60) @(posedge clk);
        check(!b_act, "B saiu de Active com a perda de sinal");
        force_los_b = 1'b0;
        wait_link(12000, took);
        check(a_act && b_act && a_up && b_up, "Link recuperado automaticamente (ClearLine 2 us + 1023 palavras)");
        $display("         recuperacao completa em %0d ciclos apos o retorno do sinal", took);
        drain(250000);
        check(bad == 0, "Nenhum pacote corrompido entregue durante a falha");

        // ---------------- C8 ----------------
        $display("\n--- C8: trafego limpo apos recuperacao ---");
        allow_loss = 1'b0;
        d0 = got_of[8'hA1]; d1 = got_of[8'hB1];
        gap_pct = 15; rdy_a_pct = 90; rdy_b_pct = 90;
        for (n = 0; n < 100; n = n + 1) begin
            enqueue_a(ADDR_B, 8'hA1, 5 + {$random(seed)} % 76);
            enqueue_b(ADDR_A, 8'hB1, 5 + {$random(seed)} % 76);
        end
        drain(150000);
        check(got_of[8'hA1] - d0 == 100 && got_of[8'hB1] - d1 == 100,
              "100+100 pacotes entregues integros apos recuperacao");

        // ---------------- C9 ----------------
        $display("\n--- C9: inversao de polaridade diferencial RXp/RXn no canal A->B ---");
        swap_pol_ab = 1'b1;
        @(negedge clk); a_lreset = 1'b1; b_lreset = 1'b1;
        @(negedge clk); a_lreset = 1'b0; b_lreset = 1'b0;
        repeat (250) @(posedge clk); // aguarda ClearLine (200 ciclos) -> Disabled
        @(negedge clk); a_start = 1'b1; b_start = 1'b1;
        @(negedge clk); a_start = 1'b0; b_start = 1'b0;
        wait_link(12000, took);
        check(a_act && b_act && a_up && b_up && b_inv && !a_inv,
              "No B detectou iINIT1, ativou InvertRxPolarity e subiu o link");
        d0 = got_of[8'hA1]; d1 = got_of[8'hB1];
        for (n = 0; n < 30; n = n + 1) begin
            enqueue_a(ADDR_B, 8'hA1, 8 + {$random(seed)} % 48);
            enqueue_b(ADDR_A, 8'hB1, 8 + {$random(seed)} % 48);
        end
        drain(80000);
        check(got_of[8'hA1] - d0 == 30 && got_of[8'hB1] - d1 == 30,
              "30+30 pacotes entregues sem erro sobre par diferencial invertido");

        tot_sent = sent_of[8'hA1] + sent_of[8'hB1] + sent_of[8'hAA];
        tot_got  = got_of[8'hA1]  + got_of[8'hB1]  + got_of[8'hAA];
        tot_lost = sent_of[8'hA1] - got_of[8'hA1] + sent_of[8'hB1] - got_of[8'hB1];
        $display("         total: enviados=%0d entregues=%0d nao entregues=%0d (so em C6/C7) truncados A=%0d B=%0d",
                 tot_sent, tot_got, tot_lost, trunc_a, trunc_b);

        $display("\n==================================================================");
        if (errors == 0) $display(" RESULTADO FINAL: [PASS] todos os cenarios ECSS passaram");
        else             $display(" RESULTADO FINAL: [FAIL] %0d erro(s)", errors);
        $display("==================================================================");
        $finish;
    end

    initial begin
        #60_000_000;
        $display("[ERRO] watchdog global");
        $finish;
    end

endmodule
