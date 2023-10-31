.segment "CODE"
CM_USERNMI = 1
CM_SPAGE   = $0300
CM_YEAR    = 1993

;	if absolutely=1


CM_SYPOS   = CM_SPAGE
CM_SDATA   = CM_SPAGE+1
CM_SCTRL   = CM_SPAGE+2
CM_SXPOS   = CM_SPAGE+3


;zero page

CM_STINDX  = 1
CM_COLINDX = 2

;keep these 5 bytes in order...@
CM_YSCRPOS  = 3
CM_TIME     = 4
CM_STADRL   = 5
CM_CODEXPOS = 6
CM_CODEYPOS = 7

CM_TEMP1    = 12
CM_TEMP2    = 13
CM_TEMP3    = 14
CM_TEMP4    = 15

CM_ADR1     = 16
CM_ADR1L    = 16
CM_ADR1H    = 17

CM_NUPZBUF  = 18	;eight bytes



CM_LOGO:
	LDX #$00
	STX $2000
	STX $2001

;powerup/reset detect & set nmi to ours

	LDY #$97

	LDA cm_flags
	AND #$3F
	CMP #4
	ORA #$40
	BCS @POWERUP

	CPY cm_powerup
	BEQ @RESET
@POWERUP:
	STY cm_powerup
	LDA #$00
@RESET:
	STA cm_flags

;download characters

	JSR CM_CHARACTERS
;clear
	LDX #$00
@55:
	LDA #$00
	STA 0,X
	LDA #$FF
	STA CM_SPAGE,X
	INX
	BNE @55

;setup

	LDX #$04
@IN:
	LDA CM_INITTAB,X
	STA CM_YSCRPOS,X
	DEX
	BPL @IN


;cls

	LDA #$20
	STA $2006
	LDX #$00
	STX $2006
	LDY #$10

	TXA
@CV0:
	STA $2007
	DEX
	BNE @CV0
	DEY
	BNE @CV0

	;assume X=0...


;print 'AB'

@AB2:
	LDA CM_ABMAP,X	;#$22
	BEQ @ABDONE
	STA $2006
	INX
	LDA CM_ABMAP,X
	STA $2006
	INX

	LDY CM_ABMAP,X
	INX

	;LDY #21
@AB1:
	LDA CM_ABMAP,X
	STA $2007
	INX
	DEY
	BNE @AB1
	BEQ @AB2

;@AB11
	;CPX #21*3
	;BCC @AB2

@ABDONE:


;'AB' attr patch

	LDA #$23
	STA $2006
	LDA #$E8
	STA $2006

	LDY #3

	LDA #$50
@AB5:
	LDX #8
@AB6:
	STA $2007
	DEX
	BNE @AB6

	LDA #$55

	DEY
	BNE @AB5

;and cmname atr

	LDY #$23
	STY $2006
	LDX #$C2+8
	STX $2006
	STA $2007
	STA $2007
	STA $2007
	STA $2007

;and 'TM' atr

	STY $2006
	LDX #$CD+8
	STX $2006
	LDA #$05
	STA $2007



;sfx setup

	LDX #$13
	LDA #$00
@CSFX:
	STA $4000,X
	DEX
	BPL @CSFX

;nmi on
	LDA #$80
	STA $2000

;main loop

CM_LOOP:
	JSR CM_VBLANK

;sfx
	LDA #$0F
	STA $4015

	LDX cm_frames

	TXA
	AND #1
	STA CM_TEMP1

;noise freq

	CPX #CM_NOISESTART
	BCS @N2
	TXA
	LSR
	BPL @N0
@N2:
	TXA
	LSR
	LSR
	LSR
	TAY
	LDA CM_SFXNOISE-3,Y
	CMP #2
	BCS @N0
	ADC CM_TEMP1
@N0:
	STA $400E

;consts

	LDY #$00
	STY $4003
	DEY
	STY $4007
	STY $400F

	LDA #$15;F
	STA $400C


