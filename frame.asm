.segment Code 

.const PRA	 = $dc00
.const DDRA	 = $dc02
.const PRB	 = $dc01
.const DDRB	 = $dc03

.const frameRaster = 251
.const preFrameRaster = 60
.const landingMargin = 24

.label nextFrameISR = reserve(0)
.label aniptr = reserve(0)
.label ftmp = reserve(0)
.label phcount = reserve(1,0)
.label seconds = reserve(1,0)
.label secondsc = reserve(1,0)
.label level = reserve(1,1)

.macro scankey(col) {
	lda #((1 << col) ^ $ff)
	sta PRA
	lda PRB
	cmp #$ff
}

.macro startFrame(delay) {
	startISR()
	switchToPreframe()
	asl $d019
	cli
	delay(delay)
	mov #3 : $d021
	moveLily() 
}

.macro switchToPreframe() {
	mov16 $fffe : nextFrameISR
	setInterrupt(preFrameISR)
	lda #preFrameRaster
	sta $d012
}

.macro animate() {
	jmp (aniptr)
}

.macro delay(n) {
	.for(var i=floor(n/2); i> 0; i--) {
		nop
	}
}

.align $100
*=* "finishFrame"
finishFrame:
	lda #80
	bit scrolling
	bne !+
	jmp fdone
!:	dec scrolling
	lda scrolling
	and #$7f
	bne !+
	sta scrolling
	jmp fdone
!:	dec xscroll
	lda #$f
	and xscroll
	sta xscroll
	lda #$f8
	and $d016
	sta ftmp
	lda xscroll
	lsr
	ora ftmp
	sta $d016
	lda xscroll
fsw:	cmp #$f
	beq !+
	jmp fdone
!:	switchBank()
	doSwitchBank()
	jsr doColorRamCopy
fdone:	
	finishISR()

*=* "preFrameISR"
preFrameISR:
	pha
	.break
	delay(28)
	mov #6 : $d021
	mov16 nextFrameISR : $fffe
	lda #frameRaster
	sta $d012
	asl $d019
	pla; rti

*=* "Animation Handlers"

ph1ani:	pushFrogRight(frspd)
	pushFrogUp(3)
	lda #$02
	adc cfreq + 1
	sta cfreq + 1
	SIDfreqd(1, cfreq)
	jmp finishFrame

ph2ani:	pushFrogRight(frspd)
	lda frdiv
	lsr
	sec
	sbc phcount
	bcs frogdown
	pushFrogUp(2)
	jmp ph2ani1
frogdown:
	pushFrogDown(2)
ph2ani1:
	jmp finishFrame

ph3ani:	pushFrogRight(frspd)
	pushFrogDown(3)
	jmp finishFrame

*=* "frameISR"
frameISR:
	startFrame(28)
	lda keyheld
	bne !+
	lda jumping
	beq !+
	jmp skipkey
!:	lda #$ff
	sta DDRA
	lda #0
	sta DDRB
	scankey(7)
	beq !+
	jmp holding
!:	lda keyheld
	bne jumpnow
	animate()
jumpnow:
	lda #1
	sta jumping
	sta phcount
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
	lda #0
	sta keyheld
	lda #$ff
	sta scrolling
	jmp skipkey
holding:
	lda keyheld
	bne !+
	jmpsound()
	lda #1
	sta keyheld
!:	lda powerLevel
	cmp #80
	bpl !+
	updatePower()
	lda #$F0
	clc
	adc cfreq
	sta cfreq
	bcc !+
	inc cfreq + 1
	SIDfreqd(1, cfreq)
!:	animate()
skipkey:
	dec phcount
	beq !+
	animate()
	// --------------- phase update ----------------
!:	ldy frdiv
	sty phcount
	inc phase
	lda phase
	cmp #1
	beq !+
	jmp ph2
!:	jmpsound()
	loadSprite(frogj1, 0)
	loadSprite(frogj2, 1)
	loadSprite(frogj3, 2)
	loadSprite(blank, 3)
	mov16 #ph1ani : aniptr
	animate()
ph2:	cmp #2
	beq !+
	jmp ph3
!:	jmpstop()
	loadSprite(frogs1, 0)
	loadSprite(frogs2, 1)
	loadSprite(blank, 2)
	loadSprite(blank, 3)
	mov16 #ph2ani : aniptr
	animate()
ph3:	cmp #3
	beq !+
	jmp ph0
!:	loadSprite(frogf1, 0)																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											 
	loadSprite(frogf2, 1)
	loadSprite(frogf4, 3)
	loadSprite(blank, 2)
	mov16 #ph3ani : aniptr
	animate()
ph0:	lda #0
	sta phase
	sta jumping
	sta keyheld
	resetPower()
	sec
	lda $d006 // frog
	sbc $d00e // lily
	clc
	adc #[landingMargin / 2]
	bpl gotabs
	eor #$ff
	clc
	adc #1
gotabs:	cmp #landingMargin
	bpl miss
	jmp hit
miss:	mov16 #missed : nextFrameISR
	mov #0 : seconds
	mov #15 : secondsc
	SIDfreq(1, $0F00)
	SIDgate(1, 1)
	animate()
hit:	mov16 #finishFrame : aniptr
	loadSprite(frog2, 3)
	loadSprite(blank, 0)
	loadSprite(blank, 1)
	loadSprite(blank, 2)
	mov16 #landed : nextFrameISR
	mov #0 : seconds
	mov #15 : secondsc
	SIDfreq(1, $0F00)
	SIDgate(1, 1)
	jmp finishFrame

* = * "Missed Handler"
missed:	startFrame(28)
	dec secondsc
	bne mlks
	mov #15 : secondsc
	inc seconds
	lda seconds
	cmp #1
	beq lotone
	SIDgate(1, 0)
	jmp mlks
lotone:	SIDfreq(1, $0780)
mlks:	lda #$ff
	sta DDRA
	lda #0
	sta DDRB
	scankey(7)
	beq !+
	jmp mcont
!:	lda keyheld
	beq !+
	jmp mcomplete
!:	lda seconds
	cmp #2
	bpl !+
	animate()
!:	mov #15 : secondsc
	jmp finishFrame
mcont:	lda #1
	sta keyheld
	lda seconds
	cmp #2
	bpl !+
	animate()
!:	jmp finishFrame
mcomplete: lda #0
	sta keyheld
	initFrog()
	mov16 #finishFrame : aniptr
	mov16 #frameISR : nextFrameISR
	jmp finishFrame

* = * "landed Handler"
landed:	startFrame(28)
	dec secondsc
	bne lks
	mov #15 : secondsc
	inc seconds
	lda seconds
	cmp #1
	beq hitone
	SIDgate(1, 0)
	jmp lks
hitone:	SIDfreq(1, $1E00)
lks:	lda #$ff
	sta DDRA
	lda #0
	sta DDRB
	scankey(7)
	beq !+
	jmp continue
!:	lda keyheld
	beq !+
	jmp complete
!:	jmp finishFrame
continue: lda #1
	sta keyheld
	jmp finishFrame
complete: 
	mov16 #frameISR : nextFrameISR
	inc level
	loadLevel(level)
	lda #0
	sta keyheld
	SIDgate(1, 0)
	initFrog()
	jmp finishFrame
