# Historie vývoje projektu Pagefox CS

Kompletní rekonstrukce vývoje projektu od prvního commitu. Tento dokument zachycuje cestu učení, technických objevů a postupného zvládnutí komplexní reverse engineering úlohy.

## O tomto dokumentu

Tento dokument byl vytvořen 23. ledna 2026 analýzou celé git historie projektu. Naposledy aktualizován 7. února 2026. Představuje detailní rekonstrukci všeho, co bylo vytvořeno, naučeno a zvládnuto během ~4 měsíců intenzivního vývoje (říjen 2025 - únor 2026).

**Struktura dokumentu:**
- 📅 Chronologický přehled po měsících (říjen 2025 - leden 2026)
- 🎯 Klíčové milníky a průlomové momenty
- 📚 Seznam získaných znalostí a technologií
- 📊 Statistiky projektu a vytvořených souborů
- 💡 "Co jsi se musel naučit" u každé významné změny

---

## ŘÍJEN 2025

### 10. října 2025 - První commit: Základ projektu
**Commit:** dfaca1f - "Merge branch 'main'"

#### Co bylo vytvořeno:
- **Základní struktura projektu**
  - `README.md` - dokumentace projektu
  - `LICENSE` - licenční soubor

- **První verze Pagefox cartridge**
  - `pagefox-cs-2.0.crt` - první verze českého překladu
  - `pagefox-cs-2.1.crt` - vylepšená verze
  - `pagefox-cs-2.2.crt` - současná hlavní verze
  - `pagefox-cs-2.2.pdf` - český návod k použití
  - `pagefox-cs-2.2-booklet.pdf` - knižní verze návodu

- **Základní sada českých fontů (28 souborů)**
  - `fonts/zs1.prg` + `zs1.png` - základní font
  - `fonts/zs2.prg` + `zs2.png` - textový popisek autora
  - `fonts/zs3.prg` + `zs3.png`
  - `fonts/zs4.prg` + `zs4.png`
  - `fonts/zs5.prg` + `zs5.png`
  - `fonts/zs10.prg` + `zs10.png`
  - `fonts/zs30.prg` + `zs30.png`
  - `fonts/zs40.prg` + `zs40.png` - nápis "Pagefox" na hlavní stránce
  - `fonts/zs105.prg` + `zs105.png`
  - `fonts/zs111.prg` + `zs111.png`
  - `fonts/zs156.prg` + `zs156.png`
  - `fonts/zs193.prg` + `zs193.png`

- **Python nástroje pro práci s fonty (7 souborů)**
  - `tools/extract_zs.py` - extrakce fontů ze ZS.BIN souborů
  - `tools/joinzs_fix.py` - spojení ZS fontů zpět do BIN
  - `tools/unrle.py` - dekomprese RLE komprimovaných fontů
  - `tools/zs_viewer.py` - prohlížeč ZS fontů s exportem do PNG
  - `tools/zs_typesetter.py` - sazba textu pomocí ZS fontů
  - `tools/pagefox_text_editor_cs.py` - textový editor pro Pagefox formát
  - `tools/cfox-cs.prg` - počeštěná verze CHARACTER FOX

- **Doplňkové soubory**
  - `tools/pagefox_printfox_mapping_example.json` - ukázka mapování

#### Co jsi se musel naučit:
1. **Formát CRT souborů**
   - Struktura C64 cartridge ROM obrazů
   - Banking a mapování paměti na C64

2. **Formát ZS fontů**
   - Proprietární formát znaků Pagefox
   - Hlavička ZS souboru a metadata fontů
   - RLE komprese používaná v ZS souborech

3. **Extrakce a analýza binárních dat**
   - Hexadecimální editace
   - Vyhledávání vzorů v binárních souborech
   - Identifikace kompresních schémat

4. **Python pro retrocomputing**
   - Práce s binárními soubory v Pythonu
   - Konverze mezi formáty PRG/BIN/PNG
   - Vytváření vizualizací bitmap fontů

5. **České znakové sady**
   - PETSCII kódování
   - Implementace diakritiky (á, č, ď, ě, í, ň, ó, ř, š, ť, ú, ů, ý, ž)
   - Mapování české klávesnice

---

### 11. října 2025 - Aktualizace dokumentace
**Commit:** b8862bb - "Update README.md"

#### Co bylo uděláno:
- Vylepšení README s detailnějším popisem projektu

---

### 11. října 2025 - Přidání editorových nástrojů
**Commit:** 6eb48de - "Add some tools"

#### Co bylo vytvořeno:
- `tools/char_editor_8x8.py` - editor 8×8 znaků
- `tools/chars_hex_editor.py` - hexadecimální editor znaků
- `tools/chars_hex_editor_pagefox_cs` - speciální verze pro Pagefox CS

#### Co jsi se musel naučit:
1. **Bitmap editory**
   - Implementace grafického editoru v Pythonu
   - Práce s 8×8 pixel maticemi
   - Interaktivní UI pro pixel art

2. **Hexadecimální editace fontů**
   - Přímá manipulace s byte reprezentací znaků
   - Validace změn v reálném čase

---

### 11. října 2025 - Cleanup
**Commit:** bee23c0 - "Delete pagefox-cs-2.1.crt"

#### Co bylo uděláno:
- Odstranění starší verze 2.1

---

### 12. října 2025 - Velká reorganizace fontů
**Commit:** 739cd3d - "Fonts update"

