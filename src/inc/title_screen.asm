.segment "CODE"
titlescreen:
    lda #255
    sta solidfound
    lda #10
    jsr starttune

stillintitle:
    inc solidfound
    lda solidfound
    and #3
    sta solidfound
    and #1
    beq showtitle
sethiscore:
    lda solidfound
    and #127
    lsr
    eor #255
    sta hipos
 	jsr setuphiscores
 	jmp turnonscreen
showtitle:
    jsr setuptitlescreen
turnonscreen:
    jsr turninteron
waitforstart:
    flybackvar
    lda solidfound
;	bmi conttitleloop
    and #1
    bne notshowingtitle
    jsr putontitlesprites
    jmp conttitleloop
notshowingtitle:
    ldx #$0d
    jsr pulsecolour

conttitleloop:
    lda tune
    bne @2
    lda #1
    jsr starttune
@2:
    lda counter
    and #7
    bne @1
    dec robiny
    bne @1
    lda #$fb
    sta fadecounter
@1:
    jsr waitforstartkey
    beq waitforstart
    lda solidfound
    bpl stillintitle
    rts

putontitlesprites:
    lda control0
    eor #8+16
    waitforsprcol
    sta _control0
    ldx #$19
    jsr pulsecolour

    ldx #16
    ldy #16-ydisplace
    lda #titlelogos
    jsr printsprite
    
	;; ldx #176
	;; ldy #26*8+2-ydisplace
	;; lda #titlelogos+1
	;; jsr printsprite
    
    ldx #128-8
    ldy #24*8-ydisplace
    lda #titlelogos+2
    jmp printsprite
;--------------------------------------------
setuptitlescreen:
    lda #titletopchrs_index
    jsr copyblockofcompactedchrs
    lda #titlebotchrs_index
    jsr copyblockofcompactedchrs
    ldxy titlescreenmess
    jsr prtmessage
    jsr clearspriteblock
    lda #16*8-1-8
    sta spriteblock
    lda #$f3
    sta spriteblock+1
    lda #3	
    sta spriteblock+2
    lda #225
    sta spriteblock+3
    lda #100
    sta robiny
    ldxy titlescreencolours
    jmp setfade
;--------------------------------------------
titlescreencolours:
    .byte $0e, $09, $17, $27
    .byte $0e, $21, $09, $19
    .byte $0e, $21, $17, $38
    .byte $0e, $21, $00, $20
    
    .byte $0e, $27, $11, $0e
    .byte $0e, $20, $15, $0e
    .byte $0e, $00, $00, $00
    .byte $0e, $0e, $0e, $0e
titlescreenmess:
    .byte mgosub
    .word clearscr
    .byte maddr+$20,$0a
    .byte $01, $02, $05, $07, $08, $02, $05, $07, $08, $12, $1E, $1F
    .byte mloop,10,$20,mendloop,mdownline
    .byte $03, $04, $09, $0A, $0B, $04, $09, $13, $14, $15, $21, $22 
    .byte mloop,10,$20,mendloop,mdownline
    .byte $00, $05, $0C, $0D, $0E, $0F, $16, $17, $18, $19, $23, $24 
    .byte mloop,10,$20,mendloop,mdownline
    .byte $00, $06, $05, $03, $10, $11, $1A, $1B, $1C, $1D, $25, $26, $27, $28, $29, $2A
    .byte mloop,6,$20,mendloop,mdownline
    .byte $00, $00, $00, $00, $2D, $2E, $32, $33, $34, $35, $40, $41, $42, $43, $50, $51, $52, $53, $60, $61, $20, $20
    .byte mdownline
    .byte $00, $00, $06, $03, $2F, $05, $36, $37, $34, $38, $44, $45, $46, $47, $54, $55, $56, $57, $62, $63, $64, $20
    .byte maddr+$20,$c6,mloop,5,0,mendloop 
    .byte $06, $03, $30, $05, $01, $39, $3A, $34, $3B, $48, $49, $4A, $4B, $58, $59, $5A, $5B, $65, $66, $67, $20
    .byte mdownline
    .byte $00, $00, $2B, $2C, $00, $06, $30, $01, $31, $05, $3C, $3D, $3E, $3F, $4C, $4D, $4E, $4F, $5C, $5D, $5E, $5F, $34, $68, $69, $20
    .byte mdownline,mlen,26
    .byte $00, $2C, $6F, $70, $71, $72, $02, $05, $07, $08, $7E, $7F, $80, $81, $83, $84, $85, $86, $8C, $8D, $8E, $8F, $34, $94, $20, $20
    .byte mdownline,mlen,26
    .byte $2B, $6A, $6F, $70, $73, $74, $04, $09, $0A, $0B, $1F, $20, $20, $20, $20, $87, $88, $89, $90, $91, $92, $93, $95, $96, $20, $20
    .byte mjump
    .addr titlescreenmess2
