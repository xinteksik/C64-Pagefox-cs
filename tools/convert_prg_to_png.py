# convert_prg_to_png.py
# Auto-detekce PG / BS / GB + převod do PNG (8×8 tiles, MSB-first)
# Výstup: černé na bílém (přepínač --invert). Umí soubor i dávku (složka).
# Finální PG RLE:
#   - 9B 00 00         -> 256 × 0x00
#   - 9B 00 <v!=00>    -> 1 × <v>       (escape)
#   - 9B <count!=0> <v>-> <v> × count
#   - ostatní bajty    -> literály

from pathlib import Path
from typing import Tuple, Iterable
import argparse

try:
    from PIL import Image
except ImportError:
    raise SystemExit("Chybí Pillow. Nainstaluj: pip install Pillow")

MARK = 0x9B

# ---------- Dekodéry ----------

def decode_gbbs(payload: bytes) -> bytes:
    """GB/BS: 0x9B <lo><hi> <val> -> opakuj <val> (hi<<8 | lo)-krát."""
    out = bytearray()
    i = 0
    n = len(payload)
    while i < n:
        b = payload[i]; i += 1
        if b != MARK:
            out.append(b); continue
        if i + 2 >= n: break
        lo = payload[i]; hi = payload[i+1]; i += 2
        count = lo | (hi << 8)
        if i >= n: break
        val = payload[i]; i += 1
        if count:
            out.extend([val]*count)
    return bytes(out)

def parse_pg_header_and_bounds(buf: bytes) -> Tuple[int,int,bytes]:
    """PG: 50 H W 4B <H*4 bytes> 00  <payload...>  → vrací (tiles_w, tiles_h, payload)."""
    if len(buf) < 3 or buf[0] != 0x50:
        raise ValueError("Neplatná PG hlavička (chybí 0x50).")
    h_tiles = buf[1]
    w_tiles = buf[2]
    p = 3
    if p >= len(buf) or buf[p] != 0x4B:
        raise ValueError("PG: chybí 0x4B po hlavičce.")
    p += 1
    need_bounds = h_tiles * 4
    if p + need_bounds > len(buf):
        raise ValueError("PG: hranice 4×4 jsou useknuté.")
    p += need_bounds
    if p >= len(buf) or buf[p] != 0x00:
        raise ValueError("PG: chybí ukončení 0x00 po hranicích.")
    p += 1
    payload = buf[p:]
    return (w_tiles, h_tiles, payload)

def decode_pg(payload: bytes) -> bytes:
    """
    PG RLE (finální):
      - 9B 00 00         -> 256× 0x00
      - 9B 00 <v!=00>    -> 1× <v>
      - 9B <count!=0> <v>-> <v> × count
      - ostatní jsou literály
    """
    out = bytearray()
    i = 0
    n = len(payload)
    while i < n:
        b = payload[i]; i += 1
        if b != MARK:
            out.append(b); continue
        if i >= n: break
        count = payload[i]; i += 1
        if count == 0:
            if i >= n: break
            val = payload[i]; i += 1
            if val == 0x00:
                out.extend([0x00]*256)
            else:
                out.append(val)
            continue
        if i >= n: break
        val = payload[i]; i += 1
        out.extend([val]*count)
    return bytes(out)

# ---------- Vykreslení ----------

def render_tiles(raw_bytes: bytes, tiles_w: int, tiles_h: int, black_on_white: bool=True) -> Image.Image:
    """Složí 1bpp obrázek z 8×8 dlaždic, MSB-first bitů."""
    w_px, h_px = tiles_w * 8, tiles_h * 8
    need = tiles_w * tiles_h * 8
    if len(raw_bytes) < need:
        raw_bytes = raw_bytes + bytes(need - len(raw_bytes))
    elif len(raw_bytes) > need:
        raw_bytes = raw_bytes[:need]
    img = Image.new("L", (w_px, h_px), color=(255 if black_on_white else 0))
    idx = 0
    for ty in range(tiles_h):
        for tx in range(tiles_w):
            for row in range(8):
                byte = raw_bytes[idx]; idx += 1
                y = ty*8 + row
                for bit in range(8):
                    x = tx*8 + bit
                    bitval = (byte >> (7-bit)) & 1
                    if black_on_white:
                        img.putpixel((x, y), 0 if bitval else 255)
                    else:
                        img.putpixel((x, y), 255 if bitval else 0)
    return img

