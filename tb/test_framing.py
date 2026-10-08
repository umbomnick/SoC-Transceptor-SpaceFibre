# ============================================================================
# Projeto  : SoC Transceptor SpaceFibre (Data Link Layer - Framing)
# Arquivo  : test_framing.py
# Padrão   : ECSS-E-ST-50-11C (15 May 2019)
# Função   : Testes cocotb do enquadramento (modelo de referência e vetores
#            das Figs. 5-42, 5-43, 5-44 e 5-46)
# Cláusulas: 5.3.5, 5.3.6, 5.3.7, 5.3.8, 5.7.6, 5.7.8, 5.8.5
# ============================================================================

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles, Timer

# Valores equivalentes aos definidos em spacefibre_pkg::link_state_t
LINK_RESET    = 0
LINK_TRAINING = 1
LINK_ACTIVE   = 2

@cocotb.test()
async def test_framing_complete_loopback(dut):
    """
    Testa o enquadramento completo com as novas regras:
    - tx_ready_out dependente apenas do estado
    - Buffer hold de 1 ciclo no RX para alinhar rx_last_out
    - Clocks de 125 MHz (8.0 ns) conforme requisitos de temporização da ICD
    """

    # Geração dos clocks de 125 MHz
    tx_clock = Clock(dut.tx_clk, 8.0, unit="ns")
    rx_clock = Clock(dut.rx_clk, 8.0, unit="ns")
    cocotb.start_soon(tx_clock.start())
    cocotb.start_soon(rx_clock.start())

    # 1. Reset Assíncrono
    dut.tx_rst_n.value = 0
    dut.rx_rst_n.value = 0
    dut.link_state.value = LINK_RESET
    dut.rx_link_up.value = 0
    dut.tx_data_in.value = 0
    dut.tx_valid_in.value = 0
    dut.tx_last_in.value = 0
    # entradas da interface com a Lane layer (palavras de 32 bits)
    dut.dl_tx_ready.value = 1
    dut.dl_rx_err.value = 0

    await ClockCycles(dut.tx_clk, 5)
    dut.tx_rst_n.value = 1
    dut.rx_rst_n.value = 1
    await RisingEdge(dut.tx_clk)

    # 2. Ativação do Link (LINK_ACTIVE / rx_link_up = 1)
    dut.link_state.value = LINK_ACTIVE
    dut.rx_link_up.value = 1
    await ClockCycles(dut.tx_clk, 4)

    # 3. Pacote de Teste
    test_packet = [0x11, 0x22, 0x33, 0x44, 0x55]
    received_bytes = []
    received_last_flag = False

    # Monitor assíncrono no domínio rx_clk
    async def rx_monitor():
        nonlocal received_last_flag
        while True:
            await RisingEdge(dut.rx_clk)
            if dut.rx_valid_out.value == 1:
                received_bytes.append(int(dut.rx_data_out.value))
                if dut.rx_last_out.value == 1:
                    received_last_flag = True
                    break

    cocotb.start_soon(rx_monitor())

    # 4. Transmissão do Pacote respeitando o valid/ready do TX
    for i, byte_val in enumerate(test_packet):
        dut.tx_valid_in.value = 1
        dut.tx_data_in.value = byte_val
        dut.tx_last_in.value = 1 if (i == len(test_packet) - 1) else 0

        while True:
            await RisingEdge(dut.tx_clk)
            if dut.tx_ready_out.value == 1:
                break

    dut.tx_valid_in.value = 0
    dut.tx_last_in.value = 0

    # 5. Aguarda conclusão e propagação até o RX
    # (era 12 ciclos; a ECSS 5.7.6.7a exige conferir o quadro inteiro antes de
    #  entregar os dados, o que soma a duração do quadro à latência)
    await ClockCycles(dut.rx_clk, 40)

    # 6. Asserções de Integridade
    assert dut.rx_frame_error.value == 0, "Falha: rx_frame_error foi acionado!"
    assert dut.tx_abort_out.value == 0, "Falha: tx_abort_out foi acionado!"
    assert received_bytes == test_packet, f"Erro no payload: Esperado {test_packet}, Obtido {received_bytes}"
    assert received_last_flag is True, "Falha: rx_last_out não foi gerado junto com o último byte!"

    dut._log.info("Sucesso! Pacote enquadrado e recebido com alinhamento de last perfeito.")

