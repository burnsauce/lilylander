
.const PRA	 = $dc00
.const DDRA	 = $dc02
.const PRB	 = $dc01
.const DDRB	 = $dc03

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
.label phcount = reserve(1,0)
.label seconds = reserve(1,0)
.label secondsc = reserve(1,0)
.label level = reserve(1,0)
.label exec_count = reserve(1,0)
.label copy_request = reserve(1,0)
.label score = reserve(2,0)
.label bestscore = reserve(2,0)
.label curbg = reserve(1,0)

.macro scankey(col) {
	lda #((1 << col) ^ $ff)
	sta PRA
	lda PRB
	and #%00011000
	cmp #%00011000
}

.macro startFrame(delay) {
	startISR()
	switchToPreframe()
	asl $d019
	cli
	delay(delay)
}

.macro switchToPreframe() {
	mov16 $fffe : nextFrameISR
	setInterrupt(preFrameISR)
	lda #preFrameRaster
	sta $d012
	asl $d019
}

.macro refreshPreframe() {
	lda #preFrameRaster
	sta $d012
	lda #$7f
	and $d011
	sta $d011
	asl $d019
}

.macro animate() {
	jmp (aniptr)
}

.macro delay(n) {
	.for(var i=floor(n/2); i> 0; i--) {
		nop
	}
}
.segment Code "Frame Code"
loadingISR:	startISR()
	jsr $5403
	// copy ghostregs
	ldx #$18
lcopy:	lda $e5,x
	sta $d400,x
	dex
	bpl lcopy
	asl $d019
	finishISR()

finishFrame:
	dec exec_count
finishNonFrame:
	lda #$80
	and scrolling + 1
	bne chkscroll
	jmp fdone
chkscroll:	dec16 scrolling
	lda #$80
	ora scrolling + 1
	sta scrolling + 1
	inc scrollamt
	lda scrolling + 1
	and #$7f
	bne doscroll
	lda scrolling
	bne doscroll
	sta scrolling + 1
	jmp fdone
doscroll:	dec xscroll
	lda #$7
	and xscroll
	sta xscroll
	lda #$f8
	and $d016
	sta tmp0
	lda xscroll
	ora tmp0
	sta $d016
	lda xscroll
	cmp #$6
	bne fsw
	jmp fdone
fsw:	cmp #$7
	beq !+
	jmp fdone
!:	switchBank()
	doSwitchBank()
	inc copy_request
fdone:	moveLilies() 
	mov curbg : $d021
	asl $d019
	finishISR()

preFrameISR:
	startISR()
	delay(40)
	mov #6 : $d021
	mov16 nextFrameISR : $fffe
	jsr $5403
	copyGhostRegs()
	lda #frameRaster
	sta $d012
	asl $d019
	finishISR()

.label frogt = reserve(1,0)
ph1ani:	pushFrogRight(frspd)
	pushFrogUp(3)
	jmp finishFrame

ph2ani:	pushFrogRight(frspd)
	lda frdiv
	lsr
	sec
	sbc phcount
	bcs frogdown
	pushFrogUp(2)
	inc frogt
	inc frogt
	jmp finishFrame
frogdown:
	pushFrogDown(2)
	dec frogt
	dec frogt
	jmp finishFrame

ph3ani:	pushFrogRight(frspd)
	pushFrogDown(3)
	lda frogt
	bne !+
	jmp finishFrame
!:	pushFrogDown(1)
	dec frogt
	jmp finishFrame

titleISR:	startISR()
	jsr $5403
	// copy ghostregs
	ldx #$18
tcopy:	lda $e5,x
	sta $d400,x
	dex
	bpl tcopy
	lda t_bgcolor
	sta BG0COL
	lda #$ff
	sta DDRA
	lda #0
	sta DDRB
	scankey(7)
	beq !+
	jmp tholding
!:	lda keyheld
	bne startgame 
	jmp titledone
tholding:
	lda keyheld
	beq !+
	jmp titledone
!:	lda #1
	sta keyheld
	jmp titledone
startgame:	lda #0
	sta keyheld
	lda #$7f
	and $d011
	sta $d011
	lda #preFrameRaster
	sta $d012
	setInterrupt(loadingISR)
	asl $d019
	cli
	startGame()
	dec exec_count
	finishISR()
