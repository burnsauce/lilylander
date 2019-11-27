.segment Code 
.const spren    = $d015
.const sprmc    = $d01c
.const sprcolor = $d027
.const sprmc1   = $d025
.const sprmc2   = $d026
.const sprxhi   = $d010
.const sprxpos  = $d000
.const sprypos  = $d001
.var   sprbase  = $4000

.macro setSpriteMC(mc1, mc2) {
	lda #mc1
	sta sprmc1
	lda #mc2
	sta sprmc2
}
.label lsarg = reserve(1, 0)

.macro loadSprite(location, num) {
	lda #location
	ldy #num
	sta sprp1, y
	sta sprp2, y
	.eval location = (((location + 1) * 64) - 1) + sprbase
	lda location
	sta lsarg
	and #$80	 // multicolor
	beq !+
	lda #(1 << num) 
	ora sprmc
	sta sprmc
!:	lda lsarg
	and #$0F // color
	sta sprcolor + num
	enableSprite(num)
}
        
.macro enableSprite(num){
	lda #(1 << num)
	ora spren
	sta spren
}
        
.macro disableSprite(num) {
	lda #((1 << num) ^ $ff)
	and spren
	sta spren
}

.macro enableSprites() {
	lda #$ff
	sta spren
}

.macro disableSprites() {
	lda #$00
	sta spren
}

.macro moveSprite(num, x, y) {
	.if (x > 255) {
	// load the hi bit	
		lda #(1 << num)
		ora sprxhi
		sta sprxhi
	} else {
		lda #((1 << num) ^ $ff)
		and sprxhi
		sta sprxhi
	}
	lda #<x
	sta sprxpos + (num * 2)
	lda #y
	sta sprypos + (num * 2)
}

.macro pushFrogRight(amt) {
	lda scrollamt
	beq !+
	dec $d000
	dec scrollamt
!:	lda $d000
	clc
	adc amt
foundhi:	sta $d000
	sta $d004
	bcc pfr1
	lda #((1 << 0) | (1 << 2))
	ora sprxhi
	sta sprxhi
pfr1:	lda $d002
	adc amt
foundhi1:	sta $d002
	sta $d006
	bcc pfr2
	lda #((1 << 1) | (1 << 3))
	ora sprxhi
	sta sprxhi
pfr2:   
}

.macro pushFrogUp(amt) {
	lda $d001
	sec
	sbc #amt
	sta $d001
	sta $d003
	lda $d005
	sec
	sbc #amt
	sta $d005
	sta $d007
}

.macro pushFrogDown(amt) {
	lda $d001
	clc
	adc #amt
	sta $d001
	sta $d003
	lda $d005
	clc
	adc #amt
	sta $d005
	sta $d007
}
