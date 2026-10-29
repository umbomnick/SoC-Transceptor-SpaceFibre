// ============================================================================
// Módulo: lane_init_fsm
// Função: Máquina de Estados de Inicialização da Lane (LISM) e gestão de erros
// ============================================================================

module lane_init_fsm (
    input  wire clk,
    input  wire rst_n,

    // Sinais de Configuração e Controle
    input  wire lane_start,
    input  wire auto_start,
    input  wire lane_reset,
    input  wire rx_only,
    input  wire tx_only,
    
    // Status do Physical Layer / Receptor
    input  wire no_signal,
    input  wire far_end_active,
    input  wire rx_err_pulse,
    input  wire word_tick,       // Pulso a cada palavra de 32-bits (4 bytes) transmitida
    
    // Status das Palavras Recebidas
    input  wire rx_init1,
    input  wire rx_init2,
    input  wire rx_init3,
    input  wire rx_standby,
    input  wire rx_lost_signal,
    input  wire rx_comma,
    
    // Comandos de Saída (Para o Gerador de Palavras e TX/RX)
    output reg  tx_enable,
    output reg  rx_enable,
    output reg  send_init1,
    output reg  send_init2,
    output reg  send_init3,
    output reg  send_standby,
    output reg  send_lost_signal,
    
    // Estado atual (para debug e integração)
    output reg [3:0] current_state
);

    // Codificação dos Estados (Baseado na Figura 5-29 do ECSS)
    localparam S_CLEARLINE      = 4'd0;
    localparam S_DISABLED       = 4'd1;
    localparam S_WAIT           = 4'd2;
    localparam S_STARTED        = 4'd3;
    localparam S_CONNECTING     = 4'd4;
    localparam S_CONNECTED      = 4'd5;
    localparam S_ACTIVE         = 4'd6;
    localparam S_PREP_STANDBY   = 4'd7;
    localparam S_LOSS_OF_SIGNAL = 4'd8;

    reg [3:0] next_state;

    // ------------------------------------------------------------------------
    // Temporizador de Timeout (5000 palavras)[cite: 8]
    // ------------------------------------------------------------------------
    reg [12:0] timeout_timer;
    wire timeout_expired = (timeout_timer == 13'd5000);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            timeout_timer <= 13'd0;
        end else if (current_state == S_ACTIVE || current_state == S_CLEARLINE) begin
            timeout_timer <= 13'd0; // Temporizador para no estado Active[cite: 8]
        end else if (word_tick && !timeout_expired) begin
            timeout_timer <= timeout_timer + 1'b1;
        end
    end

// ------------------------------------------------------------------------
    // Contador Leaky-Bucket para RXERR
    // ------------------------------------------------------------------------
    reg [7:0]  rxerr_counter;
    reg [13:0] good_word_timer;
    
    wire leaky_bucket_full = (rxerr_counter == 8'd255);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset assíncrono puro (exigência do Yosys para mapear no SKY130)
            rxerr_counter <= 8'd0;
            good_word_timer <= 14'd0;
        end else if (current_state != S_ACTIVE) begin
            // Zeramento síncrono quando fora do estado Active
            rxerr_counter <= 8'd0;
            good_word_timer <= 14'd0;
        end else begin
            // Lógica de contagem
            if (rx_err_pulse && rxerr_counter < 8'd255) begin
                rxerr_counter <= rxerr_counter + 1'b1; // Incrementa no erro
            end
            
            if (word_tick) begin
                if (good_word_timer == 14'd15000) begin
                    good_word_timer <= 14'd0;
                    if (rxerr_counter > 8'd0) begin
                        rxerr_counter <= rxerr_counter - 1'b1; // Decrementa a cada 15.000 palavras
                    end
                end else begin
                    good_word_timer <= good_word_timer + 1'b1;
                end
            end
        end
    end


    // ------------------------------------------------------------------------
    // Lógica Combinacional da Máquina de Estados
    // ------------------------------------------------------------------------
    always @(*) begin
        // Valores Padrão
        next_state = current_state;
        tx_enable = 1'b0;
        rx_enable = 1'b0;
        send_init1 = 1'b0;
        send_init2 = 1'b0;
        send_init3 = 1'b0;
        send_standby = 1'b0;
        send_lost_signal = 1'b0;

        // Regra Global: Forçar ClearLine em caso de Reset ou 3 LOST_SIGNAL / STANDBY[cite: 8]
        if (lane_reset) begin
            next_state = S_CLEARLINE;
        end else begin
            case (current_state)
                S_CLEARLINE: begin
                    // Transição imediata para Disabled (simplificação do delay de 2us)[cite: 8]
                    next_state = S_DISABLED;
                end

                S_DISABLED: begin
                    if (lane_start || auto_start) next_state = S_WAIT; //[cite: 8]
                end

                S_WAIT: begin
                    rx_enable = 1'b1; // Ativa detecção NoSignal[cite: 8]
                    if (!lane_start && !auto_start) next_state = S_DISABLED; //[cite: 8]
                    else if (lane_start || !no_signal) next_state = S_STARTED; //[cite: 8]
                end

                S_STARTED: begin
                    if (!rx_only) tx_enable = 1'b1; //[cite: 8]
                    if (!tx_only) rx_enable = 1'b1; //[cite: 8]
                    send_init1 = 1'b1;
                    
                    if (far_end_active || rx_init1 || rx_init2) next_state = S_CONNECTING; //[cite: 8]
                    else if (timeout_expired) next_state = S_CLEARLINE; //[cite: 8]
                end

                S_CONNECTING: begin
                    if (!rx_only) tx_enable = 1'b1;
                    if (!tx_only) rx_enable = 1'b1;
                    send_init2 = 1'b1;
                    
                    if (no_signal && !tx_only) next_state = S_CLEARLINE; //[cite: 8]
                    else if (rx_only || far_end_active || rx_init3) next_state = S_CONNECTED; //[cite: 8]
                    else if (timeout_expired) next_state = S_CLEARLINE; //[cite: 8]
                end

                S_CONNECTED: begin
                    if (!rx_only) tx_enable = 1'b1;
                    if (!tx_only) rx_enable = 1'b1;
                    send_init3 = 1'b1;
                    
                    if (no_signal && !tx_only) next_state = S_CLEARLINE; //[cite: 8]
                    else if (rx_comma) next_state = S_CLEARLINE; // Recebeu Comma fora do contexto[cite: 8]
                    else if (rx_only || far_end_active) next_state = S_ACTIVE; //[cite: 8]
                    else if (timeout_expired) next_state = S_CLEARLINE; //[cite: 8]
                end

                S_ACTIVE: begin
                    if (!rx_only) tx_enable = 1'b1;
                    if (!tx_only) rx_enable = 1'b1;
                    
                    if (no_signal && !tx_only) next_state = S_LOSS_OF_SIGNAL; //[cite: 8]
                    else if (leaky_bucket_full && !tx_only) next_state = S_LOSS_OF_SIGNAL; //[cite: 8]
                    else if (rx_init1 && !rx_only) next_state = S_LOSS_OF_SIGNAL; //[cite: 8]
                    else if (!lane_start && !auto_start) next_state = S_PREP_STANDBY; //[cite: 8]
                end

                S_PREP_STANDBY: begin
                    if (!rx_only) tx_enable = 1'b1;
                    if (!tx_only) rx_enable = 1'b1;
                    send_standby = 1'b1;
                    // Lógica para contar 32 palavras e ir para ClearLine será adicionada pelo contador de palavras
                end

                S_LOSS_OF_SIGNAL: begin
                    if (!rx_only) tx_enable = 1'b1;
                    if (!tx_only) rx_enable = 1'b1;
                    send_lost_signal = 1'b1;
                    // Lógica para contar 32 palavras e ir para ClearLine será adicionada pelo contador de palavras
                end

                default: next_state = S_CLEARLINE;
            endcase
        end
    end

    // Atualização de Estado
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= S_CLEARLINE;
        else        current_state <= next_state;
    end

endmodule