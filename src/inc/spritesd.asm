.segment "CODE"

spritetable: ;;defw pointers  to spritedefs   256 max
	sprvar robinheads
.addr head0, head1, head2, head3
	sprvar robinbodies
.addr robinbody0, robinbody1, robinbody2, robinbody3
.addr robinbody4, robinbody5, robinbody6, robinbody3
	sprvar bodyfiring
.addr robinstanding, bodyfire0, bodyfire1, bodyfire2, bodyfire3
	sprvar legsrunning
.addr legsrunning0, legsrunning1, legsrunning2, legsrunning3
.addr legsrunning4, legsrunning5, legsrunning6, legsrunning3
	sprvar morelegs
.addr legsstanding, legshalfcrouch, bodyfullcrouch, legsfullcrouch, legsjumping
.addr bodyonladder, legsonladder
 	sprvar barrels
.addr barrel0, barrel1, barrel2, barrel1
;	sprvar balls
; defw steelball,spikedball
	sprvar canon
.addr canons	
	sprvar platform
.addr platformspr
	sprvar titlelogos
.addr codemasterlogo, camericalogo, pressstart
	sprvar deadarrows
.addr deadarrow1, deadarrow2, deadarrow3, deadarrow4
	sprvar trampet
.addr trampet1, trampet2
;	sprvar key
; defw keyspr	
	sprvar spider
.addr spiderspr,spiderspr1
	sprvar bat
.addr bat1, bat2
	sprvar eyes
.addr eye1, eye2, eye3, eye4
;	sprvar rat
; defw rat1,rat2
	sprvar guard
.addr guardlow, guardhigh, guardlow1, guardhigh1
;	sprvar treasure
; defw chest,crown,diamond,shield,goblet,ruby,duffchest
	sprvar fire
.addr fire1, fire2, fire3, fire4, fire5
	sprvar marion
.addr marions
	sprvar pausespr
.addr pauses


spritedefs:	 ;;no. of paras,    X dis,Y dis,pallette/flip,frmlo,frmhi
	;;no of paras,  pallette/flip   ,X  ,Y  ,frmlo  ,frmhi
;;N.B. to make more efficent data pallette/flip byte holds extra stuff
;;     0        0      0           0         0        0        0        0
;    vert      hor   X/Y dis    point to   2x2 spr          pallette pallette
;                               chr, not   start from
;    			 lo,hi spr  chr



codemasterlogo:
	.byte  7,%00000000,>cmdata0,<cmdata0
	.byte  %00100000,<-3,8,>cmdata1,<cmdata1
	.byte  %00100000,<-8,16,>cmdata2,<cmdata2
	.byte  %00100000,<-8,24,>cmdata3,<cmdata3
	.byte  %00100000,<-5,32,>cmdata4,<cmdata4
	.byte  %00100000,5,40,>cmdata5,<cmdata5
	.byte  %00110000,<-8,36,$f2
cmdata0:
	.byte $41
	.byte $d5, $d6, $d7, $d8
cmdata1:
    .byte $51
	.byte $d9, $da, $db, $dc, $dd
cmdata2:
	.byte $61
	.byte $de, $df, $e0, $e1, $e2, $e3
cmdata3:
	.byte $61
	.byte $e4, $e5, $e6, $e7, $e8, $e9
cmdata4:
	.byte $51
	.byte $ea, $eb, $ec, $ed, $ee
cmdata5:
	.byte $31
	.byte $ef, $f0, $f1
camericalogo:
	.byte 2,%00000001,     >camdata0,<camdata0
	.byte   %00100001,6,16,>camdata1,<camdata1

camdata0:
	.byte $82
	.byte $dc, $dd, $de, $df, $e0, $e1, $e2, $e3
	.byte $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb
camdata1:
	.byte $61
	.byte $ec, $ed, $ed, $ed, $ed, $ee

pressstart:
	.byte 2,%00000010,>psdata,<psdata
	.byte   %00100010,0,10,>psdata1,<psdata1

psdata:
	.byte $51
	.byte $ef, $f0, $f1, $f2, $f2	
psdata1:
	.byte $51
	.byte $f2, $f3, $f4, $f0, $f3

head0:
	.byte 1,%00111100,<-5,<-15,1

head1:
	.byte 1,%00111100,<-5,<-15,5
	
head2:
	.byte 1,%00111100,<-5,<-15,9

