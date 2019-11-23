.const SIDbase = $d400
.const SIDwidth = 7

.macro SIDvol(vol) {
SIDvol:
	lda #vol
	sta SIDbase + $18
}

.macro SIDfreq(chan, freq) {
SIDfreq:
	lda #<freq
	sta SIDbase + (SIDwidth * (chan - 1))
	lda #>freq
	sta SIDbase + (SIDwidth * (chan - 1)) + 1
}

.macro SIDfreqd(chan, freqr) {
SIDfreqd:
	lda freqr
	sta SIDbase + (SIDwidth * (chan - 1))
	lda freqr + 1
	sta SIDbase + (SIDwidth * (chan - 1)) + 1
}

.macro SIDpw(chan, pw) {
SIDpw:
	lda #<pw
	sta SIDbase + (SIDwidth * (chan - 1)) + 2
	lda #(>pw >> 4)
	sta SIDbase + (SIDwidth * (chan - 1)) + 3
}

.macro SIDadsr(chan, a, d, s, r) {
SIDadsr:
	lda #((a << 4) | d)
	sta SIDbase + (SIDwidth * (chan - 1)) + 5
	lda #((s << 4) | r)
	sta SIDbase + (SIDwidth * (chan - 1)) + 6
}

.macro SIDgate(chan, gate) {
SIDgate:
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
SIDsync:
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
SIDring:
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
SIDtri:
	lda #$0f
	and SIDctrl + (chan - 1)
	ora #$10
	sta SIDctrl + (chan - 1)
	sta SIDbase + (SIDwidth * (chan - 1)) + 4
}

.macro SIDsaw(chan) {
SIDsaw:
	lda #$0f
	and SIDctrl + (chan - 1)
	ora #$20
	sta SIDctrl + (chan - 1)
	sta SIDbase + (SIDwidth * (chan - 1)) + 4
}

.macro SIDpulse(chan) {
SIDpulse:
	lda #$0f
	and SIDctrl + (chan - 1)
	ora #$40
	sta SIDctrl + (chan - 1)
	sta SIDbase + (SIDwidth * (chan - 1)) + 4
}

.macro SIDnoise(chan) {
SIDnoise:
	lda #$0f
	and SIDctrl + (chan - 1)
	ora #$80
	sta SIDctrl + (chan - 1)
	sta SIDbase + (SIDwidth * (chan - 1)) + 4
}
