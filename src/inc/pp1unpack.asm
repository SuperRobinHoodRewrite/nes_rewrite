.segment "CODE"

; Very simple to call this as you just need to:
; 1. Store index number in a
; 2. jsr to copyblockofcompactedchrs
; It will automatically select correct bank and put chrs in
; correct positions in PPU.
; Example:
; lda #titletopchrs_index
; jsr copyblockofcompactedchrs

cm_chrset_index    = 0
titletopchrs_index = 1
titlebotchrs_index = 2
hiscorechrs_index  = 3
hiscorechrs0_index = 4
basechr_index      = 5
beadchr_index      = 6
boxchr_index       = 7
archchr_index      = 8
rockchr_index      = 9
bedchr_index       = 10
doorchr_index      = 11
robinchrs_index    = 12
okchr_index        = 13

adr1 = address1
adr1l = address1
adr1h = address1+1

pp1_zbuf = toplevvar1
pp1_types = address2
pp1_fol1 = pp1_types+4
pp1_fol2 = pp1_types+8
pp1_fol3 = pp1_types+12


; Below table contains 4 fields:
; 1. half of addr to packed chrs
; 2. second half of addr to packed chrs
; 3. offset in ppu memory
; 4. bank number

compactedchrstable:
    ;>chrdata, <chrdata, start, len, bank+128 if char
cm_chrset0:    .byte >cm_chrset,<cm_chrset,0,14
titletopchrs0: .byte >titletopchrs,<titletopchrs,0,14+128
titlebotchrs0: .byte >titlebotchrs,<titlebotchrs,0,14
hiscorechrs0:  .byte >hiscorechrs,<hiscorechrs,0,14+128
hiscorechrs0s: .byte >hiscorechrs,<hiscorechrs,0,14
basechr0:      .byte >basechr,<basechr,0,14+128
beadchr0:      .byte >beadchr,<beadchr,157,14+128
boxchr0:       .byte >boxchr,<boxchr,247,14+128
archchr0:      .byte >archchr,<archchr,157,14+128
rockchr0:      .byte >rockchr,<rockchr,157,14+128
bedchr0:       .byte >bedchr,<bedchr,180,14+128
doorchr0:      .byte >doorchr,<doorchr,180,14+128
robinchrs0:    .byte >robinchrs,<robinchrs,0,14
okchr0:        .byte >okchr,<okchr,0,14


;==============================================================================
; copyblockofcompactedchrs subroutine uses "compactedchrstable" to calculate
; where given part of character data to put in ppu memory
; A register is expected to be equal to expected index in compactedchrstable
;==============================================================================
copyblockofcompactedchrs:
    ; index of chr data in A reg
    asl
    asl ;note 64 chrs sets max (256/4)
    ; now a = a * 4 ; so it points to correct offset - because each entry in
    ; compactedchrstable is 4 bytes
    tay
    lda current_bank ; here we load current memory bank
    pha ; save it to stack
    lda compactedchrstable+3,y ; load 4'th byte from the table, last 4 bits
    ; contain bank number
    and #15 ; so we do and #15
    jsr changebankrou ; and we switch bank
    lda compactedchrstable+2,y ; now we load ppu start address from table
    sta temp
    lda compactedchrstable+3,y ; not quite sure why
    asl                        ; not quite sure why - in original source
    lda #0                     ; start calculating ppu addr based on start
    adc #0
    asl temp
    rol ; *2
    asl temp
    rol ; *4
    asl temp
    rol ; *8
    asl temp
    rol ; *16
    sta _vramaddr
    lda temp
    sta _vramaddr              ; ppu contains start address now
    lda compactedchrstable+0,y ; load high byte of data
    sta adr1h                  ; save it to adr1h
    lda compactedchrstable+1,y ; same for low byte
    sta adr1l
    jsr pp1_unpack             ; call unpack subroutine
    pla                        ; bring back old bank number
    jmp changebankrou          ; switch bank back to old one


;-----------------------------------------------------------------------------
; Procedure to unpack pp1 chr assets
; Inputs:
; address1 zeropage variable contains start address for unpack
; Outputs:
; $2007 - chars will be written there directly and will appear in CHR-ROM
;-----------------------------------------------------------------------------

pp1_download3:
    stx adr1l
    sty adr1h
    txa
    lda current_bank
    pha
    txa
    jsr changebankrou
    jsr pp1_unpack
    pla
    jmp changebankrou
pp1_download2:
    stx adr1l
    sty adr1h
pp1_download:
    ldx #$D
pp1_unpack:
    ldy #0             ; Load 0 to y
    lda (adr1), y      ; load address in adr1+y to a reg
    sta temp1          ; store it to temp1
    sta temp8          ; and to temp8
    iny                ; increment y

    lda #$80           ; load $80 to a
    sta temp2          ; store a to temp2

; character loop start

