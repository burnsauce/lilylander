.var nextVar = $2
.var savedVar = 0

.const machine_irq = $fffe


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
	 
.macro setVector(vector, target) {
	lda #<target
	sta vector
	lda #>target
	sta vector + 1
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
