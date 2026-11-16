// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/elastic_buffer.v
// Padrao : ECSS-E-ST-50-11C (Clausula 5.5.3)
// Funcao : Elastic Buffer em nivel de palavra de 32 bits para compensacao de
//          deriva de clock (±100 ppm) por insercao/remocao atomica de SKIP
//          ({D31.3, D31.3, D14.6, K28.7}) sem perturbar a Running Disparity.
// ============================================================================
`timescale 1ns / 1ps

module elastic_buffer #(
    parameter DEPTH          = 8,
    parameter HIGH_WATERMARK = 6,
    parameter LOW_WATERMARK  = 1,
    parameter START_LEVEL    = 2
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        flush,          // Limpa a FIFO ao perder alinhamento
    input  wire        wr_en,          // Pulso de escrita (1 palavra a cada ~4 ciclos RX)
    input  wire [31:0] din_word,
    input  wire [3:0]  din_k,
    input  wire        din_err,
    output reg         dout_valid,     // Pulso de leitura (1 palavra a cada 4 ciclos locais)
    output reg  [31:0] dout_word,
    output reg  [3:0]  dout_k,
    output reg         dout_err,
    output wire        empty,
    output wire        full,
    output reg  [3:0]  fill_count,
    output reg         skip_deleted,
    output reg         skip_inserted
);

    localparam [31:0] WORD_SKIP = 32'h7F7F_CEFC; // {D31.3, D31.3, D14.6, K28.7}
    localparam [3:0]  K_SKIP    = 4'b0001;
    localparam        PTR_W     = $clog2(DEPTH);

    reg [36:0] mem [0:DEPTH-1];
    reg [PTR_W-1:0] wr_ptr;
    reg [PTR_W-1:0] rd_ptr;
    reg [1:0]       rd_phase;
    reg             started;

    assign empty = (fill_count == 4'd0);
    assign full  = (fill_count == DEPTH[3:0]);

    wire is_skip_in = !din_err && (din_k == K_SKIP) && (din_word == WORD_SKIP);
    wire do_del     = wr_en && is_skip_in && (fill_count >= HIGH_WATERMARK[3:0]);
    wire do_wr      = wr_en && !do_del && !full;

    wire rd_tick    = started && (rd_phase == 2'd3);
    wire do_ins     = rd_tick && ((fill_count == 4'd0) ||
                                  ((fill_count <= LOW_WATERMARK[3:0]) && !do_wr));
    wire do_rd      = rd_tick && !do_ins && !empty;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr        <= {PTR_W{1'b0}};
            rd_ptr        <= {PTR_W{1'b0}};
            fill_count    <= 4'd0;
            rd_phase      <= 2'd0;
            started       <= 1'b0;
            dout_valid    <= 1'b0;
            dout_word     <= 32'd0;
            dout_k        <= 4'd0;
            dout_err      <= 1'b0;
            skip_deleted  <= 1'b0;
            skip_inserted <= 1'b0;
        end else if (flush) begin
            wr_ptr        <= {PTR_W{1'b0}};
            rd_ptr        <= {PTR_W{1'b0}};
            fill_count    <= 4'd0;
            rd_phase      <= 2'd0;
            started       <= 1'b0;
            dout_valid    <= 1'b0;
            skip_deleted  <= 1'b0;
            skip_inserted <= 1'b0;
        end else begin
            dout_valid    <= 1'b0;
            skip_deleted  <= do_del;
            skip_inserted <= do_ins;

            if (!started) begin
                if ((fill_count + (do_wr ? 4'd1 : 4'd0)) >= START_LEVEL[3:0]) begin
                    started  <= 1'b1;
                    rd_phase <= 2'd0;
                end
            end else begin
                rd_phase <= rd_phase + 2'd1;
            end

            if (do_wr) begin
                mem[wr_ptr] <= {din_err, din_k, din_word};
                wr_ptr      <= wr_ptr + 1'b1;
            end

            if (do_ins) begin
                dout_valid <= 1'b1;
                dout_word  <= WORD_SKIP;
                dout_k     <= K_SKIP;
                dout_err   <= 1'b0;
            end else if (do_rd) begin
                dout_valid <= 1'b1;
                dout_word  <= mem[rd_ptr][31:0];
                dout_k     <= mem[rd_ptr][35:32];
                dout_err   <= mem[rd_ptr][36];
                rd_ptr     <= rd_ptr + 1'b1;
            end

            fill_count <= fill_count + (do_wr ? 4'd1 : 4'd0) - (do_rd ? 4'd1 : 4'd0);
        end
    end

endmodule
