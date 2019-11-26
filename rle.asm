.macro rleReset(resetV, readV, runCount, runByte) {
	mov #0 : runCount
	mov16 #resetV : readV
}

.macro rleNextByte(resetV, readV, runCount, runByte) {
	txa
	pha
	lda runCount
	beq !+
	dec runCount
	jmp done
!:	ldx #0
	lda (readV, x)
	sta runByte
	inc16 readV
	lda (readV, x)
	cmp runByte
	beq !+
	jmp done
!:	inc16 readV
	lda (readV, x)
	beq reset
	sta runCount
	inc16 readV
	dec runCount
	jmp done
reset:  mov16 #resetV : readV
	mov #0 : runCount
	jmp !--
done:	pla
	tax

}

.segment Code "rleUnpackImage"
rleUnpackImage:
	rleUnpackImage(bmb1, smb1, $d800)
	rts

.macro rleUnpackImage(bmbase, mbase, rbase) {
	lda bgcolor
	sta $d021
	ldy #0
	sty rrunByte
	sty rrunCount
	sty brunByte
	sty brunCount
	sty mrunByte
	sty mrunCount
	sty row
	
	// load read vectors
	mov16 #bitmap : breadV
	mov16 #matrix : mreadV
	mov16 #colorram : rreadV

	// prepare bitmap decode
	mov16 #bmbase : wrV2
	mov16 wrV2 : wrV
	lda #40
	sta column
	ldy #0
	ldx #13
block:	rleNextByte(bitmap, breadV, brunCount, brunByte)
	lda brunByte
	sta (wrV),y
	iny
	cpy #8
	bne block
	add16 wrV : #320 : wrV
	ldy #0
	dex
	beq !+
	jmp block
!:	ldx #13
	add16 wrV2 : #8 : wrV2
	mov16 wrV2 : wrV
	dec column
	beq !+
	jmp block
!:
	// prepare matrix decode
	mov16 #mbase : wrV2
	lda #40
	sta column
	ldy #0
	ldx #13
	mov16 wrV2 : wrV
col2:	rleNextByte(matrix, mreadV, mrunCount, mrunByte)
	lda mrunByte
	sta (wrV),y
	add16 wrV : #40 : wrV
	dex
	beq !+
	jmp col2
!:	ldx #13
	inc16 wrV2
	mov16 wrV2 : wrV
	dec column
	beq !+
	jmp col2

	// prepare color ram decode
!:	mov16 #rbase : wrV2
	mov16 wrV2 : wrV
	lda #40
	sta column
	ldy #0
	ldx #13
col3:	rleNextByte(colorram, rreadV, rrunCount, rrunByte)
	lda rrunByte
	sta (wrV),y
	add16 wrV : #40 : wrV
	dex
	beq !+
	jmp col3
!:	ldx #13
	inc16 wrV2
	mov16 wrV2 : wrV
	dec column
	beq !+
	jmp col3
!:
}