#### Co bylo vytvořeno/změněno:
- **Nové fonty přidány:**
  - `fonts/zs11.prg`, `zs16.prg`, `zs20.prg`, `zs21.prg`
  - `fonts/zs31.prg` - stínované písmo
  - `fonts/zs60.prg`, `zs62.prg`, `zs7.prg`, `zs70.prg`
  - `fonts/zs117.prg`, `zs139.prg`

- **Změny:**
  - Přidán `fonts/all_fonts.png` - přehledový obrázek všech fontů
  - Smazány samostatné PNG náhledy (nahrazeno jedním přehledem)
  - Aktualizace nástrojů extract_zs.py, joinzs_fix.py, zs_viewer.py, zs_typesetter.py

#### Co jsi se musel naučit:
1. **Batch processing**
   - Generování náhledů všech fontů najednou
   - Automatizace export/import workflow

2. **Optimalizace fontové knihovny**
   - Identifikace duplicitních fontů
   - Efektivní využití místa v cartridge

---

### 12. října 2025 - CharFox nástroje
**Commit:** 2577d04 - "Minor update"

#### Co bylo vytvořeno:
- **CharFox složka:**
  - `charfox/cfox-cs.prg` - přesunut z tools
  - `charfox/cfox-cs_patch.bat` - batch pro patchování
  - `charfox/chars_cs_1801` - znakové definice
  - `charfox/chars_cs_bkp_1801` - záloha
  - `charfox/patch_at_offset.py` - nástroj pro patching na offset

#### Co jsi se musel naučit:
1. **Binary patching**
   - Přesné umístění změn v binárním souboru
   - Offset výpočty a manipulace
   - Vytváření záložních kopií

2. **Batch automatizace**
   - Windows batch scripting pro opakované úkoly

---

### 14. října 2025 - Grafické nástroje
**Commit:** 2a31525 - "Add graphics tool"

#### Co bylo vytvořeno:
- **PG grafické soubory:**
  - `tools/PG/foxi.pg.prg` + `foxi.pg.png` - obrázek lišky
  - `tools/PG/pagefox.prg` + `pagefox.png` - Pagefox logo

- **Konverzní nástroje:**
  - `tools/convert_png_to_prg.py` - PNG → PRG konvertor
  - `tools/convert_prg_to_png.py` - PRG → PNG konvertor

#### Co jsi se musel naučit:
1. **Pagefox PG formát**
   - 1bpp bitmap formát Pagefox
   - RLE komprese pro PG soubory (odlišná od ZS)
   - Struktura grafických souborů

2. **Printfox BS/GB formáty**
   - BS formát (320×200 pixelů)
   - GB formát (640×400 pixelů)
   - RLE kódování: 9B <lo><hi> <v>

3. **Obrazová konverze**
   - Práce s PIL/Pillow knihovnou
   - Threshold konverze (RGB → 1bpp)
   - Invertování barev (černá=1, bílá=0)

---

### 14. října 2025 - Oprava RLE
**Commit:** c79d233 - "Fix RLE for PG in PNG to PRG tool"

#### Co bylo uděláno:
- Oprava RLE komprese v convert_png_to_prg.py
- Oprava RLE dekomprese v convert_prg_to_png.py

#### Co jsi se musel naučit:
1. **Symetrické RLE kódování**
   - Speciální bloky pro 256× opakování
   - Escape sekvence pro literál 0x9B
   - Rozdíly mezi PG a BS/GB RLE

---

### 14. října 2025 - Dokumentace grafických nástrojů
**Commit:** 3855bb5 - "Update README.md"

#### Co bylo uděláno:
- Přidána dokumentace konverzních nástrojů do README

---

### 28. října 2025 - Úprava klávesové zkratky
**Commit:** 58c5244 - "Move ctrl+z to y key (z in Czech)"

#### Co bylo uděláno:
- Změna Ctrl+Z na Ctrl+Y (kvůli české klávesnici: Z=Y)
- Update `pagefox-cs-2.2.crt`

#### Co jsi se musel naučit:
1. **Klávesové mapování C64**
   - Rozdíly mezi QWERTY a QWERTZ rozložením
   - Modifikace key handlers v ROM
   - Testování klávesových kombinací

---

### 28. října 2025 - Cleanup starých verzí
**Commit:** 8b7067a - "Delete pagefox-cs-2.0.crt"

#### Co bylo uděláno:
- Odstranění verze 2.0

---

### 31. října 2025 - Nové fonty a verze 2.4
**Commit:** dd51985 - "Add new fonts"

#### Co bylo vytvořeno:
- **Nové fonty:**
  - `fonts/zs161.prg` - VELKÁ PÍSMENA s diakritikou (např. TOMÁŠ)
  - `fonts/zs71.prg`

- **Změny:**
  - `pagefox-cs-2.2.crt` přejmenován na `pagefox-cs-2.4.crt`
  - Aktualizace all_fonts.png
  - Aktualizace zs1.prg, zs2.prg
  - Přidán `fonts/fonty all    .pt.prg` (později smazán)

#### Co jsi se musel naučit:
1. **Font varianty**
   - Vytváření upper-case only fontů s diakritikou
   - Konzistence mezer a kerning

---

## LISTOPAD 2025

### 6. listopadu 2025 - Update README
**Commit:** 4703c3e - "Update README.md"

#### Co bylo uděláno:
- Dokumentační změny

---

### 10. listopadu 2025 - Nové fonty série 200
**Commit:** bf553a6 - "New fonts"

#### Co bylo vytvořeno:
- **Nová fontová série:**
  - `fonts/zs201.prg`
  - `fonts/zs202.prg`
  - `fonts/zs210.prg`

