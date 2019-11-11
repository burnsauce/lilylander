// LilyLander
// (c) 2019 sliderule@gmail.com
//
// main.asm
//
// MEMORY MAP
//
// 0002 - 00FF - zeropage variables 
// 0400 - 07FE - video char buffer
// 0801 - 0810 - BASIC loader
// 0810 - 121b - code
// 2000 - 3f40 - bitmap
// 3f40 - 4328 - character ram
// 4328 - 4710 - color ram
// 4710 - cfff - free 
// d000 - dfff - I/O
// e000 - fffd - free
// fffe - ffff - IRQ vector
// CONSTANTS ------------------------------------


* = $801 "Bootstrap"
BasicUpstart(init)
     
* = $810 "Program Code"
//.var lowaddr = *
#import "common.asm"
//#import "bg.asm"
#import "sid.asm"
#import "sprlib.asm"
#import "sprites.asm"
#import "game.asm"
//#import "raster.asm"
#import "frame.asm"

// INIT --------------------------------------
.const kcls = $ff81
init:	jsr kcls
	lda #$35	      // disable the BASIC /K ROM
	sta $01

	initSID()
	//initBackground()
	initFrame()
	
loop:	jmp loop

highest_code:
      
