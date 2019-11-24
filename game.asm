.const lilyoffset  = 319 - 256
.label cfreq = reserve(2,0)

.macro jmpsound() {
	lda #$00
	sta cfreq
	lda #$08
	sta cfreq + 1
	SIDvol(10)
	SIDtri(1)
	SIDadsr(1, 1, 7, 15, 2)
	SIDfreqd(1, cfreq)
	SIDgate(1, 1)
}

.macro jmpstop() {
	SIDgate(1, 0)
}

.macro updatePower() {
	inc powerLevel
}

.macro resetPower() {
	lda #0
	sta powerLevel
}

.macro loadLevel(lvl) {
	lda #100
	sta lilypos

	lda #0
	sta $d40f
	lda lvl
	asl
	sta $d40e
	lda #%00010001
	sta $d412
	lda #$0f
	sta $d414
	lda #%10001111
	sta $d418
}
				
.macro initLily() {
	loadSprite(lily1, 4)
	moveSprite(4, 0, 200)
	loadSprite(lily2, 5)
	moveSprite(5, 0, 200)
	loadSprite(lily3, 6)
	moveSprite(6, 0, 200 + 21)
	loadSprite(lily4, 7)
	moveSprite(7, 0, 200 + 21)
}

.macro initFrog() {
	.const startx = 35
	.const starty = 180
	loadSprite(blank, 0)
	loadSprite(blank, 1)
	loadSprite(frog2, 2)
	loadSprite(blank, 3)
	moveSprite(0, startx, starty)
	moveSprite(1, startx + 24, starty)
	moveSprite(2, startx, starty + 21)
	moveSprite(3, startx + 24, starty + 21)
	
	setSpriteMC(5, 2)
}
					
.macro moveLily() {
	lda $d41b	// osc 3
	lsr		// 0-127
	clc
	adc #100
done:	sta lilypos
	clc
	adc #lilyoffset - 24
	sta $d008
	sta $d00C
	bcc !+
	lda #%01010000
	ora $d010
	jmp !++
!:	lda #%10101111
	and $d010
!:	sta $d010
	lda lilypos
	clc
	adc #lilyoffset
	sta $d00A
	sta $d00E
	bcc !+
	lda #%10100000
	ora $d010
	jmp !++
!:	lda #%01011111
	and $d010
!:	sta $d010
}
