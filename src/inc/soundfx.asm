;SOUND FX
;0	=TAP
;1	;=PING
;2	=WHOOSH
;3	=CLICK
;4	=CLICK2
;5	=LOUD_TAP
;6	=DELETE
;7	=BULLET HITTING BUILDING
;8	=MISSILE LAUNCHING
;9	=HEAT SEEKER ALARM  (CALL REPEATEDLY)
;10	=used with above
;11	=ENEMY FIRING
;12	=FIRING TRACER BULLET
;13	=used for above
;14	=BOMB EXPLODING ON GROUND
;15	=SHIELD LOW ALARM   (CALL REPEATEDLY)
;16	=FUEL LOW ALARM	(CALL REPEATEDLY)
;17	=PING FOR SCORE
;18	=PING FOR ANOTHER SCORE
;19	=CLICK FOR OUT OF BULLETS
;20	=THUD FOR OUT OF BOMBS
;21	=BULLET HITTING ENEMY
;22	=used for above
;23	=DROPPING BOMB
;24	=BOMB IN WATER
;25	=LITTLE EXPLOSION
;26	=LITTLE EXPLOSION
;27	=LITTLE EXPLOSION
;28	=LITTLE EXPLOSION
;29	=LARGE EXPLOSION
;30	=VERY LARGE EXPLOSION
;31	=used for above


pickupheartfx     = 1
pickuptreasurefx  = 1
pickupkeyfx       = 17
killyoutotallyfx  = 30
killyoufx         = 28
killthemtotallyfx = 29
killthemfx        = 27
doorliftingfx     = 4
arrowhitwallfx    = 32;7
spitfx            = 33
bathitfx          = 26
trampfx           = 21
themfiringfx      = 11
breathingfirefx   = 8
ballbouncefx      = 16
batsquelfx        = 15
ratsquelfx        = 34
firstappearfx     = 2
extralifefx       = 36

chooseletterfx    = 35
deleteletterfx    = 6
leftrightletterfx = 5

youfiringfx       = 11


;;MUSIC
;;0	=turn off
;;1	=story line
;;2	=intro sequence
;;3	=DONT KNOW YET    BUT GOOD TUNE
;;4	=lauch from ship
;;5	=type writer
;;6	=completed game
;
;
;
;
;var NOTEVALUE,4	;	DV 5-1
;VAR ECHODEL,4
;VAR NEXTNOTE,4
;VAR NEXTLOW,4
;VAR NEXTHIGH,4
;VAR OFFSET,1
;zVAR VFX_TEMPZ,2

.segment "ZEROPAGE"
FX_TEMP:  .res 1	;	DS 1	;
FX_AD1L:  .res 1	;	DS 1	;
FX_AD1H:  .res 1	;	DS 1	;
FX_AD1    = FX_AD1L
fFX_AD1L: .res 1	;	DS 1	;
fFX_AD1H: .res 1	;	DS 1	;
fFX_AD1	  = fFX_AD1L


FX_AD2L:  .res 1	;	DS 1	;
FX_AD2H:  .res 1	;	DS 1	;
FX_AD2	  = FX_AD2L
fFX_AD2L: .res 1	;	DS 1	;
fFX_AD2H: .res 1	;	DS 1	;
fFX_AD2   = fFX_AD2L

.segment "BSS"
FX_COUNTERZ:  .res 1	;	DS 1
FX_TEMPZ:     .res 2	;	DS 2	;
FX_VOL1:      .res 4	;	DS 4
FX_VOL2:      .res 4	;	DS 4
FX_VOLUME:    .res 4	;	DS 4
FX_ATCK:      .res 4	;	DS 4
FX_DEL:       .res 4	;	DS 4
FX_TIME:      .res 4	;	DS 4
FX_PLS:       .res 4	;	DS 4
FX_ON:        .res 4	;	DS 4
FX_DATA1:     .res 4	;	DS 4
FX_POSITION:  .res 4	;	DS 4
FX_POINTL:    .res 4	;	DS 4
FX_POINTH:    .res 4	;	DS 4
FX_CYCLES:    .res 4	;	DS 4
FX_PRIORITY:  .res 4	;	DS 4
FX_VOICES:    .res 16	;	DS 16
FX_REAL_SAVE: .res 1	;	DS 1
.segment "CODE"