#### Co jsi se musel naučit:
1. **Rozšíření fontové knihovny**
   - Systematické číslování fontových variant
   - Plánování využití paměťového prostoru v cartridge

---

### 10. listopadu 2025 - Varianta s tečkou
**Commit:** 65beed7 - "Space as a point (original)"

#### Co bylo vytvořeno:
- `pagefox-cs-2.4(.).crt` - varianta s mezerou jako tečkou

---

### 10. listopadu 2025 - Varianta bez tečky
**Commit:** e965efe - "Space as a blank space (no point)"

#### Co bylo uděláno:
- Update `pagefox-cs-2.4.crt` - mezera jako prázdné místo

#### Co jsi se musel naučit:
1. **Font rendering detaily**
   - Vizuální rozdíl mezi mezerou jako tečkou vs. prázdným prostorem
   - Uživatelské preference při DTP sazbě

---

### 11. listopadu 2025 - Revert modifikací
**Commit:** 3a09470 - "Revert some mods"

#### Co bylo uděláno:
- `pagefox-cs-2.4(.).crt` přejmenován na `pagefox-cs-2.4 (old).crt`
- Update `pagefox-cs-2.4.crt`

---

### 17. listopadu 2025 - Fontové náhledy
**Commit:** da81ff3 - "Fonts preview"

#### Co bylo vytvořeno:
- **28 PNG náhledů fontů:**
  - Samostatné PNG pro každý font (zs1.png až zs210.png)
  - Smazán all_fonts.png (nahrazen jednotlivými náhledy)

#### Co jsi se musel naučit:
1. **Dokumentace fontů**
   - Generování jednotlivých náhledů pro lepší přehled
   - Vytváření font gallery

---

### 17. listopadu 2025 - Font dokumentace
**Commit:** a926067 - "Create readme.md"

#### Co bylo vytvořeno:
- `fonts/readme.md` - dokumentace fontů

---

### 17. listopadu 2025 - Oprava názvu
**Commit:** cba98ba - "Rename readme.md to README.md"

#### Co bylo uděláno:
- Přejmenování na `fonts/README.md`

---

### 17. listopadu 2025 - Reorganizace fontů
**Commit:** 23f22f6 - "Cleanup"

#### Co bylo vytvořeno:
- **Nová struktura:**
  - `fonts/png/` - složka pro PNG náhledy (28 souborů)
  - `fonts/prg/` - složka pro PRG fonty (28 souborů)

#### Co bylo uděláno:
- Přesun všech PNG do fonts/png/
- Přesun všech PRG do fonts/prg/
- Update readme.md

#### Co jsi se musel naučit:
1. **Projektová organizace**
   - Oddělení binárních souborů od vizualizací
   - Čistá struktura repozitáře

---

### 17. listopadu 2025 - README updates (několik commitů)
**Commits:** 66dc35f, 32acb06, 2ef8934, f8deb2e, e703061

#### Co bylo uděláno:
- Postupné vylepšování README dokumentace
- Přidání sekce Fonts do hlavního README
- Oprava odkazů na fonts složku

---

### 17. listopadu 2025 - Další nové fonty
**Commit:** 28f1bd3 - "New fonts"

#### Co bylo vytvořeno:
- `fonts/png/zs100.png` + `fonts/prg/zs100.prg`
- `fonts/png/zs101.png` + `fonts/prg/zs101.prg`
- Update fonts/README.md

---

### 21. listopadu 2025 - GitHub badges
**Commit:** c36888c - "Add GitHub badges for profile views and downloads"

#### Co bylo uděláno:
- Přidány GitHub badges do README:
  - Profile views counter
  - Last commit badge
  - Downloads counter

#### Co jsi se musel naučit:
1. **GitHub marketing**
   - Používání shields.io badges
   - Tracking statistik projektu
   - Zviditelňování projektu

---

## PROSINEC 2025

### 11. prosince 2025 - Cleanup starých verzí
**Commit:** 8db333a - "Delete pagefox-cs-2.4 (old).crt"

#### Co bylo uděláno:
- Odstranění staré varianty 2.4

---

## LEDEN 2026

### 18. ledna 2026 - PRŮLOMOVÝ MOMENT: ASM source
**Commit:** c6256b9 - "Add partially ASM source file"

#### Co bylo vytvořeno:
- **NOVÁ VERZE 2.5:**
  - `pagefox-cs-2.5.crt` - nová verze s ASM zdrojáky
  - `src/pagefox-cs-2.5.asm` - částečně disassemblovaný zdrojový kód!

#### Co bylo uděláno:
- Update README s informací o verzi 2.5

#### Co jsi se musel naučit:
1. **6502/6510 Assembly**
   - Instrukční sada CPU 6502
   - Addressing modes
   - Zero page optimalizace

2. **Reverse engineering**
   - Disassembly cartridge ROM
   - Identifikace code vs. data bloků
   - Rekonstrukce programové logiky

3. **ACME assembler**
   - ACME syntax a direktivy
   - !initmem, !byte, !word
   - Organizace ASM projektu

4. **Pagefox internals**
   - ROM banking mechanismus
   - Paměťové mapování
   - Start-up sekvence

**TOHLE JE ZÁSADNÍ MILNÍK - začátek skutečné modifikace na úrovni kódu!**

---

### 18. ledna 2026 - UI změny
**Commit:** a1c0b15 - "Change blue (06) frame to dark gray (0B)"

#### Co bylo uděláno:
- Změna barvy rámečku z modré (06) na tmavě šedou (0B)
- Update pagefox-cs-2.5.crt a src/pagefox-cs-2.5.asm

