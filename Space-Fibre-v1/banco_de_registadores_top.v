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
// CREATED		"Mon Aug 31 13:27:14 2026"

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

wire	[7:0] q_Reg0;
wire	q_Reg10;
wire	q_Reg100;
wire	q_Reg101;
wire	q_Reg102;
wire	q_Reg103;
wire	q_Reg104;
wire	q_Reg105;
wire	q_Reg106;
wire	q_Reg107;
wire	q_Reg11;
wire	q_Reg110;
wire	q_Reg111;
wire	q_Reg112;
wire	q_Reg113;
wire	q_Reg114;
wire	q_Reg115;
wire	q_Reg116;
wire	q_Reg117;
wire	q_Reg12;
wire	q_Reg120;
wire	q_Reg121;
wire	q_Reg122;
wire	q_Reg123;
wire	q_Reg124;
wire	q_Reg125;
wire	q_Reg126;
wire	q_Reg127;
wire	q_Reg13;
wire	q_Reg130;
wire	q_Reg131;
wire	q_Reg132;
wire	q_Reg133;
wire	q_Reg134;
wire	q_Reg135;
wire	q_Reg136;
wire	q_Reg137;
wire	q_Reg14;
wire	q_Reg140;
wire	q_Reg141;
wire	q_Reg142;
wire	q_Reg143;
wire	q_Reg144;
wire	q_Reg145;
wire	q_Reg146;
wire	q_Reg147;
wire	q_Reg15;
wire	q_Reg150;
wire	q_Reg151;
wire	q_Reg152;
wire	q_Reg153;
wire	q_Reg154;
wire	q_Reg155;
wire	q_Reg156;
wire	q_Reg157;
wire	q_Reg16;
wire	q_Reg17;
wire	[7:0] q_Reg2;
wire	[7:0] q_Reg3;
wire	[7:0] q_Reg4;
wire	[7:0] q_Reg5;
wire	[7:0] q_Reg6;
wire	[7:0] q_Reg7;
wire	[7:0] q_Reg8;
wire	[7:0] q_Reg9;
wire	[15:0] we_dec_ALTERA_SYNTHESIZED;





register_8bit	b2v_8_registrador(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[7]),
	.d_in(w_data),
	.q_out(q_Reg7));


decoder_4_to_16	b2v_inst(
	.we(we),
	.w_addr(w_addr),
	.we_dec(we_dec_ALTERA_SYNTHESIZED));


register_8bit	b2v_inst11(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[8]),
	.d_in(w_data),
	.q_out(q_Reg8));


register_8bit	b2v_inst12(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[9]),
	.d_in(w_data),
	.q_out(q_Reg9));


register_8bit	b2v_inst13(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[10]),
	.d_in(w_data),
	.q_out({q_Reg107,q_Reg106,q_Reg105,q_Reg104,q_Reg103,q_Reg102,q_Reg101,q_Reg100}));


register_8bit	b2v_inst14(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[11]),
	.d_in(w_data),
	.q_out({q_Reg117,q_Reg116,q_Reg115,q_Reg114,q_Reg113,q_Reg112,q_Reg111,q_Reg110}));


register_8bit	b2v_inst15(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[12]),
	.d_in(w_data),
	.q_out({q_Reg127,q_Reg126,q_Reg125,q_Reg124,q_Reg123,q_Reg122,q_Reg121,q_Reg120}));


register_8bit	b2v_inst16(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[13]),
	.d_in(w_data),
	.q_out({q_Reg137,q_Reg136,q_Reg135,q_Reg134,q_Reg133,q_Reg132,q_Reg131,q_Reg130}));


register_8bit	b2v_inst17(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[14]),
	.d_in(w_data),
	.q_out({q_Reg147,q_Reg146,q_Reg145,q_Reg144,q_Reg143,q_Reg142,q_Reg141,q_Reg140}));


register_8bit	b2v_inst18(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[15]),
	.d_in(w_data),
	.q_out({q_Reg157,q_Reg156,q_Reg155,q_Reg154,q_Reg153,q_Reg152,q_Reg151,q_Reg150}));


register_8bit	b2v_inst3(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[0]),
	.d_in(w_data),
	.q_out(q_Reg0));


register_8bit	b2v_inst4(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[1]),
	.d_in(w_data),
	.q_out({q_Reg17,q_Reg16,q_Reg15,q_Reg14,q_Reg13,q_Reg12,q_Reg11,q_Reg10}));


register_8bit	b2v_inst5(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[2]),
	.d_in(w_data),
	.q_out(q_Reg2));


register_8bit	b2v_inst6(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[3]),
	.d_in(w_data),
	.q_out(q_Reg3));


register_8bit	b2v_inst7(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[4]),
	.d_in(w_data),
	.q_out(q_Reg4));


register_8bit	b2v_inst8(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[5]),
	.d_in(w_data),
	.q_out(q_Reg5));


