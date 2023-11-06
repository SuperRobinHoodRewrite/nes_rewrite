resetrobinvars:
	move_val 290,robinxl
	lda #208
	sta robiny

	.if testpause=1
	lda #startlevel
	asl
	sta temp
	asl
	add temp	
	tax
	lda mapinfo+2,x
	tay
	lda times16lo,y
	add #150
	sta robinxl
	lda times16hi,y
	adc #0
	sta robinxh
	lda #190
	sta robiny
	.endif
	lda #0
	sta minmap
	rts