head3:
	.byte 1,%01111100,<-8,<-15,$d

robinbody0:
	.byte 1,%00100100,<-7,<-14,>body0data,<body0data
robinbody1:
	.byte 1,%00100100,<-9,<-15,>body1data,<body1data
robinbody2:
	.byte 1,%00100100,<-8,<-13,>body2data,<body2data
robinbody3:
	.byte 1,%00111100,<-6,<-12,$23
robinbody4:
	.byte 1,%00111100,<-6,<-11,$27
robinbody5:
	.byte 1,%00100100,<-8,<-13,>body5data,<body5data
robinbody6:
	.byte 1,%00111100,<-7,<-13,$31

body0data:
	.byte $32
	.byte $11, $12, $13, $14, $15, $16
body1data:
	.byte $32
	.byte $17, $18, $19, $1a, $1b, $1c
body2data:
	.byte $32
	.byte $1d, $1e, $1f, $20, $21, $22
body5data:
	.byte $32
	.byte $2b, $2c, $2d, $2e, $2f, $30

;---------
robinstanding:
    .byte 1,%00100100,<-8,<-15,>robstanddata,<robstanddata
robstanddata:
	.byte $23
	.byte $35, $36, $37, $38, $39, $3a
bodyfire0:
	.byte 3,%00100100,<-8,<-15,>bodyfire0data0,<bodyfire0data0
	.byte   %00100100,8-8,<-15,>bodyfire0data1,<bodyfire0data1
	.byte   %00100100,16-8,<-11,>bodyfire0data2,<bodyfire0data2
bodyfire0data0:
    .byte $12
	.byte $35, $3b
bodyfire0data1:
    .byte $13
	.byte $36, $3c, $3d
bodyfire0data2:
    .byte $12
	.byte $3e, $3f
bodyfire1:
	.byte 2,%00100100,<-8,<-15,>bodyfire1data,<bodyfire1data
	.byte   %00110100,16-8,16-15,$44
bodyfire1data:
    .byte $32
	.byte $35, $36, $40, $41, $42, $43
bodyfire2:
	.byte 2,%00100100,<-8,<-15,>bodyfire2data,<bodyfire2data
	.byte   %00110100,16-8,16-15,$49
bodyfire2data:
    .byte $32
	.byte $35, $45, $46, $41, $47, $48
bodyfire3:
	.byte 2,%00100100,<-8,<-15,>bodyfire3data,<bodyfire3data
	.byte   %00110100,16-8,16-15,$4e
bodyfire3data:
    .byte $32
	.byte $35, $4a, $4b, $41, $4c, $4d
;-----------------
legsrunning0:
	.byte 2,%00100100,<-6,<-14,>legsrunning0data0,<legsrunning0data0
	.byte   %00100100,<-8,<-6,>legsrunning0data1,<legsrunning0data1
legsrunning0data0:
    .byte $21
	.byte $4f, $50
legsrunning0data1:
    .byte $21
	.byte $51, $52

legsrunning1:
    .byte 2,%00100100,<-13,<-13,>legsrunning1data,<legsrunning1data
	.byte   %00110100,16-13,<-5,$56
legsrunning1data:
    .byte $31
	.byte $53, $54, $55

legsrunning2:
	.byte 1,%00111100,<-10,<-14,$57

legsrunning3:
    .byte 2,%00100100,<-6,<-14,>legsrunning3data,<legsrunning3data
	.byte   %00110100,<-6,<-6,$5d
legsrunning3data:
    .byte $21
	.byte $5b, $5c

legsrunning4:
    .byte 2,%00100100,<-7,<-14,>legsrunning4data0,<legsrunning4data0
	.byte   %00100100,<-8,<-6,>legsrunning4data1,<legsrunning4data1
legsrunning4data0:
    .byte $21
	.byte $5e, $5f
legsrunning4data1:
    .byte $21
	.byte $51, $52

legsrunning5:
    .byte 2,%00100100,<-12,<-13,>legsrunning5data,<legsrunning5data
	.byte   %00110100,16-12,<-5,$56
legsrunning5data:
    .byte $31
	.byte $53, $60, $55

legsrunning6:
    .byte 1,%00100100,<-9,<-14,>legsrunning6data,<legsrunning6data
legsrunning6data:
    .byte $22
	.byte $57, $61, $59, $5a
