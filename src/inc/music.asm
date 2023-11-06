

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
.if musicon=1
.segment "CODE"
start_music:
    rts
;     ORG $8000
;     DB 13

;     JMP START_MUSIC
;     JMP PLAY_MUSIC

; START_MUSIC:
;     STA TUNE
;     SEC
;     SBC #1
;     STA TEMPA
;     ASL
;     ASL
;     ;ASL
;     ;ORA TEMPA
;     ADC TEMPA
;     ASL
;         ;ASL
;         ;ASL
;     TAY

;     LDA INDEX
;     STA TEMPA
;     LDA INDEX+1
;     STA TEMPA+1

;     LDA (TEMPA),Y
;     STA TRANSPOSE_VAR

;     INY
;     LDA (TEMPA),Y
;     STA TEMPO

;     LDX #0
; @LOOP:
;     INY
;     LDA (TEMPA),Y
;     STA MACRO_POINT1,X
;     STA SAVE_MACRO_POINT1,X
;     INX
;     CPX #8
;     BCC @LOOP


; TRIGGER:
;     LDY #VAR_END-VAR_START
;     LDA #0
; @LOOP2:
;     STA VAR_START-1,Y
;     DEY
;     BNE @LOOP2

;     LDA #IRQ_SETTING	;master on_off control + samples
;     STA $4015

;     LDA TEMPO
;     SEC
;     SBC #1
;     STA DELAY_MAIN

;     LDX #0
;     JSR NEW_MACRO
;     LDX #1
;     JSR NEW_MACRO
;     LDX #2
;     JSR NEW_MACRO
;     LDX #3
;     JMP NEW_MACRO





; PLAY_MUSIC:
; 	inc gav_counter

;     LDA TUNE
;     BNE @GO
;     RTS

; @GO:
; 	LDA VOICE1
;     BEQ @2B
;     DEC VOICE1

; @2B:
; 	LDA VOICE2
;     BEQ @2C
;     DEC VOICE2

; @2C:
; 	LDA VOICE3
;     BEQ @2D
;     DEC VOICE3

; @2D:
; 	LDA VOICE4
;     BEQ @2E
;     DEC VOICE4

; @2E:
;     INC MAIN_COUNTER

;     JSR DELAY_BIT

;     LDA MAIN_COUNTER
;     LSR
;     BCC @FX_ONLY

;     JSR DELAY_BIT

; @FX_ONLY:
; 	JMP ADSR






; DELAY_BIT	INC DELAY_MAIN
;     LDA DELAY_MAIN
;     CMP TEMPO
;     BNE @NO

;     LDA #0	;master tempo
;     STA DELAY_MAIN

;     JMP DO_VOICES
; @NO	RTS






; ****************************************************************************



; ADSR	LDX #0

; @LOOP
;     LDA INSTRUMENT1,X
;     STA YTEMP+1

;     TXA
;     ASL
;     ASL
;     TAY
;     STY YTEMP

;     CPX #2
;     BEQ @TRIANGLE

;     LDA VOICE1,X
;     BNE @CHANNEL_IS_OFF

;     LDA VOLUME1,X
;     LSR
;     LSR
;     LSR
;     LSR
;     ORA #$30
;     ORA TIN_TONE1,X
;     STA $4000,Y


; @CHANNEL_IS_OFF
;     LDY YTEMP+1	; instrument

;     LDA REVERB_COUNT1,X
;     BNE @SKIP_ADSR

;     LDA PHASE1,X
;     BEQ @ATTACK
;     CMP #1
;     BEQ @DECAY
;     BNE @SUSTAIN
; @ATTACK
;     ;LDY INSTRUMENT1,X
;     LDA VOLUME1,X
;     CLC
;     ADC INSTRUMENTS+1,Y
;     BCS @TOP

;     CMP INSTRUMENTS+2,Y
;     BCC @NO_TOP

; @TOP	LDA INSTRUMENTS+2,Y
;     INC PHASE1,X
; @NO_TOP	STA VOLUME1,X
;     JMP @CONTINUE



