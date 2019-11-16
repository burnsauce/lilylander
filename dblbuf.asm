.var 	dblnext = *

.label 	smb1 = $7000
* = smb1 "Screen Matrix Buffer 1" virtual
	.fill $3f8, 0
.label sprp1 = *
.label 	smb2 = $f000
* = smb2 "Screen Matrix Buffer 2" virtual
	.fill $3f8, 0
.label sprp2 = *
.label 	bmb1 = $4000
* = bmb1 "Bitmap Buffer 1" virtual
	.fill $1f40, 0
*=*	"Bank 1 Sprites"
#import "sprites.asm"
.label 	bmb2 = $c000
*= 	bmb2 "Bitmap Buffer 2" virtual
	.fill $1f40, 0
*=*	"Bank 2 Sprites" virtual
	.fill sprdata_size, 0
* =	dblnext "Double Buffer Routines"
.label sprBase = reserve(2)
.label sprPtr = reserve(2)
.label vicBank = reserve(1)
// flipping between banks 1 and 3
.macro switchBank() {
	//copyMem(sprp1, sprp2, 8)
	lda $dd00
	eor #2
	sta $dd00
	sta vicBank
}

.macro initDblBuf() {
	mov #2 : vicBank
	mov16 #sprp1 : sprPtr
	mov16 #bmb1 : sprBase
	//copyMem(bmb1, bmb2, $1f40)
	//copyMem(smb1, smb2, $3f8)
}
/*
.macro copyShifted() {
	// first, the bitmap
	// then, the matrix
}

.macro prepareNextBuffer() {
	copyShifted()
	decodeColumn()
}

showBank3:
	// copy the sprite pointers
	
*/

*=* "Program Code"
