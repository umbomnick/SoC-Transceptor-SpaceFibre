// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/rx_word_sync.v
// Padrao : ECSS-E-ST-50-11C (Clausulas 5.5.7 e 5.5.8, Figura 5-30)
// Funcao : Sincronizador de Palavras de 32 bits (4 simbolos) + Maquina de
//          Sincronizacao RX (LostSync / CheckSync / Ready) + substituicao
//          da palavra atual e anterior por RXERR em erro de simbolo (5.5.7l).
// ============================================================================
`timescale 1ns / 1ps

module rx_word_sync (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        sync_reset,    // Forca retorno a LostSync (sem sinal / inversao)
    input  wire        sym_valid,     // Simbolo valido do decodificador 8b/10b
    input  wire [7:0]  sym_byte,      // Byte decodificado
    input  wire        sym_k,         // Flag D/K decodificada
    input  wire        sym_err,       // code_err | disp_err no simbolo
    output wire        sync_ready,    // 1: FSM no estado Ready (RxSynchronised)
    output reg         realign_req,   // Pulso para word_aligner refazer bit-slip
    output reg         word_valid,    // Pulso: palavra de 32 bits pronta
    output reg  [31:0] word_out,      // {Byte3, Byte2, Byte1, Byte0}
    output reg  [3:0]  word_k_out,    // {k3, k2, k1, k0}
    output reg         word_err_out   // 1: palavra substituida por RXERR (5.5.7j/k/l)
);

    localparam [1:0] SYNC_LOST  = 2'd0,
                     SYNC_CHECK = 2'd1,
                     SYNC_READY = 2'd2;

    reg [1:0] sync_st;
    reg [2:0] check_err_cnt;
    reg [1:0] sym_idx;

    reg [7:0] b0, b1, b2;
    reg       k0, k1, k2;
    reg       cur_err;

    // Estagio de retencao de 1 palavra para aplicar ECSS 5.5.7l
    // (erro na palavra N invalida tambem a palavra N-1 retida)
    reg        hold_valid;
    reg [31:0] hold_word;
    reg [3:0]  hold_k;
    reg        hold_err;

    assign sync_ready = (sync_st == SYNC_READY);

    wire is_comma = sym_valid && !sym_err && sym_k &&
                    ((sym_byte == 8'hBC) || (sym_byte == 8'hFC));

    wire [31:0] full_word = {sym_byte, b2, b1, b0};
    wire [3:0]  full_k    = {sym_k, k2, k1, k0};
    wire        full_err  = cur_err | sym_err;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_st       <= SYNC_LOST;
            check_err_cnt <= 3'd0;
            sym_idx       <= 2'd0;
            b0 <= 8'd0; b1 <= 8'd0; b2 <= 8'd0;
            k0 <= 1'b0; k1 <= 1'b0; k2 <= 1'b0;
            cur_err       <= 1'b0;
            hold_valid    <= 1'b0;
            hold_word     <= 32'd0;
            hold_k        <= 4'd0;
            hold_err      <= 1'b0;
            realign_req   <= 1'b0;
            word_valid    <= 1'b0;
            word_out      <= 32'd0;
            word_k_out    <= 4'd0;
            word_err_out  <= 1'b0;
        end else begin
            realign_req <= 1'b0;
            word_valid  <= 1'b0;

            if (sync_reset) begin
                sync_st       <= SYNC_LOST;
                check_err_cnt <= 3'd0;
                sym_idx       <= 2'd0;
                cur_err       <= 1'b0;
                hold_valid    <= 1'b0;
                hold_err      <= 1'b0;
            end else if (sym_valid) begin
                if (sync_st == SYNC_LOST) begin
                    hold_valid <= 1'b0;
                    if (is_comma) begin
                        b0            <= sym_byte;
                        k0            <= 1'b1;
                        cur_err       <= 1'b0;
                        sym_idx       <= 2'd1;
                        sync_st       <= SYNC_CHECK;
                        check_err_cnt <= 3'd0;
                    end
                end else if (is_comma && (sym_idx != 2'd0)) begin
                    // ECSS 5.5.7g: Comma fora da posicao Byte0 -> realinha palavra e sinaliza RXERR
                    if (hold_valid) begin
                        word_valid   <= 1'b1;
                        word_out     <= 32'h0000_0000;
                        word_k_out   <= 4'b0001;
                        word_err_out <= 1'b1;
                    end
                    hold_valid <= 1'b1;
                    hold_word  <= 32'h0000_0000;
                    hold_k     <= 4'b0001;
                    hold_err   <= 1'b1;

                    b0      <= sym_byte;
                    k0      <= 1'b1;
                    cur_err <= 1'b0;
                    sym_idx <= 2'd1;

                    if (sync_st == SYNC_READY) begin
                        sync_st       <= SYNC_CHECK;
                        check_err_cnt <= 3'd1;
                    end else if (check_err_cnt >= 3'd4) begin
                        sync_st       <= SYNC_LOST;
                        hold_valid    <= 1'b0;
                        realign_req   <= 1'b1;
                    end else begin
                        check_err_cnt <= check_err_cnt + 3'd1;
                    end
                end else begin
                    case (sym_idx)
                        2'd0: begin
                            b0      <= sym_byte;
                            k0      <= sym_k;
                            cur_err <= sym_err;
                            sym_idx <= 2'd1;
                        end
                        2'd1: begin
                            b1      <= sym_byte;
                            k1      <= sym_k;
                            cur_err <= cur_err | sym_err;
                            sym_idx <= 2'd2;
                        end
                        2'd2: begin
                            b2      <= sym_byte;
                            k2      <= sym_k;
                            cur_err <= cur_err | sym_err;
                            sym_idx <= 2'd3;
                        end
                        2'd3: begin
                            sym_idx <= 2'd0;
                            cur_err <= 1'b0;

                            // Emite a palavra retida N-1 (com ECSS 5.5.7l se full_err == 1)
                            if (hold_valid) begin
                                word_valid   <= 1'b1;
                                word_err_out <= hold_err | full_err;
                                word_out     <= (hold_err | full_err) ? 32'h0000_0000 : hold_word;
                                word_k_out   <= (hold_err | full_err) ? 4'b0001       : hold_k;
                            end

                            // Retem a palavra atual N
                            hold_valid <= 1'b1;
                            hold_word  <= full_err ? 32'h0000_0000 : full_word;
                            hold_k     <= full_err ? 4'b0001       : full_k;
                            hold_err   <= full_err;

                            // Atualizacao da Receive Sync FSM (Figura 5-30)
                            if (sync_st == SYNC_CHECK) begin
                                if (!full_err) begin
                                    sync_st       <= SYNC_READY;
                                    check_err_cnt <= 3'd0;
                                end else if (check_err_cnt >= 3'd4) begin
                                    sync_st     <= SYNC_LOST;
                                    hold_valid  <= 1'b0;
                                    realign_req <= 1'b1;
                                end else begin
                                    check_err_cnt <= check_err_cnt + 3'd1;
                                end
                            end else if (sync_st == SYNC_READY) begin
                                if (full_err) begin
                                    sync_st       <= SYNC_CHECK;
                                    check_err_cnt <= 3'd1;
                                end
                            end
                        end
                    endcase
                end
            end
        end
    end

endmodule
