.segment Code 
#import "raster.asm"

.label framet = reserve(0)
.label d016_cache = reserve(1,0)
.label d016_cachec = reserve(1,0)
//.label interp = reserve(1,0)
.label copy_request = reserve(1,0)
.macro initFrame() {
initFrame:

	// clear raster hi bit
	// turn off the display
	// half V scroll
	lda #%00110111
	sta $d011


	// multicolor
	// 40 col
	// full H scroll
	lda #%00010111
	sta $d016

	// bits 4-7 are for matrix offset
	// bits 1-3 are for bitmap
	lda #%00001000
	sta $d018

	rleUnpackImage(bmb1, smb1, $d800)
}

.macro frameISR() {
frameISR:
	lda frame_count
	cmp #02
	bne !+
	jmp ffinal
!:	lda screen_half
	cmp #SCR_BOT
	bne !+
	jmp bframe
!:	// top of frame
	// interpolate actor positions
interp:	lda frame_count
	cmp #0
	beq frame0
	jmp frame1
frame0:
.for(var i = 0; i < ACTORS; i++) {
	sub16 newxy + i : oldxy + i : framet
	lsr framet
	add16 oldxy + i : framet : curxy + i
	sec
	lda newxy + 2 + i
	sbc oldxy + 2 + i
	lsr
	clc
	adc oldxy + 2 + i
	sta curxy + 2 + i
}
	jmp ffinal
frame1:
.for(var i=0; i<ACTORS; i++) {
	mov16 newxy + i : curxy + i
	mov newxy + i : curxy + i
}
	jmp ffinal

bframe:	jsr scheduleActors
	// handle scrolling
	.break
	lda #$80
	and scrolling
	bne !+
	jmp fdone
!:	
	lda scrolling
	and #$7f
	sec
	sbc #1
	ora #$80
	sta scrolling
	and #$7f
	bne !+
	//sta scrolling
	//jmp fdone
	lda #$fe
	sta scrolling
!:	dec xscroll
	lda #$f
	and xscroll
	sta xscroll
	lda #$f8
	and $d016
	sta $d016 
	lda xscroll
	lsr
	ora $d016
	sta $d016
	lda xscroll
!:	cmp #$f
	beq flast
	jmp fdone
flast:	inc frame_count
	mov #11 : copy_request
	switchBank()
	doSwitchBank()
	jsr doColorRamCopy
	jmp ffinal
fdone:	inc frame_count
ffinal:
}
