# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project overview

Czech (and German) localisation of the **Pagefox DTP cartridge** for Commodore 64/128. Produces a Pagefox-format `.crt` via ACME 6502 assembler + `cartconv -t pf`. Four build variants: cs/de × 9-pin/24-pin.

---

## Build

### Prerequisites

```bash
sudo apt-get install -y acme vice
```

### Build a single variant

```bash
mkdir -p build
acme -I src --format plain --outfile build/tmp.bin \
     -DLANG=0 -DP24=0 src/pg_main.asm
cartconv -t pf -i build/tmp.bin -o build/Pagefox-cs.crt
rm build/tmp.bin
```

Flags: `-DLANG=0` = Czech, `-DLANG=1` = German; `-DP24=0` = 9-pin, `-DP24=1` = 24-pin.

### Verify CRT is valid

```bash
test -s build/Pagefox-cs.crt && echo "OK"
head -c 16 build/Pagefox-cs.crt | od -c | head -1   # must start with "C64 CARTRIDGE"
```

Never commit `build/` or `*.bin` files.

---

## Architecture

### Physical ROM file layout (`pg_main.asm`)

| File offset   | pseudopc       | EPROM | Bank | Content |
|---------------|----------------|-------|------|---------|
| `$0000–$1FFF` | `$8000–$9FFF`  | 79    | 0    | Text editor, vizawrite map, init, keyboard map. Labels: `L0_8xxx` |
| `$2000–$2FFF` | `$A000–$AFFF`  | 79    | 0    | Reset, font menu, message table. Labels: `L0_Axxx` |
| `$3000–$3FFF` | `$B000–$BFFF`  | 79    | 0    | Copied to RAM `$0800–$17FF` at boot: char defs, bankswitch thunks, IRQ, print routines. Labels: `L0_Bxxx` |
| `$4000–$7FFF` | `$8000–$BFFF`  | 79    | 1    | Graphic editor, layout editor. Labels: `L2_8xxx` |
| `$8000–$BFFF` | `$8000–$BFFF`  | ZS3   | 0    | Character sets lower half (`zs-cs.bin` / `zs-de.bin`) |
| `$C000–$FFFF` | `$8000–$BFFF`  | ZS3   | 1    | Character sets upper half |

### Bankswitching register `$DE80` (write-only, I/O1 space)

| Value | Active chip | Bank | Code area |
|-------|-------------|------|-----------|
| `$00` | EPROM 79    | 0    | Text editor / menu (`L0_`) |
| `$02` | EPROM 79    | 1    | Graphic / layout editor (`L2_`) |
| `$04` | ZS3         | 0    | Charset lower half |
| `$06` | ZS3         | 1    | Charset upper half |
| `$08` | Cart RAM    | 0    | Lower 16 KB (cart enabled) |
| `$0A` | Cart RAM    | 1    | Upper 16 KB (cart enabled) |
| `$88` | Cart RAM    | 0    | Cart disabled (writes still work) |

Shadow register: zero-page `$42` = current `$DE80` value; `$43` = saved value for restore.

### RAM block `$0800–$17FF`

ROM `$B000–$BFFF` is copied here at boot. This block always stays accessible regardless of active bank and contains:
- Bankswitch thunks at `$0FD0`, `$0FDC`, `$0FE8`, `$0FF4`, `$0FFA`
- Editor-switching trampolines at `$0DA8–$0DB9` (must run from RAM because they switch banks mid-execution)
- IRQ handler, cursor blink, print routines

---

## Source file map

| File | Content |
|------|---------|
| `src/pg_main.asm` | Root: `!source` includes + build-switch variables – do not reorder |
| `src/pg_cs.asm` | Czech keyboard map, diacritic char codes, Vizawrite mapping |
| `src/pg_de.asm` | German keyboard / char mapping |
| `src/pg_en.asm` | English keyboard map – `LANG=2`, not yet implemented |
| `src/pg_kernal.asm` | C64 KERNAL address equates (read-only reference) |
| `src/pg_colors.asm` | Default colour registers – safe to edit |
| `src/pg_24.asm` | 24-pin printer driver (conditional via `.pg24`) |
| `src/pg_sd2iec.asm` | SD2IEC/SoftIEC patch (conditional via `.sd2iec`) |
| `src/zs-cs.bin` | Binary font bank Czech – generate with Python tools, never hand-edit |
| `src/zs-de.bin` | Binary font bank German – same rule |
| `src/old/` | Historical drafts – do not touch |

