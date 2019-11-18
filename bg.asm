#import "rivbg.asm"

.macro initBackground() {
	lda $d011
	ora #(1 << 5)		// bitmap gfx mode
	and #((1 << 6) ^ $ff)	// disable x color text mode
	sta $d011
	
	lda $d016
	and #((1 << 3) ^ $ff)
	ora #(1 << 4)		// multicolor mode
	sta $d016

	// bits 4-7 are for matrix offset
	// bits 1-3 are for bitmap
	lda #%00001000
	sta $d018

	initRiver(bmb1, smb1, $d800)
}
