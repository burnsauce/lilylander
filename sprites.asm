.var frog1 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $01,$00,$00,$15,$00,$00,$55,$00
.byte  $00,$66,$00,$01,$55,$00,$01,$99
.byte  $00,$05,$55,$00,$07,$65,$00,$07
.byte  $55,$00,$07,$d5,$00,$07,$f7,$82

.var frog2 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$05,$00,$00
.byte  $15,$00,$00,$5d,$40,$00,$99,$50
.byte  $00,$55,$50,$00,$55,$50,$00,$55
.byte  $70,$00,$57,$c0,$00,$57,$c0,$00
.byte  $5f,$40,$00,$7d,$00,$00,$75,$00
.byte  $00,$75,$00,$00,$f4,$00,$00,$82

.var frog3 = mod(*, $4000) / 64
.byte  $00,$0d,$ff,$00,$0f,$7f,$00,$5f
.byte  $77,$01,$5f,$f7,$05,$77,$f6,$05
.byte  $e5,$55,$15,$e9,$55,$17,$fa,$aa
.byte  $57,$ff,$ff,$57,$ff,$7f,$55,$fd
.byte  $ff,$57,$7f,$ff,$55,$df,$ff,$95
.byte  $77,$ff,$15,$dd,$dd,$25,$77,$77
.byte  $05,$5d,$dd,$09,$57,$77,$02,$55
.byte  $dd,$00,$a5,$56,$00,$0a,$a8,$8f

.var frog4 = mod(*, $4000) / 64
.byte  $d7,$00,$00,$d7,$f0,$00,$f5,$ff
.byte  $00,$b5,$ff,$c0,$ad,$7f,$f0,$ad
.byte  $7f,$f0,$6b,$5f,$fc,$aa,$bf,$fc
.byte  $ff,$ff,$fd,$7f,$df,$fd,$7f,$f5
.byte  $fd,$df,$ff,$fd,$d7,$ff,$f5,$69
.byte  $ff,$d4,$62,$77,$74,$60,$9d,$d0
.byte  $60,$25,$40,$60,$0a,$80,$80,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$8f

.var frogj1 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $01,$00,$00,$01,$00,$00,$05,$00
.byte  $00,$15,$00,$00,$55,$00,$00,$55
.byte  $00,$01,$55,$00,$01,$57,$00,$05
.byte  $ff,$00,$07,$ff,$00,$1f,$fc,$ff

.var frogj2 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$50,$00
.byte  $01,$d4,$15,$95,$95,$55,$55,$55
.byte  $59,$55,$55,$95,$55,$57,$59,$55
.byte  $7c,$55,$5f,$f0,$55,$5f,$c0,$55
.byte  $5f,$40,$55,$7d,$00,$f5,$70,$00
.byte  $fd,$d0,$00,$f7,$50,$00,$ff,$40
.byte  $00,$f0,$00,$00,$00,$00,$00,$82

.var frogj3 = mod(*, $4000) / 64
.byte  $00,$1f,$d0,$00,$7f,$40,$01,$fd
.byte  $00,$01,$f4,$00,$07,$d0,$00,$1d
.byte  $00,$00,$1c,$00,$00,$7c,$00,$00
.byte  $70,$00,$00,$70,$00,$00,$40,$00
.byte  $00,$40,$00,$00,$40,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$ff

.var frogs1 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$1d
.byte  $00,$00,$15,$00,$05,$f5,$05,$57
.byte  $f7,$57,$ff,$d5,$7f,$df,$5d,$70
.byte  $00,$7f,$40,$05,$7f,$40,$17,$ff
.byte  $01,$5f,$fd,$15,$ff,$fc,$5f,$ff
.byte  $00,$7f,$f0,$00,$c0,$00,$00,$ff

