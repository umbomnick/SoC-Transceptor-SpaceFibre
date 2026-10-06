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

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

-- DATE "08/26/2026 14:05:14"

-- 
-- Device: Altera EP4CGX22CF19C6 Package FBGA324
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIV.CYCLONEIV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	banco_de_registadores_top IS
    PORT (
	r_data_a : OUT std_logic_vector(7 DOWNTO 0);
	clk : IN std_logic;
	rst_n : IN std_logic;
	we_dec : OUT std_logic_vector(15 DOWNTO 0);
	we : IN std_logic;
	w_addr : IN std_logic_vector(3 DOWNTO 0);
	w_data : IN std_logic_vector(7 DOWNTO 0);
	r_addr_a : IN std_logic_vector(3 DOWNTO 0);
	r_data_b : OUT std_logic_vector(7 DOWNTO 0);
	r_addr_b : IN std_logic_vector(3 DOWNTO 0)
	);
END banco_de_registadores_top;

-- Design Ports Information
-- r_data_a[7]	=>  Location: PIN_J17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_a[6]	=>  Location: PIN_U13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_a[5]	=>  Location: PIN_D18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_a[4]	=>  Location: PIN_M18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_a[3]	=>  Location: PIN_G17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_a[2]	=>  Location: PIN_G15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_a[1]	=>  Location: PIN_J16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_a[0]	=>  Location: PIN_B10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[15]	=>  Location: PIN_A13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[14]	=>  Location: PIN_B16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[13]	=>  Location: PIN_C13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[12]	=>  Location: PIN_A16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[11]	=>  Location: PIN_B13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[10]	=>  Location: PIN_E15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[9]	=>  Location: PIN_D16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[8]	=>  Location: PIN_C12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[7]	=>  Location: PIN_A14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[6]	=>  Location: PIN_A18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[5]	=>  Location: PIN_C17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[4]	=>  Location: PIN_E12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[3]	=>  Location: PIN_A17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[2]	=>  Location: PIN_A7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[1]	=>  Location: PIN_B15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we_dec[0]	=>  Location: PIN_A15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_b[7]	=>  Location: PIN_C10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_b[6]	=>  Location: PIN_B9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_b[5]	=>  Location: PIN_P10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_b[4]	=>  Location: PIN_C9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_b[3]	=>  Location: PIN_D17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_b[2]	=>  Location: PIN_F18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_b[1]	=>  Location: PIN_C8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_data_b[0]	=>  Location: PIN_A11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_addr_a[1]	=>  Location: PIN_E18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_addr_a[0]	=>  Location: PIN_F16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_addr_a[3]	=>  Location: PIN_D10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_addr_a[2]	=>  Location: PIN_A9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- we	=>  Location: PIN_D13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_addr[0]	=>  Location: PIN_D14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_addr[1]	=>  Location: PIN_D15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_addr[2]	=>  Location: PIN_C15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_addr[3]	=>  Location: PIN_C14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_addr_b[1]	=>  Location: PIN_C11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_addr_b[0]	=>  Location: PIN_D9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_addr_b[3]	=>  Location: PIN_G16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- r_addr_b[2]	=>  Location: PIN_E10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_data[7]	=>  Location: PIN_A8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_M10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rst_n	=>  Location: PIN_M9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_data[6]	=>  Location: PIN_H16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_data[5]	=>  Location: PIN_G18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_data[4]	=>  Location: PIN_A10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_data[3]	=>  Location: PIN_D11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_data[2]	=>  Location: PIN_D12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_data[1]	=>  Location: PIN_V13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- w_data[0]	=>  Location: PIN_F17,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF banco_de_registadores_top IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_r_data_a : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_clk : std_logic;
SIGNAL ww_rst_n : std_logic;
SIGNAL ww_we_dec : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_we : std_logic;
SIGNAL ww_w_addr : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_w_data : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_r_addr_a : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_r_data_b : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_r_addr_b : std_logic_vector(3 DOWNTO 0);
SIGNAL \rst_n~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \clk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \inst9|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \inst7|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux0~2_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux0~3_combout\ : std_logic;
SIGNAL \inst3|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux0~7_combout\ : std_logic;
SIGNAL \inst13|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux1~0_combout\ : std_logic;
SIGNAL \inst7|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux1~4_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux1~5_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux1~7_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux2~0_combout\ : std_logic;
SIGNAL \inst12|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux2~2_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux2~3_combout\ : std_logic;
SIGNAL \inst5|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \inst3|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux2~4_combout\ : std_logic;
SIGNAL \inst12|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \inst4|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux3~0_combout\ : std_logic;
SIGNAL \inst9|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \inst5|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux3~2_combout\ : std_logic;
SIGNAL \inst11|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \inst7|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux3~4_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux3~5_combout\ : std_logic;
SIGNAL \inst14|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \inst6|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux3~7_combout\ : std_logic;
SIGNAL \inst9|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \inst7|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux4~2_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux4~3_combout\ : std_logic;
SIGNAL \inst17|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \inst15|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux4~7_combout\ : std_logic;
SIGNAL \inst13|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux5~0_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux5~4_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux5~5_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux6~0_combout\ : std_logic;
SIGNAL \inst6|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \inst13|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \inst9|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \inst5|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux7~2_combout\ : std_logic;
SIGNAL \inst17|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux7~3_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux7~4_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux7~7_combout\ : std_logic;
SIGNAL \inst|Decoder0~3_combout\ : std_logic;
SIGNAL \inst|Decoder0~10_combout\ : std_logic;
SIGNAL \inst|Decoder0~13_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux0~2_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux0~4_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux0~5_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux1~2_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux1~3_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux2~4_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux2~5_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux2~7_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux3~0_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux3~2_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux3~7_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux4~2_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux4~4_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux4~5_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux4~7_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux6~2_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux6~4_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux6~5_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux6~7_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux7~2_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux7~3_combout\ : std_logic;
SIGNAL \w_addr[0]~input_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputclkctrl_outclk\ : std_logic;
SIGNAL \r_data_a[7]~output_o\ : std_logic;
SIGNAL \r_data_a[6]~output_o\ : std_logic;
SIGNAL \r_data_a[5]~output_o\ : std_logic;
SIGNAL \r_data_a[4]~output_o\ : std_logic;
SIGNAL \r_data_a[3]~output_o\ : std_logic;
SIGNAL \r_data_a[2]~output_o\ : std_logic;
SIGNAL \r_data_a[1]~output_o\ : std_logic;
SIGNAL \r_data_a[0]~output_o\ : std_logic;
SIGNAL \we_dec[15]~output_o\ : std_logic;
SIGNAL \we_dec[14]~output_o\ : std_logic;
SIGNAL \we_dec[13]~output_o\ : std_logic;
SIGNAL \we_dec[12]~output_o\ : std_logic;
SIGNAL \we_dec[11]~output_o\ : std_logic;
SIGNAL \we_dec[10]~output_o\ : std_logic;
SIGNAL \we_dec[9]~output_o\ : std_logic;
SIGNAL \we_dec[8]~output_o\ : std_logic;
SIGNAL \we_dec[7]~output_o\ : std_logic;
SIGNAL \we_dec[6]~output_o\ : std_logic;
SIGNAL \we_dec[5]~output_o\ : std_logic;
SIGNAL \we_dec[4]~output_o\ : std_logic;
SIGNAL \we_dec[3]~output_o\ : std_logic;
SIGNAL \we_dec[2]~output_o\ : std_logic;
SIGNAL \we_dec[1]~output_o\ : std_logic;
SIGNAL \we_dec[0]~output_o\ : std_logic;
SIGNAL \r_data_b[7]~output_o\ : std_logic;
SIGNAL \r_data_b[6]~output_o\ : std_logic;
SIGNAL \r_data_b[5]~output_o\ : std_logic;
SIGNAL \r_data_b[4]~output_o\ : std_logic;
SIGNAL \r_data_b[3]~output_o\ : std_logic;
SIGNAL \r_data_b[2]~output_o\ : std_logic;
SIGNAL \r_data_b[1]~output_o\ : std_logic;
SIGNAL \r_data_b[0]~output_o\ : std_logic;
SIGNAL \r_addr_a[0]~input_o\ : std_logic;
SIGNAL \w_data[7]~input_o\ : std_logic;
SIGNAL \rst_n~input_o\ : std_logic;
SIGNAL \rst_n~inputclkctrl_outclk\ : std_logic;
SIGNAL \w_addr[2]~input_o\ : std_logic;
SIGNAL \w_addr[3]~input_o\ : std_logic;
SIGNAL \w_addr[1]~input_o\ : std_logic;
SIGNAL \inst|Decoder0~6_combout\ : std_logic;
SIGNAL \we~input_o\ : std_logic;
SIGNAL \inst|we_dec[9]~6_combout\ : std_logic;
SIGNAL \inst12|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \r_addr_a[1]~input_o\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux0~0_combout\ : std_logic;
SIGNAL \inst|Decoder0~5_combout\ : std_logic;
SIGNAL \inst|we_dec[10]~5_combout\ : std_logic;
SIGNAL \inst13|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \inst|Decoder0~4_combout\ : std_logic;
SIGNAL \inst|we_dec[11]~4_combout\ : std_logic;
SIGNAL \inst14|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux0~1_combout\ : std_logic;
SIGNAL \inst|Decoder0~12_combout\ : std_logic;
SIGNAL \inst|we_dec[3]~12_combout\ : std_logic;
SIGNAL \inst6|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \inst|we_dec[2]~13_combout\ : std_logic;
SIGNAL \inst5|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \inst|Decoder0~14_combout\ : std_logic;
SIGNAL \inst|we_dec[1]~14_combout\ : std_logic;
SIGNAL \inst4|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux0~4_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux0~5_combout\ : std_logic;
SIGNAL \r_addr_a[2]~input_o\ : std_logic;
SIGNAL \r_addr_a[3]~input_o\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux0~6_combout\ : std_logic;
SIGNAL \inst|Decoder0~0_combout\ : std_logic;
SIGNAL \inst|we_dec[15]~0_combout\ : std_logic;
SIGNAL \inst18|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \inst|Decoder0~2_combout\ : std_logic;
SIGNAL \inst|we_dec[13]~2_combout\ : std_logic;
SIGNAL \inst16|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux0~8_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux0~9_combout\ : std_logic;
SIGNAL \w_data[6]~input_o\ : std_logic;
SIGNAL \inst4|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \inst|we_dec[5]~10_combout\ : std_logic;
SIGNAL \inst8|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux1~2_combout\ : std_logic;
SIGNAL \inst12|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \inst16|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux1~3_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux1~6_combout\ : std_logic;
SIGNAL \inst18|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \inst14|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux1~8_combout\ : std_logic;
SIGNAL \inst|Decoder0~9_combout\ : std_logic;
SIGNAL \inst|we_dec[6]~9_combout\ : std_logic;
SIGNAL \inst9|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \inst|Decoder0~1_combout\ : std_logic;
SIGNAL \inst|we_dec[14]~1_combout\ : std_logic;
SIGNAL \inst17|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux1~1_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux1~9_combout\ : std_logic;
SIGNAL \w_data[5]~input_o\ : std_logic;
SIGNAL \inst18|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \inst17|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \inst|we_dec[12]~3_combout\ : std_logic;
SIGNAL \inst15|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \inst16|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux2~7_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux2~8_combout\ : std_logic;
SIGNAL \inst9|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \inst|Decoder0~8_combout\ : std_logic;
SIGNAL \inst|we_dec[7]~8_combout\ : std_logic;
SIGNAL \8_registrador|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux2~1_combout\ : std_logic;
SIGNAL \inst6|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \inst4|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux2~5_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux2~6_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux2~9_combout\ : std_logic;
SIGNAL \w_data[4]~input_o\ : std_logic;
SIGNAL \8_registrador|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \inst18|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux3~8_combout\ : std_logic;
SIGNAL \inst8|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \inst16|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux3~1_combout\ : std_logic;
SIGNAL \inst17|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \inst13|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux3~3_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux3~6_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux3~9_combout\ : std_logic;
SIGNAL \w_data[3]~input_o\ : std_logic;
SIGNAL \inst18|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \inst16|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux4~8_combout\ : std_logic;
SIGNAL \inst4|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \inst|Decoder0~15_combout\ : std_logic;
SIGNAL \inst|we_dec[0]~15_combout\ : std_logic;
SIGNAL \inst3|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux4~4_combout\ : std_logic;
SIGNAL \inst5|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \inst6|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux4~5_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux4~6_combout\ : std_logic;
SIGNAL \inst14|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \inst13|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \inst12|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux4~0_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux4~1_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux4~9_combout\ : std_logic;
SIGNAL \w_data[2]~input_o\ : std_logic;
SIGNAL \inst14|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \8_registrador|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \inst6|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux5~7_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux5~8_combout\ : std_logic;
SIGNAL \inst12|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \inst4|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \inst8|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux5~2_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux5~3_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux5~6_combout\ : std_logic;
SIGNAL \inst9|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \inst17|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux5~1_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux5~9_combout\ : std_logic;
SIGNAL \w_data[1]~input_o\ : std_logic;
SIGNAL \8_registrador|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \inst9|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux6~1_combout\ : std_logic;
SIGNAL \inst|Decoder0~7_combout\ : std_logic;
SIGNAL \inst|we_dec[8]~7_combout\ : std_logic;
SIGNAL \inst11|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \inst13|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux6~2_combout\ : std_logic;
SIGNAL \inst12|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux6~3_combout\ : std_logic;
SIGNAL \inst5|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \inst3|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux6~4_combout\ : std_logic;
SIGNAL \inst4|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux6~5_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux6~6_combout\ : std_logic;
SIGNAL \inst18|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \inst17|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \inst15|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \inst16|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux6~7_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux6~8_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux6~9_combout\ : std_logic;
SIGNAL \w_data[0]~input_o\ : std_logic;
SIGNAL \inst18|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \8_registrador|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux7~8_combout\ : std_logic;
SIGNAL \inst15|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \inst11|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux7~5_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux7~6_combout\ : std_logic;
SIGNAL \inst12|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux7~0_combout\ : std_logic;
SIGNAL \inst8|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \inst16|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux7~1_combout\ : std_logic;
SIGNAL \Porta_A_Leitura|Mux7~9_combout\ : std_logic;
SIGNAL \inst|Decoder0~11_combout\ : std_logic;
SIGNAL \inst|we_dec[4]~11_combout\ : std_logic;
SIGNAL \r_addr_b[1]~input_o\ : std_logic;
SIGNAL \r_addr_b[0]~input_o\ : std_logic;
SIGNAL \inst11|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux0~0_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux0~1_combout\ : std_logic;
SIGNAL \inst17|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \inst15|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux0~7_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux0~8_combout\ : std_logic;
SIGNAL \r_addr_b[3]~input_o\ : std_logic;
SIGNAL \8_registrador|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \inst8|dff_block[7].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux0~3_combout\ : std_logic;
SIGNAL \r_addr_b[2]~input_o\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux0~6_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux0~9_combout\ : std_logic;
SIGNAL \8_registrador|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \inst6|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux1~7_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux1~8_combout\ : std_logic;
SIGNAL \inst11|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \inst3|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux1~4_combout\ : std_logic;
SIGNAL \inst15|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux1~5_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux1~6_combout\ : std_logic;
SIGNAL \inst5|dff_block[6].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux1~0_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux1~1_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux1~9_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux2~8_combout\ : std_logic;
SIGNAL \inst8|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \inst7|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux2~0_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux2~1_combout\ : std_logic;
SIGNAL \inst14|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \inst13|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \inst11|dff_block[5].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux2~2_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux2~3_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux2~6_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux2~9_combout\ : std_logic;
SIGNAL \inst3|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux3~4_combout\ : std_logic;
SIGNAL \inst15|dff_block[4].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux3~5_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux3~3_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux3~6_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux3~8_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux3~1_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux3~9_combout\ : std_logic;
SIGNAL \inst11|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux4~0_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux4~1_combout\ : std_logic;
SIGNAL \inst8|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \8_registrador|dff_block[3].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux4~3_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux4~6_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux4~8_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux4~9_combout\ : std_logic;
SIGNAL \inst11|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \inst3|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux5~4_combout\ : std_logic;
SIGNAL \inst15|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \inst7|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux5~5_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux5~2_combout\ : std_logic;
SIGNAL \inst16|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux5~3_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux5~6_combout\ : std_logic;
SIGNAL \inst18|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux5~7_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux5~8_combout\ : std_logic;
SIGNAL \inst5|dff_block[2].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux5~0_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux5~1_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux5~9_combout\ : std_logic;
SIGNAL \inst7|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \inst8|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux6~0_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux6~1_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux6~8_combout\ : std_logic;
SIGNAL \inst14|dff_block[1].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux6~3_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux6~6_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux6~9_combout\ : std_logic;
SIGNAL \inst14|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \inst6|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux7~7_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux7~8_combout\ : std_logic;
SIGNAL \inst7|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \inst3|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux7~4_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux7~5_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux7~6_combout\ : std_logic;
SIGNAL \inst4|dff_block[0].dff_inst|q~q\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux7~0_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux7~1_combout\ : std_logic;
SIGNAL \Porta_B_Leitura|Mux7~9_combout\ : std_logic;

BEGIN

r_data_a <= ww_r_data_a;
ww_clk <= clk;
ww_rst_n <= rst_n;
we_dec <= ww_we_dec;
ww_we <= we;
ww_w_addr <= w_addr;
ww_w_data <= w_data;
ww_r_addr_a <= r_addr_a;
r_data_b <= ww_r_data_b;
ww_r_addr_b <= r_addr_b;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\rst_n~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \rst_n~input_o\);

\clk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \clk~input_o\);

-- Location: FF_X27_Y27_N25
\inst9|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst9|dff_block[7].dff_inst|q~q\);