titlescreenmess2:
    .byte mdownline,mlen,26
    .byte $6B, $6C, $70, $75, $76, $77, $79, $0C, $0D, $7A, $82, $20, $20, $20, $87, $20, $20, $20, $20, $20, $20, $20, $97, $98, $99, $20
    .byte mdownline,mlen,26
    .byte $6D, $6E, $78, $00, $00, $2B, $2C, $7B, $7C, $7D, $20, $20, $20, $20, $8A, $8B, $87, $20, $20, $20, $20, $20, $9A, $9B, $20, $20
    .byte mdownline,mlen,26
    .byte $00, $00, $00, $A6, $6A, $6F, $70, $B2, $20, $B3, $BC, $BD, $20, $BE, $C8, $C9, $CA, $CB, $D1, $D2, $20, $20, $20, $20, $20, $20
    .byte mdownline,mlen,26 
    .byte $00, $A0, $A7, $A8, $A9, $AA, $B4, $B5, $B6, $B7, $34, $BF, $C0, $C1, $CC, $CD, $CE, $CF, $34, $D3, $BD, $20, $20, $20, $20, $20
    .byte mdownline,mlen,26+3*32
    .byte $A1, $A2, $AB, $AC, $AD, $AE, $B8, $34, $34, $34, $34, $34, $C2, $C3, $00, $00, $00, $D0, $D4, $D5, $BF, $D6, $DA, $20, $20, $20
    .byte $9C, $9D, $9E, $9F, $A3, $A4, $A5, $20, $20, $AF, $B0, $B1, $B9, $BA, $BB, $34, $C4, $C5, $C6, $C7, $00, $00, $00, $00, $D7, $D8, $B0, $D9, $DB, $20, $20, $20
    .byte $01, $02, $03, $04, $09, $0A, $0B, $0C, $11, $11, $11, $11, $11, $11, $16, $17, $18, $19, $1A, $00, $00, $00, $00, $00, $1C, $1D, $1E, $11, $11, $11, $11, $11
    .byte $05, $06, $07, $08, $0D, $0E, $0F, $10, $12, $13, $14, $15, $15, $11, $11, $11, $11, $11, $1B, $00, $00, $00, $00, $00, $00, $1F, $11, $11, $11, $11, $11, $11
    .byte mjump
    .addr titlescreenmess3
titlescreenmess3:
    .byte mlen,6*32+15
    .byte $20, $21, $22, $23, $28, $29, $2A, $2B, $30, $31, $32, $33, $35, $36, $37, $11, $11, $11, $3C, $00, $00, $00, $00, $00, $00, $40, $41, $42, $11, $45, $46, $47
    .byte $24, $25, $26, $27, $2C, $2D, $2E, $2F, $34, $34, $34, $34, $38, $39, $3A, $3B, $3D, $3E, $3F, $00, $00, $00, $00, $00, $00, $00, $43, $44, $48, $49, $49, $49
    .byte $4A, $4B, $4C, $4D, $5A, $5B, $5C, $5D, $11, $11, $11, $11, $11, $11, $6C, $6D, $6E, $6F, $70, $00, $00, $00, $00, $00, $00, $00, $00, $7D, $82, $83, $84, $85
    .byte $4E, $4F, $50, $51, $5E, $5F, $60, $61, $11, $11, $11, $11, $11, $11, $34, $34, $71, $72, $73, $74, $76, $77, $78, $00, $00, $00, $00, $7E, $34, $34, $86, $87
    .byte $52, $53, $54, $55, $62, $63, $64, $65, $6A, $11, $11, $11, $11, $11, $34, $34, $34, $34, $34, $75, $79, $7A, $7B, $7C, $7F, $7C, $80, $81, $88, $89, $8A, $8B
    .byte $56, $57, $58, $59, $66, $67, $68, $69, $6B, $11, $11, $11, $11, $11, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $8C, $8D, $8E, $8F
    .byte $90, $91, $92, $93, $9F, $A0, $A1, $A2, $AE, $AF, $B0, $11, $11, $BD, $BE
    .byte mloop,17,$11,mendloop
    .byte mlen,15
    .byte $94, $95, $96, $97, $00, $A3, $A4, $A5, $B1, $B2, $B3, $B4, $BF, $C0, $C1
    .byte mloop,17,$11,mendloop,mlen,14
    .byte $98, $99, $9A, $9B, $A6, $A7, $A8, $A9, $B5, $B6, $B7, $B8, $C2, $C3
    .byte mjump
    .addr titlescreenmess4
titlescreenmess4:
    .byte mloop,18,$11,mendloop
    .byte mlen,12 
    .byte $34, $9C, $9D, $9E, $AA, $AB, $AC, $AD, $B9, $BA, $BB, $BC
    .byte mloop,20,$11,mendloop,mlen,9
    .byte $C4, $C5, $C6, $C7, $CC, $CD, $CE, $CF, $D4
    .byte mloop,23,$11,mendloop,mlen,8
    .byte $C8, $C9, $CA, $CB, $D0, $D1, $D2, $D3 
    .byte mloop,24,$11,mendloop

    .byte mlen,3*16
    .byte $00, $00, $C4, $99, $AA, $A6, $A5, $55, $00, $00, $F0, $9B, $AA, $AA, $AA, $AA
    .byte $00, $CC, $FF, $FB, $FA, $FA, $FA, $AA, $00, $80, $FF, $FF, $FF, $CF, $FF, $F5
    .byte $00, $04, $55, $5D, $5F, $00, $7F, $5F, $00, $00, $00, $44, $55, $55, $54, $55
    .byte mend
endtitle:

pulsecolour: ;x=colour to pulse
    ldy vrampointer
    lda #$3f
    sta vrambuffer,y
    txa
    sta vrambuffer+1,y
    lda #1
    sta vrambuffer+2,y
    lda counter
    and #31
    lsr
    tax
    lda pulsetable,x
    sta vrambuffer+3,y
    tya
    add #4
    sta vrampointer
    rts
pulsetable:
    .byte $17,$26,$27,$36,$37,$38,$30,$30
    .byte $30,$38,$37,$36,$27,$26,$17,$17
