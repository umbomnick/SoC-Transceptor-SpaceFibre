// ============================================================================
// Projeto  : SoC Transceptor SpaceFibre (Data Link Layer - Framing)
// Arquivo  : rx_deframing.sv
// Padrão   : ECSS-E-ST-50-11C (15 May 2019)
// Função   : Receptor do enquadramento: identificação, conferência e entrega
// Cláusulas: 5.3.6, 5.3.7, 5.3.10, 5.7.6.3.2, 5.7.6.4, 5.7.6.7, 5.7.8
// ============================================================================

`timescale 1ns / 1ps

module rx_deframing #(
    parameter int BUF_AW = 9               // buffer de 2^9 = 512 entradas
) (
    input  logic        rx_clk,
    input  logic        rx_rst_n,
    input  logic        rx_link_up,

    // Descrambler / decodificador 8b/10b
    input  logic [7:0]  rx_data_in,
    input  logic        rx_is_k_char,
    input  logic        rx_valid_in,

    // Camada superior
    output logic [7:0]  rx_data_out,
    output logic        rx_valid_out,
    output logic        rx_last_out,     // último byte do PACOTE
    output logic        rx_frame_error
);

    localparam int MAXW  = spacefibre_pkg::MAX_FRAME_WORDS;
    localparam int DEPTH = 1 << BUF_AW;

    // ---------------- Buffer de quadro ---------------------------------------
    // Entrada = {tipo[1:0], dado[7:0]}
    localparam logic [1:0] E_DATA = 2'd0, E_EOP = 2'd1, E_EEP = 2'd2, E_ERR = 2'd3;
    // Em E_ERR: dado[1] = quadro com dados perdido (sempre avisa)
    //          dado[0] = descartar até o próximo EOP/EEP

    logic [9:0]      mem [0:DEPTH-1];
    logic [BUF_AW:0] wr_ptr;   // escrita especulativa do quadro atual
    logic [BUF_AW:0] cm_ptr;   // fim da parte confirmada
    logic [BUF_AW:0] rd_ptr;   // leitura

    logic            buf_full;
    assign buf_full = ((wr_ptr - rd_ptr) >= (BUF_AW+1)'(DEPTH - 1));

    // ---------------- Identificação de palavras ------------------------------
    typedef enum logic [2:0] {
        ST_NOTHING = 3'd0,   // RxNothing / quadro idle: procura SDF
        ST_SDF     = 3'd1,   // símbolos 1..3 do SDF
        ST_DATA    = 3'd2,   // dentro do quadro de dados
        ST_EDF     = 3'd3,   // símbolos 1..3 do EDF
        ST_SKIPW   = 3'd4,   // resto de palavra de controle inserida
        ST_BCAST   = 3'd5    // broadcast inserido no quadro de dados
    } state_t;

    state_t      state;
    logic [1:0]  sym_idx;
    logic [6:0]  word_cnt;
    logic [15:0] crc;
    logic [7:0]  crc_ls, seq_rx;
    logic        fmt_err;
    logic [6:0]  rx_seq;        // Receive Sequence Counter (5.7.6.3.2a)
    logic        frame_open;    // há símbolos especulativos no buffer
    logic        bc_ebf;        // dentro do broadcast: EBF visto
    logic        skip_nc;       // palavra inserida que não começa com comma
    logic        link_q;        // rx_link_up do ciclo anterior
    logic        wpkt_open;     // no quadro atual, o último N-Char foi dado (pacote aberto)

    logic [15:0] crc_nxt;
    assign crc_nxt = spacefibre_pkg::crc16_byte(crc, rx_data_in);

    // palavra RXERR gerada pela Lane layer
    logic is_rxerr0;
    assign is_rxerr0 = rx_is_k_char && rx_data_in == spacefibre_pkg::K_RXERR;

    // símbolo 0 de uma palavra de controle (não EOP/EEP/Fill, que são de dados)
    logic is_ctrl0;
    assign is_ctrl0 = rx_is_k_char &&
                      rx_data_in != spacefibre_pkg::K_EOP &&
                      rx_data_in != spacefibre_pkg::K_EEP &&
                      rx_data_in != spacefibre_pkg::K_FILL;

    // desfaz o quadro atual e registra um marcador de erro confirmado
    task automatic discard_frame(input logic lost, input logic drop);
        mem[cm_ptr[BUF_AW-1:0]] <= {E_ERR, 6'd0, lost, drop};
        cm_ptr     <= cm_ptr + 1'b1;
        wr_ptr     <= cm_ptr + 1'b1;
        frame_open <= 1'b0;
    endtask

    // ---------------- Escrita --------------------------------------------------
    always_ff @(posedge rx_clk or negedge rx_rst_n) begin
        if (!rx_rst_n) begin
            state      <= ST_NOTHING;
            wr_ptr     <= '0;
            cm_ptr     <= '0;
            sym_idx    <= 2'd0;
            word_cnt   <= 7'd0;
            crc        <= spacefibre_pkg::CRC16_INIT;
            crc_ls     <= 8'h00;
            seq_rx     <= 8'h00;
            fmt_err    <= 1'b0;
            rx_seq     <= 7'd0;
            frame_open <= 1'b0;
            bc_ebf     <= 1'b0;
            skip_nc    <= 1'b0;
            link_q     <= 1'b0;
            wpkt_open  <= 1'b1;
        end else if (!rx_link_up) begin
            // link reset (5.7.8.2a.1, 5.7.6.3.2e/f): desfaz o quadro em curso e
            // avisa a leitura uma única vez (marcador sem descarte extra)
            link_q <= 1'b0;
            if (link_q)
                discard_frame(1'b0, 1'b0);
            state  <= ST_NOTHING;
            rx_seq <= 7'd0;
        end else if (rx_valid_in || !link_q) begin
            link_q <= 1'b1;
            if (rx_valid_in) begin
            case (state)
                // ------------------------------------------------------------
                ST_NOTHING: begin
                    // SDF reconhecido pelo comma; SIF/PRBS e demais são ignorados
                    if (rx_is_k_char && rx_data_in == spacefibre_pkg::K_COMMA) begin
                        crc     <= spacefibre_pkg::crc16_byte(spacefibre_pkg::CRC16_INIT, rx_data_in);
                        sym_idx <= 2'd1;
                        fmt_err <= 1'b0;
                        state   <= ST_SDF;
                    end
                end

                // ------------------------------------------------------------
                ST_SDF: begin
                    crc     <= crc_nxt;
                    sym_idx <= sym_idx + 2'd1;
                    if (sym_idx == 2'd1) begin
                        // SIF, SBF ou outra palavra com comma: não é quadro de dados
                        if (rx_is_k_char || rx_data_in != spacefibre_pkg::D_SDF)
                            state <= ST_NOTHING;
                    end else begin
                        // VC 0..31 (5.3.5); reservado é ignorado (5.3.8.2f)
                        if (rx_is_k_char || (sym_idx == 2'd2 && rx_data_in[7:5] != 3'b000))
                            fmt_err <= 1'b1;
                        if (sym_idx == 2'd3) begin
                            wr_ptr     <= cm_ptr;
                            word_cnt   <= 7'd0;
                            wpkt_open  <= 1'b1;   // sem EOP no quadro => pacote segue aberto
                            frame_open <= 1'b1;
                            state      <= ST_DATA;
                        end
                    end
                end

                // ------------------------------------------------------------
                ST_DATA: begin
                    if (sym_idx == 2'd0 && is_ctrl0) begin
                        // palavra de controle no início de palavra
                        if (is_rxerr0) begin
                            // RXERR dentro do quadro: erro de quadro (5.7.8)
                            discard_frame(1'b1, 1'b1);
                            state <= ST_NOTHING;
                        end else if (rx_data_in == spacefibre_pkg::K_EDF) begin
                            crc     <= crc_nxt;
                            sym_idx <= 2'd1;
                            state   <= ST_EDF;
                        end else if (rx_data_in == spacefibre_pkg::K_COMMA) begin
                            // SDF/SIF/SBF: decide no próximo símbolo
                            sym_idx <= 2'd1;
                            state   <= ST_SKIPW;
                            skip_nc <= 1'b0;
                        end else begin
                            // FCT, ACK, NACK, ... ou desconhecida: ignora (5.7.8b)
                            sym_idx <= 2'd1;
                            state   <= ST_SKIPW;
                            skip_nc <= 1'b1;
                        end
                    end else begin
                        // símbolo de palavra de dados
                        if (sym_idx == 2'd0 && word_cnt == 7'(MAXW))
                            fmt_err <= 1'b1;                // > 64 palavras (5.3.8.2c)
                        if (sym_idx == 2'd3)
                            word_cnt <= word_cnt + 7'd1;
                        sym_idx <= sym_idx + 2'd1;
                        crc     <= crc_nxt;

                        if (buf_full) begin
                            fmt_err <= 1'b1;
                        end else if (!rx_is_k_char) begin
                            mem[wr_ptr[BUF_AW-1:0]] <= {E_DATA, rx_data_in};
                            wr_ptr    <= wr_ptr + 1'b1;
                            wpkt_open <= 1'b1;
                        end else if (rx_data_in == spacefibre_pkg::K_EOP) begin
                            mem[wr_ptr[BUF_AW-1:0]] <= {E_EOP, 8'h00};
                            wr_ptr    <= wr_ptr + 1'b1;
                            wpkt_open <= 1'b0;
                        end else if (rx_data_in == spacefibre_pkg::K_EEP) begin
                            mem[wr_ptr[BUF_AW-1:0]] <= {E_EEP, 8'h00};
                            wr_ptr    <= wr_ptr + 1'b1;
                            wpkt_open <= 1'b0;
                        end else if (rx_data_in == spacefibre_pkg::K_FILL) begin
                            // Fill entra no CRC; não é entregue (a interface não o transporta)
                        end else begin
                            fmt_err <= 1'b1;                // K-code no meio da palavra
                        end
                    end
                end

                // ------------------------------------------------------------
                ST_SKIPW: begin
                    // palavra começou com comma: o símbolo 1 diz qual é
                    sym_idx <= sym_idx + 2'd1;
                    if (sym_idx == 2'd1 && !skip_nc) begin
                        if (!rx_is_k_char && rx_data_in == spacefibre_pkg::D_SBF) begin
                            bc_ebf <= 1'b0;
                            state  <= ST_BCAST;             // broadcast inserido (5.3.10j)
                        end else if (!rx_is_k_char &&
                                     (rx_data_in == spacefibre_pkg::D_SDF ||
                                      rx_data_in == spacefibre_pkg::D_SIF)) begin
                            // SDF/SIF dentro de quadro de dados: Frame Error (Fig. 5-49)
                            discard_frame(1'b1, 1'b1);
                            state <= ST_NOTHING;
                        end
                    end else if (sym_idx == 2'd3) begin
                        state <= ST_DATA;
                    end
                end

                // ------------------------------------------------------------
                ST_BCAST: begin
                    // salta SBF..EBF; o conteúdo do broadcast não é entregue
                    sym_idx <= sym_idx + 2'd1;
                    if (sym_idx == 2'd0 && is_rxerr0) begin
                        discard_frame(1'b1, 1'b1);         // RXERR (5.7.8)
                        state <= ST_NOTHING;
                    end
                    if (sym_idx == 2'd0 && rx_is_k_char && rx_data_in == spacefibre_pkg::K_EBF)
                        bc_ebf <= 1'b1;
                    if (sym_idx == 2'd3 && bc_ebf) begin
                        bc_ebf <= 1'b0;
                        state  <= ST_DATA;
                    end
                end

                // ------------------------------------------------------------
                ST_EDF: begin
                    sym_idx <= sym_idx + 2'd1;
                    case (sym_idx)
                        2'd1: begin crc <= crc_nxt; seq_rx <= rx_data_in;
                                    if (rx_is_k_char) fmt_err <= 1'b1; end
                        2'd2: begin crc_ls <= rx_data_in;
                                    if (rx_is_k_char) fmt_err <= 1'b1; end
                        default: begin
                            if (fmt_err || rx_is_k_char || {rx_data_in, crc_ls} != crc) begin
                                // CRC ou formato errado: descarta (5.7.6.7b).
                                // Conteúdo não confiável: descarta até o próximo EOP.
                                discard_frame(1'b1, 1'b1);
                            end else if (seq_rx != {1'b0, rx_seq + 7'd1}) begin
                                // fora de sequência: descarta (5.7.6.3.2n).
                                // O CRC está correto, então dá para saber se o
                                // quadro terminava com um pacote aberto.
                                discard_frame(1'b1, wpkt_open);
                                // PROVISÓRIO: sem recuperação de erro (5.7.7) o
                                // contador é ressincronizado, senão todos os
                                // quadros seguintes seriam descartados.
                                rx_seq <= seq_rx[6:0];
                            end else begin
                                // quadro aceito: confirma os dados (5.7.6.7a)
                                cm_ptr     <= wr_ptr;
                                frame_open <= 1'b0;
                                rx_seq     <= rx_seq + 7'd1;   // 5.7.6.3.2m
                            end
                            state <= ST_NOTHING;
                        end
                    endcase
                end

                default: state <= ST_NOTHING;
            endcase
            end
        end
    end

    // ---------------- Leitura e entrega à camada superior ---------------------
    logic [9:0] ent;
    logic [7:0] hold_data;
    logic       hold_valid;
    logic       dropping;
    logic       in_pkt;        // já entregou (ou retém) bytes do pacote atual

    assign ent = mem[rd_ptr[BUF_AW-1:0]];

    always_ff @(posedge rx_clk or negedge rx_rst_n) begin
        if (!rx_rst_n) begin
            rd_ptr         <= '0;
            hold_data      <= 8'h00;
            hold_valid     <= 1'b0;
            dropping       <= 1'b0;
            in_pkt         <= 1'b0;
            rx_data_out    <= 8'h00;
            rx_valid_out   <= 1'b0;
            rx_last_out    <= 1'b0;
            rx_frame_error <= 1'b0;
        end else begin
            rx_valid_out   <= 1'b0;
            rx_last_out    <= 1'b0;
            rx_frame_error <= 1'b0;

            if (rd_ptr != cm_ptr) begin
                rd_ptr <= rd_ptr + 1'b1;
                case (ent[9:8])
                    E_DATA: if (!dropping) begin
                        // retém um byte para poder marcar o último com rx_last_out
                        if (hold_valid) begin
                            rx_data_out  <= hold_data;
                            rx_valid_out <= 1'b1;
                        end
                        hold_data  <= ent[7:0];
                        hold_valid <= 1'b1;
                        in_pkt     <= 1'b1;
                    end
                    E_EOP, E_EEP: begin
                        if (dropping) begin
                            dropping <= 1'b0;          // pacote danificado terminou
                        end else if (hold_valid) begin
                            rx_data_out    <= hold_data;
                            rx_valid_out   <= 1'b1;
                            rx_last_out    <= 1'b1;
                            rx_frame_error <= (ent[9:8] == E_EEP);
                        end
                        hold_valid <= 1'b0;
                        in_pkt     <= 1'b0;
                    end
                    default: begin                     // E_ERR
                        // quadro perdido: sempre avisa;
                        // link reset: só avisa se havia pacote em andamento
                        rx_frame_error <= ent[1] | in_pkt | dropping;
                        hold_valid     <= 1'b0;
                        in_pkt         <= 1'b0;
                        dropping       <= ent[0];
                    end
                endcase
            end
        end
    end

endmodule