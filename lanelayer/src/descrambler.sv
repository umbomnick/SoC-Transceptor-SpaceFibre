  
\`timescale 1ns/1ps

module descrambler (  
    input  logic       clk,  
    input  logic       rst\_n,  
    input  logic       start\_frame,  
    input  logic       sym\_valid,  
    input  logic       sym\_is\_k,  
    input  logic       scramble\_enable,  
    input  logic       advance\_prbs,  
    input  logic       scramble\_data,  
    input  logic \[7:0\] sym\_data,  
    output logic \[7:0\] descrambled\_data,  
    output logic       descrambled\_is\_k,  
    output logic       descrambled\_valid  
);

    logic \[15:0\] lfsr;  
    logic \[15:0\] lfsr\_temp;  
    logic \[15:0\] lfsr\_for\_symbol;  
    logic \[7:0\]  prbs\_byte;

    // \=====================================================  
    // AVANCO DO LFSR  
    // Polinomio: G(x) \= x^16 \+ x^5 \+ x^4 \+ x^3 \+ 1  
    // \=====================================================

    function automatic \[15:0\] lfsr\_step(input \[15:0\] state);  
        reg \[15:0\] s;  
        begin  
            s \= 16'b0;

            s\[0\]  \= state\[15\];  
            s\[1\]  \= state\[0\];  
            s\[2\]  \= state\[1\];  
            s\[3\]  \= state\[2\] ^ state\[15\];  
            s\[4\]  \= state\[3\] ^ state\[15\];  
            s\[5\]  \= state\[4\] ^ state\[15\];  
            s\[6\]  \= state\[5\];  
            s\[7\]  \= state\[6\];  
            s\[8\]  \= state\[7\];  
            s\[9\]  \= state\[8\];  
            s\[10\] \= state\[9\];  
            s\[11\] \= state\[10\];  
            s\[12\] \= state\[11\];  
            s\[13\] \= state\[12\];  
            s\[14\] \= state\[13\];  
            s\[15\] \= state\[14\];

            lfsr\_step \= s;  
        end  
    endfunction

    // \=====================================================  
    // GERACAO DOS OITO BITS PRBS  
    // \=====================================================

    always\_comb begin  
        lfsr\_for\_symbol \= start\_frame ? 16'hFFFF : lfsr;  
        lfsr\_temp       \= lfsr\_for\_symbol;  
        prbs\_byte       \= 8'h00;

        for (integer i \= 0; i \< 8; i \= i \+ 1\) begin  
            prbs\_byte\[i\] \= lfsr\_temp\[15\];  
            lfsr\_temp    \= lfsr\_step(lfsr\_temp);  
        end  
    end

    // \=====================================================  
    // REGISTOS DO DESCRAMBLER  
    // \=====================================================

    always\_ff @(posedge clk or negedge rst\_n) begin

        if (\!rst\_n) begin  
            lfsr              \<= 16'hFFFF;  
            descrambled\_data  \<= 8'h00;  
            descrambled\_is\_k  \<= 1'b0;  
            descrambled\_valid \<= 1'b0;  
        end

        else begin  
            descrambled\_valid \<= 1'b0;

            if (start\_frame)  
                lfsr \<= 16'hFFFF;

            if (sym\_valid) begin

                // \-----------------------------------------  
                // SIMBOLO K: PRESERVAR O VALOR ORIGINAL  
                // \-----------------------------------------

                if (sym\_is\_k) begin  
                    descrambled\_data \<= sym\_data;  
                end

                // \-----------------------------------------  
                // SIMBOLO DE DADOS: APLICAR XOR COM A PRBS  
                // \-----------------------------------------

                else if (scramble\_enable && scramble\_data) begin  
                    descrambled\_data \<= sym\_data ^ prbs\_byte;  
                end

                // \-----------------------------------------  
                // SCRAMBLING DESATIVADO: DADOS INALTERADOS  
                // \-----------------------------------------

                else begin  
                    descrambled\_data \<= sym\_data;  
                end

                // Indicadores de saida  
                descrambled\_is\_k  \<= sym\_is\_k;  
                descrambled\_valid \<= 1'b1;

                // Avanco do estado da PRBS  
                if (advance\_prbs)  
                    lfsr \<= lfsr\_temp;  
                else if (start\_frame)  
                    lfsr \<= 16'hFFFF;

            end  
        end  
    end

endmodule
