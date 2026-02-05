;==========================================================
; sources
;==========================================================

!initmem $ff
!source "pg_kernal.asm"
!source "pg_colors.asm"
!source "pg_24.asm"

;==========================================================
; build options (language, 9pin/24pin printer mod)
;==========================================================
.language = 0                           ; 0 = cs, 1 = de, 2 = en (not implemented)
.pg24 = 0                               ; 1 = enable, 2 = disable 24 pin mod (native pg-24.prg)

!if .language = 0 {
    !source "pg_cs.asm"
    !to "build/pagefox-cs-2.5.bin", plain
	VIZA_LEN = (VIZA_CS_OUT - VIZA_CS_IN)
	VIZA_IN = VIZA_CS_IN
	VIZA_OUT = VIZA_CS_OUT
}

!if .language = 1 {
    !source "pg_de.asm"
    !to "build/pagefox-de-1.0.bin", plain
	VIZA_LEN = (VIZA_DE_OUT - VIZA_DE_IN)
	VIZA_IN = VIZA_DE_IN
	VIZA_OUT = VIZA_DE_OUT
}

!if .language = 2 {
    !source "pg_en.asm"
    !to "build/pagefox-en-1.0.bin", plain
	VIZA_LEN = (VIZA_DE_OUT - VIZA_DE_IN)
	VIZA_IN = VIZA_DE_IN
	VIZA_OUT = VIZA_DE_OUT
}

* = 0

