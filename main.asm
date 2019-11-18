// LilyLander
// (c) 2019 sliderule@gmail.com
//
// main.asm

#import "registers.asm"
#import "segments.asm"

.segment Code
#import "common.asm"
#import "multiply.asm"
#import "dblbuf.asm"
#import "bg.asm"
#import "sid.asm"
#import "sprlib.asm"
#import "game.asm"
#import "frame.asm"

.segment InitCode
.const kcls = $ff81
init:	sei
	// disable timer
	lda #$7f
	sta $dc0d
	// disable raster IRQ
	lda #0
	sta $d01a
	// blank the frame
	lda #1 << 4
	ora $d011
	sta $d011
	// disable BASIC and KERNAL
	lda #$35
	sta $01
	
	initDblBuf()
	initSID()
	initFrame()
	jmp ready 

.segment Code "Main Loop"
ready:	copySprites()
	copyDblRam()
loop:	lda xscroll
	cmp #$f
	bne loop
	copyDblBitmap()
	copyDblMatrix()
	copyDblRam()
	jmp loop
