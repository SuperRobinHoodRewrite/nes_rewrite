.macpack cbm
;if hiscore=1
    
;****************************************
;*       high score sort routine	*
;	if hiscore=1
;	
;****************************************
;*       high score sort routine	*
;****************************************

;To use:-
;set up a highscore table
;eg maddr+$20,$20,14,"PETE A   12345"
;   maddr+$20,$40,14,"PETE B    1234"
;   maddr+$20,$60,14,"PETE C     123"
;   maddr+$20,$80,14,"PETE D      12"
;   maddr+$20,$a0,14,"PETE E       1"
;set SIZEOFMESSAGE to equal the length of each line (17 in the above)
;set NUMBERENTRIES to equal the number of names in the table (5 in the above)
;set SIZEOFSCORE to equal the length of the score string (eg "00000"=5)
;set SIZEOFNAME to equal the length of the name string (eg "peter1234"=9)
;set NAMETRAILNO to equal the no. of control bytes before the actual name

sizeofmessage = 17	;size of one line in table
            ;eg maddr+?,?,14,"peter....12345"=17 bytes long
numberentries = 10	;number of names in the table (5 in the above)
sizeofscore   = 7	;length of score string "00000"=5
sizeofname    = 9	;length of name string "PETER1234"=9
nametrailno   = 0	;the name is stored with maddr data before it
            ;eg maddr+?,?,length,"peter1234". This no. equals
            ;the no. of trailing bytes (3 in above)
namenumafter  = 1	;the number of bytes after the score
hiscoresinram = $7eD-17*10+1
highscores    = hiscoresinram

tryhiscore:
    move_val highscores+numberentries*sizeofmessage-sizeofscore-namenumafter,address
    lda #0
    sta hipos
    ldx #numberentries
aas:
    ldy #0
ias2:
    lda (address),y
    cmp #32		;if table has leading zeros these 3
    bne sdf		;lines are not needed
    lda #33+0
sdf:
    cmp score,y
    beq inge2
    bcc hire2
    jmp enbl2
inge2:
    iny
    cpy #sizeofscore
    bne ias2
    jmp hire2
enbl2:
    jmp ovhi2
hire2:
    move_w address,address2
    inc hipos
lidy:
    add16toval0 address,-sizeofmessage,address
    dex
    bne aas
ovhi2:
    lda hipos
    bne och1
    jmp notahigh
och1:
    cmp #1
    beq nufr

    move_val highscores+(numberentries-1)*sizeofmessage+nametrailno,address
    ldx hipos
    dex
    stx temp
MOVV:
    add16toval address,-sizeofmessage,address3
    slddrind address3,address,sizeofmessage-nametrailno-namenumafter
    move_w address3,address
    dec temp
    bne MOVV
nufr:
;;	jsr entername								;get the name

copyscoreacross:
    ldy #0
@1:
    lda score,y
    sta (address2),y
    iny
    cpy #sizeofscore
    bne @1

copynameacross:
    add16toval address2,-sizeofname,mappointer
    ldy #sizeofname-1
@1:
    lda name,y
    sta (mappointer),y
    dey
    bpl @1

    lda #numberentries
    sub hipos
    sta hipos
    rts

notahigh:
    lda #255	
    sta hipos
    rts
    ;jmp displayhiscores				;print the highs

;************************************************************************

namelen	= temp9
letter	= temp8

trytoentername:
    ldxy clearscr
    jsr prtmessage

missleadingnoughts:
    ldy #0
    sty temp		;indented=miss leading noughts
@1:
    lda score,y
    bit temp
    bmi @2
    cmp #0
    beq @3
    dec temp
    bne @2
@3:
    lda #<-3		
@2:
    sta score,y
    iny
    cpy #6
    bne @1

putincommer:
    ldx #5
    ldy #6
@2:
    lda score,x
    add #33
    sta score,y
    cpx #3
    bne @3
    dey
    lda #29
    sta score,y
@3:
    dey
    dex
    bpl @2

    jsr tryhiscore