;---------------
legsstanding:
	.byte 1,%00111100,<-4,<-14,$62
legshalfcrouch:
    .byte 2,%00100100,<-7,<-13,>legshalfcrouchdata0,<legshalfcrouchdata0
 	.byte      %00100100,<-8,<-5,>legshalfcrouchdata1,<legshalfcrouchdata1
legshalfcrouchdata0:
    .byte $21
	.byte $66, $67
legshalfcrouchdata1:
    .byte $21
	.byte $68, $69

bodyfullcrouch:
    .byte 1,%00100100,<-5,<-7,>bodyfullcrouchdata,<bodyfullcrouchdata
bodyfullcrouchdata:
    .byte $21
	.byte $6a, $6b
legsfullcrouch:
    .byte 1,%00100100,<-9,<-7,>legsfullcrouchdata,<legsfullcrouchdata
legsfullcrouchdata:
    .byte $31
	.byte $6c, $6d, $6e

legsjumping:
    .byte 3,%00100100,<-13,<-10,>legsjumpdata,<legsjumpdata
 	.byte  %00110100,16-13,<-11,$71
	.byte  %00110100,18-13,<-5,$56
legsjumpdata:
    .byte $21
	.byte $6f, $70

bodyonladder:
    .byte 1,%00111100,<-9,<-15,$72
legsonladder:
    .byte 2,%00100100,<-5,<-12,>legsladderdata,<legsladderdata
	.byte   %00110100,<-5,<-4,$78
legsladderdata:
    .byte $21
	.byte $76, $77
;--------------------
barrel0:
    .byte 4,%00110001,<-8,<-8,$a8
	.byte   %01110001,0 ,<-8,$a8
	.byte   %10110001,<-8,<-8,$a8
	.byte   %11110001,0 ,<-8,$a8
barrel1:
    .byte 4,%00110001,<-8,<-8,$aa
	.byte   %00110001,0 ,<-8,$ab
	.byte   %11110001,<-8,<-8,$ab
	.byte   %11110001,0 ,<-8,$aa
barrel2:
	.byte 4,%00110001,<-8,<-8,$a9
	.byte   %01110001,0 ,<-8,$a9
	.byte   %10110001,<-8,<-8,$a9
	.byte   %11110001,0 ,<-8,$a9

;steelball	.byte 1,%00111010,<-8,<-8,$af
;spikedball	.byte 1,%00111010,<-9,<-8,$b3
canons:
	.byte 1,%00100010,<-12,0,>canondata,<canondata
platformspr:
	.byte 1,%00100001,<-12,1,>platdata,<platdata

trampet1:
	.byte 4,%00110010,<-8,0,$a2
	.byte   %01110010,0 ,0,$a2
	.byte   %00110010,<-8,8,$a3
	.byte   %01110010,0 ,8,$a3
trampet2:
	.byte 2,%00110010,<-8,8,$a1
	.byte   %01110010,0 ,8,$a1

;keyspr	.byte 1,%00111001,<-8,<-8,$9b

spiderspr:
	.byte 2,%00100001,<-8,<-8,>spider1,<spider1
	.byte   %01100001,0,<-8 ,>spider1,<spider1
spiderspr1:
	.byte 2,%00100001,<-8,<-8,>spider2,<spider2
	.byte   %01100001,0,<-8 ,>spider2,<spider2

spider1:
	.byte $12, $a4, $a5
spider2:
	.byte $12, $a6, $a7

bat1:
	.byte 2,%00110001,<-8,<-4,$9f
	.byte   %01110001,0,<-4,$9f
bat2:
	.byte 2,%00110001,<-8,<-5,$a0
	.byte   %01110001,0,<-5,$a0

coindata:
	.byte $12, $b3, $b4
canondata:
	.byte $32, $b7, $b8, $b9, $ba, $bb, $bc
platdata:
	.byte $31, $ac, $ad, $ae



;--------------------
deadarrow1:
	.byte 4,%00110001,<-16,16,$c7
	.byte   %01110001,16,16,$c7
	.byte   %11110001,16,<-16,$c7
	.byte   %10110001,<-16,<-16,$c7
deadarrow2:
	.byte 4,%00110001,<-12,12,$c7
	.byte   %01110001,12,12,$c7
	.byte   %11110001,12,<-12,$c7
	.byte   %10110001,<-12,<-12,$c7
