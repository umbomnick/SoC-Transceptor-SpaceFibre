// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: llcw_processor.v
// Padrão : ECSS-E-ST-50-11C
// Função : Processador de Palavras de Controle da Lane (LLCW Processor)
//          Montagem (TX) e Decodificação (RX) de Comandos de 32 bits
// ============================================================================

module llcw_processor (
    input  wire        clk,                 // Clock do sistema
    input  wire        rst_n,               // Reset assíncrono ativo baixo

    // ------------------------------------------------------------------------
    // INTERFACE TRANSMISSORA (TX - Montador de LLCW)
    // ------------------------------------------------------------------------
    input  wire        tx_send_cmd,         // Pulso para montar e emitir comando
    input  wire [3:0]  tx_cmd_type,         // Tipo de comando (1 a 9)
    input  wire [7:0]  tx_capabilities_in,  // Byte de capacidades (para INIT3)
    output reg  [31:0] tx_llcw_word,        // Palavra de 32 bits {Byte3, Byte2, Byte1, Byte0}
    output reg  [3:0]  tx_llcw_k_flags,     // Indicadores K para os 4 bytes {k3, k2, k1, k0}
    output reg         tx_word_valid,       // Pulso de palavra de controle TX válida

    // ------------------------------------------------------------------------
    // INTERFACE RECEPTORA (RX - Decodificador de LLCW)
    // ------------------------------------------------------------------------
    input  wire [31:0] rx_word_in,          // Palavra de 32 bits recebida da recepção
    input  wire [3:0]  rx_k_in,             // Indicadores K recebidos
    input  wire        rx_word_valid,       // Sinal de palavra recebida pronta
    output reg         rx_cmd_valid,        // Pulso de comando LLCW válido reconhecido
    output reg  [3:0]  rx_cmd_type,         // Tipo de comando reconhecido (1 a 9)
    output reg  [7:0]  rx_capabilities_out, // Capabilities extraídas (se INIT3)
    output reg         rx_llcw_err          // Pulso de erro de protocolo LLCW
);

    // ------------------------------------------------------------------------
    // DEFINIÇÃO DOS TIPOS DE COMANDOS LLCW (ECSS-E-ST-50-11C)
    // ------------------------------------------------------------------------
    localparam CMD_NONE        = 4'd0;
    localparam CMD_INIT1       = 4'd1;
    localparam CMD_IINIT1      = 4'd2;
    localparam CMD_INIT2       = 4'd3;
    localparam CMD_IINIT2      = 4'd4;
    localparam CMD_INIT3       = 4'd5;
    localparam CMD_SKIP        = 4'd6;
    localparam CMD_IDLE        = 4'd7;
    localparam CMD_STANDBY     = 4'd8;
    localparam CMD_LOST_SIGNAL = 4'd9;

    // Constantes de Controle
    localparam BYTE_K28_7  = 8'hFC; // K28.7 (Comma de Controle)
    localparam BYTE_K28_5  = 8'hBC; // K28.5 (Comma de Dados)
    localparam BYTE_D14_6  = 8'h6E; // LLCW Marker (D14.6)
    localparam BYTE_D31_3  = 8'h7F; // D31.3 (Para SKIP)

    // ------------------------------------------------------------------------
    // LÓGICA TRANSMISSORA (MONTADOR TX)
    // ------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_llcw_word    <= 32'b0;
            tx_llcw_k_flags <= 4'b0;
            tx_word_valid   <= 1'b0;
        end else begin
            tx_word_valid <= 1'b0;
            if (tx_send_cmd) begin
                tx_word_valid   <= 1'b1;
                tx_llcw_k_flags <= 4'b0001; // Byte 0 é K-code (K28.7/K28.5), demais são Dados

                case (tx_cmd_type)
                    CMD_INIT1: begin
                        tx_llcw_word <= {8'h11, 8'h11, BYTE_D14_6, BYTE_K28_7};
                    end
                    CMD_IINIT1: begin
                        tx_llcw_word <= {8'hEE, 8'hEE, BYTE_D14_6, BYTE_K28_7};
                    end
                    CMD_INIT2: begin
                        tx_llcw_word <= {8'h22, 8'h22, BYTE_D14_6, BYTE_K28_7};
                    end
                    CMD_IINIT2: begin
                        tx_llcw_word <= {8'hDD, 8'hDD, BYTE_D14_6, BYTE_K28_7};
                    end
                    CMD_INIT3: begin
                        tx_llcw_word <= {tx_capabilities_in, 8'h33, BYTE_D14_6, BYTE_K28_7};
                    end
                    CMD_SKIP: begin
                        tx_llcw_word <= {BYTE_D31_3, BYTE_D31_3, BYTE_D14_6, BYTE_K28_7};
                    end
                    CMD_IDLE: begin
                        tx_llcw_word <= {8'h00, 8'h00, BYTE_D14_6, BYTE_K28_7};
                    end
                    CMD_STANDBY: begin
                        tx_llcw_word <= {8'h55, 8'h55, BYTE_D14_6, BYTE_K28_7};
                    end
                    CMD_LOST_SIGNAL: begin
                        tx_llcw_word <= {8'hAA, 8'hAA, BYTE_D14_6, BYTE_K28_7};
                    end
                    default: begin
                        tx_word_valid   <= 1'b0;
                        tx_llcw_word    <= 32'b0;
                        tx_llcw_k_flags <= 4'b0;
                    end
                endcase
            end
        end
    end

    // ------------------------------------------------------------------------
    // LÓGICA RECEPTORA (DECODIFICADOR RX)
    // ------------------------------------------------------------------------
    wire [7:0] rx_b0 = rx_word_in[7:0];
    wire [7:0] rx_b1 = rx_word_in[15:8];
    wire [7:0] rx_b2 = rx_word_in[23:16];
    wire [7:0] rx_b3 = rx_word_in[31:24];

    wire is_valid_comma_k = rx_k_in[0] && ((rx_b0 == BYTE_K28_7) || (rx_b0 == BYTE_K28_5));
    wire is_llcw_marker   = (!rx_k_in[1]) && (rx_b1 == BYTE_D14_6);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_cmd_valid        <= 1'b0;
            rx_cmd_type         <= CMD_NONE;
            rx_capabilities_out <= 8'b0;
            rx_llcw_err         <= 1'b0;
        end else begin
            rx_cmd_valid <= 1'b0;
            rx_llcw_err  <= 1'b0;

            if (rx_word_valid) begin
                if (is_valid_comma_k && is_llcw_marker) begin
                    case ({rx_b2, rx_b3})
                        {8'h11, 8'h11}: begin
                            rx_cmd_valid <= 1'b1;
                            rx_cmd_type  <= CMD_INIT1;
                        end
                        {8'hEE, 8'hEE}: begin
                            rx_cmd_valid <= 1'b1;
                            rx_cmd_type  <= CMD_IINIT1;
                        end
                        {8'h22, 8'h22}: begin
                            rx_cmd_valid <= 1'b1;
                            rx_cmd_type  <= CMD_INIT2;
                        end
                        {8'hDD, 8'hDD}: begin
                            rx_cmd_valid <= 1'b1;
                            rx_cmd_type  <= CMD_IINIT2;
                        end
                        {BYTE_D31_3, BYTE_D31_3}: begin
                            rx_cmd_valid <= 1'b1;
                            rx_cmd_type  <= CMD_SKIP;
                        end
                        {8'h00, 8'h00}: begin
                            rx_cmd_valid <= 1'b1;
                            rx_cmd_type  <= CMD_IDLE;
                        end
                        {8'h55, 8'h55}: begin
                            rx_cmd_valid <= 1'b1;
                            rx_cmd_type  <= CMD_STANDBY;
                        end
                        {8'hAA, 8'hAA}: begin
                            rx_cmd_valid <= 1'b1;
                            rx_cmd_type  <= CMD_LOST_SIGNAL;
                        end
                        default: begin
                            if (rx_b2 == 8'h33) begin
                                rx_cmd_valid        <= 1'b1;
                                rx_cmd_type         <= CMD_INIT3;
                                rx_capabilities_out <= rx_b3;
                            end else begin
                                rx_llcw_err <= 1'b1; // Comando LLCW desconhecido
                            end
                        end
                    endcase
                end else begin
                    rx_llcw_err <= 1'b1; // Não possui cabeçalho LLCW válido
                end
            end
        end
    end

endmodule
