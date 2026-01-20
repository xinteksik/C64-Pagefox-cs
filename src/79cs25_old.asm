; All-in-one ACME source for 1-rom-0.bin
!initmem $ff
!to "79cs25.bin", plain
* = 0
!pseudopc $8000 {
; --- $0000-$1316 ---
    ; header / signature
    !by $31,$80,$BB,$0E,$C3,$C2,$CD,$38
    !by $30,$50,$46,$20,$56,$31,$2E,$30
    jmp $8045
    jmp $92BA
    jmp $9039
    jmp $9747
    jmp $957C
    jmp $915D
    jmp $9258
    jmp $977F
    jmp $98A2
    jmp $8ECC
    jmp $9474
    sei
    jsr $FDA3
    lda $DC01
    and #$10
    beq L8042
    jsr $8F6A
    jmp $0DA8

L8042:
    jmp ($A000)
    ldx #$FE
    txs
    jsr $90B0

L804B:
    jsr $8054
    jsr $8BA1

L8051:
    jmp $804B

L8054:
    jsr $949D

L8057:
    beq L8077
    sta $61
    bit $55
    bpl L8064
    pha
    jsr $973E
    pla

L8064:
    cmp #$A0
    bcs L806B
    jmp $80C0

L806B:
    sbc #$A0
    asl
    tax
    lda $8079,x
    pha
    lda $8078,x
    pha

L8077:
    rts

; -------------------------------------------------------------
; Jump/return vector table (words, interleaved low/high)
; Used by the dispatcher above:
;   X = 2*index
;   push high from $8079,X then low from $8078,X
; -------------------------------------------------------------
L8078:
    !by $60
L8079:
    !by $82,$10,$82,$52,$82,$FA,$81,$7E
    !by $82,$AF,$82,$DD,$82,$02,$83,$B7
    !by $82,$D2,$82,$12,$83,$1D,$83,$2B
    !by $83,$EF,$80,$EF,$80,$03,$81,$FE
    !by $80,$1C,$81,$18,$85,$76,$80,$2F
    !by $85,$DE,$87,$48,$87,$A7,$0D,$A7
    !by $0D,$AD,$0D,$89,$89,$40,$85,$28
    !by $85,$32,$94,$96,$89,$BD,$89,$45
    !by $8B,$82,$8B,$9B,$8B,$76,$80

L80C0:
    cmp #$20
    bcc L80E6
    ldy $23
    lda ($58),y
    cmp #$02
    bcc L80EA
    cmp #$0D
    beq L80EA
    lda $61
    sta ($58),y
    ldx $58
    ldy $59
    stx $02
    sty $03
    ldx $22
    lda $66
    jsr $9716
    jmp $8253

L80E6:
    cmp #$03
    bcc L80F2

L80EA:
    jsr $8132
    jmp $8253
    lda #$0D

L80F2:
    jsr $8130
    bcs L80FE
    lda $23
    sta $66
    jsr $8253

L80FE:
    rts
    lda #$20
    jmp $8130
    ldy $23
    lda ($58),y
    cmp #$0D
    beq L8110
    cmp #$02
    bcs L8119

L8110:
    jsr $81FB
    ldy $23
    lda ($58),y
    beq L811C

L8119:
    jsr $8190

L811C:
    rts
    ldy $23
    lda ($58),y
    cmp #$0D
    beq L812D
    lda #$0D
    jsr $8130
    jmp $83A5

L812D:
    jmp $8190

L8130:
    sta $61

L8132:
    lda $5A
    tax
    sec
    sbc $58
    lda $5B
    tay
    sbc $59
    sta $1C
    inx
    bne L8147
    iny
    cpy #$3C
    bcs L8189

L8147:
    stx $5A
    sty $5B
    tax
    inx
    lda $58
    clc
    adc $23
    sta $02
    sta $08
    lda $59
    adc $1C
    sta $03
    sta $09
    inc $08
    bne L8164
    inc $09

L8164:
    jsr $81D8
    ldy $23
    lda $61
    sta ($58),y
    inc $66
    lda $66
    cmp #$29
    bcs L8184
    ldx $58
    ldy $59
    stx $02
    sty $03
    ldx $22
    jsr $9716
    clc
    rts

L8184:
    jsr $83A5
    clc
    rts

L8189:
    lda #$05
    jsr $9747
    sec
    rts

L8190:
    lda $5A
    tay
    sec
    sbc $58
    lda $5B
    sbc $59
    tax
    inx
    tya
    bne L81A1
    dec $5B

L81A1:
    dec $5A
    lda $58
    clc
    adc $23
    sta $02
    sta $08
    lda $59
    adc #$00
    sta $03
    sta $09
    inc $02
    bne L81BA
    inc $03

L81BA:
    jsr $81EA
    dec $66
    lda $23
    cmp $66
    bcs L81D5
    ldx $58
    ldy $59
    stx $02
    sty $03
    ldx $22
    lda $66
    jsr $9716
    rts

L81D5:
    jmp $83A5

L81D8:
    ldy #$00

L81DA:
    dey
    lda ($02),y
    sta ($08),y
    tya
    bne L81DA
    dec $03
    dec $09
    dex
    bne L81DA
    rts

L81EA:
    ldy #$00

L81EC:
    lda ($02),y
    sta ($08),y
    iny
    bne L81EC
    inc $03
    inc $09
    dex
    bne L81EC
    rts

L81FB:
    lda $23
    bne L8206
    jsr $8382
    lda $23
    beq L820B

L8206:
    dec $23
    jmp $9660

L820B:
    lda #$27
    sta $23
    bne L8214
    jsr $8382

L8214:
    lda $22
    cmp #$03
    beq L8234
    jsr $8463
    lda $58
    sec
    sbc $02
    sta $66
    jsr $8332
    dec $22
    ldx $02
    ldy $03
    stx $58
    sty $59
    jmp $9660

L8234:
    jsr $8421
    ldx $56
    ldy $57
    stx $58
    sty $59
    stx $02
    sty $03
    jsr $84A8
    sta $66
    jsr $8332
    ldx #$03
    jsr $8482
    jmp $9660

L8253:
    inc $23
    lda $23
    cmp $66
    bcc L825E
    jmp $83A5

L825E:
    jmp $9660

L8261:
    lda $58
    clc
    adc $66
    sta $02
    lda $59
    adc #$00
    sta $03
    jsr $84A8
    tay
    jsr $8334
    lda $23
    clc
    adc $66
    sta $23
    jmp $83A5
    lda $22
    cmp #$03
    bne L8291
    lda $23
    bne L8291
    ldx #$01
    ldy #$19
    stx $56
    sty $57

L8291:
    ldx $56
    ldy $57
    stx $58
    sty $59
    stx $02
    sty $03
    jsr $84A8
    sta $66
    lda #$00
    sta $23
    ldx #$03
    stx $22
    jsr $8482
    jmp $9660

L82B0:
    jsr $833C
    lda #$12
    jmp $8354
    lda $5A
    cmp $0342
    lda $5B
    sbc $0343
    bcc L82B0
    ldx $0342
    ldy $0343
    stx $58
    sty $59
    lda #$0A
    jmp $8354
    ldx $58
    ldy $59
    stx $0342
    sty $0343
    rts
    ldx $56
    ldy $57
    stx $02
    sty $03
    lda #$12
    sta $26

L82EA:
    jsr $84A8
    bcc L8300
    clc
    adc $02
    sta $02
    sta $56
    bcc L82FC
    inc $03
    inc $57

L82FC:
    dec $26
    bne L82EA

L8300:
    jmp $8291
    lda #$12
    sta $26

L8307:
    jsr $8421
    beq L8310
    dec $26
    bne L8307

L8310:
    jmp $8291

L8313:
    jsr $8382
    ldy $66
    dey
    sty $23
    jmp $9660
    lda $23
    beq L8313

L8322:
    jsr $8382
    lda #$00
    sta $23
    jmp $9660
    jsr $8322
    jmp $8261

L8332:
    ldy $66

L8334:
    dey
    cpy $23
    bcs L833B
    sty $23

L833B:
    rts

L833C:
    ldy #$00

L833E:
    lda ($58),y
    beq L8349
    iny
    bne L833E
    inc $59
    bne L833E

L8349:
    tya
    clc
    adc $58
    sta $58
    bcc L8353
    inc $59

L8353:
    rts

L8354:
    ldx $58
    ldy $59
    stx $56
    sty $57
    sta $26

L835E:
    jsr $8421
    beq L8367
    dec $26
    bne L835E

L8367:
    ldx #$58
    jsr $84D7
    stx $22
    ldx $56
    ldy $57
    stx $02
    sty $03
    ldx #$03
    jsr $8482
    lda #$00
    sta $23
    jmp $83A5

L8382:
    lda $22
    cmp #$03
    beq L8395
    jsr $8463
    jsr $84A8
    clc
    adc $02
    cmp $58
    bne L83A5

L8395:
    ldx $58
    ldy $59
    stx $02
    sty $03
    jsr $84A8
    cmp $66
    bne L83A5
    rts

L83A5:
    lda $58
    clc
    adc $23
    sta $58
    bcc L83B0
    inc $59

L83B0:
    jsr $8463
    stx $22
    txa
    pha
    lda $02
    pha
    lda $03
    pha

L83BD:
    lda $58
    sec
    sbc $02
    sta $23
    jsr $84A8
    sta $66
    bcc L83E0
    lda $23
    cmp $66
    bcc L83E0
    inc $22
    lda $02
    clc
    adc $66
    sta $02
    bcc L83BD
    inc $03
    bcs L83BD

L83E0:
    ldx $02
    ldy $03
    stx $58
    sty $59
    jsr $8332

L83EB:
    lda $22
    cmp #$18
    bcc L8413
    pla
    pla
    pla
    lda #$03
    pha
    ldx $56
    ldy $57
    stx $02
    sty $03
    jsr $84A8
    clc
    adc $56
    sta $56
    pha
    lda $57
    adc #$00
    sta $57
    pha
    dec $22
    bne L83EB

L8413:
    pla
    sta $03
    pla
    sta $02
    pla
    tax
    jsr $8482
    jmp $9660

L8421:
    lda $56
    sec
    sbc #$28
    sta $56
    bcs L842C
    dec $57

L842C:
    ldy #$27
    lda #$FF
    sta $6A

L8432:
    lda ($56),y
    beq L8455
    cmp #$02
    beq L8456
    cpy #$27
    beq L8450
    cmp #$01
    beq L8455
    cmp #$0D
    beq L8455
    cmp #$2D
    beq L844E
    cmp #$20
    bne L8450

L844E:
    sty $6A

L8450:
    dey
    bpl L8432
    ldy $6A

L8455:
    iny

L8456:
    tya
    clc
    adc $56
    sta $56
    bcc L8460
    inc $57

L8460:
    cpy #$28
    rts

L8463:
    lda $56
    sta $02
    lda $57
    sta $03
    ldx #$04

L846D:
    cpx $22
    bcs L8480
    jsr $84A8
    clc
    adc $02
    sta $02
    bcc L847D
    inc $03

L847D:
    inx
    bne L846D

L8480:
    dex
    rts

L8482:
    txa
    pha
    jsr $84A8
    bcc L849F
    pha
    jsr $9716
    pla
    clc
    adc $02
    sta $02
    bcc L8497
    inc $03

L8497:
    pla
    tax
    inx
    cpx #$19
    bcc L8482
    rts

L849F:
    jsr $9716
    pla
    tax
    inx
    jmp $964F

L84A8:
    ldy #$00
    lda #$28
    sta $6A

L84AE:
    lda ($02),y
    iny
    cmp #$01
    bcc L84C0
    beq L84C0
    cmp #$02
    bne L84C2
    cpy #$01
    beq L84C2
    dey

L84C0:
    tya
    rts

L84C2:
    cmp #$0D
    beq L84C0
    cmp #$20
    beq L84CE
    cmp #$2D
    bne L84D0

L84CE:
    sty $6A

L84D0:
    cpy #$28
    bcc L84AE
    lda $6A
    rts

L84D7:
    lda $56
    sta $02
    lda $57
    sta $03
    lda #$03
    sta $26

L84E3:
    lda $00,x
    sec
    sbc $02
    sta $1C
    lda $01,x
    sbc $03
    bcc L8510
    beq L84F6
    lda #$FF
    sta $1C

L84F6:
    jsr $84A8
    cmp $1C
    beq L84FF
    bcs L8514

L84FF:
    clc
    adc $02
    sta $02
    bcc L8508
    inc $03

L8508:
    inc $26
    lda $26
    cmp #$19
    bcc L84E3

L8510:
    lda #$00
    sta $1C

L8514:
    ldx $26
    lda $1C
    rts

L8519:
    jsr $8643
    bcs L8528
    jsr $8578
    jsr $85B1
    jsr $83A5
    clc

L8528:
    rts
    jsr $8519
    bcs L8528
    bcc L8549

L8530:
    bit $5C
    bpl L8572
    lda $58
    clc
    adc $23
    tax
    lda $59
    adc #$00
    tay
    bcc L854E
    jsr $8643
    bcs L8572
    jsr $8578

L8549:
    jsr $860E
    bcs L8572

L854E:
    lda $5A
    sec
    adc $6C
    lda $5B
    adc $6D
    cmp #$3C
    bcs L8573
    stx $02
    sty $03
    txa
    pha
    tya
    pha
    jsr $85E1
    pla
    sta $09
    pla
    sta $08
    jsr $858E
    jsr $83A5

L8572:
    rts

L8573:
    lda #$05
    jmp $9747

L8578:
    ldx $5D
    ldy $5E
    stx $02
    sty $03
    ldx #$00
    ldy #$3F
    stx $08
    sty $09
    ldx $6D
    inx
    jmp $81EA

L858E:
    ldy #$00
    sty $02
    lda #$3F
    sta $03
    ldx $6C
    lda $6D
    sta $1C

L859C:
    lda ($02),y
    sta ($08),y
    iny
    bne L85A7
    inc $03
    inc $09

L85A7:
    dex
    cpx #$FF
    bne L859C
    dec $1C
    bpl L859C
    rts

L85B1:
    ldx $5F
    ldy $60
    inx
    bne L85B9
    iny

L85B9:
    stx $02
    sty $03
    ldx $5D
    ldy $5E
    stx $08
    sty $09
    lda $5A
    sec
    sbc $5F
    lda $5B
    sbc $60
    tax
    inx
    jsr $81EA
    lda $5A
    clc
    sbc $6C
    sta $5A
    lda $5B
    sbc $6D
    sta $5B
    rts

L85E1:
    lda $5A
    cmp $02
    lda $5B
    sbc $03
    tax
    inx
    clc
    adc $03
    sta $03
    lda $02
    sec
    adc $6C
    sta $08
    lda $03
    adc $6D
    sta $09
    jsr $81D8
    lda $5A
    sec
    adc $6C
    sta $5A
    lda $5B
    adc $6D
    sta $5B
    rts

L860E:
    lda #$07
    jsr $9747

L8613:
    jsr $9474
    cmp #$A0
    bcc L8613
    cmp #$B3
    beq L863E
    cmp #$AD
    beq L862A
    bcs L8613
    jsr $8064
    jmp $8613

L862A:
    lda $58
    clc
    adc $23
    pha
    lda $59
    adc #$00
    pha
    jsr $973E
    pla
    tay
    pla
    tax
    clc
    rts

L863E:
    jsr $973E
    sec

L8642:
    rts

L8643:
    ldy $23
    lda ($58),y
    sec
    beq L8642
    lda #$06
    jsr $9747
    jsr $8382
    lda $56
    pha
    lda $57
    pha
    lda $22
    pha
    lda $58
    clc
    adc $23
    sta $5D
    sta $5F
    lda $59
    adc #$00
    sta $5E
    sta $60

L866C:
    jsr $86EF

L866F:
    jsr $9474
    cmp #$A0
    bcc L866F
    cmp #$B3
    beq L86A0
    cmp #$AD
    clc
    beq L86A0
    cmp #$AD
    bcs L866F
    jsr $8064
    lda $58
    clc
    adc $23
    sta $5F
    rol $1C
    cmp $5D
    ror $1C
    lda $59
    adc #$00
    sta $60
    rol $1C
    sbc $5E
    bcs L866C
    sec

L86A0:
    rol $1C
    ldy #$00
    lda ($5F),y
    bne L86B0
    lda $5F
    bne L86AE
    dec $60

L86AE:
    dec $5F

L86B0:
    pla
    sta $22
    pla
    sta $57
    sta $03
    pla
    sta $56
    sta $02
    lda $5D
    sta $58
    lda $5E
    sta $59
    lda #$00
    sta $23
    ror $1C
    php
    bcs L86DF
    lda #$80
    sta $5C
    lda $5F
    sec
    sbc $5D
    sta $6C
    lda $60
    sbc $5E
    sta $6D

L86DF:
    ldx #$03
    jsr $8482
    jsr $9142
    jsr $973E
    jsr $83A5
    plp
    rts

L86EF:
    ldx #$5F
    jsr $8734
    inx
    bne L86F8
    iny

L86F8:
    stx $08
    sty $09
    ldx #$5D
    jsr $8734
    stx $1C
    sty $1D
    lda #$D8
    sta $03
    lda #$00
    sta $02
    ldy #$78

L870F:
    ldx $1701
    cpy $1C
    lda $03
    sbc $1D
    bcc L8725
    cpy $08
    lda $03
    sbc $09
    bcs L8725
    ldx $1703

L8725:
    txa
    sta ($02),y
    iny
    bne L870F
    inc $03
    lda $03
    cmp #$DC
    bcc L870F
    rts

L8734:
    jsr $84D7
    pha
    ldy #$28
    jsr $96FB
    stx $1C
    pla
    clc
    adc $1C
    tax
    tya
    adc #$D8
    tay
    rts
    ldx #$01
    ldy #$19
    stx $5D
    sty $5E
    ldx $5A
    ldy $5B
    stx $5F
    sty $60
    ldx #$D9
    ldy #$87
    stx $04
    sty $05
    jsr $9598
    bcs L87D6
    beq L8770
    jsr $9660
    jsr $8643
    bcs L87D6

L8770:
    lda #$03
    jsr $957C
    bcs L87D6
    ldy #$01
    jsr $9297
    bcs L87CE
    lda #$54
    jsr $FFD2
    ldy $5D
    lda #$00
    sta $5D

L8789:
    lda ($5D),y
    jsr $FFD2
    lda $90
    bne L87CE
    cpy $5F
    bne L879C
    lda $5E
    cmp $60
    beq L87A3

L879C:
    iny
    bne L8789
    inc $5E
    bne L8789

L87A3:
    lda #$00
    jsr $FFD2
    lda #$4C
    jsr $FFD2
    lda $1700
    jsr $FFD2
    ldy #$00

L87B5:
    lda $1800,y
    jsr $FFD2
    iny
    cpy $1700
    bcc L87B5
    ldy #$00

L87C3:
    lda $1701,y
    jsr $FFD2
    iny
    cpy #$0C
    bcc L87C3

L87CE:
    jsr $92B2
    lda #$00
    jsr $9258

L87D6:
    jmp $9660
    asl
    ora ($02,x)
    brk
    asl $0E
    lda #$00
    jsr $915D
    bcs L882C
    ldy #$02
    jsr $9297
    jsr $FFCF
    ldx #$00
    cmp #$54
    beq L880D
    jsr $FFCC
    ldx #$41
    ldy #$88
    stx $04
    sty $05
    jsr $9598
    bcs L8824
    pha
    ldx #$08
    jsr $FFC6
    pla
    tax
    inx

L880D:
    stx $24
    jsr $8849
    bcs L8825
    bit $1F
    bpl L8824
    lda $24
    bne L8824
    jsr $8956
    bcs L8824
    jsr $897A

L8824:
    clc

L8825:
    php
    jsr $92B2
    plp
    bcs L8831

L882C:
    lda #$00
    jsr $9258

L8831:
    ldx $56
    ldy $57
    stx $02
    sty $03
    ldx #$03
    jsr $8482
    jmp $83A5
    !by $1D, $01, $04, $00, $07, $12, $22, $28    ; 8845 oddělení pro například viza věta 1D

L8849:
    bit $1F
    bpl L8853
    ldx #$01
    ldy #$19
    bne L8857

L8853:
    ldx $5A
    ldy $5B

L8857:
    stx $5F
    sty $60
    lda #$00
    sta $5C
    ldx #$00
    ldy #$3F
    stx $02
    sty $03

L8867:
    jsr $FFCF
    jsr $88E3
    bcs L8894
    tax
    beq L8899
    ldy #$00
    sta ($02),y
    inc $02
    bne L887C
    inc $03

L887C:
    ldx $5F
    ldy $60
    inx
    bne L8890
    iny
    cpy #$3C
    bcc L8890
    lda #$05
    jsr $9747
    sec
    bcs L8899

L8890:
    stx $5F
    sty $60

L8894:
    lda $90
    beq L8867
    clc

L8899:
    php
    bit $1F
    bpl L88B3
    jsr $90C2
    stx $56
    sty $57
    stx $58
    sty $59
    lda #$00
    sta $23
    lda #$03
    sta $22
    bne L88BE

L88B3:
    lda $58
    clc
    adc $23
    tax
    lda $59
    adc #$00
    tay

L88BE:
    lda $5F
    clc
    sbc $5A
    sta $6C
    lda $60
    sbc $5B
    sta $6D
    bcc L88E1
    stx $02
    sty $03
    txa
    pha
    tya
    pha
    jsr $85E1
    pla
    sta $09
    pla
    sta $08
    jsr $858E

L88E1:
    plp
    rts

L88E3:
    ldx $24
    beq L8920
    cpx #$04
    bne L88FB
    ldy #$22

L88ED:
    dey
    bmi L88FA
    cmp viza_in_table_8932,y
    bne L88ED
    lda viza_out_table_8944,y
    bcs L8920

L88FA:
    dex

L88FB:
    dex
    beq L8913
    dex
    tay
    and #$1F
    pha
    tya
    lsr
    lsr
    lsr
    lsr
    lsr
    pha
    txa
    lsr
    pla
    rol
    tay
    pla
    ora $8922,y

L8913:
    cmp #$80
    bcs L8921
    cmp #$20
    bcs L8920
    cmp #$0D
    sec
    bne L8921

L8920:
    clc

L8921:
    rts
 
; -------------------------------------------------------------
; Data table used by L88FB: ORA $8922,Y
; CPU $8922..$8931  (file $0922..$0931)
; -------------------------------------------------------------
tbl_8922:
    !by $00,$60,$20,$20,$60,$40,$00,$00
    !by $00,$00,$00,$00,$40,$00,$00,$00


    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF

    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF



; CPU $8957..$8958 (file $0957..$0958) – data bytes before code resumes
    !by $20,$CF,$FF

; CPU $8959 continues with real code (AA = TAX)
 
    tax
    beq $8956
    cmp #$4C
    sec
    bne L8979
    jsr $FFCF
    sta $1700
    ldy #$00

L8969:
    jsr $FFCF
    sta $1800,y
    iny
    cpy $1700
    bcc L8969
    jsr $907B
    clc

L8979:
    rts

L897A:
    ldy #$00

L897C:
    jsr $FFCF
    sta $1701,y
    iny
    lda $90
    beq L897C
    jmp $9142
    lda #$02
    jsr $957C
    bcs L8994
    jsr $9258

L8994:
    jmp $9660
    ldy #$00
    jsr $8A08
    bcs L89B8
    lda #$00

L89A0:
    jsr $8A6F
    bcs L89B8
    lda #$0E
    jsr $9747

L89AA:
    jsr $9474
    beq L89AA
    cmp #$AD
    bne L89B8
    lda $0355
    bcs L89A0

L89B8:
    jsr $9660
    jmp $973E
    ldy #$00
    jsr $8A08
    bcs L89B8
    ldy #$21
    jsr $8A08
    bcs L89B8
    lda #$00
    sta $1F

L89D0:
    jsr $8A6F
    bcs L89B8
    lda #$0F
    jsr $9747

L89DA:
    jsr $9474
    cmp #$B3
    beq L89B8
    bit $1F
    bmi L89FB
    tax
    beq L89DA
    lda $0355
    cpx #$20
    beq L89D0
    cpx #$AD
    beq L89FB
    cpx #$AC
    bne L89B8
    lda #$80
    sta $1F

L89FB:
    jsr $8AD2
    lda $0376
    bcc L89D0
    lda #$05
    jmp $9747

L8A08:
    sty $85
    jsr $8A64
    ldy $85
    lda $0355,y
    beq L8A40
    tax
    dex
    clc
    adc $85
    tay

L8A1A:
    lda $0355,y
    sta $0430,x
    dey
    dex
    bpl L8A1A
    lda #$08
    ldy #$01
    jsr $9664

L8A2B:
    jsr $9474
    beq L8A2B
    cmp #$AD
    beq L8A62
    sei
    ldx $C6
    sta $0277,x
    inc $C6
    cli
    jsr $8A64

L8A40:
    jsr $94DB
    bcs L8A63
    sec
    tax
    ora $85
    beq L8A63
    ldy $85
    txa
    sta $0355,y
    beq L8A62
    clc
    adc $85
    tay
    dex

L8A58:
    lda $0430,x
    sta $0355,y
    dey
    dex
    bpl L8A58

L8A62:
    clc

L8A63:
    rts

L8A64:
    lda #$0C
    ldy $85
    beq L8A6C
    lda #$0D

L8A6C:
    jmp $9747

L8A6F:
    sei
    clc
    adc $23
    adc $58
    sta $02
    lda $59
    adc #$00
    sta $03

L8A7D:
    lda $02
    clc
    adc $0355
    rol $1C
    clc
    sbc $5A
    lda $03
    ror $1C
    adc #$00
    rol $1C
    sbc $5B
    bcs L8AC7
    ldy #$00

L8A96:
    lda ($02),y
    bit $54
    bpl L8A9F
    jsr $944B

L8A9F:
    sta $1C
    lda $0356,y
    cmp #$09
    beq L8AB3
    bit $54
    bpl L8AAF
    jsr $944B

L8AAF:
    cmp $1C
    bne L8AC9

L8AB3:
    iny
    cpy $0355
    bcc L8A96
    ldx $02
    ldy $03
    stx $58
    sty $59
    lda #$0A
    jsr $8354
    clc

L8AC7:
    cli
    rts

L8AC9:
    inc $02
    bne L8ACF
    inc $03

L8ACF:
    jmp $8A7D

L8AD2:
    lda $6C
    pha
    lda $6D
    pha
    lda $58
    clc
    adc $23
    tax
    lda #$00
    sta $6D
    adc $59
    tay
    lda $0376
    sec
    sbc $0355
    beq L8B29
    bcc L8B0D
    sta $6C
    dec $6C
    clc
    adc $5A
    lda $5B
    adc #$00
    cmp #$3C
    bcs L8B3F
    stx $02
    sty $03
    txa
    pha
    tya
    pha
    jsr $85E1
    jmp $8B25

L8B0D:
    eor #$FF
    sta $6C
    stx $5D
    txa
    pha
    clc
    adc $6C
    sta $5F
    sty $5E
    tya
    pha
    adc #$00
    sta $60
    jsr $85B1

L8B25:
    pla
    tay
    pla
    tax

L8B29:
    stx $02
    sty $03
    ldy $0376
    beq L8B3B
    dey

L8B33:
    lda $0377,y
    sta ($02),y
    dey
    bpl L8B33

L8B3B:
    jsr $83A5
    clc

L8B3F:
    pla
    sta $6D
    pla
    sta $6C
    rts
    lda #$09
    jsr $9747

L8B4B:
    jsr $9474
    cmp #$B3
    beq L8B80
    cmp #$AA
    bne L8B5F
    inc $1702
    ldx $1702
    stx $D021

L8B5F:
    cmp #$B1
    bne L8B66
    inc $D020

L8B66:
    cmp #$A8
    bne L8B73
    inc $1701
    jsr $9142
    jmp $8B4B

L8B73:
    cmp #$A6
    bne L8B4B
    inc $1703
    jsr $9136
    jmp $8B4B

L8B80:
    jmp $973E
    lda #$08
    jsr $9747
    lda #$00
    clc
    sbc $5A
    sta $1A
    lda #$3C
    sbc $5B
    sta $1B
    ldx #$01
    ldy #$0F
    jmp $9682
    lda #$1E
    jmp $9747

L8BA1:
    lda $3F
    asl
    asl
    ora $3F
    and #$24
    cmp #$04
    bne L8BE3
    lda #$FF
    sta $3F
    jsr $8E0A
    jsr $8EAA

L8BB7:
    jsr $FFE4
    cmp #$B3
    beq L8BDD
    bit $36
    bpl L8BC5
    jsr $8DB3

L8BC5:
    lda $3F
    asl
    asl
    ora $3F
    and #$24
    cmp #$04
    bne L8BB7
    lda #$FF
    sta $3F
    jsr $8DB3
    jsr $8BE4
    bcc L8BB7

L8BDD:
    jsr $90D3
    jsr $9660

L8BE3:
    rts

L8BE4:
    jsr $8C09
    bcs L8C08
    beq L8C08
    cmp #$9F
    beq L8BF7
    bcs L8BFC
    jsr $8C6C
    clc
    bcc L8C08

L8BF7:
    jsr $8CC9
    sec
    rts

L8BFC:
    pha
    jsr $90D3
    jsr $9660
    pla
    jsr $8057
    sec

L8C08:
    rts

L8C09:
    lda $0B
    sec
    sbc #$50
    bcc L8C38
    cmp #$A0
    bcs L8C38
    lsr
    lsr
    lsr
    lsr
    sta $1C
    lda $0D
    sec
    sbc #$48
    bcc L8C38
    cmp #$50
    bcs L8C38
    and #$F0
    lsr
    lsr
    sta $1D
    lsr
    lsr
    adc $1D
    asl
    adc $1C
    tax
    lda $8C3A,x
    clc
    rts

L8C38:
    sec
    rts
    brk
    brk
    brk
    brk
    brk
    brk
    brk
    ora ($02,x)
    !by $9F    ; 8C43
    brk
    brk
    brk
    brk
    brk
    brk
    brk
    !by $03,$04,$9F    ; 8C4B
    brk
    brk
    brk
    brk
    brk
    brk
    brk
    ora $06
    !by $9F    ; 8C57
    ora ($09),y
    php
    !by $0F    ; 8C5B
    asl
    bpl $8C6C
    asl $0C0B
    !by $B2,$BB    ; 8C62
    ldy $BFBE,x
    lda $B6,x
    tsx
    clv
    lda $08C9,y
    bcc L8C90
    pha
    txa
    sec
    sbc #$1E
    jsr $8E8E
    pla
    sec
    sbc #$08
    ldx #$00
    cmp #$08
    bcc L8C85
    and #$07
    inx

L8C85:
    tay
    lda $8CC1,y
    eor $81,x
    sta $81,x
    clc
    bcc L8CBD

L8C90:
    tay
    dey
    bne L8C97
    sec
    bcs L8C9B

L8C97:
    dey
    bne L8CA1
    clc

L8C9B:
    jsr $0DC6
    clc
    bcc L8CBD

L8CA1:
    ldx #$00
    dey
    beq L8CB7
    dey
    beq L8CAD
    inx
    dey
    beq L8CB7

L8CAD:
    lda $77,x
    cmp #$08
    bcs L8CC0
    inc $77,x
    bcc L8CBD

L8CB7:
    lda $77,x
    beq L8CC0
    dec $77,x

L8CBD:
    jsr $8EAA

L8CC0:
    rts
    !by $80    ; 8CC1
    rti
    jsr $0810
    !by $04,$02    ; 8CC6
    ora ($A4,x)
    !by $23    ; 8CCA
    beq L8CD9
    lda #$20

L8CCF:
    cmp ($58),y
    beq L8CD6
    dey
    bpl L8CCF

L8CD6:
    iny
    sty $23

L8CD9:
    ldy #$00
    bit $82
    bvc L8D2C
    sty $23
    ldy $59
    ldx $58
    bne L8CE8
    dey

L8CE8:
    dex
    stx $02
    sty $03
    ldy #$00
    lda ($02),y
    cmp #$0D
    beq L8CFF
    cmp #$02
    bcc L8CFF
    lda #$0D
    sta $3F00
    iny

L8CFF:
    ldx #$02

L8D01:
    lda $8DA8,x
    sta $3F00,y
    iny
    dex
    bpl L8D01
    tya
    pha
    lda $7F
    sta $1A
    lda #$00
    sta $1B
    jsr $96A1
    pla
    tay

L8D1A:
    lda $0201,x
    sta $3F00,y
    iny
    inx
    cpx #$05
    bcc L8D1A
    lda #$0D
    sta $3F00,y
    iny

L8D2C:
    bit $82
    bpl L8D36
    lda #$11
    sta $3F00,y
    iny

L8D36:
    lda $81
    sta $1C
    ldx #$07

L8D3C:
    lsr $1C
    bcc L8D67
    lda $8DAB,x
    sta $3F00,y
    iny
    cmp #$18
    bne L8D57
    lda $77
    cmp #$02
    beq L8D67
    ora #$30
    sta $3F00,y
    iny

L8D57:
    cmp #$19
    bne L8D67
    lda $78
    cmp #$02
    beq L8D67
    ora #$30
    sta $3F00,y
    iny

L8D67:
    dex
    bpl L8D3C
    dey
    bmi L8DA7
    sty $6C
    lda #$00
    sta $6D
    lda #$80
    sta $5C
    jsr $8530
    lda $82
    and #$80
    ora $81
    beq L8DA7
    lda #$06
    jsr $9747
    jsr $90D3
    jsr $9660
    jsr $8613
    bcs L8DA7
    ldy $23
    lda #$20

L8D96:
    cmp ($58),y
    beq L8DA0
    iny
    cpy $66
    bcc L8D96
    dey

L8DA0:
    sty $23
    lda #$1A
    jsr $8130

L8DA7:
    rts
    and $027A,x
    !by $03,$04    ; 8DAB
    ora $0B
    !by $0C    ; 8DAF
    clc
    ora $780E,y
    lda #$EF
    cmp $19
    bcs L8DBC
    sta $19

L8DBC:
    lda #$28
    cmp $19
    bcc L8DC4
    sta $19

L8DC4:
    lda $18
    bne L8DD2
    lda #$0E
    cmp $17
    bcc L8DDE
    sta $17
    bcs L8DDE

L8DD2:
    lda #$01
    sta $18
    lda #$4D
    cmp $17
    bcs L8DDE
    sta $17

L8DDE:
    lda $19
    sta $D003
    lda $17
    sta $D002
    lda $18
    asl
    sta $D010
    lda $19
    sec
    sbc #$28
    sta $0D
    lda $17
    sec
    sbc #$0E
    sta $0B
    lda $18
    sbc #$00
    sta $0C
    lda $36
    and #$7F
    sta $36
    cli
    rts

L8E0A:
    jsr $8ECC
    ldx #$1A
    ldy #$A0
    stx $02
    sty $03
    ldx #$90
    ldy #$6B
    stx $08
    sty $09
    ldx #$0A
    ldy #$14
    clc
    jsr $8F12
    lda #$00
    sta $02
    lda #$5C
    sta $03
    ldx #$02
    ldy #$27
    lda $1702
    and #$0F
    sta $1C
    lda $1703
    asl
    asl
    asl
    asl
    ora $1C
    jsr $8F50
    ldx #$15
    ldy #$27
    lda $1702
    and #$0F
    sta $1C
    lda $1701
    asl
    asl
    asl
    asl
    ora $1C
    jsr $8F50
    lda #$72
    sta $02
    lda #$5D
    sta $03
    ldx #$09
    ldy #$13
    lda $1704
    jsr $8F50
    lda #$03
    jsr $0DCC
    ldx #$00
    stx $5C
    stx $81
    stx $82
    inx
    stx $7F
    inx
    stx $77
    stx $78
    jsr $9042
    sei
    lda $36
    ora #$80
    sta $36
    cli
    rts

L8E8E:
    asl
    asl
    asl
    asl
    tay
    ldx #$10

L8E95:
    lda $7310,y
    eor #$FF
    sta $7310,y
    lda $7450,y
    eor #$FF
    sta $7450,y
    iny
    dex
    bne L8E95
    rts

L8EAA:
    ldx #$1A
    ldy #$A0
    stx $02
    sty $03
    ldx #$90
    ldy #$6B
    stx $08
    sty $09
    ldx #$06
    ldy #$14
    clc
    jsr $8F12
    lda $66
    pha
    jsr $0DD7
    pla
    sta $66
    rts

L8ECC:
    ldx #$00
    ldy #$04
    stx $02
    sty $03
    ldy #$60
    stx $06
    sty $07

L8EDA:
    lda #$01
    sta $09
    ldy #$00
    lda ($02),y
    asl
    rol $09
    asl
    rol $09
    asl
    rol $09
    sta $08
    ldy #$07

L8EEF:
    lda ($08),y
    sta ($06),y
    dey
    bpl L8EEF
    lda $06
    clc
    adc #$08
    sta $06
    bcc L8F01
    inc $07

L8F01:
    inc $02
    bne L8F07
    inc $03

L8F07:
    lda $02
    cmp #$E8
    lda $03
    sbc #$07
    bcc L8EDA
    rts

L8F12:
    stx $27
    sty $26

L8F16:
    lda $09
    pha
    lda $08
    pha
    ldx $26

L8F1E:
    ldy #$07

L8F20:
    lda ($02),y
    sta ($08),y
    dey
    bpl L8F20
    lda $02
    clc
    adc #$08
    sta $02
    bcc L8F32
    inc $03

L8F32:
    lda $08
    clc
    adc #$08
    sta $08
    bcc L8F3D
    inc $09

L8F3D:
    dex
    bne L8F1E
    pla
    clc
    adc #$40
    sta $08
    pla
    adc #$01
    sta $09
    dec $27
    bne L8F16
    rts

L8F50:
    sty $1C

L8F52:
    ldy $1C

L8F54:
    sta ($02),y
    dey
    bpl L8F54
    pha
    lda $02
    clc
    adc #$28
    sta $02
    bcc L8F65
    inc $03

L8F65:
    pla
    dex
    bpl L8F52
    rts

L8F6A:
    lda #$00
    tay

L8F6D:
    sta $0002,y
    sta $0200,y
    sta $0300,y
    iny
    bne L8F6D
    ldy #$1F

L8F7B:
    lda $FD30,y
    sta $0314,y
    dey
    bpl L8F7B
    lda #$04
    sta $0288
    jsr $FF5B

    ; --- Confirmed VIC border/sprite init ---
    lda #$0B
    sta $D020
    lda #$00
    sta $D01C
    sta $D01D
    sta $D017
    jsr $9070
    ldx #$01
    ldy #$19
    stx $58
    sty $59
    stx $0342
    sty $0343
    ldx #$BB
    ldy #$0E
    stx $FFFA
    sty $FFFB
    stx $0318
    sty $0319
    ldx #$45
    ldy #$0E
    stx $FFFE
    sty $FFFF
    ldx #$4A
    ldy #$0E
    stx $0314
    sty $0315
    lda #$1C
    sta $DC04
    sta $DC05
    ldx #$10
    ldy #$7F

L8FDD:
    lda $0900,y
    cmp $B100,y
    bne L8FE9
    dey
    bpl L8FDD
    dex

L8FE9:
    tya
    pha
    lda #$B0
    sta $03
    lda #$08
    sta $05
    ldy #$00
    sty $02
    sty $04

L8FF9:
    lda ($02),y
    sta ($04),y
    iny
    bne L8FF9
    inc $03
    inc $05
    dex
    bne L8FF9
    cli
    pla
    bpl L9033
    ldy #$01
    lda #$19
    sta $5B
    lda #$00
    sta $1900
    sta $5A

L9018:
    lda ($5A),y
    beq L9029
    iny
    bne L9018
    inc $5B
    lda $5B
    cmp #$3C
    bcc L9018
    bcs L9036

L9029:
    sty $5A
    lda #$00
    sta $1900
    jmp $907B

L9033:
    jsr $0DBA

L9036:
    jmp $90C2

L9039:
    jsr $90B9
    ldx #$03
    jsr $964F
    rts

L9042:
    bit $D011
    bpl L9042
    lda #$BB
    sta $D011
    lda #$78
    sta $D018
    lda $DD00
    and #$FC
    ora #$02
    sta $DD00
    ldx #$00
    stx $D01B
    stx $54
    sei
    lda $36
    ora #$01
    sta $36
    cli
    ldx #$FE
    stx $5FF9
    rts

L9070:
    lda #$00
    ldy #$3F

L9074:
    sta $7F40,y
    dey
    bpl L9074
    rts

L907B:
    ldy #$00

L907D:
    cpy $1700
    bcs L90AC
    lda $1800,y
    and #$1F
    clc
    adc #$05
    sta $1C
    lda $1803,y
    cmp $1801,y
    bcc L90AC
    cmp #$A1
    bcs L90AC
    lda $1804,y
    cmp $1802,y
    bcc L90AC
    cmp #$C9
    bcs L90AC
    tya
    adc $1C
    tay
    bcc L907D
    ldy #$00

L90AC:
    sty $1700
    rts

L90B0:
    lda #$00
    sta $5C
    lda #$0A
    jsr $8354

L90B9:
    jsr $9122
    jsr $9142
    jmp $90D3

L90C2:
    ldx #$01
    ldy #$19
    stx $5A
    sty $5B
    lda #$00
    sta $1900
    sta $1901
    rts

L90D3:
    bit $D011
    bpl L90D3
    lda #$9B
    sta $D011
    lda #$12
    sta $D018
    lda $DD00
    ora #$03
    sta $DD00
    lda #$00
    ldx #$3E

L90EE:
    sta $03C0,x
    dex
    bpl L90EE
    lda #$FF
    sta $03EB
    sta $03EE
    lda #$02
    sta $D01B
    lda #$0F
    sta $07F9
    lda #$02
    sta $D015
    lda #$00
    jsr $9437
    sei
    lda #$80
    sta $19
    sta $17
    asl
    sta $18
    lda $36
    and #$FE
    sta $36
    cli
    rts

L9122:
    ldx #$00
    lda #$00
    jsr $974D
    jsr $973E
    ldy #$27
    lda #$1E

L9130:
    sta $0450,y
    dey
    bpl L9130

L9136:
    lda $1703
    ldy #$77

L913B:
    sta $D800,y
    dey
    bpl L913B
    rts

L9142:
    lda $1701
    ldy #$DC

L9147:
    sta $D877,y
    sta $D953,y
    sta $DA2F,y
    sta $DB0B,y
    dey
    bne L9147
    lda $1702
    sta $D021
    rts

L915D:
    sta $1F
    lda #$01
    jsr $9747
    ldx #$0B
    ldy #$92
    lda #$02
    jsr $FFBD
    ldy #$00
    jsr $9297
    bcs L91D7
    lda #$04
    sta $26

L9178:
    jsr $FFCF
    dec $26
    bne L9178
    lda $90
    sec
    bne L91D7
    jsr $FFCC

L9187:
    jsr $9213
    bcs L91D7
    sta $1C
    lda #$03
    sta $27

L9192:
    ldy $27
    lda #$0C
    jsr $9664

L9199:
    jsr $9474
    ldx $27
    cmp #$A0
    bne L91AA
    cpx $26
    bcs L9199
    inc $27
    bcc L9192

L91AA:
    cmp #$A1
    bne L91B6
    cpx #$04
    bcc L9199
    dec $27
    bcs L9192

L91B6:
    cmp #$AD
    bne L91D9
    ldy #$28
    jsr $96FB
    txa
    clc
    adc #$0C
    sta $02
    tya
    adc #$04
    sta $03
    ldy #$00
    lda #$22

L91CE:
    cmp ($02),y
    beq L91E7
    iny
    cpy #$14
    bcc L91CE

L91D7:
    bcs L9205

L91D9:
    cmp #$B3
    beq L9205
    cmp #$20
    bne L9199
    lda $1C
    bne L9187
    beq L9205

L91E7:
    tya
    ldx $02
    ldy $03
    jsr $FFBD
    clc
    bit $1F
    bmi L9205
    ldx #$0D
    ldy #$92
    stx $04
    sty $05
    jsr $9598
    bne L9205
    lda #$80
    sta $1F

L9205:
    php
    jsr $92B2
    plp
    rts
    bit $30
    !by $04    ; 920D
    ora ($02,x)
    brk
    asl $0E

L9213:
    ldx #$03
    stx $26
    jsr $964F
    ldx #$08
    jsr $FFC6

L921F:
    jsr $FFCF
    sta $1A
    jsr $FFCF
    sta $1B
    ldx $26
    ldy #$07
    jsr $9682
    lda #$00
    ldx $26
    jsr $94E1
    bcs L9250
    jsr $FFCF
    sta $1C
    jsr $FFCF
    ora $1C
    beq L924F
    lda $26
    cmp #$18
    bcs L924F
    inc $26
    bcc L921F

L924F:
    clc

L9250:
    pha
    php
    jsr $FFCC
    plp
    pla
    rts

L9258:
    ldx #$30
    ldy #$04
    jsr $FFBD
    lda #$0F
    tay
    ldx #$08
    jsr $FFBA
    jsr $FFC0
    bcs L928C
    ldx #$0F
    jsr $FFC6
    bcs L928C
    jsr $973E
    lda #$FF
    sta $55
    lda #$0D
    ldy #$00
    jsr $94DF
    lda $0428
    ora $0429
    cmp #$30
    bne L928C
    clc

L928C:
    php
    jsr $FFCC
    lda #$0F
    jsr $FFC3
    plp
    rts

L9297:
    tya
    and #$01
    pha
    lda #$08
    tax
    jsr $FFBA
    jsr $FFC0
    ldx #$08
    pla
    bcs L92B1
    bne L92AE
    jmp $FFC6

L92AE:
    jsr $FFC9

L92B1:
    rts

L92B2:
    jsr $FFCC
    lda #$08
    jmp $FFC3

L92BA:
    lda $C6
    pha
    lda $028D
    pha
    jsr $EA87
    pla
    tax
    lda $028D
    and #$06
    beq L92D8
    txa
    eor $028D
    and #$06
    beq L92D8
    jsr $941B

L92D8:
    pla
    cmp $C6
    beq L930C
    tax
    lda $028D
    ora $53
    cmp #$04
    bcc L92E9
    lda #$04

L92E9:
    asl
    tay
    lda $930D,y
    sta $F5
    lda $930E,y
    sta $F6
    ldy $CB
    lda ($F5),y
    bit $54
    bpl L9300
    jsr $944B

L9300:
    sta $0277,x
    lda $53
    beq L930C
    lda #$00
    jsr $941B

L930C:
    rts
    !by $17,$93    ; 930D
    cli
    !by $93    ; 9310
    sta $9993,y
    !by $93,$DA,$93    ; 9314

; --- $1317-$141A : 4 blocks x 65 bytes ---
rom0_block_1:
    !by $AF,$AD,$A2,$B1,$A6,$A8,$AA,$A0
    !by $90,$77,$61,$8A,$79,$73,$65,$00
    !by $8F,$72,$64,$3E,$63,$66,$74,$78
    !by $7E,$7A,$67,$82,$62,$68,$75,$76
    !by $84,$69,$6A,$83,$6D,$6B,$6F,$6E
    !by $2B,$70,$6C,$2D,$2E,$7C,$7D,$2C
    !by $00,$2A,$7B,$A4,$00,$3D,$5E,$2F
    !by $21,$5F,$00,$81,$20,$00,$71,$B3
    !by $00

rom0_block_2:
    !by $B0,$AC,$A3,$B2,$A7,$A9,$AB,$A1
    !by $33,$57,$41,$34,$59,$53,$45,$00
    !by $35,$52,$44,$36,$43,$46,$54,$58
    !by $37,$5A,$47,$38,$42,$48,$55,$56
    !by $39,$49,$4A,$30,$4D,$4B,$4F,$4E
    !by $2B,$50,$4C,$80,$3A,$5C,$5D,$3B
    !by $91,$40,$5B,$A5,$00,$3C,$8E,$3F
    !by $31,$8D,$00,$32,$7F,$00,$51,$B3
    !by $00

rom0_block_3:
    !by $00,$00,$00,$C0,$C0,$C0,$C0,$00
    !by $23,$00,$00,$24,$00,$B6,$00,$00
    !by $25,$BF,$BA,$26,$BB,$BE,$C3,$00
    !by $27,$00,$B9,$28,$00,$00,$87,$C2
    !by $29,$00,$00,$00,$BC,$00,$85,$88
    !by $00,$B7,$B5,$00,$8B,$86,$60,$8C
    !by $00,$00,$00,$C1,$00,$36,$BD,$89
    !by $00,$B4,$00,$22,$C1,$00,$B8,$B3
    !by $00

rom0_block_4:
    !by $00,$AE,$00,$00,$00,$00,$00,$00
    !by $00,$19,$00,$00,$00,$0C,$04,$00
    !by $00,$1A,$00,$00,$06,$02,$07,$00
    !by $00,$0F,$00,$00,$03,$0E,$05,$00
    !by $00,$08,$09,$00,$00,$11,$18,$12
    !by $00,$01,$00,$00,$10,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$0B,$00
    !by $00,$0A,$00,$00,$00,$00,$00,$B3
    !by $00

; --- $141B-$2659 ---
    !by $85,$53,$C9,$06,$90,$02,$A9,$04,$0A,$0A,$AA,$A0,$07,$BD,$5C,$94
    !by $99,$50,$04,$E8,$88,$10,$F6,$60,$A9,$FF,$45,$54,$85,$54,$29,$06
    !by $49,$06,$AA,$A0,$05,$BD,$56,$94,$99,$59,$04,$E8,$88,$10,$F6,$60
    !by $C9,$7E,$B0,$06,$C9,$61,$90,$02,$E9,$20,$60,$1D,$53,$50,$41,$43
    !by $1C,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1D,$3D,$43,$1C,$1E,$1E
    !by $1E,$1D,$4C,$52,$54,$43,$1C,$1E,$1E,$A5,$99,$D0,$5E,$78,$A5,$3F
    !by $0A,$0A,$05,$3F,$29,$24,$C9,$04,$D0,$08,$A9,$FF,$85,$3F,$A9,$AD
    !by $D0,$4C,$A5,$3F,$29,$12,$C9,$02,$D0,$08,$A9,$FF,$85,$3F,$A9,$20
    !by $D0,$3C,$78,$A2,$A0,$A5,$19,$30,$07,$A2,$A1,$A9,$00,$38,$E5,$19
    !by $29,$7F,$C9,$08,$90,$09,$A9,$80,$85,$19,$85,$17,$8A,$D0,$1F,$A2
    !by $A2,$A5,$17,$30,$07,$A2,$A3,$A9,$00,$38,$E5,$17,$29,$7F,$C9,$08
    !by $90,$09,$A9,$80,$85,$17,$85,$19,$8A,$D0,$03,$20,$E4,$FF,$58,$60
    !by $A9,$AD,$A0,$08,$A2,$01,$85,$24,$98,$48,$86,$26,$A0,$28,$20,$FB
    !by $96,$86,$02,$98,$09,$04,$85,$03,$68,$85,$1D,$85,$1C,$A4,$26,$20
    !by $64,$96,$A9,$00,$85,$90,$20,$74,$94,$38,$A6,$90,$D0,$72,$A4,$1C
    !by $C5,$24,$F0,$67,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$A6,$99,$D0,$49
    !by $AA,$F0,$E3,$C9,$AE,$D0,$02,$A9,$0D,$C9,$AF,$D0,$0B,$C4,$1D,$F0
    !by $D5,$88,$C6,$1C,$A9,$1F,$D0,$37,$C9,$B3,$F0,$44,$C9,$BD,$D0,$06
    !by $20,$33,$94,$4C,$01,$95,$C9,$B4,$D0,$1B,$A5,$59,$C9,$5C,$B0,$B6
    !by $A6,$23,$8A,$A8,$B1,$58,$F0,$19,$A4,$1C,$C0,$28,$B0,$13,$91,$02
    !by $E8,$E6,$1C,$D0,$ED,$C9,$A0,$B0,$9D,$C0,$28,$B0,$99,$E6,$1C,$91
    !by $02,$A5,$1C,$A4,$26,$20,$64,$96,$4C,$01,$95,$38,$98,$E5,$1D,$18
    !by $60,$20,$47,$97,$A9,$FF,$20,$37,$94,$20,$DB,$94,$48,$08,$A2,$30
    !by $A0,$04,$20,$BD,$FF,$A9,$00,$20,$37,$94,$28,$68,$60,$A0,$00,$84
    !by $26,$B1,$04,$20,$47,$97,$20,$B1,$95,$90,$09,$C9,$A0,$F0,$F7,$C9
    !by $A1,$F0,$F3,$38,$AA,$60,$A0,$02,$B1,$04,$18,$69,$03,$A8,$B1,$04
    !by $85,$27,$C5,$26,$B0,$02,$85,$26,$A0,$01,$B1,$04,$A8,$A5,$26,$20
    !by $64,$96,$20,$74,$94,$F0,$FB,$C9,$A2,$D0,$0B,$A6,$26,$E8,$E4,$27
    !by $B0,$F0,$86,$26,$90,$E2,$C9,$A3,$D0,$09,$A6,$26,$CA,$30,$E3,$86
    !by $26,$10,$D5,$C9,$AD,$D0,$1B,$A0,$02,$B1,$04,$18,$69,$02,$A8,$A5
    !by $26,$D1,$04,$B0,$07,$88,$C0,$03,$B0,$F7,$90,$C6,$98,$38,$E9,$03
    !by $18,$60,$C9,$B3,$F0,$08,$C9,$A0,$F0,$04,$C9,$A1,$D0,$B4,$60,$48
    !by $A0,$01,$B1,$04,$AA,$88,$B1,$04,$20,$4D,$97,$A5,$09,$18,$69,$D4
    !by $85,$09,$AD,$01,$17,$A0,$27,$91,$08,$88,$10,$FB,$68,$18,$69,$04
    !by $A8,$B1,$04,$85,$1C,$88,$B1,$04,$A8,$AD,$03,$17,$91,$08,$C8,$C4
    !by $1C,$90,$F9,$60,$E0,$19,$B0,$0C,$8A,$48,$A9,$00,$20,$16,$97,$68
    !by $AA,$E8,$D0,$F0,$60,$A5,$23,$A4,$22,$0A,$0A,$0A,$08,$18,$69,$10
    !by $8D,$02,$D0,$A9,$00,$2A,$28,$69,$00,$0A,$8D,$10,$D0,$98,$0A,$0A
    !by $0A,$69,$2B,$8D,$03,$D0,$60,$98,$48,$A0,$28,$20,$FB,$96,$86,$02
    !by $98,$09,$04,$85,$03,$20,$A1,$96,$68,$A8,$BD,$01,$02,$91,$02,$C8
    !by $E8,$E0,$05,$90,$F5,$60,$A2,$04,$A9,$00,$A0,$10,$26,$1A,$26,$1B
    !by $2A,$C9,$0A,$90,$02,$E9,$0A,$88,$D0,$F2,$26,$1A,$26,$1B,$09,$30
    !by $9D,$01,$02,$CA,$10,$E2,$E8,$BD,$01,$02,$C9,$30,$D0,$0A,$A9,$1F
    !by $9D,$01,$02,$E8,$E0,$04,$90,$EF,$60,$A2,$00,$86,$1A,$BD,$30,$04
    !by $C9,$20,$F0,$18,$38,$E9,$30,$90,$16,$C9,$0A,$B0,$12,$48,$A5,$1A
    !by $0A,$0A,$65,$1A,$0A,$85,$1A,$68,$65,$1A,$85,$1A,$E8,$D0,$DE,$60
    !by $86,$1C,$84,$1D,$A9,$00,$A0,$08,$0A,$26,$1D,$90,$07,$18,$65,$1C
    !by $90,$02,$E6,$1D,$88,$D0,$F1,$AA,$A4,$1D,$60,$48,$A0,$28,$20,$FB
    !by $96,$86,$08,$98,$09,$04,$85,$09,$68,$F0,$0B,$48,$A8,$88,$B1,$02
    !by $91,$08,$88,$10,$F9,$68,$A8,$A9,$1F,$C0,$28,$B0,$05,$91,$08,$C8
    !by $D0,$F7,$60,$A9,$00,$85,$55,$A2,$01,$4C,$16,$97,$A2,$FF,$86,$55
    !by $A2,$01,$A8,$8A,$48,$98,$30,$08,$A2,$5A,$A0,$A6,$86,$02,$84,$03
    !by $29,$7F,$AA,$A0,$00,$C8,$B1,$02,$C9,$0D,$D0,$F9,$CA,$30,$0C,$98
    !by $38,$65,$02,$85,$02,$90,$EC,$E6,$03,$B0,$E8,$68,$AA,$98,$48,$20
    !by $16,$97,$68,$60,$20,$39,$90,$A9,$00,$8D,$09,$17,$A2,$04,$8A,$48
    !by $0A,$A8,$B9,$6F,$98,$85,$04,$B9,$70,$98,$85,$05,$BD,$05,$17,$A0
    !by $02,$D1,$04,$90,$02,$B1,$04,$20,$1A,$96,$68,$AA,$CA,$10,$DF,$A9
    !by $12,$85,$23,$A2,$04,$8A,$48,$0A,$A8,$B9,$6F,$98,$85,$04,$B9,$70
    !by $98,$85,$05,$20,$3E,$97,$A5,$23,$85,$26,$20,$B1,$95,$A8,$A5,$26
    !by $85,$23,$68,$AA,$90,$18,$C0,$B3,$F0,$6B,$C0,$A1,$D0,$05,$E0,$00
    !by $F0,$D3,$CA,$C0,$A0,$D0,$CE,$E0,$04,$B0,$CA,$E8,$90,$C7,$48,$98
    !by $9D,$05,$17,$20,$1A,$96,$68,$AA,$E0,$03,$90,$B9,$D0,$1E,$AD,$08
    !by $17,$F0,$B2,$A9,$21,$20,$47,$97,$20,$DB,$94,$A2,$03,$B0,$A6,$20
    !by $D4,$96,$A5,$1A,$8D,$08,$17,$A2,$03,$4C,$B0,$97,$AC,$09,$17,$F0
    !by $94,$88,$F0,$1D,$A9,$1F,$20,$47,$97,$20,$DB,$94,$A2,$04,$B0,$85
    !by $20,$D4,$96,$A5,$1A,$38,$F0,$0D,$8D,$09,$17,$A5,$70,$09,$30,$85
    !by $70,$20,$42,$90,$18,$60,$A2,$00,$B5,$02,$48,$E8,$E0,$04,$D0,$F8
    !by $20,$39,$90,$A2,$9C,$A0,$98,$86,$04,$84,$05,$20,$98,$95,$B0,$F3
    !by $48,$20,$42,$90,$68,$4A,$A2,$03,$68,$95,$02,$CA,$10,$FA

    ; -------------------------------------------------------------
    ; Menu row definitions (text + row + tab stops)
    ;
    ; Record format (as observed):
    ;   !by <msgNo>, <rowNo>, <nItems>
    ;   !by <tab0>, <tab1>, ... , <tabN>
    ;
    ; Notes:
    ; - msgNo  = index of sentence/line in the text block (!tx ... $0D)
    ; - rowNo  = target screen row (where the line is rendered)
    ; - nItems = number of selectable items (there will be nItems+1 tab stops)
    ; - last tab stop is usually $28 (=40 columns)
    ; - tab stops drive mouse hit-test + highlight ranges (text length does NOT)
    ;
    ; Examples:
    ;   tabs $00,$08,$11,$18,$21,$28 => columns 0,8,17,24,33,40 (widths 8,9,7,9,7)
    ; -------------------------------------------------------------
    lda #$00
    sta $D015
    rts

pf_menu_rowdef_ptr_table:        ; pointer table (little-endian)
    !word $9879,$9882,$9888,$988F,$9895

; msg $14 on row $08: "Low Medium High Shinwa MPS" (5 items)
pf_rowdef_printer_quality:
    !by $14,$08,$05
    !by $00,$08,$11,$18,$21,$28

; msg $15 on row $0A: "Auto-Linefeed  Linefeed" (2 items)
pf_rowdef_autolf_linefeed:
    !by $15,$0A,$02
    !by $00,$16,$28

; msg $16 on row $0C: "Vlevo  Střed  Vpravo" (3 items)
pf_rowdef_align_left_center_right:
    !by $16,$0C,$03
    !by $00,$10,$17,$28

; msg $20 on row $0E: "Standard  Tabela..." (2 items)
pf_rowdef_standard_tabela:
    !by $20,$0E,$02
    !by $00,$12,$28

; msg $17 on row $10: "Start  Stránka  Skupina" (3 items)
pf_rowdef_start_stranka_skupina:
    !by $17,$10,$03
    !by $00,$09,$18,$28

    ; (following bytes continue original table/logic)
    !by $1C,$01,$02,$00,$0B,$14,$A9,$00,$8D,$15,$D0,$20,$F8,$9A,$B0
    !by $22,$AD,$09,$17,$8D,$44,$03,$AE,$05,$17,$BD,$10,$17,$85,$1F,$E0
    !by $04,$F0,$06,$20,$D9,$98,$4C,$C7,$98,$20,$39,$9A,$B0,$05,$CE,$44
    !by $03,$D0,$E4,$08,$20,$66,$9B,$A9,$02,$8D,$15,$D0,$28,$60,$A5,$70
    !by $29,$EF,$C5,$70,$F0,$17,$85,$70,$A0,$0A,$20,$92,$9B,$AD,$08,$17
    !by $F0,$0B,$A0,$0B,$20,$92,$9B,$AD,$08,$17,$20,$70,$9B,$A9,$00,$85
    !by $25,$A5,$4C,$85,$22,$E6,$25,$38,$20,$C0,$0D,$A5,$23,$F0,$36,$20
    !by $AD,$9B,$A5,$1F,$29,$7F,$85,$1F,$20,$63,$99,$A5,$1F,$29,$20,$F0
    !by $15,$A0,$05,$20,$92,$9B,$20,$CC,$9B,$38,$20,$C0,$0D,$A5,$1F,$09
    !by $80,$85,$1F,$20,$63,$99,$A5,$1F,$29,$0C,$4A,$4A,$69,$01,$A8,$20
    !by $92,$9B,$20,$CC,$9B,$E6,$22,$A5,$4E,$C5,$22,$90,$0E,$20,$E4,$FF
    !by $C9,$B3,$D0,$B1,$20,$41,$98,$90,$AC,$B0,$0C,$A5,$70,$29,$20,$F0
    !by $06,$A9,$0C,$20,$70,$9B,$18,$60,$A9,$00,$85,$1B,$85,$26,$A5,$23
    !by $0A,$0A,$26,$1B,$0A,$26,$1B,$85,$1A,$A9,$50,$20,$DC,$9B,$A5,$1F
    !by $29,$03,$18,$69,$06,$A8,$20,$92,$9B,$24,$1F,$50,$15,$A5,$1A,$0A
    !by $26,$1C,$18,$65,$1A,$85,$1A,$66,$1C,$A5,$1B,$2A,$26,$1C,$65,$1B
    !by $85,$1B,$A5,$1A,$20,$70,$9B,$A5,$1B,$20,$70,$9B,$20,$C3,$0D,$A0
    !by $08,$A2,$00,$3E,$00,$02,$2A,$E8,$E0,$08,$D0,$F7,$2E,$08,$02,$20
    !by $CF,$99,$88,$D0,$EC,$C6,$23,$D0,$E3,$24,$1F,$50,$06,$A9,$00,$18
    !by $20,$CF,$99,$60,$24,$1F,$50,$4C,$30,$17,$24,$26,$10,$52,$85,$0C
    !by $A5,$0F,$25,$0B,$85,$1C,$45,$0B,$48,$25,$0C,$85,$1D,$68,$4C,$13
    !by $9A,$24,$26,$10,$3B,$85,$0C,$2A,$85,$0E,$25,$0B,$85,$1C,$A5,$0C
    !by $25,$0D,$85,$1D,$45,$1C,$48,$25,$1D,$85,$1D,$68,$25,$1C,$85,$1C
    !by $05,$0F,$49,$FF,$25,$0B,$25,$0D,$20,$70,$9B,$A5,$1C,$20,$70,$9B
    !by $A5,$1D,$85,$0F,$20,$70,$9B,$A5,$0E,$85,$0D,$A5,$0C,$85,$0B,$60
    !by $85,$0B,$2A,$85,$0D,$A9,$00,$85,$0F,$A9,$80,$85,$26,$60,$A9,$08
    !by $20,$70,$9B,$A9,$3C,$C5,$51,$B0,$02,$85,$51,$A5,$4C,$85,$22,$A9
    !by $00,$85,$24,$18,$20,$C0,$0D,$A9,$3C,$38,$E5,$51,$F0,$25,$AE,$07
    !by $17,$F0,$20,$E0,$02,$F0,$01,$4A,$0A,$0A,$0A,$26,$1C,$48,$A9,$1B
    !by $20,$70,$9B,$A9,$10,$20,$70,$9B,$A9,$1C,$29,$01,$20,$70,$9B,$68
    !by $20,$70,$9B,$A5,$51,$85,$23,$A9,$00,$85,$26,$85,$27,$20,$C3,$0D
    !by $A0,$08,$A9,$07,$85,$1C,$A6,$24,$3E,$00,$02,$6A,$E8,$C6,$1C,$D0
    !by $F7,$20,$D1,$9A,$88,$D0,$EB,$C6,$23,$D0,$E2,$A9,$0D,$20,$70,$9B
    !by $E6,$22,$C6,$24,$10,$06,$C6,$22,$A9,$07,$85,$24,$A5,$4E,$C5,$22
    !by $90,$0C,$20,$E4,$FF,$C9,$B3,$D0,$8A,$20,$41,$98,$90,$85,$08,$A9
    !by $0F,$20,$70,$9B,$28,$60,$4A,$F0,$1D,$48,$A5,$26,$05,$27,$F0,$10
    !by $A9,$80,$20,$70,$9B,$A5,$26,$D0,$02,$C6,$27,$C6,$26,$38,$B0,$EA
    !by $68,$09,$80,$4C,$70,$9B,$E6,$26,$D0,$02,$E6,$27,$60,$78,$A9,$00
    !by $8D,$01,$DD,$A9,$FF,$8D,$03,$DD,$AD,$00,$DD,$09,$04,$8D,$00,$DD
    !by $AD,$02,$DD,$09,$04,$8D,$02,$DD,$AD,$0D,$DD,$AD,$00,$DD,$29,$FB
    !by $8D,$00,$DD,$09,$04,$8D,$00,$DD,$A2,$FF,$AD,$0D,$DD,$CA,$F0,$0C
    !by $29,$10,$F0,$F6,$58,$A9,$00,$8D,$0F,$17,$18,$60,$58,$A9,$80,$8D
    !by $0F,$17,$20,$CC,$FF,$A0,$00,$AD,$05,$17,$C9,$04,$F0,$03,$AC,$0E
    !by $17,$A9,$04,$AE,$0D,$17,$20,$BA,$FF,$A9,$00,$20,$BD,$FF,$20,$C0
    !by $FF,$B0,$08,$A2,$04,$20,$C9,$FF,$B0,$01,$60,$20,$CC,$FF,$A9,$04
    !by $20,$C3,$FF,$38,$60,$2C,$0F,$17,$10,$03,$4C,$D2,$FF,$48,$8D,$01
    !by $DD,$AD,$00,$DD,$29,$FB,$8D,$00,$DD,$09,$04,$8D,$00,$DD,$AD,$0D
    !by $DD,$29,$10,$F0,$F9,$68,$60,$A2,$00,$BD,$17,$17,$E8,$C9,$FF,$D0
    !by $F8,$88,$D0,$F5,$BD,$17,$17,$C9,$FF,$F0,$06,$20,$70,$9B,$E8,$D0
    !by $F3,$60,$C6,$25,$F0,$1A,$A5,$1F,$29,$0C,$4A,$4A,$69,$01,$A8,$A5
    !by $1F,$29,$20,$F0,$01,$88,$20,$92,$9B,$20,$CC,$9B,$C6,$25,$D0,$F9
    !by $60,$A9,$0D,$20,$70,$9B,$AD,$06,$17,$F0,$05,$A9,$0A,$20,$70,$9B
    !by $60,$38,$E5,$51,$F0,$13,$AE,$07,$17,$F0,$0E,$E0,$02,$F0,$01,$4A
    !by $AA,$A9,$20,$20,$70,$9B,$CA,$D0,$F8,$60


; -------------------------------------------------------------
; VIZA import charset translation tables (mode = 4)
; CPU $8932..$8943 (file $0932..$0943)
; -------------------------------------------------------------
viza_in_table_8932:
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

; CPU $8944..$8956 (file $0944..$0956)
viza_out_table_8944:
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

*=$2000
!pseudopc $A000 {

	!by $04,$A0,$04,$A0,$A2,$08,$BD,$12,$A0,$9D,$40
    !by $03,$CA,$10,$F7,$4C,$40,$03,$A9,$FF,$8D,$80,$DE,$4C,$E2,$FC

	;grafiga pro nabídku volby písma
	
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



; --- $265A-$28F4 : texts terminated by $0D ---
rom0_texts_265a:
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

; --- $3000-$359F : 8-byte rows, commented index (hex) + alnum ---
rom0_gfx_3000:
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

; --- $35A0-$3FFF ---
    !by $A9,$00,$8D,$80,$DE,$4C,$E2,$FC,$20,$DC,$0F,$4C,$72,$99,$20,$DC
    !by $0F,$4C,$00,$80,$20,$E8,$0F,$4C,$10,$80,$20,$FA,$0F,$4C,$E8,$0F
    !by $4C,$EE,$13,$4C,$42,$14,$20,$4D,$13,$4C,$E8,$0F,$48,$20,$DC,$0F
    !by $68,$20,$3F,$AF,$4C,$E8,$0F,$20,$DC,$0F,$20,$4D,$A8,$4C,$E8,$0F
    !by $20,$E8,$0F,$20,$16,$80,$4C,$DC,$0F,$48,$20,$E8,$0F,$68,$20,$19
    !by $80,$48,$20,$DC,$0F,$68,$60,$48,$20,$E8,$0F,$68,$20,$1C,$80,$48
    !by $20,$DC,$0F,$68,$60,$48,$20,$E8,$0F,$68,$20,$1F,$80,$4C,$DC,$0F
    !by $48,$20,$E8,$0F,$68,$20,$22,$80,$4C,$DC,$0F,$20,$E8,$0F,$20,$25
    !by $80,$4C,$DC,$0F,$20,$E8,$0F,$20,$28,$80,$4C,$DC,$0F,$20,$E8,$0F
    !by $20,$2E,$80,$48,$20,$DC,$0F,$68,$60,$E7,$B3,$67,$B6,$07,$BA,$AF
    !by $95,$CE,$9F,$0A,$A1,$48,$8A,$48,$98,$48,$A5,$01,$48,$A9,$37,$85
    !by $01,$A9,$02,$8D,$80,$DE,$AD,$0D,$DC,$A5,$A2,$29,$3F,$D0,$0D,$AD
    !by $28,$D0,$49,$01,$29,$01,$8D,$28,$D0,$8D,$29,$D0,$E6,$A2,$20,$6F
    !by $88,$A5,$39,$05,$3A,$F0,$18,$A6,$39,$A4,$3A,$20,$84,$89,$A9,$04
    !by $24,$29,$F0,$03,$20,$2B,$87,$A5,$36,$09,$A0,$85,$36,$D0,$1E,$A5
    !by $36,$0A,$29,$40,$05,$36,$29,$DF,$85,$36,$A5,$A2,$4A,$90,$0E,$A5
    !by $3F,$29,$07,$D0,$08,$A9,$00,$8D,$80,$DE,$20,$13,$80,$A5,$42,$8D
    !by $80,$DE,$68,$85,$01,$68,$A8,$68,$AA,$68,$40,$48,$AD,$8D,$02,$4A
    !by $90,$1F,$D0,$1A,$58,$20,$E8,$0F,$20,$E7,$FF,$AD,$11,$D0,$29,$20
    !by $D0,$03,$20,$2B,$80,$20,$DC,$0F,$20,$F9,$83,$4C,$AE,$0D,$4C,$8E
    !by $14,$A9,$00,$85,$36,$68,$40,$A5,$4A,$10,$01,$60,$29,$BF,$85,$4A
    !by $A5,$29,$4A,$4A,$4A,$A9,$80,$90,$0C,$A5,$29,$29,$FB,$85,$29,$A9
    !by $00,$85,$34,$A9,$00,$85,$1F,$A6,$2A,$E0,$4D,$90,$04,$A2,$4D,$86
    !by $2A,$A4,$2B,$C0,$28,$90,$04,$A0,$28,$84,$2B,$20,$D3,$82,$A2,$00
    !by $A0,$60,$86,$04,$84,$05,$A0,$3F,$86,$06,$84,$07,$A2,$00,$24,$4A
    !by $10,$03,$A6,$35,$E8,$BD,$D2,$94,$8D,$5E,$0F,$A5,$29,$29,$08,$0A
    !by $0A,$0A,$0A,$85,$24,$A9,$17,$24,$1F,$50,$02,$A9,$19,$85,$27,$20
    !by $D0,$0F,$A0,$00,$A2,$08,$38,$24,$1F,$30,$13,$88,$B1,$02,$11,$06
    !by $CA,$D0,$04,$45,$24,$A2,$08,$91,$04,$98,$D0,$EF,$F0,$3C,$24,$43
    !by $30,$11,$88,$B1,$04,$CA,$D0,$04,$45,$24,$A2,$08,$91,$02,$98,$D0
    !by $F1,$F0,$27,$A9,$35,$85,$01,$88,$B1,$02,$48,$A5,$43,$85,$42,$8D
    !by $80,$DE,$B1,$04,$CA,$D0,$04,$45,$24,$A2,$08,$91,$02,$A9,$0C,$85
    !by $42,$8D,$80,$DE,$68,$91,$02,$98,$D0,$DD,$90,$0B,$E6,$03,$E6,$05
    !by $E6,$07,$A0,$40,$18,$90,$A0,$20,$DC,$0F,$20,$CF,$82,$C6,$05,$A2
    !by $04,$20,$31,$83,$C6,$07,$A2,$06,$20,$31,$83,$C6,$27,$D0,$80,$60
    ; -------------------------------------------------------------
    ; $DE80 banking helpers (Pagefox module ROM/RAM bank switching)
    ; CPU $B7D0.. (file $37D0..)
    ; -------------------------------------------------------------
rom0cs_SetBankFromZP43_andPort01FromZP45:
    lda $43
    sta $42
    sta $de80
    lda $45
    sta $01
    rts

rom0cs_SelectROMBank02_Port01_37:
    lda #$37
    sta $01
    lda #$02
    sta $42
    sta $de80
    rts

rom0cs_SelectROMBank00_Port01_37:
    lda #$37
    sta $01
    lda #$00
    sta $42
    sta $de80
    rts

rom0cs_Call0FFA_Jmp0FDC:
    jsr $0ffa
    jmp $0fdc

    !by $A9,$88,$85,$42,$8D,$80
    !by $DE,$A9,$80,$20,$18,$10,$A9,$8A,$85,$42,$8D,$80,$DE,$A9,$80,$20
    !by $18,$10,$A9,$34,$85,$01,$A9,$C0,$85,$03,$A2,$3F,$A9,$00,$85,$02
    !by $A8,$91,$02,$C8,$D0,$FB,$E6,$03,$CA,$D0,$F6,$60,$20,$85,$B2,$78
    !by $A9,$FF,$8D,$80,$DE,$4C,$E2,$FC,$20,$D0,$0F,$A9,$08,$38,$E5,$25
    !by $90,$44,$48,$A8,$A6,$25,$8A,$48,$A6,$25,$A9,$00,$0A,$11,$02,$C8
    !by $CA,$D0,$F9,$48,$A5,$25,$49,$06,$85,$1C,$68,$A2,$01,$0A,$CA,$D0
    !by $FC,$26,$24,$A6,$25,$C6,$1C,$D0,$F4,$98,$38,$E5,$25,$18,$69,$08
    !by $A8,$68,$AA,$CA,$D0,$D0,$68,$48,$4A,$24,$1F,$10,$01,$4A,$A8,$A5
    !by $24,$91,$06,$68,$10,$B7,$A5,$25,$0A,$0A,$0A,$65,$02,$85,$02,$90
    !by $02,$E6,$03,$A5,$06,$18,$69,$08,$85,$06,$90,$02,$E6,$07,$C6,$26
    !by $D0,$99,$4C,$DC,$0F,$48,$20,$7E,$82,$A6,$2A,$A4,$2B,$20,$D3,$82
    !by $68,$0A,$0A,$0A,$69,$00,$85,$08,$A9,$00,$69,$0D,$85,$09,$A2,$00
    !by $A0,$60,$86,$04,$84,$05,$A2,$00,$A0,$3F,$86,$06,$84,$07,$A2,$00
    !by $24,$4A,$50,$03,$A6,$35,$E8,$BD,$D2,$94,$8D,$F4,$10,$A9,$17,$85
    !by $26,$20,$D0,$0F,$A2,$28,$A0,$07,$24,$4A,$70,$06,$B1,$02,$51,$04
    !by $91,$06,$B1,$08,$11,$04,$31,$06,$51,$02,$91,$04,$88,$10,$E9,$20
    !by $E3,$12,$A5,$04,$18,$69,$08,$85,$04,$A5,$06,$18,$69,$08,$85,$06
    !by $90,$04,$E6,$05,$E6,$07,$CA,$D0,$CD,$20,$DC,$0F,$20,$CF,$82,$C6
    !by $26,$D0,$BE,$A9,$40,$85,$4A,$A5,$29,$29,$FB,$85,$29,$A9,$00,$85
    !by $34,$4C,$7E,$82,$A6,$2A,$A4,$2B,$20,$D3,$82,$A2,$00,$86,$26,$86
    !by $27,$24,$1F,$30,$03,$A6,$35,$E8,$BD,$D2,$94,$8D,$6D,$11,$A5,$23
    !by $85,$1C,$A0,$00,$A9,$35,$85,$01,$24,$43,$10,$03,$B1,$02,$48,$20
    !by $9A,$11,$A6,$43,$86,$42,$8E,$80,$DE,$A6,$45,$86,$01,$11,$02,$91
    !by $02,$24,$43,$10,$0A,$A9,$0C,$85,$42,$8D,$80,$DE,$68,$91,$02,$C8
    !by $C0,$08,$D0,$D0,$20,$E3,$12,$C6,$1C,$D0,$C7,$20,$DC,$0F,$A5,$90
    !by $D0,$07,$20,$CF,$82,$C6,$22,$D0,$B5,$60,$A5,$26,$05,$27,$D0,$32
    !by $E6,$26,$A9,$37,$85,$01,$20,$CF,$FF,$C9,$9B,$D0,$23,$24,$1F,$70
    !by $1F,$20,$CF,$FF,$85,$26,$A5,$1F,$29,$02,$F0,$0C,$A5,$26,$F0,$04
    !by $A9,$00,$F0,$07,$A9,$01,$D0,$03,$20,$CF,$FF,$85,$27,$20,$CF,$FF
    !by $85,$24,$A5,$26,$D0,$02,$C6,$27,$C6,$26,$A5,$24,$60,$A6,$4C,$24
    !by $4B,$70,$02,$A6,$4E,$A4,$4D,$24,$4B,$30,$02,$A4,$4F,$20,$D3,$82
    !by $A9,$00,$85,$26,$85,$27,$A6,$51,$A0,$07,$20,$D0,$0F,$98,$48,$24
    !by $4B,$50,$03,$49,$07,$A8,$B1,$02,$48,$20,$DC,$0F,$68,$24,$4B,$30
    !by $03,$20,$71,$93,$20,$BD,$85,$68,$A8,$88,$10,$DE,$20,$DB,$12,$CA
    !by $D0,$D6,$20,$DC,$0F,$A5,$90,$D0,$0E,$20,$C7,$82,$C6,$50,$D0,$C6
    !by $A5,$24,$49,$FF,$20,$BD,$85,$60,$A6,$4C,$24,$4B,$70,$02,$A6,$4E
    !by $A4,$4D,$20,$D3,$82,$A5,$4B,$0A,$08,$0A,$2A,$28,$2A,$29,$03,$85
    !by $24,$A9,$4B,$20,$D2,$FF,$A5,$50,$85,$27,$20,$D0,$0F,$A9,$FE,$A2
    !by $03,$9D,$00,$02,$CA,$10,$FA,$A9,$00,$85,$26,$85,$1C,$85,$1E,$A2
    !by $02,$A5,$02,$49,$04,$85,$02,$A0,$03,$A9,$00,$11,$02,$88,$10,$FB
    !by $A8,$F0,$1E,$B4,$1C,$D0,$0E,$95,$1C,$C9,$10,$A5,$26,$2A,$49,$01
    !by $9D,$00,$02,$B5,$1C,$29,$0F,$C9,$01,$A5,$26,$2A,$69,$01,$9D,$01
    !by $02,$CA,$CA,$10,$CC,$20,$E3,$12,$E6,$26,$A5,$26,$C5,$51,$90,$BF
    !by $20,$DC,$0F,$A2,$03,$8A,$45,$24,$A8,$B9,$00,$02,$C9,$FE,$F0,$0B
    !by $24,$4B,$30,$07,$A5,$51,$0A,$38,$F9,$00,$02,$49,$FF,$20,$D2,$FF
    !by $CA,$10,$E2,$20,$C7,$82,$C6,$27,$D0,$80,$60,$A9,$F8,$A0,$FF,$24
    !by $4B,$10,$04,$A9,$08,$A0,$00,$18,$65,$02,$85,$02,$98,$65,$03,$85
    !by $03,$60,$A9,$04,$85,$42,$8D,$80,$DE,$AD,$00,$80,$C9,$5A,$D0,$0C
    !by $A5,$7F,$A0,$0F,$D9,$01,$80,$F0,$08,$88,$10,$F8,$20,$DC,$0F,$38
    !by $60,$98,$0A,$A8,$B9,$11,$80,$85,$02,$18,$69,$78,$85,$73,$B9,$12
    !by $80,$48,$29,$3F,$09,$80,$85,$03,$85,$74,$90,$02,$E6,$74,$68,$29
    !by $40,$0A,$0A,$2A,$0A,$09,$04,$85,$44,$85,$42,$8D,$80,$DE,$A0,$77
    !by $B1,$02,$99,$00,$3C,$88,$10,$F8,$20,$DC,$0F,$18,$60,$A9,$04,$85
    !by $42,$8D,$80,$DE,$A0,$0F,$A5,$7F,$59,$01,$80,$F0,$03,$88,$10,$F6
    !by $C8,$90,$02,$88,$88,$98,$29,$0F,$A8,$B9,$01,$80,$F0,$F2,$85,$7F
    !by $4C,$DC,$0F,$A5,$44,$85,$42,$8D,$80,$DE,$A2,$FF,$86,$26,$E8,$B1
    !by $08,$9D,$00,$02,$F0,$02,$86,$26,$C8,$E8,$EC,$01,$3C,$D0,$F0,$A9
    !by $02,$85,$42,$8D,$80,$DE,$60,$A5,$1F,$29,$01,$0A,$A8,$B9,$D3,$94
    !by $8D,$D1,$13,$98,$F0,$02,$A9,$FF,$85,$24,$A6,$26,$8A,$0A,$0A,$0A
    !by $A8,$BD,$00,$02,$F0,$2D,$A9,$35,$85,$01,$24,$43,$10,$03,$B1,$02
    !by $48,$A5,$43,$85,$42,$8D,$80,$DE,$A5,$45,$85,$01,$BD,$00,$02,$45
    !by $24,$11,$02,$91,$02,$24,$43,$10,$0A,$A9,$0C,$85,$42,$8D,$80,$DE
    !by $68,$91,$02,$98,$38,$E9,$08,$A8,$CA,$10,$C6,$4C,$DC,$0F,$90,$2D
    !by $20,$DC,$0F,$A6,$22,$A4,$4F,$20,$D3,$82,$20,$D0,$0F,$A6,$51,$A0
    !by $07,$A9,$00,$11,$02,$88,$10,$FB,$A8,$D0,$0E,$A5,$02,$38,$E9,$08
    !by $85,$02,$B0,$02,$C6,$03,$CA,$D0,$E6,$86,$23,$F0,$22,$20,$DC,$0F
    !by $A6,$22,$E8,$E0,$64,$F0,$11,$A4,$4D,$20,$D3,$82,$A5,$43,$85,$44
    !by $A6,$02,$A4,$03,$86,$04,$84,$05,$A6,$22,$A4,$4D,$20,$D3,$82,$4C
    !by $E8,$0F,$20,$D0,$0F,$A0,$07,$B1,$02,$99,$00,$02,$88,$10,$F8,$A9
    !by $00,$A8,$A6,$22,$E0,$63,$F0,$17,$A9,$37,$85,$01,$A2,$34,$A5,$44
    !by $85,$42,$8D,$80,$DE,$10,$02,$A2,$37,$86,$01,$A0,$05,$B1,$04,$99
    !by $08,$02,$88,$10,$F8,$A5,$02,$18,$69,$08,$85,$02,$90,$02,$E6,$03
    !by $A5,$04,$18,$69,$08,$85,$04,$90,$02,$E6,$05,$4C,$E8,$0F,$A9,$7F
    !by $8D,$0D,$DC,$8D,$0D,$DD,$20,$DC,$0F,$20,$FC,$AF,$A9,$00,$8D,$15
    !by $D0,$85,$0C,$A9,$93,$20,$D2,$FF,$AD,$00,$DD,$29,$FB,$8D,$00,$DD
    !by $AD,$02,$DD,$09,$04,$8D,$02,$DD,$A9,$00,$85,$06,$85,$07,$A9,$61
    !by $85,$0B,$A9,$03,$85,$08,$A5,$08,$0A,$8D,$80,$DE,$20,$24,$15,$24
    !by $0C,$30,$1F,$A5,$08,$4A,$B0,$1A,$A9,$3D,$20,$D2,$FF,$A5,$07,$20
    !by $40,$16,$A5,$06,$20,$40,$16,$A9,$0D,$20,$D2,$FF,$A9,$00,$85,$06
    !by $85,$07,$20,$4F,$15,$EE,$20,$D0,$C6,$08,$10,$CA,$A9,$62,$85,$0B
    !by $20,$86,$15,$A9,$72,$85,$0B,$A9,$04,$85,$08,$0A,$8D,$80,$DE,$20
    !by $D8,$15,$A9,$05,$85,$08,$0A,$8D,$80,$DE,$20,$D8,$15,$A9,$80,$85
    !by $0C,$4C,$B8,$14,$A9,$80,$85,$03,$A9,$20,$85,$05,$A0,$00,$84,$02
    !by $84,$04,$A2,$40,$B1,$02,$91,$04,$38,$E5,$02,$18,$65,$06,$85,$06
    !by $90,$02,$E6,$07,$C8,$D0,$ED,$E6,$03,$E6,$05,$CA,$D0,$E6,$60,$A9
    !by $80,$85,$03,$A9,$20,$85,$05,$A0,$00,$84,$02,$84,$04,$A2,$40,$B1
    !by $02,$D1,$04,$F0,$16,$85,$0A,$AD,$00,$DD,$09,$04,$8D,$00,$DD,$29
    !by $FB,$8D,$00,$DD,$B1,$04,$85,$09,$20,$0B,$16,$C8,$D0,$E1,$E6,$03
    !by $E6,$05,$CA,$D0,$DA,$60,$A9,$80,$85,$03,$A0,$00,$84,$02,$A9,$40
    !by $85,$0D,$A2,$0A,$8E,$80,$DE,$B1,$02,$9D,$00,$20,$CA,$CA,$10,$F4
    !by $A2,$0A,$8E,$80,$DE,$B1,$02,$DD,$00,$20,$F0,$1B,$85,$0A,$AD,$00
    !by $DD,$09,$04,$8D,$00,$DD,$29,$FB,$8D,$00,$DD,$8A,$4A,$85,$08,$BD
    !by $00,$20,$85,$09,$20,$0B,$16,$CA,$CA,$10,$D7,$EE,$20,$D0,$C8,$D0
    !by $C1,$E6,$03,$C6,$0D,$D0,$BB,$60,$A9,$80,$85,$03,$A0,$00,$84,$02
    !by $A2,$40,$98,$4D,$12,$D0,$85,$09,$91,$02,$B1,$02,$C5,$09,$F0,$12
    !by $85,$0A,$AD,$00,$DD,$09,$04,$8D,$00,$DD,$29,$FB,$8D,$00,$DD,$20
    !by $0B,$16,$C8,$D0,$DD,$E6,$03,$CA,$D0,$D8,$60,$A9,$0D,$20,$D2,$FF
    !by $A5,$0B,$20,$D2,$FF,$A9,$20,$20,$D2,$FF,$A5,$08,$09,$30,$20,$D2
    !by $FF,$A9,$20,$20,$D2,$FF,$A5,$03,$20,$40,$16,$98,$20,$40,$16,$A9
    !by $20,$20,$D2,$FF,$A5,$09,$20,$40,$16,$A9,$20,$20,$D2,$FF,$A5,$0A
    !by $48,$4A,$4A,$4A,$4A,$20,$4B,$16,$68,$29,$0F,$09,$30,$C9,$3A,$90
    !by $02,$69,$26,$4C,$D2,$FF,$00,$00,$FF,$FF,$00,$00,$FF,$FF,$00,$00
    !by $FF,$FF,$00,$00,$FF,$FF,$00,$00,$FF,$FF,$00,$00,$FF,$FF,$00,$00
    !by $FF,$FF,$00,$00,$FF,$FF,$00,$00,$FF,$FF,$00,$00,$FF,$FF,$00,$00
    !by $FF,$FF,$00,$00,$FF,$FF,$00,$00,$FF,$FF,$00,$00,$FF,$FF,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    ; -------------------------------------------------------------
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
rom0cs_colors_table_bf00:
    !by $00
rom0cs_col_editor_text:      !by $03
rom0cs_col_editor_bg:        !by $00
rom0cs_col_menu:             !by $01
rom0cs_col_gfx_bg:           !by $0F
    !by $00,$00,$01,$00,$00,$00,$00,$00,$04,$01,$00

    !by $00,$41,$65,$0A,$00,$00,$00,$FF,$1B,$33,$18,$FF,$1B,$33,$17,$FF
    !by $1B,$33,$16,$FF,$1B,$33,$15,$FF,$1B,$33,$01,$FF,$1B,$2A,$04,$FF
    !by $1B,$5A,$FF,$1B,$4B,$FF,$1B,$2A,$03,$FF,$1B,$40,$FF,$1B,$43,$FF
}

*=$4000
!pseudopc $8000 {

L8000:
    ldx #$FE
    txs
    jsr LAEEC

L8006:
    jsr L8082
    jsr L8674
    jsr L8BA5
    jmp L8006
    ; data
    !by $64,$44,$6C,$72,$63,$70,$6A,$6D
    !by $74,$67,$61,$73,$65,$20,$7F,$C1
    !by $A6,$A7,$69,$5F,$A0,$A1,$A2,$A3
    !by $6F,$78,$75,$30,$B1,$B2,$2E,$B5
    !by $B6,$B7,$50,$BA,$B8,$C3,$66,$4D
    !by $5E,$77,$AF,$A8,$AA,$6B,$02,$96
    !by $BD,$95,$56,$82,$26,$82,$4D,$82
    !by $AA,$82,$EB,$AE,$A4,$81,$A4,$81
    !by $A4,$81,$A4,$81,$C3,$94,$C3,$94
    !by $C3,$94,$7F,$8A,$C0,$8A,$E1,$8A
    !by $85,$82,$3D,$84,$CC,$84,$D5,$83
    !by $2E,$84,$47,$86,$EC,$83,$F2,$83
    !by $EA,$91,$E0,$91,$EC,$81,$4A,$83
    !by $65,$81,$11,$84,$1A,$84,$B7,$8A

L8082:
    jsr $FFE4
    beq L80A6
    ldx $28
    cpx #$08
    bne L8094
    cmp #$A0
    bcs L8094
    jmp L8119

L8094:
    ldx #$2D

L8096:
    cmp $8012,X
    beq L80A7
    dex
    bpl L8096
    cmp #$31
    bcc L80A6
    cmp #$39
    bcc L80B9

L80A6:
    rts

L80A7:
    txa
    cmp #$0D
    bcc L80BC
    tay
    asl
    tax
    lda $8027,X
    pha
    lda $8026,X
    pha
    tya
    rts

L80B9:
    jmp L81FE

L80BC:
    pha
    cmp #$08
    bne L80CE
    lda #$01
    sta $7F
    jsr LAEE2
    bcc L80CE
    pla
    lda $28
    pha

L80CE:
    lda #$00
    sta $81
    sta $4A
    jsr $0EE7
    lda $29
    and #$9F
    sta $29
    pla

L80DE:
    sta $28
    tax
    lda $810B,X
    sta $48
    ldy $80FD,X
    bit $29
    bpl L80F1
    lda #$05
    ldy #$02

L80F1:
    sty $D015
    jsr LAF3F
    jsr L869A
    jmp L94DE
    ; data
    !by $02,$02,$02,$02,$02,$02,$02,$02
    !by $02,$02,$03,$03,$02,$02,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$02
    !by $02,$02,$02,$02

L8119:
    sta $61
    ldy $34
    bne L8139
    cmp #$21
    bcc L8151
    jsr L869A
    jsr L8AE2
    jsr $0EE7
    ldx #$02
    stx $49

L8130:
    lda $0B,X
    sta $0F,X
    dex
    bpl L8130
    ldy #$00

L8139:
    cpy #$40
    bcs L8151
    lda $61
    cmp #$20
    bcc L8152
    sta $02C0,Y
    inc $34
    lda $29
    ora #$04
    sta $29
    jsr LADB1

L8151:
    rts

L8152:
    cmp #$0F
    beq L815C
    jsr LA8B8
    jmp L817F

L815C:
    clc
    jsr $134D
    jsr LAEAA
    jmp L817F
    ; data
    !by $A5,$34,$F0,$09,$C6,$34,$20,$7F
    !by $81,$A5,$34,$F0,$01,$60,$A9,$00
    !by $85,$34,$A5,$29,$29,$FB,$85,$29
    !by $60

L817F:
    jsr $0F03
    lda $34
    beq L81A4
    ldx #$02

L8188:
    lda $13,X
    sta $0F,X
    dex
    bpl L8188
    ldy #$00

L8191:
    lda $02C0,Y
    sta $61
    tya
    pha
    jsr LADB1
    pla
    bcs L81A4
    tay
    iny
    cpy $34
    bcc L8191

L81A4:
    rts
    ; data
    !by $29,$03,$85,$49,$A5,$34,$F0,$03
    !by $4C,$7F,$81,$A5,$4A,$29,$30,$F0
    !by $03,$4C,$F9,$91,$20,$E7,$0E,$A4
    !by $49,$98,$4A,$AA,$B9,$E5,$81,$D5
    !by $2A,$F0,$17,$B5,$2A,$18,$79,$E9
    !by $81,$95,$2A,$20,$03,$0F,$A5,$CB
    !by $C9,$40,$D0,$E3,$A5,$3F,$29,$05
    !by $D0,$DD,$20,$B3,$89,$4C,$85,$B2
    !by $4D,$00,$28,$00,$01,$FF,$01,$FF
    !by $20,$E7,$0E,$A9,$50,$85,$40,$A9
    !by $2E,$85,$41,$20,$EC,$8A,$4C,$FC
    !by $AE

L81FE:
    pha
    jsr $0EE7
    pla
    and #$0F
    tax
    dex
    lda $8217,X
    sta $2A
    lda $821F,X
    sta $2B
    jsr $0F03
    jmp L89B3
    ; data
    !by $00,$00,$19,$19,$32,$32,$4B,$4B
    !by $00,$28,$00,$28,$00,$28,$00,$28
    !by $20,$E7,$0E,$A6,$2A,$A4,$2B,$E4
    !by $2C,$D0,$0A,$C4,$2D,$D0,$06,$A6
    !by $2E,$A4,$2F,$B0,$08,$86,$2E,$84
    !by $2F,$A6,$2C,$A4,$2D,$86,$2A,$84
    !by $2B,$20,$03,$0F,$4C,$B3,$89,$A6
    !by $2A,$A4,$2B,$86,$2C,$84,$2D,$60
    !by $24,$4A,$30,$18,$20,$E7,$0E,$A2
    !by $00,$A0,$60,$86,$08,$84,$09,$A2
    !by $17,$A0,$28,$A9,$00,$38,$20,$6C
    !by $B3,$4C,$7E,$82,$A9,$60,$20,$A9
    !by $92,$20,$F0,$0E,$4C,$03,$0F,$A5
    !by $29,$29,$08,$F0,$26,$D0,$06,$A5
    !by $29,$49,$08,$85,$29,$A9,$C0,$85
    !by $02,$A9,$5F,$85,$03,$A0,$40,$A2
    !by $1C,$B1,$02,$49,$80,$91,$02,$98
    !by $18,$69,$08,$A8,$90,$F3,$E6,$03
    !by $CA,$10,$EE,$60,$A9,$00,$85,$02
    !by $A9,$7C,$85,$03,$A0,$C0,$A2,$1C
    !by $88,$B1,$02,$49,$FF,$91,$02,$98
    !by $D0,$F6,$C6,$03,$CA,$10,$F1,$60
    !by $24,$4B,$70,$04,$C6,$46,$50,$08
    !by $E6,$46,$10,$04,$86,$46,$84,$47
    !by $A5,$46,$A2,$00,$C9,$19,$90,$05
    !by $E9,$19,$E8,$B0,$F7,$85,$1C,$BD
    !by $0C,$83,$85,$45,$BD,$10,$83,$85
    !by $43,$8A,$48,$A5,$47,$85,$1D,$A2
    !by $1C,$A0,$04,$20,$18,$83,$A2,$02
    !by $20,$41,$83,$68,$AA,$A5,$03,$1D
    !by $14,$83,$85,$03,$60,$34,$34,$37
    !by $37,$0C,$0C,$88,$8A,$80,$C0,$80
    !by $80,$A9,$00,$85,$03,$B5,$00,$0A
    !by $0A,$75,$00,$0A,$26,$03,$88,$D0
    !by $FA,$75,$01,$90,$02,$E6,$03,$85
    !by $02,$60,$A9,$01,$48,$A9,$40,$18
    !by $75,$00,$95,$00,$68,$75,$01,$95
    !by $01,$60,$A0,$03,$16,$00,$36,$01
    !by $88,$D0,$F9,$60,$20,$E7,$0E,$A5
    !by $2A,$38,$E9,$0C,$B0,$02,$A9,$00
    !by $C9,$36,$90,$02,$A9,$36,$AA,$A9
    !by $00,$20,$7F,$83,$4C,$7E,$82,$20
    !by $DE,$9E,$A2,$18,$A0,$60,$86,$08
    !by $84,$09,$A2,$19,$A0,$14,$A9,$FF
    !by $38,$20,$6C,$B3,$A9,$80,$A2,$00
    !by $85,$1F,$A0,$00,$20,$D3,$82,$A0
    !by $02,$A9,$17,$A2,$00,$24,$1F,$10
    !by $06,$A0,$04,$A9,$19,$A2,$18,$84
    !by $25,$85,$27,$86,$04,$A0,$60,$84
    !by $05,$A5,$04,$85,$06,$A5,$05,$85
    !by $07,$A9,$28,$24,$1F,$10,$02,$A9
    !by $14,$85,$26,$20,$38,$10,$20,$CF
    !by $82,$A5,$25,$49,$06,$18,$65,$04
    !by $85,$04,$29,$07,$D0,$DB,$A5,$04
    !by $38,$E9,$08,$85,$04,$A2,$04,$20
    !by $31,$83,$C6,$27,$D0,$CB,$60,$20
    !by $E7,$0E,$20,$0E,$8B,$B0,$0C,$A9
    !by $00,$85,$70,$20,$1B,$0E,$B0,$03
    !by $20,$24,$0E,$4C,$EC,$AE,$20,$E7
    !by $0E,$4C,$A8,$0D,$20,$E7,$0E,$4C
    !by $B4,$0D,$A9,$00,$85,$4A,$85,$34
    !by $A5,$29,$29,$FB,$85,$29,$A9,$4B
    !by $C5,$2A,$B0,$02,$85,$2A,$A9,$C0
    !by $4C,$05,$0F,$AD,$04,$17,$18,$69
    !by $10,$4C,$29,$84,$AD,$04,$17,$AA
    !by $29,$F0,$85,$1C,$E8,$8A,$29,$0F
    !by $05,$1C,$8D,$04,$17,$4C,$B4,$B3
    !by $A2,$A0,$CA,$BD,$00,$60,$9D,$00
    !by $0D,$8A,$D0,$F6,$4C,$31,$95,$20
    !by $E7,$0E,$A9,$00,$85,$71,$20,$67
    !by $84,$B0,$17,$48,$20,$CC,$FF,$20
    !by $0D,$AF,$20,$EC,$8A,$68,$B0,$0A
    !by $85,$1F,$A2,$08,$20,$C6,$FF,$20
    !by $34,$11,$20,$58,$86,$4C,$FC,$AE
    !by $48,$20,$E0,$0D,$68,$20,$05,$0E
    !by $B0,$5B

L8471:
    ldy #$00
    jsr LB209
    bcs L84CC
    jsr $FFCF
    ldy $90
    bne L84A9
    ldy #$00
    cmp #$47
    beq L84AE
    iny
    cmp #$42
    beq L84AE
    tax
    jsr $FFCF
    cpx #$50
    bne L84A6
    sta $22
    jsr $FFCF
    sta $23
    jsr LB156

L849C:
    jsr $FFCF
    tax
    bne L849C
    ldy #$02
    bne L84BC

L84A6:
    stx $71
    txa

L84A9:
    sec
    bne L84CC
    ldy #$41

L84AE:
    tya
    and #$03
    tax
    lda $8543,X
    sta $22
    lda $8545,X
    sta $23

L84BC:
    lda $22
    asl
    sta $41
    lda $23
    asl
    sta $40
    tya
    ora $1F
    sta $1F
    clc

L84CC:
    rts
    ; data
    !by $20,$E7,$0E,$A9,$00,$85,$71,$20
    !by $52,$85,$B0,$67,$48,$20,$E0,$0D
    !by $A9,$03,$20,$F7,$0D,$68,$B0,$5B
    !by $85,$1F,$A0,$01,$20,$09,$B2,$B0
    !by $4F,$A5,$1F,$C9,$01,$D0,$14,$AE
    !by $30,$04,$E0,$30,$D0,$0D,$09,$40
    !by $85,$1F,$A9,$00,$20,$D2,$FF,$A9
    !by $20,$D0,$1A,$AA,$BD,$47,$85,$20
    !by $D2,$FF,$E0,$02,$90,$12,$A5,$50
    !by $20,$D2,$FF,$A5,$51,$20,$D2,$FF
    !by $20,$38,$12,$A9,$00,$20,$D2,$FF
    !by $20,$DD,$11,$24,$1F,$70,$11,$A2
    !by $03,$46,$1F,$90,$02,$A2,$07,$BD
    !by $4A,$85,$20,$D2,$FF,$CA,$10,$F7
    !by $20,$58,$86,$4C,$EC,$AE,$32,$19
    !by $50,$28,$47,$42,$50,$BF,$20,$00
    !by $9B,$00,$00,$C0,$9B,$20,$D6,$94
    !by $A0,$2F,$B9,$E7,$B8,$99,$A0,$7D
    !by $B9,$17,$B9,$99,$E0,$7E,$88,$10
    !by $F1,$20,$85,$B2,$20,$74,$86,$20
    !by $E4,$FF,$C9,$B3,$F0,$48,$A5,$3F
    !by $29,$05,$F0,$F0,$24,$29,$10,$3E
    !by $A2,$04,$A5,$0B,$46,$0C,$6A,$CA
    !by $D0,$FA,$38,$E9,$0E,$90,$2F,$C9
    !by $02,$F0,$25,$B0,$29,$48,$A8,$B9
    !by $45,$85,$85,$51,$0A,$85,$40,$B9
    !by $43,$85,$85,$50,$0A,$85,$41,$20
    !by $EC,$8A,$A5,$2A,$85,$4C,$A5,$2B
    !by $85,$4D,$A9,$C0,$85,$4B,$68,$60
    !by $48,$20,$0E,$8B,$68,$60,$38,$60
    !by $C5,$24,$D0,$03,$4C,$41,$86,$48
    !by $A9,$02,$24,$1F,$F0,$2E,$A5,$27
    !by $F0,$13,$A9,$9B,$20,$D2,$FF,$A9
    !by $00,$20,$D2,$FF,$A5,$24,$20,$D2
    !by $FF,$C6,$27,$D0,$ED,$A5,$26,$F0
    !by $58,$C9,$04,$B0,$06,$A5,$24,$C9
    !by $9B,$D0,$3C,$A9,$9B,$20,$D2,$FF
    !by $A5,$26,$D0,$28,$50,$08,$A5,$26
    !by $05,$27,$F0,$3D,$D0,$29,$A5,$27
    !by $D0,$0E,$A5,$26,$F0,$33,$C9,$05
    !by $B0,$06,$A5,$24,$C9,$9B,$D0,$17
    !by $A9,$9B,$20,$D2,$FF,$A5,$26,$20
    !by $D2,$FF,$A5,$27,$20,$D2,$FF,$A9
    !by $01,$85,$26,$A9,$00,$85,$27,$A5
    !by $24,$20,$D2,$FF,$C6,$26,$D0,$F7
    !by $A5,$27,$F0,$05,$C6,$27,$4C,$2C
    !by $86,$68,$85,$24,$E6,$26,$D0,$02
    !by $E6,$27,$60,$20,$E0,$0D,$A9,$02
    !by $20,$F7,$0D,$B0,$03,$20,$5D,$86
    !by $4C,$FF,$AE,$20,$22,$B2,$A9,$00
    !by $20,$10,$0E,$B0,$09,$A5,$71,$F0
    !by $0D,$A9,$0B,$20,$E9,$0D,$20,$FC
    !by $AF,$20,$2D,$0E,$F0,$FB,$60

L8674:
    lda $36
    and #$C0
    beq L8699
    jsr L869A
    bit $36
    bvc L8699
    sei
    lda $36
    and #$BF
    sta $36
    cli
    bit $29
    bmi L8699
    jsr L89B3
    lda #$04
    bit $29
    beq L8699
    jsr L8D41

L8699:
    rts

L869A:
    sei
    ldx $48
    lda #$EF
    cmp $19
    bcs L86A5
    sta $19

L86A5:
    lda $8784,X
    cmp $19
    bcc L86AE
    sta $19

L86AE:
    ldy #$00
    lda $878E,X
    cmp $19
    bcs L86CC
    ldy #$80
    lda $19
    cmp #$E0
    bcs L86CC
    lda #$E0
    bit $29
    bpl L86CA

L86C5:
    ldy #$00
    lda $878E,X

L86CA:
    sta $19

L86CC:
    tya
    eor $29
    bpl L86F9
    sty $1C
    lda $29
    and #$7F
    ora $1C
    sta $29
    bpl L86EC
    lda $3F
    and #$05
    bne L86C5
    lda #$02
    sta $D015
    lda #$03
    bne L86F6

L86EC:
    ldx $28
    lda $80FD,X
    sta $D015
    lda $48

L86F6:
    jsr LAF3F

L86F9:
    ldx $48
    bit $29
    bpl L8701
    ldx #$00

L8701:
    lda $18
    bne L8710
    lda $877F,X
    cmp $17
    bcc L871D
    sta $17
    bcs L871D

L8710:
    lda #$01
    sta $18
    lda $8789,X
    cmp $17
    bcs L871D
    sta $17

L871D:
    jsr L872B
    jsr L8756
    lda $36
    and #$7F
    sta $36
    cli
    rts

L872B:
    lda $19
    sta $D001
    sta $D003
    sec
    sbc #$15
    clc
    adc $41
    sta $D005
    lda $17
    sta $D000
    sta $D002
    sec
    sbc #$18
    clc
    adc $40
    sta $D004
    lda $18
    asl
    ora $18
    sta $D010
    rts

L8756:
    ldx $48
    bit $29
    bpl L8764
    ldx #$00
    bit $38
    bmi L8764
    ldx #$03

L8764:
    lda $19
    sec
    sbc $8784,X
    sta $0D
    lda #$00
    sta $0E
    lda $17
    sec
    sbc $877F,X
    sta $0B
    lda $18
    sbc #$00
    sta $0C
    rts
    ; data
    !by $0E,$26,$18,$C6,$30,$28,$28,$32
    !by $28,$32,$4D,$C5,$40,$4D,$D0,$DF
    !by $EF,$D5,$EF,$FA,$A5,$36,$29,$C0
    !by $F0,$2B,$20,$C5,$87,$24,$36,$50
    !by $24,$78,$A5,$36,$29,$BF,$85,$36
    !by $58,$24,$29,$30,$18,$20,$CA,$89
    !by $A9,$04,$24,$29,$F0,$0F,$A2,$03
    !by $B5,$13,$95,$0F,$CA,$10,$F9,$20
    !by $11,$9F,$20,$DD,$8D,$60,$78,$A6
    !by $48,$A5,$18,$D0,$0B,$BD,$7F,$87
    !by $C5,$17,$90,$14,$85,$17,$B0,$10
    !by $A9,$01,$85,$18,$A9,$4D,$C5,$17
    !by $B0,$02,$85,$17,$A0,$80,$D0,$2C
    !by $A0,$00,$BD,$89,$87,$E0,$04,$D0
    !by $02,$E5,$40,$C5,$17,$B0,$1D,$A0
    !by $80,$A5,$17,$C9,$C6,$B0,$15,$A9
    !by $C6,$24,$29,$10,$0D,$A0,$00,$84
    !by $18,$BD,$89,$87,$E0,$04,$D0,$02
    !by $E5,$40,$85,$17,$98,$45,$29,$10
    !by $29,$84,$1C,$A5,$29,$29,$7F,$05
    !by $1C,$85,$29,$10,$0D,$24,$38,$30
    !by $DC,$A9,$02,$8D,$15,$D0,$A9,$03
    !by $D0,$0D,$A2,$02,$A5,$48,$C9,$01
    !by $F0,$02,$A2,$06,$8E,$15,$D0,$20
    !by $3F,$AF,$A6,$48,$24,$29,$10,$02
    !by $A2,$03,$BD,$84,$87,$C5,$19,$90
    !by $02,$85,$19,$BD,$8E,$87,$E0,$04
    !by $D0,$02,$E5,$41,$C5,$19,$B0,$02
    !by $85,$19,$20,$2B,$87,$20,$56,$87
    !by $A5,$36,$29,$7F,$85,$36,$58,$60
    !by $A9,$FF,$8D,$00,$DC,$A5,$36,$29
    !by $18,$D0,$1D,$AE,$19,$D4,$E0,$FF
    !by $F0,$4F,$A2,$00,$EA,$EA,$E8,$D0
    !by $FB,$A9,$08,$AE,$1A,$D4,$E0,$FF
    !by $D0,$02,$A9,$10,$05,$36,$85,$36
    !by $29,$08,$F0,$42,$A2,$01,$BD,$19
    !by $D4,$A8,$38,$F5,$3B,$29,$7F,$C9
    !by $40,$B0,$05,$4A,$F0,$0E,$D0,$07
    !by $49,$7F,$F0,$08,$4A,$49,$FF,$48
    !by $98,$95,$3B,$68,$95,$39,$CA,$10
    !by $DD,$A9,$00,$38,$E5,$3A,$85,$3A
    !by $AD,$01,$DC,$49,$FF,$4A,$4C,$16
    !by $89,$06,$3F,$06,$3F,$A9,$00,$85
    !by $3A,$85,$39,$4C,$23,$89,$A9,$00
    !by $8D,$02,$DC,$A9,$10,$8D,$03,$DC
    !by $A2,$00,$A0,$08,$A9,$00,$20,$75
    !by $89,$0A,$0A,$0A,$0A,$95,$39,$A9
    !by $10,$20,$75,$89,$29,$0F,$15,$39
    !by $18,$69,$01,$95,$39,$E8,$E0,$02
    !by $D0,$E2,$A9,$00,$8D,$03,$DC,$AE
    !by $19,$D4,$E0,$FF,$F0,$01,$18,$26
    !by $3F,$18,$AD,$01,$DC,$29,$10,$D0
    !by $01,$38,$26,$3F,$AD,$00,$DC,$49
    !by $FF,$A2,$FF,$8E,$02,$DC,$48,$18
    !by $29,$10,$F0,$01,$38,$26,$3F,$68
    !by $29,$0F,$F0,$2A,$A6,$3E,$D0,$23
    !by $4A,$90,$02,$C6,$3A,$4A,$90,$02
    !by $E6,$3A,$4A,$90,$02,$C6,$39,$4A
    !by $90,$02,$E6,$39,$A6,$3D,$F0,$1D
    !by $A5,$36,$4A,$90,$01,$CA,$86,$3D
    !by $86,$3E,$60,$C6,$3E,$60,$A2,$01
    !by $A5,$36,$4A,$90,$02,$A2,$0A,$86
    !by $3D,$A9,$00,$85,$3E,$60,$8D,$01
    !by $DC,$EA,$EA,$EA,$88,$D0,$FA,$A0
    !by $05,$AD,$01,$DC,$60,$98,$48,$A0
    !by $00,$8A,$10,$01,$88,$18,$65,$17
    !by $AA,$98,$65,$18,$10,$03,$A9,$00
    !by $AA,$86,$17,$29,$01,$85,$18,$68
    !by $18,$30,$08,$65,$19,$90,$0A,$A9
    !by $FF,$D0,$06,$65,$19,$B0,$02,$A9
    !by $00,$85,$19,$60

L89B3:
    bit $29
    bvs L89C9
    ldx #$00
    ldy $2B
    lda #$60
    jsr L89D9
    ldx #$02
    ldy $2A
    lda #$60
    jsr L89D9

L89C9:
    rts
    ; data
    !by $A9,$E0,$A0,$00,$A2,$00,$20,$D9
    !by $89,$A9,$E0,$A0,$00,$A2,$02

L89D9:
    sta $1F
    lda $8A5D,X
    sta $06
    lda $8A5E,X
    sta $07
    tya
    jsr L8A6B
    asl $1F
    bcc L89F6
    ldy #$02

L89EF:
    asl $1A
    rol $1B
    dey
    bne L89EF

L89F6:
    asl $1F
    bcc L8A16
    lda $1A
    sec
    sbc $30,X
    sta $1A
    lda $1B
    sbc $31,X
    sta $1B
    bcs L8A16
    lda #$00
    sec
    sbc $1A
    sta $1A
    lda #$00
    sbc $1B
    sta $1B

L8A16:
    ldy #$1F
    asl $1F
    bcc L8A4A
    lda $29
    and #$10
    beq L8A4A
    txa
    lsr
    lsr
    lda $1705
    rol
    tax
    lda $8A61,X
    pha
    tay
    ldx $1A
    jsr LB336
    sty $1A
    ldx $1B
    pla
    tay
    jsr LB336
    txa
    clc
    adc $1A
    sta $1A
    tya
    adc #$00
    sta $1B
    ldy #$6D

L8A4A:
    sty $0200
    jsr LB2C0
    ldx #$00
    ldy #$02
    stx $02
    sty $03
    lda #$04
    jmp LB242
    ; data
    !by $E1,$7D,$20,$7F,$51,$5A,$51,$5A
    !by $51,$5A,$51,$53,$51,$5A

L8A6B:
    asl
    asl
    rol $1C
    asl
    rol $1C
    clc
    adc $0B,X
    sta $1A
    lda $1C
    and #$03
    adc $0C,X
    sta $1B
    rts
    ; data
    !by $A2,$00,$A5,$2B,$20,$6B,$8A,$A6
    !by $1A,$A4,$1B,$86,$30,$84,$31,$A2
    !by $02,$A5,$2A,$20,$6B,$8A,$A6,$1A
    !by $A4,$1B,$86,$32,$84,$33,$4C,$B3
    !by $89,$A2,$02,$A9,$00,$95,$31,$B5
    !by $0B,$0A,$36,$31,$0A,$36,$31,$95
    !by $30,$CA,$CA,$10,$EE,$4C,$CA,$89
    !by $A5,$29,$49,$10,$85,$29,$4C,$B3
    !by $89,$A4,$48,$24,$29,$10,$02,$A0
    !by $00,$78,$A5,$13,$18,$79,$7F,$87
    !by $85,$17,$A5,$14,$69,$00,$85,$18
    !by $A5,$15,$79,$84,$87,$85,$19,$4C
    !by $7A,$86

L8AE2:
    ldx #$03

L8AE4:
    lda $0B,X
    sta $13,X
    dex
    bpl L8AE4
    rts
    ; data
    !by $20,$66,$83,$A9,$04,$85,$48,$20
    !by $3F,$AF,$A9,$06,$8D,$15,$D0,$78
    !by $A5,$2B,$0A,$69,$30,$85,$17,$A5
    !by $2A,$0A,$69,$32,$85,$19,$A9,$90
    !by $D0,$11,$20,$66,$83,$A9,$01,$85
    !by $48,$20,$3F,$AF,$A9,$02,$8D,$15
    !by $D0,$A9,$98,$85,$38,$78,$A9,$00
    !by $85,$18,$A5,$36,$09,$C0,$85,$36
    !by $58,$20,$85,$B2,$20,$93,$87,$20
    !by $E4,$FF,$C9,$B3,$F0,$5B,$C9,$30
    !by $F0,$22,$A5,$3F,$29,$05,$F0,$EC
    !by $20,$85,$B2,$A9,$08,$24,$38,$F0
    !by $3D,$A5,$29,$49,$04,$85,$29,$29
    !by $04,$F0,$0F,$20,$0D,$9F,$20,$E2
    !by $8A,$4C,$30,$8B,$20,$A1,$8A,$4C
    !by $30,$8B,$20,$82,$92,$A2,$02,$A0
    !by $00,$B5,$0B,$4A,$99,$4C,$00,$B5
    !by $0F,$4A,$99,$4E,$00,$38,$F9,$4C
    !by $00,$18,$69,$01,$99,$50,$00,$C8
    !by $CA,$CA,$10,$E5,$30,$0A,$A5,$0B
    !by $4A,$85,$2B,$A5,$0D,$4A,$85,$2A
    !by $18,$A5,$29,$29,$FB,$85,$29,$A9
    !by $80,$85,$38,$08,$20,$85,$B2,$28
    !by $60

L8BA5:
    lda $3F
    and #$05
    beq L8BEF
    jsr L869A
    lda $29
    bmi L8BEC
    and #$02
    bne L8BDF
    lda #$00
    ldx $28
    cpx #$02
    bcs L8BCE
    jsr L9092
    jsr L8C82
    ldy #$00
    eor ($02),Y
    and $0A
    beq L8BCE
    lda #$01

L8BCE:
    ldx $028D
    beq L8BD5
    eor #$01

L8BD5:
    lsr $29
    asl $29
    ora $29
    ora #$02
    sta $29

L8BDF:
    lda $28
    asl
    tax
    lda $8C06,X
    pha
    lda $8C05,X
    pha
    rts

L8BEC:
    jmp L958C

L8BEF:
    lda $29
    and #$FD
    sta $29
    lda $3F
    and #$12
    cmp #$02
    bne L8C04
    lda #$FF
    sta $3F
    jsr L95BE

L8C04:
    rts
    ; data
    !by $32,$8C,$55,$8C,$2A,$8D,$2A,$8D
    !by $2A,$8D,$9E,$8F,$31,$8F,$9C,$91
    !by $73,$81,$DE,$8C,$97,$8C,$94,$8C
    !by $9B,$8C,$43,$96

L8C21:
    ldx #$02

L8C23:
    lda $0B,X
    cmp $8C52,X
    lda $0C,X
    sbc $8C53,X
    bcs L8C51
    dex
    dex
    bpl L8C23
    jsr L9092

L8C36:
    ldy #$00
    lda $29
    lsr
    ror $1F

L8C3D:
    jsr L8C82
    eor $1F
    asl
    lda $0A
    bcc L8C4D
    eor #$FF
    and ($02),Y
    bcs L8C4F

L8C4D:
    ora ($02),Y

L8C4F:
    sta ($02),Y

L8C51:
    rts
    ; data
    !by $40,$01,$B8,$00,$A9,$03,$85,$27
    !by $C6,$0D,$A5,$0B,$D0,$02,$C6,$0C
    !by $C6,$0B,$A9,$03,$85,$26,$A5,$0D
    !by $48,$20,$21,$8C,$E6,$0D,$C6,$26
    !by $D0,$F7,$68,$85,$0D,$E6,$0B,$D0
    !by $02,$E6,$0C,$C6,$27,$D0,$E3,$60

L8C82:
    lda $29
    and #$08
    beq L8C94
    lda $02
    and #$07
    beq L8C90
    lda $0A

L8C90:
    eor $0A
    and #$80

L8C94:
    rts
    ; data
    !by $20,$9C,$8C,$A9,$00,$F0,$02,$A9
    !by $80,$85,$1F,$A5,$0D,$48,$A2,$00
    !by $20,$92,$90,$A9,$18,$85,$20,$A0
    !by $00,$BD,$40,$7F,$99,$00,$02,$E8
    !by $C8,$C0,$03,$D0,$F4,$A0,$00,$24
    !by $1F,$30,$0B,$2E,$02,$02,$2E,$01
    !by $02,$2E,$00,$02,$90,$03,$20,$3D
    !by $8C,$20,$20,$8D,$C6,$20,$D0,$E7
    !by $E6,$0D,$E0,$3F,$D0,$CA,$68,$85
    !by $0D,$60,$20,$EA,$8C,$A9,$0A,$20
    !by $DE,$80,$4C,$85,$B2,$A5,$0D,$48
    !by $A2,$00,$20,$92,$90,$A9,$18,$85
    !by $20,$A0,$00,$20,$82,$8C,$18,$51
    !by $02,$25,$0A,$F0,$01,$38,$3E,$42
    !by $7F,$3E,$41,$7F,$3E,$40,$7F,$20
    !by $20,$8D,$C6,$20,$D0,$E5,$E6,$0D
    !by $E8,$E8,$E8,$E0,$3F,$D0,$D3,$68
    !by $85,$0D,$60,$46,$0A,$90,$06,$66
    !by $0A,$98,$69,$08,$A8,$60,$20,$85
    !by $B2,$A5,$29,$49,$04,$48,$29,$04
    !by $F0,$06,$20,$E7,$0E,$20,$E2,$8A
    !by $68,$85,$29,$60

L8D41:
    lda $28
    cmp #$08
    bne L8D4D
    jsr L8AE2
    jmp L817F

L8D4D:
    ldx #$03

L8D4F:
    lda $13,X
    sta $0F,X
    dex
    bpl L8D4F
    jsr $0F03
    lda $28
    cmp #$02
    beq L8D70
    cmp #$03
    bne L8D66
    jmp L8DDD

L8D66:
    cmp #$04
    bne L8D6D
    jmp L8E26

L8D6D:
    jmp L924F

L8D70:
    lda $0D
    pha
    lda $0B
    pha
    lda $0C
    pha
    jsr L9092
    jsr L916F
    lda $06
    sec
    sbc $04
    sta $08
    lda #$00
    sbc $05
    asl
    php
    ror
    plp
    ror
    sta $09
    ror $08

L8D93:
    jsr L8C36
    lda $0B
    cmp $0F
    bne L8DA8
    lda $0C
    cmp $10
    bne L8DA8
    lda $0D
    cmp $11
    beq L8DD3

L8DA8:
    bit $09
    bmi L8DC1
    jsr L9131
    bcc L8DD3
    lda $08
    sec
    sbc $04
    sta $08
    lda $09
    sbc $05
    sta $09
    jmp L8D93

L8DC1:
    jsr L90E6
    bcc L8DD3
    lda $08
    clc
    adc $06
    sta $08
    bcc L8D93
    inc $09
    bcs L8D93

L8DD3:
    pla
    sta $0C
    pla
    sta $0B
    pla
    sta $0D
    rts

L8DDD:
    lda $11
    pha
    lda $0D
    sta $11
    jsr L8D70
    pla
    sta $11
    lda $0B
    pha
    lda $0C
    pha
    lda $0F
    sta $0B
    lda $10
    sta $0C
    jsr L8D70
    pla
    sta $0C
    pla
    sta $0B
    lda $0D
    pha
    lda $11
    sta $0D
    jsr L8D70
    pla
    sta $0D
    lda $0F
    pha
    lda $10
    pha
    lda $0B
    sta $0F
    lda $0C
    sta $10
    jsr L8D70
    pla
    sta $10
    pla
    sta $0F
    rts

L8E26:
    jsr L916F
    lda $04
    cmp $06
    bcs L8E31
    lda $06

L8E31:
    tax
    beq L8E7C
    sta $08
    ldx $04
    bne L8E3C
    sta $04

L8E3C:
    ldx $06
    bne L8E42
    sta $06

L8E42:
    lda $04
    sta $0F
    lda #$00
    sta $11
    jsr L8E7D

L8E4D:
    jsr L8EEC
    lda $0F
    beq L8E7C
    inc $11
    lda #$02
    jsr L8E7D
    dec $11
    dec $0F
    lda #$04
    jsr L8E7D
    inc $0F
    lda $0202
    cmp $0204
    lda $0203
    sbc $0205
    bcs L8E78
    inc $11
    bcc L8E4D

L8E78:
    dec $0F
    bcs L8E4D

L8E7C:
    rts

L8E7D:
    sta $24
    ldy $0F
    lda $04
    jsr L8EC7
    stx $1A
    sty $1B
    ldy $11
    lda $06
    jsr L8EC7
    txa
    clc
    adc $1A
    ldx $24
    sta $0200,X
    tya
    adc $1B
    sta $0201,X
    txa
    beq L8EC6
    lda $0200,X
    sec
    sbc $0200
    pha
    lda $0201,X
    sbc $0201
    bcs L8EBF
    tay
    pla
    eor #$FF
    adc #$01
    pha
    tya
    eor #$FF
    adc #$00

L8EBF:
    sta $0201,X
    pla
    sta $0200,X

L8EC6:
    rts

L8EC7:
    cmp $08
    beq L8EE7
    pha
    ldx $08
    jsr LB336
    pla
    sta $26
    lsr
    sta $1C
    txa
    clc
    adc $1C
    sta $1C
    tya
    adc #$00
    sta $1D
    jsr LA429
    ldy $1C

L8EE7:
    tya
    tax
    jmp LB336

L8EEC:
    lda $13
    clc
    adc $0F
    sta $0B
    pha
    lda $14
    adc #$00
    sta $0C
    pha
    lda $15
    adc $11
    sta $0D
    lda #$00
    rol
    sta $0E
    jsr L8C21
    lda $13
    sec
    sbc $0F
    sta $0B
    lda $14
    sbc #$00
    sta $0C
    jsr L8C21
    lda $15
    sec
    sbc $11
    sta $0D
    lda #$00
    sbc #$00
    sta $0E
    jsr L8C21
    pla
    sta $0C
    pla
    sta $0B
    jmp L8C21
    ; data
    !by $A9,$0A,$85,$25,$A2,$03,$B5,$0B
    !by $95,$0F,$CA,$10,$F9,$A5,$A2,$4A
    !by $AC,$12,$D0,$A2,$00,$20,$80,$8F
    !by $AA,$10,$02,$C6,$0C,$65,$0B,$85
    !by $0B,$90,$02,$E6,$0C,$AD,$12,$D0
    !by $45,$A2,$A4,$A2,$A2,$02,$20,$80
    !by $8F,$65,$0D,$85,$0D,$A5,$04,$65
    !by $06,$B0,$05,$30,$03,$20,$21,$8C
    !by $A2,$03,$B5,$0F,$95,$0B,$CA,$10
    !by $F9,$C6,$25,$D0,$C0,$60,$86,$02
    !by $84,$1C,$4A,$45,$1C,$29,$0F,$48
    !by $08,$AA,$A8,$20,$36,$B3,$8A,$A6
    !by $02,$95,$04,$98,$95,$05,$28,$68
    !by $90,$02,$49,$FF,$60,$20,$E7,$0E
    !by $20,$7E,$82,$20,$92,$90,$A0,$00
    !by $B1,$02,$25,$0A,$F0,$02,$A9,$FF
    !by $85,$24,$A9,$01,$20,$E8,$90,$A9
    !by $00,$85,$49,$A5,$0D,$85,$11,$20
    !by $85,$B2,$20,$CD,$8F,$20,$7E,$82
    !by $4C,$85,$B2,$BA,$86,$04,$BA,$E0
    !by $1C,$90,$66,$A5,$1C,$48,$A5,$1D
    !by $48,$A5,$0B,$48,$A5,$0C,$48,$A5
    !by $0D,$85,$1C,$A5,$11,$85,$1D,$20
    !by $E6,$90,$90,$41,$20,$3C,$90,$90
    !by $3C,$A5,$0D,$48,$A5,$11,$48,$20
    !by $3C,$90,$90,$05,$20,$D0,$8F,$90
    !by $F6,$68,$85,$1D,$68,$85,$1C,$A5
    !by $49,$49,$01,$85,$49,$20,$E6,$90
    !by $20,$3C,$90,$90,$05,$20,$D0,$8F
    !by $90,$F6,$A5,$49,$49,$01,$85,$49
    !by $20,$E6,$90,$A5,$3F,$29,$07,$F0
    !by $BE,$A6,$04,$9A,$60,$68,$85,$0C
    !by $68,$85,$0B,$68,$85,$1D,$68,$85
    !by $1C,$60,$A5,$1C,$85,$0D,$A5,$1D
    !by $85,$11,$20,$92,$90,$20,$89,$90
    !by $D0,$33,$20,$37,$91,$90,$08,$20
    !by $89,$90,$F0,$F6,$20,$4C,$91,$A5
    !by $0D,$AA,$20,$89,$90,$D0,$13,$B1
    !by $02,$45,$24,$05,$0A,$45,$24,$91
    !by $02,$20,$4C,$91,$A5,$0D,$C9,$B8
    !by $90,$E8,$20,$37,$91,$A5,$0D,$85
    !by $11,$86,$0D,$38,$60,$20,$4C,$91
    !by $A5,$11,$C5,$0D,$B0,$BF,$60,$A0
    !by $00,$B1,$02,$45,$24,$25,$0A,$60

L9092:
    lda #$00
    sta $02
    lda $0D
    lsr
    lsr
    lsr
    sta $03
    asl
    asl
    adc $03
    lsr
    ror $02
    lsr
    ror $02
    adc #$60
    sta $03
    lda $0D
    and #$07
    sta $1E
    lda $38
    and #$10
    beq L90B9
    lda #$18

L90B9:
    adc $0B
    and #$F8
    adc $1E
    adc $02
    sta $02
    lda $0C
    adc $03
    sta $03
    lda $0B
    and #$07
    tay
    lda $90D4,Y
    sta $0A
    rts
    ; data
    !by $80,$40,$20,$10,$08,$04,$02,$01
    !by $14,$14,$05,$12,$2D,$02,$19,$14
    !by $05,$60

L90E6:
    lda $49

L90E8:
    lsr
    bcc L910C
    lda $0B
    ora $0C
    beq L912F
    lda $0B
    bne L90F7
    dec $0C

L90F7:
    dec $0B
    asl $0A
    bcc L910A
    rol $0A
    lda $02
    sec
    sbc #$08
    sta $02
    bcs L910A
    dec $03

L910A:
    sec
    rts

L910C:
    lda $0C
    beq L9116
    lda $0B
    cmp #$3F
    beq L912F

L9116:
    inc $0B
    bne L911C
    inc $0C

L911C:
    lsr $0A
    bcc L912D
    ror $0A
    lda $02
    clc
    adc #$08
    sta $02
    bcc L912D
    inc $03

L912D:
    sec
    rts

L912F:
    clc
    rts

L9131:
    lda $49

L9133:
    and #$02
    beq L914C
    lda $0D
    beq L912F
    dec $0D
    and #$07
    beq L9145
    dec $02
    sec
    rts

L9145:
    lda #$FE
    pha
    lda #$C7
    bne L9163

L914C:
    lda $0D
    cmp #$C7
    beq L912F
    inc $0D
    lda $0D
    and #$07
    beq L915E
    inc $02
    sec
    rts

L915E:
    lda #$01
    pha
    lda #$39

L9163:
    clc
    adc $02
    sta $02
    pla
    adc $03
    sta $03
    sec
    rts

L916F:
    lda $0D
    sec
    sbc $11
    bcs L917B
    eor #$FF
    adc #$01
    clc

L917B:
    sta $06
    rol $49
    lda $0B
    sec
    sbc $0F
    sta $04
    lda $0C
    sbc $10
    bcs L9198
    lda $0F
    sec
    sbc $0B
    sta $04
    lda $10
    sbc $0C
    clc

L9198:
    sta $05
    rol $49
    rts
    ; data
    !by $20,$85,$B2,$24,$4A,$30,$39,$A5
    !by $29,$49,$04,$48,$29,$04,$F0,$09
    !by $20,$E7,$0E,$68,$85,$29,$4C,$E2
    !by $8A,$68,$85,$29,$20,$03,$0F,$A2
    !by $00,$A0,$3F,$86,$08,$84,$09,$A2
    !by $17,$A0,$28,$A9,$00,$38,$20,$6C
    !by $B3,$A9,$3F,$20,$A9,$92,$A9,$A0
    !by $85,$4A,$20,$D6,$94,$4C,$03,$0F
    !by $A9,$00,$F0,$12,$A5,$4A,$10,$13
    !by $29,$EF,$49,$20,$30,$08,$A5,$4A
    !by $10,$09,$29,$DF,$49,$10,$85,$4A
    !by $20,$D6,$94,$60,$A5,$4A,$29,$10
    !by $D0,$3B,$A4,$49,$BE,$32,$92,$BD
    !by $36,$92,$D5,$4C,$F0,$24,$98,$4A
    !by $8A,$29,$01,$AA,$90,$06,$D6,$4C
    !by $D6,$4E,$B0,$04,$F6,$4C,$F6,$4E
    !by $20,$4E,$94,$20,$03,$0F,$A5,$3F
    !by $29,$05,$D0,$D6,$A5,$CB,$C9,$40
    !by $D0,$D0,$4C,$85,$B2,$02,$00,$03
    !by $01,$00,$00,$16,$27,$20,$80,$93
    !by $20,$03,$0F,$A5,$3F,$29,$05,$D0
    !by $F4,$A5,$CB,$C9,$40,$D0,$EE,$4C
    !by $85,$B2

L924F:
    jsr L9282
    ldx #$00
    ldy #$01

L9256:
    lda $0C,X
    lsr
    lda $0B,X
    and #$F8
    sta $0B,X
    ror
    lsr
    lsr
    sta $004C,Y
    lda $10,X
    lsr
    lda $0F,X
    ora #$07
    sta $0F,X
    ror
    lsr
    lsr
    sta $004E,Y
    sbc $004C,Y
    sta $0050,Y
    inx
    inx
    dey
    bpl L9256
    jmp L8DDD

L9282:
    ldx #$02

L9284:
    lda $0B,X
    cmp $0F,X
    lda $0C,X
    sbc $10,X
    bcc L92A2
    lda $0F,X
    pha
    lda $0B,X
    sta $0F,X
    pla
    sta $0B,X
    lda $10,X
    pha
    lda $0C,X
    sta $10,X
    pla
    sta $0C,X

L92A2:
    ror $4B
    dex
    dex
    bpl L9284
    rts
    ; data
    !by $48,$49,$60,$85,$1F,$20,$7E,$82
    !by $A5,$4C,$24,$4B,$70,$02,$A5,$4E
    !by $85,$22,$A5,$4D,$24,$4B,$30,$02
    !by $A5,$4F,$85,$23,$A2,$22,$A0,$03
    !by $20,$18,$83,$A2,$02,$20,$41,$83
    !by $A5,$02,$85,$04,$85,$08,$68,$18
    !by $65,$03,$85,$05,$85,$09,$A2,$4C
    !by $A0,$03,$20,$18,$83,$A2,$02,$20
    !by $41,$83,$A5,$02,$85,$06,$A5,$03
    !by $09,$60,$85,$03,$85,$07,$A5,$50
    !by $85,$22,$A6,$51,$A0,$07,$84,$1C
    !by $A5,$1F,$F0,$13,$B1,$02,$24,$4B
    !by $30,$03,$20,$71,$93,$24,$4B,$70
    !by $06,$48,$98,$49,$07,$A8,$68,$91
    !by $04,$A4,$1C,$88,$10,$E0,$A5,$02
    !by $18,$69,$08,$85,$02,$90,$02,$E6
    !by $03,$A9,$08,$A0,$00,$24,$4B,$30
    !by $04,$A9,$F8,$A0,$FF,$18,$65,$04
    !by $85,$04,$98,$65,$05,$85,$05,$CA
    !by $10,$BA,$A2,$06,$20,$31,$83,$A5
    !by $06,$85,$02,$A5,$07,$85,$03,$A9
    !by $40,$A0,$01,$24,$4B,$70,$04,$A9
    !by $C0,$A0,$FE,$18,$65,$08,$85,$08
    !by $85,$04,$98,$65,$09,$85,$09,$85
    !by $05,$C6,$22,$10,$8D,$4C,$7E,$82
    !by $85,$1D,$84,$1C,$A0,$08,$26,$1D
    !by $6A,$88,$D0,$FA,$A4,$1C,$60,$A2
    !by $07,$BD,$46,$94,$95,$02,$CA,$10
    !by $F8,$A2,$1C,$86,$26,$A5,$49,$C9
    !by $01,$D0,$34,$A0,$40,$98,$29,$07
    !by $C9,$07,$D0,$1A,$98,$18,$65,$06
    !by $26,$1C,$C9,$C0,$66,$1C,$A9,$00
    !by $65,$07,$26,$1C,$E9,$5B,$A9,$00
    !by $B0,$08,$B1,$06,$90,$04,$C8,$B1
    !by $02,$88,$91,$02,$C8,$D0,$D6,$E6
    !by $03,$E6,$07,$CA,$10,$CF,$60,$C9
    !by $00,$D0,$2B,$A0,$C0,$88,$98,$29
    !by $07,$D0,$12,$98,$18,$65,$08,$A9
    !by $00,$65,$09,$C9,$3F,$A9,$00,$90
    !by $08,$B1,$08,$B0,$04,$88,$B1,$04
    !by $C8,$91,$04,$98,$D0,$DF,$C6,$05
    !by $C6,$09,$CA,$10,$D8,$60,$C9,$03
    !by $D0,$26,$A0,$C0,$A2,$00,$98,$29
    !by $07,$D0,$0B,$CA,$10,$06,$A9,$00
    !by $85,$1C,$A2,$27,$26,$1C,$88,$B1
    !by $04,$2A,$91,$04,$26,$1C,$98,$D0
    !by $E5,$C6,$05,$C6,$26,$10,$DF,$60
    !by $A0,$40,$A2,$00,$98,$29,$07,$D0
    !by $0B,$CA,$10,$06,$A9,$00,$85,$1C
    !by $A2,$27,$66,$1C,$B1,$02,$6A,$91
    !by $02,$66,$1C,$C8,$D0,$E6,$E6,$03
    !by $C6,$26,$10,$E0,$60,$C0,$3E,$00
    !by $5B,$F9,$3F,$C7,$59,$A5,$49,$0A
    !by $65,$49,$0A,$A8,$A2,$00,$B9,$AC
    !by $94,$95,$02,$C8,$E8,$E0,$05,$D0
    !by $F5,$AA,$B9,$AD,$94,$A8,$A5,$49
    !by $4A,$90,$10,$B1,$02,$91,$04,$C8
    !by $D0,$F9,$E6,$03,$E6,$05,$CA,$10
    !by $F2,$30,$17,$88,$B1,$02,$91,$04
    !by $98,$D0,$F8,$C6,$03,$C6,$05,$CA
    !by $10,$F1,$A2,$00,$A0,$3F,$86,$04
    !by $84,$05,$A0,$07,$A5,$49,$4A,$D0
    !by $0A,$A8,$91,$04,$88,$D0,$FB,$E6
    !by $05,$A0,$3F,$A9,$00,$91,$04,$88
    !by $10,$FB,$60,$00,$5A,$40,$5B,$1B
    !by $80,$C0,$3F,$80,$3E,$1B,$80,$00
    !by $5B,$08,$5B,$1C,$B8,$C0,$3E,$B8
    !by $3E,$1C,$48,$29,$03,$85,$35,$24
    !by $4A,$10,$03,$20,$03,$0F,$4C,$D6
    !by $94,$24,$11,$51,$31,$A5,$29,$29
    !by $9F,$09,$20,$85,$29

L94DE:
    bit $29
    bvs L9537
    ldx $0E39
    ldy $0E3A
    lda $29
    and #$20
    beq L94F4
    ldx $0E3B
    ldy $0E3C

L94F4:
    stx $02
    sty $03
    ldx #$C0
    ldy #$7C
    stx $08
    sty $09
    ldx #$02
    ldy #$28
    clc
    jsr LB36C
    jsr L89B3
    lda $29
    and #$20
    bne L9518
    ldx $28
    inx
    txa
    jmp L9570

L9518:
    lda $4A
    and #$30
    beq L9529
    ldx #$07
    and #$10
    beq L9525
    inx

L9525:
    txa
    jsr L9570

L9529:
    lda $35
    clc
    adc #$09
    jmp L9570
    ; data
    !by $A5,$29,$09,$40,$85,$29

L9537:
    ldx #$03

L9539:
    lda $956C,X
    sta $02,X
    dex
    bpl L9539
    ldx #$00
    stx $26
    ldy #$00

L9547:
    lda #$FF
    bne L954E

L954B:
    lda $0D00,X

L954E:
    sta ($02),Y
    lda $0D00,X
    sta ($04),Y
    inx
    iny
    bne L955D
    inc $03
    inc $05

L955D:
    tya
    and #$07
    bne L954B
    txa
    ldx $26
    sta $26
    cpx #$A0
    bne L9547
    rts
    ; data
    !by $C0,$7C,$00,$7E

L9570:
    asl
    asl
    asl
    asl
    tay
    ldx #$10

L9577:
    lda $7CC0,Y
    eor #$FF
    sta $7CC0,Y
    lda $7E00,Y
    eor #$FF
    sta $7E00,Y
    iny
    dex
    bne L9577
    rts

L958C:
    lda $19
    cmp #$EF
    bcs L95BE
    ldx #$04
    lda $0B

L9596:
    lsr $0C
    ror
    dex
    bne L9596
    tax
    bit $29
    bvs L95B8
    lda $29
    and #$20
    beq L95AC
    txa
    clc
    adc #$14
    tax

L95AC:
    jmp ($0E3F)
    lda $95DB,X
    jsr L8094
    jmp LB285

L95B8:
    jsr $10A5
    jmp LB285

L95BE:
    lda $29
    clc
    adc #$20
    and #$60
    cmp #$60
    bne L95CB
    lda #$00

L95CB:
    sta $1C
    lda $29
    and #$9F
    ora $1C
    sta $29
    jsr L94DE
    jmp LB285
    ; data
    !by $5F,$64,$44,$6C,$72,$63,$70,$6A
    !by $6D,$74,$67,$61,$73,$65,$20,$77
    !by $B8,$C3,$6B,$6B,$5F,$C1,$5E,$A3
    !by $A1,$A0,$A2,$4D,$66,$6F,$78,$75
    !by $2E,$69,$B5,$B6,$BA,$B7,$6B,$6B
    !by $A5,$28,$C9,$09,$90,$04,$C9,$0D
    !by $90,$05,$A9,$0D,$4C,$BC,$80,$20
    !by $E2,$8A,$20,$E7,$0E,$A9,$8C,$8D
    !by $01,$D0,$A9,$14,$8D,$00,$D0,$A9
    !by $01,$8D,$10,$D0,$A9,$01,$8D,$15
    !by $D0,$A9,$1A,$85,$02,$A9,$5C,$85
    !by $03,$A2,$16,$A0,$0D,$AD,$04,$17
    !by $20,$61,$99,$20,$CD,$B3,$4C,$AD
    !by $96,$20,$E2,$8A,$20,$E7,$0E,$20
    !by $E4,$AF,$20,$EA,$8C,$20,$9C,$8C
    !by $A9,$FC,$38,$E5,$13,$A8,$A9,$00
    !by $E5,$14,$98,$B0,$02,$A9,$00,$C9
    !by $D0,$90,$02,$A9,$D0,$29,$F8,$85
    !by $1C,$18,$6D,$81,$87,$65,$13,$8D
    !by $00,$D0,$8D,$02,$D0,$A5,$14,$69
    !by $00,$85,$1D,$0A,$05,$1D,$8D,$10
    !by $D0,$A9,$03,$8D,$15,$D0,$A9,$C0
    !by $85,$04,$38,$E5,$1C,$85,$02,$A9
    !by $7B,$85,$05,$E9,$00,$85,$03,$A2
    !by $1C,$A0,$00,$88,$B1,$02,$91,$04
    !by $98,$D0,$F8,$C6,$03,$C6,$05,$CA
    !by $D0,$F1,$20,$63,$98,$20,$85,$B2
    !by $20,$C9,$96,$20,$EC,$AE,$20,$C1
    !by $8A,$A5,$28,$C9,$0D,$D0,$06,$20
    !by $95,$8C,$20,$F0,$AF,$60,$20,$D5
    !by $96,$20,$DA,$97,$20,$3A,$99,$4C
    !by $C9,$96,$20,$2D,$0E,$D0,$01,$60
    !by $C9,$20,$D0,$03,$68,$68,$60,$C9
    !by $6D,$D0,$25,$A0,$3C,$B9,$40,$7F
    !by $20,$71,$93,$99,$82,$03,$B9,$42
    !by $7F,$20,$71,$93,$99,$80,$03,$B9
    !by $41,$7F,$20,$71,$93,$99,$81,$03
    !by $88,$88,$88,$10,$E0,$4C,$68,$97
    !by $C9,$74,$D0,$14,$A0,$00,$A2,$3E
    !by $B9,$40,$7F,$20,$71,$93,$9D,$80
    !by $03,$C8,$CA,$10,$F3,$4C,$68,$97
    !by $C9,$72,$D0,$4F,$A9,$02,$85,$27
    !by $A4,$27,$84,$08,$BE,$6C,$99,$B9
    !by $6F,$99,$85,$20,$A9,$03,$85,$26
    !by $A9,$08,$85,$21,$A4,$20,$8A,$48
    !by $A9,$00,$3E,$40,$7F,$6A,$E8,$E8
    !by $E8,$88,$D0,$F6,$A4,$08,$99,$80
    !by $03,$C8,$C8,$C8,$84,$08,$68,$AA
    !by $C6,$21,$D0,$E0,$E8,$C6,$26,$D0
    !by $D7,$C6,$27,$10,$C3,$A0,$3E,$B9
    !by $80,$03,$99,$40,$7F,$88,$10,$F7
    !by $4C,$DB,$98,$C9,$69,$D0,$10,$A0
    !by $3E,$B9,$40,$7F,$49,$FF,$99,$40
    !by $7F,$88,$10,$F5,$4C,$DB,$98,$C9
    !by $C1,$D0,$06,$20,$D9,$AF,$4C,$DB
    !by $98,$C9,$A0,$D0,$14,$A5,$0D,$C9
    !by $14,$90,$0A,$C9,$16,$B0,$37,$A5
    !by $3F,$29,$05,$D0,$31,$E6,$0D,$10
    !by $24,$C9,$A1,$D0,$08,$A5,$0D,$F0
    !by $25,$C6,$0D,$10,$18,$C9,$A2,$D0
    !by $0A,$A5,$0B,$C9,$17,$B0,$17,$E6
    !by $0B,$10,$0A,$C9,$A3,$D0,$0F,$A5
    !by $0B,$F0,$0B,$C6,$0B,$A5,$24,$A0
    !by $29,$91,$04,$20,$1C,$99,$60,$A5
    !by $3F,$29,$05,$F0,$5C,$A5,$0D,$C9
    !by $15,$B0,$5D,$A5,$29,$29,$02,$D0
    !by $1C,$AD,$3E,$03,$45,$24,$29,$0F
    !by $F0,$02,$A9,$01,$AE,$8D,$02,$F0
    !by $02,$49,$01,$46,$29,$06,$29,$05
    !by $29,$09,$02,$85,$29,$20,$C9,$90
    !by $A5,$0B,$4A,$4A,$4A,$A0,$03,$18
    !by $65,$0D,$88,$D0,$FB,$A8,$A5,$29
    !by $4A,$A5,$0A,$B0,$0A,$19,$40,$7F
    !by $99,$40,$7F,$A2,$01,$D0,$0A,$49
    !by $FF,$39,$40,$7F,$99,$40,$7F,$A2
    !by $00,$BD,$3E,$03,$85,$24,$4C,$3A
    !by $99,$A5,$29,$29,$FD,$85,$29,$60
    !by $AD,$04,$17,$A0,$29,$91,$04,$20
    !by $85,$B2,$A5,$0B,$4A,$AA,$BD,$57
    !by $98,$4C,$D8,$96,$00,$00,$00,$20
    !by $6D,$74,$72,$69,$C1,$00,$00,$00
    !by $AD,$04,$17,$20,$61,$99,$8D,$3E
    !by $03,$AD,$04,$17,$4A,$4A,$4A,$4A
    !by $85,$1C,$AD,$3E,$03,$29,$F0,$05
    !by $1C,$8D,$3F,$03,$A2,$00,$A0,$60
    !by $86,$08,$84,$09,$A2,$19,$A0,$1A
    !by $A9,$FF,$38,$20,$6C,$B3,$A9,$48
    !by $85,$02,$A9,$61,$85,$03,$A9,$15
    !by $85,$27,$A9,$18,$85,$26,$A9,$81
    !by $A0,$01,$A2,$06,$91,$02,$C8,$CA
    !by $D0,$FA,$C8,$C8,$C6,$26,$D0,$F2
    !by $A2,$02,$20,$31,$83,$C6,$27,$D0
    !by $E1,$A0,$5F,$B9,$47,$B9,$99,$B8
    !by $7B,$B9,$A7,$B9,$99,$F8,$7C,$88
    !by $10,$F1,$A9,$02,$20,$3F,$AF,$20
    !by $2A,$B0,$A9,$0A,$85,$0D,$85,$0B
    !by $A9,$3E,$85,$26,$A9,$49,$85,$02
    !by $A9,$5F,$85,$03,$A0,$02,$A6,$26
    !by $BD,$40,$7F,$99,$80,$03,$C6,$26
    !by $88,$10,$F3,$A0,$17,$4E,$80,$03
    !by $6E,$81,$03,$6E,$82,$03,$A9,$00
    !by $2A,$AA,$BD,$3E,$03,$91,$02,$88
    !by $10,$EB,$38,$A5,$02,$E9,$28,$85
    !by $02,$B0,$02,$C6,$03,$A5,$26,$10
    !by $CB,$A5,$0B,$85,$0E,$A2,$0D,$A0
    !by $03,$20,$18,$83,$A5,$02,$85,$04
    !by $A5,$03,$09,$5C,$85,$05,$A0,$29
    !by $B1,$04,$85,$24,$20,$4E,$99,$A5
    !by $24,$29,$0F,$85,$1C,$AD,$28,$D0
    !by $0A,$0A,$0A,$0A,$05,$1C,$A0,$29
    !by $91,$04,$60,$A9,$00,$A8,$AA,$85
    !by $0C,$20,$D9,$89,$A9,$00,$A8,$A2
    !by $02,$85,$0E,$4C,$D9,$89,$29,$0F
    !by $85,$1C,$0A,$0A,$0A,$0A,$05,$1C
    !by $60,$27,$0F,$00,$08,$08,$05,$A2
    !by $FE,$9A,$20,$F8,$9F,$20,$C0,$99
    !by $20,$93,$87,$20,$2B,$9A,$4C,$78
    !by $99,$62,$B5,$65,$73,$74,$C3,$B9
    !by $5F,$31,$32,$33,$C1,$76,$66,$B7
    !by $61,$A8,$AA,$30,$B8,$E3,$99,$6D
    !by $9B,$E3,$99,$1F,$9C,$6F,$9C,$B3
    !by $0D,$AD,$0D,$85,$9E,$99,$9E,$99
    !by $9E,$99,$9E,$5D,$9D,$9A,$A0,$A6
    !by $A0,$C2,$A0,$BE,$9A,$11,$84,$1A
    !by $84,$A0,$8A,$2B,$10,$20,$E4,$FF
    !by $F0,$12,$48,$20,$7A,$B2,$0E,$40
    !by $03,$68,$A2,$13,$DD,$84,$99,$F0
    !by $04,$CA,$10,$F8,$60,$8A,$0A,$A8
    !by $B9,$99,$99,$48,$B9,$98,$99,$48
    !by $60,$A9,$04,$24,$29,$D0,$06,$A5
    !by $37,$C9,$04,$D0,$07,$8A,$48,$20
    !by $A4,$9D,$68,$AA,$A5,$38,$29,$BF
    !by $85,$38,$A5,$29,$29,$FB,$85,$29
    !by $86,$37,$BD,$21,$9A,$BC,$26,$9A
    !by $85,$48,$24,$29,$10,$04,$A9,$03
    !by $A0,$02,$8C,$15,$D0,$20,$3F,$AF
    !by $20,$C5,$87,$4C,$5A,$9F,$01,$04
    !by $01,$01,$01,$02,$06,$02,$02,$02
    !by $A5,$3F,$29,$07,$F0,$22,$48,$20
    !by $C5,$87,$20,$7A,$B2,$20,$85,$B2
    !by $68,$24,$29,$10,$03,$4C,$A2,$9F
    !by $29,$02,$D0,$0D,$A5,$37,$0A,$AA
    !by $BD,$5D,$9A,$48,$BD,$5C,$9A,$48
    !by $60,$A2,$02,$20,$E4,$99,$4C,$EB
    !by $9B,$65,$9A,$B0,$9B,$EA,$9B,$3C
    !by $9C,$C4,$9C,$A5,$29,$49,$04,$85
    !by $29,$29,$04,$F0,$09,$20,$0D,$9F
    !by $20,$74,$9E,$4C,$E2,$8A,$20,$82
    !by $92,$E6,$0F,$E6,$11,$A5,$0F,$38
    !by $E5,$0B,$C9,$05,$90,$2B,$A4,$52
    !by $A2,$02,$24,$38,$70,$13,$AD,$00
    !by $17,$A8,$18,$69,$05,$B0,$1D,$8D
    !by $00,$17,$A9,$00,$99,$00,$18,$A2
    !by $00,$86,$37,$A2,$00,$B5,$0B,$99
    !by $01,$18,$C8,$E8,$E8,$E0,$08,$90
    !by $F4,$4C,$73,$A0,$A9,$05,$20,$2A
    !by $B2,$4C,$A4,$9D,$24,$38,$50,$24
    !by $20,$74,$9E,$A4,$52,$B9,$00,$18
    !by $10,$1B,$18,$69,$20,$29,$60,$C9
    !by $20,$D0,$02,$A9,$40,$85,$1C,$B9
    !by $00,$18,$29,$9F,$05,$1C,$99,$00
    !by $18,$20,$5A,$9F,$60,$A5,$52,$AA
    !by $18,$69,$05,$A8,$BD,$00,$18,$29
    !by $1F,$F0,$1C,$B9,$00,$18,$C9,$A0
    !by $90,$15,$18,$69,$04,$99,$00,$18
    !by $29,$1C,$D0,$1C,$DE,$00,$18,$A9
    !by $01,$20,$59,$9E,$4C,$2C,$9B,$A9
    !by $01,$20,$38,$9E,$B0,$0E,$A6,$52
    !by $A9,$E0,$9D,$05,$18,$FE,$00,$18
    !by $20,$2C,$9B,$60,$A9,$05,$4C,$2A
    !by $B2,$A4,$52,$B9,$00,$18,$30,$16
    !by $A2,$80,$29,$1F,$F0,$0C,$B9,$05
    !by $18,$C9,$A0,$90,$05,$0A,$0A,$29
    !by $70,$AA,$A0,$00,$F0,$0E,$A0,$10
    !by $A2,$A0,$0A,$0A,$30,$06,$A2,$90
    !by $B0,$02,$A2,$B0,$A9,$10,$85,$26
    !by $BD,$87,$BC,$99,$D0,$6F,$BD,$47
    !by $BD,$99,$10,$71,$C8,$E8,$C6,$26
    !by $D0,$EE,$60,$A9,$80,$20,$67,$84
    !by $B0,$36,$AC,$00,$17,$98,$18,$69
    !by $05,$B0,$28,$AA,$65,$B7,$B0,$23
    !by $84,$52,$A5,$B7,$09,$C0,$99,$00
    !by $18,$A0,$00,$B1,$BB,$9D,$00,$18
    !by $C8,$E8,$C4,$B7,$90,$F5,$20,$DD
    !by $9B,$20,$22,$B2,$A9,$01,$85,$37
    !by $4C,$84,$A0,$A9,$05,$20,$2A,$B2
    !by $20,$58,$86,$4C,$76,$A0,$20,$74
    !by $9E,$A4,$52,$A5,$0B,$29,$FE,$99
    !by $01,$18,$18,$65,$40,$99,$03,$18
    !by $A5,$0D,$29,$FE,$99,$02,$18,$18
    !by $65,$41,$99,$04,$18,$24,$38,$70
    !by $06,$20,$26,$9E,$8C,$00,$17,$4C
    !by $73,$A0,$A4,$52,$20,$B9,$B1,$A5
    !by $B7,$A6,$BB,$A4,$BC,$4C,$31,$B2
    !by $AD,$00,$17,$F0,$2F,$20,$EB,$9D
    !by $20,$D4,$9D,$A5,$38,$09,$40,$85
    !by $38,$A4,$52,$A2,$00,$B9,$00,$18
    !by $10,$17,$B9,$03,$18,$38,$F9,$01
    !by $18,$85,$40,$B9,$04,$18,$38,$F9
    !by $02,$18,$85,$41,$20,$DD,$9B,$A2
    !by $01,$20,$03,$9A,$60,$AD,$00,$17
    !by $F0,$13,$A0,$00,$B9,$00,$18,$30
    !by $07,$84,$52,$20,$D4,$9D,$A4,$52
    !by $20,$26,$9E,$90,$EF,$A2,$03,$4C
    !by $E4,$99,$AD,$00,$17,$F0,$2D,$20
    !by $EB,$9D,$A4,$52,$20,$D4,$9D,$20
    !by $74,$9E,$A2,$00,$A4,$52,$B9,$00
    !by $18,$9D,$00,$02,$C8,$E8,$E0,$15
    !by $90,$F4,$20,$85,$9D,$A2,$00,$BD
    !by $00,$02,$99,$00,$18,$E8,$C8,$CC
    !by $00,$17,$D0,$F3,$60,$24,$38,$50
    !by $0F,$A4,$52,$B9,$00,$18,$30,$08
    !by $20,$84,$9C,$A2,$04,$20,$03,$9A
    !by $60,$20,$08,$9F,$A4,$52,$20,$BB
    !by $9D,$A4,$52,$20,$26,$9E,$88,$98
    !by $38,$E9,$04,$C5,$52,$F0,$2A,$B9
    !by $00,$18,$C9,$A0,$B0,$23,$A6,$52
    !by $7D,$01,$18,$C9,$A0,$B0,$17,$85
    !by $0B,$85,$0F,$BD,$02,$18,$85,$0D
    !by $BD,$04,$18,$85,$11,$C6,$11,$98
    !by $48,$20,$70,$8D,$68,$A8,$88,$D0
    !by $CE,$60,$20,$74,$9E,$A4,$52,$A5
    !by $0B,$38,$F9,$01,$18,$90,$5B,$85
    !by $0F,$20,$26,$9E,$88,$98,$38,$E9
    !by $04,$C5,$52,$F0,$10,$B9,$00,$18
    !by $C9,$A0,$B0,$09,$C5,$0F,$F0,$35
    !by $90,$03,$88,$D0,$E8,$A6,$52,$A5
    !by $0B,$DD,$03,$18,$B0,$34,$BD,$00
    !by $18,$29,$1F,$C9,$0F,$B0,$19,$C8
    !by $98,$48,$A9,$01,$20,$38,$9E,$68
    !by $A8,$B0,$0D,$A5,$0F,$99,$00,$18
    !by $A6,$52,$FE,$00,$18,$4C,$84,$9C
    !by $A9,$05,$4C,$2A,$B2,$A9,$01,$20
    !by $59,$9E,$A6,$52,$DE,$00,$18,$20
    !by $84,$9C,$60,$A4,$52,$B9,$00,$18
    !by $29,$1F,$F0,$26,$AA,$98,$18,$69
    !by $05,$A8,$B9,$00,$18,$C9,$A0,$90
    !by $02,$C8,$CA,$8A,$F0,$14,$08,$20
    !by $59,$9E,$A4,$52,$B9,$00,$18,$29
    !by $E0,$4A,$28,$2A,$99,$00,$18,$20
    !by $84,$9C,$60,$0E,$40,$03,$90,$03
    !by $4C,$F4,$0F,$20,$74,$9E,$A0,$00
    !by $24,$38,$50,$10,$A5,$37,$C9,$04
    !by $D0,$03,$4C,$2E,$9D,$20,$85,$9D
    !by $A9,$02,$85,$37,$8C,$00,$17,$4C
    !by $73,$A0,$A4,$52,$20,$26,$9E,$98
    !by $38,$E5,$52,$85,$1C,$A6,$52,$B9
    !by $00,$18,$9D,$00,$18,$E8,$C8,$D0
    !by $F6,$AD,$00,$17,$38,$E5,$1C,$A8
    !by $60,$20,$08,$9F,$AD,$00,$17,$F0
    !by $0E,$A0,$00,$98,$48,$20,$BB,$9D
    !by $68,$A8,$20,$26,$9E,$90,$F4,$60
    !by $A2,$00,$B9,$01,$18,$95,$0B,$C8
    !by $E8,$A9,$00,$95,$0B,$E8,$E0,$08
    !by $90,$F0,$C6,$0F,$C6,$11,$4C,$DD
    !by $8D,$A9,$04,$85,$25,$A5,$29,$49
    !by $01,$85,$29,$A4,$52,$20,$BB,$9D
    !by $20,$0D,$9F,$C6,$25,$D0,$EE,$60
    !by $A9,$FF,$85,$24,$A0,$00,$84,$52
    !by $C8,$C8,$A2,$02,$A9,$00,$85,$1C
    !by $B9,$00,$18,$18,$79,$02,$18,$6A
    !by $38,$F5,$0B,$B0,$04,$49,$FF,$69
    !by $01,$18,$65,$1C,$85,$1C,$88,$CA
    !by $CA,$10,$E5,$B0,$08,$C5,$24,$B0
    !by $04,$85,$24,$84,$52,$20,$26,$9E
    !by $90,$CE,$60,$B9,$00,$18,$29,$1F
    !by $18,$69,$05,$85,$1C,$98,$65,$1C
    !by $A8,$CC,$00,$17,$60,$85,$26,$18
    !by $6D,$00,$17,$B0,$18,$8D,$00,$17
    !by $84,$1C,$A0,$FF,$98,$38,$E5,$26
    !by $AA,$BD,$00,$18,$99,$00,$18,$88
    !by $CA,$E4,$1C,$B0,$F4,$60,$85,$26
    !by $AD,$00,$17,$38,$E5,$26,$8D,$00
    !by $17,$98,$18,$65,$26,$AA,$BD,$00
    !by $18,$99,$00,$18,$C8,$E8,$D0,$F6
    !by $60,$A0,$00,$B9,$00,$18,$99,$00
    !by $5B,$C8,$D0,$F7,$AD,$00,$17,$8D
    !by $41,$03,$60,$A0,$00,$B9,$00,$5B
    !by $99,$00,$18,$C8,$D0,$F7,$AD,$41
    !by $03,$8D,$00,$17,$4C,$73,$A0,$8A
    !by $29,$03,$48,$20,$74,$9E,$68,$AA
    !by $BC,$BA,$9E,$A2,$00,$B9,$BD,$9E
    !by $9D,$00,$18,$F0,$04,$C8,$E8,$10
    !by $F4,$8E,$00,$17,$4C,$73,$A0,$00
    !by $06,$11,$40,$0A,$06,$96,$C3,$00
    !by $40,$09,$06,$4E,$C3,$40,$52,$06
    !by $97,$C3,$00,$40,$08,$06,$36,$C3
    !by $40,$39,$06,$67,$C3,$40,$6A,$06
    !by $98,$C3,$00,$A5,$29,$29,$76,$85
    !by $29,$A5,$38,$29,$EF,$85,$38,$A2
    !by $07,$BD,$00,$9F,$95,$0B,$CA,$10
    !by $F8,$20,$70,$8D,$A9,$B8,$85,$0B
    !by $85,$0F,$4C,$70,$8D,$17,$00,$C7
    !by $00,$17,$00,$00,$00,$A9,$00,$AA
    !by $F0,$08,$A9,$80,$D0,$02,$A9,$00
    !by $A2,$FF,$85,$1F,$86,$24,$A2,$17
    !by $A0,$60,$86,$02,$84,$03,$A2,$FF
    !by $A0,$3E,$86,$04,$84,$05,$A9,$19
    !by $85,$26,$A0,$A0,$24,$1F,$30,$0B
    !by $B1,$04,$25,$24,$91,$02,$88,$D0
    !by $F7,$F0,$07,$B1,$02,$91,$04,$88
    !by $D0,$F9,$A2,$02,$20,$31,$83,$A5
    !by $04,$18,$69,$A0,$85,$04,$90,$02
    !by $E6,$05,$C6,$26,$D0,$D4,$60,$AE
    !by $3D,$0E,$AC,$3E,$0E,$86,$02,$84
    !by $03,$A2,$D0,$A0,$6A,$86,$08,$84
    !by $09,$A2,$08,$A0,$0A,$18,$20,$6C
    !by $B3,$A5,$37,$20,$86,$9F,$24,$38
    !by $50,$08,$A9,$02,$20,$86,$9F,$20
    !by $2C,$9B,$60,$0A,$0A,$0A,$0A,$A8
    !by $A2,$10,$B9,$50,$6D,$49,$FF,$99
    !by $50,$6D,$B9,$90,$6E,$49,$FF,$99
    !by $90,$6E,$C8,$CA,$D0,$EC,$60,$A5
    !by $0B,$38,$E9,$18,$90,$3A,$C9,$50
    !by $B0,$27,$4A,$4A,$4A,$4A,$85,$1C
    !by $A5,$0D,$38,$E9,$40,$90,$29,$C9
    !by $40,$B0,$16,$29,$F0,$4A,$4A,$85
    !by $1D,$4A,$4A,$65,$1D,$65,$1C,$AA
    !by $6C,$41,$0E,$BD,$E4,$9F,$4C,$C3
    !by $99,$A5,$0D,$C9,$B8,$90,$09,$A5
    !by $0B,$C9,$68,$90,$03,$20,$B8,$8A
    !by $60,$C3,$B9,$76,$66,$B7,$62,$B5
    !by $65,$73,$74,$61,$61,$61,$00,$C1
    !by $5F,$31,$32,$33,$B8,$A2,$00,$A0
    !by $60,$86,$08,$84,$09,$A2,$19,$A0
    !by $28,$A9,$00,$38,$20,$6C,$B3,$20
    !by $B4,$B3,$20,$0D,$AF,$20,$DE,$9E
    !by $A9,$02,$85,$49,$A9,$00,$85,$81
    !by $48,$A8,$B9,$8F,$A0,$20,$E9,$0D
    !by $85,$34,$A8,$B9,$28,$04,$99,$C0
    !by $02,$88,$10,$F7,$68,$48,$A8,$B9
    !by $91,$A0,$85,$0F,$B9,$92,$A0,$85
    !by $11,$A9,$00,$85,$10,$85,$12,$B9
    !by $90,$A0,$85,$7F,$20,$E2,$AE,$B0
    !by $03,$20,$8F,$81,$68,$18,$69,$04
    !by $C9,$0C,$90,$C4,$A2,$18,$A0,$6C
    !by $86,$08,$84,$09,$A2,$08,$A0,$0A
    !by $A9,$FF,$38,$20,$6C,$B3,$20,$5A
    !by $9F,$20,$74,$9E,$A9,$10,$85,$38
    !by $20,$A4,$9D,$A5,$37,$C9,$01,$F0
    !by $04,$C9,$04,$D0,$04,$A9,$02,$85
    !by $37,$20,$0D,$AF,$A6,$37,$20,$E4
    !by $99,$4C,$85,$B2

	!by $11,$28,$CC,$08
	!by $12,$02,$C0,$23
	!by $13,$02,$C4,$2F

    !by $A9,$01,$85,$72,$A9,$00,$20,$07
    !by $A1,$4C,$76,$A0,$0E,$40,$03,$B0
    !by $06,$A9,$40,$8D,$40,$03,$60,$A9
    !by $01,$85,$72,$A9,$40,$20,$07,$A1
    !by $D0,$03,$20,$7B,$83,$4C,$76,$A0
    !by $20,$1B,$0E,$B0,$36,$A2,$05,$BD
    !by $01,$A1,$95,$4C,$CA,$10,$F8,$A9
    !by $01,$85,$72,$A9,$70,$20,$07,$A1
    !by $D0,$21,$20,$24,$0E,$B0,$1C,$A5
    !by $70,$29,$F7,$C5,$70,$F0,$14,$48
    !by $20,$38,$A7,$E6,$72,$68,$A6,$71
    !by $F0,$E3,$8A,$20,$2A,$B2,$A9,$00
    !by $20,$10,$0E,$4C,$76,$A0,$00,$00
    !by $63,$4F,$64,$50,$6C,$43,$0E,$85
    !by $70,$A9,$00,$85,$71,$8D,$15,$D0
    !by $A9,$18,$AC,$00,$17,$F0,$71,$A2
    !by $01,$A0,$19,$86,$58,$84,$59,$24
    !by $70,$50,$03,$20,$F4,$0F,$20,$08
    !by $9F,$20,$9B,$A1,$20,$D8,$A1,$20
    !by $1B,$A7,$A5,$71,$D0,$52,$AD,$01
    !by $19,$F0,$57,$A0,$00,$20,$01,$A2
    !by $A9,$18,$B0,$44,$A0,$00,$B1,$58
    !by $C9,$01,$F0,$1E,$90,$44,$C9,$02
    !by $D0,$11,$A5,$70,$09,$80,$85,$70
    !by $20,$53,$A7,$B0,$35,$A9,$00,$85
    !by $83,$90,$18,$20,$50,$A2,$90,$13
    !by $B0,$0A,$A9,$00,$85,$83,$E6,$58
    !by $D0,$02,$E6,$59,$20,$FA,$A1,$A9
    !by $19,$B0,$0D,$A5,$71,$D0,$09,$20
    !by $E4,$FF,$C9,$B3,$D0,$BE,$A9,$1B
    !by $85,$71,$20,$2A,$B2,$A9,$00,$20
    !by $10,$0E,$20,$74,$9E,$A5,$71,$60
    !by $A2,$0B,$BD,$CC,$A1,$95,$79,$CA
    !by $10,$F8,$A9,$00,$8D,$00,$3C,$20
    !by $AA,$AE,$A9,$00,$A2,$0F,$9D,$45
    !by $03,$CA,$10,$FA,$A9,$FF,$A2,$07
    !by $9D,$3E,$02,$CA,$10,$FA,$A2,$78
    !by $A0,$04,$8E,$46,$02,$8C,$47,$02
    !by $60,$01,$02,$08,$00,$00,$00,$00
    !by $01,$00,$00,$00,$00,$A0,$00,$B9
    !by $00,$18,$0A,$19,$00,$18,$0A,$39
    !by $00,$18,$4A,$29,$40,$85,$1C,$B9
    !by $00,$18,$29,$BF,$05,$1C,$99,$00
    !by $18,$20,$26,$9E,$90,$E1,$60,$A4
    !by $52,$20,$26,$9E,$B0,$4E,$B9,$00
    !by $18,$30,$F6,$84,$52,$09,$40,$99
    !by $00,$18,$29,$1F,$AA,$B9,$02,$18
    !by $85,$64,$A9,$00,$06,$64,$2A,$06
    !by $64,$2A,$85,$65,$8A,$F0,$2C,$B9
    !by $05,$18,$C9,$A0,$90,$0E,$29,$1C
    !by $85,$1C,$A5,$7C,$29,$E3,$05,$1C
    !by $85,$7C,$CA,$C8,$8A,$F0,$14,$85
    !by $26,$A2,$01,$B9,$05,$18,$9D,$45
    !by $03,$C8,$E8,$E0,$10,$B0,$04,$C6
    !by $26,$D0,$F0,$18,$60,$A5,$70,$29
    !by $7F,$85,$70,$20,$9F,$A2,$B0,$43
    !by $20,$74,$A6,$A0,$00,$B1,$58,$C9
    !by $0D,$F0,$11,$A5,$0D,$85,$11,$A9
    !by $00,$A2,$07,$95,$0B,$CA,$CA,$10
    !by $FA,$20,$70,$8D,$A5,$70,$09,$80
    !by $85,$70,$20,$D2,$A7,$20,$2C,$AA
    !by $8A,$84,$1C,$38,$E5,$1C,$18,$65
    !by $8D,$65,$7A,$65,$64,$85,$64,$90
    !by $02,$E6,$65,$20,$EE,$A9,$85,$58
    !by $84,$59,$18,$60,$A5,$64,$85,$0D
    !by $A5,$65,$4A,$66,$0D,$4A,$66,$0D
    !by $A5,$7C,$29,$FC,$85,$7C,$A5,$0D
    !by $A4,$52,$D9,$04,$18,$B0,$59,$B9
    !by $01,$18,$85,$0B,$B9,$03,$18,$85
    !by $0F,$20,$14,$A3,$B0,$2B,$20,$4C
    !by $A4,$A5,$64,$18,$65,$8C,$85,$0D
    !by $A5,$65,$69,$00,$4A,$66,$0D,$4A
    !by $66,$0D,$A5,$0D,$A4,$52,$D9,$04
    !by $18,$B0,$2D,$A5,$67,$48,$A5,$66
    !by $48,$20,$14,$A3,$68,$AA,$68,$90
    !by $13,$A9,$00,$85,$65,$B9,$04,$18
    !by $85,$0D,$0A,$26,$65,$0A,$26,$65
    !by $85,$64,$90,$AA,$E4,$66,$D0,$04
    !by $C5,$67,$F0,$03,$20,$4C,$A4,$18
    !by $60,$A0,$00,$C4,$52,$F0,$75,$B9
    !by $00,$18,$29,$40,$F0,$6E,$A5,$0D
    !by $D9,$02,$18,$90,$67,$D9,$04,$18
    !by $B0,$62,$20,$B5,$A3,$B0,$5D,$A6
    !by $0B,$E4,$1D,$2A,$E4,$1C,$2A,$A6
    !by $0F,$E4,$1C,$2A,$E4,$1D,$2A,$29
    !by $0F,$F0,$49,$C9,$0F,$F0,$45,$C9
    !by $06,$F0,$66,$AA,$A5,$1C,$38,$E5
    !by $0B,$85,$1C,$A5,$0F,$38,$E5,$1D
    !by $85,$1D,$E0,$03,$D0,$08,$A5,$1C
    !by $C5,$1D,$B0,$06,$90,$16,$E0,$02
    !by $D0,$0E,$A9,$19,$C5,$1C,$B0,$41
    !by $A5,$1A,$85,$0F,$A9,$01,$90,$10
    !by $E0,$07,$D0,$10,$A9,$19,$C5,$1D
    !by $B0,$2F,$A5,$1B,$85,$0B,$A9,$02
    !by $05,$7C,$85,$7C,$20,$26,$9E,$B0
    !by $03,$4C,$16,$A3,$A9,$00,$85,$63
    !by $85,$67,$A5,$0B,$0A,$26,$63,$0A
    !by $26,$63,$85,$62,$A5,$0F,$38,$E5
    !by $0B,$0A,$26,$67,$0A,$26,$67,$85
    !by $66,$60,$B9,$00,$18,$29,$A0,$C9
    !by $A0,$D0,$0B,$A2,$07,$98,$DD,$3E
    !by $02,$F0,$17,$CA,$10,$F8,$BE,$01
    !by $18,$86,$1A,$E8,$E8,$86,$1C,$BE
    !by $03,$18,$86,$1B,$CA,$CA,$86,$1D
    !by $18,$60,$8A,$0A,$AA,$A5,$0D,$38
    !by $F9,$02,$18,$0A,$26,$1D,$18,$7D
    !by $46,$02,$85,$02,$A5,$1D,$29,$01
    !by $7D,$47,$02,$85,$03,$A5,$7B,$4A
    !by $4A,$85,$1D,$A2,$00,$A1,$02,$C9
    !by $FE,$F0,$22,$18,$79,$01,$18,$38
    !by $E5,$1D,$B0,$02,$A9,$00,$85,$1C
    !by $85,$1A,$E6,$02,$A1,$02,$18,$79
    !by $01,$18,$65,$1D,$90,$02,$A9,$A0
    !by $85,$1D,$85,$1B,$18,$60

LA429:
    ldx #$00
    stx $1E
    ldy #$10

LA42F:
    asl $1C
    rol $1D
    rol $1E
    txa
    rol
    tax
    lda $1E
    sec
    sbc $26
    bcs LA444
    cpx #$01
    bcc LA448
    dex

LA444:
    sta $1E
    inc $1C

LA448:
    dey
    bne LA42F
    rts
    ; data
    !by $A9,$00,$A2,$08,$95,$85,$CA,$10
    !by $FB,$20,$2C,$AA,$20,$53,$AA,$A5
    !by $7D,$29,$9F,$85,$7D,$A5,$7C,$29
    !by $DF,$85,$7C,$A2,$00,$B5,$7F,$48
    !by $E8,$E0,$06,$90,$F8,$20,$CD,$A9
    !by $20,$F9,$A9,$B0,$0E,$A9,$2D,$20
    !by $A7,$AA,$B0,$65,$A9,$40,$20,$19
    !by $AA,$C6,$86,$20,$12,$A5,$B0,$59
    !by $A5,$61,$20,$B8,$A8,$90,$DE,$C9
    !by $0D,$F0,$6A,$C9,$03,$90,$64,$C9
    !by $09,$D0,$0F,$A9,$2D,$20,$A7,$AA
    !by $B0,$3F,$A9,$40,$20,$19,$AA,$4C
    !by $71,$A4,$C9,$2D,$D0,$0D,$20,$9B
    !by $AA,$B0,$2E,$A9,$00,$20,$19,$AA
    !by $4C,$71,$A4,$C9,$20,$D0,$13,$E6
    !by $89,$A6,$68,$A4,$69,$A9,$00,$20
    !by $19,$AA,$20,$9B,$AA,$B0,$12,$4C
    !by $71,$A4,$90,$0A,$CD,$03,$3C,$B0
    !by $05,$20,$9B,$AA,$B0,$03,$4C,$71
    !by $A4,$A5,$86,$F0,$16,$85,$85,$A6
    !by $6A,$A4,$6B,$86,$68,$84,$69,$A8
    !by $88,$B1,$58,$C9,$20,$D0,$0C,$C6
    !by $89,$B0,$08,$C6,$85,$A5,$7D,$29
    !by $9F,$85,$7D,$A2,$05,$68,$95,$7F
    !by $CA,$10,$FA,$4C,$AA,$AE,$24,$7D
    !by $10,$52,$A5,$83,$C9,$E8,$D0,$06
    !by $A2,$00,$86,$8B,$86,$8A,$29,$0F
    !by $C9,$08,$F0,$04,$C9,$0E,$D0,$36
    !by $A5,$61,$29,$1F,$AA,$BD,$F1,$A5
    !by $4A,$26,$8B,$E6,$8A,$A5,$85,$29
    !by $07,$0A,$A8,$A5,$68,$99,$2E,$02
    !by $A5,$69,$99,$2F,$02,$A5,$8B,$C9
    !by $05,$90,$19,$29,$03,$C9,$01,$D0
    !by $13,$A2,$03,$24,$7D,$70,$01,$E8
    !by $E4,$8A,$B0,$08,$90,$08,$A9,$00
    !by $85,$8A,$85,$8B,$18,$60,$A4,$85
    !by $88,$88,$84,$1E,$A2,$03,$B1,$58
    !by $20,$96,$B2,$9D,$00,$02,$88,$CA
    !by $10,$F4,$A0,$63,$A2,$03,$B9,$10
    !by $A6,$F0,$19,$DD,$00,$02,$D0,$06
    !by $CA,$88,$10,$F2,$30,$1D,$88,$88
    !by $30,$19,$B9,$11,$A6,$F0,$E5,$88
    !by $10,$F8,$30,$0F,$A9,$60,$C0,$00
    !by $F0,$0B,$8A,$18,$65,$1E,$38,$E9
    !by $02,$85,$1E,$A9,$40,$85,$1D,$A9
    !by $2D,$20,$A7,$AA,$48,$A4,$1E,$C8
    !by $98,$29,$07,$0A,$A8,$68,$18,$79
    !by $2E,$02,$AA,$26,$1C,$C5,$66,$66
    !by $1C,$B9,$2F,$02,$69,$00,$A8,$26
    !by $1C,$E5,$67,$B0,$11,$86,$6A,$84
    !by $6B,$A4,$1E,$84,$86,$A5,$7D,$29
    !by $9F,$05,$1D,$85,$7D,$18,$A2,$01
    !by $86,$8B,$E8,$86,$8A,$60,$01,$00
    !by $00,$00,$01,$00,$00,$00,$01,$00
    !by $00,$00,$00,$00,$01,$00,$00,$00
    !by $00,$00,$01,$00,$00,$00,$01,$00
    !by $01,$01,$01,$00,$00,$43,$4B,$00
    !by $42,$4C,$00,$42,$52,$00,$43,$48
    !by $00,$44,$52,$00,$46,$4C,$00,$46
    !by $52,$00,$47,$4C,$00,$47,$52,$00
    !by $4B,$4C,$00,$4B,$4E,$00,$4B,$52
    !by $00,$50,$48,$00,$50,$46,$00,$50
    !by $4C,$00,$50,$52,$00,$53,$50,$00
    !by $53,$54,$00,$54,$48,$00,$54,$52
    !by $00,$5A,$57,$00,$53,$43,$48,$00
    !by $53,$50,$52,$00,$53,$54,$52,$00
    !by $53,$43,$48,$4C,$00,$53,$43,$48
    !by $4E,$00,$53,$43,$48,$57,$00,$53
    !by $43,$48,$4D,$00,$53,$43,$48,$52
    !by $A5,$66,$38,$E5,$68,$85,$6C,$85
    !by $1E,$A5,$67,$E5,$69,$85,$6D,$4A
    !by $66,$1E,$4A,$66,$1E,$20,$53,$AA
    !by $A9,$10,$85,$1D,$A5,$7C,$24,$1D
    !by $F0,$0A,$29,$0F,$A8,$A5,$7C,$29
    !by $20,$19,$0B,$A7,$29,$2C,$F0,$44
    !by $C9,$0C,$F0,$0B,$29,$28,$F0,$1A
    !by $46,$6D,$66,$6C,$46,$1E,$18,$08
    !by $A5,$68,$18,$65,$6C,$85,$68,$A5
    !by $69,$65,$6D,$85,$69,$28,$90,$24
    !by $B0,$29,$A4,$85,$88,$B1,$58,$C9
    !by $0D,$F0,$19,$A0,$00,$A6,$89,$F0
    !by $1E,$A6,$6C,$E4,$89,$A5,$6D,$E9
    !by $00,$90,$14,$85,$6D,$8A,$E5,$89
    !by $AA,$C8,$D0,$EF,$A5,$0F,$38,$E5
    !by $1E,$85,$0F,$A2,$00,$A0,$00,$86
    !by $6F,$84,$6E,$A5,$69,$85,$1C,$A5
    !by $68,$46,$1C,$6A,$46,$1C,$6A,$18
    !by $65,$0B,$85,$0B,$C6,$0F,$60,$00
    !by $04,$00,$04,$04,$00,$0C,$08,$08
    !by $0C,$00,$04,$0C,$0C,$04,$04,$AD
    !by $00,$17,$F0,$17,$A0,$00,$84,$35
    !by $84,$52,$B9,$00,$18,$10,$05,$20
    !by $0F,$B1,$B0,$07,$A4,$52,$20,$26
    !by $9E,$90,$ED,$60,$A0,$01,$B1,$58
    !by $C9,$22,$F0,$07,$C8,$C0,$11,$90
    !by $F5,$B0,$0B,$98,$A6,$58,$A4,$59
    !by $20,$BD,$FF,$20,$A8,$B0,$60,$A9
    !by $00,$85,$85,$20,$CD,$A9,$C9,$02
    !by $90,$2E,$C9,$0D,$F0,$2D,$C9,$22
    !by $F0,$32,$20,$96,$B2,$A2,$08,$CA
    !by $30,$E9,$DD,$A7,$A7,$D0,$F8,$8A
    !by $48,$20,$F3,$B2,$AA,$68,$E0,$00
    !by $F0,$D9,$A8,$0A,$AA,$BD,$AE,$A7
    !by $48,$BD,$AD,$A7,$48,$A5,$1A,$60
    !by $20,$E5,$A9,$20,$EE,$A9,$85,$58
    !by $84,$59,$18,$60,$A5,$70,$09,$08
    !by $85,$70,$20,$EE,$A9,$85,$58,$84
    !by $59,$38,$60,$48,$56,$4B,$5A,$2D
    !by $4E,$B8,$A7,$B8,$A7,$B8,$A7,$BE
    !by $A7,$C6,$A7,$CC,$A7,$99,$79,$00
    !by $4C,$57,$A7,$85,$7F,$20,$AA,$AE
    !by $4C,$57,$A7,$4A,$66,$7D,$4C,$57
    !by $A7,$85,$72,$4C,$57,$A7,$A5,$85
    !by $85,$86,$A9,$00,$85,$85,$85,$88
    !by $85,$89,$85,$87,$20,$CD,$A9,$20
    !by $F9,$A9,$C9,$0D,$D0,$05,$A9,$00
    !by $85,$84,$60,$20,$B8,$A8,$90,$45
    !by $24,$70,$50,$41,$C9,$20,$D0,$1E
    !by $A4,$85,$C4,$86,$B0,$03,$20,$B7
    !by $AB,$20,$9B,$AA,$E6,$89,$A5,$6F
    !by $C5,$89,$A5,$68,$65,$6E,$85,$68
    !by $90,$23,$E6,$69,$B0,$1F,$90,$1D
    !by $CD,$03,$3C,$B0,$18,$A5,$7D,$0A
    !by $0A,$0A,$A5,$61,$90,$09,$A4,$85
    !by $C4,$86,$90,$03,$18,$69,$08,$20
    !by $CF,$AA,$20,$9B,$AA,$A4,$85,$C4
    !by $86,$90,$A1,$24,$70,$50,$09,$24
    !by $7D,$50,$05,$A9,$2D,$20,$CF,$AA
    !by $60,$A9,$00,$85,$8C,$85,$8D,$20
    !by $E2,$AE,$B0,$4C,$A9,$58,$85,$62
    !by $A9,$30,$38,$E5,$78,$E5,$8C,$B0
    !by $02,$A9,$00,$4A,$69,$49,$85,$64
    !by $A9,$00,$85,$63,$85,$65,$85,$68
    !by $85,$69,$85,$67,$85,$6E,$85,$85
    !by $85,$38,$85,$76,$A9,$64,$85,$66
    !by $A9,$04,$85,$70,$A4,$85,$C0,$13
    !by $B0,$16,$E6,$85,$B9,$A5,$A8,$85
    !by $61,$20,$A7,$AA,$B0,$0A,$A5,$61
    !by $20,$CF,$AA,$20,$9B,$AA,$90,$E4
    !by $60 
	!tx "The Quick Brown Fox"
	

LA8B8:
    cmp #$20
    bcs LA8C7
    ldx #$10

LA8BE:
    cmp $A8D4,X
    beq LA8C8
    dex
    bpl LA8BE
    sec

LA8C7:
    rts

LA8C8:
    txa
    asl
    tay
    lda $A8E6,Y
    pha
    lda $A8E5,Y
    pha
    rts
    ; data
    !by $03,$04,$05,$0B,$0C,$18,$19,$0E
    !by $06,$07,$08,$0A,$0F,$1A,$10,$11
    !by $12,$2A,$A9,$2A,$A9,$2A,$A9,$2A
    !by $A9,$2A,$A9,$0C,$A9,$0C,$A9,$2A
    !by $A9,$3E,$A9,$46,$A9,$4C,$A9,$86
    !by $A9,$A0,$A9,$06,$A9,$55,$A9,$36
    !by $A9,$AC,$A9,$A9,$00,$85,$82,$F0
    !by $23,$A9,$02,$95,$72,$A4,$85,$B1
    !by $58,$C9,$30,$90,$12,$C9,$39,$B0
    !by $0E,$20,$CD,$A9,$29,$0F,$95,$72
    !by $BD,$D4,$90,$05,$81,$D0,$05,$BD
    !by $D4,$90,$45,$81,$85,$81,$20,$2C
    !by $AA,$18,$60,$A5,$82,$49,$80,$85
    !by $82,$18,$60,$A5,$7C,$09,$20,$85
    !by $7C,$18,$60,$E6,$88,$A5,$88,$D0
    !by $04,$E6,$84,$A5,$84,$20,$74,$AA
    !by $18,$60,$20,$47,$A9,$A4,$85,$84
    !by $26,$B1,$58,$C9,$21,$90,$22,$C9
    !by $2E,$F0,$1E,$C9,$2C,$F0,$1A,$20
    !by $A7,$AA,$85,$1C,$A5,$68,$38,$E5
    !by $1C,$AA,$A5,$69,$E9,$00,$90,$09
    !by $86,$68,$85,$69,$A4,$26,$C8,$D0
    !by $D6,$18,$60,$20,$F3,$B2,$A4,$69
    !by $A5,$68,$38,$E5,$1A,$B0,$08,$88
    !by $C0,$FF,$D0,$03,$A9,$00,$A8,$85
    !by $68,$84,$69,$18,$60,$20,$F3,$B2
    !by $A5,$1A,$85,$7F,$20,$AA,$AE,$18
    !by $60,$A5,$72,$85,$1A,$A9,$00,$85
    !by $1B,$20,$C0,$B2,$8A,$49,$03,$85
    !by $87,$A2,$02,$A0,$00,$B9,$01,$02
    !by $9D,$C1,$02,$C8,$CA,$10,$F6,$18
    !by $60,$A4,$87,$F0,$07,$C6,$87,$B9
    !by $C0,$02,$D0,$0A,$A4,$85,$B1,$58
    !by $E6,$85,$D0,$02,$E6,$59,$85,$61
    !by $60,$A5,$85,$D0,$02,$C6,$59,$C6
    !by $85,$60,$A5,$85,$18,$65,$58,$A4
    !by $59,$90,$01,$C8,$60,$A4,$83,$C9
    !by $41,$26,$83,$C9,$5E,$26,$83,$C9
    !by $61,$26,$83,$C9,$7F,$26,$83,$A6
    !by $83,$E0,$E8,$D0,$06,$18,$69,$20
    !by $85,$61,$60,$38,$60,$85,$1C,$A5
    !by $7D,$29,$9F,$05,$1C,$85,$7D,$86
    !by $6A,$84,$6B,$A5,$85,$85,$86,$60

LAA2C:
    ldx $3C02
    ldy $3C76
    lda $81
    lsr
    bcc LAA3D
    txa
    asl
    tax
    tya
    asl
    tay

LAA3D:
    lda #$04
    bit $81
    beq LAA46
    inx
    inx
    iny

LAA46:
    cpx $8C
    bcc LAA4C
    stx $8C

LAA4C:
    cpy $8D
    bcc LAA52
    sty $8D

LAA52:
    rts
    ; data
    !by $A4,$84,$B9,$45,$03,$85,$1C,$06
    !by $1C,$A9,$00,$2A,$06,$1C,$2A,$A8
    !by $A6,$1C,$E4,$66,$E5,$67,$90,$04
    !by $A2,$00,$A0,$00,$86,$68,$84,$69
    !by $60,$C9,$10,$B0,$22,$A8,$B9,$45
    !by $03,$85,$1C,$06,$1C,$A9,$00,$2A
    !by $06,$1C,$2A,$A8,$A6,$1C,$E4,$68
    !by $E5,$69,$90,$0B,$98,$E4,$66,$E5
    !by $67,$B0,$04,$86,$68,$84,$69,$60
    !by $A5,$61,$20,$A7,$AA,$B0,$04,$86
    !by $68,$84,$69,$60

LAAA7:
    tax
    lda $3BE4,X
    clc
    adc $79
    clc
    bpl LAAB3
    lda #$00

LAAB3:
    bit $81
    bpl LAAB8
    asl

LAAB8:
    bit $81
    bvc LAABE
    adc #$01

LAABE:
    pha
    adc $68
    tax
    lda $69
    adc #$00
    tay
    txa
    cmp $66
    tya
    sbc $67
    pla
    rts
    ; data
    !by $48,$20,$B7,$AB,$68,$38,$E9,$20
    !by $A8,$A6,$75,$20,$36,$B3,$8A,$18
    !by $65,$73,$85,$08,$98,$65,$74,$85
    !by $09,$A5,$81,$4A,$29,$08,$F0,$0D
    !by $A5,$64,$38,$E5,$76,$AA,$A5,$65
    !by $E9,$00,$A8,$B0,$16,$AD,$76,$3C
    !by $90,$01,$0A,$85,$1C,$A5,$8D,$38
    !by $E5,$1C,$18,$65,$64,$AA,$A5,$65
    !by $69,$00,$A8,$A5,$81,$29,$08,$F0
    !by $08,$18,$8A,$65,$76,$AA,$90,$01
    !by $C8,$A5,$81,$29,$04,$F0,$0A,$CA
    !by $D0,$07,$88,$10,$04,$A2,$00,$A0
    !by $00,$86,$11,$84,$12,$A5,$62,$18
    !by $65,$68,$85,$0F,$A5,$63,$65,$69
    !by $85,$10,$24,$82,$10,$14,$AD,$02
    !by $3C,$4A,$46,$81,$B0,$02,$4A,$18
    !by $26,$81,$65,$0F,$85,$0F,$90,$02
    !by $E6,$10,$A9,$02,$24,$81,$F0,$14
    !by $A6,$78,$A4,$78,$A9,$00,$18,$20
    !by $02,$AC,$A2,$01,$A0,$01,$A9,$00
    !by $38,$20,$02,$AC,$A9,$04,$24,$81
    !by $F0,$34,$A0,$00,$A2,$00,$24,$82
    !by $10,$01,$E8,$A5,$77,$18,$20,$02
    !by $AC,$A0,$01,$A2,$00,$24,$82,$10
    !by $01,$E8,$A5,$77,$18,$20,$02,$AC
    !by $A0,$02,$A2,$00,$A5,$77,$18,$20
    !by $02,$AC,$A2,$01,$A0,$01,$38,$24
    !by $82,$10,$08,$E8,$B0,$05,$A2,$00
    !by $A0,$00,$18,$A9,$00,$4C,$02,$AC
    !by $A5,$81,$29,$20,$F0,$44,$AD,$02
    !by $3C,$4A,$4A,$4A,$65,$8D,$65,$64
    !by $85,$11,$A5,$65,$69,$00,$85,$12
    !by $A5,$62,$18,$65,$68,$85,$0F,$A5
    !by $63,$65,$69,$85,$10,$A5,$61,$20
    !by $A7,$AA,$A6,$61,$E0,$20,$D0,$02
    !by $65,$6E,$48,$A2,$00,$A0,$00,$20
    !by $85,$AC,$A9,$02,$24,$81,$F0,$09
    !by $A6,$78,$A4,$78,$68,$48,$20,$85
    !by $AC,$68,$60,$85,$25,$98,$29,$01
    !by $2A,$85,$1F,$20,$1F,$AD,$A0,$00
    !by $20,$73,$13,$24,$26,$30,$07,$98
    !by $48,$20,$B2,$AC,$68,$A8,$24,$82
    !by $10,$0D,$A5,$1F,$49,$02,$85,$1F
    !by $29,$02,$D0,$03,$20,$EB,$90,$A5
    !by $81,$4A,$90,$0E,$A5,$1F,$49,$80
    !by $85,$1F,$10,$06,$98,$38,$ED,$01
    !by $3C,$A8,$C4,$75,$F0,$3B,$E6,$02
    !by $D0,$02,$E6,$03,$E6,$0D,$A5,$0D
    !by $29,$07,$D0,$BC,$A5,$0D,$C9,$C8
    !by $B0,$17,$A5,$70,$4A,$29,$02,$AA
    !by $A5,$02,$18,$7D,$81,$AC,$85,$02
    !by $A5,$03,$7D,$82,$AC,$85,$03,$90
    !by $9F,$A9,$00,$85,$0D,$E6,$46,$98
    !by $48,$20,$60,$AD,$68,$A8,$4C,$0F
    !by $AC,$60,$78,$02,$38,$01,$48,$20
    !by $1F,$AD,$68,$AA,$4A,$4A,$4A,$A8
    !by $84,$26,$A8,$8A,$09,$F8,$AA,$A9
    !by $FF,$0A,$E8,$D0,$FC,$99,$00,$02
    !by $A9,$FF,$88,$10,$F8,$E6,$26,$A4
    !by $26,$A9,$00,$99,$00,$02,$85,$1F
    !by $4C,$0A,$AD,$E6,$26,$24,$81,$10
    !by $20,$06,$26,$A4,$26,$88,$84,$1C
    !by $A0,$04,$A5,$1C,$4A,$AA,$5E,$00
    !by $02,$08,$6A,$28,$6A,$88,$D0,$F6
    !by $A4,$1C,$99,$00,$02,$C6,$1C,$10
    !by $E7,$A4,$26,$A9,$00,$99,$00,$02
    !by $A6,$25,$F0,$06,$E6,$26,$C8,$99
    !by $00,$02,$24,$81,$50,$01,$E8,$8A
    !by $F0,$19,$85,$1C,$A2,$00,$A4,$26
    !by $18,$BD,$00,$02,$6A,$1D,$00,$02
    !by $9D,$00,$02,$E8,$88,$10,$F2,$C6
    !by $1C,$D0,$E9,$A5,$0A,$0A,$B0,$0D
    !by $A2,$00,$A4,$26,$7E,$00,$02,$E8
    !by $88,$10,$F9,$30,$F0,$4C,$97,$13
    !by $8A,$18,$65,$0F,$85,$0B,$A5,$10
    !by $69,$00,$85,$0C,$98,$18,$65,$11
    !by $85,$0D,$A5,$12,$69,$00,$85,$0E
    !by $A5,$70,$29,$04,$F0,$0C,$20,$92
    !by $90,$A9,$37,$85,$45,$A9,$02,$85
    !by $43,$60,$A2,$00,$A5,$0D,$38,$E9
    !by $C8,$A8,$A5,$0E,$E9,$00,$90,$07
    !by $84,$0D,$85,$0E,$E8,$B0,$ED,$86
    !by $46,$A9,$00,$85,$02,$A5,$0D,$4A
    !by $4A,$4A,$85,$03,$0A,$0A,$65,$03
    !by $4A,$66,$02,$85,$03,$A5,$0D,$29
    !by $07,$85,$1C,$A5,$0B,$29,$F8,$65
    !by $1C,$65,$02,$85,$02,$A5,$0C,$65
    !by $03,$A6,$46,$1D,$14,$83,$85,$03
    !by $BD,$0C,$83,$85,$45,$BD,$10,$83
    !by $85,$43,$A5,$0B,$29,$07,$A8,$B9
    !by $D4,$90,$85,$0A

LADA3:
    rts
    ; data
    !by $09,$06,$05,$20,$20,$2D,$2D,$2D
    !by $2D,$60,$A5,$61,$CD

LADB1:
    lda $61
    cmp $3C03
    bcs LADA3
    sec
    sbc #$20
    bcc LADA3
    tay
    ldx $75
    jsr LB336
    txa
    clc
    adc $73
    sta $08
    tya
    adc $74
    sta $09
    ldx #$02

LADD0:
    lda $0F,X
    sta $0B,X
    dex
    bpl LADD0
    jsr L9092
    ldy #$00
    sty $1F

LADDE:
    jsr $1373
    tya
    pha
    ldx $26
    bmi LAE30
    inx
    txa
    asl
    asl
    asl
    sta $20
    ldx #$00

LADF0:
    lda $02,X
    pha
    inx
    cpx #$0D
    bcc LADF0

LADF8:
    ldx $26

LADFA:
    rol $0200,X
    dex
    bpl LADFA
    ror
    pha
    jsr LAE86
    lda $49
    jsr LAE94
    pla
    bcc LAE28
    bit $81
    bpl LAE1D
    pha
    jsr LAE86
    lda $49
    jsr LAE94
    pla
    bcc LAE28

LAE1D:
    bit $81
    bvc LAE24
    jsr LAE86

LAE24:
    dec $20
    bne LADF8

LAE28:
    ldx #$0C

LAE2A:
    pla
    sta $02,X
    dex
    bpl LAE2A

LAE30:
    jsr LAE8F
    pla
    bcc LAE4B
    tay
    lda $81
    and #$01
    eor $1F
    sta $1F
    lsr
    bcc LAE47
    tya
    sbc $3C01
    tay

LAE47:
    cpy $75
    bcc LADDE

LAE4B:
    lda $61
    jsr LAAA7
    sta $1C
    lda $49
    and #$02
    eor #$02
    tax
    lda $49
    lsr
    lda $0F,X
    ldy $10,X
    bcs LAE77
    adc $1C
    bcc LAE67
    iny

LAE67:
    cmp $8C52,X
    bcc LAE7F
    pha
    tya
    cmp $8C53,X
    tay
    pla
    bcc LAE7F
    bcs LAE85

LAE77:
    sbc $1C
    bcs LAE7F
    sec
    dey
    bmi LAE85

LAE7F:
    sta $0F,X
    tya
    sta $10,X
    clc

LAE85:
    rts

LAE86:
    asl
    bcc LAE8E
    ldy #$00
    jsr L8C3D

LAE8E:
    rts

LAE8F:
    ldx $49
    lda $AEA6,X

LAE94:
    cmp #$02
    bcs LAEA3
    asl
    jsr L9133
    bcc LAEA2
    lda #$B7
    cmp $0D

LAEA2:
    rts

LAEA3:
    jmp L90E8
    ; data
    !by $03,$02,$00,$01

LAEAA:
    lda $7F
    bne LAEB2
    lda $80
    sta $7F

LAEB2:
    cmp $3C00
    beq LAEE1
    lda $3C00
    sta $80
    jsr $12F2
    bcc LAEC9
    jsr LB03C
    lda $7F
    sta $3C00

LAEC9:
    lda $3C77
    sta $79
    lda $3C02
    tay
    lsr
    lsr
    sta $76
    ldx $3C01
    jsr LB336
    stx $75
    jsr LAA2C

LAEE1:
    rts

LAEE2:
    jsr $12F2
    bcs LAEEB
    jsr LAEC9
    clc

LAEEB:
    rts

LAEEC:
    lda #$00
    sta $4A
    sta $34
    lda $29
    and #$FB
    sta $29
    lda #$80
    sta $38
    jsr $0F03
    jsr LAF0D
    jsr LB3B4
    lda $28
    jsr L80DE
    jmp LB285

LAF0D:
    lda #$BB
    sta $D011
    lda #$78
    sta $D018
    lda $DD00
    and #$FC
    ora #$02
    sta $DD00
    lda #$00
    sta $D01B
    sta $54
    sei
    lda $36
    ora #$01
    sta $36
    cli
    ldx #$FD
    stx $5FF8
    inx
    stx $5FF9
    inx
    stx $5FFA
    lda #$05

LAF3F:
    tax
    ldy $AF72,X
    ldx #$00
    cmp #$05
    bne LAF4B
    ldx #$40

LAF4B:
    lda $AF78,Y
    sta $02
    beq LAF71

LAF52:
    lda $AF79,Y
    sta $7F80,X
    inx
    lda $AF7A,Y
    sta $7F80,X
    inx
    lda $AF7B,Y
    sta $7F80,X
    inx
    dec $02
    bne LAF52
    iny
    iny
    iny
    iny
    bne LAF4B

LAF71:
    rts
    ; data
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
    !by $00,$01,$01,$FF,$FF,$FF,$00,$A9
    !by $00,$A0,$3F,$99,$40,$7F,$88,$10
    !by $FA,$60,$A2,$3F,$BD,$40,$7F,$9D
    !by $C0,$03,$CA,$10,$F7,$60,$A2,$3F
    !by $BD,$C0,$03,$9D,$40,$7F,$CA,$10
    !by $F7,$60,$A9,$12,$8D,$18,$D0,$A9
    !by $9B,$8D,$11,$D0,$AD,$00,$DD,$09
    !by $03,$8D,$00,$DD,$A9,$00,$A2,$3E
    !by $9D,$C0,$03,$CA,$10,$FA,$A9,$FF
    !by $8D,$EB,$03,$8D,$EE,$03,$A9,$0F
    !by $8D,$F9,$07,$A9,$02,$8D,$15,$D0
    !by $78,$A9,$80,$85,$19,$85,$17,$0A
    !by $85,$18,$A5,$36,$29,$FE,$85,$36
    !by $58,$60

LB03C:
    lda #$10
    jsr $0DE9
    tay
    lda $7F
    sta $1A
    lda #$00
    sta $1B
    ldx #$01
    jsr LB2A1
    tya
    ldx #$28
    ldy #$04
    jsr $FFBD
    lda #$5A
    jsr LB1C8
    bcs LB0A7
    ldy #$00

LB060:
    jsr $FFCF
    sta $3C00,Y
    iny
    cpy #$78
    bcc LB060
    ldx #$78
    ldy #$3C
    stx $73
    sty $74
    stx $02
    sty $03
    bit $70
    bpl LB0A4
    bvc LB0A4
    lda $7F
    cmp $7E
    beq LB0A4
    sta $7E
    lda #$00
    sta $26
    sta $27
    sta $1F

LB08D:
    jsr $119A
    ldy #$00
    sta ($02),Y
    inc $02
    bne LB09A
    inc $03

LB09A:
    lda $90
    beq LB08D
    lda $26
    ora $27
    bne LB08D

LB0A4:
    jsr LB222

LB0A7:
    rts
    ; data
    !by $A9,$54,$20,$C8,$B1,$B0,$5F,$A2
    !by $01,$A0,$19,$86,$5A,$84,$5B,$86
    !by $58,$84,$59,$20,$CF,$FF,$A0,$00
    !by $91,$5A,$AA,$F0,$19,$E6,$5A,$D0
    !by $F2,$E6,$5B,$A5,$5B,$C9,$3C,$90
    !by $EA,$C6,$5B,$C6,$5A,$A9,$00,$A8
    !by $91,$5A,$A9,$05,$B0,$25,$8D,$00
    !by $17,$20,$CF,$FF,$AA,$F0,$FA,$A9
    !by $18,$E0,$4C,$38,$D0,$15,$20,$CF
    !by $FF,$8D,$00,$17,$A0,$00,$20,$CF
    !by $FF,$99,$00,$18,$C8,$CC,$00,$17
    !by $90,$F4,$18,$48,$08,$20,$22,$B2
    !by $28,$68,$90,$02,$85,$71,$60,$A2
    !by $20,$A4,$52,$B9,$00,$18,$29,$60
    !by $C9,$60,$F0,$07,$18,$24,$70,$50
    !by $34,$A2,$00,$86,$1F,$20,$B9,$B1
    !by $A9,$00,$20,$C8,$B1,$B0,$26,$24
    !by $70,$50,$1E,$A4,$52,$B9,$01,$18
    !by $4A,$85,$2B,$18,$65,$23,$C9,$51
    !by $B0,$0F,$B9,$02,$18,$4A,$85,$2A
    !by $65,$22,$C9,$65,$B0,$03,$20,$34
    !by $11,$20,$22,$B2,$18,$60

LB156:
    lda $1F
    and #$20
    beq LB1B8
    jsr $FFCF
    cmp #$4B
    bne LB1B8
    ldx #$07

LB165:
    ldy $023D,X
    iny
    bne LB16E
    dex
    bne LB165

LB16E:
    lda $22
    asl
    asl
    sta $1C
    lda #$00
    rol
    sta $1D
    txa
    asl
    tay
    lda $0246,Y
    sta $02
    clc
    adc $1C
    sta $04
    sta $0248,Y
    lda $0247,Y
    sta $03
    adc $1D
    cmp #$08
    bcs LB1B8
    sta $05
    sta $0249,Y
    lda $52
    sta $023E,X
    ldy $02
    lda #$00
    sta $02

LB1A4:
    jsr $FFCF
    eor #$FF
    sta ($02),Y
    iny
    bne LB1B0
    inc $03

LB1B0:
    cpy $04
    lda $03
    sbc $05
    bcc LB1A4

LB1B8:
    rts
    ; data
    !by $98,$18,$69,$05,$AA,$B9,$00,$18
    !by $29,$1F,$A0,$18,$4C,$BD,$FF

LB1C8:
    sta $24
    lda $B7
    ldx $BB
    ldy $BC
    jsr LB231
    lda #$00

LB1D5:
    pha
    lda $24
    bne LB1E1
    jsr L8471
    bcs LB1F2
    pla
    rts

LB1E1:
    ldy #$00
    jsr LB209
    bcs LB1F2
    jsr $FFCF
    cmp $24
    bne LB1F2
    pla
    clc
    rts

LB1F2:
    jsr LB222
    pla
    bne LB203

LB1F8:
    jsr $0E2D
    cmp #$AD
    beq LB1D5
    cmp #$B3
    bne LB1F8

LB203:
    lda #$1A
    sta $71
    sec
    rts

LB209:
    tya
    pha
    lda #$08
    tax
    jsr $FFBA
    jsr $FFC0
    ldx #$08
    pla
    bcs LB221
    bne LB21E
    jmp $FFC6

LB21E:
    jsr $FFC9

LB221:
    rts

LB222:
    jsr $FFCC
    lda #$08
    jmp $FFC3
    ; data
    !by $20,$E9,$0D,$A2,$28,$A0,$04

LB231:
    stx $02
    sty $03
    ldx #$C0
    ldy #$79
    stx $06
    sty $07
    pha
    jsr LB27A
    pla

LB242:
    sta $1C
    ldy #$00

LB246:
    lda #$01
    sta $09
    lda ($02),Y
    asl
    rol $09
    asl
    rol $09
    asl
    rol $09
    sta $08
    tya
    pha
    ldy #$07
    lda ($08),Y
    bne LB262
    dey

LB260:
    lda ($08),Y

LB262:
    sta ($06),Y
    dey
    bpl LB260
    lda $06
    clc
    adc #$08
    sta $06
    bcc LB272
    inc $07

LB272:
    pla
    tay
    iny
    cpy $1C
    bcc LB246
    rts

LB27A:
    ldy #$7F
    lda #$00

LB27E:
    sta $79C0,Y
    dey
    bpl LB27E
    rts

LB285:
    lda $CB
    cmp #$40
    bne LB285
    lda $3F
    and #$07
    bne LB285
    lda #$00
    sta $C6
    rts
    ; data
    !by $C9,$7E,$B0,$06,$C9,$61,$90,$02
    !by $E9,$20,$60

LB2A1:
    tya
    pha
    ldy #$28
    jsr LB336
    stx $02
    tya
    ora #$04
    sta $03
    jsr LB2C0
    pla
    tay

LB2B4:
    lda $0201,X
    sta ($02),Y
    iny
    inx
    cpx #$03
    bcc LB2B4
    rts

LB2C0:
    ldx #$02

LB2C2:
    lda #$00
    ldy #$10

LB2C6:
    rol $1A
    rol $1B
    rol
    cmp #$0A
    bcc LB2D1
    sbc #$0A

LB2D1:
    dey
    bne LB2C6
    rol $1A
    rol $1B
    ora #$30
    sta $0201,X
    dex
    bpl LB2C2
    inx

LB2E1:
    lda $0201,X
    cmp #$30
    bne LB2F2
    lda #$1F
    sta $0201,X
    inx
    cpx #$02
    bcc LB2E1

LB2F2:
    rts
    ; data
    !by $A2,$00,$86,$1F,$86,$1A,$20,$CD
    !by $A9,$E0,$00,$D0,$0C,$C9,$3D,$F0
    !by $F5,$C9,$2D,$D0,$04,$66,$1F,$30
    !by $ED,$38,$E9,$30,$90,$16,$C9,$0A
    !by $B0,$12,$48,$A5,$1A,$0A,$0A,$65
    !by $1A,$0A,$85,$1A,$68,$65,$1A,$85
    !by $1A,$E8,$D0,$D2,$06,$1F,$90,$06
    !by $A9,$00,$E5,$1A,$85,$1A,$20,$E5
    !by $A9,$8A,$60

LB336:
    stx $1C
    sty $1D
    lda #$00
    ldy #$08

LB33E:
    asl
    rol $1D
    bcc LB34A
    clc
    adc $1C
    bcc LB34A
    inc $1D

LB34A:
    dey
    bne LB33E
    tax
    ldy $1D
    rts
    ; data
    !by $1E,$A0,$10,$06,$1C,$26,$1D,$26
    !by $1E,$38,$A5,$1E,$E5,$26,$90,$04
    !by $85,$1E,$E6,$1C,$88,$D0,$EC,$60
    !by $86,$27,$84

LB36C:
    stx $27
    sty $26
    sta $1C
    ror $1D

LB374:
    lda $09
    pha
    lda $08
    pha
    ldx $26

LB37C:
    ldy #$07
    lda $1C

LB380:
    bit $1D
    bmi LB386
    lda ($02),Y

LB386:
    sta ($08),Y
    dey
    bpl LB380
    lda $02
    clc
    adc #$08
    sta $02
    bcc LB396
    inc $03

LB396:
    lda $08
    clc
    adc #$08
    sta $08
    bcc LB3A1
    inc $09

LB3A1:
    dex
    bne LB37C
    pla
    clc
    adc #$40
    sta $08
    pla
    adc #$01
    sta $09
    dec $27
    bne LB374
    rts

LB3B4:
    lda $1704
    lsr
    lsr
    lsr
    lsr
    sta $D027
    lda #$00
    sta $02
    lda #$5C
    sta $03
    ldx #$18
    ldy #$27
    lda $1704
    sty $1C

LB3CF:
    ldy $1C

LB3D1:
    sta ($02),Y
    dey
    bpl LB3D1
    pha
    lda $02
    clc
    adc #$28
    sta $02
    bcc LB3E2
    inc $03

LB3E2:
    pla
    dex
    bpl LB3CF
    rts
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
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    !by $FF
}
