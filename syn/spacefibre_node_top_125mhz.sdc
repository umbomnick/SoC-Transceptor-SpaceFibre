# ============================================================================
# SDC - SpaceFibre Node Top (Network + Data Link + Lane) - ECSS-E-ST-50-11C
# Alvo estendido: 125 MHz (8.0 ns -> 1.25 Gbps na PHY SerDes 10b)
# ============================================================================
create_clock -name clk -period 8.0 [get_ports clk]
set_clock_uncertainty 0.25 [get_clocks clk]
set_clock_transition 0.15 [get_clocks clk]

# Orcamento de 20% do periodo (1.6 ns) para interface externa
set_input_delay  -clock clk 1.6 [delete_from_list [all_inputs] [get_ports {clk rst_n}]]
set_output_delay -clock clk 1.6 [all_outputs]

# rst_n e assincrono (sincronizado internamente por 2 FFs)
set_false_path -from [get_ports rst_n]

set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 -pin X [delete_from_list [all_inputs] [get_ports clk]]
set_load 0.035 [all_outputs]
