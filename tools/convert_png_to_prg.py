# png_to_prg.py
# Převod rastrových obrázků -> Pagefox (PG) / Bit-Store (BS) / Graphics Basic (GB)
# - 8×8 tile layout, MSB-first
# - Černá = 1, bílá = 0 (lze otočit --invert)
# - GB/BS RLE: 9B <lo><hi> <v> (LE16)
# - PG RLE (symetricky k dekodéru):
#     * 9B 00 00         -> 256× 0x00
#     * 9B 00 <v!=00>    -> 1× <v>      (escape, např. pro 0x9B)
#     * 9B <count> <v> (count!=0) -> <v> × count
#     * ostatní literály
#   Strategie:
#     - běhy nul kóduj po blocích 256 (9B 00 00), zbytek 9B <rem> 00 (pro rem>=3), zbytek literály
#     - literál 0x9B vždy přes escape: 9B 00 9B

from pathlib import Path
from typing import Iterable, Tuple
import argparse

try:
    from PIL import Image
except ImportError:
    raise SystemExit("Chybí Pillow. Nainstaluj: pip install Pillow")

MARK = 0x9B

# ---------- Utility ----------

def iter_input_paths(p: Path, recursive: bool=False) -> Iterable[Path]:
    if p.is_file():
        yield p; return
    if not p.is_dir():
        return
    if recursive:
        yield from (x for x in p.rglob("*") if x.is_file())
    else:
        yield from (x for x in p.iterdir() if x.is_file())

# ---------- Obrázek -> tile bytes ----------

def load_as_bw_bytes(img_path: Path, invert: bool, target_tiles: Tuple[int,int]|None, pad_to_canvas: bool) -> Tuple[bytes,int,int]:
    im = Image.open(img_path).convert("L")

    # --- nový limit rozlišení ---
    max_w, max_h = 639, 799
    if im.width > max_w or im.height > max_h:
        scale = min(max_w / im.width, max_h / im.height)
        new_w = int(im.width * scale)
        new_h = int(im.height * scale)
        im = im.resize((new_w, new_h), Image.Resampling.LANCZOS)
        print(f"[INFO] {img_path.name}: zmenšeno na {new_w}×{new_h} (max {max_w}×{max_h})")

    # --- stávající logika ---
    if target_tiles:
        tiles_w, tiles_h = target_tiles
        want_w, want_h = tiles_w*8, tiles_h*8
        if pad_to_canvas:
            canvas = Image.new("L", (want_w, want_h), color=(0 if invert else 255))
            src = im
            if src.width > want_w or src.height > want_h:
                src = src.crop((0,0,want_w,want_h))
            canvas.paste(src, (0,0))
            im = canvas
        else:
            if im.width != want_w or im.height != want_h:
                raise ValueError(f"Vstup má {im.width}x{im.height}, očekáváno {want_w}x{want_h}. Přidej --pad-to-canvas.")

    w = (im.width + 7)//8*8
    h = (im.height + 7)//8*8
    if w != im.width or h != im.height:
        canvas = Image.new("L", (w, h), color=(0 if invert else 255))
        canvas.paste(im, (0,0))
        im = canvas

    tiles_w, tiles_h = im.width//8, im.height//8
    pix = im.load()
    out = bytearray()
    for ty in range(tiles_h):
        for tx in range(tiles_w):
            for row in range(8):
                y = ty*8 + row
                b = 0
                for bit in range(8):
                    x = tx*8 + bit
                    val = pix[x, y]
                    on = (val < 128)
                    if invert:
                        on = not on
                    b = (b << 1) | (1 if on else 0)
                out.append(b)
    return bytes(out), tiles_w, tiles_h

# ---------- ENCODE: GB/BS ----------

def encode_gbbs(data: bytes) -> bytes:
    out = bytearray()
    i = 0
    n = len(data)
    while i < n:
        v = data[i]
        # spočti běh
        j = i+1
        while j < n and data[j] == v and (j - i) < 0xFFFF:
            j += 1
        run = j - i
        if v == MARK:
            out.extend((MARK, 0x01, 0x00, MARK))  # escape 9B
            i += 1; continue
        if run >= 4:
            remain = run
            while remain:
                chunk = min(remain, 0xFFFF)
                out.extend((MARK, chunk & 0xFF, (chunk>>8)&0xFF, v))
                remain -= chunk
            i += run
        else:
            out.append(v); i += 1
    return bytes(out)

# ---------- ENCODE: PG (256-zero blocks + escape) ----------

