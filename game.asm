.const LILY_OFFSET = 319-150
.label lily1offset = reserve(1,0)

#import "sin.asm"

.segment Data "SFX Data"

.const powerlen = 4 
.const snddiv = 4 

sfx_jump:
.byte $10,$f1,$00
.for(var i=0; i<32; i++) {
	.byte $a8 + i 
	.byte $11
}
.byte $00

sfx_splash:
.byte $1a,$00,$00
.for(var i=0; i<32; i++) {
	.byte $ff - i 
	.byte $81
}
.byte $00

sfx_land:
.byte $1a,$00,$22
.for(var i=0; i<16; i++) {
	.byte mod(i * 12, 48) + $a0 
	.byte $21
	.byte mod(i * 12, 48) + $a0 
	.byte $21
}
.byte $00

v3bak: .fill 7,0
.macro restoreV3() {
.for(var i=0; i<7; i++) {
	lda v3bak + i
	sta $e5 + V3FREQ - V1FREQ + i
}

}
.macro copyGhostRegs() {
	lda keyheld 
	bne !+
	jmp normal
!:
.for(var i=0; i<7; i++) {
	lda $e5 + V3FREQ - V1FREQ + i
	sta v3bak + i
}
	lda powerLevel
	lsr
	lsr
	sta tmp0+1
	lda #0
	sta tmp0
	add16 tmp0 : #$0a00 : tmp0
	mov #$11 : $e5 + (V3CTRL - V1FREQ)
	mov16 tmp0 : $e5 + (V3FREQ - V1FREQ)
	mov16 #$F010 : $e5 + (V3AD - V1FREQ)
	// copy all ghostregs
normal:	ldx #$18
copy:	lda $e5,x
	sta $d400,x
	dex
	bpl copy
	jmp done
done:
}
.label powerramp = reserve(1,0)

.macro landsound() {
	lda #<sfx_land
	ldy #>sfx_land
	ldx #14
	jsr $5406
}

.macro splashsound() {
	lda #<sfx_splash
	ldy #>sfx_splash
	ldx #14
	jsr $5406
}

.macro jmpsound() {
	lda #<sfx_jump
	ldy #>sfx_jump
	ldx #14
	jsr $5406
}

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
powdone:	//powersound()
}

.macro initLily() {
	loadSprite(lily1, 4)
	moveSprite(4, 0, 216)
	loadSprite(lily2, 5)
	moveSprite(5, 0, 216)
	loadSprite(lilys11, 6)
	moveSprite(6, startx, starty + 21)
	disableSprite(6)
	loadSprite(lilys12, 7)
	moveSprite(7, startx + 24, starty + 21)
	disableSprite(7)
	mov #LILY_OFFSET : lily1offset
	lda #0
	sta SPRYEX
	sta SPRXEX
}

.macro initFrog() {
	loadSprite(frog1, 0)
	loadSprite(frog2, 1)
	loadSprite(frog3, 2)
	loadSprite(frog4, 3)
	moveSprite(0, startx, starty)
	moveSprite(1, startx + 24, starty)
	moveSprite(2, startx, starty + 21)
	moveSprite(3, startx + 24, starty + 21)
	
	setSpriteMC(5, 13)
}

.segment Data2 "Level Data"
leveldata:
.for(var i=0; i<64;i++) {
	.word (log(i/64 * 8.75 + 1.25) * MAX_SPEED)
}

.segment Code
.label lily1ramp = reserve(2,0)			
.label frogramp = reserve(2,0)

.macro scrollsprite(num) {
chklo:	lda $d000 + num * 2
	beq chkhi
!:	dec $d000 + num * 2
	beq chkhi
	dec $d000 + num * 2
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
	lda #$7f
	and scrolling + 1
	bne movelily
	lda scrolling
	cmp #30
	bmi movelily
	dec lily1offset 
	dec lily1offset 
	// update lily1 (target lily)
movelily:	lda level
	asl
	tay
	add16 leveldata,y : lily1ramp : lily1ramp
	mov #0 : tmp0 + 1
	mov lily1ramp + 1 : tmp0
	lda lily1ramp
	bpl !+
	inc tmp0
!:	sin tmp0 : lilypos
	clc
	adc #128
	lsr
	sta lilypos
	lda scrollamt
	beq done
!:	dec scrollamt
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
