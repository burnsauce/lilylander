.segment Code
#import "sin.asm"

.label gametmp = reserve(1,0)
.label phase_countdown = reserve(1,0)
.label holding = reserve(1,0)


.const FROG3 = 0
.const LILY1 = 1
.const LILY2 = 2
.const LILY3 = 3
.const LILY4 = 4
.const FROGJ1 = 5
.const FROGJ2 = 6
.const FROGJ3 = 7
.const FROGS1 = 8
.const FROGS2 = 9
.const FROGF1 = 10
.const FROGF2 = 11
.const FROGF4 = 12
.macro initActors() {
.const FROG3 = 0
.const LILY1 = 1
.const LILY2 = 2
.const LILY3 = 3
.const LILY4 = 4
.const FROGJ1 = 5
.const FROGJ2 = 6
.const FROGJ3 = 7
.const FROGS1 = 8
.const FROGS2 = 9
.const FROGF1 = 10
.const FROGF2 = 11
.const FROGF4 = 12
	loadActor(FROG3, frog2, 35, 170)
	loadActor(LILY1, lily1, 0, 190)
	loadActor(LILY2, lily2, 0, 190)
	loadActor(LILY3, lily3, 0, 190 + 21)
	loadActor(LILY4, lily4, 0, 190 + 21)
	loadActor(FROGJ1, frogj1, 35, 170 - 21)
	loadActor(FROGJ2, frogj2, 35 + 24, 170 - 21)
	loadActor(FROGJ3, frogj3, 35, 170)
	loadActor(FROGS1, frogs1, 35, 170 - 21)
	loadActor(FROGS2, frogs2, 35 + 24, 170)
	loadActor(FROGF1, frogf1, 35, 170 - 21)
	loadActor(FROGF2, frogf2, 35 + 24, 170 - 21)
	loadActor(FROGF4, frogf4, 35 + 24, 170 - 21)
	moveActorAbs #FROG3 : #50 : #180
}

.macro scankeys() {
}
updateGame:
	lda jumping
	beq !+
	jmp processjump
!:	mov holding : gametmp
	scankeys()
	lda holding
	cmp gametmp
	bne toggle
	jmp restfrog	
toggle:	lda holding
	beq jumpnow_
	updatePower()
	jmp restfrog

jumpnow_:	inc jumping
	// set power level
	lda powerLevel
	lsr
	lsr
	lsr
	lsr
	clc
	adc #2
	sta frspd
	lda #12
	sta frdiv
	mov #1 : phase_countdown
	mov #255 : phase

	//jmp processjump
processjump:
	dec phase_countdown
	beq nextphase
	jmp movefrog
nextphase:	mov frdiv : phase_countdown
	inc phase
movefrog:	updateFrog()
	//checkLanded()
	jmp keysdone
restfrog:	showActor(FROG3)
	moveActor #FROG3 : #2 : #0
keysdone:
	// updateClouds()
	// updateLilies()
	rts

.macro updateFrog() {
	lda phase
	beq ph0
	jmp ph1_chk
ph0:	lda phase_countdown
	cmp frdiv
	beq ph0_align
	jmp ph0_move
ph0_align:	alignActor(FROGJ3, FROG3, 0, 0)
	alignActor(FROGJ1, FROGJ3, 0, -21)
	alignActor(FROGJ2, FROGJ1, 24, 0)
ph0_move:	moveActor FROGJ1 : frspd : frspd	
	moveActor FROGJ2 : frspd : frspd	
	moveActor FROGJ3 : frspd : frspd
	showActor(FROGJ1)	
	showActor(FROGJ2)	
	showActor(FROGJ3)
	jmp done

ph1_chk:	cmp #1
	beq ph1
	jmp ph2_chk
ph1:	lda phase_countdown
	cmp frdiv
	beq ph1_align
	jmp ph1_move
ph1_align:	alignActor(FROGJ1, FROGS1, 0, 0)
	alignActor(FROGJ2, FROGS2, 0, 0)
ph1_move:	moveActor FROGS1 : frspd : 0
	moveActor FROGS2 : frspd : 0
	showActor(FROGS1)
	showActor(FROGS2)
	jmp done


ph2_chk:	cmp #2
	beq ph2
	jmp ph2_move // final phase
ph2:	lda phase_countdown
	cmp frdiv
	beq ph2_align
	jmp ph2_move
ph2_align:	alignActor(FROGF1, FROGS1, 0, 0)
	alignActor(FROGF2, FROGS2, 0, 0)
	alignActor(FROGF4, FROGF2, 0, 21)
	// *= -1, invert motion
	lda frspd
	eor #$ff
	sta frspd
	inc frspd
ph2_move:	moveActor FROGF1 : frspd : frspd
	moveActor FROGF2 : frspd : frspd
	moveActor FROGF4 : frspd : frspd
	showActor(FROGF1)
	showActor(FROGF2)
	showActor(FROGF4)
done:
}

.label lilya = reserve(1,0)
.label lilyb = reserve(1,0)

.macro moveLily() {
	inc lilya
	ldy lilya
	lda sin_table,y
	sec
	sbc lilya
	sta lilyb
	moveActor LILY1 : lilyb : #0
	moveActor LILY2 : lilyb : #0
	moveActor LILY3 : lilyb : #0
	moveActor LILY4 : lilyb : #0
	showActor(LILY1)
	showActor(LILY2)
	showActor(LILY3)
	showActor(LILY4)
}

.pseudocommand asl16 a {
	asl
	rol a
}

.macro updatePower() {
updatePower:
	ldy powerLevel
	iny
	beq !+
	inc powerLevel
!:
}

.macro resetPower() {
resetPower:
	lda #0
	sta powerLevel
}

