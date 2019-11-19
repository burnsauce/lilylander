// LilyLander
// (c) 2019 sliderule@gmail.com
//
// main.asm

#import "registers.asm"
#import "segments.asm"

.segment Code
#import "common.asm"
#import "zeropage.asm"
#import "unroll.asm"
#import "dblbuf.asm"
#import "sprlib.asm"
#import "sid.asm"
#import "rle.asm"
#import "bgdata.asm"
#import "game.asm"
#import "frame.asm"
#import "init.asm"

.segment Code "Main Loop"
ready:	copyDblRam()

	//jsr doBufferRamCopy
	lda #$80
loop:	bit scrolling
	beq loop
scrl:	lda xscroll
	cmp #$e
	bne scrl
	copyDblMatrix()
	copyDblBitmap()
	//jsr doBufferRamCopy
	copyDblRam()
	lda #$80
	bit scrolling
	beq !+
	jmp scrl
!:	jmp loop