pp1_chrloop:
    ; is new header?
    ; get bit into carry flag
    jsr pp1_getc
    bcs pp1_gotheader

    ; fetch header
    ldx #3

@hl:
    ; get type
    jsr pp1_get2
    sta pp1_types,x
    beq @t0
    lsr
    beq @t1
    bcc @t2
; type3
@t3:
    jsr pp1_t3
    sta pp1_fol3,x
    jmp @t0
; type2
@t2:
    jsr pp1_t3
    sta temp3
    jsr pp1_getc
    bcc @t0
    lda temp3
    sta pp1_fol2,x
    jmp @t0
; type1
@t1:
    jsr pp1_t1
    sta pp1_fol1,x
; type0
@t0:
    dex
    bpl @hl

pp1_gotheader:
    ldx #7
pp1_getline:
    stx temp3
; line repetition?
    asl temp2
    bcc @q10
    bne pp1_gotline
    jsr pp1_getq
    bcs pp1_gotline
@q10:
    jsr pp1_get2
    tax

    sta temp4
    lsr
    ora #2
    sta temp5

@next:
    lda pp1_types,x
    beq @t0
    asl temp2
    bcc @q11
    bne @t0
    jsr pp1_getq
    bcs @t0
@q11:
    lda pp1_types,x
    lsr
    beq @t1
    bcc @t2
@t3:
    asl temp2
    bcc @q12
    bne @t1
    jsr pp1_getq
    bcs @t1
@q12:
    asl temp2
    bcc @t2b
    bne @q13
    jsr pp1_getq
    bcc @t2b
@q13:
    lda pp1_fol3,x
    tax
    jmp @p
@t2:
    asl temp2
    bcc @t1
    bne @q14
    jsr pp1_getq
    bcc @t1
@q14:
@t2b:
    lda pp1_fol2,x
    tax
    jmp @p
@t1:
    lda pp1_fol1,x
    tax
    jmp @p
@t0:
    txa
@p:
    lsr
    rol temp4
    lsr
    rol temp5
    bcc @next
    
pp1_gotline:
    ; store line
    lda temp4
    sta $2007

    ldx temp3
    lda temp5
    sta pp1_zbuf,x
    dex
    bpl pp1_getline

    ldx #7
@bpl1:
    lda pp1_zbuf,x
    sta $2007
    dex
    bpl @bpl1
    ; next char

    dec temp1
    beq @done
    jmp pp1_chrloop
@done:
    rts


;-----------------------------------------------------------------------------
; Sub routine area
;-----------------------------------------------------------------------------

pp1_getc:
    asl temp2
    beq @h0
    rts
@h0:
pp1_getq:
    lda (adr1),y
    iny
    bne @h2
    inc adr1h
@h2:
    rol
    sta temp2
    rts

; get 2 bits into a

pp1_get2:
    ; get b1
    asl temp2
    bne @twenty

    lda (adr1),y
    iny
    bne @twentytwo
    inc adr1h
@twentytwo:
    rol
    sta temp2
@twenty:
    rol
    and #1
    ; get b2
    asl temp2
    beq @twentyone
    rol
    rts
@twentyone:
    pha
    lda (adr1),y
    iny
    bne @twentythree
    inc adr1h
@twentythree:
    rol
    sta temp2
    pla
    rol
    rts

; get info for folcol1
pp1_t1:
    jsr pp1_getc
    bcc @t1b
    lda pp1_fc1,x
    rts
@t1b:
    jsr pp1_getc
    bcs @t1c
    lda pp1_fc2,x
    rts
@t1c:
    lda pp1_fc3,x
    rts

; get info for folcol2 and folcol3

pp1_t3:
    jsr pp1_t1
    sta pp1_fol1,x
    beq @t30
    cmp #2
    bcc @t31
    beq @t32
@t33:
    lda pp1_f3l,x
    sta pp1_fol2,x
    lda pp1_f3h, x
    rts
@t32:
    lda pp1_f2l,x
    sta pp1_fol2,x
    lda pp1_f2h,x
    rts
@t31:
    lda pp1_f1l,x
    sta pp1_fol2,x
    lda pp1_f1h,x
    rts
@t30:
    lda pp1_f0l,x
    sta pp1_fol2,x
    lda pp1_f0h,x
    rts

; Tables used for unpacking data
pp1_fc3: .byte $03, $03, $03
pp1_fc2: .byte $02, $02, $01
pp1_fc1: .byte $01, $00, $00, $00
pp1_f0l: .byte $02, $02, $01
pp1_f0h: .byte $03, $03, $03
pp1_f1l: .byte $02, $FF, $00, $00
pp1_f1h: .byte $03, $03, $03
pp1_f2l: .byte $01, $00, $00, $00
pp1_f2h: .byte $03, $03, $FF, $01
pp1_f3l: .byte $01, $00, $00, $00
pp1_f3h: .byte $02, $02, $01
