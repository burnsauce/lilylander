.segment Code "Raster ISRs"

// low-level raster ISR code
//	- split screen effects (bgcolor, mode, bank)
//	- music / sound
.label exec_count = reserve(1, 0)
.label frame_count = reserve(1, 0)
.const FRAME_MAX = 3

.enum {
	TOP_ISR = 13,
	BOT_ISR = 238,
	FRM_ISR = 250
}
.enum {
	SPR_ISR = 1,
	BGC_ISR = 2
}

.label nextISR = reserve(0)

.macro setNextISR(isr, line) {
	asl $d019
	mov16 #isr : nextISR
	mov #line : $d012
}

isrMUX:
	pha; txa; pha; tya; pha
	jmp (nextISR)


.macro initRasters() {
	mov16 #isrMUX : $fffe
	mov16 #frameISR : nextISR
	// set the raster interrupt line
	lda #FRM_ISR
	sta $d012
	// enable raster interrupt
	lda #1
	sta $d01a
	asl $d019
}

.label mode_flags = reserve(1,0)
.label sprites_loaded = reserve(1,0)
.label xhi_cache = reserve(1, 0)
.label schedrp = reserve(0)
.label next_sprite = reserve(1, 0)
.label d011_cache = reserve(1, 0)
.label bank_cache = reserve(1, 0)

//	bit 6 - dirty(1) clean(0)
//	bit 5 - bank 1(0) bank 2(1)
.macro loadSpriteBatch(nomoreh) {
	mov #0 : sprites_loaded
	mov #0 : xhi_cache
nextsprite:	
	lda schedrp
	cmp spriteSchedCount
	bne !+
	jmp nomoreh
!:	asl
	tay
	lda spriteschedule + 1,y
	ora xhi_cache
	sta xhi_cache
	lda spriteschedule,y
	tay // actor id
	ldx next_sprite
	// copy xy position buffers
	mov curxy,y : $d000,x
	mov curxy+2,y : $d001,x
	mov locations,y : sprp2,x
	mov locations,y : sprp1,x
	loadSpriteColor locations,y : next_sprite
posdone:	inc next_sprite
	lda #$7
	and next_sprite
	sta next_sprite
	inc schedrp
	lda schedrp
	cmp spriteSchedCount
	bne chkfull
	mov xhi_cache : $d010
	jmp nomoreh
chkfull:	inc sprites_loaded
	lda sprites_loaded
	cmp #8
	bne nextsprite
	mov xhi_cache : $d010
}
auxISR:	.break
	loadSpriteBatch(nomore)
	lda schedrp
	asl
	tay
	lda spriteschedule,y
	tay
	lda ypos,y
	sta $d012
	jmp auxdone
nomore:	setNextISR(botISR, BOT_ISR)
auxdone:	cli
	jmp frameupdate
 
topISR:
	setNextISR(auxISR, 20)
	mov #0 : next_sprite
	//setup gamescreen display
	lda #(1 << 6) ^ $ff
	and $d011
	ora #(1 << 5)
	sta d011_cache 
	lda #$80 // dirty
	sta mode_flags
	
	lda frame_ready
	bne !+
	jmp frameupdate

!:	
	lda #$20
	ora mode_flags
	sta mode_flags
	dec frame_ready
	mov #0 : schedrp
	loadSpriteBatch(tnomore)
	ldy schedrp
	lda spriteschedule,y
	tax
	lda ypos,x
	sta $d012
	jmp tdone
tnomore:	setNextISR(botISR, BOT_ISR)
tdone:	cli
	jmp frameupdate

botISR:
	setNextISR(frameISR, FRM_ISR)
	lda #$80 // dirty
	sta mode_flags
	//switch to text mode
	lda #(1 << 5) ^ $ff
	and $d011
	ora #(1 << 6)
	sta d011_cache 

	//advance music player

	cli
	jmp frameupdate

frameupdate:
	inc exec_count
	lda exec_count
	cmp #$02
	bcc !+
	jmp skip
!:
	
	lda mode_flags
	bmi modechange
	jmp skip
modechange: lda d011_cache
	sta $d011
	lda d016_cache
	sta $d016
	bvc d011done
	switchBank()
	doSwitchBank()
d011done:
	lda #0
	sta mode_flags
skip:	dec exec_count
	pla; tay; pla; tax; pla; rti

.label isrt = reserve(0)
