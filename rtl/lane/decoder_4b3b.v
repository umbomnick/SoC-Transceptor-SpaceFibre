// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/decoder_4b3b.v
// Padrao : ECSS-E-ST-50-11C (8B/10B)
// Funcao : Decodificacao 4B -> 3B (fghj -> HGF), incluindo K28.y, K.x.7 e D.x.A7
// ============================================================================
`timescale 1ns / 1ps

module decoder_4b3b (
    input  wire [3:0] din,       // fghj
    input  wire       rd_mid,    // RD apos o sub-bloco 6b
    input  wire [4:0] data_5b,   // EDCBA decodificado
    input  wire       k_5b,      // 1: sub-bloco 6b era K28
    output reg  [2:0] dout,      // HGF
    output reg        k_out,     // 1: caractere de controle
    output reg        err_out,   // 1: codigo invalido
    output reg        disp_err,  // 1: erro de disparidade
    output reg        rd_final   // RD apos o simbolo
);

    wire x_a7_neg = (data_5b == 5'd17) || (data_5b == 5'd18) || (data_5b == 5'd20);
    wire x_a7_pos = (data_5b == 5'd11) || (data_5b == 5'd13) || (data_5b == 5'd14);
    wire x_kx7    = (data_5b == 5'd23) || (data_5b == 5'd27) ||
                    (data_5b == 5'd29) || (data_5b == 5'd30);
    wire k_alt    = k_5b && !rd_mid;

    wire [2:0] ones = din[0] + din[1] + din[2] + din[3];

    always @(*) begin
        k_out   = k_5b;
        err_out = 1'b0;
        dout    = 3'd0;

        case (din)
            4'b1011, 4'b0100: dout = 3'd0;
            4'b1001:          dout = k_alt ? 3'd6 : 3'd1;
            4'b0110:          dout = k_alt ? 3'd1 : 3'd6;
            4'b0101:          dout = k_alt ? 3'd5 : 3'd2;
            4'b1010:          dout = k_alt ? 3'd2 : 3'd5;
            4'b1100, 4'b0011: dout = 3'd3;
            4'b1101, 4'b0010: dout = 3'd4;
            4'b1110, 4'b0001: begin
                dout = 3'd7;
                if (k_5b || (din == 4'b1110 && x_a7_neg) || (din == 4'b0001 && x_a7_pos))
                    err_out = 1'b1;
            end
            4'b0111, 4'b1000: begin
                dout = 3'd7;
                if (k_5b || x_kx7)
                    k_out = 1'b1;
                else if (!((din == 4'b0111 && x_a7_neg) || (din == 4'b1000 && x_a7_pos)))
                    err_out = 1'b1;
            end
            default: err_out = 1'b1;
        endcase

        disp_err = 1'b0;
        rd_final = rd_mid;
        if (ones == 3'd3) begin
            rd_final = 1'b1;
            if (rd_mid) disp_err = 1'b1;
        end else if (ones == 3'd1) begin
            rd_final = 1'b0;
            if (!rd_mid) disp_err = 1'b1;
        end else if (din == 4'b1100) begin
            if (rd_mid) disp_err = 1'b1;
        end else if (din == 4'b0011) begin
            if (!rd_mid) disp_err = 1'b1;
        end
        if (err_out) disp_err = 1'b0;
    end
endmodule
