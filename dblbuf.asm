.segment Code "Double-buffering Code"
.label sprPtr = reserve(2)
.label vicBank = reserve(1)

.macro switchBank() {
/*
	ldy #0
	lda vicBank
!:	bne !+
	lda sprp2, y
	sta sprp1, y
	iny
	cpy #8
	bne !-
	mov16 #sprp1 : sprPtr
	jmp !++
!:	lda sprp1, y
	sta sprp2, y
	iny
	cpy #8
	bne !-
	mov16 #sprp2 : sprPtr
!:	
*/
	lda vicBank
	eor #2
	sta vicBank
	lda $dd00
	eor #2
	sta $dd00
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
.label dblr = reserve()
.label dblw = reserve()

copyDblBitmap:
	ldy #0
	ldx #25
	lda vicBank
	bne !+
	mov16 #bmb2 + 8 : dblr
	mov16 #bmb1 : dblw
	mov16 #bmb1 + 39 * 8 : wrV2
	jmp crow
!:	mov16 #bmb1 + 8 : dblr
	mov16 #bmb2 : dblw
	mov16 #bmb2 + 39 * 8: wrV2
crow:	tya
	pha
	ldy #0
block:	lda (dblr),y
	sta (dblw),y
	iny
	cpy #8
	bne block
	pla
	tay
	iny
	add16 dblr : #8 : dblr
	add16 dblw : #8 : dblw
	cpy #39
	bne crow 
	ldy #0
	add16 dblr : #8 : dblr
	add16 dblw : #8 : dblw
	dex
	bne crow

	// prepare bitmap decode
	mov #8 : colbyte
	ldy #0 
	sty row
col:	mov16 wrV2 : wrV
	mla320(row, wrV)
block2:	rleNextByte(bitmap, breadV, brunCount, brunByte)
	lda brunByte
	sta (wrV),y
	inc16 wrV
	dec colbyte
	bne block2
	lda #8
	sta colbyte
	inc row
	lda row
	cmp #25
	beq !+
	jmp col
!:	rts

copyDblMatrix:
	ldy #0
	ldx #25
	lda vicBank
	bne !+
	mov16 #smb2 + 1 : dblr
	mov16 #smb1 : dblw
	mov16 #smb1 + 39 : wrV2
	jmp !++
!:	mov16 #smb1 + 1 : dblr
	mov16 #smb2 : dblw
	mov16 #smb2 + 39 : wrV2
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

	// prepare matrix decode
	ldy #0
	sty row
col2:	mov16 wrV2 : wrV
	mla40(row, wrV)
	rleNextByte(matrix, mreadV, mrunCount, mrunByte)
	lda mrunByte
	sta (wrV),y
	inc row
	lda row
	cmp #25
	beq !+
	jmp col2
!:	rts

copyDblRam:
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
	rts

copyDblToRam:
	mov16 #$d800 : dblw
	mov16 #rmb : dblr
	ldy #0
	ldx #25
!:	lda (dblr),y
	sta (dblw),y
	iny
	cpy #40
	bne !-
	ldy #0
	add16 dblr : #40 : dblr
	add16 dblw : #40 : dblw
	dex
	bne !-
	rts

