; ==========================================================
; pg_sd2iec.asm - SD2IEC directory navigation for Pagefox
; ==========================================================
; Adds folder browsing to the directory browser:
;   RETURN on a "DIR" entry → CD into subdirectory
;   ← (left arrow) key     → CD:← go up one level
;
; Inspired by Servant128 SD2IEC patch by YTM/Elysium
;
; Integration:
;   1. !source "pg_sd2iec.asm" in pg_main.asm header
;   2. +InsertSD2IEC in ROML free space area
;   3. Patch at L0_91B6 (4 bytes):
;      CMP #$AD / BNE L0_91D9  →  JMP dir_key_ext / NOP
; ==========================================================

; --- RAM buffer at $C000 (free RAM, always visible) ---
SD2IEC_BUF     = $C000              ; "CD:" + foldername (max 32 B)
SD2IEC_LEN     = $C020              ; command length

!macro InsertSD2IEC {

; ==========================================================
; dir_key_ext - extended key handler for directory browser
; Replaces code at L0_91B6 (entered via JMP from there)
; Input: A = keycode from $9474
; ==========================================================
dir_key_ext:
                CMP #$5F            ; ← left arrow key?
                BNE .dke_not_left
                JSR go_dir_up       ; send CD:←
                JMP .dke_relist     ; re-list directory

.dke_not_left:
                CMP #$AD            ; RETURN key?
                BNE .dke_not_ret
                JSR check_dir_entry ; check if DIR entry
                BCC .dke_norm_ret   ; C=0 → normal file
                                    ; C=1 → CD done, re-list
.dke_relist:
                JSR L0_92B2         ; close file #8
                LDX #<L0_920B       ; pointer to "$0" string
                LDY #>L0_920B
                LDA #$01            ; length=1 ("$" only)
                JSR CBM_SETNAM      ; KERNAL SETNAM
                LDY #$00            ; SA=0 for input
                JMP L0_916F         ; restart listing

.dke_norm_ret:
; --- reproduce original RETURN handler (L0_91B8..L0_91CD) ---
                LDX $27             ; reload row (clobbered by check_dir_entry)
                LDY #$28
                JSR L0_96FB
                TXA
                CLC
                ADC #$0C
                STA $02
                TYA
                ADC #$04
                STA $03
                LDY #$00
                LDA #$22
                JMP L0_91CE         ; continue quote search

.dke_not_ret:
; --- remaining keys (was at L0_91D9) ---
                CMP #$B3            ; STOP?
                BEQ .dke_stop
                CMP #$20            ; SPACE?
                BNE .dke_other
                LDA $1C
                BNE .dke_next_page
.dke_stop:
                JMP L0_9205

.dke_next_page:
                JMP L0_9187

.dke_other:
                JMP L0_9199


; ==========================================================
; check_dir_entry - detect DIR on current line, send CD
; Input: $27 = current row
; Output: C=1 → DIR, CD sent / C=0 → normal file
; ==========================================================
check_dir_entry:
                LDX $27
                LDY #$28
                JSR L0_96FB
                STX $02
                TYA
                ORA #$04
                STA $03

; --- scan for "DIR" ($44,$49,$52) from right ---
                LDY #$27
.cd_scan:
                LDA ($02),Y
                CMP #$52            ; 'R'
                BNE .cd_not_r
                DEY
                LDA ($02),Y
                CMP #$49            ; 'I'
                BNE .cd_fix1
                DEY
                LDA ($02),Y
                CMP #$44            ; 'D'
                BEQ .cd_found
                INY
.cd_fix1:
                INY
.cd_not_r:
                DEY
                CPY #$10
                BCS .cd_scan

                CLC                 ; not DIR
                RTS

.cd_found:
; --- write "CD:" prefix to RAM ---
                LDA #$43            ; 'C'
                STA SD2IEC_BUF
                LDA #$44            ; 'D'
                STA SD2IEC_BUF+1
                LDA #$3A            ; ':'
                STA SD2IEC_BUF+2

; --- find opening '"' and copy folder name ---
                LDY #$00
.cd_fquote:
                LDA ($02),Y
                CMP #$22            ; '"'
                BEQ .cd_got_q
                INY
                CPY #$20
                BCC .cd_fquote
                CLC
                RTS

.cd_got_q:
                INY                 ; skip '"'
                LDX #$03            ; after "CD:"
.cd_copy:
                LDA ($02),Y
                CMP #$22            ; closing '"'
                BEQ .cd_send
                CMP #$1F            ; PF space
                BEQ .cd_send
                STA SD2IEC_BUF,X
                INY
                INX
                CPX #$20
                BCC .cd_copy

.cd_send:
                CPX #$04            ; at least 1 char?
                BCC .cd_empty
                STX SD2IEC_LEN
                JSR send_cd_cmd
                SEC
                RTS
.cd_empty:
                CLC
                RTS


; ==========================================================
; go_dir_up - send CD:← to go up one level
; ==========================================================
go_dir_up:
                LDA #$43            ; 'C'
                STA SD2IEC_BUF
                LDA #$44            ; 'D'
                STA SD2IEC_BUF+1
                LDA #$3A            ; ':'
                STA SD2IEC_BUF+2
                LDA #$5F            ; ← PETSCII
                STA SD2IEC_BUF+3
                LDA #$04
                STA SD2IEC_LEN
                JSR send_cd_cmd
                SEC
                RTS


; ==========================================================
; send_cd_cmd - send command via channel 15
; ==========================================================
send_cd_cmd:
                LDA SD2IEC_LEN
                LDX #<SD2IEC_BUF
                LDY #>SD2IEC_BUF
                JSR CBM_SETNAM

                LDA #$0F
                TAY
                LDX $BA
                JSR CBM_SETLFS

                JSR CBM_OPEN
                LDA #$0F
                JSR CBM_CLOSE
                RTS

}