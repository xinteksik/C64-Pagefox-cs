# Skill: font-tools – Work with ZS font files

## Purpose

Create, inspect, edit, and repack Pagefox ZS font files using the Python
utilities in `tools/`. Fonts are stored in Pagefox's proprietary ZS format
(derived from Printfox) and embedded in `src/zs-cs.bin` or `src/zs-de.bin`.

## Font pipeline overview

```
CHARACTER FOX (C64) → .prg (RLE compressed)
        ↓  unrle.py
    raw .prg  ←→  char_editor_8x8.py  (interactive edit)
        ↓  zs_viewer.py
    PNG preview
        ↓  joinzs_fix.py
    zs-cs.bin  →  included in build via !binary
```

## Scripts

### View a single font

```bash
python3 tools/zs_viewer.py fonts/prg/zs1.prg
# With sample text:
python3 tools/zs_viewer.py fonts/prg/zs1.prg --text "Příliš žluťoučký kůň"
```

### Decompress RLE font

CHARACTER FOX saves fonts with RLE compression. Decompress before editing:

```bash
python3 tools/unrle.py fonts/prg/zs1.prg zs1_raw.prg
```

### Extract all fonts from a BIN bank

```bash
python3 tools/extract_zs.py src/zs-cs.bin --out-dir /tmp/fonts_extracted/
```

Fonts are named by their internal header (e.g., `zs1.prg`, `zs40.prg`).

### Repack fonts into a BIN bank

The list of fonts to embed is a **deliberate subset** of `fonts/prg/` – not every
font in that folder belongs in `zs-cs.bin`. For example, `zs105.prg` exists in
`fonts/prg/` but was intentionally excluded from the current Czech build.

```bash
python3 tools/joinzs_fix.py \
  --first-start '$0031' \
  --out src/zs-cs.bin \
  zs1.prg zs2.prg zs3.prg zs4.prg zs5.prg \
  zs10.prg zs21.prg zs30.prg zs31.prg zs40.prg \
  zs101.prg zs111.prg zs139.prg zs156.prg zs161.prg \
  zs193.prg zs201.prg zs202.prg zs210.prg zs211.prg
```

> **Note:** The list above reflects the current `zs-cs.bin` build set. Adjust it
> freely – just make sure the total size of all fonts fits within two 16 KB banks
> (32 KB combined).

**Required minimum fonts:** ZS1, ZS2, ZS40.

### Convert image ↔ Pagefox/Printfox format

```bash
# PRG → PNG
python3 tools/convert_prg_to_png.py tools/PG/pagefox.prg --out pagefox.png

# PNG → PRG (Pagefox PG format)
python3 tools/convert_png_to_prg.py image.png --format PG --out output.pg.prg

# PNG → PRG (Printfox BS 320×200)
python3 tools/convert_png_to_prg.py image.png --format BS --out output.bs.prg
```

## ZS format notes

- Each font file starts with a 16-byte header containing the font name and
  character spacing value.
- The spacing value must be `> 0` for Pagefox to display fonts correctly.
  Use `cfox-cs.prg` (CHARACTER FOX) to set/save spacing.
- Fonts are stored in two banks in `zs-cs.bin`: the BIN is split at the
  midpoint; first half fills one 16 KB bank, second half fills the other.

## Verification

After repacking, do a round-trip test:

```bash
# Extract, decompress a font, save with cfox, decompress again, diff
python3 tools/extract_zs.py src/zs-cs.bin --out-dir /tmp/before/
# [edit with CHARACTER FOX in VICE emulator]
python3 tools/unrle.py /tmp/after/zs1.prg /tmp/after/zs1_raw.prg
diff /tmp/before/zs1_raw.prg /tmp/after/zs1_raw.prg
```

## What NOT to do

- Never hand-edit `src/zs-cs.bin` or `src/zs-de.bin` as raw bytes.
- Do not use RLE-compressed fonts directly in `joinzs_fix.py` – decompress
  with `unrle.py` first.
- Do not add fonts that are missing the `--first-start` parameter; the
  resulting BIN will fail to load.
