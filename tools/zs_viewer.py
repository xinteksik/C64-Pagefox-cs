#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ZSx (Pagefox) font viewer – bílé pozadí, černý tisk, dávkové zpracování,
robustní vůči nesouladům, správné RLE (0x9B + count:2B LE + value:1B),
volitelné vykreslení libovolného textu A NOVĚ:
  --layout alternate  → řádek kódů, pod ním řádek glyfů (opakovaně)
  --layout label-band → původní pásky v buňkách
  --layout none       → bez kódů

Bit order výchozí MSB->LSB; přepnout lze --lsb-first.
"""

import argparse
from pathlib import Path
from typing import List, Dict, Tuple
from PIL import Image, ImageDraw

# ------------------------------ RLE ---------------------------------
def rle_decode_9b(data: bytes, counter: str = "word", minus1: bool = False) -> bytes:
    MARK = 0x9B
    out = bytearray()
    i = 0
    n = len(data)
    while i < n:
        b = data[i]; i += 1
        if b != MARK:
            out.append(b)
            continue
        if counter == "byte":
            if i + 2 > n:
                raise ValueError(f"Nedostatek bajtů po 0x9B na offsetu {i-1} (byte count)")
            count = data[i]; value = data[i + 1]; i += 2
        elif counter == "word":
            if i + 3 > n:
                raise ValueError(f"Nedostatek bajtů po 0x9B na offsetu {i-1} (word count)")
            count = data[i] | (data[i + 1] << 8); value = data[i + 2]; i += 3
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

# ------------------------------ Render základ ------------------------
def bytes_to_bitmap(glyph_bytes: bytes, width_tiles: int, height_px: int,
                    actual_width_px: int, msb_first: bool = True) -> Image.Image:
    """1bit, bílé pozadí (1), černý inkoust (0)."""
    stride = width_tiles
    w = max(1, actual_width_px)
    h = height_px
    im = Image.new("1", (w, h), 1)
    px = im.load()
    for y in range(h):
        row = glyph_bytes[y * stride:(y + 1) * stride]
        x = 0
        for byte in row:
            bits = range(7, -1, -1) if msb_first else range(0, 8)
            for bit in bits:
                if x >= w: break
                if (byte >> bit) & 1:
                    px[x, y] = 0
                x += 1
    return im

from PIL import Image, ImageDraw

def _measure_text_w(sample: str = "FF") -> int:
    """Změří šířku popisku v pixelech pro vestavěný PIL font."""
    img = Image.new("1", (1, 1), 1)
    draw = ImageDraw.Draw(img)
    # textbbox je přesnější; fallback na textsize pro starší Pillow
    try:
        l, t, r, b = draw.textbbox((0, 0), sample)
        return max(0, r - l)
    except Exception:
        w, h = draw.textsize(sample)
        return w

def render_grid(
    meta,
    glyphs: list[bytes],
    cols: int = 16,
    cell_padding: int = 1,
    msb_first: bool = True,
    scale: int = 2,
    layout: str = "alternate",   # "alternate" | "label-band" | "none"
    label_h: int = 12
) -> Image.Image:
    width_tiles = meta["width_tiles"]
    height_px = meta["height_px"]
    per_char_widths = meta["per_char_widths"]
    glyph_count = meta.get("glyph_count", len(per_char_widths))
    first_code = 0x20

    # 1) základní šířka podle glyfů
    max_w = max(per_char_widths) if per_char_widths else 8
    # 2) minimální šířka kvůli popisku (měříme „FF“ jako nejširší hex)
    label_min_w = _measure_text_w("FF") + 4  # +2px okraj zleva i zprava
    # 3) výsledná šířka sloupce
    cell_w = max(max_w + 2 * cell_padding, label_min_w)

    if layout == "alternate":
        glyph_row_h = height_px + 2 * cell_padding
        block_h = label_h + glyph_row_h
        rows_of_blocks = (glyph_count + cols - 1) // cols
        img_w = cols * cell_w
        img_h = rows_of_blocks * block_h
        grid = Image.new("1", (img_w, img_h), 1)
        draw = ImageDraw.Draw(grid)

        for idx in range(glyph_count):
            r_block = idx // cols
            c = idx % cols
            code = first_code + idx

            # --- popisek (vycentrovaný v buňce)
            label = f"{code:02X}"
            lw = _measure_text_w(label)
            lx = c * cell_w + (cell_w - lw) // 2
            ly = r_block * block_h + max(0, (label_h - 10) // 2)  # drobný svislý offset
            draw.text((lx, ly), label, fill=0)

            # --- glyf (vycentrovaný vodorovně v rámci buňky podle vlastní šířky)
            gw = per_char_widths[idx]
            bmp = bytes_to_bitmap(glyphs[idx], width_tiles, height_px, gw, msb_first=msb_first)
            ox = c * cell_w + (cell_w - gw) // 2
            oy = r_block * block_h + label_h + cell_padding
            grid.paste(bmp, (ox, oy))

        if scale != 1:
            grid = grid.resize((grid.width * scale, grid.height * scale), Image.NEAREST)
        return grid

    elif layout == "label-band":
        label_band = label_h
        cell_h = height_px + 2 * cell_padding + label_band
        rows = (glyph_count + cols - 1) // cols
        grid = Image.new("1", (cols * cell_w, rows * cell_h), 1)
        draw = ImageDraw.Draw(grid)

        for idx in range(glyph_count):
            r = idx // cols
            c = idx % cols
            code = first_code + idx

            # glyf (vodorovné centrování)
            gw = per_char_widths[idx]
            bmp = bytes_to_bitmap(glyphs[idx], width_tiles, height_px, gw, msb_first=msb_first)
            ox = c * cell_w + (cell_w - gw) // 2
            oy = r * cell_h + cell_padding
            grid.paste(bmp, (ox, oy))

            # oddělovací linka
            y_sep = r * cell_h + (cell_h - label_band - 1)
            for x in range(c * cell_w, (c + 1) * cell_w):
                grid.putpixel((x, y_sep), 0)

            # popisek (vycentrovaný v pásku)
            label = f"{code:02X}"
            lw = _measure_text_w(label)
            lx = c * cell_w + (cell_w - lw) // 2
            ly = r * cell_h + (cell_h - label_band) + max(0, (label_band - 10) // 2)
            draw.text((lx, ly), label, fill=0)

        if scale != 1:
            grid = grid.resize((grid.width * scale, grid.height * scale), Image.NEAREST)
        return grid

    else:  # 'none'
        cell_h = height_px + 2 * cell_padding
        rows = (glyph_count + cols - 1) // cols
        grid = Image.new("1", (cols * cell_w, rows * cell_h), 1)

        for idx in range(glyph_count):
            r = idx // cols
            c = idx % cols
            gw = per_char_widths[idx]
            bmp = bytes_to_bitmap(glyphs[idx], width_tiles, height_px, gw, msb_first=msb_first)
            ox = c * cell_w + (cell_w - gw) // 2
            oy = r * cell_h + cell_padding
            grid.paste(bmp, (ox, oy))

        if scale != 1:
            grid = grid.resize((grid.width * scale, grid.height * scale), Image.NEAREST)
        return grid
# ------------------------------ Render TEXT --------------------------
def build_glyph_cache(meta, glyphs, msb_first=True) -> Dict[int, Tuple[Image.Image, int]]:
    cache: Dict[int, Tuple[Image.Image, int]] = {}
    width_tiles = meta["width_tiles"]
    height_px = meta["height_px"]
    per_char_widths = meta["per_char_widths"]
    glyph_count = meta["glyph_count"]
    for idx in range(glyph_count):
        code = 0x20 + idx
        gw = per_char_widths[idx]
        bmp = bytes_to_bitmap(glyphs[idx], width_tiles, height_px, gw, msb_first=msb_first)
        cache[code] = (bmp, gw)
    return cache

def measure_text(meta, cache: Dict[int, Tuple[Image.Image, int]], text: str,
                 letter_space: int, line_gap: int, margin: int) -> Tuple[int, int, List[List[int]]]:
    lines_codes: List[List[int]] = [[ord(ch) for ch in raw_line] for raw_line in text.split("\n")]
    height_px = meta["height_px"]
    space_w = cache.get(0x20, (None, 0))[1]
    qmark_w = cache.get(ord('?'), (None, space_w))[1]

    max_w = 0
    for codes in lines_codes:
        w = 0
        for i, c in enumerate(codes):
            w += cache.get(c, (None, qmark_w if ord('?') in cache else space_w))[1]
            if i < len(codes) - 1: w += letter_space
        max_w = max(max_w, w)

    total_h = len(lines_codes) * height_px + (len(lines_codes)-1) * line_gap
    total_w = max_w
    total_w += 2 * margin; total_h += 2 * margin
    return total_w, total_h, lines_codes

def render_text_image(meta, glyphs, text: str, msb_first: bool,
                      letter_space: int, line_gap: int, margin: int, scale: int) -> Image.Image:
    cache = build_glyph_cache(meta, glyphs, msb_first=msb_first)
    if letter_space is None:
        letter_space = meta["general_spacing_px"]
    width, height, lines_codes = measure_text(meta, cache, text, letter_space, line_gap, margin)

    img = Image.new("1", (max(1, width), max(1, height)), 1)
    y = margin
    height_px = meta["height_px"]
    for codes in lines_codes:
        x = margin
        for i, c in enumerate(codes):
            if c in cache:
                bmp, gw = cache[c]
            else:
                if ord('?') in cache:
                    bmp, gw = cache[ord('?')]
                else:
                    gw = cache.get(0x20, (None, 0))[1]
                    bmp = Image.new("1", (max(1, gw), height_px), 1)
            img.paste(bmp, (x, y))
            x += gw
            if i < len(codes) - 1: x += letter_space
        y += height_px + line_gap

    if scale and scale != 1:
        img = img.resize((img.width * scale, img.height * scale), Image.NEAREST)
    return img

# ------------------------------ CLI / Batch --------------------------
def main():
    ap = argparse.ArgumentParser(
        description="Zobrazovač ZSx (Pagefox) – bílé pozadí, černý tisk, dávkové zpracování, text renderer, střídavé řádky kódů a glyfů."
    )
    ap.add_argument("input", type=Path, help="Soubor ZSx (např. zs1.prg) nebo adresář se ZS soubory")
    ap.add_argument("-o", "--out", type=Path, default=None,
                    help="Výstupní PNG (jen pokud je vstup jeden soubor)")
    ap.add_argument("--out-dir", type=Path, default=None,
                    help="Výstupní adresář (pokud je vstup adresář, povinné)")

    ap.add_argument("--cols", type=int, default=16, help="Sloupce (na blok) v mřížce")
    ap.add_argument("--scale", type=int, default=2, help="Zvětšení výsledku (default 2)")
    ap.add_argument("--lsb-first", action="store_true", help="Bit order LSB->MSB (default MSB->LSB)")
    ap.add_argument("--rle", choices=["byte", "word"], default="word",
                    help="Velikost čítače po 0x9B (default 'word' = 2B LE)")
    ap.add_argument("--minus1", action="store_true",
                    help="Použít (count-1) opakování místo count (default vypnuto)")

    ap.add_argument("--layout", choices=["alternate", "label-band", "none"], default="alternate",
                    help="Styl popisků (default alternate = řádky kódů a glyfů)")
    ap.add_argument("--label-h", type=int, default=12,
                    help="Výška řádku s kódy (px, neskalovaných)")

    # text renderer
    ap.add_argument("--text", type=str, default=None,
                    help="Krátký text k vykreslení tímto fontem (\\n pro nový řádek).")
    ap.add_argument("--text-out", type=Path, default=None,
                    help="Cesta pro PNG s textem (default <vstup>_text.png)")
    ap.add_argument("--letter-space", type=int, default=None,
                    help="Mezera mezi znaky (px). Default: general_spacing z hlavičky.")
    ap.add_argument("--line-gap", type=int, default=2,
                    help="Mezera mezi řádky textu (px neskalovaných).")
    ap.add_argument("--margin", type=int, default=4,
                    help="Vnější okraj kolem textu (px neskalovaných).")

    args = ap.parse_args()

    def process_file(inp: Path, out_file: Path, text: str):
        meta, glyphs = parse_zs(inp, rle_counter=args.rle, rle_minus1=args.minus1)
        print(f"Soubor: {inp.name}  →  {out_file.name} | znaky: {meta['glyph_count']} | "
              f"hlavička last=0x{meta['last_char']:02X}, efektivní last=0x{meta['effective_last_char']:02X}")
        grid = render_grid(
            meta, glyphs,
            cols=args.cols,
            cell_padding=1,
            msb_first=not args.lsb_first,
            scale=args.scale,
            layout=args.layout,
            label_h=args.label_h
        )
        out_file.parent.mkdir(parents=True, exist_ok=True)
        grid.save(out_file)

        if text is not None:
            text_png = args.text_out or out_file.with_name(out_file.stem + "_text.png")
            text_img = render_text_image(
                meta, glyphs, text,
                msb_first=not args.lsb_first,
                letter_space=args.letter_space,
                line_gap=args.line_gap,
                margin=args.margin,
                scale=args.scale
            )
            text_img.save(text_png)
            print(f"Text uložen: {text_png}")

    inp = args.input
    if inp.is_file():
        out_path = args.out or inp.with_suffix(".png")
        process_file(inp, out_path, args.text)
        print(f"Uloženo: {out_path}")
    elif inp.is_dir():
        if args.out_dir is None:
            raise SystemExit("Při vstupu jako adresář musíš zadat --out-dir")
        args.out_dir.mkdir(parents=True, exist_ok=True)
        for f in sorted(inp.glob("zs*")):
            if not f.is_file(): continue
            out_path = args.out_dir / (f.stem + ".png")
            try:
                process_file(f, out_path, args.text)
            except Exception as e:
                print(f"Chyba při {f.name}: {e}")
        print(f"Hotovo, PNG soubory jsou v {args.out_dir}")
    else:
        raise SystemExit("Input není ani soubor, ani adresář")

if __name__ == "__main__":
    main()