; All-in-one ACME source for 1-rom-0.bin
!to "1-rom-0-cs.rebuilt.bin", plain
* = 0

; --- $0000-$1316 ---
!pseudopc $8000 {
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
    ora $0401,x
    brk
    !by $07,$12,$22    ; 8845
    plp

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
    ldy #$12

L88ED:
    dey
    bmi L88FA
    cmp $8932,y
    bne L88ED
    lda $8944,y
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
    brk
    rts
    jsr $6020
    rti
    brk
    brk
    brk
    brk
    brk
    brk
    rti
    brk
    brk
    brk
    sbc ($E6),y
    sbc $DFEE
    !by $DB,$EB,$EF    ; 8937
    cpx $DDDC
    adc $7B7A,y
    adc $76
    sei
    !by $7C    ; 8943
    ora ($02,x)
    !by $04    ; 8946
    ora $06
    !by $07    ; 8949
    php
    !by $0B,$0C    ; 894B
    ora $5B10
    !by $5C    ; 8950
    eor $7C7B,x
    adc $207E,x
    !by $CF,$FF    ; 8957
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
}


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

*=$2000

	!by $04,$A0,$04,$A0,$A2,$08,$BD,$12,$A0,$9D,$40
    !by $03,$CA,$10,$F7,$4C,$40,$03,$A9,$FF,$8D,$80,$DE,$4C,$E2,$FC,$FF
    !by $80,$80,$80,$80,$80,$80,$80,$FF,$00,$00,$00,$00,$00,$00,$00,$FF
    !by $00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$FF
    !by $00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$FF
    !by $00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$FF
    !by $00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$FF
    !by $00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$FF
    !by $00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$FF
    !by $80,$80,$80,$80,$80,$80,$80,$FF,$00,$00,$00,$00,$3E,$02,$04,$FF
    !by $00,$00,$00,$00,$78,$84,$80,$FF,$00,$00,$00,$00,$00,$10,$10,$FF
    !by $80,$80,$80,$80,$80,$80,$80,$FF,$01,$01,$01,$01,$01,$01,$01,$80
    !by $80,$80,$80,$80,$80,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$9F
    !by $80,$80,$80,$80,$80,$80,$80,$08,$10,$20,$3E,$00,$00,$00,$00,$78
    !by $04,$84,$78,$00,$00,$00,$00,$7C,$10,$10,$00,$00,$00,$00,$00,$80
    !by $80,$80,$80,$80,$80,$80,$80,$01,$01,$01,$01,$01,$01,$01,$01,$80
    !by $80,$80,$80,$80,$80,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF
    !by $80,$80,$80,$80,$80,$80,$80,$FF,$00,$00,$00,$03,$06,$0D,$0B,$FF
    !by $00,$00,$00,$C0,$60,$B0,$D0,$FF,$00,$00,$00,$00,$00,$10,$10,$80
    !by $80,$88,$8C,$86,$83,$8F,$8F,$01,$01,$21,$61,$C1,$81,$E1,$E1,$80
    !by $80,$80,$80,$80,$80,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$9F
    !by $80,$80,$80,$80,$80,$80,$80,$0B,$08,$0B,$0A,$0E,$00,$00,$00,$D0
    !by $10,$D0,$50,$70,$00,$00,$00,$7C,$10,$10,$00,$00,$00,$00,$00,$80
    !by $87,$8F,$88,$88,$88,$8F,$87,$01,$C1,$E1,$21,$21,$21,$E1,$C1,$80
    !by $80,$80,$80,$80,$80,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF
    !by $80,$80,$80,$80,$80,$80,$9F,$FF,$00,$00,$00,$03,$04,$08,$09,$FF
    !by $00,$00,$00,$00,$80,$C0,$60,$FF,$00,$00,$00,$00,$10,$10,$7C,$80
    !by $80,$80,$80,$80,$80,$80,$80,$01,$01,$01,$01,$01,$01,$01,$01,$80
    !by $80,$80,$80,$80,$80,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    !by $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80
    !by $80,$80,$80,$80,$80,$80,$80,$0F,$0A,$0B,$02,$02,$00,$00,$00,$D0
    !by $50,$D0,$10,$10,$00,$00,$00,$10,$10,$00,$00,$00,$00,$00,$00,$80
    !by $80,$80,$80,$80,$80,$80,$80,$01,$01,$01,$01,$01,$01,$01,$01,$FF
    !by $80,$80,$80,$80,$BE,$82,$84,$FF,$00,$00,$00,$00,$78,$84,$80,$FF
    !by $80,$80,$80,$80,$81,$83,$86,$FF,$00,$00,$00,$00,$C0,$60,$30,$FF
    !by $80,$80,$80,$80,$83,$8C,$B0,$FF,$00,$00,$00,$00,$C0,$30,$0C,$FF
    !by $81,$81,$82,$82,$84,$84,$84,$FF,$80,$80,$40,$40,$20,$20,$20,$FF
    !by $80,$80,$80,$80,$81,$82,$84,$FF,$00,$00,$00,$00,$80,$40,$20,$FF
    !by $80,$80,$80,$80,$80,$80,$81,$FF,$00,$00,$00,$00,$70,$88,$08,$FF
    !by $80,$80,$80,$81,$83,$86,$85,$FF,$00,$00,$00,$E0,$30,$D8,$E8,$FF
    !by $80,$80,$80,$80,$83,$84,$88,$FF,$00,$00,$00,$00,$00,$80,$C0,$FF
    !by $80,$81,$82,$82,$83,$82,$82,$FF,$00,$C0,$20,$20,$E0,$20,$20,$FF
    !by $80,$80,$80,$80,$80,$80,$80,$FF,$01,$01,$01,$01,$01,$01,$01,$88
    !by $90,$A0,$BE,$80,$80,$80,$FF,$78,$04,$84,$78,$00,$00,$00,$FF,$86
    !by $87,$86,$86,$80,$80,$80,$FF,$30,$F0,$30,$30,$00,$00,$00,$FF,$B0
    !by $BF,$B0,$B0,$80,$80,$80,$FF,$0C,$FC,$0C,$0C,$00,$00,$00,$FF,$84
    !by $87,$87,$84,$84,$84,$84,$FF,$20,$E0,$E0,$20,$20,$20,$20,$FF,$84
    !by $87,$84,$84,$80,$9F,$80,$FF,$20,$E0,$20,$20,$00,$F8,$00,$FF,$81
    !by $83,$82,$84,$80,$80,$80,$FF,$08,$F0,$10,$20,$00,$00,$00,$FF,$85
    !by $84,$85,$85,$87,$80,$80,$FF,$E8,$08,$E8,$28,$38,$00,$00,$FF,$89
    !by $8F,$8A,$8B,$82,$82,$80,$FF,$60,$D0,$50,$D0,$10,$10,$00,$FF,$80
    !by $80,$80,$80,$80,$80,$80,$FF,$00,$00,$00,$00,$00,$00,$00,$FF,$80
    !by $83,$84,$84,$87,$84,$84,$FF,$01,$81,$41,$41,$C1,$41,$41,$FF,$FF
    !by $80,$80,$80,$80,$8F,$88,$8A,$FF,$00,$E0,$50,$28,$F8,$28,$A0,$FF
    !by $80,$80,$80,$80,$BC,$A5,$A5,$FF,$00,$00,$00,$00,$1E,$12,$92,$FF
    !by $80,$80,$80,$80,$80,$81,$81,$FF,$00,$00,$00,$00,$1E,$12,$92,$FF
    !by $80,$80,$81,$87,$8A,$9F,$81,$FF,$00,$00,$E0,$58,$AC,$FE,$20,$FF
    !by $80,$80,$80,$80,$80,$80,$80,$FF,$00,$00,$00,$00,$00,$00,$00,$FF
    !by $80,$80,$81,$83,$80,$8F,$8F,$FF,$00,$80,$C0,$E0,$00,$F8,$78,$FF
    !by $80,$83,$81,$80,$80,$8F,$8F,$FF,$00,$E0,$C0,$80,$00,$F8,$78,$FF
    !by $80,$80,$80,$8F,$8F,$8F,$8F,$FF,$00,$00,$00,$F8,$78,$78,$F8,$FF
    !by $80,$9F,$91,$91,$91,$91,$91,$FF,$00,$7C,$44,$44,$44,$44,$44,$FF
    !by $80,$E0,$90,$9F,$98,$94,$94,$FF,$01,$01,$01,$FD,$07,$05,$0D,$8A
    !by $8A,$8A,$8A,$88,$8F,$80,$FF,$A0,$A0,$A0,$A0,$20,$E0,$00,$FF,$A5
    !by $A5,$A5,$BC,$80,$80,$80,$FF,$D2,$92,$12,$1E,$00,$00,$00,$FF,$81
    !by $81,$81,$80,$80,$80,$80,$FF,$D2,$92,$12,$1E,$00,$00,$00,$FF,$81
    !by $81,$82,$82,$82,$81,$80,$FF,$20,$20,$20,$20,$20,$C0,$00,$FF,$80
    !by $80,$80,$82,$82,$81,$80,$FF,$00,$00,$00,$C0,$20,$C0,$00,$FF,$8F
    !by $8F,$8E,$8F,$8F,$8F,$80,$FF,$78,$F8,$38,$F8,$F8,$F8,$00,$FF,$8F
    !by $8F,$8E,$8F,$8F,$8F,$80,$FF,$78,$F8,$38,$F8,$F8,$F8,$00,$FF,$8E
    !by $8F,$8F,$8F,$80,$80,$80,$FF,$38,$F8,$F8,$F8,$00,$00,$00,$FF,$91
    !by $91,$91,$91,$91,$9F,$80,$FF,$44,$44,$44,$44,$44,$7C,$00,$FF,$94
    !by $94,$98,$9F,$91,$E2,$84,$FF,$15,$25,$45,$FD,$01,$01,$01,$FF

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

; --- $28F5-$2FFF ---
    !by $00,$00

*=$3000

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
	
*=$4000

