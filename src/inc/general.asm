.segment "CODE"
;******KEY PAD ROUTINE**************************
amask   = %10000000
bmask   = %01000000
selmask = %00100000
stmask  = %00010000
umask   = %00001000
dmask   = %00000100
lmask   = %00000010
rmask   = %00000001
readkeypads:
    ldx #1
    stx $4016
    dex
    stx $4016
;	jsr padloop1 
;	inx 
padloop1:
    lda pad  ;,x
    sta debounce ;,x
    ldy #$8
padloop2:
    lda $4016 ;,x
    lsr a
    rol pad ;,x
    dey
    bne padloop2 
    rts
;------------------------------
random:
    lda counter
    ror a
    eor seed+1
    eor seed
    rol a
    ror seed+2
    sta seed+1
    eor #255
    rol a
    eor seed
    sta seed
    rts
;----------------------------------------------
teststartkey: ;returns not equal if someone has pressed start
    lda #stmask
    bne generalkeytest
testselectkey:
    lda #selmask
    bne generalkeytest

testanykey:
    lda #255
generalkeytest:
    sta temp
    lda pad
    and temp
    beq @3
    lda debounce
    and temp1
    beq @4
    lda #0 
@3:
    rts
@4:
    lda #1
    rts
;----------------------------------------------
checkforpausekey:
    lda dontpause
    bne @7	;this will be eor'd and set pause to 0
@6:
    lda pad
    and #stmask
    beq @1
    lda debounce
    and #stmask
    bne @1
    lda pause
@7:
    eor #1
    sta pause
    beq @2
    lda #0
    sta $4015
    rts
@2:
    lda #15
    sta $4015

@1:
    rts
;---------------------------------------------------------------
clearfullspriteblock:
    ldx #0
    jsr clearspriteblock1
sendspriteblock:
    lda #0
    sta _spriteaddr
    lda #>spriteblock	
    sta $4014	
    rts
;--------------------------------------------------
turnofftune:
    lda #0
starttune:
    tay
    lda bankno
    pha
    jsr changebank13rou
    lda #0
    sta $4015
    tya
.if musicon = 1
    jsr start_music ; commented out to simplify current setup
.endif
    pla
    jmp changebankrou
;--------------------------------------------------------
soundfx:
    sta fFX_AD1L
    txa
    pha
    tya
    pha
    lda bankno
    pha
    jsr changebank13rou
    lda fFX_AD1L
    ;jsr fx_setup ; commented out to simplify current setup
    pla
    jsr changebankrou
    pla
    tay
    pla
    tax
    rts
;-------------------------------------------------------
clearscr:
    .byte maddr+$20,00,mloop,64,mloop,32,0,mendloop,mendloop,mend
;--------------------------------------------------
clearspriteblock:
    ldx #4
clearspriteblock1: 
    stx spriteblockpointer  
@1:
    lda #$fe
    sta spriteblock,x
    lda #0
    sta spriteblock+3,x
    sta spriteblock+2,x
    sta spriteblock+1,x
    inx
    inx
    inx
    inx
    bne @1
    rts
;----------------------------------------------------
turninteron1:
    flybackvar
    jsr sendspriteblock
turninteron:
    lda #255
    sta debounce
    ldx x_scroll
    ldy y_scroll
    stx _scrollcon
    sty _scrollcon
    lda control0
    ldy control1
    sta _control0	;;;start flyback interupt
    sty _control1
    lda #255
    sta interon
    rts
;---------------------------------------------------------------
turninterofffade:
    lda #0
    sta finishedloop
    lda #$fc
    sta fadecounter
    
fadeoffscreen:
    flybackvar
    lda fadecounter
    cmp #255
    bne fadeoffscreen
    jmp turninteroff1	

turninteroff:
    flybackvar
turninteroff1:
    lda #0
    sta finishedloop 
    sta interon
    sta _control1
    sta x_scroll
    sta y_scroll
    sta _scrollcon
    sta _scrollcon
    sta vrampointer
;	sta fx_priority+3
;	sta fx_priority+2
;	sta fx_priority+1
;	sta fx_priority+0

    sta pause
;    if testpause=1
;    sta pause1
;    endif
    lda #%00011110
    sta control1
    lda #%10010000	
    sta control0
    sta _control0
    jmp clearfullspriteblock
;----------------------------------------
addtolives:
    inc lives
    rts
;-----------------------------------------
highbitadd:
    .byte 255,0,0
