// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/llcw_processor.v
// Padrao : ECSS-E-ST-50-11C (Clausula 5.3.3 e Tabela 5-3)
// Funcao : Processador de Lane Layer Control Words (LLCW) com codificacao
//          normativa ECSS (D14.6=8'hCE, D17.1=8'h31, INIT1/iINIT1/INIT2/
//          iINIT2/INIT3/SKIP/IDLE/STANDBY/LOST_SIGNAL).
// ============================================================================
`timescale 1ns / 1ps

module llcw_processor (
    input  wire        clk,
    input  wire        rst_n,

    // Montador TX (combinacional para selecao direta no serializador de palavra)
    input  wire        tx_send_cmd,
    input  wire [3:0]  tx_cmd_type,
    input  wire [7:0]  tx_capabilities_in,
    input  wire [7:0]  tx_reason_in,
    output reg  [31:0] tx_llcw_word,
    output reg  [3:0]  tx_llcw_k_flags,
    output reg         tx_word_valid,

    // Decodificador RX (opera sobre palavra de 32 bits do Elastic Buffer)
    input  wire [31:0] rx_word_in,
    input  wire [3:0]  rx_k_in,
    input  wire        rx_word_valid,
    input  wire        rx_word_err,
    output reg         rx_is_llcw_space,    // 1: palavra pertence ao espaco LLCW da Lane
    output reg         rx_cmd_valid,        // 1: LLCW valida reconhecida
    output reg  [3:0]  rx_cmd_type,
    output reg  [7:0]  rx_capabilities_out,
    output reg         rx_caps_valid,
    output reg         rx_llcw_err          // 1: LLCW malformada (K28.5 ou K28.7+D14.6 invalida)
);

    // Codigos de comando internos
    localparam [3:0] CMD_NONE        = 4'd0,
                     CMD_INIT1       = 4'd1,
                     CMD_IINIT1      = 4'd2,
                     CMD_INIT2       = 4'd3,
                     CMD_IINIT2      = 4'd4,
                     CMD_INIT3       = 4'd5,
                     CMD_SKIP        = 4'd6,
                     CMD_IDLE        = 4'd7,
                     CMD_STANDBY     = 4'd8,
                     CMD_LOST_SIGNAL = 4'd9;

    // Simbolos normativos ECSS-E-ST-50-11C Tabela 5-3 ({y[2:0], x[4:0]})
    localparam [7:0] SYM_K28_5 = 8'hBC, // Inicializacao Comma
                     SYM_K28_7 = 8'hFC, // Comma normal
                     SYM_D14_6 = 8'hCE, // {3'd6, 5'd14} marcador LLCW
                     SYM_D17_1 = 8'h31, // {3'd1, 5'd17} marcador LLCW invertido (~D14.6)
                     SYM_D6_2  = 8'h46, // {3'd2, 5'd6}  INIT1
                     SYM_D25_5 = 8'hB9, // {3'd5, 5'd25} iINIT1 (~D6.2)
                     SYM_D6_5  = 8'hA6, // {3'd5, 5'd6}  INIT2
                     SYM_D25_2 = 8'h59, // {3'd2, 5'd25} iINIT2 (~D6.5)
                     SYM_D24_1 = 8'h38, // {3'd1, 5'd24} INIT3
                     SYM_D31_3 = 8'h7F, // {3'd3, 5'd31} SKIP
                     SYM_D15_6 = 8'hCF, // {3'd6, 5'd15} IDLE
                     SYM_D30_3 = 8'h7E, // {3'd3, 5'd30} STANDBY
                     SYM_D4_3  = 8'h64; // {3'd3, 5'd4}  LOST_SIGNAL

    // ------------------------------------------------------------------------
    // Montador TX (combinacional)
    // ------------------------------------------------------------------------
    always @(*) begin
        tx_word_valid   = tx_send_cmd;
        tx_llcw_k_flags = 4'b0001;
        tx_llcw_word    = {SYM_D15_6, SYM_D15_6, SYM_D14_6, SYM_K28_7};

        if (tx_send_cmd) begin
            case (tx_cmd_type)
                CMD_INIT1:       tx_llcw_word = {SYM_D6_2,  SYM_D6_2,  SYM_D14_6, SYM_K28_5};
                CMD_IINIT1:      tx_llcw_word = {SYM_D25_5, SYM_D25_5, SYM_D17_1, SYM_K28_5};
                CMD_INIT2:       tx_llcw_word = {SYM_D6_5,  SYM_D6_5,  SYM_D14_6, SYM_K28_5};
                CMD_IINIT2:      tx_llcw_word = {SYM_D25_2, SYM_D25_2, SYM_D17_1, SYM_K28_5};
                CMD_INIT3:       tx_llcw_word = {tx_capabilities_in, SYM_D24_1, SYM_D14_6, SYM_K28_5};
                CMD_SKIP:        tx_llcw_word = {SYM_D31_3, SYM_D31_3, SYM_D14_6, SYM_K28_7};
                CMD_IDLE:        tx_llcw_word = {SYM_D15_6, SYM_D15_6, SYM_D14_6, SYM_K28_7};
                CMD_STANDBY:     tx_llcw_word = {tx_reason_in, SYM_D30_3, SYM_D14_6, SYM_K28_7};
                CMD_LOST_SIGNAL: tx_llcw_word = {tx_reason_in, SYM_D4_3,  SYM_D14_6, SYM_K28_7};
                default: begin
                    tx_word_valid   = 1'b0;
                    tx_llcw_k_flags = 4'b0000;
                    tx_llcw_word    = 32'd0;
                end
            endcase
        end else begin
            tx_llcw_k_flags = 4'b0000;
            tx_llcw_word    = 32'd0;
        end
    end

    // ------------------------------------------------------------------------
    // Decodificador RX (combinacional para filtragem alinhada + latch de INIT3)
    // Nota: Palavras da Data Link iniciadas por K28.7 usam D16.2 (SDF), D4.2 (SIF)
    //       ou D29.2 (SBF) em Byte1, nunca D14.6/D17.1 e nunca K28.5 em Byte0.
    // ------------------------------------------------------------------------
    wire [7:0] rx_b0 = rx_word_in[7:0];
    wire [7:0] rx_b1 = rx_word_in[15:8];
    wire [7:0] rx_b2 = rx_word_in[23:16];
    wire [7:0] rx_b3 = rx_word_in[31:24];

    wire k_only_b0     = (rx_k_in == 4'b0001);
    wire is_k28_5_word = rx_k_in[0] && (rx_b0 == SYM_K28_5);
    wire is_k28_7_llcw = k_only_b0 && (rx_b0 == SYM_K28_7) &&
                         ((rx_b1 == SYM_D14_6) || (rx_b1 == SYM_D17_1));

    always @(*) begin
        rx_is_llcw_space = 1'b0;
        rx_cmd_valid     = 1'b0;
        rx_cmd_type      = CMD_NONE;
        rx_llcw_err      = 1'b0;

        if (rx_word_valid && !rx_word_err && (is_k28_5_word || is_k28_7_llcw)) begin
            rx_is_llcw_space = 1'b1;
            if (!k_only_b0) begin
                rx_llcw_err = 1'b1;
            end else if (rx_b0 == SYM_K28_5) begin
                if ((rx_b1 == SYM_D14_6) && (rx_b2 == SYM_D6_2) && (rx_b3 == SYM_D6_2)) begin
                    rx_cmd_valid = 1'b1;
                    rx_cmd_type  = CMD_INIT1;
                end else if ((rx_b1 == SYM_D17_1) && (rx_b2 == SYM_D25_5) && (rx_b3 == SYM_D25_5)) begin
                    rx_cmd_valid = 1'b1;
                    rx_cmd_type  = CMD_IINIT1;
                end else if ((rx_b1 == SYM_D14_6) && (rx_b2 == SYM_D6_5) && (rx_b3 == SYM_D6_5)) begin
                    rx_cmd_valid = 1'b1;
                    rx_cmd_type  = CMD_INIT2;
                end else if ((rx_b1 == SYM_D17_1) && (rx_b2 == SYM_D25_2) && (rx_b3 == SYM_D25_2)) begin
                    rx_cmd_valid = 1'b1;
                    rx_cmd_type  = CMD_IINIT2;
                end else if ((rx_b1 == SYM_D14_6) && (rx_b2 == SYM_D24_1)) begin
                    rx_cmd_valid = 1'b1;
                    rx_cmd_type  = CMD_INIT3;
                end else begin
                    rx_llcw_err  = 1'b1;
                end
            end else begin
                // rx_b0 == SYM_K28_7 && rx_b1 in {D14.6, D17.1}
                if (rx_b1 == SYM_D14_6) begin
                    if ((rx_b2 == SYM_D31_3) && (rx_b3 == SYM_D31_3)) begin
                        rx_cmd_valid = 1'b1;
                        rx_cmd_type  = CMD_SKIP;
                    end else if ((rx_b2 == SYM_D15_6) && (rx_b3 == SYM_D15_6)) begin
                        rx_cmd_valid = 1'b1;
                        rx_cmd_type  = CMD_IDLE;
                    end else if (rx_b2 == SYM_D30_3) begin
                        rx_cmd_valid = 1'b1;
                        rx_cmd_type  = CMD_STANDBY;
                    end else if (rx_b2 == SYM_D4_3) begin
                        rx_cmd_valid = 1'b1;
                        rx_cmd_type  = CMD_LOST_SIGNAL;
                    end else begin
                        rx_llcw_err  = 1'b1;
                    end
                end else begin
                    rx_llcw_err = 1'b1;
                end
            end
        end
    end

    // Registrador de capacidades remotas extraidas do INIT3 (ECSS 5.3.3.8e)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_capabilities_out <= 8'h00;
            rx_caps_valid       <= 1'b0;
        end else if (rx_cmd_valid && (rx_cmd_type == CMD_INIT3)) begin
            rx_capabilities_out <= rx_b3;
            rx_caps_valid       <= 1'b1;
        end
    end

endmodule
