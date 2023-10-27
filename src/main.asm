.include "variables.asm"
.include "header.asm"

.include "inc/bankswitch.asm"


.include "assets.asm"


.segment "CODE"
nmi:
    rts

reset:
    sei
    cld
    ldx #$FF
    txs

    lda #titletopchrs_index
    jsr copyblockofcompactedchrs

loop:
    jmp loop


.segment "VECTORS"
.addr nmi, reset, $0


.include "inc/chrcopy.asm"