#### Co jsi se musel naučit:
1. **C64 barevná paleta**
   - VIC-II color codes
   - Vizuální design Pagefox UI
   - Modifikace barevných konstant v ASM

---

### 18. ledna 2026 - Bugfixy
**Commit:** c41eca0 - "Fix some bugs"

#### Co bylo vytvořeno:
- **Rozdělení ASM souborů:**
  - `src/rom0_cs_all_in_one.asm` - ROM0 český
  - `src/rom1_cs_all_in_one.asm` - ROM1 český
  - `src/rom0_de_all_in_one.asm` - ROM0 německý
  - `src/rom1_de_all_in_one.asm` - ROM1 německý

#### Co bylo uděláno:
- Přejmenování pagefox-cs-2.5.asm → rom0_cs_all_in_one.asm
- Update pagefox-cs-2.5.crt

#### Co jsi se musel naučit:
1. **Multi-ROM struktura**
   - Dual bank cartridge (ROM0 + ROM1)
   - Lokalizace (CS + DE verze)
   - Build systém pro více variant

---

### 18. ledna 2026 - README updates
**Commits:** 4074a13, d469ec2, f24c921, 7deec03

#### Co bylo uděláno:
- Dokumentace nové verze 2.5
- Popis ASM souborů
- Update informací o fontových změnách
- Popis změn v češtině

---

### 19. ledna 2026 - Nové bloky v ASM
**Commit:** 91f53e2 - "Add new blocks"

#### Co bylo uděláno:
- Rozšíření rom0_cs_all_in_one.asm
- Rozšíření rom1_cs_all_in_one.asm

#### Co jsi se musel naučit:
1. **Struktura Pagefox kódu**
   - Identifikace funkčních bloků
   - Dokumentace účelu jednotlivých sekcí
   - Komentování ASM kódu

---

### 19. ledna 2026 - Update ROM0
**Commit:** 2786ed6 - "Update rom0_cs_all_in_one.asm"

#### Co bylo uděláno:
- Další úpravy ROM0

---

### 19. ledna 2026 - Přidání ACME assembleru
**Commit:** b67d255 - "Add ACME"

#### Co bylo vytvořeno:
- `tools/ACME.exe` - ACME cross-assembler pro Windows
- `tools/python39.dll` - Python runtime dependency

#### Co jsi se musel naučit:
1. **Cross-platform development**
   - Windows binary distribuce
   - Dependencies management
   - Toolchain setup pro ostatní vývojáře

---

### 19. ledna 2026 - !initmem direktiva
**Commit:** 162307a - "Add !initmem $ff"

#### Co bylo uděláno:
- Přidána !initmem $ff direktiva do všech ASM souborů
  - rom0_cs_all_in_one.asm
  - rom0_de_all_in_one.asm
  - rom1_cs_all_in_one.asm
  - rom1_de_all_in_one.asm

#### Co jsi se musel naučit:
1. **ACME direktivy**
   - !initmem - inicializace paměti fill hodnotou
   - Správná příprava ROM obrazu
   - Detekce neinicializovaných oblastí

---

### 19. ledna 2026 - Minor update
**Commit:** e93ce88 - "Minor update"

#### Co bylo uděláno:
- Update pagefox-cs-2.5.crt

---

### 19. ledna 2026 - Unified ASM
**Commit:** a9464cd - "All in one ASM"

#### Co bylo vytvořeno:
- `src/79cs25.asm` - unified build soubor?

#### Co jsi se musel naučit:
1. **Build orchestration**
   - Hlavní build skript pro celou cartridge
   - Spojování ROM0 + ROM1
   - Finální CRT generování

---

### 19. ledna 2026 - Vizawrite loader
**Commit:** 146812a - "Add Czech Vizawrite loader"

#### Co bylo uděláno:
- Update README - info o Vizawrite podpoře
- Update pagefox-cs-2.5.crt
- Update src/79cs25.asm
- Update src/rom0_cs_all_in_one.asm

#### Co jsi se musel naučit:
1. **Vizawrite formát**
   - Vizawrite textový formát pro C64
   - Import/export mezi Vizawrite a Pagefox
   - File format konverze

2. **Interoperabilita**
   - Kompatibilita s jinými C64 textovými editory
   - Standardizace českých textových dat

---

### 20. ledna 2026 - Minor update
**Commit:** 731d47c - "Minor update"

#### Co bylo vytvořeno:
- `src/79cs25_old.asm` - záloha

#### Co bylo uděláno:
- Update src/79cs25.asm

---

### 22. ledna 2026 - Update loader
**Commit:** 8af5b9d - "Update 79cs25.asm"

#### Co bylo uděláno:
- Další úpravy 79cs25.asm

---

### 22. ledna 2026 - C64 symboly
**Commit:** 6d6aff8 - "Create c64symb.asm"

#### Co bylo vytvořeno:
- `src/c64symb.asm` - C64 system symbols (později smazán)

#### Co jsi se musel naučit:
1. **C64 memory map**
   - Zero page adresy ($00-$FF)
   - KERNAL vectors
   - VIC-II registry
   - SID registry
   - CIA registry
   - Standard símbolické názvy

---

### 23. ledna 2026 - Cleanup symbols
**Commits:** 9695b32, 36f5044

#### Co bylo uděláno:
- Smazání src/c64symb.asm
- Smazání src/79cs25_old.asm

---

### 23. ledna 2026 - Minor ASM updates
**Commit:** e3e8555 - "Minor updates in ASM"