; @DECAY
;     ;LDY INSTRUMENT1,X
;     LDA VOLUME1,X
;     SEC
;     SBC INSTRUMENTS+3,Y
;     BCC @BOT

;     CMP INSTRUMENTS+4,Y
;     BCS @NO_BOT

; @BOT	LDA INSTRUMENTS+4,Y
;     INC PHASE1,X
; @NO_BOT	STA VOLUME1,X
;     BEQ @JJJ_IT
;     JMP @CONTINUE




; @SUSTAIN	LDA INSTRUMENTS+4,Y
;     BNE @NEQ
; @JJJ_IT	JMP @NO_HIGH	; sound level at 0 so don't bother processing
; @NEQ
;     STA VOLUME1,X
; @SKIP_ADSR

; @TRIANGLE	; skip ADSR on triangle
; @CONTINUE

; ;
; ;special thud
; ;
;     CPX #2
;     BCS @SPECIAL	; only on triangle
; @J_NO_SPECIAL
;     JMP @NO_SPECIAL

; @SPECIAL
;     LDA SPECIAL_THUD1,X
;     BEQ @J_NO_SPECIAL

;     CPX #3
;     BNE @NOT_WHITE_NOISE

;     LDY YTEMP	; x * 4

;     LDA VOICE1,X
;     BNE @CHANNEL_IS_OFF2

;     LDA LOW_PITCH1,X
;     CLC
;     ADC #199
;     STA LOW_PITCH1,X
;     STA $4002,Y

; @CHANNEL_IS_OFF2
;     DEC SPECIAL_THUD1,X
;     BNE @GET_Y_BIT

;     LDA #0
;     STA VOLUME1,X
;     LDA #2
;     STA PHASE1,X
;     BNE @GET_Y_BIT

; @NOT_WHITE_NOISE
;     CMP #255
;     BNE @N_DOOF

;     LDY YTEMP	; x * 4

;     LDA #35
;     JSR SUB_VOICE

;     LDA HIGH_PITCH1,X
;     CMP #2
;     BCC @GET_Y_BIT

;     LDA #0
;     STA SPECIAL_THUD1,X
;     STA VOLUME1,X

;     LDA VOICE1,X
;     BNE @CHANNEL_IS_OFF3
;     STA $4000,Y

;     LDA #6
;     STA $4002,Y
;     LDA #$AE
;     STA $4003,Y	;HMMM...

;     BNE @GET_Y_BIT

; @N_DOOF	DEC SPECIAL_THUD1,X
;     BNE @NO_SPECIAL

;     LDA #255
;     STA SPECIAL_THUD1,X

;     ;LDY INSTRUMENT1,X
;     LDY YTEMP+1	; instrument
;     LDA INSTRUMENTS+11,Y
;     TAY
;     LDA TABLO,Y
;     STA LOW_PITCH1,X
;     LDA TABHI,Y
;     STA HIGH_PITCH1,X

;     LDY YTEMP	; x * 4

;     LDA VOICE1,X
;     BNE @CHANNEL_IS_OFF4

;     LDA LOW_PITCH1,X
;     STA $4002,Y
;     LDA HIGH_PITCH1,X
;     STA $4003,Y
;     LDA #$20
;     STA $4000,Y	; retrigger thud sound

; @CHANNEL_IS_OFF3
; @CHANNEL_IS_OFF4
; @GET_Y_BIT
;     LDY YTEMP+1	; instrument
; @NO_SPECIAL
; ;
; ;reverb
; ;

;     LDA INSTRUMENTS+10,Y
;     BEQ @NO_REVERB

; *******************
;     ;LDA WHITE_OFF,X
;     STA $FF
;     LSR
;     STA $FE

;     INC REVERB_COUNT1,X
;     LDA REVERB_COUNT1,X
;     CMP $FF;#REV
;     BNE @N0
;     LDA #0
;     STA REVERB_COUNT1,X
; @N0
;     BNE @N3

;     LDA ECHO_HOLD1,X
;     STA VOLUME1,X
;     JMP @NEXT

; @N3	CMP $FE;#REV/2
;     BEQ @ON1
;     BCS @ON2
;     BCC @NEXT