titledone:	
	lda bestscore
	ora bestscore + 1
	beq titlefinal
	lda bestscore + 1
	sec
	sbc score + 1
	bcc flash
	bne titlefinal
	lda bestscore
	sbc score
	bcc flash
	bne titlefinal
flash:
	dec titletmp
	bpl !+
	lda #4
	sta titletmp
!:	pokeBestScoreColor(titletmp)	
titlefinal:	asl $d019
	finishISR()
titletmp:	.byte 5

frameISR:
	// GAME LOGIC
	//startFrame(28)
	startFrame(0)
	inc exec_count
	cmp #$02
	bcs !+
	jmp skip
!:
	lda copy_request
	beq !+
	jmp skip
!:	
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
	lda #0
	sta keyheld
	jmpsound()
	mov16 #60 : scrolling
	lda #$80
	ora scrolling + 1
	sta scrolling + 1
	lda #1
	sta jumping
	sta phcount
	lda powerLevel
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc #2 
	sta frspd
	lda #10
	sta frdiv
	jmp skipkey
holding:
	lda keyheld
	bne !+
	lda #1
	sta keyheld
!:	
	updatePower()
	animate()
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
ph1:	
	loadSprite(frogj1, 0)
	loadSprite(frogj2, 1)
	loadSprite(frogj3, 2)
	disableSprite(3)
	enableSprite(6)
	enableSprite(7)
	loadSprite(lilys11, 6)
	loadSprite(lilys12, 7)
	mov16 #ph1ani : aniptr
	animate()
ph2:	cmp #2
	beq !+
	jmp ph3
!:
	loadSprite(frogs1, 0)
	loadSprite(frogs2, 1)
	disableSprite(2)
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
	enableSprite(2)
	enableSprite(3)
	mov16 #ph3ani : aniptr
	animate()
ph0:	lda #0
	sta phase
	sta jumping
	sta keyheld
	loadSprite(lilys41, 6)
	loadSprite(lilys42, 7)
	sec
	lda $d006 // frog
	sbc $d00a // lily
	//clc
	//adc #[landingMargin / 2]
	bpl gotabs
	eor #$ff
	clc
	adc #1
gotabs:	cmp #landingMargin
	bpl miss
	jmp hit

miss:	splashsound()
	mov16 #missed : nextFrameISR
	sec
	lda bestscore + 1
	sbc score + 1
	bcc newbest
	bne !+
	lda bestscore
	sbc score
	bcs !+
newbest:	mov16 score : bestscore
!:
	mov #7 : secondsc
	mov #0 : seconds
	sta powerLevel
	sta powerdir
	pushFrogDown(11)
	loadSprite(frogdie11, 0)
	loadSprite(frogdie12, 1)
	loadSprite(frogdie13, 2)
	loadSprite(frogdie14, 3)
	mov16 #finishFrame : aniptr
	jmp finishFrame

hit:	landsound()
	mov16 #finishFrame : aniptr
	disableSprite(4)
	disableSprite(5)
	loadSprite(frogl1, 0)
	loadSprite(frogl2, 1)
	loadSprite(frogl3, 2)
	loadSprite(frogl4, 3)
	mov16 #landed : nextFrameISR
	rnd16 lily1ramp
	// set scrolling amount to d - 60
	getfrogpos tmp0 
	sub16 tmp0 : #60 : scrolling
	lsr scrolling + 1
	ror scrolling
	lda #$80
	ora scrolling + 1
	sta scrolling + 1

	// score calc
	lda powerLevel
	sec
	sbc #50
	lsr
	clc
	adc score
	sta score
	bcc !+
	lda score + 1
	adc #0
	sta score + 1
!:	lda level
	asl
	tay
	mov16 leveldata,y : tmp0
	clc
	ror tmp0 + 1
	ror tmp0
	clc
	ror tmp0 + 1
	ror tmp0
	add16 tmp0 : score : score

	mov #0 : powerLevel
	sta powerdir
	sta seconds
	mov #15 : secondsc
	jmp finishFrame

skip:	dec exec_count
	inc frame_drops
	delay(100)
	mov curbg : $d021
	finishISR()

.label frame_drops = reserve(1,0)

.label rand = reserve(1,%10011101)
.label rand_hi = reserve(1,%01011011)
.label rand_t = reserve(1,0)

