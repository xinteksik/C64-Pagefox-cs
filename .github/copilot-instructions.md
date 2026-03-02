# GitHub Copilot Instructions – C64-Pagefox-cs

## Project context

This is a **6502 assembler** project targeting the **Commodore 64/128**. The
assembler dialect is **ACME v0.97**. The output is a Pagefox cartridge image
(`.crt`) produced by `cartconv -t pf` from the VICE toolchain.

Full project description: see [`AGENTS.md`](../AGENTS.md).

---

## Language and syntax rules

- All assembler files use the **ACME** directive syntax (not `ca65`, not `dasm`).
- Directives begin with `!` (`!by`, `!wo`, `!source`, `!pseudopc`, `!binary`,
  `!ifdef`, `!macro`, `!initmem`).
- Labels follow the pattern `L0_8031`, `L2_9972` (bank prefix + hex address).
- Dot-variables (`.language`, `.pg24`) are build-time constants – do not use
  them as runtime variables.
- Comments use `;` – always written in **English**.

### Do not suggest

- `ca65` or `dasm` syntax (`.proc`, `.byte`, `.word`, etc.)
- `org` or `*=` directives (ACME uses `!pseudopc`)
- Absolute file paths in source includes (use `-I src` flag + relative names)

---

## Python tools

- Python 3.9+, standard library preferred.
- Image processing uses **Pillow** (`from PIL import Image`).
- CLI argument parsing uses `argparse`.
- Scripts in `tools/` are **standalone** – no shared modules, no setup.py.
- All file paths come from CLI arguments, never hard-coded.

---

## File roles (do not confuse)

| File | Role |
|------|------|
| `src/pg_main.asm` | **Entry point** – only `!source` includes and build flags |
| `src/pg_cs.asm` | Czech char/keyboard mapping – PETSCII bytes |
| `src/pg_colors.asm` | Colour palette constants |
| `src/zs-cs.bin` | Binary blob – **never edit by hand**, use font tools |

---

## Build command (Linux / Codespaces)

```bash
acme -I src --format plain --outfile build/tmp.bin \
     -DLANG=0 -DP24=0 src/pg_main.asm && \
cartconv -t pf -i build/tmp.bin -o build/Pagefox-cs.crt && \
rm build/tmp.bin
```

---

## Commit scope keywords

`src` | `fonts` | `tools` | `docs` | `ci` | `charfox`

---

## Security

- Never suggest committing `.crt`, `build/`, or `*.bin` intermediate files.
- Never suggest storing credentials or tokens in source files.
- Do not suggest changing `permissions:` in `ci.yml` without a clear reason.
