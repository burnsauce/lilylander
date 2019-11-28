.segment Data "Font Data"
#import "font.asm"
.segment Code 

.pseudocommand ycopy from : to : size {
	ldy size
!:	dey
	bmi !+
	lda.absy from
	sta.absy to
	jmp !-
!:
}
	
.label bestpos = bmb1 + 40 * 8 * 21 + 31 * 8
.label lastpos = 3 + bmb1 + 40 * 8 * 22 + 31 * 8

.label bcdbuf = reserve(3,0)

.pseudocommand bin16bcd24 val : tar {
	sed
	lda #0
	sta tar
	sta _16bitNext(tar)
	sta _24bitNext(tar)
	ldx #16

nextbit:	asl val
	rol _16bitNext(val)
	lda tar
	adc tar
	sta tar
	lda _16bitNext(tar)
	adc _16bitNext(tar)
	sta _16bitNext(tar)
	lda _24bitNext(tar)
	adc _24bitNext(tar) 
	sta _24bitNext(tar) 
	dex
	bne nextbit
	cld
}


.label fontp = reserve(2,0)
.label fontt = reserve(2,0)

.macro writeScore() {
	mov16 bestscore : fontp
	bin16bcd24 fontp : bcdbuf
	// highest num
	lda bcdbuf + 2
	asl
	asl
	asl
	sta fontt
	add16 #font_numerals : fontt : fontp 
	ldy #5
!:	dey
	bmi !+
	lda (fontp),y 
	sta bestpos,y
	jmp !-
!:	// 4th num
	lda bcdbuf + 1
	and #$f0
	lsr	
	add16 #font_numerals : fontt : fontp 
	ldy #5
!:	dey
	bmi !+
	lda (fontp),y 
	sta bestpos + 8,y
	jmp !-
!:	// 3rd num
	lda bcdbuf + 1 
	and #$0f
	asl
	asl
	asl
	sta fontt
	add16 #font_numerals : fontt : fontp 
	ldy #5
!:	dey
	bmi !+
	lda (fontp),y 
	sta bestpos + 16,y
	jmp !-
!:	// 2nd num
	lda bcdbuf
	and #$f0
	lsr	
	add16 #font_numerals : fontt : fontp 
	ldy #5
!:	dey
	bmi !+
	lda (fontp),y 
	sta bestpos + 24,y
	jmp !-
!:	// 1st num
	lda bcdbuf 
	and #$0f
	asl
	asl
	asl
	sta fontt
	add16 #font_numerals : fontt : fontp 
	ldy #5
!:	dey
	bmi !+
	lda (fontp),y 
	sta bestpos + 32,y
	jmp !-
!:
	
	mov16 score : fontp
	bin16bcd24 fontp : bcdbuf
	// highest num
	lda bcdbuf + 2
	asl
	asl
	asl
	sta fontt
	add16 #font_numerals : fontt : fontp 
	ldy #5
!:	dey
	bmi !+
	lda (fontp),y 
	sta lastpos,y
	jmp !-
!:	// 4th num
	lda bcdbuf + 1
	and #$f0
	lsr	
	add16 #font_numerals : fontt : fontp 
	ldy #5
!:	dey
	bmi !+
	lda (fontp),y 
	sta lastpos + 8,y
	jmp !-
!:	// 3rd num
	lda bcdbuf + 1 
	and #$0f
	asl
	asl
	asl
	sta fontt
	add16 #font_numerals : fontt : fontp 
	ldy #5
!:	dey
	bmi !+
	lda (fontp),y 
	sta lastpos + 16,y
	jmp !-
!:	// 2nd num
	lda bcdbuf
	and #$f0
	lsr	
	add16 #font_numerals : fontt : fontp 
	ldy #5
!:	dey
	bmi !+
	lda (fontp),y 
	sta lastpos + 24,y
	jmp !-
!:	// 1st num
	lda bcdbuf 
	and #$0f
	asl
	asl
	asl
	sta fontt
	add16 #font_numerals : fontt : fontp 
	ldy #5
!:	dey
	bmi !+
	lda (fontp),y 
	sta lastpos + 32,y
	jmp !-
!:
}

.macro pokeBestScoreColor(col) {
	mov16 #$d800 + 21 * 40 + 31 : fontp
	ldy col
	lda (fontp),y
	and #$0f
	clc
	adc #1
	sta (fontp),y
}

.macro setScoreColors(col) {
	mov16 #$d800 + 21 * 40 + 31 : fontp
	lda #col
	ldy #5
!:	dey
	bmi !+
	sta (fontp),y
	jmp !-
!:
	mov16 #$d800 + 22 * 40 + 31 : fontp
	lda #col
	ldy #5
!:	dey
	bmi !+
	sta (fontp),y
	jmp !-
!:
}
