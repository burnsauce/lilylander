.segment Code "Raster ISRs"

.label exec_count = reserve(1, 0)
.label frame_count = reserve(1, 2)
.label screen_half = reserve(1, 0)

.enum { SCR_TOP, SCR_BOT }

.pseudocommand setScreenHalf half {
	lda half
	sta screen_half
}
.enum {
	TOP_ISR = 15,
	BOT_ISR = 240
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

.macro initRasters() {
	mov16 #isrMUX : $fffe
	setNextISR(topISR, TOP_ISR)
	// enable raster interrupt
	lda #1
	sta $d01a
}

.label mode_flags = reserve(1,0)
.label sprites_loaded = reserve(1,0)
.label xhi_cache = reserve(1, 0)
.label schedrp = reserve(0)
.label next_sprite = reserve(1, 0)
.label d011_cache = reserve(1, 0)

* = * "isrMUX"
isrMUX:
	pha; txa; pha; tya; pha
	jmp (nextISR)

* = * "auxISR"
auxISR:	asl $d019
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
auxdone:	pla;tay;pla;tax;pla;rti

* = * "topISR"
topISR:
	setScreenHalf #SCR_TOP
	setNextISR(auxISR, 20)
	mov #0 : next_sprite
	sta schedrp
	// gfx mode
	lda #(1 << 6) ^ $ff
	and $d011
	ora #(1 << 5)
	sta $d011
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

* = * "botISR"
botISR:
	setScreenHalf #SCR_BOT
	setNextISR(topISR, TOP_ISR)
	//switch to text mode
	lda #(1 << 5) ^ $ff
	and $d011
	ora #(1 << 6)
	sta $d011

	//advance music player

	cli
	jmp frameupdate

frameupdate:
	inc exec_count
	lda exec_count
	cmp #$02
	bcc !+
	jmp skip
!:	frameISR()
skip:	dec exec_count
	pla; tay; pla; tax; pla; rti

.label isrt = reserve(0)