; @ON1	LDA VOLUME1,X
;     STA ECHO_HOLD1,X

; @ON2	LDA #0
;     STA VOLUME1,X

; @NEXT

; *******************

;     ;LDY INSTRUMENT1,X
;     LDY YTEMP+1	; instrument
; @ON


; @NO_REVERB
; ;
; ;tinny tone bit
; ;
;     LDY YTEMP+1	; instrument	;*
;     ;LDY INSTRUMENT1,X
;     LDA INSTRUMENTS+5,Y

;     AND #%11110000
;     BEQ @ONE_OFF
; ;
; ;constant pulse
; ;
;     LSR
;     LSR
;     LSR
;     LSR
;     ASL
;     STA TEMPA
;     INC TIN_DELAY1,X
;     LDA TIN_DELAY1,X
;     CMP TEMPA
;     BCC @STOPED
;     LDA #0
;     STA TIN_DELAY1,X
;     BEQ @INC_TINNY

; ;
; ;one off pulse
; ;
; @ONE_OFF	LDA TIN_TONE1,X
;     ASL
;     ROL
;     ROL
;     STA TEMPA

;     LDA INSTRUMENTS+5,Y
;     AND #3
;     CMP TEMPA
;     BEQ @STOPED

; @INC_TINNY
;     LDA TIN_TONE1,X
;     CLC
;     ADC #$40
;     BCC @OK
;     LDA #0
; @OK	STA TIN_TONE1,X

; @STOPED
;     LDA CHORD_SHAPE1,X
;     ORA GLISS_RATE1,X
;     BNE @NO_WOB		; no wobble on chord shape
; ;
; ;wobble
; ;
;     LDY YTEMP+1	; instrument ;*
;     ;LDY INSTRUMENT1,X
;     LDA WOB_DELAY1,X
;     CMP INSTRUMENTS+6,Y
;     BEQ @WOBBLE_READY
;     INC WOB_DELAY1,X
;     BNE @NO_WOB
; @WOBBLE_READY
; ;
; ;do wobble
; ;
;     LDA WOB_AMOUNT1,X
;     STA TEMPA

;     ;LDA INSTRUMENT1,X
;     ;STA TEMPA+1

;     LDY YTEMP	; x * 4

;     LDA WOB_PHASE1,X
;     BEQ @UP_WOB
;     CMP #1
;     BEQ @DOWN_WOB
; ;
; ;back up again @@@
; ;
;     LDA TEMPA	;UP_DOWN1,X
;     JSR ADD_VOICE
;     LDA WOB_FREQ1,X
;     JSR DO_WOB_CHECK
;     JMP @NO_WOB
; @UP_WOB
;     LDA TEMPA	;UP_DOWN1,X
;     JSR ADD_VOICE
;     LDA WOB_FREQ1,X
;     JSR DO_WOB_CHECK
;     JMP @NO_WOB
; @DOWN_WOB
;     LDA TEMPA	;UP_DOWN1,X
;     JSR SUB_VOICE
;     LDA WOB_FREQ1,X
;     ASL
;     JSR DO_WOB_CHECK
;     ;JMP @NO_WOB


; @NO_WOB
; ;
; ;glissando
; ;
;     LDA GLISS_RATE1,X
;     BNE @GLISS

;     JMP @NO_GLISS
; @GLISS
;     LDY GLISS_WAIT1,X
;     BEQ @EQ
;     DEC GLISS_WAIT1,X
;     JMP @NO_CHORDS

; @EQ	LSR
;     STA TEMPA
;     BCC @NO_HALF

;     LDA MAIN_COUNTER
;     AND #1
;     BEQ @NO_HALF
;     INC TEMPA
; @NO_HALF
;     LDY YTEMP	; x * 4

;     LDA GLISS_NEW_NOTE1,X
;     ;CLC
;     ;ADC TRANSPOSE_VAR
;     CMP NOTE1,X
;     BCS @GO_UP