displayhiscores:

    jsr setuphiscores

;	bit hipos
;	bmi @1
    lda tune
    cmp #1
    beq @1
    lda #3
.if musicon = 1
    jsr starttune
.endif
@1:
    jsr turninteron
    lda #0
    sta namelen
    lda #1
    sta letter

lookingathiscores:
    flybackvar
    bit hipos
    bmi @temp
    jsr entername
    jmp @2
@temp:
    ldx #$0d
    jsr pulsecolour
@2:

    lda pad
    and #stmask
    beq lookingathiscores
    lda debounce
    and #stmask
    bne lookingathiscores
    
    jmp turninterofffade
;----------------------------------------------	

setuphiscores:
    lda #hiscorechrs_index
    jsr copyblockofcompactedchrs
    lda #hiscorechrs0_index
    jsr copyblockofcompactedchrs
    lda #okchr_index
    jsr copyblockofcompactedchrs

    ldxy hiscorescreen
    jsr prtmessage

    lda #100
    sta robiny
    lda hipos
    cmp #254
    beq showcredits
    ldxy hiscoremess
    jsr prtmessage
    lda hipos
    bmi @1
    ldxy enternamemess
    jmp printedentername
@1:
    ldxy hiscorepressstart
    jmp printedentername
showcredits:
    ldxy credits
printedentername:
    jsr prtmessage

    jsr clearspriteblock

    ldxy hiscorescreencolours
    jmp setfade
;----------------------------------------------
entername:
    ;jmp chooseletter
    lda counter
    and #7
    bne chooseletter
    lda pad
    and #umask+rmask
    beq @1
    inc letter
    lda #leftrightletterfx
    jsr soundfx
@1:
    lda pad
    and #dmask+lmask
    beq @2
    dec letter
    lda #leftrightletterfx
    jsr soundfx
@2:
    lda letter
    and #31
    sta letter
    

chooseletter:
	lda pad
    and #amask
    beq @1
    lda debounce
    and #amask
    bne @1
    lda letter
    bne @2
    lda #stmask
    sta pad
    jmp @1

@2:
    lda namelen
    cmp #8
    beq @1
    lda letter
    jsr printachr
    lda letter
    ldy namelen
    sta (mappointer),y
    inc namelen
    lda #chooseletterfx
    jsr soundfx
    lda letter
    jmp flashletter
@1:

deleteletter:
	lda pad
    and #bmask
    beq @1
    lda debounce
    and #bmask
    bne @1
    ldy namelen
    beq @1
    dec namelen
    lda #30
    dey
    sta (mappointer),y
    jsr printachr
    lda #deleteletterfx
    jsr soundfx
    
@1:

flashletter:
	lda #0
    sta temp
    lda namelen
    asl
    asl
    asl
    add #64
    tax
    lda hipos
    asl
    asl
    asl
    add #63+32
    tay
    lda letter
    jsr pokesprite
    ldx #$0e
    jsr pulsecolour
    ldx #$11
    jmp pulsecolour
;------------------------------------------
printachr:	;a=chr to print
    tax
    move_val $2188-32,address
    ldy hipos
@1:
	add16toval0 address,32,address
    dey
    bpl @1
    ldy vrampointer
    lda address+1
    sta vrambuffer,y
    lda address
    add namelen
    sta vrambuffer+1,y
    lda #1
    sta vrambuffer+2,y
    txa
    sta vrambuffer+3,y
    tya
    add #4
    sta vrampointer
    rts
