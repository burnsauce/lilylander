.const SIDbase = $d400
.const SIDwidth = 7
.label SIDctrl = reserve(3)

.macro initSID() {
	lda #0
	sta SIDctrl
	sta SIDctrl + 1
	sta SIDctrl + 2
}
.macro SIDvol(vol) {
	lda #vol
	sta SIDbase + $18
}
.macro SIDfreq(chan, freq) {
	lda #<freq
	sta SIDbase + (SIDwidth * (chan - 1))
	lda #>freq
	sta SIDbase + (SIDwidth * (chan - 1)) + 1
}
.macro SIDfreqd(chan, freqr) {
	lda freqr
	sta SIDbase + (SIDwidth * (chan - 1))
	lda freqr + 1
	sta SIDbase + (SIDwidth * (chan - 1)) + 1
}
.macro SIDpw(chan, pw) {
	lda #<pw
	sta SIDbase + (SIDwidth * (chan - 1)) + 2
	lda #(>pw >> 4)
	sta SIDbase + (SIDwidth * (chan - 1)) + 3
}
.macro SIDadsr(chan, a, d, s, r) {
	lda #((a << 4) | d)
	sta SIDbase + (SIDwidth * (chan - 1)) + 5
	lda #((s << 4) | r)
	sta SIDbase + (SIDwidth * (chan - 1)) + 6
}
.macro SIDgate(chan, gate) {
	.if (gate > 0) {
		lda #1 // bit 0
		ora SIDctrl + (chan - 1)
		sta SIDctrl + (chan - 1)
		sta SIDbase + (SIDwidth * (chan - 1)) + 4
	} else {
		lda #$fe
		and SIDctrl + (chan - 1)
		sta SIDctrl + (chan - 1)
		sta SIDbase + (SIDwidth * (chan - 1)) + 4
	} 
}
.macro SIDsync(chan, sync) {
	.if (sync > 0) {
		lda #2 // bit 1
		ora SIDctrl + (chan - 1)
		sta SIDctrl + (chan - 1)
		sta SIDbase + (SIDwidth * (chan - 1)) + 4
	} else {
		lda #$fd
		and SIDctrl + (chan - 1)
		sta SIDctrl + (chan - 1)
		sta SIDbase + (SIDwidth * (chan - 1)) + 4
	}
}
.macro SIDring(chan, ring) {
	.if (ring > 0) {
		lda #4 // bit 1
		ora SIDctrl + (chan - 1)
		sta SIDctrl + (chan - 1)
		sta SIDbase + (SIDwidth * (chan - 1)) + 4
	} else {
		lda #$fb
		and SIDctrl + (chan - 1)
		sta SIDctrl + (chan - 1)
		sta SIDbase + (SIDwidth * (chan - 1)) + 4
	}
}
.macro SIDtri(chan) {
	lda #$0f
	and SIDctrl + (chan - 1)
	ora #$10
	sta SIDctrl + (chan - 1)
	sta SIDbase + (SIDwidth * (chan - 1)) + 4
}
.macro SIDsaw(chan) {
	lda #$0f
	and SIDctrl + (chan - 1)
	ora #$20
	sta SIDctrl + (chan - 1)
	sta SIDbase + (SIDwidth * (chan - 1)) + 4
}
.macro SIDpulse(chan) {
	lda #$0f
	and SIDctrl + (chan - 1)
	ora #$40
	sta SIDctrl + (chan - 1)
	sta SIDbase + (SIDwidth * (chan - 1)) + 4
}
.macro SIDnoise(chan) {
	lda #$0f
	and SIDctrl + (chan - 1)
	ora #$80
	sta SIDctrl + (chan - 1)
	sta SIDbase + (SIDwidth * (chan - 1)) + 4
}