; ;go down
;     LDA TEMPA
;     JSR SUB_VOICE
; ;
; ;check to see if new note reached
; ;
;     LDY GLISS_NEW_NOTE1,X
;     LDA TABLO,Y
;     STA TEMPA
;     LDA TABHI,Y
;     STA TEMPA+1
;     CMP HIGH_PITCH1,X
;     BEQ @TEST_LOW
;     BCS @J_NO
;     BCC @HIT
; @TEST_LOW
;     LDA TEMPA
;     CMP LOW_PITCH1,X
;     BEQ @HIT
;     BCS @J_NO
; ;
; ;note reached
; ;
; @HIT	LDA #0
;     STA GLISS_RATE1,X
;     STA GLISS_WAIT1,X

;     LDY YTEMP	; x * 4

;     LDA TEMPA+1
;     CMP HIGH_PITCH1,X
;     BEQ @SEMI_REWRITE


;     LDA TEMPA+1
;     STA HIGH_PITCH1,X
;     LDY VOICE1,X
;     BNE @CHANNEL_IS_OFF5
;     STA $4003,Y

; @CHANNEL_IS_OFF5
; @SEMI_REWRITE
;     LDA TEMPA
;     STA LOW_PITCH1,X
;     LDY VOICE1,X
;     BNE @CHANNEL_IS_OFF6
;     STA $4002,Y
; @CHANNEL_IS_OFF6
; @J_NO	JMP @NO_CHORDS




; @GO_UP
;     LDA TEMPA
;     JSR ADD_VOICE

;     LDY GLISS_NEW_NOTE1,X
;     LDA TABLO,Y
;     STA TEMPA
;     LDA TABHI,Y
;     STA TEMPA+1
;     CMP HIGH_PITCH1,X
;     BEQ @TEST_LOW2
;     BCC @NO_CHORDS
;     BCS @HIT
; @TEST_LOW2
;     LDA TEMPA
;     CMP LOW_PITCH1,X
;     BCS @HIT

; ;
; ;check to see if new note reached
; ;


;     JMP @NO_CHORDS



; @NO_GLISS
; ;
; ;chords ???
; ;
;     LDA CHORD_SHAPE1,X
;     BEQ @NO_CHORDS

;     LDA CHORD_COUNTER	; which note of the chord to play
;     BEQ @CHORD1
;     CMP #1
;     BEQ @CHORD2

; @CHORD3	LDA CHORD_SHAPE1,X
;     AND #15
;     CLC
;     ADC OLD_NOTE1,X
;     ;CLC
;     ;ADC TRANSPOSE_VAR
;     JMP @BLIP_NOTE

; @CHORD1	LDA OLD_NOTE1,X
;     ;CLC
;     ;ADC TRANSPOSE_VAR
;     JMP @BLIP_NOTE

; @CHORD2	LDA CHORD_SHAPE1,X
;     LSR
;     LSR
;     LSR
;     LSR
;     CLC
;     ADC OLD_NOTE1,X
; ;	JMP @BLIP_NOTE
; ;
; ;output note
; ;
; @BLIP_NOTE
;     TAY
;     LDA TABLO,Y
;     STA LOW_PITCH1,X
;     LDA TABHI,Y
;     STA HIGH_PITCH1,X

;     LDY YTEMP	; x * 4

;     LDA VOICE1,X
;     BNE @VOICE_OFF

;     LDA LOW_PITCH1,X
;     STA $4002,Y
;     LDA HIGH_PITCH1,X
;     STA $4003,Y

; @VOICE_OFF
; @NO_CHORDS
; @NO_HIGH
;     INX
;     CPX #4
;     BCS @NO_LOOP
;     JMP @LOOP

; @NO_LOOP	INC CHORD_COUNTER
;     LDA CHORD_COUNTER
;     CMP #3
;     BCC @NO_CH
;     LDA #0
;     STA CHORD_COUNTER
; @NO_CH
;     RTS




; ***********************************************************************







; DO_WOB_CHECK	;LDY TEMPA+1
;     LDY YTEMP+1	; instrument
;     STA TEMPB
;     INC WOB_COUNT1,X
;     LDA WOB_COUNT1,X
;     CMP TEMPB
;     BCC @NO
;     LDA #0
;     STA WOB_COUNT1,X
;     INC WOB_PHASE1,X
;     LDA WOB_PHASE1,X
;     CMP #3
;     BCC @NO
;     LDA #0
;     STA WOB_PHASE1,X

