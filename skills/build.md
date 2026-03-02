# Skill: build – Assemble and validate all CRT variants

## Purpose

Assemble all four Pagefox cartridge variants (cs/de × 9pin/24pin) and verify
that the resulting `.crt` files are non-empty and structurally valid.

## Prerequisites

```bash
sudo apt-get install -y acme vice
```

## Steps

### 1. Prepare output directory

```bash
mkdir -p build
```

### 2. Assemble each variant

Repeat for each `(LANG, P24)` combination:

| LANG | P24 | Suffix |
|------|-----|--------|
| 0    | 0   | `Pagefox-cs` |
| 0    | 1   | `Pagefox-cs-24pin` |
| 1    | 0   | `Pagefox-de` |
| 1    | 1   | `Pagefox-de-24pin` |

```bash
# Example: Czech 9-pin
acme -I src --format plain --outfile build/tmp.bin \
     -DLANG=0 -DP24=0 src/pg_main.asm

cartconv -t pf -i build/tmp.bin -o build/Pagefox-cs.crt
rm build/tmp.bin

# Verify non-empty
test -s build/Pagefox-cs.crt && echo "OK" || echo "FAIL"
```

### 3. Check CRT header (optional)

A valid Pagefox `.crt` starts with the ASCII string `C64 CARTRIDGE`:

```bash
head -c 16 build/Pagefox-cs.crt | od -c | head -1
```

### 4. Run VICE screenshot validation (headless)

```bash
xvfb-run -a x64sc \
  -kernal ci/roms/kernal-901227-03.bin \
  -basic  ci/roms/basic-901226-01.bin \
  -chargen ci/roms/chargen-901225-01.bin \
  -limitcycles 4926240 \
  -exitscreenshot build/Pagefox-cs.png \
  -cartcrt build/Pagefox-cs.crt
```

Exit codes 0 and 1 are both acceptable (VICE quirk).

## Success criteria

- All four `.crt` files exist and are non-empty (`test -s`).
- CRT header starts with `C64 CARTRIDGE`.
- VICE screenshot produces a non-empty `.png`.
- No ACME errors or warnings in stderr.

## What NOT to do

- Do not commit `build/` or `*.bin` files.
- Do not pass `-t` values other than `pf` to `cartconv`.
- Do not run with `--format cbm` (wrong output format for Pagefox).
