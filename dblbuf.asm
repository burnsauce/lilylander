.segment Code 

.macro switchBank() {
switchBank:
	lda vicBank
	eor #2
	sta vicBank
}
.macro doSwitchBank() {
doSwitchBank:
	lda $dd00
	eor #2
	sta $dd00
}

.macro copySprites() {
copySprites:
	fastMemCopy(sprbank1, sprbank2, sprsize)
}


// bitmap is 8000 bytes = $1f40
// split into jobs
// ~12-14 jobs possible
//
// 7 x $400 = $1c00
// 1 x $340 = $1f40
// rle

.macro copyDblBitmapLastPart() {
	lda vicBank
	beq !+
	jmp other
!:	fastMemCopy($1c00 + bmb2 + 8, $1c00 + bmb1, $340 - 8)
	mov16 #(bmb1 + (39 * 8)) : wrV
	jmp done
other:	fastMemCopy($1c00 + bmb1 + 8, $1c00 + bmb2, $340 - 8)
	mov16 #(bmb2 + (39 * 8)) : wrV
	jmp done
done:
}

.macro decodeBitmapColumn() {
	// Decode RLE Column
decrle:	ldy #0 
	ldx #25
block2:	rleNextByte(bitmap, breadV, brunCount, brunByte)
	lda brunByte
	sta (wrV),y
	iny
	cpy #8
	bne block2
	ldy #0
	add16 wrV : #40 * 8 : wrV
	dex
	bne block2
}


.macro copyDblBitmapPart(part) {
copyDblBitmap:
	lda vicBank
	beq !+
	jmp other
!:	fastMemCopy($400 * part + bmb2 + 8, bmb1, $400 - 8)
	jmp done
other:	fastMemCopy($400 * part + bmb1 + 8, bmb2, $400 - 8)
done:
}
.macro copyDblBitmap() {
copyDblBitmap:
	lda vicBank
	beq !+
	jmp other
!:	fastMemCopy(bmb2 + 8, bmb1, $1f40 - 8)
	mov16 #(bmb1 + (39 * 8)) : wrV
	jmp decrle
other:	fastMemCopy(bmb1 + 8, bmb2, $1f40 - 8)
	mov16 #(bmb2 + (39 * 8)) : wrV

	// Decode RLE Column
decrle:	ldy #0 
	ldx #25
block2:	rleNextByte(bitmap, breadV, brunCount, brunByte)
	lda brunByte
	sta (wrV),y
	iny
	cpy #8
	bne block2
	ldy #0
	add16 wrV : #40 * 8 : wrV
	dex
	bne block2
}

.macro copyDblMatrix() {
copyDblMatrix:
	lda vicBank
	beq !+
	jmp other
!:	mov16 #smb1 + 39 : wrV
	fastMemCopy(smb2 + 1, smb1, $3e8 - 1)
	jmp decrle
other:	mov16 #smb2 + 39 : wrV
	fastMemCopy(smb1 + 1, smb2, $3e8 - 1)

	// Decode RLE Column
decrle:	ldy #0
	ldx #25
!:	rleNextByte(matrix, mreadV, mrunCount, mrunByte)
	lda mrunByte
	sta (wrV),y
	add16 wrV : #40 : wrV
	dex
	bne !- 
}

unpackRamColumn:
	//fastMemCopy($d800 + 1, rmb, $3e8 - 1)
	// Unpack RLE Column
	mov16 #rmb + 39 : wrV
	ldy #0
	ldx #25
!:	rleNextByte(colorram, rreadV, rrunCount, rrunByte)
	lda rrunByte
	sta (wrV),y
	add16 wrV : #40 : wrV
	dex
	bne !-
	rts

.macro copyDblRam() {
copyDblRam:
	fastMemCopy($d801, rmb, 998)
	jsr unpackRamColumn
}
