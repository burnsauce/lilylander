.pseudocommand unrollMemCopy from:to:size:codeAddr {
	mov16 from : unrAddr
	mov16 to : unwAddr
	mov16 codeAddr : uncAddr
	mov16 size : unSize

// header?
	ldy #0
// copy code
copyloop:	
	lda #LDA_ABS
	sta (uncAddr),y		// lda
	inc16 uncAddr

	lda unrAddr
	sta (uncAddr),y		// lobyte
	inc16 uncAddr
	
	lda unrAddr + 1
	sta (uncAddr),y		// hibyte ;
	inc16 uncAddr
	inc16 unrAddr

	lda #STA_ABS
	sta (uncAddr),y		// sta
	inc16 uncAddr

	lda unwAddr
	sta (uncAddr),y		// lobyte
	inc16 uncAddr

	lda unwAddr + 1
	sta (uncAddr),y		// hi byte ;
	inc16 uncAddr
	inc16 unwAddr
	
	dec16 unSize
	cmp16 unSize : #0
	bne copyloop

	// footer
	
	lda #RTS
	sta (uncAddr),y		// rts
	//inc16 uncAddr
}
