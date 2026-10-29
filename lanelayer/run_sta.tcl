# ============================================================================
# Script OpenSTA - Análise Estática de Temporização (STA)
# Projeto: SpaceFibre Lane Layer Top-Level
# PDK: SkyWater SKY130 HD
# ============================================================================

# 1. Carregar a biblioteca Liberty do SKY130 HD (Caminho absoluto verificado)
read_liberty /foss/pdks/ciel/sky130/versions/1689ac3f2dc763876eaf967227c7dfe831b031ae/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 2. Carregar a netlist sintetizada
read_verilog netlist_spacefibre_sky130.v

# 3. Mapear o módulo top-level
link_design lane_layer_top

# 4. Carregar o arquivo de restrições SDC
read_sdc spacefibre_lane_top.sdc

# 5. Executar relatórios de temporização (Setup e Hold)
puts "\n===================================================================="
puts "                RELATÓRIO DE SETUP (MAX DELAY)                     "
puts "===================================================================="
report_checks -path_delay max -fields {slew cap input net fanout} -digits 3

puts "\n===================================================================="
puts "                RELATÓRIO DE HOLD (MIN DELAY)                      "
puts "===================================================================="
report_checks -path_delay min -fields {slew cap input net fanout} -digits 3

# 6. Resumo do Pior Slack do Circuito
puts "\n===================================================================="
puts "                    RESUMO DOS PIORES SLACKS                        "
puts "===================================================================="
report_worst_slack -max
report_worst_slack -min

exit
