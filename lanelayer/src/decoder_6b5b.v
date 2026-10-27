// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: decoder_6b5b-v2.v
// Padrão : ECSS-E-ST-50-11C
// Função : Decodificação combinacional de 6 bits (abcdei) para 5 bits (EDCBA)
// ============================================================================

module decoder_6b5b (
    input  wire [5:0] din,      // Símbolo de 6 bits (abcdei)
    input  wire       rd_in,    // Running Disparity atual (0 = RD-, 1 = RD+)
    output reg  [4:0] dout,     // 5 bits decodificados (EDCBA)
    output reg        k_out,    // 1 se for caractere K28 ou K-code
    output reg        err_out,  // 1 se for símbolo inválido ou erro de RD
    output reg        rd_out    // Próxima Disparidade Intermediária
);

    always @(*) begin
        k_out   = 1'b0;
        err_out = 1'b0;
        rd_out  = rd_in;
        dout    = 5'b00000;

        case (din)
            6'b100111: begin dout = 5'd0;  rd_out = 1'b1; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b011000: begin dout = 5'd0;  rd_out = 1'b0; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b011101: begin dout = 5'd1;  rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b100010: begin dout = 5'd1;  rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b101101: begin dout = 5'd2;  rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b010010: begin dout = 5'd2;  rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b110001: begin dout = 5'd3;  rd_out = rd_in; end

            6'b110101: begin dout = 5'd4;  rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b001010: begin dout = 5'd4;  rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b101001: begin dout = 5'd5;  rd_out = rd_in; end
            6'b011001: begin dout = 5'd6;  rd_out = rd_in; end

            6'b111000: begin dout = 5'd7;  rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b000111: begin dout = 5'd7;  rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b111001: begin dout = 5'd8;  rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b000110: begin dout = 5'd8;  rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b100101: begin dout = 5'd9;  rd_out = rd_in; end
            6'b010101: begin dout = 5'd10; rd_out = rd_in; end
            6'b110100: begin dout = 5'd11; rd_out = rd_in; end
            6'b001101: begin dout = 5'd12; rd_out = rd_in; end
            6'b101100: begin dout = 5'd13; rd_out = rd_in; end
            6'b011100: begin dout = 5'd14; rd_out = rd_in; end

            6'b010111: begin dout = 5'd15; rd_out = 1'b1; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b101000: begin dout = 5'd15; rd_out = 1'b0; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b011011: begin dout = 5'd16; rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b100100: begin dout = 5'd16; rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b100011: begin dout = 5'd17; rd_out = rd_in; end
            6'b010011: begin dout = 5'd18; rd_out = rd_in; end
            6'b110010: begin dout = 5'd19; rd_out = rd_in; end
            6'b001011: begin dout = 5'd20; rd_out = rd_in; end
            6'b101010: begin dout = 5'd21; rd_out = rd_in; end
            6'b011010: begin dout = 5'd22; rd_out = rd_in; end

            6'b111010: begin dout = 5'd23; rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b000101: begin dout = 5'd23; rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b110011: begin dout = 5'd24; rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b001100: begin dout = 5'd24; rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b100110: begin dout = 5'd25; rd_out = rd_in; end
            6'b010110: begin dout = 5'd26; rd_out = rd_in; end

            6'b110110: begin dout = 5'd27; rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b001001: begin dout = 5'd27; rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b001110: begin dout = 5'd28; rd_out = rd_in; end

            // K28 (Comma)
            6'b001111: begin dout = 5'd28; k_out = 1'b1; rd_out = 1'b1; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b110000: begin dout = 5'd28; k_out = 1'b1; rd_out = 1'b0; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b101110: begin dout = 5'd29; rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b010001: begin dout = 5'd29; rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b011110: begin dout = 5'd30; rd_out = 1'b0; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b100001: begin dout = 5'd30; rd_out = 1'b1; if (rd_in != 1'b1) err_out = 1'b1; end

            6'b101011: begin dout = 5'd31; rd_out = 1'b1; if (rd_in != 1'b0) err_out = 1'b1; end
            6'b010100: begin dout = 5'd31; rd_out = 1'b0; if (rd_in != 1'b1) err_out = 1'b1; end

            default: begin
                err_out = 1'b1;
            end
        endcase
    end
endmodule
