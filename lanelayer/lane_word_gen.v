// ============================================================================
// Módulo: lane_word_gen
// Função: Gerador Sequencial de Palavras de Controle (INIT1, INIT2, INIT3)
// ============================================================================

module lane_word_gen (
    input wire clk,
    input wire rst_n,
    
    // Comandos de Injeção
    input wire send_init1,
    input wire send_init2,
    input wire send_init3,
    input wire send_standby,
    input wire send_lost_signal,
    
    input wire [7:0] capability_reg, // Flags de configuração para o INIT3[cite: 8]
    
    // Saída para o Codificador 8b/10b (HGF EDCBA)
    output reg [7:0] din_to_enc,
    output reg       kin_to_enc,
    
    // Indica término de envio de 1 palavra (4 bytes)
    output wire word_done 
);

    reg [1:0] byte_cnt;
    assign word_done = (byte_cnt == 2'd3);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            byte_cnt <= 2'd0;
        end else if (send_init1 || send_init2 || send_init3 || send_standby || send_lost_signal) begin
            byte_cnt <= byte_cnt + 1'b1;
        end else begin
            byte_cnt <= 2'd0;
        end
    end

    // Mapeamento dos símbolos D/K.x.y[cite: 8]
    // Utiliza concatenação { y (3 bits), x (5 bits) }
    always @(*) begin
        din_to_enc = 8'h00;
        kin_to_enc = 1'b0;

        case (byte_cnt)
            2'd0: begin
                // Primeiro byte: Comma K28.7 para Standby/LOS, ou Init Comma K28.5 para INITs[cite: 8]
                if (send_standby || send_lost_signal) begin
                    din_to_enc = {3'd7, 5'd28}; // K28.7[cite: 8]
                end else begin
                    din_to_enc = {3'd5, 5'd28}; // K28.5[cite: 8]
                end
                kin_to_enc = 1'b1;
            end
            
            2'd1: begin
                // Segundo byte: Identificador LLCW (D14.6) para todas as palavras de Lane[cite: 8]
                din_to_enc = {3'd6, 5'd14}; 
                kin_to_enc = 1'b0;
            end
            
            2'd2: begin
                // Terceiro byte: Identificador da Palavra Específica[cite: 8]
                if (send_init1)           din_to_enc = {3'd2, 5'd6};  // D6.2[cite: 8]
                else if (send_init2)      din_to_enc = {3'd5, 5'd6};  // D6.5[cite: 8]
                else if (send_init3)      din_to_enc = {3'd1, 5'd24}; // D24.1[cite: 8]
                else if (send_standby)    din_to_enc = {3'd3, 5'd30}; // D30.3[cite: 8]
                else if (send_lost_signal)din_to_enc = {3'd3, 5'd4};  // D4.3[cite: 8]
                kin_to_enc = 1'b0;
            end
            
            2'd3: begin
                // Quarto byte: Cópia do 3º ou parâmetros[cite: 8]
                if (send_init1)           din_to_enc = {3'd2, 5'd6};  // Cópia de D6.2[cite: 8]
                else if (send_init2)      din_to_enc = {3'd5, 5'd6};  // Cópia de D6.5[cite: 8]
                else if (send_init3)      din_to_enc = capability_reg; // Flags de configuração (D0.0-D31.7)[cite: 8]
                else if (send_standby)    din_to_enc = 8'h00;         // Reason code (ex: D0.0)[cite: 8]
                else if (send_lost_signal)din_to_enc = 8'h00;         // Reason code (ex: D0.0)[cite: 8]
                kin_to_enc = 1'b0;
            end
        endcase
    end
endmodule