#!/usr/bin/env python3
"""Copia uma liberty marcando celulas como dont_use (equivalente ao DONT_USE do OpenLane).
Uso: mark_dont_use.py entrada.lib saida.lib [padrao ...]   (padroes fnmatch, default: *lpflow* *probe*)"""
import re, sys, fnmatch
src, dst = sys.argv[1], sys.argv[2]
pats = sys.argv[3:] or ["*lpflow*", "*probe*"]
n = 0
with open(src) as f, open(dst, "w") as o:
    for line in f:
        o.write(line)
        m = re.match(r'\s*cell\s*\(\s*"?([^")]+)"?\s*\)\s*\{', line)
        if m and any(fnmatch.fnmatch(m.group(1), p) for p in pats):
            o.write("        dont_use : true ;\n")
            n += 1
print(f"{n} celulas marcadas dont_use")