;pre-circle or post circle?

	CPX #CM_NOISESTART
	BCC @670


;post-circle...

;saw ping freq

	LDA #$30
	STA $4002


;fading saw ping

	TXA
	SEC
	SBC #CM_NOISESTART-8
	EOR #$FF
	LSR
	LSR

	CMP #$30
	BCS @11
	LDA #$00
@11:
	ORA #$10+$80
	STA $4000

;cut off noise

	CPX #CM_NOISELEN
	BCC @600

	LDA #$10
	STA $400C

	BNE @600

;pre-circle...

@670:

;saws
	TXA
	LSR
	ORA #$10+$80
	STA $4000
	STA $4004

	TXA
	ASL
	ASL
	ASL
	STA $4002
	STA $4006

	LDA #$02
	CLC
	ADC CM_TEMP1
	STA $4003
	STA $4007

@600:



;timeout?

	LDA cm_frames
	;CMP #$E0
	BEQ @TIMEOUT

	BIT cm_flags
	BVC @CM_LOOP

	CMP #$40
	BCC @CM_LOOP

	LDY #1
	STY $4016
	DEY
	STY $4016

	LDY #8
@J1:
	LDA $4016
	ORA $4017
	LSR
	BCS @TIMEOUT
	DEY
	BNE @J1

@CM_LOOP:
	JMP CM_LOOP

@TIMEOUT:

	LDA #$00
	STA $2000
	STA $2001
	STA $4015

;	IF CM_USERNMI
	LDA cm_flags
	ORA #$80
	STA cm_flags
;	ENDIF

;return to caller (game)

	RTS



CM_VBLANK:   ;vblank doings

	LDA cm_frames
@1: 
    CMP cm_frames
	BEQ @1

;palette
	LDX #$00
	LDA #$3F
	STA $2006
	STX $2006

	LDY #$04
@P2:
	LDX #$07
@P1:
	LDA CM_PALETTE,X
	STA $2007
	DEX
	BPL @P1
	DEY
	BNE @P2


;colour-fade-in

	LDX CM_COLINDX

	LDY #$3F
	STY $2006
	LDA #$11
	STA $2006

	LDA CM_COLFADE,X
	BMI @EOF
	STA $2007
	LDA CM_COLFADE+1,X
	STA $2007
	LDA CM_COLFADE+2,X
	STA $2007

	;LDY #$3F
	STY $2006
	LDY #$03
	STY $2006
	STA $2007

	STA $2007
	STA $2007
	STA $2007
	STA $2007

	LDY #$3F
	STY $2006
	LDY #$1B
	STY $2006
	STA $2007

	INX
	INX
	INX

	DEC CM_TIME
	BNE @EOF
	INC CM_TIME
	STX CM_COLINDX
@EOF:


;write one more column of 'MASTERS' characters

CM_STRIP:

	LDA #$04
	STA $2000


	LDA #$21
	STA $2006
	LDA CM_STADRL
	STA $2006
	INC CM_STADRL

	LDX CM_STINDX
	LDY CM_STDATA,X
	DEY
	BPL @DONE


@2:
	LDA $2007
	DEY
	BMI @2

@1:
	INX
	LDA CM_STDATA,X
	BMI @3
	STA $2007
	BPL @1

@3:
	STX CM_STINDX
@DONE:


;write 'Code' as characters when ready


CM_CODEWRITE:
	LDA CM_SXPOS+32
	CMP #$A1
	BNE @NC

	LDA #$21
	STA $2006
	LDA #$4C+$40
	STA $2006
	LDA #$08
	STA $2007

	LDA #$F4+$40-$100
	STA CM_ADR1L

	LDY #CM_C1CHR
	LDX #0

@LOOP2:
	LDA #$20+1
	STA $2006
	LDA CM_ADR1L
	STA $2006
	DEC CM_ADR1L

	LDA CM_CODEMAP,X

