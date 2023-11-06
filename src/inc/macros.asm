;------------------------------------------------------------------------------
.macro flybackvar
	asl flyflag
@tmp:
	bit flyflag
	bpl @tmp
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
	ldx #<addr
	ldy #>addr
.endmacro
;------------------------------------------------------------------------------
.macro waitforsprcol ;waits for sprite collision with sprite & char
@tmp2:
	bit _statusreg
	bvs @tmp2
@tmp1:
	bit _statusreg
	bvc @tmp1
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
;------------------------------------------------------------------------------
.macro add16toval0 first,second,third
; used when first == third
	lda first
	clc
	adc #>second
	sta third

	.if second<256

	bcc @tmp
	inc third+1
@tmp:
	.else
	lda first+1
	adc #<second
	sta third+1
	.endif
.endmacro

.macro add16toval first, second, third  ;source1,value,destination (16 bit values)
	lda first
	clc
	adc #>second
	sta third
	lda first+1
	adc #<second
	sta third+1
.endmacro
;------------------------------------------------------------------------------
.macro move_val	first, second		;entry number,address
	lda	#>first	;puts 16 bit number into address
	sta	second
	lda	#<first
	sta	second+1
.endmacro
;------------------------------------------------------------------------------
.macro move_w first, second	;entry address1,address2
	;transfers a word in (address1) to (address2)
	lda	first
	sta	second
	lda	first+1
	sta	second+1
.endmacro
;------------------------------------------------------------------------------
;SMALL LDIR - INDIRECT
;entry address1(16bit),address2(16bit),length(8bit)
;transfers up to 1 page of memory from the address pointed to by (address1)
;to the address pointed to by (address2) length is stored in (length) address
;eg slddrind $3000,$3002,$3004 where (&3000)=&2000, (&3002)=&2800, (&3004)=124
;transfers 124 bytes from $2000 on to $2800 working UP

.macro sldirind first, second, third
	ldx	third
	ldy	#0
@tmp:
	lda	(first),y
	sta	(second),y
	iny
	dex
	bne	@tmp
.endmacro
;------------------------------------------------------------------------------
;SMALL LDDR - INDIRECT
;entry address1(16bit),address2(16bit),length(8bit)
;transfers up to 1 page of memory from the address pointed to by (address1)
;to the address pointed to by (address2) length is stored in (length) address
;eg slddrind $3000,$3002,$3004 where (&3000)=&2000, (&3002)=&2800, (&3004)=124
;transfers 124 bytes from $2000 on to $2800 working DOWN

.macro slddrind	first, second, third
	ldy	#third-1
@tmp:
	lda	(first),y
	sta	(second),y
	dey
	bpl	@tmp
.endmacro
