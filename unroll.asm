.segment UnrolledCode [start=$4000, virtual]
.label docopy = *
.segment Code [start=$1000, outPrg="unrolltest.prg", modify="BasicUpstart", _start=init]

#import "common.asm"

.label unrAddr = reserve()
.label unwAddr = reserve()
.label uncAddr = reserve()
.label unSize = reserve()

init:	.break
	unrollMemCopy #$8000:#$9000:$1000:#docopy:#return
	.break
	jmp docopy
return: inc $d020
	jmp return
	


.pseudocommand unrollMemCopy from:to:size:codeAddr:jmpAddr {
	mov16 from : unrAddr
	mov16 to : unwAddr
	mov16 codeAddr : uncAddr
	mov16 size : unSize

// header?

// copy code
copyloop:	
	lda #LDA_ABS
	sta uncAddr		// lda
	inc16 uncAddr

	lda unrAddr
	sta uncAddr		// lobyte
	inc16 unrAddr
	inc16 uncAddr

	lda unrAddr
	sta uncAddr		// hibyte ;
	inc16 unrAddr
	inc16 uncAddr

	lda #STA_ABS
	sta uncAddr		// sta
	inc16 uncAddr

	lda unwAddr
	sta uncAddr		// lobyte
	inc16 unwAddr
	inc16 uncAddr

	lda unwAddr
	sta uncAddr		// lobyte
	inc16 unwAddr
	inc16 uncAddr
	
	dec16 unSize
	bne loop

	// footer
	
	lda #JMP_ABS
	sta uncAddr
	inc16 uncAddr

	lda jmpAddr
	sta uncAddr
	inc16 uncAddr

	lda _16bitNext(jmpAddr)
	sta uncAddr
	//inc16 uncAddr
}
