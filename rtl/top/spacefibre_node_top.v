// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/top/spacefibre_node_top.v
// Padrao : ECSS-E-ST-50-11C
// Funcao : Integracao unificada Network Layer + Data Link Layer + Lane Layer
//          Host <-> sf_network <-> sf_datalink <-> spacefibre_lane_top <-> PHY (10b)
// ============================================================================
`timescale 1ns / 1ps

module spacefibre_node_top #(
    parameter MAX_FRAME_BYTES       = 16,    // 16 B (compacto SKY130) ate 256 B (nominal ECSS)
    parameter RX_FRAMES             = 4,
    parameter N_ROUTES              = 4,
    parameter DEFAULT_ERR_THRESHOLD = 8,
    parameter TIMER_CLEAR_LIMIT     = 200,   // 2 us @ 100 MHz (ECSS 5.5.2.3b.1)
    parameter HANDSHAKE_WORDS       = 1023,  // 1023 palavras sem erro (ECSS Fig. 5-29)
    parameter DATA_SCRAMBLED_EN     = 1      // Scrambler de dados ECSS 5.7.6.2 habilitado
)(
    input  wire        clk,
    input  wire        rst_n,

    // ---------------- PHY SerDes (10b paralelo sincrono) ----------------
    output wire        line_driver_en,
    output wire        line_rx_en,
    output wire        cdr_en,
    output wire        invert_rx_polarity,
    input  wire        loss_of_signal,
    output wire [9:0]  tx_10b_symbol,
    input  wire [9:0]  rx_10b_symbol,

    // ---------------- Host: pacotes (N-chars) ----------------
    input  wire [7:0]  h_tx_data,
    input  wire        h_tx_flag,
    input  wire        h_tx_valid,
    output wire        h_tx_ready,
    output wire [7:0]  h_rx_data,
    output wire        h_rx_flag,
    output wire        h_rx_valid,
    input  wire        h_rx_ready,

    // ---------------- Gestao (MIB) ----------------
    input  wire        lane_start,
    input  wire        auto_start,
    input  wire        lane_reset,
    input  wire        parallel_loopback_en,
    input  wire [7:0]  error_threshold,
    input  wire [7:0]  node_addr,
    input  wire        cfg_we,
    input  wire [1:0]  cfg_idx,
    input  wire        cfg_valid,
    input  wire [7:0]  cfg_addr,
    input  wire        cfg_port,

    // ---------------- Status e Diagnostico ----------------
    output wire [2:0]  lane_state,
    output wire        lane_active,
    output wire [15:0] rxerr_count,
    output wire        link_up,
    output wire [3:0]  tx_credit,
    output wire [7:0]  far_end_capabilities,
    output wire [7:0]  cnt_tx_frames,
    output wire [7:0]  cnt_rx_frames,
    output wire [7:0]  cnt_crc_err,
    output wire [7:0]  cnt_seq_err,
    output wire [7:0]  cnt_frame_err,
    output wire [7:0]  cnt_tx_link,
    output wire [7:0]  cnt_tx_local,
    output wire [7:0]  cnt_rx_link,
    output wire [7:0]  cnt_drop,
    output wire [7:0]  cnt_misroute
);

    // Sincronizador de reset para Data Link e Network
    reg [1:0] rst_sync;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) rst_sync <= 2'b00;
        else        rst_sync <= {rst_sync[0], 1'b1};
    end
    wire rst_dl_n = rst_sync[1];

    // Network <-> Data Link (N-chars)
    wire [7:0] n2d_data, d2n_data;
    wire       n2d_flag, n2d_valid, n2d_ready;
    wire       d2n_flag, d2n_valid, d2n_ready;

    // Data Link <-> Lane (palavras ECSS de 32 bits)
    wire [31:0] dl_tx_word, lane_rx_word;
    wire [3:0]  dl_tx_k,    lane_rx_k;
    wire        dl_tx_valid, dl_tx_ready;
    wire        lane_rx_valid, lane_rx_err;
    wire [7:0]  near_end_caps;
    wire        far_end_caps_valid;
    wire        rx_polarity_status_unused;

    sf_network #(
        .N_ROUTES(N_ROUTES)
    ) u_nw (
        .clk          (clk),
        .rst_n        (rst_dl_n),
        .node_addr    (node_addr),
        .cfg_we       (cfg_we),
        .cfg_idx      (cfg_idx),
        .cfg_valid    (cfg_valid),
        .cfg_addr     (cfg_addr),
        .cfg_port     (cfg_port),
        .h_tx_data    (h_tx_data),
        .h_tx_flag    (h_tx_flag),
        .h_tx_valid   (h_tx_valid),
        .h_tx_ready   (h_tx_ready),
        .h_rx_data    (h_rx_data),
        .h_rx_flag    (h_rx_flag),
        .h_rx_valid   (h_rx_valid),
        .h_rx_ready   (h_rx_ready),
        .dl_tx_data   (n2d_data),
        .dl_tx_flag   (n2d_flag),
        .dl_tx_valid  (n2d_valid),
        .dl_tx_ready  (n2d_ready),
        .dl_rx_data   (d2n_data),
        .dl_rx_flag   (d2n_flag),
        .dl_rx_valid  (d2n_valid),
        .dl_rx_ready  (d2n_ready),
        .cnt_tx_link  (cnt_tx_link),
        .cnt_tx_local (cnt_tx_local),
        .cnt_rx_link  (cnt_rx_link),
        .cnt_drop     (cnt_drop),
        .cnt_misroute (cnt_misroute)
    );

    sf_datalink #(
        .MAX_FRAME_BYTES (MAX_FRAME_BYTES),
        .RX_FRAMES       (RX_FRAMES)
    ) u_dl (
        .clk                   (clk),
        .rst_n                 (rst_dl_n),
        .data_scrambled_en     (DATA_SCRAMBLED_EN[0]),
        .lane_active           (lane_active),
        .far_end_capabilities  (far_end_capabilities),
        .far_end_caps_valid    (far_end_caps_valid),
        .near_end_capabilities (near_end_caps),
        .dl_tx_word            (dl_tx_word),
        .dl_tx_k_flags         (dl_tx_k),
        .dl_tx_valid           (dl_tx_valid),
        .dl_tx_ready           (dl_tx_ready),
        .dl_rx_word            (lane_rx_word),
        .dl_rx_k_flags         (lane_rx_k),
        .dl_rx_valid           (lane_rx_valid),
        .dl_rx_err             (lane_rx_err),
        .tx_data               (n2d_data),
        .tx_flag               (n2d_flag),
        .tx_valid              (n2d_valid),
        .tx_ready              (n2d_ready),
        .rx_data               (d2n_data),
        .rx_flag               (d2n_flag),
        .rx_valid              (d2n_valid),
        .rx_ready              (d2n_ready),
        .link_up               (link_up),
        .tx_credit             (tx_credit),
        .cnt_tx_frames         (cnt_tx_frames),
        .cnt_rx_frames         (cnt_rx_frames),
        .cnt_crc_err           (cnt_crc_err),
        .cnt_seq_err           (cnt_seq_err),
        .cnt_frame_err         (cnt_frame_err)
    );

    spacefibre_lane_top #(
        .DEFAULT_ERR_THRESHOLD (DEFAULT_ERR_THRESHOLD),
        .TIMER_CLEAR_LIMIT     (TIMER_CLEAR_LIMIT),
        .HANDSHAKE_WORDS       (HANDSHAKE_WORDS)
    ) u_lane (
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
        .dl_tx_k_flags         (dl_tx_k),
        .dl_tx_valid           (dl_tx_valid),
        .dl_tx_ready           (dl_tx_ready),
        .dl_rx_word            (lane_rx_word),
        .dl_rx_k_flags         (lane_rx_k),
        .dl_rx_valid           (lane_rx_valid),
        .dl_rx_err             (lane_rx_err),
        .lane_active           (lane_active),
        .near_end_capabilities (near_end_caps),
        .far_end_capabilities  (far_end_capabilities),
        .far_end_caps_valid    (far_end_caps_valid),
        .lane_start            (lane_start),
        .auto_start            (auto_start),
        .lane_reset            (lane_reset),
        .parallel_loopback_en  (parallel_loopback_en),
        .error_threshold       (error_threshold),
        .lane_state            (lane_state),
        .rxerr_count           (rxerr_count),
        .rx_polarity_status    (rx_polarity_status_unused)
    );

endmodule
