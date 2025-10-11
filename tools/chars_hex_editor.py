"""
Hex editor (8 bytes per row, hex line numbers) + glyph tools
- Shows 8 bytes per line
- Line label = (offset // 8) in hex (i.e., "line number" in hex)
- Edit by typing hex digits, save with s/Ctrl+S, quit q/Ctrl+Q, goto 'g'
- Export current 8-byte row as 8x8 image: 'p' (PNG via Pillow, else PBM/TXT)
- Live glyph preview window (Tkinter): toggle with 'v' (updates as you edit)

Windows notes:
- Install `windows-curses` (pip install windows-curses) to run curses UI.
- Tkinter is usually included; if missing, install a Python build with tcl/tk.
"""
import curses
import sys
import os
import threading
import queue

try:
    import tkinter as tk  # stdlib GUI, used for live preview
except Exception:
    tk = None

BYTES_PER_LINE = 8
OFFSET_WIDTH = 8  # 8 hex digits

HELP_TEXT = (
    "Arrows=Move  Hex=Edit  g=Goto  s=Save  q=Quit  PgUp/PgDn/Home/End  "
    "p=Export glyph (8x8)  v=Live preview"
)

# ---------------- Live Preview (Tkinter) ----------------
class LivePreviewer:
    def __init__(self):
        self.enabled = False
        self._thread = None
        self._queue = queue.Queue()

    def start(self):
        if self.enabled:
            return True
        if tk is None:
            return False
        self.enabled = True
        self._thread = threading.Thread(target=self._run, daemon=True)
        self._thread.start()
        return True

    def stop(self):
        if not self.enabled:
            return
        self.enabled = False
        try:
            self._queue.put_nowait(None)
        except Exception:
            pass

    def update(self, mat):
        if not self.enabled:
            return
        try:
            self._queue.put_nowait(mat)
        except Exception:
            pass

    def _run(self):
        try:
            root = tk.Tk()
        except Exception:
            # Could not create window
            self.enabled = False
            return
        root.title("Glyph preview (8x8)")
        scale = 24
        size = 8 * scale
        canvas = tk.Canvas(root, width=size, height=size)
        canvas.pack()
        rects = [
            [
                canvas.create_rectangle(
                    x * scale,
                    y * scale,
                    (x + 1) * scale,
                    (y + 1) * scale,
                    outline="",
                    fill="white",
                )
                for x in range(8)
            ]
            for y in range(8)
        ]

        def poll():
            if not self.enabled:
                try:
                    root.destroy()
                except Exception:
                    pass
                return
            try:
                while True:
                    mat = self._queue.get_nowait()
                    if mat is None:
                        root.destroy()
                        self.enabled = False
                        return
                    for y in range(8):
                        for x in range(8):
                            canvas.itemconfig(
                                rects[y][x], fill=("black" if mat[y][x] else "white")
                            )
            except queue.Empty:
                pass
            root.after(50, poll)

        root.after(50, poll)
        try:
            root.mainloop()
        finally:
            self.enabled = False