!pseudopc $8000 {

;==========================================================
; header / signature
;==========================================================
L0_8000:
                !by $31, $80
                !by $BB, $0E, $C3, $C2, $CD, $38
                !by $30,$50,$46,$20,$56,$31,$2E,$30
                JMP $8045
                JMP $92BA
                JMP $9039
                JMP $9747
                JMP $957C
                JMP L0_915D              ; read dir
                JMP L0_9258
                JMP $977F
                JMP $98A2
                JMP $8ECC
                JMP $9474
                SEI
                JSR $FDA3
                LDA $DC01
                AND #$10
                BEQ L0_8042
                JSR L0_8F6A              ; cold start init
!if .pg24 = 1 {
                JMP pg24_boot
} else {
                JMP $0DA8               ; go to main menu
}
L0_8042:
                JMP (L0_A000)
                LDX #$FE
                TXS
                JSR L0_90B0
L0_804B:                                 ; wait for input
                JSR L0_8054
                JSR L0_8BA1
                JMP L0_804B

;==========================================================
L0_8054:
                JSR L0_949D              ; get character from imput device?
L0_8057:
                BEQ L0_8077
                STA $61                 ; break point
                BIT $55
                BPL L0_8064
                PHA
L0_8060:
                JSR L0_973E
                PLA
L0_8064:
                CMP #$A0
                BCS L0_806B
                JMP $80C0

;==========================================================
L0_806B:
                SBC #$A0
                ASL
                TAX
                LDA L0_8078+1,X
                PHA
                LDA L0_8078,X
                PHA

;==========================================================
; ext command RUN/STOP - C= + T
;==========================================================
L0_8077:
                RTS

;==========================================================
; Text address table
; Values $A0–$C3 from macro InsertKeybMap
;==========================================================
L0_8078:
                !word L0_8261-1          ; CURSOR DOWN
                !word L0_8211-1          ; CURSOR UP
                !word L0_8253-1          ; CURSOR RIGHT
                !word L0_81FB-1          ; CURSOR LEFT

                !word L0_827F-1          ; CLR/HOME
                !word L0_82B0-1          ; SHIFT-CLR/HOME
                !word L0_82DE-1          ; F1
                !word L0_8303-1          ; F2

                !word L0_82B8-1          ; F3
                !word L0_82D3-1          ; F4
                !word L0_8313-1          ; F5
                !word L0_831E-1          ; F6

                !word L0_832C-1          ; SHIFT RETURN
                !word L0_80F0-1          ; RETURN
L0_8094:
                !word L0_80F0-1          ; CTRL RETURN
                !word L0_8104-1          ; INST/DEL

                !word L0_80FF-1          ; SHIFT-INST/DEL
                !word L0_811D-1          ; F7
                !word L0_8519-1          ; F8
                !word L0_8077-1          ; RUN/STOP (points to RTS only)

                !word L0_8530-1          ; C= ARROW LEFT
                !word L0_87DF-1          ; C= L
                !word L0_8749-1          ; C= S
                !word $0DA7             ; C= P - go to main menu

                !word $0DA7             ; C= Q - go to main menu
                !word $0DAD             ; C= G - go to graphic editor
                !word L0_898A-1          ; C= D
                !word L0_8541-1          ; C= C

                !word L0_8529-1          ; C= M
                !word L0_9433-1          ; C= ARROW UP
                !word L0_8997-1          ; C= F
                !word L0_89BD-1          ; C= R

                !word L0_8B45-1          ; C= F1-F8
                !word L0_8B83-1          ; C= CLR/HOME
L0_80BC:
                !word L0_8B9B-1          ; C= V
                !word L0_8077-1          ; C= T
                CMP #$20
                BCC L0_80E6
                LDY $23
                LDA ($58),Y
                CMP #$02
                BCC L0_80EA
                CMP #$0D
                BEQ L0_80EA
                LDA $61
                STA ($58),Y
                LDX $58
                LDY $59
                STX $02
                STY $03
                LDX $22
L0_80DE:
                LDA $66
                JSR print_msg
                JMP L0_8253
L0_80E6:
                CMP #$03
                BCC L0_80F2
L0_80EA:
                JSR L0_8132
                JMP L0_8253

;==========================================================
; Text command SHIFT RETURN
;==========================================================
L0_80F0:
                LDA #$0D
L0_80F2:
                JSR L0_8130
                BCS L0_80FE
                LDA $23
                STA $66
                JSR L0_8253
L0_80FE:
                RTS

;==========================================================
; Text command SHIFT INST/DEL
;==========================================================
L0_80FF:
                LDA #$20
                JMP L0_8130

;==========================================================
; Text command INST/DEL
;==========================================================
L0_8104:
                LDY $23
                LDA ($58),Y
                CMP #$0D
                BEQ L0_8110
                CMP #$02
                BCS L0_8119
L0_8110:
                JSR L0_81FB
                LDY $23
                LDA ($58),Y
                BEQ L0_811C
L0_8119:
                JSR L0_8190
L0_811C:
                RTS

;==========================================================
; Text command F7
;==========================================================
L0_811D:
                LDY $23
                LDA ($58),Y
                CMP #$0D
                BEQ L0_812D
                LDA #$0D
                JSR L0_8130
                JMP L0_83A5
L0_812D:
                JMP L0_8190
L0_8130:
                STA $61
L0_8132:
                LDA $5A
                TAX
                SEC
                SBC $58
                LDA $5B
                TAY
                SBC $59
                STA $1C
                INX
                BNE L0_8147
                INY
                CPY #$3C
                BCS L0_8189
L0_8147:
                STX $5A
                STY $5B
                TAX
                INX
                LDA $58
                CLC
                ADC $23
                STA $02
                STA $08
                LDA $59
                ADC $1C
                STA $03
                STA $09
                INC $08
                BNE L0_8164
                INC $09
L0_8164:
                JSR L0_81D8
                LDY $23
                LDA $61
                STA ($58),Y
                INC $66
                LDA $66
                CMP #$29
                BCS L0_8184
                LDX $58
                LDY $59
                STX $02
                STY $03
                LDX $22
L0_817F:
                JSR print_msg
                CLC
                RTS
L0_8184:
                JSR L0_83A5
                CLC
                RTS
L0_8189:
                LDA #$05                ; msg. no.
                JSR L0_9747              ; print "Preteceni pameti"
                SEC
L0_818F:
                RTS
L0_8190:
                LDA $5A
                TAY
                SEC
                SBC $58
                LDA $5B
                SBC $59
                TAX
                INX
                TYA
                BNE L0_81A1
                DEC $5B
L0_81A1:
                DEC $5A
                LDA $58
                CLC
                ADC $23
                STA $02
                STA $08
                LDA $59
                ADC #$00
                STA $03
                STA $09
                INC $02
                BNE L0_81BA
                INC $03
L0_81BA:
                JSR L0_81EA
                DEC $66
                LDA $23
                CMP $66
                BCS L0_81D5
                LDX $58
                LDY $59
                STX $02
                STY $03
                LDX $22
                LDA $66
                JSR print_msg
                RTS
L0_81D5:
                JMP L0_83A5
L0_81D8:
                LDY #$00
L0_81DA:
                DEY
                LDA ($02),Y
                STA ($08),Y
                TYA
                BNE L0_81DA
                DEC $03
                DEC $09
                DEX
                BNE L0_81DA
L0_81E9:
                RTS
L0_81EA:
                LDY #$00
L0_81EC:
                LDA ($02),Y
                STA ($08),Y
                INY
                BNE L0_81EC
                INC $03
                INC $09
                DEX
                BNE L0_81EC
                RTS
L0_81FB:
                LDA $23
                BNE L0_8206
                JSR L0_8382
                LDA $23
                BEQ L0_820B
L0_8206:
                DEC $23
                JMP L0_9660
L0_820B:
                LDA #$27
                STA $23
                BNE L0_8214

;==========================================================
; Text command CURSOR UP
;==========================================================
L0_8211:
                JSR L0_8382
L0_8214:
                LDA $22
                CMP #$03
                BEQ L0_8234
                JSR L0_8463
                LDA $58
L0_821F:
                SEC
                SBC $02
                STA $66
                JSR L0_8332
                DEC $22
                LDX $02
                LDY $03
                STX $58
                STY $59
                JMP L0_9660
L0_8234:
                JSR L0_8421
                LDX $56
                LDY $57
                STX $58
                STY $59
                STX $02
                STY $03
                JSR L0_84A8
                STA $66
                JSR L0_8332
                LDX #$03
                JSR L0_8482
                JMP L0_9660

;==========================================================
; Text command CURSOR RIGHT
;==========================================================
L0_8253:
                INC $23
                LDA $23
                CMP $66
                BCC L0_825E
                JMP L0_83A5
L0_825E:
                JMP L0_9660

;==========================================================
; Text command CURSOR DOWN
;==========================================================
L0_8261:
                LDA $58
                CLC
                ADC $66
                STA $02
                LDA $59
                ADC #$00
                STA $03
                JSR L0_84A8
                TAY
                JSR L0_8334
                LDA $23
                CLC
                ADC $66
                STA $23
                JMP L0_83A5
L0_827F:
                LDA $22
                CMP #$03
                BNE L0_8291
                LDA $23
                BNE L0_8291
                LDX #$01
                LDY #$19
                STX $56
                STY $57
L0_8291:
                LDX $56
                LDY $57
                STX $58
                STY $59
                STX $02
                STY $03
                JSR L0_84A8
                STA $66
                LDA #$00
                STA $23
                LDX #$03
                STX $22
                JSR L0_8482
                JMP L0_9660

;==========================================================
; Text command SHIFT-CLR/HOME
;==========================================================
L0_82B0:
                JSR L0_833C
                LDA #$12
                JMP L0_8354

;==========================================================
; Text command F3
;==========================================================
L0_82B8:
                LDA $5A
                CMP $0342
                LDA $5B
                SBC $0343
                BCC L0_82B0
                LDX $0342
L0_82C7:
                LDY $0343
                STX $58
                STY $59
                LDA #$0A
                JMP L0_8354

;==========================================================
; Text command F4
;==========================================================
L0_82D3:
                LDX $58
                LDY $59
                STX $0342
                STY $0343
                RTS

;==========================================================
; Text command F1
;==========================================================
L0_82DE:
                LDX $56
                LDY $57
                STX $02
                STY $03
                LDA #$12
                STA $26
L0_82EA:
                JSR L0_84A8
                BCC L0_8300
                CLC
                ADC $02
                STA $02
                STA $56
                BCC L0_82FC
                INC $03
                INC $57
L0_82FC:
                DEC $26
                BNE L0_82EA
L0_8300:
                JMP L0_8291

;==========================================================
; Text command F2
;==========================================================
L0_8303:
                LDA #$12
                STA $26
L0_8307:
                JSR L0_8421
                BEQ L0_8310
L0_830C:
                DEC $26
                BNE L0_8307
L0_8310:
                JMP L0_8291

;==========================================================
; Text command F5
;==========================================================
L0_8313:
                JSR L0_8382
                LDY $66
L0_8318:
                DEY
                STY $23
                JMP L0_9660

;==========================================================
; Text command F6
;==========================================================
L0_831E:
                LDA $23
                BEQ L0_8313
L0_8322:
                JSR L0_8382
                LDA #$00
                STA $23
                JMP L0_9660

;==========================================================
; Text command SHIFT RETURN
;==========================================================
L0_832C:
                JSR L0_8322
                JMP L0_8261
L0_8332:
                LDY $66
L0_8334:
                DEY
                CPY $23
                BCS L0_833B
                STY $23
L0_833B:
                RTS
L0_833C:
                LDY #$00
L0_833E:
                LDA ($58),Y
                BEQ L0_8349
                INY
                BNE L0_833E
                INC $59
                BNE L0_833E
L0_8349:
                TYA
                CLC
                ADC $58
                STA $58
                BCC L0_8353
                INC $59
L0_8353:
                RTS
L0_8354:
                LDX $58
                LDY $59
                STX $56
                STY $57
                STA $26
L0_835E:
                JSR L0_8421
                BEQ L0_8367
                DEC $26
                BNE L0_835E
L0_8367:
                LDX #$58
                JSR L0_84D7
                STX $22
                LDX $56
                LDY $57
                STX $02
                STY $03
                LDX #$03
                JSR L0_8482
L0_837B:
                LDA #$00
                STA $23
L0_837F:
                JMP L0_83A5
L0_8382:
                LDA $22
                CMP #$03
                BEQ L0_8395
                JSR L0_8463
                JSR L0_84A8
                CLC
                ADC $02
                CMP $58
                BNE L0_83A5
L0_8395:
                LDX $58
                LDY $59
                STX $02
                STY $03
                JSR L0_84A8
                CMP $66
                BNE L0_83A5
                RTS
L0_83A5:
                LDA $58
                CLC
                ADC $23
                STA $58
                BCC L0_83B0
                INC $59
L0_83B0:
                JSR L0_8463
                STX $22
                TXA
                PHA
                LDA $02
                PHA
                LDA $03
                PHA
L0_83BD:
                LDA $58
                SEC
                SBC $02
                STA $23
                JSR L0_84A8
                STA $66
                BCC L0_83E0
                LDA $23
                CMP $66
                BCC L0_83E0
                INC $22
                LDA $02
                CLC
                ADC $66
                STA $02
                BCC L0_83BD
                INC $03
                BCS L0_83BD
L0_83E0:
                LDX $02
                LDY $03
                STX $58
                STY $59
                JSR L0_8332
L0_83EB:
                LDA $22
                CMP #$18
                BCC L0_8413
                PLA
                PLA
                PLA
                LDA #$03
                PHA
                LDX $56
L0_83F9:
                LDY $57
                STX $02
                STY $03
                JSR L0_84A8
                CLC
                ADC $56
                STA $56
                PHA
                LDA $57
                ADC #$00
                STA $57
                PHA
                DEC $22
                BNE L0_83EB
L0_8413:
                PLA
                STA $03
                PLA
                STA $02
                PLA
                TAX
                JSR L0_8482
                JMP L0_9660
L0_8421:
                LDA $56
                SEC
                SBC #$28
                STA $56
                BCS L0_842C
                DEC $57
L0_842C:
                LDY #$27
                LDA #$FF
                STA $6A
L0_8432:
                LDA ($56),Y
                BEQ L0_8455
                CMP #$02
                BEQ L0_8456
                CPY #$27
                BEQ L0_8450
                CMP #$01
                BEQ L0_8455
                CMP #$0D
                BEQ L0_8455
                CMP #$2D
                BEQ L0_844E
                CMP #$20
                BNE L0_8450
L0_844E:
                STY $6A
L0_8450:
                DEY
                BPL L0_8432
                LDY $6A
L0_8455:
                INY
L0_8456:
                TYA
                CLC
                ADC $56
                STA $56
                BCC L0_8460
                INC $57
L0_8460:
                CPY #$28
                RTS
L0_8463:
                LDA $56
                STA $02
L0_8467:
                LDA $57
                STA $03
                LDX #$04
L0_846D:
                CPX $22
                BCS L0_8480
L0_8471:
                JSR L0_84A8
                CLC
                ADC $02
                STA $02
                BCC L0_847D
                INC $03
L0_847D:
                INX
                BNE L0_846D
L0_8480:
                DEX
                RTS
L0_8482:
                TXA
                PHA
                JSR L0_84A8
                BCC L0_849F
                PHA
                JSR print_msg
                PLA
                CLC
                ADC $02
                STA $02
                BCC L0_8497
                INC $03
L0_8497:
                PLA
                TAX
                INX
                CPX #$19
                BCC L0_8482
                RTS
L0_849F:
                JSR print_msg
                PLA
                TAX
                INX
                JMP L0_964F
L0_84A8:
                LDY #$00
                LDA #$28
                STA $6A
L0_84AE:
                LDA ($02),Y
                INY
                CMP #$01
                BCC L0_84C0
                BEQ L0_84C0
                CMP #$02
                BNE L0_84C2
                CPY #$01
                BEQ L0_84C2
                DEY
L0_84C0:
                TYA
                RTS
L0_84C2:
                CMP #$0D
                BEQ L0_84C0
                CMP #$20
                BEQ L0_84CE
                CMP #$2D
                BNE L0_84D0
L0_84CE:
                STY $6A
L0_84D0:
                CPY #$28
                BCC L0_84AE
                LDA $6A
                RTS
L0_84D7:
                LDA $56
                STA $02
                LDA $57
                STA $03
                LDA #$03
                STA $26
L0_84E3:
                LDA $00,X
                SEC
                SBC $02
                STA $1C
                LDA $01,X
                SBC $03
                BCC L0_8510
                BEQ L0_84F6
                LDA #$FF
                STA $1C
L0_84F6:
                JSR L0_84A8
                CMP $1C
                BEQ L0_84FF
                BCS L0_8514
L0_84FF:
                CLC
                ADC $02
                STA $02
                BCC L0_8508
                INC $03
L0_8508:
                INC $26
                LDA $26
                CMP #$19
                BCC L0_84E3
L0_8510:
                LDA #$00
                STA $1C
L0_8514:
                LDX $26
                LDA $1C
                RTS

;==========================================================
; Text command F8
;==========================================================
L0_8519:
                JSR L0_8643
                BCS L0_8528
                JSR L0_8578
                JSR L0_85B1
                JSR L0_83A5
                CLC
L0_8528:
                RTS

;==========================================================
; Text command C= M
;==========================================================
L0_8529:
                JSR L0_8519
                BCS L0_8528
                BCC L0_8549
;==========================================================
; Text command C= ARROW LEFT
;==========================================================
L0_8530:
                BIT $5C
                BPL L0_8572
                LDA $58
                CLC
                ADC $23
                TAX
                LDA $59
                ADC #$00
                TAY
                BCC L0_854E
;==========================================================
; Text command C= C
;==========================================================
L0_8541:
                JSR L0_8643
                BCS L0_8572
                JSR L0_8578
L0_8549:
                JSR L0_860E
                BCS L0_8572
L0_854E:
                LDA $5A
                SEC
                ADC $6C
                LDA $5B
                ADC $6D
                CMP #$3C
                BCS L0_8573
                STX $02
                STY $03
                TXA
                PHA
                TYA
                PHA
                JSR L0_85E1
                PLA
                STA $09
                PLA
                STA $08
                JSR L0_858E
                JSR L0_83A5
L0_8572:
                RTS
L0_8573:
                LDA #$05                ; msg. no.
                JMP L0_9747              ; print "Preteceni pameti"
L0_8578:
                LDX $5D
                LDY $5E
                STX $02
                STY $03
                LDX #$00                ;$3F00
                LDY #$3F
                STX $08
                STY $09
                LDX $6D
                INX
                JMP L0_81EA
L0_858E:
                LDY #$00
                STY $02
                LDA #$3F                ;$3F00
                STA $03
                LDX $6C
                LDA $6D
                STA $1C
L0_859C:
                LDA ($02),Y
                STA ($08),Y
                INY
                BNE L0_85A7
                INC $03
                INC $09
L0_85A7:
                DEX
                CPX #$FF
                BNE L0_859C
                DEC $1C
                BPL L0_859C
                RTS
L0_85B1:
                LDX $5F
                LDY $60
                INX
                BNE L0_85B9
                INY
L0_85B9:
                STX $02
                STY $03
L0_85BD:
                LDX $5D
                LDY $5E
                STX $08
                STY $09
                LDA $5A
                SEC
                SBC $5F
                LDA $5B
                SBC $60
                TAX
                INX
                JSR L0_81EA
                LDA $5A
                CLC
                SBC $6C
                STA $5A
                LDA $5B
                SBC $6D
                STA $5B
                RTS
L0_85E1:
                LDA $5A
                CMP $02
                LDA $5B
                SBC $03
                TAX
                INX
                CLC
                ADC $03
                STA $03
                LDA $02
                SEC
                ADC $6C
                STA $08
                LDA $03
                ADC $6D
                STA $09
                JSR L0_81D8
                LDA $5A
                SEC
                ADC $6C
                STA $5A
                LDA $5B
                ADC $6D
                STA $5B
                RTS
L0_860E:
                LDA #$07                ; msg. no.
                JSR L0_9747              ; print "Označ cil a potvrd ..."
L0_8613:
                JSR $9474               ; get character from imput device?
                CMP #$A0
                BCC L0_8613
                CMP #$B3
                BEQ L0_863E
                CMP #$AD
                BEQ L0_862A
                BCS L0_8613
                JSR L0_8064
                JMP L0_8613
L0_862A:
                LDA $58
L0_862C:
                CLC
                ADC $23
                PHA
                LDA $59
                ADC #$00
                PHA
                JSR L0_973E
                PLA
                TAY
                PLA
                TAX
                CLC
                RTS
L0_863E:
                JSR L0_973E
L0_8641:
                SEC
L0_8642:
                RTS
L0_8643:
                LDY $23
                LDA ($58),Y
                SEC
                BEQ L0_8642
                LDA #$06                ; msg. no.
                JSR L0_9747              ; print "Oznac konec a potvrd"
                JSR L0_8382
                LDA $56
                PHA
                LDA $57
                PHA
L0_8658:
                LDA $22
                PHA
                LDA $58
L0_865D:
                CLC
                ADC $23
                STA $5D
                STA $5F
                LDA $59
                ADC #$00
                STA $5E
                STA $60
L0_866C:
                JSR L0_86EF
L0_866F:
                JSR $9474               ; get character from imput device?
                CMP #$A0
L0_8674:
                BCC L0_866F
                CMP #$B3
                BEQ L0_86A0
L0_867A:
                CMP #$AD
                CLC
                BEQ L0_86A0
                CMP #$AD
                BCS L0_866F
                JSR L0_8064
                LDA $58
                CLC
                ADC $23
                STA $5F
                ROL $1C
                CMP $5D
                ROR $1C
                LDA $59
                ADC #$00
                STA $60
                ROL $1C
                SBC $5E
                BCS L0_866C
                SEC
L0_86A0:
                ROL $1C
                LDY #$00
                LDA ($5F),Y
                BNE L0_86B0
                LDA $5F
                BNE L0_86AE
                DEC $60
L0_86AE:
                DEC $5F
L0_86B0:
                PLA
                STA $22
                PLA
                STA $57
                STA $03
                PLA
                STA $56
                STA $02
                LDA $5D
                STA $58
                LDA $5E
                STA $59
                LDA #$00
                STA $23
                ROR $1C
                PHP
                BCS L0_86DF
                LDA #$80
                STA $5C
                LDA $5F
                SEC
                SBC $5D
                STA $6C
                LDA $60
                SBC $5E
                STA $6D
L0_86DF:
                LDX #$03
                JSR L0_8482
                JSR L0_9142
                JSR L0_973E
                JSR L0_83A5
                PLP
                RTS
L0_86EF:
                LDX #$5F
                JSR L0_8734
                INX
                BNE L0_86F8
                INY
L0_86F8:
                STX $08
                STY $09
                LDX #$5D
                JSR L0_8734
                STX $1C
                STY $1D
                LDA #$D8
                STA $03
                LDA #$00
                STA $02
                LDY #$78
L0_870F:
                LDX $1701
                CPY $1C
                LDA $03
                SBC $1D
                BCC L0_8725
                CPY $08
                LDA $03
                SBC $09
                BCS L0_8725
                LDX $1703
L0_8725:
                TXA
                STA ($02),Y
                INY
                BNE L0_870F
L0_872B:
                INC $03
                LDA $03
                CMP #$DC
                BCC L0_870F
                RTS
L0_8734:
                JSR L0_84D7
                PHA
                LDY #$28
                JSR multiply_x_y        ; multiply X with Y
                STX $1C
                PLA
                CLC
                ADC $1C
                TAX
                TYA
                ADC #$D8
                TAY
                RTS
;==========================================================
; Text command C= S
;==========================================================
L0_8749:
; Nastavení rozsahu textu k uložení
                LDX #$01
                LDY #$19
                STX $5D                 ; $5D/$5E = začátek textu ($1901)
                STY $5E
                LDX $5A
                LDY $5B
                STX $5F                 ; $5F/$60 = konec textu (z $5A/$5B)
                STY $60
                LDX #$D9                ; Dialog - výběr rozsahu? (pointer na $87D9)
                LDY #$87
                STX $04
                STY $05
                JSR L0_9598              ; Zobraz dialog
                BCS L0_87D6              ; Zrušeno -> konec
                BEQ L0_8770              ; OK bez výběru -> pokračuj
                JSR L0_9660
                JSR L0_8643              ; Označ blok textu
                BCS L0_87D6
L0_8770:
                LDA #$03                ; msg. no. 03
                JSR L0_957C              ; print "Nazev"
                BCS L0_87D6
                LDY #$01
                JSR L0_9297              ; set file prameter and open
                BCS L0_87CE
; === Zápis 'T' (signatura textu) ===
                LDA #$54                ; 'T'
                JSR CBM_CHROUT          ; Output vetor
; === Zápis textových dat ===
                LDY $5D
                LDA #$00
                STA $5D
L0_8789:
                LDA ($5D),Y             ; Čti bajt textu
                JSR CBM_CHROUT          ; Zapiš na disk
L0_878E:
                LDA $90
                BNE L0_87CE              ; Chyba I/O
                CPY $5F                 ; Konec textu
                BNE L0_879C
                LDA $5E
                CMP $60
                BEQ L0_87A3              ; Ano -> pokračuj na layout
L0_879C:
                INY
                BNE L0_8789
                INC $5E
                BNE L0_8789
L0_87A3:
; === Zápis $00 (ukončení textu) ===
                LDA #$00
                JSR CBM_CHROUT          ; Output Vector
; === Zápis 'L' (signatura layout) ===
                LDA #$4C                ; 'L'
                JSR CBM_CHROUT
; === Zápis délky layout dat ===
                LDA $1700               ; Počet bajtů layoutu (n × 5)
                JSR CBM_CHROUT
; === Zápis layout dat (rámečky + obrázky) ===
; Formát záznamu:
; $40,X1/4,Y1/4,X2/4,Y2/4 = textový rámeček (5 bajtů)
; $Cn,X1/4,Y1/4,X2/4,Y2/4,filename = obrázek (5+n bajtů)
; kde n = délka názvu souboru (dolní nibble flags)
; Souřadnice jsou v jednotkách 4 bodů
                LDY #$00
L0_87B5:
                LDA $1800,Y             ; Layout data z $1800
                JSR CBM_CHROUT
                INY
                CPY $1700
                BCC L0_87B5
; === Zápis barev ($1701-$170C) ===
                LDY #$00
L0_87C3:
                LDA $1701,Y             ; Barvy a další nastavení
                JSR CBM_CHROUT
                INY
                CPY #$0C                ; 12 bajtů
                BCC L0_87C3
L0_87CE:
                JSR L0_92B2              ; restore i/o and close?
                LDA #$00
                JSR L0_9258
L0_87D6:
                JMP L0_9660
                !by $0A,$01,$02,$00,$06,$0E
;==========================================================
; Text command C= L
;==========================================================
L0_87DF:
                LDA #$00
                JSR L0_915D              ;read dir
                BCS L0_882C
                LDY #$02
                JSR L0_9297              ; Otevři soubor pro čtení
; === Kontrola signatury 'T' ===
                JSR CBM_CHRIN           ; Přečti první bajt
                LDX #$00
                CMP #$54                ; Je to 'T'?
                BEQ L0_880D              ; Ano -> nativní PageFox formát
; Není 'T' -> dialog pro výběr formátu (ASCII, atd.)
                JSR CBM_CLRCHN
                LDX #$41
                LDY #$88
                STX $04
                STY $05
                JSR L0_9598
                BCS L0_8824
                PHA
                LDX #$08
                JSR CBM_CHKIN
                PLA
                TAX
                INX
L0_880D:
                STX $24                 ; $24 = typ formátu (0=PageFox, 1-4=jiné)
                JSR L0_8849              ; Načti textová data
                BCS L0_8825
                BIT $1F
                BPL L0_8824
                LDA $24
                BNE L0_8824              ; Pokud není PageFox, přeskoč layout
; === Načtení layout sekce (jen pro PageFox) ===
                JSR L0_8956              ; Načti 'L' + layout data
                BCS L0_8824
                JSR L0_897A              ; Načti barvy
L0_8824:
                CLC
L0_8825:
                PHP
                JSR L0_92B2              ; Zavři soubor
                PLP
                BCS L0_8831
L0_882C:
                LDA #$00
                JSR L0_9258
L0_8831:
; Překresli obrazovku
                LDX $56
                LDY $57
                STX $02
                STY $03
                LDX #$03
                JSR L0_8482
                JMP L0_83A5
; Definice klikacich poli pro vetu 1D (ASCII, ..., VIZA)
                !by $1D, $01, $04, $00, $07, $12, $22, $28
L0_8849:
                BIT $1F
                BPL L0_8853
                LDX #$01
                LDY #$19
                BNE L0_8857
L0_8853:
                LDX $5A
                LDY $5B
L0_8857:
                STX $5F
                STY $60
                LDA #$00
                STA $5C
                LDX #$00
                LDY #$3F
                STX $02
                STY $03
L0_8867:
                JSR CBM_CHRIN
                JSR L0_88E3
                BCS L0_8894
L0_886F:
                TAX
                BEQ L0_8899
                LDY #$00
                STA ($02),Y
                INC $02
                BNE L0_887C
                INC $03
L0_887C:
                LDX $5F
                LDY $60
                INX
                BNE L0_8890
                INY
                CPY #$3C
                BCC L0_8890
                LDA #$05                ; msg. no.
                JSR L0_9747              ; print "Preteceni pameti"
                SEC
                BCS L0_8899
L0_8890:
                STX $5F
                STY $60
L0_8894:
                LDA $90
                BEQ L0_8867
                CLC
L0_8899:
                PHP
                BIT $1F
                BPL L0_88B3
                JSR L0_90C2
                STX $56
                STY $57
                STX $58
                STY $59
                LDA #$00
                STA $23
                LDA #$03
                STA $22
                BNE L0_88BE
L0_88B3:
                LDA $58
                CLC
                ADC $23
                TAX
                LDA $59
                ADC #$00
                TAY
L0_88BE:
                LDA $5F
                CLC
                SBC $5A
                STA $6C
                LDA $60
                SBC $5B
                STA $6D
                BCC L0_88E1
                STX $02
                STY $03
                TXA
                PHA
                TYA
                PHA
                JSR L0_85E1
                PLA
                STA $09
                PLA
                STA $08
                JSR L0_858E
L0_88E1:
                PLP
                RTS
L0_88E3:
                LDX $24
                BEQ L0_8920
                CPX #$04
                BNE L0_88FB
                LDY #VIZA_LEN
L0_88ED:
                DEY
                BMI L0_88FA
                CMP VIZA_IN,Y
                BNE L0_88ED
                LDA VIZA_OUT,Y
                BCS L0_8920
L0_88FA:
                DEX
L0_88FB:
                DEX
                BEQ L0_8913
                DEX
                TAY
                AND #$1F
                PHA
                TYA
                LSR
                LSR
                LSR
                LSR
                LSR
                PHA
                TXA
                LSR
                PLA
                ROL
                TAY
                PLA
                ORA L0_8922,Y
L0_8913:
                CMP #$80
                BCS L0_8921
                CMP #$20
                BCS L0_8920
                CMP #$0D
                SEC
                BNE L0_8921
L0_8920:
                CLC
L0_8921:
                RTS
L0_8922:
                !by $00,$60,$20,$20,$60,$40,$00,$00
                !by $00,$00,$00,$00,$40,$00,$00,$00
; VIZA_DE map change in L_88DE
VIZA_DE_IN:
                !by $F1,$E6,$ED,$EE,$DF,$DB,$EB,$EF
                !by $EC,$DC,$DD,$79,$7A,$7B,$65,$76
                !by $78,$7C
VIZA_DE_OUT:
                !by $01,$02,$04,$05,$06,$07,$08,$0B
                !by $0C,$0D,$10,$5B,$5C,$5D,$7B,$7C
                !by $7D,$7E

;==========================================================
; Načtení layout sekce ze souboru
;==========================================================
; Čte 'L' signaturu, délku a layout data
; Layout data obsahují textové rámečky a pozice obrázků:
; $40,X1/4,Y1/4,X2/4,Y2/4 = textový rámeček (5 bajtů)
; $Cn,X1/4,Y1/4,X2/4,Y2/4,filename = obrázek (5+n bajtů)
; kde n = délka názvu souboru (dolní nibble flags)
;==========================================================
L0_8956:
                JSR CBM_CHRIN           ; Čti bajt
                TAX
                BEQ L0_8956              ; Přeskoč $00
                CMP #$4C                ; Je to 'L'?
                SEC
                BNE L0_8979              ; Ne -> chyba
; === Načti délku layoutu ===
                JSR CBM_CHRIN
                STA $1700               ; Ulož délku (počet bajtů)
; === Načti layout data (rámečky) ===
                LDY #$00
L0_8969:
                JSR CBM_CHRIN
                STA $1800,Y             ; Ulož do $1800+
                INY
                CPY $1700
                BCC L0_8969
L0_8975:
                JSR L0_907B              ; Zpracuj layout data?
                CLC
L0_8979:
                RTS
L0_897A:
                LDY #$00
L0_897C:
                JSR CBM_CHRIN           ; Čti bajt
                STA $1701,Y             ; Ulož do $1701+ (barvy)
                INY
                LDA $90                 ; Kontrola konce souboru
                BEQ L0_897C              ; Pokračuj dokud není EOF
                JMP L0_9142              ; Aplikuj barvy na obrazovku
;==========================================================
; Text command C= D
;==========================================================
L0_898A:
                LDA #$02
                JSR L0_957C
                BCS L0_8994
                JSR L0_9258
L0_8994:
                JMP L0_9660
;==========================================================
; Text command C= F
;==========================================================
L0_8997:
                LDY #$00
                JSR L0_8A08
                BCS L0_89B8
                LDA #$00
L0_89A0:
                JSR L0_8A6F
                BCS L0_89B8
                LDA #$0E                ; msg. no.
                JSR L0_9747              ; print "RETURN=Dale"
L0_89AA:
                JSR $9474
                BEQ L0_89AA
                CMP #$AD
                BNE L0_89B8
L0_89B3:
                LDA $0355
                BCS L0_89A0
L0_89B8:
                JSR L0_9660
                JMP L0_973E
;==========================================================
; Text command C= R
;==========================================================
L0_89BD:
                LDY #$00
                JSR L0_8A08
                BCS L0_89B8
                LDY #$21
                JSR L0_8A08
L0_89CA:
                BCS L0_89B8
                LDA #$00
                STA $1F
L0_89D0:
                JSR L0_8A6F
                BCS L0_89B8
                LDA #$0F                ; msg. no.
                JSR L0_9747              ; print "RETURN=Nahradit..."
L0_89DA:
                JSR $9474
                CMP #$B3
                BEQ L0_89B8
                BIT $1F
                BMI L0_89FB
                TAX
                BEQ L0_89DA
                LDA $0355
                CPX #$20
                BEQ L0_89D0
                CPX #$AD
                BEQ L0_89FB
                CPX #$AC
                BNE L0_89B8
                LDA #$80
                STA $1F
L0_89FB:
                JSR L0_8AD2
                LDA $0376
                BCC L0_89D0
                LDA #$05                ; msg. no.
                JMP L0_9747              ; print "Preteceni pameti"
L0_8A08:
                STY $85
                JSR L0_8A64
                LDY $85
                LDA $0355,Y
                BEQ L0_8A40
                TAX
                DEX
                CLC
                ADC $85
                TAY
L0_8A1A:
                LDA $0355,Y
                STA $0430,X
                DEY
                DEX
                BPL L0_8A1A
                LDA #$08
                LDY #$01
                JSR L0_9664
L0_8A2B:
                JSR $9474
                BEQ L0_8A2B
                CMP #$AD
                BEQ L0_8A62
                SEI
                LDX $C6
                STA $0277,X
                INC $C6
                CLI
                JSR L0_8A64
L0_8A40:
                JSR L0_94DB
                BCS L0_8A63
                SEC
                TAX
                ORA $85
                BEQ L0_8A63
                LDY $85
                TXA
                STA $0355,Y
                BEQ L0_8A62
                CLC
                ADC $85
                TAY
                DEX
L0_8A58:
                LDA $0430,X
                STA $0355,Y
L0_8A5E:
                DEY
                DEX
                BPL L0_8A58
L0_8A62:
                CLC
L0_8A63:
                RTS
L0_8A64:
                LDA #$0C
                LDY $85
                BEQ L0_8A6C
                LDA #$0D                ; msg. no.
L0_8A6C:
                JMP L0_9747              ; print "Novy"
L0_8A6F:
                SEI
                CLC
                ADC $23
                ADC $58
                STA $02
                LDA $59
                ADC #$00
                STA $03
L0_8A7D:
                LDA $02
                CLC
                ADC $0355
                ROL $1C
                CLC
                SBC $5A
                LDA $03
                ROR $1C
                ADC #$00
                ROL $1C
                SBC $5B
                BCS L0_8AC7
                LDY #$00
L0_8A96:
                LDA ($02),Y
                BIT $54
                BPL L0_8A9F
                JSR L0_944B
L0_8A9F:
                STA $1C
L0_8AA1:
                LDA $0356,Y
                CMP #$09
                BEQ L0_8AB3
                BIT $54
                BPL L0_8AAF
                JSR L0_944B
L0_8AAF:
                CMP $1C
                BNE L0_8AC9
L0_8AB3:
                INY
                CPY $0355
                BCC L0_8A96
                LDX $02
                LDY $03
                STX $58
                STY $59
L0_8AC1:
                LDA #$0A                ; msg. no.
                JSR L0_8354
                CLC
L0_8AC7:
                CLI
                RTS
L0_8AC9:
                INC $02
                BNE L0_8ACF
                INC $03
L0_8ACF:
                JMP L0_8A7D
L0_8AD2:
                LDA $6C
                PHA
                LDA $6D
                PHA
                LDA $58
                CLC
                ADC $23
                TAX
                LDA #$00
                STA $6D
L0_8AE2:
                ADC $59
                TAY
                LDA $0376
                SEC
                SBC $0355
L0_8AEC:
                BEQ L0_8B29
                BCC L0_8B0D
                STA $6C
                DEC $6C
                CLC
                ADC $5A
                LDA $5B
                ADC #$00
                CMP #$3C
                BCS L0_8B3F
                STX $02
                STY $03
                TXA
                PHA
                TYA
                PHA
                JSR L0_85E1
                JMP L0_8B25
L0_8B0D:
                EOR #$FF
                STA $6C
                STX $5D
                TXA
                PHA
                CLC
                ADC $6C
                STA $5F
                STY $5E
                TYA
                PHA
                ADC #$00
                STA $60
                JSR L0_85B1
L0_8B25:
                PLA
                TAY
                PLA
                TAX
L0_8B29:
                STX $02
                STY $03
                LDY $0376
L0_8B30:
                BEQ L0_8B3B
                DEY
L0_8B33:
                LDA $0377,Y
                STA ($02),Y
                DEY
                BPL L0_8B33
L0_8B3B:
                JSR L0_83A5
                CLC
L0_8B3F:
                PLA
                STA $6D
                PLA
                STA $6C
                RTS
;==========================================================
; Text command C= F1 - F8
;==========================================================
L0_8B45:
                LDA #$09                ; msg. no.
                JSR L0_9747              ; print "F1=Text ...."
L0_8B4B:
                JSR $9474
                CMP #$B3
                BEQ L0_8B80
                CMP #$AA
                BNE L0_8B5F
                INC $1702
                LDX $1702
                STX $D021
L0_8B5F:
                CMP #$B1
                BNE L0_8B66
                INC $D020
L0_8B66:
                CMP #$A8
                BNE L0_8B73
                INC $1701
                JSR L0_9142
                JMP L0_8B4B
L0_8B73:
                CMP #$A6
                BNE L0_8B4B
                INC $1703
                JSR L0_9136
                JMP L0_8B4B
L0_8B80:
                JMP L0_973E

;==========================================================
; Text command C= CLR/HOME
;==========================================================
L0_8B83:
                LDA #$08                ; msg. no.
                JSR L0_9747              ; print "Volnych znaku:"
                LDA #$00
                CLC
                SBC $5A
                STA $1A
                LDA #$3C
                SBC $5B
                STA $1B
                LDX #$01
                LDY #$0F
                JMP L0_9682
;==========================================================
; Text command C= V
;==========================================================
L0_8B9B:
                LDA #$1E                ; msg. no.
                JMP L0_9747              ; print "Pagefox version"
L0_8BA1:
                LDA $3F
                ASL
                ASL
                ORA $3F
                AND #$24
                CMP #$04
                BNE L0_8BE3
                LDA #$FF
                STA $3F
                JSR L0_8E0A
                JSR L0_8EAA
L0_8BB7:
                JSR CBM_GETIN
                CMP #$B3
                BEQ L0_8BDD
                BIT $36
                BPL L0_8BC5
                JSR $8DB3
L0_8BC5:
                LDA $3F
                ASL
                ASL
                ORA $3F
                AND #$24
                CMP #$04
                BNE L0_8BB7
                LDA #$FF
                STA $3F
                JSR $8DB3
                JSR L0_8BE4
                BCC L0_8BB7
L0_8BDD:
                JSR L0_90D3
                JSR L0_9660
L0_8BE3:
                RTS
L0_8BE4:
                JSR L0_8C09
                BCS L0_8C08
                BEQ L0_8C08
                CMP #$9F
                BEQ L0_8BF7
                BCS L0_8BFC
                JSR $8C6C
                CLC
                BCC L0_8C08
L0_8BF7:
                JSR $8CC9
                SEC
                RTS
L0_8BFC:
                PHA
                JSR L0_90D3
                JSR L0_9660
                PLA
                JSR L0_8057
                SEC
L0_8C08:
                RTS
L0_8C09:
                LDA $0B
                SEC
                SBC #$50
                BCC L0_8C38
                CMP #$A0
                BCS L0_8C38
                LSR
                LSR
                LSR
                LSR
                STA $1C
                LDA $0D
                SEC
                SBC #$48
                BCC L0_8C38
L0_8C21:
                CMP #$50
                BCS L0_8C38
                AND #$F0
                LSR
                LSR
                STA $1D
                LSR
                LSR
                ADC $1D
                ASL
                ADC $1C
                TAX
                LDA L0_8C3A,X
L0_8C36:
                CLC
                RTS
L0_8C38:
                SEC
                RTS
L0_8C3A:
                !by $00
                !by $00
                !by $00
L0_8C3D:
                !by $00
                !by $00
                !by $00
                !by $00
                !by $01
                !by $02
                !by $9F
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $03
                !by $04
                !by $9F
                !by $00
                !by $00
                !by $00
                !by $00
L0_8C52:
                !by $00
L0_8C53:
                !by $00
                !by $00
L0_8C55:
                !by $05
                !by $06, $9F
                !by $11, $09
                !by $08
                !by $0F
                !by $0A
                !by $10,$0D
                !by $0E, $0B, $0C
                !by $B2
                !by $BB
                !by $BC, $BE, $BF
                !by $B5, $B6
                !by $BA
                !by $B8
                LDA $08C9,Y
                BCC L0_8C90
                PHA
                TXA
                SEC
                SBC #$1E
                JSR L0_8E8E
                PLA
                SEC
                SBC #$08
                LDX #$00
                CMP #$08
                BCC L0_8C85
L0_8C82:
                AND #$07
                INX
L0_8C85:
                TAY
                LDA $8CC1,Y
                EOR $81,X
                STA $81,X
                CLC
                BCC L0_8CBD
L0_8C90:
                TAY
                DEY
                BNE L0_8C97
                SEC
L0_8C95:
                BCS L0_8C9B
L0_8C97:
                DEY
                BNE L0_8CA1
                CLC
L0_8C9B:
                JSR $0DC6
                CLC
                BCC L0_8CBD
L0_8CA1:
                LDX #$00
                DEY
                BEQ L0_8CB7
                DEY
                BEQ L0_8CAD
                INX
                DEY
                BEQ L0_8CB7
L0_8CAD:
                LDA $77,X
                CMP #$08
                BCS L0_8CBF+1
                INC $77,X
                BCC L0_8CBD
L0_8CB7:
                LDA $77,X
                BEQ L0_8CBF+1
                DEC $77,X
L0_8CBD:
                !by $20
                TAX
L0_8CBF:
                STX L0_8060
                RTI
                JSR $0810
                !by $04
                !by $02
                ORA ($A4,X)
                !by $23
                BEQ L0_8CD9
                LDA #$20
L0_8CCF:
                CMP ($58),Y
                BEQ L0_8CD6
                DEY
                BPL L0_8CCF
L0_8CD6:
                INY
                STY $23
L0_8CD9:
                LDY #$00
                BIT $82
                BVC L0_8D2C
                STY $23
                LDY $59
                LDX $58
                BNE L0_8CE8
                DEY
L0_8CE8:
                DEX
                STX $02
                STY $03
                LDY #$00
                LDA ($02),Y
                CMP #$0D
                BEQ L0_8CFF
                CMP #$02
                BCC L0_8CFF
                LDA #$0D
                STA $3F00
                INY
L0_8CFF:
                LDX #$02
L0_8D01:
                LDA L0_8DA8,X
                STA $3F00,Y
                INY
                DEX
                BPL L0_8D01
                TYA
                PHA
                LDA $7F
                STA $1A
                LDA #$00
                STA $1B
                JSR L0_96A1
                PLA
                TAY
L0_8D1A:
                LDA $0201,X
                STA $3F00,Y
L0_8D20:
                INY
                INX
                CPX #$05
                BCC L0_8D1A
                LDA #$0D
                STA $3F00,Y
                INY
L0_8D2C:
                BIT $82
                BPL L0_8D36
                LDA #$11
                STA $3F00,Y
                INY
L0_8D36:
                LDA $81
                STA $1C
                LDX #$07
L0_8D3C:
                LSR $1C
                BCC L0_8D67
                LDA L0_8DAB,X
                STA $3F00,Y
                INY
                CMP #$18
                BNE L0_8D57
                LDA $77
                CMP #$02
                BEQ L0_8D67
                ORA #$30
                STA $3F00,Y
                INY
L0_8D57:
                CMP #$19
                BNE L0_8D67
                LDA $78
                CMP #$02
                BEQ L0_8D67
                ORA #$30
                STA $3F00,Y
                INY
L0_8D67:
                DEX
                BPL L0_8D3C
                DEY
                BMI L0_8DA7
                STY $6C
                LDA #$00
                STA $6D
                LDA #$80
                STA $5C
                JSR L0_8530
                LDA $82
                AND #$80
                ORA $81
                BEQ L0_8DA7
                LDA #$06                ; msg. no.
                JSR L0_9747              ; print "Oznac konec..."
                JSR L0_90D3
                JSR L0_9660
                JSR L0_8613
                BCS L0_8DA7
                LDY $23
                LDA #$20
L0_8D96:
                CMP ($58),Y
                BEQ L0_8DA0
                INY
                CPY $66
                BCC L0_8D96
                DEY
L0_8DA0:
                STY $23
                LDA #$1A
                JSR L0_8130
L0_8DA7:
                RTS
L0_8DA8:
                AND $027A,X
L0_8DAB:
                !by $03
                !by $04
                ORA $0B
                !by $0C
                CLC
                ORA $780E,Y
                LDA #$EF
                CMP $19
                BCS L0_8DBC
                STA $19
L0_8DBC:
                LDA #$28
                CMP $19
                BCC L0_8DC4
                STA $19
L0_8DC4:
                LDA $18
                BNE L0_8DD2
                LDA #$0E
                CMP $17
                BCC L0_8DDE
                STA $17
                BCS L0_8DDE
L0_8DD2:
                LDA #$01
                STA $18
                LDA #$4D
                CMP $17
                BCS L0_8DDE
                STA $17
L0_8DDE:
                LDA $19
                STA $D003
                LDA $17
                STA $D002
                LDA $18
                ASL
                STA $D010
                LDA $19
                SEC
                SBC #$28
                STA $0D
                LDA $17
                SEC
                SBC #$0E
                STA $0B
                LDA $18
                SBC #$00
                STA $0C
                LDA $36
                AND #$7F
                STA $36
                CLI
                RTS
L0_8E0A:
                JSR L0_8ECC
                LDX #$1A
                LDY #$A0
                STX $02
                STY $03
                LDX #$90
                LDY #$6B
                STX $08
                STY $09
                LDX #$0A
                LDY #$14
                CLC
                JSR L0_8F12
                LDA #$00
                STA $02
                LDA #$5C
                STA $03
                LDX #$02
                LDY #$27
                LDA $1702
                AND #$0F
                STA $1C
                LDA $1703
                ASL
                ASL
                ASL
                ASL
                ORA $1C
                JSR L0_8F50
                LDX #$15
                LDY #$27
                LDA $1702
                AND #$0F
                STA $1C
                LDA $1701
                ASL
                ASL
                ASL
                ASL
                ORA $1C
                JSR L0_8F50
                LDA #$72
                STA $02
                LDA #$5D
                STA $03
                LDX #$09
                LDY #$13
                LDA $1704
                JSR L0_8F50
                LDA #$03
                JSR $0DCC
                LDX #$00
                STX $5C
                STX $81
                STX $82
                INX
                STX $7F
L0_8E7D:
                INX
                STX $77
                STX $78
                JSR L0_9042
                SEI
                LDA $36
                ORA #$80
                STA $36
                CLI
                RTS
L0_8E8E:
                ASL
                ASL
                ASL
                ASL
                TAY
                LDX #$10
L0_8E95:
                LDA $7310,Y
                EOR #$FF
                STA $7310,Y
                LDA $7450,Y
                EOR #$FF
                STA $7450,Y
                INY
                DEX
                BNE L0_8E95
                RTS
L0_8EAA:
                LDX #$1A
                LDY #$A0
                STX $02
                STY $03
                LDX #$90
                LDY #$6B
                STX $08
                STY $09
                LDX #$06
                LDY #$14
                CLC
                JSR L0_8F12
                LDA $66
                PHA
                JSR $0DD7
                PLA
                STA $66
                RTS
L0_8ECC:
                LDX #$00
                LDY #$04
                STX $02
                STY $03
                LDY #$60
                STX $06
                STY $07
L0_8EDA:
                LDA #$01
                STA $09
                LDY #$00
                LDA ($02),Y
                ASL
                ROL $09
                ASL
                ROL $09
                ASL
                ROL $09
                STA $08
                LDY #$07
L0_8EEF:
                LDA ($08),Y
                STA ($06),Y
                DEY
                BPL L0_8EEF
                LDA $06
                CLC
                ADC #$08
                STA $06
                BCC L0_8F01
                INC $07
L0_8F01:
                INC $02
                BNE L0_8F07
                INC $03
L0_8F07:
                LDA $02
                CMP #$E8
                LDA $03
                SBC #$07
                BCC L0_8EDA
                RTS
L0_8F12:
                STX $27
                STY $26
L0_8F16:
                LDA $09
                PHA
                LDA $08
                PHA
                LDX $26
L0_8F1E:
                LDY #$07
L0_8F20:
                LDA ($02),Y
                STA ($08),Y
                DEY
                BPL L0_8F20
                LDA $02
                CLC
                ADC #$08
                STA $02
                BCC L0_8F32
                INC $03
L0_8F32:
                LDA $08
                CLC
                ADC #$08
                STA $08
                BCC L0_8F3D
                INC $09
L0_8F3D:
                DEX
                BNE L0_8F1E
                PLA
                CLC
                ADC #$40
                STA $08
                PLA
                ADC #$01
                STA $09
                DEC $27
                BNE L0_8F16
                RTS
L0_8F50:
                STY $1C
L0_8F52:
                LDY $1C
L0_8F54:
                STA ($02),Y
                DEY
                BPL L0_8F54
                PHA
                LDA $02
                CLC
                ADC #$28
                STA $02
                BCC L0_8F65
                INC $03
L0_8F65:
                PLA
                DEX
                BPL L0_8F52
                RTS
; cold start init
L0_8F6A:
                LDA #$00
                TAY
; clear ram $0002..$00FF, $0200..$02FF, $0300..$03FF
L0_8F6D:
                STA $0002,Y
                STA $0200,Y
                STA $0300,Y
                INY
                BNE L0_8F6D
                LDY #$1F
; copy KERNAL ROM to RAM: $FD30..$FD4F → $0314..$0333
L0_8F7B:
                LDA $FD30,Y
                STA $0314,Y
                DEY
                BPL L0_8F7B
; set colors and sprites
                LDA #$04
                STA $0288
                JSR $FF5B
; Border color
                LDA #.COLOR_BORDER
                STA $D020
                LDA #$00
                STA $D01C
                STA $D01D
                STA $D017
                JSR L0_9070
; set pointer / buffer on $1900
                LDX #$01
                LDY #$19
                STX $58
                STY $59
                STX $0342
                STY $0343
; NMI vector
                LDX #$BB
                LDY #$0E
                STX $FFFA
                STY $FFFB
                STX $0318
                STY $0319
; IRQ/BRK vector
                LDX #$45
                LDY #$0E
                STX $FFFE
                STY $FFFF
; RAM IRQ vector (KERNAL)
                LDX #$4A
                LDY #$0E
                STX $0314
                STY $0315
; CIA timer
                LDA #$1C
                STA $DC04
                STA $DC05
;==========================================================
; ram upload check
                LDX #$10
                LDY #$7F
L0_8FDD:
                LDA $0900,Y
                CMP $B100,Y
                BNE L0_8FE9
                DEY
                BPL L0_8FDD
                DEX
; copy data from $B000 to $0800, X pages by 256B (10)
L0_8FE9:
                TYA
                PHA
                LDA #$B0
                STA $03
                LDA #$08
                STA $05
                LDY #$00
                STY $02
                STY $04
L0_8FF9:
                LDA ($02),Y
                STA ($04),Y
                INY
                BNE L0_8FF9
                INC $03
                INC $05
                DEX
                BNE L0_8FF9
                CLI
                PLA
                BPL L0_9033
                LDY #$01
                LDA #$19
                STA $5B
                LDA #$00
                STA $1900
                STA $5A
L0_9018:
                LDA ($5A),Y
                BEQ L0_9029
                INY
                BNE L0_9018
                INC $5B
                LDA $5B
                CMP #$3C
                BCC L0_9018
                BCS L0_9036
L0_9029:
                STY $5A
                LDA #$00
                STA $1900
                JMP L0_907B
L0_9033:
                JSR $0DBA
L0_9036:
                JMP L0_90C2
L0_9039:
                JSR L0_90B9
L0_903C:
                LDX #$03
                JSR L0_964F
                RTS
L0_9042:
                BIT $D011
                BPL L0_9042
                LDA #$BB
                STA $D011
                LDA #$78
                STA $D018
                LDA $DD00
                AND #$FC
                ORA #$02
                STA $DD00
                LDX #$00
                STX $D01B
                STX $54
                SEI
                LDA $36
                ORA #$01
                STA $36
                CLI
                LDX #$FE
                STX $5FF9
                RTS
; clear $7F40..$7F7F (64B)
L0_9070:
                LDA #$00
                LDY #$3F
L0_9074:
                STA $7F40,Y
                DEY
                BPL L0_9074
                RTS
L0_907B:
                LDY #$00
L0_907D:
                CPY $1700
                BCS L0_90AC
                LDA $1800,Y
                AND #$1F
                CLC
                ADC #$05
                STA $1C
                LDA $1803,Y
                CMP $1801,Y
L0_9092:
                BCC L0_90AC
                CMP #$A1
                BCS L0_90AC
                LDA $1804,Y
                CMP $1802,Y
                BCC L0_90AC
                CMP #$C9
                BCS L0_90AC
                TYA
                ADC $1C
                TAY
                BCC L0_907D
                LDY #$00
L0_90AC:
                STY $1700
                RTS
L0_90B0:
                LDA #$00
                STA $5C
                LDA #$0A
                JSR L0_8354
L0_90B9:
                JSR L0_9122
                JSR L0_9142
                JMP L0_90D3
L0_90C2:
                LDX #$01
                LDY #$19
                STX $5A
                STY $5B
                LDA #$00
                STA $1900
                STA $1901
                RTS
L0_90D3:
                BIT $D011
                BPL L0_90D3
                LDA #$9B
                STA $D011
                LDA #$12
                STA $D018
                LDA $DD00
                ORA #$03
                STA $DD00
                LDA #$00
                LDX #$3E
L0_90EE:
                STA $03C0,X
                DEX
                BPL L0_90EE
                LDA #$FF
                STA $03EB
                STA $03EE
                LDA #$02
                STA $D01B
                LDA #$0F
                STA $07F9
                LDA #$02
                STA $D015
                LDA #$00
                JSR L0_9437
                SEI
                LDA #$80
                STA $19
                STA $17
                ASL
                STA $18
                LDA $36
                AND #$FE
                STA $36
                CLI
                RTS
L0_9122:
                LDX #$00
                LDA #$00
                JSR L0_974D
                JSR L0_973E
                LDY #$27
                LDA #$1E
-   STA $0450,Y
L0_9133:
                DEY
                BPL -
L0_9136:
                LDA $1703
                LDY #$77
L0_913B:
                STA $D800,Y
                DEY
                BPL L0_913B
                RTS
L0_9142:
                LDA $1701
                LDY #$DC
L0_9147:
                STA $D877,Y
                STA $D953,Y
                STA $DA2F,Y
                STA $DB0B,Y
                DEY
                BNE L0_9147
                LDA $1702
                STA $D021
                RTS
L0_915D:
                STA $1F
;read dir
                LDA #$01                ; msg. no.
                JSR L0_9747              ; print "SPACE=...
                LDX #<L0_920B            ; "$0" need_fix for SoftIEC?
                LDY #>L0_920B
                LDA #$02
                JSR CBM_SETNAM          ; Set file name
                LDY #$00
L0_916F:
                JSR L0_9297              ; set file parameter and open
                BCS L0_91D7
                LDA #$04
                STA $26
L0_9178:
                JSR CBM_CHRIN           ; Input Vector
                DEC $26
                BNE L0_9178
                LDA $90
                SEC
                BNE L0_91D7
                JSR CBM_CLRCHN          ; Restore I/O Vector
L0_9187:
                JSR L0_9213
                BCS L0_91D7
                STA $1C
                LDA #$03
                STA $27
L0_9192:
                LDY $27
                LDA #$0C
                JSR L0_9664
L0_9199:
                JSR $9474               ; get character from imput device
                LDX $27
                CMP #$A0
                BNE L0_91AA
                CPX $26
                BCS L0_9199
                INC $27
                BCC L0_9192
L0_91AA:
                CMP #$A1
                BNE L0_91B6
                CPX #$04
                BCC L0_9199
                DEC $27
                BCS L0_9192
L0_91B6:
                CMP #$AD
                BNE L0_91D9
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
L0_91CE:
                CMP ($02),Y
                BEQ L0_91E7
                INY
                CPY #$14
                BCC L0_91CE
L0_91D7:
                BCS L0_9205
L0_91D9:
                CMP #$B3
                BEQ L0_9205
                CMP #$20
                BNE L0_9199
                LDA $1C
                BNE L0_9187
                BEQ L0_9205
L0_91E7:
                TYA
                LDX $02
                LDY $03
                JSR CBM_SETNAM          ; Set file name
                CLC
                BIT $1F
                BMI L0_9205
                LDX #$0D
                LDY #$92
                STX $04
                STY $05
                JSR L0_9598
                BNE L0_9205
                LDA #$80
                STA $1F
L0_9205:
                PHP
                JSR L0_92B2
                PLP
                !by $60
L0_920B:
                !pet "$:"
                !by $04
                !by $01
                !by $02
                !by $00
                !by $06
                !by $0E
L0_9213:
                LDX #$03
                STX $26
                JSR L0_964F
                LDX #$08
                JSR CBM_CHKIN           ; Set input file
L0_921F:
                JSR CBM_CHRIN           ; Input Vector
                STA $1A
                JSR CBM_CHRIN           ; Input Vector
                STA $1B
                LDX $26
                LDY #$07
                JSR L0_9682
                LDA #$00
L0_9232:
                LDX $26
                JSR L0_94E1
                BCS L0_9250
                JSR CBM_CHRIN
                STA $1C
                JSR CBM_CHRIN
                ORA $1C
                BEQ L0_924F
                LDA $26
                CMP #$18
                BCS L0_924F
                INC $26
                BCC L0_921F
L0_924F:
                CLC
L0_9250:
                PHA
                PHP
                JSR CBM_CLRCHN
                PLP
                PLA
                RTS
L0_9258:
                LDX #$30
                LDY #$04
                JSR CBM_SETNAM
                LDA #$0F
                TAY
                LDX #$08
                JSR CBM_SETLFS
                JSR CBM_OPEN
                BCS L0_928C
                LDX #$0F
                JSR CBM_CHKIN
                BCS L0_928C
                JSR L0_973E
                LDA #$FF
                STA $55
                LDA #$0D
                LDY #$00
                JSR L0_94DF
                LDA $0428
                ORA $0429
                CMP #$30
                BNE L0_928C
                CLC
L0_928C:
                PHP
                JSR CBM_CLRCHN
                LDA #$0F
                JSR CBM_CLOSE
                PLP
                RTS
L0_9297:
                !by $98
                !by $29
                !by $01
                !by $48
                LDA #$08
                TAX
                JSR CBM_SETLFS
                JSR CBM_OPEN
                LDX #$08
                PLA
                BCS L0_92B1
L0_92A9:
                BNE L0_92AE
                JMP $FFC6
L0_92AE:
                JSR CBM_CHKOUT
L0_92B1:
                RTS
L0_92B2:
                JSR CBM_CLRCHN
                LDA #$08
                JMP $FFC3
;==========================================================
; IRQ part
;==========================================================
                LDA $C6
                PHA
                LDA $028D
                PHA
                JSR $EA87
                PLA
                TAX
                LDA $028D
                AND #$06
                BEQ L0_92D8
                TXA
                EOR $028D
                AND #$06
                BEQ L0_92D8
                JSR L0_941B
L0_92D8:
                PLA
                CMP $C6
                BEQ L0_930C
                TAX
                LDA $028D
                ORA $53
                CMP #$04
                BCC L0_92E9
                LDA #$04
L0_92E9:
                ASL
                TAY
                LDA L0_930D,Y
                STA $F5
                LDA L0_930D+1,Y
                STA $F6
                LDY $CB
                LDA ($F5),Y
                BIT $54
                BPL L0_9300
                JSR $944B
L0_9300:
                STA $0277,X
                LDA $53
                BEQ L0_930C
                LDA #$00
                JSR $941B
L0_930C:
                RTS
L0_930D:
                !word L_9317
                !word L_9358
                !word L_9399
                !word L_9399
                !word L_93DA

; Keyboard map 4 blocks x 65 bytes
+InsertKeybMap

; print CTRL or C= or an empty string
; 0 => empty, to delete C= or CTRL in front of CAPS
; 2 => print C=
; 4 => print CTRL
L0_941B:
                STA $53
                CMP #$06                ; 0 = empty, 2 = C=
                BCC L0_9423
                LDA #$04                ; for CTRL
L0_9423:
                ASL
                ASL
                TAX
                LDY #$07
L0_9428:
                LDA L0_945C,X
                STA $0450,Y
                INX
                DEY
                BPL L0_9428
                RTS
;==========================================================
; handle 'CAPS'
; #$00 > switch off, #$FF > switch on
L0_9433:
                LDA #$FF
                EOR $54
L0_9437:
                STA $54
                AND #$06
                EOR #$06
                TAX
                LDY #$05
L0_9440:
                LDA L0_9456,X
                STA $0459,Y
L0_9446:
                INX
                DEY
                BPL L0_9440
                RTS
;==========================================================
L0_944B:
                CMP #$7E
                BCS L0_9455
                CMP #$61
                BCC L0_9455
                SBC #$20
L0_9455:
                RTS
L0_9456:
                !by $1D,$53,$50,$41,$43,$1C ; "<caps>"
L0_945C:
                !by $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
                !by $1E,$1D,$3D,$43,$1C,$1E,$1E,$1E
                !by $1D,$4C,$52,$54,$43,$1C,$1E,$1E
                LDA $99
                BNE L0_94D6
                SEI
                LDA $3F
                ASL
                ASL
                ORA $3F
                AND #$24
                CMP #$04
                BNE L0_948D
                LDA #$FF
                STA $3F
                LDA #$AD
                BNE L0_94D9
L0_948D:
                LDA $3F
                AND #$12
                CMP #$02
                BNE L0_949D
                LDA #$FF
                STA $3F
                LDA #$20
                BNE L0_94D9
L0_949D:
                SEI
                LDX #$A0
                LDA $19
                BMI L0_94AB
                LDX #$A1
                LDA #$00
                SEC
                SBC $19
L0_94AB:
                AND #$7F
L0_94AD:
                CMP #$08
                BCC L0_94BA
                LDA #$80
                STA $19
                STA $17
                TXA
                BNE L0_94D9
L0_94BA:
                LDX #$A2
                LDA $17
                BMI L0_94C7
                LDX #$A3
                LDA #$00
                SEC
                SBC $17
L0_94C7:
                AND #$7F
                CMP #$08
                BCC L0_94D6
                LDA #$80
                STA $17
                STA $19
L0_94D3:
                TXA
                BNE L0_94D9
L0_94D6:
                JSR CBM_GETIN
L0_94D9:
                CLI
                RTS
L0_94DB:
                LDA #$AD
                LDY #$08
L0_94DF:
                LDX #$01
L0_94E1:
                STA $24
                TYA
                PHA
                STX $26
                LDY #$28
                JSR L0_96FB
                STX $02
                TYA
                ORA #$04
                STA $03
                PLA
                STA $1D
                STA $1C
                LDY $26
                JSR L0_9664
                LDA #$00
                STA $90
L0_9501:
                JSR $9474
                SEC
                LDX $90
                BNE L0_957B
                LDY $1C
                CMP $24
                BEQ L0_9576
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                LDX $99
                BNE L0_9564
                TAX
                BEQ L0_9501
                CMP #$AE
                BNE L0_9524
                LDA #$0D
L0_9524:
                CMP #$AF
                BNE L0_9533
                CPY $1D
                BEQ L0_9501
                DEY
                DEC $1C
                LDA #$1F
L0_9531:
                BNE L0_956A
L0_9533:
                CMP #$B3
                BEQ L0_957B
                CMP #$BD
                BNE L0_9541
                JSR L0_9433
                JMP L0_9501
L0_9541:
                CMP #$B4
                BNE L0_9560
                LDA $59
                CMP #$5C
                BCS L0_9501
                LDX $23
L0_954D:
                TXA
                TAY
                LDA ($58),Y
                BEQ L0_956C
                LDY $1C
                CPY #$28
                BCS L0_956C
                STA ($02),Y
                INX
                INC $1C
                BNE L0_954D
L0_9560:
                CMP #$A0
                BCS L0_9501
L0_9564:
                CPY #$28
                BCS L0_9501
                INC $1C
L0_956A:
                STA ($02),Y
L0_956C:
                LDA $1C
                LDY $26
L0_9570:
                JSR L0_9664
                JMP L0_9501
L0_9576:
                SEC
                TYA
                SBC $1D
                CLC
L0_957B:
                RTS
L0_957C:
                JSR L0_9747
                LDA #$FF
                JSR L0_9437
                JSR L0_94DB
                PHA
                PHP
                LDX #$30
                LDY #$04
                JSR CBM_SETNAM
                LDA #$00
                JSR L0_9437
                PLP
                PLA
                RTS
L0_9598:
                LDY #$00
                STY $26
                LDA ($04),Y
                JSR L0_9747
L0_95A1:
                JSR L0_95B1
                BCC L0_95AF
                CMP #$A0
                BEQ L0_95A1
                CMP #$A1
                BEQ L0_95A1
                SEC
L0_95AF:
                TAX
                RTS
L0_95B1:
                LDY #$02
                LDA ($04),Y
                CLC
                ADC #$03
                TAY
                LDA ($04),Y
                STA $27
                CMP $26
                BCS L0_95C3
                STA $26
L0_95C3:
                LDY #$01
                LDA ($04),Y
                TAY
                LDA $26
                JSR L0_9664
L0_95CD:
                JSR $9474
                BEQ L0_95CD
                CMP #$A2
                BNE L0_95E1
                LDX $26
                INX
                CPX $27
L0_95DB:
                BCS L0_95CD
                STX $26
                BCC L0_95C3
L0_95E1:
                CMP #$A3
                BNE L0_95EE
                LDX $26
                DEX
                BMI L0_95CD
                STX $26
                BPL L0_95C3
L0_95EE:
                CMP #$AD
                BNE L0_960D
                LDY #$02
                LDA ($04),Y
                CLC
                ADC #$02
                TAY
                LDA $26
L0_95FC:
                CMP ($04),Y
                BCS L0_9607
                DEY
                CPY #$03
                BCS L0_95FC
                BCC L0_95CD
L0_9607:
                TYA
                SEC
                SBC #$03
                CLC
                RTS
L0_960D:
                CMP #$B3
                BEQ L0_9619
                CMP #$A0
                BEQ L0_9619
                CMP #$A1
                BNE L0_95CD
L0_9619:
                RTS
L0_961A:
                PHA
                LDY #$01
                LDA ($04),Y
                TAX
                DEY
                LDA ($04),Y
                JSR L0_974D
                LDA $09
                CLC
                ADC #$D4
                STA $09
                LDA $1701
                LDY #$27
L0_9632:
                STA ($08),Y
                DEY
                BPL L0_9632
                PLA
                CLC
                ADC #$04
                TAY
                LDA ($04),Y
                STA $1C
                DEY
                LDA ($04),Y
L0_9643:
                TAY
                LDA $1703
L0_9647:
                STA ($08),Y
                INY
                CPY $1C
                BCC L0_9647
                RTS
L0_964F:
                CPX #$19
                BCS L0_965F
                TXA
                PHA
                LDA #$00
                JSR print_msg
                PLA
                TAX
                INX
                BNE L0_964F
L0_965F:
                RTS
L0_9660:
                LDA $23
                LDY $22
L0_9664:
                ASL
                ASL
                ASL
                PHP
                CLC
                ADC #$10
                STA $D002
                LDA #$00
                ROL
                PLP
                ADC #$00
                ASL
                STA $D010
                TYA
                ASL
                ASL
                ASL
                ADC #$2B
                STA $D003
                RTS
L0_9682:
                TYA
                PHA
                LDY #$28
                JSR L0_96FB
                STX $02
                TYA
                ORA #$04
                STA $03
                JSR L0_96A1
                PLA
                TAY
L0_9695:
                LDA $0201,X
                STA ($02),Y
                INY
                INX
                CPX #$05
                BCC L0_9695
                RTS
L0_96A1:
                LDX #$04
L0_96A3:
                LDA #$00
                LDY #$10
L0_96A7:
                ROL $1A
                ROL $1B
                ROL
                CMP #$0A
                BCC L0_96B2
                SBC #$0A
L0_96B2:
                DEY
                BNE L0_96A7
                ROL $1A
                ROL $1B
                ORA #$30
                STA $0201,X
                DEX
                BPL L0_96A3
                INX
L0_96C2:
                LDA $0201,X
                CMP #$30
                BNE L0_96D3
L0_96C9:
                LDA #$1F
                STA $0201,X
                INX
                CPX #$04
                BCC L0_96C2
L0_96D3:
                RTS
L0_96D4:
                LDX #$00
                STX $1A
L0_96D8:
                LDA $0430,X
                CMP #$20
                BEQ L0_96F7
                SEC
                SBC #$30
                BCC L0_96FA
                CMP #$0A
                BCS L0_96FA
                PHA
                LDA $1A
                ASL
                ASL
                ADC $1A
                ASL
                STA $1A
                PLA
                ADC $1A
                STA $1A
L0_96F7:
                INX
                BNE L0_96D8
L0_96FA:
                RTS
L0_96FB:
; multiply X with Y
; result in X = low byte, and Y = high byte
multiply_x_y
                STX $1C                 ; line No. (multiplier)
                STY $1D                 ; value to multiply
                LDA #$00
                LDY #$08
-    ASL
                ROL $1D
                BCC +
                CLC
                ADC $1C
                BCC +
                INC $1D
+   DEY
                BNE -
                TAX
                LDY $1D
                RTS
; clculate screen position, and copy msg. to screen
; msg start in ($03)
; line No. in X
L0_9716:
print_msg:
                PHA                     ; save msg. length
                LDY #$28                ; screen line length
                JSR L0_96FB              ; multiply X with Y
                STX $08                 ; screen position low byte
                TYA
                ORA #$04
                STA $09                 ; screen position high byte
                PLA                     ; msg. length
                BEQ L0_9731              ; if zero, go delete the whole line
                PHA
                TAY
                DEY
; copy actual msg. to the screen
L0_9729:
                LDA ($02),Y
                STA ($08),Y
                DEY
                BPL L0_9729
                PLA
; fill actual line from Y-position to the end with empty spaces
L0_9731:
                TAY                     ; position in line
                LDA #$1F                ; empty space
L0_9734:
                CPY #$28                ; compare with line end position
                BCS L0_973D
                STA ($08),Y
                INY
                BNE L0_9734
L0_973D:
                RTS

; delete line 1
L0_973E:
                LDA #$00
                STA $55
                LDX #$01
                JMP print_msg           ; L0_9716

; print a text into the second line on screen
; the text part No. must be in accu
L0_9747:
                LDX #$FF
                STX $55
                LDX #$01                ; line No.
; print a text into a line on screen
; the line No. must be in X,
; the text part No. must be in accu
L0_974D:
                TAY                     ; msg. No.
                TXA                     ; line No.
                PHA                     ; save line No.
                TYA                     ; msg. No
                BMI L0_975B
                LDX #<MSG_TABLE         ; msg. table start
                LDY #>MSG_TABLE
                STX $02
                STY $03
L0_975B:
                AND #$7F                ; delete bit 7
                TAX                     ; set masg. No as counter

; find msg. address pointer
; the msg. address will be in $03/$04
msg_search:
                LDY #$00                ; pointer
; find $0D for msg. end
L0_9760:
                INY
                LDA ($02),Y             ; load char fom msg_table
                CMP #$0D
                BNE L0_9760

                DEX                     ; decrement counter
L0_9768:
                BMI msg_found           ; msg found
                TYA
                SEC
                ADC $02                 ; increment pointer low byte with counter
                STA $02                 ; store as new low byte
                BCC msg_search          ; bcc skip
                INC $03                 ; else increment high byte
                BCS msg_search          ; (jmp)
msg_found:
                PLA                     ; line No.
                TAX                     ; move to X
                TYA                     ; msg. length
                PHA
                JSR print_msg           ;L0_9716
                PLA
                RTS

                JSR L0_9039
                LDA #$00
                STA $1709
                LDX #$04
L0_9789:
                TXA
                PHA
                ASL
                TAY
                LDA $986F,Y
                STA $04
                LDA $9870,Y
                STA $05
                LDA $1705,X
                LDY #$02
                CMP ($04),Y
                BCC L0_97A2
                LDA ($04),Y
L0_97A2:
                JSR L0_961A
                PLA
                TAX
                DEX
                BPL L0_9789
                LDA #$12
                STA $23
                LDX #$04
L0_97B0:
                TXA
                PHA
                ASL
                TAY
                LDA $986F,Y
                STA $04
                LDA $9870,Y
                STA $05
                JSR L0_973E
                LDA $23
                STA $26
                JSR L0_95B1
                TAY
                LDA $26
                STA $23
                PLA
                TAX
                BCC L0_97E9
                CPY #$B3
                BEQ L0_9840
                CPY #$A1
                BNE L0_97DE
                CPX #$00
                BEQ L0_97B0
                DEX
L0_97DE:
                CPY #$A0
                BNE L0_97B0
                CPX #$04
                BCS L0_97B0
                INX
                BCC L0_97B0
L0_97E9:
                PHA
                TYA
                STA $1705,X
                JSR L0_961A
                PLA
                TAX
                CPX #$03
                BCC L0_97B0
                BNE L0_9817
                LDA $1708
                BEQ L0_97B0
                LDA #$21                ; msg. no.
                JSR L0_9747              ; print "Radky"
                JSR L0_94DB
                LDX #$03
                BCS L0_97B0
                JSR L0_96D4
                LDA $1A
                STA $1708
                LDX #$03
                JMP L0_97B0
L0_9817:
                LDY $1709
                BEQ L0_97B0
                DEY
                BEQ L0_983C
                LDA #$1F                ; msg. no.
                JSR L0_9747              ; print "Cislo"
                JSR L0_94DB
                LDX #$04
                BCS L0_97B0
                JSR L0_96D4
                LDA $1A
                SEC
                BEQ L0_9840
                STA $1709
                LDA $70
                ORA #$30
                STA $70
L0_983C:
                JSR L0_9042
                CLC
L0_9840:
                RTS
L0_9841:
                LDX #$00
L0_9843:
                LDA $02,X
                PHA
                INX
                CPX #$04
                BNE L0_9843
                JSR L0_9039
L0_984E:
                LDX #$9C
                LDY #$98
                STX $04
                STY $05
                JSR L0_9598
                BCS L0_984E
                PHA
                JSR L0_9042
                PLA
                LSR
                LDX #$03
L0_9863:
                PLA
                STA $02,X
                DEX
                BPL L0_9863
; Menu row definitions (text + row + tab stops)
                lda #$00
                sta $D015
                rts
pf_menu_rowdef_ptr_table:               ; pointer table (little-endian)
                !word $9879,$9882,$9888,$988F,$9895
; msg $14 on row $08: "Low Medium High Shinwa MPS" (5 items)
                !by $14,$08,$05
                !by $00,$08,$11,$18,$21,$28
; msg $15 on row $0A: "Auto-Linefeed  Linefeed" (2 items)
                !by $15,$0A,$02
                !by $00,$16,$28
; msg $16 on row $0C: "Vlevo  Střed  Vpravo" (3 items)
                !by $16,$0C,$03
                !by $00,$10,$17,$28
; msg $20 on row $0E: "Standard  Tabela..." (2 items)
                !by $20,$0E,$02
                !by $00,$12,$28
; msg $17 on row $10: "Start  Stránka  Skupina" (3 items)
                !by $17,$10,$03
                +InsertPrinterMenuMod1
; msg $1C on row $01: "Pokracovat Zrusit" (2 items)
                !by $1C,$01,$02
                !by $00,$0B,$14
                !by $A9, $00
                STA $D015
                JSR L0_9AF8
                BCS L0_98CE
                !by $AD, $09, $17
                !by $8D, $44, $03
L0_98B2:
                LDX $1705
                LDA $1710,X
                STA $1F
                CPX #$04
                BEQ L0_98C4
                JSR L0_98D9
                JMP L0_98C7
L0_98C4:
                JSR L0_9A39
L0_98C7:
                BCS L0_98CE
                DEC $0344
                BNE L0_98B2
L0_98CE:
                PHP
                JSR L0_9B66
                LDA #$02
                STA $D015
                PLP
                RTS
L0_98D9:
                LDA $70
L0_98DB:
                AND #$EF
                CMP $70
                BEQ L0_98F8
                STA $70
                LDY #$0A
                JSR L0_9B92
                LDA $1708
                BEQ L0_98F8
                LDY #$0B
                JSR L0_9B92
                LDA $1708
                JSR L0_9B70
L0_98F8:
                LDA #$00
                STA $25
                LDA $4C
                STA $22
L0_9900:
                INC $25
                SEC
                JSR $0DC0
                LDA $23
                BEQ L0_9940
                JSR L0_9BAD
                LDA $1F
                AND #$7F
                STA $1F
                JSR L0_9963
                LDA $1F
                AND #$20
                BEQ L0_9931
L0_991C:
                LDY #$05
                JSR L0_9B92
                JSR L0_9BCC
                SEC
                JSR $0DC0
                LDA $1F
                ORA #$80
                STA $1F
                JSR L0_9963
L0_9931:
                LDA $1F
                AND #$0C
                LSR
                LSR
                ADC #$01
                TAY
L0_993A:
                JSR L0_9B92
                JSR L0_9BCC
L0_9940:
                INC $22
                LDA $4E
                CMP $22
                BCC L0_9956
                JSR CBM_GETIN
                CMP #$B3
                BNE L0_9900
                JSR L0_9841
                BCC L0_9900
                BCS L0_9962
L0_9956:
                LDA $70
                AND #$20
                BEQ L0_9962
                LDA #$0C
                JSR L0_9B70
L0_9961:
                CLC
L0_9962:
                RTS
L0_9963:
                LDA #$00
                STA $1B
                STA $26
                LDA $23
                ASL
L0_996C:
                ASL
                ROL $1B
L0_996F:
                ASL
                ROL $1B
L0_9972:
                STA $1A
                LDA #$50
                JSR L0_9BDC
                LDA $1F
                AND #$03
                CLC
                ADC #$06
                TAY
                JSR L0_9B92
L0_9984:
                BIT $1F
                BVC L0_999D
                LDA $1A
                ASL
                ROL $1C
                CLC
                ADC $1A
                STA $1A
                ROR $1C
                LDA $1B
                ROL
                ROL $1C
L0_9999:
                ADC $1B
                STA $1B
L0_999D:
                LDA $1A
                JSR L0_9B70
                LDA $1B
                JSR L0_9B70
L0_99A7:
                JSR $0DC3
                LDY #$08
L0_99AC:
                LDX #$00
L0_99AE:
                ROL $0200,X
                ROL
                INX
                CPX #$08
                BNE L0_99AE
                ROL $0208
                JSR L0_99CF
                DEY
                BNE L0_99AC
                DEC $23
                BNE L0_99A7
                BIT $1F
                BVC L0_99CE
                LDA #$00
                CLC
                JSR L0_99CF
L0_99CE:
                RTS
L0_99CF:
                BIT $1F
                BVC L0_9A1F
                BMI L0_99EC
                BIT $26
                BPL L0_9A2B
                STA $0C
                LDA $0F
                AND $0B
                STA $1C
                EOR $0B
                PHA
L0_99E4:
                AND $0C
                STA $1D
                PLA
                JMP L0_9A13
L0_99EC:
                BIT $26
                BPL L0_9A2B
                STA $0C
                ROL
                STA $0E
                AND $0B
                STA $1C
                LDA $0C
                AND $0D
                STA $1D
                EOR $1C
                PHA
                AND $1D
                STA $1D
                PLA
                AND $1C
                STA $1C
                ORA $0F
                EOR #$FF
                AND $0B
                AND $0D
L0_9A13:
                JSR L0_9B70
                LDA $1C
                JSR L0_9B70
                LDA $1D
                STA $0F
L0_9A1F:
                JSR L0_9B70
                LDA $0E
                STA $0D
L0_9A26:
                LDA $0C
                STA $0B
                RTS
L0_9A2B:
                STA $0B
                ROL
                STA $0D
                LDA #$00
                STA $0F
                LDA #$80
                STA $26
                RTS
L0_9A39:
                LDA #$08
                JSR L0_9B70
                LDA #$3C
                CMP $51
                BCS L0_9A46
                STA $51
L0_9A46:
                LDA $4C
                STA $22
                LDA #$00
                STA $24
L0_9A4E:
                CLC
                JSR $0DC0
                LDA #$3C
                SEC
                SBC $51
                BEQ L0_9A7E
                LDX $1707
L0_9A5C:
                BEQ L0_9A7E
                CPX #$02
                BEQ L0_9A63
                LSR
L0_9A63:
                ASL
                ASL
                ASL
                ROL $1C
                PHA
                LDA #$1B
                JSR L0_9B70
                LDA #$10
                JSR L0_9B70
                LDA #$1C
                AND #$01
                JSR L0_9B70
                PLA
                JSR L0_9B70
L0_9A7E:
                LDA $51
                STA $23
                LDA #$00
                STA $26
                STA $27
L0_9A88:
                JSR $0DC3
                LDY #$08
L0_9A8D:
                LDA #$07
                STA $1C
                LDX $24
L0_9A93:
                ROL $0200,X
                ROR
                INX
                DEC $1C
                BNE L0_9A93
                JSR L0_9AD1
                DEY
                BNE L0_9A8D
                DEC $23
                BNE L0_9A88
                LDA #$0D
                JSR L0_9B70
                INC $22
                DEC $24
                BPL L0_9AB7
                DEC $22
                LDA #$07
                STA $24
L0_9AB7:
                LDA $4E
                CMP $22
                BCC L0_9AC9
                JSR CBM_GETIN
                CMP #$B3
                BNE L0_9A4E
                JSR L0_9841
                BCC L0_9A4E
L0_9AC9:
                PHP
                LDA #$0F
                JSR L0_9B70
                PLP
                RTS
L0_9AD1:
                LSR
                BEQ L0_9AF1
                PHA
L0_9AD5:
                LDA $26
                ORA $27
                BEQ L0_9AEB
                LDA #$80
                JSR L0_9B70
                LDA $26
                BNE L0_9AE6
                DEC $27
L0_9AE6:
                DEC $26
                SEC
                BCS L0_9AD5
L0_9AEB:
                PLA
                ORA #$80
                JMP L0_9B70
L0_9AF1:
                INC $26
                BNE L0_9AF7
                INC $27
L0_9AF7:
                RTS
L0_9AF8:
                SEI
                LDA #$00
                STA $DD01
                LDA #$FF
L0_9B00:
                STA $DD03
                LDA $DD00
                ORA #$04
                STA $DD00
                LDA $DD02
                ORA #$04
                STA $DD02
                LDA $DD0D
                LDA $DD00
                AND #$FB
                STA $DD00
                ORA #$04
                STA $DD00
                LDX #$FF
L0_9B25:
                LDA $DD0D
                DEX
                BEQ L0_9B37
                AND #$10
                BEQ L0_9B25
                CLI
                LDA #$00
                STA $170F
                CLC
                RTS
L0_9B37:
                CLI
                LDA #$80
                STA $170F
                JSR CBM_CLRCHN
                LDY #$00
                LDA $1705
                CMP #$04
                BEQ L0_9B4C
                LDY $170E
L0_9B4C:
                LDA #$04
                LDX $170D
                JSR CBM_SETLFS
                LDA #$00
                JSR CBM_SETNAM
                JSR CBM_OPEN
                BCS L0_9B66
                LDX #$04
                JSR CBM_CHKOUT
                BCS L0_9B66
                RTS
L0_9B66:
                JSR CBM_CLRCHN
                LDA #$04
                JSR CBM_CLOSE
                SEC
                RTS
L0_9B70:
                BIT $170F
                BPL L0_9B78
                JMP $FFD2
L0_9B78:
                PHA
                STA $DD01
                LDA $DD00
                AND #$FB
                STA $DD00
                ORA #$04
                STA $DD00
L0_9B89:
                LDA $DD0D
                AND #$10
                BEQ L0_9B89
                PLA
                RTS
L0_9B92:
                LDX #$00
L0_9B94:
                LDA $1717,X
                INX
                CMP #$FF
                BNE L0_9B94
                DEY
                BNE L0_9B94
L0_9B9F:
                LDA $1717,X
                CMP #$FF
                BEQ L0_9BAC
                JSR L0_9B70
                INX
                BNE L0_9B9F
L0_9BAC:
                RTS
L0_9BAD:
                DEC $25
                BEQ L0_9BCB
                LDA $1F
                AND #$0C
                LSR
                LSR
                ADC #$01
                TAY
                LDA $1F
                AND #$20
                BEQ L0_9BC1
                DEY
L0_9BC1:
                JSR L0_9B92
L0_9BC4:
                JSR L0_9BCC
                DEC $25
                BNE L0_9BC4
L0_9BCB:
                RTS
L0_9BCC:
                LDA #$0D
                JSR L0_9B70
                LDA $1706
                BEQ L0_9BDB
                LDA #$0A
                JSR L0_9B70
L0_9BDB:
                RTS
L0_9BDC:
                SEC
L0_9BDD:
                SBC $51
                BEQ L0_9BF4
                LDX $1707
                BEQ L0_9BF4
                CPX #$02
                BEQ L0_9BEB
                LSR
L0_9BEB:
                TAX
                LDA #$20
                JSR $9B70
                DEX
                BNE L0_9BEB+1
L0_9BF4:
                RTS
VIZA_CS_IN:
+InsertVizaIn

VIZA_CS_OUT:
+InsertVizaOut
}

