#if !SPRITES_LOADED
/*
.var wix1 = mod(*, $4000) / 64
#endif
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$05,$00,$00
.byte  $15,$00,$00,$16,$00,$00,$55,$00
.byte  $01,$55,$00,$05,$55,$00,$05,$95
.byte  $00,$15,$95,$00,$15,$55,$00,$59
.byte  $65,$01,$59,$65,$01,$55,$55,$82 // spr0 wix1
#if !SPRITES_LOADED
.var wix2 = mod(*, $4000) / 64
#endif
.byte  $00,$01,$40,$00,$05,$50,$00,$05
.byte  $50,$00,$17,$50,$00,$1e,$d4,$00
.byte  $5e,$d4,$05,$57,$55,$15,$55,$55
.byte  $55,$55,$55,$55,$55,$55,$55,$55
.byte  $55,$55,$55,$55,$55,$55,$57,$55
.byte  $55,$57,$55,$55,$57,$55,$55,$5f
.byte  $55,$55,$5f,$55,$55,$7f,$55,$55
.byte  $7c,$55,$55,$fc,$55,$55,$f0,$87 // spr1 wix2
#if !SPRITES_LOADED
.var wix3 = mod(*, $4000) /64
#endif
.byte  $06,$95,$55,$16,$95,$55,$66,$a5
.byte  $55,$66,$a5,$55,$66,$a5,$55,$66
.byte  $a9,$55,$66,$a9,$55,$66,$a9,$55
.byte  $69,$ea,$55,$69,$aa,$97,$6a,$6a
.byte  $6a,$6a,$6a,$6a,$6a,$6a,$6a,$6a
.byte  $aa,$6a,$6a,$aa,$6a,$6a,$aa,$6a
.byte  $66,$a9,$00,$e9,$f4,$00,$7a,$5c
.byte  $54,$3e,$ff,$fc,$0f,$ff,$ff,$87 // spr2 wix3
#if !SPRITES_LOADED
.var wix4 = mod(*, $4000) / 64
#endif
.byte  $55,$57,$a0,$55,$5f,$90,$55,$7e
.byte  $50,$55,$fa,$40,$55,$f9,$40,$57
.byte  $e9,$00,$56,$e5,$00,$5e,$a4,$00
.byte  $de,$a4,$00,$9a,$a4,$00,$9a,$a4
.byte  $00,$9a,$ac,$00,$9a,$94,$00,$9a
.byte  $a7,$00,$95,$ad,$00,$05,$a9,$40
.byte  $01,$6b,$50,$00,$5b,$d0,$00,$16
.byte  $f4,$00,$05,$bc,$00,$00,$00,$87 // spr wix4
*/
#if !SPRITES_LOADED
.var frog2 = mod(*, $4000) / 64
#endif
.byte  $00,$00,$50,$00,$01,$50,$00,$05
.byte  $94,$00,$1d,$d5,$01,$55,$55,$05
.byte  $55,$55,$07,$75,$56,$15,$55,$68
.byte  $1d,$d5,$68,$55,$55,$a4,$67,$56
.byte  $90,$65,$56,$50,$69,$56,$50,$6a
.byte  $6a,$40,$9a,$a9,$40,$a6,$a9,$40
.byte  $a6,$6a,$50,$aa,$62,$50,$6a,$40
.byte  $94,$55,$50,$94,$15,$54,$25,$87 // spr4 resting frog
#if !SPRITES_LOADED
.var frogj1 = mod(*, $4000) / 64
#endif
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $01,$00,$00,$01,$00,$00,$05,$00
.byte  $00,$15,$00,$00,$55,$00,$00,$55
.byte  $00,$01,$55,$00,$01,$56,$00,$05
.byte  $aa,$00,$06,$aa,$00,$1a,$a8,$87 // spr5 jump1
#if !SPRITES_LOADED
.var frogj2 = mod(*, $4000) / 64
#endif
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$50,$00
.byte  $01,$94,$15,$d5,$d5,$55,$55,$55
.byte  $5d,$55,$55,$d5,$55,$56,$5d,$55
.byte  $68,$55,$5a,$a0,$55,$5a,$80,$55
.byte  $5a,$40,$55,$69,$00,$a5,$60,$00
.byte  $a9,$90,$00,$a6,$50,$00,$aa,$40
.byte  $00,$a0,$00,$00,$00,$00,$00,$87 // spr6 jump2
#if !SPRITES_LOADED
.var frogj3 = mod(*, $4000) / 64
#endif
.byte  $00,$1a,$90,$00,$6a,$40,$01,$a9
.byte  $00,$01,$a4,$00,$06,$90,$00,$19
.byte  $00,$00,$18,$00,$00,$68,$00,$00
.byte  $60,$00,$00,$60,$00,$00,$40,$00
.byte  $00,$40,$00,$00,$40,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$87 // spr7 jump3
#if !SPRITES_LOADED
.var frogs1 = mod(*, $4000) / 64
#endif
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$19
.byte  $00,$00,$15,$00,$05,$a5,$05,$56
.byte  $a6,$56,$aa,$95,$6a,$9a,$59,$60
.byte  $00,$6a,$40,$05,$6a,$40,$16,$aa
.byte  $01,$5a,$a9,$15,$aa,$a8,$5a,$aa
.byte  $00,$6a,$a0,$00,$80,$00,$00,$87 // spr8 soar1
#if !SPRITES_LOADED
.var frogs2 = mod(*, $4000) / 64
#endif
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$50,$00
.byte  $01,$94,$15,$d5,$d5,$55,$55,$55
.byte  $5d,$55,$55,$d5,$55,$5a,$5d,$55
.byte  $58,$55,$56,$90,$55,$5a,$40,$55
.byte  $59,$00,$55,$69,$00,$a5,$68,$00
.byte  $a9,$60,$00,$a6,$60,$00,$28,$20 
.byte  $00,$00,$20,$00,$00,$20,$00,$87 // spr9 soar2
#if !SPRITES_LOADED
.var frogf1 = mod(*, $4000) / 64
#endif
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$50,$00,$00
.byte  $54,$00,$00,$69,$40,$00,$4a,$50
.byte  $00,$42,$94,$00,$00,$a9,$40,$00
.byte  $0a,$95,$40,$00,$a5,$55,$00,$25
.byte  $55,$55,$55,$6a,$95,$55,$40,$aa
.byte  $55,$40,$0a,$a5,$00,$00,$a5,$87 // spr10 fall1
#if !SPRITES_LOADED
.var frogf2 = mod(*, $4000) / 64
#endif
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$40
.byte  $00,$00,$50,$00,$00,$54,$00,$00
.byte  $d5,$00,$00,$55,$00,$00,$75,$40
.byte  $00,$d5,$50,$00,$55,$d4,$00,$81 // spr11 fall2
#if !SPRITES_LOADED
.var frogf4 = mod(*, $4000) / 64
#endif
.byte  $57,$54,$50,$55,$55,$90,$95,$55
.byte  $d4,$95,$d5,$55,$a5,$55,$55,$29
.byte  $55,$55,$2a,$95,$6a,$0a,$99,$68
.byte  $0a,$a6,$a8,$02,$a6,$a8,$00,$a5
.byte  $a4,$00,$01,$05,$00,$01,$00,$00
.byte  $01,$40,$00,$00,$40,$00,$00,$40
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$87 // spr12 fall4
#if !SPRITES_LOADED
.var lily1 = mod(*, $4000) / 64
#endif
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$05,$50,$01,$55,$55
.byte  $05,$55,$95,$1a,$a9,$95,$56,$a5
.byte  $55,$55,$56,$96,$55,$56,$96,$8d // spr13 lily1
#if !SPRITES_LOADED
.var lily2 = mod(*, $4000) / 64
#endif
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$01,$55,$40,$55
.byte  $55,$40,$59,$55,$50,$55,$69,$50
.byte  $55,$59,$54,$5a,$56,$a4,$9a,$55
.byte  $95,$95,$96,$95,$a9,$65,$55,$8d // spr14 lily2
#if !SPRITES_LOADED
.var lily3 = mod(*, $4000) / 64
#endif
.byte  $55,$55,$59,$55,$55,$69,$16,$a9
.byte  $55,$16,$a9,$55,$15,$69,$55,$05
.byte  $69,$5a,$01,$55,$5a,$00,$55,$5a
.byte  $00,$01,$55,$00,$00,$15,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$8d // spr15 lily3
#if !SPRITES_LOADED
.var lily4 = mod(*, $4000) / 64
#endif
.byte  $95,$55,$54,$95,$a5,$54,$55,$a5
.byte  $50,$55,$55,$50,$55,$55,$50,$59
.byte  $55,$40,$5a,$55,$00,$55,$55,$00
.byte  $15,$50,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$8d // spr16 lily4
#if !SPRITES_LOADED
.var blank = mod(*, $4000) / 64
#endif
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$80 // spr17 blank
#define SPRITES_LOADED