.var frogs2 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$50,$00
.byte  $01,$d4,$15,$95,$95,$55,$55,$55
.byte  $59,$55,$55,$95,$55,$5f,$59,$55
.byte  $5c,$55,$57,$d0,$55,$5f,$40,$55
.byte  $5d,$00,$55,$7d,$00,$f5,$7c,$00
.byte  $fd,$70,$00,$f7,$70,$00,$3c,$30
.byte  $00,$00,$30,$00,$00,$30,$00,$82

.var frogf1 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$50,$00,$00
.byte  $54,$00,$00,$7d,$40,$00,$4f,$50
.byte  $00,$43,$d4,$00,$00,$fd,$40,$00
.byte  $0f,$d5,$40,$00,$f5,$55,$00,$35
.byte  $55,$55,$55,$7f,$d5,$55,$40,$ff
.byte  $55,$40,$0f,$f5,$00,$00,$f5,$ff

.var frogf2 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$40
.byte  $00,$00,$50,$00,$00,$54,$00,$00
.byte  $95,$00,$00,$55,$00,$00,$65,$40
.byte  $00,$95,$50,$00,$55,$94,$00,$82

.var frogf3 = mod(*, $4000) / 64
.byte  $00,$00,$3d,$00,$00,$0f,$00,$00
.byte  $03,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$ff

.var frogf4 = mod(*, $4000) / 64
.byte  $56,$54,$50,$55,$55,$d0,$d5,$55
.byte  $94,$d5,$95,$55,$f5,$55,$55,$3d
.byte  $55,$55,$3f,$d5,$7f,$0f,$dd,$7c
.byte  $0f,$f7,$fc,$03,$f7,$fc,$00,$f5
.byte  $f4,$00,$01,$05,$00,$01,$00,$00
.byte  $01,$40,$00,$00,$40,$00,$00,$40
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$82

.var lily1 = mod(*, $4000) / 64
.byte  $00,$00,$ff,$00,$07,$ff,$00,$5f
.byte  $ff,$01,$5d,$5f,$05,$7f,$f7,$05
.byte  $ff,$55,$15,$fd,$fd,$17,$f7,$fd
.byte  $57,$ff,$f7,$57,$ff,$5f,$55,$fd
.byte  $ff,$57,$7f,$ff,$55,$df,$ff,$95
.byte  $77,$ff,$15,$dd,$dd,$25,$77,$77
.byte  $05,$5d,$dd,$09,$57,$77,$02,$55
.byte  $dd,$00,$a5,$56,$00,$0a,$a8,$8f

.var lily2 = mod(*, $4000) / 64
.byte  $ff,$00,$00,$ff,$f0,$00,$ff,$ff
.byte  $00,$ff,$ff,$c0,$d5,$ff,$f0,$7f
.byte  $5f,$f0,$5f,$ff,$fc,$75,$ff,$fc
.byte  $7f,$7f,$fd,$7f,$5f,$fd,$7f,$f7
.byte  $fd,$df,$ff,$fd,$d7,$ff,$f5,$69
.byte  $ff,$d4,$62,$77,$74,$60,$9d,$d0
.byte  $60,$25,$40,$60,$0a,$80,$80,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$8f

.var frogl1 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$01,$00,$00,$15,$00,$00,$55
.byte  $00,$00,$66,$00,$01,$55,$00,$01
.byte  $99,$00,$05,$55,$00,$07,$65,$82

.var frogl2 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$05,$00
.byte  $00,$15,$00,$00,$5d,$40,$00,$99
.byte  $50,$00,$55,$50,$00,$55,$50,$00
.byte  $55,$70,$00,$57,$c0,$00,$57,$c0
.byte  $00,$5f,$40,$00,$7d,$00,$00,$82

.var frogl3 = mod(*, $4000) / 64
.byte  $00,$07,$55,$00,$07,$d5,$02,$07
.byte  $f7,$00,$1d,$ff,$20,$6f,$7f,$01
.byte  $6f,$77,$05,$ef,$f7,$25,$e7,$f6
.byte  $25,$e5,$55,$25,$e9,$55,$25,$fa
.byte  $aa,$25,$fe,$aa,$25,$7d,$7d,$25
.byte  $5f,$ff,$25,$57,$dd,$29,$55,$77
.byte  $09,$55,$dd,$02,$55,$77,$20,$95
.byte  $dd,$08,$29,$56,$00,$02,$a8,$8f

