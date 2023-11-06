.include "header.asm"
.include "variables.asm"
.include "inc/macros.asm"
.include "inc/bankswitch.asm"
.include "inc/soundfx.asm"
.include "inc/general.asm"
.include "inc/control.asm"
.include "inc/music.asm"
.include "inc/title_screen.asm"
.include "inc/interupt.asm"
.include "inc/spritesr.asm"
.include "inc/spritesd.asm"

.include "assets.asm"
.include "inc/mainloop.asm"
.include "inc/timings.asm"
.include "inc/cmlogo.asm"
.include "inc/hiscore.asm"

.segment "VECTORS"
.addr cm_nmi, start, $0

.include "inc/pp1unpack.asm"
.include "inc/prtmess.asm"

.include "inc/start.asm"
