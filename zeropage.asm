.struct zpVar {addr,size}
.var zpDict = Hashtable()
.function reserve(bytes, initv) {
	.if(zpDict.containsKey(initv) == false) {
		.eval zpDict.put(initv, List())
	}
	.eval zpDict.get(initv).add(zpVar(nextVar, bytes))
	.var ret = nextVar
	.if (nextVar == $100) {
		.error "Too many zeropage variables"
	}
	.eval nextVar = nextVar + bytes
	.return ret
}

.function reserve(initv) {
	.return reserve(2, initv)
}

.macro initZeroPage() {
.for(var i=0; i<zpDict.keys().size(); i++) {
	.var iv = zpDict.keys().get(i)
	.var zpvl = zpDict.get(iv)
	lda #iv.asNumber()
	.for(var j=0; j<zpvl.size(); j++) {
		.var zpv = zpvl.get(j)
		.for(var k=0; k<zpv.size; k++) {
			sta zpv.addr + k
		}
	}
}
}

// RLE
.label rreadV = reserve(0)
.label rrunByte = reserve(1,0)
.label rrunCount = reserve(1,0)
.label breadV = reserve(0)
.label brunByte = reserve(1,0)
.label brunCount = reserve(1,0)
.label mreadV = reserve(0)
.label mrunByte = reserve(1,0)
.label mrunCount = reserve(1,0)
.label column = reserve(1,0)
.label colbyte = reserve(1,0)
.label row = reserve(1,0)
.label wrV = reserve(0)
.label wrV2 = reserve(0)
// DblBuf
.label vicBank = reserve(1,$02)
// Frame
.label frspd = reserve(1,0)
.label frdiv = reserve(1,12)
.label phase = reserve(1,0)
.label jumping = reserve(1,0)
.label keyheld = reserve(1,0)
.label xscroll = reserve(1,$f)
.label scrolling = reserve(0)
// Game
.label powerLevel = reserve(1,0)
.label lilypos = reserve(1,100)
// SID
.label SIDctrl = reserve(3,0)
// Unroll (temp)
.label unrAddr = reserve(0)
.label unwAddr = reserve(0)
.label uncAddr = reserve(0)
.label unSize = reserve(0)