.var frogl4 = mod(*, $4000) / 64
.byte  $75,$00,$00,$75,$00,$00,$f4,$02
.byte  $00,$d7,$f0,$00,$d7,$fc,$20,$f5
.byte  $fd,$08,$b5,$ff,$40,$ad,$7f,$c0
.byte  $ad,$6f,$d2,$6b,$5b,$d0,$aa,$ab
.byte  $d0,$fe,$af,$d0,$7d,$ff,$50,$7f
.byte  $5f,$50,$df,$fd,$50,$57,$f7,$50
.byte  $69,$5d,$52,$62,$55,$40,$60,$95
.byte  $08,$80,$00,$20,$00,$00,$00,$8f

.var lilys11 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$01
.byte  $40,$00,$05,$d0,$00,$17,$f0,$00
.byte  $1f,$f0,$00,$5f,$fc,$02,$7f,$74
.byte  $22,$75,$f7,$22,$7f,$fd,$22,$7f
.byte  $f5,$02,$5d,$75,$02,$9f,$ff,$22
.byte  $97,$75,$20,$97,$ff,$00,$a5,$7f
.byte  $08,$29,$57,$02,$0a,$55,$00,$82
.byte  $a5,$00,$20,$01,$00,$00,$00,$8f

.var lilys12 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$01,$40
.byte  $00,$05,$50,$00,$1f,$d0,$80,$1f
.byte  $f4,$00,$3f,$f5,$20,$7f,$fd,$00
.byte  $df,$fd,$00,$7f,$fd,$20,$ff,$f5
.byte  $20,$5f,$f5,$00,$7f,$d4,$00,$7f
.byte  $54,$20,$fd,$50,$80,$d5,$52,$00
.byte  $56,$a0,$00,$5a,$82,$00,$50,$08
.byte  $00,$40,$00,$00,$00,$00,$00,$8f

.var lilys21 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$08,$00,$00,$20
.byte  $40,$00,$81,$51,$02,$05,$75,$00
.byte  $25,$fd,$00,$97,$d7,$00,$97,$75
.byte  $00,$97,$ff,$00,$97,$d5,$80,$97
.byte  $5d,$08,$97,$55,$08,$a7,$fd,$08
.byte  $29,$f5,$82,$09,$7d,$00,$89,$5d
.byte  $20,$89,$75,$08,$0a,$55,$02,$02
.byte  $95,$00,$80,$94,$00,$00,$00,$8f

.var lilys22 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$40,$00
.byte  $00,$52,$02,$00,$d0,$80,$80,$74
.byte  $80,$00,$f4,$20,$20,$75,$00,$00
.byte  $75,$00,$00,$75,$20,$00,$75,$00
.byte  $20,$75,$00,$00,$f5,$00,$00,$f6
.byte  $20,$20,$56,$00,$80,$d8,$00,$00
.byte  $58,$80,$00,$a0,$82,$00,$82,$08
.byte  $00,$08,$00,$00,$00,$00,$00,$8f

.var lilys31 = mod(*, $4000) / 64
.byte  $80,$20,$00,$00,$80,$00,$02,$02
.byte  $80,$00,$08,$00,$00,$00,$52,$08
.byte  $01,$50,$00,$09,$74,$00,$09,$75
.byte  $80,$09,$f5,$80,$09,$65,$00,$09
.byte  $75,$00,$09,$f5,$00,$09,$55,$00
.byte  $02,$56,$20,$02,$56,$08,$02,$58
.byte  $00,$00,$90,$00,$80,$20,$20,$20
.byte  $02,$08,$00,$02,$02,$00,$00,$8f

