
.segment CopyCode

copyColorRam:
.break
.for(var i=0; i<1000; i++) {
	lda.abs rmb + i
	sta.abs $d800 + i
}
	rts
