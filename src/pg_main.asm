!initmem $ff
!source "pg_kernal.asm"
!source "pg_colors.asm"
!source "pg_24.asm"

cs = 0
de = 1
en = 2	;not implemented

;set language
language = cs

;1 =enable, 2 = disable 24 pin mod (native pg-24.prg)
pg24 = 0

!if language = cs {
    !source "pg_cs.asm"
    !to "build/pagefox-cs-2.5.bin", plain
	VIZA_LEN = (VIZA_CS_OUT - VIZA_CS_IN)
	VIZA_IN = VIZA_CS_IN
	VIZA_OUT = VIZA_CS_OUT
}

!if language = de {
    !source "pg_de.asm"
    !to "build/pagefox-de-1.0.bin", plain
	VIZA_LEN = (VIZA_DE_OUT - VIZA_DE_IN)
	VIZA_IN = VIZA_DE_IN
	VIZA_OUT = VIZA_DE_OUT
}

!if language = en {                                                                              
    !source "pg_en.asm"                                                                         
    !to "build/pagefox-en-1.0.bin", plain    
	VIZA_LEN = (VIZA_DE_OUT - VIZA_DE_IN)
	VIZA_IN = VIZA_DE_IN
	VIZA_OUT = VIZA_DE_OUT	
} 

* = 0

