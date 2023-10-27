; zeropage vars

.segment "ZEROPAGE"

cm_frames:    .res 1
current_bank: .res 1
finishedloop: .res 1
control0:     .res 1
control1:     .res 1
y_scroll:     .res 1
x_scroll:     .res 1
flyflag:      .res 1
interon:      .res 1
vrampointer:   .res 1

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



; Compiler constants

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
