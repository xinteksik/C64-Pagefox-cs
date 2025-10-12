"""
patch_at_offset.py

Vloží obsah source souboru do target souboru od offsetu (hex nebo decimal).
Vytvoří zálohu targetu (pokud --no-backup nepovolíte). Lze povolit rozšíření targetu
(padding) pomocí --expand a volitelně zvolit pad byte (--pad 00 nebo FF).

Příklad:
  python3 patch_at_offset.py --src new.bin --dst image.bin --offset 0x1A2
  python3 patch_at_offset.py -s new.bin -d image.bin -o 0x200 --expand --pad FF
"""

import argparse
import shutil
from pathlib import Path
import sys

def parse_args():
    p = argparse.ArgumentParser(description="Vloží obsah src do dst od zadaného offsetu (hex nebo dec).")
    p.add_argument("-s", "--src", required=True, help="Zdrojový soubor (binarni) whose bytes will be inserted.")
    p.add_argument("-d", "--dst", required=True, help="Cílový soubor (binarni) to be modified.")
    p.add_argument("-o", "--offset", required=True,
                   help="Offset where to start writing. Accepts hex (0x...) or decimal.")
    p.add_argument("--no-backup", action="store_true", help="Neprovádět zálohu cílového souboru.")
    p.add_argument("--expand", action="store_true", help="Pokud offset+len(src) > len(dst), rozšířit dst pomocí pad byte.")
    p.add_argument("--pad", default="00", help="Pad byte used when expanding (hex 00..FF). Default 00.")
    p.add_argument("--backup-ext", default=".bak", help="Přípona pro zálohu. Default .bak")
    return p.parse_args()

def main():
    args = parse_args()

    src_path = Path(args.src)
    dst_path = Path(args.dst)

    if not src_path.is_file():
        print(f"ERROR: source file '{src_path}' neexistuje.", file=sys.stderr)
        sys.exit(2)
    if not dst_path.exists():
        print(f"Poznámka: target '{dst_path}' neexistuje — pokud --expand není uvedeno, bude vytvořen a naplněn padem.", file=sys.stderr)

    # parse offset
    try:
        offset = int(args.offset, 0)
    except Exception:
        print("ERROR: nelze převést offset. Použijte např. 0x1A2 nebo 420.", file=sys.stderr)
        sys.exit(2)
    if offset < 0:
        print("ERROR: offset musí být nezáporný.", file=sys.stderr)
        sys.exit(2)

    # pad byte
    try:
        pad_byte = int(args.pad, 16) & 0xFF
    except Exception:
        print("ERROR: pad musí být hex byte (např. 00 nebo FF).", file=sys.stderr)
        sys.exit(2)

    # read source
    src_data = src_path.read_bytes()
    src_len = len(src_data)

    # backup
    if dst_path.exists() and not args.no_backup:
        bak = dst_path.with_name(dst_path.name + args.backup_ext)
        shutil.copy2(dst_path, bak)
        print(f"Vytvořena záloha: {bak}")

    # open/create dst
    # ensure directory exists
    dst_path.parent.mkdir(parents=True, exist_ok=True)

    # if not exists, create empty file
    if not dst_path.exists():
        dst_path.write_bytes(b"")

    dst_data = bytearray(dst_path.read_bytes())
    dst_len_before = len(dst_data)

    write_end = offset + src_len
    if write_end > dst_len_before:
        if not args.expand:
            print(f"ERROR: zápis by přesáhl konec targetu ({write_end} > {dst_len_before}). Použijte --expand pro rozšíření.", file=sys.stderr)
            sys.exit(3)
        # rozšíříme pad-bytem
        pad_count = write_end - dst_len_before
        dst_data.extend(bytes([pad_byte]) * pad_count)
        print(f"Target rozšířen o {pad_count} bytes (pad={args.pad}).")

    # insert source bytes
    dst_data[offset:offset+src_len] = src_data

    # write back
    dst_path.write_bytes(bytes(dst_data))
    print(f"Hotovo. Zapsáno {src_len} bytů do '{dst_path}' od offsetu {hex(offset)}.")
    print(f"Velikost targetu: {len(dst_data)} (před: {dst_len_before}).")

if __name__ == "__main__":
    main()
