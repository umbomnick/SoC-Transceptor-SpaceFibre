onerror {quit -f}
vlib work
vlog -work work SpaceFibre.vo
vlog -work work SpaceFibre.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.MUX4x1_vlg_vec_tst
vcd file -direction SpaceFibre.msim.vcd
vcd add -internal MUX4x1_vlg_vec_tst/*
vcd add -internal MUX4x1_vlg_vec_tst/i1/*
add wave /*
run -all
