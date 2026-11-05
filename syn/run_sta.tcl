# ============================================================================
# OpenSTA - Analise Estatica de Tempo na netlist integrada SKY130 HD
# Uso: LIB=<lib> NETLIST=<net> SDC=<sdc> sta -no_splash -exit syn/run_sta.tcl
# ============================================================================
if {[info exists ::env(LIB)]} {
    set LIB $::env(LIB)
} else {
    set LIB /home/carlos/sky130repo/openpdk-git/sources/sky130_fd_sc_hd/timing/sky130_fd_sc_hd__tt_025C_1v80.lib
}
if {[info exists ::env(NETLIST)]} { set NET $::env(NETLIST) } else { set NET syn/netlist_spacefibre_node_sky130_rfo.v }
if {[info exists ::env(SDC)]}     { set SDC $::env(SDC)     } else { set SDC syn/spacefibre_node_top_100mhz.sdc }

read_liberty $LIB
read_verilog $NET
link_design spacefibre_node_top
read_sdc $SDC

puts "\n==================== CHECK_SETUP ($SDC) ===================="
check_setup -verbose -unconstrained_endpoints -multiple_clock -no_clock -loops -generated_clocks

puts "\n==================== SETUP (max) ===================="
report_checks -path_delay max -group_path_count 3 -fields {slew cap fanout} -digits 3
puts "\n==================== HOLD (min) ====================="
report_checks -path_delay min -group_path_count 3 -fields {slew cap fanout} -digits 3
puts "\n==================== RECOVERY/REMOVAL ===================="
report_checks -path_delay max -to [all_registers -async_pins] -digits 3
puts "\n==================== VIOLACOES ===================="
report_check_types -max_slew -max_capacitance -max_fanout -violators
report_tns
report_wns
puts "\n==================== RESUMO ===================="
report_worst_slack -max
report_worst_slack -min
puts "\n==================== PERIODO MINIMO ===================="
report_clock_min_period