---

## ACME dialect cheat-sheet

```asm
!source "file.asm"     ; include another source file
!initmem $FF           ; fill unused bytes with $FF (EPROM default)
!pseudopc $8000 { }    ; assemble as if at address $8000
!binary "file.bin"     ; embed binary blob verbatim
!ifdef FLAG { }        ; conditional assembly
!macro Name { }        ; macro definition
+Name                  ; macro invocation
!by $xx,$xx,...        ; define bytes
!wo $xxxx              ; define word (little-endian)
.variable = value      ; dot-variable (build-time constant)
```

Do not use `ca65`/`dasm` syntax (`org`, `*=`, `.proc`, `.byte`, `.word`).

---

## Editing guidelines

1. Always run a full build (`acme … && cartconv …`) before marking a task done.
2. Preserve `!pseudopc` block boundaries – binary layout is fixed by hardware.
3. New strings/messages: follow existing format in `pg_cs.asm` (PETSCII bytes, `$00`-terminated).
4. **All comments in `.asm` files must be written in English.** Discussion with the user may be in Czech.

---

## Font workflow (ZS files)

```
CHARACTER FOX (C64) → .prg (RLE)  →  unrle.py  →  raw .prg
raw .prg  →  zs_viewer.py  →  PNG preview
raw .prg  →  joinzs_fix.py  →  zs-cs.bin  →  !binary in build
```

### Common tool commands

```bash
# Preview a font
python3 tools/zs_viewer.py fonts/prg/zs1.prg --text "Příliš žluťoučký kůň"

# Decompress RLE-encoded font (required before editing or repacking)
python3 tools/unrle.py fonts/prg/zs1.prg zs1_raw.prg

# Extract all fonts from a BIN bank
python3 tools/extract_zs.py src/zs-cs.bin --out-dir /tmp/fonts/

# Repack fonts into a BIN bank (always pass --first-start $0031)
python3 tools/joinzs_fix.py --first-start '$0031' --out src/zs-cs.bin \
  zs1.prg zs2.prg zs40.prg ...

# Convert Pagefox/Printfox image files
python3 tools/convert_prg_to_png.py tools/PG/pagefox.prg --out pagefox.png
python3 tools/convert_png_to_prg.py image.png --format PG --out output.pg.prg
```

Required minimum fonts in `zs-cs.bin`: **ZS1, ZS2, ZS40**. Total must fit in 2× 16 KB banks. Note: `zs105.prg` exists in `fonts/prg/` but is intentionally excluded from the current build.

---

## Dangerous operations – ask before proceeding

- Changing `!initmem` value or `!pseudopc` offsets → breaks banking.
- Modifying `src/zs-cs.bin` / `src/zs-de.bin` in place → use font tools.
- Deleting any `!source` line from `pg_main.asm` → likely breaks build.
- Changing `cartconv -t pf` to any other type → incompatible with Pagefox HW.
- Adding binary files (`.exe`, `.dll`, `.prg`) to the repo → needs explicit human approval.
- Changing `permissions:` blocks in `ci.yml` → needs human approval.

---

## CI pipeline

File: `.github/workflows/ci.yml`

Triggers: push to `main` or PR touching `src/**` or `.github/workflows/**`; also `v*` tags.

Jobs:
1. **build** (4-variant matrix) – assembles, runs `cartconv`, takes VICE headless screenshot, uploads `.crt` + `.png`.
2. **release** (tag only) – downloads artefacts, publishes GitHub Release.

---

## Commit message convention

```
<type>(<scope>): <short summary>

Types: feat | fix | refactor | docs | ci | chore
Scopes: src | fonts | tools | docs | ci | charfox
```

---

## Useful VICE commands for debugging

```bash
# Run in emulator:
x64sc -cartcrt build/Pagefox-cs.crt

# VICE monitor inside emulator:
m $de80 $de80        # show bankswitching register state
break .L0_8031       # set breakpoint at label
```

---

## References

- Memory map: [`docs/pagefox_memory_map.md`](docs/pagefox_memory_map.md)
- Agent skills: [`skills/`](skills/) (`build.md`, `font-tools.md`, `asm-edit.md`, `release.md`)
- Full agent docs: [`AGENTS.md`](AGENTS.md)
- ACME documentation: <https://sourceforge.net/p/acme-crossass/code-0/>
- Pagefox wiki: <https://www.c64-wiki.de/wiki/Pagefox>
