# PAGEFOX Cartridge – Complete Memory Map (draft)

## 1. Hardware overview

- **EPROM "79"**: 32 KB (2× 16 KB banks) – main application code
- **EPROM "ZS3"**: 32 KB (2× 16 KB banks) – character sets
- **Cart RAM**: 32 KB (2× 16 KB banks) – document working data
- **Total**: 96 KB (64 KB ROM + 32 KB RAM)
- **Mode**: C64 16K Game Mode (ROML = $8000–$9FFF, ROMH = $A000–$BFFF)

---

## 2. Physical ROM file layout (pg_main.asm)

The output file corresponds to two 32 KB EPROMs stored sequentially:

| File offset   | Size  | pseudopc       | EPROM | Bank | Content                                                                       |
|---------------|-------|----------------|-------|------|-------------------------------------------------------------------------------|
| `$0000-$1FFF` | 8 KB  | `$8000-$9FFF`| 79    | 0    | Text editor, vizawrite map, coldstart init, ram copy, keyboard map, some free space (viza cs). Labels: `L0_8xxx`|
| `$2000-$2FFF` | 4 KB  | `$A000-$AFFF`| 79    | 0    | Init, reset, font menu in Text editor, message table, some free space (pg-24). Labels: `L0_Axxx`|
| `$3000-$3FFF` | 4 KB  | `$B000-$BFFF`| 79    | 0    | Copied to RAM $0800-$17FF at boot. Char defs, jsr, bankswitch thunks, IRQ handler, print routines, some free space. Labels: `L0_Bxxx` |
| `$4000-$7FFF` | 16 KB  | `$8000-$BFFF`| 79    | 1    | Graphic editor, Layout editor, menu graphics. Labels: `L2_8xxx`|
| `$8000-$BFFF` | 16 KB |  `$8000-$BFFF`| ZS3   | 0    | Character sets lower half (zs-cs.bin / zs-de.bin)|
| `$C000-$FFFF` | 16 KB | `$8000-$BFFF`| ZS3   | 1    | Character sets upper half|

---

## 3. Register $DE80 – bankswitching

The register is **write-only**, mapped into the range $DE80–$DEFF (I/O1 space).

### Bit structure

```
  Bit:   7  6  5  4  3  2  1  0
         ─  ─  ─  ┬  ┬──┬  ┬  ─
         x  x  x  │  │  │  │  x
                  │  └──┘  │
                  │ chip   │
                  │ select bank
                  │        select
                  cartridge
                  enable/disable
```

| Bit   | Function                                                               |
|-------|------------------------------------------------------------------------|
| 0     | unused                                                                 |
| 1     | **Bank select**: 0 = lower, 1 = upper                                  |
| 3:2   | **Chip select**: 00 = EPROM 79, 01 = ZS3, 10 = RAM, 11 = empty space  |
| 4     | **Cart enable**: 0 = enabled, 1 = disabled (note: RAM writes still work!) |
| 7:5   | unused                                                                 |

### $DE80 value table

| Value | Binary     | Chip     | Bank  | Result                                            |
|-------|------------|----------|-------|---------------------------------------------------|
| `$00` | `00000000` | EPROM 79 | lower | **L0_** code: text editor, menu, KERNAL           |
| `$02` | `00000010` | EPROM 79 | upper | **L2_** code: graphic editor, layout editor       |
| `$04` | `00000100` | ZS3      | lower | Character sets – lower half                       |
| `$06` | `00000110` | ZS3      | upper | Character sets – upper half                       |
| `$08` | `00001000` | RAM      | lower | Cart RAM lower 16 KB (read/write, cart enabled)   |
| `$0A` | `00001010` | RAM      | upper | Cart RAM upper 16 KB (read/write, cart enabled)   |
| `$0C` | `00001100` | empty    | lower | Idle – reads return VIC-II data                   |
| `$88` | `10001000` | RAM      | lower | Cart RAM lower, cartridge disabled (writes OK)    |
| `$8A` | `10001010` | RAM      | upper | Cart RAM upper, cartridge disabled (writes OK)    |
| `$FF` | `11111111` | —        | —     | Fully disabled (RAM writes blocked too)           |

---

## 4. CPU view – C64 address space

In 16K Game Mode the cartridge occupies $8000–$9FFF (ROML) and $A000–$BFFF (ROMH).

