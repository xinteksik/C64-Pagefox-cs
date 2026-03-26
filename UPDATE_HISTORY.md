# Jak aktualizovat PROJECT_HISTORY.md

Tento soubor popisuje přesný postup pro aktualizaci dokumentu `PROJECT_HISTORY.md`, který zachycuje historii vývoje projektu po měsících.

---

## Co je potřeba

- Git repozitář s historií commitů
- Přístup k souborům projektu (pro pochopení co jednotlivé soubory dělají)

---

## Postup krok za krokem

### 1. Získání nových commitů od posledního updatu

```bash
# Zobraz všechny commity od data posledního updatu (změň datum)
git log --all --pretty=format:"%H|%ai|%an|%s" --since="2026-03-26" --reverse

# Zobraz commity i se seznamem změněných souborů
git log --all --pretty=format:"%H|%ai" --name-status --since="2026-03-26" --reverse
```

### 2. Zjištění aktuálního stavu projektu

```bash
# Přehled souborů v klíčových složkách
ls src/
ls fonts/prg/
ls tools/
ls docs/ 2>/dev/null
ls .github/workflows/ 2>/dev/null

# Celkový počet commitů na main větvi
git log origin/main --oneline | wc -l
```

### 3. Struktura záznamu v PROJECT_HISTORY.md

Každý commit nebo skupina commitů se zapíše v tomto formátu:

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
- Commity se stejným tématem ve stejný den → sloučit do jednoho záznamu
- Série "Update ci.yml" → jeden záznam s poznámkou "N× iterací"
- Merge commity → přeskočit nebo jen zmínit
- Minor update / typo fix → sloučit s nejbližším tematickým commitem

### 4. Aktualizace statistik na konci dokumentu

Po přidání nových sekcí aktualizuj:

```bash
# Spočítej commity na main
git log origin/main --oneline | wc -l

# Spočítej soubory v projektu (bez .git)
git ls-files | wc -l

# Zobraz poslední commit
git log origin/main --pretty=format:"%H %ai %s" -1
```

Aktualizuj v dokumentu:
- `### Počet commitů: N`
- `- Poslední: DD. měsíce RRRR`
- `- **Celkem: ~X měsíce**`
- `**Celkem: N+ souborů**`

### 5. Aktualizace timeline vizualizace

Přidej nový měsíc do ASCII timeline:

```
MĚSÍC RRRR
├─ DD.MM  ████ Popis aktivity
└─ DD.MM  ████████████ Důležitá změna! 🚀
```

Délka `████` bloku odpovídá relativní důležitosti změny (1–5 bloků).

### 6. Aktualizace klíčových milníků

Přidej nový milník pokud commit:
- Přidává podporu nového hardware nebo formátu
- Vydává novou verzi (2.x)
- Zavádí zcela novou technologii do projektu
- Představuje průlom v reverse engineering

### 7. Aktualizace metadat na konci souboru

```markdown
*Poslední aktualizace: DD. měsíce RRRR*
*Poslední commit: <hash> (DD. měsíce RRRR)*
```

---

## Jak commitnout a pushnout

```bash
# Přidej soubor
git add PROJECT_HISTORY.md

# Commitni s popisným message
git commit -m "Update PROJECT_HISTORY.md to <měsíc> <rok>

New sections: <seznam nových sekcí>
Updated: commits N, files N, timeline"

# Pushni na claude/ větev
git push -u origin claude/document-project-history-Zntdi
```

---

## Co sledovat při analýze commitů

| Typ commitu | Jak zpracovat |
|---|---|
| Nový soubor (A) | Uvést název + stručný popis účelu |
| Smazaný soubor (D) | Zmínit jen pokud jde o záměrné odebrání funkce |
| Přejmenovaný soubor (R) | Uvést jako "přejmenováno X → Y" |
| Změna existujícího (M) | Popsat jen pokud jde o významnou změnu |
| ci.yml série | "N× ladění CI pipeline" jako jeden záznam |
| README update | Uvést jen pokud přidává novou sekci nebo info |

## Signály pro "Co jsi se musel naučit"

Sekci "Co jsi se musel naučit" přidej pokud commit:
- Přidává soubor s novou příponou nebo formátem (`.asm`, `.crt`, `.bin`, ...)
- Zavádí nový nástroj (ACME, GitHub Actions, SD2IEC, ...)
- Řeší problém specifický pro C64/Pagefox hardware nebo software
- Implementuje algoritmus (RLE, hyphenation, device handling, ...)

---

## Příklad: spuštění aktualizace

```bash
# 1. Přejdi do repozitáře
cd /home/user/C64-Pagefox-cs

# 2. Stáhni aktuální stav
git fetch origin main

# 3. Zjisti nové commity od posledního updatu
git log origin/main --pretty=format:"%H|%ai|%s" --since="2026-03-26" --reverse

# 4. Pro každý nový commit zobraz změněné soubory
git show --name-status <hash>

# 5. Uprav PROJECT_HISTORY.md dle postupu výše

# 6. Commitni a pushni
git add PROJECT_HISTORY.md
git commit -m "Update PROJECT_HISTORY.md to <datum>"
git push -u origin claude/document-project-history-Zntdi
```
