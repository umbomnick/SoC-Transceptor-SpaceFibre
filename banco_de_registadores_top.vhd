-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
-- CREATED		"Mon Aug 31 13:26:03 2026"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY banco_de_registadores_top IS 
	PORT
	(
		we :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		rst_n :  IN  STD_LOGIC;
		r_addr_a :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		r_addr_b :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		w_addr :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		w_data :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		r_data_a :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		r_data_b :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		we_dec :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END banco_de_registadores_top;

ARCHITECTURE bdf_type OF banco_de_registadores_top IS 

COMPONENT register_8bit
	PORT(clk : IN STD_LOGIC;
		 rst_n : IN STD_LOGIC;
		 we : IN STD_LOGIC;
		 d_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 q_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT decoder_4_to_16
	PORT(we : IN STD_LOGIC;
		 w_addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 we_dec : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux_16to1_8bit
	PORT(in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 in17 : IN STD_LOGIC;
		 in16 : IN STD_LOGIC;
		 in15 : IN STD_LOGIC;
		 in14 : IN STD_LOGIC;
		 in13 : IN STD_LOGIC;
		 in12 : IN STD_LOGIC;
		 in11 : IN STD_LOGIC;
		 in10 : IN STD_LOGIC;
		 in107 : IN STD_LOGIC;
		 in106 : IN STD_LOGIC;
		 in105 : IN STD_LOGIC;
		 in104 : IN STD_LOGIC;
		 in103 : IN STD_LOGIC;
		 in102 : IN STD_LOGIC;
		 in101 : IN STD_LOGIC;
		 in100 : IN STD_LOGIC;
		 in117 : IN STD_LOGIC;
		 in116 : IN STD_LOGIC;
		 in115 : IN STD_LOGIC;
		 in114 : IN STD_LOGIC;
		 in113 : IN STD_LOGIC;
		 in112 : IN STD_LOGIC;
		 in111 : IN STD_LOGIC;
		 in110 : IN STD_LOGIC;
		 in127 : IN STD_LOGIC;
		 in126 : IN STD_LOGIC;
		 in125 : IN STD_LOGIC;
		 in124 : IN STD_LOGIC;
		 in123 : IN STD_LOGIC;
		 in122 : IN STD_LOGIC;
		 in121 : IN STD_LOGIC;
		 in120 : IN STD_LOGIC;
		 in137 : IN STD_LOGIC;
		 in136 : IN STD_LOGIC;
		 in135 : IN STD_LOGIC;
		 in134 : IN STD_LOGIC;
		 in133 : IN STD_LOGIC;
		 in132 : IN STD_LOGIC;
		 in131 : IN STD_LOGIC;
		 in130 : IN STD_LOGIC;
		 in147 : IN STD_LOGIC;
		 in146 : IN STD_LOGIC;
		 in145 : IN STD_LOGIC;
		 in144 : IN STD_LOGIC;
		 in143 : IN STD_LOGIC;
		 in142 : IN STD_LOGIC;
		 in141 : IN STD_LOGIC;
		 in140 : IN STD_LOGIC;
		 in157 : IN STD_LOGIC;
		 in156 : IN STD_LOGIC;
		 in155 : IN STD_LOGIC;
		 in154 : IN STD_LOGIC;
		 in153 : IN STD_LOGIC;
		 in152 : IN STD_LOGIC;
		 in151 : IN STD_LOGIC;
		 in150 : IN STD_LOGIC;
		 in2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 in3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 in4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 in5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 in6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 in7 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 in8 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 in9 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	q_Reg0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	q_Reg10 :  STD_LOGIC;
SIGNAL	q_Reg100 :  STD_LOGIC;
SIGNAL	q_Reg101 :  STD_LOGIC;
SIGNAL	q_Reg102 :  STD_LOGIC;
SIGNAL	q_Reg103 :  STD_LOGIC;
SIGNAL	q_Reg104 :  STD_LOGIC;
SIGNAL	q_Reg105 :  STD_LOGIC;
SIGNAL	q_Reg106 :  STD_LOGIC;
SIGNAL	q_Reg107 :  STD_LOGIC;
SIGNAL	q_Reg11 :  STD_LOGIC;
SIGNAL	q_Reg110 :  STD_LOGIC;
SIGNAL	q_Reg111 :  STD_LOGIC;
SIGNAL	q_Reg112 :  STD_LOGIC;
SIGNAL	q_Reg113 :  STD_LOGIC;
SIGNAL	q_Reg114 :  STD_LOGIC;
SIGNAL	q_Reg115 :  STD_LOGIC;
SIGNAL	q_Reg116 :  STD_LOGIC;
SIGNAL	q_Reg117 :  STD_LOGIC;
SIGNAL	q_Reg12 :  STD_LOGIC;
SIGNAL	q_Reg120 :  STD_LOGIC;
SIGNAL	q_Reg121 :  STD_LOGIC;
SIGNAL	q_Reg122 :  STD_LOGIC;
SIGNAL	q_Reg123 :  STD_LOGIC;
SIGNAL	q_Reg124 :  STD_LOGIC;
SIGNAL	q_Reg125 :  STD_LOGIC;
SIGNAL	q_Reg126 :  STD_LOGIC;
SIGNAL	q_Reg127 :  STD_LOGIC;
SIGNAL	q_Reg13 :  STD_LOGIC;
SIGNAL	q_Reg130 :  STD_LOGIC;
SIGNAL	q_Reg131 :  STD_LOGIC;
SIGNAL	q_Reg132 :  STD_LOGIC;
SIGNAL	q_Reg133 :  STD_LOGIC;
SIGNAL	q_Reg134 :  STD_LOGIC;
SIGNAL	q_Reg135 :  STD_LOGIC;
SIGNAL	q_Reg136 :  STD_LOGIC;
SIGNAL	q_Reg137 :  STD_LOGIC;
SIGNAL	q_Reg14 :  STD_LOGIC;
SIGNAL	q_Reg140 :  STD_LOGIC;
SIGNAL	q_Reg141 :  STD_LOGIC;
SIGNAL	q_Reg142 :  STD_LOGIC;
SIGNAL	q_Reg143 :  STD_LOGIC;
SIGNAL	q_Reg144 :  STD_LOGIC;
SIGNAL	q_Reg145 :  STD_LOGIC;
SIGNAL	q_Reg146 :  STD_LOGIC;
SIGNAL	q_Reg147 :  STD_LOGIC;
SIGNAL	q_Reg15 :  STD_LOGIC;
SIGNAL	q_Reg150 :  STD_LOGIC;
SIGNAL	q_Reg151 :  STD_LOGIC;
SIGNAL	q_Reg152 :  STD_LOGIC;
SIGNAL	q_Reg153 :  STD_LOGIC;
SIGNAL	q_Reg154 :  STD_LOGIC;
SIGNAL	q_Reg155 :  STD_LOGIC;
SIGNAL	q_Reg156 :  STD_LOGIC;
SIGNAL	q_Reg157 :  STD_LOGIC;
SIGNAL	q_Reg16 :  STD_LOGIC;
SIGNAL	q_Reg17 :  STD_LOGIC;
SIGNAL	q_Reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	q_Reg3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	q_Reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	q_Reg5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	q_Reg6 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	q_Reg7 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	q_Reg8 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	q_Reg9 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	we_dec_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL	GDFX_TEMP_SIGNAL_6 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN 

q_Reg17 <= GDFX_TEMP_SIGNAL_6(7);
q_Reg16 <= GDFX_TEMP_SIGNAL_6(6);
q_Reg15 <= GDFX_TEMP_SIGNAL_6(5);
q_Reg14 <= GDFX_TEMP_SIGNAL_6(4);
q_Reg13 <= GDFX_TEMP_SIGNAL_6(3);
q_Reg12 <= GDFX_TEMP_SIGNAL_6(2);
q_Reg11 <= GDFX_TEMP_SIGNAL_6(1);
q_Reg10 <= GDFX_TEMP_SIGNAL_6(0);

q_Reg157 <= GDFX_TEMP_SIGNAL_5(7);
q_Reg156 <= GDFX_TEMP_SIGNAL_5(6);
q_Reg155 <= GDFX_TEMP_SIGNAL_5(5);
q_Reg154 <= GDFX_TEMP_SIGNAL_5(4);
q_Reg153 <= GDFX_TEMP_SIGNAL_5(3);
q_Reg152 <= GDFX_TEMP_SIGNAL_5(2);
q_Reg151 <= GDFX_TEMP_SIGNAL_5(1);
q_Reg150 <= GDFX_TEMP_SIGNAL_5(0);

q_Reg147 <= GDFX_TEMP_SIGNAL_4(7);
q_Reg146 <= GDFX_TEMP_SIGNAL_4(6);
q_Reg145 <= GDFX_TEMP_SIGNAL_4(5);
q_Reg144 <= GDFX_TEMP_SIGNAL_4(4);
q_Reg143 <= GDFX_TEMP_SIGNAL_4(3);
q_Reg142 <= GDFX_TEMP_SIGNAL_4(2);
q_Reg141 <= GDFX_TEMP_SIGNAL_4(1);
q_Reg140 <= GDFX_TEMP_SIGNAL_4(0);

q_Reg137 <= GDFX_TEMP_SIGNAL_3(7);
q_Reg136 <= GDFX_TEMP_SIGNAL_3(6);
q_Reg135 <= GDFX_TEMP_SIGNAL_3(5);
q_Reg134 <= GDFX_TEMP_SIGNAL_3(4);
q_Reg133 <= GDFX_TEMP_SIGNAL_3(3);
q_Reg132 <= GDFX_TEMP_SIGNAL_3(2);
q_Reg131 <= GDFX_TEMP_SIGNAL_3(1);
q_Reg130 <= GDFX_TEMP_SIGNAL_3(0);

q_Reg127 <= GDFX_TEMP_SIGNAL_2(7);
q_Reg126 <= GDFX_TEMP_SIGNAL_2(6);
q_Reg125 <= GDFX_TEMP_SIGNAL_2(5);
q_Reg124 <= GDFX_TEMP_SIGNAL_2(4);
q_Reg123 <= GDFX_TEMP_SIGNAL_2(3);
q_Reg122 <= GDFX_TEMP_SIGNAL_2(2);
q_Reg121 <= GDFX_TEMP_SIGNAL_2(1);
q_Reg120 <= GDFX_TEMP_SIGNAL_2(0);

q_Reg117 <= GDFX_TEMP_SIGNAL_1(7);
q_Reg116 <= GDFX_TEMP_SIGNAL_1(6);
q_Reg115 <= GDFX_TEMP_SIGNAL_1(5);
q_Reg114 <= GDFX_TEMP_SIGNAL_1(4);
q_Reg113 <= GDFX_TEMP_SIGNAL_1(3);
q_Reg112 <= GDFX_TEMP_SIGNAL_1(2);
q_Reg111 <= GDFX_TEMP_SIGNAL_1(1);
q_Reg110 <= GDFX_TEMP_SIGNAL_1(0);

q_Reg107 <= GDFX_TEMP_SIGNAL_0(7);
q_Reg106 <= GDFX_TEMP_SIGNAL_0(6);
q_Reg105 <= GDFX_TEMP_SIGNAL_0(5);
q_Reg104 <= GDFX_TEMP_SIGNAL_0(4);
q_Reg103 <= GDFX_TEMP_SIGNAL_0(3);
q_Reg102 <= GDFX_TEMP_SIGNAL_0(2);
q_Reg101 <= GDFX_TEMP_SIGNAL_0(1);
q_Reg100 <= GDFX_TEMP_SIGNAL_0(0);



b2v_8_registrador : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(7),
		 d_in => w_data,
		 q_out => q_Reg7);


b2v_inst : decoder_4_to_16
PORT MAP(we => we,
		 w_addr => w_addr,
		 we_dec => we_dec_ALTERA_SYNTHESIZED);


b2v_inst11 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(8),
		 d_in => w_data,
		 q_out => q_Reg8);


b2v_inst12 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(9),
		 d_in => w_data,
		 q_out => q_Reg9);


b2v_inst13 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(10),
		 d_in => w_data,
		 q_out => GDFX_TEMP_SIGNAL_0);


