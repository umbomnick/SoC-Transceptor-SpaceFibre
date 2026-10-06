transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Manu/Downloads/SpaceFibre-novo {C:/Users/Manu/Downloads/SpaceFibre-novo/register_8bit.sv}
vlog -sv -work work +incdir+C:/Users/Manu/Downloads/SpaceFibre-novo {C:/Users/Manu/Downloads/SpaceFibre-novo/mux_16to1_8bit.sv}
vlog -sv -work work +incdir+C:/Users/Manu/Downloads/SpaceFibre-novo {C:/Users/Manu/Downloads/SpaceFibre-novo/decoder_4_to_16.sv}
vlog -sv -work work +incdir+C:/Users/Manu/Downloads/SpaceFibre-novo {C:/Users/Manu/Downloads/SpaceFibre-novo/d_flip_flop.sv}