# ======================================================================
# Testes de conformidade com a ECSS-E-ST-50-11C
# Os vetores esperados foram copiados das figuras da norma.
# ======================================================================

# ---------------- Modelo de referência (conferido contra a norma) ----------
def crc16(data, crc=0xFFFF):
    """5.7.6.4: X^16+X^12+X^5+1, semente 0xFFFF, bit 0 primeiro."""
    for b in data:
        crc ^= b
        for _ in range(8):
            crc = (crc >> 1) ^ 0x8408 if crc & 1 else crc >> 1
    return crc


def crc8(data, crc=0x00):
    """5.7.6.5: x^8+x^2+x+1, semente 0x00, bit 0 primeiro."""
    for b in data:
        crc ^= b
        for _ in range(8):
            crc = (crc >> 1) ^ 0xE0 if crc & 1 else crc >> 1
    return crc


def prbs_bytes(n, state=0xFFFF):
    """5.7.6.2.3: X^16+X^5+X^4+X^3+1, semente 0xFFFF, bit 0 primeiro."""
    out = []
    for _ in range(n):
        byte = 0
        for i in range(8):
            bit = (state >> 15) & 1
            byte |= bit << i
            state = ((state << 1) & 0xFFFF) ^ (0x0039 if bit else 0)
        out.append(byte)
    return out


FC, SDF, SIF, EDF, EOP, FILL = 0xFC, 0x50, 0x44, 0x1C, 0xFD, 0xFB

# Fig. 5-42 (quadro sem scrambling) e Fig. 5-44 (três quadros curtos)
FIG_5_42 = [FC, SDF, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
            0x08, EOP, FILL, FILL, EDF, 0x22, 0x28, 0xA8]
FIG_5_44 = [
    [FC, SDF, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, EOP, FILL, FILL, FILL, EDF, 0x41, 0x8A, 0x97],
    [FC, SDF, 0x01, 0x00, 0x00, EOP, FILL, FILL, EDF, 0x7D, 0x3D, 0x35],
    [FC, SDF, 0x01, 0x00, 0x00, 0x01, 0x02, EOP, EDF, 0x7E, 0xA1, 0xB7],
]
# Fig. 5-43: primeiras palavras PRBS do primeiro quadro idle após link reset
FIG_5_43_PRBS = [0xFF, 0x17, 0xC0, 0x14, 0xB2, 0xE7, 0x02, 0x82, 0x72, 0x6E, 0x28, 0xA6]


@cocotb.test()
async def test_reference_model_matches_standard(dut):
    """O modelo Python usado nos testes reproduz as Figs. 5-42, 5-43, 5-44 e 5-46."""
    for frame in [FIG_5_42] + FIG_5_44:
        body, ls, ms = frame[:-2], frame[-2], frame[-1]
        assert crc16(body) == (ms << 8 | ls), f"CRC-16 não bate com a norma: {frame}"
    # Fig. 5-46: broadcast frame e FCT
    assert crc8([FC, 0x5D, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0x5C, 0x00, 0x41]) == 0x29
    assert crc8([0x7C, 0x01, 0x01]) == 0x4F
    assert prbs_bytes(12) == FIG_5_43_PRBS
    await Timer(1, unit="ns")


