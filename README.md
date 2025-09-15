# C64-Pagefox-cs
Tento repozitář obsahuje český překlad Pagefox pro Commodore 64/128 včetně návodu a nástrojů pro fonty a editaci.

This project is based on Pagefox by scanntronik.de

## Pagefox CS - verze 1.0 (Odstraněno)
- obsahuje češtinu a původní rozložení kláves, např.: CBM + a = á
- součástí jsou české fonty ZS1, ZS10 a ZS40

## Pagefox CS - verze 2.0
- obsahuje češtinu a nové rozložení kláves např.: 8 = á, SHIFT + 8 = 8, CBM + 8 = (
- součástí jsou české fonty ZS1, ZS2, ZS3, ZS105, ZS30, ZS10, ZS111 a ZS40
- oprava dvojteček (> na :)
- oprava fontů (například háčky u ď, ť a ľ, pak třeba vrácena tvrdá mezera SHIFT+SPACE) 
- překlad aplikace do češtiny


<img width="640" height="541" alt="pagefox2" src="https://github.com/user-attachments/assets/befc33b9-fcfd-4a07-821d-9ac510798604" />

<img width="640" height="541" alt="pagefox1" src="https://github.com/user-attachments/assets/dc9d6947-837f-4979-86d1-44bbc7f7ebe8" />

## Návod
Ve složce [navod](navod/) jsou obrázky stránek z návodu. Jde o amatérský překlad kompletního návodu. 

## Tools
Ve složce [tools](tools/) jsou pomocné nástroje, kdyby chtěl někdo laborovat třeba s fonty a vytvořit si tak vlastní balík. Přiložil jsem i počeštěnou novou verzi CHARACTER FOXu, která už umí správně uložit rozestup mezi znaky (CBM + H).

### zs_viewer.py
Umí načíst písmo například ze souboru ZS1 a uložit jeho podobu jako obrázek. Umí zpracovat i dávkově soubory ve složkách. Praktické, pro rychlý náhled znakových sad.

```cmd
zs_viewer.py zs70.prg --text "Na pasece se pase kun."
```

<img width="640" height="480" alt="zs70" src="https://github.com/user-attachments/assets/1a2457f7-4397-4ef7-9864-07eba153012f" />
<img width="640" height="480" alt="zs70_text" src="https://github.com/user-attachments/assets/ce1caa9b-3a33-4842-b0c7-0113b2d13113" />




### cfox-cs.prg
Nová verze CHARACTER FOX se pozná pokud po zadání LIST vypíše řádek s číslem 2 a následně s textem sys(2063). Problém je, že Printfox má výchozí rozestup roven 1 a tak většina českých fontů kolujících po internetu má uložen rozestup 0. S tím má pak problém Pagefox, ale lze to obejít zadáním rozestupu u definice fontu.
Nicméně pro uložení fontů jako součást Pagefox je dobré tam ten rozetup mít.

### extract_zs.py 
Rozbalí ze souboru ZS3.BIN uložené fonty a pojmenuje je podle uložené hlavičky. Takto rozbalené fonty je možné upravit, zobrazit v CHARACTER FOX a uložit. 
Pozor ale na to, že CHARACTER FOX ukládá ZS komprimované (je tam zkráceno opakování stejných znaků po sobě - RLE).

### unrle.py
Upraví ZS soubory tak, aby byly zpětně kompatibilní a tedy bez komprese.

### joinzs_fix.py
Pospojuje vybrané ZS soubory zpět do BIN souboru, který je možné spojit se souborem 79.BIN a vytvořit si tak vlastní Pagefox s vlastními fonty. Je potřeba nezapomenout na parametr --first-start $0031.
Pozor - soubor s fonty jsou vlastně dvě banky dat - nejprve se plní jedna a pak druhá.
Minimum je mít font ZS1 (základní), ZS2 (Textový popisek o autorovi na hlavní stránce) a ZS40 (tvoří nápis Pagefox na hlavní stránce).

Příklad ověření: Vyextrahuji všechny fonty. Otevřu například zs1.prg v poslední verzí CHARACTER FOX a jen uložím. Vznikne zabalený zs1.prg, který rozbalím. Pokud porovnám originál a uložený a rozbalený, měl by být obsahově totožný.

### pagefox_text_editor_cs.py
Toto je textový editor pro otevření a také pro uložení textu v Pagefox formátu. Program obsahuje mapování na české znaky a lze přemapovat do libovolného jiného jazyku.

<img width="640" height="480" alt="Snímek obrazovky 2025-09-09 v 9 06 28" src="https://github.com/user-attachments/assets/b7021f18-229b-4837-859b-984b0ac91cf1" />

### pagefox_text_editor_cs.py
Převede PT soubor a v něm uvedený text s použitím znakových sad vypíše do PNG. Takový náhled textu vytvořeného v editoru.
```cmd
zs_typesetter.py --editor navod-5-t.pt.prg --font-dir . --out vystup5.png
```

<img width="640" height="800" alt="vystup4" src="https://github.com/user-attachments/assets/f6374cbc-af42-43ee-82b6-568737f8c426" />

## To do list
- Odebrat font ZS31, protože vytvořit stín umí přímo Pagefox. Tím se uvolní místo na jiné fonty. - Hotovo
- Přidat fonty jako například ZS6, ZS105, ZS111, ZS156 a ZS193. - Hotovo
- Prověřit, zda ZS3 a ZS4 má smysl. Nekteré byly stejné, jen tam byla řeská abeceda, ale ta když se nezachová, ztrácí font smysl. - Hotovo
- Nějaký nápad ?? - Český návod :D - Hotovo, bez korekce

### Weblinks
- https://www.c64-wiki.de/wiki/Pagefox (wiki, popis v němčině)
- https://mega.nz/folder/Q7pRTCbB#sbPZOKwAx27SY4ydrL4KoA (Pagefox Demodiskette, Pagefox Grafiksammlungen, Zeichensätzen, Charakterfox, Eddifox, Pin24 Druckertreiber)
- https://www.hackup.net/2021/08/pagefox-reverse-engineered-and-replicated/


![Profile Views](https://github-vistors-counter.onrender.com/github?username=xinteksik)
