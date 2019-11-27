.segment QSinTable	[startAfter="Zeropage", max=$00ff] "QSin Table"
qsin:
.fill 64, 0
.segment InitCode "Quarter-Sin() table"
sin_table:
.for(var i=0; i<256/4; i++) {
	.var sv = 128 * sin(toRadians((i / 255) * 360))
	.byte min(max(-127, round(sv)), 127)
}

.macro initQSin() {
	ldy #63
!:	lda sin_table,y
	sta qsin,y
	dey
	bpl !-
}

.label sint = reserve(1,0)
.pseudocommand sin a : tar {
	lda a
	and #$c0
	bne !+
	jmp q1
!:	cmp #$40
	bne !+
	jmp q2
!:	cmp #$80
	bne q4
	jmp q3
q4:	// q4: table backward, negated
	lda a
	and #$3f
	sta sint
	sec
	lda #63
	sec
	sbc sint
	tax
	lda qsin,x
	eor #$ff
	clc
	adc #1
	jmp done
	// q1: table forward
q1:	ldx a
	lda qsin,x
	jmp done
q2:	// q2: table backward
!:	lda a
	and #$3f
	sta sint
	lda #63
	sec
	sbc sint
	tax
	lda qsin,x
	jmp done
q3:	// q3: table forward, negated
	lda a
	and #$3f
	tax
	lda qsin,x
	eor #$ff
	clc
	adc #1
done:	sta tar
}