@20:
	ASL
	BEQ @NEXT2
	BCC @SKIP

	STY $2007
	INY
	BNE @20
@SKIP:
	BIT $2007
	BCC @20
@NEXT2:
	INX
	CPX #9
	BNE @LOOP2

@NC:

;'TM'
	LDA #$20+1
	STA $2000
	STA $2006
	LDA #$F4+$40-$100
	STA $2006
	LDX #$8E
	STX $2007
	INX
	STX $2007



;setup PPU

;
	LDA #0
	STA $2003
	LDA #CM_SPAGE/256
	STA $4014

	LDA #$81
	STA $2000

	LDA CM_YSCRPOS
	BEQ @AT_REST
	SEC
	SBC #4
	STA CM_YSCRPOS
@AT_REST:

	ASL
	EOR #$FF
	STA $2005
	LDA CM_YSCRPOS
	STA $2005

	LDA #$1E
	STA $2001


;display 'CODE' in scrolly sprites

CM_CODE:

CM_C1CHR    = 1
CM_C2CHR    = 25

	LDY #0

	LDA CM_CODEXPOS
	CLC
	ADC #8
	CMP #$A9
	BEQ CM_QUART
	STA CM_CODEXPOS

	LDA CM_CODEYPOS
	SEC
	SBC #4
	STA CM_CODEYPOS

	LDX #10
	LDA #CM_C2CHR
	JSR @CM_CODEPLOT

	LDX #0
	LDA #CM_C1CHR

@CM_CODEPLOT:
	STA CM_TEMP4

	LDA CM_CODEXPOS
	STA CM_TEMP1

@LOOP2:
	LDA CM_CODEYPOS
	STA CM_TEMP2
	LDA CM_CODEMAP,X
	BEQ @DONE
	STA CM_TEMP3
	INX

@LOOP:
	ASL CM_TEMP3
	BEQ @NEXT2
	BCC @NEXT
	LDA CM_TEMP4
	INC CM_TEMP4

	STA CM_SDATA,Y

	LDA #$02
	STA CM_SCTRL,Y

	LDA CM_TEMP1
	CMP #$E0
	BCS @DONE
	STA CM_SXPOS,Y

	LDA CM_TEMP2
	STA CM_SYPOS,Y

	INY
	INY
	INY
	INY

@NEXT:
	LDA CM_TEMP2
	CLC
	ADC #8
	STA CM_TEMP2
	BNE @LOOP

@NEXT2:
	LDA CM_TEMP1
	SEC
	SBC #8
	STA CM_TEMP1
	BNE @LOOP2


@DONE:
	RTS




;display circle quarters

CM_QUART:

CM_QX   = $59
CM_QY   = $2F+$10
CM_QCHR = 33

	LDA #CM_QCHR
	STA CM_TEMP4

	LDA #CM_QY
	STA CM_TEMP2

	LDX #0
	LDY #32

@LOOP2:
	LDA #CM_QX
	STA CM_TEMP1
	LDA CM_QUARTMAP,X
	STA CM_TEMP3
	INX

@LOOP:
	ASL CM_TEMP3
	BCC @NEXT
	LDA CM_TEMP4
	INC CM_TEMP4

	STA CM_SDATA,Y
	STA CM_SDATA+4,Y
	STA CM_SDATA+8,Y
	STA CM_SDATA+12,Y

	LDA #$20
	STA CM_SCTRL,Y
	LDA #$60
	STA CM_SCTRL+4,Y
	LDA #$A0
	STA CM_SCTRL+8,Y
	LDA #$E0
	STA CM_SCTRL+12,Y

	LDA CM_TEMP1
	STA CM_SXPOS,Y
	STA CM_SXPOS+8,Y
	EOR #$FF
	SEC
	SBC #$05
	STA CM_SXPOS+4,Y
	STA CM_SXPOS+12,Y

	LDA CM_TEMP2
	STA CM_SYPOS,Y
	STA CM_SYPOS+4,Y
	EOR #$FF
	SEC
	SBC #$A7-CM_QY*2
	STA CM_SYPOS+8,Y
	STA CM_SYPOS+12,Y

	TYA
	CLC
	ADC #16
	TAY

