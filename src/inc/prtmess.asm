.segment "CODE"

;***********   PRINT MESSAGE ROUTINE   ***************************************


;codes            ;;;all strings in C64 format
mend      = 255   ;;end string
mgosub    = 254   ;;followed by low high of gosub
mhorvert  = 253   ;;xor  horizontal/vertical mode
mlen      = 252   ;;this says the length of string to be entered
                  ;;this enables 0's & >128 to be sent
mloop     = 251   ;;start a loop, follow by number of times
mendloop  = 250   ;;end loop..
mdownline = 249   ;;jumps down by one line
mjump     = 248   ;;jumps to new pointer
mdownattr = 247   ;;jumps addr by 8  for attr
maddr     = 128   ;;about to send data address

mbufferhorvert	= 1     ;;filling fast buffer is limited to adddresses
                        ;;strings and setting vertical register

;e.g	defb maddr+hiaddr,loaddr,"ANDREW",mend
;	defb maddr+hiaddr,loaddr,mlen,5, 254,255,0,1,2, mend

;;N.B chrs 0 and >128 can not be printed directly you must tell it string len


;;limitations with this routine are :- strings must not be more than 255 bytes
;;and if 0's or >128 are printed, you must tell it the string length first

messagepointer	=  toplevvar1  ;2 bytes
lastaddress		=  toplevvar3  ;2 bytes
tempstore		=  toplevvar5  ;1
prtmessagefly:
    flybackvar
prtmessage:	;x=low byte  y=high byte of pointer
    stx messagepointer
    sty messagepointer+1
printwhatataddress:
    ldy #0
printwhatataddress1:
    lda (messagepointer),y
notendyet:
    iny
    cmp #128
    bcs notchr
    sta _vramdata
    bcc printwhatataddress1	;;this will always jump
notchr:
    cmp #240
    bcc mustbeaddress
    cmp #mend
    bne @1
    rts
@1:
    cmp #mlen
    beq setstringlen
    cmp #mgosub
    beq gosub
    cmp #mloop
    beq startloop
    cmp #mendloop
    beq endloop	
    cmp #mdownline
    beq downlinerou
    cmp #mdownattr
    beq attrdownrou
    jmp jumpnewmessagejump

printwhatataddress2:
    iny
    bne printwhatataddress1	;this will always jump

mustbeaddress:
    and #127
    sta lastaddress+1
    sta _vramaddr
    lda (messagepointer),y
    sta lastaddress
    sta _vramaddr
    jmp printwhatataddress2

setstringlen:
    lda (messagepointer),y
    iny
    tax
stringlen1:
    lda (messagepointer),y
    iny
    sta _vramdata
    dex
    bne stringlen1
    beq printwhatataddress1	;;must always jmp

startloop:
    lda (messagepointer),y
    iny
repeatingloop:
    pha
    tya
    pha
    jmp printwhatataddress1
    
endloop:
    sty tempstore
    pla
    tay
    pla
    sec
    sbc #1
    bne repeatingloop
    ldy tempstore
    jmp printwhatataddress1

gosub:
    lda messagepointer
    pha
    lda messagepointer+1
    pha
    lda (messagepointer),y
    tax
    iny
    lda (messagepointer),y
    iny
    sta messagepointer+1
    stx messagepointer
    tya
    pha
    jsr printwhatataddress
    pla
    tay
    pla
    sta messagepointer+1
    pla
    sta messagepointer
    jmp printwhatataddress1

downlinerou:
    lda #32
joindownline:
    clc
    adc lastaddress
    sta lastaddress
    tax
    bcc @1
    inc lastaddress+1
@1:
    lda lastaddress+1
    sta _vramaddr
    stx _vramaddr
    jmp printwhatataddress1

attrdownrou:
    lda #8
    bne joindownline

jumpnewmessagejump:
    lda (messagepointer),y
    tax
    iny
    lda (messagepointer),y
    sta messagepointer+1
    stx messagepointer
    jmp printwhatataddress
;--------------------------------------------------------------
addtoprintbuffer:
    ;;format  addr,addr,len,string
    stx messagepointer
    sty messagepointer+1
    ldy #0
    ldx vrampointer
contaddtobuffer:
    lda (messagepointer),y
    sta vrambuffer,x
    iny
    inx
    lda (messagepointer),y
    sta vrambuffer,x
    iny
    inx
    lda (messagepointer),y
    sta vrambuffer,x
    inx
    sta tempstore
    iny
addtoprintbufferlp:
    lda (messagepointer),y
    sta vrambuffer,x
    iny
    inx
    dec tempstore
    bne addtoprintbufferlp
    stx vrampointer
    rts
;---------------------------------------------------------
emptyprintbufferflyadd:
    jsr addtoprintbuffer
emptyprintbufferfly:
    flybackvar
emptyprintbuffer:
    ;;emptys print buffer that was filled by addtoprintbuffer
    ;;this should be automatically called on the interupt
    ;;however it can just be called if the screen is off

    lda vrampointer
    beq retmessage
    ldy #0
veryfastprintout:
    lda vrambuffer,y	
    and #127
    sta _vramaddr
    iny
    lda vrambuffer,y
    sta _vramaddr
    iny
    ldx vrambuffer,y
    iny
stringlen:
    lda vrambuffer,y
    sta _vramdata
    iny
    dex
    bne stringlen
    cpy vrampointer
    bne veryfastprintout
nomoremessage:
    lda #0
    sta vrampointer
retmessage:
    rts

