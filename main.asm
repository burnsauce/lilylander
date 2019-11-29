// LilyLander
// (c) 2019 sliderule@gmail.com
//
// main.asm

#import "registers.asm"
#import "segments.asm"

.segment Code
#import "common.asm"
#import "zeropage.asm"
#import "config.asm"
#import "unroll.asm"
#import "dblbuf.asm"
#import "sprlib.asm"
#import "sid.asm"
#import "rle.asm"
#import "bgdata.asm"
#import "titledata.asm"
#import "game.asm"
#import "frame.asm"
#import "fontlib.asm"
#import "canvas.asm"
#import "init.asm"

.segment Code "Main Loop"
ready:	jsr copyDblRam
	cli
loop:	lda copy_request
	beq loop
	jsr doColorRamCopy
	jsr copyDblMatrix
	jsr copyDblBitmap
	jsr copyDblRam
	dec copy_request
!:	jmp loop
