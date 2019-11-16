* = * "Frame Code"
.label frdiv = reserve(1)
.label frspd = reserve(1)

.const PRA	 = $dc00
.const DDRA	 = $dc02
.const PRB	 = $dc01
.const DDRB	 = $dc03
.label aniptr = reserve()
.label cfreq = reserve()
.label phase = reserve(1)
.label phcount = reserve(1)
.label jumping = reserve(1)
.label keyheld = reserve(1)
.label seconds = reserve(1)  
.label level = reserve(1)
.const frameRaster = 251 
.const landingMargin = 24
.label xscroll = reserve(1)

.macro scankey(col) {
	lda #((1 << col) ^ $ff)
	sta PRA
	lda PRB
	cmp #$ff
}

.macro animate() {
	jmp (aniptr)
}
.macro finishFrame() {
/*
	ldy $d016
	lda $d016
	and #$f8
	sta $d016
	dey	
	tya
	and #7
	ora $d016
	sta $d016
*/
	asl $d019
	rti
}

noAnimation:
	finishFrame()

ph1ani:	pushFrogRight(frspd)
	pushFrogUp(3)
	lda #$02
	adc cfreq + 1
	sta cfreq + 1
	SIDfreqd(1, cfreq)
	finishFrame()

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
	finishFrame()

ph3ani:	pushFrogRight(frspd)
	pushFrogDown(3)
	finishFrame()

.macro jmpsound() {
	lda #$00
	sta cfreq
	lda #$08
	sta cfreq + 1
	SIDvol(10)
	SIDtri(1)
	SIDadsr(1, 1, 7, 15, 2)
	SIDfreqd(1, cfreq)
	SIDgate(1, 1)
}

.macro jmpstop() {
	SIDgate(1, 0)
}

frameISR:	moveLily()
	lda keyheld
	beq !+
	jmp !++
!:	lda jumping
	beq !+
	jmp skipkey
!:	lda #$ff
	sta DDRA
	lda #0
	sta DDRB
	scankey(0)
	beq !+
	jmp holding
!:	scankey(1)
	beq !+
	jmp holding
!:	scankey(2)
	beq !+
	jmp holding
!:	scankey(3)
	beq !+
	jmp holding
!:	scankey(4)
	beq !+
	jmp holding
!:	scankey(5)
	beq !+
	jmp holding
!:	scankey(6)
	beq !+
	jmp holding
!:	scankey(7)
	beq !+
	jmp holding
!:	lda keyheld
	bne jumpnow
	animate()
jumpnow:	lda #1
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
	jmp skipkey
	holding:	lda keyheld
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
	skipkey:	ldy phcount
	dey
	sty phcount
	beq !+
	animate()
	// --------------- phase update ----------------
!:	ldy frdiv
	sty phcount
	lda phase					 
	clc
	adc #1
	sta phase
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
	bpl absfound
	eor #$ff
	clc
	adc #1
absfound: cmp #landingMargin
	bpl miss
	jmp hit
miss:	setInterrupt(missed)
	lda #0
	sta seconds
	ldy #15
	SIDfreq(1, $0F00)
	SIDgate(1, 1)
	animate()
hit:	inc [$0400 + 41]
	mov16 #noAnimation : aniptr
	loadSprite(frog2, 3)
	loadSprite(blank, 0)
	loadSprite(blank, 1)
	loadSprite(blank, 2)
	setInterrupt(landed)
	lda #0
	sta seconds
	ldy #15
	SIDfreq(1, $0F00)
	SIDgate(1, 1)
	finishFrame()

missed:	moveLily()
	dey
	bne mlks
	ldy #15
	lda seconds
	clc
	adc #1
	sta seconds
	cmp #1
	beq lotone
	SIDgate(1, 0)
	jmp mlks
lotone:	SIDfreq(1, $0780)
mlks:	lda #$ff
	sta DDRA
	lda #0
	sta DDRB
	scankey(0)
	beq !+
	jmp mcont
!:	scankey(1)
	beq !+
	jmp mcont
!:	scankey(2)
	beq !+
	jmp mcont
!:	scankey(3)
	beq !+
	jmp mcont
!:	scankey(4)
	beq !+
	jmp mcont
!:	scankey(5)
	beq !+
	jmp mcont
!:	scankey(6)
	beq !+
	jmp mcont
!:	scankey(7)
	beq !+
	jmp mcont
!:	lda keyheld
	bne mcomplete
	lda seconds
	cmp #2
	bpl !+
	animate()
!:	ldy #15
	finishFrame()
mcont:	lda #1
	sta keyheld
	lda seconds
	cmp #2
	bpl !+
	animate()
!:	finishFrame()
mcomplete: lda #0
	sta keyheld
	initFrog()
	mov16 #noAnimation : aniptr
	setInterrupt(frameISR)
	finishFrame()

landed:	dey
	bne lks
	ldy #15
	lda seconds
	clc
	adc #1
	sta seconds
	cmp #1
	beq hitone
	SIDgate(1, 0)
	jmp lks
hitone:	SIDfreq(1, $1E00)
lks:	lda #$ff
	sta DDRA
	lda #0
	sta DDRB
	scankey(0)
	beq !+
	jmp continue
!:	scankey(1)
	beq !+
	jmp continue
!:	scankey(2)
	beq !+
	jmp continue
!:	scankey(3)
	beq !+
	jmp continue
!:	scankey(4)
	beq !+
	jmp continue
!:	scankey(5)
	beq !+
	jmp continue
!:	scankey(6)
	beq !+
	jmp continue
!:	scankey(7)
	beq !+
	jmp continue
!:	lda keyheld
	bne complete
	finishFrame()
continue: lda #1
	sta keyheld
	finishFrame()
complete: 
	inc level
	loadLevel(level)
	lda #0
	sta keyheld
	SIDgate(1, 0)
	initFrog()
	setInterrupt(frameISR)
	finishFrame()

.macro initFrame() {
	ldy #frdiv
	sty phcount
	lda #0
	sta xscroll
	sta phase
	sta jumping
	sta keyheld
	sta powerLevel
	sta seconds
	lda #1
	sta level
	lda #48
	//sta [$0400 + 41]
	initFrog()
	initLily()
	loadLevel(level)
	mov16 #noAnimation : aniptr

	// trim the border
	//lda $d016
	//and #((1 << 3) ^ $ff)
	//sta $d016
	// set interrupt vector
	sei
	lda #$7f
	sta $dc0d
	and $d011
	sta $d011
	lda #frameRaster
	sta $d012

	initBackground()
	setInterrupt(frameISR)
	lda #1
	sta $d01a
	cli

}