deadarrow3:
	.byte 4,%00110001,<-8,8,$c7
	.byte   %01110001,8,8,$c7
	.byte   %11110001,8,<-8,$c7
	.byte   %10110001,<-8,<-8,$c7
deadarrow4:
	.byte 4,%00110001,<-4,4,$c7
	.byte   %01110001,4,4,$c7
	.byte   %11110001,4,<-4,$c7
	.byte   %10110001,<-4,<-4,$c7
;-----------------------
eye1:
	.byte 2,%00110001,<-4,0,$c5
	.byte   %01110001,4,0,$c5

eye2:
	.byte 2,%00110001,<-3,0,$c6
	.byte   %00110001,2,0,$c6

eye3:
	.byte 2,%11110001,<-3,<-8,$c6
	.byte   %11110001,3,<-8,$c6

eye4:
	.byte 2,%11110001,<-2,<-8,$c6
	.byte   %11110001,4,<-8,$c6
;------------------------
;rat1	.byte 1,%00111001,<-8,0,$90
;rat2	.byte 1,%00111001,<-8,0,$c8
;------------------------
guardlow:
	.byte 2,%00110100,8,<-18,$ec	    	;firing low
	.byte   %00100100,<-8,<-32,>guardbody,<guardbody
guardbody:
	.byte $24, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb

guardhigh:
	.byte 2,%00110100,8,<-24,$f1		;firing high
	.byte   %00100100,<-8,<-32,>guardbody1,<guardbody1
guardbody1:
	.byte $24, $e4, $e5, $ed, $ee, $ef, $f0, $ea, $eb

guardlow1:
	.byte 3,%00110100,6,<-18,$ec	    	;firing low recoiling
	.byte   %00111100,<-9,<-32,$e4
	.byte   %00111100,<-8,<-16,$e8

guardhigh1:
	.byte 3,%00110100,6,<-24,$f1		;firing high
	.byte   %00100100,<-9,<-32,>guardbody2,<guardbody2
	.byte   %00100100,<-8,<-16,>guardbody3,<guardbody3

guardbody2:
	.byte $22, $e4, $e5, $ed, $ee
guardbody3:
	.byte $22, $ef, $f0, $ea, $eb


;-------------------------
;chest	.byte 1,%00111001,<-8,<-8,$cc
;crown	.byte 1,%00111001,<-8,<-8,$d0
;diamond	.byte 1,%00111010,<-8,<-8,$d4
;shield	.byte 1,%00111001,<-8,<-8,$d8
;goblet	.byte 1,%00111001,<-8,<-8,$dc
;ruby	.byte 1,%00111011,<-8,<-8,$e0
;duffchest	.byte 1,%00111001,<-8,<-8,$cd
;-------------------------
fire1:
	.byte 1,%10110011,<-4,8,$95
fire2:
	.byte 4,%00110011,<-5,<-12-4,$bf
	.byte   %00110011,<-2,<-12-4,$c0
	.byte   %00110011,<-5,<-8-4,$c1
	.byte   %00110011,<-2,<-8-4,$c2
fire3:
	.byte 4,%00110011,<-7,<-12-4,$bf
	.byte   %00110011,<-1,<-12-4,$c0
	.byte   %00110011,<-7,<-6-4,$c1
	.byte   %00110011,<-1,<-6-4,$c2
fire4:
	.byte 3,%00111011,<-8,<-12-4,$bf
	.byte   %00110011,<-8,<-4,$c3
	.byte   %00110011,0 ,<-4,$c4
fire5:
	.byte 3,%00111011,<-8,<-12-4,$bf
	.byte   %00110011,<-8,4-4,$c3
	.byte   %00110011,0 ,0,$c4

;-------------------------
marions:
	.byte 4,%00100011,0,0,>marion1,<marion1
	.byte   %00100011,2,8,>marion2,<marion2
	.byte   %00111011,3,16,$fa
	.byte   %00100011,2,32,>marion3,<marion3
marion1:
	.byte $21, $f6, $f7
marion2:
	.byte $21, $f8, $f9
marion3:
	.byte $21, $fe, $ff
;--------------------------
pauses:
	.byte 5,%00110010,0,0,$7a
	.byte   %00110010,10,0,$7b
	.byte   %00110010,20,0,$7c
	.byte   %00110010,30,0,$7d
	.byte   %00110010,40,0,$7e
	.byte   %00110010,50,0,$7f