;----------------------------------------
hiscorescreen:
    .byte mgosub
    .word clearscr
    .byte maddr+$20,$20
    .byte $2B, $2C, $00, $00, $00, $32
    .byte mdownline
    .byte $2D, $2E, $2F, $30, $33, $34, $35, $36
    .byte mloop,18,$3a,mendloop
    .byte $3B, $3C, $3A, $3A, $3A, $3A
    .byte $20, $20, $20, $31, $37, $38
    .byte mloop,20,$39,mendloop
    .byte $3D, $3E, $39, $39, $39, $39
    .byte $3F, $40, $41, $42, $4E, $4F
    .byte mloop,20,$50,mendloop
    .byte $5C, $5D, $50, $50, $50, $50
    .byte $43, $44, $45, $46, $51, $52, $53, $54
    .byte mloop,18,$5b,mendloop
    .byte $5E, $5F, $5B, $5B, $5B, $5B
    .byte $47, $48, $49, $4A, $55, $56
    .byte mloop,20,$57,mendloop
    .byte $60, $55, $63, $64, $65, $00
    .byte $00, $4B, $4C, $4D, $58, $59
    .byte mloop,20,$5a,mendloop
    .byte $61, $62, $66, $67, $68, $00
    .byte maddr+$21,03,mloop,18
    .byte 00,$69,$6a,mloop,20,$20,mendloop,mlen,2,$89,$8a,mdownline,mendloop

    .byte mjump
    .word hiscorescr4

hiscorescr4:
	.byte mlen,3
    .byte $00, $96, $97
    .byte mloop,20,mlen,1,$20,mendloop,mlen,2,$B4,$B5
    .byte mdownline,mlen,3
    .byte $93, $98, $99
    .byte mloop,10,mlen,2,$9A,$9B,mendloop,mlen,3
    .byte $B6, $B7, $B8
    .byte mdownline,mlen,32-6
    .byte $B9, $BB, $BC, $BD, $BE, $BD, $BE, $BD, $BE, $BD, $BE, $BD, $BE, $BD, $BE, $BD, $BE, $BD, $BE, $BD, $BE, $BD, $BE, $C2, $C3, $BA
    .byte mdownline,mlen,32-9
    .byte $00, $BF, $00, $C0, $C1, $C0, $C1, $C0, $C1, $C0, $C1, $C0, $C1, $C0, $C1, $C0, $C1, $C0, $C1, $C0, $C1, $C0, $C1
    .byte maddr+$23,$c0,mlen,8*8
    .byte $50, $50, $50, $50, $50, $50, $50, $50, $55, $25, $05, $05, $05, $05, $85, $55, $00 ,$22, $00, $00, $00, $00, $88, $00, $00, $22, $00, $00, $00, $00, $88, $00
    .byte $00, $22, $00, $00, $00, $00, $88, $00, $00, $22, $00, $00, $00, $00, $88, $00, $00 ,$22, $00, $00, $00, $00, $88, $20, $00, $02, $00, $00, $00, $00, $08, $02
    .byte mend
hiscorefancybits:
    .byte mgosub
    .word hiscorebit
dofleur:
	.byte maddr+$22,$e7,mgosub
    .word fleurdlys
    .byte maddr+$22,$f7

fleurdlys:
	.byte mlen,2,$8b,$8c,mdownline
    .byte mlen,3,$9c,$9d,$9e,mdownline
    .byte mlen,3,$9f,$a0,$a1,mdownline
    .byte mlen,2,$a2,$a3,mend


hiscorebit:
	.byte maddr+$21,$08
    .byte $6b, $20, $6c
    .byte mdownline,mlen,16
    .byte $6D, $6E, $6F, $70, $75, $76, $77, $78, $7D, $7E, $7F, $80, $85, $86, $75, $76
    .byte mdownline,mlen,16
    .byte $71, $72, $73, $74, $79, $7A, $7B, $7C, $81, $82, $83, $84, $87, $88, $79, $7A
    .byte mend

hiscorepressstart:
    .byte maddr+$23,$0e
    scrcode           "PRESS"
    .byte mdownline
    scrcode "START"
    .byte mjump
    .word flashingbit

enternamemess:
    .byte maddr+$23,$0a
    scrcode "PLEASE ENTER"
    .byte mdownline
    scrcode " YOUR NAME"
flashingbit:
	.byte mgosub
    .word hiscorefancybits
    .byte maddr+$23,$f2,mlen,4,$0c,$0f,$0f,$03
    .byte mend


