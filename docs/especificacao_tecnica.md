\# Especificação Técnica Adaptada - SoC Transceptor SpaceFibre



\## 1. Visão Geral e Normas

\- \*\*Norma de Referência:\*\* ECSS-E-ST-50-11C (SpaceFibre) - com escopo reduzido para foco na camada física/digital (Lane Layer).

\- \*\*Tecnologia de Processo:\*\* SkyWater SKY130 (130 nm).

\- \*\*Taxa de Transmissão Alvo:\*\* 1.25 Gbps.



\## 2. Escopo dos Módulos

\- \*\*Escopo Digital (RTL):\*\*

&#x20; - Codificador e Decodificador 8b/10b (suporte a 256 símbolos e K-characters).

&#x20; - Máquina de Estados (FSM) de inicialização e alinhamento de palavras (\*Word Aligner\*).

&#x20; - Mecanismos básicos de FDIR (\*Fault Detection, Isolation and Recovery\*).

\- \*\*Escopo Analógico (PHY):\*\*

&#x20; - Driver CML e PLL no Transmissor (TX).

&#x20; - Equalizador CTLE e CDR no Receptor (RX).

