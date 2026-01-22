!initmem $ff
!source "c64symb.asm"
!to "79cs25.bin", plain

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
    JMP $915D
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
    JSR L_8F6A
    JMP $0DA8
L_8042:
    JMP (L_A000)
    LDX #$FE
    TXS 
    JSR L_90B0
L_804B:
    JSR L_8054
    JSR L_8BA1
    JMP L_804B
L_8054:
    JSR L_949D
L_8057:
    BEQ L_8077
    STA $61
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
L_806B:
    SBC #$A0
    ASL
    TAX
    LDA $8079,X
    PHA
    LDA $8078,X
    PHA
L_8077:
    RTS
    RTS
    !word $1082
    !word $5282
    !word $FA82
    !word $7E81
    !word $AF82
    !word $DD82
    !word $0282
    !word $B783
    !word $D282
    !word $1282
    !word $1D83
    !word $2B83
    !word $EF83
    !byte $80
L_8094:
    !byte $EF
    !byte $80
    !byte $03
    !byte $81
    !byte $FE
    !byte $80
    !byte $1C
    !byte $81
    !byte $18
    !byte $85
    !byte $76
    !byte $80
    !byte $2F
    !byte $85
    !byte $DE
    !byte $87
    !byte $48
    !byte $87
    !byte $A7
    !byte $0D
    !byte $A7
    !byte $0D
    !byte $AD
    !byte $0D
    !byte $89
    !byte $89
    !byte $40
    !byte $85
    !byte $28
    !byte $85
    !byte $32
    !byte $94
    !byte $96
    !byte $89
    !byte $BD
    !byte $89
    !byte $45
    !byte $8B
    !byte $82
    !byte $8B
L_80BC:
    !byte $9B
    !byte $8B
    ROR $80,X
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
    JSR L_9716
    JMP L_8253
L_80E6:
    CMP #$03
    BCC L_80F2
L_80EA:
    JSR L_8132
    JMP L_8253
    LDA #$0D
L_80F2:
    JSR L_8130
    BCS L_80FE
    LDA $23
    STA $66
    JSR L_8253
L_80FE:
    RTS 
    LDA #$20
    JMP L_8130
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
    JSR L_9716
    CLC 
    RTS 
L_8184:
    JSR L_83A5
    CLC 
    RTS 
L_8189:
    LDA #$05
    JSR L_9747
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
    JSR L_9716
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
L_8253:
    INC $23
    LDA $23
    CMP $66
    BCC L_825E
    JMP L_83A5
L_825E:
    JMP L_9660
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
L_82B0:
    JSR L_833C
    LDA #$12
    JMP L_8354
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
L_82D3:
    LDX $58
    LDY $59
    STX $0342
    STY $0343
    RTS 
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
L_8313:
    JSR L_8382
    LDY $66
L_8318:
    DEY 
    STY $23
    JMP L_9660
    LDA $23
    BEQ L_8313
L_8322:
    JSR L_8382
    LDA #$00
    STA $23
    JMP L_9660
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
    JSR L_9716
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
    JSR L_9716
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
L_8519:
    JSR L_8643
    BCS L_8528
    JSR L_8578
    JSR L_85B1
    JSR L_83A5
    CLC 
L_8528:
    RTS 
    JSR L_8519
    BCS L_8528
    BCC L_8549
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
    LDA #$05
    JMP L_9747
L_8578:
    LDX $5D
    LDY $5E
    STX $02
    STY $03
    LDX #$00
    LDY #$3F
    STX $08
    STY $09
    LDX $6D
    INX 
    JMP L_81EA
L_858E:
    LDY #$00
    STY $02
    LDA #$3F
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
    LDA #$07
    JSR L_9747
L_8613:
    JSR $9474
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
    LDA #$06
    JSR L_9747
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
    JSR $9474
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
    JSR L_96FB
    STX $1C
    PLA 
    CLC 
    ADC $1C
    TAX 
    TYA 
    ADC #$D8
    TAY 
    RTS 
    LDX #$01
    LDY #$19
    STX $5D
    STY $5E
    LDX $5A
    LDY $5B
    STX $5F
    STY $60
    LDX #$D9
    LDY #$87
    STX $04
    STY $05
    JSR L_9598
    BCS L_87D6
    BEQ L_8770
    JSR L_9660
    JSR L_8643
    BCS L_87D6
L_8770:
    LDA #$03
    JSR L_957C
    BCS L_87D6
    LDY #$01
    JSR L_9297
    BCS L_87CE
    LDA #$54
    JSR $FFD2
    LDY $5D
    LDA #$00
    STA $5D
L_8789:
    LDA ($5D),Y
    JSR $FFD2
L_878E:
    LDA $90
    BNE L_87CE
    CPY $5F
    BNE L_879C
    LDA $5E
    CMP $60
    BEQ L_87A3
L_879C:
    INY 
    BNE L_8789
    INC $5E
    BNE L_8789
L_87A3:
    LDA #$00
    JSR $FFD2
    LDA #$4C
    JSR $FFD2
    LDA $1700
    JSR $FFD2
    LDY #$00
L_87B5:
    LDA $1800,Y
    JSR $FFD2
    INY 
    CPY $1700
    BCC L_87B5
    LDY #$00
L_87C3:
    LDA $1701,Y
    JSR $FFD2
    INY 
    CPY #$0C
    BCC L_87C3
L_87CE:
    JSR L_92B2
    LDA #$00
    JSR L_9258
L_87D6:
    JMP L_9660
    ASL 
    ORA ($02,X)
    BRK 
    ASL $0E
    LDA #$00
    JSR L_915D
    BCS L_882C
    LDY #$02
    JSR L_9297
    JSR $FFCF
    LDX #$00
    CMP #$54
    BEQ L_880D
    JSR $FFCC
    LDX #$41
    LDY #$88
    STX $04
    STY $05
    JSR L_9598
    BCS L_8824
    PHA 
    LDX #$08
    JSR $FFC6
    PLA 
    TAX 
    INX 
