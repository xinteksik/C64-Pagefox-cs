# C64-Pagefox-cs
This project is based on Pagefox by scanntronik.de

## Pagefox CS - verze 1.0
- obsahuje češtinu a původní rozložení kláves, např.: CBM + a = á
- součástí jsou české fonty ZS1, ZS10 a ZS40

## Pagefox CS - verze 2.0
- obsahuje češtinu a nové rozložení kláves např.: 8 = á, SHIFT + 8 = 8, CBM + 8 = (
- součástí jsou české fonty ZS1, ZS2, ZS3, ZS4, ZS10, ZS30, ZS111, ZS156, ZS193 a ZS40
- oprava dvojteček (> na :)
- oprava fontů (například háčky u ď, ť a ľ, pak třeba vrácena tvrdá mezera SHIFT+SPACE) 
- překlad aplikace do češtiny

## Tools
Ve složce tools jsou pomocné nástroje, kdyby chtěl někdo laborovat třeba s fonty a vytvořit si tak vlastní balík. Přiložil jsem i počeštěnou novou verzi CHARACTER FOXu, která už umí správně uložit rozestup mezi znaky (CBM + H).

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

### To do list
- Odebrat font ZS31, protože vytvořit stín umí přímo Pagefox. Tím se uvolní místo na jiné fonty. - Hotovo
- Přidat fonty jako například ZS6, ZS105, ZS111, ZS156 a ZS193. - Hotovo
- Prověřit, zda ZS3 a ZS4 má smysl. Nekteré byly stejné, jen tam byla řeská abeceda, ale ta když se nezachová, ztrácí font smysl.

![Profile Views](https://github-vistors-counter.onrender.com/github?username=xinteksik)
