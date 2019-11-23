#import "actors.asm"
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
	//initSID()
	initDblBuf()
	initFrame()
	initSprMux()
	initActors()

	copySprites()
	copyDblBitmap()
	copyDblMatrix()

	unrollMemCopy #rmb:#$d800:#1000:#doColorRamCopy

	setSpriteMC(5, 2)
	// wait for high raster
!:	lda $d011
	bpl !-

	mov #$ff : scrolling

	initRasters()
	jsr updateGame
	cli
	jmp ready 

.macro initDblBuf() {
initDblBuf:
	lda $dd00
	and #$fc
	ora #2
	sta $dd00
	mov #2 : vicBank
}