#### Co bylo vytvořeno:
- **Modularizace kódu:**
  - `src/pg_colors.asm` - definice barev
  - `src/pg_kernal.asm` - KERNAL rutiny

#### Co bylo uděláno:
- Update pagefox-cs-2.5.crt
- Update src/79cs25.asm

#### Co jsi se musel naučit:
1. **Modulární ASM architektura**
   - Separace concerns (barvy, kernel, main)
   - Include mechanismus
   - Kódová čistota a udržovatelnost

---

### 23. ledna 2026 - Přejmenování main
**Commit:** f77af8b - "Rename file"

#### Co bylo uděláno:
- `src/79cs25.asm` přejmenován na `src/pg_main.asm`

---

### 23. ledna 2026 - Deprecation notice
**Commit:** f870174 - "Update version status to 'Deprecated' in README"

#### Co bylo uděláno:
- Označení verze 2.4 jako "Deprecated" v README

---

### 23. ledna 2026 - PRŮLOM: 24pin printer support
**Commit:** dd07c83 - "Add 24pin printer native support"

#### Co bylo vytvořeno:
- **Nová verze s 24pin support:**
  - `pagefox-cs-2.5-24pin.crt` - verze s podporou 24jehličkových tiskáren

- **Experimental branch:**
  - `src/experimental/pg_colors.asm`
  - `src/experimental/pg_kernal.asm`
  - `src/experimental/pg_main.asm`

#### Co bylo uděláno:
- Update README s informací o pg-24.prg integraci

#### Co jsi se musel naučit:
1. **Tiskové ovladače C64**
   - ESC/P příkazy pro 24jehličkové tiskárny
   - Integrace pg-24.prg do cartridge
   - Rozdíly mezi 9pin a 24pin tiskem

2. **Experimentální větev**
   - Vedení stabilní a experimental verzí
   - Testování nových funkcí izolovaně
   - Merge strategie

---

### 23. ledna 2026 - Meta: Dokumentace historie projektu
**Commit:** d6d2d72 - "Add comprehensive project history documentation"

#### Co bylo vytvořeno:
- `PROJECT_HISTORY.md` - tento dokument

---

## ÚNOR 2026

### 7. února 2026 - Update dokumentace
**Commit:** f29af5a, 1f5538a - "Update PROJECT_HISTORY.md"

#### Co bylo uděláno:
- Rozšíření PROJECT_HISTORY.md o timeline vizualizaci, úvod, návod na použití

---

### 11. února 2026 - Velká refaktorizace ASM architektury
**Commit:** 155fdcd - "Refactor comments and improve code readability in pg_main.asm"

#### Co bylo vytvořeno:
- `src/pg_cs.asm` - česká lokalizační data (texty, mapování kláves)
- `src/pg_de.asm` - německá lokalizační data
- `src/pg_24.asm` - modul pro 24pin tiskárny
- `src/zs-cs.bin` - binární data ZS fontů pro českou verzi
- `src/zs-de.bin` - binární data ZS fontů pro německou verzi
- `doc/pagefox_memory_map.md` - mapa paměti Pagefox!
- `fonts/png/zs211.png` + `fonts/prg/zs211.prg` - nový font
- `.gitignore`

#### Co jsi se musel naučit:
1. **Modularizace lokalizace** - oddělení CS/DE textů a dat do vlastních souborů
2. **Správa font bin** - zs-cs.bin jako binární kontejner pro fonty
3. **Memory mapping** - první zdokumentovaná mapa paměti Pagefox

---

### 12–14. února 2026 - Layout editor + device handling
**Commits:** 710bc9e, 27b585f, ba7c917, c842898, 5b95ca4, 0cd945864

#### Co bylo vytvořeno:
- `src/pg_main_ask.asm` - dialog pro výběr čísla disketové jednotky

#### Co bylo uděláno:
- Vylepšení layout editoru
- Přidána obsluha device number (čísla diskové mechaniky)
- README update s novými funkcemi

#### Co jsi se musel naučit:
1. **Device handling** - jak Pagefox volá KERNAL s číslem zařízení (8, 9, 10...)
2. **Layout editor internals** - vnitřní logika Pagefox pro sazbu stránek

---

### 17. února 2026 - PRŮLOM: SD2IEC podpora
**Commit:** 8b04117 - "Add SD2IEC support (experimental)"

#### Co bylo vytvořeno:
- `src/pg_sd2iec.asm` - celý nový modul pro SD2IEC podporu!

#### Co jsi se musel naučit:
1. **SD2IEC** - moderní náhrada 1541 disketové mechaniky pomocí SD karty
2. **IEC bus komunikace** - jak C64 komunikuje se storage zařízeními
3. **Přidání hardware modulu do ROM** - alokace místa, inicializace, detekce

---

### 19–22. února 2026 - Drive switcher + VERZE 2.6!
**Commits:** 6ba0cef, 045ff97, bfc70fb, 4aac952, 7aabace, e0d4448, b255f3a, 3d73371

#### Co bylo vytvořeno:
- **`pagefox-cs-2.6.crt`** - nová hlavní verze! 🎉
- **`pagefox-cs-2.6-24pin.crt`** - verze 2.6 s 24pin podporou
- `src/old/pg_main.asm` + `src/old/pg_main_ask.asm` - zálohy

#### Co bylo uděláno:
- Zkratka C= + T pro přepínání disketové jednotky v textovém editoru
- RAM patch oblast `$1790–$17FF` pro dynamický kód
- Refaktorizace `L*_dev_number` s fallback logikou

