.segment Data
#import "bgdata.asm"

.segment Code 
#import "rle.asm"

.label rreadV = reserve()
.label rrunByte = reserve(1)
.label rrunCount = reserve(1)
.label breadV = reserve()
.label brunByte = reserve(1)
.label brunCount = reserve(1)
.label mreadV = reserve()
.label mrunByte = reserve(1)
.label mrunCount = reserve(1)
.label column = reserve(1)
.label colbyte = reserve(1)
.label row = reserve(1)
.label wrV = reserve()
.label wrV2 = reserve()


.macro initRiver(bmbase, mbase, rbase) {
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
	lda #40
	sta column
	lda #8
	sta colbyte
col:	mov16 wrV2 : wrV
	mla320(row, wrV)
block:	rleNextByte(bitmap, breadV, brunCount, brunByte)
	lda brunByte
	sta (wrV),y
	inc16 wrV
	dec colbyte
	bne block
	lda #8
	sta colbyte
	inc row
	lda row
	cmp #25
	beq !+
	jmp col
!:	sty row
	add16 wrV2 : #8 : wrV2
	dec column
	beq !+
	jmp col
!:
	// prepare matrix decode
	mov16 #mbase : wrV2
	lda #40
	sta column
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
!:	sty row
	inc16 wrV2
	dec column
	beq !+
	jmp col2

	// prepare color ram decode
!:	mov16 #rbase : wrV2
	lda #40
	sta column
	ldy #0
	sty row
col3:	mov16 wrV2 : wrV
	mla40(row, wrV)
	rleNextByte(colorram, rreadV, rrunCount, rrunByte)
	lda rrunByte
	sta (wrV),y
	inc row
	lda row
	cmp #25
	beq !+
	jmp col3
!:	sty row
	inc16 wrV2
	dec column
	beq !+
	jmp col3
!:
}
