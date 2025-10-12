import argparse, struct, sys, re
from pathlib import Path

MAX_SLOTS   = 16
U16         = 0xFFFF
BANK_SIZE   = 0x4000   # 16384
TOTAL_SIZE  = 2 * BANK_SIZE
ID_RE = re.compile(r"^zs(\d+)\.prg$", re.IGNORECASE)

def parse_id(p: Path) -> int:
    m = ID_RE.match(p.name)
    if not m: raise ValueError(f"{p.name}: očekávám název ve tvaru 'zs<id>.prg'")
    v = int(m.group(1))
    if not (0 <= v <= 255): raise ValueError(f"{p.name}: ID {v} mimo rozsah 0..255")
    return v

def read_block_strip_Z(p: Path) -> bytes:
    b = p.read_bytes()
    if not b: raise ValueError(f"{p}: soubor je prázdný")
    if b[0:1] != b"Z":
        raise ValueError(f"{p}: první bajt je {b[0]:02X}, očekávám 0x5A ('Z')")
    return b[1:]  # bez 'Z'

def build_header(ids, starts) -> bytes:
    ids_tab   = ids + [0x00]  * (MAX_SLOTS - len(ids))
    addrs_tab = starts + [0xFFFF] * (MAX_SLOTS - len(starts))
    out = bytearray()
    out += b"Z"
    out += bytes(ids_tab)
    for a in addrs_tab:
        out += struct.pack("<H", a & U16)
    return bytes(out)

def parse_addr(s: str) -> int:
    s = s.strip()
    if s.startswith("$"): s = "0x" + s[1:]
    return int(s,16) & U16 if s.lower().startswith("0x") else (int(s) & U16)

def main():
    ap = argparse.ArgumentParser(
        description="Složí zs<id>.prg (začínají 'Z') do kontejneru se 2 bankami po 16 KB. "
                    "Hlavička vždy v 1. bance. Pokud by blok přešel přes $4000, posune se na $4000 a 1. banka se doplní FF."
    )
    ap.add_argument("output", help="Výsledný kontejner (bin)")
    ap.add_argument("inputs", nargs="+", help="Vstupní soubory zs<id>.prg v požadovaném pořadí")
    ap.add_argument("--first-start", required=True, help="Start adresa prvního bloku (např. $0031 nebo 49)")
    ap.add_argument("--order-by-id", action="store_true", help="Seřadit vstupy podle ID vzestupně (jinak pořadí argumentů)")
    ap.add_argument("--dry-run", action="store_true", help="Jen vypíše plán, soubor nevytváří")
    args = ap.parse_args()

    in_paths = [Path(p) for p in args.inputs]
    if len(in_paths) > MAX_SLOTS:
        raise ValueError("Max 16 vstupů (hlavička má 16 slotů).")

    # načti bloky a ID
    items = []
    for p in in_paths:
        ident = parse_id(p)
        data  = read_block_strip_Z(p)
        if len(data) > BANK_SIZE:
            raise ValueError(f"{p.name}: blok má {len(data)} B > 16384 B (nevejde se do jedné banky).")
        items.append((ident, p.name, data))

    if args.order_by_id:
        items.sort(key=lambda x: x[0])  # podle ID

    ids    = [it[0] for it in items]
    names  = [it[1] for it in items]
    blocks = [it[2] for it in items]

    # spočítej start adresy s pravidlem $4000
    first = parse_addr(args.first_start)
    starts = []
    cur_addr = first
    for blk in blocks:
        # pokud by blok začínající < $4000 přesáhl hranici, přesuň start na $4000
        if cur_addr < BANK_SIZE and cur_addr + len(blk) > BANK_SIZE:
            cur_addr = BANK_SIZE
        starts.append(cur_addr)
        cur_addr = (cur_addr + len(blk)) & U16

    # výpis plánu (End jen informačně)
    print(f"Slotů: {len(ids)}  | first-start: ${first:04X}")
    print(f"{'#':>2}  {'ID':>3}  {'Start':>6}  {'End':>6}  {'Size(B)':>8}  Soubor")
    print("-"*64)
    for idx, (i, s, blk, nm) in enumerate(zip(ids, starts, blocks, names), start=1):
        e = ((s + len(blk) - 1) & U16)
        print(f"{idx:2d}  {i:02X}  ${s:04X}  ${e:04X}  {len(blk):8d}  {nm}")

    # sestav hlavičku (musí se vejít do 1. banky)
    header = build_header(ids, starts)
    if len(header) > BANK_SIZE:
        raise ValueError(f"Hlavička má {len(header)} B a nevejde se do první banky ({BANK_SIZE} B).")

    # stavba výstupu s doplněním na hranicích bank
    out = bytearray()
    out += header
    # aktuální fyzický offset v souboru (pro bankové zarovnání)
    phys_off = len(out)

    for s, blk in zip(starts, blocks):
        # pokud by se fyzicky blok roztrhl mezi bankami, dopaduj FF do konce 1. banky
        if phys_off < BANK_SIZE and phys_off + len(blk) > BANK_SIZE:
            out += b"\xFF" * (BANK_SIZE - phys_off)
            phys_off = BANK_SIZE

        # pokud logika startů přikázala začít od $4000 a fyzicky ještě nejsme na hranici, dopaduj FF
        if s >= BANK_SIZE and phys_off < BANK_SIZE:
            out += b"\xFF" * (BANK_SIZE - phys_off)
            phys_off = BANK_SIZE

        out += blk
        phys_off += len(blk)

    # doplň na přesně 2×16 KB
    if phys_off > TOTAL_SIZE:
        raise ValueError(f"Výsledek by měl {phys_off} B > {TOTAL_SIZE} B (2×16KB).")
    if phys_off < TOTAL_SIZE:
        out += b"\xFF" * (TOTAL_SIZE - phys_off)

    if args.dry_run:
        print(f"(dry-run) Výstup by měl {len(out)} B (2×{BANK_SIZE}).")
        return

    Path(args.output).write_bytes(out)
    print(f"OK -> {args.output}  ({len(out)} B = 2 × {BANK_SIZE})")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Chyba: {e}", file=sys.stderr)
        sys.exit(1)