def encode_pg(data: bytes) -> bytes:
    out = bytearray()
    i = 0
    n = len(data)
    while i < n:
        v = data[i]
        # spočti běh
        j = i+1
        while j < n and data[j] == v:
            j += 1
        run = j - i

        if v == MARK:
            # escape pro 0x9B (1× 9B)
            out.extend((MARK, 0x00, MARK))
            i += 1
            continue

        if v == 0x00 and run >= 3:
            # bloky 256 nul -> 9B 00 00
            blocks256 = run // 256
            if blocks256:
                out.extend((MARK, 0x00, 0x00) * blocks256)
            rem = run % 256
            if rem >= 3:
                out.extend((MARK, rem & 0xFF, 0x00))
            else:
                out.extend(b"\x00" * rem)
            i += run
            continue

        if run >= 3:
            remain = run
            while remain:
                chunk = min(remain, 255)
                out.extend((MARK, chunk & 0xFF, v))
                remain -= chunk
            i += run
        else:
            out.append(v)
            i += 1

    return bytes(out)

# ---------- Zápis formátů ----------

def write_pg(out_path: Path, tiles_w: int, tiles_h: int, tile_bytes: bytes, bounds_mode: str="flat") -> None:
    payload = encode_pg(tile_bytes)
    if bounds_mode == "zero":
        bounds = bytes([0x00] * (tiles_h * 4))
    else:
        bounds = bytes([0x01] * (tiles_h * 4))
    out = bytearray()
    out.append(0x50); out.append(tiles_h & 0xFF); out.append(tiles_w & 0xFF)
    out.append(0x4B); out.extend(bounds); out.append(0x00)
    out.extend(payload)
    out_path.write_bytes(bytes(out))

def write_bs(out_path: Path, tile_bytes: bytes) -> None:
    payload = encode_gbbs(tile_bytes)
    out = bytearray([0x42]); out.extend(payload)
    out_path.write_bytes(bytes(out))

def write_gb(out_path: Path, tile_bytes: bytes) -> None:
    payload = encode_gbbs(tile_bytes)
    out = bytearray([0x47]); out.extend(payload)
    out_path.write_bytes(bytes(out))

# ---------- CLI ----------

def main():
    ap = argparse.ArgumentParser(description="PNG → PG/BS/GB enkodér (8×8 tiles, MSB-first).")
    ap.add_argument("input", help="Vstupní PNG (nebo složka).")
    ap.add_argument("--format", choices=["pg","bs","gb"], required=True, help="Cílový formát.")
    ap.add_argument("--invert", action="store_true", help="Otočit význam barev (výchozí: černá=1, bílá=0).")
    ap.add_argument("--recursive", action="store_true", help="Při vstupu složky projít rekurzivně.")
    ap.add_argument("--pad-to-canvas", action="store_true", help="U BS/GB/PG doplní/ořízne na přesné plátno.")
    ap.add_argument("--pg-tiles", type=str, metavar="WxH", help="Vynutit PG dlaždice (např. 13x13).")
    ap.add_argument("--pg-bounds", choices=["flat","zero"], default="flat", help="PG bounds sekce (H*4 bajtů).")
    args = ap.parse_args()

    in_path = Path(args.input)
    if not in_path.exists():
        raise SystemExit(f"Vstup neexistuje: {in_path}")

    if args.format == "gb":
        target_tiles = (80, 50)   # 640×400
    elif args.format == "bs":
        target_tiles = (40, 25)   # 320×200
    else:
        target_tiles = None
        if args.pg_tiles:
            try:
                w,h = args.pg_tiles.lower().split("x")
                target_tiles = (int(w), int(h))
            except Exception:
                raise SystemExit("Neplatné --pg-tiles. Použij např. 13x13")

    any_done = False
    for src in iter_input_paths(in_path, recursive=args.recursive):
        try:
            tile_bytes, tiles_w, tiles_h = load_as_bw_bytes(
                src, invert=args.invert,
                target_tiles=target_tiles,
                pad_to_canvas=args.pad_to_canvas
            )
            out_path = src.with_suffix("." + args.format.upper())
            if args.format == "pg":
                tw, th = (target_tiles if target_tiles else (tiles_w, tiles_h))
                write_pg(out_path, tw, th, tile_bytes, bounds_mode=args.pg_bounds)
            elif args.format == "bs":
                if (tiles_w, tiles_h) != (40,25) and not args.pad_to_canvas:
                    raise ValueError(f"BS vyžaduje 40x25 tiles (320x200). Máš {tiles_w}x{tiles_h}. Přidej --pad-to-canvas.")
                write_bs(out_path, tile_bytes)
            else:
                if (tiles_w, tiles_h) != (80,50) and not args.pad_to_canvas:
                    raise ValueError(f"GB vyžaduje 80x50 tiles (640x400). Máš {tiles_w}x{tiles_h}. Přidej --pad-to-canvas.")
                write_gb(out_path, tile_bytes)

            print(f"[OK] {src.name} -> {out_path.name} ({tiles_w*8}x{tiles_h*8}px tiles)")
            any_done = True

        except Exception as e:
            print(f"[SKIP] {src}: {e}")

    if not any_done:
        print("Nenalezeny žádné použitelné vstupy.")

if __name__ == "__main__":
    main()