;-----------------------------------------
;subfromlives	lda #200
;	sta killed
;	dec lives
;	rts
;-----------------------------------------
; printlives:
;     lda lives
;     beq @2
;     bmi @2
;     cmp #3
;     bcc @3
;     lda #3
; @3:
;     sta temp9
;     lda #0+64
;     sta temp
;     lda #32-ydisplace
;     sta address5
; @1:
;     ldy address5	
;     ldx #240
;     lda #1
;     jsr pokesprite2by2 
;     lda address5
;     add #24
;     sta address5
;     dec temp9
;     bne @1
; @2:
;     rts
;-------------------------------------------
printscore:
    lda #128-10*3-4
    ldy #0
@3:
    ldx score,y
    bne @4
    add #5
    iny
    cpy #3
    bne @3
@4:
    sta temp
@2:
    lda score,y
    add #$80
    ldx spriteblockpointer
    beq @1
    sta spriteblock+1,x
    lda temp1
    lda #2
    sta spriteblock+2,x
    lda temp
    sta spriteblock+3,x
    add #10
    sta temp
    lda #16
    sta spriteblock+0,x
    txa
    add #4
    sta spriteblockpointer
    iny
    cpy #6
    bne @2	
@1:
    rts	
    
;-------------------------------------------
;hit a guard		=20
;kill a guard	=50
;kill a bat		=10
;pick up treasure	=200
;pick up key		=150
;pick up heart	=80
;rescue main marion	=10000
;
;
addtoscore:		;add low nibble of A to
        ;(hi nibble)th digit of score 0=100,000   5=1 unit
    sty tempy
    pha
    lsr
    lsr
    lsr
    lsr
    tay
    pla
    and #15
addtolp:
    clc
    adc score,y
    sta score,y
    cmp #10
    bcc endupdatescore
    sec
    sbc #10
    sta score,y
    lda #1
    dey
    bpl addtolp
endupdatescore:
    ldy tempy
    rts
;------------------------------------------
resetscore:
    ldy #6
@1:
    lda #0
    sta score,y
    lda #8
    sta treasures,y
    dey
    bpl @1
    rts
;------------------------------------------
addtohearts:
    lda hearts
    add #1
    sta hearts
    cmp #5
    bcc @2
    inc lives
    add #<-3
    sta hearts
    lda #extralifefx
    jsr soundfx
@2:
    rts
;------------------------------------------
subfromhearts: ;a=number of hearts to sub
    ;if testpause=1
;	lda pause
;	beq @3
;	rts
@3:
    ;endif

    ldy robininvinc
    beq @2
    rts
    
@2:
subfromhearts1:
    nega
    add hearts
    sta hearts
    ldy #150
    sty robininvinc
    cmp #0
    beq killyou1
    bpl littlekill
killyoutotally:
    lda #0
    sta hearts
;	jsr subfromlives
;	lda hearts
;	add #3
;	sta hearts
killyou1:
    lda #100
    sta killed
    lda #1	
    sta temp2
    lda #0
    sta heartstable+0
    sta heartstable+16
    sta heartstable+32
    ldx #32
    ;jsr gotstarsx	;startstars   ;large robin explosion ; disabled now
    lda #killyoutotallyfx
    jmp soundfx
littlekill:
    lda #0
    ;jsr startstars   ;small robin explosion ; disabled now
    lda #killyoufx
    jmp soundfx
;------------------------------------------
printhearts:
    lda #24
    sta temp
    ldy hearts
    bmi @1
    beq @1
    lda heartcounter
    bit pause
    bne @3
    add heartbeat-1,y
    sta heartcounter
@3:
    lda heartcounter
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    tax
    lda heartsdefs,x
    sta temp1

@2:
    ldx spriteblockpointer
    beq @1
    lda temp1
    sta spriteblock+1,x
    lda #3
    sta spriteblock+2,x
    sta spriteblock+2+4,x
    lda #16
    sta spriteblock+3,x
    lda temp
    sta spriteblock+0,x
    add #24
    sta temp
    txa
    add #4
    sta spriteblockpointer
    dey
    bne @2	
@1:
    rts	
heartsdefs:
    .byte $8a,$8b,$8c,$8b
heartbeat:
    .byte 18,14,10,8,6,4,2
treaspal:
    .byte 1,1,2,1,1,3
;------------------------------------------
waitforstartkey: ;equal=keep going round loop
    lda fadecounter
    cmp #255
    beq @2
    cmp #0
    bne @4
    lda pad
    and #stmask
    beq @1
    lda debounce
    and #stmask
    bne @4
    lda solidfound
    add #128
    sta solidfound
@3:
    lda #$fb	
    sta fadecounter
    bne @4
@2:
    jsr turninteroff1
    lda #1
    rts
@4:
    lda #0
@1:
    rts
;---------------------------------------------

