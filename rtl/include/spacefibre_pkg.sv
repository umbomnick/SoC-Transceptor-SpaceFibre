// ============================================================================
// Projeto  : SoC Transceptor SpaceFibre (Data Link Layer - Framing)
// Arquivo  : spacefibre_pkg.sv
// Padrão   : ECSS-E-ST-50-11C (15 May 2019)
// Função   : Constantes do enquadramento e funções de CRC-16, CRC-8 e PRBS
// Cláusulas: 5.3.5, 5.3.6, 5.3.7, 5.3.8.2, 5.7.6.2.3, 5.7.6.4, 5.7.6.5
// ============================================================================

`timescale 1ns / 1ps

// ============================================================================
// Constantes e funções da ECSS-E-ST-50-11C (15 May 2019) usadas no framing.
// Cada item indica a cláusula da norma de onde veio.
// ============================================================================
package spacefibre_pkg;

    // ---------------- Símbolos (valor de 8 bits; flag K separado) -----------
    localparam logic [7:0] K_COMMA = 8'hFC; // K28.7  1o símbolo de SDF/SBF/SIF  (5.3.5, Tab. 5-5)
    localparam logic [7:0] K_EDF   = 8'h1C; // K28.0  1o símbolo do EDF          (5.3.5, Tab. 5-5)
    localparam logic [7:0] K_EBF   = 8'h5C; // K28.2  1o símbolo do EBF          (5.3.5, Tab. 5-5)
    localparam logic [7:0] D_SDF   = 8'h50; // D16.2  identifica SDF             (5.3.5, Tab. 5-5)
    localparam logic [7:0] D_SBF   = 8'h5D; // D29.2  identifica SBF             (5.3.5, Tab. 5-5)
    localparam logic [7:0] D_SIF   = 8'h44; // D4.2   identifica SIF             (5.3.5, Tab. 5-5)
    localparam logic [7:0] K_EOP   = 8'hFD; // K29.7  End of Packet              (5.3.7.1b)
    localparam logic [7:0] K_EEP   = 8'hFE; // K30.7  Error End of Packet        (5.3.7.1c)
    localparam logic [7:0] K_FILL  = 8'hFB; // K27.7  Fill                       (5.3.7.2a)
    localparam logic [7:0] K_RXERR = 8'h00; // K0.0   RXERR, gerado pela Lane layer (5.3.6, Tab. 5-8)

    localparam int MAX_FRAME_WORDS = 64;    // dados e PRBS por quadro, 1 lane  (5.3.8.2c, 5.3.8.3k)

    typedef enum logic [1:0] {
        LINK_RESET    = 2'b00,
        LINK_TRAINING = 2'b01,
        LINK_ACTIVE   = 2'b10
    } link_state_t;

    // ---------------- CRC-16 do quadro de dados (5.7.6.4) -------------------
    // Polinômio ITU X^16+X^12+X^5+1 (f), semente 0xFFFF (g), bit 0 do
    // símbolo 0 primeiro (h) => forma refletida (0x1021 refletido = 0x8408).
    // Conferido com as Figs. 5-42 e 5-44.
    localparam logic [15:0] CRC16_INIT = 16'hFFFF;

    function automatic logic [15:0] crc16_byte(input logic [15:0] crc,
                                               input logic [7:0]  b);
        logic [15:0] c;
        c = crc ^ {8'h00, b};
        for (int i = 0; i < 8; i++)
            c = c[0] ? ((c >> 1) ^ 16'h8408) : (c >> 1);
        return c;
    endfunction

    // ---------------- CRC-8 de SIF/SBF/FCT... (5.7.6.5) ---------------------
    // g(x) = x^8+x^2+x+1 (d.3), semente 0x00 (f), bit 0 primeiro (e.1)
    // => forma refletida (0x07 refletido = 0xE0). Conferido com a Fig. 5-46.
    function automatic logic [7:0] crc8_byte(input logic [7:0] crc,
                                             input logic [7:0] b);
        logic [7:0] c;
        c = crc ^ b;
        for (int i = 0; i < 8; i++)
            c = c[0] ? ((c >> 1) ^ 8'hE0) : (c >> 1);
        return c;
    endfunction

    // ---------------- PRBS dos quadros idle (5.7.6.2.3) ---------------------
    // G(x) = X^16+X^5+X^4+X^3+1 (c), semente 0xFFFF no link reset (d),
    // bit 0 do byte preenchido primeiro (g). Conferido com a Fig. 5-43.
    // Retorna {próximo estado[15:0], byte gerado[7:0]}.
    localparam logic [15:0] PRBS_SEED = 16'hFFFF;

    function automatic logic [23:0] prbs_byte(input logic [15:0] state);
        logic [15:0] s;
        logic [7:0]  b;
        s = state;
        for (int i = 0; i < 8; i++) begin
            b[i] = s[15];
            s    = {s[14:0], 1'b0} ^ (s[15] ? 16'h0039 : 16'h0000);
        end
        return {s, b};
    endfunction

endpackage