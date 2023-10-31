.segment "BSS"
score:   .res 7
heartstable: .res 48
killed: .res 1

robindx: .res 1
robinxl: .res 1
robinxh: .res 1
robiny: .res 1
robinonscrx: .res 1
leftright: .res 1
oleftright: .res 1
orobinxl: .res 1
orobinxh: .res 1
orobiny: .res 1
runcount: .res 1

robindir: .res 1
robinanim: .res 1
robinfiring: .res 1
robincrouch: .res 1
robinheight: .res 1
robinjumping: .res 1
robingravity: .res 1
robinlook: .res 1
robinladder: .res 1
robinladdercounter: .res 1
robininvinc: .res 1
robinbehind: .res 1
robinjustjumped: .res 1
finishedloop: .res 1

juststartedlife: .res 1
hipos: .res 1 ; hiscore sorting

fadecolours: .res 32

treasures: .res 6
coinnum: .res 1

filledblockbuffer: .res 1
riseup: .res 1
ingame: .res 1
; zeropage vars

.segment "ZEROPAGE"

current_bank: .res 1

cm_frames: .res 1
control0: .res 1
control1: .res 1
interon: .res 1
seed: .res 3
pad: .res 1
debounce: .res 1
y_scroll: .res 1
x_scroll: .res 1
flyflag: .res 1
vrampointer: .res 1
bankno: .res 1
spriteblockpointer: .res 1
blockpointer: .res 1
counter: .res 1

toplevvar1:  .res 1
toplevvar2:  .res 1
toplevvar3:  .res 1
toplevvar4:  .res 1
toplevvar5:  .res 1
toplevvar6:  .res 1
toplevvar7:  .res 1
toplevvar8:  .res 1
toplevvar9:  .res 1
toplevvar10: .res 1

address:  .res 2
address1: .res 2
address2: .res 2
address3: .res 2
address4: .res 2
address5: .res 2
address6: .res 2
address7: .res 2
address8: .res 2
address9: .res 2


tempx: .res 1
tempy: .res 1
temp:  .res 1
temp1: .res 1
temp2: .res 1
temp3: .res 1
temp4: .res 1
temp5: .res 1
temp6: .res 1
temp7: .res 1
temp8: .res 1
temp9: .res 1

solidfound: .res 1

lives: .res 1
hearts: .res 1
heartcounter: .res 1

pause: .res 1	;pause rou 
dontpause: .res 1	;pause rou
palversion: .res 1
scrolldir: .res 1

fadecounter: .res 1
fadetemp: .res 1


; Compiler constants

cm_gamebyte = $7fd
cm_flags    = $7fe
cm_powerup  = $7ff

_control0   = $2000 ;Control register 0.
_control1   = $2001 ;Control register 1.
_statusreg  = $2002 ;Status register.
_spriteaddr = $2003 ;Sprite address set.
_spritedata = $2004 ;Sprite data set.
_scrollcon  = $2005 ;Scroll control.
_vramaddr   = $2006 ;VRAM address register.
_vramdata   = $2007 ;VRAM data register.
_bank       = $fffe
ppu_mask    = $2001
ppu_addr    = $2006
ppu_data    = $2007

;Ordinary constants.
spriteblock = $0200
vrambuffer  = $0100     ;same as stack ,but this works up
normalvars  = $0300  ;;;>&7ff
blockbuffer = $170      ;this leaves 112 for vrambuffer

absolutely	= 1
title	    = 1
hiscore	    = 1
musicon	    = 1

testpause	= 0
startlevel	= 5
analyzeon	= 0
master	    = 1
showcoins   = 0

ydisplace   = 12

zlim        = $0
varlim      = $300