L_880D:
    STX $24
    JSR L_8849
    BCS L_8825
    BIT $1F
    BPL L_8824
    LDA $24
    BNE L_8824
    JSR L_8956
    BCS L_8824
    JSR L_897A
L_8824:
    CLC 
L_8825:
    PHP 
    JSR L_92B2
    PLP 
    BCS L_8831
L_882C:
    LDA #$00
    JSR L_9258
L_8831:
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
    JSR $FFCF
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
    LDA #$05
    JSR L_9747
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
    LDY #$22
L_88ED:
    DEY 
    BMI L_88FA
    CMP VIZA_CS_IN,Y
    BNE L_88ED
    LDA VIZA_CS_OUT,Y
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
    !by 01,$02,$04,$05,$06,$07,$08,$0B
    !by $0C,$0D,$10,$5B,$5C,$5D,$7B,$7C
    !by $7D,$7E
L_8956:
    JSR CBM_CHRIN
    TAX 
    BEQ L_8956
    CMP #$4C
    SEC 
    BNE L_8979
    JSR CBM_CHRIN
    STA $1700
    LDY #$00
L_8969:
    JSR CBM_CHRIN
    STA $1800,Y
    INY 
    CPY $1700
    BCC L_8969
L_8975:
    JSR L_907B
    CLC 
L_8979:
    RTS 
L_897A:
    LDY #$00
L_897C:
    JSR CBM_CHRIN
    STA $1701,Y
    INY 
    LDA $90
    BEQ L_897C
    JMP L_9142
    LDA #$02
    JSR L_957C
    BCS L_8994
    JSR L_9258
L_8994:
    JMP L_9660
    LDY #$00
    JSR L_8A08
    BCS L_89B8
    LDA #$00
L_89A0:
    JSR L_8A6F
    BCS L_89B8
    LDA #$0E
    JSR L_9747
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
    LDA #$0F
    JSR L_9747
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
    LDA #$05
    JMP L_9747
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
    LDA #$0D
L_8A6C:
    JMP L_9747
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
    LDA #$0A
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
    LDA #$09
    JSR L_9747
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
    LDA #$08
    JSR L_9747
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
    LDA #$1E
    JMP L_9747
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
    JSR $FFE4
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
    BRK 
    BRK 
    BRK 
L_8C3D:
    BRK 
    !byte $00
    !byte $00
    !byte $00
    !byte $01
    !byte $02
    !byte $9F
    BRK 
    BRK 
    BRK 
    BRK 
    !byte $00
    !byte $00
    !byte $00
    !byte $03
    !byte $04
    !byte $9F
    BRK 
    BRK 
    !byte $00
    !byte $00
L_8C52:
    !byte $00
L_8C53:
    !byte $00
    !byte $00
L_8C55:
    !byte $05
    ASL $9F
    ORA ($09),Y
    PHP 
    !byte $0F
    ASL 
    BPL $8C6C
    ASL $0C0B
    !byte $B2
    !byte $BB
    LDY $BFBE,X
    LDA $B6,X
    TSX 
    CLV 
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
    !byte $B0
    !byte $0D
    !byte $F6
    !byte $77
    !byte $90
    !byte $06
L_8CB7:
    !byte $B5
    !byte $77
    !byte $F0
    !byte $05
    !byte $D6
    !byte $77
L_8CBD:
    !byte $20
    TAX 
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
    LDA #$06
    JSR L_9747
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
L_8F6A:
    LDA #$00
    TAY 
L_8F6D:
    STA $0002,Y
    STA $0200,Y
    STA $0300,Y
    INY 
    BNE L_8F6D
    LDY #$1F
L_8F7B:
    LDA $FD30,Y
    STA $0314,Y
    DEY 
    BPL L_8F7B
    LDA #$04
    STA $0288
    JSR $FF5B
    LDA #$0B
    STA L_D020
    LDA #$00
    STA L_D01C
    STA $D01D
    STA L_D017
    JSR L_9070
    LDX #$01
    LDY #$19
    STX $58
    STY $59
    STX $0342
    STY $0343
    LDX #$BB
    LDY #$0E
    STX $FFFA
    STY $FFFB
    STX $0318
    STY $0319
    LDX #$45
    LDY #$0E
    STX $FFFE
    STY $FFFF
    LDX #$4A
    LDY #$0E
    STX $0314
    STY $0315
    LDA #$1C
    STA $DC04
    STA L_DC05
    LDX #$10
    LDY #$7F
L_8FDD:
    LDA $0900,Y
    CMP $B100,Y
    BNE L_8FE9
    DEY 
    BPL L_8FDD
    DEX 
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
L_9130:
    STA $0450,Y
L_9133:
    DEY 
    BPL L_9130
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
    LDA #$01
    JSR L_9747
    LDX #$0B
    LDY #$92
    LDA #$02
    JSR $FFBD
    LDY #$00
L_916F:
    JSR L_9297
    BCS L_91D7
    LDA #$04
    STA $26
L_9178:
    JSR $FFCF
    DEC $26
    BNE L_9178
    LDA $90
    SEC 
    BNE L_91D7
    JSR $FFCC
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
    JSR $9474
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
    JSR $FFBD
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
    RTS 
    BIT $30
    !byte $04
    ORA ($02,X)
    BRK 
    ASL $0E
L_9213:
    LDX #$03
    STX $26
    JSR L_964F
    LDX #$08
    JSR $FFC6
L_921F:
    JSR $FFCF
    STA $1A
    JSR $FFCF
    STA $1B
    LDX $26
    LDY #$07
    JSR L_9682
    LDA #$00
L_9232:
    LDX $26
    JSR L_94E1
    BCS L_9250
    JSR $FFCF
    STA $1C
    JSR $FFCF
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
    JSR $FFCC
    PLP 
    PLA 
    RTS 
