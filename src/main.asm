.include "header.asm"
.include "variables.asm"
.include "inc/macros.asm"
.include "inc/bankswitch.asm"
.include "inc/soundfx.asm"
.include "inc/general.asm"
.include "inc/title_screen.asm"
.include "inc/interupt.asm"
.include "inc/spritesr.asm"
.include "inc/spritesd.asm"
.include "inc/music.asm"
.include "assets.asm"
.include "inc/mainloop.asm"
.include "inc/timings.asm"
.include "inc/cmlogo.asm"
.include "inc/start.asm"

; .segment "CODE"
; reset:
;     sei
;     cld
;     ldx #$FF
;     txs

; 	ldy #0
; 	sty _control0
; 	sty _control1
; 	sty address
; 	sty address+1
; clearram:
; @2:
; 	lda #0
; @1:
; 	sta (address),Y
; 	iny
; 	bne @1
; @3:
; 	inc address+1
; 	lda address+1
; 	cmp #1
; 	beq @3
; 	cmp #07
; 	bne @2

; 	lda #%10010000	
; 	sta control0
; 	sta _control0
; 	sta seed
; 	lda #%00011110
; 	sta control1	
; 	sta seed+1
; ;	lda #0
; ;	sta _control1
; 	jsr turninteroff1

;     ; THIS WILL NEED TO BE TURNED ON LATER
; 	;lda #10
; 	;jsr starttune

;     jmp anewgame

; loop:
;     jmp loop


.segment "VECTORS"
.addr cm_nmi, start, $0


.include "inc/pp1unpack.asm"
.include "inc/prtmess.asm"

