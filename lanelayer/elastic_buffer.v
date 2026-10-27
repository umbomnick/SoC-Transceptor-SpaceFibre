// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: elastic_buffer-v2.v (v2 - Ajustado para Operação Nominal)
// Padrão : ECSS-E-ST-50-11C
// Função : Elastic Buffer (FIFO para Compensação de Deriva de Clock/SKIP)
// ============================================================================

module elastic_buffer #(
    parameter DEPTH          = 16,
    parameter HIGH_WATERMARK = 12,
    parameter LOW_WATERMARK  = 2
)(
    input  wire       wr_clk,        // Clock de escrita (RX da PHY SerDes)
    input  wire       rd_clk,        // Clock de leitura (Clock local do sistema)
    input  wire       rst_n,         // Reset assíncrono ativo baixo
    input  wire       wr_en,         // Habilita escrita
    input  wire       rd_en,         // Habilita leitura
    input  wire [9:0] din_10b,       // Palavra de 10 bits recebida da PHY
    output reg  [9:0] dout_10b,      // Palavra de 10 bits alinhada para leitura
    output wire       empty,         // Indicador de FIFO vazia
    output wire       full,          // Indicador de FIFO cheia
    output reg  [4:0] fill_count,    // Nível atual de preenchimento da FIFO
    output reg        skip_deleted,  // Pulso de 1 ciclo quando SKIP é descartado
    output reg        skip_inserted  // Pulso de 1 ciclo quando SKIP é inserido
);

    reg [9:0] mem [0:DEPTH-1];
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;

    // Identificação de símbolos SKIP (K28.5 / K28.7 Comma)
    wire is_skip_in = (din_10b == 10'h0FA) || (din_10b == 10'h305) ||
                      (din_10b == 10'h0F8) || (din_10b == 10'h307);

    assign empty = (fill_count == 0);
    assign full  = (fill_count == DEPTH);

    // Lógica Síncrona Principal (Clock de Leitura / Sistema)
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr        <= 4'd0;
            rd_ptr        <= 4'd0;
            fill_count    <= 5'd0;
            dout_10b      <= 10'b0;
            skip_deleted  <= 1'b0;
            skip_inserted <= 1'b0;
        end else begin
            skip_deleted  <= 1'b0;
            skip_inserted <= 1'b0;

            // 1. CONDIÇÃO DE DESCARTE (High Watermark + SKIP na entrada)
            if (wr_en && is_skip_in && (fill_count >= HIGH_WATERMARK)) begin
                skip_deleted <= 1'b1; // Descarta a palavra SKIP da FIFO
                if (rd_en && !empty) begin
                    dout_10b   <= mem[rd_ptr];
                    rd_ptr     <= rd_ptr + 1'b1;
                    fill_count <= fill_count - 1'b1;
                end
            end
            // 2. CONDIÇÃO DE INSERÇÃO (Low Watermark + Leitura)
            else if (rd_en && (fill_count <= LOW_WATERMARK) && !empty) begin
                dout_10b      <= 10'h0FA; // Insere palavra de controle SKIP no fluxo
                skip_inserted <= 1'b1;
                if (wr_en && !full) begin
                    mem[wr_ptr] <= din_10b;
                    wr_ptr      <= wr_ptr + 1'b1;
                    fill_count  <= fill_count + 1'b1; // Leitura retida: FIFO cresce
                end
            end
            // 3. OPERAÇÃO NORMAL DE ESCRITA E LEITURA
            else begin
                case ({wr_en && !full, rd_en && !empty})
                    2'b10: begin // Somente Escrita
                        mem[wr_ptr] <= din_10b;
                        wr_ptr      <= wr_ptr + 1'b1;
                        fill_count  <= fill_count + 1'b1;
                    end
                    2'b01: begin // Somente Leitura
                        dout_10b   <= mem[rd_ptr];
                        rd_ptr     <= rd_ptr + 1'b1;
                        fill_count <= fill_count - 1'b1;
                    end
                    2'b11: begin // Escrita e Leitura Simultâneas
                        mem[wr_ptr] <= din_10b;
                        dout_10b    <= mem[rd_ptr];
                        wr_ptr      <= wr_ptr + 1'b1;
                        rd_ptr      <= rd_ptr + 1'b1;
                    end
                    default: ;
                endcase
            end
        end
    end

endmodule