* = $2000

!pseudopc $A000 {
L0_A000:
                !word $A004
                !word $A004
                LDX #$08
PF_INIT_LOOP:
                LDA L0_A012,X
                STA $0340,X
                DEX
                BPL PF_INIT_LOOP
                JMP $0340
L0_A012:
                LDA #$FF
                STA $DE80               ; disable cartridge / reset bank switching
                JMP CBM_START           ; KERNAL RESET
; Grafiga pro nabidku volby pisma
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$00,$00,$00,$00,$3E,$02,$04
                !by $FF,$00,$00,$00,$00,$78,$84,$80
                !by $FF,$00,$00,$00,$00,$00,$10,$10
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$01,$01,$01,$01,$01,$01,$01
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $9F,$80,$80,$80,$80,$80,$80,$80
                !by $08,$10,$20,$3E,$00,$00,$00,$00
                !by $78,$04,$84,$78,$00,$00,$00,$00
                !by $7C,$10,$10,$00,$00,$00,$00,$00
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $01,$01,$01,$01,$01,$01,$01,$01
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$00,$00,$00,$03,$06,$0D,$0B
                !by $FF,$00,$00,$00,$C0,$60,$B0,$D0
                !by $FF,$00,$00,$00,$00,$00,$10,$10
                !by $80,$80,$88,$8C,$86,$83,$8F,$8F
                !by $01,$01,$21,$61,$C1,$81,$E1,$E1
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $9F,$80,$80,$80,$80,$80,$80,$80
                !by $0B,$08,$0B,$0A,$0E,$00,$00,$00
                !by $D0,$10,$D0,$50,$70,$00,$00,$00
                !by $7C,$10,$10,$00,$00,$00,$00,$00
                !by $80,$87,$8F,$88,$88,$88,$8F,$87
                !by $01,$C1,$E1,$21,$21,$21,$E1,$C1
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$80,$80,$80,$80,$80,$80,$9F
                !by $FF,$00,$00,$00,$03,$04,$08,$09
                !by $FF,$00,$00,$00,$00,$80,$C0,$60
                !by $FF,$00,$00,$00,$00,$10,$10,$7C
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $01,$01,$01,$01,$01,$01,$01,$01
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $0F,$0A,$0B,$02,$02,$00,$00,$00
                !by $D0,$50,$D0,$10,$10,$00,$00,$00
                !by $10,$10,$00,$00,$00,$00,$00,$00
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $01,$01,$01,$01,$01,$01,$01,$01
                !by $FF,$80,$80,$80,$80,$BE,$82,$84
                !by $FF,$00,$00,$00,$00,$78,$84,$80
                !by $FF,$80,$80,$80,$80,$81,$83,$86
                !by $FF,$00,$00,$00,$00,$C0,$60,$30
                !by $FF,$80,$80,$80,$80,$83,$8C,$B0
                !by $FF,$00,$00,$00,$00,$C0,$30,$0C
                !by $FF,$81,$81,$82,$82,$84,$84,$84
                !by $FF,$80,$80,$40,$40,$20,$20,$20
                !by $FF,$80,$80,$80,$80,$81,$82,$84
                !by $FF,$00,$00,$00,$00,$80,$40,$20
                !by $FF,$80,$80,$80,$80,$80,$80,$81
                !by $FF,$00,$00,$00,$00,$70,$88,$08
                !by $FF,$80,$80,$80,$81,$83,$86,$85
                !by $FF,$00,$00,$00,$E0,$30,$D8,$E8
                !by $FF,$80,$80,$80,$80,$83,$84,$88
                !by $FF,$00,$00,$00,$00,$00,$80,$C0
                !by $FF,$80,$81,$82,$82,$83,$82,$82
                !by $FF,$00,$C0,$20,$20,$E0,$20,$20
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$01,$01,$01,$01,$01,$01,$01
                !by $88,$90,$A0,$BE,$80,$80,$80,$FF
                !by $78,$04,$84,$78,$00,$00,$00,$FF
                !by $86,$87,$86,$86,$80,$80,$80,$FF
                !by $30,$F0,$30,$30,$00,$00,$00,$FF
                !by $B0,$BF,$B0,$B0,$80,$80,$80,$FF
                !by $0C,$FC,$0C,$0C,$00,$00,$00,$FF
                !by $84,$87,$87,$84,$84,$84,$84,$FF
                !by $20,$E0,$E0,$20,$20,$20,$20,$FF
                !by $84,$87,$84,$84,$80,$9F,$80,$FF
                !by $20,$E0,$20,$20,$00,$F8,$00,$FF
                !by $81,$83,$82,$84,$80,$80,$80,$FF
                !by $08,$F0,$10,$20,$00,$00,$00,$FF
                !by $85,$84,$85,$85,$87,$80,$80,$FF
                !by $E8,$08,$E8,$28,$38,$00,$00,$FF
                !by $89,$8F,$8A,$8B,$82,$82,$80,$FF
                !by $60,$D0,$50,$D0,$10,$10,$00,$FF
                !by $80,$80,$80,$80,$80,$80,$80,$FF
                !by $00,$00,$00,$00,$00,$00,$00,$FF
                !by $80,$83,$84,$84,$87,$84,$84,$FF
                !by $01,$81,$41,$41,$C1,$41,$41,$FF
                !by $FF,$80,$80,$80,$80,$8F,$88,$8A
                !by $FF,$00,$E0,$50,$28,$F8,$28,$A0
                !by $FF,$80,$80,$80,$80,$BC,$A5,$A5
                !by $FF,$00,$00,$00,$00,$1E,$12,$92
                !by $FF,$80,$80,$80,$80,$80,$81,$81
                !by $FF,$00,$00,$00,$00,$1E,$12,$92
                !by $FF,$80,$80,$81,$87,$8A,$9F,$81
                !by $FF,$00,$00,$E0,$58,$AC,$FE,$20
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$80,$80,$81,$83,$80,$8F,$8F
                !by $FF,$00,$80,$C0,$E0,$00,$F8,$78
                !by $FF,$80,$83,$81,$80,$80,$8F,$8F
                !by $FF,$00,$E0,$C0,$80,$00,$F8,$78
                !by $FF,$80,$80,$80,$8F,$8F,$8F,$8F
                !by $FF,$00,$00,$00,$F8,$78,$78,$F8
                !by $FF,$80,$9F,$91,$91,$91,$91,$91
                !by $FF,$00,$7C,$44,$44,$44,$44,$44
                !by $FF,$80,$E0,$90,$9F,$98,$94,$94
                !by $FF,$01,$01,$01,$FD,$07,$05,$0D
                !by $8A,$8A,$8A,$8A,$88,$8F,$80,$FF
                !by $A0,$A0,$A0,$A0,$20,$E0,$00,$FF
                !by $A5,$A5,$A5,$BC,$80,$80,$80,$FF
                !by $D2,$92,$12,$1E,$00,$00,$00,$FF
                !by $81,$81,$81,$80,$80,$80,$80,$FF
                !by $D2,$92,$12,$1E,$00,$00,$00,$FF
                !by $81,$81,$82,$82,$82,$81,$80,$FF
                !by $20,$20,$20,$20,$20,$C0,$00,$FF
                !by $80,$80,$80,$82,$82,$81,$80,$FF
                !by $00,$00,$00,$C0,$20,$C0,$00,$FF
                !by $8F,$8F,$8E,$8F,$8F,$8F,$80,$FF
                !by $78,$F8,$38,$F8,$F8,$F8,$00,$FF
                !by $8F,$8F,$8E,$8F,$8F,$8F,$80,$FF
                !by $78,$F8,$38,$F8,$F8,$F8,$00,$FF
                !by $8E,$8F,$8F,$8F,$80,$80,$80,$FF
                !by $38,$F8,$F8,$F8,$00,$00,$00,$FF
                !by $91,$91,$91,$91,$91,$9F,$80,$FF
                !by $44,$44,$44,$44,$44,$7C,$00,$FF
                !by $94,$94,$98,$9F,$91,$E2,$84,$FF
                !by $15,$25,$45,$FD,$01,$01,$01,$FF
; Texty a hlasky
MSG_TABLE:
+InsertMsgTable

!if .pg24 = 1 {+InsertModPG24}

}

*=$3000

