`timescale 1ns / 1ps


// Módulo: scrambler
// Polinômio: G(x) = x^16 + x^5 + x^4 + x^3 + 1
// Semente:   16'hFFFF
// Ordem:     LSB-first
//
// start_frame: reinicia a PRBS e pode coincidir com sym_valid.
// sym_valid:   indica que existe um símbolo válido.
// sym_is_k:    indica que o símbolo é um caractere de controlo K.
// scramble_enable: habilita o scrambling.
// scramble_data: 1 aplica XOR com a PRBS; 0 mantém o símbolo original.
// advance_prbs: 1 avança a PRBS para este símbolo.




module scrambler (
    input  logic       clk,
    input  logic       rst_n,


    input  logic       start_frame,
    input  logic       sym_valid,
    input  logic       sym_is_k,


    input  logic       scramble_enable,
    input  logic       advance_prbs,
    input  logic       scramble_data,


    input  logic [7:0] sym_data,


    output logic [7:0] scrambled_data,
    output logic       scrambled_is_k,
    output logic       scrambled_valid
);


    logic [15:0] lfsr;
    logic [15:0] lfsr_temp;
    logic [15:0] lfsr_for_symbol;
    logic [7:0]  prbs_byte;


    // ------------------------------------------------
    // Gera um próximo estado do LFSR.
    // Mantém a lógica explícita do código original.
    // ------------------------------------------------


    function automatic [15:0] lfsr_step(
        input [15:0] state
    );
        reg [15:0] s;
        begin
            s = 16'b0;


            s[0] = state[15];


            s[1] = state[0];
            s[2] = state[1];


            s[3] = state[2] ^ state[15];
            s[4] = state[3] ^ state[15];
            s[5] = state[4] ^ state[15];


            s[6]  = state[5];
            s[7]  = state[6];
            s[8]  = state[7];
            s[9]  = state[8];
            s[10] = state[9];
            s[11] = state[10];
            s[12] = state[11];
            s[13] = state[12];
            s[14] = state[13];
            s[15] = state[14];


            lfsr_step = s;
        end
    endfunction


    // ------------------------------------------------
    // Geração dos 8 bits PRBS.
    // O primeiro bit gerado vai para prbs_byte[0].
    // ------------------------------------------------


    always @* begin
        // Se o quadro começar neste ciclo, a máscara
        // deve ser gerada a partir da semente.
        lfsr_for_symbol = start_frame ? 16'hFFFF : lfsr;


        lfsr_temp = lfsr_for_symbol;
        prbs_byte = 8'h00;


        for (int i = 0; i < 8; i = i + 1) begin
            prbs_byte[i] = lfsr_temp[15];
            lfsr_temp = lfsr_step(lfsr_temp);
        end
    end


    // ------------------------------------------------
    // Registos do scrambler.
    // ------------------------------------------------


    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr            <= 16'hFFFF;
            scrambled_data  <= 8'h00;
            scrambled_is_k  <= 1'b0;
            scrambled_valid <= 1'b0;
        end else begin
            scrambled_valid <= 1'b0;


            // Reinício da PRBS no começo do quadro.
            if (start_frame)
                lfsr <= 16'hFFFF;


            if (sym_valid) begin
                // Os símbolos K não são alterados.
                if (sym_is_k)
                    scrambled_data <= sym_data;
                else if (scramble_enable && scramble_data)
                    scrambled_data <= sym_data ^ prbs_byte;
                else
                    scrambled_data <= sym_data;


                scrambled_is_k  <= sym_is_k;
                scrambled_valid <= 1'b1;


                // O avanço é independente da aplicação do XOR.
                if (advance_prbs)
                    lfsr <= lfsr_temp;
                else if (start_frame)
                    lfsr <= 16'hFFFF;
            end
        end
    end


endmodule
