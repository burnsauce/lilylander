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
mov:
	lda src
	sta tar
}

.pseudocommand mov16 src:tar {
mov16:
	lda src
	sta tar
	lda _16bitNext(src)
	sta _16bitNext(tar)
}

.pseudocommand add a:b:tar {
	clc
	lda a
	adc b
	sta tar
}

.pseudocommand sub a:b:tar {
	sec
	lda a
	sbc b
	sta tar
}

.pseudocommand add16 a:b:tar {
add16:
	clc
	lda a
	adc b
	sta tar
	lda _16bitNext(a)
	adc _16bitNext(b)
	sta _16bitNext(tar)
}
.pseudocommand sub16 a:b:tar {
sub16:
	sec
	lda a
	sbc b
	sta tar
	lda _16bitNext(a)
	sbc _16bitNext(b)
	sta _16bitNext(tar)
}

.pseudocommand inc16 a {
inc16:
	inc a
	bne !+
	inc _16bitNext(a)
!:
}

.pseudocommand dec16 a {
dec16:
	lda a
	bne !+
	dec _16bitNext(a)
!:	dec a
}

.pseudocommand cmp16 a : b {
cmp16:
	lda a
	cmp b
	bne !+
	lda _16bitNext(a)
	cmp _16bitNext(b)
!:
}

.pseudocommand lerp320 start:end:delta:tar {
lerp:
	sub16 end : start : tar
	mla320 tar : delta
	add16 tar : start : tar
}
	 
.macro setInterrupt(vector) {
setInterrupt:
	lda #<vector
	sta machine_irq
	lda #>vector
	sta machine_irq + 1
}
	
.macro startISR() {
startIsr:
	pha; txa; pha; tya; pha
}

.macro finishISR() {
finishIsr:
	pla; tay; pla; tax; pla; rti
}

.macro fastMemCopy(from, to, size) {
fastMemCopy:
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