b2v_inst14 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(11),
		 d_in => w_data,
		 q_out => GDFX_TEMP_SIGNAL_1);


b2v_inst15 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(12),
		 d_in => w_data,
		 q_out => GDFX_TEMP_SIGNAL_2);


b2v_inst16 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(13),
		 d_in => w_data,
		 q_out => GDFX_TEMP_SIGNAL_3);


b2v_inst17 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(14),
		 d_in => w_data,
		 q_out => GDFX_TEMP_SIGNAL_4);


b2v_inst18 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(15),
		 d_in => w_data,
		 q_out => GDFX_TEMP_SIGNAL_5);


b2v_inst3 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(0),
		 d_in => w_data,
		 q_out => q_Reg0);


b2v_inst4 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(1),
		 d_in => w_data,
		 q_out => GDFX_TEMP_SIGNAL_6);


b2v_inst5 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(2),
		 d_in => w_data,
		 q_out => q_Reg2);


b2v_inst6 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(3),
		 d_in => w_data,
		 q_out => q_Reg3);


b2v_inst7 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(4),
		 d_in => w_data,
		 q_out => q_Reg4);


b2v_inst8 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(5),
		 d_in => w_data,
		 q_out => q_Reg5);


b2v_inst9 : register_8bit
PORT MAP(clk => clk,
		 rst_n => rst_n,
		 we => we_dec_ALTERA_SYNTHESIZED(6),
		 d_in => w_data,
		 q_out => q_Reg6);


