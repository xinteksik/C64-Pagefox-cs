#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ZSx (Pagefox) font viewer – bílé pozadí, černý tisk, dávkové zpracování, popisky bez překryvu, robustní vůči nesouladům,
RLE správně: 0x9B + count:2B LE + value:1B (výchozí). Lze přepnout na byte count nebo (count-1).

Bit order výchozí MSB->LSB; přepnout lze --lsb-first.
"""

import argparse
from pathlib import Path
from typing import List
from PIL import Image, ImageDraw

# ------------------------------ RLE ---------------------------------
def rle_decode_9b(data: bytes, counter: str = "word", minus1: bool = False) -> bytes:
    """
    0x9B RLE:
      counter='byte' -> 1B count
      counter='word' -> 2B count (little-endian) [default]
      minus1=True    -> použij (count-1)
    """
    MARK = 0x9B
    out = bytearray()
    i = 0
    n = len(data)
    while i < n:
        b = data[i]
        i += 1
        if b != MARK:
            out.append(b)
            continue

        if counter == "byte":
            if i + 2 > n:
                raise ValueError(f"Nedostatek bajtů po 0x9B na offsetu {i-1} (byte count)")
            count = data[i]
            value = data[i + 1]
            i += 2
        elif counter == "word":
            if i + 3 > n:
                raise ValueError(f"Nedostatek bajtů po 0x9B na offsetu {i-1} (word count)")
            count = data[i] | (data[i + 1] << 8)
            value = data[i + 2]
            i += 3
        else:
            raise ValueError("counter musí být 'byte' nebo 'word'")

        if count == 0:
            raise ValueError(f"Neplatná délka 0 po 0x9B na offsetu {i-1}")

        reps = count - 1 if minus1 else count
        if reps < 0:
            raise ValueError("Výsledný počet opakování je záporný")
        out.extend([value] * reps)

    return bytes(out)

# ------------------------------ Parsování ZS -------------------------
def parse_zs(path: Path, rle_counter: str, rle_minus1: bool):
    raw = path.read_bytes()
    if len(raw) < 2 + 119:
        raise ValueError("Soubor je příliš krátký na hlavičku.")

    if raw[0] != 0x5A:
        raise ValueError(f"Očekáván 0x5A ('z') na pozici 0, nalezeno {raw[0]:02X}")
    set_number = raw[1]

    hdr = raw[2:2 + 119]
    width_tiles = hdr[0]              # 1..3 (1 tile = 1 byte = 8 px)
    height_px = hdr[1]                # 5..42
    last_char = hdr[2]                # např. 0x92
    per_char_widths = list(hdr[3:3 + 114])
    x_height_px = hdr[117]
    general_spacing_px = hdr[118]

    first_char = 0x20
    declared_count = max(0, last_char - first_char + 1)
    widths_count = len(per_char_widths)  # 114
    if declared_count <= 0:
        raise ValueError("V hlavičce nevyšla žádná množina znaků.")

    comp = raw[2 + 119:]
    decomp = rle_decode_9b(comp, counter=rle_counter, minus1=rle_minus1)

    stride_bytes = width_tiles
    glyph_bytes = stride_bytes * height_px
    if glyph_bytes <= 0:
        raise ValueError("Nevyhovující kombinace width_tiles/height_px v hlavičce.")

    available_count = len(decomp) // glyph_bytes
    remainder = len(decomp) % glyph_bytes
    glyph_count = min(declared_count, widths_count, available_count)

    if available_count < declared_count:
        print(f"Upozornění: data obsahují pouze {available_count} znaků, "
              f"hlavička deklaruje {declared_count}. Použito {glyph_count}.")
    if remainder != 0:
        print(f"Upozornění: po rozdělení znaků zbylo {remainder} bajtů – ignoruji.")

    per_char_widths = per_char_widths[:glyph_count]
    effective_last_char = first_char + glyph_count - 1

    glyphs = []
    pos = 0
    for _ in range(glyph_count):
        glyphs.append(decomp[pos:pos + glyph_bytes])
        pos += glyph_bytes

    meta = {
        "set_number": set_number,
        "width_tiles": width_tiles,
        "height_px": height_px,
        "last_char": last_char,
        "effective_last_char": effective_last_char,
        "x_height_px": x_height_px,
        "general_spacing_px": general_spacing_px,
        "per_char_widths": per_char_widths,
        "glyph_count": glyph_count,
    }
    return meta, glyphs

# ------------------------------ Render -------------------------------
def bytes_to_bitmap(
    glyph_bytes: bytes,
    width_tiles: int,
    height_px: int,
    actual_width_px: int,
    msb_first: bool = True
) -> Image.Image:
    """Převod 1bit streamu znaku na bitmapu PIL ('1').
       Pozadí bílé (1), inkoust černý (0)."""
    stride = width_tiles
    w = max(1, actual_width_px)
    h = height_px
    im = Image.new("1", (w, h), 1)  # 1 = white background
    px = im.load()

    for y in range(h):
        row = glyph_bytes[y * stride:(y + 1) * stride]
        x = 0
        for byte in row:
            bits = range(7, -1, -1) if msb_first else range(0, 8)
            for bit in bits:
                if x >= w:
                    break
                if (byte >> bit) & 1:
                    px[x, y] = 0  # black ink
                # else leave white background
                x += 1
    return im

def render_grid(
    meta,
    glyphs: List[bytes],
    cols: int = 16,
    cell_padding: int = 1,
    msb_first: bool = True,
    scale: int = 2,
    label_pos: str = "bottom",   # "none" | "top" | "bottom"
    label_h: int = 10            # výška pásku pro popisek (neskalovaná)
) -> Image.Image:
    width_tiles = meta["width_tiles"]
    height_px = meta["height_px"]
    per_char_widths = meta["per_char_widths"]
    glyph_count = meta.get("glyph_count", len(per_char_widths))

    max_w = max(per_char_widths) if per_char_widths else 8

    label_band = 0 if label_pos == "none" else label_h
    cell_w = max_w + 2 * cell_padding
    cell_h = height_px + 2 * cell_padding + label_band

    rows = (glyph_count + cols - 1) // cols
    grid = Image.new("1", (cols * cell_w, rows * cell_h), 1)  # white background
    draw = ImageDraw.Draw(grid)

    # glyfy
    for idx in range(glyph_count):
        gw = per_char_widths[idx]
        bmp = bytes_to_bitmap(
            glyphs[idx],
            width_tiles=width_tiles,
            height_px=height_px,
            actual_width_px=gw,
            msb_first=msb_first
        )
        r = idx // cols
        c = idx % cols
        ox = c * cell_w + cell_padding
        oy = r * cell_h + cell_padding + (label_band if label_pos == "top" else 0)
        grid.paste(bmp, (ox, oy))

        # oddělovací linka (pokud je label) – černá
        if label_pos != "none":
            y_sep = r * cell_h + (cell_h - label_band - 1 if label_pos == "bottom" else label_band - 1)
            if 0 <= y_sep < grid.height:
                for x in range(c * cell_w, (c + 1) * cell_w):
                    grid.putpixel((x, y_sep), 0)

    # popisky – černé
    if label_pos != "none":
        for idx in range(glyph_count):
            code = 0x20 + idx
            r = idx // cols
            c = idx % cols
            label = f"{code:02X}"
            if label_pos == "bottom":
                lx = c * cell_w + 2
                ly = (r * cell_h) + (cell_h - label_band) + 1
            else:  # top
                lx = c * cell_w + 2
                ly = (r * cell_h) + 1
            draw.text((lx, ly), label, fill=0)  # black

    # scale (nearest zachová 1bit vzhled)
    if scale != 1:
        grid = grid.resize((grid.width * scale, grid.height * scale), Image.NEAREST)

    return grid

# ------------------------------ CLI / Batch --------------------------
def main():
    ap = argparse.ArgumentParser(
        description="Zobrazovač ZSx (Pagefox) – bílé pozadí, černý tisk, dávkové zpracování, robustní RLE 0x9B."
    )
    ap.add_argument("input", type=Path, help="Soubor ZSx (např. zs1.prg) nebo adresář se ZS soubory")
    ap.add_argument("-o", "--out", type=Path, default=None,
                    help="Výstupní PNG (jen pokud je vstup jeden soubor)")
    ap.add_argument("--out-dir", type=Path, default=None,
                    help="Výstupní adresář (pokud je vstup adresář, povinné)")
    ap.add_argument("--cols", type=int, default=16, help="Sloupce mřížky (default 16)")
    ap.add_argument("--scale", type=int, default=2, help="Zvětšení výsledku (default 2)")
    ap.add_argument("--lsb-first", action="store_true", help="Bit order LSB->MSB (default MSB->LSB)")
    ap.add_argument("--rle", choices=["byte", "word"], default="word",
                    help="Velikost čítače po 0x9B (default 'word' = 2B LE)")
    ap.add_argument("--minus1", action="store_true",
                    help="Použít (count-1) opakování místo count (default vypnuto)")
    ap.add_argument("--label", choices=["none", "top", "bottom"], default="bottom",
                    help="Umístění popisku kódu znaku (default bottom)")
    ap.add_argument("--label-h", type=int, default=10,
                    help="Výška pásku pro popisek (px, neskalovaných)")

    args = ap.parse_args()

    def process_file(inp: Path, out_file: Path):
        meta, glyphs = parse_zs(inp, rle_counter=args.rle, rle_minus1=args.minus1)
        print(f"Soubor: {inp.name}  →  {out_file.name} | znaky: {meta['glyph_count']} | "
              f"hlavička last=0x{meta['last_char']:02X}, efektivní last=0x{meta['effective_last_char']:02X}")
        grid = render_grid(
            meta,
            glyphs,
            cols=args.cols,
            cell_padding=1,
            msb_first=not args.lsb_first,
            scale=args.scale,
            label_pos=args.label,
            label_h=args.label_h
        )
        out_file.parent.mkdir(parents=True, exist_ok=True)
        grid.save(out_file)

    inp = args.input
    if inp.is_file():
        out_path = args.out or inp.with_suffix(".png")
        process_file(inp, out_path)
        print(f"Uloženo: {out_path}")
    elif inp.is_dir():
        if args.out_dir is None:
            raise SystemExit("Při vstupu jako adresář musíš zadat --out-dir")
        args.out_dir.mkdir(parents=True, exist_ok=True)
        for f in sorted(inp.glob("zs*")):
            if not f.is_file():
                continue
            out_path = args.out_dir / (f.stem + ".png")
            try:
                process_file(f, out_path)
            except Exception as e:
                print(f"Chyba při {f.name}: {e}")
        print(f"Hotovo, PNG soubory jsou v {args.out_dir}")
    else:
        raise SystemExit("Input není ani soubor, ani adresář")

if __name__ == "__main__":
    main()