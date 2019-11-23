.segment Data

*=* "Multiply table (0-5 * 320)"
mul320_table:	
x320_0:	.word 0 * 320
x320_1:	.word 1 * 320
x320_2:	.word 2 * 320
x320_3:	.word 3 * 320
x320_4:	.word 4 * 320
x320_5:	.word 5 * 320

.pseudocommand mla320 val : tar {
mla320:
	tya
	pha
	lda val
	asl
	tay
	lda mul320_table,y
	clc
	adc tar
	sta tar
	iny
	lda mul320_table,y
	adc tar + 1
	sta tar + 1
	pla
	tay
}