L_9258:
    LDX #$30
    LDY #$04
    JSR $FFBD
    LDA #$0F
    TAY 
    LDX #$08
    JSR $FFBA
    JSR $FFC0
    BCS L_928C
    LDX #$0F
    JSR $FFC6
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
    JSR $FFCC
    LDA #$0F
    JSR $FFC3
    PLP 
    RTS 
L_9297:
    TYA 
    AND #$01
    PHA 
    LDA #$08
    TAX 
    JSR $FFBA
    JSR $FFC0
    LDX #$08
    PLA 
    BCS L_92B1
L_92A9:
    BNE L_92AE
    JMP $FFC6
L_92AE:
    JSR $FFC9
L_92B1:
    RTS 
L_92B2:
    JSR $FFCC
    LDA #$08
    JMP $FFC3
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
    LDA L_930E,Y
    STA $F6
    LDY $CB
    LDA ($F5),Y
    !byte $24
    !byte $54
    !byte $10
    !byte $03
    !byte $20
    !byte $4B
    !byte $94
    !byte $9D
    !byte $77
    !byte $02
    !byte $A5
    !byte $53
    !byte $F0
    !byte $05
    !byte $A9
    !byte $00
    !byte $20
    !byte $1B
    !byte $94
L_930C:
    !byte $60
L_930D:
    !byte $17
L_930E:
    !byte $93
    !byte $58
    !byte $93
    !byte $99
    !byte $93
    !byte $99
    !byte $93
    !byte $DA
    !byte $93

; Mapovani klavesnice 4 blocks x 65 bytes
    !by $AF,$AD,$A2,$B1,$A6,$A8,$AA,$A0
    !by $90,$77,$61,$8A,$79,$73,$65,$00
    !by $8F,$72,$64,$3E,$63,$66,$74,$78
    !by $7E,$7A,$67,$82,$62,$68,$75,$76
    !by $84,$69,$6A,$83,$6D,$6B,$6F,$6E
    !by $2B,$70,$6C,$2D,$2E,$7C,$7D,$2C
    !by $00,$2A,$7B,$A4,$00,$3D,$5E,$2F
    !by $21,$5F,$00,$81,$20,$00,$71,$B3
    !by $00
    !by $B0,$AC,$A3,$B2,$A7,$A9,$AB,$A1
    !by $33,$57,$41,$34,$59,$53,$45,$00
    !by $35,$52,$44,$36,$43,$46,$54,$58
    !by $37,$5A,$47,$38,$42,$48,$55,$56
    !by $39,$49,$4A,$30,$4D,$4B,$4F,$4E
    !by $2B,$50,$4C,$80,$3A,$5C,$5D,$3B
    !by $91,$40,$5B,$A5,$00,$3C,$8E,$3F
    !by $31,$8D,$00,$32,$7F,$00,$51,$B3
    !by $00
    !by $00,$00,$00,$C0,$C0,$C0,$C0,$00
    !by $23,$00,$00,$24,$00,$B6,$00,$00
    !by $25,$BF,$BA,$26,$BB,$BE,$C3,$00
    !by $27,$00,$B9,$28,$00,$00,$87,$C2
    !by $29,$00,$00,$00,$BC,$00,$85,$88
    !by $00,$B7,$B5,$00,$8B,$86,$60,$8C
    !by $00,$00,$00,$C1,$00,$36,$BD,$89
    !by $00,$B4,$00,$22,$C1,$00,$B8,$B3
    !by $00
    !by $00,$AE,$00,$00,$00,$00,$00,$00
    !by $00,$19,$00,$00,$00,$0C,$04,$00
    !by $00,$1A,$00,$00,$06,$02,$07,$00
    !by $00,$0F,$00,$00,$03,$0E,$05,$00
    !by $00,$08,$09,$00,$00,$11,$18,$12
    !by $00,$01,$00,$00,$10,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$0B,$00
    !by $00,$0A,$00,$00,$00,$00,$00,$B3
    !by $00
L_941B:
    STA $53
    CMP #$06
    BCC L_9423
    LDA #$04
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
L_944B:
    CMP #$7E
    BCS L_9455
    CMP #$61
    !byte $90
    !byte $02
    !byte $E9
    !byte $20
L_9455:
    !byte $60
L_9456:
    !byte $1D
    !byte $53
    !byte $50
    !byte $41
    !byte $43
    !byte $1C
L_945C:
    !byte $1E
    ASL $1E1E,X
    ASL $1E1E,X
    ASL $1D1E,X
    AND $1C43,X
    ASL $1E1E,X
    ORA $524C,X
    !byte $54
    !byte $43
    !byte $1C
    ASL $A51E,X
    STA $5ED0,Y
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
    JSR $FFE4
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
    JSR $FFBD
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
    JSR L_9716
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
    STX $1C
    STY $1D
    LDA #$00
    LDY #$08
L_9703:
    ASL 
    ROL $1D
    BCC L_970F
    CLC 
    ADC $1C
    BCC L_970F
    INC $1D
L_970F:
    DEY 
    BNE L_9703
    TAX 
    LDY $1D
    RTS 
L_9716:
    PHA 
    LDY #$28
    JSR L_96FB
    STX $08
    TYA 
    ORA #$04
    STA $09
    PLA 
    BEQ L_9731
    PHA 
    TAY 
    DEY 
L_9729:
    LDA ($02),Y
    STA ($08),Y
    DEY 
    BPL L_9729
    PLA 
L_9731:
    TAY 
    LDA #$1F
L_9734:
    CPY #$28
    BCS L_973D
    STA ($08),Y
    INY 
    BNE L_9734
L_973D:
    RTS 
L_973E:
    LDA #$00
    STA $55
    LDX #$01
    JMP L_9716
L_9747:
    LDX #$FF
    STX $55
    LDX #$01
