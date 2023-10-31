.segment "CODE"
;;	orgfullpage

; count	= 0
; times16lo	do 216
; 	defb >count	
; count	= count+16
; 	loop
; ;------------------------------------------
; times32tablelo 
; xx	= 0
; 	do 14
; 	defb >xx
; xx	= xx+64
; 	loop
; times32tablehi 
; xx	= 0
; 	do 14
; 	defb <(xx+&20*256)
; xx	= xx+64
; 	loop
; ;------------------------------------------
; waterchrs	HEX 0C3F
; 	HEX 33FF
; 	HEX C0F3
; 	HEX 33FF
; 	HEX 01A3
; 	HEX 00C3
; 	HEX 003C
; 	HEX 18BD
; ;------------------------------------------
; count	= 0
; times16hi	do 216
; 	defb <count	
; count	= count+16
; 	loop
; endtimes16
; ;------------------------------------------
; multstripby16 ;enter with a
; 	tay
; 	lda times16hi,y
; 	sta address7+1
; 	lda times16lo,y
; 	rts
; ;---
; multstripby16sub  ;enter with a
; 	tay
; 	lda times16lo,y
; 	sec
; 	sbc scrxl
; 	sta address8
; 	lda times16hi,y
; 	sbc scrxh
; 	sta xcoordh	
; 	rts
;--------------------------
numberofblocks = 10
emptyblockbuffer:
    lda ingame
    beq @4
    lda filledblockbuffer
    bne @4
    lda #0
    ldx blockpointer
    sta blockbuffer,x
    tax
    stx blockpointer
@2:
    lda blockbuffer,x
@3:
    beq @4
    sta _vramaddr
    lda blockbuffer+1,x
    sta _vramaddr
    lda blockbuffer+2,x
    sta _vramdata
    lda blockbuffer+3,x
    sta _vramdata        ;34
    
    lda blockbuffer+4,x
    sta _vramaddr
    lda blockbuffer+5,x
    sta _vramaddr
    lda blockbuffer+6,x
    sta _vramdata
    lda blockbuffer+7,x
    sta _vramdata        ;32


    lda blockbuffer+8,x
    sta _vramaddr
    lda blockbuffer+9,x
    sta _vramaddr
    lda blockbuffer+10,x
    sta _vramdata	;24

    txa
    add #11
    tax
    cpx #11*numberofblocks	
    bne @2	
@4:
    rts
