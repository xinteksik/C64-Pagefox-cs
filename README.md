# Pagefox (Czech translation for Commodore 64/128)
![Profile Views](https://github-vistors-counter.onrender.com/github?username=xinteksik)
![GitHub last commit](https://img.shields.io/github/last-commit/xinteksik/C64-Pagefox-cs)
![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/xinteksik/C64-Pagefox-cs/total)

This repository contains the **Czech translation of Pagefox** for the **Commodore 64 and Commodore 128**.  
Included are:

- source files for **Czech** and **German** version, partially commented
- **24-pin dot matrix printer** support configurable in the source code
- default **device number** configurable in the source code
- support **sd2iec/softiec** configurable in the source code
- the translated **user manual** to Czech 
- **font tools** for creating and editing custom fonts  
- a **basic text editor** adapted for Pagefox  

Pagefox is a classic desktop publishing (DTP) cartridge for the C64/128, originally released in the 1987.  
This project makes it more accessible for Czech users, while keeping compatibility with the original software.

The project is based on Pagefox by scanntronik.de

---

👉 **English summary:**
This repository provides a Czech translation of the Pagefox desktop publishing cartridge for the Commodore 64/128. It includes the translated manual, Czech-localized fonts (ZS series), and tools for font editing and Pagefox text handling. Each release adds improvements such as new keyboard mappings, diacritic fixes, and application translation. The tools folder contains utilities for extracting, editing, and rebuilding ZS font files, plus a Pagefox-compatible text editor.

---

## Pagefox CS - verze 1.0 (Odstraněno)
- obsahuje češtinu a původní rozložení kláves, např.: CBM + a = á
*(English: Version 1.0 with Czech fonts and original keyboard layout. Removed in later releases.)*
- součástí jsou české fonty ZS1, ZS10 a ZS40

## Pagefox CS - verze 2.0 (Odstraněno)
*(English: New keyboard mapping, extended Czech font support, font and diacritic fixes, and full Czech translation.)*
- obsahuje češtinu a nové rozložení kláves např.: 8 = á, SHIFT + 8 = 8, CBM + 8 = (
- součástí jsou české fonty ZS1, ZS2, ZS3, ZS105, ZS30, ZS10, ZS111 a ZS40
- oprava dvojteček (> na :)
- oprava fontů (například háčky u ď, ť a ľ, pak třeba vrácena tvrdá mezera SHIFT+SPACE) 
- překlad aplikace do češtiny

## Pagefox CS - verze 2.2 (Odstraněno)
*(English: Extended font collection ZS1–ZS5, improved punctuation handling, diacritic corrections, and application translated into Czech.)*
- obsahuje češtinu a nové rozložení kláves např.: 8 = á, SHIFT + 8 = 8, CBM + 8 = (
- součástí jsou české fonty ZS1, ZS2, ZS3, ZS4, ZS30, ZS111, ZS105, ZS5, ZS10 a ZS40 (ZS1 až ZS4 jsou počeštěné podle originál Pagefox písma, ZS5 je ZS3 z verze 2.0)
- oprava dvojteček (> na :)
- oprava fontů (například háčky u ď, ť a ľ, pak třeba vrácena tvrdá mezera SHIFT+SPACE) 
- překlad aplikace do češtiny

## Pagefox CS - verze 2.4 (Deprecated)
*(English: Extended font collection ZS1–ZS5, improved punctuation handling, diacritic corrections, and application translated into Czech.)*
- obsahuje češtinu a nové rozložení kláves např.: 8 = á, SHIFT + 8 = 8, CBM + 8 = (
- součástí jsou české fonty ZS1, ZS161, ZS2, ZS3, ZS4, ZS30, ZS111, ZS5, ZS10 a ZS40 (ZS1 až ZS4 jsou počeštěné podle originál Pagefox písma, ZS5 je ZS3 z verze 2.0 a ZS161)
- odebráno písmo ZS105
- přidáno písmo ZS161, což je stejné jako ZS1, jen obsahuje pouze velká písmena, ale včetně diakritiky (Tomáš napíše jako TOMÁŠ)
- oprava dvojteček (> na :)
- oprava fontů (například háčky u ď, ť a ľ, pak třeba vrácena tvrdá mezera SHIFT+SPACE) 
- překlad aplikace do češtiny

## Pagefox CS - verze 2.5
*(English: Same as version 2.4 and improved punctuation handling, diacritic corrections, and application translated into Czech. Partially completed disassembly, which makes it easier to edit the known sections.)*

- !!! Pagefox umí otevřít české texty ve formátu Vizawrite !!!
- !!! Pagefox pagefox-cs-2.5-24pin.crt s nativní podporou pro 24 jehličkové tiskárny (integrován pg-24.prg) - experimental!!!

- obsahuje češtinu a nové rozložení kláves např.: 8 = á, SHIFT + 8 = 8, CBM + 8 = (
- součástí jsou české fonty ZS1, ZS161, ZS2, ZS3, ZS4, ZS30, ZS111, ZS5, ZS10 a ZS40 (ZS1 až ZS4 jsou počeštěné podle originál Pagefox písma, ZS5 je ZS3 z verze 2.0 a ZS161)
- odebráno písmo ZS105
- přidáno písmo ZS161, což je stejné jako ZS1, jen obsahuje pouze velká písmena, ale včetně diakritiky (Tomáš napíše jako TOMÁŠ)
- oprava dvojteček (> na :)
- oprava fontů (například háčky u ď, ť a ľ, pak třeba vrácena tvrdá mezera SHIFT+SPACE) 
- částečně dissassemblovaný zdroják ve složce [src](src/)
- díky popisu asm v ACME formátu lze lépe řešit modifikace
- zdokumentovány sekce pro výchozí změnu barev aplikace 
- popsané písma
- přeložené texty
- mapování české klávesnice
- zmapován výpis textů na úvodní stránce
 
<img width="640" height="541" alt="pagefox2" src="https://github.com/user-attachments/assets/befc33b9-fcfd-4a07-821d-9ac510798604" />

<img width="640" height="541" alt="pagefox1" src="https://github.com/user-attachments/assets/dc9d6947-837f-4979-86d1-44bbc7f7ebe8" />

## Návod / Manual
*(English: A draft Czech translation of the full Pagefox manual.)*

[pagefox-cs-2.2.pdf](pagefox-cs-2.2.pdf)

## Písma / Fonts
*(English:Fonts with preview.)*

Písma s náhledem.

[Písma/Fonts](fonts/)

## Tools
*(English: Folder `tools` includes helper utilities for fonts, Pagefox file handling and a Czech-enabled CHARACTER FOX version.)*
Ve složce [tools](tools/) jsou pomocné nástroje, kdyby chtěl někdo laborovat třeba s fonty a vytvořit si tak vlastní balík. Přiložil jsem i počeštěnou novou verzi CHARACTER FOXu, která už umí správně uložit rozestup mezi znaky (CBM + H).

### zs_viewer.py
*(English: Loads ZS fonts and exports them as PNG images, supports batch processing.)*

Umí načíst písmo například ze souboru ZS1 a uložit jeho podobu jako obrázek. Umí zpracovat i dávkově soubory ve složkách. Praktické, pro rychlý náhled znakových sad.

```cmd
zs_viewer.py zs70.prg --text "Na pasece se pase kun."
```

<img width="640" height="480" alt="zs70" src="https://github.com/user-attachments/assets/1a2457f7-4397-4ef7-9864-07eba153012f" />
<img width="640" alt="zs70_text" src="https://github.com/user-attachments/assets/ce1caa9b-3a33-4842-b0c7-0113b2d13113" />


### cfox-cs.prg
*(English: Updated CHARACTER FOX with proper font spacing for Czech diacritics.)*

Nová verze CHARACTER FOX se pozná pokud po zadání LIST vypíše řádek s číslem 2 a následně s textem sys(2063). Problém je, že Printfox má výchozí rozestup roven 1 a tak většina českých fontů kolujících po internetu má uložen rozestup 0. S tím má pak problém Pagefox, ale lze to obejít zadáním rozestupu u definice fontu.
Nicméně pro uložení fontů jako součást Pagefox je dobré tam ten rozetup mít.

### extract_zs.py 
*(English: Extracts fonts from ZS BIN files for further editing or re-import.)*

Rozbalí ze souboru ZS3.BIN uložené fonty a pojmenuje je podle uložené hlavičky. Takto rozbalené fonty je možné upravit, zobrazit v CHARACTER FOX a uložit. 
Pozor ale na to, že CHARACTER FOX ukládá ZS komprimované (je tam zkráceno opakování stejných znaků po sobě - RLE).

### unrle.py
*(English: Converts compressed RLE ZS files into raw format for compatibility.)*

Upraví ZS soubory tak, aby byly zpětně kompatibilní a tedy bez komprese.

### joinzs_fix.py
*(English: Rebuilds a Pagefox BIN with selected fonts, requires proper first-start parameter.)*

Pospojuje vybrané ZS soubory zpět do BIN souboru, který je možné spojit se souborem 79.BIN a vytvořit si tak vlastní Pagefox s vlastními fonty. Je potřeba nezapomenout na parametr --first-start $0031.
Pozor - soubor s fonty jsou vlastně dvě banky dat - nejprve se plní jedna a pak druhá.
Minimum je mít font ZS1 (základní), ZS2 (Textový popisek o autorovi na hlavní stránce) a ZS40 (tvoří nápis Pagefox na hlavní stránce).

Příklad ověření: Vyextrahuji všechny fonty. Otevřu například zs1.prg v poslední verzí CHARACTER FOX a jen uložím. Vznikne zabalený zs1.prg, který rozbalím. Pokud porovnám originál a uložený a rozbalený, měl by být obsahově totožný.

### pagefox_text_editor_cs.py
*(English: A Pagefox text editor with Czech key mapping, customizable for other languages.)*

Toto je textový editor pro otevření a také pro uložení textu v Pagefox formátu. Program obsahuje mapování na české znaky a lze přemapovat do libovolného jiného jazyku.

<img width="640" height="480" alt="Snímek obrazovky 2025-09-09 v 9 06 28" src="https://github.com/user-attachments/assets/b7021f18-229b-4837-859b-984b0ac91cf1" />

### zs_typesetter.py
*(English: Converts PT files into PNG previews using ZS fonts.)*

Převede PT soubor a v něm uvedený text s použitím znakových sad vypíše do PNG. Takový náhled textu vytvořeného v editoru.
```cmd
zs_typesetter.py --editor navod-5-t.pt.prg --font-dir . --out vystup5.png
```

<img width="640" height="800" alt="vystup4" src="https://github.com/user-attachments/assets/f6374cbc-af42-43ee-82b6-568737f8c426" />

### convert_prg_to_png.py
*(English: Auto-detects Pagefox PG / Printfox BS/GB image files and converts them to PNG.)*

Automaticky rozpozná formát PG (Pagefox), BS (320×200) a GB (640×400), dekóduje RLE a vykreslí 1bpp obraz do PNG.

### convert_png_to_prg.py

(English: Encodes PNG (1bpp thresholded) into Pagefox PG / Printfox BS/GB with correct RLE.)

Převede rastrový PNG (případně dávku ve složce) do PG / BS / GB. Vstup převádí na 1bpp (černá=1, bílá=0; lze invertovat). Pro BS/GB používá standardní RLE 9B <lo><hi> <v> (od délky 4), pro PG používá symetrické RLE včetně speciálních bloků 256× a escape literálu 0x9B.


## To do list
- Odebrat font ZS31, protože vytvořit stín umí přímo Pagefox. Tím se uvolní místo na jiné fonty. - Hotovo
- Přidat fonty jako například ZS6, ZS105, ZS111, ZS156 a ZS193. - Hotovo
- Prověřit, zda ZS3 a ZS4 má smysl. Nekteré byly stejné, jen tam byla řeská abeceda, ale ta když se nezachová, ztrácí font smysl. - Hotovo
- Nějaký nápad ?? - Český návod :D - Hotovo, bez korekce

### Weblinks
- https://www.c64.cz/index.php?recenze=software_dvaroky
- https://www.c64-wiki.de/wiki/Pagefox (wiki, popis v němčině)
- https://mega.nz/folder/Q7pRTCbB#sbPZOKwAx27SY4ydrL4KoA (Pagefox Demodiskette, Pagefox Grafiksammlungen, Zeichensätzen, Charakterfox, Eddifox, Pin24 Druckertreiber)
- https://www.hackup.net/2021/08/pagefox-reverse-engineered-and-replicated/

---
**Keywords:** Commodore 64, Commodore 128, C64, C128, Pagefox, Czech translation, desktop publishing, DTP, retro computing, vintage software, character sets, fonts, tools


