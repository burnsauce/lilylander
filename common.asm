.segment Code
.var nextVar = $2
.var savedVar = 0

.const machine_irq = $fffe

.function _16bitNext(arg) {
    .if (arg.getType()==AT_IMMEDIATE) 
        .return CmdArgument(arg.getType(),>arg.getValue())
    .return CmdArgument(arg.getType(),arg.getValue()+1)
}

.pseudocommand mov src:tar {
	lda src
	sta tar
}

.pseudocommand mov16 src:tar {
	lda src
	sta tar
	lda _16bitNext(src)
	sta _16bitNext(tar)
}

.pseudocommand add16 a:b:tar {
	clc
	lda a
	adc b
	sta tar
	lda _16bitNext(a)
	adc _16bitNext(b)
	sta _16bitNext(tar)
}

.pseudocommand inc16 a {
	inc a
	bne !+
	inc _16bitNext(a)
!:
}

.pseudocommand dec16 a {
	lda a
	bne !+
	dec _16bitNext(a)
!:	dec a
}

.pseudocommand cmp16 a : b {
	lda a
	cmp b
	bne !+
	lda _16bitNext(a)
	cmp _16bitNext(b)
!:
}

.function reserve(bytes) {
	.var ret = nextVar
		.if (nextVar == $100) {
		.error "Too many zeropage variables"
	}
	.if ((bytes == 1) && (savedVar != 0)) {
		.eval ret = savedVar
		.eval savedVar = 0
	} else {
		.eval nextVar = nextVar + bytes
	}
	.return ret
}

.function reserve() {
	.if (mod(nextVar, 2) != 0) {
		.eval savedVar = nextVar
		.eval nextVar = nextVar + 1
	}
	.var ret = nextVar
	.eval nextVar = nextVar + 2
	.return ret
}
	 
.macro setInterrupt(vector) {
	lda #<vector
	sta machine_irq
	lda #>vector
	sta machine_irq + 1
}
	
.macro startISR() {
	pha; txa; pha; tya; pha
}

.macro finishISR() {
	pla; tay; pla; tax; pla; rti
}
/*
.label mcrptr = reserve()
.label mcwptr = reserve()
.label mcompr = reserve()
.pseudocommand memcpy from : to : size {
	mov16 from : mcrptr
	mov16 to : mcwptr
	mov16 from : mcompr
	add16 mcompr : size : mcompr
	ldy #0
!:	lda (mcrptr), y
	sta (mcwptr), y
	inc16 mcrptr
	inc16 mcwptr
	cmp16 mcrptr : mcompr
	bne !-
}
*/
.macro fastMemCopy(from, to, size) {
	pha
	tya
	pha
	ldy #0
	.var pages = floor(size / $100)
	.if(pages > 0) {
page:	.for(var i = 0; i < pages; i++) {
	lda from + (i * $100), y
	sta to + (i * $100), y
	} // for
	iny
	beq !+
	jmp page
	} // if
	.var rem = size - (pages * $100)
!:
	.if(rem > 0) {
	lda from + (pages * $100), y
	sta to + (pages * $100), y
	iny
	cpy #rem
	bne !-
	}
	pla
	tay
	pla
}
