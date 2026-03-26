# Jak aktualizovat PROJECT_HISTORY.md

Přesný postup pro aktualizaci dokumentu `PROJECT_HISTORY.md`, který zachycuje historii vývoje projektu po měsících.

---

## Větev

Dokumentace žije na větvi `claude/document-project-history-Zntdi`, která je **rebasována na `main`** — tedy obsahuje celou historii projektu plus naše dva soubory (`PROJECT_HISTORY.md`, `UPDATE_HISTORY.md`) na vrchu.

---

## Kompletní postup aktualizace

### 1. Přepni se na dokumentační větev a synchronizuj s main

```bash
cd /home/user/C64-Pagefox-cs

# Stáhni aktuální main
git fetch origin main

# Přepni na dokumentační větev
git checkout claude/document-project-history-Zntdi

# Ulož naše soubory
cp PROJECT_HISTORY.md /tmp/PROJECT_HISTORY.md
cp UPDATE_HISTORY.md /tmp/UPDATE_HISTORY.md

# Přepni na main a přidej naše soubory
git checkout main
cp /tmp/PROJECT_HISTORY.md .
cp /tmp/UPDATE_HISTORY.md .

# Commitni (pokud byly změny v souborech)
git add PROJECT_HISTORY.md UPDATE_HISTORY.md
git commit -m "docs: sync documentation files with main"

# Force push na dokumentační větev
git push origin HEAD:claude/document-project-history-Zntdi --force

# Přepni zpět na dokumentační větev a synchronizuj
git checkout claude/document-project-history-Zntdi
git reset --hard origin/claude/document-project-history-Zntdi
```

### 2. Zjisti nové commity od posledního updatu

```bash
# Zjisti datum posledního updatu z metadat dokumentu
grep "Poslední aktualizace" PROJECT_HISTORY.md

# Zobraz nové commity (uprav datum)
git log origin/main --pretty=format:"%H|%ai|%an|%s" --since="2026-03-26" --reverse

# Zobraz commity i se změněnými soubory
git log origin/main --pretty=format:"%H|%ai" --name-status --since="2026-03-26" --reverse
```

### 3. Zjisti aktuální stav projektu

```bash
# Přesné počty souborů
ls fonts/prg/ | wc -l          # počet fontů
ls src/ | wc -l                 # počet src souborů
ls tools/*.py | wc -l           # Python nástroje
git ls-files | wc -l            # celkem sledovaných souborů

# Přehled klíčových složek
ls src/ && ls docs/ && ls skills/ && ls .github/workflows/

# Poslední commit na main
git log origin/main --pretty=format:"%H %ai %s" -1
```

### 4. Napiš záznamy do PROJECT_HISTORY.md

Každý commit nebo skupina commitů ve formátu:

```markdown
### DD. měsíce RRRR - Krátký popis
**Commit:** abc1234 - "přesný název commitu"

#### Co bylo vytvořeno:
- `cesta/k/souboru.ext` - co soubor dělá

#### Co bylo uděláno:
- popis změny

#### Co jsi se musel naučit:
1. **Technologie/koncept**
   - detail
```

**Pravidla pro seskupování:**

| Situace | Jak zpracovat |
|---|---|
| Commity stejného tématu ve stejný den | Sloučit do jednoho záznamu |
| Série "Update ci.yml" | Jeden záznam: "N× ladění CI pipeline" |
| Merge commity | Přeskočit |
| Minor update / typo fix | Sloučit s nejbližším tematickým commitem |
| README update | Uvést jen pokud přidává novou sekci |

**Sekci "Co jsi se musel naučit" přidej pokud commit:**
- Přidává soubor s novým formátem (`.asm`, `.crt`, `.bin`, `ci.yml`, ...)
- Zavádí nový nástroj nebo hardware (ACME, SD2IEC, U64, ...)
- Implementuje algoritmus (RLE, hyphenation, device handling, ...)
- Řeší problém specifický pro C64/Pagefox

**Co sledovat podle typu změny:**