.var lilys32 = mod(*, $4000) / 64
.byte  $0c,$03,$00,$03,$00,$c0,$00,$00
.byte  $00,$00,$30,$0c,$00,$0c,$00,$c0
.byte  $00,$03,$cc,$c0,$00,$0c,$00,$00
.byte  $00,$c3,$03,$00,$00,$00,$00,$03
.byte  $00,$00,$00,$00,$00,$00,$03,$00
.byte  $03,$00,$0c,$03,$00,$00,$03,$03
.byte  $c3,$00,$00,$0c,$00,$30,$00,$0c
.byte  $c0,$00,$0c,$00,$00,$30,$00,$0f

.var lilys41 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$c0,$00,$03,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$0c,$00,$00,$30,$00
.byte  $00,$30,$0c,$00,$00,$3c,$00,$00
.byte  $03,$00,$00,$0c,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$c0,$00,$00,$30
.byte  $00,$00,$00,$00,$00,$00,$00,$0f

.var lilys42 = mod(*, $4000) / 64
.byte  $00,$00,$00,$03,$00,$00,$00,$00
.byte  $00,$00,$30,$00,$00,$0c,$00,$00
.byte  $00,$00,$0c,$00,$00,$03,$00,$00
.byte  $00,$03,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$03,$00,$00,$00
.byte  $00,$00,$0c,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$0c
.byte  $00,$00,$0c,$00,$00,$30,$00,$0f

.var frogdie11 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$50,$00
.byte  $01,$50,$00,$01,$d0,$00,$50,$34
.byte  $01,$50,$34,$01,$d4,$34,$00,$34
.byte  $34,$00,$34,$0d,$00,$35,$0d,$00
.byte  $3f,$4d,$00,$03,$4d,$00,$03,$43
.byte  $00,$03,$43,$00,$00,$d0,$00,$00
.byte  $d5,$00,$00,$15,$00,$00,$05,$ff

.var frogdie12 = mod(*, $4000) / 64
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$00,$00,$00
.byte  $00,$00,$00,$00,$00,$c0,$00,$00
.byte  $c0,$00,$00,$c0,$00,$00,$c0,$00
.byte  $00,$f0,$00,$00,$f0,$00,$00,$05

.var frogdie13 = mod(*, $4000) / 64
.byte $00,$00,$1f,$00,$80,$7f,$08,$20
.byte $7f,$00,$20,$7f,$02,$00,$7f,$00
.byte $88,$7f,$00,$02,$bf,$00,$22,$af
.byte $00,$08,$0b,$00,$00,$a2,$00,$08
.byte $28,$00,$00,$08,$00,$00,$a0,$00
.byte $00,$2a,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$8f

.var frogdie14 = mod(*, $4000) / 64
.byte $f0,$08,$00,$f0,$20,$00,$fc,$22
.byte $00,$fc,$00,$00,$fc,$88,$00,$fc
.byte $80,$00,$fe,$20,$00,$f8,$00,$00
.byte $f8,$80,$00,$aa,$00,$00,$28,$20
.byte $00,$a2,$80,$00,$02,$00,$00,$28
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$8f

.var frogdie21 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $a0,$00,$00,$20,$00,$00,$08,$00
.byte $00,$00,$00,$03,$82,$00,$f3,$8f

.var frogdie22 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$08,$00,$00,$20
.byte $00,$00,$20,$00,$00,$80,$f0,$00
.byte $00,$f0,$02,$08,$70,$02,$20,$8f

.var frogdie23 = mod(*, $4000) / 64
.byte $22,$03,$f0,$20,$83,$70,$08,$00
.byte $1c,$00,$00,$1c,$80,$00,$1c,$08
.byte $20,$1c,$00,$02,$27,$00,$00,$0a
.byte $00,$08,$00,$00,$02,$82,$00,$00
.byte $a0,$00,$00,$00,$00,$00,$08,$00
.byte $02,$a0,$00,$0a,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$8f

.var frogdie24 = mod(*, $4000) / 64
.byte $70,$08,$20,$70,$00,$80,$1c,$00
.byte $02,$1c,$00,$20,$1c,$88,$00,$1c
.byte $00,$80,$1e,$00,$00,$28,$20,$00
.byte $00,$a8,$00,$22,$80,$00,$00,$00
.byte $00,$00,$00,$00,$82,$80,$00,$00
.byte $a0,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$8f

