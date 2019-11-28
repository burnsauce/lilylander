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

	initZeroPage()
	initDblBuf()
	initFrame()
	initQSin()

	copySprites()
	jsr copyDblBitmap
	jsr copyDblMatrix

	unrollMemCopy #rmb:#$d800:#(13 * 40):#doColorRamCopy

	// wait for high raster
!:	lda $d011
	bpl !-
	// enable interrupt
	lda #1
	sta $d01a
	jmp ready 

.macro initFrame() {

	// bits 4-7 are for matrix offset
	// bits 1-3 are for bitmap
	lda #%00001000
	sta $d018
	showTitle()
}

.macro showTitle() {
	disableSprites()
	lda #%11101111
	and $d011
	sta $d011
	lda t_bgcolor
	sta BG0COL
	// clear raster hi bit
	// full V scroll
	lda #%00100111
	sta $d011
	// multicolor
	// 38 col
	// no H scroll
	lda #%00010000
	sta $d016
	jsr rleUnpackTitle
	writeScore()
	setScoreColors(6)
	// set the raster interrupt line
	lda #frameRaster
	sta $d012
	mov16 #finishFrame : aniptr
	mov16 #frameISR : nextFrameISR
	lda #frameRaster
	sta $d012
	setInterrupt(titleISR)
	lda #%00110111
	sta $d011

}
	
.macro startGame() {
	// blank screen
	lda #%00100111
	sta $d011
	// multicolor
	// 38 col
	// full H scroll
!:	lda RASTER - 1
	bpl !-
	lda #%00010111
	sta $d016
	jsr rleUnpackImage
	jsr copyDblBitmap
	jsr copyDblMatrix
	jsr copyDblRam	
	zeroMem(bmb2 + 13 * 8 * 40, 12 * 8 * 40)
	zeroMem(smb2 + 13 * 40, 12 * 40)
	zeroMem($d800 + 13 * 40, 12 * 40)
	zeroMem(bmb1 + 13 * 8 * 40, 12 * 8 * 40)
	zeroMem(smb1 + 13 * 40, 12 * 40)
	zeroMem(rmb + 13 * 40, 12 * 40)
	
	lda #%00010000
	sta $d016
	initFrog()
	mov #7 : xscroll
	lda #$f8
	and $d016
	ora xscroll
	sta $d016
	mov #0 : level
	mov #6 : watercolor
	mov16 #0 : score
	
	
	initLily()
	mov #7 : xscroll
	lda #$f8
	and $d016
	ora xscroll
	sta $d016
	mov #0 : level
	mov #6 : watercolor
	mov16 #0 : score
	
	
	initLily()
	mov16 #finishFrame : aniptr
	mov16 #frameISR : nextFrameISR
	// set the raster interrupt line
	lda #preFrameRaster
	sta $d012
	setInterrupt(preFrameISR)
	lda #%00110111
	sta $d011
}

.macro initDblBuf() {
	lda $dd00
	and #$fc
	ora #2
	sta $dd00
	mov #2 : vicBank
}
