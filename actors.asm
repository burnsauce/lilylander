.segment Data "Actor Data"
oldxy:
.fill ACTORS * 3, 0
newxy:
.fill ACTORS * 3, 0
curxy:
.fill ACTORS * 3, 0

.segment Code
.macro loadActor(id, loc, ix, iy) {
	ldy #id
	mov #loc : locations,y
	mov #$ff : ypos,y
	mov16 #ix : oldxy,y
	mov16 #ix : newxy,y
	iny
	iny
	mov #iy : oldxy,y
	sta newxy,y
}

.macro setSpriteMC(mc1, mc2) {
setSpriteMC:
	lda #mc1
	sta $d025
	lda #mc2
	sta $d026
}

.macro alignActor(a, b, dx, dy) {
	ldx #a
	ldy #b
	lda newxy,x
	sta oldxy,y
	inx
	iny
	lda newxy,x
	sta oldxy,y
	inx
	iny
	lda newxy,x
	sta oldxy,y
	.if (dx != 0) {
		ldy #b
		add16 oldxy,y : #dx : oldxy,x
	}
	.if (dy != 0) {
		ldy #b
		lda oldxy + 3,y
		clc
		adc #dy
		sta oldxy + 3,y
	}
}

.pseudocommand moveActor id : dx : dy {
	ldy id
	lda newxy,y
	sta oldxy,y
	clc
	adc dx
	sta newxy,y
	iny
	lda newxy,y
	sta oldxy,y
	adc _16bitNext(dx)
	sta newxy,y
	beq noover
	lda newxy-1,y
	cmp #75
	bmi noover
	lda #0
	sta newxy-1,y
	sta newxy,y
	sta oldxy-1,y
	sta oldxy,y
noover:	iny
	lda newxy,y
	sta oldxy,y
	clc
	adc dy
	sta newxy,y
	sta ypos-2,y
}

.label sprt = reserve(2,0)
.label sprn = reserve(1,0)

.pseudocommand loadSpriteColor location : num {
	mov #0 : sprt
	sta sprt + 1
	mov num : sprn
	lda location
	clc
	ror
	ror sprt
	ror
	ror sprt
	adc #$40
	sta sprt + 1	// *64
	tya
	pha
	ldy #63
	lda (sprt), y
	and #$0F // color
	ldy sprn
	sta $d027,y
	pla
	tay
}

.pseudocommand moveActorAbs id : nx : ny {
	ldy id
	mov16 nx : newxy,y
	mov16 nx : oldxy,y
	mov ny: ypos,y
	iny
	iny
	mov ny: newxy,y
	mov ny: oldxy,y
}