.var frogdie31 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$03,$00,$00,$00,$00,$0c
.byte $00,$00,$00,$00,$00,$00,$00,$0f

.var frogdie32 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$30
.byte $00,$00,$00,$00,$00,$00,$30,$0f

.var frogdie33 = mod(*, $4000) / 64
.byte $30,$c0,$c0,$00,$00,$00,$00,$c0
.byte $00,$00,$00,$00,$0c,$00,$00,$00
.byte $00,$00,$30,$00,$0f,$00,$00,$00
.byte $0c,$00,$00,$30,$c0,$00,$00,$00
.byte $00,$00,$00,$cc,$0c,$00,$00,$00
.byte $00,$00,$00,$0c,$00,$00,$f0,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$0f

.var frogdie34 = mod(*, $4000) / 64
.byte $f3,$00,$00,$00,$0c,$03,$00,$00
.byte $c0,$00,$00,$00,$00,$00,$30,$00
.byte $00,$00,$0c,$00,$00,$00,$00,$0c
.byte $00,$00,$30,$00,$03,$00,$00,$00
.byte $00,$0c,$00,$00,$00,$0c,$00,$00
.byte $30,$00,$00,$00,$00,$00,$c0,$00
.byte $c0,$3c,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$0f

.var lilyunf1 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$15,$50,$00,$1f,$d4
.byte $00,$1d,$d4,$00,$17,$74,$00,$17
.byte $74,$00,$05,$d4,$00,$01,$54,$00
.byte $00,$10,$00,$00,$10,$00,$00,$10
.byte $00,$00,$90,$00,$00,$a0,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$8f

.var lilyunf21 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$01,$50,$00,$15
.byte $54,$00,$15,$fd,$00,$5f,$dd,$00
.byte $57,$77,$00,$5d,$7f,$01,$7f,$7f
.byte $01,$7d,$5f,$01,$77,$77,$01,$5f
.byte $7f,$02,$57,$dd,$02,$55,$dd,$02
.byte $55,$75,$00,$55,$55,$00,$95,$54
.byte $00,$29,$64,$00,$02,$84,$00,$00
.byte $08,$00,$00,$00,$00,$00,$00,$8f

.var lilyunf22 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$c0,$00,$00,$c0
.byte $00,$00,$f0,$00,$00,$f0,$00,$00
.byte $f0,$00,$00,$f0,$00,$00,$f0,$00
.byte $00,$c0,$00,$00,$c0,$00,$00,$c0
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$05

.var lilyunf31 = mod(*, $4000) / 64
.byte $00,$55,$55,$01,$5d,$ff,$05,$77
.byte $ff,$15,$7d,$ff,$15,$df,$7d,$17
.byte $7d,$57,$15,$f7,$d5,$17,$df,$d7
.byte $17,$ff,$77,$15,$fd,$f7,$15,$77
.byte $f7,$15,$ff,$fd,$15,$5f,$fd,$25
.byte $77,$75,$09,$5d,$dd,$01,$57,$75
.byte $02,$55,$55,$00,$a5,$41,$00,$0a
.byte $82,$00,$00,$00,$00,$00,$00,$8f

.var lilyunf32 = mod(*, $4000) / 64
.byte $50,$00,$00,$d4,$00,$00,$f5,$00
.byte $00,$75,$00,$00,$dd,$40,$00,$fd
.byte $50,$00,$fd,$50,$00,$5d,$50,$00
.byte $f5,$50,$00,$fd,$50,$00,$75,$50
.byte $00,$d5,$40,$00,$55,$00,$00,$15
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$ff


.label sprsize = 48 * 64
canvas:
.var canvasdbl = canvas + $8000
.var canvas1 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00

.var canvas2 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00

.var canvas3 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00

.var canvas4 = mod(*, $4000) / 64
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00