# ---------------- Infraestrutura ------------------------------------------
async def _setup(dut):
    cocotb.start_soon(Clock(dut.tx_clk, 8.0, unit="ns").start())
    cocotb.start_soon(Clock(dut.rx_clk, 8.0, unit="ns").start())
    dut.tx_rst_n.value = 0
    dut.rx_rst_n.value = 0
    dut.link_state.value = LINK_RESET
    dut.rx_link_up.value = 0
    dut.tx_data_in.value = 0
    dut.tx_valid_in.value = 0
    dut.tx_last_in.value = 0
    dut.dl_tx_ready.value = 1
    dut.dl_rx_err.value = 0
    await ClockCycles(dut.tx_clk, 5)
    dut.tx_rst_n.value = 1
    dut.rx_rst_n.value = 1
    await RisingEdge(dut.tx_clk)
    dut.link_state.value = LINK_ACTIVE
    dut.rx_link_up.value = 1


async def _send(dut, packet):
    for i, byte_val in enumerate(packet):
        dut.tx_valid_in.value = 1
        dut.tx_data_in.value = byte_val
        dut.tx_last_in.value = 1 if i == len(packet) - 1 else 0
        while True:
            await RisingEdge(dut.tx_clk)
            if dut.tx_ready_out.value == 1:
                break
    dut.tx_valid_in.value = 0
    dut.tx_last_in.value = 0


def _start_monitors(dut):
    """Captura a lane (símbolo a símbolo) e a saída do RX."""
    mon = {"lane": [], "pkts": [], "cur": [], "events": []}

    async def lane():
        while True:
            await RisingEdge(dut.tx_clk)
            if dut.lane_valid.value == 1:
                mon["lane"].append((int(dut.lane_is_k.value), int(dut.lane_data.value)))

    async def rx():
        while True:
            await RisingEdge(dut.rx_clk)
            err = int(dut.rx_frame_error.value)
            if dut.rx_valid_out.value == 1:
                mon["cur"].append(int(dut.rx_data_out.value))
                if dut.rx_last_out.value == 1:
                    mon["pkts"].append(list(mon["cur"]))
                    mon["events"].append(("pkt", len(mon["cur"]), err))
                    mon["cur"].clear()
            elif err:
                mon["events"].append(("erro", len(mon["cur"])))
                mon["cur"].clear()

    cocotb.start_soon(lane())
    cocotb.start_soon(rx())
    return mon


def _parse_lane(lane):
    """Separa a lane em quadros de dados e quadros idle (palavra a palavra)."""
    data, idle, i = [], [], 0
    while i + 4 <= len(lane):
        assert lane[i] == (1, FC), f"esperado comma no início de palavra, posição {i}: {lane[i]}"
        kind = lane[i + 1][1]
        if kind == SDF:
            j = i + 4
            while j + 4 <= len(lane) and lane[j] != (1, EDF):
                j += 4
            if j + 4 > len(lane):
                break
            data.append({"syms": [d for _, d in lane[i:j + 4]],
                         "body": lane[i + 4:j], "seq": lane[j + 1][1]})
            i = j + 4
        elif kind == SIF:
            j = i + 4
            while j < len(lane) and lane[j][0] == 0:
                j += 1
            idle.append(lane[i:j])
            i = j
        else:
            raise AssertionError(f"palavra de controle inesperada: {lane[i:i+4]}")
    return data, idle


# ---------------- Testes ----------------------------------------------------
@cocotb.test()
async def test_idle_frame_after_reset(dut):
    """Sem dados, o TX envia quadros idle; o primeiro reproduz a Fig. 5-43."""
    await _setup(dut)
    mon = _start_monitors(dut)
    await ClockCycles(dut.tx_clk, 300)

    lane = mon["lane"]
    sif = [d for _, d in lane[0:4]]
    assert sif[:3] == [FC, SIF, 0x00], f"SIF inválido: {sif}"           # SEQ 0 após reset
    assert sif[3] == crc8(sif[:3]), "CRC-8 do SIF errado"
    prbs = [d for _, d in lane[4:16]]
    assert prbs == FIG_5_43_PRBS, f"PRBS difere da Fig. 5-43: {[hex(x) for x in prbs]}"

    _, idle = _parse_lane(lane)
    # quadro idle completo = SIF + 64 palavras PRBS (5.3.8.3k)
    assert len(idle[0]) == 4 + 64 * 4, f"tamanho do quadro idle: {len(idle[0])}"
    # PRBS continua de um quadro idle para o outro (5.7.6.2.3b)
    prbs_all = [d for f in idle for _, d in f[4:]]
    ref = prbs_bytes(len(prbs_all))
    if prbs_all != ref:
        k = next(i for i in range(len(ref)) if prbs_all[i] != ref[i])
        dut._log.error(f"diverge no byte {k}: lens={[len(f) for f in idle]}")
    assert prbs_all == ref


