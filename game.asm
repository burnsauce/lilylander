.label lily1offset = reserve(1,319-150)
.label frogoffset = reserve(1,60)
.label frogpos = reserve(1,0)

.label cfreq = reserve(2,0)
#import "sin.asm"
.pseudocommand getfrogpos tar {
	lda $d002
	sta tar
	lda $d010
	and #2
	beq !+
	lda #1
	sta _16bitNext(tar)
	jmp !++
!:	lda #0
	sta _16bitNext(tar)
!:
}
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

.label powerdir = reserve(1,0)
.macro updatePower() {
	lda powerdir
	bne down
	inc powerLevel
	inc powerLevel
	bne powdone
	inc powerdir
down:	dec powerLevel
	dec powerLevel
	bne powdone
	dec powerdir
powdone:	
}

.macro resetPower() {
	lda #0
	sta powerLevel
}

.macro initLily() {
	loadSprite(lily1, 4)
	moveSprite(4, 0, 216)
	loadSprite(lily2, 5)
	moveSprite(5, 0, 216)
}

.macro initFrog() {
	.const startx = 35
	.const starty = 196
	loadSprite(frog1, 0)
	loadSprite(frog2, 1)
	loadSprite(frog3, 2)
	loadSprite(frog4, 3)
	moveSprite(0, startx, starty)
	moveSprite(1, startx + 24, starty)
	moveSprite(2, startx, starty + 21)
	moveSprite(3, startx + 24, starty + 21)

	loadSprite(lilys11, 6)
	moveSprite(6, startx, starty + 21)
	disableSprite(6)
	loadSprite(lilys12, 7)
	moveSprite(7, startx + 24, starty + 21)
	disableSprite(7)
	enableSprite(4)
	enableSprite(5)
	
	setSpriteMC(5, 13)
}

.segment Data "Level Data"
leveldata:
.for(var i=0; i<64;i++) {
	.word (i + 1) * $28
}

.segment Code
.label lily1ramp = reserve(2,0)			
.label frogramp = reserve(2,0)

.macro scrollsprite(num) {
chklo:	lda $d000 + num * 2
	beq chkhi
!:	dec $d000 + num * 2
	jmp scrldone
chkhi:	lda #(1 << num)
	and $d010
	beq scrldone
	lda #$ff ^ (1 << num)
	and $d010
	sta $d010
	jmp !-
scrldone:
}

.macro moveLilies() {
	lda scrollamt
	bne !+
	jmp movelily
!:	scrollsprite(0)
	scrollsprite(1)
	scrollsprite(2)
	scrollsprite(3)
	scrollsprite(6)
	scrollsprite(7)
	dec scrollamt
	// update lily1 (target lily)
movelily:	ldy level
	iny
	tya
	asl
	tay
	add16 leveldata,y : lily1ramp : lily1ramp
!:	sin lily1ramp + 1 : lilypos
	clc
	adc #128
	lsr
	sta lilypos
	lda level
	lda scrollamt 
	beq done
	dec lily1offset
	dec scrollamt
done:	lda lilypos	
	clc
	adc lily1offset
	bcc noover
	// overflow already
	sbc #24
	jmp foundhi
noover:	// no overflow yet
	sbc #23
	clc
foundhi:	sta $d008
	//sta $d00C
	bcc !+
	lda #%00010000
	ora $d010
	jmp !++
!:	lda #%11101111
	and $d010
!:	sta $d010
	lda lilypos
	clc
	adc lily1offset
	sta $d00A
	//sta $d00E
	bcc !+
	lda #%00100000
	ora $d010
	jmp !++
!:	lda #%11011111
	and $d010
!:	sta $d010
}