!pseudopc $8000 {

L_8000:
    ;  header / signature
    !by $31, $80
    !by $BB, $0E, $C3, $C2, $CD, $38
    !by $30,$50,$46,$20,$56,$31,$2E,$30
    JMP $8045
    JMP $92BA
    JMP $9039
    JMP $9747
    JMP $957C
    JMP $915D                        ; read dir
    JMP $9258
    JMP $977F
    JMP $98A2
    JMP $8ECC
    JMP $9474
    SEI
    JSR $FDA3
    LDA $DC01
    AND #$10
    BEQ L_8042
    JSR L_8F6A						; cold start init
!if pg24 = 1 {
    JMP pg24_boot
	} else {
    JMP $0DA8						; go to main menu
	}
L_8042:
    JMP (L_A000)
    LDX #$FE
    TXS 
    JSR L_90B0
L_804B:
    JSR L_8054
    JSR L_8BA1
    JMP L_804B
; ----------------------------------
L_8054:
    JSR L_949D                     ; get character from imput device?
L_8057:
    BEQ L_8077
    STA $61                        ; break point
    BIT $55
    BPL L_8064
    PHA 
L_8060:
    JSR L_973E
    PLA 
L_8064:
    CMP #$A0
    BCS L_806B
    JMP $80C0
; ----------------------------------
L_806B:
    SBC #$A0
    ASL
    TAX
    LDA L_8078+1,X
    PHA
    LDA L_8078,X
    PHA

; ---------------------------------
; Text command RUN/STOP - C= + T
; ---------------------------------
L_8077:
    RTS

; ---------------------------------
; Text address table
; Values $A0–$C3 from macro InsertKeybMap
; ---------------------------------
L_8078:
    !word L_8261-1					; CURSOR DOWN
    !word L_8211-1					; CURSOR UP
    !word L_8253-1					; CURSOR RIGHT
    !word L_81FB-1					; CURSOR LEFT

    !word L_827F-1					; CLR/HOME
    !word L_82B0-1					; SHIFT-CLR/HOME
    !word L_82DE-1					; F1
    !word L_8303-1					; F2

    !word L_82B8-1					; F3
    !word L_82D3-1					; F4
    !word L_8313-1					; F5
    !word L_831E-1					; F6

    !word L_832C-1					; SHIFT RETURN
    !word L_80F0-1					; RETURN
L_8094:
    !word L_80F0-1					; CTRL RETURN
    !word L_8104-1					; INST/DEL

    !word L_80FF-1					; SHIFT-INST/DEL
    !word L_811D-1					; F7
    !word L_8519-1					; F8
    !word L_8077-1					; RUN/STOP (points to RTS only)
 
	!word L_8530-1					; C= ARROW LEFT
    !word L_87DF-1					; C= L
    !word L_8749-1					; C= S
    !word $0DA7						; C= P - go to main menu

    !word $0DA7						; C= Q - go to main menu
    !word $0DAD						; C= G - go to graphic editor
    !word L_898A-1					; C= D
    !word L_8541-1					; C= C

    !word L_8529-1					; C= M
    !word L_9433-1					; C= ARROW UP
    !word L_8997-1					; C= F
    !word L_89BD-1					; C= R

    !word L_8B45-1					; C= F1-F8
    !word L_8B83-1					; C= CLR/HOME
L_80BC:
    !word L_8B9B-1					; C= V
    !word L_8077-1					; C= T
    CMP #$20
    BCC L_80E6
    LDY $23
    LDA ($58),Y
    CMP #$02
    BCC L_80EA
    CMP #$0D
    BEQ L_80EA
    LDA $61
    STA ($58),Y
    LDX $58
    LDY $59
    STX $02
    STY $03
    LDX $22
L_80DE:
    LDA $66
    JSR print_msg
    JMP L_8253
L_80E6:
    CMP #$03
    BCC L_80F2
L_80EA:
    JSR L_8132
    JMP L_8253
; ---------------------------------
; Text command SHIFT RETURN
; ---------------------------------
L_80F0:
    LDA #$0D
L_80F2:
    JSR L_8130
    BCS L_80FE
    LDA $23
    STA $66
    JSR L_8253
L_80FE:
    RTS 
; ---------------------------------
; Text command SHIFT INST/DEL
; ---------------------------------
L_80FF:
    LDA #$20
    JMP L_8130
; ---------------------------------
; Text command INST/DEL
; ---------------------------------
L_8104:
    LDY $23
    LDA ($58),Y
    CMP #$0D
    BEQ L_8110
    CMP #$02
    BCS L_8119
L_8110:
    JSR L_81FB
    LDY $23
    LDA ($58),Y
    BEQ L_811C
L_8119:
    JSR L_8190
L_811C:
    RTS 
; ---------------------------------
; Text command F7
; ---------------------------------
L_811D:
    LDY $23
    LDA ($58),Y
    CMP #$0D
    BEQ L_812D
    LDA #$0D
    JSR L_8130
    JMP L_83A5
L_812D:
    JMP L_8190
L_8130:
    STA $61
L_8132:
    LDA $5A
    TAX 
    SEC 
    SBC $58
    LDA $5B
    TAY 
    SBC $59
    STA $1C
    INX 
    BNE L_8147
    INY 
    CPY #$3C
    BCS L_8189
L_8147:
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
    BNE L_8164
    INC $09
L_8164:
    JSR L_81D8
    LDY $23
    LDA $61
    STA ($58),Y
    INC $66
    LDA $66
    CMP #$29
    BCS L_8184
    LDX $58
    LDY $59
    STX $02
    STY $03
    LDX $22
L_817F:
    JSR print_msg
    CLC 
    RTS 
L_8184:
    JSR L_83A5
    CLC 
    RTS 
L_8189:
    LDA #$05						; msg. no.
    JSR L_9747						; print "Preteceni pameti"
    SEC 
L_818F:
    RTS 
L_8190:
    LDA $5A
    TAY 
    SEC 
    SBC $58
    LDA $5B
    SBC $59
    TAX 
    INX 
    TYA 
    BNE L_81A1
    DEC $5B
L_81A1:
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
    BNE L_81BA
    INC $03
L_81BA:
    JSR L_81EA
    DEC $66
    LDA $23
    CMP $66
    BCS L_81D5
    LDX $58
    LDY $59
    STX $02
    STY $03
    LDX $22
    LDA $66
    JSR print_msg
    RTS 
L_81D5:
    JMP L_83A5
L_81D8:
    LDY #$00
L_81DA:
    DEY 
    LDA ($02),Y
    STA ($08),Y
    TYA 
    BNE L_81DA
    DEC $03
    DEC $09
    DEX 
    BNE L_81DA
L_81E9:
    RTS 
L_81EA:
    LDY #$00
L_81EC:
    LDA ($02),Y
    STA ($08),Y
    INY 
    BNE L_81EC
    INC $03
    INC $09
    DEX 
    BNE L_81EC
    RTS 
L_81FB:
    LDA $23
    BNE L_8206
    JSR L_8382
    LDA $23
    BEQ L_820B
L_8206:
    DEC $23
    JMP L_9660
L_820B:
    LDA #$27
    STA $23
    BNE L_8214
; ---------------------------------
; Text command CURSOR UP
; ---------------------------------
L_8211:
    JSR L_8382
L_8214:
    LDA $22
    CMP #$03
    BEQ L_8234
    JSR L_8463
    LDA $58
L_821F:
    SEC 
    SBC $02
    STA $66
    JSR L_8332
    DEC $22
    LDX $02
    LDY $03
    STX $58
    STY $59
    JMP L_9660
L_8234:
    JSR L_8421
    LDX $56
    LDY $57
    STX $58
    STY $59
    STX $02
    STY $03
    JSR L_84A8
    STA $66
    JSR L_8332
    LDX #$03
    JSR L_8482
    JMP L_9660
; ---------------------------------
; Text command CURSOR RIGHT
; ---------------------------------
L_8253:
    INC $23
    LDA $23
    CMP $66
    BCC L_825E
    JMP L_83A5
L_825E:
    JMP L_9660

; ---------------------------------
; Text command CURSOR DOWN
; ---------------------------------
L_8261:
    LDA $58
    CLC 
    ADC $66
    STA $02
    LDA $59
    ADC #$00
    STA $03
    JSR L_84A8
    TAY 
    JSR L_8334
    LDA $23
    CLC 
    ADC $66
    STA $23
    JMP L_83A5
L_827F:
    LDA $22
    CMP #$03
    BNE L_8291
    LDA $23
    BNE L_8291
    LDX #$01
    LDY #$19
    STX $56
    STY $57
L_8291:
    LDX $56
    LDY $57
    STX $58
    STY $59
    STX $02
    STY $03
    JSR L_84A8
    STA $66
    LDA #$00
    STA $23
    LDX #$03
    STX $22
    JSR L_8482
    JMP L_9660
; ---------------------------------
; Text command SHIFT-CLR/HOME
; ---------------------------------
L_82B0:
    JSR L_833C
    LDA #$12
    JMP L_8354
; ---------------------------------
; Text command F3
; ---------------------------------
L_82B8:
    LDA $5A
    CMP $0342
    LDA $5B
    SBC $0343
    BCC L_82B0
    LDX $0342
L_82C7:
    LDY $0343
    STX $58
    STY $59
    LDA #$0A
    JMP L_8354
; ---------------------------------
; Text command F4
; ---------------------------------
L_82D3:
    LDX $58
    LDY $59
    STX $0342
    STY $0343
    RTS 
; ---------------------------------
; Text command F1
; ---------------------------------
L_82DE:
    LDX $56
    LDY $57
    STX $02
    STY $03
    LDA #$12
    STA $26
L_82EA:
    JSR L_84A8
    BCC L_8300
    CLC 
    ADC $02
    STA $02
    STA $56
    BCC L_82FC
    INC $03
    INC $57
L_82FC:
    DEC $26
    BNE L_82EA
L_8300:
    JMP L_8291
; ---------------------------------
; Text command F2
; ---------------------------------
L_8303:
    LDA #$12
    STA $26
L_8307:
    JSR L_8421
    BEQ L_8310
L_830C:
    DEC $26
    BNE L_8307
L_8310:
    JMP L_8291
; ---------------------------------
; Text command F5
; ---------------------------------
L_8313:
    JSR L_8382
    LDY $66
L_8318:
    DEY 
    STY $23
    JMP L_9660
; ---------------------------------
; Text command F6
; ---------------------------------
L_831E:
    LDA $23
    BEQ L_8313
L_8322:
    JSR L_8382
    LDA #$00
    STA $23
    JMP L_9660
; ---------------------------------
; Text command SHIFT RETURN
; ---------------------------------
L_832C:
    JSR L_8322
    JMP L_8261
L_8332:
    LDY $66
L_8334:
    DEY 
    CPY $23
    BCS L_833B
    STY $23
L_833B:
    RTS 
L_833C:
    LDY #$00
L_833E:
    LDA ($58),Y
    BEQ L_8349
    INY 
    BNE L_833E
    INC $59
    BNE L_833E
L_8349:
    TYA 
    CLC 
    ADC $58
    STA $58
    BCC L_8353
    INC $59
L_8353:
    RTS 
L_8354:
    LDX $58
    LDY $59
    STX $56
    STY $57
    STA $26
L_835E:
    JSR L_8421
    BEQ L_8367
    DEC $26
    BNE L_835E
L_8367:
    LDX #$58
    JSR L_84D7
    STX $22
    LDX $56
    LDY $57
    STX $02
    STY $03
    LDX #$03
    JSR L_8482
L_837B:
    LDA #$00
    STA $23
L_837F:
    JMP L_83A5
L_8382:
    LDA $22
    CMP #$03
    BEQ L_8395
    JSR L_8463
    JSR L_84A8
    CLC 
    ADC $02
    CMP $58
    BNE L_83A5
L_8395:
    LDX $58
    LDY $59
    STX $02
    STY $03
    JSR L_84A8
    CMP $66
    BNE L_83A5
    RTS 
L_83A5:
    LDA $58
    CLC 
    ADC $23
    STA $58
    BCC L_83B0
    INC $59
L_83B0:
    JSR L_8463
    STX $22
    TXA 
    PHA 
    LDA $02
    PHA 
    LDA $03
    PHA 
L_83BD:
    LDA $58
    SEC 
    SBC $02
    STA $23
    JSR L_84A8
    STA $66
    BCC L_83E0
    LDA $23
    CMP $66
    BCC L_83E0
    INC $22
    LDA $02
    CLC 
    ADC $66
    STA $02
    BCC L_83BD
    INC $03
    BCS L_83BD
L_83E0:
    LDX $02
    LDY $03
    STX $58
    STY $59
    JSR L_8332
L_83EB:
    LDA $22
    CMP #$18
    BCC L_8413
    PLA 
    PLA 
    PLA 
    LDA #$03
    PHA 
    LDX $56
L_83F9:
    LDY $57
    STX $02
    STY $03
    JSR L_84A8
    CLC 
    ADC $56
    STA $56
    PHA 
    LDA $57
    ADC #$00
    STA $57
    PHA 
    DEC $22
    BNE L_83EB
L_8413:
    PLA 
    STA $03
    PLA 
    STA $02
    PLA 
    TAX 
    JSR L_8482
    JMP L_9660
L_8421:
    LDA $56
    SEC 
    SBC #$28
    STA $56
    BCS L_842C
    DEC $57
L_842C:
    LDY #$27
    LDA #$FF
    STA $6A
L_8432:
    LDA ($56),Y
    BEQ L_8455
    CMP #$02
    BEQ L_8456
    CPY #$27
    BEQ L_8450
    CMP #$01
    BEQ L_8455
    CMP #$0D
    BEQ L_8455
    CMP #$2D
    BEQ L_844E
    CMP #$20
    BNE L_8450
L_844E:
    STY $6A
L_8450:
    DEY 
    BPL L_8432
    LDY $6A
L_8455:
    INY 
L_8456:
    TYA 
    CLC 
    ADC $56
    STA $56
    BCC L_8460
    INC $57
L_8460:
    CPY #$28
    RTS 
L_8463:
    LDA $56
    STA $02
L_8467:
    LDA $57
    STA $03
    LDX #$04
L_846D:
    CPX $22
    BCS L_8480
L_8471:
    JSR L_84A8
    CLC 
    ADC $02
    STA $02
    BCC L_847D
    INC $03
L_847D:
    INX 
    BNE L_846D
L_8480:
    DEX 
    RTS 
L_8482:
    TXA 
    PHA 
    JSR L_84A8
    BCC L_849F
    PHA 
    JSR print_msg
    PLA 
    CLC 
    ADC $02
    STA $02
    BCC L_8497
    INC $03
L_8497:
    PLA 
    TAX 
    INX 
    CPX #$19
    BCC L_8482
    RTS 
L_849F:
    JSR print_msg
    PLA 
    TAX 
    INX 
    JMP L_964F
L_84A8:
    LDY #$00
    LDA #$28
    STA $6A
L_84AE:
    LDA ($02),Y
    INY 
    CMP #$01
    BCC L_84C0
    BEQ L_84C0
    CMP #$02
    BNE L_84C2
    CPY #$01
    BEQ L_84C2
    DEY 
L_84C0:
    TYA 
    RTS 
L_84C2:
    CMP #$0D
    BEQ L_84C0
    CMP #$20
    BEQ L_84CE
    CMP #$2D
    BNE L_84D0
L_84CE:
    STY $6A
L_84D0:
    CPY #$28
    BCC L_84AE
    LDA $6A
    RTS 
L_84D7:
    LDA $56
    STA $02
    LDA $57
    STA $03
    LDA #$03
    STA $26
L_84E3:
    LDA $00,X
    SEC 
    SBC $02
    STA $1C
    LDA $01,X
    SBC $03
    BCC L_8510
    BEQ L_84F6
    LDA #$FF
    STA $1C
L_84F6:
    JSR L_84A8
    CMP $1C
    BEQ L_84FF
    BCS L_8514
L_84FF:
    CLC 
    ADC $02
    STA $02
    BCC L_8508
    INC $03
L_8508:
    INC $26
    LDA $26
    CMP #$19
    BCC L_84E3
L_8510:
    LDA #$00
    STA $1C
L_8514:
    LDX $26
    LDA $1C
    RTS 
; ---------------------------------
; Text command F8
; ---------------------------------
L_8519:
    JSR L_8643
    BCS L_8528
    JSR L_8578
    JSR L_85B1
    JSR L_83A5
    CLC 
L_8528:
    RTS 
; ---------------------------------
; Text command C= M
; ---------------------------------
L_8529:
    JSR L_8519
    BCS L_8528
    BCC L_8549
; ---------------------------------
; Text command C= ARROW LEFT
; ---------------------------------
L_8530:
    BIT $5C
    BPL L_8572
    LDA $58
    CLC 
    ADC $23
    TAX 
    LDA $59
    ADC #$00
    TAY 
    BCC L_854E
; ---------------------------------
; Text command C= C
; ---------------------------------
L_8541:
    JSR L_8643
    BCS L_8572
    JSR L_8578
L_8549:
    JSR L_860E
    BCS L_8572
L_854E:
    LDA $5A
    SEC 
    ADC $6C
    LDA $5B
    ADC $6D
    CMP #$3C
    BCS L_8573
    STX $02
    STY $03
    TXA 
    PHA 
    TYA 
    PHA 
    JSR L_85E1
    PLA 
    STA $09
    PLA 
    STA $08
    JSR L_858E
    JSR L_83A5
L_8572:
    RTS 
L_8573:
    LDA #$05						; msg. no.
    JMP L_9747						; print "Preteceni pameti" 
L_8578:
    LDX $5D
    LDY $5E
    STX $02
    STY $03
    LDX #$00						;$3F00
    LDY #$3F
    STX $08
    STY $09
    LDX $6D
    INX 
    JMP L_81EA
L_858E:
    LDY #$00
    STY $02
    LDA #$3F						;$3F00
    STA $03
    LDX $6C
    LDA $6D
    STA $1C
L_859C:
    LDA ($02),Y
    STA ($08),Y
    INY 
    BNE L_85A7
    INC $03
    INC $09
L_85A7:
    DEX 
    CPX #$FF
    BNE L_859C
    DEC $1C
    BPL L_859C
    RTS 
L_85B1:
    LDX $5F
    LDY $60
    INX 
    BNE L_85B9
    INY 
L_85B9:
    STX $02
    STY $03
L_85BD:
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
    JSR L_81EA
    LDA $5A
    CLC 
    SBC $6C
    STA $5A
    LDA $5B
    SBC $6D
    STA $5B
    RTS 
L_85E1:
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
    JSR L_81D8
    LDA $5A
    SEC 
    ADC $6C
    STA $5A
    LDA $5B
    ADC $6D
    STA $5B
    RTS 
L_860E:
    LDA #$07						; msg. no.
    JSR L_9747						; print "Označ cil a potvrd ..."
L_8613:
    JSR $9474						; get character from imput device?
    CMP #$A0
    BCC L_8613
    CMP #$B3
    BEQ L_863E
    CMP #$AD
    BEQ L_862A
    BCS L_8613
    JSR L_8064
    JMP L_8613
L_862A:
    LDA $58
L_862C:
    CLC 
    ADC $23
    PHA 
    LDA $59
    ADC #$00
    PHA 
    JSR L_973E
    PLA 
    TAY 
    PLA 
    TAX 
    CLC 
    RTS 
L_863E:
    JSR L_973E
L_8641:
    SEC 
L_8642:
    RTS 
L_8643:
    LDY $23
    LDA ($58),Y
    SEC 
    BEQ L_8642
    LDA #$06						; msg. no.
    JSR L_9747						; print "Oznac konec a potvrd"
    JSR L_8382
    LDA $56
    PHA 
    LDA $57
    PHA 
L_8658:
    LDA $22
    PHA 
    LDA $58
L_865D:
    CLC 
    ADC $23
    STA $5D
    STA $5F
    LDA $59
    ADC #$00
    STA $5E
    STA $60
L_866C:
    JSR L_86EF
L_866F:
    JSR $9474						; get character from imput device?
    CMP #$A0
L_8674:
    BCC L_866F
    CMP #$B3
    BEQ L_86A0
L_867A:
    CMP #$AD
    CLC 
    BEQ L_86A0
    CMP #$AD
    BCS L_866F
    JSR L_8064
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
    BCS L_866C
    SEC 
L_86A0:
    ROL $1C
    LDY #$00
    LDA ($5F),Y
    BNE L_86B0
    LDA $5F
    BNE L_86AE
    DEC $60
L_86AE:
    DEC $5F
L_86B0:
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
    BCS L_86DF
    LDA #$80
    STA $5C
    LDA $5F
    SEC 
    SBC $5D
    STA $6C
    LDA $60
    SBC $5E
    STA $6D
L_86DF:
    LDX #$03
    JSR L_8482
    JSR L_9142
    JSR L_973E
    JSR L_83A5
    PLP 
    RTS 
L_86EF:
    LDX #$5F
    JSR L_8734
    INX 
    BNE L_86F8
    INY 
L_86F8:
    STX $08
    STY $09
    LDX #$5D
    JSR L_8734
    STX $1C
    STY $1D
    LDA #$D8
    STA $03
    LDA #$00
    STA $02
    LDY #$78
L_870F:
    LDX $1701
    CPY $1C
    LDA $03
    SBC $1D
    BCC L_8725
    CPY $08
    LDA $03
    SBC $09
    BCS L_8725
    LDX $1703
L_8725:
    TXA 
    STA ($02),Y
    INY 
    BNE L_870F
L_872B:
    INC $03
    LDA $03
    CMP #$DC
    BCC L_870F
    RTS 
L_8734:
    JSR L_84D7
    PHA 
    LDY #$28
    JSR multiply_x_y				; multiply X with Y
    STX $1C
    PLA 
    CLC 
    ADC $1C
    TAX 
    TYA 
    ADC #$D8
    TAY 
    RTS 
; ---------------------------------
; Text command C= S 
; ---------------------------------
L_8749:
; Nastavení rozsahu textu k uložení
    LDX #$01
    LDY #$19
    STX $5D							; $5D/$5E = začátek textu ($1901)
    STY $5E
    LDX $5A
    LDY $5B
    STX $5F							; $5F/$60 = konec textu (z $5A/$5B)
    STY $60
    LDX #$D9						; Dialog - výběr rozsahu? (pointer na $87D9)
    LDY #$87
    STX $04
    STY $05
    JSR L_9598						; Zobraz dialog
    BCS L_87D6						; Zrušeno -> konec
    BEQ L_8770						; OK bez výběru -> pokračuj
    JSR L_9660
    JSR L_8643						; Označ blok textu
    BCS L_87D6
L_8770:
    LDA #$03						; msg. no. 03
    JSR L_957C						; print "Nazev"
    BCS L_87D6
    LDY #$01
    JSR L_9297						; set file prameter and open
    BCS L_87CE
; === Zápis 'T' (signatura textu) ===
    LDA #$54						; 'T'
    JSR CBM_CHROUT					; Output vetor
; === Zápis textových dat ===
    LDY $5D
    LDA #$00
    STA $5D
L_8789:
    LDA ($5D),Y						; Čti bajt textu
    JSR CBM_CHROUT					; Zapiš na disk
L_878E:
    LDA $90
    BNE L_87CE						; Chyba I/O
    CPY $5F							; Konec textu
    BNE L_879C
    LDA $5E
    CMP $60
    BEQ L_87A3						; Ano -> pokračuj na layout
L_879C:
    INY 
    BNE L_8789
    INC $5E
    BNE L_8789
L_87A3:
; === Zápis $00 (ukončení textu) ===
    LDA #$00
    JSR CBM_CHROUT					; Output Vector
; === Zápis 'L' (signatura layout) ===
    LDA #$4C						; 'L'
    JSR CBM_CHROUT
; === Zápis délky layout dat ===
    LDA $1700						; Počet bajtů layoutu (n × 5)
    JSR CBM_CHROUT
; === Zápis layout dat (rámečky + obrázky) ===
; Formát záznamu:
; $40,X1/4,Y1/4,X2/4,Y2/4 = textový rámeček (5 bajtů)
; $Cn,X1/4,Y1/4,X2/4,Y2/4,filename = obrázek (5+n bajtů)
; kde n = délka názvu souboru (dolní nibble flags)
; Souřadnice jsou v jednotkách 4 bodů 
    LDY #$00
L_87B5:
    LDA $1800,Y						; Layout data z $1800
    JSR CBM_CHROUT
    INY 
    CPY $1700
    BCC L_87B5
; === Zápis barev ($1701-$170C) === 
	LDY #$00
L_87C3:
    LDA $1701,Y						; Barvy a další nastavení
    JSR CBM_CHROUT
    INY 
    CPY #$0C						; 12 bajtů
    BCC L_87C3
L_87CE:
    JSR L_92B2						; restore i/o and close?
    LDA #$00
    JSR L_9258
L_87D6:
    JMP L_9660
    !by $0A,$01,$02,$00,$06,$0E
; ---------------------------------
; Text command C= L
; ---------------------------------
L_87DF:
    LDA #$00
    JSR L_915D						;read dir
    BCS L_882C
    LDY #$02
    JSR L_9297						; Otevři soubor pro čtení
; === Kontrola signatury 'T' ===
    JSR CBM_CHRIN					; Přečti první bajt
    LDX #$00
    CMP #$54						; Je to 'T'?
    BEQ L_880D						; Ano -> nativní PageFox formát
; Není 'T' -> dialog pro výběr formátu (ASCII, atd.)
    JSR CBM_CLRCHN
    LDX #$41
    LDY #$88
    STX $04
    STY $05
    JSR L_9598
    BCS L_8824
    PHA 
    LDX #$08
    JSR CBM_CHKIN
    PLA 
    TAX 
    INX 
L_880D:
    STX $24							; $24 = typ formátu (0=PageFox, 1-4=jiné)
    JSR L_8849						; Načti textová data
    BCS L_8825
    BIT $1F
    BPL L_8824						
    LDA $24
    BNE L_8824						; Pokud není PageFox, přeskoč layout
; === Načtení layout sekce (jen pro PageFox) ===
    JSR L_8956						; Načti 'L' + layout data
    BCS L_8824
    JSR L_897A						; Načti barvy
L_8824:
    CLC 
L_8825:
    PHP 
    JSR L_92B2						; Zavři soubor
    PLP 
    BCS L_8831
L_882C:
    LDA #$00
    JSR L_9258
L_8831:
; Překresli obrazovku
    LDX $56
    LDY $57
    STX $02
    STY $03
    LDX #$03
    JSR L_8482
    JMP L_83A5
    ; Definice klikacich poli pro vetu 1D (ASCII, ..., VIZA)
    !by $1D, $01, $04, $00, $07, $12, $22, $28
L_8849:
    BIT $1F
    BPL L_8853
    LDX #$01
    LDY #$19
    BNE L_8857
L_8853:
    LDX $5A
    LDY $5B
L_8857:
    STX $5F
    STY $60
    LDA #$00
    STA $5C
    LDX #$00
    LDY #$3F
    STX $02
    STY $03
L_8867:
    JSR CBM_CHRIN
    JSR L_88E3
    BCS L_8894
L_886F:
    TAX 
    BEQ L_8899
    LDY #$00
    STA ($02),Y
    INC $02
    BNE L_887C
    INC $03
L_887C:
    LDX $5F
    LDY $60
    INX 
    BNE L_8890
    INY 
    CPY #$3C
    BCC L_8890
    LDA #$05						; msg. no.
    JSR L_9747						; print "Preteceni pameti"
    SEC 
    BCS L_8899
L_8890:
    STX $5F
    STY $60
L_8894:
    LDA $90
    BEQ L_8867
    CLC 
L_8899:
    PHP 
    BIT $1F
    BPL L_88B3
    JSR L_90C2
    STX $56
    STY $57
    STX $58
    STY $59
    LDA #$00
    STA $23
    LDA #$03
    STA $22
    BNE L_88BE
L_88B3:
    LDA $58
    CLC 
    ADC $23
    TAX 
    LDA $59
    ADC #$00
    TAY 
L_88BE:
    LDA $5F
    CLC 
    SBC $5A
    STA $6C
    LDA $60
    SBC $5B
    STA $6D
    BCC L_88E1
    STX $02
    STY $03
    TXA 
    PHA 
    TYA 
    PHA 
    JSR L_85E1
    PLA 
    STA $09
    PLA 
    STA $08
    JSR L_858E
L_88E1:
    PLP 
    RTS 
L_88E3:
    LDX $24
    BEQ L_8920
    CPX #$04
    BNE L_88FB
    LDY #VIZA_LEN
L_88ED:
    DEY 
    BMI L_88FA
    CMP VIZA_IN,Y
    BNE L_88ED
    LDA VIZA_OUT,Y
    BCS L_8920
L_88FA:
    DEX 
L_88FB:
    DEX 
    BEQ L_8913
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
    ORA L_8922,Y
L_8913:
    CMP #$80
    BCS L_8921
    CMP #$20
    BCS L_8920
    CMP #$0D
    SEC 
    BNE L_8921
L_8920:
    CLC 
L_8921:
    RTS 
L_8922:
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

; ---------------------------------
; Načtení layout sekce ze souboru
; ---------------------------------
; Čte 'L' signaturu, délku a layout data
; Layout data obsahují textové rámečky a pozice obrázků:
; $40,X1/4,Y1/4,X2/4,Y2/4 = textový rámeček (5 bajtů)
; $Cn,X1/4,Y1/4,X2/4,Y2/4,filename = obrázek (5+n bajtů)
; kde n = délka názvu souboru (dolní nibble flags)
; ---------------------------------
L_8956:
    JSR CBM_CHRIN					; Čti bajt
    TAX 
    BEQ L_8956						; Přeskoč $00
    CMP #$4C						; Je to 'L'?
    SEC 
    BNE L_8979						; Ne -> chyba
; === Načti délku layoutu ===
    JSR CBM_CHRIN
    STA $1700						; Ulož délku (počet bajtů)
; === Načti layout data (rámečky) ===
    LDY #$00
L_8969:
    JSR CBM_CHRIN
    STA $1800,Y						; Ulož do $1800+
    INY 
    CPY $1700
    BCC L_8969
L_8975:
    JSR L_907B						; Zpracuj layout data?
    CLC 
L_8979:
    RTS 
L_897A:
    LDY #$00
L_897C:
    JSR CBM_CHRIN					; Čti bajt
    STA $1701,Y						; Ulož do $1701+ (barvy)
    INY 
    LDA $90							; Kontrola konce souboru
    BEQ L_897C						; Pokračuj dokud není EOF
    JMP L_9142						; Aplikuj barvy na obrazovku
; ---------------------------------
; Text command C= D
; ---------------------------------
L_898A:
    LDA #$02
    JSR L_957C
    BCS L_8994
    JSR L_9258
L_8994:
    JMP L_9660
; ---------------------------------
; Text command C= F
; ---------------------------------
L_8997:
    LDY #$00
    JSR L_8A08
    BCS L_89B8
    LDA #$00
L_89A0:
    JSR L_8A6F
    BCS L_89B8
    LDA #$0E						; msg. no.
    JSR L_9747						; print "RETURN=Dale"
L_89AA:
    JSR $9474
    BEQ L_89AA
    CMP #$AD
    BNE L_89B8
L_89B3:
    LDA $0355
    BCS L_89A0
L_89B8:
    JSR L_9660
    JMP L_973E
; ---------------------------------
; Text command C= R
; ---------------------------------
L_89BD:
    LDY #$00
    JSR L_8A08
    BCS L_89B8
    LDY #$21
    JSR L_8A08
L_89CA:
    BCS L_89B8
    LDA #$00
    STA $1F
L_89D0:
    JSR L_8A6F
    BCS L_89B8
    LDA #$0F						; msg. no.
    JSR L_9747						; print "RETURN=Nahradit..."
L_89DA:
    JSR $9474
    CMP #$B3
    BEQ L_89B8
    BIT $1F
    BMI L_89FB
    TAX 
    BEQ L_89DA
    LDA $0355
    CPX #$20
    BEQ L_89D0
    CPX #$AD
    BEQ L_89FB
    CPX #$AC
    BNE L_89B8
    LDA #$80
    STA $1F
L_89FB:
    JSR L_8AD2
    LDA $0376
    BCC L_89D0
    LDA #$05						; msg. no.
    JMP L_9747						; print "Preteceni pameti"
L_8A08:
    STY $85
    JSR L_8A64
    LDY $85
    LDA $0355,Y
    BEQ L_8A40
    TAX 
    DEX 
    CLC 
    ADC $85
    TAY 
L_8A1A:
    LDA $0355,Y
    STA $0430,X
    DEY 
    DEX 
    BPL L_8A1A
    LDA #$08
    LDY #$01
    JSR L_9664
L_8A2B:
    JSR $9474
    BEQ L_8A2B
    CMP #$AD
    BEQ L_8A62
    SEI 
    LDX $C6
    STA $0277,X
    INC $C6
    CLI 
    JSR L_8A64
L_8A40:
    JSR L_94DB
    BCS L_8A63
    SEC 
    TAX 
    ORA $85
    BEQ L_8A63
    LDY $85
    TXA 
    STA $0355,Y
    BEQ L_8A62
    CLC 
    ADC $85
    TAY 
    DEX 
L_8A58:
    LDA $0430,X
    STA $0355,Y
L_8A5E:
    DEY 
    DEX 
    BPL L_8A58
L_8A62:
    CLC 
L_8A63:
    RTS 
L_8A64:
    LDA #$0C
    LDY $85
    BEQ L_8A6C
    LDA #$0D						; msg. no.
L_8A6C:
    JMP L_9747						; print "Novy"
L_8A6F:
    SEI 
    CLC 
    ADC $23
    ADC $58
    STA $02
    LDA $59
    ADC #$00
    STA $03
L_8A7D:
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
    BCS L_8AC7
    LDY #$00
L_8A96:
    LDA ($02),Y
    BIT $54
    BPL L_8A9F
    JSR L_944B
L_8A9F:
    STA $1C
L_8AA1:
    LDA $0356,Y
    CMP #$09
    BEQ L_8AB3
    BIT $54
    BPL L_8AAF
    JSR L_944B
L_8AAF:
    CMP $1C
    BNE L_8AC9
L_8AB3:
    INY 
    CPY $0355
    BCC L_8A96
    LDX $02
    LDY $03
    STX $58
    STY $59
L_8AC1:
    LDA #$0A						; msg. no.
    JSR L_8354
    CLC 
L_8AC7:
    CLI 
    RTS 
L_8AC9:
    INC $02
    BNE L_8ACF
    INC $03
L_8ACF:
    JMP L_8A7D
L_8AD2:
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
L_8AE2:
    ADC $59
    TAY 
    LDA $0376
    SEC 
    SBC $0355
L_8AEC:
    BEQ L_8B29
    BCC L_8B0D
    STA $6C
    DEC $6C
    CLC 
    ADC $5A
    LDA $5B
    ADC #$00
    CMP #$3C
    BCS L_8B3F
    STX $02
    STY $03
    TXA 
    PHA 
    TYA 
    PHA 
    JSR L_85E1
    JMP L_8B25
L_8B0D:
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
    JSR L_85B1
L_8B25:
    PLA 
    TAY 
    PLA 
    TAX 
L_8B29:
    STX $02
    STY $03
    LDY $0376
L_8B30:
    BEQ L_8B3B
    DEY 
L_8B33:
    LDA $0377,Y
    STA ($02),Y
    DEY 
    BPL L_8B33
L_8B3B:
    JSR L_83A5
    CLC 
L_8B3F:
    PLA 
    STA $6D
    PLA 
    STA $6C
    RTS
; ---------------------------------
; Text command C= F1 - F8
; ---------------------------------
L_8B45:
    LDA #$09                        ; msg. no.
    JSR L_9747                      ; print "F1=Text ...."
L_8B4B:
    JSR $9474
    CMP #$B3
    BEQ L_8B80
    CMP #$AA
    BNE L_8B5F
    INC $1702
    LDX $1702
    STX $D021
L_8B5F:
    CMP #$B1
    BNE L_8B66
    INC L_D020
L_8B66:
    CMP #$A8
    BNE L_8B73
    INC $1701
    JSR L_9142
    JMP L_8B4B
L_8B73:
    CMP #$A6
    BNE L_8B4B
    INC $1703
    JSR L_9136
    JMP L_8B4B
L_8B80:
    JMP L_973E

; ---------------------------------
; Text command C= CLR/HOME
; ---------------------------------
L_8B83:
    LDA #$08                        ; msg. no.
    JSR L_9747                      ; print "Volnych znaku:"
    LDA #$00
    CLC 
    SBC $5A
    STA $1A
    LDA #$3C
    SBC $5B
    STA $1B
    LDX #$01
    LDY #$0F
    JMP L_9682
; ---------------------------------
; Text command C= V
; ---------------------------------
L_8B9B:
    LDA #$1E						; msg. no.
    JMP L_9747						; print "Pagefox version"
L_8BA1:
    LDA $3F
    ASL 
    ASL 
    ORA $3F
    AND #$24
    CMP #$04
    BNE L_8BE3
    LDA #$FF
    STA $3F
    JSR L_8E0A
    JSR L_8EAA
L_8BB7:
    JSR CBM_GETIN
    CMP #$B3
    BEQ L_8BDD
    BIT $36
    BPL L_8BC5
    JSR $8DB3
L_8BC5:
    LDA $3F
    ASL 
    ASL 
    ORA $3F
    AND #$24
    CMP #$04
    BNE L_8BB7
    LDA #$FF
    STA $3F
    JSR $8DB3
    JSR L_8BE4
    BCC L_8BB7
L_8BDD:
    JSR L_90D3
    JSR L_9660
L_8BE3:
    RTS 
L_8BE4:
    JSR L_8C09
    BCS L_8C08
    BEQ L_8C08
    CMP #$9F
    BEQ L_8BF7
    BCS L_8BFC
    JSR $8C6C
    CLC 
    BCC L_8C08
L_8BF7:
    JSR $8CC9
    SEC 
    RTS 
L_8BFC:
    PHA 
    JSR L_90D3
    JSR L_9660
    PLA 
    JSR L_8057
    SEC 
L_8C08:
    RTS 
L_8C09:
    LDA $0B
    SEC 
    SBC #$50
    BCC L_8C38
    CMP #$A0
    BCS L_8C38
    LSR 
    LSR 
    LSR 
    LSR 
    STA $1C
    LDA $0D
    SEC 
    SBC #$48
    BCC L_8C38
L_8C21:
    CMP #$50
    BCS L_8C38
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
    LDA L_8C3A,X
L_8C36:
    CLC 
    RTS 
L_8C38:
    SEC 
    RTS 
L_8C3A:
    !by $00
    !by $00
    !by $00
L_8C3D:
    !by $00
    !byte $00
    !byte $00
    !byte $00
    !byte $01
    !byte $02
    !byte $9F
    !by $00
    !by $00
    !by $00
    !by $00
    !byte $00
    !byte $00
    !byte $00
    !byte $03
    !byte $04
    !byte $9F
    !by $00
    !by $00
    !byte $00
    !byte $00
L_8C52:
    !byte $00
L_8C53:
    !byte $00
    !byte $00
L_8C55:
    !byte $05
    !by $06, $9F
    !by $11, $09
    !by $08
    !byte $0F
    !by $0A 
    !by $10,$0D
    !by $0E, $0B, $0C
    !byte $B2
    !byte $BB
    !by $BC, $BE, $BF
    !by $B5, $B6
    !by $BA
    !by $B8
    LDA $08C9,Y
    BCC L_8C90
    PHA 
    TXA 
    SEC 
    SBC #$1E
    JSR L_8E8E
    PLA 
    SEC 
    SBC #$08
    LDX #$00
    CMP #$08
    BCC L_8C85
L_8C82:
    AND #$07
    INX 
L_8C85:
    TAY 
    LDA $8CC1,Y
    EOR $81,X
    STA $81,X
    CLC 
    BCC L_8CBD
L_8C90:
    TAY 
    DEY 
    BNE L_8C97
    SEC 
L_8C95:
    BCS L_8C9B
L_8C97:
    DEY 
    BNE L_8CA1
    CLC 
L_8C9B:
    JSR $0DC6
    CLC 
    BCC L_8CBD
L_8CA1:
    LDX #$00
    DEY 
    BEQ L_8CB7
    DEY 
    BEQ L_8CAD
    INX 
    DEY 
    BEQ L_8CB7
L_8CAD:
    LDA $77,X
    CMP #$08
    BCS L_8CBF+1
    INC $77,X
    BCC L_8CBD
L_8CB7:
    LDA $77,X
    BEQ L_8CBF+1
    DEC $77,X
L_8CBD:
    !byte $20
    TAX 
L_8CBF:
    STX L_8060
    RTI 
    JSR $0810
    !byte $04
    !byte $02
    ORA ($A4,X)
    !byte $23
    BEQ L_8CD9
    LDA #$20
L_8CCF:
    CMP ($58),Y
    BEQ L_8CD6
    DEY 
    BPL L_8CCF
L_8CD6:
    INY 
    STY $23
L_8CD9:
    LDY #$00
    BIT $82
    BVC L_8D2C
    STY $23
    LDY $59
    LDX $58
    BNE L_8CE8
    DEY 
L_8CE8:
    DEX 
    STX $02
    STY $03
    LDY #$00
    LDA ($02),Y
    CMP #$0D
    BEQ L_8CFF
    CMP #$02
    BCC L_8CFF
    LDA #$0D
    STA $3F00
    INY 
L_8CFF:
    LDX #$02
L_8D01:
    LDA L_8DA8,X
    STA $3F00,Y
    INY 
    DEX 
    BPL L_8D01
    TYA 
    PHA 
    LDA $7F
    STA $1A
    LDA #$00
    STA $1B
    JSR L_96A1
    PLA 
    TAY 
L_8D1A:
    LDA $0201,X
    STA $3F00,Y
L_8D20:
    INY 
    INX 
    CPX #$05
    BCC L_8D1A
    LDA #$0D
    STA $3F00,Y
    INY 
L_8D2C:
    BIT $82
    BPL L_8D36
    LDA #$11
    STA $3F00,Y
    INY 
L_8D36:
    LDA $81
    STA $1C
    LDX #$07
L_8D3C:
    LSR $1C
    BCC L_8D67
    LDA L_8DAB,X
    STA $3F00,Y
    INY 
    CMP #$18
    BNE L_8D57
    LDA $77
    CMP #$02
    BEQ L_8D67
    ORA #$30
    STA $3F00,Y
    INY 
L_8D57:
    CMP #$19
    BNE L_8D67
    LDA $78
    CMP #$02
    BEQ L_8D67
    ORA #$30
    STA $3F00,Y
    INY 
L_8D67:
    DEX 
    BPL L_8D3C
    DEY 
    BMI L_8DA7
    STY $6C
    LDA #$00
    STA $6D
    LDA #$80
    STA $5C
    JSR L_8530
    LDA $82
    AND #$80
    ORA $81
    BEQ L_8DA7
    LDA #$06						; msg. no.
    JSR L_9747						; print "Oznac konec..."
    JSR L_90D3
    JSR L_9660
    JSR L_8613
    BCS L_8DA7
    LDY $23
    LDA #$20
L_8D96:
    CMP ($58),Y
    BEQ L_8DA0
    INY 
    CPY $66
    BCC L_8D96
    DEY 
L_8DA0:
    STY $23
    LDA #$1A
    JSR L_8130
L_8DA7:
    RTS 
L_8DA8:
    AND $027A,X
L_8DAB:
    !byte $03
    !byte $04
    ORA $0B
    !byte $0C
    CLC 
    ORA $780E,Y
    LDA #$EF
    CMP $19
    BCS L_8DBC
    STA $19
L_8DBC:
    LDA #$28
    CMP $19
    BCC L_8DC4
    STA $19
L_8DC4:
    LDA $18
    BNE L_8DD2
    LDA #$0E
    CMP $17
    BCC L_8DDE
    STA $17
    BCS L_8DDE
L_8DD2:
    LDA #$01
    STA $18
    LDA #$4D
    CMP $17
    BCS L_8DDE
    STA $17
L_8DDE:
    LDA $19
    STA L_D003
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
L_8E0A:
    JSR L_8ECC
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
    JSR L_8F12
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
    JSR L_8F50
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
    JSR L_8F50
    LDA #$72
    STA $02
    LDA #$5D
    STA $03
    LDX #$09
    LDY #$13
    LDA $1704
    JSR L_8F50
    LDA #$03
    JSR $0DCC
    LDX #$00
    STX $5C
    STX $81
    STX $82
    INX 
    STX $7F
L_8E7D:
    INX 
    STX $77
    STX $78
    JSR L_9042
    SEI 
    LDA $36
    ORA #$80
    STA $36
    CLI 
    RTS 
L_8E8E:
    ASL 
    ASL 
    ASL 
    ASL 
    TAY 
    LDX #$10
L_8E95:
    LDA $7310,Y
    EOR #$FF
    STA $7310,Y
    LDA $7450,Y
    EOR #$FF
    STA $7450,Y
    INY 
    DEX 
    BNE L_8E95
    RTS 
L_8EAA:
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
    JSR L_8F12
    LDA $66
    PHA 
    JSR $0DD7
    PLA 
    STA $66
    RTS 
L_8ECC:
    LDX #$00
    LDY #$04
    STX $02
    STY $03
    LDY #$60
    STX $06
    STY $07
L_8EDA:
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
L_8EEF:
    LDA ($08),Y
    STA ($06),Y
    DEY 
    BPL L_8EEF
    LDA $06
    CLC 
    ADC #$08
    STA $06
    BCC L_8F01
    INC $07
L_8F01:
    INC $02
    BNE L_8F07
    INC $03
L_8F07:
    LDA $02
    CMP #$E8
    LDA $03
    SBC #$07
    BCC L_8EDA
    RTS 
L_8F12:
    STX $27
    STY $26
L_8F16:
    LDA $09
    PHA 
    LDA $08
    PHA 
    LDX $26
L_8F1E:
    LDY #$07
L_8F20:
    LDA ($02),Y
    STA ($08),Y
    DEY 
    BPL L_8F20
    LDA $02
    CLC 
    ADC #$08
    STA $02
    BCC L_8F32
    INC $03
L_8F32:
    LDA $08
    CLC 
    ADC #$08
    STA $08
    BCC L_8F3D
    INC $09
L_8F3D:
    DEX 
    BNE L_8F1E
    PLA 
    CLC 
    ADC #$40
    STA $08
    PLA 
    ADC #$01
    STA $09
    DEC $27
    BNE L_8F16
    RTS 
L_8F50:
    STY $1C
L_8F52:
    LDY $1C
L_8F54:
    STA ($02),Y
    DEY 
    BPL L_8F54
    PHA 
    LDA $02
    CLC 
    ADC #$28
    STA $02
    BCC L_8F65
    INC $03
L_8F65:
    PLA 
    DEX 
    BPL L_8F52
    RTS 
; cold start init
L_8F6A:
    LDA #$00
    TAY 
; clear ram $0002..$00FF, $0200..$02FF, $0300..$03FF
L_8F6D:
    STA $0002,Y
    STA $0200,Y
    STA $0300,Y
    INY 
    BNE L_8F6D
    LDY #$1F
; copy KERNAL ROM to RAM: $FD30..$FD4F → $0314..$0333
L_8F7B:
    LDA $FD30,Y
    STA $0314,Y
    DEY 
    BPL L_8F7B
; set colors and sprites
    LDA #$04
    STA $0288
    JSR $FF5B
; Border color
    LDA #COLOR_BORDER
    STA L_D020
    LDA #$00
    STA L_D01C
    STA $D01D
    STA L_D017
    JSR L_9070
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
    STA L_DC05
; ---------------------------
; ram upload check
    LDX #$10
    LDY #$7F
L_8FDD:
    LDA $0900,Y
    CMP $B100,Y
    BNE L_8FE9
    DEY 
    BPL L_8FDD
    DEX 
; copy data from $B000 to $0800, X pages by 256B (10)
L_8FE9:
    TYA 
    PHA 
    LDA #$B0
    STA $03
    LDA #$08
    STA $05
    LDY #$00
    STY $02
    STY $04
L_8FF9:
    LDA ($02),Y
    STA ($04),Y
    INY 
    BNE L_8FF9
    INC $03
    INC $05
    DEX 
    BNE L_8FF9
    CLI 
    PLA 
    BPL L_9033
    LDY #$01
    LDA #$19
    STA $5B
    LDA #$00
    STA $1900
    STA $5A
L_9018:
    LDA ($5A),Y
    BEQ L_9029
    INY 
    BNE L_9018
    INC $5B
    LDA $5B
    CMP #$3C
    BCC L_9018
    BCS L_9036
L_9029:
    STY $5A
    LDA #$00
    STA $1900
    JMP L_907B
L_9033:
    JSR $0DBA
L_9036:
    JMP L_90C2
L_9039:
    JSR L_90B9
L_903C:
    LDX #$03
    JSR L_964F
    RTS 
L_9042:
    BIT $D011
    BPL L_9042
    LDA #$BB
    STA $D011
    LDA #$78
    STA $D018
    LDA L_DD00
    AND #$FC
    ORA #$02
    STA L_DD00
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
L_9070:
    LDA #$00
    LDY #$3F
L_9074:
    STA $7F40,Y
    DEY 
    BPL L_9074
    RTS 
L_907B:
    LDY #$00
L_907D:
    CPY $1700
    BCS L_90AC
    LDA $1800,Y
    AND #$1F
    CLC 
    ADC #$05
    STA $1C
    LDA $1803,Y
    CMP $1801,Y
L_9092:
    BCC L_90AC
    CMP #$A1
    BCS L_90AC
    LDA $1804,Y
    CMP $1802,Y
    BCC L_90AC
    CMP #$C9
    BCS L_90AC
    TYA 
    ADC $1C
    TAY 
    BCC L_907D
    LDY #$00
L_90AC:
    STY $1700
    RTS 
L_90B0:
    LDA #$00
    STA $5C
    LDA #$0A
    JSR L_8354
L_90B9:
    JSR L_9122
    JSR L_9142
    JMP L_90D3
L_90C2:
    LDX #$01
    LDY #$19
    STX $5A
    STY $5B
    LDA #$00
    STA $1900
    STA $1901
    RTS 
L_90D3:
    BIT $D011
    BPL L_90D3
    LDA #$9B
    STA $D011
    LDA #$12
    STA $D018
    LDA L_DD00
    ORA #$03
    STA L_DD00
    LDA #$00
    LDX #$3E
L_90EE:
    STA $03C0,X
    DEX 
    BPL L_90EE
    LDA #$FF
    STA $03EB
    STA $03EE
    LDA #$02
    STA $D01B
    LDA #$0F
    STA $07F9
    LDA #$02
    STA L_D015
    LDA #$00
    JSR L_9437
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
L_9122:
    LDX #$00
    LDA #$00
    JSR L_974D
    JSR L_973E
    LDY #$27
    LDA #$1E
-   STA $0450,Y
L_9133:
    DEY 
    BPL -
L_9136:
    LDA $1703
    LDY #$77
L_913B:
    STA L_D800,Y
    DEY 
    BPL L_913B
    RTS 
L_9142:
    LDA $1701
    LDY #$DC
L_9147:
    STA $D877,Y
    STA $D953,Y
    STA L_DA2F,Y
    STA $DB0B,Y
    DEY 
    BNE L_9147
    LDA $1702
    STA $D021
    RTS 
L_915D:
    STA $1F
;read dir
    LDA #$01                        ; msg. no.
    JSR L_9747                 		; print "SPACE=...
    LDX #<L_920B                    ; "$0" need_fix for SoftIEC?
    LDY #>L_920B
    LDA #$02
    JSR CBM_SETNAM                  ; Set file name
    LDY #$00
L_916F:
    JSR L_9297                      ; set file parameter and open
    BCS L_91D7
    LDA #$04
    STA $26
L_9178:
    JSR CBM_CHRIN                   ; Input Vector
    DEC $26
    BNE L_9178
    LDA $90
    SEC 
    BNE L_91D7
    JSR CBM_CLRCHN                  ; Restore I/O Vector
L_9187:
    JSR L_9213
    BCS L_91D7
    STA $1C
    LDA #$03
    STA $27
L_9192:
    LDY $27
    LDA #$0C
    JSR L_9664
L_9199:
    JSR $9474						; get character from imput device
    LDX $27
    CMP #$A0
    BNE L_91AA
    CPX $26
    BCS L_9199
    INC $27
    BCC L_9192
L_91AA:
    CMP #$A1
    BNE L_91B6
    CPX #$04
    BCC L_9199
    DEC $27
    BCS L_9192
L_91B6:
    CMP #$AD
    BNE L_91D9
    LDY #$28
    JSR L_96FB
    TXA 
    CLC 
    ADC #$0C
    STA $02
    TYA 
    ADC #$04
    STA $03
    LDY #$00
    LDA #$22
L_91CE:
    CMP ($02),Y
    BEQ L_91E7
    INY 
    CPY #$14
    BCC L_91CE
L_91D7:
    BCS L_9205
L_91D9:
    CMP #$B3
    BEQ L_9205
    CMP #$20
    BNE L_9199
    LDA $1C
    BNE L_9187
    BEQ L_9205
L_91E7:
    TYA 
    LDX $02
    LDY $03
    JSR CBM_SETNAM                  ; Set file name
    CLC 
    BIT $1F
    BMI L_9205
    LDX #$0D
    LDY #$92
    STX $04
    STY $05
    JSR L_9598
    BNE L_9205
    LDA #$80
    STA $1F
L_9205:
    PHP 
    JSR L_92B2
    PLP
    !by $60
L_920B
    !pet "$:"
    !by $04
    !by $01
    !by $02
    !by $00
    !by $06
    !by $0E
L_9213:
    LDX #$03
    STX $26
    JSR L_964F
    LDX #$08
    JSR CBM_CHKIN                   ; Set input file
L_921F:
    JSR CBM_CHRIN                   ; Input Vector
    STA $1A
    JSR CBM_CHRIN                   ; Input Vector
    STA $1B
    LDX $26
    LDY #$07
    JSR L_9682
    LDA #$00
L_9232:
    LDX $26
    JSR L_94E1
    BCS L_9250
    JSR CBM_CHRIN
    STA $1C
    JSR CBM_CHRIN
    ORA $1C
    BEQ L_924F
    LDA $26
    CMP #$18
    BCS L_924F
    INC $26
    BCC L_921F
L_924F:
    CLC 
L_9250:
    PHA 
    PHP 
    JSR CBM_CLRCHN
    PLP
    PLA
    RTS
L_9258:
    LDX #$30
    LDY #$04
    JSR CBM_SETNAM
    LDA #$0F
    TAY 
    LDX #$08
    JSR CBM_SETLFS
    JSR CBM_OPEN
    BCS L_928C
    LDX #$0F
    JSR CBM_CHKIN
    BCS L_928C
    JSR L_973E
    LDA #$FF
    STA $55
    LDA #$0D
    LDY #$00
    JSR L_94DF
    LDA $0428
    ORA $0429
    CMP #$30
    BNE L_928C
    CLC 
L_928C:
    PHP 
    JSR CBM_CLRCHN
    LDA #$0F
    JSR CBM_CLOSE
    PLP 
    RTS 
L_9297:
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
    BCS L_92B1
L_92A9:
    BNE L_92AE
    JMP $FFC6
L_92AE:
    JSR CBM_CHKOUT
L_92B1:
    RTS 
L_92B2:
    JSR CBM_CLRCHN
    LDA #$08
    JMP $FFC3
; ---------------------------------
; IRQ part
; ---------------------------------
    LDA $C6
    PHA
    LDA $028D
    PHA
    JSR L_EA87
    PLA 
    TAX 
    LDA $028D
    AND #$06
    BEQ L_92D8
    TXA 
    EOR $028D
    AND #$06
    BEQ L_92D8
    JSR L_941B
L_92D8:
    PLA 
    CMP $C6
    BEQ L_930C
    TAX 
    LDA $028D
    ORA $53
    CMP #$04
    BCC L_92E9
    LDA #$04
L_92E9:
    ASL 
    TAY 
    LDA L_930D,Y
    STA $F5
    LDA L_930D+1,Y
    STA $F6
    LDY $CB
    LDA ($F5),Y
    BIT $54
    BPL L_9300
    JSR $944B
L_9300:
    STA $0277,X
    LDA $53
    BEQ L_930C
    LDA #$00
    JSR $941B
L_930C:
    RTS
L_930D:
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
L_941B:
    STA $53
    CMP #$06	; 0 = empty, 2 = C=
    BCC L_9423
    LDA #$04	; for CTRL
L_9423:
    ASL 
    ASL 
    TAX 
    LDY #$07
L_9428:
    LDA L_945C,X
    STA $0450,Y
    INX 
    DEY 
    BPL L_9428
    RTS
; ---------------------------------
; handle 'CAPS'
; #$00 > switch off, #$FF > switch on
L_9433:
    LDA #$FF
    EOR $54
L_9437:
    STA $54
    AND #$06
    EOR #$06
    TAX 
    LDY #$05
L_9440:
    LDA L_9456,X
    STA $0459,Y
L_9446:
    INX 
    DEY 
    BPL L_9440
    RTS
; ---------------------------------
L_944B:
    CMP #$7E
    BCS L_9455
    CMP #$61
    BCC L_9455
    SBC #$20
L_9455:
    RTS
L_9456:
    !by $1D,$53,$50,$41,$43,$1C         ; "<caps>"
L_945C:
    !by $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
    !by $1E,$1D,$3D,$43,$1C,$1E,$1E,$1E
    !by $1D,$4C,$52,$54,$43,$1C,$1E,$1E
    LDA $99
    BNE L_94D6
    SEI
    LDA $3F
    ASL 
    ASL 
    ORA $3F
    AND #$24
    CMP #$04
    BNE L_948D
    LDA #$FF
    STA $3F
    LDA #$AD
    BNE L_94D9
L_948D:
    LDA $3F
    AND #$12
    CMP #$02
    BNE L_949D
    LDA #$FF
    STA $3F
    LDA #$20
    BNE L_94D9
L_949D:
    SEI 
    LDX #$A0
    LDA $19
    BMI L_94AB
    LDX #$A1
    LDA #$00
    SEC 
    SBC $19
L_94AB:
    AND #$7F
L_94AD:
    CMP #$08
    BCC L_94BA
    LDA #$80
    STA $19
    STA $17
    TXA 
    BNE L_94D9
L_94BA:
    LDX #$A2
    LDA $17
    BMI L_94C7
    LDX #$A3
    LDA #$00
    SEC 
    SBC $17
L_94C7:
    AND #$7F
    CMP #$08
    BCC L_94D6
    LDA #$80
    STA $17
    STA $19
L_94D3:
    TXA 
    BNE L_94D9
L_94D6:
    JSR CBM_GETIN
L_94D9:
    CLI 
    RTS 
L_94DB:
    LDA #$AD
    LDY #$08
L_94DF:
    LDX #$01
L_94E1:
    STA $24
    TYA 
    PHA 
    STX $26
    LDY #$28
    JSR L_96FB
    STX $02
    TYA 
    ORA #$04
    STA $03
    PLA 
    STA $1D
    STA $1C
    LDY $26
    JSR L_9664
    LDA #$00
    STA $90
L_9501:
    JSR $9474
    SEC 
    LDX $90
    BNE L_957B
    LDY $1C
    CMP $24
    BEQ L_9576
    NOP 
    NOP 
    NOP 
    NOP 
    NOP 
    NOP 
    NOP 
    NOP 
    LDX $99
    BNE L_9564
    TAX 
    BEQ L_9501
    CMP #$AE
    BNE L_9524
    LDA #$0D
L_9524:
    CMP #$AF
    BNE L_9533
    CPY $1D
    BEQ L_9501
    DEY 
    DEC $1C
    LDA #$1F
L_9531:
    BNE L_956A
L_9533:
    CMP #$B3
    BEQ L_957B
    CMP #$BD
    BNE L_9541
    JSR L_9433
    JMP L_9501
L_9541:
    CMP #$B4
    BNE L_9560
    LDA $59
    CMP #$5C
    BCS L_9501
    LDX $23
L_954D:
    TXA 
    TAY 
    LDA ($58),Y
    BEQ L_956C
    LDY $1C
    CPY #$28
    BCS L_956C
    STA ($02),Y
    INX 
    INC $1C
    BNE L_954D
L_9560:
    CMP #$A0
    BCS L_9501
L_9564:
    CPY #$28
    BCS L_9501
    INC $1C
L_956A:
    STA ($02),Y
L_956C:
    LDA $1C
    LDY $26
L_9570:
    JSR L_9664
    JMP L_9501
L_9576:
    SEC 
    TYA 
    SBC $1D
    CLC 
L_957B:
    RTS 
L_957C:
    JSR L_9747
    LDA #$FF
    JSR L_9437
    JSR L_94DB
    PHA 
    PHP 
    LDX #$30
    LDY #$04
    JSR CBM_SETNAM
    LDA #$00
    JSR L_9437
    PLP 
    PLA 
    RTS 
L_9598:
    LDY #$00
    STY $26
    LDA ($04),Y
    JSR L_9747
L_95A1:
    JSR L_95B1
    BCC L_95AF
    CMP #$A0
    BEQ L_95A1
    CMP #$A1
    BEQ L_95A1
    SEC 
L_95AF:
    TAX 
    RTS 
L_95B1:
    LDY #$02
    LDA ($04),Y
    CLC 
    ADC #$03
    TAY 
    LDA ($04),Y
    STA $27
    CMP $26
    BCS L_95C3
    STA $26
L_95C3:
    LDY #$01
    LDA ($04),Y
    TAY 
    LDA $26
    JSR L_9664
L_95CD:
    JSR $9474
    BEQ L_95CD
    CMP #$A2
    BNE L_95E1
    LDX $26
    INX 
    CPX $27
L_95DB:
    BCS L_95CD
    STX $26
    BCC L_95C3
L_95E1:
    CMP #$A3
    BNE L_95EE
    LDX $26
    DEX 
    BMI L_95CD
    STX $26
    BPL L_95C3
L_95EE:
    CMP #$AD
    BNE L_960D
    LDY #$02
    LDA ($04),Y
    CLC 
    ADC #$02
    TAY 
    LDA $26
L_95FC:
    CMP ($04),Y
    BCS L_9607
    DEY 
    CPY #$03
    BCS L_95FC
    BCC L_95CD
L_9607:
    TYA 
    SEC 
    SBC #$03
    CLC 
    RTS 
L_960D:
    CMP #$B3
    BEQ L_9619
    CMP #$A0
    BEQ L_9619
    CMP #$A1
    BNE L_95CD
L_9619:
    RTS 
L_961A:
    PHA 
    LDY #$01
    LDA ($04),Y
    TAX 
    DEY 
    LDA ($04),Y
    JSR L_974D
    LDA $09
    CLC 
    ADC #$D4
    STA $09
    LDA $1701
    LDY #$27
L_9632:
    STA ($08),Y
    DEY 
    BPL L_9632
    PLA 
    CLC 
    ADC #$04
    TAY 
    LDA ($04),Y
    STA $1C
    DEY 
    LDA ($04),Y
L_9643:
    TAY 
    LDA $1703
L_9647:
    STA ($08),Y
    INY 
    CPY $1C
    BCC L_9647
    RTS 
L_964F:
    CPX #$19
    BCS L_965F
    TXA 
    PHA 
    LDA #$00
    JSR print_msg
    PLA 
    TAX 
    INX 
    BNE L_964F
L_965F:
    RTS 
L_9660:
    LDA $23
    LDY $22
L_9664:
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
    STA L_D003
    RTS 
L_9682:
    TYA 
    PHA 
    LDY #$28
    JSR L_96FB
    STX $02
    TYA 
    ORA #$04
    STA $03
    JSR L_96A1
    PLA 
    TAY 
L_9695:
    LDA $0201,X
    STA ($02),Y
    INY 
    INX 
    CPX #$05
    BCC L_9695
    RTS 
L_96A1:
    LDX #$04
L_96A3:
    LDA #$00
    LDY #$10
L_96A7:
    ROL $1A
    ROL $1B
    ROL 
    CMP #$0A
    BCC L_96B2
    SBC #$0A
L_96B2:
    DEY 
    BNE L_96A7
    ROL $1A
    ROL $1B
    ORA #$30
    STA $0201,X
    DEX 
    BPL L_96A3
    INX 
L_96C2:
    LDA $0201,X
    CMP #$30
    BNE L_96D3
L_96C9:
    LDA #$1F
    STA $0201,X
    INX 
    CPX #$04
    BCC L_96C2
L_96D3:
    RTS 
L_96D4:
    LDX #$00
    STX $1A
L_96D8:
    LDA $0430,X
    CMP #$20
    BEQ L_96F7
    SEC 
    SBC #$30
    BCC L_96FA
    CMP #$0A
    BCS L_96FA
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
L_96F7:
    INX 
    BNE L_96D8
L_96FA:
    RTS 
L_96FB:
; multiply X with Y
; result in X = low byte, and Y = high byte
multiply_x_y
    STX $1C						; line No. (multiplier)
    STY $1D						; value to multiply
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
L_9716:
print_msg:
    PHA 							; save msg. length
    LDY #$28						; screen line length
    JSR L_96FB						; multiply X with Y
    STX $08							; screen position low byte
    TYA 
    ORA #$04
    STA $09							; screen position high byte
    PLA 							; msg. length
    BEQ L_9731						; if zero, go delete the whole line
    PHA 
    TAY 
    DEY 
; copy actual msg. to the screen
L_9729:
    LDA ($02),Y
    STA ($08),Y
    DEY 
    BPL L_9729
    PLA 
; fill actual line from Y-position to the end with empty spaces
L_9731:
    TAY 							; position in line
    LDA #$1F						; empty space
L_9734:
    CPY #$28						; compare with line end position
    BCS L_973D
    STA ($08),Y
    INY 
    BNE L_9734
L_973D:
    RTS
---------------------------------
; delete line 1
L_973E:
    LDA #$00
    STA $55
    LDX #$01
    JMP print_msg					; L_9716

; print a text into the second line on screen
; the text part No. must be in accu
L_9747:
    LDX #$FF
    STX $55
    LDX #$01     					; line No.
; print a text into a line on screen
; the line No. must be in X,
; the text part No. must be in accu
L_974D:
    TAY								; msg. No. 
    TXA 							; line No.
    PHA 							; save line No.
    TYA 							; msg. No
    BMI L_975B
    LDX #<MSG_TABLE					; msg. table start
    LDY #>MSG_TABLE
    STX $02
    STY $03
L_975B:
    AND #$7F    					; delete bit 7
    TAX    							; set masg. No as counter 

; find msg. address pointer
; the msg. address will be in $03/$04
msg_search:
    LDY #$00    					; pointer
; find $0D for msg. end
L_9760:
    INY 
    LDA ($02),Y    					; load char fom msg_table
    CMP #$0D
    BNE L_9760

    DEX 							; decrement counter
L_9768:
    BMI msg_found					; msg found
    TYA 
    SEC 
    ADC $02							; increment pointer low byte with counter
    STA $02							; store as new low byte
    BCC msg_search					; bcc skip
    INC $03							; else increment high byte
    BCS msg_search					; (jmp)
msg_found:
    PLA 							; line No.
    TAX 							; move to X
    TYA 							; msg. length
    PHA 
    JSR print_msg					;L_9716
    PLA 
    RTS 
 
	JSR L_9039
    LDA #$00
    STA $1709
    LDX #$04
L_9789:
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
    BCC L_97A2
    LDA ($04),Y
L_97A2:
    JSR L_961A
    PLA 
    TAX 
    DEX 
    BPL L_9789
    LDA #$12
    STA $23
    LDX #$04
L_97B0:
    TXA 
    PHA 
    ASL 
    TAY 
    LDA $986F,Y
    STA $04
    LDA $9870,Y
    STA $05
    JSR L_973E
    LDA $23
    STA $26
    JSR L_95B1
    TAY 
    LDA $26
    STA $23
    PLA 
    TAX 
    BCC L_97E9
    CPY #$B3
    BEQ L_9840
    CPY #$A1
    BNE L_97DE
    CPX #$00
    BEQ L_97B0
    DEX 
L_97DE:
    CPY #$A0
    BNE L_97B0
    CPX #$04
    BCS L_97B0
    INX 
    BCC L_97B0
L_97E9:
    PHA 
    TYA 
    STA $1705,X
    JSR L_961A
    PLA 
    TAX 
    CPX #$03
    BCC L_97B0
    BNE L_9817
    LDA $1708
    BEQ L_97B0
    LDA #$21						; msg. no.
    JSR L_9747						; print "Radky"
    JSR L_94DB
    LDX #$03
    BCS L_97B0
    JSR L_96D4
    LDA $1A
    STA $1708
    LDX #$03
    JMP L_97B0
L_9817:
    LDY $1709
    BEQ L_97B0
    DEY 
    BEQ L_983C
    LDA #$1F						; msg. no.
    JSR L_9747						; print "Cislo"
    JSR L_94DB
    LDX #$04
    BCS L_97B0
    JSR L_96D4
    LDA $1A
    SEC 
    BEQ L_9840
    STA $1709
    LDA $70
    ORA #$30
    STA $70
L_983C:
    JSR L_9042
    CLC 
L_9840:
    RTS 
L_9841:
    LDX #$00
L_9843:
    LDA $02,X
    PHA 
    INX 
    CPX #$04
    BNE L_9843
    JSR L_9039
L_984E:
    LDX #$9C
    LDY #$98
    STX $04
    STY $05
    JSR L_9598
    BCS L_984E
    PHA 
    JSR L_9042
    PLA 
    LSR 
    LDX #$03
L_9863:
    PLA 
    STA $02,X
    DEX 
    BPL L_9863
; Menu row definitions (text + row + tab stops)
    lda #$00
    sta $D015
    rts
pf_menu_rowdef_ptr_table:        					; pointer table (little-endian)
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
    !byte $1C,$01,$02
    !by $00,$0B,$14
    !by $A9, $00
    STA L_D015
    JSR L_9AF8
    BCS L_98CE
    !by $AD, $09, $17
    !by $8D, $44, $03
L_98B2:
    LDX $1705
    LDA $1710,X
    STA $1F
    CPX #$04
    BEQ L_98C4
    JSR L_98D9
    JMP L_98C7
L_98C4:
    JSR L_9A39
L_98C7:
    BCS L_98CE
    DEC $0344
    BNE L_98B2
L_98CE:
    PHP 
    JSR L_9B66
    LDA #$02
    STA L_D015
    PLP 
    RTS 
L_98D9:
    LDA $70
L_98DB:
    AND #$EF
    CMP $70
    BEQ L_98F8
    STA $70
    LDY #$0A
    JSR L_9B92
    LDA $1708
    BEQ L_98F8
    LDY #$0B
    JSR L_9B92
    LDA $1708
    JSR L_9B70
L_98F8:
    LDA #$00
    STA $25
    LDA $4C
    STA $22
L_9900:
    INC $25
    SEC 
    JSR $0DC0
    LDA $23
    BEQ L_9940
    JSR L_9BAD
    LDA $1F
    AND #$7F
    STA $1F
    JSR L_9963
    LDA $1F
    AND #$20
    BEQ L_9931
L_991C:
    LDY #$05
    JSR L_9B92
    JSR L_9BCC
    SEC 
    JSR $0DC0
    LDA $1F
    ORA #$80
    STA $1F
    JSR L_9963
L_9931:
    LDA $1F
    AND #$0C
    LSR 
    LSR 
    ADC #$01
    TAY 
L_993A:
    JSR L_9B92
    JSR L_9BCC
L_9940:
    INC $22
    LDA $4E
    CMP $22
    BCC L_9956
    JSR CBM_GETIN
    CMP #$B3
    BNE L_9900
    JSR L_9841
    BCC L_9900
    BCS L_9962
L_9956:
    LDA $70
    AND #$20
    BEQ L_9962
    LDA #$0C
    JSR L_9B70
L_9961:
    CLC 
L_9962:
    RTS 
L_9963:
    LDA #$00
    STA $1B
    STA $26
    LDA $23
    ASL 
L_996C:
    ASL 
    ROL $1B
L_996F:
    ASL 
    ROL $1B
L_9972:
    STA $1A
    LDA #$50
    JSR L_9BDC
    LDA $1F
    AND #$03
    CLC 
    ADC #$06
    TAY 
    JSR L_9B92
L_9984:
    BIT $1F
    BVC L_999D
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
L_9999:
    ADC $1B
    STA $1B
L_999D:
    LDA $1A
    JSR L_9B70
    LDA $1B
    JSR L_9B70
L_99A7:
    JSR $0DC3
    LDY #$08
L_99AC:
    LDX #$00
L_99AE:
    ROL $0200,X
    ROL 
    INX 
    CPX #$08
    BNE L_99AE
    ROL $0208
    JSR L_99CF
    DEY 
    BNE L_99AC
    DEC $23
    BNE L_99A7
    BIT $1F
    BVC L_99CE
    LDA #$00
    CLC 
    JSR L_99CF
L_99CE:
    RTS 
L_99CF:
    BIT $1F
    BVC L_9A1F
    BMI L_99EC
    BIT $26
    BPL L_9A2B
    STA $0C
    LDA $0F
    AND $0B
    STA $1C
    EOR $0B
    PHA 
L_99E4:
    AND $0C
    STA $1D
    PLA 
    JMP L_9A13
L_99EC:
    BIT $26
    BPL L_9A2B
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
L_9A13:
    JSR L_9B70
    LDA $1C
    JSR L_9B70
    LDA $1D
    STA $0F
L_9A1F:
    JSR L_9B70
    LDA $0E
    STA $0D
L_9A26:
    LDA $0C
    STA $0B
    RTS 
L_9A2B:
    STA $0B
    ROL 
    STA $0D
    LDA #$00
    STA $0F
    LDA #$80
    STA $26
    RTS 
L_9A39:
    LDA #$08
    JSR L_9B70
    LDA #$3C
    CMP $51
    BCS L_9A46
    STA $51
L_9A46:
    LDA $4C
    STA $22
    LDA #$00
    STA $24
L_9A4E:
    CLC 
    JSR $0DC0
    LDA #$3C
    SEC 
    SBC $51
    BEQ L_9A7E
    LDX $1707
L_9A5C:
    BEQ L_9A7E
    CPX #$02
    BEQ L_9A63
    LSR 
L_9A63:
    ASL 
    ASL 
    ASL 
    ROL $1C
    PHA 
    LDA #$1B
    JSR L_9B70
    LDA #$10
    JSR L_9B70
    LDA #$1C
    AND #$01
    JSR L_9B70
    PLA 
    JSR L_9B70
L_9A7E:
    LDA $51
    STA $23
    LDA #$00
    STA $26
    STA $27
L_9A88:
    JSR $0DC3
    LDY #$08
L_9A8D:
    LDA #$07
    STA $1C
    LDX $24
L_9A93:
    ROL $0200,X
    ROR 
    INX 
    DEC $1C
    BNE L_9A93
    JSR L_9AD1
    DEY 
    BNE L_9A8D
    DEC $23
    BNE L_9A88
    LDA #$0D
    JSR L_9B70
    INC $22
    DEC $24
    BPL L_9AB7
    DEC $22
    LDA #$07
    STA $24
L_9AB7:
    LDA $4E
    CMP $22
    BCC L_9AC9
    JSR CBM_GETIN
    CMP #$B3
    BNE L_9A4E
    JSR L_9841
    BCC L_9A4E
L_9AC9:
    PHP 
    LDA #$0F
    JSR L_9B70
    PLP 
    RTS 
L_9AD1:
    LSR 
    BEQ L_9AF1
    PHA 
L_9AD5:
    LDA $26
    ORA $27
    BEQ L_9AEB
    LDA #$80
    JSR L_9B70
    LDA $26
    BNE L_9AE6
    DEC $27
L_9AE6:
    DEC $26
    SEC 
    BCS L_9AD5
L_9AEB:
    PLA 
    ORA #$80
    JMP L_9B70
L_9AF1:
    INC $26
    BNE L_9AF7
    INC $27
L_9AF7:
    RTS 
L_9AF8:
    SEI 
    LDA #$00
    STA $DD01
    LDA #$FF
L_9B00:
    STA L_DD03
    LDA L_DD00
    ORA #$04
    STA L_DD00
    LDA L_DD02
    ORA #$04
    STA L_DD02
    LDA $DD0D
    LDA L_DD00
    AND #$FB
    STA L_DD00
    ORA #$04
    STA L_DD00
    LDX #$FF
L_9B25:
    LDA $DD0D
    DEX 
    BEQ L_9B37
    AND #$10
    BEQ L_9B25
    CLI 
    LDA #$00
    STA $170F
    CLC 
    RTS 
L_9B37:
    CLI 
    LDA #$80
    STA $170F
    JSR CBM_CLRCHN
    LDY #$00
    LDA $1705
    CMP #$04
    BEQ L_9B4C
    LDY $170E
L_9B4C:
    LDA #$04
    LDX $170D
    JSR CBM_SETLFS
    LDA #$00
    JSR CBM_SETNAM
    JSR CBM_OPEN
    BCS L_9B66
    LDX #$04
    JSR CBM_CHKOUT
    BCS L_9B66
    RTS 
L_9B66:
    JSR CBM_CLRCHN
    LDA #$04
    JSR CBM_CLOSE
    SEC 
    RTS 
L_9B70:
    BIT $170F
    BPL L_9B78
    JMP $FFD2
L_9B78:
    PHA 
    STA $DD01
    LDA L_DD00
    AND #$FB
    STA L_DD00
    ORA #$04
    STA L_DD00
L_9B89:
    LDA $DD0D
    AND #$10
    BEQ L_9B89
    PLA 
    RTS 
L_9B92:
    LDX #$00
L_9B94:
    LDA $1717,X
    INX 
    CMP #$FF
    BNE L_9B94
    DEY 
    BNE L_9B94
L_9B9F:
    LDA $1717,X
    CMP #$FF
    BEQ L_9BAC
    JSR L_9B70
    INX 
    BNE L_9B9F
L_9BAC:
    RTS 
L_9BAD:
    DEC $25
    BEQ L_9BCB
    LDA $1F
    AND #$0C
    LSR 
    LSR 
    ADC #$01
    TAY 
    LDA $1F
    AND #$20
    BEQ L_9BC1
    DEY 
L_9BC1:
    JSR L_9B92
L_9BC4:
    JSR L_9BCC
    DEC $25
    BNE L_9BC4
L_9BCB:
    RTS 
L_9BCC:
    LDA #$0D
    JSR L_9B70
    LDA $1706
    BEQ L_9BDB
    LDA #$0A
    JSR L_9B70
L_9BDB:
    RTS 
L_9BDC:
    SEC 
L_9BDD:
    SBC $51
    BEQ L_9BF4
    LDX $1707
    BEQ L_9BF4
    CPX #$02
    BEQ L_9BEB
    LSR
L_9BEB:
    TAX
    LDA #$20
    JSR $9B70
    DEX
    BNE L_9BEB+1
L_9BF4:
    RTS
VIZA_CS_IN:
+InsertVizaIn

VIZA_CS_OUT:
+InsertVizaOut
}