;     LDA WOB_AMOUNT1,X
;     CMP INSTRUMENTS+9,Y
;     BCS @NO
;     ;CLC
;     ADC INSTRUMENTS+8,Y
;     STA WOB_AMOUNT1,X
;     CMP INSTRUMENTS+9,Y
;     BCC @NO
;     LDA INSTRUMENTS+9,Y
;     STA WOB_AMOUNT1,X
; @NO	RTS







; SUB_VOICE	CLC
;     ADC LOW_PITCH1,X
;     STA LOW_PITCH1,X
;     BCC @STORE_LOW
;     INC HIGH_PITCH1,X

;     LDA VOICE1,X
;     BNE @CHANNEL_IS_OFF8

;     LDA HIGH_PITCH1,X
;     STA $4003,Y

; @STORE_LOW
;     LDA VOICE1,X
;     BNE @CHANNEL_IS_OFF8

;     LDA LOW_PITCH1,X
;     STA $4002,Y

; @CHANNEL_IS_OFF8
;     RTS







; ADD_VOICE	STA TEMPB
;     LDA LOW_PITCH1,X
;     SEC
;     SBC TEMPB
;     STA LOW_PITCH1,X
;     BCS @STORE_LOW
;     DEC HIGH_PITCH1,X

;     LDA VOICE1,X
;     BNE @CHANNEL_IS_OFF7

;     LDA HIGH_PITCH1,X
;     STA $4003,Y

; @STORE_LOW
;     LDA VOICE1,X
;     BNE @CHANNEL_IS_OFF7

;     LDA LOW_PITCH1,X
;     STA $4002,Y

; @CHANNEL_IS_OFF7
;     RTS







; NEW_MACRO	TXA
;     ASL
;     TAY

;     LDA MACRO_POINT1,Y
;     CLC
;     ADC #2
;     STA MACRO_POINT1,Y
;     BCC @NO_HIGH
;     LDA MACRO_POINT1+1,Y
;     ADC #0
;     STA MACRO_POINT1+1,Y

; @NO_HIGH	LDA MACRO_POINT1+1,Y
;     STA TEMP_HI
;     LDA MACRO_POINT1,Y
;     STA TEMP_LO

;     LDY #1
;     LDA (TEMP_LO),Y
;     BNE @NO_STOP_TUNE
;     CPX #0
;     BNE @NO_CHANNEL_0

; ;
; ;stop or repeat tune?
; ;
;     DEY
;     LDA (TEMP_LO),Y
;     BEQ @STOP_TUNE
; ;
; ;repeat tune
; ;
;     SEC
;     SBC #1
;     ASL
;     STA TEMPA

;     LDX #0
; @LOOP1	LDA SAVE_MACRO_POINT1+1,X
;     STA MACRO_POINT1+1,X

;     LDA SAVE_MACRO_POINT1,X
;     CLC
;     ADC TEMPA
;     STA MACRO_POINT1,X
;     BCC @NO_HIGH_2

;     INC MACRO_POINT1+1,X
; @NO_HIGH_2
;     INX
;     INX
;     CPX #8
;     BCC @LOOP1

;     JSR TRIGGER
;     PLA
;     PLA
;     RTS

; @STOP_TUNE
;     LDA #0
;     STA $4015
;     STA TUNE

;     SEC
;     RTS

;     ;JMP BREAKPOINT

; @NO_CHANNEL_0
; @NO_STOP_TUNE
; ;
; ;find instrument
; ;
;     LDY #0
;     LDA (TEMP_LO),Y

;     STA TEMPB
;     INY
;     LDA (TEMP_LO),Y
;     STA TEMPB+1

;     DEY	;LDY #0
;     LDA (TEMPB),Y
;     STA INSTRUMENT1,X
; ;
; ;found instrument
; ;
;     LDA #1
;     STA MACRO_COUNT1,X

;     LDA #32
;     CPX #2	;3
;     BCS @NOT_ON_WN	;BEQ @NOT_ON_WN

