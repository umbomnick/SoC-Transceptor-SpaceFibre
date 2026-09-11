// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
// CREATED		"Thu Sep 10 01:27:21 2026"

module banco_de_registadores_top(
	we,
	clk,
	rst_n,
	r_addr_a,
	r_addr_b,
	w_addr,
	w_data,
	r_data_a,
	r_data_b,
	we_dec
);


input wire	we;
input wire	clk;
input wire	rst_n;
input wire	[3:0] r_addr_a;
input wire	[3:0] r_addr_b;
input wire	[3:0] w_addr;
input wire	[7:0] w_data;
output wire	[7:0] r_data_a;
output wire	[7:0] r_data_b;
output wire	[15:0] we_dec;

wire	[7:0] q_Reg00;
wire	[7:0] q_Reg01;
wire	[7:0] q_Reg02;
wire	[7:0] q_Reg03;
wire	[7:0] q_Reg04;
wire	[7:0] q_Reg05;
wire	[7:0] q_Reg06;
wire	[7:0] q_Reg07;
wire	[7:0] q_Reg08;
wire	[7:0] q_Reg09;
wire	[7:0] q_Reg10;
wire	[7:0] q_Reg11;
wire	[7:0] q_Reg12;
wire	[7:0] q_Reg13;
wire	[7:0] q_Reg14;
wire	[7:0] q_Reg15;
wire	[15:0] we_dec_ALTERA_SYNTHESIZED;





register_8bit	b2v_8_registrador(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[7]),
	.d_in(w_data),
	.q_out(q_Reg07));


decoder_4_to_16	b2v_inst(
	.we(we),
	.w_addr(w_addr),
	.we_dec(we_dec_ALTERA_SYNTHESIZED));


register_8bit	b2v_inst11(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[8]),
	.d_in(w_data),
	.q_out(q_Reg08));


register_8bit	b2v_inst12(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[9]),
	.d_in(w_data),
	.q_out(q_Reg09));


register_8bit	b2v_inst13(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[10]),
	.d_in(w_data),
	.q_out(q_Reg10));


register_8bit	b2v_inst14(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[11]),
	.d_in(w_data),
	.q_out(q_Reg11));


register_8bit	b2v_inst15(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[12]),
	.d_in(w_data),
	.q_out(q_Reg12));


register_8bit	b2v_inst16(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[13]),
	.d_in(w_data),
	.q_out(q_Reg13));


register_8bit	b2v_inst17(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[14]),
	.d_in(w_data),
	.q_out(q_Reg14));


register_8bit	b2v_inst18(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[15]),
	.d_in(w_data),
	.q_out(q_Reg15));


register_8bit	b2v_inst3(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[0]),
	.d_in(w_data),
	.q_out(q_Reg00));


register_8bit	b2v_inst4(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[1]),
	.d_in(w_data),
	.q_out(q_Reg01));


register_8bit	b2v_inst5(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[2]),
	.d_in(w_data),
	.q_out(q_Reg02));


register_8bit	b2v_inst6(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[3]),
	.d_in(w_data),
	.q_out(q_Reg03));


register_8bit	b2v_inst7(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[4]),
	.d_in(w_data),
	.q_out(q_Reg04));


register_8bit	b2v_inst8(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[5]),
	.d_in(w_data),
	.q_out(q_Reg05));


register_8bit	b2v_inst9(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[6]),
	.d_in(w_data),
	.q_out(q_Reg06));


mux_16to1_8bit	b2v_Porta_A_Leitura(
	.in00(q_Reg00),
	.in01(q_Reg01),
	.in02(q_Reg02),
	.in03(q_Reg03),
	.in04(q_Reg04),
	.in05(q_Reg05),
	.in06(q_Reg06),
	.in07(q_Reg07),
	.in08(q_Reg08),
	.in09(q_Reg09),
	.in10(q_Reg10),
	.in11(q_Reg11),
	.in12(q_Reg12),
	.in13(q_Reg13),
	.in14(q_Reg14),
	.in15(q_Reg15),
	.sel(r_addr_a),
	.out(r_data_a));


mux_16to1_8bit	b2v_Porta_B_Leitura(
	.in00(q_Reg00),
	.in01(q_Reg01),
	.in02(q_Reg02),
	.in03(q_Reg03),
	.in04(q_Reg04),
	.in05(q_Reg05),
	.in06(q_Reg06),
	.in07(q_Reg07),
	.in08(q_Reg08),
	.in09(q_Reg09),
	.in10(q_Reg10),
	.in11(q_Reg11),
	.in12(q_Reg12),
	.in13(q_Reg13),
	.in14(q_Reg14),
	.in15(q_Reg15),
	.sel(r_addr_b),
	.out(r_data_b));

assign	we_dec = we_dec_ALTERA_SYNTHESIZED;

endmodule