@NEXT:
	LDA CM_TEMP1
	CLC
	ADC #8
	STA CM_TEMP1
	CMP #CM_QX+8*5
	BNE @LOOP

	LDA CM_TEMP2
	CLC
	ADC #8
	STA CM_TEMP2
	CMP #CM_QY+8*6
	BNE @LOOP2

;done
	RTS


;** Data **


CM_SFXNOISE: .byte $04, $06, $01, $01

CM_NOISESTART = 24
CM_NOISELEN   = 56
CM_TRIANGLEN  = 44
CM_INITTAB: .byte $5C, $18, $49, $F1, $9F
	;HEX 5C1809F18F

CM_STDATA:
	.byte $88, $2F, $30
	.byte $86, $31, $32, $33, $34
	.byte $85, $35, $36, $37, $38
	.byte $85, $39, $3A, $3B
	.byte $84, $3C, $3D, $3E, $3F, $40
	.byte $84, $41, $42, $43, $44, $19
	.byte $84, $45, $46, $47, $48
	.byte $83, $49, $4A, $4B, $4C, $4D
	.byte $82, $4E, $4F, $50, $51, $52, $0B
	.byte $82, $53, $54, $55, $56, $0B
	.byte $82, $57, $58, $59, $0B
	.byte $82, $5A, $5B, $5C
	.byte $81, $5D, $5E
	.byte $80

CM_COLFADE:
    .byte $04, $04, $04
    .byte $04, $04, $03
    .byte $04, $04, $13
    .byte $03, $14, $12
    .byte $02, $16, $11
    .byte $01, $18, $11
    .byte $80


CM_QUARTMAP:
    .byte %00111000
    .byte %01111000
    .byte %11100000
    .byte %11000000
    .byte %10000000
    .byte %10000000

CM_CODEMAP:
    .byte %00100010
    .byte %00100010
    .byte %01100010
    .byte %11100010
    .byte %01110010
    .byte %01111010
    .byte %01111010
    .byte %01111010
    .byte %00001110
    .byte 0

    .byte %00010010
    .byte %00010010
    .byte %00010010
    .byte %00011010
    .byte %00001010
    .byte %00000010
    .byte %00000110
    .byte %00000110
    .byte %00000010
    .byte 0

chr3:
mess93:
    .byte %00000000
    .byte %10001100
    .byte %01010010
    .byte %01000010
    .byte %11001110
    .byte %01000010
    .byte %10010010
    .byte %00001100

    .byte %00000000
    .byte %10001100
    .byte %01010010
    .byte %01000010
    .byte %11001110
    .byte %01000010
    .byte %10010010
    .byte %00001100


CM_ABMAP:
    .byte $22, $C5, $15, $5F, $60, $61, $62, $63, $64, $65, $66, $63, $67, $00, $60, $60, $68, $63, $63, $68, $5F, $69, $6A, $6B
    .byte $22, $E5, $15, $6C, $6D, $6E, $6F, $70, $71, $63, $72, $70, $73, $00, $6D, $74, $75, $70, $70, $75, $6C, $76, $77, $78

	;IF CM_YEAR = 1992
	;HEX 232515797A7B7C7D7E7F808182838485868788898A8B8C8D
	;ELSE
    .byte $23, $25, $15, $79, $7A, $7B, $90, $7D, $7E, $7F, $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D
	;ENDIF