;     CLC
;     ADC TRANSPOSE_VAR
; @NOT_ON_WN
;     STA NOTE1,X

;     LDA #0
;     STA DELAY_SMALL1,X

;     CLC
;     RTS








; DO_VOICES	LDX #0

; @LOOP	DEC DELAY_SMALL1,X
;     BMI @YES
;     JMP @NEXT_VOICE
; @YES
; ;
; ;get next note
; ;
;     TXA
;     ASL
;     TAY

;     LDA MACRO_POINT1,Y
;     STA TEMP_LO
;     LDA MACRO_POINT1+1,Y
;     STA TEMP_HI

; ;
; ;clear chord pattern + disable + clear other vars...
; ;
;     LDA #0
;     STA CHORD_SHAPE1,X
;     STA CHORD_COUNTER
;     STA GLISS_RATE1,X
;     STA SPECIAL_THUD1,X

;     TAY	;LDY #0
;     LDA (TEMP_LO),Y
;     PHA
;     INY
;     LDA (TEMP_LO),Y
;     STA TEMP_HI
;     PLA
;     STA TEMP_LO



;     LDY MACRO_COUNT1,X
;     INC MACRO_COUNT1,X

;     LDA (TEMP_LO),Y
;     CMP #1
;     BNE @NO_NEW

;     JSR NEW_MACRO
;     BCC @YES	;LOOP
;     JMP @NO_LOOP

;     ;;;JMP @YES	;LOOP

; @NO_NEW	PHA
;     ;AND #248
;     LSR
;     LSR
;     LSR
;     STA TEMPA
;     PLA
;     AND #7
;     SEC
;     SBC #1
;     STA DELAY_SMALL1,X
;     BCS @N_LARGE_DELAYNOTE	; delay of 0 = special comand...

; ;
; ;this value lsr,lsr,lsr = delay
; ;next value = note
; ;
;     LDA TEMPA
;     STA DELAY_SMALL1,X	; read from table

; @NEW_INSTRUMENT_RELOOP
;     INY
;     INC MACRO_COUNT1,X
;     LDA (TEMP_LO),Y
;     PHA
;     AND #63	;127
;     STA TEMPC
;     CLC		;add offset
;     ADC #9	;
;     CPX #3
;     BEQ @NOT_ON_WN
;     ADC TRANSPOSE_VAR
; @NOT_ON_WN
;     STA NOTE1,X
;     STA OLD_NOTE1,X
;     PLA
;     ASL
;     ROL
;     ROL
;     AND #3
;     BEQ @NO_CHORD
;     CMP #2
;     BEQ @CHORDS_ON
;     CMP #1
;     BEQ @GLISSANDO
; ;
; ;new instrument
; ;
;     LDA TEMPC	; * by 12 = instrument1
;     ASL
;     CLC
;     ADC TEMPC
;     ASL
;     ASL
;     STA INSTRUMENT1,X

;     JMP @NEW_INSTRUMENT_RELOOP
;     ;INY
;     ;INC MACRO_COUNT1,X
;     ;LDA (TEMP_LO),Y
;     ;STA INSTRUMENT1,X
;     ;JMP @NO_CHORD
; ;
; ;glissando
; ;
; @GLISSANDO
;     INY
;     INC MACRO_COUNT1,X
;     LDA (TEMP_LO),Y
;     CLC
;     ADC TRANSPOSE_VAR
;     ;CLC		;add offset
;     ;ADC #9	;
;     STA GLISS_NEW_NOTE1,X

;     INY
;     INC MACRO_COUNT1,X
;     LDA (TEMP_LO),Y
;     STA GLISS_WAIT1,X

;     INY
;     INC MACRO_COUNT1,X
;     LDA (TEMP_LO),Y
;     STA GLISS_RATE1,X

;     JMP @NO_CHORD


; @CHORDS_ON	INY
;     INC MACRO_COUNT1,X
;     LDA (TEMP_LO),Y
;     STA CHORD_SHAPE1,X	; high nybble + low nybble = offsets
; ;
; ;high bit set = chord + base note
; ;

; @NO_CHORD
;     JMP @SORT_DELAY

; @N_LARGE_DELAYNOTE

