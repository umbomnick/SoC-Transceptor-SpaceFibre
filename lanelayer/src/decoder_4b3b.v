// ============================================================================
// Projeto: SoC Transceptor SpaceFibre (Lane Layer)
// Arquivo: decoder_4b3b-v2.v
// Padrão : ECSS-E-ST-50-11C
// Função : Decodificação combinacional de 4 bits (fghj) para 3 bits (HGF)
// ============================================================================

module decoder_4b3b (
    input  wire [3:0] din,      // Símbolo de 4 bits (fghj)
    input  wire       rd_mid,   // Running Disparity intermediário vindo do 6B/5B
    input  wire [4:0] data_5b,  // EDCBA para desempate de exceções Dxx.7
    input  wire       k_5b,     // 1 se o bloco 5B indicou K28 ou K-code
    output reg  [2:0] dout,     // 3 bits decodificados (HGF)
    output reg        k_out,    // 1 se for caractere K de controle
    output reg        err_out,  // 1 se for símbolo inválido ou erro de RD
    output reg        rd_final  // Próxima Disparidade Final
);

    wire alt7 = (data_5b == 5'd11) || (data_5b == 5'd13) || (data_5b == 5'd14);

    always @(*) begin
        k_out    = k_5b;
        err_out  = 1'b0;
        rd_final = rd_mid;
        dout     = 3'b000;

        case (din)
            // D/K.xx.0 (000)
            4'b1011: begin dout = 3'd0; rd_final = 1'b1; if (rd_mid != 1'b0) err_out = 1'b1; end
            4'b0100: begin dout = 3'd0; rd_final = 1'b0; if (rd_mid != 1'b1) err_out = 1'b1; end

            // D/K.xx.1 (001)
            4'b1001: begin dout = 3'd1; rd_final = rd_mid; end
            4'b0110: begin 
                if (k_5b) begin
                    dout = 3'd1; k_out = 1'b1; rd_final = 1'b1; if (rd_mid != 1'b0) err_out = 1'b1; 
                end else begin
                    dout = 3'd6; rd_final = rd_mid; 
                end
            end

            // D/K.xx.2 (010) e D/K.xx.5 (101)
            4'b0101: begin 
                if (k_5b) begin
                    k_out = 1'b1;
                    if (rd_mid == 1'b1) begin
                        dout = 3'd2; rd_final = 1'b1; // K.xx.2 (RD-)
                    end else begin
                        dout = 3'd5; rd_final = 1'b0; // K.xx.5 (RD+)
                    end
                end else begin
                    dout = 3'd2; rd_final = rd_mid; // D.xx.2
                end
            end

            4'b1010: begin 
                if (k_5b) begin
                    k_out = 1'b1;
                    if (rd_mid == 1'b1) begin
                        dout = 3'd5; rd_final = 1'b1; // K.xx.5 (RD-) -> Comma K28.5!
                    end else begin
                        dout = 3'd2; rd_final = 1'b0; // K.xx.2 (RD+)
                    end
                end else begin
                    dout = 3'd5; rd_final = rd_mid; // D.xx.5
                end
            end

            // D/K.xx.3 (011)
            4'b1100, 4'b0011: begin dout = 3'd3; rd_final = rd_mid; end

            // D/K.xx.4 (100)
            4'b1101: begin dout = 3'd4; rd_final = 1'b1; if (rd_mid != 1'b0) err_out = 1'b1; end
            4'b0010: begin dout = 3'd4; rd_final = 1'b0; if (rd_mid != 1'b1) err_out = 1'b1; end

            // D/K.xx.7 (111)
            4'b1110: begin dout = 3'd7; rd_final = 1'b1; if (rd_mid != 1'b0) err_out = 1'b1; end
            4'b0001: begin dout = 3'd7; rd_final = 1'b0; if (rd_mid != 1'b1) err_out = 1'b1; end
            4'b0111: begin 
                dout = 3'd7; 
                if (alt7) begin
                    rd_final = 1'b1; if (rd_mid != 1'b0) err_out = 1'b1;
                end else begin
                    k_out = 1'b1; rd_final = 1'b1; if (rd_mid != 1'b0) err_out = 1'b1;
                end
            end
            4'b1000: begin 
                dout = 3'd7; 
                if (alt7) begin
                    rd_final = 1'b0; if (rd_mid != 1'b1) err_out = 1'b1;
                end else begin
                    k_out = 1'b1; rd_final = 1'b0; if (rd_mid != 1'b1) err_out = 1'b1;
                end
            end

            default: begin
                err_out = 1'b1;
            end
        endcase
    end

endmodule
