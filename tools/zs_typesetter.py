#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ZSx typesetter – zalamování do stránky 640x800, výchozí ZS1, správné 0x0D (nový řádek),
neztrácí 0x85, přepínání fontu přes řádky '[f] z=N' / 'z=N', ignoruje [značky].
RLE ve fontech: 0x9B + count:2B LE + value:1B. Bílé pozadí, černý text.
"""

import argparse
import re
from pathlib import Path
from typing import Dict, Tuple, List, Optional
from PIL import Image, ImageDraw

# ---------------- PETSCII payload -> text ----------------
def petscii_relaxed_to_text(payload: bytes) -> str:
    """
    - 0x0D -> '\n' (nový řádek)
    - ostatní < 0x20 se zahodí (řídicí kódy), ale 0x0D ne
    - vše ostatní vracíme jako chr(b) (včetně 0x80..0xFF), aby se nic „neztratilo“
    """
    out = []
    for b in payload:
        if b == 0x0D:
            out.append("\n")
        elif b < 0x20:
            continue
        else:
            out.append(chr(b))
    return "".join(out)

def load_editor_text(path: Path) -> str:
    """
    Načte editorový vstup:
      - .prg: přeskočí 2B load adresu a zbytek běží přes petscii_relaxed_to_text
      - jinak: čte UTF-8 (errors=replace); pokud selže, spadne do petscii_relaxed_to_text
    Pozor: řádky nerozdělujeme splitlines(), aby se neztrácel U+0085 (0x85).
    """
    raw = path.read_bytes()
    if path.suffix.lower() == ".prg":
        if len(raw) < 2:
            return ""
        return petscii_relaxed_to_text(raw[2:])
    try:
        return path.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return petscii_relaxed_to_text(raw)

def to_lines(text: str) -> List[str]:
    """Rozdělí na řádky jen podle '\n' (chr(10)), aby se 0x85 neztratilo jako NL."""
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    return text.split("\n")

# ---------------- RLE 0x9B WORD LE -----------------------
def rle_decode_9b_word(data: bytes) -> bytes:
    MARK = 0x9B
    out = bytearray()
    i, n = 0, len(data)
    while i < n:
        b = data[i]; i += 1
        if b != MARK:
            out.append(b)
            continue
        if i + 3 > n:
            raise ValueError("Truncated 0x9B packet (need 3 bytes)")
        count = data[i] | (data[i+1] << 8)
        value = data[i+2]
        i += 3
        if count <= 0:
            raise ValueError("Invalid RLE count 0")
        out.extend([value] * count)
    return bytes(out)

# ---------------- ZS font loader -------------------------
class ZSFont:
    def __init__(self, zs_path: Path):
        raw = zs_path.read_bytes()
        if len(raw) < 2 + 119 or raw[0] != 0x5A:
            raise ValueError(f"{zs_path.name}: špatná signatura/hlavička")
        self.set_number = raw[1]
        hdr = raw[2:2+119]
        self.width_tiles = hdr[0]
        self.height_px  = hdr[1]
        self.last_char  = hdr[2]
        per_char_widths = list(hdr[3:3+114])
        self.x_height_px = hdr[117]
        self.general_spacing_px = hdr[118]

        first_char = 0x20
        declared = max(0, self.last_char - first_char + 1)

        comp = raw[2+119:]
        decomp = rle_decode_9b_word(comp)

        stride = self.width_tiles
        glyph_bytes = stride * self.height_px
        if glyph_bytes <= 0:
            raise ValueError("Nevyhovující kombinace width_tiles/height_px.")
        avail = len(decomp) // glyph_bytes

        self.glyph_count = min(declared, len(per_char_widths), avail)
        self.effective_last_char = first_char + self.glyph_count - 1
        self.per_char_widths = per_char_widths[:self.glyph_count]

        # rozřezání glyfů
        self._glyph_bytes: List[bytes] = []
        pos = 0
        for _ in range(self.glyph_count):
            self._glyph_bytes.append(decomp[pos:pos+glyph_bytes])
            pos += glyph_bytes

        self._cache: Dict[int, Tuple[Image.Image, int]] = {}

    def _bytes_to_bitmap(self, glyph_bytes: bytes, actual_width_px: int, msb_first: bool = True) -> Image.Image:
        stride = self.width_tiles
        w = max(1, actual_width_px); h = self.height_px
        im = Image.new("1", (w, h), 1)  # bílé pozadí
        px = im.load()
        for y in range(h):
            row = glyph_bytes[y*stride:(y+1)*stride]
            x = 0
            for byte in row:
                bits = range(7, -1, -1) if msb_first else range(0, 8)
                for bit in bits:
                    if x >= w: break
                    if (byte >> bit) & 1:
                        px[x, y] = 0  # černý inkoust
                    x += 1
        return im

    def get_glyph(self, code: int, msb_first: bool = True) -> Optional[Tuple[Image.Image, int]]:
        if code < 0x20 or code > self.effective_last_char:
            return None
        if code in self._cache:
            return self._cache[code]
        idx = code - 0x20
        gw = self.per_char_widths[idx]
        bmp = self._bytes_to_bitmap(self._glyph_bytes[idx], gw, msb_first=msb_first)
        self._cache[code] = (bmp, gw)
        return self._cache[code]

# ---------------- Typesetter (wrap na šířku) ---------------
RE_FONT_SWITCH = re.compile(r"^\s*(?:\[f\]\s*)?z\s*=\s*(\d+)\s*$", re.IGNORECASE)
BRACKET_TOKEN  = re.compile(r"\[[^\]\n]*\]")  # odstraní [e], [c=..], …

class EditorTypesetter:
    def __init__(self, font_dir: Path, default_z: Optional[int] = None,
                 letter_space: Optional[int] = None, line_gap: int = 1, margin: int = 4,
                 msb_first: bool = True, scale: int = 2,
                 page_w: int = 640, page_h: int = 800):
        self.font_dir = font_dir
        self.letter_space_override = letter_space
        self.line_gap = line_gap             # neskalovaných px
        self.margin = margin                 # neskalovaných px, vlevo/vpravo řádku
        self.msb_first = msb_first
        self.scale = scale
        self.page_w = page_w                 # neskalovaných px
        self.page_h = page_h                 # neskalovaných px

        # Výchozí font: vždy ZS1, pokud uživatel nic nezadal
        if default_z is None:
            default_z = 1
        self.current_font: ZSFont = self._load_zs(default_z)

    def _load_zs(self, znum: int) -> ZSFont:
        for name in (f"ZS{znum}.prg", f"zs{znum}.prg", f"ZS{znum}", f"zs{znum}"):
            p = self.font_dir / name
            if p.exists():
                print(f"[info] font: {p.name}")
                return ZSFont(p)
        raise FileNotFoundError(f"Nenalezen ZS{znum} v {self.font_dir}")

    def _wrap_line(self, font: ZSFont, text_line: str) -> List[List[Tuple[Image.Image, int, int]]]:
        """
        Rozdělí „logický“ řádek na více vizuálních řádků tak, aby se vešly do page_w.
        Vrací list řádků; každý řádek je list prvků (bmp, width, code).
        Zalomení preferuje mezeru, jinak zalomí „natvrdo“.
        """
        letter_space = self.letter_space_override if self.letter_space_override is not None else font.general_spacing_px
        max_inner = max(1, self.page_w - 2 * self.margin)

        # čistý text bez [značek]
        clean = BRACKET_TOKEN.sub("", text_line)

        seq: List[Tuple[Image.Image, int, int]] = []
        for ch in clean:
            g = font.get_glyph(ord(ch), msb_first=self.msb_first)
            if g:
                bmp, gw = g
                seq.append((bmp, gw, ord(ch)))

        lines: List[List[Tuple[Image.Image, int, int]]] = []
        i = 0
        while i < len(seq):
            start = i
            width = 0
            last_space = -1
            while i < len(seq):
                gw = seq[i][1]
                add = gw + (letter_space if i > start else 0)
                if width + add > max_inner:
                    break
                width += add
                if seq[i][2] == 0x20:  # space
                    last_space = i
                i += 1

            if i == start:
                i = start + 1  # nevejde se ani jeden znak -> vezmi alespoň první

            if last_space >= start and i < len(seq):
                # zalomení na poslední mezeře (mezera se nepřenáší)
                cut = last_space
                lines.append(seq[start:cut])
                i = last_space + 1
            else:
                lines.append(seq[start:i])

        return lines

    def _render_wrapped_lines(self, font: ZSFont, wrapped: List[List[Tuple[Image.Image, int, int]]]) -> List[Image.Image]:
        """Z (bmp,gw,code) složí obrázky jednotlivých řádků (už bez přetečení)."""
        letter_space = self.letter_space_override if self.letter_space_override is not None else font.general_spacing_px
        imgs: List[Image.Image] = []
        for row in wrapped:
            inner_w = sum(gw for (_b, gw, _c) in row) + (len(row)-1)*letter_space if row else 0
            width  = inner_w + 2*self.margin
            height = font.height_px + 2*self.margin
            img = Image.new("1", (max(1, width), max(1, height)), 1)
            x = self.margin; y = self.margin
            for idx, (bmp, gw, _code) in enumerate(row):
                img.paste(bmp, (x, y))
                x += gw + (letter_space if idx < len(row)-1 else 0)
            if self.scale != 1:
                img = img.resize((img.width*self.scale, img.height*self.scale), Image.NEAREST)
            imgs.append(img)
        return imgs

    def render_document(self, lines: List[str]) -> Image.Image:
        rendered_rows: List[Image.Image] = []
        for raw in lines:
            # font switch
            m = RE_FONT_SWITCH.match(raw)
            if m:
                self.current_font = self._load_zs(int(m.group(1)))
                continue

            # běžný řádek textu
            wrapped = self._wrap_line(self.current_font, raw)
            rendered_rows += self._render_wrapped_lines(self.current_font, wrapped)

        # Vykreslení na stránku (co se nevejde na výšku, se ořízne)
        out_w = self.page_w if self.scale == 1 else self.page_w * self.scale
        out_h = self.page_h if self.scale == 1 else self.page_h * self.scale
        page = Image.new("1", (out_w, out_h), 1)
        y = 0
        gap = self.line_gap * (self.scale if self.scale != 1 else 1)
        for row in rendered_rows:
            if y + row.height > page.height:
                break
            page.paste(row, (0, y))
            y += row.height + gap
        return page

# ---------------- Loader řádků ---------------------------
def load_editor_lines(path: Path) -> List[str]:
    """Vrátí seznam řádků; dělí pouze na '\n', aby 0x85 zůstal znakem."""
    text = load_editor_text(path)
    return to_lines(text)

# ---------------- CLI -----------------------------------
def main():
    ap = argparse.ArgumentParser(description="ZS typesetter (TXT/PRG) – výchozí ZS1, 640x800, wrap, 0x0D=NL, 0x85 neztratit.")
    ap.add_argument("--editor",    type=Path, required=True, help="Vstupní soubor (TXT nebo PRG).")
    ap.add_argument("--font-dir",  type=Path, required=True, help="Složka se ZS*.prg.")
    ap.add_argument("--out",       type=Path, required=True, help="Výstupní PNG (stránka).")

    ap.add_argument("--default-z", type=int, default=None, help="Výchozí ZS (implicitně 1).")
    ap.add_argument("--letter-space", type=int, default=None, help="Mezera mezi znaky (px neskalovaných). Default: dle ZS.")
    ap.add_argument("--line-gap",  type=int, default=1, help="Mezera mezi řádky (px neskalovaných).")
    ap.add_argument("--margin",    type=int, default=4, help="Vnitřní okraj řádku (px neskalovaných).")

    ap.add_argument("--scale",     type=int, default=2, help="Zvětšení (nearest).")
    ap.add_argument("--lsb-first", action="store_true", help="Bit order LSB->MSB (default MSB->LSB).")

    ap.add_argument("--page-w",    type=int, default=640, help="Šířka stránky (px před škálováním).")
    ap.add_argument("--page-h",    type=int, default=800, help="Výška stránky (px před škálováním).")
    args = ap.parse_args()

    lines = load_editor_lines(args.editor)
    ts = EditorTypesetter(
        font_dir=args.font_dir,
        default_z=args.default_z,     # pokud None -> uvnitř se nastaví na 1
        letter_space=args.letter_space,
        line_gap=args.line_gap,
        margin=args.margin,
        msb_first=not args.lsb_first,
        scale=args.scale,
        page_w=args.page_w,
        page_h=args.page_h
    )

    img = ts.render_document(lines)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    img.save(args.out)
    print(f"Hotovo: {args.out}")

if __name__ == "__main__":
    main()