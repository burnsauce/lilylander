.segment Data

*=* "Multiply table (0-24 * 40)"
mul40_table:
	.for(var x=0; x<25; x++) {
		.word x * 40
	}

*=* "Multiply table (0-24 * 320)"
mul320_table:	
	.for(var x=0; x<25; x++) {
		.word x * 320
	}

.macro mla40(val, tar) {
	tya
	pha
	lda val
	asl
	tay
	lda mul40_table,y
	clc
	adc tar
	sta tar
	bcc !+
	lda #0
	adc tar + 1
	sta tar + 1
!:	iny
	lda mul40_table,y
	clc
	adc tar + 1
	sta tar + 1
done:	pla
	tay
}


.macro mla320(val, tar) {
	tya
	pha
	lda val
	asl
	tay
	lda mul320_table,y
	clc
	adc tar
	sta tar
	bcc !+
	lda #0
	adc tar + 1
	sta tar + 1
!:	iny
	lda mul320_table,y
	clc
	adc tar + 1
	sta tar + 1
done:	pla
	tay
}
