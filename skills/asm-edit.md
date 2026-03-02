# Skill: asm-edit – Safe editing of ACME source files

## Purpose

Guidelines for AI agents editing the 6502 / ACME source files in `src/`
without breaking the Pagefox banking layout.

## Golden rules

1. **Never change `!pseudopc` boundaries** – the physical ROM layout is
   fixed by the Pagefox cartridge hardware. Shifting an address block by even
   one byte breaks all downstream jumps.

2. **Never reorder `!source` directives** in `pg_main.asm` – the include
   order determines the binary layout.

3. **Always rebuild and validate** after any change to `src/`:

   ```bash
   acme -I src --format plain --outfile build/tmp.bin \
        -DLANG=0 -DP24=0 src/pg_main.asm && \
   cartconv -t pf -i build/tmp.bin -o build/Pagefox-cs.crt && \
   test -s build/Pagefox-cs.crt && echo "Build OK"
   rm -f build/tmp.bin
   ```

4. **Preserve label naming** (`L0_`, `L2_` prefix + hex address) for all
   labels that correspond to known ROM addresses. New utility labels can use
   any naming but must not clash with existing ones.

5. **Conditional assembly flags** – the following dot-variables are set from
   the CLI (`-DFLAG=value`) and must not be hard-coded:

   | Variable | CLI flag | Default | Meaning |
   |----------|----------|---------|---------|
   | `.language` | `-DLANG=n` | 0 | 0=cs, 1=de |
   | `.pg24` | `-DP24=n` | 0 | 0=9pin, 1=24pin |
   | `.device` | — | `$08` | Default IEC device |
   | `.change_device` | — | 1 | Enable C= T device change |
   | `.sd2iec` | — | 1 | Enable SD2IEC patch |

## Safe zones for edits

| File | What you can safely change |
|------|---------------------------|
| `pg_colors.asm` | All colour byte values |
| `pg_cs.asm` | Keyboard mapping bytes, PETSCII char codes, string messages |
| `pg_de.asm` | Same as above for German |
| `pg_main.asm` | Values of `.device`, `.change_device`, `.sd2iec`, `.strobe_fix`, `.u64turbobit` |

## Editing string messages

Strings in `pg_cs.asm` / `pg_de.asm` are stored as PETSCII byte sequences,
usually `$00`-terminated. When editing:

- Keep the same byte length as the original (the layout has no dynamic sizing).
- Use the C64 PETSCII table for character codes (not ASCII).
- Diacritic characters use the project's custom charset mapping (see
  the comments in `pg_cs.asm`).

## Editing keyboard maps

The keyboard map is a lookup table of (PETSCII key code → internal char code)
pairs. When adding or changing a mapping:

1. Find the relevant table in `pg_cs.asm`.
2. Replace the byte pair, keeping table length identical.
3. Update the comment on the same line.
4. Test in VICE: boot the CRT and press the changed key.

## Adding a free-space feature (advanced)

Some areas contain `!initmem $FF` padding (dead ROM space). Small additions
can fit here:

1. Identify a run of `$FF` bytes in the assembled output (`xxd build/tmp.bin | grep -c 'ffff ffff ffff ffff'`).
2. Note the file offset and calculate the `!pseudopc` address.
3. Add a `; free space` labelled block at that position.
4. Ensure the feature does not extend past the block boundary.

## Disassembled vs. undisassembled sections

Large parts of `pg_main.asm` still contain raw `!by`/`!wo` sequences
(not yet reverse-engineered). **Do not modify these sections** without
understanding their purpose. Mark any new understanding with a comment:

```asm
; IDENTIFIED 2026-03-02: this is the font menu title printer
```

## After editing

- Run `acme -v …` for verbose output to spot relocation issues.
- Check that `build/Pagefox-cs.crt` boots in VICE (`x64sc -cartcrt …`).
- If VICE hangs or shows a black screen, the banking layout is likely broken.
