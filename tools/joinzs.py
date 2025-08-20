#!/usr/bin/env python3
import argparse, struct, sys, re
from pathlib import Path

MAX_SLOTS = 16
U16 = 0xFFFF
ID_RE = re.compile(r"^zs(\d+)\.prg$", re.IGNORECASE)

def parse_id(p: Path) -> int:
    m = ID_RE.match(p.name)
    if not m:
        raise ValueError(f"{p.name}: očekávám název ve tvaru 'zs<id>.prg'")
    v = int(m.group(1))
    if not (0 <= v <= 255): raise ValueError(f"{p.name}: ID {v} mimo rozsah 0..255")
    return v

def read_block_strip_Z(p: Path) -> bytes:
    b = p.read_bytes()
    if not b: raise ValueError(f"{p}: soubor je prázdný")
    if b[0:1] != b"Z":
        raise ValueError(f"{p}: první bajt je {b[0]:02X}, očekávám 0x5A ('Z')")
    return b[1:]

def build_header(ids, starts):
    ids_tab = ids + [0x00]*(MAX_SLOTS - len(ids))
    addrs_tab = starts + [0xFFFF]*(MAX_SLOTS - len(starts))
    out = bytearray()
    out += b"Z"
    out += bytes(ids_tab)
    for a in addrs_tab:
        out += struct.pack("<H", a)
    return bytes(out)

def parse_addr(s: str) -> int:
    s = s.strip()
    if s.startswith("$"): s = "0x" + s[1:]
    return int(s, 16) & U16 if s.lower().startswith("0x") else (int(s) & U16)

def main():
    ap = argparse.ArgumentParser(
        description="Složí zs<id>.prg soubory (každý začíná 'Z') do jednoho kontejneru a doplní do 32768 B pomocí 0xFF."
    )
    ap.add_argument("output", help="Výsledný kontejner (bin)")
    ap.add_argument("inputs", nargs="+", help="Vstupní soubory zs<id>.prg v požadovaném pořadí")
    ap.add_argument("--first-start", required=True, help="Start adresa prvního bloku (např. $0031 nebo 49)")
    ap.add_argument("--order-by-id", action="store_true", help="Seřadit vstupy podle ID vzestupně")
    ap.add_argument("--dry-run", action="store_true", help="Jen vypíše plán, soubor nevytváří")
    args = ap.parse_args()

    in_paths = [Path(p) for p in args.inputs]
    if len(in_paths) > MAX_SLOTS:
        raise ValueError("Max 16 vstupů (hlavička má 16 slotů).")

    items = []
    for p in in_paths:
        ident = parse_id(p)
        data = read_block_strip_Z(p)
        items.append((ident, p, data))

    if args.order_by_id:
        items.sort(key=lambda x: x[0])

    first = parse_addr(args.first_start)
    ids    = [it[0] for it in items]
    blocks = [it[2] for it in items]
    names  = [it[1].name for it in items]

    starts = []
    cur = first
    for blk in blocks:
        starts.append(cur)
        cur = (cur + len(blk)) & U16

    ends = []
    for i in range(len(starts)):
        ends.append((starts[i+1]-1)&U16 if i < len(starts)-1 else None)

    # výpis
    print(f"Slotů: {len(ids)}  | first-start: ${first:04X}")
    print(f"{'#':>2}  {'ID':>3}  {'Start':>6}  {'End':>6}  {'Size(B)':>8}  Soubor")
    print("-"*64)
    for idx,(i,s,e,blk,nm) in enumerate(zip(ids,starts,ends,blocks,names), start=1):
        e_str = f"${e:04X}" if e is not None else "----"
        print(f"{idx:2d}  {i:02X}  ${s:04X}  {e_str:>6}  {len(blk):8d}  {nm}")

    header = build_header(ids, starts)
    payload = b"".join(blocks)
    out_bytes = header + payload

    # dopadování na 32768 B
    TARGET_SIZE = 32768
    if len(out_bytes) < TARGET_SIZE:
        pad_len = TARGET_SIZE - len(out_bytes)
        out_bytes += b"\xFF" * pad_len
        print(f"Doplněno {pad_len} bajtů 0xFF -> celková velikost {TARGET_SIZE} B")
    elif len(out_bytes) > TARGET_SIZE:
        print(f"Upozornění: výsledek je {len(out_bytes)} B, což je > {TARGET_SIZE}. Nebylo oříznuto.")

    if args.dry_run:
        print(f"(dry-run) Výstupní velikost by byla {len(out_bytes)} B")
        return

    Path(args.output).write_bytes(out_bytes)
    print(f"OK -> {args.output}  ({len(out_bytes)} B)")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Chyba: {e}", file=sys.stderr)
        sys.exit(1)