credits:
	.byte maddr+$21,$07
    scrcode "     CREDITS"      
    .byte mdownline, mdownline
    scrcode "DESIGNED BY^^"     
    .byte mdownline
    scrcode "  THE OLIVER TWINS"
    .byte mdownline, mdownline
    scrcode "GRAPHICS BY^^"     
    .byte mdownline
    scrcode "        PAUL ADAMS"
    .byte mdownline
    scrcode "MUSIC FX BY^^"     
    .byte mdownline
    scrcode "     GAVIN RAEBURN"
    .byte mdownline
    scrcode "LICENSED BY^^"     
    .byte mdownline
    scrcode "   CODEMASTERS LTD"
    .byte mdownline, mdownline
    scrcode "OTHER GAMES BY"    
    .byte mdownline
    scrcode "THE OLIVER TWINS^^"
    .byte mdownline, mdownline
    scrcode "THE F^ A^ OF DIZZY"
    .byte mdownline
    scrcode "  BMX SIMULATOR"   
    .byte mdownline
    scrcode "     FIREHAWK"     
    .byte mdownline
    scrcode "  GO"
    .byte 27
    scrcode " DIZZY GO"
    .byte 27
    .byte mend


hiscorescreencolours:
    .byte $21, $27, $16, $09
    .byte $21, $20, $27, $0e
    .byte $21, $27, $16, $0e
    .byte $21, $37, $27, $09
    
    .byte $21, $27, $11, $09
    .byte $21, $20, $15, $0e
    .byte $21, $00, $00, $00
    .byte $21, $0e, $0e, $0e
hiscoremess:
	.byte maddr+$21,$88,mgosub
    .word hiscoresinram
    .byte mend


;----------------------------------------------
copyhiscorestoram:
    cpx #$97
    beq dontcopyinscores
copyhis:
    ldx #17*10+1
copyhiscores:
	lda initnames-1,x
    sta hiscoresinram-1,x
    dex
    bne copyhiscores
    rts
dontcopyinscores:
    ldx #0
@1:
	ldy #0
@3:
	lda checkhiscores,y
    bpl @2
    cmp #131
    bcs @2

    cmp #128
    bne @5
    lda hiscoresinram,x
    cmp #33
    bcs copyhis
    jmp @4
@5:
    lda hiscoresinram,x
    cmp #$1e
    beq @4
    cmp #32
    bcc copyhis
    cmp #43
    bcs copyhis
    jmp @4

@2:
	cmp hiscoresinram,x
    bne copyhis
@4:
	inx
    iny
    cpy #17
    bne @3
    cpx #10*17
    bne @1
    lda hiscoresinram+17*10
    cmp #255
    bne copyhis
    rts
;-----------------------------------------
initnames:
	scrcode "FIRST^^^^"
    .byte 30,35,33,29,33,33,33,mdownline
    scrcode "SECOND^^^"
    .byte 30,34,41,29,33,33,33,mdownline
    scrcode "THIRD^^^^"
    .byte 30,34,39,29,33,33,33,mdownline
    scrcode "FOURTH^^^"
    .byte 30,34,37,29,33,33,33,mdownline
    scrcode "FIFTH^^^^"
    .byte 30,34,35,29,33,33,33,mdownline
    scrcode "SIXTH^^^^"
    .byte 30,34,33,29,33,33,33,mdownline
    scrcode "SEVENTH^^"
    .byte 30,30,41,29,33,33,33,mdownline
    scrcode "EIGHTH^^^"
    .byte 30,30,39,29,33,33,33,mdownline
    scrcode "NINTH^^^^"
    .byte 30,30,37,29,33,33,33,mdownline
    scrcode "TENTH^^^^"
    .byte 30,30,35,29,33,33,33,mdownline,mend
name:
	scrcode "^^^^^^^^^"
checkhiscores:
    .byte 9,128 ; it was defs before so I might be wrong here
    .byte 129,129,129,29,129,129,129,mdownline



;endif