@cocotb.test()
async def test_frame_matches_fig_5_42(dut):
    """O 34o quadro (SEQ 0x22) com dados 00..08 deve sair idêntico à Fig. 5-42."""
    await _setup(dut)
    mon = _start_monitors(dut)
    for n in range(33):
        await _send(dut, [n])
    await _send(dut, list(range(9)))
    await ClockCycles(dut.rx_clk, 60)

    frames, _ = _parse_lane(mon["lane"])
    assert len(frames) == 34
    got = frames[33]["syms"]
    assert got == FIG_5_42, f"\n obtido:   {[hex(x) for x in got]}\n esperado: {[hex(x) for x in FIG_5_42]}"
    assert mon["pkts"][-1] == list(range(9))


@cocotb.test()
async def test_lengths_and_word_format(dut):
    """Pacotes de 1 a 9 bytes: EOP, Fill, SEQ_NUM e CRC conferidos com o modelo da norma."""
    await _setup(dut)
    mon = _start_monitors(dut)
    packets = [[(n * 16 + i) & 0xFF for i in range(n)] for n in range(1, 10)]
    for p in packets:
        await _send(dut, p)
    await ClockCycles(dut.rx_clk, 60)

    assert not [e for e in mon["events"] if e[0] == "erro" or e[2]], mon["events"]
    assert mon["pkts"] == packets

    frames, _ = _parse_lane(mon["lane"])
    assert len(frames) == len(packets)
    for n, (f, p) in enumerate(zip(frames, packets), start=1):
        body = f["body"]
        assert [d for k, d in body if k == 0] == p
        assert body[len(p)] == (1, EOP), "EOP fora de posição"
        assert all(s == (1, FILL) for s in body[len(p) + 1:]), "padding diferente de Fill"
        assert len(body) % 4 == 0
        assert f["seq"] == n, f"SEQ_NUM esperado {n}, obtido {f['seq']}"
        s = f["syms"]
        assert crc16(s[:-2]) == (s[-1] << 8 | s[-2]), f"CRC do quadro {n} não bate com a norma"


