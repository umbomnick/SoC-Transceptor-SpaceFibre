#!/usr/bin/env python3
"""
repair_fanout.py - Insercao de arvores de buffers em redes de alto fanout
(equivalente simplificado ao `repair_design -max_fanout` do OpenROAD), para a
STA pos-sintese em SKY130 HD.
"""
import re, sys, argparse

OUT_PINS = {"X", "Y", "Q", "Q_N", "COUT", "SUM", "HI", "LO", "GCLK"}

ap = argparse.ArgumentParser()
ap.add_argument("inp")
ap.add_argument("out")
ap.add_argument("--max-fanout", type=int, default=10)
ap.add_argument("--buf", default="sky130_fd_sc_hd__buf_4")
ap.add_argument("--skip", action="append", default=["clk"])
ap.add_argument("--buffer-outputs", action="store_true")
ap.add_argument("--out-buf", default="sky130_fd_sc_hd__buf_2")
a = ap.parse_args()

src = open(a.inp).read()
m_end = src.rfind("endmodule")
head, tail = src[:m_end], src[m_end:]

inst_re = re.compile(r"(\n\s*)(sky130_fd_sc_hd__\w+)\s+(\S+)\s*\((.*?)\n\s*\);", re.S)
pin_re  = re.compile(r"\.(\w+)\(([^()]*)\)")

def norm(n):
    return n.strip()

insts = []
for m in inst_re.finditer(head):
    pins = [(p, norm(n)) for p, n in pin_re.findall(m.group(4))]
    insts.append({"cell": m.group(2), "name": m.group(3), "pins": pins, "span": m.span()})

out_bufs = []
if a.buffer_outputs:
    obits = []
    for m in re.finditer(r"^\s*output\s+(?:\[(\d+):(\d+)\]\s+)?(\w+)\s*;", head, re.M):
        if m.group(1) is not None:
            hi, lo = int(m.group(1)), int(m.group(2))
            obits += [f"{m.group(3)}[{b}]" for b in range(lo, hi + 1)]
        else:
            obits.append(m.group(3))
    oset = set(obits)
    src_of = {}
    def expand(lhs):
        mm = re.match(r"(\w+)\[(\d+):(\d+)\]$", lhs)
        if mm:
            return [f"{mm.group(1)}[{b}]" for b in range(int(mm.group(2)), int(mm.group(3)) - 1, -1)]
        return [lhs]
    def assign_sub(m):
        lhs, rhs = m.group(1).strip(), m.group(2).strip()
        lb = expand(lhs)
        rb = [x.strip() for x in rhs.strip("{} ").split(",")] if rhs.startswith("{") else [rhs]
        if len(lb) == len(rb) and all(b in oset for b in lb):
            for l, r in zip(lb, rb):
                src_of[l] = r
            return ""
        return m.group(0)
    head = re.sub(r"^\s*assign\s+(.+?)\s*=\s*(.+?);\s*$", assign_sub, head, flags=re.M)
    insts = []
    for m in inst_re.finditer(head):
        pins = [(p, norm(n)) for p, n in pin_re.findall(m.group(4))]
        insts.append({"cell": m.group(2), "name": m.group(3), "pins": pins, "span": m.span()})
    ren = {}
    k = 0
    for ins in insts:
        for j, (p, n) in enumerate(ins["pins"]):
            if p in OUT_PINS and n in oset and n not in ren:
                k += 1
                ren[n] = f"_rfoo{k}_"
    for ins in insts:
        ins["pins"] = [(p, ren.get(n, n)) for p, n in ins["pins"]]
    for b in obits:
        if b in ren:
            out_bufs.append((f"_rfoob{len(out_bufs)}_", ren[b], b))
        elif b in src_of:
            sname = ren.get(src_of[b], src_of[b])
            out_bufs.append((f"_rfoob{len(out_bufs)}_", sname, b))
    ren_decls = [f"  wire {w};\n" for w in ren.values()]
else:
    ren_decls = []

loads = {}
for i, ins in enumerate(insts):
    for j, (p, n) in enumerate(ins["pins"]):
        if p not in OUT_PINS and n:
            loads.setdefault(n, []).append((i, j))
for ob in out_bufs:
    insts.append({"cell": a.out_buf, "name": ob[0], "pins": [("A", ob[1]), ("X", ob[2])], "span": None})
    loads.setdefault(ob[1], []).append((len(insts) - 1, 0))

skip = set(a.skip)
cnt = 0
new_decls, new_insts = [], []

def fresh(prefix):
    global cnt
    cnt += 1
    return f"_rfo{prefix}{cnt}_"

stats = []
for net, ld in sorted(loads.items(), key=lambda kv: -len(kv[1])):
    if net in skip or net.startswith("1'") or len(ld) <= a.max_fanout:
        continue
    orig = len(ld)
    items = [("pin", x) for x in ld]
    levels = 0
    while len(items) > a.max_fanout:
        levels += 1
        groups = [items[k:k + a.max_fanout] for k in range(0, len(items), a.max_fanout)]
        nxt = []
        for g in groups:
            out_net = fresh("n")
            in_net  = fresh("i")
            bname   = fresh("b")
            new_decls.append(f"  wire {out_net};\n  wire {in_net};\n")
            new_insts.append([bname, in_net, out_net])
            for kind, ref in g:
                if kind == "pin":
                    i, j = ref
                    p, _ = insts[i]["pins"][j]
                    insts[i]["pins"][j] = (p, out_net)
                else:
                    ref[1] = out_net
            nxt.append(("buf", new_insts[-1]))
        items = nxt
    for kind, ref in items:
        if kind == "buf":
            ref[1] = net
    stats.append((net, orig, levels))

used_in = {b[1] for b in new_insts}
decls = []
for d in new_decls:
    for line in d.strip().split("\n"):
        w = line.split()[1].rstrip(";")
        if w.startswith("_rfoi") and w not in used_in:
            continue
        decls.append(line + "\n")

out, pos = [], 0
inserted_decls = False
for ins in insts:
    if ins["span"] is None:
        continue
    s, e = ins["span"]
    out.append(head[pos:s])
    if not inserted_decls:
        out.append("\n  // ---- fios inseridos por repair_fanout.py ----\n")
        out.extend(ren_decls)
        out.extend(decls)
        inserted_decls = True
    body = ",\n".join(f"    .{p}({n if not n.startswith(chr(92)) else n + ' '})" for p, n in ins["pins"])
    out.append(f"\n  {ins['cell']} {ins['name']} (\n{body}\n  );")
    pos = e
out.append(head[pos:])
out.append("\n  // ---- buffers inseridos por repair_fanout.py ----\n")
for ins in insts:
    if ins["span"] is None:
        body = ",\n".join(f"    .{p}({n if not n.startswith(chr(92)) else n + ' '})" for p, n in ins["pins"])
        out.append(f"  {ins['cell']} {ins['name']} (\n{body}\n  );\n")
for bname, i_net, o_net in new_insts:
    i_s = i_net + " " if i_net.startswith("\\") else i_net
    out.append(f"  {a.buf} {bname} (\n    .A({i_s}),\n    .X({o_net})\n  );\n")
out.append(tail)
open(a.out, "w").write("".join(out))

print(f"buffers de saida: {len(out_bufs)} | redes reparadas: {len(stats)} | buffers de fanout: {len(new_insts)} | max_fanout={a.max_fanout}")
for net, n, lv in stats[:12]:
    print(f"  {net:40s} fanout {n:4d} -> {lv} nivel(is)")