| Typ (git) | Jak zpracovat |
|---|---|
| `A` — nový soubor | Uvést název + popis účelu |
| `D` — smazaný soubor | Jen pokud jde o záměrné odebrání funkce |
| `R` — přejmenování | Uvést jako "přejmenováno X → Y" |
| `M` — změna | Jen pokud jde o významnou změnu logiky |

### 5. Aktualizuj statistiky

```bash
git log origin/main --oneline | wc -l   # počet commitů
git ls-files | wc -l                     # počet souborů
git log origin/main -1 --format="%ai %s" # poslední commit
```

Aktualizuj v dokumentu sekci `## STATISTIKY PROJEKTU`:
- `### Počet commitů: N`
- `- Poslední: DD. měsíce RRRR`
- `- **Celkem: ~X měsíce**`
- Přesné počty souborů podle kategorií

### 6. Aktualizuj timeline

Přidej nový měsíc do ASCII bloku:

```
MĚSÍC RRRR
├─ DD.MM  ████ Popis aktivity
└─ DD.MM  ████████████ Důležitá změna! 🚀
```

Délka `████` odpovídá důležitosti (1 blok = minor, 5 bloků = průlom).

### 7. Přidej klíčový milník (pokud relevantní)

Přidej do sekce `## KLÍČOVÉ MILNÍKY` pokud commit:
- Vydává novou verzi (2.x)
- Přidává podporu nového hardware
- Zavádí zcela novou technologii
- Představuje průlom v reverse engineering

### 8. Aktualizuj metadata na konci dokumentu

```markdown
*Poslední aktualizace: DD. měsíce RRRR*
*Poslední commit main: <hash> (DD. měsíce RRRR)*
```

### 9. Commitni a pushni

```bash
git add PROJECT_HISTORY.md UPDATE_HISTORY.md
git commit -m "Update PROJECT_HISTORY.md to <měsíc> <rok>

New sections: <popis>
Updated: N commits, N files, timeline to <měsíc>"

git push -u origin claude/document-project-history-Zntdi
```

---

## Struktura projektu (referenční přehled)

```
C64-Pagefox-cs/
├── src/                   # ASM zdrojáky
│   ├── pg_main.asm        # Root: !source includes + build proměnné
│   ├── pg_cs.asm          # Česká klávesnice, diakritika, Vizawrite
│   ├── pg_de.asm          # Německá lokalizace
│   ├── pg_kernal.asm      # C64 KERNAL adresy (read-only reference)
│   ├── pg_colors.asm      # Výchozí barvy (bezpečné editovat)
│   ├── pg_24.asm          # 24pin tiskárna (podmíněné .pg24)
│   ├── pg_sd2iec.asm      # SD2IEC patch (podmíněné .sd2iec)
│   ├── zs-cs.bin          # Binární font banka CZ (generovat přes tools)
│   ├── zs-de.bin          # Binární font banka DE
│   └── old/               # Historické verze (nesahej)
├── fonts/
│   ├── prg/               # 33× ZS fonty (.prg)
│   └── png/               # 33× PNG náhledy
├── tools/                 # Python nástroje + ACME + skripty
├── docs/                  # PDF manuály + pagefox_memory_map.md
├── charfox/               # Character Fox (počeštěná verze)
├── skills/                # AI agent skills
├── .github/workflows/     # CI/CD pipeline
├── CLAUDE.md              # Instrukce pro AI (build, architektura, workflow)
├── PROJECT_HISTORY.md     # Tento dokument
└── UPDATE_HISTORY.md      # Návod na aktualizaci
```

### Build příkaz (referenčně)

```bash
# Sestavení české 9pin varianty
acme -I src --format plain --outfile build/tmp.bin \
     -DLANG=0 -DP24=0 src/pg_main.asm
cartconv -t pf -i build/tmp.bin -o build/Pagefox-cs.crt

# Flags: LANG=0=CS, LANG=1=DE | P24=0=9pin, P24=1=24pin
```

---

*Naposledy aktualizováno: 26. března 2026*