@cocotb.test()
async def test_packet_split_across_frames(dut):
    """255, 256 e 300 bytes: quadros de até 64 palavras, EOP só no fim do pacote."""
    await _setup(dut)
    mon = _start_monitors(dut)
    packets = [[(i * 7 + n) & 0xFF for i in range(n)] for n in (255, 256, 300)]
    for p in packets:
        await _send(dut, p)
    await ClockCycles(dut.rx_clk, 400)

    assert not [e for e in mon["events"] if e[0] == "erro" or e[2]], mon["events"]
    assert mon["pkts"] == packets

    frames, _ = _parse_lane(mon["lane"])
    sizes = [len(f["body"]) // 4 for f in frames]
    dut._log.info(f"palavras por quadro: {sizes}")
    assert sizes == [64, 64, 1, 64, 12], f"divisão inesperada: {sizes}"
    assert [f["seq"] for f in frames] == [1, 2, 3, 4, 5]
    eops = [sum(1 for s in f["body"] if s == (1, EOP)) for f in frames]
    assert eops == [1, 0, 1, 0, 1]
    for f in frames:
        s = f["syms"]
        assert crc16(s[:-2]) == (s[-1] << 8 | s[-2])


async def _corrupt_first(dut, value, mask):
    """Troca bits de um byte já com o CRC calculado no TX (erro no meio físico)."""
    while True:
        await RisingEdge(dut.tx_clk)
        if dut.lane_valid.value == 1 and dut.lane_is_k.value == 0 \
                and int(dut.lane_data.value) == value:
            dut.u_tx.tx_data_out.value = value ^ mask
            return


@cocotb.test()
async def test_crc_error_discards_frame(dut):
    """Quadro com CRC errado é descartado inteiro (5.7.6.7b).

    Sem recuperação de erro (5.7.7), o quadro seguinte chega com SEQ_NUM
    "pulando" um número e também é descartado (5.7.6.3.2n). O terceiro passa.
    """
    await _setup(dut)
    mon = _start_monitors(dut)
    await ClockCycles(dut.tx_clk, 10)
    cocotb.start_soon(_corrupt_first(dut, 0xA3, 0x03))   # 2 bits (5.7.6.4a NOTE)
    await _send(dut, [0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6])
    await ClockCycles(dut.rx_clk, 40)
    await _send(dut, [0x01, 0x02, 0x03])
    await ClockCycles(dut.rx_clk, 40)
    await _send(dut, [0x04, 0x05, 0x06])
    await ClockCycles(dut.rx_clk, 40)

    # nenhum byte de quadro descartado pode ter sido entregue
    assert mon["events"] == [("erro", 0), ("erro", 0), ("pkt", 3, 0)], mon["events"]
    assert mon["pkts"] == [[0x04, 0x05, 0x06]]


@cocotb.test()
async def test_error_in_middle_frame(dut):
    """Erro no 1o quadro de um pacote de 300 bytes: o pacote inteiro é descartado.

    O 2o quadro do pacote é descartado por sequência, mas tem CRC correto e
    contém o EOP; por isso o pacote seguinte já é aceito normalmente.
    """
    await _setup(dut)
    mon = _start_monitors(dut)
    await ClockCycles(dut.tx_clk, 10)
    big = [(i * 3) & 0xFF for i in range(300)]
    cocotb.start_soon(_corrupt_first(dut, big[10], 0x81))
    await _send(dut, big)
    await ClockCycles(dut.rx_clk, 100)
    await _send(dut, [1, 2, 3])
    await ClockCycles(dut.rx_clk, 60)

    assert mon["events"] == [("erro", 0), ("erro", 0), ("pkt", 3, 0)], mon["events"]
    assert mon["pkts"] == [[1, 2, 3]]


# ======================================================================
# Interface de 32 bits com a Lane layer e RXERR
# ======================================================================

def _start_word_monitor(dut):
    """Captura as palavras de 32 bits entregues à Lane layer."""
    words = []

    async def mon():
        while True:
            await RisingEdge(dut.tx_clk)
            if dut.dl_tx_valid.value == 1 and dut.dl_tx_ready.value == 1:
                words.append((int(dut.dl_tx_ctrl.value), int(dut.dl_tx_data.value)))

    cocotb.start_soon(mon())
    return words


def _words_to_symbols(words):
    out = []
    for ctrl, data in words:
        for i in range(4):
            out.append(((ctrl >> i) & 1, (data >> (8 * i)) & 0xFF))
    return out


@cocotb.test()
async def test_lane_word_format(dut):
    """As palavras de 32 bits têm o símbolo 0 em [7:0]/ctrl[0] e estão alinhadas aos quadros."""
    await _setup(dut)
    mon = _start_monitors(dut)
    words = _start_word_monitor(dut)
    packets = [[(n * 9 + i) & 0xFF for i in range(n)] for n in (1, 5, 7, 70)]
    for p in packets:
        await _send(dut, p)
    await ClockCycles(dut.rx_clk, 120)

    assert mon["pkts"] == packets
    syms = _words_to_symbols(words)
    # o fluxo de palavras é exatamente o fluxo de símbolos do framer
    assert syms == mon["lane"][:len(syms)], "palavras não correspondem aos símbolos do framer"
    # toda palavra de controle de quadro começa no símbolo 0 da palavra
    for ctrl, data in words:
        for i in (1, 2, 3):
            if (ctrl >> i) & 1:
                assert (data >> (8 * i)) & 0xFF in (EOP, FILL), \
                    f"K-code fora do símbolo 0 que não é EOP/Fill: {ctrl:04b} {data:08x}"
    frames, _ = _parse_lane(syms)
    assert len(frames) == 4   # um quadro por pacote (70 bytes + EOP = 18 palavras)


@cocotb.test()
async def test_lane_backpressure(dut):
    """A Lane layer recusando palavras (SKIP) aleatoriamente não perde nem corrompe dados."""
    import random
    random.seed(7)
    await _setup(dut)
    mon = _start_monitors(dut)

    async def ready_noise():
        while True:
            await RisingEdge(dut.tx_clk)
            dut.dl_tx_ready.value = 1 if random.random() > 0.3 else 0

    cocotb.start_soon(ready_noise())
    packets = [[random.randrange(256) for _ in range(n)] for n in (3, 64, 255, 300, 9)]
    for p in packets:
        await _send(dut, p)
    await ClockCycles(dut.rx_clk, 1200)

    assert not [e for e in mon["events"] if e[0] == "erro" or e[2]], mon["events"]
    assert mon["pkts"] == packets
    assert dut.rx_overflow.value == 0
    frames, _ = _parse_lane(mon["lane"])
    for f in frames:
        s = f["syms"]
        assert crc16(s[:-2]) == (s[-1] << 8 | s[-2])


@cocotb.test()
async def test_rxerr_discards_frame(dut):
    """Palavra com erro de decodificação vira RXERR e o quadro é descartado (5.3.6, 5.7.8)."""
    await _setup(dut)
    mon = _start_monitors(dut)

    async def inject_on_payload_word():
        # espera o SDF passar pelo barramento de palavras e marca com erro a
        # palavra seguinte (a 1a palavra de dados do quadro)
        while True:
            await RisingEdge(dut.tx_clk)
            await Timer(1, unit="ns")
            if dut.dl_tx_valid.value == 1 and (int(dut.dl_tx_data.value) & 0xFFFF) == 0x50FC:
                break
        await RisingEdge(dut.rx_clk)          # SDF gravado no unpacker
        await Timer(1, unit="ns")
        wp0 = int(dut.u_unpack.wp.value)
        dut.dl_rx_err.value = 1
        while True:
            await RisingEdge(dut.rx_clk)
            await Timer(1, unit="ns")
            if int(dut.u_unpack.wp.value) != wp0:   # próxima palavra gravada com erro
                break
        dut.dl_rx_err.value = 0

    cocotb.start_soon(inject_on_payload_word())
    await _send(dut, [0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6])
    await ClockCycles(dut.rx_clk, 40)
    await _send(dut, [0x01, 0x02, 0x03])
    await ClockCycles(dut.rx_clk, 40)
    await _send(dut, [0x04, 0x05, 0x06])
    await ClockCycles(dut.rx_clk, 40)

    # 1o descartado por RXERR; 2o por sequência (sem retransmissão); 3o entregue
    assert mon["events"] == [("erro", 0), ("erro", 0), ("pkt", 3, 0)], mon["events"]
    assert mon["pkts"] == [[0x04, 0x05, 0x06]]


# ======================================================================
# Envio de uma imagem sintética
#
# Decisões do teste (a norma não define como dividir uma imagem em pacotes):
#   - imagem 64 x 64 em tons de cinza, pixel(x, y) = (4x + y) mod 256;
#     cada linha tem conteúdo único, o que permite identificar linhas perdidas
#   - cenário 1: uma linha por pacote (64 pacotes de 64 bytes)
#   - cenário 2: a imagem inteira em um pacote (4096 bytes)
# Normas aplicadas: formato do pacote (dados + EOP), ECSS (2019, p. 200-201);
# quadro de dados com 1 a 64 palavras, ECSS (2019, p. 68).
# ======================================================================
import os
import struct
import zlib

IMG_W = IMG_H = 64
OUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "image_out")


