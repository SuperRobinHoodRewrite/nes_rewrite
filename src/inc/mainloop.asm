.segment "CODE"

anewgame:
    ; if title=1
    ; changebank 13
    jsr titlescreen
    ; changebank 12
    ; endif
; BELOW CODE NEEDS CLEANING UP STILL
;     jsr clearfullspriteblock

;     flybackvar
;     lda #0
;     sta completedgame
; startlives:
;     ldx #3
;     lda pad
;     and #lmask+amask
;     cmp #lmask+amask
;     bne normal3lives
;     ldx #4
; normal3lives:
;     stx lives
;     lda #0
;     sta hearts
;     jsr resetscore
;     jsr resetextras

;     lda #1
;     sta ingame

;     lda #robinchrs0.255
;     jsr copyblockofcompactedchrs

;     jsr resetrobinvars

;     jsr resetrobinvars1

;     lda #startlevel
;     sta mapno
;     jsr gointonewmap

; ingameloop:
;     lda #0
;     sta finishedloop
;     sta filledblockbuffer
;     flybackvar
;     lda #1
;     sta finishedloop
;     sta filledblockbuffer


;     lda juststartedlife
;     beq @11
;     jsr zoominstars
; @11:

;     if testpause=1
;     jsr moverobinaround
;     endif


;     lda pause
;     beq @12
;     lda pad
;     and #stmask
;     bne @21

;     lda #256-4*6
;     sta spriteblockpointer
;     ldy #80
;     lda robiny
;     cmp #124
;     bcs @20
;     ldy #128
; @20:
;     ldx #128-25-4
;     lda #pausespr
;     jsr printsprite
; @21:
;     jmp endofmainloop
; @12:
;     jsr doorrou

;     jsr printlives
;     jsr printscore
;     jsr printhearts



; ;

;     if showcoins=1
;     changebank 13
;     jsr showcoinsrou
;     changebank 12
;     endif

;     if testpause=1
;     lda pad
;     and #selmask
;     bne @2
;     lda pause
;     ora pause1
;     bne @1
; @2:
;     jsr moveman
; @1:
;     else
;     jsr moveman
;     endif
;     jsr animatelegs
;     jsr setxscroll
;     jsr updatearrows	
;     changebank 13
;     jsr printrobin
;     jsr floatupnumber
;     changebank 12
;     jsr updatespitters
; ;	jsr updatebats

;     lda counter
;     and #1
;     bne @5
;     jsr updateonscreens
;     jsr putextrason
;     changebank 13
;     jsr updatehearts
;     changebank 12
;     jmp @6
; @5:
;     changebank 13
;     jsr updatehearts
;     changebank 12
;     jsr putextrason
;     jsr updateonscreens
; @6:


; endofmainloop
;     jsr checkforpausekey
;     jsr checkoffscreen	

; nearendofmainloop
;     lda killed
;     beq @5
;     cmp #1
;     bne @7
;     lda #255
;     sta robiny
; @7:
;     lda pause
;     bne @5

;     dec killed
;     bne @5


; @8:
;     lda lives
;     beq theend
;     jsr resetrobinvars1	
;     jsr restoreoldrobin
;     lda #190
;     sta robininvinc
;     jsr gointonewmap

; @5:	

;     if testpause=1
;     lda pad
;     and #stmask+selmask
;     cmp #stmask+selmask
;     bne @1
; @6:
;     lda #&fd
;     sta fadecounter
; @1:
;     endif

;     lda fadecounter
;     cmp #255
;     beq @2
;     jmp ingameloop
; @2:


; theend	lda completedgame
;     bne completedthegame
;     lda #255
;     sta hearts
; completedthegame
;     jsr resetrobinvars1

;     jsr turninteroff
;     lda #0
;     sta ingame

;     if hiscore=1
;     changebank 13
;     jsr trytoentername ;displayhiscores
;     changebank 12
;     endif


;     jmp anewgame


; ;------------
; zoominstars:
;     dec juststartedlife
;     lda juststartedlife
;     cmp #30
;     bcc @1
;     and #3
;     bne @1
;     lda #firstappearfx
;     jsr soundfx
;     lda #2
;     jmp startstars
; @1:
;     rts
; ;------------------------------------------


