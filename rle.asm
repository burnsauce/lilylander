
.macro rleNextByte(resetV, readV, runCount, runByte) {
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
done:

}
