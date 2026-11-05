# SoC Transceptor SpaceFibre Brasileiro (ECSS-E-ST-50-11C — SKY130)

Implementacao RTL unificada em Verilog/SystemVerilog sintetizavel das camadas digitais do protocolo **SpaceFibre** conforme a norma europeia **ECSS-E-ST-50-11C** (*SpaceFibre — Very high-speed serial link*, 15 de maio de 2019), voltada a fabricacao ASIC no PDK aberto **SkyWater SKY130 (`sky130_fd_sc_hd`, 130 nm)**.

## Arquitetura e Separacao Normativa de Camadas

Em estrita conformidade com a secao **4.2** e as clausulas **5.5**, **5.7** e **5.8** da ECSS-E-ST-50-11C, o *Scrambling* (`5.7.6.2`) e o *Framing* (`5.7.6.1`, `5.3.8`) residem exclusivamente na **Data Link Layer** (`rtl/datalink/`), enquanto a **Lane Layer** (`rtl/lane/`) opera sobre palavras alinhadas de 32 bits (4 simbolos 8B/10B):

```text
rtl/
├── top/
│   └── spacefibre_node_top.v   # Topo integrado (Network + Data Link + Lane)
├── network/
│   └── sf_network.v            # Network Layer (Path 0x00/0x01 + Logical 0x20..0xFE, Tabela 5-35)
├── datalink/
│   ├── sf_datalink.v           # Data Link Layer (1 VC No-Retry, SDF/EDF/SIF/FCT, INIT3, VCB 32b)
│   ├── sf_scrambler.v          # Scrambler/Descrambler Galois X^16+X^5+X^4+X^3+1 + PRBS Idle (5.7.6.2)
│   ├── sf_crc16.v              # CRC-16 ITU LSB-first refletido (X^16+X^12+X^5+1, Fig. 5-45)
│   ├── sf_crc8.v               # CRC-8 LSB-first refletido (X^8+X^2+X+1, Fig. 5-47)
│   └── sf_fifo.v               # FIFO sincrona show-ahead parametrizavel
└── lane/
    ├── spacefibre_lane_top.v   # Topo da Lane Layer (interface de palavras de 32 bits)
    ├── fsm_layer.sv            # Maquina LISM completa de 10 estados (Fig. 5-29 + Polaridade RX)
    ├── llcw_processor.v        # Gerador/decodificador LLCW normativo (Tabela 5-3: D14.6 / D17.1)
    ├── word_aligner.v          # Alinhador de bit sobre janela de 20 bits (virgulas K28.5 / K28.7)
    ├── rx_word_sync.v          # Sincronizador de palavras de 32 bits (Fig. 5-30 + regra 5.5.7l)
    ├── elastic_buffer.v        # Buffer elastico em nivel de palavra de 32 bits (SKIP atomico)
    ├── rxerr_counter.v         # Monitor de qualidade de enlace (leaky-bucket, decaimento /16384)
    ├── encoder_8b10b.v         # Codificador 8B/10B (com encoder_5b6b.v e encoder_3b4b.v)
    └── decoder_8b10b.v         # Decodificador 8B/10B (rejeicao Tabela 5-11 + substituicao K0.0)
```

### Perfil ECSS-E-ST-50-11C Implementado
- **Formato de Fio 100% Normativo**:
  - **8B/10B (`5.5.7`, Tabela `5-11`)**: reset de disparidade (`RD = -1`) quando TX desabilitado (`5.3.2g`), rejeicao dos codigos K nao utilizados pelo SpaceFibre (`K28.1`, `K28.4`, `K28.6`, `K23.7`) e substituicao por `K0.0` em erro (`5.5.7j/k`).
  - **Sincronizacao de Palavra (`5.5.5`, Fig. `5-30`)**: FSM `LostSync` / `CheckSync` / `Ready` com propagacao de `RXERR` na palavra atual e na anterior em violacao de disparidade (`5.5.7l`).
  - **LISM de 10 Estados (`5.5.2`, Fig. `5-29`, Tabela `5-3`)**: `ClearLine` de `2 us` (`200` ciclos @ 100 MHz), handshakes `INIT1`/`INIT2` de `1023` palavras, deteccao automatica de inversao diferencial `RXp/RXn` (`~INIT1 -> iINIT1` / `~INIT2 -> iINIT2` -> `InvertRxPolarity`), `Abort` de `32` palavras `LOST_SIGNAL` e troca de capacidades em `INIT3`.
  - **Enquadramento e Controle de Fluxo (`5.3.5`..`5.3.8`, `5.7.3`..`5.7.6`)**: `SDF` (`K28.7, D16.2, VC, 00`), `EDF` (`K28.0, SEQ_NUM, CRC16`), `SIF` (`K28.7, D4.2, SEQ_NUM, CRC8`) + palavras PRBS continuas, `FCT` (`K28.3, Mult/VC, SEQ_NUM, CRC8`) contabilizado exatamente em palavras do VCB, e marcadores in-band `EOP` (`K29.7`), `EEP` (`K30.7`) e `Fill` (`K27.7`).
  - **Network Layer (`5.8.3`, Tabela `5-35`)**: *Path Addressing* (`0x00` Local, `0x01` Link) com *header deletion* e *Logical Addressing* (`0x20..0xFE`) com preservacao de cabecalho e tabela de rotas configuravel (`0xFF` reservado/descartado).
