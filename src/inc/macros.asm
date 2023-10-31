;------------------------------------------------------------------------------
.macro flybackvar
	asl flyflag
@1:
	bit flyflag
	bpl @1
.endmacro
;------------------------------------------------------------------------------
;does a CLC ADC with any legal addressing mode
.macro add first, second, third
	.ifblank #second
	clc
	adc first
	.else
	.ifblank #third
	clc
	adc first, second
	.endif
	.endif
.endmacro
;------------------------------------------------------------------------------
.macro nega
	eor #255
	clc
	adc #1
.endmacro
;------------------------------------------------------------------------------
.macro ldxy	addr         ;;;ldx with lo   ldy with hi   
	ldx #>addr
	ldy #<addr
.endmacro
;------------------------------------------------------------------------------
.macro waitforsprcol ;waits for sprite collision with sprite & char
@2:
	bit _statusreg
	bvs @2
@1:
	bit _statusreg
	bvc @1
.endmacro
;------------------------------------------------------------------------------
.macro sprvar label
label = (*-spritetable)/2
.endmacro
;------------------------------------------------------------------------------
.macro changebank bankno
	.if bankno=12
	jsr changebank12rou
	.endif
	.if bankno=13
	jsr changebank13rou
	.endif
	.if bankno=14
	lda #bankno
	sta bankno
	sta banktable+bankno
	.endif
.endmacro
;------------------------------------------------------------------------------
.macro sub first, second, third		;does a SEC  SBC with any legal addressing mode
.ifblank #second
	sec
	sbc first
.else
.ifblank #third
	sec
	sbc first, second
.endif
.endif
.endmacro
