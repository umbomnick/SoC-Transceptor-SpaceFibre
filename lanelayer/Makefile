# ==============================================================================
# Projeto: SoC Transceptor SpaceFibre (Lane Layer)
# Arquivo: Makefile
# Padrao : ECSS-E-ST-50-11C
# Descricao: Automaçao de Compilaçao e Simulaçao RTL com Icarus Verilog e GTKWave
# ==============================================================================

# Compilador e Sinalizadores
SIM      ?= iverilog
FLAGS    ?= -g2012
RUNTCL   ?= vvp
WAVE_VIEW?= gtkwave

# Nome da Saida do Executavel e Waveform
TARGET   ?= sim_lane_top.vvp
VCD_FILE ?= wave_lane_top.vcd

# Lista de Arquivos Fontes RTL (Submódulos e Top-Level)
# Nota: Funciona tanto com os nomes padrao quanto com os arquivos -v3
SRCS     ?= spacefibre_lane_top.v \
            fsm_layer.sv \
            word_aligner.v \
            elastic_buffer.v \
            encoder_8b10b.v \
            encoder_5b6b.v \
            encoder_3b4b.v \
            decoder_8b10b.v \
            decoder_6b5b.v \
            decoder_4b3b.v \
            llcw_processor.v \
            rxerr_counter.v \
            tb_spacefibre_lane_top.v

# Regra Padrao
all: sim

# Compilacao RTL com Icarus Verilog
compile: $(SRCS)
	@echo "=================================================================="
	@echo " Compilando Lane Layer RTL com Icarus Verilog..."
	@echo "=================================================================="
	$(SIM) $(FLAGS) -o $(TARGET) $(SRCS)

# Execucao da Simulaçao Autoverificavel
sim: compile
	@echo "=================================================================="
	@echo " Executando Simulaçao com VVP..."
	@echo "=================================================================="
	$(RUNTCL) $(TARGET)

# Visualizaçao das Formas de Onda no GTKWave
wave: sim
	@if [ -f $(VCD_FILE) ]; then \
		echo "Abrindo GTKWave com $(VCD_FILE)..."; \
		$(WAVE_VIEW) $(VCD_FILE) & \
	else \
		echo "Erro: Arquivo $(VCD_FILE) nao encontrado. Execute 'make sim' primeiro."; \
	fi

# Limpeza de Arquivos Gerados
clean:
	@echo "Limpando arquivos temporarios e VCDs..."
	rm -f *.vvp *.vcd *.log

.PHONY: all compile sim wave clean