```
$FFFF ┌─────────────────────────────────┐
      │ KERNAL ROM                      │
$E000 ├─────────────────────────────────┤
      │ I/O area                        │
      │ $DE80 = bankswitch register     │
$D000 ├─────────────────────────────────┤
      │ C64 RAM / I/O                   │
$C000 ├═══════════════════════════════╤═╡
      │                               │ │
      │ ROMH – cartridge ROM/RAM      │ │
      │ (upper 8 KB of active bank)   │ │
      │                               │ │
$A000 ├───────────────────────────────┤ │
      │                               │B│
      │ ROML – cartridge ROM/RAM      │A│
      │ (content depends on $DE80)    │N│
      │                               │K│
      │ $DE80=$00 → EPROM 79 lower    │S│
      │ $DE80=$02 → EPROM 79 upper    │W│
      │ $DE80=$04 → ZS3 lower         │I│
      │ $DE80=$06 → ZS3 upper         │T│
      │ $DE80=$08 → Cart RAM lower    │C│
      │ $DE80=$0A → Cart RAM upper    │H│
      │                               │E│
      │                               │D│
$8000 ├═══════════════════════════════╧═╡
      │ Bitmap / VIC-II data            │
$4000 ├─────────────────────────────────┤
      │ Free RAM / working buffers      │
$1800 ├═════════════════════════════════┤
      │ *** COPY FROM ROM $B000 ***     │
      │ Character data (InsertChars)    │
      │ $0800–$0D9F                     │
      │                                 │
      │ Editor-switching trampolines    │
      │ $0DA8–$0DCx                     │
      │                                 │
      │ IRQ handler, cursor blink       │
      │ $0E50+                          │
      │                                 │
      │ Print routines                  │
      │ $0Fxx                           │
      │                                 │
      │ Bankswitch thunks:              │
      │   $0FD0 = restore bank ($43/$45)│
      │   $0FDC = map EPROM 79 upper    │
      │           (L2_, $02 → $DE80)    │
      │   $0FE8 = map EPROM 79 lower    │
      │           (L0_, $00 → $DE80)    │
      │   $0FFA = map Cart RAM lower    │
      │           ($88 → $DE80)         │
      │                                 │
$0800 ├═════════════════════════════════┤
      │ Screen RAM (1 KB)               │
$0400 ├─────────────────────────────────┤
      │ System variables                │
$0200 ├─────────────────────────────────┤
      │ Stack                           │
$0100 ├─────────────────────────────────┤
      │ Zero Page (system + Pagefox)    │
      │ $42 = current $DE80 shadow      │
      │ $43 = saved $DE80 for restore   │
      │ $45 = saved $01 for restore     │
$0000 └─────────────────────────────────┘
```

---

## 5. Bankswitch thunks in RAM – detail

These routines reside in RAM (copied from ROM $B7D0–$B7FF) and are **always** accessible, regardless of the current bank.

### $0FD0 – Restore bank (8 B, ROM: $B7D0)

```
                LDA $43             ; saved $DE80 value
                STA $42             ; update shadow
                STA $DE80           ; switch bank
                LDA $45             ; saved $01 value
                STA $01             ; restore memory config
                RTS
```

### $0FDC – Map EPROM 79 upper / L2_ (12 B, ROM: $B7DC)

```
                LDA #$37            ; KERNAL + I/O visible
                STA $01
                LDA #$02            ; EPROM 79, bank 1 (upper)
                STA $42             ; shadow
                STA $DE80           ; switch
                RTS
```

### $0FE8 – Map EPROM 79 lower / L0_ (12 B, ROM: $B7E8)

```
                LDA #$37            ; KERNAL + I/O visible
                STA $01
                LDA #$00            ; EPROM 79, bank 0 (lower)
                STA $42             ; shadow
                STA $DE80           ; switch
                RTS
```

### $0FF4 – Map RAM lower + switch to L2_ (6 B, ROM: $B7F4)

```
                JSR $0FFA           ; map Cart RAM lower
                JMP $0FDC           ; then switch to EPROM 79 upper
```

### $0FFA – Map Cart RAM lower (ROM: $B7FA)

```
                LDA #$88            ; Cart RAM, lower, cart disabled
                STA $42             ; shadow
                STA $DE80           ; switch
                LDA #$80
                JSR $1018           ; helper routine
                LDA #$8A            ; Cart RAM, upper, cart disabled
                STA $42
                STA $DE80
                LDA #$80
                JSR $1018
                ...                 ; continues with clear routine
```

