// ============================================================================
// Módulo: lane_layer_top
// Função: Integra a Máquina de Estados, Gerador de Palavras e Encoder 8b/10b
// ============================================================================

module lane_layer_top (
    input  wire clk,
    input  wire rst_n,
    
    // Controles da Lane
    input  wire lane_start,
    input  wire auto_start,
    input  wire lane_reset,
    input  wire rx_only,
    input  wire tx_only,
    input  wire [7:0] capability_reg,
    
    // Sinais recebidos do RX / Physical Layer
    input  wire no_signal,
    input  wire far_end_active,
    input  wire rx_err_pulse,
    input  wire rx_init1,
    input  wire rx_init2,
    input  wire rx_init3,
    input  wire rx_standby,
    input  wire rx_lost_signal,
    input  wire rx_comma,
    
    // Saídas
    output wire tx_enable,
    output wire rx_enable,
    output wire [3:0] current_state,
    output wire [9:0] tx_data_out // Símbolo serializado final indo para o Physical Layer
);

    // Fios de interligação interna
    wire send_init1, send_init2, send_init3, send_standby, send_lost_signal;
    wire [7:0] din_to_enc;
    wire kin_to_enc;
    wire word_done;
    
    // Gerador de pulso de palavra (1 pulso a cada 4 clocks)
    reg word_tick;
    reg [1:0] tick_counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tick_counter <= 2'b0;
            word_tick <= 1'b0;
        end else begin
            tick_counter <= tick_counter + 1'b1;
            word_tick <= (tick_counter == 2'd3) ? 1'b1 : 1'b0;
        end
    end

    // 1. Instancia a Máquina de Estados (LISM)
    lane_init_fsm u_fsm (
        .clk(clk),
        .rst_n(rst_n),
        .lane_start(lane_start),
        .auto_start(auto_start),
        .lane_reset(lane_reset),
        .rx_only(rx_only),
        .tx_only(tx_only),
        .no_signal(no_signal),
        .far_end_active(far_end_active),
        .rx_err_pulse(rx_err_pulse),
        .word_tick(word_tick),
        .rx_init1(rx_init1),
        .rx_init2(rx_init2),
        .rx_init3(rx_init3),
        .rx_standby(rx_standby),
        .rx_lost_signal(rx_lost_signal),
        .rx_comma(rx_comma),
        .tx_enable(tx_enable),
        .rx_enable(rx_enable),
        .send_init1(send_init1),
        .send_init2(send_init2),
        .send_init3(send_init3),
        .send_standby(send_standby),
        .send_lost_signal(send_lost_signal),
        .current_state(current_state)
    );

    // 2. Instancia o Gerador de Palavras
    lane_word_gen u_word_gen (
        .clk(clk),
        .rst_n(rst_n),
        .send_init1(send_init1),
        .send_init2(send_init2),
        .send_init3(send_init3),
        .send_standby(send_standby),
        .send_lost_signal(send_lost_signal),
        .capability_reg(capability_reg),
        .din_to_enc(din_to_enc),
        .kin_to_enc(kin_to_enc),
        .word_done(word_done)
    );

    // 3. Instancia o Codificador 8b/10b (que já estava nos seus arquivos)
    encoder_8b10b u_encoder (
        .clk(clk),
        .rst_n(rst_n),
        .kin(kin_to_enc),
        .din(din_to_enc),
        .dout(tx_data_out)
    );

endmodule
