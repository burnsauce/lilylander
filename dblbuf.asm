.segment Code 
.label vicBank = reserve(1)

.macro switchBank() {
	lda $dd00
	eor #2
	sta $dd00
	and #2
	sta vicBank
}


.macro initDblBuf() {
	mov #2 : vicBank
}

.macro copyDblBuf() {
	memcpy #bmb1 : #bmb2 : #$1f40
	memcpy #smb1 : #smb2 : #$3f8
	memcpy #$d800 : #rmb : #$3f8
	memcpy #sprbank1 : #sprbank2 : #sprdata_size
}

.label dblr = reserve()
.label dblw = reserve()
.label dblt = reserve(1)

.macro copyDblBitmap() {
	ldy #0
	ldx #25
	mov #39 : dblt
	lda vicBank
	bne !+
	mov16 #bmb2 + 8 : dblr
	mov16 #bmb1 : dblw
	mov16 #bmb1 + 39 * 8 : wrV
	jmp block
!:	mov16 #bmb1 + 8 : dblr
	mov16 #bmb2 : dblw
	mov16 #bmb2 + 39 * 8 : wrV

	// copy columns 1-40
block:	lda (dblr),y
	sta (dblw),y
	iny
	cpy #8
	bne block
	ldy #0
	add16 dblr : #8 : dblr
	add16 dblw : #8 : dblw
	dec dblt
	bne block
	mov #39 : dblt
	add16 dblr : #8 : dblr
	add16 dblw : #8 : dblw
	dex
	bne block

	// Decode RLE Column
	ldy #0 
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
	ldy #0
	ldx #25
	lda vicBank
	bne !+
	mov16 #smb2 + 1 : dblr
	mov16 #smb1 : dblw
	mov16 #smb1 + 39 : wrV
	jmp !++
!:	mov16 #smb1 + 1 : dblr
	mov16 #smb2 : dblw
	mov16 #smb2 + 39 : wrV

	// Copy columns 1-40
!:	lda (dblr),y
	sta (dblw),y
	iny
	cpy #39
	bne !-
	ldy #0
	add16 dblr : #40 : dblr
	add16 dblw : #40 : dblw
	dex
	bne !-

	// Decode RLE Column
	ldy #0
	ldx #25
!:	rleNextByte(matrix, mreadV, mrunCount, mrunByte)
	lda mrunByte
	sta (wrV),y
	add16 wrV : #40 : wrV
	dex
	bne !- 
}

.macro copyDblRam() {
	mov16 #$d800 + 1 : dblr
	mov16 #rmb : dblw
	ldy #0
	ldx #25
!:	lda (dblr),y
	sta (dblw),y
	iny
	cpy #39
	bne !-
	ldy #0
	add16 dblr : #40 : dblr
	add16 dblw : #40 : dblw
	dex
	bne !-

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
}

.label dblw2 = reserve()
.label dblr2 = reserve()
.macro copyDblToRam() {
	mov16 #$d800 : dblw2
	mov16 #rmb : dblr2
	ldy #0
	ldx #25
!:	lda (dblr2),y
	sta (dblw2),y
	iny
	cpy #40
	bne !-
	ldy #0
	add16 dblr2 : #40 : dblr2
	add16 dblw2 : #40 : dblw2
	dex
	bne !-
}