;     LDA TEMPA
;     SEC
;     SBC #16	; relative next note +-16
;     CLC
;     ADC NOTE1,X
;     STA NOTE1,X
;     STA OLD_NOTE1,X
;     ;CPX #0
;     ;BNE @SORT_DELAY
;     ;BWON
; @SORT_DELAY
; ;
; ;set wobble
; ;
;     LDA #0
;     STA REVERB_COUNT1,X
;     STA WOB_DELAY1,X
;     STA WOB_PHASE1,X
;     STA WOB_COUNT1,X
;     LDA #1
;     STA WOB_AMOUNT1,X
;     LDY INSTRUMENT1,X
;     LDA INSTRUMENTS+7,Y
;     STA WOB_FREQ1,X

;     LDA INSTRUMENTS+6,Y	;if not delayed wobble = instant peak
;     BNE @DEL_WOB
;     LDA INSTRUMENTS+9,Y
;     STA WOB_AMOUNT1,X

; @DEL_WOB
; ;
; ;special thud
; ;
;     LDY INSTRUMENT1,X
;     LDA INSTRUMENTS+11,Y
;     BEQ @NO_THUD
;     CPX #3
;     BEQ @WHITE_NOISE

;     LDA #2
; @WHITE_NOISE
;     STA SPECIAL_THUD1,X

; @NO_THUD
; ;
; ;tinnytone
; ;
;     LDA INSTRUMENTS+5,Y

;     AND #%00001100
;     ASL
;     ASL
;     ASL
;     ASL
;     STA TIN_TONE1,X

;     LDA #0
;     STA TIN_DELAY1,X
; ;
; ;delay
; ;
; ;	LDY DELAY_SMALL1,X
; ;	CPY #7
; ;	BCC @SMALL_DELAY_ON	; skip table delay if index <7
; ;	LDA DELAY_TABLE-1,Y
; ;	STA DELAY_SMALL1,X
; ;Y
; ;@SMALL_DELAY_ON
;     LDY INSTRUMENT1,X
;     LDA INSTRUMENTS,Y
;     STA VOLUME1,X


;     LDY NOTE1,X
;     LDA TABLO,Y
;     STA LOW_PITCH1,X
;     LDA TABHI,Y
;     STA HIGH_PITCH1,X

;     LDA #0
;     STA PHASE1,X


;     TXA
;     ASL
;     ASL
;     TAY

;     LDA VOICE1,X
;     BNE @CHANNEL_IS_OFF

;     LDA #1
;     STA $4001,Y
;     LDA LOW_PITCH1,X
;     STA $4002,Y
;     LDA HIGH_PITCH1,X
;     STA $4003,Y

;     CPX #2
;     BNE @NO_TRIANGLE
; ;triangle
;     LDY INSTRUMENT1,X
;     LDA INSTRUMENTS+1,Y
;     PHA
;     TXA
;     ASL
;     ASL
;     TAY
;     PLA
;     STA $4000,Y

; @CHANNEL_IS_OFF
; @NO_TRIANGLE
; @NEXT_VOICE	INX
;     CPX #4
;     BCS @NO_LOOP
;     JMP @LOOP

; @NO_LOOP	RTS







; TABLO	DL $6AE,$64E,$5F3,$59E,$54D,$501
;     DL $4B9,$475,$435,$3F8,$3BF,$389
;     DL $6AE/2,$64E/2,$5F3/2,$59E/2,$54D/2,$501/2
;     DL $4B9/2,$475/2,$435/2,$3F8/2,$3BF/2,$389/2
;     DL $6AE/4,$64E/4,$5F3/4,$59E/4,$54D/4,$501/4
;     DL $4B9/4,$475/4,$435/4,$3F8/4,$3BF/4,$389/4
;     DL $6AE/8,$64E/8,$5F3/8,$59E/8,$54D/8,$501/8
;     DL $4B9/8,$475/8,$435/8,$3F8/8,$3BF/8,$389/8
;     DL $6AE/16,$64E/16,$5F3/16,$59E/16,$54D/16,$501/16
;     DL $4B9/16,$475/16,$435/16,$3F8/16,$3BF/16,$389/16
;     DL $6AE/32,$64E/32,$5F3/32,$59E/32,$54D/32,$501/32
;     DL $4B9/32,$475/32,$435/32,$3F8/32,$3BF/32,$389/32
;     DL $6AE/64,$64E/64,$5F3/64,$59E/64,$54D/64,$501/64
;     DL $4B9/64,$475/64,$435/64,$3F8/64,$3BF/64,$389/64
;     DL $6AE/128,$64E/128,$5F3/128,$59E/128,$54D/128,$501/128
;     DL $4B9/128,$475/128,$435/128,$3F8/128,$3BF/128,$389/128

