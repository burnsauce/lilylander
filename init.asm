.segment InitCode "init"
init:	
	sei
	// disable timer
	lda #$7f
	sta $dc0d
	// disable raster IRQ
	lda #0
	sta $d01a
	// disable BASIC and KERNAL
	lda #$35
	sta $01

	initSID()
	initDblBuf()
	initFrame()

	copySprites()
	copyDblBitmap()
	copyDblMatrix()

	unrollMemCopy #rmb:#$d800:#1000:#doColorRamCopy
	unrollMemCopy #$d801:#rmb:#998:#doBufferRamCopy

	// wait for high raster
!:	lda $d011
	bpl !-
	// enable display
	//ora #1 << 4
	//and #$7f
	//sta $d011
	// enable interrupt
	lda #1
	sta $d01a
	cli
	jmp ready 

.macro initSID() {
	lda #0
	sta SIDctrl
	sta SIDctrl + 1
	sta SIDctrl + 2
}

.macro initFrame() {
	mov #12 : frdiv
	sta phcount
	lda #0
	sta phase
	sta jumping
	sta keyheld
	sta powerLevel
	sta seconds
	sta scrolling
	lda #1
	sta level

	// clear raster hi bit
	// turn off the display
	// half V scroll
	lda #%00110111
	sta $d011

	// set the raster interrupt line
	lda #frameRaster
	sta $d012

	// multicolor
	// 40 col
	// full H scroll
	lda #%00010111
	sta $d016
	lda #$f
	sta xscroll

	// bits 4-7 are for matrix offset
	// bits 1-3 are for bitmap
	lda #%00001000
	sta $d018

	rleUnpackImage(bmb1, smb1, $d800)
	initFrog()
	initLily()
	loadLevel(level)
	mov16 #finishFrame : aniptr
	setInterrupt(frameISR)
}

.macro initDblBuf() {
	lda $dd00
	and #$fc
	ora #2
	sta $dd00
	mov #2 : vicBank
}