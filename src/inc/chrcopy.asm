.include "pp1unpacker.asm"
.segment "CODE"

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
