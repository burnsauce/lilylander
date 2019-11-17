.segment Code "Double-buffering Code"
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
/*
.segment Data "Bitmap Column 1 LUT"
bm1col1addr:
	.for(var row=0; row<25; row++) {
		.word bmb1 + row * 40 * 8 + 8
	}

bm2col1addr:
	.for(var row=0; row<25; row++) {
		.word bmb2 + row * 40 * 8 + 8
	}
sm1col1addr:
	.for(var row=0; row<25; row++) {
		.word smb1 + row * 40 + 1
	}
sm2col1addr:
	.for(var row=0; row<25; row++) {
		.word smb2 + row * 40 + 1
	}
rmcol1addr:
	.for(var row=0; row<25; row++) {
		.word $d800 + row * 40 + 1
	}
rmbcol1addr:
	.for(var row=0; row<25; row++) {
		.word rmb + row * 40 + 1
	}
	

.pseudocommand loadFromTable t : i : p {
	pha
	txa
	pha
	lda i
	asl
	tax
	lda t,x
	sta p
	inx
	lda t,x
	sta _16bitNext(p)
	pla
	tax
	pla
}
*/
.segment Code

.label dblr = reserve()
.label dblw = reserve()
copyDblBitmap:
	//loadFromTable #bm1col1addr : dblarg : dblr
	
	mov16 #bmb1 + 8 : dblr
	mov16 #bmb2 : dblw
	ldy #0
	ldx #25
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
	rts

copyDblMatrix:
	// matrix
	mov16 #smb1 + 1 : dblr
	mov16 #smb2 : dblw
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

