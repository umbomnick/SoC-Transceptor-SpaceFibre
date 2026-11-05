// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/datalink/sf_datalink.v
// Padrao : ECSS-E-ST-50-11C (Clausulas 5.3.5, 5.3.7, 5.3.8, 5.7.3, 5.7.4,
//          5.7.6, 5.7.8, 5.7.9 e 5.7.10) - Perfil 1 VC (VC0) No-Retry
// Funcao : Camada de Enlace de Dados (Data Link Layer) com formato de fio
//          100% normativo ECSS-E-ST-50-11C:
//          - Scrambler / Descrambler Galois X^16+X^5+X^4+X^3+1 + PRBS de Idle
//          - Enquadramento SDF (K28.7,D16.2,VC,00) / EDF (K28.0,SEQ,CRC16)
//          - Quadros ociosos SIF (K28.7,D4.2,SEQ,CRC8) + palavras PRBS
//          - Controle de fluxo FCT (K28.3,Mult/VC,SEQ,CRC8) por palavras VCB
//          - Marcadores in-band EOP (K29.7), EEP (K30.7) e Fill (K27.7)
//          - CRC-16 ITU LSB-first refletido (5.7.6.4) e CRC-8 (5.7.6.5)
//          - Negociacao INIT3LinkResetFlag / INIT3DataScrambled (5.7.9)
// ============================================================================
`timescale 1ns / 1ps

module sf_datalink #(
    parameter MAX_FRAME_BYTES = 16,  // Multiplo de 4 (padrao 16 B = 4 palavras; nominal ECSS = 256 B = 64 palavras)
    parameter RX_FRAMES       = 4,   // Profundidade do VCB em quadros maximos (potencia de 2)
    parameter IDLE_PRBS_WORDS = 8,   // Palavras PRBS por quadro ocioso SIF (0..64 conforme 5.3.8.3)
    parameter TXQ_AW          = 3    // log2 da FIFO de entrada N-char (8 posicoes)
)(
    input  wire        clk,
    input  wire        rst_n,

    // Configuracao
    input  wire        data_scrambled_en,

    // Interface com a Lane Layer (palavras de 32 bits)
    input  wire        lane_active,
    input  wire [7:0]  far_end_capabilities,
    input  wire        far_end_caps_valid,
    output wire [7:0]  near_end_capabilities,
    output reg  [31:0] dl_tx_word,
    output reg  [3:0]  dl_tx_k_flags,
    output reg         dl_tx_valid,
    input  wire        dl_tx_ready,
    input  wire [31:0] dl_rx_word,
    input  wire [3:0]  dl_rx_k_flags,
    input  wire        dl_rx_valid,
    input  wire        dl_rx_err,

    // Interface com a Network Layer (TX: N-chars de 9 bits {flag, data})
    input  wire [7:0]  tx_data,
    input  wire        tx_flag,
    input  wire        tx_valid,
    output wire        tx_ready,

    // Interface com a Network Layer (RX: N-chars de 9 bits {flag, data})
    output wire [7:0]  rx_data,
    output wire        rx_flag,
    output wire        rx_valid,
    input  wire        rx_ready,

    // Status e Contadores de Diagnostico
    output wire        link_up,
    output wire [3:0]  tx_credit,
    output reg  [7:0]  cnt_tx_frames,
    output reg  [7:0]  cnt_rx_frames,
    output reg  [7:0]  cnt_crc_err,
    output reg  [7:0]  cnt_seq_err,
    output reg  [7:0]  cnt_frame_err
);

    // ------------------------------------------------------------------------
    // Parametros derivados e constantes ECSS-E-ST-50-11C
    // ------------------------------------------------------------------------
    localparam integer MAX_FRAME_WORDS = (MAX_FRAME_BYTES >= 4) ? (MAX_FRAME_BYTES / 4) : 1;
    localparam integer FCT_WORDS       = MAX_FRAME_WORDS;
    localparam integer RX_BUF_WORDS    = RX_FRAMES * MAX_FRAME_WORDS;
    localparam integer FW_SH           = (FCT_WORDS > 1) ? $clog2(FCT_WORDS) : 0;
    localparam integer FW_W            = $clog2(MAX_FRAME_WORDS + 1);
    localparam integer CRED_W          = $clog2(RX_BUF_WORDS + 1);
    localparam integer BUF_AW          = $clog2(RX_BUF_WORDS);
    localparam integer FCT_CNT_W       = $clog2(RX_FRAMES + 4);
    localparam integer IDLE_W          = $clog2(IDLE_PRBS_WORDS + 1);

    // Simbolos K e D normativos (Tabelas 5-5, 5-6, 5-9, 5-10)
    localparam [7:0] SYM_K28_7 = 8'hFC, // Comma (SDF, SIF, SBF)
                     SYM_K28_0 = 8'h1C, // EDF
                     SYM_K28_2 = 8'h5C, // EBF
                     SYM_K28_3 = 8'h7C, // FCT
                     SYM_K27_7 = 8'hFB, // Fill
                     SYM_K29_7 = 8'hFD, // EOP
                     SYM_K30_7 = 8'hFE, // EEP
                     SYM_D16_2 = 8'h50, // SDF segundo simbolo
                     SYM_D4_2  = 8'h44; // SIF segundo simbolo

    reg  remote_alive;
    assign link_up = lane_active & remote_alive;

    // Capacidades anunciadas em INIT3 (ECSS 5.3.3.8e / 5.7.9):
    // bit 0 = INIT3LinkResetFlag (1 ate LinkInitialised), bit 1 = LaneStart, bit 2 = DataScrambled
    assign near_end_capabilities = {5'b00000, data_scrambled_en, 1'b1, ~link_up};
    wire   rx_scramble_active    = far_end_caps_valid ? far_end_capabilities[2] : data_scrambled_en;

    // Credito disponivel em unidades de quadros (teto de tx_credit_words / FCT_WORDS)
    reg [CRED_W-1:0] tx_credit_words;
    wire [CRED_W:0]  cred_ceil_num = {1'b0, tx_credit_words} + (FCT_WORDS - 1);
    wire [CRED_W:0]  cred_frames   = cred_ceil_num >> FW_SH;
    assign tx_credit = (cred_frames > RX_FRAMES) ? RX_FRAMES[3:0] : cred_frames[3:0];

    // ========================================================================
    // 1. FIFO de Entrada TX (N-chars vindos da Network Layer)
    // ========================================================================
    wire [8:0] src;
    wire       src_empty, src_full;
    reg        src_pop;

    sf_fifo #(.W(9), .AW(TXQ_AW)) u_txq (
        .clk   (clk),
        .rst_n (rst_n),
        .flush (1'b0),
        .wr    (tx_valid),
        .din   ({tx_flag, tx_data}),
        .rd    (src_pop),
        .dout  (src),
        .empty (src_empty),
        .full  (src_full)
    );
    assign tx_ready = !src_full;

    // ========================================================================
    // 2. Montador de Data Words TX + Scrambler + Geradores CRC-16 / CRC-8
    // ========================================================================
    reg [31:0] stg_word;
    reg [3:0]  stg_k;
    reg [2:0]  stg_cnt;      // 0..4 caracteres validos no registrador de estagio
    reg        stg_pkt_end;  // 1: palavra estagiada contem EOP ou EEP
    reg        tx_pkt_open;  // 1: pacote parcialmente consumido de u_txq
    reg        tx_discard;   // 1: descartando cauda de pacote interrompido (5.7.10a.3)

    reg              tx_in_frame;
    reg              tx_force_edf;
    reg [FW_W-1:0]   tx_words_sent;
    reg [6:0]        tx_seq_cnt;
    reg [15:0]       tx_crc16_lfsr;
    reg [15:0]       tx_scr_lfsr;
    reg [15:0]       tx_idle_lfsr;
    reg              tx_idle_active;
    reg [IDLE_W-1:0] tx_idle_cnt;
    reg [FCT_CNT_W-1:0] tx_fct_pending;

    // Completa slots vazios (stg_cnt..3) com K27.7 (Fill) quando necessario (5.3.7.2c)
    reg [31:0] raw_tx_dw;
    reg [3:0]  raw_tx_dk;
    always @(*) begin
        raw_tx_dw = stg_word;
        raw_tx_dk = stg_k;
        if (stg_cnt <= 3'd1) begin raw_tx_dw[15:8]  = SYM_K27_7; raw_tx_dk[1] = 1'b1; end
        if (stg_cnt <= 3'd2) begin raw_tx_dw[23:16] = SYM_K27_7; raw_tx_dk[2] = 1'b1; end
        if (stg_cnt <= 3'd3) begin raw_tx_dw[31:24] = SYM_K27_7; raw_tx_dk[3] = 1'b1; end
    end

    // Scrambler de Dados TX
    wire [31:0] scr_tx_dw;
    wire [15:0] tx_scr_lfsr_nx;
    wire [31:0] unused_scr_prbs;
    sf_scrambler u_tx_scrambler (
        .lfsr_in     (tx_scr_lfsr),
        .data_in     (raw_tx_dw),
        .k_in        (raw_tx_dk),
        .scramble_en (data_scrambled_en),
        .prbs_word   (unused_scr_prbs),
        .data_out    (scr_tx_dw),
        .lfsr_out    (tx_scr_lfsr_nx)
    );

    // Gerador PRBS continuo para Idle Frames (ECSS 5.7.6.2.3)
    wire [31:0] idle_prbs_word;
    wire [15:0] tx_idle_lfsr_nx;
    wire [31:0] unused_idle_dout;
    sf_scrambler u_tx_idle_prbs (
        .lfsr_in     (tx_idle_lfsr),
        .data_in     (32'd0),
        .k_in        (4'b0000),
        .scramble_en (1'b0),
        .prbs_word   (idle_prbs_word),
        .data_out    (unused_idle_dout),
        .lfsr_out    (tx_idle_lfsr_nx)
    );

    // CRC-16 TX (palavra SDF ou Data Word embaralhada)
    localparam [31:0] WORD_SDF = {8'h00, 8'h00, SYM_D16_2, SYM_K28_7};
    wire [15:0] crc16_tx_in  = tx_in_frame ? tx_crc16_lfsr : 16'hFFFF;
    wire [31:0] crc16_tx_din = tx_in_frame ? scr_tx_dw     : WORD_SDF;
    wire [15:0] crc16_tx_nx;
    sf_crc16_word u_crc16_tx_word (
        .lfsr_in  (crc16_tx_in),
        .word_in  (crc16_tx_din),
        .lfsr_out (crc16_tx_nx)
    );

    wire [6:0]  tx_seq_plus1 = tx_seq_cnt + 7'd1;
    wire [7:0]  tx_seq_inc_b = {1'b0, tx_seq_plus1};
    wire [7:0]  tx_seq_cur_b = {1'b0, tx_seq_cnt};
    wire [15:0] edf_crc16_val;
    sf_crc16_edf u_crc16_tx_edf (
        .lfsr_in    (tx_crc16_lfsr),
        .edf_hdr_in ({tx_seq_inc_b, SYM_K28_0}),
        .crc_val_out(edf_crc16_val)
    );

    // CRC-8 TX para FCT e SIF
    wire [7:0] fct_crc8_val, unused_fct_lfsr;
    sf_crc8 u_crc8_tx_fct (
        .lfsr_in  (8'h00),
        .data_24b ({tx_seq_inc_b, 8'h00, SYM_K28_3}),
        .lfsr_out (unused_fct_lfsr),
        .crc_out  (fct_crc8_val)
    );

    wire [7:0] sif_crc8_val, unused_sif_lfsr;
    sf_crc8 u_crc8_tx_sif (
        .lfsr_in  (8'h00),
        .data_24b ({tx_seq_cur_b, SYM_D4_2, SYM_K28_7}),
        .lfsr_out (unused_sif_lfsr),
        .crc_out  (sif_crc8_val)
    );

    // Decisao combinacional da palavra TX apresentada a Lane Layer
    wire stg_ready_start = (stg_cnt == 3'd4) || stg_pkt_end ||
                           ((stg_cnt != 3'd0) && src_empty);
    wire can_start_df    = link_up && (tx_credit_words != {CRED_W{1'b0}}) &&
                           stg_ready_start && !tx_discard;
    wire can_send_dw     = tx_in_frame && link_up && !tx_force_edf &&
                           (tx_words_sent < MAX_FRAME_WORDS[FW_W-1:0]) &&
                           (tx_credit_words != {CRED_W{1'b0}}) &&
                           (stg_cnt != 3'd0);

    localparam [2:0] TXW_NONE = 3'd0,
                     TXW_FCT  = 3'd1,
                     TXW_SDF  = 3'd2,
                     TXW_DATA = 3'd3,
                     TXW_EDF  = 3'd4,
                     TXW_SIF  = 3'd5,
                     TXW_PRBS = 3'd6;

    reg [2:0] tx_sel;
    always @(*) begin
        tx_sel        = TXW_NONE;
        dl_tx_valid   = 1'b0;
        dl_tx_word    = 32'd0;
        dl_tx_k_flags = 4'b0000;

        if (lane_active) begin
            dl_tx_valid = 1'b1;
            if (tx_in_frame) begin
                if (!link_up) begin
                    // Link caiu no meio do quadro: encerra imediatamente com SIF
                    tx_sel        = TXW_SIF;
                    dl_tx_word    = {sif_crc8_val, tx_seq_cur_b, SYM_D4_2, SYM_K28_7};
                    dl_tx_k_flags = 4'b0001;
                end else if (can_send_dw) begin
                    tx_sel        = TXW_DATA;
                    dl_tx_word    = scr_tx_dw;
                    dl_tx_k_flags = raw_tx_dk;
                end else begin
                    tx_sel        = TXW_EDF;
                    dl_tx_word    = {edf_crc16_val[15:8], edf_crc16_val[7:0], tx_seq_inc_b, SYM_K28_0};
                    dl_tx_k_flags = 4'b0001;
                end
            end else if (tx_fct_pending != {FCT_CNT_W{1'b0}}) begin
                tx_sel        = TXW_FCT;
                dl_tx_word    = {fct_crc8_val, tx_seq_inc_b, 8'h00, SYM_K28_3};
                dl_tx_k_flags = 4'b0001;
            end else if (can_start_df) begin
                tx_sel        = TXW_SDF;
                dl_tx_word    = WORD_SDF;
                dl_tx_k_flags = 4'b0001;
            end else if (!tx_idle_active || (tx_idle_cnt >= IDLE_PRBS_WORDS[IDLE_W-1:0])) begin
                tx_sel        = TXW_SIF;
                dl_tx_word    = {sif_crc8_val, tx_seq_cur_b, SYM_D4_2, SYM_K28_7};
                dl_tx_k_flags = 4'b0001;
            end else begin
                tx_sel        = TXW_PRBS;
                dl_tx_word    = idle_prbs_word;
                dl_tx_k_flags = 4'b0000;
            end
        end
    end

    wire tx_fire        = lane_active && dl_tx_ready;
    wire tx_consume_stg = tx_fire && (tx_sel == TXW_DATA);
    wire tx_send_fct    = tx_fire && (tx_sel == TXW_FCT);

    // Pop combinacional da u_txq para o registrador de estagio stg
    wire stg_can_accept = tx_consume_stg || ((stg_cnt < 3'd4) && !stg_pkt_end);
    always @(*) begin
        src_pop = 1'b0;
        if (!src_empty) begin
            if (tx_discard)
                src_pop = 1'b1;
            else if (link_up && stg_can_accept)
                src_pop = 1'b1;
        end
    end

    wire [7:0] src_mark_sym = src[0] ? SYM_K30_7 : SYM_K29_7; // EEP : EOP

    // ========================================================================
    // 3. Caminho RX: Identificador de Palavras + Descrambler + VCB de Palavras
    // ========================================================================
    reg              r_in_frame;
    reg              r_frame_bad;
    reg              rxerr_pend;
    reg              in_idle_frame;
    reg              saw_unframed_rxerr;
    reg [FW_W-1:0]   spec_words;
    reg [FW_W-1:0]   orphan_words;
    reg [15:0]       rx_crc16_lfsr;
    reg [15:0]       rx_scr_lfsr;
    reg [6:0]        exp_seq;
    reg              seq_synced;

    // Estado de continuidade de pacote (especulativo vs comitado)
    reg pkt_open_com,  w_pkt_open;
    reg drop_tail_com, w_drop_tail;
    reg need_eep_com,  w_need_eep;

    // VCB circular de palavras de 36 bits {k[3:0], byte3..byte0}
    reg [35:0]     vcb_mem [0:RX_BUF_WORDS-1];
    reg [BUF_AW:0] wr_spec_ptr;
    reg [BUF_AW:0] wr_commit_ptr;
    reg [BUF_AW:0] rd_ptr;
    reg [1:0]      b_sub;
    reg            out_pkt_open;
    reg            los_eep_pending;

    // Acumulador de palavras liberadas para geracao de FCT (ECSS 5.7.3.3c)
    reg [FW_W:0]   freed_words_acc;

    wire [7:0] rb0 = dl_rx_word[7:0];
    wire [7:0] rb1 = dl_rx_word[15:8];
    wire [7:0] rb2 = dl_rx_word[23:16];
    wire [7:0] rb3 = dl_rx_word[31:24];

    // Distincao entre Control Words (K28.7/K28.0/K28.2/K28.3) e Data Words (D / EOP / EEP / Fill)
    wire rx_is_ctrl_word = dl_rx_k_flags[0] &&
                           ((rb0 == SYM_K28_7) || (rb0 == SYM_K28_0) ||
                            (rb0 == SYM_K28_2) || (rb0 == SYM_K28_3));

    // Verificador CRC-8 RX (para FCT e SIF)
    wire [7:0] rx_crc8_calc, unused_rx_crc8_lfsr;
    sf_crc8 u_crc8_rx (
        .lfsr_in  (8'h00),
        .data_24b ({rb2, rb1, rb0}),
        .lfsr_out (unused_rx_crc8_lfsr),
        .crc_out  (rx_crc8_calc)
    );
    wire rx_crc8_ok = (rx_crc8_calc == rb3);

    // Verificador CRC-16 RX (calculado sobre os dados recebidos da linha antes do descrambler, 5.7.6.4e)
    wire [15:0] rx_crc16_word_in = (rx_is_ctrl_word && (rb0 == SYM_K28_7) && (rb1 == SYM_D16_2)) ?
                                   16'hFFFF : rx_crc16_lfsr;
    wire [15:0] rx_crc16_word_nx;
    sf_crc16_word u_crc16_rx_word (
        .lfsr_in  (rx_crc16_word_in),
        .word_in  (dl_rx_word),
        .lfsr_out (rx_crc16_word_nx)
    );

    wire [15:0] rx_edf_crc_calc;
    sf_crc16_edf u_crc16_rx_edf (
        .lfsr_in    (rx_crc16_lfsr),
        .edf_hdr_in ({rb1, rb0}),
        .crc_val_out(rx_edf_crc_calc)
    );
    wire rx_edf_crc_ok = ({rb3, rb2} == rx_edf_crc_calc);

    // Descrambler de Data Words RX
    wire [31:0] unscr_rx_word;
    wire [15:0] rx_scr_lfsr_nx;
    wire [31:0] unused_rx_prbs;
    sf_scrambler u_rx_descrambler (
        .lfsr_in     (rx_scr_lfsr),
        .data_in     (dl_rx_word),
        .k_in        (dl_rx_k_flags),
        .scramble_en (rx_scramble_active),
        .prbs_word   (unused_rx_prbs),
        .data_out    (unscr_rx_word),
        .lfsr_out    (rx_scr_lfsr_nx)
    );

    // Valida caracteres K permitidos dentro de uma Data Word (apenas Fill, EOP, EEP)
    reg        dw_char_invalid;
    reg [31:0] filt_dw_bytes;
    reg [3:0]  filt_dw_k;
    reg        nx_w_pkt_open, nx_w_drop_tail, nx_w_need_eep;
    integer    ci;
    reg [7:0]  ch_b;
    reg        ch_k, ch_is_fill, ch_is_end;

    always @(*) begin
        dw_char_invalid = 1'b0;
        filt_dw_bytes   = unscr_rx_word;
        filt_dw_k       = dl_rx_k_flags;
        nx_w_pkt_open   = w_pkt_open;
        nx_w_drop_tail  = w_drop_tail;
        nx_w_need_eep   = w_need_eep;

        for (ci = 0; ci < 4; ci = ci + 1) begin
            ch_b       = unscr_rx_word[ci*8 +: 8];
            ch_k       = dl_rx_k_flags[ci];
            ch_is_fill = ch_k && (ch_b == SYM_K27_7);
            ch_is_end  = ch_k && ((ch_b == SYM_K29_7) || (ch_b == SYM_K30_7));

            if (ch_k && !ch_is_fill && !ch_is_end) begin
                dw_char_invalid = 1'b1;
            end else if (!ch_is_fill) begin
                if (nx_w_drop_tail) begin
                    // Descarta cauda do pacote abortado ate encontrar seu EOP/EEP
                    filt_dw_k[ci]            = 1'b1;
                    filt_dw_bytes[ci*8 +: 8] = nx_w_need_eep ? SYM_K30_7 : SYM_K27_7;
                    nx_w_need_eep            = 1'b0;
                    if (ch_is_end) begin
                        nx_w_drop_tail = 1'b0;
                        nx_w_pkt_open  = 1'b0;
                    end
                end else begin
                    nx_w_pkt_open = !ch_is_end;
                end
            end
        end
    end

    wire [BUF_AW:0] vcb_spec_used = wr_spec_ptr - rd_ptr;
    wire            vcb_spec_full = (vcb_spec_used >= RX_BUF_WORDS[BUF_AW:0]);

    // ------------------------------------------------------------------------
    // Leitor do VCB -> FIFO registrada de saida u_rxo (2 posicoes) -> Network
    // ------------------------------------------------------------------------
    wire       vcb_has_word = (rd_ptr != wr_commit_ptr);
    wire [35:0] cur_vcb_w   = vcb_mem[rd_ptr[BUF_AW-1:0]];

    wire [3:0] slot_is_fill;
    genvar si;
    generate
        for (si = 0; si < 4; si = si + 1) begin : GEN_SLOT_FILL
            assign slot_is_fill[si] = cur_vcb_w[32 + si] && (cur_vcb_w[si*8 +: 8] == SYM_K27_7);
        end
    endgenerate

    wire       cur_k_bit   = cur_vcb_w[32 + b_sub];
    wire [7:0] cur_b_val   = cur_vcb_w[b_sub*8 +: 8];
    wire       cur_is_fill = cur_k_bit && (cur_b_val == SYM_K27_7);
    wire       cur_is_eop  = cur_k_bit && (cur_b_val == SYM_K29_7);
    wire       cur_is_eep  = cur_k_bit && (cur_b_val == SYM_K30_7);

    // Verifica se todos os slots restantes apos b_sub sao Fill (permite avancar rd_ptr em 1 ciclo)
    wire rest_all_fill = (b_sub == 2'd3) ||
                         ((b_sub == 2'd2) && slot_is_fill[3]) ||
                         ((b_sub == 2'd1) && slot_is_fill[2] && slot_is_fill[3]) ||
                         ((b_sub == 2'd0) && slot_is_fill[1] && slot_is_fill[2] && slot_is_fill[3]);

    wire rxo_full, rxo_empty;
    wire rxo_rdy = !rxo_full;

    wire synth_idle_eep = lane_active && !vcb_has_word && !r_in_frame && need_eep_com;
    wire emit_eep_only  = los_eep_pending || synth_idle_eep;

    wire rxi_wr   = emit_eep_only ? 1'b1 : (lane_active && vcb_has_word && !cur_is_fill);
    wire rxi_flag = emit_eep_only ? 1'b1 : (cur_is_eop | cur_is_eep);
    wire [7:0] rxi_data = emit_eep_only ? 8'h01 :
                          cur_is_eep    ? 8'h01 :
                          cur_is_eop    ? 8'h00 : cur_b_val;

    sf_fifo #(.W(9), .AW(1)) u_rxo (
        .clk   (clk),
        .rst_n (rst_n),
        .flush (1'b0),
        .wr    (rxi_wr),
        .din   ({rxi_flag, rxi_data}),
        .rd    (rx_ready),
        .dout  ({rx_flag, rx_data}),
        .empty (rxo_empty),
        .full  (rxo_full)
    );
    assign rx_valid = !rxo_empty;

    wire vcb_step        = lane_active && !emit_eep_only && vcb_has_word && (cur_is_fill || rxo_rdy);
    wire vcb_word_popped = vcb_step && rest_all_fill;

    // ========================================================================
    // 4. Atualizacao Sequencial Unificada (TX + RX + Creditos / FCTs)
    // ========================================================================
    reg             rx_got_fct;
    reg [FW_W:0]    rx_rollback_words;
    reg [FW_W:0]    next_freed_acc;
    reg [1:0]       fct_gen_cnt;
    reg [FW_W-1:0]  tot_f_words;
    reg             seq_gap;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Estado TX
            stg_word       <= 32'd0;
            stg_k          <= 4'd0;
            stg_cnt        <= 3'd0;
            stg_pkt_end    <= 1'b0;
            tx_pkt_open    <= 1'b0;
            tx_discard     <= 1'b0;
            tx_in_frame    <= 1'b0;
            tx_force_edf   <= 1'b0;
            tx_words_sent  <= {FW_W{1'b0}};
            tx_seq_cnt     <= 7'd0;
            tx_crc16_lfsr  <= 16'hFFFF;
            tx_scr_lfsr    <= 16'hFFFF;
            tx_idle_lfsr   <= 16'hFFFF;
            tx_idle_active <= 1'b0;
            tx_idle_cnt    <= {IDLE_W{1'b0}};
            tx_fct_pending <= RX_FRAMES[FCT_CNT_W-1:0];
            tx_credit_words<= {CRED_W{1'b0}};
            cnt_tx_frames  <= 8'd0;

            // Estado RX
            remote_alive       <= 1'b0;
            r_in_frame         <= 1'b0;
            r_frame_bad        <= 1'b0;
            rxerr_pend         <= 1'b0;
            in_idle_frame      <= 1'b0;
            saw_unframed_rxerr <= 1'b0;
            spec_words         <= {FW_W{1'b0}};
            orphan_words       <= {FW_W{1'b0}};
            rx_crc16_lfsr      <= 16'hFFFF;
            rx_scr_lfsr        <= 16'hFFFF;
            exp_seq            <= 7'd0;
            seq_synced         <= 1'b0;
            pkt_open_com       <= 1'b0;
            drop_tail_com      <= 1'b0;
            need_eep_com       <= 1'b0;
            w_pkt_open         <= 1'b0;
            w_drop_tail        <= 1'b0;
            w_need_eep         <= 1'b0;
            wr_spec_ptr        <= {(BUF_AW+1){1'b0}};
            wr_commit_ptr      <= {(BUF_AW+1){1'b0}};
            rd_ptr             <= {(BUF_AW+1){1'b0}};
            b_sub              <= 2'd0;
            out_pkt_open       <= 1'b0;
            los_eep_pending    <= 1'b0;
            freed_words_acc    <= {(FW_W+1){1'b0}};
            cnt_rx_frames      <= 8'd0;
            cnt_crc_err        <= 8'd0;
            cnt_seq_err        <= 8'd0;
            cnt_frame_err      <= 8'd0;
        end else begin
            rx_got_fct        = 1'b0;
            rx_rollback_words = {(FW_W+1){1'b0}};

            // ----------------------------------------------------------------
            // A. Gestao do registrador de estagio TX (1 N-char por ciclo)
            // ----------------------------------------------------------------
            if (tx_discard && src_pop && src[8]) begin
                tx_discard <= 1'b0;
            end

            if (!link_up) begin
                if (tx_pkt_open || ((stg_cnt != 3'd0) && !stg_pkt_end)) begin
                    tx_discard  <= 1'b1;
                    tx_pkt_open <= 1'b0;
                end
                stg_cnt     <= 3'd0;
                stg_pkt_end <= 1'b0;
            end else if (tx_consume_stg) begin
                if (src_pop && !tx_discard) begin
                    if (src[8]) begin
                        stg_word    <= {SYM_K27_7, SYM_K27_7, SYM_K27_7, src_mark_sym};
                        stg_k       <= 4'b1111;
                        stg_cnt     <= 3'd4;
                        stg_pkt_end <= 1'b1;
                        tx_pkt_open <= 1'b0;
                    end else begin
                        stg_word[7:0] <= src[7:0];
                        stg_k[0]      <= 1'b0;
                        stg_cnt       <= 3'd1;
                        stg_pkt_end   <= 1'b0;
                        tx_pkt_open   <= 1'b1;
                    end
                end else begin
                    stg_cnt     <= 3'd0;
                    stg_pkt_end <= 1'b0;
                end
            end else if (src_pop && !tx_discard) begin
                if (src[8]) begin
                    case (stg_cnt[1:0])
                        2'd0: begin stg_word <= {SYM_K27_7, SYM_K27_7, SYM_K27_7, src_mark_sym}; stg_k <= 4'b1111; end
                        2'd1: begin stg_word[31:8]  <= {SYM_K27_7, SYM_K27_7, src_mark_sym}; stg_k[3:1] <= 3'b111; end
                        2'd2: begin stg_word[31:16] <= {SYM_K27_7, src_mark_sym};            stg_k[3:2] <= 2'b11;  end
                        2'd3: begin stg_word[31:24] <= src_mark_sym;                         stg_k[3]   <= 1'b1;   end
                    endcase
                    stg_cnt     <= 3'd4;
                    stg_pkt_end <= 1'b1;
                    tx_pkt_open <= 1'b0;
                end else begin
                    stg_word[stg_cnt[1:0]*8 +: 8] <= src[7:0];
                    stg_k[stg_cnt[1:0]]           <= 1'b0;
                    stg_cnt                       <= stg_cnt + 3'd1;
                    tx_pkt_open                   <= 1'b1;
                end
            end

            // ----------------------------------------------------------------
            // B. Transmissor de Quadros (acionado em tx_fire = lane_active & dl_tx_ready)
            // ----------------------------------------------------------------
            if (!lane_active) begin
                tx_in_frame    <= 1'b0;
                tx_force_edf   <= 1'b0;
                tx_words_sent  <= {FW_W{1'b0}};
                tx_seq_cnt     <= 7'd0;
                tx_idle_active <= 1'b0;
                tx_idle_cnt    <= {IDLE_W{1'b0}};
            end else if (tx_fire) begin
                case (tx_sel)
                    TXW_FCT: begin
                        tx_seq_cnt     <= tx_seq_plus1;
                        tx_idle_active <= 1'b0;
                    end
                    TXW_SDF: begin
                        tx_in_frame    <= 1'b1;
                        tx_force_edf   <= 1'b0;
                        tx_words_sent  <= {FW_W{1'b0}};
                        tx_scr_lfsr    <= 16'hFFFF;
                        tx_crc16_lfsr  <= crc16_tx_nx;
                        tx_idle_active <= 1'b0;
                    end
                    TXW_DATA: begin
                        tx_words_sent <= tx_words_sent + 1'b1;
                        tx_scr_lfsr   <= tx_scr_lfsr_nx;
                        tx_crc16_lfsr <= crc16_tx_nx;
                        if (stg_pkt_end || (stg_cnt < 3'd4))
                            tx_force_edf <= 1'b1;
                    end
                    TXW_EDF: begin
                        tx_in_frame    <= 1'b0;
                        tx_force_edf   <= 1'b0;
                        tx_seq_cnt     <= tx_seq_plus1;
                        tx_idle_active <= 1'b0;
                        cnt_tx_frames  <= cnt_tx_frames + 8'd1;
                    end
                    TXW_SIF: begin
                        tx_in_frame    <= 1'b0;
                        tx_force_edf   <= 1'b0;
                        tx_idle_active <= 1'b1;
                        tx_idle_cnt    <= {IDLE_W{1'b0}};
                    end
                    TXW_PRBS: begin
                        tx_idle_lfsr <= tx_idle_lfsr_nx;
                        tx_idle_cnt  <= tx_idle_cnt + 1'b1;
                    end
                    default: ;
                endcase
            end

            // ----------------------------------------------------------------
            // C. Receptor de Quadros e VCB
            // ----------------------------------------------------------------
            if (!lane_active) begin
                // Link Reset na recepcao (ECSS 5.7.10)
                remote_alive       <= 1'b0;
                r_in_frame         <= 1'b0;
                r_frame_bad        <= 1'b0;
                rxerr_pend         <= 1'b0;
                in_idle_frame      <= 1'b0;
                saw_unframed_rxerr <= 1'b0;
                spec_words         <= {FW_W{1'b0}};
                orphan_words       <= {FW_W{1'b0}};
                exp_seq            <= 7'd0;
                seq_synced         <= 1'b0;
                pkt_open_com       <= 1'b0;
                drop_tail_com      <= 1'b0;
                need_eep_com       <= 1'b0;
                wr_spec_ptr        <= {(BUF_AW+1){1'b0}};
                wr_commit_ptr      <= {(BUF_AW+1){1'b0}};
                rd_ptr             <= {(BUF_AW+1){1'b0}};
                b_sub              <= 2'd0;
                freed_words_acc    <= {(FW_W+1){1'b0}};

                if (los_eep_pending) begin
                    if (rxo_rdy) los_eep_pending <= 1'b0;
                end else if (out_pkt_open) begin
                    los_eep_pending <= 1'b1;
                    out_pkt_open    <= 1'b0;
                end
            end else begin
                // Drena eventual EEP pendente ao consumir em u_rxo
                if (los_eep_pending && rxo_rdy) begin
                    los_eep_pending <= 1'b0;
                    out_pkt_open    <= 1'b0;
                end else if (synth_idle_eep && rxo_rdy) begin
                    need_eep_com <= 1'b0;
                    out_pkt_open <= 1'b0;
                end else if (vcb_step) begin
                    if (!cur_is_fill)
                        out_pkt_open <= !(cur_is_eop | cur_is_eep);
                    if (rest_all_fill) begin
                        rd_ptr <= rd_ptr + 1'b1;
                        b_sub  <= 2'd0;
                    end else begin
                        b_sub  <= b_sub + 2'd1;
                    end
                end

                // Processamento de palavras recebidas da Lane Layer
                if (dl_rx_valid) begin
                    if (dl_rx_err) begin
                        in_idle_frame <= 1'b0;
                        if (r_in_frame) begin
                            r_frame_bad <= 1'b1;
                            if (rxerr_pend && (spec_words < MAX_FRAME_WORDS[FW_W-1:0]))
                                spec_words <= spec_words + 1'b1;
                            rxerr_pend <= 1'b1;
                        end else begin
                            if (saw_unframed_rxerr && (orphan_words < MAX_FRAME_WORDS[FW_W-1:0]))
                                orphan_words <= orphan_words + 1'b1;
                            saw_unframed_rxerr <= 1'b1;
                        end
                    end else if (rx_is_ctrl_word) begin
                        // 1. FCT: {CRC8, SEQ_NUM, {Mult,VC}, K28.3}
                        if ((dl_rx_k_flags == 4'b0001) && (rb0 == SYM_K28_3)) begin
                            if (rx_crc8_ok && (rb1[4:0] == 5'd0)) begin
                                remote_alive <= 1'b1;
                                rx_got_fct    = 1'b1;
                                if (seq_synced && (rb2[6:0] != (exp_seq + 7'd1)))
                                    cnt_seq_err <= cnt_seq_err + 8'd1;
                                exp_seq    <= rb2[6:0];
                                seq_synced <= 1'b1;
                            end else if (!rx_crc8_ok) begin
                                cnt_crc_err <= cnt_crc_err + 8'd1;
                            end
                        end
                        // 2. SIF: {CRC8, SEQ_NUM, D4.2, K28.7}
                        else if ((dl_rx_k_flags == 4'b0001) && (rb0 == SYM_K28_7) && (rb1 == SYM_D4_2)) begin
                            if (r_in_frame) begin
                                // Quadro anterior interrompido (ex.: EDF virou RXERR)
                                wr_spec_ptr       <= wr_commit_ptr;
                                rx_rollback_words  = {1'b0, spec_words};
                                r_in_frame        <= 1'b0;
                                rxerr_pend        <= 1'b0;
                                cnt_frame_err     <= cnt_frame_err + 8'd1;
                                drop_tail_com     <= 1'b1;
                                if (pkt_open_com) begin
                                    need_eep_com <= 1'b1;
                                    pkt_open_com <= 1'b0;
                                end
                            end
                            saw_unframed_rxerr <= 1'b0;
                            orphan_words       <= {FW_W{1'b0}};

                            if (rx_crc8_ok) begin
                                remote_alive  <= 1'b1;
                                in_idle_frame <= 1'b1;
                                if (seq_synced && (rb2[6:0] != exp_seq)) begin
                                    cnt_seq_err <= cnt_seq_err + 8'd1;
                                    exp_seq     <= rb2[6:0];
                                    if (pkt_open_com) begin
                                        drop_tail_com <= 1'b1;
                                        need_eep_com  <= 1'b1;
                                        pkt_open_com  <= 1'b0;
                                    end
                                end
                            end else begin
                                cnt_crc_err <= cnt_crc_err + 8'd1;
                            end
                        end
                        // 3. SDF: {00, VC, D16.2, K28.7}
                        else if ((dl_rx_k_flags == 4'b0001) && (rb0 == SYM_K28_7) && (rb1 == SYM_D16_2)) begin
                            if (r_in_frame) begin
                                wr_spec_ptr       <= wr_commit_ptr;
                                rx_rollback_words  = {1'b0, spec_words};
                                cnt_frame_err     <= cnt_frame_err + 8'd1;
                                drop_tail_com     <= 1'b1;
                                if (pkt_open_com) begin
                                    need_eep_com <= 1'b1;
                                    pkt_open_com <= 1'b0;
                                end
                            end
                            in_idle_frame      <= 1'b0;
                            saw_unframed_rxerr <= 1'b0;
                            orphan_words       <= {FW_W{1'b0}};

                            if ((rb2[4:0] == 5'd0) && !vcb_spec_full) begin
                                r_in_frame    <= 1'b1;
                                r_frame_bad   <= 1'b0;
                                rxerr_pend    <= 1'b0;
                                spec_words    <= {FW_W{1'b0}};
                                rx_scr_lfsr   <= 16'hFFFF;
                                rx_crc16_lfsr <= rx_crc16_word_nx;
                                // Copia estado comitado caso nao tenha havido aborto neste mesmo ciclo
                                w_pkt_open    <= r_in_frame ? 1'b0 : pkt_open_com;
                                w_drop_tail   <= r_in_frame ? 1'b1 : drop_tail_com;
                                w_need_eep    <= r_in_frame ? (pkt_open_com ? 1'b1 : need_eep_com) : need_eep_com;
                            end else begin
                                r_in_frame    <= 1'b0;
                                cnt_frame_err <= cnt_frame_err + 8'd1;
                            end
                        end
                        // 4. EDF: {CRC_MS, CRC_LS, SEQ_NUM, K28.0}
                        else if ((dl_rx_k_flags == 4'b0001) && (rb0 == SYM_K28_0)) begin
                            tot_f_words = spec_words + (rxerr_pend ? 1'b1 : 1'b0);
                            r_in_frame  <= 1'b0;
                            rxerr_pend  <= 1'b0;

                            if (!r_in_frame) begin
                                cnt_frame_err <= cnt_frame_err + 8'd1;
                                if (saw_unframed_rxerr) begin
                                    rx_rollback_words  = {1'b0, orphan_words};
                                    saw_unframed_rxerr <= 1'b0;
                                    orphan_words       <= {FW_W{1'b0}};
                                    drop_tail_com      <= 1'b1;
                                    if (pkt_open_com) begin
                                        need_eep_com <= 1'b1;
                                        pkt_open_com <= 1'b0;
                                    end
                                end
                            end else if (r_frame_bad || (tot_f_words == {FW_W{1'b0}})) begin
                                cnt_frame_err     <= cnt_frame_err + 8'd1;
                                wr_spec_ptr       <= wr_commit_ptr;
                                rx_rollback_words  = {1'b0, tot_f_words};
                                drop_tail_com     <= 1'b1;
                                if (pkt_open_com) begin
                                    need_eep_com <= 1'b1;
                                    pkt_open_com <= 1'b0;
                                end
                            end else if (!rx_edf_crc_ok) begin
                                cnt_crc_err       <= cnt_crc_err + 8'd1;
                                wr_spec_ptr       <= wr_commit_ptr;
                                rx_rollback_words  = {1'b0, tot_f_words};
                                drop_tail_com     <= 1'b1;
                                if (pkt_open_com) begin
                                    need_eep_com <= 1'b1;
                                    pkt_open_com <= 1'b0;
                                end
                            end else begin
                                // Quadro integro validado por CRC-16!
                                remote_alive <= 1'b1;
                                seq_gap       = seq_synced && (rb1[6:0] != (exp_seq + 7'd1));
                                if (seq_gap) cnt_seq_err <= cnt_seq_err + 8'd1;
                                exp_seq    <= rb1[6:0];
                                seq_synced <= 1'b1;

                                if (seq_gap && pkt_open_com && !drop_tail_com) begin
                                    // Um quadro intermediario do pacote aberto desapareceu por completo
                                    wr_spec_ptr       <= wr_commit_ptr;
                                    rx_rollback_words  = {1'b0, tot_f_words};
                                    drop_tail_com     <= 1'b1;
                                    need_eep_com      <= 1'b1;
                                    pkt_open_com      <= 1'b0;
                                end else begin
                                    wr_commit_ptr <= wr_spec_ptr;
                                    pkt_open_com  <= w_pkt_open;
                                    drop_tail_com <= w_drop_tail;
                                    need_eep_com  <= w_need_eep;
                                    cnt_rx_frames <= cnt_rx_frames + 8'd1;
                                end
                            end
                        end
                        // 5. Outra palavra de controle desconhecida / invalida
                        else begin
                            cnt_frame_err <= cnt_frame_err + 8'd1;
                            if (r_in_frame) begin
                                wr_spec_ptr       <= wr_commit_ptr;
                                rx_rollback_words  = {1'b0, spec_words};
                                r_in_frame        <= 1'b0;
                                drop_tail_com     <= 1'b1;
                                if (pkt_open_com) begin
                                    need_eep_com <= 1'b1;
                                    pkt_open_com <= 1'b0;
                                end
                            end
                        end
                    end else begin
                        // Palavra de Dados (ou PRBS de Idle Frame fora de r_in_frame)
                        if (r_in_frame) begin
                            rx_scr_lfsr   <= rx_scr_lfsr_nx;
                            rx_crc16_lfsr <= rx_crc16_word_nx;
                            if (rxerr_pend) begin
                                rxerr_pend <= 1'b0;
                                spec_words <= spec_words + 2'd2;
                            end else if ((spec_words < MAX_FRAME_WORDS[FW_W-1:0]) &&
                                         !vcb_spec_full && !dw_char_invalid) begin
                                vcb_mem[wr_spec_ptr[BUF_AW-1:0]] <= {filt_dw_k, filt_dw_bytes};
                                wr_spec_ptr <= wr_spec_ptr + 1'b1;
                                spec_words  <= spec_words + 1'b1;
                                w_pkt_open  <= nx_w_pkt_open;
                                w_drop_tail <= nx_w_drop_tail;
                                w_need_eep  <= nx_w_need_eep;
                            end else begin
                                r_frame_bad <= 1'b1;
                                if (spec_words < MAX_FRAME_WORDS[FW_W-1:0])
                                    spec_words <= spec_words + 1'b1;
                            end
                        end else if (saw_unframed_rxerr && !in_idle_frame) begin
                            if (orphan_words < MAX_FRAME_WORDS[FW_W-1:0])
                                orphan_words <= orphan_words + 1'b1;
                        end
                    end
                end
            end

            // ----------------------------------------------------------------
            // D. Contabilidade Atomica de Creditos (TX) e Geracao de FCTs (RX)
            // ----------------------------------------------------------------
            if (!lane_active) begin
                tx_credit_words <= {CRED_W{1'b0}};
                tx_fct_pending  <= RX_FRAMES[FCT_CNT_W-1:0];
            end else begin
                // 1. Credito de palavras disponivel no nosso transmissor
                if (rx_got_fct && tx_consume_stg) begin
                    if ((tx_credit_words + FCT_WORDS[CRED_W-1:0] - 1'b1) <= RX_BUF_WORDS[CRED_W-1:0])
                        tx_credit_words <= tx_credit_words + FCT_WORDS[CRED_W-1:0] - 1'b1;
                    else
                        tx_credit_words <= RX_BUF_WORDS[CRED_W-1:0];
                end else if (rx_got_fct) begin
                    if ((tx_credit_words + FCT_WORDS[CRED_W-1:0]) <= RX_BUF_WORDS[CRED_W-1:0])
                        tx_credit_words <= tx_credit_words + FCT_WORDS[CRED_W-1:0];
                    else
                        tx_credit_words <= RX_BUF_WORDS[CRED_W-1:0];
                end else if (tx_consume_stg) begin
                    tx_credit_words <= tx_credit_words - 1'b1;
                end

                // 2. Acumulador de palavras liberadas no VCB receptor -> geracao de FCT
                next_freed_acc = freed_words_acc +
                                 (vcb_word_popped ? {{FW_W{1'b0}}, 1'b1} : {(FW_W+1){1'b0}}) +
                                 rx_rollback_words;
                if (next_freed_acc >= (2 * FCT_WORDS)) begin
                    freed_words_acc <= next_freed_acc - (2 * FCT_WORDS);
                    fct_gen_cnt      = 2'd2;
                end else if (next_freed_acc >= FCT_WORDS) begin
                    freed_words_acc <= next_freed_acc - FCT_WORDS;
                    fct_gen_cnt      = 2'd1;
                end else begin
                    freed_words_acc <= next_freed_acc;
                    fct_gen_cnt      = 2'd0;
                end

                tx_fct_pending <= tx_fct_pending + fct_gen_cnt - (tx_send_fct ? 1'b1 : 1'b0);
            end
        end
    end

endmodule
