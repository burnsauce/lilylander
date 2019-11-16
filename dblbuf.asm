.var 	dblnext = *

.label 	smb1 = $4000
* = smb1 "Screen Matrix Buffer 1" virtual
	.fill $3f8, 0
.label sprp1 = *

*=* + 8	"Bank 1 Sprites"
.label sprbank1 = *
#import "sprites.asm"
.label 	smb2 = $c000

* = smb2 "Screen Matrix Buffer 2" virtual
	.fill $3f8, 0
.label sprp2 = *

*=* + 8	"Bank 2 Sprites" virtual
.label sprbank2 = *
	.fill sprdata_size, 0

.label 	bmb1 = $6000
* = bmb1 "Bitmap Buffer 1" virtual
	.fill $1f40, 0


.label 	bmb2 = $e000
*= 	bmb2 "Bitmap Buffer 2" virtual
	.fill $1f40, 0

* = dblnext

.label sprPtr = reserve(2)
.label vicBank = reserve(1)

.macro switchBank() {
	memcpy #sprp1 : #sprp2 : #8
	lda $dd00
	eor #2
	sta $dd00
	and #2
	sta vicBank
}

.macro initDblBuf() {
	mov #2 : vicBank
	mov16 #sprp1 : sprPtr
}

.macro copyDblBuf() {
	memcpy #bmb1 : #bmb2 : #$1f40
	memcpy #smb1 : #smb2 : #$3f8
	memcpy #sprbank1 : #sprbank2 : #sprdata_size
}

*=* "Program Code"