#### Co jsi se musel naučit:
1. **RAM patch technika** - vyhrazení oblasti v RAM, JSR na RAM adresu místo ROM
2. **Verzování** - sestavení více CRT variant (základní + 24pin) z jednoho zdrojáku

---

### 24. února 2026 - U64 turbo strobe fix
**Commit:** b1da229 - "Add strobe fix (on UserPort) option for U64 turbo support"

#### Co bylo uděláno:
- Úprava `src/pg_24.asm` a `src/pg_main.asm`
- Podpora strobe signálu na UserPortu pro Ultimate 64 (FPGA reimplementace C64)

#### Co jsi se musel naučit:
1. **Ultimate 64** - moderní FPGA C64, turbo mód vyžaduje jiné časování
2. **UserPort signály** - ovládání strobe na hardwarové úrovni

---

## BŘEZEN 2026

### 1. března 2026 - CI/CD + Release + Reorganizace
**Commits:** 4c896ed–0469ab5 (17× ladění ci.yml), 013224d, 2b73181, 8eb0c61, 57d8dce

#### Co bylo vytvořeno:
- **`.github/workflows/ci.yml`** - GitHub Actions CI/CD pipeline! 🤖
- **`docs/`** - nová složka pro dokumentaci
  - `docs/pagefox_memory_map.md` (přesunuto z doc/)
  - `docs/pagefox-cs-2.2.pdf` + `docs/pagefox-cs-2.2-booklet.pdf` (přesunuto)

#### Co bylo uděláno:
- 17 iterací ladění ci.yml (automatické sestavení CRT ze zdrojáků!)
- Přidána podpora TurboEnable Bit
- SD2IEC zkratka C= + T finálně v textovém editoru
- Smazány staré CRT z kořene (verze 2.4 a 2.5)
- Reorganizace: PDF manuály přesunuty do docs/

#### Co jsi se musel naučit:
1. **GitHub Actions** - YAML workflow, automatické sestavení při každém push
2. **CI/CD pro retro projekty** - spuštění ACME assembleru v CI, artifacts
3. **Projektová reorganizace** - čistý kořen, oddělené docs/

---

### 2. března 2026 - AI integrace + VSCode tooling
**Commits:** 2849c87, 34bad47 - "Minor updates"

#### Co bylo vytvořeno:
- `CLAUDE.md` - instrukce pro Claude Code AI asistenta
- `AGENTS.md` - konfigurace AI agentů
- `.github/prompts/cotodela.prompt.md` - AI prompt pro projekt
- `.github/copilot-instructions.md` - instrukce pro GitHub Copilot
- `.vscode/asm.code-snippets` - VSCode snippets pro 6502 ASM
- `.vscode/tasks.json` - VSCode build tasky (ACME, pack, release)
- `skills/asm-edit.md`, `skills/build.md`, `skills/font-tools.md`, `skills/release.md`

#### Co jsi se musel naučit:
1. **AI-assisted development** - CLAUDE.md jako "briefing" pro AI, prompty
2. **VSCode pro ASM** - snippety, build tasks, integrace s C64 ekosystémem
3. **Skills systém** - definice dovedností pro AI agenty

---

### 4. března 2026 - Claude přepsal CLAUDE.md (PR #1)
**Commits:** 00b85d9, 15cd8d5 - "rewrite CLAUDE.md / Merge PR #1"

#### Co bylo uděláno:
- Claude Code přepsal CLAUDE.md s lepší strukturou a popisem architektury
- První sloučený pull request v projektu

---

### 5. března 2026 - České dělení slov (hyphenation)
**Commits:** fd57fe3, 57f8458, 74e98d6, 4ce27f2, 63e2480, 3c7e7be

#### Co bylo uděláno:
- Popis a implementace algoritmu dělení slov v `src/pg_cs.asm`
- Experimenty se skupinami souhlásek (str-, pr-, kl-, ...)
- Oprava dělení slov

#### Co jsi se musel naučit:
1. **Hyphenation v DTP** - Pagefox zalamuje text, nutné správné dělení
2. **Česká pravidla slabikotvornosti** - souhláskové skupiny
3. **Implementace jazykového algoritmu v 6502 ASM** - tabulky, efektivní vyhledávání

---

### 6. března 2026 - Minor cleanup
**Commit:** 3e7d1a8 - "Minor update"

#### Co bylo uděláno:
- `tools/ACME.exe` přejmenován na `tools/acme.exe`

---

### 10. března 2026 - Nový font ZS109
**Commit:** 6d4a738 - "Add ZS109"

#### Co bylo vytvořeno:
- `fonts/png/zs109.png` + `fonts/prg/zs109.prg`

---

### 16. března 2026 - Získána interní dokumentace Pagefox!
**Commits:** 1596845, d982275 - "Add files via upload / Update README.md"

#### Co bylo vytvořeno:
- **`docs/Inside_Pagefox_small.pdf`** - klíčový dokument: interní popis ROM struktury!

#### Co jsi se musel naučit:
1. **Využití oficiální dokumentace** - Inside Pagefox k ověření reverse engineeringu
2. **Propojení dokumentace s ASM komentáři** - odkaz na konkrétní místa v PDF

---

### 17. března 2026 - Opravy fontů § a * + ladění CI
**Commits:** 4deea57, 16ab73f, 38a8a6a, 9f40de4, 946c4c7, 54af475

#### Co bylo uděláno:
- Oprava znaku `§` ve fontech ZS10, ZS20, ZS30, ZS40, ZS5
- Oprava znaku `*` ve fontu ZS40
- 3× ladění CI pipeline