!pseudopc $B000 {
+InsertChars
                LDA #$00                ; map ROM0 LO
                STA $DE80
                JMP $FCE2
                JSR $0FDC
                JMP L0_9972
                JSR $0FDC
                JMP L0_8000
                JSR $0FE8
                JMP $8010
                JSR $0FFA
                JMP $0FE8
                JMP $13EE
                JMP $1442
                JSR $134D
                JMP $0FE8
                PHA
                JSR $0FDC
                PLA
                JSR $AF3F
                JMP $0FE8
                JSR $0FDC
                JSR $A84D
                JMP $0FE8
                JSR $0FE8
                JSR $8016
                JMP $0FDC
                PHA
                JSR $0FE8
                PLA
                JSR $8019
                PHA
                JSR $0FDC
                PLA
                RTS
                PHA
                JSR $0FE8
                PLA
                JSR $801C
                PHA
                JSR $0FDC
                PLA
                RTS
                PHA
                JSR $0FE8
                PLA
                JSR $801F
                JMP $0FDC
                PHA
                JSR $0FE8
                PLA
                JSR $8022
                JMP $0FDC
                JSR $0FE8
                JSR $8025
                JMP $0FDC
                !by $20
                !by $E8
                !by $0F
                !by $20
                !by $28
                !by $80
                !by $4C
                !by $DC
                !by $0F
                !by $20
                !by $E8
                !by $0F
                !by $20
                !by $2E
                !by $80
                !by $48
                !by $20
                !by $DC
                !by $0F
                !by $68
                !by $60
                !by $E7
                !by $B3
                !by $67
                LDX $07,Y
                TSX
                !by $AF
                STA $CE,X
                !by $9F
                ASL
                LDA ($48,X)
                TXA
                PHA
                TYA
                PHA
                LDA $01
                PHA
                LDA #$37
                STA $01
                LDA #$02                ; map ROM0 HI
                STA $DE80
                LDA $DC0D
                LDA $A2
                AND #$3F
                BNE L0_B66C
                LDA $D028
                EOR #$01
                AND #$01
                STA $D028
                STA $D029
L0_B66C:
                INC $A2
                JSR L0_886F
                LDA $39
                ORA $3A
                BEQ L0_B68F
                LDX $39
                LDY $3A
                JSR $8984
                LDA #$04
                BIT $29
                BEQ L0_B687
                JSR L0_872B
L0_B687:
                LDA $36
                ORA #$A0
                STA $36
                BNE L0_B6AD
L0_B68F:
                LDA $36
                ASL
                AND #$40
                ORA $36
                AND #$DF
                STA $36
                LDA $A2
                LSR
                BCC L0_B6AD
                LDA $3F
                AND #$07
                BNE L0_B6AD
                LDA #$00                ; map ROM0 LO
                STA $DE80
                JSR $8013
L0_B6AD:
                LDA $42
                STA $DE80
                PLA
                STA $01
                PLA
                TAY
                PLA
                TAX
                PLA
                RTI
                PHA
                LDA $028D
                LSR
                BCC L0_B6E1
                BNE L0_B6DE
                CLI
                JSR $0FE8
                JSR $FFE7
                LDA $D011
                AND #$20
                BNE L0_B6D5
                JSR $802B
L0_B6D5:
                JSR $0FDC
                JSR L0_83F9
                JMP $0DAE               ; go to graphic menu
L0_B6DE:
                JMP $148E
L0_B6E1:
                LDA #$00
                STA $36
                PLA
                RTI
                LDA $4A
                BPL L0_B6EC
                RTS
L0_B6EC:
                AND #$BF
                STA $4A
                LDA $29
                LSR
                LSR
                LSR
                LDA #$80
                BCC L0_B705
                LDA $29
                AND #$FB
                STA $29
                LDA #$00
                STA $34
                LDA #$00
L0_B705:
                STA $1F
                LDX $2A
                CPX #$4D
                BCC L0_B711
                LDX #$4D
                STX $2A
L0_B711:
                LDY $2B
                CPY #$28
                BCC L0_B71B
                LDY #$28
                STY $2B
L0_B71B:
                JSR L0_82D3
                LDX #$00
                LDY #$60
                STX $04
                STY $05
                LDY #$3F
                STX $06
                STY $07
                LDX #$00
                BIT $4A
                BPL L0_B735
                LDX $35
                INX
L0_B735:
                LDA $94D2,X
                STA $0F5E
                LDA $29
                AND #$08
                ASL
                ASL
                ASL
                ASL
                STA $24
                LDA #$17
                BIT $1F
                BVC L0_B74D
                LDA #$19
L0_B74D:
                STA $27
L0_B74F:
                JSR $0FD0
                LDY #$00
                LDX #$08
                SEC
L0_B757:
                BIT $1F
                BMI L0_B76E
L0_B75B:
                DEY
                LDA ($02),Y
                ORA ($06),Y
                DEX
                BNE L0_B767
                EOR $24
                LDX #$08
L0_B767:
                STA ($04),Y
                TYA
                BNE L0_B75B
                BEQ L0_B7AA
L0_B76E:
                BIT $43
                BMI L0_B783
L0_B772:
                DEY
                LDA ($04),Y
                DEX
                BNE L0_B77C
                EOR $24
                LDX #$08
L0_B77C:
                STA ($02),Y
                TYA
                BNE L0_B772
                BEQ L0_B7AA
L0_B783:
                LDA #$35
                STA $01                 ; C64-RAM + IO enabled
L0_B787:
                DEY
                LDA ($02),Y             ; reading C64-RAM
                PHA                     ; and save
                LDA $43                 ; read value $08, $0A, $04, $06
                STA $42                 ; and save
                STA $DE80               ; CRT-RAM enable
                LDA ($04),Y             ; Source
                DEX                     ; 
                BNE L0_B79B
                EOR $24
                LDX #$08
L0_B79B:
                STA ($02),Y             ; in CRT
                LDA #$0C                ; idle CRT-RAM
                STA $42
                STA $DE80               ; idle CRT-RAM
                PLA
                STA ($02),Y             ; Repairing C64-RAM
                TYA
                BNE L0_B787
L0_B7AA:
                BCC L0_B7B7
                INC $03
                INC $05
                INC $07
                LDY #$40
                CLC
                BCC L0_B757
L0_B7B7:
                JSR $0FDC
                JSR $82CF
                DEC $05
                LDX #$04
                JSR $8331
                DEC $07
                LDX #$06
                JSR $8331
                DEC $27
                BNE L0_B74F
                RTS
                LDA $43
                STA $42
                STA $DE80
                LDA $45
                STA $01
                RTS
                LDA #$37
                STA $01
                LDA #$02                ;map to ROM0 HI
                STA $42
                STA $DE80
                RTS
                LDA #$37
                STA $01
                LDA #$00                ;map to ROM0 LO
                STA $42
                STA $DE80
                RTS
                JSR $0FFA
                JMP $0FDC
                LDA #$88                ;map to RAM LO
                STA $42
                STA $DE80
                LDA #$80
                JSR $1018
                LDA #$8A                ;map to RAM HI
                STA $42
                STA $DE80
                LDA #$80
                JSR $1018
                LDA #$34
                STA $01
                LDA #$C0
                STA $03
                LDX #$3F
                LDA #$00
                STA $02
                TAY
L0_B821:
                STA ($02),Y
                INY
                BNE L0_B821
                INC $03
                DEX
                BNE L0_B821
                RTS
                JSR $B285
                SEI
                LDA #$FF
                STA $DE80
                JMP $FCE2
                JSR $0FD0
L0_B83B:
                LDA #$08
L0_B83D:
                SEC
                SBC $25
                BCC L0_B886
                PHA
                TAY
                LDX $25
L0_B846:
                TXA
                PHA
                LDX $25
                LDA #$00
L0_B84C:
                ASL
                ORA ($02),Y
                INY
                DEX
                BNE L0_B84C
                PHA
                LDA $25
                EOR #$06
                STA $1C
                PLA
                LDX #$01
L0_B85D:
                ASL
                DEX
                BNE L0_B85D
                ROL $24
                LDX $25
                DEC $1C
                BNE L0_B85D
                TYA
                SEC
                SBC $25
                CLC
                ADC #$08
                TAY
                PLA
                TAX
                DEX
                BNE L0_B846
                PLA
                PHA
                LSR
                BIT $1F
                BPL L0_B87E
                LSR
L0_B87E:
                TAY
                LDA $24
                STA ($06),Y
                PLA
                BPL L0_B83D
L0_B886:
                LDA $25
                ASL
                ASL
                ASL
                ADC $02
                STA $02
                BCC L0_B893
                INC $03
L0_B893:
                LDA $06
                CLC
                ADC #$08
                STA $06
                BCC L0_B89E
                INC $07
L0_B89E:
                DEC $26
                BNE L0_B83B
                JMP $0FDC
                PHA
                JSR $827E
                LDX $2A
                LDY $2B
                JSR L0_82D3
                PLA
                ASL
                ASL
                ASL
                ADC #$00
                STA $08
                LDA #$00
                ADC #$0D
                STA $09
                LDX #$00
                LDY #$60
                STX $04
                STY $05
                LDX #$00
                LDY #$3F
                STX $06
                STY $07
                LDX #$00
                BIT $4A
                BVC L0_B8D7
                LDX $35
                INX
L0_B8D7:
                LDA $94D2,X
                STA $10F4
                LDA #$17
                STA $26
L0_B8E1:
                JSR $0FD0
                LDX #$28
L0_B8E6:
                LDY #$07
L0_B8E8:
                BIT $4A
                BVS L0_B8F2
                LDA ($02),Y
                EOR ($04),Y
                STA ($06),Y
L0_B8F2:
                LDA ($08),Y
                ORA ($04),Y
                AND ($06),Y
                EOR ($02),Y
                STA ($04),Y
                DEY
                BPL L0_B8E8
                JSR $12E3
                LDA $04
                CLC
                ADC #$08
                STA $04
                LDA $06
                CLC
                ADC #$08
                STA $06
                BCC L0_B916
                INC $05
                INC $07
L0_B916:
                DEX
L0_B917:
                BNE L0_B8E6
                JSR $0FDC
                JSR $82CF
                DEC $26
                BNE L0_B8E1
                LDA #$40
                STA $4A
                LDA $29
                AND #$FB
                STA $29
                LDA #$00
                STA $34
                JMP $827E
                LDX $2A
                LDY $2B
                JSR L0_82D3
                LDX #$00
                STX $26
                STX $27
                BIT $1F
                BMI L0_B948
                LDX $35
L0_B947:
                INX
L0_B948:
                LDA $94D2,X
                STA $116D
L0_B94E:
                LDA $23
                STA $1C
L0_B952:
                LDY #$00
L0_B954:
                LDA #$35
                STA $01
                BIT $43
                BPL L0_B95F
                LDA ($02),Y
                PHA
L0_B95F:
                JSR $119A
                LDX $43
                STX $42
                STX $DE80
                LDX $45
                STX $01
                ORA ($02),Y
                STA ($02),Y
                BIT $43
                BPL L0_B97F
                LDA #$0C
                STA $42
                STA $DE80
                PLA
                STA ($02),Y
L0_B97F:
                INY
                CPY #$08
                BNE L0_B954
                JSR $12E3
                DEC $1C
                BNE L0_B952
                JSR $0FDC
                LDA $90
                BNE L0_B999
                JSR $82CF
                DEC $22
                BNE L0_B94E
L0_B999:
                RTS
                LDA $26
                ORA $27
                BNE L0_B9D2
                INC $26
                LDA #$37
                STA $01
                JSR CBM_CHRIN
                CMP #$9B
                BNE L0_B9D0
                BIT $1F
                BVS L0_B9D0
                JSR CBM_CHRIN
                STA $26
                LDA $1F
                AND #$02
                BEQ L0_B9C8
                LDA $26
                BEQ L0_B9C4
                LDA #$00
                BEQ L0_B9CB
L0_B9C4:
                LDA #$01
                BNE L0_B9CB
L0_B9C8:
                JSR CBM_CHRIN
L0_B9CB:
                STA $27
                JSR CBM_CHRIN
L0_B9D0:
                STA $24
L0_B9D2:
                LDA $26
                BNE L0_B9D8
                DEC $27
L0_B9D8:
                DEC $26
                LDA $24
                RTS
                LDX $4C
                BIT $4B
                BVS L0_B9E5
                LDX $4E
L0_B9E5:
                LDY $4D
                BIT $4B
                BMI L0_B9ED
                LDY $4F
L0_B9ED:
                JSR L0_82D3
                LDA #$00
                STA $26
                STA $27
L0_B9F6:
                LDX $51
L0_B9F8:
                LDY #$07
L0_B9FA:
                JSR $0FD0
                TYA
                PHA
                BIT $4B
                BVC L0_BA06
                EOR #$07
                TAY
L0_BA06:
                LDA ($02),Y
                PHA
                JSR $0FDC
                PLA
                BIT $4B
                BMI L0_BA14
                JSR $9371
L0_BA14:
                JSR L0_85BD
                PLA
                TAY
                DEY
                BPL L0_B9FA
                JSR $12DB
                DEX
                BNE L0_B9F8
                JSR $0FDC
                LDA $90
                BNE L0_BA37
                JSR L0_82C7
                DEC $50
                BNE L0_B9F6
                LDA $24
                EOR #$FF
                JSR L0_85BD
L0_BA37:
                RTS
                LDX $4C
                BIT $4B
                BVS L0_BA40
                LDX $4E
L0_BA40:
                LDY $4D
                JSR L0_82D3
                LDA $4B
                ASL
                PHP
                ASL
                ROL
                PLP
                ROL
                AND #$03
                STA $24
                LDA #$4B
                JSR CBM_CHROUT
                LDA $50
                STA $27
L0_BA5A:
                JSR $0FD0
                LDA #$FE
                LDX #$03
L0_BA61:
                STA $0200,X
                DEX
                BPL L0_BA61
                LDA #$00
                STA $26
                STA $1C
                STA $1E
L0_BA6F:
                LDX #$02
L0_BA71:
                LDA $02
                EOR #$04
                STA $02
                LDY #$03
                LDA #$00
L0_BA7B:
                ORA ($02),Y
                DEY
                BPL L0_BA7B
                TAY
                BEQ L0_BAA1
                LDY $1C,X
                BNE L0_BA95
                STA $1C,X
                CMP #$10
                LDA $26
                ROL
                EOR #$01
                STA $0200,X
                LDA $1C,X
L0_BA95:
                AND #$0F
                CMP #$01
                LDA $26
                ROL
                ADC #$01
                STA $0201,X
L0_BAA1:
                DEX
                DEX
                BPL L0_BA71
                JSR $12E3
                INC $26
                LDA $26
                CMP $51
                BCC L0_BA6F
                JSR $0FDC
                LDX #$03
L0_BAB5:
                TXA
                EOR $24
                TAY
                LDA $0200,Y
                CMP #$FE
                BEQ L0_BACB
                BIT $4B
                BMI L0_BACB
                LDA $51
                ASL
                SEC
                SBC $0200,Y
L0_BACB:
                EOR #$FF
                JSR CBM_CHROUT
                DEX
                BPL L0_BAB5
                JSR L0_82C7
                DEC $27
                BNE L0_BA5A
                RTS
                LDA #$F8
                LDY #$FF
                BIT $4B
                BPL L0_BAE7
                LDA #$08
                LDY #$00
L0_BAE7:
                CLC
                ADC $02
                STA $02
                TYA
                ADC $03
                STA $03
                RTS
                LDA #$04
                STA $42
                STA $DE80               ; ROM1 LO
                LDA $8000               ; ROM1 LO 
                CMP #$5A                ; first byte = Z
                BNE L0_BB0C             ; if not
                LDA $7F                 ; ZS number
                LDY #$0F                ; 16 bits
L0_BB04:
                CMP $8001,Y             ; serach from $8001 to $8010
                BEQ L0_BB11              ; ok
                DEY                     ; Y+1
                BPL L0_BB04              ; loop
L0_BB0C:
                JSR $0FDC               ; error
                SEC
                RTS
L0_BB11:
                TYA
                ASL
                TAY
                LDA $8011,Y             ; read ZS ROM addres
                STA $02
                CLC
                ADC #$78
                STA $73
                LDA $8012,Y
                PHA
                AND #$3F
                ORA #$80
                STA $03
                STA $74
                BCC L0_BB2E
                INC $74
L0_BB2E:                                 ; read from ZS LO or HI
                PLA
                AND #$40                ; $4xxx = HI, $0xxx = LO
                ASL
                ASL
                ROL
                ASL
                ORA #$04
                STA $44
                STA $42
                STA $DE80
                LDY #$77
L0_BB40:                                 ; map 120 chars from ZS
                LDA ($02),Y
                STA $3C00,Y
                DEY
                BPL L0_BB40
                JSR $0FDC
                CLC
                RTS
                LDA #$04
                STA $42
                STA $DE80
                LDY #$0F
L0_BB56:
                LDA $7F
                EOR $8001,Y
                BEQ L0_BB60
                DEY
                BPL L0_BB56
L0_BB60:
                INY
                BCC L0_BB65
                DEY
                DEY
L0_BB65:
                TYA
                AND #$0F
                TAY
                LDA $8001,Y
                BEQ L0_BB60
                STA $7F
                JMP $0FDC
                LDA $44
                STA $42
                STA $DE80
                LDX #$FF
                STX $26
                INX
L0_BB7F:
                LDA ($08),Y
                STA $0200,X
                BEQ L0_BB88
                STX $26
L0_BB88:
                INY
                INX
                CPX $3C01
                BNE L0_BB7F
                LDA #$02                ; map ROM0 HI
                STA $42
                STA $DE80
                RTS
                LDA $1F
                AND #$01
                ASL
                TAY
                LDA L0_94D3,Y
                STA $13D1
                TYA
                BEQ L0_BBA8
                LDA #$FF
L0_BBA8:
                STA $24
                LDX $26
                TXA
                ASL
                ASL
                ASL
                TAY
L0_BBB1:
                LDA $0200,X
                BEQ L0_BBE3
                LDA #$35
                STA $01
                BIT $43
                BPL L0_BBC1
                LDA ($02),Y
                PHA
L0_BBC1:
                LDA $43
                STA $42
                STA $DE80
                LDA $45
                STA $01
                LDA $0200,X
                EOR $24
                ORA ($02),Y
                STA ($02),Y
                BIT $43
                BPL L0_BBE3
                LDA #$0C
                STA $42
                STA $DE80
                PLA
                STA ($02),Y
L0_BBE3:
                TYA
                SEC
                SBC #$08
                TAY
                DEX
                BPL L0_BBB1
                JMP $0FDC
                BCC L0_BC1D
                JSR $0FDC
                LDX $22
                LDY $4F
                JSR L0_82D3
                JSR $0FD0
                LDX $51
L0_BBFF:
                LDY #$07
                LDA #$00
L0_BC03:
                ORA ($02),Y
                DEY
                BPL L0_BC03
                TAY
                BNE L0_BC19
                LDA $02
                SEC
                SBC #$08
                STA $02
                BCS L0_BC16
                DEC $03
L0_BC16:
                DEX
                BNE L0_BBFF
L0_BC19:
                STX $23
                BEQ L0_BC3F
L0_BC1D:
                JSR $0FDC
                LDX $22
                INX
                CPX #$64
                BEQ L0_BC38
                LDY $4D
                JSR L0_82D3
                LDA $43
                STA $44
                LDX $02
                LDY $03
                STX $04
                STY $05
L0_BC38:
                LDX $22
                LDY $4D
                JSR L0_82D3
L0_BC3F:
                JMP $0FE8
                JSR $0FD0
                LDY #$07
L0_BC47:
                LDA ($02),Y
                STA $0200,Y
                DEY
                BPL L0_BC47
                LDA #$00
                TAY
                LDX $22
                CPX #$63
                BEQ L0_BC6F
                LDA #$37
                STA $01
                LDX #$34
                LDA $44
                STA $42
                STA $DE80
                BPL L0_BC69
                LDX #$37
L0_BC69:
                STX $01
                LDY #$05
L0_BC6D:
                LDA ($04),Y
L0_BC6F:
                STA $0208,Y
                DEY
                BPL L0_BC6D
                LDA $02
                CLC
                ADC #$08
                STA $02
                BCC L0_BC80
                INC $03
L0_BC80:
                LDA $04
                CLC
                ADC #$08
                STA $04
L0_BC87:
                BCC L0_BC8B
                INC $05
L0_BC8B:
                JMP $0FE8
                LDA #$7F
                STA $DC0D
                STA $DD0D
                JSR $0FDC
                JSR $AFFC
                LDA #$00
                STA $D015
                STA $0C
                LDA #$93
                JSR CBM_CHROUT
                LDA $DD00
                AND #$FB
                STA $DD00
                LDA $DD02
                ORA #$04
                STA $DD02
                LDA #$00
                STA $06
                STA $07
                LDA #$61
                STA $0B
                LDA #$03
                STA $08
L0_BCC6:
                LDA $08
                ASL
                STA $DE80
                JSR $1524
                BIT $0C
                BMI L0_BCF2
                LDA $08
                LSR
                BCS L0_BCF2
                LDA #$3D
                JSR CBM_CHROUT
                LDA $07
                JSR $1640
                LDA $06
                JSR $1640
                LDA #$0D
                JSR CBM_CHROUT
                LDA #$00
                STA $06
                STA $07
L0_BCF2:
                JSR $154F
                INC $D020
                DEC $08
                BPL L0_BCC6
                LDA #$62
                STA $0B
                JSR $1586
                LDA #$72
                STA $0B
                LDA #$04
                STA $08
                ASL
                STA $DE80
                JSR $15D8
                LDA #$05
                STA $08
                ASL
                STA $DE80
                JSR $15D8
                LDA #$80
                STA $0C
                JMP $14B8
                LDA #$80
                STA $03
                LDA #$20
                STA $05
                LDY #$00
                STY $02
                STY $04
                LDX #$40
L0_BD34:
                LDA ($02),Y
                STA ($04),Y
                SEC
                SBC $02
                CLC
                ADC $06
                STA $06
                BCC L0_BD44
                INC $07
L0_BD44:
                INY
                BNE L0_BD34
L0_BD47:
                INC $03
                INC $05
                DEX
                BNE L0_BD34
                RTS
                LDA #$80
                STA $03
                LDA #$20
                STA $05
                LDY #$00
                STY $02
                STY $04
                LDX #$40
L0_BD5F:
                LDA ($02),Y
                CMP ($04),Y
                BEQ L0_BD7B
                STA $0A
                LDA $DD00
                ORA #$04
                STA $DD00
                AND #$FB
                STA $DD00
                LDA ($04),Y
                STA $09
                JSR $160B
L0_BD7B:
                INY
                BNE L0_BD5F
                INC $03
                INC $05
                DEX
                BNE L0_BD5F
                RTS
                LDA #$80
                STA $03
                LDY #$00
                STY $02
                LDA #$40
                STA $0D
L0_BD92:
                LDX #$0A
L0_BD94:
                STX $DE80
                LDA ($02),Y
                STA $2000,X
                DEX
                DEX
                BPL L0_BD94
                LDX #$0A
L0_BDA2:
                STX $DE80
                LDA ($02),Y
                CMP $2000,X
                BEQ L0_BDC7
                STA $0A
                LDA $DD00
                ORA #$04
                STA $DD00
                AND #$FB
                STA $DD00
                TXA
                LSR
                STA $08
                LDA $2000,X
                STA $09
                JSR $160B
L0_BDC7:
                DEX
                DEX
                BPL L0_BDA2
                INC $D020
                INY
                BNE L0_BD92
                INC $03
                DEC $0D
                BNE L0_BD92
                RTS
                LDA #$80
                STA $03
                LDY #$00
                STY $02
                LDX #$40
L0_BDE2:
                TYA
                EOR $D012
                STA $09
                STA ($02),Y
                LDA ($02),Y
                CMP $09
                BEQ L0_BE02
                STA $0A
                LDA $DD00
                ORA #$04
                STA $DD00
                AND #$FB
                STA $DD00
                JSR $160B
L0_BE02:
                INY
                BNE L0_BDE2
                INC $03
                DEX
                BNE L0_BDE2
                RTS
                LDA #$0D
                JSR CBM_CHROUT
                LDA $0B
                JSR CBM_CHROUT
                LDA #$20
                JSR CBM_CHROUT
                LDA $08
                ORA #$30
                JSR CBM_CHROUT
                LDA #$20
                JSR CBM_CHROUT
                LDA $03
                JSR $1640
                TYA
                JSR $1640
                LDA #$20
                JSR CBM_CHROUT
                LDA $09
                JSR $1640
                LDA #$20
                JSR CBM_CHROUT
                LDA $0A
                PHA
                LSR
                LSR
                LSR
                LSR
                JSR $164B
                !by $68
                !by $29
                !by $0F
                !by $09
                !by $30
                !by $C9
                !by $3A
                !by $90
                !by $02
                !by $69
                !by $26
                !by $4C
                !by $D2
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $FF
                !by $FF
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by .COLOR_TEXT_TEXT
                !by .COLOR_TEXT_BACKGROUND
                !by .COLOR_TEXT_MENU
                !by .COLOR_GRAPHIC_TEXT+.COLOR_GRAPHIC_BACKGROUND
                !by $00
                !by $00
                !by $01,$00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $04
                !by $01
                !by $00
                !by $00
                !by $41
                !by $65
                !by $0A
                !by $00
                !by $00
                !by $00
                !by $FF
                !by $1B
                !by $33
                !by $18
                !by $FF
                !by $1B
                !by $33
                !by $17
                !by $FF
                !by $1B
                !by $33
                !by $16
                !by $FF
                !by $1B
                !by $33
                !by $15
                !by $FF
                !by $1B
                !by $33
                !by $01
                !by $FF
                !by $1B
                !by $2A
                !by $04
                !by $FF
                !by $1B
                !by $5A
                !by $FF
                !by $1B
                !by $4B
                !by $FF
                !by $1B
                !by $2A
                !by $03
                !by $FF
                !by $1B
                !by $40
                !by $FF
                !by $1B
                !by $43
                !by $FF
}

* = $4000

