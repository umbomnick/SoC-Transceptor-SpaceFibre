// ============================================================================
// Projeto: SoC Transceptor SpaceFibre
// Arquivo: rtl/lane/decoder_6b5b.v
// Padrao : ECSS-E-ST-50-11C (8B/10B)
// Funcao : Decodificacao 6B -> 5B (abcdei -> EDCBA)
// ============================================================================
`timescale 1ns / 1ps

module decoder_6b5b (
    input  wire [5:0] din,       // abcdei
    input  wire       rd_in,     // RD atual (0 = RD-, 1 = RD+)
    output reg  [4:0] dout,      // EDCBA
    output reg        k_out,     // 1: bloco K28 (001111 / 110000)
    output reg        err_out,   // 1: codigo invalido
    output reg        disp_err,  // 1: erro de disparidade
    output reg        rd_out     // RD apos o sub-bloco de 6 bits
);

    wire [2:0] ones = din[0] + din[1] + din[2] + din[3] + din[4] + din[5];

    always @(*) begin
        k_out   = 1'b0;
        err_out = 1'b0;
        dout    = 5'd0;

        case (din)
            6'b100111, 6'b011000: dout = 5'd0;
            6'b011101, 6'b100010: dout = 5'd1;
            6'b101101, 6'b010010: dout = 5'd2;
            6'b110001:            dout = 5'd3;
            6'b110101, 6'b001010: dout = 5'd4;
            6'b101001:            dout = 5'd5;
            6'b011001:            dout = 5'd6;
            6'b111000, 6'b000111: dout = 5'd7;
            6'b111001, 6'b000110: dout = 5'd8;
            6'b100101:            dout = 5'd9;
            6'b010101:            dout = 5'd10;
            6'b110100:            dout = 5'd11;
            6'b001101:            dout = 5'd12;
            6'b101100:            dout = 5'd13;
            6'b011100:            dout = 5'd14;
            6'b010111, 6'b101000: dout = 5'd15;
            6'b011011, 6'b100100: dout = 5'd16;
            6'b100011:            dout = 5'd17;
            6'b010011:            dout = 5'd18;
            6'b110010:            dout = 5'd19;
            6'b001011:            dout = 5'd20;
            6'b101010:            dout = 5'd21;
            6'b011010:            dout = 5'd22;
            6'b111010, 6'b000101: dout = 5'd23;
            6'b110011, 6'b001100: dout = 5'd24;
            6'b100110:            dout = 5'd25;
            6'b010110:            dout = 5'd26;
            6'b110110, 6'b001001: dout = 5'd27;
            6'b001110:            dout = 5'd28;
            6'b001111, 6'b110000: begin dout = 5'd28; k_out = 1'b1; end
            6'b101110, 6'b010001: dout = 5'd29;
            6'b011110, 6'b100001: dout = 5'd30;
            6'b101011, 6'b010100: dout = 5'd31;
            default:              err_out = 1'b1;
        endcase

        disp_err = 1'b0;
        rd_out   = rd_in;
        if (ones == 3'd4) begin
            rd_out = 1'b1;
            if (rd_in) disp_err = 1'b1;
        end else if (ones == 3'd2) begin
            rd_out = 1'b0;
            if (!rd_in) disp_err = 1'b1;
        end else if (din == 6'b111000) begin
            if (rd_in) disp_err = 1'b1;
        end else if (din == 6'b000111) begin
            if (!rd_in) disp_err = 1'b1;
        end
        if (err_out) disp_err = 1'b0;
    end
endmodule
