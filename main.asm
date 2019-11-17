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
init:	jsr kcls
	lda #$35	      // disable the BASIC /K ROM
	sta $01
	initDblBuf()
	initSID()
	initFrame()
	jmp loop

.segment Code "Main Loop"
loop:	lda xscroll
	cmp #$e
	bne loop
	jsr copyDblBitmap
	jsr copyDblMatrix
	//jsr copyDblRam
	//jsr copyDblToRam
	jmp loop
