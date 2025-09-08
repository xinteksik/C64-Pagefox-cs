import csv
import json
import os
import re
from tkinter import Tk, Text, Menu, filedialog, messagebox, simpledialog, StringVar, BooleanVar, END, Label

APP_NAME = "PFxText – Pagefox/Printfox Binary Editor"

# --- Default mapping baked-in (from user's spec) ---
# You can extend this mapping (or load an external CSV/JSON at runtime).
DEFAULT_MAPPING = {
    " ": 0x20, ".": 0x2E, "!": 0x21, '"': 0x22, "#": 0x23, "(": 0x28, ")": 0x29,
    "*": 0x2A, "+": 0x2B, ",": 0x2C, "-": 0x2D, "↑": 0x5E, "/": 0x2F, "←": 0x5F,
    "→": 0x8D, "↓": 0x8E, "$": 0x24, "%": 0x25, "&": 0x26, "'": 0x27, "(": 0x28,
    ")": 0x29,
    # digits
    "0": 0x30, "1": 0x31, "2": 0x32, "3": 0x33, "4": 0x34,
    "5": 0x35, "6": 0x36, "7": 0x37, "8": 0x38, "9": 0x39,
    # specials per user
    ">": 0x3A, "<": 0x3B, "=": 0x3D, "ž": 0x3E, "?": 0x3F, "§": 0x40,
    # A..Z
    "A": 0x41, "B": 0x42, "C": 0x43, "D": 0x44, "E": 0x45, "F": 0x46, "G": 0x47, "H": 0x48, "I": 0x49, "J": 0x4A,
    "K": 0x4B, "L": 0x4C, "M": 0x4D, "N": 0x4E, "O": 0x4F, "P": 0x50, "Q": 0x51, "R": 0x52, "S": 0x53, "T": 0x54,
    "U": 0x55, "V": 0x56, "W": 0x57, "X": 0x58, "Y": 0x59, "Z": 0x5A,
    # bracket swap per user
    "]": 0x5B, "[": 0x5C,
    # user's explicit: 'ú' at 0x60
    "ú": 0x60,
    # a..z
    "a": 0x61, "b": 0x62, "c": 0x63, "d": 0x64, "e": 0x65, "f": 0x66, "g": 0x67, "h": 0x68, "i": 0x69, "j": 0x6A,
    "k": 0x6B, "l": 0x6C, "m": 0x6D, "n": 0x6E, "o": 0x6F, "p": 0x70, "q": 0x71, "r": 0x72, "s": 0x73, "t": 0x74,
    "u": 0x75, "v": 0x76, "w": 0x77, "x": 0x78, "y": 0x79, "z": 0x7A,
    # 0x7B..0x7F
    "{": 0x7B, ":": 0x7C, "@": 0x7D, "ý": 0x7E, "_": 0x7F,
    # 0x80+ Czech diacritics
    "ĺ": 0x80, "ě": 0x81, "á": 0x82, "é": 0x83, "í": 0x84, "ó": 0x85, "ů": 0x86, "µ": 0x87, "ň": 0x88, "ď": 0x89,
    "č": 0x8A, "ř": 0x8F, "š": 0x90, "ť": 0x91
}