b2v_Porta_A_Leitura : mux_16to1_8bit
PORT MAP(in0 => q_Reg0,
		 in17 => q_Reg17,
		 in16 => q_Reg16,
		 in15 => q_Reg15,
		 in14 => q_Reg14,
		 in13 => q_Reg13,
		 in12 => q_Reg12,
		 in11 => q_Reg11,
		 in10 => q_Reg10,
		 in107 => q_Reg107,
		 in106 => q_Reg106,
		 in105 => q_Reg105,
		 in104 => q_Reg104,
		 in103 => q_Reg103,
		 in102 => q_Reg102,
		 in101 => q_Reg101,
		 in100 => q_Reg100,
		 in117 => q_Reg117,
		 in116 => q_Reg116,
		 in115 => q_Reg115,
		 in114 => q_Reg114,
		 in113 => q_Reg113,
		 in112 => q_Reg112,
		 in111 => q_Reg111,
		 in110 => q_Reg110,
		 in127 => q_Reg127,
		 in126 => q_Reg126,
		 in125 => q_Reg125,
		 in124 => q_Reg124,
		 in123 => q_Reg123,
		 in122 => q_Reg122,
		 in121 => q_Reg121,
		 in120 => q_Reg120,
		 in137 => q_Reg137,
		 in136 => q_Reg136,
		 in135 => q_Reg135,
		 in134 => q_Reg134,
		 in133 => q_Reg133,
		 in132 => q_Reg132,
		 in131 => q_Reg131,
		 in130 => q_Reg130,
		 in147 => q_Reg147,
		 in146 => q_Reg146,
		 in145 => q_Reg145,
		 in144 => q_Reg144,
		 in143 => q_Reg143,
		 in142 => q_Reg142,
		 in141 => q_Reg141,
		 in140 => q_Reg140,
		 in157 => q_Reg157,
		 in156 => q_Reg156,
		 in155 => q_Reg155,
		 in154 => q_Reg154,
		 in153 => q_Reg153,
		 in152 => q_Reg152,
		 in151 => q_Reg151,
		 in150 => q_Reg150,
		 in2 => q_Reg2,
		 in3 => q_Reg3,
		 in4 => q_Reg4,
		 in5 => q_Reg5,
		 in6 => q_Reg6,
		 in7 => q_Reg7,
		 in8 => q_Reg8,
		 in9 => q_Reg9,
		 sel => r_addr_a,
		 out => r_data_a);