L_974D:
    TAY 
    TXA 
    PHA 
    TYA 
    BMI L_975B
    LDX #$5A
    LDY #$A6
    STX $02
    STY $03
L_975B:
    AND #$7F
    TAX 
L_975E:
    LDY #$00
L_9760:
    INY 
    LDA ($02),Y
    CMP #$0D
    BNE L_9760
    DEX 
L_9768:
    BMI L_9776
    TYA 
    SEC 
    ADC $02
    STA $02
    BCC L_975E
    INC $03
    BCS L_975E
L_9776:
    PLA 
    TAX 
    TYA 
    PHA 
    JSR L_9716
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
    LDA #$21
    JSR L_9747
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
    LDA #$1F
    JSR L_9747
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
pf_menu_rowdef_ptr_table:        ; pointer table (little-endian)
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
    !by $00,$09,$18,$28
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
    JSR $FFE4
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
    JSR $FFE4
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
    JSR $FFCC
    LDY #$00
    LDA $1705
    CMP #$04
    BEQ L_9B4C
    LDY $170E
L_9B4C:
    LDA #$04
    LDX $170D
    JSR $FFBA
    LDA #$00
    JSR $FFBD
    JSR $FFC0
    BCS L_9B66
    LDX #$04
    JSR $FFC9
    BCS L_9B66
    RTS 
L_9B66:
    JSR $FFCC
    LDA #$04
    JSR $FFC3
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
    !byte $F0
    !byte $01
    !byte $4A
L_9BEB:
    !byte $AA
    !byte $A9
    !byte $20
    !byte $20
    !byte $70
    !byte $9B
    !byte $CA
    !byte $D0
    !byte $F8
L_9BF4:
    !byte $60
VIZA_CS_IN:
    !by $F1		; 01 01
    !by $E6		; 02 02
    !by $ED		; 04 04
    !by $EE		; 05 05
    !by $DF		; 06 06
    !by $DB		; 07 07
    !by $EB		; 08 08
    !by $EF		; 0B 11
    !by $EC		; 0C 12
    !by $DC		; 0D 13
    !by $3E		; 3A 58	>
    !by $3C		; 3B 59	<
    !by $3B		; 3E 62	ž
    !by $79		; 5B 91	]
    !by $7A		; 5C 92	[
    !by $7B		; 5D 93	znak CBM
    !by $7D		; 60 96	ú
    !by $3A		; 7C 124	:
    !by $78		; 7D 125	@
    !by $1C		; 7E 126	ý
    !by $1E		; 81 129	ě
    !by $1F		; 82 130	á
    !by $26		; 83 131	é
    !by $27		; 84 132	í
    !by $7F		; 85 133	ó
    !by $7E		; 86 134	ů
    !by $40		; 88 136	ň
    !by $65		; 89 137	ď
    !by $00		; 8A 138	č
    !by $3E		; 8B 139	>>
    !by $3C		; 8C 140	<<
    !by $1B		; 8F 143	ř
    !by $1D		; 90 144	š
    !by $5E		; 91 145	ť
VIZA_CS_OUT:
    !by $01	; 01
    !by $02	; 02
    !by $04	; 04
    !by $05	; 05
    !by $06	; 06
    !by $07	; 07
    !by $08	; 08
    !by $0B	; 11
    !by $0C	; 12
    !by $0D	; 13
    !by $3A	; 58	>
    !by $3B	; 59	<
    !by $3E	; 62	ž
    !by $5B	; 91	]
    !by $5C	; 92	[
    !by $5D	; 93	znak CBM
    !by $60	; 96	ú
    !by $7C	; 124	:
    !by $7D	; 125	@
    !by $7E	; 126	ý
    !by $81	; 129	ě
    !by $82	; 130	á
    !by $83	; 131	é
    !by $84	; 132	í
    !by $85	; 133	ó
    !by $86	; 134	ů
    !by $88	; 136	ň
    !by $89	; 137	ď
    !by $8A	; 138	č
    !by $8B	; 139	>>
    !by $8C	; 140	<<
    !by $8F	; 143	ř
    !by $90	; 144	š
    !by $91	; 145	ť
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
    !tx $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1C, $1B, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $9F, $1B, $1D, $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1E, $0D
    !tx "SPACE=D", $82, "le, CRSR/RETURN=Na", $8A, $84, "st", $0D
    !tx "P", $8F, $84, "kaz|", $0D
    !tx "N", $82, "zev|", $0D
    !tx "Na", $8A, "ti", $1F, $1F, "P", $8F, "ipoj", $1F, $0D
    !tx "Pr", $8F, "te", $8A, "en", $84, " pam", $81, "ti", $0D
    !tx "Ozna", $8A, " konec a potvr", $89, $1F, "RETURN", $0D
    !tx "Ozna", $8A, " c", $84, "l a potvr", $89, $1F, $1F, $1F, "RETURN", $0D
    !tx "Voln~ch znak", $86, "|", $0D
    !tx "F1=Nab", $84, "dka",$1F, "F3=Text", $1F, "F5=Plocha", $1F, "F7=Okraje", $0D
    !tx "v", $90, "echno", $1F, $1F, $1F, $8A, $82, "st", $0D
    !tx "Filetyp?", $0D
    !tx "Hledat|", $0D
    !tx "Nov~", $0D
    !tx "RETURN=D", $82, "le", $1F, $1F, $0D
    !tx "RETURN=Nahradit,", $1F, "SPACE=P", $8F, "esko", $8A, "it", $1F, $1F, $1F, $0D
    !tx "ZS", $0D
    !tx "Pagefox", $0D	;$11
    !tx "H. Haberl ", $26," T. Kakul", $84, ">ek", $0D	;$12
    !tx "(C) 1987 by Scanntronik", $0D	;$13
    !tx $1F, $1F, $1F, "Low", $1F, $1F, $1F, "Medium", $1F, $1F, $1F, "High", $1F, $1F, $1F, "Shinwa", $1F, $1F, $1F, "MPS", $0D
    !tx $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, "Auto-Linefeed", $1F, $1F, $1F, "Linefeed", $0D
    !tx $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, "Vlevo", $1F, $1F, "St", $8F, "ed", $1F, $1F, "Vpravo", $0D
    !tx $1F, $1F, $1F, "Tisk|", $1F, $1F, "Jedna", $1F, "str", $82, "nka", $1F, $1F, "V" ,$84, "ce", $1F, "stran", $1F, $0D
    !tx "Rozlo>en", $84, "?", $0D
    !tx "Nen", $84, " kam vlo>it", $0D
    !tx "Disk-Error", $0D
    !tx "Stop", $0D
    !tx "Pokra", $8A, "ovat", $1F, $1F, "Zru", $90, "it", $1F, $0D
    !tx $1F, "ASCII", $1F, $1F, "CBM-ASCII", $1F, $1F, "Bildschirmcode", $1F, $1F, "Viza", $0D
    !tx "Pagefox-cs", $1F, "v2.5", $1F, "(01/2026)", $0D
    !tx $8A, $84, "slo|", $1F, $0D
    !tx $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, "Standard", $1F, $1F, $1F, "Tabela", $8A, "n", $84, $1F, $1F, $0D
    !tx $8F, $82, "dky|", $1F, $0D
    !tx "M34", $0D
    !by $00,$00
}

