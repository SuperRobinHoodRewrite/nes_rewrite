.segment "ROM2"
cm_chrset: .incbin "../assets/gfx/CMLOGO.PP1"
titletopchrs: .incbin "../assets/gfx/TOPCHRS.PP1"
titlebotchrs: .incbin "../assets/gfx/BOTCHRS.PP1"
collisionchr: .byte $0e, $00, $80
solidcollisionchr: .byte $0f, $ff

alphachrs:
hiscorechrs: .incbin "../assets/gfx/HISCORE.PP1"

robinchrs: .incbin "../assets/gfx/ROBINCHR.PP1"

basechr: .incbin  "../assets/gfx/BASECHR.PP1"
beadchr: .incbin  "../assets/gfx/BEADCHR.PP1"
boxchr:  .incbin "../assets/gfx/BOXCHR.PP1"
archchr: .incbin  "../assets/gfx/ARCHCHR.PP1"
rockchr: .incbin  "../assets/gfx/ROCKCHR.PP1"
bedchr:  .incbin "../assets/gfx/BEDCHR.PP1"
doorchr: .incbin  "../assets/gfx/DOORCHR.PP1"

okchr: .incbin "../assets/gfx/OKCHR.PP1"