# Pagefox control-byte visualizations
# ----------------------------
# Zde můžeš doplňovat další řídicí znaky podle Pagefox manuálu.
# Každý řídicí kód (hex) má symbolické zobrazení ve tvaru "[x]".
# Při OPEN se bajt převede na [x], při SAVE se [x] převede zpět na bajt.
# Např.:
#   0x02 → [f]
#   0x04 → [e]  (tučné)
#   0x06 → [c]
#
CONTROL_SHOW = {
    0x01: "[*]",
    0x02: "[f]",
    0x03: "[b]",
    0x04: "[e]",
    0x05: "[u]",
    0x06: "[c]",
    0x07: "[t]",
    0x08: "[i]",
    0x09: "[?]",
    0x10: "[.]",
    0x0E: "[h]",
    0x11: "[k]",
    0x12: "[n]",
    0x18: "[o]",
    0x19: "[w]",
    0x0A: "[←]",
    0x0B: "[↑]",
    0x0C: "[↓]",
    0x1A: "[r]",
    0x0F: "[z]",
    0x5D: "[CBM]",
    0x3C: "[+-]",
    0x8C: "[<<]",
    0x8B: "[>>]",
}
CONTROL_PARSE = {v: k for k, v in CONTROL_SHOW.items()}
# Regulární výraz pro rozpoznání známých tokenů (rozšiř dle CONTROL_SHOW):
CONTROL_TOKEN_RE = re.compile(r"\[(?:%s)\]" % "|".join(re.escape(v[1:-1]) for v in CONTROL_SHOW.values()))

def build_reverse(mp: dict) -> dict:
    """Create reverse mapping: byte(int) -> unicode char."""
    rev = {}
    for ch, code in mp.items():
        try:
            rev[int(code)] = ch
        except Exception:
            pass
    return rev