# ---------- Autodetekce formátu ----------

def autodetect_and_decode(buf: bytes):
    """
    Vrací (mode, tiles_w, tiles_h, decoded_bytes)
    - PG: 0x50, rozměry z hlavičky
    - BS: 0x42, 40×25 dlaždic (320×200)
    - GB: 0x47, 80×50 dlaždic (640×400)
    """
    if not buf: raise ValueError("Prázdný soubor.")
    hdr = buf[0]
    if hdr == 0x50:  # PG
        tiles_w, tiles_h, payload = parse_pg_header_and_bounds(buf)
        decoded = decode_pg(payload)
        return ("PG", tiles_w, tiles_h, decoded)
    if hdr == 0x42:  # BS
        return ("BS", 40, 25, decode_gbbs(buf[1:]))
    if hdr == 0x47:  # GB
        return ("GB", 80, 50, decode_gbbs(buf[1:]))
    raise ValueError(f"Neznámý formát (0x{hdr:02X}).")

# ---------- I/O util ----------

def iter_input_paths(input_path: Path, recursive: bool=False) -> Iterable[Path]:
    if input_path.is_file():
        yield input_path; return
    if not input_path.is_dir():
        return
    if recursive:
        yield from (p for p in input_path.rglob("*") if p.is_file())
    else:
        yield from (p for p in input_path.iterdir() if p.is_file())

# ---------- Main CLI ----------

def main():
    ap = argparse.ArgumentParser(
        description="Konverze PG/BS/GB do PNG (8×8 tiles, MSB-first). Umí soubor i dávku (složka)."
    )
    ap.add_argument("input", help="Vstupní soubor NEBO složka.")
    ap.add_argument("--preview4x", action="store_true", help="Uložit i 4× náhled (_preview4x.png).")
    ap.add_argument("--invert", action="store_true", help="Invertovat (bílé na černém). Výchozí je černé na bílém.")
    ap.add_argument("--recursive", action="store_true", help="Při zpracování složky procházet rekurzivně.")
    ap.add_argument("--save-raw", dest="save_raw", action="store_true", help="Uložit dekomprimovaný RAW (stejné_jmeno.raw).")
    args = ap.parse_args()

    in_path = Path(args.input)
    if not in_path.exists():
        raise SystemExit(f"Vstup neexistuje: {in_path}")

    any_done = False
    for src in iter_input_paths(in_path, recursive=args.recursive):
        try:
            data = src.read_bytes()
            mode, tiles_w, tiles_h, decoded = autodetect_and_decode(data)

            if args.save_raw:
                src.with_suffix(".raw").write_bytes(decoded)

            img = render_tiles(decoded, tiles_w, tiles_h, black_on_white=not args.invert)
            out_png = src.with_suffix(".png")
            img.save(out_png)
            print(f"[OK] {src.name} ({mode}) -> {out_png.name} [{tiles_w*8}×{tiles_h*8}px]")

            if args.preview4x:
                try:
                    resampling = Image.Resampling.NEAREST
                except AttributeError:
                    resampling = Image.NEAREST
                preview = img.resize((tiles_w*8*4, tiles_h*8*4), resample=resampling)
                preview_path = src.with_name(src.stem + "_preview4x.png")
                preview.save(preview_path)
                print(f"      + náhled: {preview_path.name}")

            any_done = True
        except Exception as e:
            print(f"[SKIP] {src}: {e}")

    if not any_done:
        print("Nenalezeny žádné soubory ke zpracování.")

if __name__ == "__main__":
    main()