!pseudopc $8000 {
                LDX #$FE
                TXS
    JSR $AEEC
    JSR $8082
    JSR $8674
    JSR $8BA5
    JMP $8006
                !by $64
                !by $44
                JMP ($6372)
                BVS $8083
                !by $6D
                !by $74
                !by $67
                !by $61
                !by $73
                !by $65
                JSR $C17F
                LDX $A7
                ADC #$5F
                LDY #$A1
                !by $A2
                !by $A3
                !by $6F
                !by $78
                !by $75
                !by $30
                !by $B1
                !by $B2
                !by $2E
                !by $B5
                !by $B6
                !by $B7
                !by $50
                !by $BA
                !by $B8
                !by $C3
                !by $66
                !by $4D
                !by $5E
                !by $77
                !by $AF
                !by $A8
                !by $AA
                !by $6B
                !by $02
                !by $96
                !by $BD
                !by $95
                LSR $82,X
                ROL $82
                EOR $AA82
                !by $82
                !by $EB
                LDX $81A4
                LDY $81
                LDY $81
                LDY $81
                !by $C3
                !by $94
                !by $C3
                !by $94
                !by $C3
                !by $94
                !by $7F
                !by $8A
                !by $C0
                !by $8A
                !by $E1
                !by $8A
                !by $85
                !by $82
                !by $3D
                !by $84
                !by $CC
                !by $84
                !by $D5
                !by $83
                !by $2E
                !by $84
                !by $47
                !by $86
                CPX $F283
                !by $83
                NOP
                STA ($E0),Y
                STA ($EC),Y
                STA ($4A,X)
                !by $83
                ADC $81
                ORA ($84),Y
                !by $1A
                STY $B7
                TXA
                JSR CBM_GETIN
                BEQ L2_80A6
                LDX $28
                CPX #$08
                BNE L2_8094
                CMP #$A0
                BCS L2_8094
                JMP L0_8119
L2_8094:
                LDX #$2D
L2_8096:
                CMP $8012,X
                BEQ L2_80A7
                DEX
                BPL L2_8096
                CMP #$31
                BCC L2_80A6
                CMP #$39
                BCC L2_80B9
L2_80A6:
                RTS
L2_80A7:
                TXA
                CMP #$0D
                BCC L2_80BC
                TAY
                ASL
                TAX
                LDA $8027,X
                PHA
                LDA $8026,X
                PHA
                TYA
                RTS
L2_80B9:
                JMP $81FE
L2_80BC:
                PHA
                CMP #$08
                BNE L2_80CE
                LDA #$01
                STA $7F
                JSR $AEE2
                BCC L2_80CE
                PLA
                LDA $28
                PHA
L2_80CE:
                LDA #$00
                STA $81
                STA $4A
                JSR $0EE7
                LDA $29
                AND #$9F
                STA $29
                PLA
                STA $28
                TAX
                !by $BD
                !by $0B
                !by $81
                !by $85
                !by $48
                !by $BC
                !by $FD
                !by $80
                !by $24
                !by $29
                !by $10
                !by $04
                !by $A9
                !by $05
                !by $A0
                !by $02
                !by $8C
                !by $15
                !by $D0
                !by $20
                !by $3F
                !by $AF
                !by $20
                !by $9A
                !by $86
                !by $4C
                !by $DE
                !by $94
                !by $02
                !by $02
                !by $02
                !by $02
                !by $02
                !by $02
                !by $02
                !by $02
                !by $02
                !by $02
                !by $03
                !by $03
                !by $02
                !by $02
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $00
                !by $02
                !by $02
                !by $02
                !by $02
                !by $02
                STA $61
                LDY $34
                BNE L2_8139
                CMP #$21
                BCC L2_8151
                JSR $869A
                JSR L0_8AE2
                JSR $0EE7
                LDX #$02
                STX $49
L2_8130:
                LDA $0B,X
                STA $0F,X
                DEX
                BPL L2_8130
                LDY #$00
L2_8139:
                CPY #$40
                BCS L2_8151
                LDA $61
                CMP #$20
                BCC L2_8152
                STA $02C0,Y
                INC $34
                LDA $29
                ORA #$04
                STA $29
                JSR $ADB1
L2_8151:
                RTS
L2_8152:
                CMP #$0F
                BEQ L2_815C
                JSR $A8B8
                JMP L0_817F
L2_815C:
                CLC
                JSR $134D
                JSR $AEAA
                JMP L0_817F
                LDA $34
                BEQ L2_8173
                DEC $34
                JSR L0_817F
                LDA $34
                BEQ L2_8174
L2_8173:
                RTS
L2_8174:
                LDA #$00
                STA $34
                LDA $29
                AND #$FB
                STA $29
                RTS
L2_817F:
                JSR $0F03
                LDA $34
                BEQ L2_81A4
                LDX #$02
L2_8188:
                LDA $13,X
                STA $0F,X
                DEX
                BPL L2_8188
                LDY #$00
L2_8191:
                LDA $02C0,Y
                STA $61
                TYA
                PHA
                JSR $ADB1
                PLA
                BCS L2_81A4
                TAY
                INY
                CPY $34
                BCC L2_8191
L2_81A4:
                RTS
                AND #$03
                STA $49
                LDA $34
                BEQ L2_81B0
                JMP L0_817F
L2_81B0:
                LDA $4A
                AND #$30
                BEQ L2_81B9
                JMP $91F9
L2_81B9:
                JSR $0EE7
L2_81BC:
                LDY $49
                TYA
                LSR
                TAX
                LDA $81E5,Y
                CMP $2A,X
                BEQ L2_81DF
                LDA $2A,X
                CLC
                ADC L0_81E9,Y
                STA $2A,X
                JSR $0F03
                LDA $CB
                CMP #$40
                BNE L2_81BC
                LDA $3F
                AND #$05
                BNE L2_81BC
L2_81DF:
                JSR L0_89B3
                JMP $B285
                EOR $2800
                BRK
                ORA ($FF,X)
                ORA ($FF,X)
                JSR $0EE7
                LDA #$50
                STA $40
                LDA #$2E
                STA $41
                JSR L0_8AEC
                JMP $AEFC
                PHA
                JSR $0EE7
                PLA
                AND #$0F
                TAX
                DEX
                LDA $8217,X
                STA $2A
                LDA L0_821F,X
                STA $2B
                JSR $0F03
                JMP L0_89B3
                BRK
                BRK
                ORA $3219,Y
                !by $32
                !by $4B
                !by $4B
                BRK
                PLP
                BRK
                PLP
                BRK
                PLP
                BRK
                PLP
                JSR $0EE7
                LDX $2A
                LDY $2B
                CPX $2C
                BNE L2_823C
                CPY $2D
                BNE L2_823C
                LDX $2E
                LDY $2F
                BCS L2_8244
L2_823C:
                STX $2E
                STY $2F
                LDX $2C
                LDY $2D
L2_8244:
                STX $2A
                STY $2B
                JSR $0F03
                JMP L0_89B3
                LDX $2A
                LDY $2B
                STX $2C
                STY $2D
                RTS
                BIT $4A
                BMI L2_8273
                JSR $0EE7
                LDX #$00
                LDY #$60
                STX $08
                STY $09
                LDX #$17
                LDY #$28
                LDA #$00
                SEC
                JSR $B36C
                JMP $827E
L2_8273:
                LDA #$60
                JSR L0_92A9
                JSR $0EF0
                JMP $0F03
                LDA $29
                AND #$08
                BEQ L2_82AA
                BNE L2_828C
                LDA $29
                EOR #$08
                STA $29
L2_828C:
                LDA #$C0
                STA $02
                LDA #$5F
                STA $03
                LDY #$40
                LDX #$1C
L2_8298:
                LDA ($02),Y
                EOR #$80
                STA ($02),Y
                TYA
                CLC
                ADC #$08
                TAY
                BCC L2_8298
                INC $03
                DEX
                BPL L2_8298
L2_82AA:
                RTS
                LDA #$00
                STA $02
                LDA #$7C
                STA $03
                LDY #$C0
                LDX #$1C
L2_82B7:
                DEY
                LDA ($02),Y
                EOR #$FF
                STA ($02),Y
                TYA
                BNE L2_82B7
                DEC $03
                DEX
                BPL L2_82B7
                RTS
                BIT $4B
                BVS L2_82CF
                DEC $46
                BVC L2_82D7
L2_82CF:
                INC $46
                BPL L2_82D7
                STX $46
                STY $47
L2_82D7:
                LDA $46
                LDX #$00
L2_82DB:
                CMP #$19
                BCC L2_82E4
                SBC #$19
                INX
                BCS L2_82DB
L2_82E4:
                STA $1C
                LDA L0_830C,X
                STA $45
                LDA L0_8310,X
                STA $43
                TXA
                PHA
                LDA $47
                STA $1D
                !by $A2
                !by $1C
                !by $A0
                !by $04
                !by $20
                !by $18
                !by $83
                !by $A2
                !by $02
                !by $20
                !by $41
                !by $83
                !by $68
                !by $AA
                !by $A5
                !by $03
                !by $1D
                !by $14
                !by $83
                !by $85
                !by $03
                !by $60
                !by $34
                !by $34
                !by $37
                !by $37
                !by $0C
                !by $0C
                DEY
                TXA
                !by $80
                CPY #$80
                !by $80
                LDA #$00
                STA $03
                LDA $00,X
                ASL
                ASL
                ADC $00,X
L2_8322:
                ASL
                ROL $03
                DEY
                BNE L2_8322
                ADC $01,X
                BCC L2_832E
                INC $03
L2_832E:
                STA $02
                RTS
                LDA #$01
                PHA
                LDA #$40
                CLC
                ADC $00,X
                STA $00,X
                PLA
                ADC $01,X
                STA $01,X
                RTS
                LDY #$03
L2_8343:
                ASL $00,X
                ROL $01,X
                DEY
                BNE L2_8343
                RTS
                JSR $0EE7
                LDA $2A
                SEC
                SBC #$0C
                BCS L2_8357
                LDA #$00
L2_8357:
                CMP #$36
                BCC L2_835D
                LDA #$36
L2_835D:
                TAX
                LDA #$00
                JSR L0_837F
                JMP $827E
                JSR $9EDE
                LDX #$18
                LDY #$60
                STX $08
                STY $09
                LDX #$19
                LDY #$14
                LDA #$FF
                SEC
                JSR $B36C
                LDA #$80
                LDX #$00
                STA $1F
                LDY #$00
                JSR L0_82D3
                LDY #$02
                LDA #$17
                LDX #$00
                BIT $1F
                BPL L2_8396
                LDY #$04
                LDA #$19
                LDX #$18
L2_8396:
                STY $25
                STA $27
                STX $04
                LDY #$60
                STY $05
L2_83A0:
                LDA $04
                STA $06
                LDA $05
                STA $07
                LDA #$28
                BIT $1F
                BPL L2_83B0
                LDA #$14
L2_83B0:
                STA $26
                JSR $1038
                JSR $82CF
                LDA $25
                EOR #$06
                CLC
                ADC $04
                STA $04
                AND #$07
                BNE L2_83A0
                LDA $04
                SEC
                SBC #$08
                STA $04
                LDX #$04
                JSR $8331
                DEC $27
                BNE L2_83A0
                RTS
                JSR $0EE7
                JSR $8B0E
                BCS L2_83EA
                LDA #$00
                STA $70
                JSR $0E1B
                BCS L2_83EA
                JSR $0E24
L2_83EA:
                JMP $AEEC
                JSR $0EE7
                JMP $0DA8
                JSR $0EE7
                JMP $0DB4
                LDA #$00
                STA $4A
                STA $34
                LDA $29
                AND #$FB
                STA $29
                LDA #$4B
                CMP $2A
                BCS L2_840D
                STA $2A
L2_840D:
                LDA #$C0
                JMP $0F05
                LDA $1704
                CLC
                ADC #$10
                JMP $8429
                LDA $1704
                TAX
                AND #$F0
                STA $1C
                INX
                TXA
                AND #$0F
                ORA $1C
                STA $1704
                JMP $B3B4
                LDX #$A0
L2_8431:
                DEX
                LDA $6000,X
                STA $0D00,X
                TXA
                BNE L2_8431
                JMP L0_9531
                JSR $0EE7
                LDA #$00
                STA $71
                JSR L0_8467
                BCS L2_8461
                PHA
                JSR CBM_CLRCHN
                JSR $AF0D
                JSR L0_8AEC
                PLA
                BCS L2_8461
                STA $1F
                LDX #$08
                JSR CBM_CHKIN
                JSR $1134
L2_8461:
                JSR L0_8658
                JMP $AEFC
                PHA
                JSR $0DE0
                PLA
                JSR $0E05
                BCS L2_84CC
                LDY #$00
                JSR $B209
                BCS L2_84CC
                JSR CBM_CHRIN
                LDY $90
                BNE L2_84A9
                LDY #$00
                CMP #$47
                BEQ L2_84AE
                INY
                CMP #$42
                BEQ L2_84AE
                TAX
                JSR CBM_CHRIN
                CPX #$50
                BNE L2_84A6
                STA $22
                JSR CBM_CHRIN
                STA $23
                JSR $B156
L2_849C:
                JSR CBM_CHRIN
                TAX
                BNE L2_849C
                LDY #$02
                BNE L2_84BC
L2_84A6:
                STX $71
                TXA
L2_84A9:
                SEC
                BNE L2_84CC
                LDY #$41
L2_84AE:
                TYA
                AND #$03
                TAX
                LDA $8543,X
                STA $22
                LDA $8545,X
                STA $23
L2_84BC:
                LDA $22
                ASL
                STA $41
                LDA $23
                ASL
                STA $40
                TYA
                ORA $1F
                STA $1F
                CLC
L2_84CC:
                RTS
                JSR $0EE7
                LDA #$00
                STA $71
                JSR $8552
                BCS L2_8540
                PHA
                JSR $0DE0
                LDA #$03
                JSR $0DF7
                PLA
                BCS L2_8540
                STA $1F
                LDY #$01
                JSR $B209
                BCS L2_853D
                LDA $1F
                CMP #$01
                BNE L2_8508
                LDX $0430
                CPX #$30
                BNE L2_8508
                ORA #$40
                STA $1F
                LDA #$00
                JSR CBM_CHROUT
                LDA #$20
                BNE L2_8522
L2_8508:
                TAX
                LDA $8547,X
                JSR CBM_CHROUT
                CPX #$02
                BCC L2_8525
                LDA $50
                JSR CBM_CHROUT
                LDA $51
                JSR CBM_CHROUT
                JSR $1238
                LDA #$00
L2_8522:
                JSR CBM_CHROUT
L2_8525:
                JSR $11DD
                BIT $1F
                BVS L2_853D
                LDX #$03
                LSR $1F
                BCC L2_8534
                LDX #$07
L2_8534:
                LDA $854A,X
                JSR CBM_CHROUT
                DEX
                BPL L2_8534
L2_853D:
                JSR L0_8658
L2_8540:
                JMP $AEEC
                !by $32
                ORA $2850,Y
                !by $47
                !by $42
                BVC $850A
                JSR L0_9B00
                BRK
                BRK
                CPY #$9B
                JSR L0_94D6
                LDY #$2F
L2_8557:
                LDA $B8E7,Y
                STA $7DA0,Y
                LDA L0_B917,Y
                STA $7EE0,Y
                DEY
                BPL L2_8557
                JSR $B285
L2_8569:
                JSR L0_8674
                JSR CBM_GETIN
                CMP #$B3
                BEQ L2_85BB
                LDA $3F
                AND #$05
                BEQ L2_8569
                BIT $29
                BPL L2_85BB
                LDX #$04
                LDA $0B
L2_8581:
                LSR $0C
                ROR
                DEX
                BNE L2_8581
                SEC
                SBC #$0E
                BCC L2_85BB
                CMP #$02
                BEQ L2_85B5
                BCS L2_85BB
                PHA
                TAY
                LDA $8545,Y
                STA $51
                ASL
                STA $40
                LDA $8543,Y
                STA $50
                ASL
                STA $41
                JSR L0_8AEC
                LDA $2A
                STA $4C
                LDA $2B
                STA $4D
                LDA #$C0
                STA $4B
                PLA
                RTS
L2_85B5:
                PHA
                JSR $8B0E
                PLA
                RTS
L2_85BB:
                SEC
                RTS
                CMP $24
                BNE L2_85C4
                JMP L0_8641
L2_85C4:
                PHA
                LDA #$02
                BIT $1F
                BEQ L2_85F9
                LDA $27
                BEQ L2_85E2
L2_85CF:
                LDA #$9B
                JSR CBM_CHROUT
                LDA #$00
                JSR CBM_CHROUT
                LDA $24
                JSR CBM_CHROUT
                DEC $27
                BNE L2_85CF
L2_85E2:
                LDA $26
                BEQ L2_863E
                CMP #$04
                BCS L2_85F0
                LDA $24
                CMP #$9B
                BNE L2_862C
L2_85F0:
                LDA #$9B
                JSR CBM_CHROUT
                LDA $26
                BNE L2_8621
L2_85F9:
                BVC L2_8603
                LDA $26
                ORA $27
                BEQ L2_863E
                BNE L2_862C
L2_8603:
                LDA $27
                BNE L2_8615
                LDA $26
                BEQ L2_863E
                CMP #$05
                BCS L2_8615
                LDA $24
                CMP #$9B
                BNE L2_862C
L2_8615:
                LDA #$9B
                JSR CBM_CHROUT
                LDA $26
                JSR CBM_CHROUT
                LDA $27
L2_8621:
                JSR CBM_CHROUT
                LDA #$01
                STA $26
                LDA #$00
                STA $27
L2_862C:
                LDA $24
                JSR CBM_CHROUT
                DEC $26
                BNE L2_862C
                LDA $27
                BEQ L2_863E
                DEC $27
                JMP L0_862C
L2_863E:
                PLA
                STA $24
                INC $26
                BNE L2_8647
                INC $27
L2_8647:
                RTS
                JSR $0DE0
                LDA #$02
                JSR $0DF7
                BCS L2_8655
                JSR L0_865D
L2_8655:
                JMP $AEFF
                JSR $B222
                LDA #$00
                JSR $0E10
                BCS L2_866B
                LDA $71
                BEQ L2_8673
                LDA #$0B
                JSR $0DE9
L2_866B:
                JSR $AFFC
L2_866E:
                JSR $0E2D
                BEQ L2_866E
L2_8673:
                RTS
                LDA $36
                AND #$C0
                BEQ L2_8699
                JSR $869A
                BIT $36
                BVC L2_8699
                SEI
                LDA $36
                AND #$BF
                STA $36
                CLI
                BIT $29
                BMI L2_8699
                JSR L0_89B3
                LDA #$04
                BIT $29
                BEQ L2_8699
                JSR $8D41
L2_8699:
                RTS
                SEI
                LDX $48
                LDA #$EF
                CMP $19
                BCS L2_86A5
                STA $19
L2_86A5:
                LDA $8784,X
                CMP $19
                BCC L2_86AE
                STA $19
L2_86AE:
                LDY #$00
                LDA L0_878E,X
                CMP $19
                BCS L2_86CC
                LDY #$80
                LDA $19
                CMP #$E0
                BCS L2_86CC
                LDA #$E0
                BIT $29
                BPL L2_86CA
L2_86C5:
                LDY #$00
                LDA L0_878E,X
L2_86CA:
                STA $19
L2_86CC:
                TYA
                EOR $29
                BPL L2_86F9
                STY $1C
                LDA $29
                AND #$7F
                ORA $1C
                STA $29
                BPL L2_86EC
                LDA $3F
                AND #$05
                BNE L2_86C5
                LDA #$02
                STA $D015
                LDA #$03
                BNE L2_86F6
L2_86EC:
                LDX $28
                LDA $80FD,X
                STA $D015
                LDA $48
L2_86F6:
                JSR $AF3F
L2_86F9:
                LDX $48
                BIT $29
                BPL L2_8701
                LDX #$00
L2_8701:
                LDA $18
                BNE L2_8710
                LDA $877F,X
                CMP $17
                BCC L2_871D
                STA $17
                BCS L2_871D
L2_8710:
                LDA #$01
                STA $18
                LDA L0_8789,X
                CMP $17
                BCS L2_871D
                STA $17
L2_871D:
                JSR L0_872B
                JSR $8756
                LDA $36
                AND #$7F
                STA $36
                CLI
                RTS
                LDA $19
                STA $D001
                STA $D003
                SEC
                SBC #$15
                CLC
                ADC $41
                STA $D005
                LDA $17
                STA $D000
                STA $D002
                SEC
                SBC #$18
                CLC
                ADC $40
                STA $D004
                LDA $18
                ASL
                ORA $18
                STA $D010
                RTS
                LDX $48
                BIT $29
                BPL L2_8764
                LDX #$00
                BIT $38
                BMI L2_8764
                LDX #$03
L2_8764:
                LDA $19
                SEC
                SBC $8784,X
                STA $0D
                LDA #$00
                STA $0E
                LDA $17
                SEC
                SBC $877F,X
                STA $0B
                LDA $18
                !by $E9
                !by $00
                !by $85
                !by $0C
                !by $60
                !by $0E
                !by $26
                !by $18
                !by $C6
                !by $30
                !by $28
                !by $28
                !by $32
                PLP
                !by $32
                EOR $40C5
                EOR $DFD0
                !by $EF
                CMP $EF,X
                !by $FA
L2_8793:
                LDA $36
                AND #$C0
                BEQ L2_87C4
                JSR $87C5
                BIT $36
                BVC L2_87C4
                SEI
                LDA $36
                AND #$BF
                STA $36
                CLI
                BIT $29
                BMI L2_87C4
                JSR L0_89CA
                LDA #$04
                BIT $29
                BEQ L2_87C4
                LDX #$03
L2_87B7:
                LDA $13,X
                STA $0F,X
                DEX
                BPL L2_87B7
                JSR $9F11
                JSR $8DDD
L2_87C4:
                RTS
                SEI
                LDX $48
                LDA $18
                BNE L2_87D7
                LDA $877F,X
                CMP $17
                BCC L2_87E7
                STA $17
                BCS L2_87E7
L2_87D7:
                LDA #$01
                STA $18
                LDA #$4D
                CMP $17
                BCS L2_87E3
                STA $17
L2_87E3:
                LDY #$80
                BNE L2_8813
L2_87E7:
                LDY #$00
                LDA L0_8789,X
                CPX #$04
                BNE L2_87F2
                SBC $40
L2_87F2:
                CMP $17
                BCS L2_8813
                LDY #$80
                LDA $17
                CMP #$C6
                BCS L2_8813
                LDA #$C6
                BIT $29
                BPL L2_8811
L2_8804:
                LDY #$00
                STY $18
                LDA L0_8789,X
                CPX #$04
                BNE L2_8811
                SBC $40
L2_8811:
                STA $17
L2_8813:
                TYA
                EOR $29
                BPL L2_8841
                STY $1C
                LDA $29
                AND #$7F
                ORA $1C
                STA $29
                BPL L2_8831
                BIT $38
                BMI L2_8804
                LDA #$02
                STA $D015
                LDA #$03
                BNE L2_883E
L2_8831:
                LDX #$02
                LDA $48
                CMP #$01
                BEQ L2_883B
                LDX #$06
L2_883B:
                STX $D015
L2_883E:
                JSR $AF3F
L2_8841:
                LDX $48
                BIT $29
                BPL L2_8849
                LDX #$03
L2_8849:
                LDA $8784,X
                CMP $19
                BCC L2_8852
                STA $19
L2_8852:
                LDA L0_878E,X
                CPX #$04
                BNE L2_885B
                SBC $41
L2_885B:
                CMP $19
                BCS L2_8861
                STA $19
L2_8861:
                JSR L0_872B
                JSR $8756
                LDA $36
                AND #$7F
                STA $36
                CLI
                RTS
                LDA #$FF
                STA $DC00
                LDA $36
                AND #$18
                BNE L2_8897
                LDX $D419
                CPX #$FF
                BEQ L2_88D0
                LDX #$00
L2_8883:
                NOP
                NOP
                INX
                BNE L2_8883
                LDA #$08
                LDX $D41A
                CPX #$FF
                BNE L2_8893
                LDA #$10
L2_8893:
                ORA $36
                STA $36
L2_8897:
                AND #$08
                BEQ L2_88DD
                LDX #$01
L2_889D:
                LDA $D419,X
                TAY
                SEC
                SBC $3B,X
                AND #$7F
                CMP #$40
                BCS L2_88AF
                LSR
                BEQ L2_88BB
                BNE L2_88B6
L2_88AF:
                EOR #$7F
                BEQ L2_88BB
                LSR
                EOR #$FF
L2_88B6:
                PHA
                TYA
                STA $3B,X
                PLA
L2_88BB:
                STA $39,X
                DEX
                BPL L2_889D
                LDA #$00
                SEC
                SBC $3A
                STA $3A
                LDA $DC01
                EOR #$FF
                LSR
                JMP $8916
L2_88D0:
                ASL $3F
                ASL $3F
                LDA #$00
                STA $3A
                STA $39
                JMP $8923
L2_88DD:
                LDA #$00
                STA $DC02
                LDA #$10
                STA $DC03
                LDX #$00
                LDY #$08
L2_88EB:
                LDA #$00
                JSR L0_8975
                ASL
                ASL
                ASL
                ASL
                STA $39,X
                LDA #$10
                JSR L0_8975
                AND #$0F
                ORA $39,X
                CLC
                ADC #$01
                STA $39,X
                INX
                CPX #$02
                BNE L2_88EB
                LDA #$00
                STA $DC03
                LDX $D419
                CPX #$FF
                BEQ L2_8916
                CLC
L2_8916:
                ROL $3F
                CLC
                LDA $DC01
                AND #$10
                BNE L2_8921
                SEC
L2_8921:
                ROL $3F
                LDA $DC00
                EOR #$FF
                LDX #$FF
                STX $DC02
                PHA
                CLC
                AND #$10
                BEQ L2_8934
                SEC
L2_8934:
                ROL $3F
                PLA
                AND #$0F
                BEQ L2_8965
                LDX $3E
                BNE L2_8962
                LSR
                BCC L2_8944
                DEC $3A
L2_8944:
                LSR
                BCC L2_8949
                INC $3A
L2_8949:
                LSR
                BCC L2_894E
                DEC $39
L2_894E:
                LSR
                BCC L2_8953
                INC $39
L2_8953:
                LDX $3D
                BEQ L2_8974
                LDA $36
                LSR
                BCC L2_895D
                DEX
L2_895D:
                STX $3D
                STX $3E
                RTS
L2_8962:
                DEC $3E
                RTS
L2_8965:
                LDX #$01
                LDA $36
                LSR
                BCC L2_896E
                LDX #$0A
L2_896E:
                STX $3D
                LDA #$00
                STA $3E
L2_8974:
                RTS
                STA $DC01
L2_8978:
                NOP
                NOP
                NOP
                DEY
                BNE L2_8978
                LDY #$05
                LDA $DC01
                RTS
                TYA
                PHA
                LDY #$00
                TXA
                BPL L2_898C
                DEY
L2_898C:
                CLC
                ADC $17
                TAX
                TYA
                ADC $18
                BPL L2_8998
                LDA #$00
                TAX
L2_8998:
                STX $17
                AND #$01
                STA $18
                PLA
                CLC
                BMI L2_89AA
                ADC $19
                BCC L2_89B0
                LDA #$FF
                BNE L2_89B0
L2_89AA:
                ADC $19
                BCS L2_89B0
                LDA #$00
L2_89B0:
                STA $19
                RTS
                BIT $29
                BVS L2_89C9
                LDX #$00
                LDY $2B
                LDA #$60
                JSR $89D9
                LDX #$02
                LDY $2A
                LDA #$60
                JSR $89D9
L2_89C9:
                RTS
                LDA #$E0
                LDY #$00
                LDX #$00
                JSR $89D9
                LDA #$E0
                LDY #$00
                LDX #$02
                STA $1F
                LDA $8A5D,X
                STA $06
                LDA L0_8A5E,X
                STA $07
                TYA
                JSR $8A6B
                ASL $1F
                BCC L2_89F6
                LDY #$02
L2_89EF:
                ASL $1A
                ROL $1B
                DEY
                BNE L2_89EF
L2_89F6:
                ASL $1F
                BCC L2_8A16
                LDA $1A
                SEC
                SBC $30,X
                STA $1A
                LDA $1B
                SBC $31,X
                STA $1B
                BCS L2_8A16
                LDA #$00
                SEC
                SBC $1A
                STA $1A
                LDA #$00
                SBC $1B
                STA $1B
L2_8A16:
                LDY #$1F
                ASL $1F
                BCC L2_8A4A
                LDA $29
                AND #$10
                BEQ L2_8A4A
                TXA
                LSR
                LSR
                LDA $1705
                ROL
                TAX
                LDA $8A61,X
                PHA
                TAY
                LDX $1A
                JSR $B336
                STY $1A
                LDX $1B
                PLA
                TAY
                JSR $B336
                TXA
                CLC
                ADC $1A
                STA $1A
                TYA
                ADC #$00
                STA $1B
                LDY #$6D
L2_8A4A:
                STY $0200
                JSR $B2C0
                LDX #$00
                LDY #$02
                STX $02
                STY $03
                LDA #$04
                JMP $B242
                SBC ($7D,X)
                JSR $517F
                !by $5A
                EOR ($5A),Y
                EOR ($5A),Y
                EOR ($53),Y
                EOR ($5A),Y
                ASL
                ASL
                ROL $1C
                ASL
                ROL $1C
                CLC
                ADC $0B,X
                STA $1A
                LDA $1C
                AND #$03
                ADC $0C,X
                STA $1B
                RTS
                LDX #$00
                LDA $2B
                JSR $8A6B
                LDX $1A
                LDY $1B
                STX $30
                STY $31
                LDX #$02
                LDA $2A
                JSR $8A6B
                LDX $1A
                LDY $1B
                STX $32
                STY $33
                JMP L0_89B3
                LDX #$02
L2_8AA3:
                LDA #$00
                STA $31,X
                LDA $0B,X
                ASL
                ROL $31,X
                ASL
                ROL $31,X
                STA $30,X
                DEX
                DEX
                BPL L2_8AA3
                JMP L0_89CA
                LDA $29
                EOR #$10
                STA $29
                JMP L0_89B3
                LDY $48
                BIT $29
                BPL L2_8AC9
                LDY #$00
L2_8AC9:
                SEI
                LDA $13
                CLC
                ADC $877F,Y
                STA $17
                LDA $14
                ADC #$00
                STA $18
                LDA $15
                ADC $8784,Y
                STA $19
                JMP L0_867A
                LDX #$03
L2_8AE4:
                LDA $0B,X
                STA $13,X
                DEX
                BPL L2_8AE4
                RTS
                JSR $8366
                LDA #$04
                STA $48
                JSR $AF3F
                LDA #$06
                STA $D015
                SEI
                LDA $2B
                ASL
                ADC #$30
                STA $17
                LDA $2A
                ASL
                ADC #$32
                STA $19
                LDA #$90
                BNE L2_8B1F
                JSR $8366
                LDA #$01
                STA $48
                JSR $AF3F
                LDA #$02
                STA $D015
                LDA #$98
L2_8B1F:
                STA $38
                SEI
                LDA #$00
                STA $18
                LDA $36
                ORA #$C0
                STA $36
                CLI
                JSR $B285
L2_8B30:
                JSR $8793
                JSR CBM_GETIN
                CMP #$B3
                BEQ L2_8B95
                CMP #$30
                BEQ L2_8B60
                LDA $3F
                AND #$05
                BEQ L2_8B30
                JSR $B285
                LDA #$08
                BIT $38
                BEQ L2_8B8A
                LDA $29
                EOR #$04
                STA $29
                AND #$04
                BEQ L2_8B66
                JSR $9F0D
                JSR L0_8AE2
                JMP L0_8B30
L2_8B60:
                JSR L0_8AA1
                JMP L0_8B30
L2_8B66:
                JSR $9282
                LDX #$02
                LDY #$00
L2_8B6D:
                LDA $0B,X
                LSR
                STA $004C,Y
                LDA $0F,X
                LSR
                STA $004E,Y
                SEC
                SBC $004C,Y
                CLC
                ADC #$01
                STA $0050,Y
                INY
                DEX
                DEX
                BPL L2_8B6D
                BMI L2_8B94
L2_8B8A:
                LDA $0B
                LSR
                STA $2B
                LDA $0D
                LSR
                STA $2A
L2_8B94:
                CLC
L2_8B95:
                LDA $29
                AND #$FB
                STA $29
                LDA #$80
                STA $38
                PHP
                JSR $B285
                PLP
                RTS
                LDA $3F
                AND #$05
                BEQ L2_8BEF
                JSR $869A
                LDA $29
                BMI L2_8BEC
                AND #$02
                BNE L2_8BDF
                LDA #$00
                LDX $28
                CPX #$02
                BCS L2_8BCE
                JSR L0_9092
                JSR L0_8C82
                LDY #$00
                EOR ($02),Y
                AND $0A
                BEQ L2_8BCE
                LDA #$01
L2_8BCE:
                LDX $028D
                BEQ L2_8BD5
                EOR #$01
L2_8BD5:
                LSR $29
                ASL $29
                ORA $29
                ORA #$02
                STA $29
L2_8BDF:
                LDA $28
                ASL
                TAX
                LDA $8C06,X
                PHA
                LDA $8C05,X
                PHA
                RTS
L2_8BEC:
                JMP $958C
L2_8BEF:
                LDA $29
                AND #$FD
                STA $29
                LDA $3F
                AND #$12
                CMP #$02
                BNE L2_8C04
                LDA #$FF
                STA $3F
                JSR $95BE
L2_8C04:
                RTS
                !by $32
                STY L0_8C55
                ROL
                STA $8D2A
                ROL
                STA $8F9E
                AND ($8F),Y
                !by $9C
                STA ($73),Y
                STA ($DE,X)
                STY L0_8C97
                STY $8C,X
                !by $9B
                STY L0_9643
                LDX #$02
L2_8C23:
                LDA $0B,X
                CMP L0_8C52,X
                LDA $0C,X
                SBC L0_8C53,X
                BCS L2_8C51
                DEX
                DEX
                BPL L2_8C23
                JSR L0_9092
                LDY #$00
                LDA $29
                LSR
                ROR $1F
                JSR L0_8C82
                EOR $1F
                ASL
                LDA $0A
                BCC L2_8C4D
                EOR #$FF
                AND ($02),Y
                BCS L2_8C4F
L2_8C4D:
                ORA ($02),Y
L2_8C4F:
                STA ($02),Y
L2_8C51:
                RTS
                RTI
                ORA ($B8,X)
                BRK
                LDA #$03
                STA $27
                DEC $0D
                LDA $0B
                BNE L2_8C62
                DEC $0C
L2_8C62:
                DEC $0B
L2_8C64:
                LDA #$03
                STA $26
                LDA $0D
                PHA
L2_8C6B:
                JSR L0_8C21
                INC $0D
                DEC $26
                BNE L2_8C6B
                PLA
                STA $0D
                INC $0B
                BNE L2_8C7D
                INC $0C
L2_8C7D:
                DEC $27
                BNE L2_8C64
                RTS
                LDA $29
                AND #$08
                BEQ L2_8C94
                LDA $02
                AND #$07
                BEQ L2_8C90
                LDA $0A
L2_8C90:
                EOR $0A
                AND #$80
L2_8C94:
                RTS
                JSR $8C9C
                LDA #$00
                BEQ L2_8C9E
                LDA #$80
L2_8C9E:
                STA $1F
                LDA $0D
                PHA
                LDX #$00
L2_8CA5:
                JSR L0_9092
                LDA #$18
                STA $20
                LDY #$00
L2_8CAE:
                LDA $7F40,X
                STA $0200,Y
                INX
                INY
                CPY #$03
                BNE L2_8CAE
                LDY #$00
L2_8CBC:
                BIT $1F
                BMI L2_8CCB
                ROL $0202
                ROL $0201
                ROL $0200
                BCC L2_8CCE
L2_8CCB:
                JSR L0_8C3D
L2_8CCE:
                JSR L0_8D20
                DEC $20
                BNE L2_8CBC
                INC $0D
                CPX #$3F
                BNE L2_8CA5
                PLA
                STA $0D
                RTS
                JSR $8CEA
                LDA #$0A
                JSR L0_80DE
                JMP $B285
                LDA $0D
                PHA
                LDX #$00
L2_8CEF:
                JSR L0_9092
                LDA #$18
                STA $20
                LDY #$00
L2_8CF8:
                JSR L0_8C82
                CLC
                EOR ($02),Y
                AND $0A
                BEQ L2_8D03
                SEC
L2_8D03:
                ROL $7F42,X
                ROL $7F41,X
                ROL $7F40,X
                JSR L0_8D20
                DEC $20
                BNE L2_8CF8
                INC $0D
                INX
                INX
                INX
                CPX #$3F
                BNE L2_8CEF
                PLA
                STA $0D
                RTS
                LSR $0A
                BCC L2_8D2A
                ROR $0A
                TYA
                ADC #$08
                TAY
L2_8D2A:
                RTS
                JSR $B285
                LDA $29
                EOR #$04
                PHA
                AND #$04
                BEQ L2_8D3D
                JSR $0EE7
                JSR L0_8AE2
L2_8D3D:
                PLA
                STA $29
                RTS
                LDA $28
                CMP #$08
                BNE L2_8D4D
                JSR L0_8AE2
                JMP L0_817F
L2_8D4D:
                LDX #$03
L2_8D4F:
                LDA $13,X
                STA $0F,X
                DEX
                BPL L2_8D4F
                JSR $0F03
                LDA $28
                CMP #$02
                BEQ L2_8D70
                CMP #$03
                BNE L2_8D66
                JMP $8DDD
L2_8D66:
                CMP #$04
                BNE L2_8D6D
                JMP $8E26
L2_8D6D:
                JMP L0_924F
L2_8D70:
                LDA $0D
                PHA
                LDA $0B
                PHA
                LDA $0C
                PHA
                JSR L0_9092
                JSR L0_916F
                LDA $06
                SEC
                SBC $04
                STA $08
                LDA #$00
                SBC $05
                ASL
                PHP
                ROR
                PLP
                ROR
                STA $09
                ROR $08
L2_8D93:
                JSR L0_8C36
                LDA $0B
                CMP $0F
                BNE L2_8DA8
                LDA $0C
                CMP $10
                BNE L2_8DA8
                LDA $0D
                CMP $11
                BEQ L2_8DD3
L2_8DA8:
                BIT $09
                BMI L2_8DC1
                JSR $9131
                BCC L2_8DD3
                LDA $08
                SEC
                SBC $04
                STA $08
                LDA $09
                SBC $05
                STA $09
                JMP $8D93
L2_8DC1:
                JSR $90E6
                BCC L2_8DD3
                LDA $08
                CLC
                ADC $06
                STA $08
                BCC L2_8D93
                INC $09
                BCS L2_8D93
L2_8DD3:
                PLA
                STA $0C
                PLA
                STA $0B
                PLA
                STA $0D
                RTS
                LDA $11
                PHA
                LDA $0D
                STA $11
                JSR $8D70
                PLA
                STA $11
                LDA $0B
                PHA
                LDA $0C
                PHA
                LDA $0F
                STA $0B
                LDA $10
                STA $0C
                JSR $8D70
                PLA
                STA $0C
                PLA
                STA $0B
                LDA $0D
                PHA
                LDA $11
                STA $0D
                JSR $8D70
                PLA
                STA $0D
                LDA $0F
                PHA
                LDA $10
                PHA
                LDA $0B
                STA $0F
                LDA $0C
                STA $10
                JSR $8D70
                PLA
                STA $10
                PLA
                STA $0F
                RTS
                JSR L0_916F
                LDA $04
                CMP $06
                BCS L2_8E31
                LDA $06
L2_8E31:
                TAX
                BEQ L2_8E7C
                STA $08
                LDX $04
                BNE L2_8E3C
                STA $04
L2_8E3C:
                LDX $06
                BNE L2_8E42
                STA $06
L2_8E42:
                LDA $04
                STA $0F
                LDA #$00
                STA $11
                JSR L0_8E7D
L2_8E4D:
                JSR $8EEC
                LDA $0F
                BEQ L2_8E7C
                INC $11
                LDA #$02
                JSR L0_8E7D
                DEC $11
                DEC $0F
                LDA #$04
                JSR L0_8E7D
                INC $0F
                LDA $0202
                CMP $0204
                LDA $0203
                SBC $0205
                BCS L2_8E78
                INC $11
                BCC L2_8E4D
L2_8E78:
                DEC $0F
                BCS L2_8E4D
L2_8E7C:
                RTS
                STA $24
                LDY $0F
                LDA $04
                JSR $8EC7
                STX $1A
                STY $1B
                LDY $11
                LDA $06
                JSR $8EC7
                TXA
                CLC
                ADC $1A
                LDX $24
                STA $0200,X
                TYA
                ADC $1B
                STA $0201,X
                TXA
                BEQ L2_8EC6
                LDA $0200,X
                SEC
                SBC $0200
                PHA
                LDA $0201,X
                SBC $0201
                BCS L2_8EBF
                TAY
                PLA
                EOR #$FF
                ADC #$01
                PHA
                TYA
                EOR #$FF
                ADC #$00
L2_8EBF:
                STA $0201,X
                PLA
                STA $0200,X
L2_8EC6:
                RTS
                CMP $08
                BEQ L2_8EE7
                PHA
                LDX $08
                JSR $B336
                PLA
                STA $26
                LSR
                STA $1C
                TXA
                CLC
                ADC $1C
                STA $1C
                TYA
                ADC #$00
                STA $1D
                JSR $A429
                LDY $1C
L2_8EE7:
                TYA
                TAX
                JMP $B336
                LDA $13
                CLC
                ADC $0F
                STA $0B
                PHA
                LDA $14
                ADC #$00
                STA $0C
                PHA
                LDA $15
                ADC $11
                STA $0D
                LDA #$00
                ROL
                STA $0E
                JSR L0_8C21
                LDA $13
                SEC
                SBC $0F
                STA $0B
                LDA $14
                SBC #$00
                STA $0C
                JSR L0_8C21
                LDA $15
                SEC
                SBC $11
                STA $0D
                LDA #$00
                SBC #$00
                STA $0E
                JSR L0_8C21
                PLA
                STA $0C
                PLA
                STA $0B
                JMP L0_8C21
                LDA #$0A
                STA $25
                LDX #$03
L2_8F38:
                LDA $0B,X
                STA $0F,X
                DEX
                BPL L2_8F38
L2_8F3F:
                LDA $A2
                LSR
                LDY $D012
                LDX #$00
                JSR $8F80
                TAX
                BPL L2_8F4F
                DEC $0C
L2_8F4F:
                ADC $0B
                STA $0B
                BCC L2_8F57
                INC $0C
L2_8F57:
                LDA $D012
                EOR $A2
                LDY $A2
                LDX #$02
                JSR $8F80
                ADC $0D
                STA $0D
                LDA $04
                ADC $06
                BCS L2_8F72
                BMI L2_8F72
                JSR L0_8C21
L2_8F72:
                LDX #$03
L2_8F74:
                LDA $0F,X
                STA $0B,X
                DEX
                BPL L2_8F74
                DEC $25
                BNE L2_8F3F
                RTS
                STX $02
                STY $1C
                LSR
                EOR $1C
                AND #$0F
                PHA
                PHP
                TAX
                TAY
                JSR $B336
                TXA
                LDX $02
                STA $04,X
                TYA
                STA $05,X
                PLP
                PLA
                BCC L2_8F9E
                EOR #$FF
L2_8F9E:
                RTS
                JSR $0EE7
                JSR $827E
                JSR L0_9092
                LDY #$00
                LDA ($02),Y
                AND $0A
                BEQ L2_8FB2
                LDA #$FF
L2_8FB2:
                STA $24
                LDA #$01
                JSR $90E8
                LDA #$00
                STA $49
                LDA $0D
                STA $11
                JSR $B285
                JSR $8FCD
                JSR $827E
                JMP $B285
                TSX
                STX $04
                TSX
                CPX #$1C
                BCC L2_903B
                LDA $1C
                PHA
                LDA $1D
                PHA
                LDA $0B
                PHA
                LDA $0C
                PHA
                LDA $0D
                STA $1C
                LDA $11
                STA $1D
L2_8FE9:
                JSR $90E6
                BCC L2_902F
                JSR L0_903C
                BCC L2_902F
                LDA $0D
                PHA
                LDA $11
                PHA
L2_8FF9:
                JSR L0_903C
                BCC L2_9003
                JSR $8FD0
L2_9001:
                BCC L2_8FF9
L2_9003:
                PLA
L2_9004:
                STA $1D
                PLA
                STA $1C
                LDA $49
                EOR #$01
                STA $49
                JSR $90E6
L2_9012:
                JSR L0_903C
L2_9015:
                BCC L2_901C
L2_9017:
                JSR $8FD0
                BCC L2_9012
L2_901C:
                LDA $49
                EOR #$01
L2_9020:
                STA $49
                JSR $90E6
                LDA $3F
L2_9027:
                AND #$07
L2_9029:
                BEQ L2_8FE9
                LDX $04
                TXS
                RTS
L2_902F:
                PLA
                STA $0C
                PLA
                STA $0B
                PLA
                STA $1D
                PLA
                STA $1C
L2_903B:
                RTS
                LDA $1C
                STA $0D
                LDA $1D
                STA $11
                JSR L0_9092
L2_9047:
                JSR $9089
                BNE L2_907F
L2_904C:
                JSR $9137
                BCC L2_9059
                JSR $9089
                BEQ L2_904C
                JSR $914C
L2_9059:
                LDA $0D
                TAX
L2_905C:
                JSR $9089
                BNE L2_9074
                LDA ($02),Y
                EOR $24
                ORA $0A
                EOR $24
                STA ($02),Y
                JSR $914C
                LDA $0D
                CMP #$B8
                BCC L2_905C
L2_9074:
                JSR $9137
                LDA $0D
                STA $11
                STX $0D
                SEC
                RTS
L2_907F:
                JSR $914C
                LDA $11
                CMP $0D
                BCS L2_9047
                RTS
                LDY #$00
                LDA ($02),Y
                EOR $24
                AND $0A
                RTS
                LDA #$00
                STA $02
                LDA $0D
                LSR
                LSR
                LSR
                STA $03
                ASL
                ASL
                ADC $03
                LSR
                ROR $02
                LSR
                ROR $02
                ADC #$60
                STA $03
                LDA $0D
                AND #$07
                STA $1E
                LDA $38
                AND #$10
                BEQ L2_90B9
                LDA #$18
L2_90B9:
                ADC $0B
                AND #$F8
                ADC $1E
                ADC $02
                STA $02
                LDA $0C
                !by $65
                !by $03
                !by $85
                !by $03
                !by $A5
                !by $0B
                !by $29
                !by $07
                !by $A8
                !by $B9
                !by $D4
                !by $90
                !by $85
                !by $0A
                !by $60
                !by $80
                !by $40
                !by $20
                !by $10
                !by $08
                !by $04
                !by $02
                ORA ($14,X)
                !by $14
                ORA $12
                AND $1902
                !by $14
                ORA $60
                LDA $49
                LSR
                BCC L2_910C
                LDA $0B
                ORA $0C
                BEQ L2_912F
                LDA $0B
                BNE L2_90F7
                DEC $0C
L2_90F7:
                DEC $0B
                ASL $0A
                BCC L2_910A
                ROL $0A
                LDA $02
                SEC
                SBC #$08
                STA $02
                BCS L2_910A
                DEC $03
L2_910A:
                SEC
                RTS
L2_910C:
                LDA $0C
                BEQ L2_9116
                LDA $0B
                CMP #$3F
                BEQ L2_912F
L2_9116:
                INC $0B
                BNE L2_911C
                INC $0C
L2_911C:
                LSR $0A
                BCC L2_912D
                ROR $0A
                LDA $02
                CLC
                ADC #$08
                STA $02
                BCC L2_912D
                INC $03
L2_912D:
                SEC
                RTS
L2_912F:
                CLC
                RTS
                LDA $49
                AND #$02
                BEQ L2_914C
                LDA $0D
                BEQ L2_912F
                DEC $0D
                AND #$07
                BEQ L2_9145
                DEC $02
                SEC
                RTS
L2_9145:
                LDA #$FE
                PHA
                LDA #$C7
                BNE L2_9163
L2_914C:
                LDA $0D
                CMP #$C7
                BEQ L2_912F
                INC $0D
                LDA $0D
                AND #$07
                BEQ L2_915E
                INC $02
                SEC
                RTS
L2_915E:
                LDA #$01
                PHA
                LDA #$39
L2_9163:
                CLC
                ADC $02
                STA $02
                PLA
                ADC $03
                STA $03
                SEC
                RTS
                LDA $0D
                SEC
                SBC $11
                BCS L2_917B
                EOR #$FF
                ADC #$01
                CLC
L2_917B:
                STA $06
                ROL $49
                LDA $0B
                SEC
                SBC $0F
                STA $04
                LDA $0C
                SBC $10
                BCS L2_9198
                LDA $0F
                SEC
                SBC $0B
                STA $04
                LDA $10
                SBC $0C
                CLC
L2_9198:
                STA $05
                ROL $49
                RTS
                JSR $B285
                BIT $4A
                BMI L2_91DD
                LDA $29
                EOR #$04
                PHA
                AND #$04
                BEQ L2_91B6
                JSR $0EE7
                PLA
                STA $29
                JMP L0_8AE2
L2_91B6:
                PLA
                STA $29
                JSR $0F03
                LDX #$00
                LDY #$3F
                STX $08
                STY $09
                LDX #$17
                LDY #$28
                LDA #$00
                SEC
                JSR $B36C
                LDA #$3F
                JSR L0_92A9
                LDA #$A0
                STA $4A
                JSR L0_94D6
                JMP $0F03
L2_91DD:
                LDA #$00
                BEQ L2_91F3
                LDA $4A
                BPL L2_91F8
                AND #$EF
                EOR #$20
                BMI L2_91F3
                LDA $4A
                BPL L2_91F8
                AND #$DF
                EOR #$10
L2_91F3:
                STA $4A
                JSR L0_94D6
L2_91F8:
                RTS
                LDA $4A
                AND #$10
                BNE L2_923A
L2_91FF:
                LDY $49
                LDX L0_9232,Y
                LDA $9236,X
                CMP $4C,X
                BEQ L2_922F
                TYA
                LSR
                TXA
                AND #$01
                TAX
                BCC L2_9219
                DEC $4C,X
                DEC $4E,X
                BCS L2_921D
L2_9219:
                INC $4C,X
                INC $4E,X
L2_921D:
                JSR $944E
                JSR $0F03
                LDA $3F
                AND #$05
                BNE L2_91FF
                LDA $CB
                CMP #$40
                BNE L2_91FF
L2_922F:
                JMP $B285
                !by $02
                BRK
                !by $03
                ORA ($00,X)
                BRK
                ASL $27,X
L2_923A:
                JSR $9380
                JSR $0F03
                LDA $3F
                AND #$05
                BNE L2_923A
                LDA $CB
                CMP #$40
                BNE L2_923A
                JMP $B285
                JSR $9282
                LDX #$00
                LDY #$01
L2_9256:
                LDA $0C,X
                LSR
                LDA $0B,X
                AND #$F8
                STA $0B,X
                ROR
                LSR
                LSR
                STA $004C,Y
                LDA $10,X
                LSR
                LDA $0F,X
                ORA #$07
                STA $0F,X
                ROR
                LSR
                LSR
                STA $004E,Y
                SBC $004C,Y
                STA $0050,Y
                INX
                INX
                DEY
                BPL L2_9256
                JMP $8DDD
                LDX #$02
L2_9284:
                LDA $0B,X
                CMP $0F,X
                LDA $0C,X
                SBC $10,X
                BCC L2_92A2
                LDA $0F,X
                PHA
                LDA $0B,X
                STA $0F,X
                PLA
                STA $0B,X
                LDA $10,X
                PHA
                LDA $0C,X
                STA $10,X
                PLA
                STA $0C,X
L2_92A2:
                ROR $4B
                DEX
                DEX
                BPL L2_9284
                RTS
                PHA
                EOR #$60
                STA $1F
                JSR $827E
                LDA $4C
                BIT $4B
                BVS L2_92B9
                LDA $4E
L2_92B9:
                STA $22
                LDA $4D
                BIT $4B
                BMI L2_92C3
                LDA $4F
L2_92C3:
                STA $23
                LDX #$22
                LDY #$03
                JSR L0_8318
                LDX #$02
                JSR $8341
                LDA $02
                STA $04
                STA $08
                PLA
                CLC
                ADC $03
                STA $05
                STA $09
                LDX #$4C
                LDY #$03
                JSR L0_8318
                LDX #$02
                JSR $8341
                LDA $02
                STA $06
                LDA $03
                ORA #$60
                STA $03
                STA $07
                LDA $50
                STA $22
L2_92FB:
                LDX $51
L2_92FD:
                LDY #$07
L2_92FF:
                STY $1C
                LDA $1F
                BEQ L2_9318
                LDA ($02),Y
                BIT $4B
                BMI L2_930E
                JSR $9371
L2_930E:
                BIT $4B
                BVS L2_9318
                PHA
                TYA
                EOR #$07
                TAY
                PLA
L2_9318:
                STA ($04),Y
                LDY $1C
                DEY
                BPL L2_92FF
                LDA $02
                CLC
                ADC #$08
                STA $02
                BCC L2_932A
                INC $03
L2_932A:
                LDA #$08
                LDY #$00
                BIT $4B
                BMI L2_9336
                LDA #$F8
                LDY #$FF
L2_9336:
                CLC
                ADC $04
                STA $04
                TYA
                ADC $05
                STA $05
                DEX
                BPL L2_92FD
                LDX #$06
                JSR $8331
                LDA $06
                STA $02
                LDA $07
                STA $03
                LDA #$40
                LDY #$01
                BIT $4B
                BVS L2_935C
                LDA #$C0
                LDY #$FE
L2_935C:
                CLC
                ADC $08
                STA $08
                STA $04
                TYA
                ADC $09
                STA $09
                STA $05
                DEC $22
                BPL L2_92FB
                JMP $827E
                STA $1D
                STY $1C
                LDY #$08
L2_9377:
                ROL $1D
                ROR
                DEY
                BNE L2_9377
                LDY $1C
                RTS
                LDX #$07
L2_9382:
                LDA L0_9446,X
                STA $02,X
                DEX
                BPL L2_9382
                LDX #$1C
                STX $26
                LDA $49
                CMP #$01
                BNE L2_93C8
                LDY #$40
L2_9396:
                TYA
                AND #$07
                CMP #$07
                BNE L2_93B7
                TYA
                CLC
                ADC $06
                ROL $1C
                CMP #$C0
                ROR $1C
                LDA #$00
                ADC $07
                ROL $1C
                SBC #$5B
                LDA #$00
                BCS L2_93BB
                LDA ($06),Y
                BCC L2_93BB
L2_93B7:
                INY
                LDA ($02),Y
                DEY
L2_93BB:
                STA ($02),Y
                INY
                BNE L2_9396
                INC $03
                INC $07
                DEX
                BPL L2_9396
                RTS
L2_93C8:
                CMP #$00
                BNE L2_93F7
                LDY #$C0
L2_93CE:
                DEY
                TYA
                AND #$07
                BNE L2_93E6
                TYA
                CLC
                ADC $08
                LDA #$00
                ADC $09
                CMP #$3F
                LDA #$00
                BCC L2_93EA
                LDA ($08),Y
                BCS L2_93EA
L2_93E6:
                DEY
                LDA ($04),Y
                INY
L2_93EA:
                STA ($04),Y
                TYA
                BNE L2_93CE
                DEC $05
                DEC $09
                DEX
                BPL L2_93CE
                RTS
L2_93F7:
                CMP #$03
                BNE L2_9421
                LDY #$C0
                LDX #$00
L2_93FF:
                TYA
                AND #$07
                BNE L2_940F
                DEX
                BPL L2_940D
                LDA #$00
                STA $1C
                LDX #$27
L2_940D:
                ROL $1C
L2_940F:
                DEY
                LDA ($04),Y
                ROL
                STA ($04),Y
                ROL $1C
                TYA
                BNE L2_93FF
L2_941A:
                DEC $05
                DEC $26
                BPL L2_93FF
                RTS
L2_9421:
                LDY #$40
                LDX #$00
L2_9425:
                TYA
                AND #$07
                BNE L2_9435
                DEX
                BPL L2_9433
                LDA #$00
                STA $1C
                LDX #$27
L2_9433:
                ROR $1C
L2_9435:
                LDA ($02),Y
                ROR
                STA ($02),Y
                ROR $1C
                INY
                BNE L2_9425
                INC $03
                DEC $26
                BPL L2_9425
                RTS
                CPY #$3E
                BRK
                !by $5B
                SBC $C73F,Y
                EOR $49A5,Y
                ASL
                ADC $49
                ASL
                TAY
                LDX #$00
L2_9457:
                LDA $94AC,Y
                STA $02,X
                INY
                INX
                CPX #$05
                BNE L2_9457
                TAX
                LDA L0_94AD,Y
                TAY
                LDA $49
                LSR
                BCC L2_947C
L2_946C:
                LDA ($02),Y
                STA ($04),Y
                INY
                BNE L2_946C
                INC $03
                INC $05
                DEX
                BPL L2_946C
                BMI L2_9493
L2_947C:
                DEY
                LDA ($02),Y
                STA ($04),Y
                TYA
                BNE L2_947C
                DEC $03
                DEC $05
                DEX
                BPL L2_947C
                LDX #$00
                LDY #$3F
                STX $04
                STY $05
L2_9493:
                LDY #$07
                LDA $49
                LSR
                BNE L2_94A4
                TAY
                STA ($04),Y
                !by $88
                !by $D0
                !by $FB
                !by $E6
                !by $05
                !by $A0
                !by $3F
L2_94A4:
                !by $A9
                !by $00
                !by $91
                !by $04
                !by $88
                !by $10
                !by $FB
                !by $60
                !by $00
                !by $5A
                !by $40
                !by $5B
                !by $1B
                !by $80
                !by $C0
                !by $3F
                !by $80
                ROL $801B,X
                BRK
                !by $5B
                PHP
                !by $5B
                !by $1C
                CLV
                CPY #$3E
                CLV
                ROL $481C,X
                AND #$03
                STA $35
                BIT $4A
                BPL L2_94CF
                JSR $0F03
L2_94CF:
                JMP L0_94D6
                BIT $11
                EOR ($31),Y
                LDA $29
                AND #$9F
                ORA #$20
                STA $29
                BIT $29
                BVS L2_9537
                LDX $0E39
                LDY $0E3A
                LDA $29
                AND #$20
                BEQ L2_94F4
                LDX $0E3B
                LDY $0E3C
L2_94F4:
                STX $02
                STY $03
                LDX #$C0
                LDY #$7C
                STX $08
                STY $09
                LDX #$02
                LDY #$28
                CLC
                JSR $B36C
                JSR L0_89B3
                LDA $29
                AND #$20
                BNE L2_9518
                LDX $28
                INX
                TXA
                JMP L0_9570
L2_9518:
                LDA $4A
                AND #$30
                BEQ L2_9529
                LDX #$07
                AND #$10
                BEQ L2_9525
                INX
L2_9525:
                TXA
                JSR L0_9570
L2_9529:
                LDA $35
                CLC
                ADC #$09
                JMP L0_9570
                LDA $29
                ORA #$40
                STA $29
L2_9537:
                LDX #$03
L2_9539:
                LDA L0_956C,X
                STA $02,X
                DEX
                BPL L2_9539
                LDX #$00
                STX $26
                LDY #$00
L2_9547:
                LDA #$FF
                BNE L2_954E
L2_954B:
                LDA $0D00,X
L2_954E:
                STA ($02),Y
                LDA $0D00,X
                STA ($04),Y
                INX
                INY
                BNE L2_955D
                INC $03
                INC $05
L2_955D:
                TYA
                AND #$07
                BNE L2_954B
                TXA
                LDX $26
                STA $26
                CPX #$A0
                BNE L2_9547
                RTS
                CPY #$7C
                BRK
                ROR $0A0A,X
                ASL
                ASL
                TAY
                LDX #$10
L2_9577:
                LDA $7CC0,Y
                EOR #$FF
                STA $7CC0,Y
                LDA $7E00,Y
                EOR #$FF
                STA $7E00,Y
                INY
                DEX
                BNE L2_9577
                RTS
                LDA $19
                CMP #$EF
                BCS L2_95BE
                LDX #$04
                LDA $0B
L2_9596:
                LSR $0C
                ROR
                DEX
                BNE L2_9596
                TAX
                BIT $29
                BVS L2_95B8
                LDA $29
                AND #$20
                BEQ L2_95AC
                TXA
                CLC
                ADC #$14
                TAX
L2_95AC:
                JMP ($0E3F)
                LDA L0_95DB,X
                JSR L0_8094
                JMP $B285
L2_95B8:
                JSR $10A5
                JMP $B285
L2_95BE:
                LDA $29
                CLC
                ADC #$20
                AND #$60
                CMP #$60
                BNE L2_95CB
                LDA #$00
L2_95CB:
                STA $1C
                !by $A5
                !by $29
                !by $29
                !by $9F
                !by $05
                !by $1C
                !by $85
                !by $29
                !by $20
                !by $DE
                !by $94
                !by $4C
                !by $85
                !by $B2
                !by $5F
                !by $64
                !by $44
                !by $6C
                !by $72
                !by $63
                !by $70
                !by $6A
                !by $6D
                !by $74
                !by $67
                !by $61
                !by $73
                !by $65
                !by $20
                !by $77
                !by $B8
                !by $C3
                !by $6B
                !by $6B
                !by $5F
                !by $C1
                LSR $A1A3,X
                LDY #$A2
                EOR $6F66
                SEI
                ADC $2E,X
                ADC #$B5
                LDX $BA,Y
                !by $B7
                !by $6B
                !by $6B
                LDA $28
                CMP #$09
                BCC L2_960D
                CMP #$0D
                BCC L2_9612
L2_960D:
                LDA #$0D
                JMP L0_80BC
L2_9612:
                JSR L0_8AE2
                JSR $0EE7
                LDA #$8C
                STA $D001
                LDA #$14
                STA $D000
                LDA #$01
                STA $D010
                LDA #$01
                STA $D015
                LDA #$1A
                STA $02
                LDA #$5C
                STA $03
                LDX #$16
                LDY #$0D
                LDA $1704
                JSR L0_9961
                JSR $B3CD
                JMP $96AD
                JSR L0_8AE2
                JSR $0EE7
                JSR $AFE4
                JSR $8CEA
                JSR $8C9C
                LDA #$FC
                SEC
                SBC $13
                TAY
                LDA #$00
                SBC $14
                TYA
                BCS L2_9662
                LDA #$00
L2_9662:
                CMP #$D0
                BCC L2_9668
                LDA #$D0
L2_9668:
                AND #$F8
                STA $1C
                CLC
                ADC $8781
                ADC $13
                STA $D000
                STA $D002
                LDA $14
                ADC #$00
                STA $1D
                ASL
                ORA $1D
                STA $D010
                LDA #$03
                STA $D015
                LDA #$C0
                STA $04
                SEC
                SBC $1C
                STA $02
                LDA #$7B
                STA $05
                SBC #$00
                STA $03
                LDX #$1C
                LDY #$00
L2_969E:
                DEY
                LDA ($02),Y
                STA ($04),Y
                TYA
                BNE L2_969E
                DEC $03
                DEC $05
                DEX
                BNE L2_969E
                JSR L0_9863
                JSR $B285
                JSR L0_96C9
                JSR $AEEC
                JSR L0_8AC1
                LDA $28
                CMP #$0D
                BNE L2_96C8
                JSR L0_8C95
                JSR $AFF0
L2_96C8:
                RTS
                JSR $96D5
                JSR $97DA
                JSR L0_993A
                JMP L0_96C9
                JSR $0E2D
                BNE L2_96DB
                RTS
L2_96DB:
                CMP #$20
                BNE L2_96E2
                PLA
                PLA
                RTS
L2_96E2:
                CMP #$6D
                BNE L2_970B
                LDY #$3C
L2_96E8:
                LDA $7F40,Y
                JSR $9371
                STA $0382,Y
                LDA $7F42,Y
                JSR $9371
                STA $0380,Y
                LDA $7F41,Y
                JSR $9371
                STA $0381,Y
                DEY
                DEY
                DEY
                BPL L2_96E8
                JMP L0_9768
L2_970B:
                CMP #$74
                BNE L2_9723
                LDY #$00
                LDX #$3E
L2_9713:
                LDA $7F40,Y
                JSR $9371
                STA $0380,X
                INY
                DEX
                BPL L2_9713
                JMP L0_9768
L2_9723:
                CMP #$72
                BNE L2_9776
                LDA #$02
                STA $27
L2_972B:
                LDY $27
                STY $08
                LDX L0_996C,Y
                LDA L0_996F,Y
                STA $20
                LDA #$03
                STA $26
L2_973B:
                LDA #$08
                STA $21
L2_973F:
                LDY $20
                TXA
                PHA
                LDA #$00
L2_9745:
                ROL $7F40,X
                ROR
                INX
                INX
                INX
                DEY
                BNE L2_9745
                LDY $08
                STA $0380,Y
                INY
                INY
                INY
                STY $08
                PLA
                TAX
                DEC $21
                BNE L2_973F
                INX
                DEC $26
                BNE L2_973B
                DEC $27
                BPL L2_972B
                LDY #$3E
L2_976A:
                LDA $0380,Y
                STA $7F40,Y
                DEY
                BPL L2_976A
                JMP L0_98DB
L2_9776:
                CMP #$69
                BNE L2_978A
                LDY #$3E
L2_977C:
                LDA $7F40,Y
                EOR #$FF
                STA $7F40,Y
                DEY
                BPL L2_977C
                JMP L0_98DB
L2_978A:
                CMP #$C1
                BNE L2_9794
                JSR $AFD9
                JMP L0_98DB
L2_9794:
                CMP #$A0
                BNE L2_97AC
                LDA $0D
                CMP #$14
                BCC L2_97A8
                CMP #$16
                BCS L2_97D9
                LDA $3F
                AND #$05
                BNE L2_97D9
L2_97A8:
                INC $0D
                BPL L2_97D0
L2_97AC:
                CMP #$A1
                BNE L2_97B8
                LDA $0D
                BEQ L2_97D9
                DEC $0D
                BPL L2_97D0
L2_97B8:
                CMP #$A2
                BNE L2_97C6
                LDA $0B
                CMP #$17
                BCS L2_97D9
                INC $0B
                BPL L2_97D0
L2_97C6:
                CMP #$A3
                BNE L2_97D9
                LDA $0B
                BEQ L2_97D9
                DEC $0B
L2_97D0:
                LDA $24
                LDY #$29
                STA ($04),Y
                JSR L0_991C
L2_97D9:
                RTS
                LDA $3F
                AND #$05
                BEQ L2_983C
                LDA $0D
                CMP #$15
                BCS L2_9843
                LDA $29
                AND #$02
                BNE L2_9808
                LDA $033E
                EOR $24
                AND #$0F
                BEQ L2_97F7
                LDA #$01
L2_97F7:
                LDX $028D
                BEQ L2_97FE
                EOR #$01
L2_97FE:
                LSR $29
L2_9800:
                ASL $29
                ORA $29
                ORA #$02
                STA $29
L2_9808:
                JSR $90C9
                LDA $0B
                LSR
                LSR
                LSR
                LDY #$03
                CLC
L2_9813:
                ADC $0D
                DEY
                BNE L2_9813
                TAY
                LDA $29
                LSR
                LDA $0A
                BCS L2_982A
                ORA $7F40,Y
                STA $7F40,Y
                LDX #$01
                BNE L2_9834
L2_982A:
                EOR #$FF
                AND $7F40,Y
                STA $7F40,Y
                LDX #$00
L2_9834:
                LDA $033E,X
                STA $24
                JMP L0_993A
L2_983C:
                LDA $29
                AND #$FD
                STA $29
                RTS
L2_9843:
                LDA $1704
                LDY #$29
                STA ($04),Y
                JSR $B285
                LDA $0B
                LSR
                TAX
                LDA $9857,X
                JMP L0_96D8
                BRK
                BRK
                BRK
                JSR $746D
                !by $72
                ADC #$C1
                BRK
                BRK
                BRK
                LDA $1704
                JSR L0_9961
                STA $033E
                LDA $1704
                LSR
                LSR
                LSR
                LSR
                STA $1C
                LDA $033E
                AND #$F0
                ORA $1C
                STA $033F
                LDX #$00
                LDY #$60
                STX $08
                STY $09
                LDX #$19
                LDY #$1A
                LDA #$FF
                SEC
                JSR $B36C
                LDA #$48
                STA $02
                LDA #$61
                STA $03
                LDA #$15
                STA $27
L2_989D:
                LDA #$18
                STA $26
                LDA #$81
                LDY #$01
L2_98A5:
                LDX #$06
L2_98A7:
                STA ($02),Y
                INY
                DEX
                BNE L2_98A7
                INY
                INY
                DEC $26
                BNE L2_98A5
                LDX #$02
                JSR $8331
                DEC $27
                BNE L2_989D
                LDY #$5F
L2_98BE:
                LDA L0_B947,Y
                STA $7BB8,Y
                LDA $B9A7,Y
                STA $7CF8,Y
                DEY
                BPL L2_98BE
                LDA #$02
                JSR $AF3F
                JSR $B02A
                LDA #$0A
                STA $0D
                STA $0B
                LDA #$3E
                STA $26
                LDA #$49
                STA $02
                LDA #$5F
                STA $03
L2_98E7:
                LDY #$02
L2_98E9:
                LDX $26
                LDA $7F40,X
                STA $0380,Y
                DEC $26
                DEY
                BPL L2_98E9
                LDY #$17
L2_98F8:
                LSR $0380
                ROR $0381
                ROR $0382
                LDA #$00
                ROL
                TAX
                LDA $033E,X
                STA ($02),Y
                DEY
                BPL L2_98F8
                SEC
                LDA $02
                SBC #$28
                STA $02
                BCS L2_9918
                DEC $03
L2_9918:
                LDA $26
                BPL L2_98E7
                LDA $0B
                STA $0E
                LDX #$0D
                LDY #$03
                JSR L0_8318
                LDA $02
                STA $04
                LDA $03
                ORA #$5C
                STA $05
                LDY #$29
                LDA ($04),Y
                STA $24
                JSR $994E
                LDA $24
                AND #$0F
                STA $1C
                LDA $D028
                ASL
                ASL
                ASL
                ASL
                ORA $1C
                LDY #$29
                STA ($04),Y
                RTS
                LDA #$00
                TAY
                TAX
                STA $0C
                JSR $89D9
                LDA #$00
                TAY
                LDX #$02
                STA $0E
                JMP $89D9
                AND #$0F
                STA $1C
                ASL
                ASL
                ASL
                ASL
                ORA $1C
                !by $60
                !by $27
                !by $0F
                !by $00
                !by $08
                !by $08
                !by $05
                !by $A2
                !by $FE
                !by $9A
                !by $20
                !by $F8
                !by $9F
L2_9978:
                JSR $99C0
                JSR L2_8793
                JSR $9A2B
                JMP L2_9978
                !by $62
                !by $B5
                !by $65
                !by $73
                !by $74
                !by $C3
                !by $B9
                !by $5F
                !by $31
                !by $32
                !by $33
                !by $C1
                !by $76
                !by $66
                !by $B7
                !by $61
                !by $A8
                !by $AA
                !by $30
                !by $B8
                !by $E3
                !by $99
                !by $6D
                !by $9B
                !by $E3
                !by $99
                !by $1F
                !by $9C
                !by $6F
                !by $9C
                !by $B3
                !by $0D
                !by $AD
                !by $0D
                !by $85
                !by $9E
                !by $99
                !by $9E
                STA $999E,Y
                !by $9E
                EOR $9A9D,X
                LDY #$A6
                LDY #$C2
                LDY #$BE
                TXS
                ORA ($84),Y
                !by $1A
                STY $A0
                TXA
                !by $2B
                !by $10
L2_99C0:
                JSR $FFE4
                BEQ L2_99D7
                PHA
                JSR $B27A
                ASL $0340
                PLA
                LDX #$13
L2_99CF:
                CMP L0_9984,X
                BEQ L2_99D8
                DEX
                BPL L2_99CF
L2_99D7:
                RTS
L2_99D8:
                TXA
                ASL
                TAY
                LDA L0_9999,Y
                PHA
                LDA $9998,Y
                PHA
                RTS
                LDA #$04
                BIT $29
                BNE L2_99F0
                LDA $37
                CMP #$04
                BNE L2_99F7
L2_99F0:
                TXA
                PHA
                JSR $9DA4
                PLA
                TAX
L2_99F7:
                LDA $38
                AND #$BF
L2_99FB:
                STA $38
                LDA $29
                AND #$FB
                STA $29
                STX $37
                LDA $9A21,X
                LDY L0_9A26,X
                STA $48
                BIT $29
                BPL L2_9A15
                LDA #$03
                LDY #$02
L2_9A15:
                STY $D015
                JSR $AF3F
                JSR $87C5
                JMP $9F5A
                ORA ($04,X)
                ORA ($01,X)
                ORA ($02,X)
                ASL $02
                !by $02
                !by $02
                LDA $3F
                AND #$07
L2_9A2F:
                BEQ L2_9A53
                PHA
                JSR $87C5
                JSR $B27A
                JSR $B285
                PLA
                BIT $29
                BPL L2_9A43
                JMP $9FA2
L2_9A43:
                AND #$02
                BNE L2_9A54
                LDA $37
                ASL
                TAX
                LDA $9A5D,X
                PHA
                LDA L0_9A5C,X
                PHA
L2_9A53:
                RTS
L2_9A54:
                LDX #$02
                JSR L0_99E4
                JMP L0_9BEB
                ADC $9A
                BCS L2_99FB
                NOP
                !by $9B
                !by $3C
                !by $9C
                CPY $9C
                LDA $29
                EOR #$04
                STA $29
                AND #$04
                BEQ L2_9A79
                JSR $9F0D
                JSR $9E74
                JMP L0_8AE2
L2_9A79:
                JSR $9282
                INC $0F
                INC $11
                LDA $0F
                SEC
                SBC $0B
                CMP #$05
                BCC L2_9AB4
                LDY $52
                LDX #$02
                BIT $38
                BVS L2_9AA4
                LDA $1700
                TAY
                CLC
                ADC #$05
                BCS L2_9AB7
                STA $1700
                LDA #$00
                STA $1800,Y
                LDX #$00
L2_9AA4:
                STX $37
                LDX #$00
L2_9AA8:
                LDA $0B,X
                STA $1801,Y
                INY
                INX
                INX
                CPX #$08
                BCC L2_9AA8
L2_9AB4:
                JMP $A073
L2_9AB7:
                LDA #$05
                JSR $B22A
                JMP $9DA4
                BIT $38
                BVC L2_9AE7
                JSR $9E74
                LDY $52
                LDA $1800,Y
                BPL L2_9AE8
                CLC
                ADC #$20
                AND #$60
                CMP #$20
                BNE L2_9AD8
                LDA #$40
L2_9AD8:
                STA $1C
                LDA $1800,Y
                AND #$9F
                ORA $1C
                STA $1800,Y
                JSR $9F5A
L2_9AE7:
                RTS
L2_9AE8:
                LDA $52
                TAX
                CLC
                ADC #$05
                TAY
                LDA $1800,X
                AND #$1F
                BEQ L2_9B12
                LDA $1800,Y
                CMP #$A0
                BCC L2_9B12
                CLC
                ADC #$04
                STA $1800,Y
                AND #$1C
                BNE L2_9B23
                DEC $1800,X
                LDA #$01
                JSR $9E59
                JMP $9B2C
L2_9B12:
                LDA #$01
                JSR $9E38
                BCS L2_9B27
                LDX $52
                LDA #$E0
                STA $1805,X
                INC $1800,X
L2_9B23:
                JSR $9B2C
                RTS
L2_9B27:
                LDA #$05
                JMP $B22A
                LDY $52
                LDA $1800,Y
                BMI L2_9B49
                LDX #$80
                AND #$1F
                BEQ L2_9B45
                LDA $1805,Y
                CMP #$A0
                BCC L2_9B45
                ASL
                ASL
                AND #$70
                TAX
L2_9B45:
                LDY #$00
                BEQ L2_9B57
L2_9B49:
                LDY #$10
                LDX #$A0
                ASL
                ASL
                BMI L2_9B57
                LDX #$90
                BCS L2_9B57
                LDX #$B0
L2_9B57:
                LDA #$10
                STA $26
L2_9B5B:
                LDA L0_BC87,X
                STA $6FD0,Y
                LDA L0_BD47,X
                STA $7110,Y
                INY
                INX
                DEC $26
                BNE L2_9B5B
                RTS
                LDA #$80
                JSR L0_8467
                BCS L2_9BAB
                LDY $1700
                TYA
                CLC
                ADC #$05
                BCS L2_9BA6
                TAX
                ADC $B7
                BCS L2_9BA6
                STY $52
                LDA $B7
                ORA #$C0
                STA $1800,Y
                LDY #$00
L2_9B8E:
                LDA ($BB),Y
                STA $1800,X
                INY
                INX
                CPY $B7
                BCC L2_9B8E
                JSR L0_9BDD
                JSR $B222
                LDA #$01
                STA $37
                JMP $A084
L2_9BA6:
                LDA #$05
                JSR $B22A
L2_9BAB:
                JSR L0_8658
                JMP $A076
                JSR $9E74
                LDY $52
                LDA $0B
                AND #$FE
                STA $1801,Y
                CLC
                ADC $40
                STA $1803,Y
                LDA $0D
                AND #$FE
                STA $1802,Y
                CLC
                ADC $41
                STA $1804,Y
                BIT $38
                BVS L2_9BDA
                JSR $9E26
                STY $1700
L2_9BDA:
                JMP $A073
                LDY $52
                JSR $B1B9
                LDA $B7
                LDX $BB
                LDY $BC
                JMP $B231
                LDA $1700
                BEQ L2_9C1F
                JSR $9DEB
                JSR $9DD4
                LDA $38
                ORA #$40
                STA $38
                LDY $52
                LDX #$00
L2_9C00:
                LDA $1800,Y
L2_9C03:
                BPL L2_9C1C
L2_9C05:
                LDA $1803,Y
                SEC
                SBC $1801,Y
                STA $40
                LDA $1804,Y
                SEC
                SBC $1802,Y
                STA $41
                JSR L0_9BDD
                LDX #$01
L2_9C1C:
                JSR $9A03
L2_9C1F:
                RTS
                LDA $1700
                BEQ L2_9C38
                LDY #$00
L2_9C27:
                LDA $1800,Y
                BMI L2_9C33
                STY $52
                JSR $9DD4
                LDY $52
L2_9C33:
                JSR $9E26
                BCC L2_9C27
L2_9C38:
                LDX #$03
                JMP L0_99E4
                LDA $1700
                BEQ L2_9C6F
                JSR $9DEB
                LDY $52
                JSR $9DD4
                JSR $9E74
                LDX #$00
                LDY $52
L2_9C51:
                LDA $1800,Y
                STA $0200,X
                INY
                INX
                CPX #$15
                BCC L2_9C51
                JSR $9D85
                LDX #$00
L2_9C62:
                LDA $0200,X
                STA $1800,Y
                INX
                INY
                CPY $1700
                BNE L2_9C62
L2_9C6F:
                RTS
                BIT $38
                BVC L2_9C83
                LDY $52
                LDA $1800,Y
                BMI L2_9C83
                JSR $9C84
                LDX #$04
                JSR $9A03
L2_9C83:
                RTS
                JSR $9F08
                LDY $52
                JSR $9DBB
                LDY $52
                JSR $9E26
                DEY
L2_9C92:
                TYA
                SEC
                SBC #$04
                CMP $52
                BEQ L2_9CC4
                LDA $1800,Y
                CMP #$A0
                BCS L2_9CC4
                LDX $52
                ADC $1801,X
                CMP #$A0
                BCS L2_9CC1
                STA $0B
                STA $0F
                LDA $1802,X
                STA $0D
                LDA $1804,X
                STA $11
                DEC $11
                TYA
                PHA
                JSR $8D70
                PLA
                TAY
L2_9CC1:
                DEY
                BNE L2_9C92
L2_9CC4:
                RTS
                JSR $9E74
                LDY $52
                LDA $0B
                SEC
                SBC $1801,Y
                BCC L2_9D2D
                STA $0F
                JSR $9E26
                DEY
L2_9CD8:
                TYA
                SEC
                SBC #$04
                CMP $52
                BEQ L2_9CF0
                LDA $1800,Y
                CMP #$A0
                BCS L2_9CF0
                CMP $0F
                BEQ L2_9D20
                BCC L2_9CF0
                DEY
                BNE L2_9CD8
L2_9CF0:
                LDX $52
                LDA $0B
                CMP $1803,X
                BCS L2_9D2D
                LDA $1800,X
                AND #$1F
                CMP #$0F
L2_9D00:
                BCS L2_9D1B
L2_9D02:
                INY
L2_9D03:
                TYA
                PHA
                LDA #$01
                JSR $9E38
                PLA
                TAY
                BCS L2_9D1B
                LDA $0F
                STA $1800,Y
                LDX $52
                INC $1800,X
                JMP $9C84
L2_9D1B:
                LDA #$05
                JMP $B22A
L2_9D20:
                LDA #$01
                JSR $9E59
                LDX $52
                DEC $1800,X
                JSR $9C84
L2_9D2D:
                RTS
                LDY $52
                LDA $1800,Y
                AND #$1F
                BEQ L2_9D5D
                TAX
                TYA
                CLC
                ADC #$05
                TAY
                LDA $1800,Y
                CMP #$A0
                BCC L2_9D46
                INY
                DEX
L2_9D46:
                TXA
                BEQ L2_9D5D
                PHP
                JSR $9E59
                LDY $52
                LDA $1800,Y
                AND #$E0
                LSR
                PLP
                ROL
                STA $1800,Y
                JSR $9C84
L2_9D5D:
                RTS
                ASL $0340
                BCC L2_9D66
                JMP $0FF4
L2_9D66:
                JSR $9E74
                LDY #$00
                BIT $38
                BVC L2_9D7F
                LDA $37
                CMP #$04
                BNE L2_9D78
                JMP $9D2E
L2_9D78:
                JSR $9D85
                LDA #$02
                STA $37
L2_9D7F:
                STY $1700
                JMP $A073
                LDY $52
                JSR $9E26
                TYA
                SEC
                SBC $52
                STA $1C
                LDX $52
L2_9D92:
                LDA $1800,Y
                STA $1800,X
                INX
                INY
                BNE L2_9D92
                LDA $1700
                SEC
                SBC $1C
                TAY
                RTS
                JSR $9F08
                LDA $1700
                BEQ L2_9DBA
                LDY #$00
L2_9DAE:
                TYA
                PHA
                JSR $9DBB
                PLA
                TAY
                JSR $9E26
                BCC L2_9DAE
L2_9DBA:
                RTS
                LDX #$00
L2_9DBD:
                LDA $1801,Y
                STA $0B,X
                INY
                INX
                LDA #$00
                STA $0B,X
                INX
                CPX #$08
                BCC L2_9DBD
                DEC $0F
                DEC $11
                JMP $8DDD
                LDA #$04
                STA $25
L2_9DD8:
                LDA $29
                EOR #$01
                STA $29
                LDY $52
                JSR $9DBB
                JSR $9F0D
                DEC $25
                BNE L2_9DD8
                RTS
                LDA #$FF
                STA $24
                LDY #$00
                STY $52
L2_9DF3:
                INY
                INY
                LDX #$02
                LDA #$00
                STA $1C
L2_9DFB:
                LDA $1800,Y
                CLC
                ADC $1802,Y
                ROR
                SEC
                SBC $0B,X
                BCS L2_9E0C
                EOR #$FF
                ADC #$01
L2_9E0C:
                CLC
                ADC $1C
                STA $1C
                DEY
                DEX
                DEX
                BPL L2_9DFB
                BCS L2_9E20
                CMP $24
                BCS L2_9E20
                STA $24
                STY $52
L2_9E20:
                JSR $9E26
                BCC L2_9DF3
                RTS
                LDA $1800,Y
                AND #$1F
                CLC
                ADC #$05
                STA $1C
                TYA
                ADC $1C
                TAY
                CPY $1700
                RTS
                STA $26
                CLC
                ADC $1700
                BCS L2_9E58
                STA $1700
                STY $1C
                LDY #$FF
                TYA
                SEC
                SBC $26
                TAX
L2_9E4C:
                LDA $1800,X
                STA $1800,Y
                DEY
                DEX
                CPX $1C
                BCS L2_9E4C
L2_9E58:
                RTS
                STA $26
                LDA $1700
                SEC
                SBC $26
                STA $1700
                TYA
                CLC
                ADC $26
                TAX
L2_9E69:
                LDA $1800,X
                STA $1800,Y
                INY
                INX
                BNE L2_9E69
                RTS
                LDY #$00
L2_9E76:
                LDA $1800,Y
                STA $5B00,Y
                INY
                BNE L2_9E76
                LDA $1700
                STA $0341
                RTS
                LDY #$00
L2_9E88:
                LDA $5B00,Y
                STA $1800,Y
                INY
                BNE L2_9E88
                LDA $0341
                STA $1700
                JMP $A073
                TXA
                AND #$03
                PHA
                JSR $9E74
                PLA
                TAX
                LDY $9EBA,X
                LDX #$00
L2_9EA8:
                LDA $9EBD,Y
                STA $1800,X
                BEQ L2_9EB4
                INY
                INX
                BPL L2_9EA8
L2_9EB4:
                STX $1700
                JMP $A073
                BRK
                ASL $11
                RTI
                !by $0A
                !by $06
                STX $C3,Y
                !by $00
                !by $40
                !by $09
                !by $06
                !by $4E
                !by $C3
                !by $40
                !by $52
                !by $06
                !by $97
                !by $C3
                BRK
                RTI
                PHP
                ASL $36
                !by $C3
                RTI
                AND $6706,Y
                !by $C3
                RTI
                ROR
                ASL $98
                !by $C3
                BRK
                LDA $29
                AND #$76
                STA $29
                LDA $38
                AND #$EF
                STA $38
                LDX #$07
L2_9EEC:
                LDA $9F00,X
                STA $0B,X
                DEX
                BPL L2_9EEC
                JSR $8D70
                LDA #$B8
                STA $0B
                STA $0F
                JMP $8D70
                !by $17
                BRK
                !by $C7
                BRK
                !by $17
                BRK
                BRK
                BRK
                LDA #$00
                TAX
                BEQ L2_9F15
                LDA #$80
                BNE L2_9F13
                LDA #$00
L2_9F13:
                LDX #$FF
L2_9F15:
                STA $1F
                STX $24
                LDX #$17
                LDY #$60
                STX $02
                STY $03
                LDX #$FF
                LDY #$3E
                STX $04
                STY $05
                LDA #$19
                STA $26
L2_9F2D:
                LDY #$A0
                BIT $1F
                BMI L2_9F3E
L2_9F33:
                LDA ($04),Y
                AND $24
                STA ($02),Y
                DEY
                BNE L2_9F33
                BEQ L2_9F45
L2_9F3E:
                LDA ($02),Y
                STA ($04),Y
                DEY
                BNE L2_9F3E
L2_9F45:
                LDX #$02
                JSR $8331
                LDA $04
                CLC
                ADC #$A0
                STA $04
                BCC L2_9F55
                INC $05
L2_9F55:
                DEC $26
                BNE L2_9F2D
                RTS
                LDX $0E3D
                LDY $0E3E
                STX $02
                STY $03
                LDX #$D0
                LDY #$6A
                STX $08
                STY $09
                LDX #$08
                LDY #$0A
                CLC
                JSR $B36C
                LDA $37
                JSR $9F86
                BIT $38
                BVC L2_9F85
                LDA #$02
                JSR $9F86
                JSR $9B2C
L2_9F85:
                RTS
                ASL
                ASL
                ASL
                ASL
                TAY
                LDX #$10
L2_9F8D:
                LDA $6D50,Y
                EOR #$FF
                STA $6D50,Y
                LDA $6E90,Y
                EOR #$FF
                STA $6E90,Y
                INY
                DEX
                BNE L2_9F8D
                RTS
                LDA $0B
                SEC
                SBC #$18
                BCC L2_9FE3
                CMP #$50
                BCS L2_9FD4
                LSR
                LSR
                LSR
                LSR
                STA $1C
                LDA $0D
                SEC
                SBC #$40
                BCC L2_9FE3
                CMP #$40
                BCS L2_9FD4
                AND #$F0
                LSR
                LSR
                STA $1D
                LSR
                LSR
                ADC $1D
                ADC $1C
                TAX
                JMP ($0E41)
                LDA $9FE4,X
                !by $4C
                !by $C3
                !by $99
L2_9FD4:
                !by $A5
                !by $0D
                !by $C9
                !by $B8
                !by $90
                !by $09
                !by $A5
                !by $0B
                !by $C9
                !by $68
                !by $90
                !by $03
                !by $20
                !by $B8
                !by $8A
L2_9FE3:
                !by $60
                !by $C3
                !by $B9
                !by $76
                !by $66
                !by $B7
                !by $62
                LDA $65,X
                !by $73
                !by $74
                ADC ($61,X)
                ADC ($00,X)
                CMP ($5F,X)
                AND ($32),Y
                !by $33
                CLV
                LDX #$00
                LDY #$60
                STX $08
                STY $09
                LDX #$19
                LDY #$28
                LDA #$00
                SEC
                JSR $B36C
                JSR $B3B4
                JSR $AF0D
                JSR $9EDE
                LDA #$02
                STA $49
                LDA #$00
                STA $81
L2_A01B:
                PHA
                TAY
                LDA $A08F,Y
                JSR $0DE9
                STA $34
                TAY
L2_A026:
                LDA $0428,Y
                STA $02C0,Y
                DEY
                BPL L2_A026
                PLA
                PHA
                TAY
                LDA $A091,Y
                STA $0F
                LDA $A092,Y
                STA $11
                LDA #$00
                STA $10
                STA $12
                LDA $A090,Y
                STA $7F
                JSR $AEE2
                BCS L2_A04F
                JSR L0_818F
L2_A04F:
                PLA
                CLC
                ADC #$04
                CMP #$0C
                BCC L2_A01B
                LDX #$18
                LDY #$6C
                STX $08
                STY $09
                LDX #$08
                LDY #$0A
                LDA #$FF
                SEC
                JSR $B36C
                JSR $9F5A
                JSR $9E74
                LDA #$10
                STA $38
                JSR $9DA4
                LDA $37
                CMP #$01
                BEQ L2_A080
                CMP #$04
                BNE L2_A084
L2_A080:
                LDA #$02
                STA $37
L2_A084:
                JSR $AF0D
                LDX $37
                JSR L0_99E4
                JMP $B285
                +InsertMainScreenTextPos ; Position of texts $11, $12 a $13
                LDA #$01
                STA $72
                LDA #$00
                JSR $A107
                JMP $A076
                ASL $0340
                BCS L2_A0B2
                LDA #$40
                STA $0340
                RTS
L2_A0B2:
                LDA #$01
                STA $72
                LDA #$40
                JSR $A107
                BNE L2_A0C0
                JSR L0_837B
L2_A0C0:
                JMP $A076
                JSR $0E1B
                BCS L2_A0FE
                LDX #$05
L2_A0CA:
                LDA $A101,X
                STA $4C,X
                DEX
                BPL L2_A0CA
                LDA #$01
                STA $72
                LDA #$70
                JSR $A107
                BNE L2_A0FE
                JSR $0E24
                BCS L2_A0FE
                LDA $70
                AND #$F7
                CMP $70
                BEQ L2_A0FE
                PHA
                JSR $A738
                INC $72
                !by $68
                !by $A6
                !by $71
                !by $F0
                !by $E3
                !by $8A
                !by $20
                !by $2A
                !by $B2
                !by $A9
                !by $00
                !by $20
                !by $10
                !by $0E
L2_A0FE:
                !by $4C
                !by $76
                !by $A0
                !by $00
                !by $00
                !by $63
                !by $4F
                !by $64
                BVC $A174
                !by $43
                ASL $7085
                LDA #$00
                STA $71
                STA $D015
                LDA #$18
                LDY $1700
                BEQ L2_A18B
                LDX #$01
                LDY #$19
                STX $58
                STY $59
                BIT $70
                BVC L2_A129
                JSR $0FF4
L2_A129:
                JSR $9F08
                JSR $A19B
                JSR $A1D8
                JSR $A71B
                LDA $71
                BNE L2_A18B
                LDA $1901
                BEQ L2_A195
                LDY #$00
                JSR $A201
                LDA #$18
                BCS L2_A18B
L2_A147:
                LDY #$00
                LDA ($58),Y
                CMP #$01
                BEQ L2_A16D
                BCC L2_A195
                CMP #$02
                BNE L2_A166
                LDA $70
                ORA #$80
                STA $70
                JSR $A753
                BCS L2_A195
                LDA #$00
                STA $83
                BCC L2_A17E
L2_A166:
                JSR $A250
                BCC L2_A17E
                BCS L2_A177
L2_A16D:
                LDA #$00
                STA $83
                INC $58
                BNE L2_A177
                INC $59
L2_A177:
                JSR $A1FA
                LDA #$19
                BCS L2_A18B
L2_A17E:
                LDA $71
                BNE L2_A18B
                JSR CBM_GETIN
                CMP #$B3
                BNE L2_A147
                LDA #$1B
L2_A18B:
                STA $71
                JSR $B22A
                LDA #$00
                JSR $0E10
L2_A195:
                JSR $9E74
                LDA $71
                RTS
                LDX #$0B
L2_A19D:
                LDA $A1CC,X
                STA $79,X
                DEX
                BPL L2_A19D
                LDA #$00
                STA $3C00
                JSR $AEAA
                LDA #$00
                LDX #$0F
L2_A1B1:
                STA $0345,X
                DEX
                BPL L2_A1B1
                LDA #$FF
                LDX #$07
L2_A1BB:
                STA $023E,X
                DEX
                BPL L2_A1BB
                LDX #$78
                LDY #$04
                STX $0246
                STY $0247
                RTS
                ORA ($02,X)
                PHP
                BRK
                BRK
                BRK
                BRK
                ORA ($00,X)
                BRK
                BRK
                BRK
                LDY #$00
L2_A1DA:
                LDA $1800,Y
                ASL
                ORA $1800,Y
                ASL
                AND $1800,Y
                LSR
                AND #$40
                STA $1C
                LDA $1800,Y
                AND #$BF
                ORA $1C
                STA $1800,Y
                JSR $9E26
                BCC L2_A1DA
                RTS
                LDY $52
L2_A1FC:
                JSR $9E26
                BCS L2_A24F
                LDA $1800,Y
                BMI L2_A1FC
                STY $52
                ORA #$40
                STA $1800,Y
                AND #$1F
                TAX
                LDA $1802,Y
                STA $64
                LDA #$00
                ASL $64
                ROL
                ASL $64
                ROL
                STA $65
                TXA
                BEQ L2_A24E
                LDA $1805,Y
                CMP #$A0
                BCC L2_A237
                AND #$1C
                STA $1C
                LDA $7C
                AND #$E3
                ORA $1C
                STA $7C
                DEX
                INY
L2_A237:
                TXA
                BEQ L2_A24E
                STA $26
                LDX #$01
L2_A23E:
                LDA $1805,Y
                STA $0345,X
                INY
                INX
                CPX #$10
                BCS L2_A24E
                DEC $26
                BNE L2_A23E
L2_A24E:
                CLC
L2_A24F:
                RTS
                LDA $70
                AND #$7F
                STA $70
                JSR $A29F
                BCS L2_A29E
                JSR $A674
                LDY #$00
                LDA ($58),Y
                CMP #$0D
                BEQ L2_A277
                LDA $0D
                STA $11
                LDA #$00
                LDX #$07
L2_A26E:
                STA $0B,X
                DEX
                DEX
                BPL L2_A26E
                JSR $8D70
L2_A277:
                LDA $70
                ORA #$80
                STA $70
                JSR $A7D2
                JSR $AA2C
                TXA
                STY $1C
                SEC
                SBC $1C
                CLC
                ADC $8D
                ADC $7A
                ADC $64
                STA $64
                BCC L2_A296
                INC $65
L2_A296:
                JSR $A9EE
                STA $58
                STY $59
                CLC
L2_A29E:
                RTS
                LDA $64
                STA $0D
                LDA $65
                LSR
                ROR $0D
                LSR
                ROR $0D
                LDA $7C
                AND #$FC
                STA $7C
L2_A2B1:
                LDA $0D
                LDY $52
                CMP $1804,Y
                BCS L2_A313
                LDA $1801,Y
                STA $0B
                LDA $1803,Y
                STA $0F
                JSR $A314
                BCS L2_A2F4
                JSR $A44C
                LDA $64
                CLC
                ADC $8C
                STA $0D
                LDA $65
                ADC #$00
                LSR
                ROR $0D
                LSR
                ROR $0D
                LDA $0D
                LDY $52
                CMP $1804,Y
                BCS L2_A313
                LDA $67
                PHA
                LDA $66
                PHA
                JSR $A314
                PLA
                TAX
                PLA
                BCC L2_A307
L2_A2F4:
                LDA #$00
                STA $65
                LDA $1804,Y
                STA $0D
                ASL
                ROL $65
                ASL
                ROL $65
                STA $64
                BCC L2_A2B1
L2_A307:
                CPX $66
                BNE L2_A30F
                CMP $67
                BEQ L2_A312
L2_A30F:
                JSR $A44C
L2_A312:
                CLC
L2_A313:
                RTS
                LDY #$00
                CPY $52
                BEQ L2_A38F
                LDA $1800,Y
                AND #$40
                BEQ L2_A38F
                LDA $0D
                CMP $1802,Y
                BCC L2_A38F
                CMP $1804,Y
                BCS L2_A38F
                JSR $A3B5
                BCS L2_A38F
                LDX $0B
                CPX $1D
                ROL
                CPX $1C
                ROL
                LDX $0F
                CPX $1C
                ROL
                CPX $1D
                ROL
                AND #$0F
                BEQ L2_A38F
                CMP #$0F
                BEQ L2_A38F
                CMP #$06
                BEQ L2_A3B4
                TAX
                LDA $1C
                SEC
                SBC $0B
                STA $1C
                LDA $0F
                SEC
                SBC $1D
                STA $1D
                CPX #$03
                BNE L2_A369
                LDA $1C
                CMP $1D
                BCS L2_A36D
                BCC L2_A37F
L2_A369:
                CPX #$02
                BNE L2_A37B
L2_A36D:
                LDA #$19
                CMP $1C
                BCS L2_A3B4
                LDA $1A
                STA $0F
                LDA #$01
                BCC L2_A38B
L2_A37B:
                CPX #$07
                BNE L2_A38F
L2_A37F:
                LDA #$19
                CMP $1D
                BCS L2_A3B4
                LDA $1B
                STA $0B
                LDA #$02
L2_A38B:
                ORA $7C
                STA $7C
L2_A38F:
                JSR $9E26
                BCS L2_A397
                JMP $A316
L2_A397:
                LDA #$00
                STA $63
                STA $67
                LDA $0B
                ASL
                ROL $63
                ASL
                ROL $63
                STA $62
                LDA $0F
                SEC
                SBC $0B
                ASL
                ROL $67
                ASL
                ROL $67
                STA $66
L2_A3B4:
                RTS
                LDA $1800,Y
                AND #$A0
                CMP #$A0
                BNE L2_A3C9
                LDX #$07
                TYA
L2_A3C1:
                CMP $023E,X
                BEQ L2_A3DD
                DEX
                BPL L2_A3C1
L2_A3C9:
                LDX $1801,Y
                STX $1A
                INX
                INX
                STX $1C
                LDX $1803,Y
                STX $1B
                DEX
                DEX
                STX $1D
                CLC
                RTS
L2_A3DD:
                TXA
                ASL
                TAX
                LDA $0D
                SEC
                SBC $1802,Y
                ASL
                ROL $1D
                CLC
                ADC $0246,X
                STA $02
                LDA $1D
                AND #$01
                ADC $0247,X
                STA $03
                LDA $7B
                LSR
                LSR
                STA $1D
                LDX #$00
                LDA ($02,X)
                CMP #$FE
                BEQ L2_A428
                CLC
                ADC $1801,Y
                SEC
                SBC $1D
                BCS L2_A411
                LDA #$00
L2_A411:
                STA $1C
                STA $1A
                INC $02
                LDA ($02,X)
                CLC
                ADC $1801,Y
                ADC $1D
                BCC L2_A423
                LDA #$A0
L2_A423:
                STA $1D
                STA $1B
                CLC
L2_A428:
                RTS
                LDX #$00
                STX $1E
                LDY #$10
L2_A42F:
                ASL $1C
                ROL $1D
                ROL $1E
                TXA
                ROL
                TAX
                LDA $1E
                SEC
                SBC $26
                BCS L2_A444
                CPX #$01
                BCC L2_A448
                DEX
L2_A444:
                STA $1E
                INC $1C
L2_A448:
                DEY
                BNE L2_A42F
                RTS
                LDA #$00
                LDX #$08
L2_A450:
                STA $85,X
                DEX
                BPL L2_A450
                JSR $AA2C
                JSR $AA53
                LDA $7D
                AND #$9F
                STA $7D
                LDA $7C
                AND #$DF
                STA $7C
                LDX #$00
L2_A469:
                LDA $7F,X
                PHA
                INX
                CPX #$06
                BCC L2_A469
L2_A471:
                JSR $A9CD
                JSR $A9F9
                BCS L2_A487
                LDA #$2D
                JSR $AAA7
                BCS L2_A4E5
                LDA #$40
                JSR $AA19
                DEC $86
L2_A487:
                JSR $A512
                BCS L2_A4E5
                LDA $61
                JSR $A8B8
                BCC L2_A471
                CMP #$0D
                BEQ L2_A501
                CMP #$03
                BCC L2_A4FF
                CMP #$09
                BNE L2_A4AE
                LDA #$2D
                JSR $AAA7
                BCS L2_A4E5
                LDA #$40
                JSR $AA19
                JMP $A471
L2_A4AE:
                CMP #$2D
                BNE L2_A4BF
                JSR $AA9B
                BCS L2_A4E5
                LDA #$00
                JSR $AA19
                JMP $A471
L2_A4BF:
                CMP #$20
                BNE L2_A4D6
                INC $89
                LDX $68
                LDY $69
                LDA #$00
                JSR $AA19
                JSR $AA9B
                BCS L2_A4E5
                JMP $A471
L2_A4D6:
                BCC L2_A4E2
                CMP $3C03
                BCS L2_A4E2
                JSR $AA9B
                BCS L2_A4E5
L2_A4E2:
                JMP $A471
L2_A4E5:
                LDA $86
                BEQ L2_A4FF
                STA $85
                LDX $6A
                LDY $6B
                STX $68
                STY $69
                TAY
                DEY
                LDA ($58),Y
                CMP #$20
                BNE L2_A507
                DEC $89
                BCS L2_A507
L2_A4FF:
                DEC $85
L2_A501:
                LDA $7D
                AND #$9F
                STA $7D
L2_A507:
                LDX #$05
L2_A509:
                PLA
                STA $7F,X
                DEX
                BPL L2_A509
                JMP $AEAA
                BIT $7D
                BPL L2_A568
                LDA $83
                CMP #$E8
                BNE L2_A522
                LDX #$00
                STX $8B
                STX $8A
L2_A522:
                AND #$0F
                CMP #$08
                BEQ L2_A52C
                CMP #$0E
                BNE L2_A562
L2_A52C:
                LDA $61
                AND #$1F
                TAX
                LDA $A5F1,X
                LSR
                ROL $8B
                INC $8A
                LDA $85
                AND #$07
                ASL
                TAY
                LDA $68
                STA $022E,Y
                LDA $69
                STA $022F,Y
                LDA $8B
                CMP #$05
                BCC L2_A568
                AND #$03
                CMP #$01
                BNE L2_A568
                LDX #$03
                BIT $7D
                BVS L2_A55C
                INX
L2_A55C:
                CPX $8A
                BCS L2_A568
                BCC L2_A56A
L2_A562:
                LDA #$00
                STA $8A
                STA $8B
L2_A568:
                CLC
                RTS
L2_A56A:
                LDY $85
                DEY
                DEY
                STY $1E
                LDX #$03
L2_A572:
                LDA ($58),Y
                JSR $B296
                STA $0200,X
                DEY
                DEX
                BPL L2_A572
                LDY #$63
L2_A580:
                LDX #$03
L2_A582:
                LDA $A610,Y
                BEQ L2_A5A0
                CMP $0200,X
                BNE L2_A592
                DEX
                DEY
                BPL L2_A582
                BMI L2_A5AF
L2_A592:
                DEY
                DEY
                BMI L2_A5AF
L2_A596:
                LDA $A611,Y
                BEQ L2_A580
                DEY
                BPL L2_A596
                BMI L2_A5AF
L2_A5A0:
                LDA #$60
                CPY #$00
                BEQ L2_A5B1
                TXA
                CLC
                ADC $1E
                SEC
                SBC #$02
                STA $1E
L2_A5AF:
                LDA #$40
L2_A5B1:
                STA $1D
                LDA #$2D
                JSR $AAA7
                PHA
                LDY $1E
                INY
                TYA
                AND #$07
                ASL
                TAY
                PLA
                CLC
                ADC $022E,Y
                TAX
                ROL $1C
                CMP $66
                ROR $1C
                LDA $022F,Y
                ADC #$00
                TAY
                ROL $1C
                SBC $67
                BCS L2_A5EA
                STX $6A
                STY $6B
                LDY $1E
                STY $86
                LDA $7D
                AND #$9F
                ORA $1D
                STA $7D
                CLC
L2_A5EA:
                LDX #$01
                STX $8B
                INX
                STX $8A
                RTS
                ORA ($00,X)
                BRK
                BRK
                ORA ($00,X)
                BRK
                BRK
                ORA ($00,X)
                BRK
                BRK
                BRK
                BRK
                ORA ($00,X)
                BRK
                BRK
                !by $00
                !by $00
                !by $01
                !by $00
                !by $00
                !by $00
                !by $01
                !by $00
                !by $01
                !by $01
                !by $01
                !by $00
                !by $00
                !by $43
                !by $4B
                !by $00
                !by $42
                !by $4C
                !by $00
                !by $42
                !by $52
                !by $00
                !by $43
                !by $48
                !by $00
                !by $44
                !by $52
                !by $00
                !by $46
                !by $4C
                !by $00
                !by $46
                !by $52
                !by $00
                !by $47
                JMP $4700
                !by $52
                BRK
                !by $4B
                JMP $4B00
                !by $4E
                !by $00
                !by $4B
                !by $52
                !by $00
                !by $50
                !by $48
                !by $00
                !by $50
                !by $46
                !by $00
                !by $50
                !by $4C
                !by $00
                !by $50
                !by $52
                !by $00
                !by $53
                !by $50
                !by $00
                !by $53
                !by $54
                !by $00
                !by $54
                !by $48
                !by $00
                !by $54
                !by $52
                !by $00
                !by $5A
                !by $57
                !by $00
                !by $53
                !by $43
                !by $48
                !by $00
                !by $53
                !by $50
                !by $52
                !by $00
                !by $53
                !by $54
                !by $52
                !by $00
                !by $53
                !by $43
                !by $48
                !by $4C
                !by $00
                !by $53
                !by $43
                !by $48
                !by $4E
                !by $00
                !by $53
                !by $43
                !by $48
                !by $57
                !by $00
                !by $53
                !by $43
                PHA
                EOR $5300
                !by $43
                PHA
                !by $52
                LDA $66
                SEC
                SBC $68
                STA $6C
                STA $1E
                LDA $67
                SBC $69
                STA $6D
                LSR
                ROR $1E
                LSR
                ROR $1E
                JSR $AA53
                LDA #$10
                STA $1D
                LDA $7C
                BIT $1D
                BEQ L2_A6A0
                AND #$0F
                TAY
                LDA $7C
                AND #$20
                ORA $A70B,Y
L2_A6A0:
                AND #$2C
                BEQ L2_A6E8
                CMP #$0C
                BEQ L2_A6B3
                AND #$28
                BEQ L2_A6C6
                LSR $6D
                ROR $6C
                LSR $1E
                CLC
L2_A6B3:
                PHP
                LDA $68
                CLC
                ADC $6C
                STA $68
                LDA $69
                ADC $6D
                STA $69
                PLP
                BCC L2_A6E8
                BCS L2_A6EF
L2_A6C6:
                LDY $85
                DEY
                LDA ($58),Y
                CMP #$0D
                BEQ L2_A6E8
                LDY #$00
                LDX $89
                BEQ L2_A6F3
                LDX $6C
L2_A6D7:
                CPX $89
                LDA $6D
                SBC #$00
                BCC L2_A6F3
                STA $6D
                TXA
                SBC $89
                TAX
                INY
                BNE L2_A6D7
L2_A6E8:
                LDA $0F
                SEC
                SBC $1E
                STA $0F
L2_A6EF:
                LDX #$00
                LDY #$00
L2_A6F3:
                STX $6F
                STY $6E
                LDA $69
                STA $1C
                LDA $68
                LSR $1C
                !by $6A
                !by $46
                !by $1C
                !by $6A
                !by $18
                !by $65
                !by $0B
                !by $85
                !by $0B
                !by $C6
                !by $0F
                !by $60
                !by $00
                !by $04
                !by $00
                !by $04
                !by $04
                !by $00
                !by $0C
                !by $08
                !by $08
                !by $0C
                !by $00
                !by $04
                !by $0C
                !by $0C
                !by $04
                !by $04
                LDA $1700
                BEQ L2_A737
                LDY #$00
                STY $35
L2_A724:
                STY $52
                LDA $1800,Y
                BPL L2_A730
                JSR $B10F
                BCS L2_A737
L2_A730:
                LDY $52
                JSR $9E26
                BCC L2_A724
L2_A737:
                RTS
                LDY #$01
L2_A73A:
                LDA ($58),Y
                CMP #$22
                BEQ L2_A747
                INY
                CPY #$11
                BCC L2_A73A
                BCS L2_A752
L2_A747:
                TYA
                LDX $58
                LDY $59
                JSR CBM_SETNAM
                JSR $B0A8
L2_A752:
                RTS
                LDA #$00
                STA $85
L2_A757:
                JSR $A9CD
                CMP #$02
                BCC L2_A78C
                CMP #$0D
                BEQ L2_A78F
                CMP #$22
                BEQ L2_A798
                JSR $B296
                LDX #$08
L2_A76B:
                DEX
                BMI L2_A757
                CMP $A7A7,X
                BNE L2_A76B
                TXA
                PHA
                JSR $B2F3
                TAX
                PLA
                CPX #$00
                BEQ L2_A757
                TAY
                ASL
                TAX
                LDA $A7AE,X
                PHA
                LDA $A7AD,X
                PHA
                LDA $1A
                RTS
L2_A78C:
                JSR $A9E5
L2_A78F:
                JSR $A9EE
                STA $58
                STY $59
                CLC
                RTS
L2_A798:
                LDA $70
                ORA #$08
                !by $85
                !by $70
                !by $20
                !by $EE
                !by $A9
                !by $85
                !by $58
                !by $84
                !by $59
                !by $38
                !by $60
                !by $48
                !by $56
                !by $4B
                !by $5A
                !by $2D
                !by $4E
                !by $B8
                !by $A7
                !by $B8
                !by $A7
                !by $B8
                !by $A7
                LDX $C6A7,Y
                !by $A7
                CPY L0_99A7
                ADC $4C00,Y
                !by $57
                !by $A7
                STA $7F
                JSR $AEAA
                JMP $A757
                LSR
                ROR $7D
                JMP $A757
                STA $72
                JMP $A757
                LDA $85
                STA $86
                LDA #$00
                STA $85
                STA $88
                STA $89
                STA $87
L2_A7E0:
                JSR $A9CD
                JSR $A9F9
                CMP #$0D
                BNE L2_A7EF
                LDA #$00
                STA $84
                RTS
L2_A7EF:
                JSR $A8B8
                BCC L2_A839
                BIT $70
                BVC L2_A839
                CMP #$20
                BNE L2_A81A
                LDY $85
                CPY $86
                BCS L2_A805
                JSR $ABB7
L2_A805:
                JSR $AA9B
                INC $89
                LDA $6F
                CMP $89
                LDA $68
                ADC $6E
                STA $68
                BCC L2_A839
                INC $69
                BCS L2_A839
L2_A81A:
                BCC L2_A839
                CMP $3C03
                BCS L2_A839
                LDA $7D
                ASL
                ASL
                ASL
                LDA $61
                BCC L2_A833
                LDY $85
                CPY $86
                BCC L2_A833
                CLC
                ADC #$08
L2_A833:
                JSR $AACF
                JSR $AA9B
L2_A839:
                LDY $85
                CPY $86
                BCC L2_A7E0
                BIT $70
                BVC L2_A84C
                BIT $7D
                BVC L2_A84C
                LDA #$2D
                JSR $AACF
L2_A84C:
                RTS
                LDA #$00
                STA $8C
                STA $8D
                JSR $AEE2
                BCS L2_A8A4
                LDA #$58
                STA $62
                LDA #$30
                SEC
                SBC $78
                SBC $8C
                BCS L2_A867
                LDA #$00
L2_A867:
                LSR
                ADC #$49
                STA $64
                LDA #$00
                STA $63
                STA $65
                STA $68
                STA $69
                STA $67
                STA $6E
                STA $85
                STA $38
                STA $76
                LDA #$64
                STA $66
                LDA #$04
                STA $70
                LDY $85
                CPY #$13
                BCS L2_A8A4
                INC $85
                LDA $A8A5,Y
                STA $61
                JSR $AAA7
                !by $B0
                !by $0A
                !by $A5
                !by $61
                !by $20
                !by $CF
                !by $AA
                !by $20
                !by $9B
                !by $AA
                !by $90
                !by $E4
L2_A8A4:
                !by $60
                !by $54
                !by $68
                !by $65
                !by $20
                !by $51
                !by $75
                !by $69
                !by $63
                !by $6B
                JSR $7242
                !by $6F
                !by $77
                ROR $4620
                !by $6F
                SEI
                CMP #$20
                BCS L2_A8C7
                LDX #$10
L2_A8BE:
                CMP $A8D4,X
                BEQ L2_A8C8
                DEX
                BPL L2_A8BE
                SEC
L2_A8C7:
                RTS
L2_A8C8:
                !by $8A
                !by $0A
                !by $A8
                !by $B9
                !by $E6
                !by $A8
                !by $48
                !by $B9
                !by $E5
                !by $A8
                !by $48
                !by $60
                !by $03
                !by $04
                !by $05
                !by $0B
                !by $0C
                !by $18
                !by $19
                ASL $0706
                PHP
                ASL
                !by $0F
                !by $1A
                BPL $A8F5
                !by $12
                ROL
                LDA #$2A
                LDA #$2A
                LDA #$2A
                LDA #$2A
                LDA #$0C
                LDA #$0C
                LDA #$2A
                LDA #$3E
                LDA #$46
                LDA #$4C
                LDA #$86
                LDA #$A0
                LDA #$06
                LDA #$55
                LDA #$36
                LDA #$AC
                LDA #$A9
                BRK
                STA $82
                BEQ L2_A930
                LDA #$02
                STA $72,X
                LDY $85
                LDA ($58),Y
                CMP #$30
                BCC L2_A92B
                CMP #$39
                BCS L2_A92B
                JSR $A9CD
                AND #$0F
                STA $72,X
                LDA $90D4,X
                ORA $81
                BNE L2_A930
L2_A92B:
                LDA $90D4,X
                EOR $81
L2_A930:
                STA $81
                JSR $AA2C
                CLC
                RTS
                LDA $82
                EOR #$80
                STA $82
                CLC
                RTS
                LDA $7C
                ORA #$20
                STA $7C
                CLC
                RTS
                INC $88
                LDA $88
                BNE L2_A951
                INC $84
                LDA $84
L2_A951:
                JSR $AA74
                CLC
                RTS
                JSR $A947
                LDY $85
L2_A95B:
                STY $26
                LDA ($58),Y
                CMP #$21
                BCC L2_A985
                CMP #$2E
                BEQ L2_A985
                CMP #$2C
                BEQ L2_A985
                JSR $AAA7
                STA $1C
                LDA $68
                SEC
                SBC $1C
                TAX
                LDA $69
                SBC #$00
                BCC L2_A985
                STX $68
                STA $69
                LDY $26
                INY
                BNE L2_A95B
L2_A985:
                CLC
                RTS
                JSR $B2F3
                LDY $69
                LDA $68
                SEC
                SBC $1A
                BCS L2_A99B
                DEY
                CPY #$FF
                BNE L2_A99B
                LDA #$00
                TAY
L2_A99B:
                STA $68
                STY $69
                CLC
                RTS
                JSR $B2F3
                LDA $1A
                STA $7F
                JSR $AEAA
                CLC
                RTS
                LDA $72
                STA $1A
                LDA #$00
                STA $1B
                JSR $B2C0
                TXA
                EOR #$03
                STA $87
                LDX #$02
                LDY #$00
L2_A9C1:
                LDA $0201,Y
                STA $02C1,X
                INY
                DEX
                BPL L2_A9C1
                CLC
                RTS
                LDY $87
                BEQ L2_A9D8
                DEC $87
                LDA $02C0,Y
                BNE L2_A9E2
L2_A9D8:
                LDY $85
                LDA ($58),Y
                INC $85
                BNE L2_A9E2
                INC $59
L2_A9E2:
                STA $61
                RTS
                LDA $85
                BNE L2_A9EB
                DEC $59
L2_A9EB:
                DEC $85
                RTS
                LDA $85
                CLC
                ADC $58
                LDY $59
                BCC L2_A9F8
                INY
L2_A9F8:
                RTS
                LDY $83
                CMP #$41
                ROL $83
                CMP #$5E
                ROL $83
                CMP #$61
                ROL $83
                CMP #$7F
                ROL $83
                LDX $83
                CPX #$E8
                BNE L2_AA17
                CLC
                ADC #$20
                STA $61
                RTS
L2_AA17:
                SEC
                RTS
                STA $1C
                LDA $7D
                AND #$9F
                ORA $1C
                STA $7D
                STX $6A
                STY $6B
                LDA $85
                STA $86
                RTS
                LDX $3C02
                LDY $3C76
                LDA $81
                LSR
                BCC L2_AA3D
                TXA
                ASL
                TAX
                TYA
                ASL
                TAY
L2_AA3D:
                LDA #$04
                BIT $81
                BEQ L2_AA46
                INX
                INX
                INY
L2_AA46:
                CPX $8C
                BCC L2_AA4C
                STX $8C
L2_AA4C:
                CPY $8D
                BCC L2_AA52
                STY $8D
L2_AA52:
                RTS
                LDY $84
                LDA $0345,Y
                STA $1C
                ASL $1C
                LDA #$00
                ROL
                ASL $1C
                ROL
                TAY
                LDX $1C
                CPX $66
                SBC $67
                BCC L2_AA6F
                LDX #$00
                LDY #$00
L2_AA6F:
                STX $68
                STY $69
                RTS
                CMP #$10
                BCS L2_AA9A
                TAY
                LDA $0345,Y
                STA $1C
                ASL $1C
                LDA #$00
                ROL
                ASL $1C
                ROL
                TAY
L2_AA87:
                LDX $1C
                CPX $68
                SBC $69
                BCC L2_AA9A
                TYA
                CPX $66
                SBC $67
                BCS L2_AA9A
                STX $68
                STY $69
L2_AA9A:
                RTS
                LDA $61
                JSR $AAA7
                BCS L2_AAA6
                STX $68
                STY $69
L2_AAA6:
                RTS
                TAX
                LDA $3BE4,X
                CLC
                ADC $79
                CLC
                BPL L2_AAB3
                LDA #$00
L2_AAB3:
                BIT $81
                BPL L2_AAB8
                ASL
L2_AAB8:
                BIT $81
                BVC L2_AABE
                ADC #$01
L2_AABE:
                PHA
                ADC $68
                TAX
                LDA $69
                ADC #$00
                TAY
                TXA
                CMP $66
                TYA
                SBC $67
                PLA
                RTS
                PHA
                JSR $ABB7
                PLA
                SEC
                SBC #$20
                TAY
                LDX $75
                JSR $B336
                TXA
                CLC
                ADC $73
                STA $08
                TYA
                ADC $74
                STA $09
                LDA $81
                LSR
                AND #$08
                BEQ L2_AAFC
                LDA $64
                SEC
                SBC $76
                TAX
                LDA $65
                SBC #$00
                TAY
                BCS L2_AB12
L2_AAFC:
                LDA $3C76
                BCC L2_AB02
                ASL
L2_AB02:
                STA $1C
                LDA $8D
                SEC
                SBC $1C
                CLC
                ADC $64
                TAX
                LDA $65
                ADC #$00
                TAY
L2_AB12:
                LDA $81
                AND #$08
                BEQ L2_AB20
                CLC
                TXA
                ADC $76
                TAX
                BCC L2_AB20
                INY
L2_AB20:
                LDA $81
                AND #$04
                BEQ L2_AB30
                DEX
                BNE L2_AB30
                DEY
                BPL L2_AB30
                LDX #$00
                LDY #$00
L2_AB30:
                STX $11
                STY $12
                LDA $62
                CLC
                ADC $68
                STA $0F
                LDA $63
                ADC $69
                STA $10
                BIT $82
                BPL L2_AB59
                LDA $3C02
                LSR
                LSR $81
                BCS L2_AB4F
                LSR
                CLC
L2_AB4F:
                ROL $81
                ADC $0F
                STA $0F
                BCC L2_AB59
                INC $10
L2_AB59:
                LDA #$02
                BIT $81
                BEQ L2_AB73
                LDX $78
                LDY $78
                LDA #$00
                CLC
                JSR $AC02
                LDX #$01
                LDY #$01
                LDA #$00
                SEC
                JSR $AC02
L2_AB73:
                LDA #$04
                BIT $81
                BEQ L2_ABAD
                LDY #$00
                LDX #$00
                BIT $82
                BPL L2_AB82
                INX
L2_AB82:
                LDA $77
                CLC
                JSR $AC02
                LDY #$01
                LDX #$00
                BIT $82
                BPL L2_AB91
                INX
L2_AB91:
                LDA $77
                CLC
                JSR $AC02
                LDY #$02
                LDX #$00
                LDA $77
                CLC
                JSR $AC02
                LDX #$01
                LDY #$01
                SEC
                BIT $82
                BPL L2_ABB2
                INX
                BCS L2_ABB2
L2_ABAD:
                LDX #$00
                LDY #$00
                CLC
L2_ABB2:
                LDA #$00
                JMP $AC02
                LDA $81
                AND #$20
                BEQ L2_AC01
                LDA $3C02
                LSR
                LSR
                LSR
                ADC $8D
                ADC $64
                STA $11
                LDA $65
                ADC #$00
                STA $12
                LDA $62
                CLC
                ADC $68
                STA $0F
                LDA $63
                ADC $69
                STA $10
                LDA $61
                JSR $AAA7
                LDX $61
                CPX #$20
                BNE L2_ABE9
                ADC $6E
L2_ABE9:
                PHA
                LDX #$00
                LDY #$00
                JSR $AC85
                LDA #$02
                BIT $81
                BEQ L2_AC00
                LDX $78
                LDY $78
                PLA
                PHA
                JSR $AC85
L2_AC00:
                PLA
L2_AC01:
                RTS
                STA $25
                TYA
                AND #$01
                ROL
                STA $1F
                JSR $AD1F
                LDY #$00
L2_AC0F:
                JSR $1373
                BIT $26
                BMI L2_AC1D
                TYA
                PHA
                JSR $ACB2
                PLA
                TAY
L2_AC1D:
                BIT $82
                BPL L2_AC2E
                LDA $1F
                EOR #$02
                STA $1F
                AND #$02
                BNE L2_AC2E
                JSR $90EB
L2_AC2E:
                LDA $81
                LSR
                BCC L2_AC41
                LDA $1F
                EOR #$80
                STA $1F
                BPL L2_AC41
                TYA
                SEC
                SBC $3C01
                TAY
L2_AC41:
                CPY $75
                BEQ L2_AC80
                INC $02
                BNE L2_AC4B
                INC $03
L2_AC4B:
                INC $0D
                LDA $0D
                AND #$07
                BNE L2_AC0F
                LDA $0D
                CMP #$C8
                BCS L2_AC70
                LDA $70
                LSR
                AND #$02
                TAX
                LDA $02
                CLC
                ADC $AC81,X
                STA $02
                LDA $03
                ADC $AC82,X
                STA $03
                BCC L2_AC0F
L2_AC70:
                LDA #$00
                STA $0D
                INC $46
                TYA
                PHA
                JSR $AD60
                PLA
                TAY
                JMP $AC0F
L2_AC80:
                RTS
                SEI
                !by $02
                SEC
                ORA ($48,X)
                JSR $AD1F
                PLA
                TAX
                LSR
                LSR
                LSR
                TAY
                STY $26
                TAY
                TXA
                ORA #$F8
                TAX
                LDA #$FF
L2_AC98:
                ASL
                INX
                BNE L2_AC98
L2_AC9C:
                STA $0200,Y
                LDA #$FF
                DEY
                BPL L2_AC9C
                INC $26
                LDY $26
                LDA #$00
                STA $0200,Y
                STA $1F
                JMP $AD0A
                INC $26
                BIT $81
                BPL L2_ACD8
                ASL $26
                LDY $26
                DEY
                STY $1C
L2_ACBF:
                LDY #$04
                LDA $1C
                LSR
                TAX
L2_ACC5:
                LSR $0200,X
                PHP
                ROR
                PLP
                ROR
                DEY
                BNE L2_ACC5
                LDY $1C
                STA $0200,Y
                DEC $1C
                BPL L2_ACBF
L2_ACD8:
                LDY $26
                LDA #$00
                STA $0200,Y
                LDX $25
                BEQ L2_ACE9
                INC $26
                INY
                STA $0200,Y
L2_ACE9:
                BIT $81
                BVC L2_ACEE
                INX
L2_ACEE:
                TXA
                BEQ L2_AD0A
                STA $1C
L2_ACF3:
                LDX #$00
                LDY $26
                CLC
L2_ACF8:
                LDA $0200,X
                ROR
                ORA $0200,X
                STA $0200,X
                INX
                DEY
                BPL L2_ACF8
                DEC $1C
                BNE L2_ACF3
L2_AD0A:
                LDA $0A
L2_AD0C:
                ASL
                BCS L2_AD1C
                LDX #$00
                LDY $26
L2_AD13:
                ROR $0200,X
                INX
                DEY
                BPL L2_AD13
                BMI L2_AD0C
L2_AD1C:
                JMP $1397
                TXA
                CLC
                ADC $0F
                STA $0B
                LDA $10
                ADC #$00
                STA $0C
                TYA
                CLC
                ADC $11
                STA $0D
                LDA $12
                ADC #$00
                STA $0E
                LDA $70
                AND #$04
                BEQ L2_AD49
                JSR L0_9092
                LDA #$37
                STA $45
                LDA #$02
                STA $43
                RTS
L2_AD49:
                LDX #$00
L2_AD4B:
                LDA $0D
                SEC
                SBC #$C8
                TAY
                LDA $0E
                SBC #$00
                BCC L2_AD5E
                STY $0D
                STA $0E
                INX
                BCS L2_AD4B
L2_AD5E:
                STX $46
                LDA #$00
                STA $02
                LDA $0D
                LSR
                LSR
                LSR
                STA $03
                ASL
                ASL
                ADC $03
                LSR
                ROR $02
                STA $03
                LDA $0D
                AND #$07
                STA $1C
                LDA $0B
                AND #$F8
                ADC $1C
                ADC $02
                STA $02
                LDA $0C
                ADC $03
                LDX $46
                ORA $8314,X
                STA $03
                LDA L0_830C,X
                STA $45
                LDA L0_8310,X
                STA $43
                LDA $0B
                AND #$07
                TAY
                LDA $90D4,Y
                STA $0A
L2_ADA3:
                RTS
                ORA #$06
                ORA $20
                JSR $2D2D
                AND $602D
                LDA $61
                CMP $61A5
                CMP $3C03
                BCS L2_ADA3
                SEC
                SBC #$20
                BCC L2_ADA3
                TAY
                LDX $75
                JSR $B336
                TXA
                CLC
                ADC $73
                STA $08
                TYA
                ADC $74
                STA $09
                LDX #$02
L2_ADD0:
                LDA $0F,X
                STA $0B,X
                DEX
                BPL L2_ADD0
                JSR L0_9092
                LDY #$00
                STY $1F
L2_ADDE:
                JSR $1373
                TYA
                PHA
                LDX $26
                BMI L2_AE30
                INX
                TXA
                ASL
                ASL
                ASL
                STA $20
                LDX #$00
L2_ADF0:
                LDA $02,X
                PHA
                INX
                CPX #$0D
                BCC L2_ADF0
L2_ADF8:
                LDX $26
L2_ADFA:
                ROL $0200,X
                DEX
                BPL L2_ADFA
                ROR
                PHA
                JSR $AE86
                LDA $49
                JSR $AE94
                PLA
                BCC L2_AE28
                BIT $81
                BPL L2_AE1D
                PHA
                JSR $AE86
                LDA $49
                JSR $AE94
                PLA
                BCC L2_AE28
L2_AE1D:
                BIT $81
                BVC L2_AE24
                JSR $AE86
L2_AE24:
                DEC $20
                BNE L2_ADF8
L2_AE28:
                LDX #$0C
L2_AE2A:
                PLA
                STA $02,X
                DEX
                BPL L2_AE2A
L2_AE30:
                JSR $AE8F
                PLA
                BCC L2_AE4B
                TAY
                LDA $81
                AND #$01
                EOR $1F
                STA $1F
                LSR
                BCC L2_AE47
                TYA
                SBC $3C01
                TAY
L2_AE47:
                CPY $75
                BCC L2_ADDE
L2_AE4B:
                LDA $61
                JSR $AAA7
                STA $1C
                LDA $49
                AND #$02
                EOR #$02
                TAX
                LDA $49
                LSR
                LDA $0F,X
                LDY $10,X
                BCS L2_AE77
                ADC $1C
                BCC L2_AE67
                INY
L2_AE67:
                CMP L0_8C52,X
                BCC L2_AE7F
                PHA
                TYA
                CMP L0_8C53,X
                TAY
                PLA
                BCC L2_AE7F
                BCS L2_AE85
L2_AE77:
                SBC $1C
                BCS L2_AE7F
                SEC
                DEY
                BMI L2_AE85
L2_AE7F:
                STA $0F,X
                TYA
                STA $10,X
                CLC
L2_AE85:
                RTS
                ASL
                BCC L2_AE8E
                LDY #$00
                JSR L0_8C3D
L2_AE8E:
                RTS
                LDX $49
                LDA $AEA6,X
                CMP #$02
                BCS L2_AEA3
                ASL
                JSR L0_9133
                BCC L2_AEA2
                LDA #$B7
                CMP $0D
L2_AEA2:
                RTS
L2_AEA3:
                JMP $90E8
                !by $03
                !by $02
                BRK
                ORA ($A5,X)
                !by $7F
                BNE L2_AEB2
                LDA $80
                STA $7F
L2_AEB2:
                CMP $3C00
                BEQ L2_AEE1
                LDA $3C00
                STA $80
                JSR $12F2
                BCC L2_AEC9
                JSR $B03C
                LDA $7F
                STA $3C00
L2_AEC9:
                LDA $3C77
                STA $79
                LDA $3C02
                TAY
                LSR
                LSR
                STA $76
                LDX $3C01
                JSR $B336
                STX $75
                JSR $AA2C
L2_AEE1:
                RTS
                JSR $12F2
                BCS L2_AEEB
                JSR $AEC9
                CLC
L2_AEEB:
                RTS
                LDA #$00
                STA $4A
                STA $34
                LDA $29
                AND #$FB
                STA $29
                LDA #$80
                STA $38
                JSR $0F03
                JSR $AF0D
                JSR $B3B4
                LDA $28
                JSR L0_80DE
                JMP $B285
                LDA #$BB
                STA $D011
                LDA #$78
                STA $D018
                LDA $DD00
                AND #$FC
                ORA #$02
                STA $DD00
                LDA #$00
                STA $D01B
                STA $54
                SEI
                LDA $36
                ORA #$01
                STA $36
                CLI
                LDX #$FD
                STX $5FF8
                INX
                STX $5FF9
                INX
                STX $5FFA
                LDA #$05
                TAX
                LDY $AF72,X
                LDX #$00
                CMP #$05
                BNE L2_AF4B
                LDX #$40
;==========================================================
; RLE?
L2_AF4B:
                LDA $AF78,Y
                STA $02
                BEQ L2_AF71
L2_AF52:
                LDA $AF79,Y
                STA $7F80,X
                INX
                LDA $AF7A,Y
                STA $7F80,X
                INX
                LDA $AF7B,Y
                STA $7F80,X
                INX
                DEC $02
                BNE L2_AF52
                INY
                INY
                INY
                INY
                BNE L2_AF4B
L2_AF71:
                RTS
L2_AF72:
;==========================================================
                !by $00,$00,$15,$2B,$22,$58,$08,$00
                !by $20,$00,$02,$00,$00,$00,$01,$FF
                !by $07,$F8,$02,$00,$00,$00,$08,$00
                !by $20,$00,$00,$01,$FF,$FF,$FF,$13
                !by $80,$00,$01,$01,$FF,$FF,$FF,$00
                !by $01,$FF,$FF,$FF,$14,$80,$00,$00
                !by $00,$0A,$00,$00,$00,$01,$00,$3F
                !by $00,$01,$00,$3E,$00,$01,$00,$3C
                !by $00,$01,$00,$3E,$00,$01,$00,$37
                !by $00,$01,$00,$23,$80,$01,$00,$01
                !by $C0,$01,$00,$00,$E0,$01,$00,$00
                !by $40,$02,$00,$00,$00,$00,$14,$00
                !by $00,$01,$01,$FF,$FF,$FF,$00
L2_AFD9:
                LDA #$00
                LDY #$3F
L2_AFDD:
                STA $7F40,Y
                DEY
                BPL L2_AFDD
                RTS
                LDX #$3F
L2_AFE6:
                LDA $7F40,X
                STA $03C0,X
                DEX
                BPL L2_AFE6
                RTS
                LDX #$3F
L2_AFF2:
                LDA $03C0,X
                STA $7F40,X
                DEX
                BPL L2_AFF2
                RTS
                LDA #$12
                STA $D018
                LDA #$9B
                STA $D011
                LDA $DD00
                ORA #$03
                STA $DD00
                LDA #$00
                LDX #$3E
L2_B012:
                STA $03C0,X
                DEX
                BPL L2_B012
                LDA #$FF
                STA $03EB
                STA $03EE
                LDA #$0F
                STA $07F9
                LDA #$02
                STA $D015
                SEI
                LDA #$80
                STA $19
                STA $17
                ASL
                STA $18
                LDA $36
                AND #$FE
                STA $36
                CLI
                RTS
                LDA #$10
                JSR $0DE9
                TAY
                LDA $7F
                STA $1A
                LDA #$00
                STA $1B
                LDX #$01
                JSR $B2A1
                TYA
                LDX #$28
                LDY #$04
                JSR CBM_SETNAM
                LDA #$5A
                JSR $B1C8
                BCS L2_B0A7
                LDY #$00
L2_B060:
                JSR CBM_CHRIN
                STA $3C00,Y
                INY
                CPY #$78
                BCC L2_B060
                LDX #$78
                LDY #$3C
                STX $73
                STY $74
                STX $02
                STY $03
                BIT $70
                BPL L2_B0A4
                BVC L2_B0A4
                LDA $7F
                CMP $7E
                BEQ L2_B0A4
                STA $7E
                LDA #$00
                STA $26
                STA $27
                STA $1F
L2_B08D:
                JSR $119A
                LDY #$00
                STA ($02),Y
                INC $02
                BNE L2_B09A
                INC $03
L2_B09A:
                LDA $90
                BEQ L2_B08D
                LDA $26
                ORA $27
                BNE L2_B08D
L2_B0A4:
                JSR $B222
L2_B0A7:
                RTS
                LDA #$54
                JSR $B1C8
                BCS L2_B10E
                LDX #$01
                LDY #$19
                STX $5A
                STY $5B
                STX $58
                STY $59
L2_B0BB:
                JSR CBM_CHRIN
                LDY #$00
                STA ($5A),Y
                TAX
                BEQ L2_B0DE
                INC $5A
                BNE L2_B0BB
                INC $5B
                LDA $5B
                CMP #$3C
                BCC L2_B0BB
                DEC $5B
                DEC $5A
                LDA #$00
                TAY
                STA ($5A),Y
                LDA #$05
                BCS L2_B103
L2_B0DE:
                STA $1700
L2_B0E1:
                JSR CBM_CHRIN
                TAX
                BEQ L2_B0E1
                LDA #$18
                CPX #$4C
                SEC
                BNE L2_B103
                JSR CBM_CHRIN
                STA $1700
                LDY #$00
L2_B0F6:
                JSR CBM_CHRIN
                STA $1800,Y
                INY
                CPY $1700
                BCC L2_B0F6
                CLC
L2_B103:
                PHA
                PHP
                JSR $B222
                PLP
                PLA
                BCC L2_B10E
                STA $71
L2_B10E:
                RTS
                LDX #$20
                LDY $52
                LDA $1800,Y
                AND #$60
                CMP #$60
                BEQ L2_B123
                CLC
                BIT $70
                BVC L2_B155
                LDX #$00
L2_B123:
                STX $1F
                JSR $B1B9
                LDA #$00
                JSR $B1C8
                BCS L2_B155
                BIT $70
                BVC L2_B151
                LDY $52
                LDA $1801,Y
                LSR
                STA $2B
                CLC
                ADC $23
                CMP #$51
                BCS L2_B151
                LDA $1802,Y
                LSR
                STA $2A
                ADC $22
                CMP #$65
                BCS L2_B151
                JSR $1134
L2_B151:
                JSR $B222
                CLC
L2_B155:
                RTS
                LDA $1F
                AND #$20
                BEQ L2_B1B8
                JSR CBM_CHRIN
                CMP #$4B
                BNE L2_B1B8
                LDX #$07
L2_B165:
                LDY $023D,X
                INY
                BNE L2_B16E
                DEX
                BNE L2_B165
L2_B16E:
                LDA $22
                ASL
                ASL
                STA $1C
                LDA #$00
                ROL
                STA $1D
                TXA
                ASL
                TAY
                LDA $0246,Y
                STA $02
                CLC
                ADC $1C
                STA $04
                STA $0248,Y
                LDA $0247,Y
                STA $03
                ADC $1D
                CMP #$08
                BCS L2_B1B8
                STA $05
                STA $0249,Y
                LDA $52
                STA $023E,X
                LDY $02
                LDA #$00
                STA $02
L2_B1A4:
                JSR CBM_CHRIN
                EOR #$FF
                STA ($02),Y
                INY
                BNE L2_B1B0
                INC $03
L2_B1B0:
                CPY $04
                LDA $03
                SBC $05
                BCC L2_B1A4
L2_B1B8:
                RTS
                TYA
                CLC
                ADC #$05
                TAX
                LDA $1800,Y
                AND #$1F
                LDY #$18
                JMP $FFBD
                STA $24
                LDA $B7
                LDX $BB
                LDY $BC
                JSR $B231
                LDA #$00
L2_B1D5:
                PHA
                LDA $24
                BNE L2_B1E1
                JSR L0_8471
                BCS L2_B1F2
                PLA
                RTS
L2_B1E1:
                LDY #$00
                JSR $B209
                BCS L2_B1F2
                JSR CBM_CHRIN
                CMP $24
                BNE L2_B1F2
                PLA
                CLC
                RTS
L2_B1F2:
                JSR $B222
                PLA
                BNE L2_B203
L2_B1F8:
                JSR $0E2D
                CMP #$AD
                BEQ L2_B1D5
                CMP #$B3
                BNE L2_B1F8
L2_B203:
                LDA #$1A
                STA $71
                SEC
                RTS
                TYA
                PHA
                LDA #$08
                TAX
                JSR CBM_SETLFS
                JSR CBM_OPEN
                LDX #$08
                PLA
                BCS L2_B221
                BNE L2_B21E
                JMP CBM_CHKIN
L2_B21E:
                JSR CBM_CHKOUT
L2_B221:
                RTS
                JSR CBM_CLRCHN
                LDA #$08
                JMP $FFC3
                JSR $0DE9
                LDX #$28
                LDY #$04
                STX $02
                STY $03
                LDX #$C0
                LDY #$79
                STX $06
                STY $07
                PHA
                JSR $B27A
                PLA
                STA $1C
                LDY #$00
L2_B246:
                LDA #$01
                STA $09
                LDA ($02),Y
                ASL
                ROL $09
                ASL
                ROL $09
                ASL
                ROL $09
                STA $08
                TYA
                PHA
                LDY #$07
                LDA ($08),Y
                BNE L2_B262
                DEY
L2_B260:
                LDA ($08),Y
L2_B262:
                STA ($06),Y
                DEY
                BPL L2_B260
                LDA $06
                CLC
                ADC #$08
                STA $06
                BCC L2_B272
                INC $07
L2_B272:
                PLA
                TAY
                INY
                CPY $1C
                BCC L2_B246
                RTS
                LDY #$7F
                LDA #$00
L2_B27E:
                STA $79C0,Y
                DEY
                BPL L2_B27E
                RTS
L2_B285:
                LDA $CB
                CMP #$40
                BNE L2_B285
                LDA $3F
                AND #$07
                BNE L2_B285
                LDA #$00
                STA $C6
                RTS
                CMP #$7E
                BCS L2_B2A0
                CMP #$61
                BCC L2_B2A0
                SBC #$20
L2_B2A0:
                RTS
                TYA
                PHA
                LDY #$28
                JSR $B336
                STX $02
                TYA
                ORA #$04
                STA $03
                JSR $B2C0
                PLA
                TAY
L2_B2B4:
                LDA $0201,X
                STA ($02),Y
                INY
                INX
                CPX #$03
                BCC L2_B2B4
                RTS
                LDX #$02
L2_B2C2:
                LDA #$00
                LDY #$10
L2_B2C6:
                ROL $1A
                ROL $1B
                ROL
                CMP #$0A
                BCC L2_B2D1
                SBC #$0A
L2_B2D1:
                DEY
                BNE L2_B2C6
                ROL $1A
                ROL $1B
                ORA #$30
                STA $0201,X
                DEX
                BPL L2_B2C2
                INX
L2_B2E1:
                LDA $0201,X
                CMP #$30
                BNE L2_B2F2
                LDA #$1F
                STA $0201,X
                INX
                CPX #$02
                BCC L2_B2E1
L2_B2F2:
                RTS
                LDX #$00
                STX $1F
                STX $1A
L2_B2F9:
                JSR $A9CD
                CPX #$00
                BNE L2_B30C
                CMP #$3D
                BEQ L2_B2F9
                CMP #$2D
                BNE L2_B30C
                ROR $1F
                BMI L2_B2F9
L2_B30C:
                SEC
                SBC #$30
                BCC L2_B327
                CMP #$0A
                BCS L2_B327
                PHA
                LDA $1A
                ASL
                ASL
                ADC $1A
                ASL
                STA $1A
                PLA
                ADC $1A
                STA $1A
                INX
                BNE L2_B2F9
L2_B327:
                ASL $1F
                BCC L2_B331
                LDA #$00
                SBC $1A
                STA $1A
L2_B331:
                JSR $A9E5
                TXA
                RTS
                STX $1C
                STY $1D
                LDA #$00
                LDY #$08
L2_B33E:
                ASL
                ROL $1D
                BCC L2_B34A
                CLC
                ADC $1C
                BCC L2_B34A
                INC $1D
L2_B34A:
                DEY
                BNE L2_B33E
                TAX
                LDY $1D
                RTS
                ASL $10A0,X
L2_B354:
                ASL $1C
                ROL $1D
                ROL $1E
                SEC
                LDA $1E
                SBC $26
                BCC L2_B365
                STA $1E
                INC $1C
L2_B365:
                DEY
                BNE L2_B354
                RTS
                STX $27
                STY $86
                !by $27
                STY $26
                STA $1C
                ROR $1D
L2_B374:
                LDA $09
                PHA
                LDA $08
                PHA
                LDX $26
L2_B37C:
                LDY #$07
                LDA $1C
L2_B380:
                BIT $1D
                BMI L2_B386
                LDA ($02),Y
L2_B386:
                STA ($08),Y
                DEY
                BPL L2_B380
                LDA $02
                CLC
                ADC #$08
                STA $02
                BCC L2_B396
                INC $03
L2_B396:
                LDA $08
                CLC
                ADC #$08
                STA $08
                BCC L2_B3A1
                INC $09
L2_B3A1:
                DEX
                BNE L2_B37C
                PLA
                CLC
                ADC #$40
                STA $08
                PLA
                ADC #$01
                STA $09
                DEC $27
                BNE L2_B374
                RTS
                LDA $1704
                LSR
                LSR
                LSR
                LSR
                STA $D027
                LDA #$00
                STA $02
                LDA #$5C
                STA $03
                LDX #$18
                LDY #$27
                LDA $1704
                STY $1C
                LDY $1C
L2_B3D1:
                STA ($02),Y
                DEY
                BPL L2_B3D1
                PHA
                LDA $02
                CLC
                ADC #$28
                STA $02
                BCC L2_B3E2
                INC $03
L2_B3E2:
                !by $68
                !by $CA
                !by $10
                !by $E9
                !by $60
; data - grafika nabídek (grafické ikony)
; menu 1 line 1
                !by $FF,$80,$E6,$E6,$E6,$E6,$BE,$80
                !by $FF,$00,$7C,$66,$66,$66,$66,$00
                !by $FF,$80,$80,$80,$80,$80,$81,$83
                !by $FF,$08,$11,$23,$46,$8C,$18,$30
                !by $FF,$80,$80,$80,$80,$83,$84,$89
                !by $FF,$13,$26,$4C,$98,$B0,$E0,$C0
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$00,$00,$08,$18,$30,$60,$C0
                !by $FF,$80,$80,$80,$9F,$90,$90,$90
                !by $FF,$00,$00,$00,$FC,$04,$04,$04
                !by $FF,$80,$83,$8E,$98,$90,$B0,$A0
                !by $FF,$00,$C0,$70,$18,$08,$0C,$04
                !by $FF,$80,$84,$8A,$91,$A0,$C0,$FF
                !by $FF,$00,$00,$00,$00,$80,$60,$80
                !by $FF,$C0,$90,$C4,$91,$C4,$90,$C0
                !by $FF,$00,$00,$00,$78,$10,$28,$44
                !by $FF,$80,$80,$80,$80,$BC,$A5,$A5
                !by $FF,$00,$00,$00,$00,$1E,$12,$92
                !by $FF,$80,$98,$A4,$A4,$BD,$A5,$81
                !by $FF,$00,$00,$00,$00,$C0,$20,$C0
                !by $FF,$80,$80,$80,$80,$98,$A4,$A5
                !by $FF,$00,$00,$00,$30,$60,$C0,$80
                !by $FF,$80,$81,$83,$87,$83,$81,$81
                !by $FF,$00,$C0,$E0,$F0,$E0,$C0,$C0
                !by $FF,$80,$80,$99,$9F,$88,$88,$98
                !by $FF,$00,$00,$98,$F8,$10,$10,$18
                !by $FF,$80,$80,$80,$80,$80,$83,$8C
                !by $FF,$00,$00,$00,$00,$E0,$50,$08
                !by $FF,$80,$80,$88,$94,$90,$A0,$AC
                !by $FF,$00,$00,$10,$28,$08,$04,$34
                !by $FF,$80,$84,$8C,$94,$84,$84,$84
                !by $FF,$00,$00,$00,$00,$20,$40,$80
                !by $FF,$80,$9F,$91,$91,$91,$91,$91
                !by $FF,$00,$7C,$44,$44,$44,$44,$44
                !by $FF,$80,$80,$9F,$90,$80,$80,$80
                !by $FF,$01,$01,$FD,$85,$81,$81,$81
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$01,$01,$01,$01,$01,$01,$01
; menu 1 line 2
                !by $86,$86,$BE,$E6,$E6,$BE,$80,$FF
                !by $00,$3C,$66,$66,$66,$3C,$00,$FF
                !by $84,$84,$89,$8E,$98,$90,$80,$FF
                !by $E0,$C0,$80,$00,$00,$00,$00,$FF
                !by $8B,$97,$97,$9F,$9E,$98,$90,$FF
                !by $80,$80,$00,$00,$00,$00,$00,$FF
                !by $81,$83,$86,$8C,$88,$80,$80,$FF
                !by $80,$00,$00,$00,$00,$00,$00,$FF
                !by $90,$90,$90,$9F,$80,$80,$80,$FF
                !by $04,$04,$04,$FC,$00,$00,$00,$FF
                !by $A0,$B0,$90,$98,$8E,$83,$80,$FF
                !by $04,$0C,$08,$18,$70,$C0,$00,$FF
                !by $FF,$FE,$FC,$F8,$F0,$E0,$C0,$FF
                !by $10,$30,$68,$78,$30,$00,$00,$FF
                !by $80,$80,$80,$80,$80,$80,$80,$FF
                !by $44,$44,$44,$44,$44,$FE,$00,$FF
                !by $A5,$A5,$A5,$BC,$80,$80,$80,$FF
                !by $D2,$92,$12,$1E,$00,$00,$00,$FF
                !by $81,$81,$80,$80,$80,$80,$80,$FF
                !by $20,$CC,$12,$10,$12,$0C,$00,$FF
                !by $9F,$86,$8C,$92,$92,$8C,$80,$FF
                !by $F8,$00,$00,$00,$00,$00,$00,$FF
                !by $81,$8F,$8F,$9F,$9F,$80,$80,$FF
                !by $C0,$F8,$F8,$FC,$FC,$00,$00,$FF
                !by $98,$88,$88,$9F,$99,$80,$80,$FF
                !by $18,$10,$10,$F8,$98,$00,$00,$FF
                !by $94,$91,$92,$88,$87,$80,$80,$FF
                !by $44,$14,$44,$18,$E0,$00,$00,$FF
                !by $B3,$A1,$A1,$92,$8C,$80,$80,$FF
                !by $CC,$84,$84,$48,$30,$00,$00,$FF
                !by $81,$82,$84,$80,$80,$80,$80,$FF
                !by $30,$48,$08,$10,$20,$78,$00,$FF
                !by $91,$91,$91,$91,$91,$9F,$80,$FF
                !by $44,$44,$44,$44,$44,$7C,$00,$FF
                !by $80,$80,$80,$80,$80,$81,$80,$FF
                !by $81,$81,$81,$81,$81,$C1,$01,$FF
                !by $00,$00,$00,$00,$00,$00,$00,$FF
                !by $00,$00,$00,$00,$00,$00,$00,$FF
                !by $00,$00,$00,$00,$00,$00,$00,$FF
                !by $01,$01,$01,$01,$01,$01,$01,$FF
; menu 2 line 1
                !by $FF,$80,$E6,$E6,$E6,$E6,$BE,$80
                !by $FF,$00,$7C,$66,$66,$66,$66,$00
                !by $FF,$80,$80,$80,$80,$8F,$88,$8A
                !by $FF,$00,$E0,$50,$28,$F8,$28,$A0
                !by $FF,$80,$9F,$90,$90,$97,$94,$94
                !by $FF,$00,$FC,$04,$04,$C4,$44,$44
                !by $FF,$80,$80,$81,$83,$87,$8F,$9F
                !by $FF,$00,$00,$00,$00,$FC,$F8,$F0
                !by $FF,$80,$80,$81,$83,$87,$8F,$83
                !by $FF,$00,$80,$C0,$E0,$F0,$F8,$E0
                !by $FF,$80,$80,$82,$83,$83,$83,$83
                !by $FF,$00,$00,$20,$60,$E0,$E0,$E0
                !by $FF,$80,$80,$80,$80,$9F,$8F,$87
                !by $FF,$00,$00,$40,$60,$F0,$F8,$FC
                !by $FF,$80,$80,$81,$83,$80,$89,$9A
                !by $FF,$00,$80,$C0,$E0,$00,$C8,$2C
                !by $FF,$80,$80,$81,$83,$80,$88,$99
                !by $FF,$00,$80,$C0,$E0,$00,$88,$8C
                !by $FF,$80,$BF,$BF,$BF,$BF,$BF,$BF
                !by $FF,$00,$F0,$F0,$F0,$F0,$FE,$FE
                !by $FF,$80,$BF,$BF,$BF,$BF,$BC,$BC
                !by $FF,$00,$F0,$F0,$F0,$F0,$0E,$0E
                !by $FF,$80,$BF,$A0,$A0,$A0,$A3,$A3
                !by $FF,$00,$F0,$10,$10,$10,$FE,$F2
                !by $FF,$80,$80,$80,$88,$80,$80,$80
                !by $FF,$00,$00,$00,$88,$00,$00,$00
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$01,$03,$07,$0F,$1F,$3F,$7F
                !by $FF,$80,$80,$81,$83,$80,$8F,$8F
                !by $FF,$00,$80,$C0,$E0,$00,$F8,$78
                !by $FF,$80,$83,$81,$80,$80,$8F,$8F
                !by $FF,$00,$E0,$C0,$80,$00,$F8,$78
                !by $FF,$80,$80,$80,$8F,$8F,$8F,$8F
                !by $FF,$00,$00,$00,$F8,$78,$78,$F8
                !by $FF,$80,$83,$84,$88,$88,$88,$8F
                !by $FF,$01,$F9,$11,$21,$21,$25,$ED
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$01,$01,$01,$01,$01,$01,$01
                !by $86,$86,$BE,$E6,$E6,$BE,$80,$FF
                !by $00,$3C,$66,$66,$66,$3C,$00,$FF
                !by $8A,$8A,$8A,$8A,$88,$8F,$80,$FF
                !by $A0,$A0,$A0,$A0,$20,$E0,$00,$FF
                !by $97,$90,$90,$90,$90,$9F,$80,$FF
                !by $C4,$04,$04,$04,$04,$FC,$00,$FF
                !by $8F,$87,$83,$81,$80,$80,$80,$FF
                !by $F8,$FC,$00,$00,$00,$00,$00,$FF
                !by $83,$83,$83,$83,$82,$80,$80,$FF
                !by $E0,$E0,$E0,$60,$20,$00,$00,$FF
                !by $83,$8F,$87,$83,$81,$80,$80,$FF
                !by $E0,$F8,$F0,$E0,$C0,$80,$00,$FF
                !by $8F,$9F,$80,$80,$80,$80,$80,$FF
                !by $F8,$F0,$60,$40,$00,$00,$00,$FF
                !by $B9,$9A,$89,$80,$83,$81,$80,$FF
                !by $CE,$2C,$C8,$00,$E0,$C0,$80,$FF
                !by $B8,$98,$89,$80,$83,$81,$80,$FF
                !by $8E,$8C,$C8,$00,$E0,$C0,$80,$FF
                !by $BF,$BF,$BF,$83,$83,$83,$80,$FF
                !by $FE,$FE,$FE,$FE,$FE,$FE,$00,$FF
                !by $BC,$BC,$BC,$83,$83,$83,$80,$FF
                !by $0E,$0E,$0E,$FE,$FE,$FE,$00,$FF
                !by $A3,$A3,$BF,$82,$82,$83,$80,$FF
                !by $F2,$F2,$F2,$02,$02,$FE,$00,$FF
                !by $88,$80,$80,$80,$88,$80,$80,$FF
                !by $88,$00,$00,$00,$88,$00,$00,$FF
                !by $80,$81,$83,$87,$8F,$9F,$BF,$FF
                !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                !by $8F,$8F,$8E,$8F,$8F,$8F,$80,$FF
                !by $78,$F8,$38,$F8,$F8,$F8,$00,$FF
                !by $8F,$8F,$8E,$8F,$8F,$8F,$80,$FF
                !by $78,$F8,$38,$F8,$F8,$F8,$00,$FF
                !by $8E,$8F,$8F,$8F,$80,$80,$80,$FF
                !by $38,$F8,$F8,$F8,$00,$00,$00,$FF
                !by $90,$BF,$A0,$A0,$BF,$80,$80,$FF
                !by $15,$E5,$29,$31,$E1,$01,$01,$FF
                !by $00,$00,$00,$00,$00,$00,$00,$FF
                !by $00,$00,$00,$00,$00,$00,$00,$FF
                !by $00,$00,$00,$00,$00,$00,$00,$FF
                !by $01,$01,$01,$01,$01,$01,$01,$FF
                !by $FF,$80,$9F,$90,$90,$9F,$9F,$9F
                !by $FF,$00,$FC,$04,$04,$FC,$FC,$FC
                !by $FF,$80,$9F,$90,$90,$97,$97,$97
                !by $FF,$00,$FC,$04,$04,$E4,$E4,$E4
                !by $FF,$80,$9F,$90,$91,$91,$91,$91
                !by $FF,$00,$FC,$04,$E4,$E4,$E4,$E4
                !by $9F,$9F,$9F,$90,$90,$9F,$80,$FF
                !by $FC,$FC,$FC,$04,$04,$FC,$00,$FF
                !by $97,$90,$90,$90,$90,$9F,$80,$FF
                !by $E4,$04,$04,$04,$04,$FC,$00,$FF
                !by $91,$91,$91,$90,$90,$9F,$80,$FF
                !by $E4,$E4,$E4,$04,$04,$FC,$00,$FF
                !by $FF,$80,$80,$81,$81,$81,$F9,$F9
                !by $FF,$00,$00,$C0,$C0,$C0,$CF,$CF
                !by $FF,$80,$B0,$B8,$AC,$A6,$B2,$BA
                !by $FF,$00,$06,$0E,$1A,$32,$26,$2E
                !by $FF,$80,$B0,$B8,$AC,$A6,$B2,$BA
                !by $FF,$00,$02,$02,$02,$32,$3A,$2E
                !by $FF,$80,$B0,$B8,$AC,$A6,$B2,$BA
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$01,$03,$07,$0F,$1F,$3F,$7F
                !by $FF,$80,$80,$80,$80,$8F,$88,$8A
                !by $FF,$41,$A1,$51,$29,$F5,$29,$A1
                !by $81,$81,$87,$83,$81,$80,$80,$FF
                !by $C0,$C0,$F0,$E0,$C0,$80,$00,$FF
                !by $AE,$A6,$A0,$A0,$A0,$A0,$80,$FF
                !by $3A,$32,$02,$02,$02,$02,$00,$FF
                !by $AE,$A6,$A0,$A0,$A0,$A0,$80,$FF
                !by $26,$32,$1A,$0E,$06,$02,$00,$FF
                !by $AE,$A6,$A0,$A1,$A1,$A0,$80,$FF
                !by $FE,$66,$CC,$98,$F0,$00,$00,$FF
                !by $80,$81,$83,$87,$8F,$9F,$BF,$FF
                !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
                !by $8A,$8A,$8A,$8A,$88,$8F,$80,$FF
                !by $A1,$A1,$A1,$A1,$21,$E1,$01,$FF
                !by $FF,$80,$80,$9F,$90,$80,$80,$80
                !by $FF,$00,$00,$FC,$84,$80,$80,$80
                !by $FF,$80,$E0,$90,$9F,$98,$94,$94
                !by $FF,$00,$00,$00,$FD,$06,$04,$0C
                !by $FF,$80,$81,$83,$81,$80,$9F,$8F
                !by $FF,$00,$00,$80,$C0,$E0,$F0,$F8
                !by $FF,$80,$84,$8A,$91,$A0,$C0,$FF
                !by $FF,$00,$00,$00,$00,$80,$60,$80
                !by $FF,$80,$83,$84,$88,$88,$88,$8F
                !by $FF,$01,$F9,$11,$21,$21,$25,$ED
                !by $80,$80,$80,$80,$80,$81,$80,$80
                !by $80,$80,$80,$80,$80,$C0,$00,$00
                !by $94,$94,$98,$9F,$91,$E2,$84,$88
                !by $14,$24,$44,$FC,$00,$00,$00,$00
                !by $87,$83,$81,$80,$80,$80,$80,$80
                !by $00,$80,$C8,$F8,$78,$78,$F8,$00
                !by $FF,$FE,$FC,$F8,$F0,$E0,$C0,$80
                !by $10,$30,$68,$78,$30,$00,$00,$00
                !by $90,$BF,$A0,$A0,$BF,$80,$80,$80
                !by $15,$E5,$29,$31,$E1,$01,$01,$01
                !by $FF,$80,$80,$9F,$90,$90,$90,$90
                !by $FF,$00,$00,$FC,$A4,$A4,$A4,$A4
                !by $FF,$80,$80,$88,$9C,$9D,$9D,$9D
                !by $FF,$00,$00,$00,$00,$00,$40,$58
                !by $FF,$80,$80,$80,$84,$8C,$9C,$9F
                !by $FF,$00,$00,$00,$00,$00,$00,$FC
                !by $FF,$80,$90,$B0,$90,$90,$91,$82
                !by $FF,$00,$00,$00,$00,$00,$00,$80
                !by $FF,$80,$80,$80,$82,$83,$8F,$8F
                !by $FF,$01,$11,$11,$11,$11,$91,$D1
                !by $90,$9F,$90,$9F,$90,$9F,$80,$80
                !by $A4,$A4,$24,$E4,$04,$FC,$00,$00
                !by $9D,$9D,$9D,$9D,$9C,$8B,$80,$80
                !by $58,$58,$40,$10,$10,$F8,$00,$00
                !by $9F,$9C,$9C,$80,$80,$80,$80,$80
                !by $FC,$00,$00,$00,$00,$00,$00,$00
                !by $80,$81,$83,$80,$80,$80,$80,$80
                !by $80,$00,$98,$04,$08,$04,$18,$00
                !by $8F,$83,$82,$80,$80,$80,$80,$80
                !by $91,$11,$11,$11,$11,$11,$11,$01
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$80,$80,$80,$80,$80,$80,$80
                !by $FF,$00,$00,$00,$00,$00,$00,$00
                !by $FF,$80,$80,$80,$80,$8F,$88,$8A
                !by $FF,$01,$E1,$51,$29,$F9,$29,$A1
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $80,$80,$80,$80,$80,$80,$80,$80
                !by $00,$00,$00,$00,$00,$00,$00,$00
                !by $8A,$8A,$8A,$8A,$88,$8F,$80,$80
                !by $A1,$A1,$A1,$A1,$21,$E1,$01,$01
                !by $FF,$80,$E6,$E6,$E6,$E6,$BE,$80
                !by $FF,$00,$7C,$66,$66,$66,$66,$00
                !by $FF,$80,$9F,$90,$90,$90,$90,$90
                !by $FF,$00,$FC,$04,$04,$04,$04,$04
                !by $FF,$80,$9F,$91,$91,$91,$91,$91
                !by $FF,$00,$7C,$44,$44,$44,$44,$44
                !by $FF,$80,$9D,$95,$95,$95,$95,$95
                !by $FF,$00,$DC,$54,$54,$54,$54,$54
                !by $FF,$80,$80,$81,$81,$81,$F9,$F9
                !by $FF,$01,$01,$C1,$C1,$C1,$CF,$CF
                !by $86,$86,$BE,$E6,$E6,$BE,$80,$FF
                !by $00,$3C,$66,$66,$66,$3C,$00,$FF
                !by $90,$90,$90,$90,$90,$9F,$80,$FF
                !by $04,$04,$04,$04,$04,$FC,$00,$FF
                !by $91,$91,$91,$91,$91,$9F,$80,$FF
                !by $44,$44,$44,$44,$44,$7C,$00,$FF
                !by $95,$95,$95,$95,$95,$9D,$80,$FF
                !by $54,$54,$54,$54,$54,$DC,$00,$FF
                !by $81,$81,$87,$83,$81,$80,$80,$FF
                !by $C1,$C1,$F1,$E1,$C1,$81,$01,$FF
                !by $FF,$80,$9F,$80,$9F,$80,$9F,$80
                !by $FF,$00,$F8,$00,$C0,$00,$FC,$00
                !by $FF,$80,$9F,$80,$9F,$80,$9F,$80
                !by $FF,$00,$FC,$00,$FC,$00,$FC,$00
                !by $FF,$80,$8F,$80,$83,$80,$9F,$80
                !by $FF,$00,$F8,$00,$E0,$00,$FC,$00
                !by $FF,$80,$8F,$80,$80,$80,$9F,$80
                !by $FF,$00,$FC,$00,$FC,$00,$FC,$00
                !by $FF,$80,$9F,$80,$9F,$80,$9F,$80
                !by $FF,$00,$F8,$00,$E0,$00,$FC,$00
                !by $FF,$80,$9F,$80,$9F,$80,$9F,$80
                !by $FF,$00,$FC,$00,$FC,$00,$FC,$00
                !by $FF,$80,$8F,$80,$83,$80,$9F,$80
                !by $FF,$00,$F8,$00,$E0,$00,$FC,$00
                !by $FF,$80,$8F,$80,$80,$80,$9F,$80
                !by $FF,$00,$FC,$00,$FC,$00,$FC,$00
                !by $FF,$80,$80,$90,$88,$84,$82,$81
                !by $FF,$00,$00,$04,$08,$10,$20,$40
                !by $FF,$80,$9F,$80,$9E,$80,$9E,$80
                !by $FF,$00,$FC,$00,$00,$00,$00,$00
                !by $FF,$80,$9F,$80,$9F,$80,$9F,$80
                !by $FF,$00,$FC,$00,$E0,$00,$00,$00
                !by $FF,$80,$9F,$80,$9F,$80,$9F,$80
                !by $FF,$00,$FC,$00,$FC,$00,$FC,$00
                !by $9F,$80,$9F,$80,$9F,$80,$9F,$80
                !by $80,$00,$F0,$00,$C0,$00,$F8,$00
                !by $9F,$80,$9F,$80,$9F,$80,$9F,$80
                !by $FC,$00,$FC,$00,$FC,$00,$FC,$00
                !by $87,$80,$87,$80,$83,$80,$8F,$80
                !by $F0,$00,$F0,$00,$E0,$00,$F8,$00
                !by $81,$80,$87,$80,$83,$80,$9F,$80
                !by $FC,$00,$FC,$00,$FC,$00,$FC,$00
                !by $9F,$80,$9F,$80,$9F,$80,$9F,$80
                !by $3F,$20,$20,$20,$20,$20,$20,$20
                !by $9E,$80,$9C,$80,$9F,$80,$9C,$80
                !by $3F,$20,$20,$20,$20,$20,$20,$20
                !by $8F,$80,$9F,$80,$87,$80,$8F,$80
                !by $3F,$20,$20,$20,$20,$20,$20,$20
                !by $FE,$82,$82,$82,$82,$82,$82,$82
                !by $7C,$00,$7C,$00,$7C,$00,$7C,$00
                !by $80,$81,$82,$84,$88,$90,$80,$80
                !by $80,$40,$20,$10,$08,$04,$00,$00
                !by $9E,$80,$9E,$80,$9E,$80,$9F,$80
                !by $00,$00,$00,$00,$00,$00,$FC,$00
                !by $9E,$80,$9F,$80,$9F,$80,$9F,$80
                !by $00,$00,$00,$00,$E0,$00,$FC,$00
                !by $9F,$80,$9F,$80,$9F,$80,$9F,$80
                !by $FC,$00,$FC,$00,$FC,$00,$FC,$00

}
* = $8000

!if .language = 0 {
!bin "zs-cs.bin"
}

!if .language = 1 {
!bin "zs-de.bin"
}

!if .language = 2 {
!bin "zs-de.bin"
}