-- Location: FF_X27_Y27_N27
\inst7|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[4]~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst7|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y27_N24
\Porta_A_Leitura|Mux0~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux0~2_combout\ = (\r_addr_a[1]~input_o\ & (((\inst9|dff_block[7].dff_inst|q~q\) # (\r_addr_a[0]~input_o\)))) # (!\r_addr_a[1]~input_o\ & (\inst7|dff_block[7].dff_inst|q~q\ & ((!\r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|dff_block[7].dff_inst|q~q\,
	datab => \r_addr_a[1]~input_o\,
	datac => \inst9|dff_block[7].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux0~2_combout\);

-- Location: LCCOMB_X28_Y27_N16
\Porta_A_Leitura|Mux0~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux0~3_combout\ = (\r_addr_a[0]~input_o\ & ((\Porta_A_Leitura|Mux0~2_combout\ & ((\8_registrador|dff_block[7].dff_inst|q~q\))) # (!\Porta_A_Leitura|Mux0~2_combout\ & (\inst8|dff_block[7].dff_inst|q~q\)))) # (!\r_addr_a[0]~input_o\ & 
-- (\Porta_A_Leitura|Mux0~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[0]~input_o\,
	datab => \Porta_A_Leitura|Mux0~2_combout\,
	datac => \inst8|dff_block[7].dff_inst|q~q\,
	datad => \8_registrador|dff_block[7].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux0~3_combout\);

-- Location: FF_X28_Y29_N3
\inst3|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[0]~15_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst3|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y29_N18
\Porta_A_Leitura|Mux0~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux0~7_combout\ = (\r_addr_a[1]~input_o\ & (((\inst17|dff_block[7].dff_inst|q~q\) # (\r_addr_a[0]~input_o\)))) # (!\r_addr_a[1]~input_o\ & (\inst15|dff_block[7].dff_inst|q~q\ & ((!\r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \inst15|dff_block[7].dff_inst|q~q\,
	datac => \inst17|dff_block[7].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux0~7_combout\);

-- Location: FF_X28_Y28_N19
\inst13|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[10]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst13|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y28_N18
\Porta_A_Leitura|Mux1~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux1~0_combout\ = (\r_addr_a[2]~input_o\ & (((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & ((\r_addr_a[3]~input_o\ & ((\inst13|dff_block[6].dff_inst|q~q\))) # (!\r_addr_a[3]~input_o\ & (\inst5|dff_block[6].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[2]~input_o\,
	datab => \inst5|dff_block[6].dff_inst|q~q\,
	datac => \inst13|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux1~0_combout\);

-- Location: FF_X27_Y27_N31
\inst7|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[4]~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst7|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y28_N20
\Porta_A_Leitura|Mux1~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux1~4_combout\ = (\r_addr_a[2]~input_o\ & (((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & ((\r_addr_a[3]~input_o\ & ((\inst11|dff_block[6].dff_inst|q~q\))) # (!\r_addr_a[3]~input_o\ & (\inst3|dff_block[6].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[2]~input_o\,
	datab => \inst3|dff_block[6].dff_inst|q~q\,
	datac => \inst11|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux1~4_combout\);

-- Location: LCCOMB_X27_Y27_N30
\Porta_A_Leitura|Mux1~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux1~5_combout\ = (\r_addr_a[2]~input_o\ & ((\Porta_A_Leitura|Mux1~4_combout\ & (\inst15|dff_block[6].dff_inst|q~q\)) # (!\Porta_A_Leitura|Mux1~4_combout\ & ((\inst7|dff_block[6].dff_inst|q~q\))))) # (!\r_addr_a[2]~input_o\ & 
-- (((\Porta_A_Leitura|Mux1~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst15|dff_block[6].dff_inst|q~q\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst7|dff_block[6].dff_inst|q~q\,
	datad => \Porta_A_Leitura|Mux1~4_combout\,
	combout => \Porta_A_Leitura|Mux1~5_combout\);

-- Location: LCCOMB_X29_Y29_N20
\Porta_A_Leitura|Mux1~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux1~7_combout\ = (\r_addr_a[2]~input_o\ & (((\8_registrador|dff_block[6].dff_inst|q~q\) # (\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & (\inst6|dff_block[6].dff_inst|q~q\ & ((!\r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|dff_block[6].dff_inst|q~q\,
	datab => \r_addr_a[2]~input_o\,
	datac => \8_registrador|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux1~7_combout\);

-- Location: LCCOMB_X28_Y27_N20
\Porta_A_Leitura|Mux2~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux2~0_combout\ = (\r_addr_a[0]~input_o\ & ((\r_addr_a[1]~input_o\) # ((\inst8|dff_block[5].dff_inst|q~q\)))) # (!\r_addr_a[0]~input_o\ & (!\r_addr_a[1]~input_o\ & ((\inst7|dff_block[5].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100110101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[0]~input_o\,
	datab => \r_addr_a[1]~input_o\,
	datac => \inst8|dff_block[5].dff_inst|q~q\,
	datad => \inst7|dff_block[5].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux2~0_combout\);

-- Location: FF_X27_Y28_N13
\inst12|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[9]~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst12|dff_block[5].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y28_N14
\Porta_A_Leitura|Mux2~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux2~2_combout\ = (\r_addr_a[1]~input_o\ & (((\inst13|dff_block[5].dff_inst|q~q\) # (\r_addr_a[0]~input_o\)))) # (!\r_addr_a[1]~input_o\ & (\inst11|dff_block[5].dff_inst|q~q\ & ((!\r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \inst11|dff_block[5].dff_inst|q~q\,
	datac => \inst13|dff_block[5].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux2~2_combout\);

-- Location: LCCOMB_X27_Y28_N12
\Porta_A_Leitura|Mux2~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux2~3_combout\ = (\Porta_A_Leitura|Mux2~2_combout\ & ((\inst14|dff_block[5].dff_inst|q~q\) # ((!\r_addr_a[0]~input_o\)))) # (!\Porta_A_Leitura|Mux2~2_combout\ & (((\inst12|dff_block[5].dff_inst|q~q\ & \r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst14|dff_block[5].dff_inst|q~q\,
	datab => \Porta_A_Leitura|Mux2~2_combout\,
	datac => \inst12|dff_block[5].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux2~3_combout\);

-- Location: FF_X27_Y29_N15
\inst5|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[2]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst5|dff_block[5].dff_inst|q~q\);

-- Location: FF_X28_Y29_N27
\inst3|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[0]~15_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst3|dff_block[5].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y29_N14
\Porta_A_Leitura|Mux2~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux2~4_combout\ = (\r_addr_a[1]~input_o\ & ((\r_addr_a[0]~input_o\) # ((\inst5|dff_block[5].dff_inst|q~q\)))) # (!\r_addr_a[1]~input_o\ & (!\r_addr_a[0]~input_o\ & ((\inst3|dff_block[5].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100110101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \r_addr_a[0]~input_o\,
	datac => \inst5|dff_block[5].dff_inst|q~q\,
	datad => \inst3|dff_block[5].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux2~4_combout\);

-- Location: FF_X27_Y28_N9
\inst12|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[9]~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst12|dff_block[4].dff_inst|q~q\);

-- Location: FF_X28_Y29_N5
\inst4|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[1]~14_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst4|dff_block[4].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y28_N8
\Porta_A_Leitura|Mux3~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux3~0_combout\ = (\r_addr_a[2]~input_o\ & (((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & ((\r_addr_a[3]~input_o\ & ((\inst12|dff_block[4].dff_inst|q~q\))) # (!\r_addr_a[3]~input_o\ & (\inst4|dff_block[4].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst4|dff_block[4].dff_inst|q~q\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst12|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux3~0_combout\);

-- Location: FF_X27_Y27_N1
\inst9|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst9|dff_block[4].dff_inst|q~q\);

-- Location: FF_X27_Y29_N9
\inst5|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[2]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst5|dff_block[4].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y27_N0
\Porta_A_Leitura|Mux3~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux3~2_combout\ = (\r_addr_a[2]~input_o\ & (((\inst9|dff_block[4].dff_inst|q~q\) # (\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & (\inst5|dff_block[4].dff_inst|q~q\ & ((!\r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst5|dff_block[4].dff_inst|q~q\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst9|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux3~2_combout\);

-- Location: FF_X28_Y28_N13
\inst11|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[8]~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst11|dff_block[4].dff_inst|q~q\);

-- Location: FF_X27_Y27_N11
\inst7|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[4]~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst7|dff_block[4].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y27_N10
\Porta_A_Leitura|Mux3~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux3~4_combout\ = (\r_addr_a[2]~input_o\ & (((\inst7|dff_block[4].dff_inst|q~q\) # (\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & (\inst3|dff_block[4].dff_inst|q~q\ & ((!\r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst3|dff_block[4].dff_inst|q~q\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst7|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux3~4_combout\);

-- Location: LCCOMB_X28_Y28_N12
\Porta_A_Leitura|Mux3~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux3~5_combout\ = (\Porta_A_Leitura|Mux3~4_combout\ & ((\inst15|dff_block[4].dff_inst|q~q\) # ((!\r_addr_a[3]~input_o\)))) # (!\Porta_A_Leitura|Mux3~4_combout\ & (((\inst11|dff_block[4].dff_inst|q~q\ & \r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux3~4_combout\,
	datab => \inst15|dff_block[4].dff_inst|q~q\,
	datac => \inst11|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux3~5_combout\);

-- Location: FF_X27_Y28_N19
\inst14|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[11]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst14|dff_block[4].dff_inst|q~q\);

-- Location: FF_X29_Y29_N13
\inst6|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[3]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst6|dff_block[4].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y28_N18
\Porta_A_Leitura|Mux3~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux3~7_combout\ = (\r_addr_a[2]~input_o\ & (((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & ((\r_addr_a[3]~input_o\ & ((\inst14|dff_block[4].dff_inst|q~q\))) # (!\r_addr_a[3]~input_o\ & (\inst6|dff_block[4].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|dff_block[4].dff_inst|q~q\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst14|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux3~7_combout\);

-- Location: FF_X27_Y27_N21
\inst9|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst9|dff_block[3].dff_inst|q~q\);

-- Location: FF_X27_Y27_N15
\inst7|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[4]~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst7|dff_block[3].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y27_N20
\Porta_A_Leitura|Mux4~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux4~2_combout\ = (\r_addr_a[1]~input_o\ & (((\inst9|dff_block[3].dff_inst|q~q\) # (\r_addr_a[0]~input_o\)))) # (!\r_addr_a[1]~input_o\ & (\inst7|dff_block[3].dff_inst|q~q\ & ((!\r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \inst7|dff_block[3].dff_inst|q~q\,
	datac => \inst9|dff_block[3].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux4~2_combout\);

-- Location: LCCOMB_X28_Y27_N10
\Porta_A_Leitura|Mux4~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux4~3_combout\ = (\r_addr_a[0]~input_o\ & ((\Porta_A_Leitura|Mux4~2_combout\ & ((\8_registrador|dff_block[3].dff_inst|q~q\))) # (!\Porta_A_Leitura|Mux4~2_combout\ & (\inst8|dff_block[3].dff_inst|q~q\)))) # (!\r_addr_a[0]~input_o\ & 
-- (\Porta_A_Leitura|Mux4~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[0]~input_o\,
	datab => \Porta_A_Leitura|Mux4~2_combout\,
	datac => \inst8|dff_block[3].dff_inst|q~q\,
	datad => \8_registrador|dff_block[3].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux4~3_combout\);

-- Location: FF_X27_Y29_N21
\inst17|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[14]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst17|dff_block[3].dff_inst|q~q\);

-- Location: FF_X27_Y30_N31
\inst15|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[12]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst15|dff_block[3].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y29_N20
\Porta_A_Leitura|Mux4~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux4~7_combout\ = (\r_addr_a[0]~input_o\ & (((\r_addr_a[1]~input_o\)))) # (!\r_addr_a[0]~input_o\ & ((\r_addr_a[1]~input_o\ & ((\inst17|dff_block[3].dff_inst|q~q\))) # (!\r_addr_a[1]~input_o\ & (\inst15|dff_block[3].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst15|dff_block[3].dff_inst|q~q\,
	datab => \r_addr_a[0]~input_o\,
	datac => \inst17|dff_block[3].dff_inst|q~q\,
	datad => \r_addr_a[1]~input_o\,
	combout => \Porta_A_Leitura|Mux4~7_combout\);

-- Location: FF_X28_Y28_N1
\inst13|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[10]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst13|dff_block[2].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y28_N0
\Porta_A_Leitura|Mux5~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux5~0_combout\ = (\r_addr_a[2]~input_o\ & (((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & ((\r_addr_a[3]~input_o\ & ((\inst13|dff_block[2].dff_inst|q~q\))) # (!\r_addr_a[3]~input_o\ & (\inst5|dff_block[2].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[2]~input_o\,
	datab => \inst5|dff_block[2].dff_inst|q~q\,
	datac => \inst13|dff_block[2].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux5~0_combout\);

-- Location: LCCOMB_X29_Y28_N26
\Porta_A_Leitura|Mux5~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux5~4_combout\ = (\r_addr_a[2]~input_o\ & (((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & ((\r_addr_a[3]~input_o\ & ((\inst11|dff_block[2].dff_inst|q~q\))) # (!\r_addr_a[3]~input_o\ & (\inst3|dff_block[2].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst3|dff_block[2].dff_inst|q~q\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst11|dff_block[2].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux5~4_combout\);

-- Location: LCCOMB_X28_Y26_N16
\Porta_A_Leitura|Mux5~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux5~5_combout\ = (\r_addr_a[2]~input_o\ & ((\Porta_A_Leitura|Mux5~4_combout\ & (\inst15|dff_block[2].dff_inst|q~q\)) # (!\Porta_A_Leitura|Mux5~4_combout\ & ((\inst7|dff_block[2].dff_inst|q~q\))))) # (!\r_addr_a[2]~input_o\ & 
-- (((\Porta_A_Leitura|Mux5~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[2]~input_o\,
	datab => \inst15|dff_block[2].dff_inst|q~q\,
	datac => \inst7|dff_block[2].dff_inst|q~q\,
	datad => \Porta_A_Leitura|Mux5~4_combout\,
	combout => \Porta_A_Leitura|Mux5~5_combout\);

-- Location: LCCOMB_X28_Y27_N22
\Porta_A_Leitura|Mux6~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux6~0_combout\ = (\r_addr_a[0]~input_o\ & (((\inst8|dff_block[1].dff_inst|q~q\) # (\r_addr_a[1]~input_o\)))) # (!\r_addr_a[0]~input_o\ & (\inst7|dff_block[1].dff_inst|q~q\ & ((!\r_addr_a[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[0]~input_o\,
	datab => \inst7|dff_block[1].dff_inst|q~q\,
	datac => \inst8|dff_block[1].dff_inst|q~q\,
	datad => \r_addr_a[1]~input_o\,
	combout => \Porta_A_Leitura|Mux6~0_combout\);

-- Location: FF_X29_Y29_N29
\inst6|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[3]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst6|dff_block[1].dff_inst|q~q\);

-- Location: FF_X28_Y28_N25
\inst13|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[10]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst13|dff_block[0].dff_inst|q~q\);

-- Location: FF_X28_Y26_N27
\inst9|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst9|dff_block[0].dff_inst|q~q\);

-- Location: FF_X27_Y29_N27
\inst5|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[2]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst5|dff_block[0].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y26_N26
\Porta_A_Leitura|Mux7~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux7~2_combout\ = (\r_addr_a[3]~input_o\ & (((\r_addr_a[2]~input_o\)))) # (!\r_addr_a[3]~input_o\ & ((\r_addr_a[2]~input_o\ & ((\inst9|dff_block[0].dff_inst|q~q\))) # (!\r_addr_a[2]~input_o\ & (\inst5|dff_block[0].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[3]~input_o\,
	datab => \inst5|dff_block[0].dff_inst|q~q\,
	datac => \inst9|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_a[2]~input_o\,
	combout => \Porta_A_Leitura|Mux7~2_combout\);

-- Location: FF_X27_Y29_N29
\inst17|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[14]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst17|dff_block[0].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y28_N24
\Porta_A_Leitura|Mux7~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux7~3_combout\ = (\Porta_A_Leitura|Mux7~2_combout\ & ((\inst17|dff_block[0].dff_inst|q~q\) # ((!\r_addr_a[3]~input_o\)))) # (!\Porta_A_Leitura|Mux7~2_combout\ & (((\inst13|dff_block[0].dff_inst|q~q\ & \r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst17|dff_block[0].dff_inst|q~q\,
	datab => \Porta_A_Leitura|Mux7~2_combout\,
	datac => \inst13|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux7~3_combout\);

-- Location: LCCOMB_X28_Y26_N20
\Porta_A_Leitura|Mux7~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux7~4_combout\ = (\r_addr_a[3]~input_o\ & (\r_addr_a[2]~input_o\)) # (!\r_addr_a[3]~input_o\ & ((\r_addr_a[2]~input_o\ & (\inst7|dff_block[0].dff_inst|q~q\)) # (!\r_addr_a[2]~input_o\ & ((\inst3|dff_block[0].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100111001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[3]~input_o\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst7|dff_block[0].dff_inst|q~q\,
	datad => \inst3|dff_block[0].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux7~4_combout\);

-- Location: LCCOMB_X30_Y29_N26
\Porta_A_Leitura|Mux7~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux7~7_combout\ = (\r_addr_a[2]~input_o\ & (((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & ((\r_addr_a[3]~input_o\ & ((\inst14|dff_block[0].dff_inst|q~q\))) # (!\r_addr_a[3]~input_o\ & (\inst6|dff_block[0].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[2]~input_o\,
	datab => \inst6|dff_block[0].dff_inst|q~q\,
	datac => \inst14|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux7~7_combout\);

-- Location: LCCOMB_X39_Y40_N6
\inst|Decoder0~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~3_combout\ = (!\w_addr[0]~input_o\ & (\w_addr[2]~input_o\ & (\w_addr[3]~input_o\ & !\w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~3_combout\);

-- Location: LCCOMB_X39_Y40_N4
\inst|Decoder0~10\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~10_combout\ = (\w_addr[0]~input_o\ & (\w_addr[2]~input_o\ & (!\w_addr[3]~input_o\ & !\w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~10_combout\);

-- Location: LCCOMB_X39_Y40_N2
\inst|Decoder0~13\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~13_combout\ = (!\w_addr[0]~input_o\ & (!\w_addr[2]~input_o\ & (!\w_addr[3]~input_o\ & \w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~13_combout\);

-- Location: LCCOMB_X27_Y27_N26
\Porta_B_Leitura|Mux0~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux0~2_combout\ = (\r_addr_b[1]~input_o\ & ((\inst9|dff_block[7].dff_inst|q~q\) # ((\r_addr_b[0]~input_o\)))) # (!\r_addr_b[1]~input_o\ & (((\inst7|dff_block[7].dff_inst|q~q\ & !\r_addr_b[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \inst9|dff_block[7].dff_inst|q~q\,
	datac => \inst7|dff_block[7].dff_inst|q~q\,
	datad => \r_addr_b[0]~input_o\,
	combout => \Porta_B_Leitura|Mux0~2_combout\);

-- Location: LCCOMB_X28_Y29_N2
\Porta_B_Leitura|Mux0~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux0~4_combout\ = (\r_addr_b[0]~input_o\ & ((\inst4|dff_block[7].dff_inst|q~q\) # ((\r_addr_b[1]~input_o\)))) # (!\r_addr_b[0]~input_o\ & (((\inst3|dff_block[7].dff_inst|q~q\ & !\r_addr_b[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[0]~input_o\,
	datab => \inst4|dff_block[7].dff_inst|q~q\,
	datac => \inst3|dff_block[7].dff_inst|q~q\,
	datad => \r_addr_b[1]~input_o\,
	combout => \Porta_B_Leitura|Mux0~4_combout\);

-- Location: LCCOMB_X29_Y29_N10
\Porta_B_Leitura|Mux0~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux0~5_combout\ = (\r_addr_b[1]~input_o\ & ((\Porta_B_Leitura|Mux0~4_combout\ & ((\inst6|dff_block[7].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux0~4_combout\ & (\inst5|dff_block[7].dff_inst|q~q\)))) # (!\r_addr_b[1]~input_o\ & 
-- (((\Porta_B_Leitura|Mux0~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \inst5|dff_block[7].dff_inst|q~q\,
	datac => \inst6|dff_block[7].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux0~4_combout\,
	combout => \Porta_B_Leitura|Mux0~5_combout\);

-- Location: LCCOMB_X28_Y29_N20
\Porta_B_Leitura|Mux1~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux1~2_combout\ = (\r_addr_b[2]~input_o\ & ((\r_addr_b[3]~input_o\) # ((\inst8|dff_block[6].dff_inst|q~q\)))) # (!\r_addr_b[2]~input_o\ & (!\r_addr_b[3]~input_o\ & (\inst4|dff_block[6].dff_inst|q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[2]~input_o\,
	datab => \r_addr_b[3]~input_o\,
	datac => \inst4|dff_block[6].dff_inst|q~q\,
	datad => \inst8|dff_block[6].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux1~2_combout\);

-- Location: LCCOMB_X27_Y30_N10
\Porta_B_Leitura|Mux1~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux1~3_combout\ = (\Porta_B_Leitura|Mux1~2_combout\ & (((\inst16|dff_block[6].dff_inst|q~q\) # (!\r_addr_b[3]~input_o\)))) # (!\Porta_B_Leitura|Mux1~2_combout\ & (\inst12|dff_block[6].dff_inst|q~q\ & ((\r_addr_b[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst12|dff_block[6].dff_inst|q~q\,
	datab => \Porta_B_Leitura|Mux1~2_combout\,
	datac => \inst16|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux1~3_combout\);

-- Location: LCCOMB_X28_Y29_N26
\Porta_B_Leitura|Mux2~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux2~4_combout\ = (\r_addr_b[0]~input_o\ & (((\r_addr_b[1]~input_o\)))) # (!\r_addr_b[0]~input_o\ & ((\r_addr_b[1]~input_o\ & (\inst5|dff_block[5].dff_inst|q~q\)) # (!\r_addr_b[1]~input_o\ & ((\inst3|dff_block[5].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[0]~input_o\,
	datab => \inst5|dff_block[5].dff_inst|q~q\,
	datac => \inst3|dff_block[5].dff_inst|q~q\,
	datad => \r_addr_b[1]~input_o\,
	combout => \Porta_B_Leitura|Mux2~4_combout\);

-- Location: LCCOMB_X29_Y29_N24
\Porta_B_Leitura|Mux2~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux2~5_combout\ = (\r_addr_b[0]~input_o\ & ((\Porta_B_Leitura|Mux2~4_combout\ & ((\inst6|dff_block[5].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux2~4_combout\ & (\inst4|dff_block[5].dff_inst|q~q\)))) # (!\r_addr_b[0]~input_o\ & 
-- (((\Porta_B_Leitura|Mux2~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst4|dff_block[5].dff_inst|q~q\,
	datab => \r_addr_b[0]~input_o\,
	datac => \inst6|dff_block[5].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux2~4_combout\,
	combout => \Porta_B_Leitura|Mux2~5_combout\);

-- Location: LCCOMB_X27_Y30_N8
\Porta_B_Leitura|Mux2~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux2~7_combout\ = (\r_addr_b[0]~input_o\ & ((\inst16|dff_block[5].dff_inst|q~q\) # ((\r_addr_b[1]~input_o\)))) # (!\r_addr_b[0]~input_o\ & (((\inst15|dff_block[5].dff_inst|q~q\ & !\r_addr_b[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[0]~input_o\,
	datab => \inst16|dff_block[5].dff_inst|q~q\,
	datac => \inst15|dff_block[5].dff_inst|q~q\,
	datad => \r_addr_b[1]~input_o\,
	combout => \Porta_B_Leitura|Mux2~7_combout\);

-- Location: LCCOMB_X28_Y29_N4
\Porta_B_Leitura|Mux3~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux3~0_combout\ = (\r_addr_b[3]~input_o\ & ((\inst12|dff_block[4].dff_inst|q~q\) # ((\r_addr_b[2]~input_o\)))) # (!\r_addr_b[3]~input_o\ & (((\inst4|dff_block[4].dff_inst|q~q\ & !\r_addr_b[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst12|dff_block[4].dff_inst|q~q\,
	datab => \r_addr_b[3]~input_o\,
	datac => \inst4|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux3~0_combout\);

-- Location: LCCOMB_X27_Y29_N8
\Porta_B_Leitura|Mux3~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux3~2_combout\ = (\r_addr_b[2]~input_o\ & ((\inst9|dff_block[4].dff_inst|q~q\) # ((\r_addr_b[3]~input_o\)))) # (!\r_addr_b[2]~input_o\ & (((\inst5|dff_block[4].dff_inst|q~q\ & !\r_addr_b[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|dff_block[4].dff_inst|q~q\,
	datab => \r_addr_b[2]~input_o\,
	datac => \inst5|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux3~2_combout\);

-- Location: LCCOMB_X29_Y29_N12
\Porta_B_Leitura|Mux3~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux3~7_combout\ = (\r_addr_b[3]~input_o\ & ((\inst14|dff_block[4].dff_inst|q~q\) # ((\r_addr_b[2]~input_o\)))) # (!\r_addr_b[3]~input_o\ & (((\inst6|dff_block[4].dff_inst|q~q\ & !\r_addr_b[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[3]~input_o\,
	datab => \inst14|dff_block[4].dff_inst|q~q\,
	datac => \inst6|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux3~7_combout\);

-- Location: LCCOMB_X27_Y27_N14
\Porta_B_Leitura|Mux4~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux4~2_combout\ = (\r_addr_b[1]~input_o\ & ((\inst9|dff_block[3].dff_inst|q~q\) # ((\r_addr_b[0]~input_o\)))) # (!\r_addr_b[1]~input_o\ & (((\inst7|dff_block[3].dff_inst|q~q\ & !\r_addr_b[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \inst9|dff_block[3].dff_inst|q~q\,
	datac => \inst7|dff_block[3].dff_inst|q~q\,
	datad => \r_addr_b[0]~input_o\,
	combout => \Porta_B_Leitura|Mux4~2_combout\);

-- Location: LCCOMB_X28_Y29_N18
\Porta_B_Leitura|Mux4~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux4~4_combout\ = (\r_addr_b[0]~input_o\ & ((\inst4|dff_block[3].dff_inst|q~q\) # ((\r_addr_b[1]~input_o\)))) # (!\r_addr_b[0]~input_o\ & (((\inst3|dff_block[3].dff_inst|q~q\ & !\r_addr_b[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[0]~input_o\,
	datab => \inst4|dff_block[3].dff_inst|q~q\,
	datac => \inst3|dff_block[3].dff_inst|q~q\,
	datad => \r_addr_b[1]~input_o\,
	combout => \Porta_B_Leitura|Mux4~4_combout\);

-- Location: LCCOMB_X29_Y29_N22
\Porta_B_Leitura|Mux4~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux4~5_combout\ = (\r_addr_b[1]~input_o\ & ((\Porta_B_Leitura|Mux4~4_combout\ & ((\inst6|dff_block[3].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux4~4_combout\ & (\inst5|dff_block[3].dff_inst|q~q\)))) # (!\r_addr_b[1]~input_o\ & 
-- (((\Porta_B_Leitura|Mux4~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \inst5|dff_block[3].dff_inst|q~q\,
	datac => \inst6|dff_block[3].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux4~4_combout\,
	combout => \Porta_B_Leitura|Mux4~5_combout\);

-- Location: LCCOMB_X27_Y30_N30
\Porta_B_Leitura|Mux4~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux4~7_combout\ = (\r_addr_b[0]~input_o\ & (\r_addr_b[1]~input_o\)) # (!\r_addr_b[0]~input_o\ & ((\r_addr_b[1]~input_o\ & ((\inst17|dff_block[3].dff_inst|q~q\))) # (!\r_addr_b[1]~input_o\ & (\inst15|dff_block[3].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[0]~input_o\,
	datab => \r_addr_b[1]~input_o\,
	datac => \inst15|dff_block[3].dff_inst|q~q\,
	datad => \inst17|dff_block[3].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux4~7_combout\);

-- Location: LCCOMB_X28_Y28_N4
\Porta_B_Leitura|Mux6~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux6~2_combout\ = (\r_addr_b[0]~input_o\ & (((\r_addr_b[1]~input_o\)))) # (!\r_addr_b[0]~input_o\ & ((\r_addr_b[1]~input_o\ & (\inst13|dff_block[1].dff_inst|q~q\)) # (!\r_addr_b[1]~input_o\ & ((\inst11|dff_block[1].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst13|dff_block[1].dff_inst|q~q\,
	datab => \r_addr_b[0]~input_o\,
	datac => \inst11|dff_block[1].dff_inst|q~q\,
	datad => \r_addr_b[1]~input_o\,
	combout => \Porta_B_Leitura|Mux6~2_combout\);

-- Location: LCCOMB_X28_Y29_N10
\Porta_B_Leitura|Mux6~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux6~4_combout\ = (\r_addr_b[1]~input_o\ & ((\inst5|dff_block[1].dff_inst|q~q\) # ((\r_addr_b[0]~input_o\)))) # (!\r_addr_b[1]~input_o\ & (((\inst3|dff_block[1].dff_inst|q~q\ & !\r_addr_b[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \inst5|dff_block[1].dff_inst|q~q\,
	datac => \inst3|dff_block[1].dff_inst|q~q\,
	datad => \r_addr_b[0]~input_o\,
	combout => \Porta_B_Leitura|Mux6~4_combout\);

-- Location: LCCOMB_X29_Y29_N28
\Porta_B_Leitura|Mux6~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux6~5_combout\ = (\r_addr_b[0]~input_o\ & ((\Porta_B_Leitura|Mux6~4_combout\ & ((\inst6|dff_block[1].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux6~4_combout\ & (\inst4|dff_block[1].dff_inst|q~q\)))) # (!\r_addr_b[0]~input_o\ & 
-- (((\Porta_B_Leitura|Mux6~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst4|dff_block[1].dff_inst|q~q\,
	datab => \r_addr_b[0]~input_o\,
	datac => \inst6|dff_block[1].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux6~4_combout\,
	combout => \Porta_B_Leitura|Mux6~5_combout\);

-- Location: LCCOMB_X29_Y30_N18
\Porta_B_Leitura|Mux6~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux6~7_combout\ = (\r_addr_b[1]~input_o\ & (\r_addr_b[0]~input_o\)) # (!\r_addr_b[1]~input_o\ & ((\r_addr_b[0]~input_o\ & ((\inst16|dff_block[1].dff_inst|q~q\))) # (!\r_addr_b[0]~input_o\ & (\inst15|dff_block[1].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \r_addr_b[0]~input_o\,
	datac => \inst15|dff_block[1].dff_inst|q~q\,
	datad => \inst16|dff_block[1].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux6~7_combout\);

-- Location: LCCOMB_X27_Y29_N26
\Porta_B_Leitura|Mux7~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux7~2_combout\ = (\r_addr_b[3]~input_o\ & (\r_addr_b[2]~input_o\)) # (!\r_addr_b[3]~input_o\ & ((\r_addr_b[2]~input_o\ & ((\inst9|dff_block[0].dff_inst|q~q\))) # (!\r_addr_b[2]~input_o\ & (\inst5|dff_block[0].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[3]~input_o\,
	datab => \r_addr_b[2]~input_o\,
	datac => \inst5|dff_block[0].dff_inst|q~q\,
	datad => \inst9|dff_block[0].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux7~2_combout\);

-- Location: LCCOMB_X27_Y29_N28
\Porta_B_Leitura|Mux7~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux7~3_combout\ = (\Porta_B_Leitura|Mux7~2_combout\ & (((\inst17|dff_block[0].dff_inst|q~q\) # (!\r_addr_b[3]~input_o\)))) # (!\Porta_B_Leitura|Mux7~2_combout\ & (\inst13|dff_block[0].dff_inst|q~q\ & ((\r_addr_b[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110010010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux7~2_combout\,
	datab => \inst13|dff_block[0].dff_inst|q~q\,
	datac => \inst17|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux7~3_combout\);

-- Location: IOIBUF_X43_Y41_N8
\w_addr[0]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_addr(0),
	o => \w_addr[0]~input_o\);

-- Location: IOIBUF_X27_Y0_N15
\clk~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G17
\clk~inputclkctrl\ : cycloneiv_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk~inputclkctrl_outclk\);

-- Location: IOOBUF_X52_Y23_N9
\r_data_a[7]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_A_Leitura|Mux0~9_combout\,
	devoe => ww_devoe,
	o => \r_data_a[7]~output_o\);

-- Location: IOOBUF_X29_Y0_N9
\r_data_a[6]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_A_Leitura|Mux1~9_combout\,
	devoe => ww_devoe,
	o => \r_data_a[6]~output_o\);

-- Location: IOOBUF_X52_Y31_N9
\r_data_a[5]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_A_Leitura|Mux2~9_combout\,
	devoe => ww_devoe,
	o => \r_data_a[5]~output_o\);

-- Location: IOOBUF_X52_Y19_N2
\r_data_a[4]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_A_Leitura|Mux3~9_combout\,
	devoe => ww_devoe,
	o => \r_data_a[4]~output_o\);

-- Location: IOOBUF_X52_Y27_N9
\r_data_a[3]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_A_Leitura|Mux4~9_combout\,
	devoe => ww_devoe,
	o => \r_data_a[3]~output_o\);

-- Location: IOOBUF_X52_Y28_N9
\r_data_a[2]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_A_Leitura|Mux5~9_combout\,
	devoe => ww_devoe,
	o => \r_data_a[2]~output_o\);

-- Location: IOOBUF_X52_Y23_N2
\r_data_a[1]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_A_Leitura|Mux6~9_combout\,
	devoe => ww_devoe,
	o => \r_data_a[1]~output_o\);

-- Location: IOOBUF_X21_Y41_N9
\r_data_a[0]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_A_Leitura|Mux7~9_combout\,
	devoe => ww_devoe,
	o => \r_data_a[0]~output_o\);

-- Location: IOOBUF_X31_Y41_N16
\we_dec[15]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[15]~0_combout\,
	devoe => ww_devoe,
	o => \we_dec[15]~output_o\);

-- Location: IOOBUF_X38_Y41_N9
\we_dec[14]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[14]~1_combout\,
	devoe => ww_devoe,
	o => \we_dec[14]~output_o\);

-- Location: IOOBUF_X36_Y41_N9
\we_dec[13]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[13]~2_combout\,
	devoe => ww_devoe,
	o => \we_dec[13]~output_o\);

-- Location: IOOBUF_X38_Y41_N2
\we_dec[12]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[12]~3_combout\,
	devoe => ww_devoe,
	o => \we_dec[12]~output_o\);

-- Location: IOOBUF_X31_Y41_N23
\we_dec[11]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[11]~4_combout\,
	devoe => ww_devoe,
	o => \we_dec[11]~output_o\);

-- Location: IOOBUF_X52_Y32_N9
\we_dec[10]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[10]~5_combout\,
	devoe => ww_devoe,
	o => \we_dec[10]~output_o\);

-- Location: IOOBUF_X46_Y41_N9
\we_dec[9]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[9]~6_combout\,
	devoe => ww_devoe,
	o => \we_dec[9]~output_o\);

-- Location: IOOBUF_X36_Y41_N2
\we_dec[8]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[8]~7_combout\,
	devoe => ww_devoe,
	o => \we_dec[8]~output_o\);

-- Location: IOOBUF_X34_Y41_N2
\we_dec[7]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[7]~8_combout\,
	devoe => ww_devoe,
	o => \we_dec[7]~output_o\);

-- Location: IOOBUF_X46_Y41_N23
\we_dec[6]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[6]~9_combout\,
	devoe => ww_devoe,
	o => \we_dec[6]~output_o\);

-- Location: IOOBUF_X48_Y41_N9
\we_dec[5]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[5]~10_combout\,
	devoe => ww_devoe,
	o => \we_dec[5]~output_o\);

-- Location: IOOBUF_X41_Y41_N23
\we_dec[4]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[4]~11_combout\,
	devoe => ww_devoe,
	o => \we_dec[4]~output_o\);

-- Location: IOOBUF_X46_Y41_N16
\we_dec[3]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[3]~12_combout\,
	devoe => ww_devoe,
	o => \we_dec[3]~output_o\);

-- Location: IOOBUF_X12_Y41_N2
\we_dec[2]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[2]~13_combout\,
	devoe => ww_devoe,
	o => \we_dec[2]~output_o\);

-- Location: IOOBUF_X41_Y41_N2
\we_dec[1]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[1]~14_combout\,
	devoe => ww_devoe,
	o => \we_dec[1]~output_o\);

-- Location: IOOBUF_X34_Y41_N9
\we_dec[0]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|we_dec[0]~15_combout\,
	devoe => ww_devoe,
	o => \we_dec[0]~output_o\);

-- Location: IOOBUF_X25_Y41_N2
\r_data_b[7]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_B_Leitura|Mux0~9_combout\,
	devoe => ww_devoe,
	o => \r_data_b[7]~output_o\);

-- Location: IOOBUF_X21_Y41_N2
\r_data_b[6]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_B_Leitura|Mux1~9_combout\,
	devoe => ww_devoe,
	o => \r_data_b[6]~output_o\);

-- Location: IOOBUF_X25_Y0_N9
\r_data_b[5]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_B_Leitura|Mux2~9_combout\,
	devoe => ww_devoe,
	o => \r_data_b[5]~output_o\);

-- Location: IOOBUF_X18_Y41_N2
\r_data_b[4]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_B_Leitura|Mux3~9_combout\,
	devoe => ww_devoe,
	o => \r_data_b[4]~output_o\);

-- Location: IOOBUF_X52_Y31_N2
\r_data_b[3]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_B_Leitura|Mux4~9_combout\,
	devoe => ww_devoe,
	o => \r_data_b[3]~output_o\);

-- Location: IOOBUF_X52_Y30_N2
\r_data_b[2]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_B_Leitura|Mux5~9_combout\,
	devoe => ww_devoe,
	o => \r_data_b[2]~output_o\);

-- Location: IOOBUF_X14_Y41_N9
\r_data_b[1]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_B_Leitura|Mux6~9_combout\,
	devoe => ww_devoe,
	o => \r_data_b[1]~output_o\);

-- Location: IOOBUF_X23_Y41_N9
\r_data_b[0]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Porta_B_Leitura|Mux7~9_combout\,
	devoe => ww_devoe,
	o => \r_data_b[0]~output_o\);

-- Location: IOIBUF_X52_Y32_N15
\r_addr_a[0]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_r_addr_a(0),
	o => \r_addr_a[0]~input_o\);

-- Location: IOIBUF_X16_Y41_N1
\w_data[7]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_data(7),
	o => \w_data[7]~input_o\);

-- Location: IOIBUF_X27_Y0_N22
\rst_n~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_rst_n,
	o => \rst_n~input_o\);

-- Location: CLKCTRL_G19
\rst_n~inputclkctrl\ : cycloneiv_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \rst_n~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \rst_n~inputclkctrl_outclk\);

-- Location: IOIBUF_X41_Y41_N8
\w_addr[2]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_addr(2),
	o => \w_addr[2]~input_o\);

-- Location: IOIBUF_X43_Y41_N1
\w_addr[3]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_addr(3),
	o => \w_addr[3]~input_o\);

-- Location: IOIBUF_X46_Y41_N1
\w_addr[1]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_addr(1),
	o => \w_addr[1]~input_o\);

-- Location: LCCOMB_X39_Y40_N12
\inst|Decoder0~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~6_combout\ = (\w_addr[0]~input_o\ & (!\w_addr[2]~input_o\ & (\w_addr[3]~input_o\ & !\w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~6_combout\);

-- Location: IOIBUF_X41_Y41_N15
\we~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_we,
	o => \we~input_o\);

-- Location: LCCOMB_X38_Y40_N4
\inst|we_dec[9]~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[9]~6_combout\ = (\inst|Decoder0~6_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|Decoder0~6_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[9]~6_combout\);

-- Location: FF_X29_Y28_N25
\inst12|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[9]~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst12|dff_block[7].dff_inst|q~q\);

-- Location: IOIBUF_X52_Y30_N8
\r_addr_a[1]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_r_addr_a(1),
	o => \r_addr_a[1]~input_o\);

-- Location: LCCOMB_X29_Y28_N24
\Porta_A_Leitura|Mux0~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux0~0_combout\ = (\r_addr_a[0]~input_o\ & (((\inst12|dff_block[7].dff_inst|q~q\) # (\r_addr_a[1]~input_o\)))) # (!\r_addr_a[0]~input_o\ & (\inst11|dff_block[7].dff_inst|q~q\ & ((!\r_addr_a[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst11|dff_block[7].dff_inst|q~q\,
	datab => \r_addr_a[0]~input_o\,
	datac => \inst12|dff_block[7].dff_inst|q~q\,
	datad => \r_addr_a[1]~input_o\,
	combout => \Porta_A_Leitura|Mux0~0_combout\);

-- Location: LCCOMB_X39_Y40_N10
\inst|Decoder0~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~5_combout\ = (!\w_addr[0]~input_o\ & (!\w_addr[2]~input_o\ & (\w_addr[3]~input_o\ & \w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~5_combout\);

-- Location: LCCOMB_X38_Y40_N26
\inst|we_dec[10]~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[10]~5_combout\ = (\inst|Decoder0~5_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|Decoder0~5_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[10]~5_combout\);

-- Location: FF_X28_Y28_N9
\inst13|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[10]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst13|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X39_Y40_N8
\inst|Decoder0~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~4_combout\ = (\w_addr[0]~input_o\ & (!\w_addr[2]~input_o\ & (\w_addr[3]~input_o\ & \w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~4_combout\);

-- Location: LCCOMB_X38_Y40_N24
\inst|we_dec[11]~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[11]~4_combout\ = (\inst|Decoder0~4_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|Decoder0~4_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[11]~4_combout\);

-- Location: FF_X30_Y29_N17
\inst14|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[11]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst14|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y28_N8
\Porta_A_Leitura|Mux0~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux0~1_combout\ = (\r_addr_a[1]~input_o\ & ((\Porta_A_Leitura|Mux0~0_combout\ & ((\inst14|dff_block[7].dff_inst|q~q\))) # (!\Porta_A_Leitura|Mux0~0_combout\ & (\inst13|dff_block[7].dff_inst|q~q\)))) # (!\r_addr_a[1]~input_o\ & 
-- (\Porta_A_Leitura|Mux0~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \Porta_A_Leitura|Mux0~0_combout\,
	datac => \inst13|dff_block[7].dff_inst|q~q\,
	datad => \inst14|dff_block[7].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux0~1_combout\);

-- Location: LCCOMB_X39_Y40_N16
\inst|Decoder0~12\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~12_combout\ = (\w_addr[0]~input_o\ & (!\w_addr[2]~input_o\ & (!\w_addr[3]~input_o\ & \w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~12_combout\);

-- Location: LCCOMB_X38_Y40_N8
\inst|we_dec[3]~12\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[3]~12_combout\ = (\inst|Decoder0~12_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|Decoder0~12_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[3]~12_combout\);

-- Location: FF_X29_Y29_N11
\inst6|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[3]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst6|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X38_Y40_N2
\inst|we_dec[2]~13\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[2]~13_combout\ = (\inst|Decoder0~13_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|Decoder0~13_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[2]~13_combout\);

-- Location: FF_X27_Y29_N17
\inst5|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[2]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst5|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X39_Y40_N28
\inst|Decoder0~14\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~14_combout\ = (\w_addr[0]~input_o\ & (!\w_addr[2]~input_o\ & (!\w_addr[3]~input_o\ & !\w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~14_combout\);

-- Location: LCCOMB_X38_Y40_N20
\inst|we_dec[1]~14\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[1]~14_combout\ = (\inst|Decoder0~14_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|Decoder0~14_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[1]~14_combout\);

-- Location: FF_X28_Y29_N25
\inst4|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[1]~14_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst4|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y29_N24
\Porta_A_Leitura|Mux0~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux0~4_combout\ = (\r_addr_a[0]~input_o\ & (((\inst4|dff_block[7].dff_inst|q~q\) # (\r_addr_a[1]~input_o\)))) # (!\r_addr_a[0]~input_o\ & (\inst3|dff_block[7].dff_inst|q~q\ & ((!\r_addr_a[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst3|dff_block[7].dff_inst|q~q\,
	datab => \r_addr_a[0]~input_o\,
	datac => \inst4|dff_block[7].dff_inst|q~q\,
	datad => \r_addr_a[1]~input_o\,
	combout => \Porta_A_Leitura|Mux0~4_combout\);

-- Location: LCCOMB_X27_Y29_N16
\Porta_A_Leitura|Mux0~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux0~5_combout\ = (\r_addr_a[1]~input_o\ & ((\Porta_A_Leitura|Mux0~4_combout\ & (\inst6|dff_block[7].dff_inst|q~q\)) # (!\Porta_A_Leitura|Mux0~4_combout\ & ((\inst5|dff_block[7].dff_inst|q~q\))))) # (!\r_addr_a[1]~input_o\ & 
-- (((\Porta_A_Leitura|Mux0~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \inst6|dff_block[7].dff_inst|q~q\,
	datac => \inst5|dff_block[7].dff_inst|q~q\,
	datad => \Porta_A_Leitura|Mux0~4_combout\,
	combout => \Porta_A_Leitura|Mux0~5_combout\);

-- Location: IOIBUF_X16_Y41_N8
\r_addr_a[2]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_r_addr_a(2),
	o => \r_addr_a[2]~input_o\);

-- Location: IOIBUF_X29_Y41_N1
\r_addr_a[3]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_r_addr_a(3),
	o => \r_addr_a[3]~input_o\);

-- Location: LCCOMB_X29_Y27_N8
\Porta_A_Leitura|Mux0~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux0~6_combout\ = (\r_addr_a[2]~input_o\ & ((\Porta_A_Leitura|Mux0~3_combout\) # ((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & (((\Porta_A_Leitura|Mux0~5_combout\ & !\r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux0~3_combout\,
	datab => \Porta_A_Leitura|Mux0~5_combout\,
	datac => \r_addr_a[2]~input_o\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux0~6_combout\);

-- Location: LCCOMB_X39_Y40_N24
\inst|Decoder0~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~0_combout\ = (\w_addr[0]~input_o\ & (\w_addr[2]~input_o\ & (\w_addr[3]~input_o\ & \w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~0_combout\);

-- Location: LCCOMB_X38_Y40_N16
\inst|we_dec[15]~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[15]~0_combout\ = (\inst|Decoder0~0_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|Decoder0~0_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[15]~0_combout\);

-- Location: FF_X29_Y27_N29
\inst18|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst18|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X39_Y40_N20
\inst|Decoder0~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~2_combout\ = (\w_addr[0]~input_o\ & (\w_addr[2]~input_o\ & (\w_addr[3]~input_o\ & !\w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~2_combout\);

-- Location: LCCOMB_X38_Y40_N28
\inst|we_dec[13]~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[13]~2_combout\ = (\inst|Decoder0~2_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|Decoder0~2_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[13]~2_combout\);

-- Location: FF_X29_Y27_N27
\inst16|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[13]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst16|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y27_N26
\Porta_A_Leitura|Mux0~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux0~8_combout\ = (\Porta_A_Leitura|Mux0~7_combout\ & ((\inst18|dff_block[7].dff_inst|q~q\) # ((!\r_addr_a[0]~input_o\)))) # (!\Porta_A_Leitura|Mux0~7_combout\ & (((\inst16|dff_block[7].dff_inst|q~q\ & \r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux0~7_combout\,
	datab => \inst18|dff_block[7].dff_inst|q~q\,
	datac => \inst16|dff_block[7].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux0~8_combout\);

-- Location: LCCOMB_X29_Y27_N30
\Porta_A_Leitura|Mux0~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux0~9_combout\ = (\Porta_A_Leitura|Mux0~6_combout\ & (((\Porta_A_Leitura|Mux0~8_combout\) # (!\r_addr_a[3]~input_o\)))) # (!\Porta_A_Leitura|Mux0~6_combout\ & (\Porta_A_Leitura|Mux0~1_combout\ & ((\r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux0~1_combout\,
	datab => \Porta_A_Leitura|Mux0~6_combout\,
	datac => \Porta_A_Leitura|Mux0~8_combout\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux0~9_combout\);

-- Location: IOIBUF_X52_Y28_N1
\w_data[6]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_data(6),
	o => \w_data[6]~input_o\);

-- Location: FF_X28_Y29_N21
\inst4|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[1]~14_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst4|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X38_Y40_N12
\inst|we_dec[5]~10\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[5]~10_combout\ = (\inst|Decoder0~10_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|Decoder0~10_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[5]~10_combout\);

-- Location: FF_X28_Y27_N27
\inst8|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[5]~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst8|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y27_N26
\Porta_A_Leitura|Mux1~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux1~2_combout\ = (\r_addr_a[2]~input_o\ & (((\inst8|dff_block[6].dff_inst|q~q\) # (\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & (\inst4|dff_block[6].dff_inst|q~q\ & ((!\r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[2]~input_o\,
	datab => \inst4|dff_block[6].dff_inst|q~q\,
	datac => \inst8|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux1~2_combout\);

-- Location: FF_X27_Y28_N17
\inst12|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[9]~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst12|dff_block[6].dff_inst|q~q\);

-- Location: FF_X27_Y30_N11
\inst16|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[13]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst16|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y28_N16
\Porta_A_Leitura|Mux1~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux1~3_combout\ = (\r_addr_a[3]~input_o\ & ((\Porta_A_Leitura|Mux1~2_combout\ & ((\inst16|dff_block[6].dff_inst|q~q\))) # (!\Porta_A_Leitura|Mux1~2_combout\ & (\inst12|dff_block[6].dff_inst|q~q\)))) # (!\r_addr_a[3]~input_o\ & 
-- (\Porta_A_Leitura|Mux1~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[3]~input_o\,
	datab => \Porta_A_Leitura|Mux1~2_combout\,
	datac => \inst12|dff_block[6].dff_inst|q~q\,
	datad => \inst16|dff_block[6].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux1~3_combout\);

-- Location: LCCOMB_X29_Y28_N12
\Porta_A_Leitura|Mux1~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux1~6_combout\ = (\r_addr_a[0]~input_o\ & (((\Porta_A_Leitura|Mux1~3_combout\) # (\r_addr_a[1]~input_o\)))) # (!\r_addr_a[0]~input_o\ & (\Porta_A_Leitura|Mux1~5_combout\ & ((!\r_addr_a[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux1~5_combout\,
	datab => \r_addr_a[0]~input_o\,
	datac => \Porta_A_Leitura|Mux1~3_combout\,
	datad => \r_addr_a[1]~input_o\,
	combout => \Porta_A_Leitura|Mux1~6_combout\);

-- Location: FF_X28_Y30_N27
\inst18|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst18|dff_block[6].dff_inst|q~q\);

-- Location: FF_X27_Y28_N27
\inst14|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[11]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst14|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y28_N26
\Porta_A_Leitura|Mux1~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux1~8_combout\ = (\Porta_A_Leitura|Mux1~7_combout\ & ((\inst18|dff_block[6].dff_inst|q~q\) # ((!\r_addr_a[3]~input_o\)))) # (!\Porta_A_Leitura|Mux1~7_combout\ & (((\inst14|dff_block[6].dff_inst|q~q\ & \r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux1~7_combout\,
	datab => \inst18|dff_block[6].dff_inst|q~q\,
	datac => \inst14|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux1~8_combout\);

-- Location: LCCOMB_X39_Y40_N18
\inst|Decoder0~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~9_combout\ = (!\w_addr[0]~input_o\ & (\w_addr[2]~input_o\ & (!\w_addr[3]~input_o\ & \w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~9_combout\);

-- Location: LCCOMB_X38_Y40_N18
\inst|we_dec[6]~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[6]~9_combout\ = (\inst|Decoder0~9_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|Decoder0~9_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[6]~9_combout\);

-- Location: FF_X27_Y27_N29
\inst9|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst9|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X39_Y40_N26
\inst|Decoder0~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~1_combout\ = (!\w_addr[0]~input_o\ & (\w_addr[2]~input_o\ & (\w_addr[3]~input_o\ & \w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~1_combout\);

-- Location: LCCOMB_X38_Y40_N10
\inst|we_dec[14]~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[14]~1_combout\ = (\inst|Decoder0~1_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|Decoder0~1_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[14]~1_combout\);

-- Location: FF_X28_Y30_N9
\inst17|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[14]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst17|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y27_N28
\Porta_A_Leitura|Mux1~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux1~1_combout\ = (\Porta_A_Leitura|Mux1~0_combout\ & (((\inst17|dff_block[6].dff_inst|q~q\)) # (!\r_addr_a[2]~input_o\))) # (!\Porta_A_Leitura|Mux1~0_combout\ & (\r_addr_a[2]~input_o\ & (\inst9|dff_block[6].dff_inst|q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101001100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux1~0_combout\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst9|dff_block[6].dff_inst|q~q\,
	datad => \inst17|dff_block[6].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux1~1_combout\);

-- Location: LCCOMB_X29_Y28_N22
\Porta_A_Leitura|Mux1~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux1~9_combout\ = (\Porta_A_Leitura|Mux1~6_combout\ & ((\Porta_A_Leitura|Mux1~8_combout\) # ((!\r_addr_a[1]~input_o\)))) # (!\Porta_A_Leitura|Mux1~6_combout\ & (((\Porta_A_Leitura|Mux1~1_combout\ & \r_addr_a[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux1~6_combout\,
	datab => \Porta_A_Leitura|Mux1~8_combout\,
	datac => \Porta_A_Leitura|Mux1~1_combout\,
	datad => \r_addr_a[1]~input_o\,
	combout => \Porta_A_Leitura|Mux1~9_combout\);

-- Location: IOIBUF_X52_Y25_N8
\w_data[5]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_data(5),
	o => \w_data[5]~input_o\);

-- Location: FF_X28_Y30_N23
\inst18|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst18|dff_block[5].dff_inst|q~q\);

-- Location: FF_X28_Y30_N13
\inst17|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[14]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst17|dff_block[5].dff_inst|q~q\);

-- Location: LCCOMB_X38_Y40_N6
\inst|we_dec[12]~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[12]~3_combout\ = (\inst|Decoder0~3_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|Decoder0~3_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[12]~3_combout\);

-- Location: FF_X27_Y30_N9
\inst15|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[12]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst15|dff_block[5].dff_inst|q~q\);

-- Location: FF_X27_Y30_N15
\inst16|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[13]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst16|dff_block[5].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y30_N14
\Porta_A_Leitura|Mux2~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux2~7_combout\ = (\r_addr_a[0]~input_o\ & (((\inst16|dff_block[5].dff_inst|q~q\) # (\r_addr_a[1]~input_o\)))) # (!\r_addr_a[0]~input_o\ & (\inst15|dff_block[5].dff_inst|q~q\ & ((!\r_addr_a[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[0]~input_o\,
	datab => \inst15|dff_block[5].dff_inst|q~q\,
	datac => \inst16|dff_block[5].dff_inst|q~q\,
	datad => \r_addr_a[1]~input_o\,
	combout => \Porta_A_Leitura|Mux2~7_combout\);

-- Location: LCCOMB_X28_Y30_N12
\Porta_A_Leitura|Mux2~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux2~8_combout\ = (\r_addr_a[1]~input_o\ & ((\Porta_A_Leitura|Mux2~7_combout\ & (\inst18|dff_block[5].dff_inst|q~q\)) # (!\Porta_A_Leitura|Mux2~7_combout\ & ((\inst17|dff_block[5].dff_inst|q~q\))))) # (!\r_addr_a[1]~input_o\ & 
-- (((\Porta_A_Leitura|Mux2~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \inst18|dff_block[5].dff_inst|q~q\,
	datac => \inst17|dff_block[5].dff_inst|q~q\,
	datad => \Porta_A_Leitura|Mux2~7_combout\,
	combout => \Porta_A_Leitura|Mux2~8_combout\);

-- Location: FF_X27_Y27_N9
\inst9|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst9|dff_block[5].dff_inst|q~q\);

-- Location: LCCOMB_X39_Y40_N0
\inst|Decoder0~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~8_combout\ = (\w_addr[0]~input_o\ & (\w_addr[2]~input_o\ & (!\w_addr[3]~input_o\ & \w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~8_combout\);

-- Location: LCCOMB_X38_Y40_N0
\inst|we_dec[7]~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[7]~8_combout\ = (\inst|Decoder0~8_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|Decoder0~8_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[7]~8_combout\);

-- Location: FF_X28_Y27_N15
\8_registrador|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[7]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \8_registrador|dff_block[5].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y27_N8
\Porta_A_Leitura|Mux2~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux2~1_combout\ = (\Porta_A_Leitura|Mux2~0_combout\ & (((\8_registrador|dff_block[5].dff_inst|q~q\)) # (!\r_addr_a[1]~input_o\))) # (!\Porta_A_Leitura|Mux2~0_combout\ & (\r_addr_a[1]~input_o\ & (\inst9|dff_block[5].dff_inst|q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101001100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux2~0_combout\,
	datab => \r_addr_a[1]~input_o\,
	datac => \inst9|dff_block[5].dff_inst|q~q\,
	datad => \8_registrador|dff_block[5].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux2~1_combout\);

-- Location: FF_X29_Y29_N25
\inst6|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[3]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst6|dff_block[5].dff_inst|q~q\);

-- Location: FF_X28_Y29_N1
\inst4|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[1]~14_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst4|dff_block[5].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y29_N0
\Porta_A_Leitura|Mux2~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux2~5_combout\ = (\Porta_A_Leitura|Mux2~4_combout\ & ((\inst6|dff_block[5].dff_inst|q~q\) # ((!\r_addr_a[0]~input_o\)))) # (!\Porta_A_Leitura|Mux2~4_combout\ & (((\inst4|dff_block[5].dff_inst|q~q\ & \r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux2~4_combout\,
	datab => \inst6|dff_block[5].dff_inst|q~q\,
	datac => \inst4|dff_block[5].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux2~5_combout\);

-- Location: LCCOMB_X27_Y27_N12
\Porta_A_Leitura|Mux2~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux2~6_combout\ = (\r_addr_a[2]~input_o\ & (((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & ((\r_addr_a[3]~input_o\ & (\Porta_A_Leitura|Mux2~3_combout\)) # (!\r_addr_a[3]~input_o\ & ((\Porta_A_Leitura|Mux2~5_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux2~3_combout\,
	datab => \r_addr_a[2]~input_o\,
	datac => \Porta_A_Leitura|Mux2~5_combout\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux2~6_combout\);

-- Location: LCCOMB_X27_Y27_N22
\Porta_A_Leitura|Mux2~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux2~9_combout\ = (\r_addr_a[2]~input_o\ & ((\Porta_A_Leitura|Mux2~6_combout\ & (\Porta_A_Leitura|Mux2~8_combout\)) # (!\Porta_A_Leitura|Mux2~6_combout\ & ((\Porta_A_Leitura|Mux2~1_combout\))))) # (!\r_addr_a[2]~input_o\ & 
-- (((\Porta_A_Leitura|Mux2~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux2~8_combout\,
	datab => \Porta_A_Leitura|Mux2~1_combout\,
	datac => \r_addr_a[2]~input_o\,
	datad => \Porta_A_Leitura|Mux2~6_combout\,
	combout => \Porta_A_Leitura|Mux2~9_combout\);

-- Location: IOIBUF_X23_Y41_N1
\w_data[4]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_data(4),
	o => \w_data[4]~input_o\);

-- Location: FF_X29_Y29_N19
\8_registrador|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[7]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \8_registrador|dff_block[4].dff_inst|q~q\);

-- Location: FF_X28_Y30_N11
\inst18|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst18|dff_block[4].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y29_N18
\Porta_A_Leitura|Mux3~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux3~8_combout\ = (\Porta_A_Leitura|Mux3~7_combout\ & (((\inst18|dff_block[4].dff_inst|q~q\)) # (!\r_addr_a[2]~input_o\))) # (!\Porta_A_Leitura|Mux3~7_combout\ & (\r_addr_a[2]~input_o\ & (\8_registrador|dff_block[4].dff_inst|q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101001100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux3~7_combout\,
	datab => \r_addr_a[2]~input_o\,
	datac => \8_registrador|dff_block[4].dff_inst|q~q\,
	datad => \inst18|dff_block[4].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux3~8_combout\);

-- Location: FF_X28_Y27_N9
\inst8|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[5]~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst8|dff_block[4].dff_inst|q~q\);

-- Location: FF_X27_Y30_N27
\inst16|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[13]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst16|dff_block[4].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y27_N8
\Porta_A_Leitura|Mux3~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux3~1_combout\ = (\Porta_A_Leitura|Mux3~0_combout\ & (((\inst16|dff_block[4].dff_inst|q~q\)) # (!\r_addr_a[2]~input_o\))) # (!\Porta_A_Leitura|Mux3~0_combout\ & (\r_addr_a[2]~input_o\ & (\inst8|dff_block[4].dff_inst|q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101001100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux3~0_combout\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst8|dff_block[4].dff_inst|q~q\,
	datad => \inst16|dff_block[4].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux3~1_combout\);

-- Location: FF_X28_Y30_N25
\inst17|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[14]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst17|dff_block[4].dff_inst|q~q\);

-- Location: FF_X28_Y28_N11
\inst13|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[10]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst13|dff_block[4].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y28_N10
\Porta_A_Leitura|Mux3~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux3~3_combout\ = (\Porta_A_Leitura|Mux3~2_combout\ & ((\inst17|dff_block[4].dff_inst|q~q\) # ((!\r_addr_a[3]~input_o\)))) # (!\Porta_A_Leitura|Mux3~2_combout\ & (((\inst13|dff_block[4].dff_inst|q~q\ & \r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux3~2_combout\,
	datab => \inst17|dff_block[4].dff_inst|q~q\,
	datac => \inst13|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux3~3_combout\);

-- Location: LCCOMB_X29_Y28_N16
\Porta_A_Leitura|Mux3~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux3~6_combout\ = (\r_addr_a[1]~input_o\ & (((\Porta_A_Leitura|Mux3~3_combout\) # (\r_addr_a[0]~input_o\)))) # (!\r_addr_a[1]~input_o\ & (\Porta_A_Leitura|Mux3~5_combout\ & ((!\r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux3~5_combout\,
	datab => \r_addr_a[1]~input_o\,
	datac => \Porta_A_Leitura|Mux3~3_combout\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux3~6_combout\);

-- Location: LCCOMB_X29_Y28_N2
\Porta_A_Leitura|Mux3~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux3~9_combout\ = (\r_addr_a[0]~input_o\ & ((\Porta_A_Leitura|Mux3~6_combout\ & (\Porta_A_Leitura|Mux3~8_combout\)) # (!\Porta_A_Leitura|Mux3~6_combout\ & ((\Porta_A_Leitura|Mux3~1_combout\))))) # (!\r_addr_a[0]~input_o\ & 
-- (((\Porta_A_Leitura|Mux3~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[0]~input_o\,
	datab => \Porta_A_Leitura|Mux3~8_combout\,
	datac => \Porta_A_Leitura|Mux3~1_combout\,
	datad => \Porta_A_Leitura|Mux3~6_combout\,
	combout => \Porta_A_Leitura|Mux3~9_combout\);

-- Location: IOIBUF_X31_Y41_N1
\w_data[3]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_data(3),
	o => \w_data[3]~input_o\);

-- Location: FF_X29_Y27_N21
\inst18|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst18|dff_block[3].dff_inst|q~q\);

-- Location: FF_X29_Y27_N11
\inst16|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[13]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst16|dff_block[3].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y27_N10
\Porta_A_Leitura|Mux4~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux4~8_combout\ = (\Porta_A_Leitura|Mux4~7_combout\ & ((\inst18|dff_block[3].dff_inst|q~q\) # ((!\r_addr_a[0]~input_o\)))) # (!\Porta_A_Leitura|Mux4~7_combout\ & (((\inst16|dff_block[3].dff_inst|q~q\ & \r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux4~7_combout\,
	datab => \inst18|dff_block[3].dff_inst|q~q\,
	datac => \inst16|dff_block[3].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux4~8_combout\);

-- Location: FF_X28_Y29_N17
\inst4|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[1]~14_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst4|dff_block[3].dff_inst|q~q\);

-- Location: LCCOMB_X39_Y40_N22
\inst|Decoder0~15\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~15_combout\ = (!\w_addr[0]~input_o\ & (!\w_addr[2]~input_o\ & (!\w_addr[3]~input_o\ & !\w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~15_combout\);

-- Location: LCCOMB_X38_Y40_N30
\inst|we_dec[0]~15\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[0]~15_combout\ = (\inst|Decoder0~15_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|Decoder0~15_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[0]~15_combout\);

-- Location: FF_X28_Y29_N19
\inst3|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[0]~15_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst3|dff_block[3].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y29_N16
\Porta_A_Leitura|Mux4~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux4~4_combout\ = (\r_addr_a[1]~input_o\ & (\r_addr_a[0]~input_o\)) # (!\r_addr_a[1]~input_o\ & ((\r_addr_a[0]~input_o\ & (\inst4|dff_block[3].dff_inst|q~q\)) # (!\r_addr_a[0]~input_o\ & ((\inst3|dff_block[3].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100111001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \r_addr_a[0]~input_o\,
	datac => \inst4|dff_block[3].dff_inst|q~q\,
	datad => \inst3|dff_block[3].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux4~4_combout\);

-- Location: FF_X27_Y29_N11
\inst5|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[2]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst5|dff_block[3].dff_inst|q~q\);

-- Location: FF_X29_Y29_N23
\inst6|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[3]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst6|dff_block[3].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y29_N10
\Porta_A_Leitura|Mux4~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux4~5_combout\ = (\r_addr_a[1]~input_o\ & ((\Porta_A_Leitura|Mux4~4_combout\ & ((\inst6|dff_block[3].dff_inst|q~q\))) # (!\Porta_A_Leitura|Mux4~4_combout\ & (\inst5|dff_block[3].dff_inst|q~q\)))) # (!\r_addr_a[1]~input_o\ & 
-- (\Porta_A_Leitura|Mux4~4_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \Porta_A_Leitura|Mux4~4_combout\,
	datac => \inst5|dff_block[3].dff_inst|q~q\,
	datad => \inst6|dff_block[3].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux4~5_combout\);

-- Location: LCCOMB_X29_Y27_N16
\Porta_A_Leitura|Mux4~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux4~6_combout\ = (\r_addr_a[2]~input_o\ & ((\Porta_A_Leitura|Mux4~3_combout\) # ((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & (((\Porta_A_Leitura|Mux4~5_combout\ & !\r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux4~3_combout\,
	datab => \Porta_A_Leitura|Mux4~5_combout\,
	datac => \r_addr_a[2]~input_o\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux4~6_combout\);

-- Location: FF_X30_Y29_N3
\inst14|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[11]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst14|dff_block[3].dff_inst|q~q\);

-- Location: FF_X28_Y28_N31
\inst13|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[10]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst13|dff_block[3].dff_inst|q~q\);

-- Location: FF_X29_Y28_N29
\inst12|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[9]~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst12|dff_block[3].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y28_N28
\Porta_A_Leitura|Mux4~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux4~0_combout\ = (\r_addr_a[1]~input_o\ & (((\r_addr_a[0]~input_o\)))) # (!\r_addr_a[1]~input_o\ & ((\r_addr_a[0]~input_o\ & ((\inst12|dff_block[3].dff_inst|q~q\))) # (!\r_addr_a[0]~input_o\ & (\inst11|dff_block[3].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst11|dff_block[3].dff_inst|q~q\,
	datab => \r_addr_a[1]~input_o\,
	datac => \inst12|dff_block[3].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux4~0_combout\);

-- Location: LCCOMB_X28_Y28_N30
\Porta_A_Leitura|Mux4~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux4~1_combout\ = (\r_addr_a[1]~input_o\ & ((\Porta_A_Leitura|Mux4~0_combout\ & (\inst14|dff_block[3].dff_inst|q~q\)) # (!\Porta_A_Leitura|Mux4~0_combout\ & ((\inst13|dff_block[3].dff_inst|q~q\))))) # (!\r_addr_a[1]~input_o\ & 
-- (((\Porta_A_Leitura|Mux4~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \inst14|dff_block[3].dff_inst|q~q\,
	datac => \inst13|dff_block[3].dff_inst|q~q\,
	datad => \Porta_A_Leitura|Mux4~0_combout\,
	combout => \Porta_A_Leitura|Mux4~1_combout\);

-- Location: LCCOMB_X29_Y27_N22
\Porta_A_Leitura|Mux4~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux4~9_combout\ = (\Porta_A_Leitura|Mux4~6_combout\ & ((\Porta_A_Leitura|Mux4~8_combout\) # ((!\r_addr_a[3]~input_o\)))) # (!\Porta_A_Leitura|Mux4~6_combout\ & (((\Porta_A_Leitura|Mux4~1_combout\ & \r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux4~8_combout\,
	datab => \Porta_A_Leitura|Mux4~6_combout\,
	datac => \Porta_A_Leitura|Mux4~1_combout\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux4~9_combout\);

-- Location: IOIBUF_X31_Y41_N8
\w_data[2]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_data(2),
	o => \w_data[2]~input_o\);

-- Location: FF_X30_Y29_N23
\inst14|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[11]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst14|dff_block[2].dff_inst|q~q\);

-- Location: FF_X29_Y29_N9
\8_registrador|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[7]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \8_registrador|dff_block[2].dff_inst|q~q\);

-- Location: FF_X29_Y29_N3
\inst6|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[3]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst6|dff_block[2].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y29_N8
\Porta_A_Leitura|Mux5~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux5~7_combout\ = (\r_addr_a[3]~input_o\ & (\r_addr_a[2]~input_o\)) # (!\r_addr_a[3]~input_o\ & ((\r_addr_a[2]~input_o\ & (\8_registrador|dff_block[2].dff_inst|q~q\)) # (!\r_addr_a[2]~input_o\ & ((\inst6|dff_block[2].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100111001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[3]~input_o\,
	datab => \r_addr_a[2]~input_o\,
	datac => \8_registrador|dff_block[2].dff_inst|q~q\,
	datad => \inst6|dff_block[2].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux5~7_combout\);

-- Location: LCCOMB_X30_Y29_N22
\Porta_A_Leitura|Mux5~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux5~8_combout\ = (\r_addr_a[3]~input_o\ & ((\Porta_A_Leitura|Mux5~7_combout\ & (\inst18|dff_block[2].dff_inst|q~q\)) # (!\Porta_A_Leitura|Mux5~7_combout\ & ((\inst14|dff_block[2].dff_inst|q~q\))))) # (!\r_addr_a[3]~input_o\ & 
-- (((\Porta_A_Leitura|Mux5~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst18|dff_block[2].dff_inst|q~q\,
	datab => \r_addr_a[3]~input_o\,
	datac => \inst14|dff_block[2].dff_inst|q~q\,
	datad => \Porta_A_Leitura|Mux5~7_combout\,
	combout => \Porta_A_Leitura|Mux5~8_combout\);

-- Location: FF_X29_Y28_N9
\inst12|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[9]~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst12|dff_block[2].dff_inst|q~q\);

-- Location: FF_X28_Y29_N13
\inst4|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[1]~14_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst4|dff_block[2].dff_inst|q~q\);

-- Location: FF_X30_Y29_N21
\inst8|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[5]~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst8|dff_block[2].dff_inst|q~q\);

-- Location: LCCOMB_X30_Y29_N20
\Porta_A_Leitura|Mux5~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux5~2_combout\ = (\r_addr_a[2]~input_o\ & (((\inst8|dff_block[2].dff_inst|q~q\) # (\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & (\inst4|dff_block[2].dff_inst|q~q\ & ((!\r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[2]~input_o\,
	datab => \inst4|dff_block[2].dff_inst|q~q\,
	datac => \inst8|dff_block[2].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux5~2_combout\);

-- Location: LCCOMB_X29_Y28_N8
\Porta_A_Leitura|Mux5~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux5~3_combout\ = (\r_addr_a[3]~input_o\ & ((\Porta_A_Leitura|Mux5~2_combout\ & (\inst16|dff_block[2].dff_inst|q~q\)) # (!\Porta_A_Leitura|Mux5~2_combout\ & ((\inst12|dff_block[2].dff_inst|q~q\))))) # (!\r_addr_a[3]~input_o\ & 
-- (((\Porta_A_Leitura|Mux5~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst16|dff_block[2].dff_inst|q~q\,
	datab => \r_addr_a[3]~input_o\,
	datac => \inst12|dff_block[2].dff_inst|q~q\,
	datad => \Porta_A_Leitura|Mux5~2_combout\,
	combout => \Porta_A_Leitura|Mux5~3_combout\);

-- Location: LCCOMB_X29_Y28_N4
\Porta_A_Leitura|Mux5~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux5~6_combout\ = (\r_addr_a[1]~input_o\ & (((\r_addr_a[0]~input_o\)))) # (!\r_addr_a[1]~input_o\ & ((\r_addr_a[0]~input_o\ & ((\Porta_A_Leitura|Mux5~3_combout\))) # (!\r_addr_a[0]~input_o\ & (\Porta_A_Leitura|Mux5~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux5~5_combout\,
	datab => \r_addr_a[1]~input_o\,
	datac => \Porta_A_Leitura|Mux5~3_combout\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux5~6_combout\);

-- Location: FF_X27_Y27_N17
\inst9|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst9|dff_block[2].dff_inst|q~q\);

-- Location: FF_X28_Y30_N21
\inst17|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[14]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst17|dff_block[2].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y27_N16
\Porta_A_Leitura|Mux5~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux5~1_combout\ = (\Porta_A_Leitura|Mux5~0_combout\ & (((\inst17|dff_block[2].dff_inst|q~q\)) # (!\r_addr_a[2]~input_o\))) # (!\Porta_A_Leitura|Mux5~0_combout\ & (\r_addr_a[2]~input_o\ & (\inst9|dff_block[2].dff_inst|q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101001100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux5~0_combout\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst9|dff_block[2].dff_inst|q~q\,
	datad => \inst17|dff_block[2].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux5~1_combout\);

-- Location: LCCOMB_X29_Y28_N6
\Porta_A_Leitura|Mux5~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux5~9_combout\ = (\Porta_A_Leitura|Mux5~6_combout\ & ((\Porta_A_Leitura|Mux5~8_combout\) # ((!\r_addr_a[1]~input_o\)))) # (!\Porta_A_Leitura|Mux5~6_combout\ & (((\Porta_A_Leitura|Mux5~1_combout\ & \r_addr_a[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux5~8_combout\,
	datab => \Porta_A_Leitura|Mux5~6_combout\,
	datac => \Porta_A_Leitura|Mux5~1_combout\,
	datad => \r_addr_a[1]~input_o\,
	combout => \Porta_A_Leitura|Mux5~9_combout\);

-- Location: IOIBUF_X29_Y0_N1
\w_data[1]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_data(1),
	o => \w_data[1]~input_o\);

-- Location: FF_X28_Y27_N25
\8_registrador|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[7]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \8_registrador|dff_block[1].dff_inst|q~q\);

-- Location: FF_X27_Y27_N19
\inst9|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[6]~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst9|dff_block[1].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y27_N18
\Porta_A_Leitura|Mux6~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux6~1_combout\ = (\Porta_A_Leitura|Mux6~0_combout\ & ((\8_registrador|dff_block[1].dff_inst|q~q\) # ((!\r_addr_a[1]~input_o\)))) # (!\Porta_A_Leitura|Mux6~0_combout\ & (((\inst9|dff_block[1].dff_inst|q~q\ & \r_addr_a[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux6~0_combout\,
	datab => \8_registrador|dff_block[1].dff_inst|q~q\,
	datac => \inst9|dff_block[1].dff_inst|q~q\,
	datad => \r_addr_a[1]~input_o\,
	combout => \Porta_A_Leitura|Mux6~1_combout\);

-- Location: LCCOMB_X39_Y40_N30
\inst|Decoder0~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~7_combout\ = (!\w_addr[0]~input_o\ & (!\w_addr[2]~input_o\ & (\w_addr[3]~input_o\ & !\w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~7_combout\);

-- Location: LCCOMB_X38_Y40_N14
\inst|we_dec[8]~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[8]~7_combout\ = (\inst|Decoder0~7_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|Decoder0~7_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[8]~7_combout\);

-- Location: FF_X28_Y28_N5
\inst11|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[8]~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst11|dff_block[1].dff_inst|q~q\);

-- Location: FF_X28_Y28_N27
\inst13|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[10]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst13|dff_block[1].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y28_N26
\Porta_A_Leitura|Mux6~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux6~2_combout\ = (\r_addr_a[1]~input_o\ & (((\inst13|dff_block[1].dff_inst|q~q\) # (\r_addr_a[0]~input_o\)))) # (!\r_addr_a[1]~input_o\ & (\inst11|dff_block[1].dff_inst|q~q\ & ((!\r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \inst11|dff_block[1].dff_inst|q~q\,
	datac => \inst13|dff_block[1].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux6~2_combout\);

-- Location: FF_X27_Y28_N29
\inst12|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[9]~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst12|dff_block[1].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y28_N28
\Porta_A_Leitura|Mux6~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux6~3_combout\ = (\Porta_A_Leitura|Mux6~2_combout\ & ((\inst14|dff_block[1].dff_inst|q~q\) # ((!\r_addr_a[0]~input_o\)))) # (!\Porta_A_Leitura|Mux6~2_combout\ & (((\inst12|dff_block[1].dff_inst|q~q\ & \r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst14|dff_block[1].dff_inst|q~q\,
	datab => \Porta_A_Leitura|Mux6~2_combout\,
	datac => \inst12|dff_block[1].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux6~3_combout\);

-- Location: FF_X27_Y29_N25
\inst5|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[2]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst5|dff_block[1].dff_inst|q~q\);

-- Location: FF_X28_Y29_N11
\inst3|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[0]~15_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst3|dff_block[1].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y29_N24
\Porta_A_Leitura|Mux6~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux6~4_combout\ = (\r_addr_a[1]~input_o\ & ((\r_addr_a[0]~input_o\) # ((\inst5|dff_block[1].dff_inst|q~q\)))) # (!\r_addr_a[1]~input_o\ & (!\r_addr_a[0]~input_o\ & ((\inst3|dff_block[1].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100110101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \r_addr_a[0]~input_o\,
	datac => \inst5|dff_block[1].dff_inst|q~q\,
	datad => \inst3|dff_block[1].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux6~4_combout\);

-- Location: FF_X28_Y29_N9
\inst4|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[1]~14_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst4|dff_block[1].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y29_N8
\Porta_A_Leitura|Mux6~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux6~5_combout\ = (\Porta_A_Leitura|Mux6~4_combout\ & ((\inst6|dff_block[1].dff_inst|q~q\) # ((!\r_addr_a[0]~input_o\)))) # (!\Porta_A_Leitura|Mux6~4_combout\ & (((\inst4|dff_block[1].dff_inst|q~q\ & \r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst6|dff_block[1].dff_inst|q~q\,
	datab => \Porta_A_Leitura|Mux6~4_combout\,
	datac => \inst4|dff_block[1].dff_inst|q~q\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux6~5_combout\);

-- Location: LCCOMB_X27_Y28_N24
\Porta_A_Leitura|Mux6~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux6~6_combout\ = (\r_addr_a[2]~input_o\ & (((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & ((\r_addr_a[3]~input_o\ & (\Porta_A_Leitura|Mux6~3_combout\)) # (!\r_addr_a[3]~input_o\ & ((\Porta_A_Leitura|Mux6~5_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[2]~input_o\,
	datab => \Porta_A_Leitura|Mux6~3_combout\,
	datac => \Porta_A_Leitura|Mux6~5_combout\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux6~6_combout\);

-- Location: FF_X28_Y30_N19
\inst18|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst18|dff_block[1].dff_inst|q~q\);

-- Location: FF_X28_Y30_N1
\inst17|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[14]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst17|dff_block[1].dff_inst|q~q\);

-- Location: FF_X29_Y30_N19
\inst15|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[12]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst15|dff_block[1].dff_inst|q~q\);

-- Location: FF_X29_Y30_N25
\inst16|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[13]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst16|dff_block[1].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y30_N24
\Porta_A_Leitura|Mux6~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux6~7_combout\ = (\r_addr_a[0]~input_o\ & (((\inst16|dff_block[1].dff_inst|q~q\) # (\r_addr_a[1]~input_o\)))) # (!\r_addr_a[0]~input_o\ & (\inst15|dff_block[1].dff_inst|q~q\ & ((!\r_addr_a[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[0]~input_o\,
	datab => \inst15|dff_block[1].dff_inst|q~q\,
	datac => \inst16|dff_block[1].dff_inst|q~q\,
	datad => \r_addr_a[1]~input_o\,
	combout => \Porta_A_Leitura|Mux6~7_combout\);

-- Location: LCCOMB_X28_Y30_N0
\Porta_A_Leitura|Mux6~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux6~8_combout\ = (\r_addr_a[1]~input_o\ & ((\Porta_A_Leitura|Mux6~7_combout\ & (\inst18|dff_block[1].dff_inst|q~q\)) # (!\Porta_A_Leitura|Mux6~7_combout\ & ((\inst17|dff_block[1].dff_inst|q~q\))))) # (!\r_addr_a[1]~input_o\ & 
-- (((\Porta_A_Leitura|Mux6~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[1]~input_o\,
	datab => \inst18|dff_block[1].dff_inst|q~q\,
	datac => \inst17|dff_block[1].dff_inst|q~q\,
	datad => \Porta_A_Leitura|Mux6~7_combout\,
	combout => \Porta_A_Leitura|Mux6~8_combout\);

-- Location: LCCOMB_X28_Y28_N22
\Porta_A_Leitura|Mux6~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux6~9_combout\ = (\r_addr_a[2]~input_o\ & ((\Porta_A_Leitura|Mux6~6_combout\ & ((\Porta_A_Leitura|Mux6~8_combout\))) # (!\Porta_A_Leitura|Mux6~6_combout\ & (\Porta_A_Leitura|Mux6~1_combout\)))) # (!\r_addr_a[2]~input_o\ & 
-- (((\Porta_A_Leitura|Mux6~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[2]~input_o\,
	datab => \Porta_A_Leitura|Mux6~1_combout\,
	datac => \Porta_A_Leitura|Mux6~6_combout\,
	datad => \Porta_A_Leitura|Mux6~8_combout\,
	combout => \Porta_A_Leitura|Mux6~9_combout\);

-- Location: IOIBUF_X52_Y25_N1
\w_data[0]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_w_data(0),
	o => \w_data[0]~input_o\);

-- Location: FF_X28_Y30_N29
\inst18|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst18|dff_block[0].dff_inst|q~q\);

-- Location: FF_X29_Y29_N31
\8_registrador|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[7]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \8_registrador|dff_block[0].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y29_N30
\Porta_A_Leitura|Mux7~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux7~8_combout\ = (\Porta_A_Leitura|Mux7~7_combout\ & ((\inst18|dff_block[0].dff_inst|q~q\) # ((!\r_addr_a[2]~input_o\)))) # (!\Porta_A_Leitura|Mux7~7_combout\ & (((\8_registrador|dff_block[0].dff_inst|q~q\ & \r_addr_a[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux7~7_combout\,
	datab => \inst18|dff_block[0].dff_inst|q~q\,
	datac => \8_registrador|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_a[2]~input_o\,
	combout => \Porta_A_Leitura|Mux7~8_combout\);

-- Location: FF_X29_Y30_N31
\inst15|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[12]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst15|dff_block[0].dff_inst|q~q\);

-- Location: FF_X29_Y28_N19
\inst11|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[8]~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst11|dff_block[0].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y28_N18
\Porta_A_Leitura|Mux7~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux7~5_combout\ = (\Porta_A_Leitura|Mux7~4_combout\ & ((\inst15|dff_block[0].dff_inst|q~q\) # ((!\r_addr_a[3]~input_o\)))) # (!\Porta_A_Leitura|Mux7~4_combout\ & (((\inst11|dff_block[0].dff_inst|q~q\ & \r_addr_a[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux7~4_combout\,
	datab => \inst15|dff_block[0].dff_inst|q~q\,
	datac => \inst11|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux7~5_combout\);

-- Location: LCCOMB_X29_Y28_N20
\Porta_A_Leitura|Mux7~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux7~6_combout\ = (\r_addr_a[1]~input_o\ & ((\Porta_A_Leitura|Mux7~3_combout\) # ((\r_addr_a[0]~input_o\)))) # (!\r_addr_a[1]~input_o\ & (((\Porta_A_Leitura|Mux7~5_combout\ & !\r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux7~3_combout\,
	datab => \Porta_A_Leitura|Mux7~5_combout\,
	datac => \r_addr_a[1]~input_o\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux7~6_combout\);

-- Location: FF_X29_Y28_N1
\inst12|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[9]~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst12|dff_block[0].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y28_N0
\Porta_A_Leitura|Mux7~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux7~0_combout\ = (\r_addr_a[2]~input_o\ & (((\r_addr_a[3]~input_o\)))) # (!\r_addr_a[2]~input_o\ & ((\r_addr_a[3]~input_o\ & ((\inst12|dff_block[0].dff_inst|q~q\))) # (!\r_addr_a[3]~input_o\ & (\inst4|dff_block[0].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst4|dff_block[0].dff_inst|q~q\,
	datab => \r_addr_a[2]~input_o\,
	datac => \inst12|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_a[3]~input_o\,
	combout => \Porta_A_Leitura|Mux7~0_combout\);

-- Location: FF_X30_Y29_N25
\inst8|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[5]~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst8|dff_block[0].dff_inst|q~q\);

-- Location: FF_X29_Y30_N21
\inst16|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[13]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst16|dff_block[0].dff_inst|q~q\);

-- Location: LCCOMB_X30_Y29_N24
\Porta_A_Leitura|Mux7~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux7~1_combout\ = (\r_addr_a[2]~input_o\ & ((\Porta_A_Leitura|Mux7~0_combout\ & ((\inst16|dff_block[0].dff_inst|q~q\))) # (!\Porta_A_Leitura|Mux7~0_combout\ & (\inst8|dff_block[0].dff_inst|q~q\)))) # (!\r_addr_a[2]~input_o\ & 
-- (\Porta_A_Leitura|Mux7~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_a[2]~input_o\,
	datab => \Porta_A_Leitura|Mux7~0_combout\,
	datac => \inst8|dff_block[0].dff_inst|q~q\,
	datad => \inst16|dff_block[0].dff_inst|q~q\,
	combout => \Porta_A_Leitura|Mux7~1_combout\);

-- Location: LCCOMB_X29_Y28_N30
\Porta_A_Leitura|Mux7~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_A_Leitura|Mux7~9_combout\ = (\Porta_A_Leitura|Mux7~6_combout\ & ((\Porta_A_Leitura|Mux7~8_combout\) # ((!\r_addr_a[0]~input_o\)))) # (!\Porta_A_Leitura|Mux7~6_combout\ & (((\Porta_A_Leitura|Mux7~1_combout\ & \r_addr_a[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_A_Leitura|Mux7~8_combout\,
	datab => \Porta_A_Leitura|Mux7~6_combout\,
	datac => \Porta_A_Leitura|Mux7~1_combout\,
	datad => \r_addr_a[0]~input_o\,
	combout => \Porta_A_Leitura|Mux7~9_combout\);

-- Location: LCCOMB_X39_Y40_N14
\inst|Decoder0~11\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|Decoder0~11_combout\ = (!\w_addr[0]~input_o\ & (\w_addr[2]~input_o\ & (!\w_addr[3]~input_o\ & !\w_addr[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \w_addr[0]~input_o\,
	datab => \w_addr[2]~input_o\,
	datac => \w_addr[3]~input_o\,
	datad => \w_addr[1]~input_o\,
	combout => \inst|Decoder0~11_combout\);

-- Location: LCCOMB_X38_Y40_N22
\inst|we_dec[4]~11\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|we_dec[4]~11_combout\ = (\inst|Decoder0~11_combout\ & \we~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|Decoder0~11_combout\,
	datad => \we~input_o\,
	combout => \inst|we_dec[4]~11_combout\);

-- Location: IOIBUF_X25_Y41_N8
\r_addr_b[1]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_r_addr_b(1),
	o => \r_addr_b[1]~input_o\);

-- Location: IOIBUF_X18_Y41_N8
\r_addr_b[0]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_r_addr_b(0),
	o => \r_addr_b[0]~input_o\);

-- Location: FF_X29_Y28_N11
\inst11|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[8]~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst11|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y28_N10
\Porta_B_Leitura|Mux0~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux0~0_combout\ = (\r_addr_b[1]~input_o\ & (\r_addr_b[0]~input_o\)) # (!\r_addr_b[1]~input_o\ & ((\r_addr_b[0]~input_o\ & ((\inst12|dff_block[7].dff_inst|q~q\))) # (!\r_addr_b[0]~input_o\ & (\inst11|dff_block[7].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \r_addr_b[0]~input_o\,
	datac => \inst11|dff_block[7].dff_inst|q~q\,
	datad => \inst12|dff_block[7].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux0~0_combout\);

-- Location: LCCOMB_X30_Y29_N16
\Porta_B_Leitura|Mux0~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux0~1_combout\ = (\r_addr_b[1]~input_o\ & ((\Porta_B_Leitura|Mux0~0_combout\ & ((\inst14|dff_block[7].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux0~0_combout\ & (\inst13|dff_block[7].dff_inst|q~q\)))) # (!\r_addr_b[1]~input_o\ & 
-- (((\Porta_B_Leitura|Mux0~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst13|dff_block[7].dff_inst|q~q\,
	datab => \r_addr_b[1]~input_o\,
	datac => \inst14|dff_block[7].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux0~0_combout\,
	combout => \Porta_B_Leitura|Mux0~1_combout\);

-- Location: FF_X27_Y29_N19
\inst17|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[14]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst17|dff_block[7].dff_inst|q~q\);

-- Location: FF_X27_Y30_N17
\inst15|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[12]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst15|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y30_N16
\Porta_B_Leitura|Mux0~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux0~7_combout\ = (\r_addr_b[0]~input_o\ & (((\r_addr_b[1]~input_o\)))) # (!\r_addr_b[0]~input_o\ & ((\r_addr_b[1]~input_o\ & (\inst17|dff_block[7].dff_inst|q~q\)) # (!\r_addr_b[1]~input_o\ & ((\inst15|dff_block[7].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[0]~input_o\,
	datab => \inst17|dff_block[7].dff_inst|q~q\,
	datac => \inst15|dff_block[7].dff_inst|q~q\,
	datad => \r_addr_b[1]~input_o\,
	combout => \Porta_B_Leitura|Mux0~7_combout\);

-- Location: LCCOMB_X29_Y27_N28
\Porta_B_Leitura|Mux0~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux0~8_combout\ = (\r_addr_b[0]~input_o\ & ((\Porta_B_Leitura|Mux0~7_combout\ & (\inst18|dff_block[7].dff_inst|q~q\)) # (!\Porta_B_Leitura|Mux0~7_combout\ & ((\inst16|dff_block[7].dff_inst|q~q\))))) # (!\r_addr_b[0]~input_o\ & 
-- (\Porta_B_Leitura|Mux0~7_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110011011000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[0]~input_o\,
	datab => \Porta_B_Leitura|Mux0~7_combout\,
	datac => \inst18|dff_block[7].dff_inst|q~q\,
	datad => \inst16|dff_block[7].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux0~8_combout\);

-- Location: IOIBUF_X52_Y27_N1
\r_addr_b[3]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_r_addr_b(3),
	o => \r_addr_b[3]~input_o\);

-- Location: FF_X29_Y29_N17
\8_registrador|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[7]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \8_registrador|dff_block[7].dff_inst|q~q\);

-- Location: FF_X28_Y27_N17
\inst8|dff_block[7].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[7]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[5]~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst8|dff_block[7].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y29_N16
\Porta_B_Leitura|Mux0~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux0~3_combout\ = (\Porta_B_Leitura|Mux0~2_combout\ & (((\8_registrador|dff_block[7].dff_inst|q~q\)) # (!\r_addr_b[0]~input_o\))) # (!\Porta_B_Leitura|Mux0~2_combout\ & (\r_addr_b[0]~input_o\ & ((\inst8|dff_block[7].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110011010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux0~2_combout\,
	datab => \r_addr_b[0]~input_o\,
	datac => \8_registrador|dff_block[7].dff_inst|q~q\,
	datad => \inst8|dff_block[7].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux0~3_combout\);

-- Location: IOIBUF_X29_Y41_N8
\r_addr_b[2]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_r_addr_b(2),
	o => \r_addr_b[2]~input_o\);

-- Location: LCCOMB_X29_Y29_N26
\Porta_B_Leitura|Mux0~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux0~6_combout\ = (\r_addr_b[3]~input_o\ & (((\r_addr_b[2]~input_o\)))) # (!\r_addr_b[3]~input_o\ & ((\r_addr_b[2]~input_o\ & ((\Porta_B_Leitura|Mux0~3_combout\))) # (!\r_addr_b[2]~input_o\ & (\Porta_B_Leitura|Mux0~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux0~5_combout\,
	datab => \Porta_B_Leitura|Mux0~3_combout\,
	datac => \r_addr_b[3]~input_o\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux0~6_combout\);

-- Location: LCCOMB_X29_Y27_N24
\Porta_B_Leitura|Mux0~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux0~9_combout\ = (\r_addr_b[3]~input_o\ & ((\Porta_B_Leitura|Mux0~6_combout\ & ((\Porta_B_Leitura|Mux0~8_combout\))) # (!\Porta_B_Leitura|Mux0~6_combout\ & (\Porta_B_Leitura|Mux0~1_combout\)))) # (!\r_addr_b[3]~input_o\ & 
-- (((\Porta_B_Leitura|Mux0~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux0~1_combout\,
	datab => \Porta_B_Leitura|Mux0~8_combout\,
	datac => \r_addr_b[3]~input_o\,
	datad => \Porta_B_Leitura|Mux0~6_combout\,
	combout => \Porta_B_Leitura|Mux0~9_combout\);

-- Location: FF_X29_Y29_N21
\8_registrador|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[7]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \8_registrador|dff_block[6].dff_inst|q~q\);

-- Location: FF_X29_Y29_N7
\inst6|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[3]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst6|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y29_N6
\Porta_B_Leitura|Mux1~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux1~7_combout\ = (\r_addr_b[3]~input_o\ & (((\r_addr_b[2]~input_o\)))) # (!\r_addr_b[3]~input_o\ & ((\r_addr_b[2]~input_o\ & (\8_registrador|dff_block[6].dff_inst|q~q\)) # (!\r_addr_b[2]~input_o\ & 
-- ((\inst6|dff_block[6].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[3]~input_o\,
	datab => \8_registrador|dff_block[6].dff_inst|q~q\,
	datac => \inst6|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux1~7_combout\);

-- Location: LCCOMB_X28_Y30_N26
\Porta_B_Leitura|Mux1~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux1~8_combout\ = (\r_addr_b[3]~input_o\ & ((\Porta_B_Leitura|Mux1~7_combout\ & ((\inst18|dff_block[6].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux1~7_combout\ & (\inst14|dff_block[6].dff_inst|q~q\)))) # (!\r_addr_b[3]~input_o\ & 
-- (((\Porta_B_Leitura|Mux1~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[3]~input_o\,
	datab => \inst14|dff_block[6].dff_inst|q~q\,
	datac => \inst18|dff_block[6].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux1~7_combout\,
	combout => \Porta_B_Leitura|Mux1~8_combout\);

-- Location: FF_X28_Y28_N21
\inst11|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[8]~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst11|dff_block[6].dff_inst|q~q\);

-- Location: FF_X28_Y29_N7
\inst3|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[0]~15_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst3|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y29_N6
\Porta_B_Leitura|Mux1~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux1~4_combout\ = (\r_addr_b[2]~input_o\ & (((\r_addr_b[3]~input_o\)))) # (!\r_addr_b[2]~input_o\ & ((\r_addr_b[3]~input_o\ & (\inst11|dff_block[6].dff_inst|q~q\)) # (!\r_addr_b[3]~input_o\ & ((\inst3|dff_block[6].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[2]~input_o\,
	datab => \inst11|dff_block[6].dff_inst|q~q\,
	datac => \inst3|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux1~4_combout\);

-- Location: FF_X27_Y30_N13
\inst15|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[12]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst15|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y30_N12
\Porta_B_Leitura|Mux1~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux1~5_combout\ = (\Porta_B_Leitura|Mux1~4_combout\ & (((\inst15|dff_block[6].dff_inst|q~q\) # (!\r_addr_b[2]~input_o\)))) # (!\Porta_B_Leitura|Mux1~4_combout\ & (\inst7|dff_block[6].dff_inst|q~q\ & ((\r_addr_b[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|dff_block[6].dff_inst|q~q\,
	datab => \Porta_B_Leitura|Mux1~4_combout\,
	datac => \inst15|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux1~5_combout\);

-- Location: LCCOMB_X27_Y30_N20
\Porta_B_Leitura|Mux1~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux1~6_combout\ = (\r_addr_b[1]~input_o\ & (((\r_addr_b[0]~input_o\)))) # (!\r_addr_b[1]~input_o\ & ((\r_addr_b[0]~input_o\ & (\Porta_B_Leitura|Mux1~3_combout\)) # (!\r_addr_b[0]~input_o\ & ((\Porta_B_Leitura|Mux1~5_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001111100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux1~3_combout\,
	datab => \r_addr_b[1]~input_o\,
	datac => \r_addr_b[0]~input_o\,
	datad => \Porta_B_Leitura|Mux1~5_combout\,
	combout => \Porta_B_Leitura|Mux1~6_combout\);

-- Location: FF_X27_Y29_N13
\inst5|dff_block[6].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[6]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[2]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst5|dff_block[6].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y29_N12
\Porta_B_Leitura|Mux1~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux1~0_combout\ = (\r_addr_b[2]~input_o\ & (((\r_addr_b[3]~input_o\)))) # (!\r_addr_b[2]~input_o\ & ((\r_addr_b[3]~input_o\ & (\inst13|dff_block[6].dff_inst|q~q\)) # (!\r_addr_b[3]~input_o\ & ((\inst5|dff_block[6].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst13|dff_block[6].dff_inst|q~q\,
	datab => \r_addr_b[2]~input_o\,
	datac => \inst5|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux1~0_combout\);

-- Location: LCCOMB_X28_Y30_N8
\Porta_B_Leitura|Mux1~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux1~1_combout\ = (\Porta_B_Leitura|Mux1~0_combout\ & (((\inst17|dff_block[6].dff_inst|q~q\) # (!\r_addr_b[2]~input_o\)))) # (!\Porta_B_Leitura|Mux1~0_combout\ & (\inst9|dff_block[6].dff_inst|q~q\ & ((\r_addr_b[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|dff_block[6].dff_inst|q~q\,
	datab => \Porta_B_Leitura|Mux1~0_combout\,
	datac => \inst17|dff_block[6].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux1~1_combout\);

-- Location: LCCOMB_X28_Y30_N14
\Porta_B_Leitura|Mux1~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux1~9_combout\ = (\Porta_B_Leitura|Mux1~6_combout\ & ((\Porta_B_Leitura|Mux1~8_combout\) # ((!\r_addr_b[1]~input_o\)))) # (!\Porta_B_Leitura|Mux1~6_combout\ & (((\Porta_B_Leitura|Mux1~1_combout\ & \r_addr_b[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux1~8_combout\,
	datab => \Porta_B_Leitura|Mux1~6_combout\,
	datac => \Porta_B_Leitura|Mux1~1_combout\,
	datad => \r_addr_b[1]~input_o\,
	combout => \Porta_B_Leitura|Mux1~9_combout\);

-- Location: LCCOMB_X28_Y30_N22
\Porta_B_Leitura|Mux2~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux2~8_combout\ = (\Porta_B_Leitura|Mux2~7_combout\ & (((\inst18|dff_block[5].dff_inst|q~q\)) # (!\r_addr_b[1]~input_o\))) # (!\Porta_B_Leitura|Mux2~7_combout\ & (\r_addr_b[1]~input_o\ & ((\inst17|dff_block[5].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110011010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux2~7_combout\,
	datab => \r_addr_b[1]~input_o\,
	datac => \inst18|dff_block[5].dff_inst|q~q\,
	datad => \inst17|dff_block[5].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux2~8_combout\);

-- Location: FF_X28_Y27_N21
\inst8|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[5]~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst8|dff_block[5].dff_inst|q~q\);

-- Location: FF_X27_Y27_N3
\inst7|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[4]~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst7|dff_block[5].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y27_N2
\Porta_B_Leitura|Mux2~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux2~0_combout\ = (\r_addr_b[1]~input_o\ & (((\r_addr_b[0]~input_o\)))) # (!\r_addr_b[1]~input_o\ & ((\r_addr_b[0]~input_o\ & (\inst8|dff_block[5].dff_inst|q~q\)) # (!\r_addr_b[0]~input_o\ & ((\inst7|dff_block[5].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \inst8|dff_block[5].dff_inst|q~q\,
	datac => \inst7|dff_block[5].dff_inst|q~q\,
	datad => \r_addr_b[0]~input_o\,
	combout => \Porta_B_Leitura|Mux2~0_combout\);

-- Location: LCCOMB_X28_Y27_N14
\Porta_B_Leitura|Mux2~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux2~1_combout\ = (\r_addr_b[1]~input_o\ & ((\Porta_B_Leitura|Mux2~0_combout\ & ((\8_registrador|dff_block[5].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux2~0_combout\ & (\inst9|dff_block[5].dff_inst|q~q\)))) # (!\r_addr_b[1]~input_o\ & 
-- (((\Porta_B_Leitura|Mux2~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|dff_block[5].dff_inst|q~q\,
	datab => \r_addr_b[1]~input_o\,
	datac => \8_registrador|dff_block[5].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux2~0_combout\,
	combout => \Porta_B_Leitura|Mux2~1_combout\);

-- Location: FF_X27_Y28_N31
\inst14|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[11]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst14|dff_block[5].dff_inst|q~q\);

-- Location: FF_X28_Y28_N15
\inst13|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[10]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst13|dff_block[5].dff_inst|q~q\);

-- Location: FF_X28_Y28_N17
\inst11|dff_block[5].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[5]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[8]~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst11|dff_block[5].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y28_N16
\Porta_B_Leitura|Mux2~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux2~2_combout\ = (\r_addr_b[1]~input_o\ & ((\inst13|dff_block[5].dff_inst|q~q\) # ((\r_addr_b[0]~input_o\)))) # (!\r_addr_b[1]~input_o\ & (((\inst11|dff_block[5].dff_inst|q~q\ & !\r_addr_b[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \inst13|dff_block[5].dff_inst|q~q\,
	datac => \inst11|dff_block[5].dff_inst|q~q\,
	datad => \r_addr_b[0]~input_o\,
	combout => \Porta_B_Leitura|Mux2~2_combout\);

-- Location: LCCOMB_X27_Y28_N30
\Porta_B_Leitura|Mux2~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux2~3_combout\ = (\r_addr_b[0]~input_o\ & ((\Porta_B_Leitura|Mux2~2_combout\ & ((\inst14|dff_block[5].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux2~2_combout\ & (\inst12|dff_block[5].dff_inst|q~q\)))) # (!\r_addr_b[0]~input_o\ & 
-- (((\Porta_B_Leitura|Mux2~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst12|dff_block[5].dff_inst|q~q\,
	datab => \r_addr_b[0]~input_o\,
	datac => \inst14|dff_block[5].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux2~2_combout\,
	combout => \Porta_B_Leitura|Mux2~3_combout\);

-- Location: LCCOMB_X27_Y28_N10
\Porta_B_Leitura|Mux2~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux2~6_combout\ = (\r_addr_b[2]~input_o\ & (((\r_addr_b[3]~input_o\)))) # (!\r_addr_b[2]~input_o\ & ((\r_addr_b[3]~input_o\ & ((\Porta_B_Leitura|Mux2~3_combout\))) # (!\r_addr_b[3]~input_o\ & (\Porta_B_Leitura|Mux2~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux2~5_combout\,
	datab => \Porta_B_Leitura|Mux2~3_combout\,
	datac => \r_addr_b[2]~input_o\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux2~6_combout\);

-- Location: LCCOMB_X27_Y28_N20
\Porta_B_Leitura|Mux2~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux2~9_combout\ = (\r_addr_b[2]~input_o\ & ((\Porta_B_Leitura|Mux2~6_combout\ & (\Porta_B_Leitura|Mux2~8_combout\)) # (!\Porta_B_Leitura|Mux2~6_combout\ & ((\Porta_B_Leitura|Mux2~1_combout\))))) # (!\r_addr_b[2]~input_o\ & 
-- (((\Porta_B_Leitura|Mux2~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux2~8_combout\,
	datab => \Porta_B_Leitura|Mux2~1_combout\,
	datac => \r_addr_b[2]~input_o\,
	datad => \Porta_B_Leitura|Mux2~6_combout\,
	combout => \Porta_B_Leitura|Mux2~9_combout\);

-- Location: FF_X28_Y29_N31
\inst3|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[0]~15_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst3|dff_block[4].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y29_N30
\Porta_B_Leitura|Mux3~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux3~4_combout\ = (\r_addr_b[3]~input_o\ & (((\r_addr_b[2]~input_o\)))) # (!\r_addr_b[3]~input_o\ & ((\r_addr_b[2]~input_o\ & (\inst7|dff_block[4].dff_inst|q~q\)) # (!\r_addr_b[2]~input_o\ & ((\inst3|dff_block[4].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst7|dff_block[4].dff_inst|q~q\,
	datab => \r_addr_b[3]~input_o\,
	datac => \inst3|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux3~4_combout\);

-- Location: FF_X27_Y30_N29
\inst15|dff_block[4].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[4]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[12]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst15|dff_block[4].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y30_N28
\Porta_B_Leitura|Mux3~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux3~5_combout\ = (\Porta_B_Leitura|Mux3~4_combout\ & (((\inst15|dff_block[4].dff_inst|q~q\) # (!\r_addr_b[3]~input_o\)))) # (!\Porta_B_Leitura|Mux3~4_combout\ & (\inst11|dff_block[4].dff_inst|q~q\ & ((\r_addr_b[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst11|dff_block[4].dff_inst|q~q\,
	datab => \Porta_B_Leitura|Mux3~4_combout\,
	datac => \inst15|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux3~5_combout\);

-- Location: LCCOMB_X28_Y30_N24
\Porta_B_Leitura|Mux3~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux3~3_combout\ = (\Porta_B_Leitura|Mux3~2_combout\ & (((\inst17|dff_block[4].dff_inst|q~q\) # (!\r_addr_b[3]~input_o\)))) # (!\Porta_B_Leitura|Mux3~2_combout\ & (\inst13|dff_block[4].dff_inst|q~q\ & ((\r_addr_b[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110010010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux3~2_combout\,
	datab => \inst13|dff_block[4].dff_inst|q~q\,
	datac => \inst17|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux3~3_combout\);

-- Location: LCCOMB_X27_Y30_N22
\Porta_B_Leitura|Mux3~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux3~6_combout\ = (\r_addr_b[1]~input_o\ & (((\r_addr_b[0]~input_o\) # (\Porta_B_Leitura|Mux3~3_combout\)))) # (!\r_addr_b[1]~input_o\ & (\Porta_B_Leitura|Mux3~5_combout\ & (!\r_addr_b[0]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111010100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \Porta_B_Leitura|Mux3~5_combout\,
	datac => \r_addr_b[0]~input_o\,
	datad => \Porta_B_Leitura|Mux3~3_combout\,
	combout => \Porta_B_Leitura|Mux3~6_combout\);

-- Location: LCCOMB_X28_Y30_N10
\Porta_B_Leitura|Mux3~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux3~8_combout\ = (\Porta_B_Leitura|Mux3~7_combout\ & (((\inst18|dff_block[4].dff_inst|q~q\) # (!\r_addr_b[2]~input_o\)))) # (!\Porta_B_Leitura|Mux3~7_combout\ & (\8_registrador|dff_block[4].dff_inst|q~q\ & ((\r_addr_b[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110010010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux3~7_combout\,
	datab => \8_registrador|dff_block[4].dff_inst|q~q\,
	datac => \inst18|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux3~8_combout\);

-- Location: LCCOMB_X27_Y30_N26
\Porta_B_Leitura|Mux3~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux3~1_combout\ = (\Porta_B_Leitura|Mux3~0_combout\ & (((\inst16|dff_block[4].dff_inst|q~q\) # (!\r_addr_b[2]~input_o\)))) # (!\Porta_B_Leitura|Mux3~0_combout\ & (\inst8|dff_block[4].dff_inst|q~q\ & ((\r_addr_b[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110010010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux3~0_combout\,
	datab => \inst8|dff_block[4].dff_inst|q~q\,
	datac => \inst16|dff_block[4].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux3~1_combout\);

-- Location: LCCOMB_X27_Y30_N0
\Porta_B_Leitura|Mux3~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux3~9_combout\ = (\Porta_B_Leitura|Mux3~6_combout\ & ((\Porta_B_Leitura|Mux3~8_combout\) # ((!\r_addr_b[0]~input_o\)))) # (!\Porta_B_Leitura|Mux3~6_combout\ & (((\Porta_B_Leitura|Mux3~1_combout\ & \r_addr_b[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux3~6_combout\,
	datab => \Porta_B_Leitura|Mux3~8_combout\,
	datac => \Porta_B_Leitura|Mux3~1_combout\,
	datad => \r_addr_b[0]~input_o\,
	combout => \Porta_B_Leitura|Mux3~9_combout\);

-- Location: FF_X29_Y28_N15
\inst11|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[8]~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst11|dff_block[3].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y28_N14
\Porta_B_Leitura|Mux4~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux4~0_combout\ = (\r_addr_b[1]~input_o\ & (\r_addr_b[0]~input_o\)) # (!\r_addr_b[1]~input_o\ & ((\r_addr_b[0]~input_o\ & ((\inst12|dff_block[3].dff_inst|q~q\))) # (!\r_addr_b[0]~input_o\ & (\inst11|dff_block[3].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \r_addr_b[0]~input_o\,
	datac => \inst11|dff_block[3].dff_inst|q~q\,
	datad => \inst12|dff_block[3].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux4~0_combout\);

-- Location: LCCOMB_X30_Y29_N2
\Porta_B_Leitura|Mux4~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux4~1_combout\ = (\r_addr_b[1]~input_o\ & ((\Porta_B_Leitura|Mux4~0_combout\ & ((\inst14|dff_block[3].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux4~0_combout\ & (\inst13|dff_block[3].dff_inst|q~q\)))) # (!\r_addr_b[1]~input_o\ & 
-- (((\Porta_B_Leitura|Mux4~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst13|dff_block[3].dff_inst|q~q\,
	datab => \r_addr_b[1]~input_o\,
	datac => \inst14|dff_block[3].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux4~0_combout\,
	combout => \Porta_B_Leitura|Mux4~1_combout\);

-- Location: FF_X28_Y27_N11
\inst8|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[5]~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst8|dff_block[3].dff_inst|q~q\);

-- Location: FF_X28_Y27_N13
\8_registrador|dff_block[3].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[3]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[7]~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \8_registrador|dff_block[3].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y27_N12
\Porta_B_Leitura|Mux4~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux4~3_combout\ = (\Porta_B_Leitura|Mux4~2_combout\ & (((\8_registrador|dff_block[3].dff_inst|q~q\) # (!\r_addr_b[0]~input_o\)))) # (!\Porta_B_Leitura|Mux4~2_combout\ & (\inst8|dff_block[3].dff_inst|q~q\ & ((\r_addr_b[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110010010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux4~2_combout\,
	datab => \inst8|dff_block[3].dff_inst|q~q\,
	datac => \8_registrador|dff_block[3].dff_inst|q~q\,
	datad => \r_addr_b[0]~input_o\,
	combout => \Porta_B_Leitura|Mux4~3_combout\);

-- Location: LCCOMB_X29_Y27_N18
\Porta_B_Leitura|Mux4~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux4~6_combout\ = (\r_addr_b[2]~input_o\ & (((\r_addr_b[3]~input_o\) # (\Porta_B_Leitura|Mux4~3_combout\)))) # (!\r_addr_b[2]~input_o\ & (\Porta_B_Leitura|Mux4~5_combout\ & (!\r_addr_b[3]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111011000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux4~5_combout\,
	datab => \r_addr_b[2]~input_o\,
	datac => \r_addr_b[3]~input_o\,
	datad => \Porta_B_Leitura|Mux4~3_combout\,
	combout => \Porta_B_Leitura|Mux4~6_combout\);

-- Location: LCCOMB_X29_Y27_N20
\Porta_B_Leitura|Mux4~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux4~8_combout\ = (\Porta_B_Leitura|Mux4~7_combout\ & (((\inst18|dff_block[3].dff_inst|q~q\) # (!\r_addr_b[0]~input_o\)))) # (!\Porta_B_Leitura|Mux4~7_combout\ & (\inst16|dff_block[3].dff_inst|q~q\ & ((\r_addr_b[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110010010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux4~7_combout\,
	datab => \inst16|dff_block[3].dff_inst|q~q\,
	datac => \inst18|dff_block[3].dff_inst|q~q\,
	datad => \r_addr_b[0]~input_o\,
	combout => \Porta_B_Leitura|Mux4~8_combout\);

-- Location: LCCOMB_X29_Y27_N12
\Porta_B_Leitura|Mux4~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux4~9_combout\ = (\Porta_B_Leitura|Mux4~6_combout\ & (((\Porta_B_Leitura|Mux4~8_combout\) # (!\r_addr_b[3]~input_o\)))) # (!\Porta_B_Leitura|Mux4~6_combout\ & (\Porta_B_Leitura|Mux4~1_combout\ & (\r_addr_b[3]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110000101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux4~1_combout\,
	datab => \Porta_B_Leitura|Mux4~6_combout\,
	datac => \r_addr_b[3]~input_o\,
	datad => \Porta_B_Leitura|Mux4~8_combout\,
	combout => \Porta_B_Leitura|Mux4~9_combout\);

-- Location: FF_X29_Y28_N27
\inst11|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[8]~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst11|dff_block[2].dff_inst|q~q\);

-- Location: FF_X28_Y29_N15
\inst3|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[0]~15_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst3|dff_block[2].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y29_N14
\Porta_B_Leitura|Mux5~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux5~4_combout\ = (\r_addr_b[2]~input_o\ & (((\r_addr_b[3]~input_o\)))) # (!\r_addr_b[2]~input_o\ & ((\r_addr_b[3]~input_o\ & (\inst11|dff_block[2].dff_inst|q~q\)) # (!\r_addr_b[3]~input_o\ & ((\inst3|dff_block[2].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[2]~input_o\,
	datab => \inst11|dff_block[2].dff_inst|q~q\,
	datac => \inst3|dff_block[2].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux5~4_combout\);

-- Location: FF_X27_Y30_N19
\inst15|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[12]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst15|dff_block[2].dff_inst|q~q\);

-- Location: FF_X28_Y26_N17
\inst7|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[4]~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst7|dff_block[2].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y30_N18
\Porta_B_Leitura|Mux5~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux5~5_combout\ = (\r_addr_b[2]~input_o\ & ((\Porta_B_Leitura|Mux5~4_combout\ & (\inst15|dff_block[2].dff_inst|q~q\)) # (!\Porta_B_Leitura|Mux5~4_combout\ & ((\inst7|dff_block[2].dff_inst|q~q\))))) # (!\r_addr_b[2]~input_o\ & 
-- (\Porta_B_Leitura|Mux5~4_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110011011000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[2]~input_o\,
	datab => \Porta_B_Leitura|Mux5~4_combout\,
	datac => \inst15|dff_block[2].dff_inst|q~q\,
	datad => \inst7|dff_block[2].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux5~5_combout\);

-- Location: LCCOMB_X28_Y29_N12
\Porta_B_Leitura|Mux5~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux5~2_combout\ = (\r_addr_b[2]~input_o\ & ((\r_addr_b[3]~input_o\) # ((\inst8|dff_block[2].dff_inst|q~q\)))) # (!\r_addr_b[2]~input_o\ & (!\r_addr_b[3]~input_o\ & (\inst4|dff_block[2].dff_inst|q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[2]~input_o\,
	datab => \r_addr_b[3]~input_o\,
	datac => \inst4|dff_block[2].dff_inst|q~q\,
	datad => \inst8|dff_block[2].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux5~2_combout\);

-- Location: FF_X27_Y30_N25
\inst16|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[13]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst16|dff_block[2].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y30_N24
\Porta_B_Leitura|Mux5~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux5~3_combout\ = (\Porta_B_Leitura|Mux5~2_combout\ & (((\inst16|dff_block[2].dff_inst|q~q\) # (!\r_addr_b[3]~input_o\)))) # (!\Porta_B_Leitura|Mux5~2_combout\ & (\inst12|dff_block[2].dff_inst|q~q\ & ((\r_addr_b[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst12|dff_block[2].dff_inst|q~q\,
	datab => \Porta_B_Leitura|Mux5~2_combout\,
	datac => \inst16|dff_block[2].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux5~3_combout\);

-- Location: LCCOMB_X27_Y30_N2
\Porta_B_Leitura|Mux5~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux5~6_combout\ = (\r_addr_b[1]~input_o\ & (((\r_addr_b[0]~input_o\)))) # (!\r_addr_b[1]~input_o\ & ((\r_addr_b[0]~input_o\ & ((\Porta_B_Leitura|Mux5~3_combout\))) # (!\r_addr_b[0]~input_o\ & (\Porta_B_Leitura|Mux5~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010010100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \Porta_B_Leitura|Mux5~5_combout\,
	datac => \r_addr_b[0]~input_o\,
	datad => \Porta_B_Leitura|Mux5~3_combout\,
	combout => \Porta_B_Leitura|Mux5~6_combout\);

-- Location: FF_X28_Y30_N31
\inst18|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[15]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst18|dff_block[2].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y29_N2
\Porta_B_Leitura|Mux5~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux5~7_combout\ = (\r_addr_b[3]~input_o\ & (((\r_addr_b[2]~input_o\)))) # (!\r_addr_b[3]~input_o\ & ((\r_addr_b[2]~input_o\ & (\8_registrador|dff_block[2].dff_inst|q~q\)) # (!\r_addr_b[2]~input_o\ & 
-- ((\inst6|dff_block[2].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[3]~input_o\,
	datab => \8_registrador|dff_block[2].dff_inst|q~q\,
	datac => \inst6|dff_block[2].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux5~7_combout\);

-- Location: LCCOMB_X28_Y30_N30
\Porta_B_Leitura|Mux5~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux5~8_combout\ = (\r_addr_b[3]~input_o\ & ((\Porta_B_Leitura|Mux5~7_combout\ & ((\inst18|dff_block[2].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux5~7_combout\ & (\inst14|dff_block[2].dff_inst|q~q\)))) # (!\r_addr_b[3]~input_o\ & 
-- (((\Porta_B_Leitura|Mux5~7_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[3]~input_o\,
	datab => \inst14|dff_block[2].dff_inst|q~q\,
	datac => \inst18|dff_block[2].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux5~7_combout\,
	combout => \Porta_B_Leitura|Mux5~8_combout\);

-- Location: FF_X27_Y29_N7
\inst5|dff_block[2].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[2]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[2]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst5|dff_block[2].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y29_N6
\Porta_B_Leitura|Mux5~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux5~0_combout\ = (\r_addr_b[2]~input_o\ & (((\r_addr_b[3]~input_o\)))) # (!\r_addr_b[2]~input_o\ & ((\r_addr_b[3]~input_o\ & (\inst13|dff_block[2].dff_inst|q~q\)) # (!\r_addr_b[3]~input_o\ & ((\inst5|dff_block[2].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst13|dff_block[2].dff_inst|q~q\,
	datab => \r_addr_b[2]~input_o\,
	datac => \inst5|dff_block[2].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux5~0_combout\);

-- Location: LCCOMB_X28_Y30_N20
\Porta_B_Leitura|Mux5~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux5~1_combout\ = (\Porta_B_Leitura|Mux5~0_combout\ & (((\inst17|dff_block[2].dff_inst|q~q\) # (!\r_addr_b[2]~input_o\)))) # (!\Porta_B_Leitura|Mux5~0_combout\ & (\inst9|dff_block[2].dff_inst|q~q\ & ((\r_addr_b[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|dff_block[2].dff_inst|q~q\,
	datab => \Porta_B_Leitura|Mux5~0_combout\,
	datac => \inst17|dff_block[2].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux5~1_combout\);

-- Location: LCCOMB_X28_Y30_N16
\Porta_B_Leitura|Mux5~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux5~9_combout\ = (\Porta_B_Leitura|Mux5~6_combout\ & (((\Porta_B_Leitura|Mux5~8_combout\)) # (!\r_addr_b[1]~input_o\))) # (!\Porta_B_Leitura|Mux5~6_combout\ & (\r_addr_b[1]~input_o\ & ((\Porta_B_Leitura|Mux5~1_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110011010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux5~6_combout\,
	datab => \r_addr_b[1]~input_o\,
	datac => \Porta_B_Leitura|Mux5~8_combout\,
	datad => \Porta_B_Leitura|Mux5~1_combout\,
	combout => \Porta_B_Leitura|Mux5~9_combout\);

-- Location: FF_X27_Y27_N5
\inst7|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[4]~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst7|dff_block[1].dff_inst|q~q\);

-- Location: FF_X28_Y27_N23
\inst8|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[5]~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst8|dff_block[1].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y27_N4
\Porta_B_Leitura|Mux6~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux6~0_combout\ = (\r_addr_b[1]~input_o\ & (\r_addr_b[0]~input_o\)) # (!\r_addr_b[1]~input_o\ & ((\r_addr_b[0]~input_o\ & ((\inst8|dff_block[1].dff_inst|q~q\))) # (!\r_addr_b[0]~input_o\ & (\inst7|dff_block[1].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[1]~input_o\,
	datab => \r_addr_b[0]~input_o\,
	datac => \inst7|dff_block[1].dff_inst|q~q\,
	datad => \inst8|dff_block[1].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux6~0_combout\);

-- Location: LCCOMB_X28_Y27_N24
\Porta_B_Leitura|Mux6~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux6~1_combout\ = (\r_addr_b[1]~input_o\ & ((\Porta_B_Leitura|Mux6~0_combout\ & ((\8_registrador|dff_block[1].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux6~0_combout\ & (\inst9|dff_block[1].dff_inst|q~q\)))) # (!\r_addr_b[1]~input_o\ & 
-- (((\Porta_B_Leitura|Mux6~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst9|dff_block[1].dff_inst|q~q\,
	datab => \r_addr_b[1]~input_o\,
	datac => \8_registrador|dff_block[1].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux6~0_combout\,
	combout => \Porta_B_Leitura|Mux6~1_combout\);

-- Location: LCCOMB_X28_Y30_N18
\Porta_B_Leitura|Mux6~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux6~8_combout\ = (\Porta_B_Leitura|Mux6~7_combout\ & (((\inst18|dff_block[1].dff_inst|q~q\)) # (!\r_addr_b[1]~input_o\))) # (!\Porta_B_Leitura|Mux6~7_combout\ & (\r_addr_b[1]~input_o\ & ((\inst17|dff_block[1].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110011010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux6~7_combout\,
	datab => \r_addr_b[1]~input_o\,
	datac => \inst18|dff_block[1].dff_inst|q~q\,
	datad => \inst17|dff_block[1].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux6~8_combout\);

-- Location: FF_X27_Y28_N23
\inst14|dff_block[1].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[1]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[11]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst14|dff_block[1].dff_inst|q~q\);

-- Location: LCCOMB_X27_Y28_N22
\Porta_B_Leitura|Mux6~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux6~3_combout\ = (\Porta_B_Leitura|Mux6~2_combout\ & (((\inst14|dff_block[1].dff_inst|q~q\)) # (!\r_addr_b[0]~input_o\))) # (!\Porta_B_Leitura|Mux6~2_combout\ & (\r_addr_b[0]~input_o\ & ((\inst12|dff_block[1].dff_inst|q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110011010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux6~2_combout\,
	datab => \r_addr_b[0]~input_o\,
	datac => \inst14|dff_block[1].dff_inst|q~q\,
	datad => \inst12|dff_block[1].dff_inst|q~q\,
	combout => \Porta_B_Leitura|Mux6~3_combout\);

-- Location: LCCOMB_X27_Y28_N6
\Porta_B_Leitura|Mux6~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux6~6_combout\ = (\r_addr_b[2]~input_o\ & (((\r_addr_b[3]~input_o\)))) # (!\r_addr_b[2]~input_o\ & ((\r_addr_b[3]~input_o\ & ((\Porta_B_Leitura|Mux6~3_combout\))) # (!\r_addr_b[3]~input_o\ & (\Porta_B_Leitura|Mux6~5_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux6~5_combout\,
	datab => \Porta_B_Leitura|Mux6~3_combout\,
	datac => \r_addr_b[2]~input_o\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux6~6_combout\);

-- Location: LCCOMB_X27_Y28_N0
\Porta_B_Leitura|Mux6~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux6~9_combout\ = (\r_addr_b[2]~input_o\ & ((\Porta_B_Leitura|Mux6~6_combout\ & ((\Porta_B_Leitura|Mux6~8_combout\))) # (!\Porta_B_Leitura|Mux6~6_combout\ & (\Porta_B_Leitura|Mux6~1_combout\)))) # (!\r_addr_b[2]~input_o\ & 
-- (((\Porta_B_Leitura|Mux6~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux6~1_combout\,
	datab => \Porta_B_Leitura|Mux6~8_combout\,
	datac => \r_addr_b[2]~input_o\,
	datad => \Porta_B_Leitura|Mux6~6_combout\,
	combout => \Porta_B_Leitura|Mux6~9_combout\);

-- Location: FF_X30_Y29_N27
\inst14|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[11]~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst14|dff_block[0].dff_inst|q~q\);

-- Location: FF_X29_Y29_N1
\inst6|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[3]~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst6|dff_block[0].dff_inst|q~q\);

-- Location: LCCOMB_X29_Y29_N0
\Porta_B_Leitura|Mux7~7\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux7~7_combout\ = (\r_addr_b[3]~input_o\ & ((\inst14|dff_block[0].dff_inst|q~q\) # ((\r_addr_b[2]~input_o\)))) # (!\r_addr_b[3]~input_o\ & (((\inst6|dff_block[0].dff_inst|q~q\ & !\r_addr_b[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[3]~input_o\,
	datab => \inst14|dff_block[0].dff_inst|q~q\,
	datac => \inst6|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux7~7_combout\);

-- Location: LCCOMB_X28_Y30_N28
\Porta_B_Leitura|Mux7~8\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux7~8_combout\ = (\Porta_B_Leitura|Mux7~7_combout\ & (((\inst18|dff_block[0].dff_inst|q~q\) # (!\r_addr_b[2]~input_o\)))) # (!\Porta_B_Leitura|Mux7~7_combout\ & (\8_registrador|dff_block[0].dff_inst|q~q\ & ((\r_addr_b[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \8_registrador|dff_block[0].dff_inst|q~q\,
	datab => \Porta_B_Leitura|Mux7~7_combout\,
	datac => \inst18|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux7~8_combout\);

-- Location: FF_X28_Y26_N21
\inst7|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[4]~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst7|dff_block[0].dff_inst|q~q\);

-- Location: FF_X28_Y29_N23
\inst3|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[0]~15_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst3|dff_block[0].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y29_N22
\Porta_B_Leitura|Mux7~4\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux7~4_combout\ = (\r_addr_b[2]~input_o\ & ((\inst7|dff_block[0].dff_inst|q~q\) # ((\r_addr_b[3]~input_o\)))) # (!\r_addr_b[2]~input_o\ & (((\inst3|dff_block[0].dff_inst|q~q\ & !\r_addr_b[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[2]~input_o\,
	datab => \inst7|dff_block[0].dff_inst|q~q\,
	datac => \inst3|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux7~4_combout\);

-- Location: LCCOMB_X29_Y30_N30
\Porta_B_Leitura|Mux7~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux7~5_combout\ = (\r_addr_b[3]~input_o\ & ((\Porta_B_Leitura|Mux7~4_combout\ & ((\inst15|dff_block[0].dff_inst|q~q\))) # (!\Porta_B_Leitura|Mux7~4_combout\ & (\inst11|dff_block[0].dff_inst|q~q\)))) # (!\r_addr_b[3]~input_o\ & 
-- (((\Porta_B_Leitura|Mux7~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst11|dff_block[0].dff_inst|q~q\,
	datab => \r_addr_b[3]~input_o\,
	datac => \inst15|dff_block[0].dff_inst|q~q\,
	datad => \Porta_B_Leitura|Mux7~4_combout\,
	combout => \Porta_B_Leitura|Mux7~5_combout\);

-- Location: LCCOMB_X28_Y27_N2
\Porta_B_Leitura|Mux7~6\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux7~6_combout\ = (\r_addr_b[1]~input_o\ & ((\Porta_B_Leitura|Mux7~3_combout\) # ((\r_addr_b[0]~input_o\)))) # (!\r_addr_b[1]~input_o\ & (((\Porta_B_Leitura|Mux7~5_combout\ & !\r_addr_b[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Porta_B_Leitura|Mux7~3_combout\,
	datab => \Porta_B_Leitura|Mux7~5_combout\,
	datac => \r_addr_b[1]~input_o\,
	datad => \r_addr_b[0]~input_o\,
	combout => \Porta_B_Leitura|Mux7~6_combout\);

-- Location: FF_X28_Y29_N29
\inst4|dff_block[0].dff_inst|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \w_data[0]~input_o\,
	clrn => \rst_n~inputclkctrl_outclk\,
	sload => VCC,
	ena => \inst|we_dec[1]~14_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst4|dff_block[0].dff_inst|q~q\);

-- Location: LCCOMB_X28_Y29_N28
\Porta_B_Leitura|Mux7~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux7~0_combout\ = (\r_addr_b[2]~input_o\ & (((\r_addr_b[3]~input_o\)))) # (!\r_addr_b[2]~input_o\ & ((\r_addr_b[3]~input_o\ & (\inst12|dff_block[0].dff_inst|q~q\)) # (!\r_addr_b[3]~input_o\ & ((\inst4|dff_block[0].dff_inst|q~q\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[2]~input_o\,
	datab => \inst12|dff_block[0].dff_inst|q~q\,
	datac => \inst4|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_b[3]~input_o\,
	combout => \Porta_B_Leitura|Mux7~0_combout\);

-- Location: LCCOMB_X29_Y30_N20
\Porta_B_Leitura|Mux7~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux7~1_combout\ = (\Porta_B_Leitura|Mux7~0_combout\ & (((\inst16|dff_block[0].dff_inst|q~q\) # (!\r_addr_b[2]~input_o\)))) # (!\Porta_B_Leitura|Mux7~0_combout\ & (\inst8|dff_block[0].dff_inst|q~q\ & ((\r_addr_b[2]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst8|dff_block[0].dff_inst|q~q\,
	datab => \Porta_B_Leitura|Mux7~0_combout\,
	datac => \inst16|dff_block[0].dff_inst|q~q\,
	datad => \r_addr_b[2]~input_o\,
	combout => \Porta_B_Leitura|Mux7~1_combout\);

-- Location: LCCOMB_X28_Y27_N28
\Porta_B_Leitura|Mux7~9\ : cycloneiv_lcell_comb
-- Equation(s):
-- \Porta_B_Leitura|Mux7~9_combout\ = (\r_addr_b[0]~input_o\ & ((\Porta_B_Leitura|Mux7~6_combout\ & (\Porta_B_Leitura|Mux7~8_combout\)) # (!\Porta_B_Leitura|Mux7~6_combout\ & ((\Porta_B_Leitura|Mux7~1_combout\))))) # (!\r_addr_b[0]~input_o\ & 
-- (((\Porta_B_Leitura|Mux7~6_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101101011010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \r_addr_b[0]~input_o\,
	datab => \Porta_B_Leitura|Mux7~8_combout\,
	datac => \Porta_B_Leitura|Mux7~6_combout\,
	datad => \Porta_B_Leitura|Mux7~1_combout\,
	combout => \Porta_B_Leitura|Mux7~9_combout\);

ww_r_data_a(7) <= \r_data_a[7]~output_o\;

ww_r_data_a(6) <= \r_data_a[6]~output_o\;

ww_r_data_a(5) <= \r_data_a[5]~output_o\;

ww_r_data_a(4) <= \r_data_a[4]~output_o\;

ww_r_data_a(3) <= \r_data_a[3]~output_o\;

ww_r_data_a(2) <= \r_data_a[2]~output_o\;

ww_r_data_a(1) <= \r_data_a[1]~output_o\;

ww_r_data_a(0) <= \r_data_a[0]~output_o\;

ww_we_dec(15) <= \we_dec[15]~output_o\;

ww_we_dec(14) <= \we_dec[14]~output_o\;

ww_we_dec(13) <= \we_dec[13]~output_o\;

ww_we_dec(12) <= \we_dec[12]~output_o\;

ww_we_dec(11) <= \we_dec[11]~output_o\;

ww_we_dec(10) <= \we_dec[10]~output_o\;

ww_we_dec(9) <= \we_dec[9]~output_o\;

ww_we_dec(8) <= \we_dec[8]~output_o\;

ww_we_dec(7) <= \we_dec[7]~output_o\;

ww_we_dec(6) <= \we_dec[6]~output_o\;

ww_we_dec(5) <= \we_dec[5]~output_o\;

ww_we_dec(4) <= \we_dec[4]~output_o\;

ww_we_dec(3) <= \we_dec[3]~output_o\;

ww_we_dec(2) <= \we_dec[2]~output_o\;

ww_we_dec(1) <= \we_dec[1]~output_o\;

ww_we_dec(0) <= \we_dec[0]~output_o\;

ww_r_data_b(7) <= \r_data_b[7]~output_o\;

ww_r_data_b(6) <= \r_data_b[6]~output_o\;

ww_r_data_b(5) <= \r_data_b[5]~output_o\;

ww_r_data_b(4) <= \r_data_b[4]~output_o\;

ww_r_data_b(3) <= \r_data_b[3]~output_o\;

ww_r_data_b(2) <= \r_data_b[2]~output_o\;

ww_r_data_b(1) <= \r_data_b[1]~output_o\;

ww_r_data_b(0) <= \r_data_b[0]~output_o\;
END structure;


