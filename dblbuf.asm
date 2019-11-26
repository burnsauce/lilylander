.segment Code 

.macro switchBank() {
	lda vicBank
	eor #2
	sta vicBank
}
.macro doSwitchBank() {
	lda $dd00
	eor #2
	sta $dd00
}

.macro copySprites() {
	fastMemCopy(sprbank1, sprbank2, sprsize)
}

.macro resetToStart() {
	rleReset(bitmap, breadV, brunCount, brunByte)	
	rleReset(matrix, mreadV, mrunCount, mrunByte)	
	rleReset(colorram, rreadV, rrunCount, rrunByte)	
}

copyDblBitmap:
	lda vicBank
	beq !+
	jmp bother
!:	//fastMemCopy(bmb2 + 8, bmb1, $1f40 - 8)
	fastMemCopy(bmb2 + 8, bmb1, $fa0 - 8)
	mov16 #(bmb1 + (39 * 8)) : wrV
	jmp bdecrle
bother:  	//fastMemCopy(bmb1 + 8, bmb2, $1f40 - 8)
  	fastMemCopy(bmb1 + 8, bmb2, $fa0 - 8)
	mov16 #(bmb2 + (39 * 8)) : wrV

	// Decode RLE Column
bdecrle:	ldy #0 
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
	rts

copyDblMatrix:
	lda vicBank
	beq !+
	jmp mother
!:	mov16 #smb1 + 39 : wrV
	//fastMemCopy(smb2 + 1, smb1, $3e8 - 1)
	fastMemCopy(smb2 + 1, smb1, $1f4 - 1)
	jmp mdecrle
mother:	mov16 #smb2 + 39 : wrV
	//fastMemCopy(smb1 + 1, smb2, $3e8 - 1)
	fastMemCopy(smb1 + 1, smb2, $1f4 - 1)

	// Decode RLE Column
mdecrle:	ldy #0
	ldx #25
!:	rleNextByte(matrix, mreadV, mrunCount, mrunByte)
	lda mrunByte
	sta (wrV),y
	add16 wrV : #40 : wrV
	dex
	bne !- 
	rts
//}

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
	fastMemCopy($d800 + 1, rmb, $1f4 - 1)
	//jsr doBufferRamCopy
	jsr unpackRamColumn
}