;	HEX 22C5155F606162636465666367006060686363685F696A6B
;	HEX 22E5156C6D6E6F707163727073006D74757070756C767778
;	IF CM_YEAR=1991
;	HEX 232515797A7B7C7D7E7F808182838485868788898A8B8C8D
;	ELSE
;	HEX 232515797A7B907D7E7F808182838485868788898A8B8C8D
;	ENDIF

	;cmname
    .byte $20, $AA, $0C, $91, $62, $92, $66, $93, $94, $95, $96, $65, $66, $60, $61
    .byte $20, $CA, $0C, $97, $6F, $98, $72, $99, $9A, $9B, $9C, $63, $72, $74, $6E
    .byte $00



CM_PALETTE:
	.byte $34, $24, $14, $04
	.byte $11, $28, $1D, $04




;CM_SHORT = *-CM_LOGO
;CM_SHORT


;*******************************************************************

CM_CHARACTERS:
;	lda #0
;	sta _vramaddr
;	sta _vramaddr
;	move.val cm_chrset,pp1address
;	jsr PP1_UNPACK
;	lda #<(&90*16)
;	sta _vramaddr
;	lda #>(&90*16)
;	sta _vramaddr
;	ldx #0
;@1	lda chr3,x
;	sta _vramdata
;	inx
;	cpx #16
;	bne @1
;	rts
;
;


	lda #14
	sta bankno
	lda #cm_chrset_index
	jsr copyblockofcompactedchrs
	lda #<($90*16)
	sta _vramaddr
	lda #>($90*16)
	sta _vramaddr
	ldx #0
@1:
	lda chr3,x
	sta _vramdata
	inx
	cpx #16
	bne @1
	rts


	;X=bank#, pp1address = packed chrs, data into $2007
	;exit: pp1address=source for next char, temp8=#chars just done

;CM_CHRSET	;now 1242 bytes long
;	incbin CMLOGO.PP1

;CM_TOTAL	EQU *-CM_LOGO



;*************************************************************

; SMILEY self-tst code V1.3

; by Jon Menzies and Gavin Raeburn 3-10-90
; or
; by Gavin Raeburn and Jon Menzies 3-10-90

;variable size (eg 64k/128k) update by Jon Menzies 16-2-91

;(extra 13 bytes added to be same length as smileyQ (597 bytes) 7-8-91)
;extra 15 bytes added to be same length as smileyQ v1.3q (612 bytes) 2-10-91

;BANK_TABLE, SMILEY_LOBANK, and SMILEY_HIBANK must be declared externally


; SMILEY	;<-- this is the only non-local label defined here

; 	IF SMILEY_HIBANK > $F
; 	ERROR "SMILEY_HIBANK must be $0..$F
; 	ENDIF

; 	IF SMILEY_LOBANK > SMILEY_HIBANK
; 	ERROR "SMILEY_LOBANK is greater than SMILEY_HIBANK
; 	ENDIF

; ;define zero page chars used

; @tst_BYTE	EQU $13
; @BANK	EQU $14
; @PAGE	EQU $15
; @PAD1	EQU $16
; @BANK_ON	EQU $17
; @FACE_MASK	EQU $18

; 	LDX #$20
; @1	LDA @ROM_CHECK-$20,X
; 	STA $0,X

; 	INX
; 	BNE @1

; 	STX $2000
; 	STX $2001

; ;read keypad

; 	JSR @KEYPAD
; 	STY @tst_BYTE

; 	LDA @PAD1
; 	AND #%10111111
; 	CMP #%10111111
; 	BNE @NEXT_tst

; ;set no. of banks to check

; 	LDA #SMILEY_HIBANK	;#15
; 	STA @BANK

; ;tst 1 - ROM check

; 	LDA @SMILEY_BANK
; 	STA @BANK_ON

; 	JSR $20

; @NEXT_tst	LDA @PAD1
; 	AND #%01111111
; 	CMP #%01111111
; 	BNE @NO_EQ

; 	JSR @tst_2

; @NO_EQ	LDA @tst_BYTE
; 	BEQ @EXIT

; 	AND #4+8
; 	BNE @FAILED

