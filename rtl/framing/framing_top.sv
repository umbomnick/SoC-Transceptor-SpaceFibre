// ============================================================================
// Projeto  : SoC Transceptor SpaceFibre (Data Link Layer - Framing)
// Arquivo  : framing_top.sv
// Padrão   : ECSS-E-ST-50-11C (15 May 2019)
// Função   : Topo de simulação: loopback TX -> RX do enquadramento
// Cláusulas: -
// ============================================================================

`timescale 1ns / 1ps

// ============================================================================
module framing_top (
    // Clocks da ICD (125 MHz)
    input  logic        tx_clk,          // ID 2 da ICD
    input  logic        rx_clk,          // ID 6 da ICD

    // Resets da ICD
    input  logic        tx_rst_n,        // Reset sincronizado a tx_clk
    input  logic        rx_rst_n,        // Reset sincronizado a rx_clk

    // Status da PHY / Lane FSM
    input  spacefibre_pkg::link_state_t link_state,
    input  logic        rx_link_up,

    // Interface Superior de TX
    input  logic [7:0]  tx_data_in,
    input  logic        tx_valid_in,
    input  logic        tx_last_in,
    output logic        tx_ready_out,
    output logic        tx_abort_out,

    // Símbolos do framer (visíveis na simulação)
    output logic [7:0]  lane_data,
    output logic        lane_is_k,
    output logic        lane_valid,

    // Interface com a Lane layer (palavras de 32 bits)
    output logic [31:0] dl_tx_data,
    output logic [3:0]  dl_tx_ctrl,
    output logic        dl_tx_valid,
    input  logic        dl_tx_ready,          // contrapressão da Lane layer
    input  logic        dl_rx_err,            // erro do decodificador na palavra (teste)
    output logic        rx_overflow,

    // Interface Superior de RX
    output logic [7:0]  rx_data_out,
    output logic        rx_valid_out,
    output logic        rx_last_out,
    output logic        rx_frame_error
);

    logic       framer_en;
    logic [7:0] rx_sym;
    logic       rx_sym_k, rx_sym_v;

    tx_framing u_tx (
        .tx_clk         (tx_clk),
        .tx_rst_n       (tx_rst_n),
        .link_state     (link_state),
        .tx_en          (framer_en),
        .tx_data_in     (tx_data_in),
        .tx_valid_in    (tx_valid_in),
        .tx_last_in     (tx_last_in),
        .tx_ready_out   (tx_ready_out),
        .tx_abort_out   (tx_abort_out),
        .tx_data_out    (lane_data),
        .tx_is_k_char   (lane_is_k),
        .tx_valid_out   (lane_valid)
    );

    tx_word_packer u_pack (
        .clk         (tx_clk),
        .rst_n       (tx_rst_n),
        .link_active (link_state == spacefibre_pkg::LINK_ACTIVE),
        .sym_data    (lane_data),
        .sym_is_k    (lane_is_k),
        .sym_valid   (lane_valid),
        .framer_en   (framer_en),
        .tx_data     (dl_tx_data),
        .tx_ctrl     (dl_tx_ctrl),
        .tx_valid    (dl_tx_valid),
        .tx_ready    (dl_tx_ready)
    );

    rx_word_unpacker u_unpack (
        .clk         (rx_clk),
        .rst_n       (rx_rst_n),
        .link_up     (rx_link_up),
        .rx_data     (dl_tx_data),
        .rx_ctrl     (dl_tx_ctrl),
        .rx_valid    (dl_tx_valid & dl_tx_ready),
        .rx_err      (dl_rx_err),
        .rx_overflow (rx_overflow),
        .sym_data    (rx_sym),
        .sym_is_k    (rx_sym_k),
        .sym_valid   (rx_sym_v)
    );

    rx_deframing u_rx (
        .rx_clk         (rx_clk),
        .rx_rst_n       (rx_rst_n),
        .rx_link_up     (rx_link_up),
        .rx_data_in     (rx_sym),
        .rx_is_k_char   (rx_sym_k),
        .rx_valid_in    (rx_sym_v),
        .rx_data_out    (rx_data_out),
        .rx_valid_out   (rx_valid_out),
        .rx_last_out    (rx_last_out),
        .rx_frame_error (rx_frame_error)
    );

    `ifdef COCOTB_SIM
    initial begin
        $dumpfile("waves/dump.vcd");
        $dumpvars(0, framing_top);
    end
    `endif

endmodule