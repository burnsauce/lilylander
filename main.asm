// LilyLander
// (c) 2019 sliderule@gmail.com
//
// main.asm

#import "registers.asm"
#import "segments.asm"

.segment Code
#import "common.asm"
#import "multiply.asm"
#import "zeropage.asm"
#import "unroll.asm"
#import "dblbuf.asm"
//#import "sprlib.asm"
#import "sid.asm"
#import "rle.asm"
#import "bgdata.asm"
#import "sprmux.asm"
#import "frame.asm"
#import "init.asm"
#import "game.asm"

.segment Code "Main Loop"
ready:	
	copyDblRam()
	//jsr doBufferRamCopy
loop:	lda frame_count
	beq loop
	jsr updateGame
wait:	lda frame_count
	bne wait
	jmp loop
