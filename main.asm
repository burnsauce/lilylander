// LilyLander
// (c) 2019 sliderule@gmail.com
//
// main.asm

#import "registers.asm"
* = $801 "Bootstrap"
BasicUpstart(init)
     
* = $810 "Program Code"
//.var lowaddr = *
#import "common.asm"
#import "bg.asm"
#import "sid.asm"
#import "sprlib.asm"
#import "game.asm"
//#import "raster.asm"
#import "frame.asm"

.const kcls = $ff81
init:	jsr kcls
	lda #$35	      // disable the BASIC /K ROM
	sta $01

	initSID()
	//initBackground()
	initFrame()
	
loop:	jmp loop

highest_code:
      