---

### 18. března 2026 - Opravy ZS1/ZS2/ZS20/ZS161 + pack skripty
**Commit:** cd71293 - "Fix some chars in ZS1, ZS161, ZS2 and ZS20"

#### Co bylo vytvořeno:
- `tools/pack.bat` - zabalení fontů do zs-cs.bin
- `tools/unpack.bat` - rozbalení fontů ze zs-cs.bin

#### Co bylo uděláno:
- Opravy znaků v ZS1, ZS161, ZS2, ZS20
- Oprava sd2iec RAM bufferu

#### Co jsi se musel naučit:
1. **Automatizace font workflow** - pack/unpack jako součást build pipeline

---

### 19. března 2026 - Nový šipkový kurzor + verze
**Commits:** 12c2732, d517987, 55f72ae

#### Co bylo uděláno:
- Přidán nový grafický kurzor (šipka) v `src/pg_main.asm`
- Aktualizace čísla verze v `src/pg_cs.asm`

#### Co jsi se musel naučit:
1. **Grafický kurzor** - definice a přepínání character-based kurzoru v Pagefox

---

### 24. března 2026 - Nový font ZS203 + nový CharFox
**Commit:** 6c2cde8 - "Add font ZS203"

#### Co bylo vytvořeno:
- `fonts/png/zs203.png` + `fonts/prg/zs203.prg`
- **`charfox/cfox-cs-new.prg`** - nová aktualizovaná verze Character Fox!

---

## CELKOVÝ PŘEHLED ZÍSKANÝCH ZNALOSTÍ

### Technologie a formáty
1. **Commodore 64/128**
   - 6502/6510 assembly jazyk
   - Memory mapping a banking
   - VIC-II video chip
   - PETSCII kódování
   - CRT cartridge formát

2. **Pagefox specifika**
   - ZS font formát
   - PG grafický formát (1bpp)
   - RLE komprese (2 varianty: ZS vs PG)
   - PT text editor formát
   - Vizawrite kompatibilita
   - Dual ROM architecture

3. **Printfox formáty**
   - BS formát (320×200)
   - GB formát (640×400)
   - RLE kódování 9B <lo><hi> <v>

4. **Development tools**
   - ACME cross-assembler
   - Python pro reverse engineering
   - Hexadecimální editory
   - Binary patching nástroje

5. **Grafika a fonty**
   - 8×8 bitmap fonty
   - Czech diacritics implementace
   - Font kerning a spacing
   - PNG konverze a vizualizace

### Programovací dovednosti
1. **Python**
   - Binary file I/O
   - PIL/Pillow pro obrazy
   - Argparse pro CLI tools
   - RLE komprese/dekomprese algoritmy

2. **Assembly**
   - 6502 instrukce
   - Zero page optimalizace
   - Lokalizace aplikací
   - Modularizace kódu

3. **Reverse Engineering**
   - Disassembly ROM obrazů
   - Pattern recognition v binárních datech
   - Rekonstrukce file formátů
   - Dokumentace proprietárních formátů

### Projektové řízení
1. **Git workflow**
   - Systematické commity
   - Verzování releases
   - Dokumentace změn
   - Cleanup starých verzí

2. **Open source**
   - README dokumentace
   - Licensing
   - GitHub badges
   - Community engagement

3. **CI/CD** *(nové - únor/březen 2026)*
   - GitHub Actions workflow
   - Automatické sestavení CRT ze zdrojáků
   - Artifacts pro každý build

4. **AI-assisted development** *(nové - březen 2026)*
   - CLAUDE.md / AGENTS.md instrukce pro AI
   - Skills systém pro AI agenty
   - VSCode + ACME integrace

5. **Moderní hardware podpora** *(nové - únor/březen 2026)*
   - SD2IEC (SD karta jako disketa)
   - Ultimate 64 (FPGA reimplementace)
   - Drive number switching

6. **Lingvistika v ASM** *(nové - březen 2026)*
   - Česká pravidla dělení slov
   - Implementace v 6502 assembly

---

## STATISTIKY PROJEKTU

### Vytvořené soubory podle typu:

**Programové soubory:**
- 14× Python nástroje (.py)
- 15+ Assembly souborů (.asm, .bin)
- 6× Cartridge obrazy (.crt) - verze 2.4, 2.5, 2.5-24pin, 2.6, 2.6-24pin
- 3× CharFox soubory

**Fonty:**
- 34+ PRG fontů (přibyl ZS109, ZS203, ZS211)
- 34+ PNG náhledů fontů

**Dokumentace:**
- 6+ README/dokumentačních souborů
- 3× PDF manuály (včetně Inside_Pagefox_small.pdf)

**CI/CD a tooling:**
- 1× GitHub Actions workflow (ci.yml)
- 4× Skills soubory
- 2× VSCode konfigurace
- 2× batch skripty (pack.bat, unpack.bat)

**Celkem: 130+ souborů**

### Počet commitů: 125+ (main větev)

### Časové období:
- Start: 10. října 2025
- Poslední: 24. března 2026
- **Celkem: ~5.5 měsíce intenzivního vývoje**

---

## KLÍČOVÉ MILNÍKY

