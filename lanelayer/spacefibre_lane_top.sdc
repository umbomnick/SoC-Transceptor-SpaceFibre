# ============================================================================
# Synopsys Design Constraints (SDC) - SpaceFibre Lane Top Level
# Target Frequency: 100 MHz (Period: 10.0 ns)
# PDK: SkyWater SKY130 HD
# ============================================================================

# 1. Definir o clock principal (Período de 10.0 ns = 100 MHz)
create_clock -name clk -period 10.0 [get_ports clk]

# 2. Incerteza do clock (Jitter/Skew estimado para síntese e STA)
set_clock_uncertainty 0.25 [get_clocks clk]

# 3. Delays de entrada e saída (em relação à borda de subida do clk)
set_input_delay -clock clk 2.0 [all_inputs -no_clocks]
set_output_delay -clock clk 2.0 [all_outputs]

# 4. Transição das entradas e carga estimada nas saídas
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_1 [all_inputs -no_clocks]
set_load 0.035 [all_outputs]