// default labels
.label zp02 = $02
.label zp03 = $03
.label zp04 = $04
.label zp05 = $05
.label zp06 = $06
.label zp07 = $07
.label zp08 = $08
.label zp09 = $09
.label zp0a = $0a
.label zp0b = $0b
.label zp0c = $0c
.label zp0d = $0d
.label zp0e = $0e
.label zp0f = $0f
.label zp10 = $10
.label zp11 = $11
.label zp12 = $12
.label zp13 = $13
.label zp14 = $14
.label zp15 = $15
.label zp16 = $16
.label zp17 = $17
.label zp18 = $18
.label zp19 = $19
.label zp1a = $1a
.label zp1b = $1b
.label zp1c = $1c
.label zp1d = $1d
.label zp1e = $1e
.label zp1f = $1f
.label zp20 = $20
.label zp21 = $21
.label zp22 = $22
.label zp23 = $23
.label zp24 = $24
.label zp25 = $25
.label zp26 = $26
.label zp27 = $27
.label zp28 = $28
.label zp29 = $29
.label zp2a = $2a
.label zp2b = $2b
.label zp2c = $2c
.label zp2d = $2d
.label zp2e = $2e
.label zp2f = $2f
.label zp30 = $30
.label zp31 = $31
.label zp32 = $32
.label zp33 = $33
.label zp34 = $34
.label zp35 = $35
.label zp36 = $36
.label zp37 = $37
.label zp38 = $38
.label zp39 = $39
.label zp3a = $3a
.label zp3b = $3b
.label zp3c = $3c
.label zp3d = $3d
.label zp3e = $3e
.label zp3f = $3f
.label zp40 = $40
.label zp41 = $41
.label zp42 = $42
.label zp43 = $43
.label zp44 = $44
.label zp45 = $45
.label zp46 = $46
.label zp47 = $47
.label zp48 = $48
.label zp49 = $49
.label zp4a = $4a
.label zp4b = $4b
.label zp4c = $4c
.label zp4d = $4d
.label zp4e = $4e
.label zp4f = $4f
.label zp50 = $50
.label zp51 = $51
.label zp52 = $52
.label zp53 = $53
.label zp54 = $54
.label zp55 = $55
.label zp56 = $56
.label zp57 = $57
.label zp58 = $58
.label zp59 = $59
.label zp5a = $5a
.label zp5b = $5b
.label zp5c = $5c
.label zp5d = $5d
.label zp5e = $5e
.label zp5f = $5f
.label zp60 = $60
.label zp61 = $61
.label zp62 = $62
.label zp63 = $63
.label zp64 = $64
.label zp65 = $65
.label zp66 = $66
.label zp67 = $67
.label zp68 = $68
.label zp69 = $69
.label zp6a = $6a
.label zp6b = $6b
.label zp6c = $6c
.label zp6d = $6d
.label zp6e = $6e
.label zp6f = $6f
.label zp70 = $70
.label zp71 = $71
.label zp72 = $72
.label zp73 = $73
.label zp74 = $74
.label zp75 = $75
.label zp76 = $76
.label zp77 = $77
.label zp78 = $78
.label zp79 = $79
.label zp7a = $7a
.label zp7b = $7b
.label zp7c = $7c
.label zp7d = $7d
.label zp7e = $7e
.label zp7f = $7f
.label zp80 = $80
.label zp81 = $81
.label zp82 = $82
.label zp83 = $83
.label zp84 = $84
.label zp85 = $85
.label zp86 = $86
.label zp87 = $87
.label zp88 = $88
.label zp89 = $89
.label zp8a = $8a
.label zp8b = $8b
.label zp8c = $8c
.label zp8d = $8d
.label zp8e = $8e
.label zp8f = $8f
.label zp90 = $90
.label zp91 = $91
.label zp92 = $92
.label zp93 = $93
.label zp94 = $94
.label zp95 = $95
.label zp96 = $96
.label zp97 = $97
.label zp98 = $98
.label zp99 = $99
.label zp9a = $9a
.label zp9b = $9b
.label zp9c = $9c
.label zp9d = $9d
.label zp9e = $9e
.label zp9f = $9f
.label zpa0 = $a0
.label zpa1 = $a1
.label zpa2 = $a2
.label zpa3 = $a3
.label zpa4 = $a4
.label zpa5 = $a5
.label zpa6 = $a6
.label zpa7 = $a7
.label zpa8 = $a8
.label zpa9 = $a9
.label zpaa = $aa
.label zpab = $ab
.label zpac = $ac
.label zpad = $ad
.label zpae = $ae
.label zpaf = $af
.label zpb0 = $b0
.label zpb1 = $b1
.label zpb2 = $b2
.label zpb3 = $b3
.label zpb4 = $b4
.label zpb5 = $b5
.label zpb6 = $b6
.label zpb7 = $b7
.label zpb8 = $b8
.label zpb9 = $b9
.label zpba = $ba
.label zpbb = $bb
.label zpbc = $bc
.label zpbd = $bd
.label zpbe = $be
.label zpbf = $bf
.label zpc0 = $c0
.label zpc1 = $c1
.label zpc2 = $c2
.label zpc3 = $c3
.label zpc4 = $c4
.label zpc5 = $c5
.label zpc6 = $c6
.label zpc7 = $c7
.label zpc8 = $c8
.label zpc9 = $c9
.label zpca = $ca
.label zpcb = $cb
.label zpcc = $cc
.label zpcd = $cd
.label zpce = $ce
.label zpcf = $cf
.label zpd0 = $d0
.label zpd1 = $d1
.label zpd2 = $d2
.label zpd3 = $d3
.label zpd4 = $d4
.label zpd5 = $d5
.label zpd6 = $d6
.label zpd7 = $d7
.label zpd8 = $d8
.label zpd9 = $d9
.label zpda = $da
.label zpdb = $db
.label zpdc = $dc
.label zpdd = $dd
.label zpde = $de
.label zpdf = $df
.label zpe0 = $e0
.label zpe1 = $e1
.label zpe2 = $e2
.label zpe3 = $e3
.label zpe4 = $e4
.label zpe5 = $e5
.label zpe6 = $e6
.label zpe7 = $e7
.label zpe8 = $e8
.label zpe9 = $e9
.label zpea = $ea
.label zpeb = $eb
.label zpec = $ec
.label zped = $ed
.label zpee = $ee
.label zpef = $ef
.label zpf0 = $f0
.label zpf1 = $f1
.label zpf2 = $f2
.label zpf3 = $f3
.label zpf4 = $f4
.label zpf5 = $f5
.label zpf6 = $f6
.label zpf7 = $f7
.label zpf8 = $f8
.label zpf9 = $f9
.label zpfa = $fa
.label zpfb = $fb
.label zpfc = $fc
.label zpfd = $fd
.label zpfe = $fe
.label zpff = $ff
