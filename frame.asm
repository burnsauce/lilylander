.segment Code 

.const PRA	 = $dc00
.const DDRA	 = $dc02
.const PRB	 = $dc01
.const DDRB	 = $dc03

.const frameRaster = 251
.const preFrameRaster = 120
.const landingMargin = 24

.label frspd = reserve(1,0)
.label frdiv = reserve(1,12)
.label phase = reserve(1,0)
.label jumping = reserve(1,0)
.label keyheld = reserve(1,0)
.label xscroll = reserve(1,$7)
.label scrolling = reserve(2,0)
.label scrollamt = reserve(2,0)
.label nextFrameISR = reserve(0)
.label aniptr = reserve(0)
.label ftmp = reserve(0)
.label phcount = reserve(1,0)
.label seconds = reserve(1,0)
.label secondsc = reserve(1,0)
.label level = reserve(1,1)
.label exec_count = reserve(1,0)
.label copy_request = reserve(1,0)
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
	lda #$80
	and scrolling + 1
	bne !+
	jmp fdone
!:	
	dec16 scrolling
	lda #$80
	ora scrolling + 1
	sta scrolling + 1
	inc scrollamt
	lda scrolling + 1
	and #$7f
	bne !+
	lda scrolling
	bne !+
	sta scrolling + 1
	jmp fdone
!:	dec xscroll
	lda #$7
	and xscroll
	sta xscroll
	lda #$f8
	and $d016
	sta ftmp
	lda xscroll
	ora ftmp
	sta $d016
	lda xscroll
	cmp #$6
	bne fsw
	inc copy_request
	jmp fdone
fsw:	cmp #$7
	beq !+
	jmp fdone
wait:	lda copy_request
	bne wait
!:	switchBank()
	doSwitchBank()
	jsr doColorRamCopy
fdone:	moveLilies() 
	dec exec_count
	finishISR()

*=* "preFrameISR"
preFrameISR:
	pha
	delay(40)
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
	// GAME LOGIC
	//startFrame(28)
	startFrame(0)
	inc exec_count
	cmp #$02
	bcs !+
	jmp skip
!:	lda copy_request
	beq !+
	jmp skip
!:	lda keyheld
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
	lda powerLevel
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
	beq ph1
	jmp ph2
ph1:	jmpsound()
	loadSprite(frogj1, 0)
	loadSprite(frogj2, 1)
	loadSprite(frogj3, 2)
	loadSprite(blank, 3)
	enableSprite(6)
	enableSprite(7)
	loadSprite(lilys11, 6)
	loadSprite(lilys12, 7)
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
	loadSprite(lilys21, 6)
	loadSprite(lilys22, 7)
	mov16 #ph2ani : aniptr
	animate()
ph3:	cmp #3
	beq !+
	jmp ph0
!:	loadSprite(frogf1, 0)																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											 
	loadSprite(frogf2, 1)
	loadSprite(frogf3, 2)
	loadSprite(frogf4, 3)
	loadSprite(lilys31, 6)
	loadSprite(lilys32, 7)
	mov16 #ph3ani : aniptr
	animate()
ph0:	lda #0
	sta phase
	sta jumping
	sta keyheld
	resetPower()
	loadSprite(lilys41, 6)
	loadSprite(lilys42, 7)
	sec
	lda $d006 // frog
	sbc $d00a // lily
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
	disableSprite(4)
	disableSprite(5)
	loadSprite(frogl1, 0)
	loadSprite(frogl2, 1)
	loadSprite(frogl3, 2)
	loadSprite(frogl4, 3)
	mov16 #landed : nextFrameISR
	getfrogpos ftmp 
	sub16 ftmp : #60 : scrolling
	lda #$80
	ora scrolling + 1
	sta scrolling + 1
	mov #0 : seconds
	mov #15 : secondsc
	SIDfreq(1, $0F00)
	SIDgate(1, 1)
	jmp finishFrame
skip:	dec exec_count
	finishISR()

* = * "Missed Handler"
missed:	startFrame(0)
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
	disableSprite(6)
	disableSprite(7)
mlks:
!:	lda seconds
	cmp #2
	bpl !+
	animate()
!:	mov #15 : secondsc
	sei
	lda #%11101111
	and $d011
	sta $d011
	resetToStart()
.for(var i=0; i<40; i++) {
	copyDblRam()
	jsr doColorRamCopy
	jsr copyDblBitmap
	jsr copyDblMatrix
	switchBank()
	//doSwitchBank()
}
	lda #%00010000
	ora $d011
	sta $d011
	initFrog()
	mov16 #finishFrame : aniptr
	mov16 #frameISR : nextFrameISR
	cli
	jmp finishFrame

* = * "landed Handler"
landed:	startFrame(0)
	dec secondsc
	beq !+
	jmp lks
!:	mov #15 : secondsc
	inc seconds
	lda seconds
	cmp #1
	beq hitone
	SIDgate(1, 0)
	jmp lks
hitone:	SIDfreq(1, $1E00)
	disableSprite(6)
	disableSprite(7)
	loadSprite(frog1, 0)
	loadSprite(frog2, 1)
	loadSprite(frog3, 2)
	loadSprite(frog4, 3)
lks:	lda scrolling + 1
	and #$80
	beq complete
	
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
