.const ACTORS = 16
/*
	Field Sort Algorithm
	(mostly) clean slate implementation of
	https://www.linusakesson.net/programming/fieldsort/index.php
*/

.segment FieldData [start=$4d00] "inyfield"
/*
	A sled of iny
	Needs to be located at ADDRHI & 4c = 4c
	due to use of SHY instruction
*/
inyfield:
.for(var i=0; i<220; i++) {
	.byte $c8
}
	jmp sortDone

.segment FieldLink [start=$aa00, virtual] "Sort Ylink"
/*
	A table of which actor is the last to be
	added to a given ypos.
	Needs to be at $aa00
*/
ylink:

.segment Data "Actor Data"
//	A table of the actor that follows the
//	indexed actor
nextactor:
.for(var i=0; i<ACTORS; i++) {
	.byte $c8
}

//	A table of the y position of each actor
ypos:
.for(var i=0; i<ACTORS; i++) {
	.byte i * 4 + 4
}

//	A table of the sprite pointers for each actor
locations:
.for(var i=0; i<ACTORS; i++) {
	.byte blank
}
actorenable:
.for(var i=0; i<ACTORS; i++) {
	.byte 0
}
spriteschedule:
.for(var i=0; i<ACTORS; i++) {
	.byte 0
}


.segment InitCode "Init Link Table"
linktable:
.for(var i=0; i<220; i++) {
	.byte $c8 
}

.segment Code

.label sortBeginSp = reserve(1,0)
.label sortEndSp = reserve(1,0)
.label sortActor = reserve(1,0)
.label sortRaster = reserve(1,0)
.label spriteSchedCount = reserve(1,0)

.macro initSprMux() {
initSprMux:
	fastMemCopy(eb0, emptybucket_0, 21) 
	fastMemCopy(eb1, emptybucket_1, 21) 
	fastMemCopy(eb2, emptybucket_2, 21) 
	fastMemCopy(eb3, emptybucket_3, 21) 
	fastMemCopy(linktable, ylink, 220) 
	lda #$ff
	sta $d015 // enable all sprites
	lda #0
	ldy #0
!:	sta $d000,y
	iny
	cpy #17
	bne !-
	mov #$ff : $d01c
}

.macro scheduleActor(actor) {
	
}
.label sortt = reserve(1,0)

// frame setup
//.macro scheduleActors() {
scheduleActors:
	fillBuckets()
sortActors:	tsx
	stx sortBeginSp
	ldy #0
	jmp inyfield
sortDone:
	lda sortBeginSp
	tsx
	stx sortEndSp
	sec
	sbc sortEndSp // a = begin - end
	tay
	cpy #0
	bne !+
	jmp scheduleDone
!:	clearSpriteSchedule()
schedule:
	lda sortEndSp,y // the actor id
	sta sortActor
dosched:	
	lda spriteSchedCount
	asl
	tax
	mov sortActor : spriteschedule,x
	// need to do more here to prepare
	// precache hi bit according to schedcount
	lda curxy + 1,x
	bne hibithi
	sta spriteschedule + 1,x
	jmp hibitdone
hibithi:	// x is schedule index
	txa
	pha
	lda spriteSchedCount
	and #7
	clc
	adc #1
	tax
	lda #1
hibitloop:	dex
	bne morehi
	sta sortt
	pla
	tax
	mov sortt : spriteschedule + 1, x
	jmp hibitdone
morehi:	asl
	jmp hibitloop
hibitdone:	
	inc spriteSchedCount
	dey
	beq scheduleDone
	jmp schedule
scheduleDone:
	ldx sortBeginSp
	txs
	rts
//}

.macro fillBuckets() {
fillBuckets:
.for(var i=0; i<ACTORS; i++) {
	lda actorenable + i
	beq !+
	fillBucket(i)
	!:
}
}

.macro fillBucket(i) {
	ldx #JMP_ABS
		    // for some actor id [i]
	ldy ypos+i	    // get its y position as index
	shx inyfield,y  // store JMP in field
	lda ylink,y	    // get the existing actor id
	sta nextactor+i // store in this actor's next
	lda #i	    // load this actor id
	sta ylink,y	    // store as first actor
}

.macro clearSpriteSchedule() {
	mov #0 : spriteSchedCount
}

// game code
.macro showActor(id) {
showActor:
	inc actorenable + id
}

.macro clearActors() {
	lda #0
.for(var i=0; i<ACTORS; i++) {
	sta actorenable + i
}
}

.macro placeActors() {
.for(var i=0; i<ACTORS; i++) {
	lda actorenable + i
	beq !+
	ldx #i
	placeActor #i : ypos,x
!:
}
}

.pseudocommand placeActor id : yindex {
placeActor:
	ldy yindex
	ldx id
	lda ylink,y
	sta nextactor,x
	lda #JMP_ABS
	sta inyfield,y
}

// Emptybucket code
.segment InitCode
eb0:
.pseudopc $4c4c {
emptybucket_0:
        sty endptr_0+1
        lax ylink,y
emit_0:
        pha
        lda nextactor,x
        bpl emit_0-1

        sta inyfield,y
        sta ylink,y

endptr_0: jmp inyfield
}
eb1:
.pseudopc $4cc8 {
emptybucket_1:
        sty endptr_1+1
        lax ylink,y
emit_1:
        pha
        lda nextactor,x
        bpl emit_1-1

        sta inyfield,y
        sta ylink,y

endptr_1: jmp inyfield
}
eb2:
.pseudopc $c84c {
emptybucket_2:
        sty endptr_2+1
        lax ylink,y
emit_2:
        pha
        lda nextactor,x
        bpl emit_2-1

        sta inyfield,y
        sta ylink,y

endptr_2: jmp inyfield
}

eb3:
.pseudopc $c8c8 {
emptybucket_3:
        sty endptr_3+1
        lax ylink,y
emit_3:
        pha
        lda nextactor,x
        bpl emit_3-1

        sta inyfield,y
        sta ylink,y

endptr_3: jmp inyfield
}



