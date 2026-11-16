# ==============================================================================
# Projeto: SoC Transceptor SpaceFibre Brasileiro (RTL Unificado ECSS-E-ST-50-11C)
# Alvo   : SkyWater SKY130 HD (100 MHz = 1.0 Gbps / 125 MHz = 1.25 Gbps)
#
#   make sim        -> testbench de sistema (2 nos) em RTL, com VCD
#   make regress    -> vetores ECSS + TB da Lane + sistema (5 seeds + quadro 256 B)
#   make synth      -> Yosys -> syn/netlist_spacefibre_node_sky130.v
#   make repair     -> buffers de saida + arvores de fanout (max 10)
#   make sta        -> OpenSTA em 100 MHz (10.0 ns) e 125 MHz (8.0 ns)
#   make gls        -> simulacao gate-level da netlist SKY130 reparada
#   make all        -> regress + synth + repair + sta + gls
# ==============================================================================

SIM      ?= $(shell command -v iverilog 2>/dev/null || echo /tools/iverilog/bin/iverilog)
RUNTCL   ?= $(shell command -v vvp      2>/dev/null || echo /tools/iverilog/bin/vvp)
YOSYS    ?= $(shell command -v yosys    2>/dev/null || echo /usr/local/bin/yosys)
STA      ?= $(shell command -v sta      2>/dev/null || echo /tools/openroad/bin/sta)
WAVE_VIEW?= gtkwave
FLAGS    ?= -g2012
SEEDS    ?= 1 7 42 1234 99991

HOST_LIB := /home/carlos/sky130repo/openpdk-git/sources/sky130_fd_sc_hd/timing/sky130_fd_sc_hd__tt_025C_1v80.lib
CONT_LIB := /foss/pdks/ciel/sky130/versions/1689ac3f2dc763876eaf967227c7dfe831b031ae/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
LIB      ?= $(shell if [ -f "$(HOST_LIB)" ]; then echo "$(HOST_LIB)"; else echo "$(CONT_LIB)"; fi)
LIB_DU   := build/sky130_fd_sc_hd__tt_025C_1v80_dontuse.lib

RTL      := $(shell cat files.f)
LANE_RTL := rtl/lane/spacefibre_lane_top.v rtl/lane/fsm_layer.sv rtl/lane/word_aligner.v \
            rtl/lane/rx_word_sync.v rtl/lane/elastic_buffer.v rtl/lane/encoder_8b10b.v \
            rtl/lane/encoder_5b6b.v rtl/lane/encoder_3b4b.v rtl/lane/decoder_8b10b.v \
            rtl/lane/decoder_6b5b.v rtl/lane/decoder_4b3b.v rtl/lane/llcw_processor.v \
            rtl/lane/rxerr_counter.v
VEC_RTL  := rtl/lane/encoder_8b10b.v rtl/lane/encoder_5b6b.v rtl/lane/encoder_3b4b.v \
            rtl/lane/decoder_8b10b.v rtl/lane/decoder_6b5b.v rtl/lane/decoder_4b3b.v \
            rtl/lane/llcw_processor.v rtl/datalink/sf_scrambler.v \
            rtl/datalink/sf_crc16.v rtl/datalink/sf_crc8.v

NETLIST   := syn/netlist_spacefibre_node_sky130.v
NETLIST_R := syn/netlist_spacefibre_node_sky130_rfo.v

all: regress synth repair sta gls

build:
	@mkdir -p build syn

# ------------------------------------------------------------------ simulacao
build/sim_node_top.vvp: $(RTL) tb/tb_spacefibre_system.v | build
	$(SIM) $(FLAGS) -o $@ $(RTL) tb/tb_spacefibre_system.v

build/sim_node_256b.vvp: $(RTL) tb/tb_spacefibre_system.v | build
	$(SIM) $(FLAGS) -DPARAM_MAX_FRAME_BYTES=256 -o $@ $(RTL) tb/tb_spacefibre_system.v

sim: build/sim_node_top.vvp
	cd build && $(RUNTCL) sim_node_top.vvp +seed=1
	@echo "Formas de onda: build/wave_system.vcd"

wave: sim
	$(WAVE_VIEW) build/wave_system.vcd &

regress: build/sim_node_top.vvp build/sim_node_256b.vvp
	$(SIM) $(FLAGS) -o build/ecss_vec.vvp $(VEC_RTL) tb/tb_ecss_vectors.v && $(RUNTCL) build/ecss_vec.vvp | grep RESULTADO
	$(SIM) $(FLAGS) -o build/lane.vvp $(LANE_RTL) tb/tb_spacefibre_lane_top.v && (cd build && $(RUNTCL) lane.vvp +nodump | grep RESULTADO)
	@for s in $(SEEDS); do printf "16B  seed=%-6s " $$s; (cd build && $(RUNTCL) sim_node_top.vvp +nodump +seed=$$s | grep RESULTADO); done
	@printf "256B nominal     "; (cd build && $(RUNTCL) sim_node_256b.vvp +nodump +seed=1 +clk125 | grep RESULTADO)

# ------------------------------------------------------------- sintese e STA
$(LIB_DU): | build
	python3 scripts/mark_dont_use.py $(LIB) $@

synth: $(LIB_DU)
	LIB=$(abspath $(LIB_DU)) $(YOSYS) -l syn/log_sintese.log -c syn/sintese_sky130.tcl

repair:
	python3 scripts/repair_fanout.py $(NETLIST) $(NETLIST_R) --buffer-outputs

sta: $(LIB_DU)
	@echo "=== OpenSTA @ 100 MHz (10.0 ns - 1.0 Gbps) ==="
	LIB=$(abspath $(LIB_DU)) NETLIST=$(NETLIST_R) SDC=syn/spacefibre_node_top_100mhz.sdc $(STA) -no_splash -exit syn/run_sta.tcl | tee syn/relatorio_sta_100mhz.log | grep -E "^worst|^tns|^wns|period_min"
	@echo "=== OpenSTA @ 125 MHz (8.0 ns  - 1.25 Gbps) ==="
	LIB=$(abspath $(LIB_DU)) NETLIST=$(NETLIST_R) SDC=syn/spacefibre_node_top_125mhz.sdc $(STA) -no_splash -exit syn/run_sta.tcl | tee syn/relatorio_sta_125mhz.log | grep -E "^worst|^tns|^wns|period_min"

build/cells_tt.v: $(LIB_DU)
	$(YOSYS) -q -p "read_liberty -ignore_miss_func $(abspath $(LIB_DU)); write_verilog -noattr $@"

gls: build/cells_tt.v
	$(SIM) $(FLAGS) -DGLS -DFUNCTIONAL -DUNIT_DELAY="#1" -o build/gls.vvp build/cells_tt.v $(NETLIST_R) tb/tb_spacefibre_system.v
	cd build && $(RUNTCL) gls.vvp +nodump +seed=1 | tee ../syn/relatorio_gls_sky130.log | grep -E "OK|ERRO|RESULTADO"

clean:
	rm -rf build

.PHONY: all sim wave regress synth repair sta gls clean
