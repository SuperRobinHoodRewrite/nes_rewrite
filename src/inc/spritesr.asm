
frmwidth     = toplevvar1
frmheight    = toplevvar2
tempwidth    = toplevvar3
tempheight   = toplevvar4
xcoord1      = toplevvar5
ycoord1      = toplevvar6
addx         = toplevvar7
addy         = toplevvar8
tempattr     = toplevvar9
tempchr      = toplevvar10
spriterev    = temp1
xcoord       = temp2
ycoord       = temp3
whichsprite  = temp4
frmsinspr    = temp5
xcoordh1     = temp6
xcoordh      = temp7
spritetempxh = temp8
sprchrs      = address3 ;;;and address4

allowbehind  = 1	;if set slightly slower sprites,but setting spritebehind
                    ;to 32 makes sprite go behind chars

.segment "ZEROPAGE"
spritebehind: .res 1
spritecolour: .res 1
spritetempx:  .res 1
.segment "CODE"

windowedge    = 30*8     ;y window, for games with panels  ;just for bmx

;;;USES   address1,address2,address3,address4
;;temp1 to temp8

;;N.B. this sprite routine has no ability for boundries.

printspriterev:	;;same parameters
    sec
    bcs printspriteposrev
printsprite:	;;a=sprite no.  X=x coord  Y=y coord
    clc
printspriteposrev:
    stx xcoord
    ldx #0
    stx spriterev
    ror spriterev
    sty ycoord
    asl
    tay
;--------------------------------------------------
    bcs @2 		;this piece of code allows 256 sprites
    lda spritetable,y
    sta address2
    lda spritetable+1,y
    sta address2+1
    jmp @1
@2:
    lda spritetable+$100,y
    sta address2
    lda spritetable+1+$100,y
    sta address2+1
@1:
;---------------------------------------------------
;	lda (spritetablepointer),y  ;this piece of code allows several
;	sta address2		;different sprite tables of 128 sprs
;	iny			;therefore you can have any no. of
;	lda (spritetablepointer),y	;sprites, but need to set the pointer
;	sta address2+1		;before entering the subgame, etc.
;---------------------------------------------------
        ;;address2 now points to sprite defs
    ldy #0
    lda (address2),y
    sta frmsinspr	;;no of frms to make up this sprite
    lda ycoord
    add #ydisplace
    sta ycoord
    iny
eachfrminspritelp:
        ;;;get pallette/flip byte
    lda (address2),y
    ldx spriterev
    bpl @2
    eor #%01000000
@2:
    sta temp
    bit playermask
    beq @1
    clc
    adc spritecolour		;player colour
@1:
    and #%11000011
    sta tempattr


    lda #8
    asl temp		;;vert
    bcc notvert
    lda #<-8
notvert:
    sta addy
    lda #8
    asl temp		;;hor
    bcc nothor
    lda #<-8
nothor:
    sta addx
    iny

    lda #0
    tax
    asl temp
    bcc nodisplacements
    lda (address2),y
    tax
    iny
     lda (address2),y
    iny
nodisplacements:
    stx xcoord1
    sta ycoord1
dothesprite:
    lda (address2),y
    asl temp
    bcc mustbespr
    tax
    sta sprchrs+0
    lda #1
    asl temp
    bcc nottwobytwo
    asl
    inx
    stx sprchrs+1
    inx
    stx sprchrs+2
    inx
    stx sprchrs+3
nottwobytwo:
    sta frmwidth
    sta frmheight
    sty whichsprite
    lda #>sprchrs
    sta address1
    lda #<sprchrs
    sta address1+1
    ldy #0
    jmp mustbejustchr
mustbespr:
    sta address1
    iny
    sty whichsprite
    lda (address2),y
    sta address1+1		;;address point to frm
    ldy #0
    lda (address1),y
    lsr
    lsr
    lsr
    lsr
    sta frmwidth
    lda (address1),y
    and #15
    sta frmheight
    iny
mustbejustchr:

    lda xcoord1
    bit spriterev
    bmi @1
    bit addx
    bpl @2
    ldx frmwidth
    clc
    adc frmtimes8,x
    jmp @2
@1:
    bit addx
    bmi @3
    ldx frmwidth
    clc
    adc frmtimes8,x
@3:
    eor #255
    add #<-8+1
    
@2:
    clc
    adc xcoord
    sta xcoord1

    lda addy
    bpl notflippedover
    sec
    sbc ycoord1
    sta ycoord1
notflippedover:
    lda ycoord
    clc
    adc ycoord1
    sta ycoord1

    ldx spriteblockpointer
    beq nomorespritechrsleft
