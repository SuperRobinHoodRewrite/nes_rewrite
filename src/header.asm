;----------------------------------------------------------------------------
;iNES header definition
;Description: iNes header set to Camerica mapper 71.
;64kib or PRG-ROM
;4 banks - 16 kib each
;Banks 1,2 and 3 are located at 0x8000
;Bank 4 is located at 0xC000 and cannot be switched
;Internally there is 8kib of CHR-RAM
;----------------------------------------------------------------------------

.segment "HEADER"
    .byte "N","E","S", $1A
    .byte 4
    .byte 0
    .byte $71, $40
    .byte $0, $0, $0, $07, $0, $0
