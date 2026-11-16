// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: tb/tb_ecss_vectors.v
// Padrao : ECSS-E-ST-50-11C (15 May 2019)
// Funcao : Verificacao unitaria contra 100% dos vetores aureos da norma ECSS:
//          1. Codec 8B/10B exaustivo + rejeicao estrita de K nao usados (Tab 5-11)
//          2. Inversao de polaridade de INIT1 -> iINIT1 e INIT2 -> iINIT2 (Tab 5-3)
//          3. Scrambler de dados (Fig 5-42) e PRBS de Idle Frame (Fig 5-43)
//          4. CRC-16 ITU LSB-first refletido (Fig 5-44 Ex 1..3 e Fig 5-42)
//          5. CRC-8 LSB-first refletido (Fig 5-46: FCT e Broadcast EBF)
// ============================================================================
`timescale 1ns / 1ps

module tb_ecss_vectors;

    reg clk = 1'b0;
    always #5 clk = ~clk;
    reg rst_n = 1'b0;

    integer errs = 0;
    integer tests = 0;

    task check_cond(input cond, input [8*76-1:0] msg);
        begin
            tests = tests + 1;
            if (!cond) begin
                errs = errs + 1;
                $display("  [FALHA] %0s", msg);
            end else begin
                $display("  [OK]    %0s", msg);
            end
        end
    endtask

    // ------------------------------------------------------------------------
    // 1. Instancias 8B/10B + LLCW Processor
    // ------------------------------------------------------------------------
    reg  [7:0] enc_din;
    reg        enc_kin;
    wire [9:0] sym_10b;
    reg        inv_wire = 1'b0;
    wire [9:0] rx_10b   = inv_wire ? ~sym_10b : sym_10b;

    wire [7:0] dec_dout;
    wire       dec_kout, dec_cerr, dec_derr;

    encoder_8b10b u_enc (
        .clk    (clk),
        .rst_n  (rst_n),
        .rd_rst (1'b0),
        .kin    (enc_kin),
        .din    (enc_din),
        .dout   (sym_10b)
    );

    decoder_8b10b #(.SPACEFIBRE_STRICT_K(1)) u_dec (
        .clk      (clk),
        .rst_n    (rst_n),
        .din      (rx_10b),
        .hold     (1'b0),
        .rd_sync  (1'b0),
        .dout     (dec_dout),
        .kout     (dec_kout),
        .code_err (dec_cerr),
        .disp_err (dec_derr)
    );

    reg        llcw_tx_en = 1'b0;
    reg  [3:0] llcw_tx_cmd = 4'd0;
    wire [31:0] llcw_tx_w;
    wire [3:0]  llcw_tx_k;
    wire        llcw_tx_v;

    reg  [31:0] llcw_rx_w = 32'd0;
    reg  [3:0]  llcw_rx_k = 4'd0;
    reg         llcw_rx_v = 1'b0;
    wire        llcw_is_sp, llcw_rx_ok, llcw_caps_v, llcw_err;
    wire [3:0]  llcw_rx_type;
    wire [7:0]  llcw_caps;

    llcw_processor u_llcw (
        .clk                 (clk),
        .rst_n               (rst_n),
        .tx_send_cmd         (llcw_tx_en),
        .tx_cmd_type         (llcw_tx_cmd),
        .tx_capabilities_in  (8'h07),
        .tx_reason_in        (8'h01),
        .tx_llcw_word        (llcw_tx_w),
        .tx_llcw_k_flags     (llcw_tx_k),
        .tx_word_valid       (llcw_tx_v),
        .rx_word_in          (llcw_rx_w),
        .rx_k_in             (llcw_rx_k),
        .rx_word_valid       (llcw_rx_v),
        .rx_word_err         (1'b0),
        .rx_is_llcw_space    (llcw_is_sp),
        .rx_cmd_valid        (llcw_rx_ok),
        .rx_cmd_type         (llcw_rx_type),
        .rx_capabilities_out (llcw_caps),
        .rx_caps_valid       (llcw_caps_v),
        .rx_llcw_err         (llcw_err)
    );

    // ------------------------------------------------------------------------
    // 2. Instancias Scrambler, CRC-16 e CRC-8
    // ------------------------------------------------------------------------
    reg  [15:0] scr_lfsr_in;
    reg  [31:0] scr_din;
    reg  [3:0]  scr_kin;
    reg         scr_en;
    wire [31:0] scr_prbs, scr_dout;
    wire [15:0] scr_lfsr_out;

    sf_scrambler u_scr (
        .lfsr_in     (scr_lfsr_in),
        .data_in     (scr_din),
        .k_in        (scr_kin),
        .scramble_en (scr_en),
        .prbs_word   (scr_prbs),
        .data_out    (scr_dout),
        .lfsr_out    (scr_lfsr_out)
    );

    reg  [15:0] c16_lfsr_in;
    reg  [31:0] c16_word_in;
    wire [15:0] c16_lfsr_out;
    reg  [15:0] c16_edf_hdr;
    wire [15:0] c16_final;

    sf_crc16_word u_c16w (.lfsr_in(c16_lfsr_in), .word_in(c16_word_in), .lfsr_out(c16_lfsr_out));
    sf_crc16_edf  u_c16e (.lfsr_in(c16_lfsr_in), .edf_hdr_in(c16_edf_hdr), .crc_val_out(c16_final));

    reg  [7:0]  c8_lfsr_in;
    reg  [23:0] c8_din;
    wire [7:0]  c8_lfsr_out, c8_val;
    sf_crc8 u_c8 (.lfsr_in(c8_lfsr_in), .data_24b(c8_din), .lfsr_out(c8_lfsr_out), .crc_out(c8_val));

    // Auxiliar para codificar 1 palavra de 32 bits em 4 ciclos (opcionalmente invertida)
    // e capturar a palavra decodificada de 32 bits
    task automatic send_and_decode_word(
        input  [31:0] tx_w,
        input  [3:0]  tx_k,
        input         invert_line,
        output [31:0] rx_w,
        output [3:0]  rx_k,
        output        any_err
    );
        integer s;
        reg [7:0] db [0:3];
        reg       dk [0:3];
        begin
            inv_wire = invert_line;
            any_err  = 1'b0;
            for (s = 0; s < 6; s = s + 1) begin
                @(negedge clk);
                if (s < 4) begin
                    enc_din = tx_w[s*8 +: 8];
                    enc_kin = tx_k[s];
                end else begin
                    enc_din = 8'h00;
                    enc_kin = 1'b0;
                end
                if (s >= 2) begin
                    db[s-2] = dec_dout;
                    dk[s-2] = dec_kout;
                    if (dec_cerr || dec_derr) any_err = 1'b1;
                end
            end
            rx_w = {db[3], db[2], db[1], db[0]};
            rx_k = {dk[3], dk[2], dk[1], dk[0]};
            inv_wire = 1'b0;
        end
    endtask

    reg [8:0]  hist [0:3];
    reg [7:0]  sf_klist [0:7];
    reg [7:0]  bad_klist [0:3];
    integer    i, codec_errs, bad_k_ok;
    reg [31:0] w_rx, w_scr0, w_scr1, w_scr2;
    reg [3:0]  k_rx;
    reg        w_err;
    reg [15:0] lfsr_tmp;
    reg [7:0]  c8_tmp;

    // Passo auxiliar de 1 byte no CRC-8 para SBF/Data de Broadcast (4 bytes = 3 + 1)
    function [7:0] crc8_step_word(input [7:0] cin, input [31:0] w);
        integer bi, bit_i;
        reg [7:0] c;
        reg       f;
        begin
            c = cin;
            for (bi = 0; bi < 4; bi = bi + 1)
                for (bit_i = 0; bit_i < 8; bit_i = bit_i + 1) begin
                    f = c[7] ^ w[bi*8 + bit_i];
                    c = {c[6:2], c[1] ^ f, c[0] ^ f, f};
                end
            crc8_step_word = c;
        end
    endfunction

    initial begin
        // 8 K-codes validos em SpaceFibre (Tabela 5-11)
        sf_klist[0] = 8'h1C; // K28.0 (EDF)
        sf_klist[1] = 8'h5C; // K28.2 (EBF)
        sf_klist[2] = 8'h7C; // K28.3 (FCT)
        sf_klist[3] = 8'hBC; // K28.5 (Init Comma)
        sf_klist[4] = 8'hFC; // K28.7 (Comma)
        sf_klist[5] = 8'hFB; // K27.7 (Fill)
        sf_klist[6] = 8'hFD; // K29.7 (EOP)
        sf_klist[7] = 8'hFE; // K30.7 (EEP)

        // 4 K-codes proibidos em SpaceFibre (Tabela 5-11: "Not used")
        bad_klist[0] = 8'h3C; // K28.1
        bad_klist[1] = 8'h9C; // K28.4
        bad_klist[2] = 8'hDC; // K28.6
        bad_klist[3] = 8'hF7; // K23.7

        enc_din = 8'd0; enc_kin = 1'b0;
        scr_lfsr_in = 16'hFFFF; scr_din = 32'd0; scr_kin = 4'd0; scr_en = 1'b0;
        c16_lfsr_in = 16'hFFFF; c16_word_in = 32'd0; c16_edf_hdr = 16'd0;
        c8_lfsr_in  = 8'h00;    c8_din = 24'd0;

        $display("==================================================================");
        $display(" VERIFICACAO DE VETORES AUREOS ECSS-E-ST-50-11C (15 May 2019)");
        $display("==================================================================");

        repeat (3) @(posedge clk);
        rst_n = 1'b1;

        // --------------------------------------------------------------------
        // TESTE 1: 8B/10B exaustivo + K-codes proibidos (Tabela 5-11)
        // --------------------------------------------------------------------
        codec_errs = 0;
        for (i = 0; i < 4000; i = i + 1) begin
            @(negedge clk);
            if (i < 512) begin
                enc_din = i[7:0]; enc_kin = 1'b0;
            end else if (i < 528) begin
                enc_din = sf_klist[(i - 512) % 8]; enc_kin = 1'b1;
            end else begin
                if (({$random} % 8) == 0) begin enc_din = sf_klist[{$random} % 8]; enc_kin = 1'b1; end
                else                      begin enc_din = $random;                 enc_kin = 1'b0; end
            end
            hist[i % 4] = {enc_kin, enc_din};
            if (i >= 3) begin
                if (({dec_kout, dec_dout} !== hist[(i - 2) % 4]) || dec_cerr || dec_derr)
                    codec_errs = codec_errs + 1;
            end
        end
        check_cond(codec_errs == 0, "8B/10B: 256 D-codes + 8 K-codes SpaceFibre (3997 simbolos, 0 erros)");

        bad_k_ok = 1;
        for (i = 0; i < 4; i = i + 1) begin
            @(negedge clk); enc_din = bad_klist[i]; enc_kin = 1'b1;
            @(negedge clk); enc_din = 8'h00;        enc_kin = 1'b0;
            @(negedge clk);
            if (!(dec_cerr && (dec_kout == 1'b1) && (dec_dout == 8'h00)))
                bad_k_ok = 0;
        end
        check_cond(bad_k_ok == 1, "8B/10B Tabela 5-11: K28.1, K28.4, K28.6 e K23.7 rejeitados como K0.0");

        // --------------------------------------------------------------------
        // TESTE 2: LLCWs normativos + Inversao de Polaridade (~INIT1 -> iINIT1)
        // --------------------------------------------------------------------
        // Alinha RD apos teste de erro anterior
        @(negedge clk); enc_din = 8'hBC; enc_kin = 1'b1;
        @(negedge clk); enc_din = 8'hCE; enc_kin = 1'b0;

        llcw_tx_en = 1'b1; llcw_tx_cmd = 4'd1; #1; // INIT1 = {46, 46, CE, BC}
        check_cond(llcw_tx_w == 32'h4646_CEBC && llcw_tx_k == 4'b0001,
                   "Tabela 5-3: INIT1 = {D6.2(46), D6.2(46), D14.6(CE), K28.5(BC)}");

        send_and_decode_word(llcw_tx_w, llcw_tx_k, 1'b1, w_rx, k_rx, w_err);
        llcw_rx_w = w_rx; llcw_rx_k = k_rx; llcw_rx_v = 1'b1; #1;
        check_cond(!w_err && (w_rx == 32'hB9B9_31BC) && llcw_rx_ok && (llcw_rx_type == 4'd2),
                   "Tabela 5-3: ~encode(INIT1) decodifica sem erro em iINIT1 {B9,B9,31,BC}");

        llcw_tx_cmd = 4'd3; #1; // INIT2 = {A6, A6, CE, BC}
        send_and_decode_word(llcw_tx_w, llcw_tx_k, 1'b1, w_rx, k_rx, w_err);
        llcw_rx_w = w_rx; llcw_rx_k = k_rx; llcw_rx_v = 1'b1; #1;
        check_cond(!w_err && (w_rx == 32'h5959_31BC) && llcw_rx_ok && (llcw_rx_type == 4'd4),
                   "Tabela 5-3: ~encode(INIT2) decodifica sem erro em iINIT2 {59,59,31,BC}");
        llcw_rx_v = 1'b0; llcw_tx_en = 1'b0;

        // --------------------------------------------------------------------
        // TESTE 3: Scrambler (Figura 5-42) e PRBS de Idle Frame (Figura 5-43)
        // --------------------------------------------------------------------
        scr_lfsr_in = 16'hFFFF; scr_din = 32'h0302_0100; scr_kin = 4'b0000; scr_en = 1'b1; #1;
        w_scr0      = scr_dout;
        check_cond(scr_prbs == 32'h14C0_17FF, "Figura 5-43: PRBS palavra 0 = {14, C0, 17, FF}");
        check_cond(w_scr0   == 32'h17C2_16FF, "Figura 5-42: Scrambler palavra 0 = {17, C2, 16, FF}");

        scr_lfsr_in = scr_lfsr_out; scr_din = 32'h0706_0504; scr_kin = 4'b0000; #1;
        w_scr1      = scr_dout;
        check_cond(scr_prbs == 32'h8202_E7B2, "Figura 5-43: PRBS palavra 1 = {82, 02, E7, B2}");
        check_cond(w_scr1   == 32'h8504_E2B6, "Figura 5-42: Scrambler palavra 1 = {85, 04, E2, B6}");

        scr_lfsr_in = scr_lfsr_out; scr_din = 32'hFBFB_FD08; scr_kin = 4'b1110; #1;
        w_scr2      = scr_dout;
        check_cond(scr_prbs == 32'hA628_6E72, "Figura 5-43: PRBS palavra 2 = {A6, 28, 6E, 72}");
        check_cond(w_scr2   == 32'hFBFB_FD7A, "Figura 5-42: Scrambler palavra 2 = {Fill, Fill, EOP, 7A}");

        // --------------------------------------------------------------------
        // TESTE 4: CRC-16 Vetores Aureos (Figura 5-44 Ex 1..3 e Figura 5-42)
        // --------------------------------------------------------------------
        // Ex 1: SDF(FC,50,02,00), 00_00_00_00, FB_FB_FB_FD, EDF(1C, 41) -> CRC=0x978A
        c16_lfsr_in = 16'hFFFF;     c16_word_in = 32'h0002_50FC; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_word_in = 32'h0000_0000; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_word_in = 32'hFBFB_FBFD; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_edf_hdr = 16'h411C;      #1;
        check_cond(c16_final == 16'h978A, "Figura 5-44 Ex 1: CRC-16 = 0x978A (LS=0x8A, MS=0x97)");

        // Ex 2: SDF(FC,50,01,00), FB_FB_FD_00, EDF(1C, 7D) -> CRC=0x353D
        c16_lfsr_in = 16'hFFFF;     c16_word_in = 32'h0001_50FC; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_word_in = 32'hFBFB_FD00; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_edf_hdr = 16'h7D1C;      #1;
        check_cond(c16_final == 16'h353D, "Figura 5-44 Ex 2: CRC-16 = 0x353D (LS=0x3D, MS=0x35)");

        // Ex 3: SDF(FC,50,01,00), FD_02_01_00, EDF(1C, 7E) -> CRC=0xB7A1
        c16_lfsr_in = 16'hFFFF;     c16_word_in = 32'h0001_50FC; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_word_in = 32'hFD02_0100; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_edf_hdr = 16'h7E1C;      #1;
        check_cond(c16_final == 16'hB7A1, "Figura 5-44 Ex 3: CRC-16 = 0xB7A1 (LS=0xA1, MS=0xB7)");

        // Fig 5-42 sem scrambling -> CRC=0xA828; com scrambling -> CRC=0xDA98
        c16_lfsr_in = 16'hFFFF;     c16_word_in = 32'h0000_50FC; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_word_in = 32'h0302_0100; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_word_in = 32'h0706_0504; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_word_in = 32'hFBFB_FD08; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_edf_hdr = 16'h221C;      #1;
        check_cond(c16_final == 16'hA828, "Figura 5-42 (nao embaralhado): CRC-16 = 0xA828");

        c16_lfsr_in = 16'hFFFF;     c16_word_in = 32'h0000_50FC; #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_word_in = w_scr0;        #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_word_in = w_scr1;        #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_word_in = w_scr2;        #1; lfsr_tmp = c16_lfsr_out;
        c16_lfsr_in = lfsr_tmp;     c16_edf_hdr = 16'h221C;      #1;
        check_cond(c16_final == 16'hDA98, "Figura 5-42 (embaralhado):     CRC-16 = 0xDA98");

        // --------------------------------------------------------------------
        // TESTE 5: CRC-8 Vetores Aureos (Figura 5-46: FCT e EBF)
        // --------------------------------------------------------------------
        c8_lfsr_in = 8'h00; c8_din = 24'h01_01_7C; #1;
        check_cond(c8_val == 8'h4F, "Figura 5-46 FCT (7C,01,01): CRC-8 = 0x4F");

        c8_tmp = crc8_step_word(8'h00,  32'h0000_5DFC);
        c8_tmp = crc8_step_word(c8_tmp, 32'h0000_0000);
        c8_tmp = crc8_step_word(c8_tmp, 32'h0101_0101);
        c8_lfsr_in = c8_tmp; c8_din = 24'h41_00_5C; #1;
        check_cond(c8_val == 8'h29, "Figura 5-46 Broadcast EBF:  CRC-8 = 0x29");

        $display("------------------------------------------------------------------");
        if (errs == 0)
            $display(" RESULTADO ECSS VECTORS: [PASS] %0d/%0d verificacoes normativas OK", tests, tests);
        else
            $display(" RESULTADO ECSS VECTORS: [FAIL] %0d falhas em %0d verificacoes", errs, tests);
        $display("==================================================================");
        $finish;
    end

endmodule