def _image():
    return [[(4 * x + y) & 0xFF for x in range(IMG_W)] for y in range(IMG_H)]


def _save_png(path, rows):
    """PNG em tons de cinza, 8 bits, gerado só com a biblioteca padrão."""
    def chunk(tag, data):
        c = struct.pack(">I", len(data)) + tag + data
        return c + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)
    raw = b"".join(b"\x00" + bytes(r) for r in rows)
    png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", len(rows[0]), len(rows), 8, 0, 0, 0, 0))
    png += chunk(b"IDAT", zlib.compress(raw, 9)) + chunk(b"IEND", b"")
    os.makedirs(OUT_DIR, exist_ok=True)
    with open(path, "wb") as f:
        f.write(png)


async def _corrupt_in_frame(dut, frame_no, data_idx, mask):
    """Troca bits do data_idx-ésimo byte de dados do quadro de dados número frame_no
    (contado desde o link reset), depois de o TX já ter calculado o CRC."""
    frames, prev, idx, in_frame = 0, None, 0, False
    while True:
        await RisingEdge(dut.tx_clk)
        if dut.lane_valid.value != 1:
            continue
        sym = (int(dut.lane_is_k.value), int(dut.lane_data.value))
        if prev == (1, 0xFC) and sym == (0, 0x50):
            frames += 1
            in_frame, idx = frames == frame_no, -2          # faltam VC e reservado
        elif in_frame:
            if idx >= 0 and sym[0] == 0:
                if idx == data_idx:
                    dut.u_tx.tx_data_out.value = sym[1] ^ mask
                    return
            idx += 1
        prev = sym


