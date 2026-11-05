# ============================================================================
# Sintese Yosys - RTL unificado ECSS-E-ST-50-11C (Network + Data Link + Lane)
# Alvo: SkyWater SKY130 HD (tt_025C_1v80)
# ============================================================================

if {[info exists ::env(LIB)]} {
    set LIB $::env(LIB)
} else {
    set LIB /home/carlos/sky130repo/openpdk-git/sources/sky130_fd_sc_hd/timing/sky130_fd_sc_hd__tt_025C_1v80.lib
}

# Periodo-alvo para o ABC (ps): 8000 ps (125 MHz) garante folga em 100 e 125 MHz
if {[info exists ::env(ABC_DELAY_PS)]} { set DPS $::env(ABC_DELAY_PS) } else { set DPS 8000 }

set files [list \
    rtl/top/spacefibre_node_top.v \
    rtl/network/sf_network.v \
    rtl/datalink/sf_datalink.v \
    rtl/datalink/sf_fifo.v \
    rtl/datalink/sf_scrambler.v \
    rtl/datalink/sf_crc16.v \
    rtl/datalink/sf_crc8.v \
    rtl/lane/spacefibre_lane_top.v \
    rtl/lane/fsm_layer.sv \
    rtl/lane/word_aligner.v \
    rtl/lane/rx_word_sync.v \
    rtl/lane/elastic_buffer.v \
    rtl/lane/encoder_8b10b.v \
    rtl/lane/encoder_5b6b.v \
    rtl/lane/encoder_3b4b.v \
    rtl/lane/decoder_8b10b.v \
    rtl/lane/decoder_6b5b.v \
    rtl/lane/decoder_4b3b.v \
    rtl/lane/llcw_processor.v \
    rtl/lane/rxerr_counter.v ]

file mkdir build syn
foreach f $files { yosys read_verilog -sv $f }

yosys hierarchy -check -top spacefibre_node_top

# Sintese generica hierarquica para relatorio por camada, seguida de flatten
yosys synth -top spacefibre_node_top
yosys tee -o build/rpt_hier_generic.txt stat
yosys flatten
yosys opt -full

# Mapeamento de Flip-Flops e logica combinacional em SKY130 HD
yosys dfflibmap -liberty $LIB
yosys abc -D $DPS -liberty $LIB

yosys setundef -zero
yosys hilomap -singleton -hicell sky130_fd_sc_hd__conb_1 HI -locell sky130_fd_sc_hd__conb_1 LO
yosys splitnets
yosys opt_clean -purge

yosys check
yosys tee -o build/rpt_area.txt stat -liberty $LIB

yosys write_verilog -noattr -noexpr -nohex -nodec syn/netlist_spacefibre_node_sky130.v
