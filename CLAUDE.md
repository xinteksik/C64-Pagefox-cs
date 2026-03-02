# CLAUDE.md – Instructions for Claude

This file tells Claude how to work effectively in the **C64-Pagefox-cs**
repository. Read `AGENTS.md` first for the full project description.

---

## Quick-start summary

- **Language:** ACME 6502 assembler + Python 3
- **Goal:** Build a Pagefox `.crt` cartridge for Commodore 64/128
- **Entry point:** `src/pg_main.asm` (assembles with `acme -I src`)
- **Output:** `build/Pagefox-<lang>-<ver>[-24pin].crt` (via `cartconv -t pf`)
- **CI:** `.github/workflows/ci.yml` – runs on every push/PR to `src/**`

---

## How to build locally (Codespaces / Linux)

```bash
sudo apt-get install -y acme vice

mkdir -p build
acme -I src --format plain --outfile build/tmp.bin \
     -DLANG=0 -DP24=0 src/pg_main.asm
cartconv -t pf -i build/tmp.bin -o build/Pagefox-cs.crt
rm build/tmp.bin
```

For the 24-pin variant: use `-DP24=1`.
For German: use `-DLANG=1`.
Never commit `build/` or `*.bin` files.

---

## Source file map (read before editing)

| File | Content |
|------|---------|
| `src/pg_main.asm` | Root: `!source` includes + build-switch variables |
| `src/pg_cs.asm` | Czech keyboard map, diacritic char codes, Vizawrite mapping |
| `src/pg_de.asm` | German keyboard / char mapping |
| `src/pg_en.asm` | English keyboard / char mapping – referenced by `LANG=2`, not yet implemented |
| `src/pg_kernal.asm` | C64 KERNAL address equates (read-only reference) |
| `src/pg_colors.asm` | Default colour registers – safe to edit |
| `src/pg_24.asm` | 24-pin printer driver (conditional via `.pg24`) |
| `src/pg_sd2iec.asm` | SD2IEC/SoftIEC patch (conditional via `.sd2iec`) |
| `src/zs-cs.bin` | Binary font bank Czech – generate with Python tools, never hand-edit |
| `src/zs-de.bin` | Binary font bank German – same rule |

---

## ACME dialect cheat-sheet

```asm
!source "file.asm"     ; include another source file
!initmem $FF           ; fill unused bytes with $FF
!pseudopc $8000 {      ; assemble as if at address $8000
    ...
}
!binary "file.bin"     ; embed binary blob verbatim
!ifdef FLAG { ... }    ; conditional assembly
!macro Name { ... }    ; macro definition
+Name                  ; macro invocation
!by $xx,$xx,...        ; define bytes
!wo $xxxx              ; define word (little-endian)
.variable = value      ; dot-variable (build-time constant)
```

Label prefixes used in this project:

| Prefix | Bank | Location |
|--------|------|---------|
| `L0_8xxx` | EPROM 79 bank 0 | `$8000–$9FFF` – text editor |
| `L0_Axxx` | EPROM 79 bank 0 | `$A000–$AFFF` – init, font menu |
| `L0_Bxxx` | EPROM 79 bank 0 | `$B000–$BFFF` → copied to RAM `$0800–$17FF` |
| `L2_8xxx` | EPROM 79 bank 1 | `$8000–$BFFF` – graphic / layout editor |

---

## Editing guidelines

### Assembler sources

1. Always test a build (`acme … && cartconv …`) before marking a task done.
2. Preserve `!pseudopc` block boundaries – the binary layout is fixed by
   the Pagefox ROM banking hardware.
3. When adding new strings/messages, follow the existing format in `pg_cs.asm`
   (PETSCII bytes, terminated with `$00`).
4. Do not re-order `!source` lines in `pg_main.asm`.

### Python tools

- Run with Python 3.9+.
- Tools in `tools/` are standalone scripts; no virtual environment is needed
  for most of them (standard library only, except `Pillow` for PNG tools).
- Install Pillow if needed: `pip install Pillow`
- Input/output paths are always passed as CLI arguments – do not hard-code
  paths inside scripts.

### Font workflow (ZS files)

```
charfox (CHARACTER FOX) → .prg  →  unrle.py  →  raw .prg
raw .prg  →  zs_viewer.py  →  PNG preview
raw .prg  →  joinzs_fix.py --first-start $0031  →  zs-cs.bin
```

Minimum fonts required in `zs-cs.bin`: ZS1, ZS2, ZS40.

---

## Dangerous operations – ask before proceeding

- Changing `!initmem` value or `!pseudopc` offsets → breaks banking.
- Modifying `src/zs-cs.bin` / `src/zs-de.bin` in place → use font tools.
- Deleting any `!source` line from `pg_main.asm` → likely breaks build.
- Changing `cartconv -t pf` to any other type → incompatible with Pagefox HW.
- Adding binary files (`.exe`, `.dll`, `.prg`) to the repo → needs explicit
  human approval.

---

## CI pipeline summary

File: `.github/workflows/ci.yml`

Triggers: push to `main` or PR when `src/**` changes, or on `v*` tags.

Jobs:
1. **build** (matrix: 4 variants) – assembles with ACME, converts with
   `cartconv`, runs VICE headless screenshot validation, uploads `.crt` +
   `.png` artefacts.
2. **release** (on `v*` tag only) – downloads artefacts and publishes to
   GitHub Release.

Permissions: `contents: read` (build job), `contents: write` (release job only).

Do not change the `permissions:` blocks without human approval.

---

## Commit message convention

```
<type>(<scope>): <short summary>

Types: feat | fix | refactor | docs | ci | chore
Scopes: src | fonts | tools | docs | ci | charfox

Examples:
feat(src): add Ú character to Czech keyboard map
fix(fonts): correct ZS161 uppercase diacritic spacing
docs(docs): update memory map for $0FF4 trampoline
ci: cache VICE ROMs between workflow runs
```

---

## Useful VICE commands for debugging

```bash
# Run in emulator with cartridge:
x64sc -cartcrt build/Pagefox-cs.crt

# VICE monitor inside emulator:
m $de80 $de80        # show bankswitching register state
break .L0_8031       # set breakpoint at label
```

---

## References

- ACME documentation: <https://sourceforge.net/p/acme-crossass/code-0/>
- Pagefox wiki: <https://www.c64-wiki.de/wiki/Pagefox>
- VICE cartconv: `cartconv --help`
- Memory map: [`docs/pagefox_memory_map.md`](docs/pagefox_memory_map.md)
- Full agent docs: [`AGENTS.md`](AGENTS.md)
