.label lastscore = reserve(2,0)

.macro paintScore() {
	zeroMem(canvas, 64)
	sub16 score : lastscore : fontp
	bin16bcd24 fontp : bcdbuf
	lda bcdbuf + 1 
	and #$0f
	asl
	asl
	asl
	bne !+
	jmp second
!:	sta fontt
	add16 #hrfont_numerals : fontt : fontp 
	ldy #0
.for(var i=0; i<5; i++) {
	lda (fontp),y
	iny
	sta canvas + i * 3
}
second:
	lda bcdbuf
	and #$f0
	lsr	
	sta fontt
	add16 #hrfont_numerals : fontt : fontp 
	ldy #0
.for(var i=0; i<5; i++) {
	lda (fontp),y
	iny
	sta canvas + 1 + i * 3
}
	lda bcdbuf 
	and #$0f
	asl
	asl
	asl
	sta fontt
	add16 #hrfont_numerals : fontt : fontp 
	ldy #0
.for(var i=0; i<5; i++) {
	lda (fontp),y
	iny
	sta canvas + 2 + i * 3
}
	mov16 score : lastscore
	mov #$07 : canvas + 63
	
	lda #1
	sta $01
	fastMemCopy(canvas, canvasdbl, 64)
	lda #29
	sta $01
}