* = $2000

!pseudopc $A000 {
L_A000:
    !word $A004
    !word $A004
    LDX #$08
PF_INIT_LOOP:
    LDA L_A012,X
    STA $0340,X
    DEX
    BPL PF_INIT_LOOP
    JMP $0340
L_A012:
    LDA #$FF
    STA $DE80    ; disable cartridge / reset bank switching
    JMP CBM_START    ; KERNAL RESET
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

!if pg24 = 1 {+InsertModPG24}

}

*=$3000

!pseudopc $B000 {
+InsertChars
    LDA #$00
    STA $DE80
    JMP $FCE2
    JSR $0FDC
    JMP L_9972
    JSR $0FDC
    JMP L_8000
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
    !byte $20
    !byte $E8
    !byte $0F
    !byte $20
    !byte $28
    !byte $80
    !byte $4C
    !byte $DC
    !byte $0F
    !byte $20
    !byte $E8
    !byte $0F
    !byte $20
    !byte $2E
    !byte $80
    !byte $48
    !byte $20
    !byte $DC
    !byte $0F
    !byte $68
    !byte $60
    !byte $E7
    !byte $B3
    !byte $67
    LDX $07,Y
    TSX 
    !byte $AF
    STA $CE,X
    !byte $9F
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
    LDA #$02
    STA $DE80
    LDA $DC0D
    LDA $A2
    AND #$3F
    BNE L_B66C
    LDA $D028
    EOR #$01
    AND #$01
    STA $D028
    STA L_D029
L_B66C:
    INC $A2
    JSR L_886F
    LDA $39
    ORA $3A
    BEQ L_B68F
    LDX $39
    LDY $3A
    JSR $8984
    LDA #$04
    BIT $29
    BEQ L_B687
    JSR L_872B
L_B687:
    LDA $36
    ORA #$A0
    STA $36
    BNE L_B6AD
L_B68F:
    LDA $36
    ASL 
    AND #$40
    ORA $36
    AND #$DF
    STA $36
    LDA $A2
    LSR 
    BCC L_B6AD
    LDA $3F
    AND #$07
    BNE L_B6AD
    LDA #$00
    STA $DE80
    JSR $8013
L_B6AD:
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
    BCC L_B6E1
    BNE L_B6DE
    CLI 
    JSR $0FE8
    JSR $FFE7
    LDA $D011
    AND #$20
    BNE L_B6D5
    JSR $802B
L_B6D5:
    JSR $0FDC
    JSR L_83F9
    JMP $0DAE						; go to graphic menu
L_B6DE:
    JMP $148E
L_B6E1:
    LDA #$00
    STA $36
    PLA 
    RTI 
    LDA $4A
    BPL L_B6EC
    RTS 
L_B6EC:
    AND #$BF
    STA $4A
    LDA $29
    LSR 
    LSR 
    LSR 
    LDA #$80
    BCC L_B705
    LDA $29
    AND #$FB
    STA $29
    LDA #$00
    STA $34
    LDA #$00
L_B705:
    STA $1F
    LDX $2A
    CPX #$4D
    BCC L_B711
    LDX #$4D
    STX $2A
L_B711:
    LDY $2B
    CPY #$28
    BCC L_B71B
    LDY #$28
    STY $2B
L_B71B:
    JSR L_82D3
    LDX #$00
    LDY #$60
    STX $04
    STY $05
    LDY #$3F
    STX $06
    STY $07
    LDX #$00
    BIT $4A
    BPL L_B735
    LDX $35
    INX 
L_B735:
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
    BVC L_B74D
    LDA #$19
L_B74D:
    STA $27
L_B74F:
    JSR $0FD0
    LDY #$00
    LDX #$08
    SEC 
L_B757:
    BIT $1F
    BMI L_B76E
L_B75B:
    DEY 
    LDA ($02),Y
    ORA ($06),Y
    DEX 
    BNE L_B767
    EOR $24
    LDX #$08
L_B767:
    STA ($04),Y
    TYA 
    BNE L_B75B
    BEQ L_B7AA
L_B76E:
    BIT $43
    BMI L_B783
L_B772:
    DEY 
    LDA ($04),Y
    DEX 
    BNE L_B77C
    EOR $24
    LDX #$08
L_B77C:
    STA ($02),Y
    TYA 
    BNE L_B772
    BEQ L_B7AA
L_B783:
    LDA #$35
    STA $01
L_B787:
    DEY 
    LDA ($02),Y
    PHA 
    LDA $43
    STA $42
    STA $DE80
    LDA ($04),Y
    DEX 
    BNE L_B79B
    EOR $24
    LDX #$08
L_B79B:
    STA ($02),Y
    LDA #$0C
    STA $42
    STA $DE80
    PLA 
    STA ($02),Y
    TYA 
    BNE L_B787
L_B7AA:
    BCC L_B7B7
    INC $03
    INC $05
    INC $07
    LDY #$40
    CLC 
    BCC L_B757
L_B7B7:
    JSR $0FDC
    JSR $82CF
    DEC $05
    LDX #$04
    JSR $8331
    DEC $07
    LDX #$06
    JSR $8331
    DEC $27
    BNE L_B74F
    RTS 
    LDA $43
    STA $42
    STA $DE80
    LDA $45
    STA $01
    RTS 
    LDA #$37
    STA $01
    LDA #$02
    STA $42
    STA $DE80
    RTS 
    LDA #$37
    STA $01
    LDA #$00
    STA $42
    STA $DE80
    RTS 
    JSR $0FFA
    JMP $0FDC
    LDA #$88
    STA $42
    STA $DE80
    LDA #$80
    JSR $1018
    LDA #$8A
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
L_B821:
    STA ($02),Y
    INY 
    BNE L_B821
    INC $03
    DEX 
    BNE L_B821
    RTS 
    JSR $B285
    SEI 
    LDA #$FF
    STA $DE80
    JMP $FCE2
    JSR $0FD0
L_B83B:
    LDA #$08
L_B83D:
    SEC 
    SBC $25
    BCC L_B886
    PHA 
    TAY 
    LDX $25
L_B846:
    TXA 
    PHA 
    LDX $25
    LDA #$00
L_B84C:
    ASL 
    ORA ($02),Y
    INY 
    DEX 
    BNE L_B84C
    PHA 
    LDA $25
    EOR #$06
    STA $1C
    PLA 
    LDX #$01
L_B85D:
    ASL 
    DEX 
    BNE L_B85D
    ROL $24
    LDX $25
    DEC $1C
    BNE L_B85D
    TYA 
    SEC 
    SBC $25
    CLC 
    ADC #$08
    TAY 
    PLA 
    TAX 
    DEX 
    BNE L_B846
    PLA 
    PHA 
    LSR 
    BIT $1F
    BPL L_B87E
    LSR 
L_B87E:
    TAY 
    LDA $24
    STA ($06),Y
    PLA 
    BPL L_B83D
L_B886:
    LDA $25
    ASL 
    ASL 
    ASL 
    ADC $02
    STA $02
    BCC L_B893
    INC $03
L_B893:
    LDA $06
    CLC 
    ADC #$08
    STA $06
    BCC L_B89E
    INC $07
L_B89E:
    DEC $26
    BNE L_B83B
    JMP $0FDC
    PHA 
    JSR $827E
    LDX $2A
    LDY $2B
    JSR L_82D3
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
    BVC L_B8D7
    LDX $35
    INX 
L_B8D7:
    LDA $94D2,X
    STA $10F4
    LDA #$17
    STA $26
L_B8E1:
    JSR $0FD0
    LDX #$28
L_B8E6:
    LDY #$07
L_B8E8:
    BIT $4A
    BVS L_B8F2
    LDA ($02),Y
    EOR ($04),Y
    STA ($06),Y
L_B8F2:
    LDA ($08),Y
    ORA ($04),Y
    AND ($06),Y
    EOR ($02),Y
    STA ($04),Y
    DEY 
    BPL L_B8E8
    JSR $12E3
    LDA $04
    CLC 
    ADC #$08
    STA $04
    LDA $06
    CLC 
    ADC #$08
    STA $06
    BCC L_B916
    INC $05
    INC $07
L_B916:
    DEX 
L_B917:
    BNE L_B8E6
    JSR $0FDC
    JSR $82CF
    DEC $26
    BNE L_B8E1
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
    JSR L_82D3
    LDX #$00
    STX $26
    STX $27
    BIT $1F
    BMI L_B948
    LDX $35
L_B947:
    INX 
L_B948:
    LDA $94D2,X
    STA $116D
L_B94E:
    LDA $23
    STA $1C
L_B952:
    LDY #$00
L_B954:
    LDA #$35
    STA $01
    BIT $43
    BPL L_B95F
    LDA ($02),Y
    PHA 
L_B95F:
    JSR $119A
    LDX $43
    STX $42
    STX $DE80
    LDX $45
    STX $01
    ORA ($02),Y
    STA ($02),Y
    BIT $43
    BPL L_B97F
    LDA #$0C
    STA $42
    STA $DE80
    PLA 
    STA ($02),Y
L_B97F:
    INY 
    CPY #$08
    BNE L_B954
    JSR $12E3
    DEC $1C
    BNE L_B952
    JSR $0FDC
    LDA $90
    BNE L_B999
    JSR $82CF
    DEC $22
    BNE L_B94E
L_B999:
    RTS 
    LDA $26
    ORA $27
    BNE L_B9D2
    INC $26
    LDA #$37
    STA $01
    JSR CBM_CHRIN
    CMP #$9B
    BNE L_B9D0
    BIT $1F
    BVS L_B9D0
    JSR CBM_CHRIN
    STA $26
    LDA $1F
    AND #$02
    BEQ L_B9C8
    LDA $26
    BEQ L_B9C4
    LDA #$00
    BEQ L_B9CB
L_B9C4:
    LDA #$01
    BNE L_B9CB
L_B9C8:
    JSR CBM_CHRIN
L_B9CB:
    STA $27
    JSR CBM_CHRIN
L_B9D0:
    STA $24
L_B9D2:
    LDA $26
    BNE L_B9D8
    DEC $27
L_B9D8:
    DEC $26
    LDA $24
    RTS 
    LDX $4C
    BIT $4B
    BVS L_B9E5
    LDX $4E
L_B9E5:
    LDY $4D
    BIT $4B
    BMI L_B9ED
    LDY $4F
L_B9ED:
    JSR L_82D3
    LDA #$00
    STA $26
    STA $27
L_B9F6:
    LDX $51
L_B9F8:
    LDY #$07
L_B9FA:
    JSR $0FD0
    TYA 
    PHA 
    BIT $4B
    BVC L_BA06
    EOR #$07
    TAY 
L_BA06:
    LDA ($02),Y
    PHA 
    JSR $0FDC
    PLA 
    BIT $4B
    BMI L_BA14
    JSR $9371
L_BA14:
    JSR L_85BD
    PLA 
    TAY 
    DEY 
    BPL L_B9FA
    JSR $12DB
    DEX 
    BNE L_B9F8
    JSR $0FDC
    LDA $90
    BNE L_BA37
    JSR L_82C7
    DEC $50
    BNE L_B9F6
    LDA $24
    EOR #$FF
    JSR L_85BD
L_BA37:
    RTS 
    LDX $4C
    BIT $4B
    BVS L_BA40
    LDX $4E
L_BA40:
    LDY $4D
    JSR L_82D3
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
L_BA5A:
    JSR $0FD0
    LDA #$FE
    LDX #$03
L_BA61:
    STA $0200,X
    DEX 
    BPL L_BA61
    LDA #$00
    STA $26
    STA $1C
    STA $1E
L_BA6F:
    LDX #$02
L_BA71:
    LDA $02
    EOR #$04
    STA $02
    LDY #$03
    LDA #$00
L_BA7B:
    ORA ($02),Y
    DEY 
    BPL L_BA7B
    TAY 
    BEQ L_BAA1
    LDY $1C,X
    BNE L_BA95
    STA $1C,X
    CMP #$10
    LDA $26
    ROL 
    EOR #$01
    STA $0200,X
    LDA $1C,X
L_BA95:
    AND #$0F
    CMP #$01
    LDA $26
    ROL 
    ADC #$01
    STA $0201,X
L_BAA1:
    DEX 
    DEX 
    BPL L_BA71
    JSR $12E3
    INC $26
    LDA $26
    CMP $51
    BCC L_BA6F
    JSR $0FDC
    LDX #$03
L_BAB5:
    TXA 
    EOR $24
    TAY 
    LDA $0200,Y
    CMP #$FE
    BEQ L_BACB
    BIT $4B
    BMI L_BACB
    LDA $51
    ASL 
    SEC 
    SBC $0200,Y
L_BACB:
    EOR #$FF
    JSR CBM_CHROUT
    DEX 
    BPL L_BAB5
    JSR L_82C7
    DEC $27
    BNE L_BA5A
    RTS 
    LDA #$F8
    LDY #$FF
    BIT $4B
    BPL L_BAE7
    LDA #$08
    LDY #$00
L_BAE7:
    CLC 
    ADC $02
    STA $02
    TYA 
    ADC $03
    STA $03
    RTS 
    LDA #$04
    STA $42
    STA $DE80
    LDA L_8000
    CMP #$5A
    BNE L_BB0C
    LDA $7F
    LDY #$0F
L_BB04:
    CMP $8001,Y
    BEQ L_BB11
    DEY 
    BPL L_BB04
L_BB0C:
    JSR $0FDC
    SEC 
    RTS 
L_BB11:
    TYA 
    ASL 
    TAY 
    LDA $8011,Y
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
    BCC L_BB2E
    INC $74
L_BB2E:
    PLA 
    AND #$40
    ASL 
    ASL 
    ROL 
    ASL 
    ORA #$04
    STA $44
    STA $42
    STA $DE80
    LDY #$77
L_BB40:
    LDA ($02),Y
    STA $3C00,Y
    DEY 
    BPL L_BB40
    JSR $0FDC
    CLC 
    RTS 
    LDA #$04
    STA $42
    STA $DE80
    LDY #$0F
L_BB56:
    LDA $7F
    EOR $8001,Y
    BEQ L_BB60
    DEY 
    BPL L_BB56
L_BB60:
    INY 
    BCC L_BB65
    DEY 
    DEY 
L_BB65:
    TYA 
    AND #$0F
    TAY 
    LDA $8001,Y
    BEQ L_BB60
    STA $7F
    JMP $0FDC
    LDA $44
    STA $42
    STA $DE80
    LDX #$FF
    STX $26
    INX 
L_BB7F:
    LDA ($08),Y
    STA $0200,X
    BEQ L_BB88
    STX $26
L_BB88:
    INY 
    INX 
    CPX $3C01
    BNE L_BB7F
    LDA #$02
    STA $42
    STA $DE80
    RTS 
    LDA $1F
    AND #$01
    ASL 
    TAY 
    LDA L_94D3,Y
    STA $13D1
    TYA 
    BEQ L_BBA8
    LDA #$FF
L_BBA8:
    STA $24
    LDX $26
    TXA 
    ASL 
    ASL 
    ASL 
    TAY 
L_BBB1:
    LDA $0200,X
    BEQ L_BBE3
    LDA #$35
    STA $01
    BIT $43
    BPL L_BBC1
    LDA ($02),Y
    PHA 
L_BBC1:
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
    BPL L_BBE3
    LDA #$0C
    STA $42
    STA $DE80
    PLA 
    STA ($02),Y
L_BBE3:
    TYA 
    SEC 
    SBC #$08
    TAY 
    DEX 
    BPL L_BBB1
    JMP $0FDC
    BCC L_BC1D
    JSR $0FDC
    LDX $22
    LDY $4F
    JSR L_82D3
    JSR $0FD0
    LDX $51
L_BBFF:
    LDY #$07
    LDA #$00
L_BC03:
    ORA ($02),Y
    DEY 
    BPL L_BC03
    TAY 
    BNE L_BC19
    LDA $02
    SEC 
    SBC #$08
    STA $02
    BCS L_BC16
    DEC $03
L_BC16:
    DEX 
    BNE L_BBFF
L_BC19:
    STX $23
    BEQ L_BC3F
L_BC1D:
    JSR $0FDC
    LDX $22
    INX 
    CPX #$64
    BEQ L_BC38
    LDY $4D
    JSR L_82D3
    LDA $43
    STA $44
    LDX $02
    LDY $03
    STX $04
    STY $05
L_BC38:
    LDX $22
    LDY $4D
    JSR L_82D3
L_BC3F:
    JMP $0FE8
    JSR $0FD0
    LDY #$07
L_BC47:
    LDA ($02),Y
    STA $0200,Y
    DEY 
    BPL L_BC47
    LDA #$00
    TAY 
    LDX $22
    CPX #$63
    BEQ L_BC6F
    LDA #$37
    STA $01
    LDX #$34
    LDA $44
    STA $42
    STA $DE80
    BPL L_BC69
    LDX #$37
L_BC69:
    STX $01
    LDY #$05
L_BC6D:
    LDA ($04),Y
L_BC6F:
    STA $0208,Y
    DEY 
    BPL L_BC6D
    LDA $02
    CLC 
    ADC #$08
    STA $02
    BCC L_BC80
    INC $03
L_BC80:
    LDA $04
    CLC 
    ADC #$08
    STA $04
L_BC87:
    BCC L_BC8B
    INC $05
L_BC8B:
    JMP $0FE8
    LDA #$7F
    STA $DC0D
    STA $DD0D
    JSR $0FDC
    JSR $AFFC
    LDA #$00
    STA L_D015
    STA $0C
    LDA #$93
    JSR CBM_CHROUT
    LDA L_DD00
    AND #$FB
    STA L_DD00
    LDA L_DD02
    ORA #$04
    STA L_DD02
    LDA #$00
    STA $06
    STA $07
    LDA #$61
    STA $0B
    LDA #$03
    STA $08
L_BCC6:
    LDA $08
    ASL 
    STA $DE80
    JSR $1524
    BIT $0C
    BMI L_BCF2
    LDA $08
    LSR 
    BCS L_BCF2
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
L_BCF2:
    JSR $154F
    INC L_D020
    DEC $08
    BPL L_BCC6
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
L_BD34:
    LDA ($02),Y
    STA ($04),Y
    SEC 
    SBC $02
    CLC 
    ADC $06
    STA $06
    BCC L_BD44
    INC $07
L_BD44:
    INY 
    BNE L_BD34
L_BD47:
    INC $03
    INC $05
    DEX 
    BNE L_BD34
    RTS 
    LDA #$80
    STA $03
    LDA #$20
    STA $05
    LDY #$00
    STY $02
    STY $04
    LDX #$40
L_BD5F:
    LDA ($02),Y
    CMP ($04),Y
    BEQ L_BD7B
    STA $0A
    LDA L_DD00
    ORA #$04
    STA L_DD00
    AND #$FB
    STA L_DD00
    LDA ($04),Y
    STA $09
    JSR $160B
L_BD7B:
    INY 
    BNE L_BD5F
    INC $03
    INC $05
    DEX 
    BNE L_BD5F
    RTS 
    LDA #$80
    STA $03
    LDY #$00
    STY $02
    LDA #$40
    STA $0D
L_BD92:
    LDX #$0A
L_BD94:
    STX $DE80
    LDA ($02),Y
    STA $2000,X
    DEX 
    DEX 
    BPL L_BD94
    LDX #$0A
L_BDA2:
    STX $DE80
    LDA ($02),Y
    CMP $2000,X
    BEQ L_BDC7
    STA $0A
    LDA L_DD00
    ORA #$04
    STA L_DD00
    AND #$FB
    STA L_DD00
    TXA 
    LSR 
    STA $08
    LDA $2000,X
    STA $09
    JSR $160B
L_BDC7:
    DEX 
    DEX 
    BPL L_BDA2
    INC L_D020
    INY 
    BNE L_BD92
    INC $03
    DEC $0D
    BNE L_BD92
    RTS 
    LDA #$80
    STA $03
    LDY #$00
    STY $02
    LDX #$40
L_BDE2:
    TYA 
    EOR L_D012
    STA $09
    STA ($02),Y
    LDA ($02),Y
    CMP $09
    BEQ L_BE02
    STA $0A
    LDA L_DD00
    ORA #$04
    STA L_DD00
    AND #$FB
    STA L_DD00
    JSR $160B
L_BE02:
    INY 
    BNE L_BDE2
    INC $03
    DEX 
    BNE L_BDE2
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
    !byte $68
    !byte $29
    !byte $0F
    !byte $09
    !byte $30
    !byte $C9
    !byte $3A
    !byte $90
    !byte $02
    !byte $69
    !byte $26
    !byte $4C
    !byte $D2
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !byte $00
    !byte $00
    !byte $FF
    !byte $FF
    !by $00
    !by $00
    !byte $FF
    !byte $FF
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
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    BRK 
    !by $00
    !by COLOR_TEXT_TEXT
    !by COLOR_TEXT_BACKGROUND
    !by COLOR_TEXT_MENU
    !by COLOR_GRAPHIC_TEXT+COLOR_GRAPHIC_BACKGROUND
    !by $00
    !by $00
    ORA ($00,X)
    !byte $00
    !byte $00
    !byte $00
    !byte $00
    !byte $04
    !byte $01
    !byte $00
    !byte $00
    !byte $41
    !byte $65
    !byte $0A
    !byte $00
    !byte $00
    !byte $00
    !byte $FF
    !byte $1B
    !byte $33
    !byte $18
    !byte $FF
    !byte $1B
    !byte $33
    !byte $17
    !byte $FF
    !byte $1B
    !byte $33
    !byte $16
    !byte $FF
    !byte $1B
    !byte $33
    !byte $15
    !byte $FF
    !byte $1B
    !byte $33
    !byte $01
    !byte $FF
    !byte $1B
    !byte $2A
    !byte $04
    !byte $FF
    !byte $1B
    !byte $5A
    !byte $FF
    !byte $1B
    !byte $4B
    !byte $FF
    !byte $1B
    !byte $2A
    !byte $03
    !byte $FF
    !byte $1B
    !byte $40
    !byte $FF
    !byte $1B
    !byte $43
    !byte $FF
}

