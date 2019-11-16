.label bitmapAddr = $4000
.label matrixAddr = $7000
.label ramAddr = $d800
#import "rivbg.asm"
#import "sprites.asm"

.macro initBackground() {
	lda $d011
	ora #(1 << 5)		// bitmap gfx mode
	and #((1 << 6) ^ $ff)	// disable x color text mode
	sta $d011
	
	lda $d016
	and #((1 << 3) ^ $ff)
	ora #(1 << 4)		// multicolor mode
	sta $d016

	lda $d018 // bits 4-7 are for matrix offset
	and #$0f
	ora #%11000000
	sta $d018

	lda $dd00 // last 2 bits set VIC bank
	and #%11111100
	ora #%00000010
	sta $dd00

	initRiver(bitmapAddr, matrixAddr, ramAddr)
}