b2v_Porta_B_Leitura : mux_16to1_8bit
PORT MAP(in0 => q_Reg0,
		 in17 => q_Reg17,
		 in16 => q_Reg16,
		 in15 => q_Reg15,
		 in14 => q_Reg14,
		 in13 => q_Reg13,
		 in12 => q_Reg12,
		 in11 => q_Reg11,
		 in10 => q_Reg10,
		 in107 => q_Reg107,
		 in106 => q_Reg106,
		 in105 => q_Reg105,
		 in104 => q_Reg104,
		 in103 => q_Reg103,
		 in102 => q_Reg102,
		 in101 => q_Reg101,
		 in100 => q_Reg100,
		 in117 => q_Reg117,
		 in116 => q_Reg116,
		 in115 => q_Reg115,
		 in114 => q_Reg114,
		 in113 => q_Reg113,
		 in112 => q_Reg112,
		 in111 => q_Reg111,
		 in110 => q_Reg110,
		 in127 => q_Reg127,
		 in126 => q_Reg126,
		 in125 => q_Reg125,
		 in124 => q_Reg124,
		 in123 => q_Reg123,
		 in122 => q_Reg122,
		 in121 => q_Reg121,
		 in120 => q_Reg120,
		 in137 => q_Reg137,
		 in136 => q_Reg136,
		 in135 => q_Reg135,
		 in134 => q_Reg134,
		 in133 => q_Reg133,
		 in132 => q_Reg132,
		 in131 => q_Reg131,
		 in130 => q_Reg130,
		 in147 => q_Reg147,
		 in146 => q_Reg146,
		 in145 => q_Reg145,
		 in144 => q_Reg144,
		 in143 => q_Reg143,
		 in142 => q_Reg142,
		 in141 => q_Reg141,
		 in140 => q_Reg140,
		 in157 => q_Reg157,
		 in156 => q_Reg156,
		 in155 => q_Reg155,
		 in154 => q_Reg154,
		 in153 => q_Reg153,
		 in152 => q_Reg152,
		 in151 => q_Reg151,
		 in150 => q_Reg150,
		 in2 => q_Reg2,
		 in3 => q_Reg3,
		 in4 => q_Reg4,
		 in5 => q_Reg5,
		 in6 => q_Reg6,
		 in7 => q_Reg7,
		 in8 => q_Reg8,
		 in9 => q_Reg9,
		 sel => r_addr_b,
		 out => r_data_b);