---

## 6. Trampolines – editor transitions

Trampolines reside in RAM ($0DA8+) because they switch the bank and then jump into code in the new bank. They must run from memory that is accessible in all bank configurations.

```
RAM addr    ROM addr    Code                            Function
──────────────────────────────────────────────────────────────────────
$0DA8       $B5A8       JSR $0FDC  ; → EPROM 79 upper (L2_)
$0DAB       $B5AB       JMP L2_9972                     → layout editor entry (menu init)

$0DAE       $B5AE       JSR $0FDC  ; → EPROM 79 upper (L2_)
$0DB1       $B5B1       JMP $8000                       → graphic editor entry

$0DB4       $B5B4       JSR $0FE8  ; → EPROM 79 lower (L0_)
$0DB7       $B5B7       JMP $8010                       → text editor entry
```

### Example: C= T in layout editor (transition to text editor)

```
Layout editor (L2_, bank upper, $DE80=$02)
  → keypress C= T
  → PETSCII code found in jump table
  → PHA/PHA/RTS → address $0DB3+1 = $0DB4 (in RAM!)
  → $0DB4: JSR $0FE8      ; switch to EPROM 79 lower ($00 → $DE80)
  → $0DB7: JMP $8010      ; = JMP into text editor (L0_)
```

---

## 7. Shadow registers (Zero Page)

| Address | Function                                               |
|---------|--------------------------------------------------------|
| `$01`   | C64 processor port (memory configuration: RAM/ROM/I/O) |
| `$42`   | Shadow of current $DE80 value (register is write-only) |
| `$43`   | Saved $DE80 value for restore (thunk $0FD0)            |
| `$45`   | Saved $01 value for restore (thunk $0FD0)              |

---

## 8. Initialization (cold start)

Sequence at power-on (`L0_8F6A` → `L0_8FE9`):

1. Set up KERNAL vectors ($0314–$0333)
2. Configure CIA timers
3. **RAM check**: compare $0900+ with $B100+ (128 bytes × 16 pages)
4. **Copy ROM→RAM**: $B000–$BFFF → $0800–$17FF (16 pages × 256 B = 4 KB)
5. Continue to menu initialization

Copy routine (`L0_8FE9`):

```
                LDA #$B0            ; source = $B000
                STA $03
                LDA #$08            ; destination = $0800
                STA $05
                LDY #$00
                STY $02
                STY $04
loop            LDA ($02),Y         ; read from ROM
                STA ($04),Y         ; write to RAM
                INY
                BNE loop
                INC $03             ; next source page
                INC $05             ; next destination page
                DEX                 ; X = page count (max 16)
                BNE loop
```

---

## 9. Bankswitching overview diagram

```
              $DE80 = $00              $DE80 = $02
            ┌──────────────┐         ┌──────────────┐
   $8000    │  EPROM 79    │         │  EPROM 79    │
            │  Bank 0      │         │  Bank 1      │
            │  (L0_)       │         │  (L2_)       │
            │              │         │              │
            │ Text editor  │         │ Graphic ed.  │
            │ Menu system  │         │ Layout ed.   │
   $9FFF    │ Core utils   │         │              │
            ├──────────────┤         ├──────────────┤
   $A000    │ Init/Reset   │         │ Data tables  │
            │ Font graphics│         │ Editor data  │
   $BFFF    │ Messages     │         │              │
            └──────────────┘         └──────────────┘

              $DE80 = $04              $DE80 = $06
            ┌──────────────┐         ┌──────────────┐
   $8000    │  EPROM ZS3   │         │  EPROM ZS3   │
            │  Bank 0      │         │  Bank 1      │
            │  Charset LO  │         │  Charset HI  │
   $BFFF    │              │         │              │
            └──────────────┘         └──────────────┘

              $DE80 = $08              $DE80 = $0A
            ┌──────────────┐         ┌──────────────┐
   $8000    │  Cart RAM    │         │  Cart RAM    │
            │  Bank 0      │         │  Bank 1      │
            │  (lower)     │         │  (upper)     │
   $BFFF    │  16 KB       │         │  16 KB       │
            └──────────────┘         └──────────────┘

                    Always in RAM
            ┌──────────────────────────┐
   $0800    │  Copy of $B000 block     │
            │  Trampolines             │
            │  Bankswitch thunks       │
   $17FF    │  IRQ, print, utilities   │
            └──────────────────────────┘
```