class HexEditor:
    def __init__(self, stdscr, path):
        self.stdscr = stdscr
        self.path = path
        self.buf = bytearray()
        self.load_error = None
        self.load()
        self.cursor = 0
        self.top_line = 0
        self.changed = False
        self.nibble_phase = 0
        # live preview
        self.previewer = LivePreviewer()
        self._prev_line_idx = None
        self._prev_line_bytes = None

    # ------------- File I/O -------------
    def load(self):
        try:
            if self.path and os.path.exists(self.path):
                with open(self.path, 'rb') as f:
                    self.buf = bytearray(f.read())
            else:
                self.buf = bytearray()
        except Exception as e:
            self.load_error = str(e)
            self.buf = bytearray()

    def save(self):
        try:
            if not self.path:
                self.path = self.prompt("Save as (path): ")
                if self.path is None:
                    return False
            with open(self.path, 'wb') as f:
                f.write(self.buf)
            self.changed = False
            return True
        except Exception as e:
            self.status(f"Save failed: {e}")
            return False

    # ------------- UI Helpers -------------
    def status(self, msg):
        h, w = self.stdscr.getmaxyx()
        if w <= 1:
            return
        line = (msg[: w - 1]).ljust(w - 1)
        try:
            self.stdscr.attron(curses.A_REVERSE)
            self.stdscr.move(h - 1, 0)
            self.stdscr.clrtoeol()
            self.stdscr.addstr(h - 1, 0, line)
            self.stdscr.attroff(curses.A_REVERSE)
            self.stdscr.refresh()
        except curses.error:
            pass

    def prompt(self, msg):
        h, w = self.stdscr.getmaxyx()
        if w <= 2:
            return None
        prompt_msg = (msg[: w - 1]).ljust(w - 1)
        try:
            curses.curs_set(1)
        except curses.error:
            pass
        try:
            self.stdscr.attron(curses.A_REVERSE)
            self.stdscr.move(h - 1, 0)
            self.stdscr.clrtoeol()
            self.stdscr.addstr(h - 1, 0, prompt_msg)
            self.stdscr.attroff(curses.A_REVERSE)
            self.stdscr.refresh()

            curses.echo()
            maxlen = max(1, w - len(msg) - 1)
            self.stdscr.move(h - 1, len(msg))
            s = self.stdscr.getstr(h - 1, len(msg), maxlen)
            s = s.decode('utf-8', 'ignore').strip()
            curses.noecho()
            try:
                curses.curs_set(0)
            except curses.error:
                pass
            return s
        except Exception:
            try:
                curses.noecho()
                curses.curs_set(0)
            except curses.error:
                pass
            return None

    def confirm(self, msg):
        ans = self.prompt(msg + " [y/N]: ")
        return ans is not None and ans.lower().startswith('y')

    # -------- Glyph helpers --------
    def current_line_bytes(self):
        line_idx = (self.cursor // BYTES_PER_LINE)
        base = line_idx * BYTES_PER_LINE
        return [ (self.buf[base + i] if base + i < len(self.buf) else 0) for i in range(8) ]

    @staticmethod
    def bytes_to_matrix(bytes8):
        return [[1 if (bytes8[row] & (0x80 >> col)) else 0 for col in range(8)] for row in range(8)]

    def export_glyph(self):
        """Export 8 bytes of the current line as an 8x8 monochrome image."""
        line_idx = (self.cursor // BYTES_PER_LINE)
        base = line_idx * BYTES_PER_LINE
        bytes8 = self.current_line_bytes()
        mat = self.bytes_to_matrix(bytes8)

        stem = os.path.splitext(os.path.basename(self.path) if self.path else 'buffer')[0]
        outdir = os.path.dirname(self.path) if self.path else os.getcwd()
        line_hex = f"{(base // BYTES_PER_LINE):08X}"

        # Try Pillow PNG first
        wrote_png = False
        try:
            from PIL import Image
            scale = 16
            img = Image.new('1', (8, 8))
            for y in range(8):
                for x in range(8):
                    img.putpixel((x, y), 0 if mat[y][x] else 1)
            img = img.resize((8*scale, 8*scale), Image.NEAREST)
            out_png = os.path.join(outdir, f"{stem}_glyph_{line_hex}.png")
            img.save(out_png)
            self.status(f"Glyph saved: {out_png}")
            wrote_png = True
        except Exception:
            wrote_png = False

        if not wrote_png:
            # Fallback PBM (plain P1)
            out_pbm = os.path.join(outdir, f"{stem}_glyph_{line_hex}.pbm")
            try:
                with open(out_pbm, 'w') as f:
                    f.write("P1\n8 8\n")
                    for y in range(8):
                        f.write(" ".join('1' if mat[y][x]==1 else '0' for x in range(8)) + "\n")
                self.status(f"Glyph saved: {out_pbm}")
            except Exception:
                out_txt = os.path.join(outdir, f"{stem}_glyph_{line_hex}.txt")
                with open(out_txt, 'w') as f:
                    for y in range(8):
                        f.write(''.join('#' if mat[y][x] else '.' for x in range(8)) + "\n")
                self.status(f"Glyph saved (ASCII): {out_txt}")

    # ------------- Drawing -------------
    def draw(self):
        self.stdscr.erase()
        h, w = self.stdscr.getmaxyx()
        usable_rows = h - 2

        header = f"Line(HEX)   " + " ".join([f"{i:02X}" for i in range(BYTES_PER_LINE)])
        self.stdscr.attron(curses.A_BOLD)
        if w > 1:
            self.stdscr.addstr(0, 0, header[: w - 1])
        self.stdscr.attroff(curses.A_BOLD)

        cur_line = self.cursor // BYTES_PER_LINE
        if cur_line < self.top_line:
            self.top_line = cur_line
        elif cur_line >= self.top_line + usable_rows:
            self.top_line = cur_line - usable_rows + 1
        if self.top_line < 0:
            self.top_line = 0

        total_lines = (max(1, len(self.buf)) + BYTES_PER_LINE - 1) // BYTES_PER_LINE
        for row in range(usable_rows):
            line_idx = self.top_line + row
            if line_idx >= total_lines:
                break
            base = line_idx * BYTES_PER_LINE
            # Offset divided by 8 (line number in hex)
            offset_str = f"{(base // BYTES_PER_LINE):0{OFFSET_WIDTH}X}  "
            if w > 1:
                self.stdscr.addstr(1 + row, 0, offset_str[: w - 1])

            for col in range(BYTES_PER_LINE):
                x = len(offset_str) + col * 3
                if x >= w - 1:
                    break
                idx = base + col
                if idx < len(self.buf):
                    byte = self.buf[idx]
                    text = f"{byte:02X}"
                    text = text[: max(0, w - 1 - x)]
                    if idx == self.cursor:
                        self.stdscr.attron(curses.A_REVERSE)
                        self.stdscr.addstr(1 + row, x, text)
                        self.stdscr.attroff(curses.A_REVERSE)
                    else:
                        self.stdscr.addstr(1 + row, x, text)
                else:
                    filler = "  "[: max(0, w - 1 - x)]
                    self.stdscr.addstr(1 + row, x, filler)

        # Live preview update if enabled and line bytes changed
        if self.previewer.enabled:
            line_idx = (self.cursor // BYTES_PER_LINE)
            bytes8 = self.current_line_bytes()
            if line_idx != self._prev_line_idx or bytes8 != self._prev_line_bytes:
                mat = self.bytes_to_matrix(bytes8)
                self.previewer.update(mat)
                self._prev_line_idx = line_idx
                self._prev_line_bytes = list(bytes8)

        pos_info = f"{os.path.basename(self.path) if self.path else '(new)'}  size={len(self.buf)}  cursor={self.cursor:08X}  line={cur_line+1}  {HELP_TEXT}"
        if self.changed:
            pos_info = "* " + pos_info
        if w > 1:
            self.status(pos_info[: w - 1])

        self.stdscr.refresh()

    # ------------- Navigation -------------
    def move_cursor(self, delta):
        if len(self.buf) == 0:
            return
        self.cursor = max(0, min(len(self.buf) - 1, self.cursor + delta))
        self.nibble_phase = 0

    def run(self):
        self.stdscr.keypad(True)
        try:
            curses.curs_set(0)
        except curses.error:
            pass
        if self.load_error:
            self.status(f"Warning: {self.load_error}")
        while True:
            self.draw()
            ch = self.stdscr.getch()

            # Quit
            if ch in (ord('q'), 17):
                if self.changed and not self.confirm("Unsaved changes. Quit anyway?"):
                    continue
                self.previewer.stop()
                break

            # Save
            if ch in (ord('s'), 19):
                if self.save():
                    self.status("Saved.")
                continue

            # Goto offset
            if ch == ord('g'):
                s = self.prompt("Goto hex offset: 0x")
                try:
                    if s is not None and s != "":
                        off = int(s, 16)
                        if 0 <= off < max(1, len(self.buf)):
                            self.cursor = min(off, max(0, len(self.buf) - 1))
                            self.nibble_phase = 0
                except ValueError:
                    self.status("Invalid hex offset")
                continue

            # Export 8x8 glyph from current line
            if ch == ord('p'):
                self.export_glyph()
                continue

            # Toggle live preview window
            if ch == ord('v'):
                if self.previewer.enabled:
                    self.previewer.stop()
                    self.status("Live preview: OFF")
                else:
                    if self.previewer.start():
                        # send immediate state
                        self._prev_line_idx = None
                        self._prev_line_bytes = None
                        self.status("Live preview: ON")
                    else:
                        self.status("Live preview failed (Tkinter not available)")
                continue

            # Arrows & paging
            if ch == curses.KEY_LEFT:
                self.move_cursor(-1)
                continue
            if ch == curses.KEY_RIGHT:
                self.move_cursor(1)
                continue
            if ch == curses.KEY_UP:
                self.move_cursor(-BYTES_PER_LINE)
                continue
            if ch == curses.KEY_DOWN:
                self.move_cursor(BYTES_PER_LINE)
                continue
            if ch == curses.KEY_PPAGE:  # PageUp
                h, _ = self.stdscr.getmaxyx()
                self.move_cursor(-(h - 3) * BYTES_PER_LINE)
                continue
            if ch == curses.KEY_NPAGE:  # PageDown
                h, _ = self.stdscr.getmaxyx()
                self.move_cursor((h - 3) * BYTES_PER_LINE)
                continue
            if ch == curses.KEY_HOME:
                line_base = (self.cursor // BYTES_PER_LINE) * BYTES_PER_LINE
                self.cursor = line_base
                self.nibble_phase = 0
                continue
            if ch == curses.KEY_END:
                line_base = (self.cursor // BYTES_PER_LINE) * BYTES_PER_LINE
                self.cursor = min(line_base + BYTES_PER_LINE - 1, max(0, len(self.buf) - 1))
                self.nibble_phase = 0
                continue

            # Hex edit
            if (ord('0') <= ch <= ord('9')) or (ord('a') <= ch <= ord('f')) or (ord('A') <= ch <= ord('F')):
                if len(self.buf) == 0:
                    self.buf = bytearray([0])
                nyb = int(chr(ch), 16)
                cur = self.buf[self.cursor]
                if self.nibble_phase == 0:
                    new_val = (nyb << 4) | (cur & 0x0F)
                    self.buf[self.cursor] = new_val & 0xFF
                    self.nibble_phase = 1
                else:
                    new_val = (cur & 0xF0) | nyb
                    self.buf[self.cursor] = new_val & 0xFF
                    self.nibble_phase = 0
                    if self.cursor < len(self.buf) - 1:
                        self.cursor += 1
                self.changed = True
                continue


def main(stdscr, path):
    editor = HexEditor(stdscr, path)
    editor.run()

if __name__ == '__main__':
    path = sys.argv[1] if len(sys.argv) > 1 else None
    curses.wrapper(main, path)