.pseudocommand rnd16 tar {
	lda rand_hi
	sta rand_t
	asl 
	rol rand_t
	asl 
	rol rand_t
	clc
	adc rand
	pha
	lda rand_t
	adc rand_hi
	sta rand_hi
	pla
	adc #$11
	sta rand
	lda rand_hi
	adc #$36
	sta rand_hi
	sta _16bitNext(tar)
	lda rand
	sta tar
}


.label waiting = reserve(1,0)

missed:	startFrame(0)
	lda waiting
	beq !+
	jmp chkcopy
!:	dec secondsc
	beq !+
	animate()
!:	mov #7 : secondsc
	inc seconds
	lda seconds
	cmp #1
	beq lotone
	jmp wait1more
lotone:	
	mov16 #finishFrame : aniptr
	disableSprite(6)
	disableSprite(7)
	loadSprite(frogdie21, 0)
	loadSprite(frogdie22, 1)
	loadSprite(frogdie23, 2)
	loadSprite(frogdie24, 3)
	jmp finishNonFrame
wait1more:	lda seconds
	cmp #2
	beq !+
	jmp chkcopy
!:	
	loadSprite(frogdie31, 0)
	loadSprite(frogdie32, 1)
	loadSprite(frogdie33, 2)
	loadSprite(frogdie34, 3)
	jmp finishNonFrame
chkcopy:	lda copy_request
	beq !+
	lda #1
	sta waiting
	jmp finishNonFrame
!:	sei
	lda #0
	sta waiting
	mov #15 : secondsc
	rnd16 lily1ramp
	// blank the display
	// clear raster hi
	lda #%01101111
	and $d011
	sta $d011
	lda #preFrameRaster
	sta $d012
	setInterrupt(loadingISR)
	asl $d019
	cli
	
	lda #2
	sta vicBank
	lda $dd00
	and #%11111100
	ora #2
	sta $dd00

	mov #LILY_OFFSET : lily1offset

	showTitle()
	restoreV3()
	// special case
	dec exec_count

	finishISR()

landed:	startFrame(0)
	lda seconds
	beq !+
	lda $d001 + (6 * 2)
	beq !+
	dec $d001 + (6 * 2)
	dec $d001 + (6 * 2)
!:	dec secondsc
	beq !+
	jmp chkscrol
!:	mov #15 : secondsc
	inc seconds
	lda seconds
	cmp #1
	beq hitone
	jmp ltwo 
hitone:	
	paintScore()
	loadSprite(canvas1, 6)
	lda #(1<<6)
	ora SPRYEX
	sta SPRYEX
	lda #(1<<6)
	ora SPRXEX
	sta SPRXEX
	mov #180 : $d001 + (6 * 2)
	lda #1
	and $d010
	beq !+
	lda #(1<<6)
	ora $d010
	sta $d010
	jmp !++
!:	lda #(1<<6) ^ $ff
	and $d010
	sta $d010
!:	mov $d000 : $d000 + (6 * 2)
	//disableSprite(6)
	disableSprite(7)
	loadSprite(frog1, 0)
	loadSprite(frog2, 1)
	loadSprite(frog3, 2)
	loadSprite(frog4, 3)
	inc level
	lda #63
	and level
	sta level
	//bne !+
	// Win condition?
	jmp finishNonFrame
ltwo:	
	getfrogpos tmp0 
	lda tmp0 + 1
	beq !+
	dec seconds
	jmp finishNonFrame
!:	lda tmp0
	cmp #110
	bcc !+
	dec seconds
	jmp finishNonFrame
!:	ldy #15
	sty secondsc
	moveLilies()
	lda seconds
	cmp #2
	beq !+
	jmp lthree
!:	loadSprite(lilyunf1, 4)
	mov #LILY_OFFSET : lily1offset
	jmp finishNonFrame
lthree:	cmp #3
	beq !+
	jmp lfour
!:	loadSprite(lilyunf21, 4)
	loadSprite(lilyunf22, 5)
	jmp finishNonFrame
lfour:	loadSprite(lilyunf31, 4)
	loadSprite(lilyunf32, 5)
	jmp finishNonFrame
chkscrol:	lda scrolling + 1
	and #$7f
	beq chklo
	jmp finishNonFrame
chklo:	lda scrolling
	beq complete
	jmp finishNonFrame
complete:	initLily()
	mov16 #frameISR : nextFrameISR
	refreshPreframe()
	jmp finishNonFrame