- **Tailoring de Area para ASIC SKY130 sem Macros SRAM**:
  - Perfil **1 Virtual Channel (`VC0`)** e **No-Retry** (sem *Retry Buffer*; quadros corrompidos sofrem *rollback* especulativo no VCB e emitem `EEP` sem vazamento de creditos `FCT`).
  - Padrao `MAX_FRAME_BYTES = 16` (4 palavras/quadro, `RX_FRAMES = 4`), parametrizavel ate o nominal ECSS de **`MAX_FRAME_BYTES = 256`** (64 palavras/quadro, validado em regressao).

## Parametros Principais (`spacefibre_node_top`)

| Parametro | Padrao | Descricao |
|---|---:|---|
| `MAX_FRAME_BYTES` | `16` | Tamanho maximo do payload de um Data Frame em bytes (`16` compactado FF; `256` nominal ECSS) |
| `RX_FRAMES` | `4` | Profundidade do Virtual Channel Buffer receptor em quadros maximos |
| `IDLE_PRBS_WORDS` | `8` | Palavras PRBS inseridas apos `SIF` em cada Idle Frame (`0..64`, ECSS `5.3.8.3`) |
| `N_ROUTES` | `4` | Entradas da tabela estatica de roteamento logico na Network Layer |
| `TIMER_CLEAR_LIMIT` | `200` | Duracao de `ClearLine` em ciclos (`200` ciclos = `2.0 us` @ 100 MHz) |
| `HANDSHAKE_WORDS` | `1023` | Contagem normativa de palavras validas `INIT1`/`INIT2` para subida do link |
| `SKIP_INTERVAL` | `5000` | Intervalo maximo entre insercoes periodicas de `SKIP` (ECSS `5.5.3.2`) |

## Fluxo de Verificacao, Sintese SKY130, OpenSTA e GLS

Requisitos no sistema: **Icarus Verilog** (`iverilog`/`vvp`), **Yosys**, **OpenSTA** (`sta`), **Python 3** e a biblioteca Liberty **SkyWater SKY130 HD** (`sky130_fd_sc_hd__tt_025C_1v80.lib`).

```bash
make sim       # Simulacao RTL de sistema (2 nos completos, cenarios C1..C9) com VCD
make regress   # Vetores aureos ECSS + TB da Lane + 5 seeds (16 B) + nominal ECSS (256 B @ 125 MHz)
make synth     # Sintese logica no Yosys para sky130_fd_sc_hd
make repair    # Insercao de buffers de saida e arvores de fanout (max_fanout = 10)
make sta       # Analise Estatica de Tempo (OpenSTA) em 100 MHz (10 ns) e 125 MHz (8 ns)
make gls       # Simulacao Gate-Level (GLS) da netlist SKY130 reparada
make all       # Executa regress + synth + repair + sta + gls
```

## Resultados em SkyWater SKY130 (`sky130_fd_sc_hd__tt_025C_1v80`)

| Metrica | Pos-Sintese (`netlist`) | Pos-Reparo de Fanout (`netlist_rfo`) |
|---|---:|---:|
| Celulas padrao | `6 653` | `7 459` |
| Flip-Flops (`dfrtp_1` + `dfstp_1` + `edfxtp_1`) | `1 711` | `1 711` |
| Area total do no (`spacefibre_node_top`) | `79 588.83 um^2` (`0.080 mm^2`) | `85 294.30 um^2` (`0.085 mm^2`) |
| Parcela sequencial | `47 765.81 um^2` (`60.02%`) | `47 765.81 um^2` (`56.00%`) |

### Fechamento de Tempo (OpenSTA — `tt_025C_1v80`, incerteza `250 ps`, carga `35 fF`)

| Ponto de Operacao | Taxa de Linha Serial | WNS Setup | WNS Hold | TNS | Violacoes DRC (`slew`/`cap`/`fanout`) | `f_max` (`period_min`) |
|---|---|---:|---:|---:|---:|---:|
| **100 MHz (`10.0 ns`)** | **1.00 Gbps** | `+3.60 ns` | `+0.11 ns` | `0.00 ns` | `0` | **181.54 MHz** (`5.51 ns`) |
| **125 MHz (`8.0 ns`)** | **1.25 Gbps** | `+2.40 ns` | `+0.11 ns` | `0.00 ns` | `0` | **181.54 MHz** (`5.51 ns`) |