; 	JMP @GOOD_FACE

; @FAILED	JMP @BAD_FACE

; @EXIT	RTS



; ;tst 2 - Char RAM tst


; ;write to video ram

; @tst_2
; 	JSR @tst2_SET

; @tst1A	LDY #64

; @tst1B	STX $2007
; 	INX
; 	STX $2007
; 	INX
; 	STX $2007
; 	INX
; 	STX $2007
; 	INX

; 	DEY
; 	BNE @tst1B
; 	INX

; 	SEC
; 	SBC #1
; 	BNE @tst1A


; ;read video ram

; 	JSR @tst2_SET

; 	LDY $2007

; @tst2A	LDY #64

; @tst2B	CPX $2007
; 	BNE @CRAM_FAIL
; 	INX
; 	CPX $2007
; 	BNE @CRAM_FAIL
; 	INX
; 	CPX $2007
; 	BNE @CRAM_FAIL
; 	INX
; 	CPX $2007
; 	BNE @CRAM_FAIL
; 	INX

; 	DEY
; 	BNE @tst2B
; 	INX

; 	SEC
; 	SBC #1
; 	BNE @tst2A



; ;write to video ram with
; ;complement value

; 	JSR @tst2_SET
; 	LDX #255-37

; @tst3A	LDY #64

; @tst3B	STX $2007
; 	DEX
; 	STX $2007
; 	DEX
; 	STX $2007
; 	DEX
; 	STX $2007
; 	DEX

; 	DEY
; 	BNE @tst3B
; 	DEX

; 	SEC
; 	SBC #1
; 	BNE @tst3A



; ;read video ram again

; 	JSR @tst2_SET
; 	LDX #255-37

; 	LDY $2007

; @tst4A	LDY #64

; @tst4B	CPX $2007
; 	BNE @CRAM_FAIL
; 	DEX
; 	CPX $2007
; 	BNE @CRAM_FAIL
; 	DEX
; 	CPX $2007
; 	BNE @CRAM_FAIL
; 	DEX
; 	CPX $2007
; 	BNE @CRAM_FAIL
; 	DEX

; 	DEY
; 	BNE @tst4B
; 	DEX

; 	SEC
; 	SBC #1
; 	BNE @tst4A

; 	LDA #2
; 	BNE @STORE_IT

; @CRAM_FAIL	LDA #8

; @STORE_IT	ORA @tst_BYTE
; 	STA @tst_BYTE
; 	RTS

; @tst2_SET
; 	LDA #$20
; 	LDX #37
; 	LDY #0
; 	STY $2006
; 	STY $2006
; 	RTS



; @KEYPAD	LDX #1
; 	STX $4016
; 	DEX
; 	STX $4016

; 	LDY #8
; @PAD	LDA $4016
; 	LSR
; 	ROL @PAD1
; 	DEY
; 	BNE @PAD
; 	RTS

; ***********************************************************************

; ;ROM check relocating code

; @ROM_CHECK
; 	ORG *,$20

; ;init y
; 	LDY #0

; @HERE2

; ;setbank to be checked

; 	LDA @BANK
; 	JSR @SET_BANK

; ;set up pointers + loop values

; 	LDA #$40/4
; 	STA @PAGE

; 	LDA #$80	; BANK POINTERS
; 	DB $85,@HERE+2	; STA @HERE+2
; 	LDA #$90
; 	DB $85,@HEREA+2
; 	LDA #$A0
; 	DB $85,@HEREB+2
; 	LDA #$B0
; 	DB $85,@HEREC+2

; 	LDX #0
; 	TXA

; 	CLC

; @HERE	ADC $8000,X
; 	BCC @HEREA
; 	INY
; 	CLC

; @HEREA	ADC $9000,X
; 	BCC @HEREB
; 	INY
; 	CLC

; @HEREB	ADC $A000,X
; 	BCC @HEREC
; 	INY
; 	CLC