yspritelp:
    lda frmwidth
    sta tempwidth
    lda xcoord1
    sta spritetempx	
xspritelp:
    lda ycoord1
    sta spriteblock,x
    lda (address1),y
    iny
    inx
    sta spriteblock,x
    lda tempattr
    ;if allowbehind=1
    ora spritebehind
    ;endif
    inx
    sta spriteblock,x
    inx
    lda spritetempx
    sta spriteblock,x
    inx
    beq nomorespritechrsleft
@1:
    clc
    adc addx
    sta spritetempx
    dec tempwidth
    bne xspritelp
    
    lda ycoord1
    clc
    adc addy
    sta ycoord1
    dec frmheight
    bne yspritelp

nomorespritechrsleft:
    stx spriteblockpointer
    dec frmsinspr
    beq @2
    ldy whichsprite
    iny
    jmp eachfrminspritelp
@2:
    rts

;******************END  OF   SPRITE  ROUTINE*********************************
frmtimes8:  .byte 0,0,8,16,24,32,40,48,56,64
playermask: .byte %00000100

;*****************WINDOW SPRITE ROUTINE***************************************************************************
;;;difference with window sprite is Xh sould be stored into xcoordh,then call
winprintspritereversed:		;;same parameters
    sec
    bcs winprintspriteposrev
winprintsprite:	;;a=sprite no.  X=x coord  Y=y coord
    clc
winprintspriteposrev:
    stx xcoord
    ldx #0
    sta spriterev
    ror spriterev
    ldx xcoordh
    inx
    cpx #3
    bcc @5
@3:
    rts
@5:
    cpx #1
    beq @4
    bcc @6
    ldx xcoord
    cpx #<-24
    bcc @4
    rts
@6:
    ldx xcoord
    cpx #24
    bcs @3

@4:
    sty ycoord
    asl
    tay
;--------------------------------------------------
    bcs @2 		;this piece of code allows 256 sprites
    lda spritetable,y
    sta address2
    lda spritetable+1,y
    sta address2+1
    jmp @1
@2:
    lda spritetable+$100,y
    sta address2
    lda spritetable+1+$100,y
    sta address2+1
@1:
;---------------------------------------------------
;	lda (spritetablepointer),y  ;this piece of code allows several
;	sta address2		;different sprite tables of 128 sprs
;	iny			;therefore you can have any no. of
;	lda (spritetablepointer),y	;sprites, but need to set the pointer
;	sta address2+1		;before entering the subgame, etc.
;---------------------------------------------------

        ;;address2 now points to sprite defs
    ldy #0
    lda (address2),y
    sta frmsinspr	;;no of frms to make up this sprite
    lda ycoord
    add #ydisplace
    sta ycoord

    iny
wineachfrminspritelp:
    lda xcoordh
    sta xcoordh1

        ;;;get pallette/flip byte
    lda (address2),y
    bit spriterev
    bpl @2
    eor #%01000000
@2:
    sta temp
    bit playermask
    beq @1
    clc
    adc spritecolour		;player colour
@1:
    and #%11000011
    sta tempattr

    lda #8
    asl temp		;;vert
    bcc winnotvert
    lda #<-8
winnotvert:
    sta addy
    lda #8
    asl temp		;;hor
    bcc winnothor
    lda #<-8
winnothor:
    sta addx
    iny

    lda #0
    tax
    asl temp
    bcc winnodisplacements
    lda (address2),y
    tax
    iny
     lda (address2),y
    iny
winnodisplacements:
    stx xcoord1
    sta ycoord1
windothesprite:
    lda (address2),y
    asl temp
    bcc winmustbespr
    tax
    sta sprchrs+0
    lda #1
    asl temp
    bcc winnottwobytwo
    asl
    inx
    stx sprchrs+1
    inx
    stx sprchrs+2
    inx
    stx sprchrs+3
winnottwobytwo:
    sta frmwidth
    sta frmheight
    sty whichsprite
    lda #>sprchrs
    sta address1
    lda #<sprchrs
    sta address1+1
    ldy #0
    jmp winmustbejustchr
winmustbespr:
    sta address1
    iny
    sty whichsprite
    lda (address2),y
    sta address1+1		;;address point to frm
    ldy #0
    lda (address1),y
    lsr
    lsr
    lsr
    lsr
    sta frmwidth
    lda (address1),y
    and #15
    sta frmheight
    iny
winmustbejustchr:
;------------------------------------------------------------------------
    bit spriterev
    bmi @1

    lda xcoord1
    bmi @8
    inc xcoordh1
@8:
    bit addx
    bpl @5
    ldx frmwidth
    clc
    adc frmtimes8,x
    bcs @2
@5:
    dec xcoordh1
    jmp @2

