
;	if musicon=1




;0 = turn off
;1 = title page music (repeats)
;2 = game completed    (repeats)
;3 = enter name	  (repeats)
;4 = game over
;5 = intro into game
;6 = dungeons	  (repeats)
;7 = halls		  (repeats)
;8 = sky		  (repeats)
;9 = bedrooms	  (repeats)



IRQ_SETTING		= 15	;master on_off control + samples (add+16)

ZERO_PAGE_START	= zlim ;$30

NORM_PAGE_START	= varlim ;$600



;mega music driver for the nintendo 8-bit console
;(c) 1990 g.raeburn
;6502 assembly source


;
;zero page variables
;
;	ORG ZERO_PAGE_START
.segment "ZEROPAGE"
TEMPA: .res 2	;DV 2
TEMPB: .res 2	;DV 2
TEMPC: .res 2	;DV 2

;TEMP			;gavin
TEMP_LO: .res 1	;DV 1
TEMP_HI: .res 1	;DV 1

YTEMP: .res 2	;	DV 2

;zlim	= *
;
;ram vars
;
.segment "BSS"
;	ORG NORM_PAGE_START
VAR_START: .res 1

gav_COUNTER	= VAR_START	;DV 1

VOICE1: .res 1	;DV 1
VOICE2: .res 1	;DV 1
VOICE3: .res 1	;DV 1
VOICE4: .res 1	;DV 1

DELAY_SMALL1: .res 1	;DV 1
DELAY_SMALL2: .res 1	;DV 1
DELAY_SMALL3: .res 1	;DV 1
DELAY_SMALL4: .res 1	;DV 1

REVERB_COUNT1: .res 1	;DV 1
REVERB_COUNT2: .res 1	;DV 1
REVERB_COUNT3: .res 1	;DV 1
REVERB_COUNT4: .res 1	;DV 1

ECHO_HOLD1: .res 1	;DV 1
ECHO_HOLD2: .res 1	;DV 1
ECHO_HOLD3: .res 1	;DV 1
ECHO_HOLD4: .res 1	;DV 1

WOB_DELAY1: .res 1	;DV 1
WOB_DELAY2: .res 1	;DV 1
WOB_DELAY3: .res 1	;DV 1
WOB_DELAY4: .res 1	;DV 1

WOB_PROG1: .res 1	;DV 1
WOB_PROG2: .res 1	;DV 1
WOB_PROG3: .res 1	;DV 1
WOB_PROG4: .res 1	;DV 1

WOB_COUNT1: .res 1	;DV 1
WOB_COUNT2: .res 1	;DV 1
WOB_COUNT3: .res 1	;DV 1
WOB_COUNT4: .res 1	;DV 1
WOB_PHASE1: .res 1	;DV 1
WOB_PHASE2: .res 1	;DV 1
WOB_PHASE3: .res 1	;DV 1
WOB_PHASE4: .res 1	;DV 1

WOB_FREQ1: .res 1	;DV 1
WOB_FREQ2: .res 1	;DV 1
WOB_FREQ3: .res 1	;DV 1
WOB_FREQ4: .res 1	;DV 1

WOB_AMOUNT1: .res 1	;DV 1
WOB_AMOUNT2: .res 1	;DV 1
WOB_AMOUNT3: .res 1	;DV 1
WOB_AMOUNT4: .res 1	;DV 1

SPECIAL_THUD1: .res 1	;DV 1
SPECIAL_THUD2: .res 1	;DV 1
SPECIAL_THUD3: .res 1	;DV 1
SPECIAL_THUD4: .res 1	;DV 1

VOLUME1: .res 1	;DV 1
VOLUME2: .res 1	;DV 1
VOLUME3: .res 1	;DV 1
VOLUME4: .res 1	;DV 1

NOTE1: .res 1	;DV 1
NOTE2: .res 1	;DV 1
NOTE3: .res 1	;DV 1
NOTE4: .res 1	;DV 1
OLD_NOTE1: .res 1	;DV 1
OLD_NOTE2: .res 1	;DV 1
OLD_NOTE3: .res 1	;DV 1
OLD_NOTE4: .res 1	;DV 1

LOW_PITCH1: .res 1	;DV 1
LOW_PITCH2: .res 1	;DV 1
LOW_PITCH3: .res 1	;DV 1
LOW_PITCH4: .res 1	;DV 1
HIGH_PITCH1: .res 1	;DV 1
HIGH_PITCH2: .res 1	;DV 1
HIGH_PITCH3: .res 1	;DV 1
HIGH_PITCH4: .res 1	;DV 1

PHASE1: .res 1	;DV 1
PHASE2: .res 1	;DV 1
PHASE3: .res 1	;DV 1
PHASE4: .res 1	;DV 1


;instrument offset address
;
INSTRUMENT1: .res 1	;DV 1
INSTRUMENT2: .res 1	;DV 1
INSTRUMENT3: .res 1	;DV 1
INSTRUMENT4: .res 1	;DV 1

;
;
TIN_TONE1: .res 1	;DV 1
TIN_TONE2: .res 1	;DV 1
TIN_TONE3: .res 1	;DV 1
TIN_TONE4: .res 1	;DV 1


;
;
TIN_DELAY1: .res 1	;DV 1
TIN_DELAY2: .res 1	;DV 1
TIN_DELAY3: .res 1	;DV 1
TIN_DELAY4: .res 1	;DV 1

;current macro being read + played
;
MACRO_COUNT1: .res 1	;DV 1
MACRO_COUNT2: .res 1	;DV 1
MACRO_COUNT3: .res 1	;DV 1
MACRO_COUNT4: .res 1	;DV 1

;low nybble + high nybble are offsets from note
;

CHORD_SHAPE1: .res 1	;DV 1
GLISS_WAIT1	= CHORD_SHAPE1

CHORD_SHAPE2: .res 1	;DV 1
GLISS_WAIT2	= CHORD_SHAPE2

CHORD_SHAPE3: .res 1	;DV 1
GLISS_WAIT3	= CHORD_SHAPE3

CHORD_SHAPE4: .res 1	;DV 1
GLISS_WAIT4	= CHORD_SHAPE4

GLISS_NEW_NOTE1: .res 1	;DV 1	; cross with glis_rate1 ????
GLISS_NEW_NOTE2: .res 1	;DV 1
GLISS_NEW_NOTE3: .res 1	;DV 1
GLISS_NEW_NOTE4: .res 1	;DV 1

GLISS_RATE1: .res 1	;DV 1
GLISS_RATE2: .res 1	;DV 1
GLISS_RATE3: .res 1	;DV 1
GLISS_RATE4: .res 1	;DV 1

CHORD_COUNTER: .res 1	;DV 1
MAIN_COUNTER:  .res 2	;DV 2

VAR_END	= varlim

macro_point1: .res 2	;dv 2
macro_point2: .res 2	;dv 2
macro_point3: .res 2	;dv 2
macro_point4: .res 2	;dv 2

save_macro_point1: .res 2	;dv 2
save_macro_point2: .res 2	;dv 2
save_macro_point3: .res 2	;dv 2
save_macro_point4: .res 2	;dv 2

tune: .res 1	;dv 1
tempo: .res 1	;dv 1
TRANSPOSE_VAR: .res 1	;DV 1
DELAY_MAIN: .res 1	;DV 1

;varlim	= *

.segment "CODE"