; TABHI	DH $6AE,$64E,$5F3,$59E,$54D,$501
;     DH $4B9,$475,$435,$3F8,$3BF,$389
;     DH $6AE/2,$64E/2,$5F3/2,$59E/2,$54D/2,$501/2
;     DH $4B9/2,$475/2,$435/2,$3F8/2,$3BF/2,$389/2
;     DH $6AE/4,$64E/4,$5F3/4,$59E/4,$54D/4,$501/4
;     DH $4B9/4,$475/4,$435/4,$3F8/4,$3BF/4,$389/4
;     DH $6AE/8,$64E/8,$5F3/8,$59E/8,$54D/8,$501/8
;     DH $4B9/8,$475/8,$435/8,$3F8/8,$3BF/8,$389/8
;     DH $6AE/16,$64E/16,$5F3/16,$59E/16,$54D/16,$501/16
;     DH $4B9/16,$475/16,$435/16,$3F8/16,$3BF/16,$389/16
;     DH $6AE/32,$64E/32,$5F3/32,$59E/32,$54D/32,$501/32
;     DH $4B9/32,$475/32,$435/32,$3F8/32,$3BF/32,$389/32
;     DH $6AE/64,$64E/64,$5F3/64,$59E/64,$54D/64,$501/64
;     DH $4B9/64,$475/64,$435/64,$3F8/64,$3BF/64,$389/64
;     DH $6AE/128,$64E/128,$5F3/128,$59E/128,$54D/128,$501/128
;     DH $4B9/128,$475/128,$435/128,$3F8/128,$3BF/128,$389/128



; END_OF_CODE



; ;DELAY_TABLE	DB 0,1,2,3,4,5,6
; ;transpose	db 0,0,0,0,0,0,0


; ;
; ;start of transmitted data
; ;

; INDEX	dw $87d6;9


; ;start vol	0-255
; ;attack rate	0-255
; ;peak vol	0-255
; ;decay rate	0-255
; ;sustain vol	0-255
; ;tone - 	delay 0-15, start 0-3, end 0-3
; ;wobble wait 	0-255	; delay before wobble comes in
; ;freq(up/down)	0-255	; number of up/down steps (2 = norm wobble)
; ;progress	0-255	; value added up or down
; ;max wobble	0-255	; maximum value added up or down
; ;reverb	0-255 ; 0 = off
; ;thud trigger	0-255 ; note value
; ;
;     ORG $86Da;D
; INSTRUMENTS
;     IF gav_master = 0

;     DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	;0
;     DB $01,$00,$F0,$10,$80,$03,$05,$03,$01,$04,$0A,$30	;12
;     DB $FF,$00,$F0,$10,$00,$03,$05,$03,$01,$04,$00,$00	;24

; SONGS	DB 0,7
;     DW TUNE1A-2,TUNE1B-2,TUNE1C-2,TUNE1D-2

;     ENDIF
; ADSASD
;     incbin data3

; ASDA	EQU *-$8001
;     FREE ASDA

;     IF gav_master = 1
; AA	= $ffed	;BREAKPOINT
;     ENDIF

;     IF gav_master = 0

; ;@END0	IF @END0>$C000
; ;	ERROR "Bank 0 is full
; ;	ENDIF

;     BANK 0

; AA	= SYSTEM
; ;** end of code **

;     ORG $FFFA

;     DW NMI
;     DW SYSTEM

;     ENDIF

;     ;END AA


;     option 0,1
;     endif

; 
.endif
