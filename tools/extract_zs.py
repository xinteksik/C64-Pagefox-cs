#!/usr/bin/env python3
import argparse, struct, sys
from pathlib import Path

MAX_SLOTS = 16
U16MASK   = 0xFFFF

def parse_header(data):
    if len(data) < 1 or data[0:1] != b"Z":
        raise ValueError("Soubor nezačíná 0x5A ('Z').")

    off = 1
    ids = list(data[off:off+MAX_SLOTS]); off += MAX_SLOTS

    addrs = []
    for _ in range(MAX_SLOTS):
        addr = struct.unpack("<H", data[off:off+2])[0]
        addrs.append(addr)
        off += 2

    slots_all = list(zip(ids, addrs))
    slots_active = [(i, a) for (i, a) in slots_all if i != 0x00 and a != 0xFFFF]
    return slots_active, off

def compute_end_addrs(slots):
    ends = []
    for idx in range(len(slots)):
        if idx < len(slots) - 1:
            next_start = slots[idx + 1][1]
            ends.append((next_start - 1) & U16MASK)
        else:
            ends.append(None)
    return ends

def compute_sizes_from_addrs(slots, ends):
    sizes = []
    for (ident, start), end in zip(slots, ends):
        if end is None:
            sizes.append(None)
        else:
            size = (end - start + 1) & U16MASK
            sizes.append(size)
    return sizes

def write_file(out_dir: Path, ident: int, blob: bytes):
    out_dir.mkdir(parents=True, exist_ok=True)
    path = out_dir / f"zs{ident}.prg"
    with open(path, "wb") as f:
        f.write(b"Z")   # přidat znak Z
        f.write(blob)
    return path

def main():
    ap = argparse.ArgumentParser(description="Extrahuje bloky ze ZS kontejneru (16 slotů) do souborů bez PRG hlavičky.")
    ap.add_argument("input", help="Vstupní soubor")
    ap.add_argument("-o", "--outdir", default="out_zs", help="Výstupní složka")
    ap.add_argument("--dry-run", action="store_true", help="Jen vypsat plán, neukládat")
    args = ap.parse_args()

    data = Path(args.input).read_bytes()
    slots, payload_off = parse_header(data)

    total_payload = len(data) - payload_off
    ends  = compute_end_addrs(slots)
    sizes = compute_sizes_from_addrs(slots, ends)

    known_sizes = sum(s for s in sizes[:-1] if s is not None)
    last_size = total_payload - known_sizes
    sizes[-1] = last_size

    spans, cur = [], payload_off
    for sz in sizes:
        s, e = cur, cur + sz
        spans.append((s, e))
        cur = e

    print(f"Aktivní sloty: {len(slots)} | payload: {total_payload} B | payload_off: {payload_off}")
    print(f"{'ID':>3}  {'Start':>6}  {'End':>6}  {'Size(B)':>8}")
    print("-" * 36)
    for (ident, start), end, (s, e) in zip(slots, ends, spans):
        size = e - s
        end_str = f"${end:04X}" if end is not None else "----"
        print(f"{ident:02X}  ${start:04X}  {end_str:>6}  {size:8d}")

    if not args.dry_run:
        outdir = Path(args.outdir)
        for (ident, start), (s, e) in zip(slots, spans):
            blob = data[s:e]
            out = write_file(outdir, ident, blob)
            print(f"-> {out}")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Chyba: {e}", file=sys.stderr)
        sys.exit(1)