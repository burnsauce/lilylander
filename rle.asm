.label rreadV = reserve(0)
.label rrunByte = reserve(1,0)
.label rrunCount = reserve(1,0)
.label breadV = reserve(0)
.label brunByte = reserve(1,0)
.label brunCount = reserve(1,0)
.label mreadV = reserve(0)
.label mrunByte = reserve(1,0)
.label mrunCount = reserve(1,0)
.label colbyte = reserve(1,0)
.label wrV = reserve(0)
.label wrV2 = reserve(0)

.macro rleReset(resetV, readV, runCount, runByte) {
	mov #0 : runCount
	mov16 #resetV : readV
}

.macro rleNextByte(resetV, readV, runCount, runByte) {
	lda runCount
	beq !+
	dec runCount
	jmp done
!:	
	lda (readV), y
	sta runByte
	inc16 readV
	lda (readV), y
	cmp runByte
	beq !+
	jmp done
!:	inc16 readV
	lda (readV), y
	beq reset
	sta runCount
	inc16 readV
	dec runCount
	jmp done
reset:	mov16 #resetV : readV
	mov #0 : runCount
	jmp !--
done:	


}
.segment Code2 "rleUnpackImage"
rleUnpackImage:
	rleUnpackImage(bmb1, smb1, $d800, bitmap, matrix, colorram, bgcolor, 13)
	rts

.segment Code2 "rleUnpackTitle"
rleUnpackTitle:
	rleUnpackImage(bmb1, smb1, $d800, t_bitmap, t_matrix, t_colorram, t_bgcolor, 25)
	rts

.macro rleUnpackImage(bmbase, mbase, rbase, bitmapr, matrixr, colorramr, bgcolorr, cols) {
	lda bgcolorr
	sta curbg
	ldy #0
	sty rrunByte
	sty rrunCount
	sty brunByte
	sty brunCount
	sty mrunByte
	sty mrunCount
	
	// load read vectors
	mov16 #bitmapr : breadV
	mov16 #matrixr : mreadV
	mov16 #colorramr : rreadV

	// prepare bitmap decode
	mov16 #bmbase : wrV2
	mov16 wrV2 : wrV
	lda #40
	sta tmp0
	ldy #0
	ldx #cols
block:	tya; pha; ldy #0
	rleNextByte(bitmap, breadV, brunCount, brunByte)
	pla; tay
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
!:	ldx #cols
	add16 wrV2 : #8 : wrV2
	mov16 wrV2 : wrV
	dec tmp0
	beq !+
	jmp block
!:
	// prepare matrix decode
	mov16 #mbase : wrV2
	lda #40
	sta tmp0
	ldy #0
	ldx #cols
	mov16 wrV2 : wrV
col2:	rleNextByte(matrix, mreadV, mrunCount, mrunByte)
	lda mrunByte
	sta (wrV),y
	add16 wrV : #40 : wrV
	dex
	beq !+
	jmp col2
!:	ldx #cols
	inc16 wrV2
	mov16 wrV2 : wrV
	dec tmp0
	beq !+
	jmp col2

	// prepare color ram decode
!:	mov16 #rbase : wrV2
	mov16 wrV2 : wrV
	lda #40
	sta tmp0
	ldy #0
	ldx #cols
col3:	rleNextByte(colorram, rreadV, rrunCount, rrunByte)
	lda rrunByte
	sta (wrV),y
	add16 wrV : #40 : wrV
	dex
	beq !+
	jmp col3
!:	ldx #cols
	inc16 wrV2
	mov16 wrV2 : wrV
	dec tmp0
	beq !+
	jmp col3
!:
}
