# decode_rle_9b_minus1.py
# Použití: python decode_rle_9b_minus1.py input.prg output.prg
# Formát: 9B <count> <value> => repeat <value> (count-1)-krát

import sys
from pathlib import Path

MARK = 0x9B

def decode_rle_9b(data: bytes) -> bytes:
    out = bytearray()
    i = 0
    n = len(data)
    while i < n:
        b = data[i]
        if b == MARK:
            if i + 2 >= n:
                raise ValueError(f"Nedostatek bajtů po 0x9B na offsetu {i}")
            count = data[i+1]
            value = data[i+3]
            if count == 0:
                raise ValueError(f"Neplatná délka 0 po 0x9B na offsetu {i}")
            out.extend([value] * (count))
            i += 4
        else:
            out.append(b)
            i += 1
    return bytes(out)

def main():
    if len(sys.argv) != 3:
        print("Použití: python decode_rle_9b_minus1.py input.prg output.prg")
        sys.exit(1)

    inp = Path(sys.argv[1])
    outp = Path(sys.argv[2])

    raw = inp.read_bytes()

    # první 2 bajty = load adresa
    load_addr = raw[:2]
    payload = raw[2:]

    decoded_payload = decode_rle_9b(payload)

    outp.write_bytes(load_addr + decoded_payload)

    print(f"Hotovo: {inp} ({len(raw)} B) -> {outp} ({len(load_addr)+len(decoded_payload)} B)")

if __name__ == "__main__":
    main()
