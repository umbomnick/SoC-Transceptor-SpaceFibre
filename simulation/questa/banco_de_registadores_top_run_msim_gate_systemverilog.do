transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

if ![file isdirectory vhdl_libs] {
	file mkdir vhdl_libs
}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog  -work altera_mf_ver {c:/altera_lite/25.1std/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog  -work altera_ver {c:/altera_lite/25.1std/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog  -work lpm_ver {c:/altera_lite/25.1std/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog  -work sgate_ver {c:/altera_lite/25.1std/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/cycloneiv_hssi_ver
vmap cycloneiv_hssi_ver ./verilog_libs/cycloneiv_hssi_ver
vlog  -work cycloneiv_hssi_ver {c:/altera_lite/25.1std/quartus/eda/sim_lib/cycloneiv_hssi_atoms.v}

vlib verilog_libs/cycloneiv_pcie_hip_ver
vmap cycloneiv_pcie_hip_ver ./verilog_libs/cycloneiv_pcie_hip_ver
vlog  -work cycloneiv_pcie_hip_ver {c:/altera_lite/25.1std/quartus/eda/sim_lib/cycloneiv_pcie_hip_atoms.v}

vlib verilog_libs/cycloneiv_ver
vmap cycloneiv_ver ./verilog_libs/cycloneiv_ver
vlog  -work cycloneiv_ver {c:/altera_lite/25.1std/quartus/eda/sim_lib/cycloneiv_atoms.v}

if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -sv -work work +incdir+. {banco_de_registadores_top.svo}

