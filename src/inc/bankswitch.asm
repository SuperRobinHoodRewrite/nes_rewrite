.segment "CODE"

banktable:
    .byte $00, $01, $02, $03, $04, $05, $06, $07
    .byte $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
bankswitch_y:
    sty current_bank
bankswitch_nosave:
    lda banktable, y
    sta banktable, y
    rts
changebankrou:
    sta current_bank
changebankrou1:
    tax
    sta banktable, x
    rts
