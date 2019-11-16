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

.pseudocommand ld16 val:tar {
	lda #<val.getValue()
	sta tar
	lda #>val.getValue()
	sta _16bitNext(tar)
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
	
.macro copyInterruptO(vector, offset) {
	lda offset
	asl
	tay
	lda vector, y
	sta machine_irq
	lda vector + 1, y
	sta machine_irq + 1
}

.macro copyInterrupt(vector) {
	lda vector
	sta machine_irq
	lda vector + 1
	sta machine_irq + 1
}

.macro copyPage(from, to) {
	ldx #0
!:	lda from, x
	sta to, x
	inx
	bne !-
}

/*
	$1001, $2000, $fff
	256 - 1 = 255 bytes from first page
*/
.macro copyMem(from, to, size) {
	.print toHexString(*) + ": copying $" + toHexString(size) + " bytes from $" + toHexString(from) + " to $" + toHexString(to)
	.if(size < $100) {
		ldx #0
!:		lda from, x
		sta to, x
		inx
		cpx #size
		bne !-
	} else {
		.var bytes_left = size
		// copy as many pages as possible
		.var page = 0
		.while(bytes_left >= $100) {
			.eval bytes_left -= $100
			copyPage(from + page, to + page)
			.eval page += $100
		}
		// copy the remainder
		.if (bytes_left > 0) {
			ldx #0
!:			lda from + page, x
			sta to + page, x
			inx
			cpx #bytes_left
			bne !-
		}
	}
}


