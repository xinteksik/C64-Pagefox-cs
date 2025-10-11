# -*- coding: utf-8 -*-
"""
8x8 Bitmap Click Tool
- Click cells to toggle pixels.
- Paste custom hex (e.g., "FF FC FC FC FC FC FC FF") and render.
- Accepts: spaces/commas/newlines, 0x-prefixed bytes, or a continuous 16-hex string.
- Shows 8 hex bytes (one per row, MSB = leftmost pixel).
- Buttons: Clear, Invert, Load from Hex, Copy Hex, Copy Binary, Copy C Array.
"""
import tkinter as tk
from tkinter import ttk, messagebox
import re

CELL_SIZE = 36
GRID = 8

BG_ON = "#111111"
BG_OFF = "#ffffff"
BORDER = "#cccccc"

class Bitmap8x8(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("8x8 Bitmap Tool (Hex Rows)")
        self.resizable(False, False)

        self.state = [[0 for _ in range(GRID)] for _ in range(GRID)]  # row-major

        # UI
        main = ttk.Frame(self, padding=10)
        main.grid(row=0, column=0, sticky="nsew")

        # Grid of toggle buttons
        self.cells = []
        grid_frame = ttk.Frame(main)
        grid_frame.grid(row=0, column=0, rowspan=3, padx=(0, 12))

        style = ttk.Style(self)
        style.configure("Pixel.TButton", relief="flat")
        style.map("Pixel.TButton", background=[("active", BG_ON)])

        for r in range(GRID):
            row_cells = []
            for c in range(GRID):
                btn = tk.Canvas(grid_frame, width=CELL_SIZE, height=CELL_SIZE, highlightthickness=1, highlightbackground=BORDER, bg=BG_OFF)
                btn.grid(row=r, column=c, padx=1, pady=1)
                btn.bind("<Button-1>", lambda e, rr=r, cc=c: self.toggle(rr, cc))
                btn.bind("<B1-Motion>", lambda e, rr=r, cc=c: self.paint(rr, cc, e))
                row_cells.append(btn)
            self.cells.append(row_cells)

        # Right side: outputs + controls
        right = ttk.Frame(main)
        right.grid(row=0, column=1, sticky="nw")

        ttk.Label(right, text="Hex (rows, MSB=left):").grid(row=0, column=0, sticky="w")
        self.hex_var = tk.StringVar()
        self.hex_entry = ttk.Entry(right, textvariable=self.hex_var, width=34)
        self.hex_entry.grid(row=1, column=0, pady=(2, 6), sticky="we")
        self.hex_entry.bind("<Return>", lambda e: self.load_hex())

        ttk.Button(right, text="Načíst z Hex", command=self.load_hex).grid(row=2, column=0, pady=(0,10), sticky="we")

        ttk.Label(right, text="Binary (rows):").grid(row=3, column=0, sticky="w")
        self.bin_text = tk.Text(right, width=34, height=4, wrap="none")
        self.bin_text.grid(row=4, column=0, pady=(2, 10), sticky="we")

        # Controls
        controls = ttk.Frame(right)
        controls.grid(row=5, column=0, sticky="we")
        ttk.Button(controls, text="Clear", command=self.clear).grid(row=0, column=0, padx=(0,6))
        ttk.Button(controls, text="Invert", command=self.invert).grid(row=0, column=1, padx=(0,6))
        ttk.Button(controls, text="Copy Hex", command=self.copy_hex).grid(row=0, column=2, padx=(0,6))
        ttk.Button(controls, text="Copy Bin", command=self.copy_bin).grid(row=0, column=3, padx=(0,6))

        ttk.Button(right, text="Copy C Array (uint8_t[8])", command=self.copy_c_array).grid(row=6, column=0, pady=(8,0), sticky="we")

        # Footer help
        help_lbl = ttk.Label(main, text="Tip: vlož hex jako \"FF FC FC FC FC FC FC FF\" nebo 16 hex znaků bez mezer (např. FFFCFCFCFCFCFCFF). Enter/Načíst z Hex vykreslí. Levý pixel = bit7 (MSB).", foreground="#555")
        help_lbl.grid(row=3, column=0, columnspan=2, pady=(10,0), sticky="w")

        self.update_outputs()

    def toggle(self, r, c):
        self.state[r][c] ^= 1
        self.refresh_cell(r, c)
        self.update_outputs()

    def paint(self, r, c, event):
        # While dragging, turn ON the cell under cursor
        if self.state[r][c] == 0:
            self.state[r][c] = 1
            self.refresh_cell(r, c)
            self.update_outputs()

    def refresh_cell(self, r, c):
        self.cells[r][c].configure(bg=BG_ON if self.state[r][c] else BG_OFF)

    def clear(self):
        for r in range(GRID):
            for c in range(GRID):
                self.state[r][c] = 0
                self.refresh_cell(r, c)
        self.update_outputs()

    def invert(self):
        for r in range(GRID):
            for c in range(GRID):
                self.state[r][c] ^= 1
                self.refresh_cell(r, c)
        self.update_outputs()

    def rows_to_bytes(self):
        """Return list of 8 integers (0-255), one per row. Leftmost pixel is bit7 (MSB)."""
        bytes_out = []
        for r in range(GRID):
            v = 0
            for c in range(GRID):
                v = (v << 1) | (self.state[r][c] & 1)
            bytes_out.append(v)
        return bytes_out

    def bytes_to_rows(self, byte_list):
        """Given list of 8 integers (0-255), set the grid. Leftmost pixel = bit7."""
        for r in range(GRID):
            b = byte_list[r] & 0xFF
            for c in range(GRID):
                bit = (b >> (7 - c)) & 1
                self.state[r][c] = bit
                self.refresh_cell(r, c)
        self.update_outputs()

    def parse_hex_bytes(self, s):
        """Parse 8 bytes from string. Accepts spaced/CSV/newlines, 0x-prefixed, or 16 hex chars continuous."""
        s = s.strip()
        if not s:
            raise ValueError("Vstup je prázdný.")
        # If it's exactly 16 hex chars without separators, chunk by 2.
        compact = re.fullmatch(r'[0-9A-Fa-f]{16}', s.replace(" ", ""))
        if compact and len(s.replace(" ", "")) == 16 and (" " not in s and "," not in s and "\n" not in s and "\t" not in s):
            raw = s
            bytes16 = [int(raw[i:i+2], 16) for i in range(0, 16, 2)]
            return bytes16

        # Normalize 0x prefixes by removing them
        norm = re.sub(r'0x', '', s, flags=re.IGNORECASE)
        # Find all 1-2 digit hex groups
        tokens = re.findall(r'[0-9A-Fa-f]{1,2}', norm)
        if len(tokens) != 8:
            raise ValueError(f"Očekávám přesně 8 hex bajtů, ale našel jsem {len(tokens)}: {tokens}")
        return [int(t, 16) for t in tokens]

    def load_hex(self):
        s = self.hex_var.get()
        try:
            by = self.parse_hex_bytes(s)
        except Exception as e:
            messagebox.showerror("Chyba při načítání", str(e))
            return
        self.bytes_to_rows(by)

    def update_outputs(self):
        by = self.rows_to_bytes()
        hex_str = " ".join(f"{b:02X}" for b in by)
        # Only mirror to the entry if the user is NOT currently editing it
        if self.focus_get() is not self.hex_entry:
            self.hex_var.set(hex_str)

        # Binary rows
        self.bin_text.delete("1.0", "end")
        for b in by:
            self.bin_text.insert("end", format(b, "08b") + "\n")

    def copy_hex(self):
        self.clipboard_clear()
        self.clipboard_append(" ".join(f"{b:02X}" for b in self.rows_to_bytes()))
        self.update()  # keep on some platforms

    def copy_bin(self):
        self.clipboard_clear()
        self.clipboard_append(self.bin_text.get("1.0", "end-1c"))
        self.update()

    def copy_c_array(self):
        by = self.rows_to_bytes()
        arr = "{ " + ", ".join(f"0x{b:02X}" for b in by) + " }"
        self.clipboard_clear()
        self.clipboard_append(arr)
        self.update()

if __name__ == "__main__":
    app = Bitmap8x8()
    app.mainloop()