async def _wait_packets(dut, mon, n, limit):
    for _ in range(limit):
        await RisingEdge(dut.rx_clk)
        if len(mon["pkts"]) >= n:
            break
    await ClockCycles(dut.rx_clk, 20)


def _frame_report(dut, frames):
    sizes = [len(f["body"]) // 4 for f in frames]
    dut._log.info(f"quadros de dados: {len(frames)}; palavras por quadro: min {min(sizes)}, max {max(sizes)}")
    assert max(sizes) <= 64, "quadro com mais de 64 palavras (ECSS, 2019, p. 68)"
    return sizes


@cocotb.test()
async def test_image_row_packets(dut):
    """Imagem 64x64, uma linha por pacote: chega idêntica e cada quadro tem no máximo 64 palavras."""
    img = _image()
    await _setup(dut)
    mon = _start_monitors(dut)
    for row in img:
        await _send(dut, row)
    await _wait_packets(dut, mon, IMG_H, 20000)

    _save_png(os.path.join(OUT_DIR, "imagem_enviada.png"), img)
    _save_png(os.path.join(OUT_DIR, "imagem_recebida_linhas.png"),
              mon["pkts"] if len(mon["pkts"]) == IMG_H else img)
    assert not [e for e in mon["events"] if e[0] == "erro" or e[2]], mon["events"]
    assert mon["pkts"] == img, "imagem recebida diferente da enviada"

    frames, _ = _parse_lane(mon["lane"])
    sizes = _frame_report(dut, frames)
    assert len(frames) == IMG_H                       # um quadro por pacote
    # 64 bytes + EOP = 65 símbolos -> 17 palavras (EOP e 3 Fills na última)
    assert all(s == 17 for s in sizes), sizes
    for f in frames:
        assert sum(1 for s in f["body"] if s == (1, EOP)) == 1
        s = f["syms"]
        assert crc16(s[:-2]) == (s[-1] << 8 | s[-2])


@cocotb.test()
async def test_image_single_packet(dut):
    """Imagem inteira em um pacote de 4096 bytes: 16 quadros de 64 palavras e o EOP em um 17o quadro."""
    img = _image()
    flat = [p for row in img for p in row]
    await _setup(dut)
    mon = _start_monitors(dut)
    await _send(dut, flat)
    await _wait_packets(dut, mon, 1, 20000)

    assert not [e for e in mon["events"] if e[0] == "erro" or e[2]], mon["events"]
    assert len(mon["pkts"]) == 1 and mon["pkts"][0] == flat, "imagem recebida diferente da enviada"
    rx = mon["pkts"][0]
    _save_png(os.path.join(OUT_DIR, "imagem_recebida_pacote_unico.png"),
              [rx[i * IMG_W:(i + 1) * IMG_W] for i in range(IMG_H)])

    frames, _ = _parse_lane(mon["lane"])
    sizes = _frame_report(dut, frames)
    # 4096 bytes = 16 x 256: os 16 quadros enchem só com dados; o EOP não cabe
    # e vai em um quadro próprio, completado com 3 Fills (ECSS, 2019, p. 65, 68)
    assert sizes == [64] * 16 + [1], sizes
    eops = [sum(1 for s in f["body"] if s == (1, EOP)) for f in frames]
    assert eops == [0] * 16 + [1]
    assert [f["seq"] for f in frames] == list(range(1, 18))


@cocotb.test()
async def test_image_with_error_current_rtl(dut):
    """Imagem com erro de 2 bits na linha 10: nenhum dado corrompido é entregue.

    Registra as linhas perdidas no COMPORTAMENTO DO RTL ATUAL, que ainda tem
    os desvios A1-A3 pendentes (ressincronização do contador de sequência,
    descarte até o próximo EOP e SIF sem conferência de SEQ). A asserção
    verifica apenas o que a norma exige: o conteúdo de um quadro com erro não
    é entregue (ECSS, 2019, p. 177-178).
    """
    img = _image()
    await _setup(dut)
    mon = _start_monitors(dut)
    cocotb.start_soon(_corrupt_in_frame(dut, frame_no=11, data_idx=20, mask=0x03))   # linha 10, pixel 20
    for row in img:
        await _send(dut, row)
    await _wait_packets(dut, mon, IMG_H, 20000)
    await ClockCycles(dut.rx_clk, 200)

    by_first = {row[0]: y for y, row in enumerate(img)}
    received = {}
    for p in mon["pkts"]:
        y = by_first.get(p[0])
        assert y is not None and p == img[y], f"pacote entregue com conteúdo alterado: {p[:8]}..."
        received[y] = p
    lost = sorted(set(range(IMG_H)) - set(received))
    dut._log.info(f"linhas perdidas no RTL atual: {lost}")
    assert 10 in lost, "a linha com erro não pode ser entregue (ECSS, 2019, p. 178)"

    view = [received.get(y, [0] * IMG_W) for y in range(IMG_H)]   # linhas perdidas em preto
    _save_png(os.path.join(OUT_DIR, "imagem_recebida_com_erro.png"), view)


@cocotb.test()
async def test_image_single_packet_with_error_current_rtl(dut):
    """Imagem em um pacote, erro de 2 bits no pixel (20, 10): nenhum dado corrompido é entregue.

    Registra o comportamento do RTL ATUAL (desvios A1-A3 pendentes). O pixel
    (20, 10) é o byte 660 do pacote, no 3o quadro de dados (bytes 512 a 767).
    """
    img = _image()
    flat = [p for row in img for p in row]
    await _setup(dut)
    mon = _start_monitors(dut)
    cocotb.start_soon(_corrupt_in_frame(dut, frame_no=3, data_idx=660 - 512, mask=0x03))
    await _send(dut, flat)
    for _ in range(20000):
        await RisingEdge(dut.rx_clk)
    for p in mon["pkts"]:
        assert p == flat, "pacote entregue com conteúdo alterado"
    dut._log.info(f"pacotes completos entregues: {len(mon['pkts'])}; eventos: {mon['events']}")
    dut._log.info(f"bytes entregues antes do erro (pacote parcial): {len(mon['cur'])}")