@1:
 ;--------------------------
    lda xcoord1
    bmi @9
    dec xcoordh1
@9:
    bit addx
    bmi @3
    ldx frmwidth
    clc
    adc frmtimes8,x
    bcc @3	
    dec xcoordh1
@3:
    eor #255
    clc
    adc #<-8+1
    bcs @7
    dec xcoordh1
@7:
;----------------------------------
@2:
    clc
    adc xcoord
    sta xcoord1
    bcc @4
    inc xcoordh1
@4:
;-----------------------------------------------------------------------
aroundaddx:
    lda addy
    bpl winnotflippedover
    sec
    sbc ycoord1
    sta ycoord1
winnotflippedover:
    lda ycoord
    clc
    adc ycoord1
    sta ycoord1

    ldx spriteblockpointer
    beq winnomorespritechrsleft
winyspritelp:
    lda frmwidth
    sta tempwidth
    lda xcoord1
    sta spritetempx	
    lda xcoordh1
    sta spritetempxh
winxspritelp:
    lda spritetempxh
    bne winthischrnotonscreen
    lda ycoord1
    cmp #windowedge
    bcs winthischrnotonscreen
    sta spriteblock,x
    lda (address1),y
    inx
    sta spriteblock,x
    lda tempattr
    ;if allowbehind=1
    ora spritebehind
    ;endif
    inx
    sta spriteblock,x
    inx
    lda spritetempx
    sta spriteblock,x
    inx
    beq winnomorespritechrsleft
winthischrnotonscreen:
    iny
    lda addx
    bmi @1	
    lda spritetempx
    clc
    adc addx
    sta spritetempx
    bcc @2
    inc spritetempxh
    jmp @2

@1:	
    add spritetempx
    sta spritetempx
    bcs @2
    dec spritetempxh
@2:
    dec tempwidth
    bne winxspritelp
    
    lda ycoord1
    clc
    adc addy
    sta ycoord1
    dec frmheight
    bne winyspritelp

winnomorespritechrsleft:
    stx spriteblockpointer
    dec frmsinspr
    beq @3
    ldy whichsprite
    iny
    jmp wineachfrminspritelp
@3:
    rts

    


;******************END  OF  WINDOW SPRITE  ROUTINE*********************************
pokesprite:	;;;poking in a single chr sprite
    ;x=x  y=y A=chr temp=attribute
    stx toplevvar1
    ldx spriteblockpointer
    beq nomorespriteplaces
    sta spriteblock+1,x
    lda toplevvar1
    sta spriteblock+3,x
    tya
    sta spriteblock+0,x
    lda temp
    sta spriteblock+2,x
    txa
    add #4
    sta spriteblockpointer
nomorespriteplaces:
    rts

;-------------------------------------
pokesprite2by2:	;;;pokes in a 2by2 chr sprite
    ;x=x  y=y A=chr to start at temp=attribute, this indicates flips
                ; 128=vert  64=hor
    stx toplevvar1
    ldx spriteblockpointer
    bne @2
@3:
    rts
@2:
    cpx #240 ;4
    bcs @3
    sta spriteblock+1,x
    adc #1
    sta spriteblock+1+4,x
    adc #1
    sta spriteblock+1+8,x
    adc #1
    sta spriteblock+1+12,x
    lda temp
    sta spriteblock+2,x
    sta spriteblock+2+4,x
    sta spriteblock+2+8,x
    sta spriteblock+2+12,x
    and #128
    bne flippedvert
    tya
    add #ydisplace
    sta spriteblock+8,x
    sta spriteblock+12,x
    add #<-8
    sta spriteblock+0,x
    sta spriteblock+4,x
    jmp nowhor
flippedvert:
	tya
    add #ydisplace
    sta spriteblock+0,x
    sta spriteblock+4,x
    add #<-8
    sta spriteblock+8,x
    sta spriteblock+12,x
nowhor:
	lda toplevvar1
    bit temp
    bvs flippedhor
    sta spriteblock+3+4,x
    sta spriteblock+3+12,x
    add #<-8
    bcs @1
    lda #245
    sta spriteblock+0+0,x
    sta spriteblock+0+8,x
@1:
    sta spriteblock+3+0,x
    sta spriteblock+3+8,x
    jmp done2by2
flippedhor:
	sta spriteblock+3+0,x
    sta spriteblock+3+8,x
    add #<-8
    bcs @1
    lda #245	
    sta spriteblock+0+4,x
    sta spriteblock+0+12,x
@1:
    sta spriteblock+3+4,x
    sta spriteblock+3+12,x
done2by2:
	txa
    add #16
    sta spriteblockpointer
nomore2by2:
	rts
