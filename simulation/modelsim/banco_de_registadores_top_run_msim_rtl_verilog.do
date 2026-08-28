transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/altera/13.0sp1/Banco\ de\ Registradores {C:/altera/13.0sp1/Banco de Registradores/d_flip_flop.sv}

vlog -sv -work work +incdir+C:/altera/13.0sp1/Banco\ de\ Registradores {C:/altera/13.0sp1/Banco de Registradores/tb_leitura_banco.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver -L rtl_work -L work -voptargs="+acc"  tb_leitura_banco

add wave *
view structure
view signals
run -all
