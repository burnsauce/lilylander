.pseudocommand unrollMemCopy from:to:size:codeAddr {
	mov16 from : tmp0
	mov16 to : tmp1
	mov16 codeAddr : lily1ramp
	mov16 size : score

// header?
	ldy #0
// copy code
copyloop:	
	lda #LDA_ABS
	sta (lily1ramp),y		// lda
	inc16 lily1ramp

	lda tmp0
	sta (lily1ramp),y		// lobyte
	inc16 lily1ramp
	
	lda tmp0 + 1
	sta (lily1ramp),y		// hibyte ;
	inc16 lily1ramp
	inc16 tmp0

	lda #STA_ABS
	sta (lily1ramp),y		// sta
	inc16 lily1ramp

	lda tmp1
	sta (lily1ramp),y		// lobyte
	inc16 lily1ramp

	lda tmp1 + 1
	sta (lily1ramp),y		// hi byte ;
	inc16 lily1ramp
	inc16 tmp1
	
	dec16 score
	cmp16 score : #0
	bne copyloop

	// footer
	
	lda #RTS
	sta (lily1ramp),y		// rts
	//inc16 lily1ramp
}
