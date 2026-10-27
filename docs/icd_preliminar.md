# Interface Control Document (ICD) Preliminar

## 1. Introdução
Este documento estabelece o contrato imutável de sinais entre a **Macro Digital (RTL)** e a **Macro Analógica (PHY SerDes)** do transceptor SpaceFibre.

## 2. Tabela de Pinout e Sinais de Fronteira

| Nome do Sinal | Direção (Origem → Destino) | Largura (Bits) | Frequência | Descrição Funcional |
| :--- | :--- | :---: | :---: | :--- |
| `clk_ref` | Externo → Digital e Analógico | 1 | 125 MHz | Clock de referência principal do sistema. |
| `clk_tx_fast` | Analógico (PLL) → Digital | 1 | 1.25 GHz | Clock de alta velocidade para serialização. |
| `pll_locked` | Analógico (PLL) → Digital | 1 | DC | Sinalizador de estabilidade do clock analógico. |
| `tx_10b_symbol` | Digital (Lane) → Analógico (CML) | 10 | 125 MHz | Barramento paralelo de símbolos codificados 8b/10b. |
| `rx_10b_symbol` | Analógico (CDR) → Digital | 10 | 125 MHz | Barramento paralelo de símbolos recuperados. |
| `rst_n` | Digital → Analógico | 1 | DC | Reset assíncrono global ativo em nível baixo. |
| `loss_of_signal` | Analógico (Receptor) → Digital | 1 | DC | Indicador de perda de portadora no meio físico. |