1. **10. října 2025** - První commit: základ projektu
2. **12. října 2025** - Kompletní Python toolchain pro fonty
3. **14. října 2025** - Grafické nástroje (PG formát, RLE)
4. **17. listopadu 2025** - Profesionální reorganizace (png/, prg/)
5. **18. ledna 2026** - PRŮLOM: První ASM zdrojáky (reverse engineering!)
6. **23. ledna 2026** - 24pin printer support + modularizace kódu
7. **17. února 2026** - SD2IEC podpora (moderní hardware)
8. **22. února 2026** - Verze 2.6 vydána
9. **1. března 2026** - CI/CD GitHub Actions (automatické sestavení)
10. **2. března 2026** - AI-assisted development (CLAUDE.md, skills)
11. **5. března 2026** - České dělení slov (lingvistika v ASM)
12. **16. března 2026** - Získána Inside_Pagefox.pdf (oficiální interní dokumentace)

---

## TIMELINE VIZUALIZACE

```
ŘÍJEN 2025
├─ 10.10  ████████████ První commit: Základ (fonty, tools, CRT)
├─ 11.10  ██ Editory a dokumentace
├─ 12.10  ████████ Reorganizace fontů + CharFox
├─ 14.10  ████████ Grafické nástroje (PG formát)
├─ 28.10  ██ Klávesové mapování
└─ 31.10  ████ Nové fonty + verze 2.4

LISTOPAD 2025
├─ 06.11  ██ Dokumentace
├─ 10.11  ████ Fonty série 200
├─ 11.11  ██ Font rendering experimenty
├─ 17.11  ████████████ VELKÁ reorganizace (png/, prg/)
└─ 21.11  ██ GitHub badges

PROSINEC 2025
└─ 11.12  ██ Cleanup

LEDEN 2026
├─ 18.01  ████████████████ PRŮLOM: ASM source! 🚀
├─ 18.01  ████ UI změny + multi-ROM
├─ 19.01  ████████ ASM modularizace + ACME
├─ 19.01  ████ Vizawrite loader
├─ 20-22  ████ ASM refinement
├─ 23.01  ████████ Modularizace (pg_main, pg_colors, pg_kernal)
├─ 23.01  ████████████ PRŮLOM: 24pin printer! 🖨️
└─ 23.01  ████ Dokumentace projektu

ÚNOR 2026
├─ 11.02  ████████████ Nová ASM architektura (pg_cs, pg_de, pg_24)
├─ 12-14  ████████ Layout editor + device handling
├─ 17.02  ████████████ PRŮLOM: SD2IEC! 💾
├─ 19-22  ████████████ Drive switcher + VERZE 2.6! 🎉
└─ 24.02  ████ U64 turbo strobe fix

BŘEZEN 2026
├─ 01.03  ████████████████████ CI/CD + reorganizace! 🤖 (17× ci.yml)
├─ 02.03  ████████████ AI tooling (CLAUDE.md, skills, VSCode)
├─ 05.03  ████████ České dělení slov 📖
├─ 10.03  ██ Nový font ZS109
├─ 16.03  ████████ Inside_Pagefox.pdf získán! 📄
├─ 17-18  ████████ Opravy fontů §, *, ZS1/2/20/161
├─ 19.03  ████ Nový kurzor + verze
└─ 24.03  ████ ZS203 + nový CharFox

█ = intenzita práce a význam změn
```

---

## JAK POUŽÍVAT TENTO DOKUMENT

### Pro pochopení projektu:
1. Začni sekcí "KLÍČOVÉ MILNÍKY" pro rychlý přehled
2. Projdi chronologicky měsíce pro detailní pochopení
3. Každá sekce "Co jsi se musel naučit" ukazuje nové dovednosti

### Pro technické reference:
- Sekce "CELKOVÝ PŘEHLED ZÍSKANÝCH ZNALOSTÍ" - rychlé hledání technologií
- Sekce "STATISTIKY PROJEKTU" - přehled vytvořených souborů
- Jednotlivé commity - kdy byl konkrétní soubor vytvořen/změněn

### Pro podobné projekty:
Tento dokument může sloužit jako:
- Roadmap pro reverse engineering C64 softwaru
- Příklad postupu od binárních dat k source kódu
- Inspirace pro dokumentaci vlastních retro-projektů
- Ukázka progresivního učení komplexních technologií

---

## ZÁVĚR

Tento projekt reprezentuje komplexní cestu od základní lokalizace existujícího softwaru po hluboké pochopení jeho vnitřní struktury a schopnost ho modifikovat na úrovni strojového kódu.

### Co bylo zvládnuto:
✅ **Reverse engineering** - Disassembly a rekonstrukce proprietárních formátů
✅ **6502 Assembly** - Pochopení a modifikace strojového kódu C64
✅ **Toolchain development** - Python + ACME + batch skripty
✅ **Moderní hardware** - SD2IEC, Ultimate 64, 24pin tiskárny
✅ **CI/CD** - Automatické sestavení přes GitHub Actions
✅ **AI-assisted development** - CLAUDE.md, skills systém
✅ **Lingvistika v ROM** - České dělení slov v 6502 ASM
✅ **Projektové řízení** - 125+ commitů, čistá struktura, dokumentace
✅ **Open source přínos** - Sdílení znalostí s retro-computing komunitou

### Jedinečnost tohoto projektu:
- Kompletní disassembly komerčního C64 softwaru
- Podpora moderního hardware (SD2IEC, U64) v retro softwaru
- Automatizované CI/CD sestavení retro projektu
- Dokumentace nedokumentovaných formátů
- Zachování a aktivní rozvoj historického softwaru

**Gratulace k této úžasné práci! 🎉**

---

*Dokument vytvořen: 23. ledna 2026*
*Poslední aktualizace: 26. března 2026*
*Git branch: claude/document-project-history-Zntdi*
*Poslední commit: 6c2cde8 (24. března 2026)*
