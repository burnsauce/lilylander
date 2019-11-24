.segment Data "Sin() table"
sin_table:
.for(var i=0; i<256; i++) {
	.var sv = 128 * sin(toRadians((i / 255) * 360))
	.byte min(max(-127, round(sv)), 127)
}

.pseudocommand sin a : tar {
	ldy a
	lda sin_table,y
	sta tar
}
