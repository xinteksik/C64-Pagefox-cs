# AGENTS.md – C64-Pagefox-cs

> AI agent instructions for this repository.
> Follows the [agents.md](https://agentskills.io) convention.

---

## Project overview

**C64-Pagefox-cs** is a Czech (and German) localisation of the **Pagefox DTP
cartridge** for the Commodore 64 and Commodore 128, originally created by
Scanntronik in 1987. The project produces a Pagefox-format `.crt` file that
can be used with real hardware or an emulator (VICE).

Repository: <https://github.com/xinteksik/C64-Pagefox-cs>
License: MIT

---

## Repository layout

```
C64-Pagefox-cs/
├── src/                   # ACME assembler sources (LANG=0 cs, LANG=1 de)
│   ├── pg_main.asm        # Root source – include point, build switches
│   ├── pg_cs.asm          # Czech keyboard / char mapping
│   ├── pg_de.asm          # German keyboard / char mapping
│   ├── pg_kernal.asm      # KERNAL address equates
│   ├── pg_colors.asm      # Default colour palette
│   ├── pg_24.asm          # 24-pin printer driver (optional)
│   ├── pg_sd2iec.asm      # SD2IEC / SoftIEC patch (optional)
│   ├── zs-cs.bin          # Pre-built Czech font bank (binary)
│   ├── zs-de.bin          # Pre-built German font bank (binary)
│   └── old/               # Historical drafts – do not touch
├── fonts/
│   ├── prg/               # Individual ZS font files (.prg)
│   ├── png/               # PNG previews of each font
│   └── README.md
├── charfox/               # Patched CHARACTER FOX utility
├── tools/                 # Python helper scripts (see below)
├── docs/                  # Czech manual PDF + memory map
├── .github/
│   └── workflows/
│       └── ci.yml         # Build + CRT conversion + VICE screenshot CI
├── skills/                # Agent skill definitions
├── AGENTS.md              # This file
├── CLAUDE.md              # Claude-specific instructions
└── .github/copilot-instructions.md
```

---

## Tech stack

| Component | Details |
|-----------|---------|
| Assembler | **ACME** v0.97, 6502 dialect |
| Output format | Pagefox cartridge `.crt` via `cartconv -t pf` (VICE toolchain) |
| Language flags | `-DLANG=0` (cs) / `-DLANG=1` (de); `-DP24=0/1` (24-pin printer) |
| Python tools | Python 3.x scripts in `tools/` – font utilities, image converters |
| CI | GitHub Actions (ubuntu-latest), ACME + VICE from `apt` |
| Editor | VS Code + GitHub Codespaces |

---

## Build

### Prerequisites (Linux / Codespaces)

```bash
sudo apt-get install -y acme vice
```

### Manual build – Czech 9-pin

```bash
mkdir -p build
acme -I src --format plain --outfile build/tmp.bin \
     -DLANG=0 -DP24=0 src/pg_main.asm
cartconv -t pf -i build/tmp.bin -o build/Pagefox-cs.crt
rm build/tmp.bin
```

### Variants

| `LANG` | `P24` | Output name suffix |
|--------|-------|--------------------|
| 0 (cs) | 0     | `Pagefox-cs-<ver>.crt` |
| 0 (cs) | 1     | `Pagefox-cs-<ver>-24pin.crt` |
| 1 (de) | 0     | `Pagefox-de-<ver>.crt` |
| 1 (de) | 1     | `Pagefox-de-<ver>-24pin.crt` |

CI builds all four variants automatically on every push to `main` or on a
pull-request that changes `src/**`.

---

## Key source conventions (ACME 6502)

- Labels prefixed `L0_` live in EPROM 79 Bank 0 (text editor, $8000–$BFFF)
- Labels prefixed `L2_` live in EPROM 79 Bank 1 (graphic / layout editor)
- Build-time flags are dot-variables: `.language`, `.pg24`, `.device`, …
- `!source` includes are relative to the `src/` directory (pass `-I src`)
- `!initmem $FF` fills unused bytes with `$FF` (EPROM default)
- Binary blobs are included with `!binary`; never commit generated `.crt` or
  intermediate `.bin` files

### Bankswitching register `$DE80`

| Value | Active chip | Bank |
|-------|------------|------|
| `$00` | EPROM 79   | 0 – text editor (L0_) |
| `$02` | EPROM 79   | 1 – graphic/layout editor (L2_) |
| `$04` | ZS3        | 0 – charset lower half |
| `$06` | ZS3        | 1 – charset upper half |
| `$08` | Cart RAM   | 0 – lower 16 KB |
| `$0A` | Cart RAM   | 1 – upper 16 KB |

Full memory map: [`docs/pagefox_memory_map.md`](docs/pagefox_memory_map.md)

---

## Python tools in `tools/`

| Script | Purpose |
|--------|---------|
| `zs_viewer.py` | Load ZS font, export PNG preview (batch-capable) |
| `extract_zs.py` | Unpack fonts from a ZS BIN container |
| `unrle.py` | Decompress RLE-encoded ZS files to raw |
| `joinzs_fix.py` | Repack selected ZS files into a BIN bank |
| `pagefox_text_editor_cs.py` | Text editor for Pagefox `.pt` files with Czech mapping |
| `zs_typesetter.py` | Render PT text with ZS fonts → PNG |
| `convert_prg_to_png.py` | Decode Pagefox PG / Printfox BS/GB → PNG |
| `convert_png_to_prg.py` | Encode PNG → PG / BS / GB with RLE |
| `char_editor_8x8.py` | Interactive 8×8 character editor |
| `chars_hex_editor.py` | Hex-level char data editor |
| `patch_at_offset.py` | Patch binary at a specific offset (charfox) |

---

## Agent skills

Defined in [`skills/`](skills/). Each `.md` file describes one skill that an
agent can invoke:

| Skill file | What it does |
|-----------|-------------|
| `skills/build.md` | Assemble all variants and validate CRT files |
| `skills/font-tools.md` | Work with ZS font files using Python tools |
| `skills/asm-edit.md` | Conventions for editing ACME source files safely |
| `skills/release.md` | Tag a release and trigger the CI release job |

---

## Security rules for agents

Working on a **public repository** – the following rules are non-negotiable:

1. **Never commit secrets** – no API keys, passwords, tokens, or personal
   data. Use GitHub Actions secrets for CI credentials.
2. **Never commit build artefacts** – `.crt`, `*.bin` (intermediate),
   `build/` directory. Only source files belong in git.
3. **Never modify CI permissions** beyond what is already declared in
   `ci.yml`. The `contents: write` scope is restricted to the `release` job.
4. **Binaries in `tools/`** (`ACME.exe`, `python39.dll`) are Windows
   convenience copies – do not update them without explicit human approval.
5. **Do not run Python tools with `--overwrite` on binary assets** without
   first backing them up or staging them in git.
6. **All changes to `src/` must pass the CI build** before merging. Do not
   merge a PR with a failing build job.

---

## Contribution workflow

```
main  ──► feature/xyz  ──► PR (CI passes) ──► merge to main
```

For a release:
```bash
git tag v2.6.1
git push origin v2.6.1
```
This triggers the `release` job, which publishes all four `.crt` artefacts to
the GitHub Release page automatically.

---

## Out of scope for agents

- Do **not** attempt to reverse-engineer sections of `pg_main.asm` that are
  not yet disassembled (marked as raw `!by` / `!wo` sequences).
- Do **not** modify `zs-cs.bin` or `zs-de.bin` directly – use the Python font
  tools instead.
- Do **not** alter the Pagefox original algorithm or binary layout in a way
  that would break compatibility with the real Pagefox cartridge ROM banking
  hardware.
