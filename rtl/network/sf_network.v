// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/network/sf_network.v
// Padrao : ECSS-E-ST-50-11C (Clausula 5.8.3 e Tabela 5-35)
// Funcao : Network Layer wormhole com suporte a:
//          - Path Addressing (0x00 = Porta Local 0, 0x01 = Porta Link 1) com
//            remocao do byte de cabecalho (header deletion, 5.8.3.1b/e)
//          - Logical Addressing (0x20..0xFE) preservando cabecalho via node_addr
//            e tabela de rotas estatica (5.8.3.2b), 0xFF reservado (descartado)
//          - Arbitro de saida round-robin atomico por pacote para o Host RX
// ============================================================================
`timescale 1ns / 1ps

module sf_network #(
    parameter N_ROUTES = 4
)(
    input  wire        clk,
    input  wire        rst_n,

    // Configuracao
    input  wire [7:0]  node_addr,
    input  wire        cfg_we,
    input  wire [1:0]  cfg_idx,
    input  wire        cfg_valid,
    input  wire [7:0]  cfg_addr,
    input  wire        cfg_port,     // 0: LOCAL, 1: LINK

    // Host TX (pacotes a enviar)
    input  wire [7:0]  h_tx_data,
    input  wire        h_tx_flag,
    input  wire        h_tx_valid,
    output wire        h_tx_ready,

    // Host RX (pacotes recebidos)
    output wire [7:0]  h_rx_data,
    output wire        h_rx_flag,
    output wire        h_rx_valid,
    input  wire        h_rx_ready,

    // Data Link Layer
    output wire [7:0]  dl_tx_data,
    output wire        dl_tx_flag,
    output wire        dl_tx_valid,
    input  wire        dl_tx_ready,
    input  wire [7:0]  dl_rx_data,
    input  wire        dl_rx_flag,
    input  wire        dl_rx_valid,
    output wire        dl_rx_ready,

    // Contadores de Diagnostico
    output reg  [7:0]  cnt_tx_link,
    output reg  [7:0]  cnt_tx_local,
    output reg  [7:0]  cnt_rx_link,
    output reg  [7:0]  cnt_drop,
    output reg  [7:0]  cnt_misroute
);

    localparam P_LOCAL = 1'b0, P_LINK = 1'b1;

    // ------------------------------------------------------------------------
    // Tabela de rotas estatica (enderecos logicos 0x20..0xFE)
    // ------------------------------------------------------------------------
    reg       rt_valid [0:N_ROUTES-1];
    reg [7:0] rt_addr  [0:N_ROUTES-1];
    reg       rt_port  [0:N_ROUTES-1];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < N_ROUTES; i = i + 1) begin
                rt_valid[i] <= 1'b0;
                rt_addr[i]  <= 8'd0;
                rt_port[i]  <= 1'b0;
            end
        end else if (cfg_we) begin
            rt_valid[cfg_idx] <= cfg_valid;
            rt_addr[cfg_idx]  <= cfg_addr;
            rt_port[cfg_idx]  <= cfg_port;
        end
    end

    // Consulta combinacional ECSS Tabela 5-35: retorna {is_path, hit, port}
    function [2:0] lookup_ecss(input [7:0] a);
        integer j;
        begin
            lookup_ecss = 3'b000;
            if (a < 8'h20) begin
                // Path Addressing: 0x00 -> Porta 0 (Local), 0x01 -> Porta 1 (Link)
                if (a == 8'h00)      lookup_ecss = {1'b1, 1'b1, P_LOCAL};
                else if (a == 8'h01) lookup_ecss = {1'b1, 1'b1, P_LINK};
                else                 lookup_ecss = {1'b1, 1'b0, P_LOCAL};
            end else if (a == 8'hFF) begin
                // 0xFF reservado pela ECSS (Tabela 5-35)
                lookup_ecss = 3'b000;
            end else if (a == node_addr) begin
                lookup_ecss = {1'b0, 1'b1, P_LOCAL};
            end else begin
                for (j = N_ROUTES - 1; j >= 0; j = j - 1)
                    if (rt_valid[j] && (rt_addr[j] == a))
                        lookup_ecss = {1'b0, 1'b1, rt_port[j]};
            end
        end
    endfunction

    // ------------------------------------------------------------------------
    // Caminho TX (Host -> LOCAL / LINK / Descarte)
    // ------------------------------------------------------------------------
    localparam [1:0] S_HDR = 2'd0, S_LINK = 2'd1, S_LOCAL = 2'd2, S_DROP = 2'd3;
    reg [1:0] tx_st;
    reg       tx_first_after_strip;

    wire [2:0] tx_lk       = lookup_ecss(h_tx_data);
    wire       tx_hdr_strip = (tx_st == S_HDR) && h_tx_valid && !h_tx_flag && tx_lk[2] && tx_lk[1];
    wire       tx_empty_pkt = tx_first_after_strip && h_tx_valid && h_tx_flag;

    wire lb_valid = (tx_st == S_LOCAL) && h_tx_valid && !tx_empty_pkt;
    wire lb_ready;

    assign dl_tx_data  = h_tx_data;
    assign dl_tx_flag  = h_tx_flag;
    assign dl_tx_valid = (tx_st == S_LINK) && h_tx_valid && !tx_empty_pkt;

    assign h_tx_ready = tx_hdr_strip       ? 1'b1        :
                        tx_empty_pkt       ? 1'b1        :
                        (tx_st == S_LINK)  ? dl_tx_ready :
                        (tx_st == S_LOCAL) ? lb_ready    :
                        (tx_st == S_DROP);

    wire tx_fire = h_tx_valid && h_tx_ready;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_st                <= S_HDR;
            tx_first_after_strip <= 1'b0;
            cnt_tx_link          <= 8'd0;
            cnt_tx_local         <= 8'd0;
            cnt_drop             <= 8'd0;
        end else begin
            case (tx_st)
                S_HDR: if (h_tx_valid) begin
                    if (h_tx_flag || !tx_lk[1]) begin
                        tx_st                <= S_DROP;
                        tx_first_after_strip <= 1'b0;
                        cnt_drop             <= cnt_drop + 8'd1;
                    end else begin
                        tx_st                <= tx_lk[0] ? S_LINK : S_LOCAL;
                        tx_first_after_strip <= tx_lk[2];
                    end
                end
                default: if (tx_fire) begin
                    tx_first_after_strip <= 1'b0;
                    if (h_tx_flag) begin
                        tx_st <= S_HDR;
                        if (tx_empty_pkt) begin
                            cnt_drop <= cnt_drop + 8'd1;
                        end else begin
                            if (tx_st == S_LINK)  cnt_tx_link  <= cnt_tx_link  + 8'd1;
                            if (tx_st == S_LOCAL) cnt_tx_local <= cnt_tx_local + 8'd1;
                        end
                    end
                end
            endcase
        end
    end

    // ------------------------------------------------------------------------
    // Caminho RX (Link -> Host ou Descarte)
    // ------------------------------------------------------------------------
    localparam [1:0] R_HDR = 2'd0, R_DELIVER = 2'd1, R_DROP = 2'd2;
    reg [1:0] rx_st;
    reg       rx_first_after_strip;

    wire [2:0] rx_lk        = lookup_ecss(dl_rx_data);
    wire       rx_deliver_ok = !dl_rx_flag && rx_lk[1] && (rx_lk[0] == P_LOCAL);
    wire       rx_hdr_strip  = (rx_st == R_HDR) && dl_rx_valid && rx_deliver_ok && rx_lk[2];
    wire       rx_empty_pkt  = rx_first_after_strip && dl_rx_valid && dl_rx_flag;

    wire ln_valid = (rx_st == R_DELIVER) && dl_rx_valid && !rx_empty_pkt;
    wire ln_ready;

    assign dl_rx_ready = rx_hdr_strip         ? 1'b1     :
                         rx_empty_pkt         ? 1'b1     :
                         (rx_st == R_DELIVER) ? ln_ready :
                         (rx_st == R_DROP);

    wire rx_fire = dl_rx_valid && dl_rx_ready;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_st                <= R_HDR;
            rx_first_after_strip <= 1'b0;
            cnt_rx_link          <= 8'd0;
            cnt_misroute         <= 8'd0;
        end else begin
            case (rx_st)
                R_HDR: if (dl_rx_valid) begin
                    if (rx_deliver_ok) begin
                        rx_st                <= R_DELIVER;
                        rx_first_after_strip <= rx_lk[2];
                    end else begin
                        rx_st                <= R_DROP;
                        rx_first_after_strip <= 1'b0;
                        if (!dl_rx_flag) cnt_misroute <= cnt_misroute + 8'd1;
                    end
                end
                R_DELIVER: if (rx_fire) begin
                    rx_first_after_strip <= 1'b0;
                    if (dl_rx_flag) begin
                        rx_st <= R_HDR;
                        if (!rx_empty_pkt)
                            cnt_rx_link <= cnt_rx_link + 8'd1;
                    end
                end
                default: if (rx_fire && dl_rx_flag) rx_st <= R_HDR;
            endcase
        end
    end

    // ------------------------------------------------------------------------
    // Arbitro de saida para o Host RX (round-robin, atomico por pacote)
    // ------------------------------------------------------------------------
    reg  owner_valid;
    reg  owner;
    reg  last;

    wire want_lb = lb_valid;
    wire want_ln = ln_valid;
    wire pick    = (want_lb && want_ln) ? ~last : want_ln;
    wire sel     = owner_valid ? owner : pick;
    wire any     = owner_valid ? (owner ? want_ln : want_lb) : (want_lb || want_ln);

    assign h_rx_valid = any;
    assign h_rx_data  = sel ? dl_rx_data : h_tx_data;
    assign h_rx_flag  = sel ? dl_rx_flag : h_tx_flag;
    assign lb_ready   = h_rx_ready && any && (sel == 1'b0);
    assign ln_ready   = h_rx_ready && any && (sel == 1'b1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            owner_valid <= 1'b0;
            owner       <= 1'b0;
            last        <= 1'b0;
        end else if (any && h_rx_ready) begin
            if (h_rx_flag) begin
                owner_valid <= 1'b0;
                last        <= sel;
            end else begin
                owner_valid <= 1'b1;
                owner       <= sel;
            end
        end
    end

endmodule