register_8bit	b2v_inst9(
	.clk(clk),
	.rst_n(rst_n),
	.we(we_dec_ALTERA_SYNTHESIZED[6]),
	.d_in(w_data),
	.q_out(q_Reg6));


mux_16to1_8bit	b2v_Porta_A_Leitura(
	.in0(q_Reg0),
	.in17(q_Reg17),
	.in16(q_Reg16),
	.in15(q_Reg15),
	.in14(q_Reg14),
	.in13(q_Reg13),
	.in12(q_Reg12),
	.in11(q_Reg11),
	.in10(q_Reg10),
	.in107(q_Reg107),
	.in106(q_Reg106),
	.in105(q_Reg105),
	.in104(q_Reg104),
	.in103(q_Reg103),
	.in102(q_Reg102),
	.in101(q_Reg101),
	.in100(q_Reg100),
	.in117(q_Reg117),
	.in116(q_Reg116),
	.in115(q_Reg115),
	.in114(q_Reg114),
	.in113(q_Reg113),
	.in112(q_Reg112),
	.in111(q_Reg111),
	.in110(q_Reg110),
	.in127(q_Reg127),
	.in126(q_Reg126),
	.in125(q_Reg125),
	.in124(q_Reg124),
	.in123(q_Reg123),
	.in122(q_Reg122),
	.in121(q_Reg121),
	.in120(q_Reg120),
	.in137(q_Reg137),
	.in136(q_Reg136),
	.in135(q_Reg135),
	.in134(q_Reg134),
	.in133(q_Reg133),
	.in132(q_Reg132),
	.in131(q_Reg131),
	.in130(q_Reg130),
	.in147(q_Reg147),
	.in146(q_Reg146),
	.in145(q_Reg145),
	.in144(q_Reg144),
	.in143(q_Reg143),
	.in142(q_Reg142),
	.in141(q_Reg141),
	.in140(q_Reg140),
	.in157(q_Reg157),
	.in156(q_Reg156),
	.in155(q_Reg155),
	.in154(q_Reg154),
	.in153(q_Reg153),
	.in152(q_Reg152),
	.in151(q_Reg151),
	.in150(q_Reg150),
	.in2(q_Reg2),
	.in3(q_Reg3),
	.in4(q_Reg4),
	.in5(q_Reg5),
	.in6(q_Reg6),
	.in7(q_Reg7),
	.in8(q_Reg8),
	.in9(q_Reg9),
	.sel(r_addr_a),
	.out(r_data_a));


mux_16to1_8bit	b2v_Porta_B_Leitura(
	.in0(q_Reg0),
	.in17(q_Reg17),
	.in16(q_Reg16),
	.in15(q_Reg15),
	.in14(q_Reg14),
	.in13(q_Reg13),
	.in12(q_Reg12),
	.in11(q_Reg11),
	.in10(q_Reg10),
	.in107(q_Reg107),
	.in106(q_Reg106),
	.in105(q_Reg105),
	.in104(q_Reg104),
	.in103(q_Reg103),
	.in102(q_Reg102),
	.in101(q_Reg101),
	.in100(q_Reg100),
	.in117(q_Reg117),
	.in116(q_Reg116),
	.in115(q_Reg115),
	.in114(q_Reg114),
	.in113(q_Reg113),
	.in112(q_Reg112),
	.in111(q_Reg111),
	.in110(q_Reg110),
	.in127(q_Reg127),
	.in126(q_Reg126),
	.in125(q_Reg125),
	.in124(q_Reg124),
	.in123(q_Reg123),
	.in122(q_Reg122),
	.in121(q_Reg121),
	.in120(q_Reg120),
	.in137(q_Reg137),
	.in136(q_Reg136),
	.in135(q_Reg135),
	.in134(q_Reg134),
	.in133(q_Reg133),
	.in132(q_Reg132),
	.in131(q_Reg131),
	.in130(q_Reg130),
	.in147(q_Reg147),
	.in146(q_Reg146),
	.in145(q_Reg145),
	.in144(q_Reg144),
	.in143(q_Reg143),
	.in142(q_Reg142),
	.in141(q_Reg141),
	.in140(q_Reg140),
	.in157(q_Reg157),
	.in156(q_Reg156),
	.in155(q_Reg155),
	.in154(q_Reg154),
	.in153(q_Reg153),
	.in152(q_Reg152),
	.in151(q_Reg151),
	.in150(q_Reg150),
	.in2(q_Reg2),
	.in3(q_Reg3),
	.in4(q_Reg4),
	.in5(q_Reg5),
	.in6(q_Reg6),
	.in7(q_Reg7),
	.in8(q_Reg8),
	.in9(q_Reg9),
	.sel(r_addr_b),
	.out(r_data_b));

assign	we_dec = we_dec_ALTERA_SYNTHESIZED;

endmodule