; @HEREC	ADC $B000,X
; 	BCC @HERED
; 	INY
; 	CLC

; @HERED	INX
; 	BNE @HERE

; 	INC @HERE+2
; 	INC @HEREA+2
; 	INC @HEREB+2
; 	INC @HEREC+2

; ;loop until bank done

; 	DEC @PAGE
; 	BNE @HERE

; 	LDX @BANK
; 	CMP @SMILEY_NAME,X
; 	BNE @FAIL_IT

; 	LDA @BANK
; 	DEC @BANK
; 	CMP #SMILEY_LOBANK
; 	BNE @HERE2
; 	;BPL @HERE2

; 	LDA #1

; 	CPY @SMILEY_NAME+16
; 	BEQ @tst2_BALLS

; @FAIL_IT	LDA #4

; @tst2_BALLS	STA @tst_BYTE

; 	LDA @BANK_ON

; @SET_BANK	;called from earlier on
; 	TAX
; 	STA BANKTABLE,X
; 	RTS

; 	;* REMOVE THESE BYTES AT YOUR PERIL *
; 	DS 13,$EA
; 	DS 15,$EA

; @SMILEY_NAME
; @0	DB "* SMILEY TEST V1.3 "

; 	IF *-@0 <> 19
; 	ERROR "SMILEY TEXT MUST BE 19 BYTES LONG..."
; 	ENDIF

; @SMILEY_BANK	= *-1

; *************************************************************


; *************************************************************

; 	ORG *,*
; 	ORG *

; @GOOD_FACE	LDX #$55
; 	LDA #$1A	;green=good
; 	BNE @SHOW_FACE

; @BAD_FACE	LDX #$AA
; 	LDA #$16	;red=bad


; @SHOW_FACE
; 	;A=bg col, X= $55 or $aa

; 	STX @FACE_MASK

; 	LDX @TST_BYTE
; 	STX $4400

; ;set palette colours
; 	LDY #$00
; 	STY $2001

; 	LDX #$3F
; 	STX $2006
; 	STY $2006

; 	JSR @STORE

; 	ORA #$30
; 	JSR @STORE

; 	JSR @STORE

; 	;assume Y=0...

; ;download 1 solid character

; 	STY $2006
; 	STY $2006

; 	LDX #16
; 	DEY
; @1Q	STY $2007
; 	DEX
; 	BNE @1Q

; ;print face
; 	LDA #$20
; 	STA $2006
; 	STX $2006

; 	TXA
; 	LDY #4

; @L1	STA $2007
; 	INX
; 	BNE @L1
; 	DEY
; 	BNE @L1


; 	LDA #$23
; 	STA $2006
; 	LDA #$C8
; 	STA $2006

; 	LDY #0
; @L2	LDA @FACE_DATA,Y
; 	AND @FACE_MASK
; 	STA $2007
; 	INY
; 	CPY #48
; 	BCC @L2

; ;screen on, sprites off etc.
; 	LDX #$00
; 	STX $2000
; 	STX $2006
; 	STX $2006
; 	STX $2005
; 	STX $2005

; 	LDA #$0E
; 	STA $2001


; 	;assume X=0...

; ;wait a few seconds
; 	LDY #10
; @WAIT	DEC TEMP1
; 	BNE @WAIT
; 	DEX
; 	BNE @WAIT
; 	DEY
; 	BNE @WAIT

; ;screen off
; 	STY $2001

; ;it's a wrap@
; 	RTS




; @STORE:
; 	STA $2007
; 	STA $2007
; 	STA $2007
; 	STA $2007
; 	RTS

; @FACE_DATA:
; 	HEX 00C0FCFFFFF00000
; 	HEX 40FF87FFB7CF7300
; 	HEX 44FFFEB7FFFE7700
; 	HEX 44FF07F535CF7700
; 	HEX 00CFF9FAFAFD0300
; 	HEX 00000F0F0F030000
