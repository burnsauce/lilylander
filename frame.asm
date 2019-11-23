.segment Code 
#import "raster.asm"

.label framet = reserve(0)
.label d016_cache = reserve(1,0)
.label d016_cachec = reserve(1,0)
.label interp = reserve(1,0)
.label frame_ready = reserve(1,0)
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

*=* "frameISR"
frameISR:
	setNextISR(topISR, TOP_ISR)
	mov $d016 : d016_cachec
	cli
	lda frame_ready
	beq !+
	jmp fskip
!:
	// handle frame update
	// interpolate sprite movement
	ldy #0
	lda frame_count
	beq frame0
	jmp frame1
frame0:	jsr scheduleActors
frame0l:    sub16 newxy,y : oldxy,y : framet
	lda framet
	lsr framet
	sta framet
	add16 oldxy,y : framet : curxy,y
	iny
	iny
	sec
	lda newxy,y
	sbc oldxy,y
	lsr
	clc
	adc oldxy,y
	sta curxy,y
	iny
	cpy #ACTORS * 3
	beq scroll
	jmp frame0l
frame1:
	mov16 newxy,y : curxy,y
	iny
	iny
	mov newxy,y : curxy,y
	iny
	cpy #ACTORS * 3
	bne frame1

scroll:	// handle scrolling
	lda #80
	bit scrolling
	bne !+
	jmp fdone
!:	
	dec scrolling
	lda scrolling
	and #$7f
	bne !+
	sta scrolling
	jmp fdone
!:	dec xscroll
	lda #$f
	and xscroll
	sta xscroll
	lda #$f8
	and d016_cachec
	sta d016_cachec 
	lda xscroll
	lsr
	ora d016_cachec
	sta d016_cachec
	lda xscroll
	beq !+
	jmp flast
!:	mov d016_cachec : d016_cache
	copyDblMatrix()
	copyDblBitmap()
	copyDblRam()
	jmp fdone
flast:	cmp #$f
	bne fdone
	jsr doColorRamCopy
fdone:	mov d016_cachec : d016_cache
	lda #1
	eor frame_count
	sta frame_count
	inc frame_ready
fskip:	pla; tay; pla; tax; pla; rti

