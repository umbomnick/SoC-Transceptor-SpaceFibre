// ============================================================================
// Projeto  : SoC Transceptor SpaceFibre (Data Link Layer - Framing)
// Arquivo  : tx_word_packer.sv
// Padrão   : ECSS-E-ST-50-11C (15 May 2019)
// Função   : Agrupa símbolos do framer em palavras de 32 bits para a Lane Layer
// Cláusulas: 3.4.4 (símbolo 0 transmitido primeiro)
// ============================================================================

`timescale 1ns / 1ps

module tx_word_packer #(
    parameter int FIFO_AW = 2                 // 2^2 = 4 palavras
) (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        link_active,

    // do tx_framing (1 símbolo por ciclo, quando valid)
    input  logic [7:0]  sym_data,
    input  logic        sym_is_k,
    input  logic        sym_valid,
    output logic        framer_en,            // -> tx_framing.tx_en

    // para a Lane layer
    output logic [31:0] tx_data,
    output logic [3:0]  tx_ctrl,
    output logic        tx_valid,
    input  logic        tx_ready
);

    localparam int DEPTH = 1 << FIFO_AW;

    logic [35:0]      fifo [0:DEPTH-1];       // {ctrl[3:0], data[31:0]}
    logic [FIFO_AW:0] wp, rp;
    logic [FIFO_AW:0] used;
    logic [31:0]      acc_d;
    logic [3:0]       acc_k;
    logic [1:0]       idx;

    assign used     = wp - rp;
    // folga de 2 palavras: o framer tem 1 ciclo de latência de saída
    assign framer_en = (used <= (FIFO_AW+1)'(DEPTH - 2));

    assign tx_valid = (used != '0);
    assign {tx_ctrl, tx_data} = fifo[rp[FIFO_AW-1:0]];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wp <= '0; rp <= '0; idx <= 2'd0; acc_d <= '0; acc_k <= '0;
        end else if (!link_active) begin
            // link reset: descarta palavra parcial e o que estava no FIFO
            wp <= '0; rp <= '0; idx <= 2'd0;
        end else begin
            if (tx_valid && tx_ready)
                rp <= rp + 1'b1;
            if (sym_valid) begin
                acc_d[8*idx +: 8] <= sym_data;
                acc_k[idx]        <= sym_is_k;
                idx               <= idx + 2'd1;
                if (idx == 2'd3) begin
                    fifo[wp[FIFO_AW-1:0]] <= {sym_is_k, acc_k[2:0], sym_data, acc_d[23:0]};
                    wp <= wp + 1'b1;
                end
            end
        end
    end

endmodule