we_dec <= we_dec_ALTERA_SYNTHESIZED;

q_Reg10 <= GDFX_TEMP_SIGNAL_6(0);
q_Reg100 <= GDFX_TEMP_SIGNAL_0(0);
q_Reg101 <= GDFX_TEMP_SIGNAL_0(1);
q_Reg102 <= GDFX_TEMP_SIGNAL_0(2);
q_Reg103 <= GDFX_TEMP_SIGNAL_0(3);
q_Reg104 <= GDFX_TEMP_SIGNAL_0(4);
q_Reg105 <= GDFX_TEMP_SIGNAL_0(5);
q_Reg106 <= GDFX_TEMP_SIGNAL_0(6);
q_Reg107 <= GDFX_TEMP_SIGNAL_0(7);
q_Reg11 <= GDFX_TEMP_SIGNAL_6(1);
q_Reg110 <= GDFX_TEMP_SIGNAL_1(0);
q_Reg111 <= GDFX_TEMP_SIGNAL_1(1);
q_Reg112 <= GDFX_TEMP_SIGNAL_1(2);
q_Reg113 <= GDFX_TEMP_SIGNAL_1(3);
q_Reg114 <= GDFX_TEMP_SIGNAL_1(4);
q_Reg115 <= GDFX_TEMP_SIGNAL_1(5);
q_Reg116 <= GDFX_TEMP_SIGNAL_1(6);
q_Reg117 <= GDFX_TEMP_SIGNAL_1(7);
q_Reg12 <= GDFX_TEMP_SIGNAL_6(2);
q_Reg120 <= GDFX_TEMP_SIGNAL_2(0);
q_Reg121 <= GDFX_TEMP_SIGNAL_2(1);
q_Reg122 <= GDFX_TEMP_SIGNAL_2(2);
q_Reg123 <= GDFX_TEMP_SIGNAL_2(3);
q_Reg124 <= GDFX_TEMP_SIGNAL_2(4);
q_Reg125 <= GDFX_TEMP_SIGNAL_2(5);
q_Reg126 <= GDFX_TEMP_SIGNAL_2(6);
q_Reg127 <= GDFX_TEMP_SIGNAL_2(7);
q_Reg13 <= GDFX_TEMP_SIGNAL_6(3);
q_Reg130 <= GDFX_TEMP_SIGNAL_3(0);
q_Reg131 <= GDFX_TEMP_SIGNAL_3(1);
q_Reg132 <= GDFX_TEMP_SIGNAL_3(2);
q_Reg133 <= GDFX_TEMP_SIGNAL_3(3);
q_Reg134 <= GDFX_TEMP_SIGNAL_3(4);
q_Reg135 <= GDFX_TEMP_SIGNAL_3(5);
q_Reg136 <= GDFX_TEMP_SIGNAL_3(6);
q_Reg137 <= GDFX_TEMP_SIGNAL_3(7);
q_Reg14 <= GDFX_TEMP_SIGNAL_6(4);
q_Reg140 <= GDFX_TEMP_SIGNAL_4(0);
q_Reg141 <= GDFX_TEMP_SIGNAL_4(1);
q_Reg142 <= GDFX_TEMP_SIGNAL_4(2);
q_Reg143 <= GDFX_TEMP_SIGNAL_4(3);
q_Reg144 <= GDFX_TEMP_SIGNAL_4(4);
q_Reg145 <= GDFX_TEMP_SIGNAL_4(5);
q_Reg146 <= GDFX_TEMP_SIGNAL_4(6);
q_Reg147 <= GDFX_TEMP_SIGNAL_4(7);
q_Reg15 <= GDFX_TEMP_SIGNAL_6(5);
q_Reg150 <= GDFX_TEMP_SIGNAL_5(0);
q_Reg151 <= GDFX_TEMP_SIGNAL_5(1);
q_Reg152 <= GDFX_TEMP_SIGNAL_5(2);
q_Reg153 <= GDFX_TEMP_SIGNAL_5(3);
q_Reg154 <= GDFX_TEMP_SIGNAL_5(4);
q_Reg155 <= GDFX_TEMP_SIGNAL_5(5);
q_Reg156 <= GDFX_TEMP_SIGNAL_5(6);
q_Reg157 <= GDFX_TEMP_SIGNAL_5(7);
q_Reg16 <= GDFX_TEMP_SIGNAL_6(6);
q_Reg17 <= GDFX_TEMP_SIGNAL_6(7);
END bdf_type;