class PFxEditor:
    def __init__(self, root):
        self.root = root
        self.root.title(APP_NAME)
        self.text = Text(self.root, wrap="word", undo=True, font=("Consolas", 12))
        self.text.pack(fill="both", expand=True)

        # Status bar
        self.status = Label(self.root, anchor="w")
        self.status.pack(fill="x")

        # State
        self.current_file = None
        self.mapping = dict(DEFAULT_MAPPING)
        self.placeholder_mode = StringVar(value="ignore")  # "ignore" or "replace"
        self.placeholder_char = StringVar(value="?")
        self.line_endings = StringVar(value="CR")  # "CR", "LF", "CRLF"
        self.force_uppercase = BooleanVar(value=False)
        self.show_unmapped_report = BooleanVar(value=True)

        # Binary I/O options
        self.open_skip_bytes = 0            # bytes to skip on OPEN (e.g., 2 for PRG load address)
        self.save_prepend_hex = ""          # header bytes to prepend on SAVE, e.g. "01 08"
        self.decode_unmapped_placeholder = "·"  # placeholder for unknown bytes on OPEN

        self.create_menu()

    # --- Menu ---
    def create_menu(self):
        menubar = Menu(self.root)

        # File (binary I/O)
        filemenu = Menu(menubar, tearoff=0)
        filemenu.add_command(label="Open (Binary)…", command=self.open_binary, accelerator="Ctrl+O")
        filemenu.add_command(label="Save (Binary)…", command=self.save_binary, accelerator="Ctrl+S")
        filemenu.add_separator()
        filemenu.add_command(label="Export mapping template…", command=self.export_mapping_template)
        filemenu.add_separator()
        filemenu.add_command(label="Exit", command=self.root.quit)
        menubar.add_cascade(label="File", menu=filemenu)

        # Mapping
        mapmenu = Menu(menubar, tearoff=0)
        mapmenu.add_command(label="Load Mapping (CSV)…", command=self.load_mapping_csv)
        mapmenu.add_command(label="Load Mapping (JSON)…", command=self.load_mapping_json)
        mapmenu.add_command(label="Reset Mapping to Default", command=self.reset_mapping_to_default)
        mapmenu.add_separator()
        options = Menu(mapmenu, tearoff=0)
        options.add_radiobutton(label="On unmapped at SAVE: Ignore", variable=self.placeholder_mode, value="ignore")
        options.add_radiobutton(label="On unmapped at SAVE: Replace with placeholder", variable=self.placeholder_mode, value="replace")
        options.add_separator()
        options.add_command(label="Set placeholder char…", command=self.set_placeholder_char)
        options.add_separator()
        options.add_radiobutton(label="Line endings at SAVE: CR (0x0D)", variable=self.line_endings, value="CR")
        options.add_radiobutton(label="Line endings at SAVE: LF (0x0A)", variable=self.line_endings, value="LF")
        options.add_radiobutton(label="Line endings at SAVE: CRLF (0x0D 0x0A)", variable=self.line_endings, value="CRLF")
        options.add_separator()
        options.add_checkbutton(label="Force ASCII UPPERCASE before SAVE", variable=self.force_uppercase, onvalue=True, offvalue=False)
        options.add_checkbutton(label="Show unmapped SAVE report", variable=self.show_unmapped_report, onvalue=True, offvalue=False)
        menubar.add_cascade(label="Mapping", menu=mapmenu)

        # Binary I/O options
        iomenu = Menu(menubar, tearoff=0)
        iomenu.add_command(label="Binary I/O Options…", command=self.configure_binary_io)
        menubar.add_cascade(label="Binary I/O", menu=iomenu)

        # Quick Insert (as escape text; will be parsed to bytes at SAVE)
        insertmenu = Menu(menubar, tearoff=0)
        insertmenu.add_command(label="Insert CR (\\x0D)", command=lambda: self.insert_escape("\\x0D"))
        insertmenu.add_command(label="Insert ESC (\\x1B)", command=lambda: self.insert_escape("\\x1B"))
        insertmenu.add_command(label="Insert FF (\\x0C)", command=lambda: self.insert_escape("\\x0C"))
        insertmenu.add_command(label="Insert TAB (\\x09)", command=lambda: self.insert_escape("\\x09"))
        insertmenu.add_separator()
        insertmenu.add_command(label="Insert arbitrary byte…", command=self.insert_arbitrary_byte)
        menubar.add_cascade(label="Quick Insert", menu=insertmenu)

        # Help
        helpmenu = Menu(menubar, tearoff=0)
        helpmenu.add_command(label="About", command=self.show_about)
        menubar.add_cascade(label="Help", menu=helpmenu)

        self.root.config(menu=menubar)

        # Shortcuts
        self.root.bind("<Control-o>", lambda e: self.open_binary())
        self.root.bind("<Control-s>", lambda e: self.save_binary())

        # Cursor/status updates
        self.text.bind("<KeyRelease>", lambda e: self.update_status())
        self.text.bind("<ButtonRelease>", lambda e: self.update_status())
        self.text.bind("<<Modified>>", lambda e: (self.text.edit_modified(False), self.update_status()))
        self.update_status()

    # --- Helpers ---
    
    def _get_token_byte_at_insert(self):
        """Return (desc, byte_val or None) for the token/char under cursor.
        desc is a human-readable description; byte_val is int 0..255 or None if unknown.
        """
        idx = self.text.index("insert")
        # Position info
        line, col = map(int, idx.split("."))

        # Get surrounding text to detect [x] token
        start_line_idx = f"{line}.0"
        end_line_idx = f"{line}.end"
        line_text = self.text.get(start_line_idx, end_line_idx)

        # Column within the line_text
        c = col

        # Try to see if cursor is inside a CONTROL token like [e]/[f]/[c]
        # Find all tokens in the line and check bounds
        for m in CONTROL_TOKEN_RE.finditer(line_text):
            a, b = m.span()  # [a, b)
            if a <= c < b:
                token = m.group(0)
                byte_val = CONTROL_PARSE.get(token)
                if byte_val is not None:
                    return (f"token {token}", byte_val)
                return (f"token {token}", None)

        # Otherwise, get the single character at insert (if any)
        ch = self.text.get(idx)
        if ch == "":
            return ("<eof>", None)

        # Newline case is not present in line_text (since we slice per line), but handle CR mapping when saving
        if ch == "\n":
            return ("newline", 0x0D)

        # Map via current mapping
        if ch in self.mapping:
            return (repr(ch), self.mapping[ch])

        # Maybe it's the start of an escape like \xHH – show that if present
        # Look back two chars for '\x', then read two hex digits
        try:
            back2 = self.text.get(f"{line}.{max(0, c-2)}", f"{line}.{c+2}")
            # back2 window around cursor; try to match at any position
            esc_m = re.search(r"\\x([0-9A-Fa-f]{2})", back2)
            if esc_m:
                val = int(esc_m.group(1), 16)
                return (f"escape \\x{val:02X}", val)
        except Exception:
            pass

        return (repr(ch), None)

    def update_status(self):
        # Position
        idx = self.text.index("insert")
        line, col = idx.split(".")
        desc, byte_val = self._get_token_byte_at_insert()
        byte_txt = f"0x{byte_val:02X}" if isinstance(byte_val, int) else "--"
        self.status.config(text=f"Ln {line}, Col {col}   |   {desc} → {byte_txt}")

    def set_placeholder_char(self):
        ch = simpledialog.askstring("Placeholder", "Character to insert for unmapped glyphs at SAVE (single character):", initialvalue=self.placeholder_char.get())
        if ch:
            self.placeholder_char.set(ch[:1])

    def _normalized_text(self, s: str) -> str:
        if self.force_uppercase.get():
            s = "".join([c.upper() if "a" <= c <= "z" else c for c in s])
        return s

    def _get_line_ending_bytes(self) -> bytes:
        le = self.line_endings.get()
        if le == "CR":
            return bytes([0x0D])
        elif le == "LF":
            return bytes([0x0A])
        else:
            return bytes([0x0D, 0x0A])

    def _parse_hex_bytes(self, s: str) -> bytes:
        # parse "01 08" or "0x01,0x08" etc.
        s = s.strip()
        if not s:
            return b""
        parts = re.split(r"[\s,;]+", s)
        out = bytearray()
        for p in parts:
            p = p.strip().lower()
            if not p:
                continue
            if p.startswith("0x"):
                p = p[2:]
            val = int(p, 16)
            if not (0 <= val <= 255):
                raise ValueError("byte out of range")
            out.append(val)
        return bytes(out)

    def insert_escape(self, esc: str):
        self.text.insert("insert", esc)

    def insert_arbitrary_byte(self):
        s = simpledialog.askstring("Insert byte", "Hex byte (e.g. 0D for CR, 1B for ESC):")
        if not s:
            return
        try:
            if s.lower().startswith("0x"):
                s = s[2:]
            val = int(s, 16)
            if not (0 <= val <= 255):
                raise ValueError
            self.insert_escape(f"\\x{val:02X}")
        except Exception:
            messagebox.showerror("Invalid value", "Enter a valid hex byte like 0D, 1B, 0x0C.")

    # --- Binary I/O ---
    def open_binary(self):
        path = filedialog.askopenfilename(filetypes=[("PF/PT/PRG/All", "*.pfxbin;*.pt;*.prg;*.*"), ("All files", "*.*")])
        if not path:
            return
        try:
            raw = open(path, "rb").read()
            if self.open_skip_bytes > 0 and len(raw) >= self.open_skip_bytes:
                raw = raw[self.open_skip_bytes:]
            # --- Pagefox auto trim: drop leading 0x54 ('T') and cut at first 0x00 0x00 ---
            if len(raw) >= 1 and raw[0] == 0x54:
                raw = raw[1:]
            # cut at first 0x00 0x00
            end_idx = None
            for i in range(len(raw)-1):
                if raw[i] == 0x00 and raw[i+1] == 0x00:
                    end_idx = i
                    break
            if end_idx is not None:
                raw = raw[:end_idx]
            # decode via reverse map; CR=0x0D -> \n, known controls -> [x]
            rev = build_reverse(self.mapping)
            out = []
            for b in raw:
                if b == 0x0D:
                    out.append("\n")
                elif b in CONTROL_SHOW:
                    out.append(CONTROL_SHOW[b])
                else:
                    out.append(rev.get(b, self.decode_unmapped_placeholder))
            txt = "".join(out)
            self.text.delete("1.0", END)
            self.text.insert("1.0", txt)
            self.current_file = path
            self.root.title(f"{os.path.basename(path)} – {APP_NAME}")
        except Exception as e:
            messagebox.showerror("Open failed", str(e))
    
    def _emit_with_escapes(self, s: str, out: bytearray, le_bytes: bytes, unmapped: dict):
        i = 0
        n = len(s)
        while i < n:
            ch = s[i]
            # Control tokens like [e], [f], [c]
            if ch == '[':
                m = CONTROL_TOKEN_RE.match(s, i)
                if m:
                    token = m.group(0)     # e.g. "[e]"
                    out.append(CONTROL_PARSE[token])
                    i += len(token)
                    continue

            # newlines -> chosen LE
            if ch == "\n":
                out.extend(le_bytes)
                i += 1
                continue
            if ch == "\r":
                out.extend(le_bytes)
                i += 1
                continue

            # \xHH raw insertion
            if ch == "\\" and i + 3 < n and s[i+1] == "x":
                h1, h2 = s[i+2], s[i+3]
                def is_hex(c): return c.isdigit() or ('a' <= c.lower() <= 'f')
                if is_hex(h1) and is_hex(h2):
                    out.append(int(h1 + h2, 16) & 0xFF)
                    i += 4
                    continue

            if ch in self.mapping:
                out.append(self.mapping[ch] & 0xFF)
            else:
                unmapped[ch] = unmapped.get(ch, 0) + 1
                if self.placeholder_mode.get() == "replace":
                    ph = self.placeholder_char.get()
                    if ph in self.mapping:
                        out.append(self.mapping[ph] & 0xFF)
                    else:
                        out.append(0x20)
                # else ignore
            i += 1

    def save_binary(self):
        path = filedialog.asksaveasfilename(defaultextension=".pfxbin", filetypes=[("Pagefox/Printfox binary", "*.pt.prg"), ("All files", "*.*")])
        if not path:
            return
        try:
            text = self._normalized_text(self.text.get("1.0", END).rstrip("\n\r"))
            le_bytes = self._get_line_ending_bytes()

            body = bytearray()
            unmapped = {}
            self._emit_with_escapes(text, body, le_bytes, unmapped)

            # Always wrap with Pagefox envelope: 0x54 ... 0x00 0x00
            header = bytes([0x54])
            extra = self._parse_hex_bytes(self.save_prepend_hex)  # optional user header
            footer = b"\x00\x00"

            with open(path, "wb") as f:
                f.write(header + extra + body + footer)

            if self.show_unmapped_report.get() and unmapped:
                lines = [f"Saved {len(header)+len(extra)+len(body)+len(footer)} bytes to: {path}", "", "Unmapped characters at SAVE:"]
                for ch, cnt in sorted(unmapped.items(), key=lambda kv: (-kv[1], kv[0])):
                    disp = ch
                    if ch == " ":
                        disp = "SPACE"
                    elif ch == "\t":
                        disp = "\\t"
                    elif ch == "\x0b":
                        disp = "\\v"
                    elif ch == "\x0c":
                        disp = "\\f"
                    lines.append(f"  '{disp}'  x {cnt}")
                messagebox.showwarning("Save completed with unmapped", "\n".join(lines))
            else:
                messagebox.showinfo("Saved", f"Saved {len(header)+len(extra)+len(body)+len(footer)} bytes to:\n{path}")
        except Exception as e:
            messagebox.showerror("Save failed", str(e))
    
    def reset_mapping_to_default(self):
        self.mapping = dict(DEFAULT_MAPPING)

    def load_mapping_csv(self):
        path = filedialog.askopenfilename(filetypes=[("CSV files", "*.csv"), ("All files", "*.*")])
        if not path:
            return
        try:
            mapping = {}
            with open(path, "r", encoding="utf-8") as f:
                reader = csv.reader(f)
                for row in reader:
                    if not row or all(not c.strip() for c in row):
                        continue
                    if row[0].strip().lower().startswith("unicode"):
                        continue
                    uni = row[0]
                    code_str = row[1] if len(row) > 1 else ""
                    if not uni:
                        continue
                    ch = uni[0]
                    cs = code_str.strip()
                    if cs.lower().startswith("0x"):
                        val = int(cs, 16)
                    else:
                        val = int(cs)
                    mapping[ch] = val & 0xFF
            if not mapping:
                raise ValueError("CSV did not contain any mappings.")
            self.mapping = mapping
            messagebox.showinfo("Mapping loaded", f"Loaded {len(mapping)} entries from:\n{path}")
        except Exception as e:
            messagebox.showerror("Failed to load CSV mapping", str(e))

    def load_mapping_json(self):
        path = filedialog.askopenfilename(filetypes=[("JSON files", "*.json"), ("All files", "*.*")])
        if not path:
            return
        try:
            with open(path, "r", encoding="utf-8") as f:
                obj = json.load(f)
            mapping = {}
            for k, v in obj.items():
                if not k:
                    continue
                ch = k[0]
                mapping[ch] = int(v) & 0xFF
            if not mapping:
                raise ValueError("JSON did not contain any mappings.")
            self.mapping = mapping
            messagebox.showinfo("Mapping loaded", f"Loaded {len(mapping)} entries from:\n{path}")
        except Exception as e:
            messagebox.showerror("Failed to load JSON mapping", str(e))

    def export_mapping_template(self):
        path = filedialog.asksaveasfilename(defaultextension=".csv", filetypes=[("CSV files", "*.csv")])
        if not path:
            return
        try:
            with open(path, "w", encoding="utf-8", newline="") as f:
                w = csv.writer(f)
                w.writerow(["unicode", "code"])
                for ch in sorted(self.mapping.keys(), key=lambda c: (ord(c))):
                    w.writerow([ch, f"0x{self.mapping[ch]:02X}"])
            messagebox.showinfo("Template saved", f"Saved mapping template to:\n{path}")
        except Exception as e:
            messagebox.showerror("Failed to save template", str(e))

    def configure_binary_io(self):
        # Simple dialogs for now
        try:
            skip = simpledialog.askinteger("Binary I/O Options",
                                           "Bytes to skip on OPEN (e.g. 2 for PRG load address):",
                                           initialvalue=self.open_skip_bytes, minvalue=0, maxvalue=65535)
            if skip is not None:
                self.open_skip_bytes = int(skip)
            hdr = simpledialog.askstring("Binary I/O Options",
                                         "Header bytes to PREPEND on SAVE (hex, e.g. '01 08' or empty):",
                                         initialvalue=self.save_prepend_hex)
            if hdr is not None:
                # basic validation
                self._parse_hex_bytes(hdr)  # will raise if invalid
                self.save_prepend_hex = hdr.strip()
        except Exception as e:
            messagebox.showerror("Invalid option", str(e))

    def show_about(self):
        messagebox.showinfo("About",
            "PFxText – Binary editor for Pagefox/Printfox.\n\n"
            "• ALWAYS opens & saves binary using the active mapping.\n"
            "• OPEN: reads bytes, skips optional header, decodes via mapping, CR (0x0D) -> newline.\n"
            "• SAVE: encodes text via mapping, converts newlines to CR/LF/CRLF, prepends optional header.\n"
            "• Known control bytes render as [x] (Pagefox-style) and are parsed back on save.\n"
            "• Quick Insert lets you embed raw bytes as \\xHH escapes (applied at SAVE).\n"
        )


def main():
    root = Tk()
    root.geometry("900x600")
    PFxEditor(root)
    root.mainloop()


if __name__ == "__main__":
    main()