* = $4000

!pseudopc $C000 {
    LDX #$FE
    TXS 
    !byte $20
    !byte $EC
    !byte $AE
    !byte $20
    !byte $82
    !byte $80
    !byte $20
    !byte $74
    !byte $86
    !byte $20
    !byte $A5
    !byte $8B
    !byte $4C
    !byte $06
    !byte $80
    !byte $64
    !byte $44
    JMP ($6372)
    BVS $C083
    !byte $6D
    !byte $74
    !byte $67
    !byte $61
    !byte $73
    !byte $65
    JSR L_C17F
    LDX $A7
    ADC #$5F
    LDY #$A1
    !byte $A2
    !byte $A3
    !byte $6F
    !byte $78
    !byte $75
    !byte $30
    !byte $B1
    !byte $B2
    !byte $2E
    !byte $B5
    !byte $B6
    !byte $B7
    !byte $50
    !byte $BA
    !byte $B8
    !byte $C3
    !byte $66
    !byte $4D
    !byte $5E
    !byte $77
    !byte $AF
    !byte $A8
    !byte $AA
    !byte $6B
    !byte $02
    !byte $96
    !byte $BD
    !byte $95
    LSR $82,X
    ROL $82
    EOR $AA82
    !byte $82
    !byte $EB
    LDX $81A4
    LDY $81
    LDY $81
    LDY $81
    !byte $C3
    !byte $94
    !byte $C3
    !byte $94
    !byte $C3
    !byte $94
    !byte $7F
    !byte $8A
    !byte $C0
    !byte $8A
    !byte $E1
    !byte $8A
    !byte $85
    !byte $82
    !byte $3D
    !byte $84
    !byte $CC
    !byte $84
    !byte $D5
    !byte $83
    !byte $2E
    !byte $84
    !byte $47
    !byte $86
    CPX $F283
    !byte $83
    NOP 
    STA ($E0),Y
    STA ($EC),Y
    STA ($4A,X)
    !byte $83
    ADC $81
    ORA ($84),Y
    !byte $1A
    STY $B7
    TXA 
    JSR CBM_GETIN
    BEQ L_C0A6
    LDX $28
    CPX #$08
    BNE L_C094
    CMP #$A0
    BCS L_C094
    JMP L_8119
L_C094:
    LDX #$2D
L_C096:
    CMP $8012,X
    BEQ L_C0A7
    DEX 
    BPL L_C096
    CMP #$31
    BCC L_C0A6
    CMP #$39
    BCC L_C0B9
L_C0A6:
    RTS 
L_C0A7:
    TXA 
    CMP #$0D
    BCC L_C0BC
    TAY 
    ASL 
    TAX 
    LDA $8027,X
    PHA 
    LDA $8026,X
    PHA 
    TYA 
    RTS 
L_C0B9:
    JMP $81FE
L_C0BC:
    PHA 
    CMP #$08
    BNE L_C0CE
    LDA #$01
    STA $7F
    JSR $AEE2
    BCC L_C0CE
    PLA 
    LDA $28
    PHA 
L_C0CE:
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
    !byte $BD
    !byte $0B
    !byte $81
    !byte $85
    !byte $48
    !byte $BC
    !byte $FD
    !byte $80
    !byte $24
    !byte $29
    !byte $10
    !byte $04
    !byte $A9
    !byte $05
    !byte $A0
    !byte $02
    !byte $8C
    !byte $15
    !byte $D0
    !byte $20
    !byte $3F
    !byte $AF
    !byte $20
    !byte $9A
    !byte $86
    !byte $4C
    !byte $DE
    !byte $94
    !byte $02
    !byte $02
    !byte $02
    !byte $02
    !byte $02
    !byte $02
    !byte $02
    !byte $02
    !byte $02
    !byte $02
    !byte $03
    !byte $03
    !byte $02
    !byte $02
    !byte $00
    !byte $00
    !byte $00
    !byte $00
    !byte $00
    !byte $00
    !byte $00
    !byte $00
    !byte $00
    !byte $02
    !byte $02
    !byte $02
    !byte $02
    !byte $02
    STA $61
    LDY $34
    BNE L_C139
    CMP #$21
    BCC L_C151
    JSR $869A
    JSR L_8AE2
    JSR $0EE7
    LDX #$02
    STX $49
L_C130:
    LDA $0B,X
    STA $0F,X
    DEX 
    BPL L_C130
    LDY #$00
L_C139:
    CPY #$40
    BCS L_C151
    LDA $61
    CMP #$20
    BCC L_C152
    STA $02C0,Y
    INC $34
    LDA $29
    ORA #$04
    STA $29
    JSR $ADB1
L_C151:
    RTS 
L_C152:
    CMP #$0F
    BEQ L_C15C
    JSR $A8B8
    JMP L_817F
L_C15C:
    CLC 
    JSR $134D
    JSR $AEAA
    JMP L_817F
    LDA $34
    BEQ L_C173
    DEC $34
    JSR L_817F
    LDA $34
    BEQ L_C174
L_C173:
    RTS 
L_C174:
    LDA #$00
    STA $34
    LDA $29
    AND #$FB
    STA $29
    RTS 
L_C17F:
    JSR $0F03
    LDA $34
    BEQ L_C1A4
    LDX #$02
L_C188:
    LDA $13,X
    STA $0F,X
    DEX 
    BPL L_C188
    LDY #$00
L_C191:
    LDA $02C0,Y
    STA $61
    TYA 
    PHA 
    JSR $ADB1
    PLA 
    BCS L_C1A4
    TAY 
    INY 
    CPY $34
    BCC L_C191
L_C1A4:
    RTS 
    AND #$03
    STA $49
    LDA $34
    BEQ L_C1B0
    JMP L_817F
L_C1B0:
    LDA $4A
    AND #$30
    BEQ L_C1B9
    JMP $91F9
L_C1B9:
    JSR $0EE7
L_C1BC:
    LDY $49
    TYA 
    LSR 
    TAX 
    LDA $81E5,Y
    CMP $2A,X
    BEQ L_C1DF
    LDA $2A,X
    CLC 
    ADC L_81E9,Y
    STA $2A,X
    JSR $0F03
    LDA $CB
    CMP #$40
    BNE L_C1BC
    LDA $3F
    AND #$05
    BNE L_C1BC
L_C1DF:
    JSR L_89B3
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
    JSR L_8AEC
    JMP $AEFC
    PHA 
    JSR $0EE7
    PLA 
    AND #$0F
    TAX 
    DEX 
    LDA $8217,X
    STA $2A
    LDA L_821F,X
    STA $2B
    JSR $0F03
    JMP L_89B3
    BRK 
    BRK 
    ORA $3219,Y
    !byte $32
    !byte $4B
    !byte $4B
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
    BNE L_C23C
    CPY $2D
    BNE L_C23C
    LDX $2E
    LDY $2F
    BCS L_C244
L_C23C:
    STX $2E
    STY $2F
    LDX $2C
    LDY $2D
L_C244:
    STX $2A
    STY $2B
    JSR $0F03
    JMP L_89B3
    LDX $2A
    LDY $2B
    STX $2C
    STY $2D
    RTS 
    BIT $4A
    BMI L_C273
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
L_C273:
    LDA #$60
    JSR L_92A9
    JSR $0EF0
    JMP $0F03
    LDA $29
    AND #$08
    BEQ L_C2AA
    BNE L_C28C
    LDA $29
    EOR #$08
    STA $29
L_C28C:
    LDA #$C0
    STA $02
    LDA #$5F
    STA $03
    LDY #$40
    LDX #$1C
L_C298:
    LDA ($02),Y
    EOR #$80
    STA ($02),Y
    TYA 
    CLC 
    ADC #$08
    TAY 
    BCC L_C298
    INC $03
    DEX 
    BPL L_C298
L_C2AA:
    RTS 
    LDA #$00
    STA $02
    LDA #$7C
    STA $03
    LDY #$C0
    LDX #$1C
L_C2B7:
    DEY 
    LDA ($02),Y
    EOR #$FF
    STA ($02),Y
    TYA 
    BNE L_C2B7
    DEC $03
    DEX 
    BPL L_C2B7
    RTS 
    BIT $4B
    BVS L_C2CF
    DEC $46
    BVC L_C2D7
L_C2CF:
    INC $46
    BPL L_C2D7
    STX $46
    STY $47
L_C2D7:
    LDA $46
    LDX #$00
L_C2DB:
    CMP #$19
    BCC L_C2E4
    SBC #$19
    INX 
    BCS L_C2DB
L_C2E4:
    STA $1C
    LDA L_830C,X
    STA $45
    LDA L_8310,X
    STA $43
    TXA 
    PHA 
    LDA $47
    STA $1D
    !byte $A2
    !byte $1C
    !byte $A0
    !byte $04
    !byte $20
    !byte $18
    !byte $83
    !byte $A2
    !byte $02
    !byte $20
    !byte $41
    !byte $83
    !byte $68
    !byte $AA
    !byte $A5
    !byte $03
    !byte $1D
    !byte $14
    !byte $83
    !byte $85
    !byte $03
    !byte $60
    !byte $34
    !byte $34
    !byte $37
    !byte $37
    !byte $0C
    !byte $0C
    DEY 
    TXA 
    !byte $80
    CPY #$80
    !byte $80
    LDA #$00
    STA $03
    LDA $00,X
    ASL 
    ASL 
    ADC $00,X
L_C322:
    ASL 
    ROL $03
    DEY 
    BNE L_C322
    ADC $01,X
    BCC L_C32E
    INC $03
L_C32E:
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
L_C343:
    ASL $00,X
    ROL $01,X
    DEY 
    BNE L_C343
    RTS 
    JSR $0EE7
    LDA $2A
    SEC 
    SBC #$0C
    BCS L_C357
    LDA #$00
L_C357:
    CMP #$36
    BCC L_C35D
    LDA #$36
L_C35D:
    TAX 
    LDA #$00
    JSR L_837F
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
    JSR L_82D3
    LDY #$02
    LDA #$17
    LDX #$00
    BIT $1F
    BPL L_C396
    LDY #$04
    LDA #$19
    LDX #$18
L_C396:
    STY $25
    STA $27
    STX $04
    LDY #$60
    STY $05
L_C3A0:
    LDA $04
    STA $06
    LDA $05
    STA $07
    LDA #$28
    BIT $1F
    BPL L_C3B0
    LDA #$14
L_C3B0:
    STA $26
    JSR $1038
    JSR $82CF
    LDA $25
    EOR #$06
    CLC 
    ADC $04
    STA $04
    AND #$07
    BNE L_C3A0
    LDA $04
    SEC 
    SBC #$08
    STA $04
    LDX #$04
    JSR $8331
    DEC $27
    BNE L_C3A0
    RTS 
    JSR $0EE7
    JSR $8B0E
    BCS L_C3EA
    LDA #$00
    STA $70
    JSR $0E1B
    BCS L_C3EA
    JSR $0E24
L_C3EA:
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
    BCS L_C40D
    STA $2A
L_C40D:
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
L_C431:
    DEX 
    LDA $6000,X
    STA $0D00,X
    TXA 
    BNE L_C431
    JMP L_9531
    JSR $0EE7
    LDA #$00
    STA $71
    JSR L_8467
    BCS L_C461
    PHA 
    JSR CBM_CLRCHN
    JSR $AF0D
    JSR L_8AEC
    PLA 
    BCS L_C461
    STA $1F
    LDX #$08
    JSR CBM_CHKIN
    JSR $1134
L_C461:
    JSR L_8658
    JMP $AEFC
    PHA 
    JSR $0DE0
    PLA 
    JSR $0E05
    BCS L_C4CC
    LDY #$00
    JSR $B209
    BCS L_C4CC
    JSR CBM_CHRIN
    LDY $90
    BNE L_C4A9
    LDY #$00
    CMP #$47
    BEQ L_C4AE
    INY 
    CMP #$42
    BEQ L_C4AE
    TAX 
    JSR CBM_CHRIN
    CPX #$50
    BNE L_C4A6
    STA $22
    JSR CBM_CHRIN
    STA $23
    JSR $B156
L_C49C:
    JSR CBM_CHRIN
    TAX 
    BNE L_C49C
    LDY #$02
    BNE L_C4BC
L_C4A6:
    STX $71
    TXA 
L_C4A9:
    SEC 
    BNE L_C4CC
    LDY #$41
L_C4AE:
    TYA 
    AND #$03
    TAX 
    LDA $8543,X
    STA $22
    LDA $8545,X
    STA $23
L_C4BC:
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
L_C4CC:
    RTS 
    JSR $0EE7
    LDA #$00
    STA $71
    JSR $8552
    BCS L_C540
    PHA 
    JSR $0DE0
    LDA #$03
    JSR $0DF7
    PLA 
    BCS L_C540
    STA $1F
    LDY #$01
    JSR $B209
    BCS L_C53D
    LDA $1F
    CMP #$01
    BNE L_C508
    LDX $0430
    CPX #$30
    BNE L_C508
    ORA #$40
    STA $1F
    LDA #$00
    JSR CBM_CHROUT
    LDA #$20
    BNE L_C522
L_C508:
    TAX 
    LDA $8547,X
    JSR CBM_CHROUT
    CPX #$02
    BCC L_C525
    LDA $50
    JSR CBM_CHROUT
    LDA $51
    JSR CBM_CHROUT
    JSR $1238
    LDA #$00
L_C522:
    JSR CBM_CHROUT
L_C525:
    JSR $11DD
    BIT $1F
    BVS L_C53D
    LDX #$03
    LSR $1F
    BCC L_C534
    LDX #$07
L_C534:
    LDA $854A,X
    JSR CBM_CHROUT
    DEX 
    BPL L_C534
L_C53D:
    JSR L_8658
L_C540:
    JMP $AEEC
    !byte $32
    ORA $2850,Y
    !byte $47
    !byte $42
    BVC $C50A
    JSR L_9B00
    BRK 
    BRK 
    CPY #$9B
    JSR L_94D6
    LDY #$2F
L_C557:
    LDA $B8E7,Y
    STA $7DA0,Y
    LDA L_B917,Y
    STA $7EE0,Y
    DEY 
    BPL L_C557
    JSR $B285
L_C569:
    JSR L_8674
    JSR CBM_GETIN
    CMP #$B3
    BEQ L_C5BB
    LDA $3F
    AND #$05
    BEQ L_C569
    BIT $29
    BPL L_C5BB
    LDX #$04
    LDA $0B
L_C581:
    LSR $0C
    ROR 
    DEX 
    BNE L_C581
    SEC 
    SBC #$0E
    BCC L_C5BB
    CMP #$02
    BEQ L_C5B5
    BCS L_C5BB
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
    JSR L_8AEC
    LDA $2A
    STA $4C
    LDA $2B
    STA $4D
    LDA #$C0
    STA $4B
    PLA 
    RTS 
L_C5B5:
    PHA 
    JSR $8B0E
    PLA 
    RTS 
L_C5BB:
    SEC 
    RTS 
    CMP $24
    BNE L_C5C4
    JMP L_8641
L_C5C4:
    PHA 
    LDA #$02
    BIT $1F
    BEQ L_C5F9
    LDA $27
    BEQ L_C5E2
L_C5CF:
    LDA #$9B
    JSR CBM_CHROUT
    LDA #$00
    JSR CBM_CHROUT
    LDA $24
    JSR CBM_CHROUT
    DEC $27
    BNE L_C5CF
L_C5E2:
    LDA $26
    BEQ L_C63E
    CMP #$04
    BCS L_C5F0
    LDA $24
    CMP #$9B
    BNE L_C62C
L_C5F0:
    LDA #$9B
    JSR CBM_CHROUT
    LDA $26
    BNE L_C621
L_C5F9:
    BVC L_C603
    LDA $26
    ORA $27
    BEQ L_C63E
    BNE L_C62C
L_C603:
    LDA $27
    BNE L_C615
    LDA $26
    BEQ L_C63E
    CMP #$05
    BCS L_C615
    LDA $24
    CMP #$9B
    BNE L_C62C
L_C615:
    LDA #$9B
    JSR CBM_CHROUT
    LDA $26
    JSR CBM_CHROUT
    LDA $27
L_C621:
    JSR CBM_CHROUT
    LDA #$01
    STA $26
    LDA #$00
    STA $27
L_C62C:
    LDA $24
    JSR CBM_CHROUT
    DEC $26
    BNE L_C62C
    LDA $27
    BEQ L_C63E
    DEC $27
    JMP L_862C
L_C63E:
    PLA 
    STA $24
    INC $26
    BNE L_C647
    INC $27
L_C647:
    RTS 
    JSR $0DE0
    LDA #$02
    JSR $0DF7
    BCS L_C655
    JSR L_865D
L_C655:
    JMP $AEFF
    JSR $B222
    LDA #$00
    JSR $0E10
    BCS L_C66B
    LDA $71
    BEQ L_C673
    LDA #$0B
    JSR $0DE9
L_C66B:
    JSR $AFFC
L_C66E:
    JSR $0E2D
    BEQ L_C66E
L_C673:
    RTS 
    LDA $36
    AND #$C0
    BEQ L_C699
    JSR $869A
    BIT $36
    BVC L_C699
    SEI 
    LDA $36
    AND #$BF
    STA $36
    CLI 
    BIT $29
    BMI L_C699
    JSR L_89B3
    LDA #$04
    BIT $29
    BEQ L_C699
    JSR $8D41
L_C699:
    RTS 
    SEI 
    LDX $48
    LDA #$EF
    CMP $19
    BCS L_C6A5
    STA $19
L_C6A5:
    LDA $8784,X
    CMP $19
    BCC L_C6AE
    STA $19
L_C6AE:
    LDY #$00
    LDA L_878E,X
    CMP $19
    BCS L_C6CC
    LDY #$80
    LDA $19
    CMP #$E0
    BCS L_C6CC
    LDA #$E0
    BIT $29
    BPL L_C6CA
L_C6C5:
    LDY #$00
    LDA L_878E,X
L_C6CA:
    STA $19
L_C6CC:
    TYA 
    EOR $29
    BPL L_C6F9
    STY $1C
    LDA $29
    AND #$7F
    ORA $1C
    STA $29
    BPL L_C6EC
    LDA $3F
    AND #$05
    BNE L_C6C5
    LDA #$02
    STA L_D015
    LDA #$03
    BNE L_C6F6
L_C6EC:
    LDX $28
    LDA $80FD,X
    STA L_D015
    LDA $48
L_C6F6:
    JSR $AF3F
L_C6F9:
    LDX $48
    BIT $29
    BPL L_C701
    LDX #$00
L_C701:
    LDA $18
    BNE L_C710
    LDA $877F,X
    CMP $17
    BCC L_C71D
    STA $17
    BCS L_C71D
L_C710:
    LDA #$01
    STA $18
    LDA L_8789,X
    CMP $17
    BCS L_C71D
    STA $17
L_C71D:
    JSR L_872B
    JSR $8756
    LDA $36
    AND #$7F
    STA $36
    CLI 
    RTS 
    LDA $19
    STA L_D001
    STA L_D003
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
    STA L_D004
    LDA $18
    ASL 
    ORA $18
    STA $D010
    RTS 
    LDX $48
    BIT $29
    BPL L_C764
    LDX #$00
    BIT $38
    BMI L_C764
    LDX #$03
L_C764:
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
    !byte $E9
    !byte $00
    !byte $85
    !byte $0C
    !byte $60
    !byte $0E
    !byte $26
    !byte $18
    !byte $C6
    !byte $30
    !byte $28
    !byte $28
    !byte $32
    PLP 
    !byte $32
    EOR $40C5
    EOR $DFD0
    !byte $EF
    CMP $EF,X
    !byte $FA
    LDA $36
    AND #$C0
    BEQ L_C7C4
    JSR $87C5
    BIT $36
    BVC L_C7C4
    SEI 
    LDA $36
    AND #$BF
    STA $36
    CLI 
    BIT $29
    BMI L_C7C4
    JSR L_89CA
    LDA #$04
    BIT $29
    BEQ L_C7C4
    LDX #$03
L_C7B7:
    LDA $13,X
    STA $0F,X
    DEX 
    BPL L_C7B7
    JSR $9F11
    JSR $8DDD
L_C7C4:
    RTS 
    SEI 
    LDX $48
    LDA $18
    BNE L_C7D7
    LDA $877F,X
    CMP $17
    BCC L_C7E7
    STA $17
    BCS L_C7E7
L_C7D7:
    LDA #$01
    STA $18
    LDA #$4D
    CMP $17
    BCS L_C7E3
    STA $17
L_C7E3:
    LDY #$80
    BNE L_C813
L_C7E7:
    LDY #$00
    LDA L_8789,X
    CPX #$04
    BNE L_C7F2
    SBC $40
L_C7F2:
    CMP $17
    BCS L_C813
    LDY #$80
    LDA $17
    CMP #$C6
    BCS L_C813
    LDA #$C6
    BIT $29
    BPL L_C811
L_C804:
    LDY #$00
    STY $18
    LDA L_8789,X
    CPX #$04
    BNE L_C811
    SBC $40
L_C811:
    STA $17
L_C813:
    TYA 
    EOR $29
    BPL L_C841
    STY $1C
    LDA $29
    AND #$7F
    ORA $1C
    STA $29
    BPL L_C831
    BIT $38
    BMI L_C804
    LDA #$02
    STA L_D015
    LDA #$03
    BNE L_C83E
L_C831:
    LDX #$02
    LDA $48
    CMP #$01
    BEQ L_C83B
    LDX #$06
L_C83B:
    STX L_D015
L_C83E:
    JSR $AF3F
L_C841:
    LDX $48
    BIT $29
    BPL L_C849
    LDX #$03
L_C849:
    LDA $8784,X
    CMP $19
    BCC L_C852
    STA $19
L_C852:
    LDA L_878E,X
    CPX #$04
    BNE L_C85B
    SBC $41
L_C85B:
    CMP $19
    BCS L_C861
    STA $19
L_C861:
    JSR L_872B
    JSR $8756
    LDA $36
    AND #$7F
    STA $36
    CLI 
    RTS 
    LDA #$FF
    STA L_DC00
    LDA $36
    AND #$18
    BNE L_C897
    LDX $D419
    CPX #$FF
    BEQ L_C8D0
    LDX #$00
L_C883:
    NOP 
    NOP 
    INX 
    BNE L_C883
    LDA #$08
    LDX L_D41A
    CPX #$FF
    BNE L_C893
    LDA #$10
L_C893:
    ORA $36
    STA $36
L_C897:
    AND #$08
    BEQ L_C8DD
    LDX #$01
L_C89D:
    LDA $D419,X
    TAY 
    SEC 
    SBC $3B,X
    AND #$7F
    CMP #$40
    BCS L_C8AF
    LSR 
    BEQ L_C8BB
    BNE L_C8B6
L_C8AF:
    EOR #$7F
    BEQ L_C8BB
    LSR 
    EOR #$FF
L_C8B6:
    PHA 
    TYA 
    STA $3B,X
    PLA 
L_C8BB:
    STA $39,X
    DEX 
    BPL L_C89D
    LDA #$00
    SEC 
    SBC $3A
    STA $3A
    LDA $DC01
    EOR #$FF
    LSR 
    JMP $8916
L_C8D0:
    ASL $3F
    ASL $3F
    LDA #$00
    STA $3A
    STA $39
    JMP $8923
L_C8DD:
    LDA #$00
    STA $DC02
    LDA #$10
    STA L_DC03
    LDX #$00
    LDY #$08
L_C8EB:
    LDA #$00
    JSR L_8975
    ASL 
    ASL 
    ASL 
    ASL 
    STA $39,X
    LDA #$10
    JSR L_8975
    AND #$0F
    ORA $39,X
    CLC 
    ADC #$01
    STA $39,X
    INX 
    CPX #$02
    BNE L_C8EB
    LDA #$00
    STA L_DC03
    LDX $D419
    CPX #$FF
    BEQ L_C916
    CLC 
L_C916:
    ROL $3F
    CLC 
    LDA $DC01
    AND #$10
    BNE L_C921
    SEC 
L_C921:
    ROL $3F
    LDA L_DC00
    EOR #$FF
    LDX #$FF
    STX $DC02
    PHA 
    CLC 
    AND #$10
    BEQ L_C934
    SEC 
L_C934:
    ROL $3F
    PLA 
    AND #$0F
    BEQ L_C965
    LDX $3E
    BNE L_C962
    LSR 
    BCC L_C944
    DEC $3A
L_C944:
    LSR 
    BCC L_C949
    INC $3A
L_C949:
    LSR 
    BCC L_C94E
    DEC $39
L_C94E:
    LSR 
    BCC L_C953
    INC $39
L_C953:
    LDX $3D
    BEQ L_C974
    LDA $36
    LSR 
    BCC L_C95D
    DEX 
L_C95D:
    STX $3D
    STX $3E
    RTS 
L_C962:
    DEC $3E
    RTS 
L_C965:
    LDX #$01
    LDA $36
    LSR 
    BCC L_C96E
    LDX #$0A
L_C96E:
    STX $3D
    LDA #$00
    STA $3E
L_C974:
    RTS 
    STA $DC01
L_C978:
    NOP 
    NOP 
    NOP 
    DEY 
    BNE L_C978
    LDY #$05
    LDA $DC01
    RTS 
    TYA 
    PHA 
    LDY #$00
    TXA 
    BPL L_C98C
    DEY 
L_C98C:
    CLC 
    ADC $17
    TAX 
    TYA 
    ADC $18
    BPL L_C998
    LDA #$00
    TAX 
L_C998:
    STX $17
    AND #$01
    STA $18
    PLA 
    CLC 
    BMI L_C9AA
    ADC $19
    BCC L_C9B0
    LDA #$FF
    BNE L_C9B0
L_C9AA:
    ADC $19
    BCS L_C9B0
    LDA #$00
L_C9B0:
    STA $19
    RTS 
    BIT $29
    BVS L_C9C9
    LDX #$00
    LDY $2B
    LDA #$60
    JSR $89D9
    LDX #$02
    LDY $2A
    LDA #$60
    JSR $89D9
L_C9C9:
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
    LDA L_8A5E,X
    STA $07
    TYA 
    JSR $8A6B
    ASL $1F
    BCC L_C9F6
    LDY #$02
L_C9EF:
    ASL $1A
    ROL $1B
    DEY 
    BNE L_C9EF
L_C9F6:
    ASL $1F
    BCC L_CA16
    LDA $1A
    SEC 
    SBC $30,X
    STA $1A
    LDA $1B
    SBC $31,X
    STA $1B
    BCS L_CA16
    LDA #$00
    SEC 
    SBC $1A
    STA $1A
    LDA #$00
    SBC $1B
    STA $1B
L_CA16:
    LDY #$1F
    ASL $1F
    BCC L_CA4A
    LDA $29
    AND #$10
    BEQ L_CA4A
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
L_CA4A:
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
    !byte $5A
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
    JMP L_89B3
    LDX #$02
L_CAA3:
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
    BPL L_CAA3
    JMP L_89CA
    LDA $29
    EOR #$10
    STA $29
    JMP L_89B3
    LDY $48
    BIT $29
    BPL L_CAC9
    LDY #$00
L_CAC9:
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
    JMP L_867A
    LDX #$03
L_CAE4:
    LDA $0B,X
    STA $13,X
    DEX 
    BPL L_CAE4
    RTS 
    JSR $8366
    LDA #$04
    STA $48
    JSR $AF3F
    LDA #$06
    STA L_D015
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
    BNE L_CB1F
    JSR $8366
    LDA #$01
    STA $48
    JSR $AF3F
    LDA #$02
    STA L_D015
    LDA #$98
L_CB1F:
    STA $38
    SEI 
    LDA #$00
    STA $18
    LDA $36
    ORA #$C0
    STA $36
    CLI 
    JSR $B285
L_CB30:
    JSR $8793
    JSR CBM_GETIN
    CMP #$B3
    BEQ L_CB95
    CMP #$30
    BEQ L_CB60
    LDA $3F
    AND #$05
    BEQ L_CB30
    JSR $B285
    LDA #$08
    BIT $38
    BEQ L_CB8A
    LDA $29
    EOR #$04
    STA $29
    AND #$04
    BEQ L_CB66
    JSR $9F0D
    JSR L_8AE2
    JMP L_8B30
L_CB60:
    JSR L_8AA1
    JMP L_8B30
L_CB66:
    JSR $9282
    LDX #$02
    LDY #$00
L_CB6D:
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
    BPL L_CB6D
    BMI L_CB94
L_CB8A:
    LDA $0B
    LSR 
    STA $2B
    LDA $0D
    LSR 
    STA $2A
L_CB94:
    CLC 
L_CB95:
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
    BEQ L_CBEF
    JSR $869A
    LDA $29
    BMI L_CBEC
    AND #$02
    BNE L_CBDF
    LDA #$00
    LDX $28
    CPX #$02
    BCS L_CBCE
    JSR L_9092
    JSR L_8C82
    LDY #$00
    EOR ($02),Y
    AND $0A
    BEQ L_CBCE
    LDA #$01
L_CBCE:
    LDX $028D
    BEQ L_CBD5
    EOR #$01
L_CBD5:
    LSR $29
    ASL $29
    ORA $29
    ORA #$02
    STA $29
L_CBDF:
    LDA $28
    ASL 
    TAX 
    LDA $8C06,X
    PHA 
    LDA $8C05,X
    PHA 
    RTS 
L_CBEC:
    JMP $958C
L_CBEF:
    LDA $29
    AND #$FD
    STA $29
    LDA $3F
    AND #$12
    CMP #$02
    BNE L_CC04
    LDA #$FF
    STA $3F
    JSR $95BE
L_CC04:
    RTS 
    !byte $32
    STY L_8C55
    ROL 
    STA $8D2A
    ROL 
    STA $8F9E
    AND ($8F),Y
    !byte $9C
    STA ($73),Y
    STA ($DE,X)
    STY L_8C97
    STY $8C,X
    !byte $9B
    STY L_9643
    LDX #$02
L_CC23:
    LDA $0B,X
    CMP L_8C52,X
    LDA $0C,X
    SBC L_8C53,X
    BCS L_CC51
    DEX 
    DEX 
    BPL L_CC23
    JSR L_9092
    LDY #$00
    LDA $29
    LSR 
    ROR $1F
    JSR L_8C82
    EOR $1F
    ASL 
    LDA $0A
    BCC L_CC4D
    EOR #$FF
    AND ($02),Y
    BCS L_CC4F
L_CC4D:
    ORA ($02),Y
L_CC4F:
    STA ($02),Y
L_CC51:
    RTS 
    RTI 
    ORA ($B8,X)
    BRK 
    LDA #$03
    STA $27
    DEC $0D
    LDA $0B
    BNE L_CC62
    DEC $0C
L_CC62:
    DEC $0B
L_CC64:
    LDA #$03
    STA $26
    LDA $0D
    PHA 
L_CC6B:
    JSR L_8C21
    INC $0D
    DEC $26
    BNE L_CC6B
    PLA 
    STA $0D
    INC $0B
    BNE L_CC7D
    INC $0C
L_CC7D:
    DEC $27
    BNE L_CC64
    RTS 
    LDA $29
    AND #$08
    BEQ L_CC94
    LDA $02
    AND #$07
    BEQ L_CC90
    LDA $0A
L_CC90:
    EOR $0A
    AND #$80
L_CC94:
    RTS 
    JSR $8C9C
    LDA #$00
    BEQ L_CC9E
    LDA #$80
L_CC9E:
    STA $1F
    LDA $0D
    PHA 
    LDX #$00
L_CCA5:
    JSR L_9092
    LDA #$18
    STA $20
    LDY #$00
L_CCAE:
    LDA $7F40,X
    STA $0200,Y
    INX 
    INY 
    CPY #$03
    BNE L_CCAE
    LDY #$00
L_CCBC:
    BIT $1F
    BMI L_CCCB
    ROL $0202
    ROL $0201
    ROL $0200
    BCC L_CCCE
L_CCCB:
    JSR L_8C3D
L_CCCE:
    JSR L_8D20
    DEC $20
    BNE L_CCBC
    INC $0D
    CPX #$3F
    BNE L_CCA5
    PLA 
    STA $0D
    RTS 
    JSR $8CEA
    LDA #$0A
    JSR L_80DE
    JMP $B285
    LDA $0D
    PHA 
    LDX #$00
L_CCEF:
    JSR L_9092
    LDA #$18
    STA $20
    LDY #$00
L_CCF8:
    JSR L_8C82
    CLC 
    EOR ($02),Y
    AND $0A
    BEQ L_CD03
    SEC 
L_CD03:
    ROL $7F42,X
    ROL $7F41,X
    ROL $7F40,X
    JSR L_8D20
    DEC $20
    BNE L_CCF8
    INC $0D
    INX 
    INX 
    INX 
    CPX #$3F
    BNE L_CCEF
    PLA 
    STA $0D
    RTS 
    LSR $0A
    BCC L_CD2A
    ROR $0A
    TYA 
    ADC #$08
    TAY 
L_CD2A:
    RTS 
    JSR $B285
    LDA $29
    EOR #$04
    PHA 
    AND #$04
    BEQ L_CD3D
    JSR $0EE7
    JSR L_8AE2
L_CD3D:
    PLA 
    STA $29
    RTS 
    LDA $28
    CMP #$08
    BNE L_CD4D
    JSR L_8AE2
    JMP L_817F
L_CD4D:
    LDX #$03
L_CD4F:
    LDA $13,X
    STA $0F,X
    DEX 
    BPL L_CD4F
    JSR $0F03
    LDA $28
    CMP #$02
    BEQ L_CD70
    CMP #$03
    BNE L_CD66
    JMP $8DDD
L_CD66:
    CMP #$04
    BNE L_CD6D
    JMP $8E26
L_CD6D:
    JMP L_924F
L_CD70:
    LDA $0D
    PHA 
    LDA $0B
    PHA 
    LDA $0C
    PHA 
    JSR L_9092
    JSR L_916F
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
L_CD93:
    JSR L_8C36
    LDA $0B
    CMP $0F
    BNE L_CDA8
    LDA $0C
    CMP $10
    BNE L_CDA8
    LDA $0D
    CMP $11
    BEQ L_CDD3
L_CDA8:
    BIT $09
    BMI L_CDC1
    JSR $9131
    BCC L_CDD3
    LDA $08
    SEC 
    SBC $04
    STA $08
    LDA $09
    SBC $05
    STA $09
    JMP $8D93
L_CDC1:
    JSR $90E6
    BCC L_CDD3
    LDA $08
    CLC 
    ADC $06
    STA $08
    BCC L_CD93
    INC $09
    BCS L_CD93
L_CDD3:
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
    JSR L_916F
    LDA $04
    CMP $06
    BCS L_CE31
    LDA $06
L_CE31:
    TAX 
    BEQ L_CE7C
    STA $08
    LDX $04
    BNE L_CE3C
    STA $04
L_CE3C:
    LDX $06
    BNE L_CE42
    STA $06
L_CE42:
    LDA $04
    STA $0F
    LDA #$00
    STA $11
    JSR L_8E7D
L_CE4D:
    JSR $8EEC
    LDA $0F
    BEQ L_CE7C
    INC $11
    LDA #$02
    JSR L_8E7D
    DEC $11
    DEC $0F
    LDA #$04
    JSR L_8E7D
    INC $0F
    LDA $0202
    CMP $0204
    LDA $0203
    SBC $0205
    BCS L_CE78
    INC $11
    BCC L_CE4D
L_CE78:
    DEC $0F
    BCS L_CE4D
L_CE7C:
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
    BEQ L_CEC6
    LDA $0200,X
    SEC 
    SBC $0200
    PHA 
    LDA $0201,X
    SBC $0201
    BCS L_CEBF
    TAY 
    PLA 
    EOR #$FF
    ADC #$01
    PHA 
    TYA 
    EOR #$FF
    ADC #$00
L_CEBF:
    STA $0201,X
    PLA 
    STA $0200,X
L_CEC6:
    RTS 
    CMP $08
    BEQ L_CEE7
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
L_CEE7:
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
    JSR L_8C21
    LDA $13
    SEC 
    SBC $0F
    STA $0B
    LDA $14
    SBC #$00
    STA $0C
    JSR L_8C21
    LDA $15
    SEC 
    SBC $11
    STA $0D
    LDA #$00
    SBC #$00
    STA $0E
    JSR L_8C21
    PLA 
    STA $0C
    PLA 
    STA $0B
    JMP L_8C21
    LDA #$0A
    STA $25
    LDX #$03
L_CF38:
    LDA $0B,X
    STA $0F,X
    DEX 
    BPL L_CF38
L_CF3F:
    LDA $A2
    LSR 
    LDY L_D012
    LDX #$00
    JSR $8F80
    TAX 
    BPL L_CF4F
    DEC $0C
L_CF4F:
    ADC $0B
    STA $0B
    BCC L_CF57
    INC $0C
L_CF57:
    LDA L_D012
    EOR $A2
    LDY $A2
    LDX #$02
    JSR $8F80
    ADC $0D
    STA $0D
    LDA $04
    ADC $06
    BCS L_CF72
    BMI L_CF72
    JSR L_8C21
L_CF72:
    LDX #$03
L_CF74:
    LDA $0F,X
    STA $0B,X
    DEX 
    BPL L_CF74
    DEC $25
    BNE L_CF3F
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
    BCC L_CF9E
    EOR #$FF
L_CF9E:
    RTS 
    JSR $0EE7
    JSR $827E
    JSR L_9092
    LDY #$00
    LDA ($02),Y
    AND $0A
    BEQ L_CFB2
    LDA #$FF
L_CFB2:
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
    BCC L_D03B
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
L_CFE9:
    JSR $90E6
    BCC L_D02F
    JSR L_903C
    BCC L_D02F
    LDA $0D
    PHA 
    LDA $11
    PHA 
L_CFF9:
    JSR L_903C
    BCC L_D003
    JSR $8FD0
L_D001:
    BCC L_CFF9
L_D003:
    PLA 
L_D004:
    STA $1D
    PLA 
    STA $1C
    LDA $49
    EOR #$01
    STA $49
    JSR $90E6
L_D012:
    JSR L_903C
L_D015:
    BCC L_D01C
L_D017:
    JSR $8FD0
    BCC L_D012
L_D01C:
    LDA $49
    EOR #$01
L_D020:
    STA $49
    JSR $90E6
    LDA $3F
L_D027:
    AND #$07
L_D029:
    BEQ L_CFE9
    LDX $04
    TXS 
    RTS 
L_D02F:
    PLA 
    STA $0C
    PLA 
    STA $0B
    PLA 
    STA $1D
    PLA 
    STA $1C
L_D03B:
    RTS 
    LDA $1C
    STA $0D
    LDA $1D
    STA $11
    JSR L_9092
L_D047:
    JSR $9089
    BNE L_D07F
L_D04C:
    JSR $9137
    BCC L_D059
    JSR $9089
    BEQ L_D04C
    JSR $914C
L_D059:
    LDA $0D
    TAX 
L_D05C:
    JSR $9089
    BNE L_D074
    LDA ($02),Y
    EOR $24
    ORA $0A
    EOR $24
    STA ($02),Y
    JSR $914C
    LDA $0D
    CMP #$B8
    BCC L_D05C
L_D074:
    JSR $9137
    LDA $0D
    STA $11
    STX $0D
    SEC 
    RTS 
L_D07F:
    JSR $914C
    LDA $11
    CMP $0D
    BCS L_D047
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
    BEQ L_D0B9
    LDA #$18
L_D0B9:
    ADC $0B
    AND #$F8
    ADC $1E
    ADC $02
    STA $02
    LDA $0C
    !byte $65
    !byte $03
    !byte $85
    !byte $03
    !byte $A5
    !byte $0B
    !byte $29
    !byte $07
    !byte $A8
    !byte $B9
    !byte $D4
    !byte $90
    !byte $85
    !byte $0A
    !byte $60
    !byte $80
    !byte $40
    !byte $20
    !byte $10
    !byte $08
    !byte $04
    !byte $02
    ORA ($14,X)
    !byte $14
    ORA $12
    AND $1902
    !byte $14
    ORA $60
    LDA $49
    LSR 
    BCC L_D10C
    LDA $0B
    ORA $0C
    BEQ L_D12F
    LDA $0B
    BNE L_D0F7
    DEC $0C
L_D0F7:
    DEC $0B
    ASL $0A
    BCC L_D10A
    ROL $0A
    LDA $02
    SEC 
    SBC #$08
    STA $02
    BCS L_D10A
    DEC $03
L_D10A:
    SEC 
    RTS 
L_D10C:
    LDA $0C
    BEQ L_D116
    LDA $0B
    CMP #$3F
    BEQ L_D12F
L_D116:
    INC $0B
    BNE L_D11C
    INC $0C
L_D11C:
    LSR $0A
    BCC L_D12D
    ROR $0A
    LDA $02
    CLC 
    ADC #$08
    STA $02
    BCC L_D12D
    INC $03
L_D12D:
    SEC 
    RTS 
L_D12F:
    CLC 
    RTS 
    LDA $49
    AND #$02
    BEQ L_D14C
    LDA $0D
    BEQ L_D12F
    DEC $0D
    AND #$07
    BEQ L_D145
    DEC $02
    SEC 
    RTS 
L_D145:
    LDA #$FE
    PHA 
    LDA #$C7
    BNE L_D163
L_D14C:
    LDA $0D
    CMP #$C7
    BEQ L_D12F
    INC $0D
    LDA $0D
    AND #$07
    BEQ L_D15E
    INC $02
    SEC 
    RTS 
L_D15E:
    LDA #$01
    PHA 
    LDA #$39
L_D163:
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
    BCS L_D17B
    EOR #$FF
    ADC #$01
    CLC 
L_D17B:
    STA $06
    ROL $49
    LDA $0B
    SEC 
    SBC $0F
    STA $04
    LDA $0C
    SBC $10
    BCS L_D198
    LDA $0F
    SEC 
    SBC $0B
    STA $04
    LDA $10
    SBC $0C
    CLC 
L_D198:
    STA $05
    ROL $49
    RTS 
    JSR $B285
    BIT $4A
    BMI L_D1DD
    LDA $29
    EOR #$04
    PHA 
    AND #$04
    BEQ L_D1B6
    JSR $0EE7
    PLA 
    STA $29
    JMP L_8AE2
L_D1B6:
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
    JSR L_92A9
    LDA #$A0
    STA $4A
    JSR L_94D6
    JMP $0F03
L_D1DD:
    LDA #$00
    BEQ L_D1F3
    LDA $4A
    BPL L_D1F8
    AND #$EF
    EOR #$20
    BMI L_D1F3
    LDA $4A
    BPL L_D1F8
    AND #$DF
    EOR #$10
L_D1F3:
    STA $4A
    JSR L_94D6
L_D1F8:
    RTS 
    LDA $4A
    AND #$10
    BNE L_D23A
L_D1FF:
    LDY $49
    LDX L_9232,Y
    LDA $9236,X
    CMP $4C,X
    BEQ L_D22F
    TYA 
    LSR 
    TXA 
    AND #$01
    TAX 
    BCC L_D219
    DEC $4C,X
    DEC $4E,X
    BCS L_D21D
L_D219:
    INC $4C,X
    INC $4E,X
L_D21D:
    JSR $944E
    JSR $0F03
    LDA $3F
    AND #$05
    BNE L_D1FF
    LDA $CB
    CMP #$40
    BNE L_D1FF
L_D22F:
    JMP $B285
    !byte $02
    BRK 
    !byte $03
    ORA ($00,X)
    BRK 
    ASL $27,X
L_D23A:
    JSR $9380
    JSR $0F03
    LDA $3F
    AND #$05
    BNE L_D23A
    LDA $CB
    CMP #$40
    BNE L_D23A
    JMP $B285
    JSR $9282
    LDX #$00
    LDY #$01
L_D256:
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
    BPL L_D256
    JMP $8DDD
    LDX #$02
L_D284:
    LDA $0B,X
    CMP $0F,X
    LDA $0C,X
    SBC $10,X
    BCC L_D2A2
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
L_D2A2:
    ROR $4B
    DEX 
    DEX 
    BPL L_D284
    RTS 
    PHA 
    EOR #$60
    STA $1F
    JSR $827E
    LDA $4C
    BIT $4B
    BVS L_D2B9
    LDA $4E
L_D2B9:
    STA $22
    LDA $4D
    BIT $4B
    BMI L_D2C3
    LDA $4F
L_D2C3:
    STA $23
    LDX #$22
    LDY #$03
    JSR L_8318
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
    JSR L_8318
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
L_D2FB:
    LDX $51
L_D2FD:
    LDY #$07
L_D2FF:
    STY $1C
    LDA $1F
    BEQ L_D318
    LDA ($02),Y
    BIT $4B
    BMI L_D30E
    JSR $9371
L_D30E:
    BIT $4B
    BVS L_D318
    PHA 
    TYA 
    EOR #$07
    TAY 
    PLA 
L_D318:
    STA ($04),Y
    LDY $1C
    DEY 
    BPL L_D2FF
    LDA $02
    CLC 
    ADC #$08
    STA $02
    BCC L_D32A
    INC $03
L_D32A:
    LDA #$08
    LDY #$00
    BIT $4B
    BMI L_D336
    LDA #$F8
    LDY #$FF
L_D336:
    CLC 
    ADC $04
    STA $04
    TYA 
    ADC $05
    STA $05
    DEX 
    BPL L_D2FD
    LDX #$06
    JSR $8331
    LDA $06
    STA $02
    LDA $07
    STA $03
    LDA #$40
    LDY #$01
    BIT $4B
    BVS L_D35C
    LDA #$C0
    LDY #$FE
L_D35C:
    CLC 
    ADC $08
    STA $08
    STA $04
    TYA 
    ADC $09
    STA $09
    STA $05
    DEC $22
    BPL L_D2FB
    JMP $827E
    STA $1D
    STY $1C
    LDY #$08
L_D377:
    ROL $1D
    ROR 
    DEY 
    BNE L_D377
    LDY $1C
    RTS 
    LDX #$07
L_D382:
    LDA L_9446,X
    STA $02,X
    DEX 
    BPL L_D382
    LDX #$1C
    STX $26
    LDA $49
    CMP #$01
    BNE L_D3C8
    LDY #$40
L_D396:
    TYA 
    AND #$07
    CMP #$07
    BNE L_D3B7
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
    BCS L_D3BB
    LDA ($06),Y
    BCC L_D3BB
L_D3B7:
    INY 
    LDA ($02),Y
    DEY 
L_D3BB:
    STA ($02),Y
    INY 
    BNE L_D396
    INC $03
    INC $07
    DEX 
    BPL L_D396
    RTS 
L_D3C8:
    CMP #$00
    BNE L_D3F7
    LDY #$C0
L_D3CE:
    DEY 
    TYA 
    AND #$07
    BNE L_D3E6
    TYA 
    CLC 
    ADC $08
    LDA #$00
    ADC $09
    CMP #$3F
    LDA #$00
    BCC L_D3EA
    LDA ($08),Y
    BCS L_D3EA
L_D3E6:
    DEY 
    LDA ($04),Y
    INY 
L_D3EA:
    STA ($04),Y
    TYA 
    BNE L_D3CE
    DEC $05
    DEC $09
    DEX 
    BPL L_D3CE
    RTS 
L_D3F7:
    CMP #$03
    BNE L_D421
    LDY #$C0
    LDX #$00
L_D3FF:
    TYA 
    AND #$07
    BNE L_D40F
    DEX 
    BPL L_D40D
    LDA #$00
    STA $1C
    LDX #$27
L_D40D:
    ROL $1C
L_D40F:
    DEY 
    LDA ($04),Y
    ROL 
    STA ($04),Y
    ROL $1C
    TYA 
    BNE L_D3FF
L_D41A:
    DEC $05
    DEC $26
    BPL L_D3FF
    RTS 
L_D421:
    LDY #$40
    LDX #$00
L_D425:
    TYA 
    AND #$07
    BNE L_D435
    DEX 
    BPL L_D433
    LDA #$00
    STA $1C
    LDX #$27
L_D433:
    ROR $1C
L_D435:
    LDA ($02),Y
    ROR 
    STA ($02),Y
    ROR $1C
    INY 
    BNE L_D425
    INC $03
    DEC $26
    BPL L_D425
    RTS 
    CPY #$3E
    BRK 
    !byte $5B
    SBC $C73F,Y
    EOR $49A5,Y
    ASL 
    ADC $49
    ASL 
    TAY 
    LDX #$00
L_D457:
    LDA $94AC,Y
    STA $02,X
    INY 
    INX 
    CPX #$05
    BNE L_D457
    TAX 
    LDA L_94AD,Y
    TAY 
    LDA $49
    LSR 
    BCC L_D47C
L_D46C:
    LDA ($02),Y
    STA ($04),Y
    INY 
    BNE L_D46C
    INC $03
    INC $05
    DEX 
    BPL L_D46C
    BMI L_D493
L_D47C:
    DEY 
    LDA ($02),Y
    STA ($04),Y
    TYA 
    BNE L_D47C
    DEC $03
    DEC $05
    DEX 
    BPL L_D47C
    LDX #$00
    LDY #$3F
    STX $04
    STY $05
L_D493:
    LDY #$07
    LDA $49
    LSR 
    BNE L_D4A4
    TAY 
    STA ($04),Y
    !byte $88
    !byte $D0
    !byte $FB
    !byte $E6
    !byte $05
    !byte $A0
    !byte $3F
L_D4A4:
    !byte $A9
    !byte $00
    !byte $91
    !byte $04
    !byte $88
    !byte $10
    !byte $FB
    !byte $60
    !byte $00
    !byte $5A
    !byte $40
    !byte $5B
    !byte $1B
    !byte $80
    !byte $C0
    !byte $3F
    !byte $80
    ROL $801B,X
    BRK 
    !byte $5B
    PHP 
    !byte $5B
    !byte $1C
    CLV 
    CPY #$3E
    CLV 
    ROL $481C,X
    AND #$03
    STA $35
    BIT $4A
    BPL L_D4CF
    JSR $0F03
L_D4CF:
    JMP L_94D6
    BIT $11
    EOR ($31),Y
    LDA $29
    AND #$9F
    ORA #$20
    STA $29
    BIT $29
    BVS L_D537
    LDX $0E39
    LDY $0E3A
    LDA $29
    AND #$20
    BEQ L_D4F4
    LDX $0E3B
    LDY $0E3C
L_D4F4:
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
    JSR L_89B3
    LDA $29
    AND #$20
    BNE L_D518
    LDX $28
    INX 
    TXA 
    JMP L_9570
L_D518:
    LDA $4A
    AND #$30
    BEQ L_D529
    LDX #$07
    AND #$10
    BEQ L_D525
    INX 
L_D525:
    TXA 
    JSR L_9570
L_D529:
    LDA $35
    CLC 
    ADC #$09
    JMP L_9570
    LDA $29
    ORA #$40
    STA $29
L_D537:
    LDX #$03
L_D539:
    LDA L_956C,X
    STA $02,X
    DEX 
    BPL L_D539
    LDX #$00
    STX $26
    LDY #$00
L_D547:
    LDA #$FF
    BNE L_D54E
L_D54B:
    LDA $0D00,X
L_D54E:
    STA ($02),Y
    LDA $0D00,X
    STA ($04),Y
    INX 
    INY 
    BNE L_D55D
    INC $03
    INC $05
L_D55D:
    TYA 
    AND #$07
    BNE L_D54B
    TXA 
    LDX $26
    STA $26
    CPX #$A0
    BNE L_D547
    RTS 
    CPY #$7C
    BRK 
    ROR $0A0A,X
    ASL 
    ASL 
    TAY 
    LDX #$10
L_D577:
    LDA $7CC0,Y
    EOR #$FF
    STA $7CC0,Y
    LDA $7E00,Y
    EOR #$FF
    STA $7E00,Y
    INY 
    DEX 
    BNE L_D577
    RTS 
    LDA $19
    CMP #$EF
    BCS L_D5BE
    LDX #$04
    LDA $0B
L_D596:
    LSR $0C
    ROR 
    DEX 
    BNE L_D596
    TAX 
    BIT $29
    BVS L_D5B8
    LDA $29
    AND #$20
    BEQ L_D5AC
    TXA 
    CLC 
    ADC #$14
    TAX 
L_D5AC:
    JMP ($0E3F)
    LDA L_95DB,X
    JSR L_8094
    JMP $B285
L_D5B8:
    JSR $10A5
    JMP $B285
L_D5BE:
    LDA $29
    CLC 
    ADC #$20
    AND #$60
    CMP #$60
    BNE L_D5CB
    LDA #$00
L_D5CB:
    STA $1C
    !byte $A5
    !byte $29
    !byte $29
    !byte $9F
    !byte $05
    !byte $1C
    !byte $85
    !byte $29
    !byte $20
    !byte $DE
    !byte $94
    !byte $4C
    !byte $85
    !byte $B2
    !byte $5F
    !byte $64
    !byte $44
    !byte $6C
    !byte $72
    !byte $63
    !byte $70
    !byte $6A
    !byte $6D
    !byte $74
    !byte $67
    !byte $61
    !byte $73
    !byte $65
    !byte $20
    !byte $77
    !byte $B8
    !byte $C3
    !byte $6B
    !byte $6B
    !byte $5F
    !byte $C1
    LSR $A1A3,X
    LDY #$A2
    EOR $6F66
    SEI 
    ADC $2E,X
    ADC #$B5
    LDX $BA,Y
    !byte $B7
    !byte $6B
    !byte $6B
    LDA $28
    CMP #$09
    BCC L_D60D
    CMP #$0D
    BCC L_D612
L_D60D:
    LDA #$0D
    JMP L_80BC
L_D612:
    JSR L_8AE2
    JSR $0EE7
    LDA #$8C
    STA L_D001
    LDA #$14
    STA $D000
    LDA #$01
    STA $D010
    LDA #$01
    STA L_D015
    LDA #$1A
    STA $02
    LDA #$5C
    STA $03
    LDX #$16
    LDY #$0D
    LDA $1704
    JSR L_9961
    JSR $B3CD
    JMP $96AD
    JSR L_8AE2
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
    BCS L_D662
    LDA #$00
L_D662:
    CMP #$D0
    BCC L_D668
    LDA #$D0
L_D668:
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
    STA L_D015
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
L_D69E:
    DEY 
    LDA ($02),Y
    STA ($04),Y
    TYA 
    BNE L_D69E
    DEC $03
    DEC $05
    DEX 
    BNE L_D69E
    JSR L_9863
    JSR $B285
    JSR L_96C9
    JSR $AEEC
    JSR L_8AC1
    LDA $28
    CMP #$0D
    BNE L_D6C8
    JSR L_8C95
    JSR $AFF0
L_D6C8:
    RTS 
    JSR $96D5
    JSR $97DA
    JSR L_993A
    JMP L_96C9
    JSR $0E2D
    BNE L_D6DB
    RTS 
L_D6DB:
    CMP #$20
    BNE L_D6E2
    PLA 
    PLA 
    RTS 
L_D6E2:
    CMP #$6D
    BNE L_D70B
    LDY #$3C
L_D6E8:
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
    BPL L_D6E8
    JMP L_9768
L_D70B:
    CMP #$74
    BNE L_D723
    LDY #$00
    LDX #$3E
L_D713:
    LDA $7F40,Y
    JSR $9371
    STA $0380,X
    INY 
    DEX 
    BPL L_D713
    JMP L_9768
L_D723:
    CMP #$72
    BNE L_D776
    LDA #$02
    STA $27
L_D72B:
    LDY $27
    STY $08
    LDX L_996C,Y
    LDA L_996F,Y
    STA $20
    LDA #$03
    STA $26
L_D73B:
    LDA #$08
    STA $21
L_D73F:
    LDY $20
    TXA 
    PHA 
    LDA #$00
L_D745:
    ROL $7F40,X
    ROR 
    INX 
    INX 
    INX 
    DEY 
    BNE L_D745
    LDY $08
    STA $0380,Y
    INY 
    INY 
    INY 
    STY $08
    PLA 
    TAX 
    DEC $21
    BNE L_D73F
    INX 
    DEC $26
    BNE L_D73B
    DEC $27
    BPL L_D72B
    LDY #$3E
L_D76A:
    LDA $0380,Y
    STA $7F40,Y
    DEY 
    BPL L_D76A
    JMP L_98DB
L_D776:
    CMP #$69
    BNE L_D78A
    LDY #$3E
L_D77C:
    LDA $7F40,Y
    EOR #$FF
    STA $7F40,Y
    DEY 
    BPL L_D77C
    JMP L_98DB
L_D78A:
    CMP #$C1
    BNE L_D794
    JSR $AFD9
    JMP L_98DB
L_D794:
    CMP #$A0
    BNE L_D7AC
    LDA $0D
    CMP #$14
    BCC L_D7A8
    CMP #$16
    BCS L_D7D9
    LDA $3F
    AND #$05
    BNE L_D7D9
L_D7A8:
    INC $0D
    BPL L_D7D0
L_D7AC:
    CMP #$A1
    BNE L_D7B8
    LDA $0D
    BEQ L_D7D9
    DEC $0D
    BPL L_D7D0
L_D7B8:
    CMP #$A2
    BNE L_D7C6
    LDA $0B
    CMP #$17
    BCS L_D7D9
    INC $0B
    BPL L_D7D0
L_D7C6:
    CMP #$A3
    BNE L_D7D9
    LDA $0B
    BEQ L_D7D9
    DEC $0B
L_D7D0:
    LDA $24
    LDY #$29
    STA ($04),Y
    JSR L_991C
L_D7D9:
    RTS 
    LDA $3F
    AND #$05
    BEQ L_D83C
    LDA $0D
    CMP #$15
    BCS L_D843
    LDA $29
    AND #$02
    BNE L_D808
    LDA $033E
    EOR $24
    AND #$0F
    BEQ L_D7F7
    LDA #$01
L_D7F7:
    LDX $028D
    BEQ L_D7FE
    EOR #$01
L_D7FE:
    LSR $29
L_D800:
    ASL $29
    ORA $29
    ORA #$02
    STA $29
L_D808:
    JSR $90C9
    LDA $0B
    LSR 
    LSR 
    LSR 
    LDY #$03
    CLC 
L_D813:
    ADC $0D
    DEY 
    BNE L_D813
    TAY 
    LDA $29
    LSR 
    LDA $0A
    BCS L_D82A
    ORA $7F40,Y
    STA $7F40,Y
    LDX #$01
    BNE L_D834
L_D82A:
    EOR #$FF
    AND $7F40,Y
    STA $7F40,Y
    LDX #$00
L_D834:
    LDA $033E,X
    STA $24
    JMP L_993A
L_D83C:
    LDA $29
    AND #$FD
    STA $29
    RTS 
L_D843:
    LDA $1704
    LDY #$29
    STA ($04),Y
    JSR $B285
    LDA $0B
    LSR 
    TAX 
    LDA $9857,X
    JMP L_96D8
    BRK 
    BRK 
    BRK 
    JSR $746D
    !byte $72
    ADC #$C1
    BRK 
    BRK 
    BRK 
    LDA $1704
    JSR L_9961
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
L_D89D:
    LDA #$18
    STA $26
    LDA #$81
    LDY #$01
L_D8A5:
    LDX #$06
L_D8A7:
    STA ($02),Y
    INY 
    DEX 
    BNE L_D8A7
    INY 
    INY 
    DEC $26
    BNE L_D8A5
    LDX #$02
    JSR $8331
    DEC $27
    BNE L_D89D
    LDY #$5F
L_D8BE:
    LDA L_B947,Y
    STA $7BB8,Y
    LDA $B9A7,Y
    STA $7CF8,Y
    DEY 
    BPL L_D8BE
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
L_D8E7:
    LDY #$02
L_D8E9:
    LDX $26
    LDA $7F40,X
    STA $0380,Y
    DEC $26
    DEY 
    BPL L_D8E9
    LDY #$17
L_D8F8:
    LSR $0380
    ROR $0381
    ROR $0382
    LDA #$00
    ROL 
    TAX 
    LDA $033E,X
    STA ($02),Y
    DEY 
    BPL L_D8F8
    SEC 
    LDA $02
    SBC #$28
    STA $02
    BCS L_D918
    DEC $03
L_D918:
    LDA $26
    BPL L_D8E7
    LDA $0B
    STA $0E
    LDX #$0D
    LDY #$03
    JSR L_8318
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
    !byte $60
    !byte $27
    !byte $0F
    !byte $00
    !byte $08
    !byte $08
    !byte $05
    !byte $A2
    !byte $FE
    !byte $9A
    !byte $20
    !byte $F8
    !byte $9F
    !byte $20
    !byte $C0
    !byte $99
    !byte $20
    !byte $93
    !byte $87
    !byte $20
    !byte $2B
    !byte $9A
    !byte $4C
    !byte $78
    !byte $99
    !byte $62
    !byte $B5
    !byte $65
    !byte $73
    !byte $74
    !byte $C3
    !byte $B9
    !byte $5F
    !byte $31
    !byte $32
    !byte $33
    !byte $C1
    !byte $76
    !byte $66
    !byte $B7
    !byte $61
    !byte $A8
    !byte $AA
    !byte $30
    !byte $B8
    !byte $E3
    !byte $99
    !byte $6D
    !byte $9B
    !byte $E3
    !byte $99
    !byte $1F
    !byte $9C
    !byte $6F
    !byte $9C
    !byte $B3
    !byte $0D
    !byte $AD
    !byte $0D
    !byte $85
    !byte $9E
    !byte $99
    !byte $9E
    STA $999E,Y
    !byte $9E
    EOR $9A9D,X
    LDY #$A6
    LDY #$C2
    LDY #$BE
    TXS 
    ORA ($84),Y
    !byte $1A
    STY $A0
    TXA 
    !byte $2B
    BPL $D9E1
    CPX $FF
    BEQ L_D9D7
    PHA 
    JSR $B27A
    ASL $0340
    PLA 
    LDX #$13
L_D9CF:
    CMP L_9984,X
    BEQ L_D9D8
    DEX 
    BPL L_D9CF
L_D9D7:
    RTS 
L_D9D8:
    TXA 
    ASL 
    TAY 
    LDA L_9999,Y
    PHA 
    LDA $9998,Y
    PHA 
    RTS 
    LDA #$04
    BIT $29
    BNE L_D9F0
    LDA $37
    CMP #$04
    BNE L_D9F7
L_D9F0:
    TXA 
    PHA 
    JSR $9DA4
    PLA 
    TAX 
L_D9F7:
    LDA $38
    AND #$BF
L_D9FB:
    STA $38
    LDA $29
    AND #$FB
    STA $29
    STX $37
    LDA $9A21,X
    LDY L_9A26,X
    STA $48
    BIT $29
    BPL L_DA15
    LDA #$03
    LDY #$02
L_DA15:
    STY L_D015
    JSR $AF3F
    JSR $87C5
    JMP $9F5A
    ORA ($04,X)
    ORA ($01,X)
    ORA ($02,X)
    ASL $02
    !byte $02
    !byte $02
    LDA $3F
    AND #$07
L_DA2F:
    BEQ L_DA53
    PHA 
    JSR $87C5
    JSR $B27A
    JSR $B285
    PLA 
    BIT $29
    BPL L_DA43
    JMP $9FA2
L_DA43:
    AND #$02
    BNE L_DA54
    LDA $37
    ASL 
    TAX 
    LDA $9A5D,X
    PHA 
    LDA L_9A5C,X
    PHA 
L_DA53:
    RTS 
L_DA54:
    LDX #$02
    JSR L_99E4
    JMP L_9BEB
    ADC $9A
    BCS L_D9FB
    NOP 
    !byte $9B
    !byte $3C
    !byte $9C
    CPY $9C
    LDA $29
    EOR #$04
    STA $29
    AND #$04
    BEQ L_DA79
    JSR $9F0D
    JSR $9E74
    JMP L_8AE2
L_DA79:
    JSR $9282
    INC $0F
    INC $11
    LDA $0F
    SEC 
    SBC $0B
    CMP #$05
    BCC L_DAB4
    LDY $52
    LDX #$02
    BIT $38
    BVS L_DAA4
    LDA $1700
    TAY 
    CLC 
    ADC #$05
    BCS L_DAB7
    STA $1700
    LDA #$00
    STA $1800,Y
    LDX #$00
L_DAA4:
    STX $37
    LDX #$00
L_DAA8:
    LDA $0B,X
    STA $1801,Y
    INY 
    INX 
    INX 
    CPX #$08
    BCC L_DAA8
L_DAB4:
    JMP $A073
L_DAB7:
    LDA #$05
    JSR $B22A
    JMP $9DA4
    BIT $38
    BVC L_DAE7
    JSR $9E74
    LDY $52
    LDA $1800,Y
    BPL L_DAE8
    CLC 
    ADC #$20
    AND #$60
    CMP #$20
    BNE L_DAD8
    LDA #$40
L_DAD8:
    STA $1C
    LDA $1800,Y
    AND #$9F
    ORA $1C
    STA $1800,Y
    JSR $9F5A
L_DAE7:
    RTS 
L_DAE8:
    LDA $52
    TAX 
    CLC 
    ADC #$05
    TAY 
    LDA $1800,X
    AND #$1F
    BEQ L_DB12
    LDA $1800,Y
    CMP #$A0
    BCC L_DB12
    CLC 
    ADC #$04
    STA $1800,Y
    AND #$1C
    BNE L_DB23
    DEC $1800,X
    LDA #$01
    JSR $9E59
    JMP $9B2C
L_DB12:
    LDA #$01
    JSR $9E38
    BCS L_DB27
    LDX $52
    LDA #$E0
    STA $1805,X
    INC $1800,X
L_DB23:
    JSR $9B2C
    RTS 
L_DB27:
    LDA #$05
    JMP $B22A
    LDY $52
    LDA $1800,Y
    BMI L_DB49
    LDX #$80
    AND #$1F
    BEQ L_DB45
    LDA $1805,Y
    CMP #$A0
    BCC L_DB45
    ASL 
    ASL 
    AND #$70
    TAX 
L_DB45:
    LDY #$00
    BEQ L_DB57
L_DB49:
    LDY #$10
    LDX #$A0
    ASL 
    ASL 
    BMI L_DB57
    LDX #$90
    BCS L_DB57
    LDX #$B0
L_DB57:
    LDA #$10
    STA $26
L_DB5B:
    LDA L_BC87,X
    STA $6FD0,Y
    LDA L_BD47,X
    STA $7110,Y
    INY 
    INX 
    DEC $26
    BNE L_DB5B
    RTS 
    LDA #$80
    JSR L_8467
    BCS L_DBAB
    LDY $1700
    TYA 
    CLC 
    ADC #$05
    BCS L_DBA6
    TAX 
    ADC $B7
    BCS L_DBA6
    STY $52
    LDA $B7
    ORA #$C0
    STA $1800,Y
    LDY #$00
L_DB8E:
    LDA ($BB),Y
    STA $1800,X
    INY 
    INX 
    CPY $B7
    BCC L_DB8E
    JSR L_9BDD
    JSR $B222
    LDA #$01
    STA $37
    JMP $A084
L_DBA6:
    LDA #$05
    JSR $B22A
L_DBAB:
    JSR L_8658
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
    BVS L_DBDA
    JSR $9E26
    STY $1700
L_DBDA:
    JMP $A073
    LDY $52
    JSR $B1B9
    LDA $B7
    LDX $BB
    LDY $BC
    JMP $B231
    LDA $1700
    BEQ L_DC1F
    JSR $9DEB
    JSR $9DD4
    LDA $38
    ORA #$40
    STA $38
    LDY $52
    LDX #$00
L_DC00:
    LDA $1800,Y
L_DC03:
    BPL L_DC1C
L_DC05:
    LDA $1803,Y
    SEC 
    SBC $1801,Y
    STA $40
    LDA $1804,Y
    SEC 
    SBC $1802,Y
    STA $41
    JSR L_9BDD
    LDX #$01
L_DC1C:
    JSR $9A03
L_DC1F:
    RTS 
    LDA $1700
    BEQ L_DC38
    LDY #$00
L_DC27:
    LDA $1800,Y
    BMI L_DC33
    STY $52
    JSR $9DD4
    LDY $52
L_DC33:
    JSR $9E26
    BCC L_DC27
L_DC38:
    LDX #$03
    JMP L_99E4
    LDA $1700
    BEQ L_DC6F
    JSR $9DEB
    LDY $52
    JSR $9DD4
    JSR $9E74
    LDX #$00
    LDY $52
L_DC51:
    LDA $1800,Y
    STA $0200,X
    INY 
    INX 
    CPX #$15
    BCC L_DC51
    JSR $9D85
    LDX #$00
L_DC62:
    LDA $0200,X
    STA $1800,Y
    INX 
    INY 
    CPY $1700
    BNE L_DC62
L_DC6F:
    RTS 
    BIT $38
    BVC L_DC83
    LDY $52
    LDA $1800,Y
    BMI L_DC83
    JSR $9C84
    LDX #$04
    JSR $9A03
L_DC83:
    RTS 
    JSR $9F08
    LDY $52
    JSR $9DBB
    LDY $52
    JSR $9E26
    DEY 
L_DC92:
    TYA 
    SEC 
    SBC #$04
    CMP $52
    BEQ L_DCC4
    LDA $1800,Y
    CMP #$A0
    BCS L_DCC4
    LDX $52
    ADC $1801,X
    CMP #$A0
    BCS L_DCC1
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
L_DCC1:
    DEY 
    BNE L_DC92
L_DCC4:
    RTS 
    JSR $9E74
    LDY $52
    LDA $0B
    SEC 
    SBC $1801,Y
    BCC L_DD2D
    STA $0F
    JSR $9E26
    DEY 
L_DCD8:
    TYA 
    SEC 
    SBC #$04
    CMP $52
    BEQ L_DCF0
    LDA $1800,Y
    CMP #$A0
    BCS L_DCF0
    CMP $0F
    BEQ L_DD20
    BCC L_DCF0
    DEY 
    BNE L_DCD8
L_DCF0:
    LDX $52
    LDA $0B
    CMP $1803,X
    BCS L_DD2D
    LDA $1800,X
    AND #$1F
    CMP #$0F
L_DD00:
    BCS L_DD1B
L_DD02:
    INY 
L_DD03:
    TYA 
    PHA 
    LDA #$01
    JSR $9E38
    PLA 
    TAY 
    BCS L_DD1B
    LDA $0F
    STA $1800,Y
    LDX $52
    INC $1800,X
    JMP $9C84
L_DD1B:
    LDA #$05
    JMP $B22A
L_DD20:
    LDA #$01
    JSR $9E59
    LDX $52
    DEC $1800,X
    JSR $9C84
L_DD2D:
    RTS 
    LDY $52
    LDA $1800,Y
    AND #$1F
    BEQ L_DD5D
    TAX 
    TYA 
    CLC 
    ADC #$05
    TAY 
    LDA $1800,Y
    CMP #$A0
    BCC L_DD46
    INY 
    DEX 
L_DD46:
    TXA 
    BEQ L_DD5D
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
L_DD5D:
    RTS 
    ASL $0340
    BCC L_DD66
    JMP $0FF4
L_DD66:
    JSR $9E74
    LDY #$00
    BIT $38
    BVC L_DD7F
    LDA $37
    CMP #$04
    BNE L_DD78
    JMP $9D2E
L_DD78:
    JSR $9D85
    LDA #$02
    STA $37
L_DD7F:
    STY $1700
    JMP $A073
    LDY $52
    JSR $9E26
    TYA 
    SEC 
    SBC $52
    STA $1C
    LDX $52
L_DD92:
    LDA $1800,Y
    STA $1800,X
    INX 
    INY 
    BNE L_DD92
    LDA $1700
    SEC 
    SBC $1C
    TAY 
    RTS 
    JSR $9F08
    LDA $1700
    BEQ L_DDBA
    LDY #$00
L_DDAE:
    TYA 
    PHA 
    JSR $9DBB
    PLA 
    TAY 
    JSR $9E26
    BCC L_DDAE
L_DDBA:
    RTS 
    LDX #$00
L_DDBD:
    LDA $1801,Y
    STA $0B,X
    INY 
    INX 
    LDA #$00
    STA $0B,X
    INX 
    CPX #$08
    BCC L_DDBD
    DEC $0F
    DEC $11
    JMP $8DDD
    LDA #$04
    STA $25
L_DDD8:
    LDA $29
    EOR #$01
    STA $29
    LDY $52
    JSR $9DBB
    JSR $9F0D
    DEC $25
    BNE L_DDD8
    RTS 
    LDA #$FF
    STA $24
    LDY #$00
    STY $52
L_DDF3:
    INY 
    INY 
    LDX #$02
    LDA #$00
    STA $1C
L_DDFB:
    LDA $1800,Y
    CLC 
    ADC $1802,Y
    ROR 
    SEC 
    SBC $0B,X
    BCS L_DE0C
    EOR #$FF
    ADC #$01
L_DE0C:
    CLC 
    ADC $1C
    STA $1C
    DEY 
    DEX 
    DEX 
    BPL L_DDFB
    BCS L_DE20
    CMP $24
    BCS L_DE20
    STA $24
    STY $52
L_DE20:
    JSR $9E26
    BCC L_DDF3
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
    BCS L_DE58
    STA $1700
    STY $1C
    LDY #$FF
    TYA 
    SEC 
    SBC $26
    TAX 
L_DE4C:
    LDA $1800,X
    STA $1800,Y
    DEY 
    DEX 
    CPX $1C
    BCS L_DE4C
L_DE58:
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
L_DE69:
    LDA $1800,X
    STA $1800,Y
    INY 
    INX 
    BNE L_DE69
    RTS 
    LDY #$00
L_DE76:
    LDA $1800,Y
    STA $5B00,Y
    INY 
    BNE L_DE76
    LDA $1700
    STA $0341
    RTS 
    LDY #$00
L_DE88:
    LDA $5B00,Y
    STA $1800,Y
    INY 
    BNE L_DE88
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
L_DEA8:
    LDA $9EBD,Y
    STA $1800,X
    BEQ L_DEB4
    INY 
    INX 
    BPL L_DEA8
L_DEB4:
    STX $1700
    JMP $A073
    BRK 
    ASL $11
    RTI 
    !byte $0A
    !byte $06
    STX $C3,Y
    !byte $00
    !byte $40
    !byte $09
    !byte $06
    !byte $4E
    !byte $C3
    !byte $40
    !byte $52
    !byte $06
    !byte $97
    !byte $C3
    BRK 
    RTI 
    PHP 
    ASL $36
    !byte $C3
    RTI 
    AND $6706,Y
    !byte $C3
    RTI 
    ROR 
    ASL $98
    !byte $C3
    BRK 
    LDA $29
    AND #$76
    STA $29
    LDA $38
    AND #$EF
    STA $38
    LDX #$07
L_DEEC:
    LDA $9F00,X
    STA $0B,X
    DEX 
    BPL L_DEEC
    JSR $8D70
    LDA #$B8
    STA $0B
    STA $0F
    JMP $8D70
    !byte $17
    BRK 
    !byte $C7
    BRK 
    !byte $17
    BRK 
    BRK 
    BRK 
    LDA #$00
    TAX 
    BEQ L_DF15
    LDA #$80
    BNE L_DF13
    LDA #$00
L_DF13:
    LDX #$FF
L_DF15:
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
L_DF2D:
    LDY #$A0
    BIT $1F
    BMI L_DF3E
L_DF33:
    LDA ($04),Y
    AND $24
    STA ($02),Y
    DEY 
    BNE L_DF33
    BEQ L_DF45
L_DF3E:
    LDA ($02),Y
    STA ($04),Y
    DEY 
    BNE L_DF3E
L_DF45:
    LDX #$02
    JSR $8331
    LDA $04
    CLC 
    ADC #$A0
    STA $04
    BCC L_DF55
    INC $05
L_DF55:
    DEC $26
    BNE L_DF2D
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
    BVC L_DF85
    LDA #$02
    JSR $9F86
    JSR $9B2C
L_DF85:
    RTS 
    ASL 
    ASL 
    ASL 
    ASL 
    TAY 
    LDX #$10
L_DF8D:
    LDA $6D50,Y
    EOR #$FF
    STA $6D50,Y
    LDA $6E90,Y
    EOR #$FF
    STA $6E90,Y
    INY 
    DEX 
    BNE L_DF8D
    RTS 
    LDA $0B
    SEC 
    SBC #$18
    BCC L_DFE3
    CMP #$50
    BCS L_DFD4
    LSR 
    LSR 
    LSR 
    LSR 
    STA $1C
    LDA $0D
    SEC 
    SBC #$40
    BCC L_DFE3
    CMP #$40
    BCS L_DFD4
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
    !byte $4C
    !byte $C3
    !byte $99
L_DFD4:
    !byte $A5
    !byte $0D
    !byte $C9
    !byte $B8
    !byte $90
    !byte $09
    !byte $A5
    !byte $0B
    !byte $C9
    !byte $68
    !byte $90
    !byte $03
    !byte $20
    !byte $B8
    !byte $8A
L_DFE3:
    !byte $60
    !byte $C3
    !byte $B9
    !byte $76
    !byte $66
    !byte $B7
    !byte $62
    LDA $65,X
    !byte $73
    !byte $74
    ADC ($61,X)
    ADC ($00,X)
    CMP ($5F,X)
    AND ($32),Y
    !byte $33
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
L_E01B:
    PHA 
    TAY 
    LDA $A08F,Y
    JSR $0DE9
    STA $34
    TAY 
L_E026:
    LDA $0428,Y
    STA $02C0,Y
    DEY 
    BPL L_E026
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
    BCS L_E04F
    JSR L_818F
L_E04F:
    PLA 
    CLC 
    ADC #$04
    CMP #$0C
    BCC L_E01B
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
    BEQ L_E080
    CMP #$04
    BNE L_E084
L_E080:
    LDA #$02
    STA $37
L_E084:
    JSR $AF0D
    LDX $37
    JSR L_99E4
    JMP $B285
	+InsertMainScreenTextPos	; Position of texts $11, $12 a $13
    LDA #$01
    STA $72
    LDA #$00
    JSR $A107
    JMP $A076
    ASL $0340
    BCS L_E0B2
    LDA #$40
    STA $0340
    RTS 
L_E0B2:
    LDA #$01
    STA $72
    LDA #$40
    JSR $A107
    BNE L_E0C0
    JSR L_837B
L_E0C0:
    JMP $A076
    JSR $0E1B
    BCS L_E0FE
    LDX #$05
L_E0CA:
    LDA $A101,X
    STA $4C,X
    DEX 
    BPL L_E0CA
    LDA #$01
    STA $72
    LDA #$70
    JSR $A107
    BNE L_E0FE
    JSR $0E24
    BCS L_E0FE
    LDA $70
    AND #$F7
    CMP $70
    BEQ L_E0FE
    PHA 
    JSR $A738
    INC $72
    !byte $68
    !byte $A6
    !byte $71
    !byte $F0
    !byte $E3
    !byte $8A
    !byte $20
    !byte $2A
    !byte $B2
    !byte $A9
    !byte $00
    !byte $20
    !byte $10
    !byte $0E
L_E0FE:
    !byte $4C
    !byte $76
    !byte $A0
    !byte $00
    !byte $00
    !byte $63
    !byte $4F
    !byte $64
    BVC $E174
    !byte $43
    ASL $7085
    LDA #$00
    STA $71
    STA L_D015
    LDA #$18
    LDY $1700
    BEQ L_E18B
    LDX #$01
    LDY #$19
    STX $58
    STY $59
    BIT $70
    BVC L_E129
    JSR $0FF4
L_E129:
    JSR $9F08
    JSR $A19B
    JSR $A1D8
    JSR $A71B
    LDA $71
    BNE L_E18B
    LDA $1901
    BEQ L_E195
    LDY #$00
    JSR $A201
    LDA #$18
    BCS L_E18B
L_E147:
    LDY #$00
    LDA ($58),Y
    CMP #$01
    BEQ L_E16D
    BCC L_E195
    CMP #$02
    BNE L_E166
    LDA $70
    ORA #$80
    STA $70
    JSR $A753
    BCS L_E195
    LDA #$00
    STA $83
    BCC L_E17E
L_E166:
    JSR $A250
    BCC L_E17E
    BCS L_E177
L_E16D:
    LDA #$00
    STA $83
    INC $58
    BNE L_E177
    INC $59
L_E177:
    JSR $A1FA
    LDA #$19
    BCS L_E18B
L_E17E:
    LDA $71
    BNE L_E18B
    JSR CBM_GETIN
    CMP #$B3
    BNE L_E147
    LDA #$1B
L_E18B:
    STA $71
    JSR $B22A
    LDA #$00
    JSR $0E10
L_E195:
    JSR $9E74
    LDA $71
    RTS 
    LDX #$0B
L_E19D:
    LDA $A1CC,X
    STA $79,X
    DEX 
    BPL L_E19D
    LDA #$00
    STA $3C00
    JSR $AEAA
    LDA #$00
    LDX #$0F
L_E1B1:
    STA $0345,X
    DEX 
    BPL L_E1B1
    LDA #$FF
    LDX #$07
L_E1BB:
    STA $023E,X
    DEX 
    BPL L_E1BB
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
L_E1DA:
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
    BCC L_E1DA
    RTS 
    LDY $52
L_E1FC:
    JSR $9E26
    BCS L_E24F
    LDA $1800,Y
    BMI L_E1FC
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
    BEQ L_E24E
    LDA $1805,Y
    CMP #$A0
    BCC L_E237
    AND #$1C
    STA $1C
    LDA $7C
    AND #$E3
    ORA $1C
    STA $7C
    DEX 
    INY 
L_E237:
    TXA 
    BEQ L_E24E
    STA $26
    LDX #$01
L_E23E:
    LDA $1805,Y
    STA $0345,X
    INY 
    INX 
    CPX #$10
    BCS L_E24E
    DEC $26
    BNE L_E23E
L_E24E:
    CLC 
L_E24F:
    RTS 
    LDA $70
    AND #$7F
    STA $70
    JSR $A29F
    BCS L_E29E
    JSR $A674
    LDY #$00
    LDA ($58),Y
    CMP #$0D
    BEQ L_E277
    LDA $0D
    STA $11
    LDA #$00
    LDX #$07
L_E26E:
    STA $0B,X
    DEX 
    DEX 
    BPL L_E26E
    JSR $8D70
L_E277:
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
    BCC L_E296
    INC $65
L_E296:
    JSR $A9EE
    STA $58
    STY $59
    CLC 
L_E29E:
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
L_E2B1:
    LDA $0D
    LDY $52
    CMP $1804,Y
    BCS L_E313
    LDA $1801,Y
    STA $0B
    LDA $1803,Y
    STA $0F
    JSR $A314
    BCS L_E2F4
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
    BCS L_E313
    LDA $67
    PHA 
    LDA $66
    PHA 
    JSR $A314
    PLA 
    TAX 
    PLA 
    BCC L_E307
L_E2F4:
    LDA #$00
    STA $65
    LDA $1804,Y
    STA $0D
    ASL 
    ROL $65
    ASL 
    ROL $65
    STA $64
    BCC L_E2B1
L_E307:
    CPX $66
    BNE L_E30F
    CMP $67
    BEQ L_E312
L_E30F:
    JSR $A44C
L_E312:
    CLC 
L_E313:
    RTS 
    LDY #$00
    CPY $52
    BEQ L_E38F
    LDA $1800,Y
    AND #$40
    BEQ L_E38F
    LDA $0D
    CMP $1802,Y
    BCC L_E38F
    CMP $1804,Y
    BCS L_E38F
    JSR $A3B5
    BCS L_E38F
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
    BEQ L_E38F
    CMP #$0F
    BEQ L_E38F
    CMP #$06
    BEQ L_E3B4
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
    BNE L_E369
    LDA $1C
    CMP $1D
    BCS L_E36D
    BCC L_E37F
L_E369:
    CPX #$02
    BNE L_E37B
L_E36D:
    LDA #$19
    CMP $1C
    BCS L_E3B4
    LDA $1A
    STA $0F
    LDA #$01
    BCC L_E38B
L_E37B:
    CPX #$07
    BNE L_E38F
L_E37F:
    LDA #$19
    CMP $1D
    BCS L_E3B4
    LDA $1B
    STA $0B
    LDA #$02
L_E38B:
    ORA $7C
    STA $7C
L_E38F:
    JSR $9E26
    BCS L_E397
    JMP $A316
L_E397:
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
L_E3B4:
    RTS 
    LDA $1800,Y
    AND #$A0
    CMP #$A0
    BNE L_E3C9
    LDX #$07
    TYA 
L_E3C1:
    CMP $023E,X
    BEQ L_E3DD
    DEX 
    BPL L_E3C1
L_E3C9:
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
L_E3DD:
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
    BEQ L_E428
    CLC 
    ADC $1801,Y
    SEC 
    SBC $1D
    BCS L_E411
    LDA #$00
L_E411:
    STA $1C
    STA $1A
    INC $02
    LDA ($02,X)
    CLC 
    ADC $1801,Y
    ADC $1D
    BCC L_E423
    LDA #$A0
L_E423:
    STA $1D
    STA $1B
    CLC 
L_E428:
    RTS 
    LDX #$00
    STX $1E
    LDY #$10
L_E42F:
    ASL $1C
    ROL $1D
    ROL $1E
    TXA 
    ROL 
    TAX 
    LDA $1E
    SEC 
    SBC $26
    BCS L_E444
    CPX #$01
    BCC L_E448
    DEX 
L_E444:
    STA $1E
    INC $1C
L_E448:
    DEY 
    BNE L_E42F
    RTS 
    LDA #$00
    LDX #$08
L_E450:
    STA $85,X
    DEX 
    BPL L_E450
    JSR $AA2C
    JSR $AA53
    LDA $7D
    AND #$9F
    STA $7D
    LDA $7C
    AND #$DF
    STA $7C
    LDX #$00
L_E469:
    LDA $7F,X
    PHA 
    INX 
    CPX #$06
    BCC L_E469
L_E471:
    JSR $A9CD
    JSR $A9F9
    BCS L_E487
    LDA #$2D
    JSR $AAA7
    BCS L_E4E5
    LDA #$40
    JSR $AA19
    DEC $86
L_E487:
    JSR $A512
    BCS L_E4E5
    LDA $61
    JSR $A8B8
    BCC L_E471
    CMP #$0D
    BEQ L_E501
    CMP #$03
    BCC L_E4FF
    CMP #$09
    BNE L_E4AE
    LDA #$2D
    JSR $AAA7
    BCS L_E4E5
    LDA #$40
    JSR $AA19
    JMP $A471
L_E4AE:
    CMP #$2D
    BNE L_E4BF
    JSR $AA9B
    BCS L_E4E5
    LDA #$00
    JSR $AA19
    JMP $A471
L_E4BF:
    CMP #$20
    BNE L_E4D6
    INC $89
    LDX $68
    LDY $69
    LDA #$00
    JSR $AA19
    JSR $AA9B
    BCS L_E4E5
    JMP $A471
L_E4D6:
    BCC L_E4E2
    CMP $3C03
    BCS L_E4E2
    JSR $AA9B
    BCS L_E4E5
L_E4E2:
    JMP $A471
L_E4E5:
    LDA $86
    BEQ L_E4FF
    STA $85
    LDX $6A
    LDY $6B
    STX $68
    STY $69
    TAY 
    DEY 
    LDA ($58),Y
    CMP #$20
    BNE L_E507
    DEC $89
    BCS L_E507
L_E4FF:
    DEC $85
L_E501:
    LDA $7D
    AND #$9F
    STA $7D
L_E507:
    LDX #$05
L_E509:
    PLA 
    STA $7F,X
    DEX 
    BPL L_E509
    JMP $AEAA
    BIT $7D
    BPL L_E568
    LDA $83
    CMP #$E8
    BNE L_E522
    LDX #$00
    STX $8B
    STX $8A
L_E522:
    AND #$0F
    CMP #$08
    BEQ L_E52C
    CMP #$0E
    BNE L_E562
L_E52C:
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
    BCC L_E568
    AND #$03
    CMP #$01
    BNE L_E568
    LDX #$03
    BIT $7D
    BVS L_E55C
    INX 
L_E55C:
    CPX $8A
    BCS L_E568
    BCC L_E56A
L_E562:
    LDA #$00
    STA $8A
    STA $8B
L_E568:
    CLC 
    RTS 
L_E56A:
    LDY $85
    DEY 
    DEY 
    STY $1E
    LDX #$03
L_E572:
    LDA ($58),Y
    JSR $B296
    STA $0200,X
    DEY 
    DEX 
    BPL L_E572
    LDY #$63
L_E580:
    LDX #$03
L_E582:
    LDA $A610,Y
    BEQ L_E5A0
    CMP $0200,X
    BNE L_E592
    DEX 
    DEY 
    BPL L_E582
    BMI L_E5AF
L_E592:
    DEY 
    DEY 
    BMI L_E5AF
L_E596:
    LDA $A611,Y
    BEQ L_E580
    DEY 
    BPL L_E596
    BMI L_E5AF
L_E5A0:
    LDA #$60
    CPY #$00
    BEQ L_E5B1
    TXA 
    CLC 
    ADC $1E
    SEC 
    SBC #$02
    STA $1E
L_E5AF:
    LDA #$40
L_E5B1:
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
    BCS L_E5EA
    STX $6A
    STY $6B
    LDY $1E
    STY $86
    LDA $7D
    AND #$9F
    ORA $1D
    STA $7D
    CLC 
L_E5EA:
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
    !byte $00
    !byte $00
    !byte $01
    !byte $00
    !byte $00
    !byte $00
    !byte $01
    !byte $00
    !byte $01
    !byte $01
    !byte $01
    !byte $00
    !byte $00
    !byte $43
    !byte $4B
    !byte $00
    !byte $42
    !byte $4C
    !byte $00
    !byte $42
    !byte $52
    !byte $00
    !byte $43
    !byte $48
    !byte $00
    !byte $44
    !byte $52
    !byte $00
    !byte $46
    !byte $4C
    !byte $00
    !byte $46
    !byte $52
    !byte $00
    !byte $47
    JMP $4700
    !byte $52
    BRK 
    !byte $4B
    JMP $4B00
    !byte $4E
    !byte $00
    !byte $4B
    !byte $52
    !byte $00
    !byte $50
    !byte $48
    !byte $00
    !byte $50
    !byte $46
    !byte $00
    !byte $50
    !byte $4C
    !byte $00
    !byte $50
    !byte $52
    !byte $00
    !byte $53
    !byte $50
    !byte $00
    !byte $53
    !byte $54
    !byte $00
    !byte $54
    !byte $48
    !byte $00
    !byte $54
    !byte $52
    !byte $00
    !byte $5A
    !byte $57
    !byte $00
    !byte $53
    !byte $43
    !byte $48
    !byte $00
    !byte $53
    !byte $50
    !byte $52
    !byte $00
    !byte $53
    !byte $54
    !byte $52
    !byte $00
    !byte $53
    !byte $43
    !byte $48
    !byte $4C
    !byte $00
    !byte $53
    !byte $43
    !byte $48
    !byte $4E
    !byte $00
    !byte $53
    !byte $43
    !byte $48
    !byte $57
    !byte $00
    !byte $53
    !byte $43
    PHA 
    EOR $5300
    !byte $43
    PHA 
    !byte $52
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
    BEQ L_E6A0
    AND #$0F
    TAY 
    LDA $7C
    AND #$20
    ORA $A70B,Y
L_E6A0:
    AND #$2C
    BEQ L_E6E8
    CMP #$0C
    BEQ L_E6B3
    AND #$28
    BEQ L_E6C6
    LSR $6D
    ROR $6C
    LSR $1E
    CLC 
L_E6B3:
    PHP 
    LDA $68
    CLC 
    ADC $6C
    STA $68
    LDA $69
    ADC $6D
    STA $69
    PLP 
    BCC L_E6E8
    BCS L_E6EF
L_E6C6:
    LDY $85
    DEY 
    LDA ($58),Y
    CMP #$0D
    BEQ L_E6E8
    LDY #$00
    LDX $89
    BEQ L_E6F3
    LDX $6C
L_E6D7:
    CPX $89
    LDA $6D
    SBC #$00
    BCC L_E6F3
    STA $6D
    TXA 
    SBC $89
    TAX 
    INY 
    BNE L_E6D7
L_E6E8:
    LDA $0F
    SEC 
    SBC $1E
    STA $0F
L_E6EF:
    LDX #$00
    LDY #$00
L_E6F3:
    STX $6F
    STY $6E
    LDA $69
    STA $1C
    LDA $68
    LSR $1C
    !byte $6A
    !byte $46
    !byte $1C
    !byte $6A
    !byte $18
    !byte $65
    !byte $0B
    !byte $85
    !byte $0B
    !byte $C6
    !byte $0F
    !byte $60
    !byte $00
    !byte $04
    !byte $00
    !byte $04
    !byte $04
    !byte $00
    !byte $0C
    !byte $08
    !byte $08
    !byte $0C
    !byte $00
    !byte $04
    !byte $0C
    !byte $0C
    !byte $04
    !byte $04
    LDA $1700
    BEQ L_E737
    LDY #$00
    STY $35
L_E724:
    STY $52
    LDA $1800,Y
    BPL L_E730
    JSR $B10F
    BCS L_E737
L_E730:
    LDY $52
    JSR $9E26
    BCC L_E724
L_E737:
    RTS 
    LDY #$01
L_E73A:
    LDA ($58),Y
    CMP #$22
    BEQ L_E747
    INY 
    CPY #$11
    BCC L_E73A
    BCS L_E752
L_E747:
    TYA 
    LDX $58
    LDY $59
    JSR CBM_SETNAM
    JSR $B0A8
L_E752:
    RTS 
    LDA #$00
    STA $85
L_E757:
    JSR $A9CD
    CMP #$02
    BCC L_E78C
    CMP #$0D
    BEQ L_E78F
    CMP #$22
    BEQ L_E798
    JSR $B296
    LDX #$08
L_E76B:
    DEX 
    BMI L_E757
    CMP $A7A7,X
    BNE L_E76B
    TXA 
    PHA 
    JSR $B2F3
    TAX 
    PLA 
    CPX #$00
    BEQ L_E757
    TAY 
    ASL 
    TAX 
    LDA $A7AE,X
    PHA 
    LDA $A7AD,X
    PHA 
    LDA $1A
    RTS 
L_E78C:
    JSR $A9E5
L_E78F:
    JSR $A9EE
    STA $58
    STY $59
    CLC 
    RTS 
L_E798:
    LDA $70
    ORA #$08
    !byte $85
    !byte $70
    !byte $20
    !byte $EE
    !byte $A9
    !byte $85
    !byte $58
    !byte $84
    !byte $59
    !byte $38
    !byte $60
    !byte $48
    !byte $56
    !byte $4B
    !byte $5A
    !byte $2D
    !byte $4E
    !byte $B8
    !byte $A7
    !byte $B8
    !byte $A7
    !byte $B8
    !byte $A7
    LDX $C6A7,Y
    !byte $A7
    CPY L_99A7
    ADC $4C00,Y
    !byte $57
    !byte $A7
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
L_E7E0:
    JSR $A9CD
    JSR $A9F9
    CMP #$0D
    BNE L_E7EF
    LDA #$00
    STA $84
    RTS 
L_E7EF:
    JSR $A8B8
    BCC L_E839
    BIT $70
    BVC L_E839
    CMP #$20
    BNE L_E81A
    LDY $85
    CPY $86
    BCS L_E805
    JSR $ABB7
L_E805:
    JSR $AA9B
    INC $89
    LDA $6F
    CMP $89
    LDA $68
    ADC $6E
    STA $68
    BCC L_E839
    INC $69
    BCS L_E839
L_E81A:
    BCC L_E839
    CMP $3C03
    BCS L_E839
    LDA $7D
    ASL 
    ASL 
    ASL 
    LDA $61
    BCC L_E833
    LDY $85
    CPY $86
    BCC L_E833
    CLC 
    ADC #$08
L_E833:
    JSR $AACF
    JSR $AA9B
L_E839:
    LDY $85
    CPY $86
    BCC L_E7E0
    BIT $70
    BVC L_E84C
    BIT $7D
    BVC L_E84C
    LDA #$2D
    JSR $AACF
L_E84C:
    RTS 
    LDA #$00
    STA $8C
    STA $8D
    JSR $AEE2
    BCS L_E8A4
    LDA #$58
    STA $62
    LDA #$30
    SEC 
    SBC $78
    SBC $8C
    BCS L_E867
    LDA #$00
L_E867:
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
    BCS L_E8A4
    INC $85
    LDA $A8A5,Y
    STA $61
    JSR $AAA7
    !byte $B0
    !byte $0A
    !byte $A5
    !byte $61
    !byte $20
    !byte $CF
    !byte $AA
    !byte $20
    !byte $9B
    !byte $AA
    !byte $90
    !byte $E4
L_E8A4:
    !byte $60
    !byte $54
    !byte $68
    !byte $65
    !byte $20
    !byte $51
    !byte $75
    !byte $69
    !byte $63
    !byte $6B
    JSR $7242
    !byte $6F
    !byte $77
    ROR $4620
    !byte $6F
    SEI 
    CMP #$20
    BCS L_E8C7
    LDX #$10
L_E8BE:
    CMP $A8D4,X
    BEQ L_E8C8
    DEX 
    BPL L_E8BE
    SEC 
L_E8C7:
    RTS 
L_E8C8:
    !byte $8A
    !byte $0A
    !byte $A8
    !byte $B9
    !byte $E6
    !byte $A8
    !byte $48
    !byte $B9
    !byte $E5
    !byte $A8
    !byte $48
    !byte $60
    !byte $03
    !byte $04
    !byte $05
    !byte $0B
    !byte $0C
    !byte $18
    !byte $19
    ASL $0706
    PHP 
    ASL 
    !byte $0F
    !byte $1A
    BPL $E8F5
    !byte $12
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
    BEQ L_E930
    LDA #$02
    STA $72,X
    LDY $85
    LDA ($58),Y
    CMP #$30
    BCC L_E92B
    CMP #$39
    BCS L_E92B
    JSR $A9CD
    AND #$0F
    STA $72,X
    LDA $90D4,X
    ORA $81
    BNE L_E930
L_E92B:
    LDA $90D4,X
    EOR $81
L_E930:
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
    BNE L_E951
    INC $84
    LDA $84
L_E951:
    JSR $AA74
    CLC 
    RTS 
    JSR $A947
    LDY $85
L_E95B:
    STY $26
    LDA ($58),Y
    CMP #$21
    BCC L_E985
    CMP #$2E
    BEQ L_E985
    CMP #$2C
    BEQ L_E985
    JSR $AAA7
    STA $1C
    LDA $68
    SEC 
    SBC $1C
    TAX 
    LDA $69
    SBC #$00
    BCC L_E985
    STX $68
    STA $69
    LDY $26
    INY 
    BNE L_E95B
L_E985:
    CLC 
    RTS 
    JSR $B2F3
    LDY $69
    LDA $68
    SEC 
    SBC $1A
    BCS L_E99B
    DEY 
    CPY #$FF
    BNE L_E99B
    LDA #$00
    TAY 
L_E99B:
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
L_E9C1:
    LDA $0201,Y
    STA $02C1,X
    INY 
    DEX 
    BPL L_E9C1
    CLC 
    RTS 
    LDY $87
    BEQ L_E9D8
    DEC $87
    LDA $02C0,Y
    BNE L_E9E2
L_E9D8:
    LDY $85
    LDA ($58),Y
    INC $85
    BNE L_E9E2
    INC $59
L_E9E2:
    STA $61
    RTS 
    LDA $85
    BNE L_E9EB
    DEC $59
L_E9EB:
    DEC $85
    RTS 
    LDA $85
    CLC 
    ADC $58
    LDY $59
    BCC L_E9F8
    INY 
L_E9F8:
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
    BNE L_EA17
    CLC 
    ADC #$20
    STA $61
    RTS 
L_EA17:
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
    BCC L_EA3D
    TXA 
    ASL 
    TAX 
    TYA 
    ASL 
    TAY 
L_EA3D:
    LDA #$04
    BIT $81
    BEQ L_EA46
    INX 
    INX 
    INY 
L_EA46:
    CPX $8C
    BCC L_EA4C
    STX $8C
L_EA4C:
    CPY $8D
    BCC L_EA52
    STY $8D
L_EA52:
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
    BCC L_EA6F
    LDX #$00
    LDY #$00
L_EA6F:
    STX $68
    STY $69
    RTS 
    CMP #$10
    BCS L_EA9A
    TAY 
    LDA $0345,Y
    STA $1C
    ASL $1C
    LDA #$00
    ROL 
    ASL $1C
    ROL 
    TAY 
L_EA87:
    LDX $1C
    CPX $68
    SBC $69
    BCC L_EA9A
    TYA 
    CPX $66
    SBC $67
    BCS L_EA9A
    STX $68
    STY $69
L_EA9A:
    RTS 
    LDA $61
    JSR $AAA7
    BCS L_EAA6
    STX $68
    STY $69
L_EAA6:
    RTS 
    TAX 
    LDA $3BE4,X
    CLC 
    ADC $79
    CLC 
    BPL L_EAB3
    LDA #$00
L_EAB3:
    BIT $81
    BPL L_EAB8
    ASL 
L_EAB8:
    BIT $81
    BVC L_EABE
    ADC #$01
L_EABE:
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
    BEQ L_EAFC
    LDA $64
    SEC 
    SBC $76
    TAX 
    LDA $65
    SBC #$00
    TAY 
    BCS L_EB12
L_EAFC:
    LDA $3C76
    BCC L_EB02
    ASL 
L_EB02:
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
L_EB12:
    LDA $81
    AND #$08
    BEQ L_EB20
    CLC 
    TXA 
    ADC $76
    TAX 
    BCC L_EB20
    INY 
L_EB20:
    LDA $81
    AND #$04
    BEQ L_EB30
    DEX 
    BNE L_EB30
    DEY 
    BPL L_EB30
    LDX #$00
    LDY #$00
L_EB30:
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
    BPL L_EB59
    LDA $3C02
    LSR 
    LSR $81
    BCS L_EB4F
    LSR 
    CLC 
L_EB4F:
    ROL $81
    ADC $0F
    STA $0F
    BCC L_EB59
    INC $10
L_EB59:
    LDA #$02
    BIT $81
    BEQ L_EB73
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
L_EB73:
    LDA #$04
    BIT $81
    BEQ L_EBAD
    LDY #$00
    LDX #$00
    BIT $82
    BPL L_EB82
    INX 
L_EB82:
    LDA $77
    CLC 
    JSR $AC02
    LDY #$01
    LDX #$00
    BIT $82
    BPL L_EB91
    INX 
L_EB91:
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
    BPL L_EBB2
    INX 
    BCS L_EBB2
L_EBAD:
    LDX #$00
    LDY #$00
    CLC 
L_EBB2:
    LDA #$00
    JMP $AC02
    LDA $81
    AND #$20
    BEQ L_EC01
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
    BNE L_EBE9
    ADC $6E
L_EBE9:
    PHA 
    LDX #$00
    LDY #$00
    JSR $AC85
    LDA #$02
    BIT $81
    BEQ L_EC00
    LDX $78
    LDY $78
    PLA 
    PHA 
    JSR $AC85
L_EC00:
    PLA 
L_EC01:
    RTS 
    STA $25
    TYA 
    AND #$01
    ROL 
    STA $1F
    JSR $AD1F
    LDY #$00
L_EC0F:
    JSR $1373
    BIT $26
    BMI L_EC1D
    TYA 
    PHA 
    JSR $ACB2
    PLA 
    TAY 
L_EC1D:
    BIT $82
    BPL L_EC2E
    LDA $1F
    EOR #$02
    STA $1F
    AND #$02
    BNE L_EC2E
    JSR $90EB
L_EC2E:
    LDA $81
    LSR 
    BCC L_EC41
    LDA $1F
    EOR #$80
    STA $1F
    BPL L_EC41
    TYA 
    SEC 
    SBC $3C01
    TAY 
L_EC41:
    CPY $75
    BEQ L_EC80
    INC $02
    BNE L_EC4B
    INC $03
L_EC4B:
    INC $0D
    LDA $0D
    AND #$07
    BNE L_EC0F
    LDA $0D
    CMP #$C8
    BCS L_EC70
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
    BCC L_EC0F
L_EC70:
    LDA #$00
    STA $0D
    INC $46
    TYA 
    PHA 
    JSR $AD60
    PLA 
    TAY 
    JMP $AC0F
L_EC80:
    RTS 
    SEI 
    !byte $02
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
L_EC98:
    ASL 
    INX 
    BNE L_EC98
L_EC9C:
    STA $0200,Y
    LDA #$FF
    DEY 
    BPL L_EC9C
    INC $26
    LDY $26
    LDA #$00
    STA $0200,Y
    STA $1F
    JMP $AD0A
    INC $26
    BIT $81
    BPL L_ECD8
    ASL $26
    LDY $26
    DEY 
    STY $1C
L_ECBF:
    LDY #$04
    LDA $1C
    LSR 
    TAX 
L_ECC5:
    LSR $0200,X
    PHP 
    ROR 
    PLP 
    ROR 
    DEY 
    BNE L_ECC5
    LDY $1C
    STA $0200,Y
    DEC $1C
    BPL L_ECBF
L_ECD8:
    LDY $26
    LDA #$00
    STA $0200,Y
    LDX $25
    BEQ L_ECE9
    INC $26
    INY 
    STA $0200,Y
L_ECE9:
    BIT $81
    BVC L_ECEE
    INX 
L_ECEE:
    TXA 
    BEQ L_ED0A
    STA $1C
L_ECF3:
    LDX #$00
    LDY $26
    CLC 
L_ECF8:
    LDA $0200,X
    ROR 
    ORA $0200,X
    STA $0200,X
    INX 
    DEY 
    BPL L_ECF8
    DEC $1C
    BNE L_ECF3
L_ED0A:
    LDA $0A
L_ED0C:
    ASL 
    BCS L_ED1C
    LDX #$00
    LDY $26
L_ED13:
    ROR $0200,X
    INX 
    DEY 
    BPL L_ED13
    BMI L_ED0C
L_ED1C:
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
    BEQ L_ED49
    JSR L_9092
    LDA #$37
    STA $45
    LDA #$02
    STA $43
    RTS 
L_ED49:
    LDX #$00
L_ED4B:
    LDA $0D
    SEC 
    SBC #$C8
    TAY 
    LDA $0E
    SBC #$00
    BCC L_ED5E
    STY $0D
    STA $0E
    INX 
    BCS L_ED4B
L_ED5E:
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
    LDA L_830C,X
    STA $45
    LDA L_8310,X
    STA $43
    LDA $0B
    AND #$07
    TAY 
    LDA $90D4,Y
    STA $0A
L_EDA3:
    RTS 
    ORA #$06
    ORA $20
    JSR $2D2D
    AND $602D
    LDA $61
    CMP $61A5
    CMP $3C03
    BCS L_EDA3
    SEC 
    SBC #$20
    BCC L_EDA3
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
L_EDD0:
    LDA $0F,X
    STA $0B,X
    DEX 
    BPL L_EDD0
    JSR L_9092
    LDY #$00
    STY $1F
L_EDDE:
    JSR $1373
    TYA 
    PHA 
    LDX $26
    BMI L_EE30
    INX 
    TXA 
    ASL 
    ASL 
    ASL 
    STA $20
    LDX #$00
L_EDF0:
    LDA $02,X
    PHA 
    INX 
    CPX #$0D
    BCC L_EDF0
L_EDF8:
    LDX $26
L_EDFA:
    ROL $0200,X
    DEX 
    BPL L_EDFA
    ROR 
    PHA 
    JSR $AE86
    LDA $49
    JSR $AE94
    PLA 
    BCC L_EE28
    BIT $81
    BPL L_EE1D
    PHA 
    JSR $AE86
    LDA $49
    JSR $AE94
    PLA 
    BCC L_EE28
L_EE1D:
    BIT $81
    BVC L_EE24
    JSR $AE86
L_EE24:
    DEC $20
    BNE L_EDF8
L_EE28:
    LDX #$0C
L_EE2A:
    PLA 
    STA $02,X
    DEX 
    BPL L_EE2A
L_EE30:
    JSR $AE8F
    PLA 
    BCC L_EE4B
    TAY 
    LDA $81
    AND #$01
    EOR $1F
    STA $1F
    LSR 
    BCC L_EE47
    TYA 
    SBC $3C01
    TAY 
L_EE47:
    CPY $75
    BCC L_EDDE
L_EE4B:
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
    BCS L_EE77
    ADC $1C
    BCC L_EE67
    INY 
L_EE67:
    CMP L_8C52,X
    BCC L_EE7F
    PHA 
    TYA 
    CMP L_8C53,X
    TAY 
    PLA 
    BCC L_EE7F
    BCS L_EE85
L_EE77:
    SBC $1C
    BCS L_EE7F
    SEC 
    DEY 
    BMI L_EE85
L_EE7F:
    STA $0F,X
    TYA 
    STA $10,X
    CLC 
L_EE85:
    RTS 
    ASL 
    BCC L_EE8E
    LDY #$00
    JSR L_8C3D
L_EE8E:
    RTS 
    LDX $49
    LDA $AEA6,X
    CMP #$02
    BCS L_EEA3
    ASL 
    JSR L_9133
    BCC L_EEA2
    LDA #$B7
    CMP $0D
L_EEA2:
    RTS 
L_EEA3:
    JMP $90E8
    !byte $03
    !byte $02
    BRK 
    ORA ($A5,X)
    !byte $7F
    BNE L_EEB2
    LDA $80
    STA $7F
L_EEB2:
    CMP $3C00
    BEQ L_EEE1
    LDA $3C00
    STA $80
    JSR $12F2
    BCC L_EEC9
    JSR $B03C
    LDA $7F
    STA $3C00
L_EEC9:
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
L_EEE1:
    RTS 
    JSR $12F2
    BCS L_EEEB
    JSR $AEC9
    CLC 
L_EEEB:
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
    JSR L_80DE
    JMP $B285
    LDA #$BB
    STA $D011
    LDA #$78
    STA $D018
    LDA L_DD00
    AND #$FC
    ORA #$02
    STA L_DD00
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
    BNE L_EF4B
    LDX #$40
; --------------------
; RLE?
L_EF4B:
    LDA $AF78,Y
    STA $02
    BEQ L_EF71
L_EF52:
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
    BNE L_EF52
    INY 
    INY 
    INY 
    INY 
    BNE L_EF4B
L_EF71:
    RTS 
L_EF72:
; --------------------
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
L_EFD9:
	LDA #$00
    LDY #$3F
L_EFDD:
    STA $7F40,Y
    DEY 
    BPL L_EFDD
    RTS 
    LDX #$3F
L_EFE6:
    LDA $7F40,X
    STA $03C0,X
    DEX 
    BPL L_EFE6
    RTS 
    LDX #$3F
L_EFF2:
    LDA $03C0,X
    STA $7F40,X
    DEX 
    BPL L_EFF2
    RTS 
    LDA #$12
    STA $D018
    LDA #$9B
    STA $D011
    LDA L_DD00
    ORA #$03
    STA L_DD00
    LDA #$00
    LDX #$3E
L_F012:
    STA $03C0,X
    DEX 
    BPL L_F012
    LDA #$FF
    STA $03EB
    STA $03EE
    LDA #$0F
    STA $07F9
    LDA #$02
    STA L_D015
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
    BCS L_F0A7
    LDY #$00
L_F060:
    JSR CBM_CHRIN
    STA $3C00,Y
    INY 
    CPY #$78
    BCC L_F060
    LDX #$78
    LDY #$3C
    STX $73
    STY $74
    STX $02
    STY $03
    BIT $70
    BPL L_F0A4
    BVC L_F0A4
    LDA $7F
    CMP $7E
    BEQ L_F0A4
    STA $7E
    LDA #$00
    STA $26
    STA $27
    STA $1F
L_F08D:
    JSR $119A
    LDY #$00
    STA ($02),Y
    INC $02
    BNE L_F09A
    INC $03
L_F09A:
    LDA $90
    BEQ L_F08D
    LDA $26
    ORA $27
    BNE L_F08D
L_F0A4:
    JSR $B222
L_F0A7:
    RTS 
    LDA #$54
    JSR $B1C8
    BCS L_F10E
    LDX #$01
    LDY #$19
    STX $5A
    STY $5B
    STX $58
    STY $59
L_F0BB:
    JSR CBM_CHRIN
    LDY #$00
    STA ($5A),Y
    TAX 
    BEQ L_F0DE
    INC $5A
    BNE L_F0BB
    INC $5B
    LDA $5B
    CMP #$3C
    BCC L_F0BB
    DEC $5B
    DEC $5A
    LDA #$00
    TAY 
    STA ($5A),Y
    LDA #$05
    BCS L_F103
L_F0DE:
    STA $1700
L_F0E1:
    JSR CBM_CHRIN
    TAX 
    BEQ L_F0E1
    LDA #$18
    CPX #$4C
    SEC 
    BNE L_F103
    JSR CBM_CHRIN
    STA $1700
    LDY #$00
L_F0F6:
    JSR CBM_CHRIN
    STA $1800,Y
    INY 
    CPY $1700
    BCC L_F0F6
    CLC 
L_F103:
    PHA 
    PHP 
    JSR $B222
    PLP 
    PLA 
    BCC L_F10E
    STA $71
L_F10E:
    RTS 
    LDX #$20
    LDY $52
    LDA $1800,Y
    AND #$60
    CMP #$60
    BEQ L_F123
    CLC 
    BIT $70
    BVC L_F155
    LDX #$00
L_F123:
    STX $1F
    JSR $B1B9
    LDA #$00
    JSR $B1C8
    BCS L_F155
    BIT $70
    BVC L_F151
    LDY $52
    LDA $1801,Y
    LSR 
    STA $2B
    CLC 
    ADC $23
    CMP #$51
    BCS L_F151
    LDA $1802,Y
    LSR 
    STA $2A
    ADC $22
    CMP #$65
    BCS L_F151
    JSR $1134
L_F151:
    JSR $B222
    CLC 
L_F155:
    RTS 
    LDA $1F
    AND #$20
    BEQ L_F1B8
    JSR CBM_CHRIN
    CMP #$4B
    BNE L_F1B8
    LDX #$07
L_F165:
    LDY $023D,X
    INY 
    BNE L_F16E
    DEX 
    BNE L_F165
L_F16E:
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
    BCS L_F1B8
    STA $05
    STA $0249,Y
    LDA $52
    STA $023E,X
    LDY $02
    LDA #$00
    STA $02
L_F1A4:
    JSR CBM_CHRIN
    EOR #$FF
    STA ($02),Y
    INY 
    BNE L_F1B0
    INC $03
L_F1B0:
    CPY $04
    LDA $03
    SBC $05
    BCC L_F1A4
L_F1B8:
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
L_F1D5:
    PHA 
    LDA $24
    BNE L_F1E1
    JSR L_8471
    BCS L_F1F2
    PLA 
    RTS 
L_F1E1:
    LDY #$00
    JSR $B209
    BCS L_F1F2
    JSR CBM_CHRIN
    CMP $24
    BNE L_F1F2
    PLA 
    CLC 
    RTS 
L_F1F2:
    JSR $B222
    PLA 
    BNE L_F203
L_F1F8:
    JSR $0E2D
    CMP #$AD
    BEQ L_F1D5
    CMP #$B3
    BNE L_F1F8
L_F203:
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
    BCS L_F221
    BNE L_F21E
    JMP CBM_CHKIN
L_F21E:
    JSR CBM_CHKOUT
L_F221:
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
L_F246:
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
    BNE L_F262
    DEY 
L_F260:
    LDA ($08),Y
L_F262:
    STA ($06),Y
    DEY 
    BPL L_F260
    LDA $06
    CLC 
    ADC #$08
    STA $06
    BCC L_F272
    INC $07
L_F272:
    PLA 
    TAY 
    INY 
    CPY $1C
    BCC L_F246
    RTS 
    LDY #$7F
    LDA #$00
L_F27E:
    STA $79C0,Y
    DEY 
    BPL L_F27E
    RTS 
L_F285:
    LDA $CB
    CMP #$40
    BNE L_F285
    LDA $3F
    AND #$07
    BNE L_F285
    LDA #$00
    STA $C6
    RTS 
    CMP #$7E
    BCS L_F2A0
    CMP #$61
    BCC L_F2A0
    SBC #$20
L_F2A0:
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
L_F2B4:
    LDA $0201,X
    STA ($02),Y
    INY 
    INX 
    CPX #$03
    BCC L_F2B4
    RTS 
    LDX #$02
L_F2C2:
    LDA #$00
    LDY #$10
L_F2C6:
    ROL $1A
    ROL $1B
    ROL 
    CMP #$0A
    BCC L_F2D1
    SBC #$0A
L_F2D1:
    DEY 
    BNE L_F2C6
    ROL $1A
    ROL $1B
    ORA #$30
    STA $0201,X
    DEX 
    BPL L_F2C2
    INX 
L_F2E1:
    LDA $0201,X
    CMP #$30
    BNE L_F2F2
    LDA #$1F
    STA $0201,X
    INX 
    CPX #$02
    BCC L_F2E1
L_F2F2:
    RTS 
    LDX #$00
    STX $1F
    STX $1A
L_F2F9:
    JSR $A9CD
    CPX #$00
    BNE L_F30C
    CMP #$3D
    BEQ L_F2F9
    CMP #$2D
    BNE L_F30C
    ROR $1F
    BMI L_F2F9
L_F30C:
    SEC 
    SBC #$30
    BCC L_F327
    CMP #$0A
    BCS L_F327
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
    BNE L_F2F9
L_F327:
    ASL $1F
    BCC L_F331
    LDA #$00
    SBC $1A
    STA $1A
L_F331:
    JSR $A9E5
    TXA 
    RTS 
    STX $1C
    STY $1D
    LDA #$00
    LDY #$08
L_F33E:
    ASL 
    ROL $1D
    BCC L_F34A
    CLC 
    ADC $1C
    BCC L_F34A
    INC $1D
L_F34A:
    DEY 
    BNE L_F33E
    TAX 
    LDY $1D
    RTS 
    ASL $10A0,X
L_F354:
    ASL $1C
    ROL $1D
    ROL $1E
    SEC 
    LDA $1E
    SBC $26
    BCC L_F365
    STA $1E
    INC $1C
L_F365:
    DEY 
    BNE L_F354
    RTS 
    STX $27
    STY $86
    !byte $27
    STY $26
    STA $1C
    ROR $1D
L_F374:
    LDA $09
    PHA 
    LDA $08
    PHA 
    LDX $26
L_F37C:
    LDY #$07
    LDA $1C
L_F380:
    BIT $1D
    BMI L_F386
    LDA ($02),Y
L_F386:
    STA ($08),Y
    DEY 
    BPL L_F380
    LDA $02
    CLC 
    ADC #$08
    STA $02
    BCC L_F396
    INC $03
L_F396:
    LDA $08
    CLC 
    ADC #$08
    STA $08
    BCC L_F3A1
    INC $09
L_F3A1:
    DEX 
    BNE L_F37C
    PLA 
    CLC 
    ADC #$40
    STA $08
    PLA 
    ADC #$01
    STA $09
    DEC $27
    BNE L_F374
    RTS 
    LDA $1704
    LSR 
    LSR 
    LSR 
    LSR 
    STA L_D027
    LDA #$00
    STA $02
    LDA #$5C
    STA $03
    LDX #$18
    LDY #$27
    LDA $1704
    STY $1C
    LDY $1C
L_F3D1:
    STA ($02),Y
    DEY 
    BPL L_F3D1
    PHA 
    LDA $02
    CLC 
    ADC #$28
    STA $02
    BCC L_F3E2
    INC $03
L_F3E2:
    !byte $68
    !byte $CA
    !byte $10
    !byte $E9
    !byte $60
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

!if language = cs {
!bin "zs-cs.bin"
}

!if language = de {
!bin "zs-de.bin"
}

!if language = en {
!bin "zs-de.bin"
}