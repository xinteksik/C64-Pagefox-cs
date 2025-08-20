# C64-Pagefox-cs
This project is based on Pagefox by scanntronik.de

## Pagefox CS - verze 1.0
- obsahuje češtinu a původní rozložení kláves, např.: CBM + a = á
- součástí jsou české fonty ZS1, ZS10 a ZS40

## Pagefox CS - verze 2.0
- obsahuje češtinu a nové rozložení kláves např.: 8 = á, SHIFT + 8 = 8, CBM + 8 = (
- součástí jsou české fonty ZS1, ZS2, ZS3, ZS4, ZS10, ZS30, ZS31 a ZS40
- oprava dvojteček (> na :) 
- překlad aplikace do češtiny (kde to šlo)

## Tools
Ve složce tools jsou pomocné nástroje, kdyby chtěl někdo laborovat třeba s fonty a vytvořit si tak vlastní balík.

### extract_zs.py 
Rozbalí ze souboru ZS3.BIN uložené fonty a pojmenuje je podle uložené hlavičky. Takto rozbalené fonty je možné upravit, zobrazit v CHARACTER FOX a uložit. Pozor ale na to, že CFOX ukládá ZS komprimované (je zkráceno tam opakování stejných znaků po sobě).

### unrle.py
Upraví ZS soubory tak, aby byly zpětně kompatibilní a tedy bez komprese.

### joinzs_fix.py
Pospojuje vybrané ZS soubory zpět do BIN souboru, který je možné spojit se souborem 79.BIN a vytvořit si tak vlastní Pagefox s vlastními fonty. Pozor - soubor s fonty jsou vlastně dvě banky dat. Sloučení se děje do dvou 16k bank.

Příklad ověření: Vyextrahuji všechny fonty. Otevřu například zs1.prg v CFOX a jen uložím. Vznikne zabalený zs1.prg, který rozbalím. Pokud porovnám originál a uložený a rozbalený, měl by být obsahově totožný.


![Profile Views](https://github-vistors-counter.onrender.com/github?username=xinteksik)