*=$3000

!pseudopc $B000 {
; Definice pisma
    !by $00,$00,$38,$7C,$7C,$7C,$38,$00		;00 tlustá tečka
    !by $00,$00,$38,$7C,$7C,$7C,$38,$00		;01 tlustá tečka
    !by $FF,$F1,$E7,$C1,$E7,$E7,$E7,$00		;02 f (negativní)
    !by $FF,$9F,$9F,$83,$99,$99,$83,$00		;03 b (negativní)
    !by $FF,$FF,$C3,$99,$81,$9F,$C3,$00		;04 e (negativní)
    !by $FF,$FF,$99,$99,$99,$99,$C1,$00		;05 u (negativní)
    !by $FF,$FF,$C3,$9F,$9F,$9F,$C3,$00		;06 c (negativní)
    !by $FF,$E7,$81,$E7,$E7,$E7,$F1,$00		;07 t (negativní)
    !by $FF,$E7,$FF,$C7,$E7,$E7,$C3,$00		;08 i (negativní)
    !by $C3,$99,$F9,$F3,$E7,$FF,$E7,$00		;09 ? (negativní)
    !by $FF,$DF,$9F,$01,$01,$9F,$DF,$00		;0A šipka vlevo (negativní)
    !by $E7,$C3,$81,$E7,$E7,$E7,$E7,$00		;0B šipka nahoru (negativní)
    !by $E7,$E7,$E7,$E7,$81,$C3,$E7,$00		;0C šipka dolů (negativní)
    !by $10,$3F,$7F,$FF,$7F,$3F,$10,$00		;0D tlustá šipka vlevo
    !by $FF,$9F,$9F,$83,$99,$99,$99,$00		;0E h (negativní)
    !by $FF,$FF,$81,$F3,$E7,$CF,$81,$00		;0F z (negativní)
    !by $FF,$FF,$FF,$FF,$FF,$E7,$E7,$00		;10 . (negativní)
    !by $FF,$9F,$9F,$93,$87,$93,$99,$00		;11 k (negativní)
    !by $FF,$FF,$83,$99,$99,$99,$99,$00		;12 n (negativní)
    !by $00,$00,$00,$00,$00,$00,$00,$00		;13
    !by $00,$00,$00,$00,$00,$00,$00,$00		;14
    !by $00,$00,$00,$00,$00,$00,$00,$00		;15
    !by $00,$00,$00,$00,$00,$00,$00,$00		;16
    !by $00,$00,$00,$00,$00,$00,$00,$00		;17
    !by $FF,$FF,$C3,$99,$99,$99,$C3,$00		;18 o (negativní)
    !by $FF,$FF,$9C,$94,$80,$C1,$C9,$00		;19 w (negativní)
    !by $FF,$FF,$83,$99,$9F,$9F,$9F,$00		;1A r (negativní)
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		;1B celé negativní
    !by $03,$0F,$3F,$FF,$FF,$3F,$0F,$03		;1C <|
    !by $C0,$F0,$FC,$FF,$FF,$FC,$F0,$C0		;1D |>
    !by $00,$00,$00,$FF,$FF,$00,$00,$00		;1E -
    !by $00,$00,$00,$00,$00,$00,$00,$00		;1F mezera
    !by $00,$00,$00,$00,$00,$00,$08,$00		;20 .
    !by $18,$18,$18,$18,$00,$00,$18,$00		;21 !
    !by $66,$66,$66,$00,$00,$00,$00,$00		;22 "
    !by $66,$66,$FF,$66,$FF,$66,$66,$00		;23 #
    !by $18,$3E,$60,$3C,$06,$7C,$18,$00		;24 $
    !by $62,$66,$0C,$18,$30,$66,$46,$00		;25 %
    !by $3C,$66,$3C,$38,$67,$66,$3F,$00		;26 &
    !by $06,$0C,$18,$00,$00,$00,$00,$00		;27 '
    !by $0C,$18,$30,$30,$30,$18,$0C,$00		;28 (
    !by $30,$18,$0C,$0C,$0C,$18,$30,$00		;29 )
    !by $00,$66,$3C,$FF,$3C,$66,$00,$00		;2A *
    !by $00,$18,$18,$7E,$18,$18,$00,$00		;2B +
    !by $00,$00,$00,$00,$00,$18,$18,$30		;2C ,
    !by $00,$00,$00,$7E,$00,$00,$00,$00		;2D -
    !by $00,$00,$00,$00,$00,$18,$18,$00		;2E .
    !by $00,$03,$06,$0C,$18,$30,$60,$00		;2F /
    !by $3C,$66,$6E,$76,$66,$66,$3C,$00		;30 0
    !by $18,$38,$18,$18,$18,$18,$7E,$00		;31 1
    !by $3C,$66,$06,$0C,$30,$60,$7E,$00		;32 2
    !by $3C,$66,$06,$1C,$06,$66,$3C,$00		;33 3
    !by $06,$0E,$1E,$66,$7F,$06,$06,$00		;34 4
    !by $7E,$60,$7C,$06,$06,$66,$3C,$00		;35 5
    !by $1C,$30,$60,$7C,$66,$66,$3C,$00		;36 6
    !by $7E,$66,$06,$0C,$18,$18,$18,$00		;37 7
    !by $3C,$66,$66,$3C,$66,$66,$3C,$00		;38 8
    !by $3C,$66,$66,$3E,$06,$0C,$38,$00		;39 9
    !by $70,$18,$0C,$06,$0C,$18,$70,$00		;3A >
    !by $0E,$18,$30,$60,$30,$18,$0E,$00		;3B <
    !by $00,$10,$38,$10,$00,$00,$38,$00		;3C +-
    !by $00,$00,$7E,$00,$7E,$00,$00,$00		;3D =
    !by $24,$18,$7E,$0C,$18,$30,$7E,$00		;3E ž
    !by $3C,$66,$06,$0C,$18,$00,$18,$00		;3F ?
    !by $3C,$60,$3C,$66,$3C,$06,$3C,$00		;40 §
    !by $18,$3C,$66,$66,$7E,$66,$66,$00		;41 A
    !by $7C,$66,$66,$7C,$66,$66,$7C,$00		;42 B
    !by $3C,$66,$60,$60,$60,$66,$3C,$00		;43 C
    !by $78,$6C,$66,$66,$66,$6C,$78,$00		;44 D
    !by $7E,$60,$60,$78,$60,$60,$7E,$00		;45 E
    !by $7E,$60,$60,$78,$60,$60,$60,$00		;46 F
    !by $3C,$66,$60,$6E,$66,$66,$3C,$00		;47 G
    !by $66,$66,$66,$7E,$66,$66,$66,$00		;48 H
    !by $3C,$18,$18,$18,$18,$18,$3C,$00		;49 I
    !by $1E,$0C,$0C,$0C,$0C,$6C,$38,$00		;4A J
    !by $66,$6C,$78,$70,$78,$6C,$66,$00		;4B K
    !by $60,$60,$60,$60,$60,$60,$7E,$00		;4C L
    !by $63,$77,$7F,$6B,$63,$63,$63,$00		;4D M
    !by $66,$76,$7E,$7E,$6E,$66,$66,$00		;4E N
    !by $3C,$66,$66,$66,$66,$66,$3C,$00		;4F O
    !by $7C,$66,$66,$7C,$60,$60,$60,$00		;50 P
    !by $3C,$66,$66,$66,$66,$6A,$3C,$06		;51 Q
    !by $7C,$66,$66,$7C,$78,$6C,$66,$00		;52 R
    !by $3C,$66,$60,$3C,$06,$66,$3C,$00		;53 S
    !by $7E,$18,$18,$18,$18,$18,$18,$00		;54 T
    !by $66,$66,$66,$66,$66,$66,$3C,$00		;55 U
    !by $63,$63,$36,$36,$1C,$1C,$08,$00		;56 V
    !by $63,$63,$63,$6B,$7F,$77,$63,$00		;57 W
    !by $66,$66,$3C,$18,$3C,$66,$66,$00		;58 X
    !by $66,$66,$66,$3C,$18,$18,$18,$00		;59 Y
    !by $7E,$06,$0C,$18,$30,$60,$7E,$00		;5A Z
    !by $3C,$0C,$0C,$0C,$0C,$0C,$3C,$00		;5B ]
    !by $3C,$30,$30,$30,$30,$30,$3C,$00		;5C [
    !by $38,$7F,$C6,$C0,$C6,$7F,$38,$00		;5D cbm logo
    !by $18,$3C,$7E,$18,$18,$18,$18,$00		;5E šipka nahoru
    !by $00,$20,$60,$FE,$FE,$60,$20,$00		;5F šipka vlevo
    !by $0C,$18,$66,$66,$66,$66,$3E,$00		;60 ú
    !by $00,$00,$3C,$06,$3E,$66,$3E,$00		;61 a
    !by $00,$60,$60,$7C,$66,$66,$7C,$00		;62 b
    !by $00,$00,$3C,$60,$60,$60,$3C,$00		;63 c
    !by $00,$06,$06,$3E,$66,$66,$3E,$00		;64 d
    !by $00,$00,$3C,$66,$7E,$60,$3C,$00		;65 e
    !by $00,$0E,$18,$3E,$18,$18,$18,$00		;66 f
    !by $00,$00,$3E,$66,$66,$3E,$06,$7C		;67 g
    !by $00,$60,$60,$7C,$66,$66,$66,$00		;68 h
    !by $00,$18,$00,$38,$18,$18,$3C,$00		;69 i
    !by $00,$06,$00,$06,$06,$06,$06,$3C		;6A j
    !by $00,$60,$60,$6C,$78,$6C,$66,$00		;6B k
    !by $00,$38,$18,$18,$18,$18,$3C,$00		;6C l
    !by $00,$00,$66,$7F,$7F,$6B,$63,$00		;6D m
    !by $00,$00,$7C,$66,$66,$66,$66,$00		;6E n
    !by $00,$00,$3C,$66,$66,$66,$3C,$00		;6F o
    !by $00,$00,$7C,$66,$66,$7C,$60,$60		;70 p
    !by $00,$00,$3E,$66,$66,$3E,$06,$06		;71 q
    !by $00,$00,$7C,$66,$60,$60,$60,$00		;72 r
    !by $00,$00,$3E,$60,$3C,$06,$7C,$00		;73 s
    !by $00,$18,$7E,$18,$18,$18,$0E,$00		;74 t
    !by $00,$00,$66,$66,$66,$66,$3E,$00		;75 u
    !by $00,$00,$66,$66,$66,$3C,$18,$00		;76 v
    !by $00,$00,$63,$6B,$7F,$3E,$36,$00		;77 w
    !by $00,$00,$66,$3C,$18,$3C,$66,$00		;78 x
    !by $00,$00,$66,$66,$66,$3E,$0C,$78		;79 y
    !by $00,$00,$7E,$0C,$18,$30,$7E,$00		;7A z
    !by $00,$00,$18,$00,$00,$18,$18,$30		;7B ;
    !by $00,$00,$18,$00,$00,$18,$00,$00		;7C :
    !by $3C,$66,$6E,$6E,$60,$62,$3C,$00		;7D @
    !by $0C,$18,$66,$66,$66,$3E,$0C,$78		;7E ý
    !by $00,$00,$00,$00,$00,$00,$7F,$00		;7F _
    !by $02,$3A,$18,$18,$18,$18,$3C,$00		;80 í
    !by $24,$18,$3C,$66,$7E,$60,$3C,$00		;81 ě
    !by $0C,$18,$3C,$06,$3E,$66,$3E,$00		;82 á
    !by $0C,$18,$3C,$66,$7E,$60,$3C,$00		;83 é
    !by $0C,$18,$00,$38,$18,$18,$3C,$00		;84 í
    !by $0C,$18,$3C,$66,$66,$66,$3C,$00		;85 ó
    !by $18,$18,$66,$66,$66,$66,$3E,$00		;86 ů
    !by $00,$00,$66,$66,$66,$7E,$60,$C0		;87 µ
    !by $24,$18,$7C,$66,$66,$66,$66,$00		;88 ň
    !by $01,$0D,$0C,$3C,$6C,$6C,$3C,$00		;89 ď
    !by $24,$18,$3C,$60,$60,$60,$3C,$00		;8A č
    !by $D8,$6C,$36,$1B,$36,$6C,$D8,$00		;8B >>
    !by $1B,$36,$6C,$D8,$6C,$36,$1B,$00		;8C <<
    !by $00,$04,$06,$7F,$7F,$06,$04,$00		;8D šipka vpravo
    !by $18,$18,$18,$18,$7E,$3C,$18,$00		;8E šipka dolů
    !by $24,$18,$7C,$66,$60,$60,$60,$00		;8F ř
    !by $24,$18,$3E,$60,$3C,$06,$7C,$00		;90 š
    !by $01,$19,$7E,$18,$18,$18,$0E,$00		;91 ť
    !by $FF,$FC,$FC,$FC,$FC,$FC,$FC,$FF		;92 P
    !by $FF,$01,$FC,$FC,$01,$FF,$FF,$FF		;93 P
    !by $FF,$F8,$F3,$E7,$E0,$E7,$E7,$FF		;94 A
    !by $FF,$1F,$CF,$E7,$07,$E7,$E7,$FF		;95 A
    !by $FF,$80,$3E,$3F,$30,$3E,$80,$FF		;96 G
    !by $FF,$F0,$73,$F3,$70,$73,$F0,$FF		;97 G
    !by $FF,$07,$FF,$FF,$1F,$FF,$07,$FF		;98 E
    !by $FF,$00,$3F,$3F,$01,$3F,$3F,$FF		;99 F
    !by $FF,$78,$F3,$F3,$F3,$F3,$F8,$FF		;9A O
    !by $FF,$0F,$E7,$E7,$E7,$E7,$0F,$FF		;9B O
    !by $FF,$1E,$CC,$E1,$E1,$CC,$1E,$FF		;9C X
    !by $FF,$3F,$FF,$FF,$FF,$FF,$3F,$FF		;9D X
    !by $FF,$81,$3F,$3F,$3F,$3F,$81,$FF		;9E C
    !by $FF,$C0,$9F,$9F,$C0,$FE,$80,$FF		;9F S
    !by $88,$00,$22,$00,$88,$00,$22,$00		;A0 vzor 1
    !by $88,$22,$88,$22,$88,$22,$88,$22		;A1 vzor 2
    !by $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA		;A2 vzor 3
    !by $FF,$00,$FF,$00,$FF,$00,$FF,$00		;A3
    !by $44,$44,$44,$44,$44,$44,$44,$44		;A4
    !by $00,$FF,$00,$00,$00,$FF,$00,$00		;A5
    !by $44,$22,$11,$88,$44,$22,$11,$88		;A6
    !by $22,$44,$88,$11,$22,$44,$88,$11		;A7
    !by $10,$08,$04,$02,$01,$80,$40,$20		;A8
    !by $08,$10,$20,$40,$80,$01,$02,$04		;A9
    !by $C9,$93,$27,$4E,$9C,$39,$72,$E4		;AA
    !by $FF,$08,$08,$08,$FF,$80,$80,$80		;AB
    !by $08,$1C,$22,$C1,$80,$01,$02,$04		;AC
    !by $00,$08,$1C,$3E,$7F,$3E,$1C,$08		;AD
    !by $F8,$EC,$CE,$8F,$F1,$73,$37,$1F		;AE
    !by $FF,$FE,$FC,$F8,$F0,$E0,$C0,$80		;AF
    !by $3E,$08,$08,$14,$E3,$80,$80,$41		;B0
    !by $47,$8F,$17,$22,$71,$F8,$74,$22		;B1
    !by $8F,$77,$98,$F8,$F8,$77,$89,$8F		;B2
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		;B3 vzor 20
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
    JMP $0DAE
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
    JSR $FFCF
    CMP #$9B
    BNE L_B9D0
    BIT $1F
    BVS L_B9D0
    JSR $FFCF
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
    JSR $FFCF
L_B9CB:
    STA $27
    JSR $FFCF
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
    JSR $FFD2
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
    JSR $FFD2
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
    JSR $FFD2
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
    JSR $FFD2
    LDA $07
    JSR $1640
    LDA $06
    JSR $1640
    LDA #$0D
    JSR $FFD2
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
    JSR $FFD2
    LDA $0B
    JSR $FFD2
    LDA #$20
    JSR $FFD2
    LDA $08
    ORA #$30
    JSR $FFD2
    LDA #$20
    JSR $FFD2
    LDA $03
    JSR $1640
    TYA 
    JSR $1640
    LDA #$20
    JSR $FFD2
    LDA $09
    JSR $1640
    LDA #$20
    JSR $FFD2
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
    ; Default UI/Editor colors table (identified by Tomas)
    ; CPU $BF00 (file $3F00). Bytes: 00,03,00,01,0F,...
    ;   $BF01 = $03  editor text color
    ;   $BF02 = $00  editor background
    ;   $BF03 = $01  menu color
    ;   $BF04 = $0F  graphics editor on and off color 0F means 0 - on = black, F - off - light gray (backgroud)
    ;   00 = black
    ;   01 = white
    ;   02 = red
    ;   03 = cyan
    ;   04 = purple
    ;   05 = green
    ;   06 = blue
    ;   07 = yellow
    ;   08 = orange
    ;   09 = brown
    ;   0A = pink
    ;   0B = dark grey
    ;   0C = grey
    ;   0D = light green
    ;   0E = light blue
    ;   0F = light grey
    ; -------------------------------------------------------------
    !by $00
    !by $03
    !by $00
    !by $01
    !by $0F
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
    JSR $FFE4
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
    JSR $FFCC
    JSR $AF0D
    JSR L_8AEC
    PLA 
    BCS L_C461
    STA $1F
    LDX #$08
    JSR $FFC6
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
    JSR $FFCF
    LDY $90
    BNE L_C4A9
    LDY #$00
    CMP #$47
    BEQ L_C4AE
    INY 
    CMP #$42
    BEQ L_C4AE
    TAX 
    JSR $FFCF
    CPX #$50
    BNE L_C4A6
    STA $22
    JSR $FFCF
    STA $23
    JSR $B156
L_C49C:
    JSR $FFCF
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
    JSR $FFD2
    LDA #$20
    BNE L_C522
L_C508:
    TAX 
    LDA $8547,X
    JSR $FFD2
    CPX #$02
    BCC L_C525
    LDA $50
    JSR $FFD2
    LDA $51
    JSR $FFD2
    JSR $1238
    LDA #$00
L_C522:
    JSR $FFD2
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
    JSR $FFD2
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
    JSR $FFE4
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
    JSR $FFD2
    LDA #$00
    JSR $FFD2
    LDA $24
    JSR $FFD2
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
    JSR $FFD2
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
    JSR $FFD2
    LDA $26
    JSR $FFD2
    LDA $27
L_C621:
    JSR $FFD2
    LDA #$01
    STA $26
    LDA #$00
    STA $27
L_C62C:
    LDA $24
    JSR $FFD2
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
    JSR $FFE4
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
    ; Definice pozic pro vypis textu 11, 12 a 13
    !by $11,$28,$CC,$08
    !by $12,$02,$C0,$23
    !by $13,$02,$C4,$2F
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
    JSR $FFE4
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
    JSR $FFBD
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
    BRK 
    BRK 
    ORA $2B,X
    !byte $22
    CLI 
    PHP 
    BRK 
    JSR $0200
    BRK 
    !byte $00
    !byte $00
    !byte $01
    !byte $FF
    !byte $07
    !byte $F8
    !byte $02
    !byte $00
    !byte $00
    !byte $00
    !byte $08
    !byte $00
    !byte $20
    !byte $00
    !byte $00
    !byte $01
    !byte $FF
    !byte $FF
    !byte $FF
    !byte $13
    !byte $80
    !byte $00
    !byte $01
    !byte $01
    !byte $FF
    !byte $FF
    !byte $FF
    !byte $00
    !byte $01
    !byte $FF
    !byte $FF
    !byte $FF
    !byte $14
    !byte $80
    BRK 
    BRK 
    BRK 
    ASL 
    BRK 
    BRK 
    BRK 
    !byte $01
    !byte $00
    !byte $3F
    !byte $00
    !byte $01
    !byte $00
    !byte $3E
    !byte $00
    !byte $01
    !byte $00
    !byte $3C
    BRK 
    ORA ($00,X)
    ROL $0100,X
    !byte $00
    !byte $37
    BRK 
    ORA ($00,X)
    !byte $23
    !byte $80
    ORA ($00,X)
    ORA ($C0,X)
    ORA ($00,X)
    BRK 
    !byte $E0
    !byte $01
    !byte $00
    !byte $00
    !byte $40
    !byte $02
    !byte $00
    !byte $00
    !byte $00
    !byte $00
    !byte $14
    BRK 
    BRK 
    ORA ($01,X)
    !byte $FF
    !byte $FF
    !byte $FF
    BRK 
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
    JSR $FFBD
    LDA #$5A
    JSR $B1C8
    BCS L_F0A7
    LDY #$00
L_F060:
    JSR $FFCF
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
    JSR $FFCF
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
    JSR $FFCF
    TAX 
    BEQ L_F0E1
    LDA #$18
    CPX #$4C
    SEC 
    BNE L_F103
    JSR $FFCF
    STA $1700
    LDY #$00
L_F0F6:
    JSR $FFCF
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
    JSR $FFCF
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
    JSR $FFCF
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
    JSR $FFCF
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
    JSR $FFBA
    JSR $FFC0
    LDX #$08
    PLA 
    BCS L_F221
    BNE L_F21E
    JMP $FFC6
L_F21E:
    JSR $FFC9
L_F221:
    RTS 
    JSR $FFCC
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
    !byte $FF
}
* = $8000