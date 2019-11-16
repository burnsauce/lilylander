
* = $6000 "Screen Matrix Buffer 1" virtual
smb1:	.fill $400, 0
* = $A000 "Screen Matrix Buffer 2" virtual
smb2:	.fill $400, 0

* = $E000 "Bitmap Buffer 1" virtual
bmb1:	.fill $1f40, 0
* = $C000 "Bitmap Buffer 2" virtual
bmb2:	.fill $1f40, 0

// flipping between banks 1 and 3

#import "common.asm"

.label mreadVector = reserve()
.label mwriteVector = reserve()



.macro loadNextMatrixColumn(to) {
	// read address (colno,y) = from + y + 25 * colno
	// write address (colno,y) = to + colno + y * 40
	
	mov16 #to + 39 : mwriteVector
	ldy #0
	ldx #0
!:	lda (mreadVector, x)
	sta (mwriteVector), x
	inc16 mreadVector
	add16 mwriteVector : #40 : mwriteVector
	iny
	cpy #25
	bne !-
}
.macro loadMatrix(image, width) {
	mov16 #image : mreadVector
	mov16 #smb1 : mwriteVector
	ldy #0
	ldx #0
	lda #40
	pha
!:	lda (mreadVector, x)
	sta (mwriteVector), y
	inc16 mreadVector
	iny
	cpy #25
	bne !-
	ldy #0
	add16 mwriteVector : #40 : mwriteVector
	pla
	sec
	sbc #1
	bne !-
}	

*=$1000
	loadMatrix($000, 0)
