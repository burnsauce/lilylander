.segment Stack	[start=$0100, min=$0100, max=$01ff, virtual] "Stack"
.fill $100, 0
.segment CopyCode	[startAfter="Stack", max=$0200 + $0bb9, virtual]
doColorRamCopy:
.fill 13 * 40 * 6 + 1,0
.segmentdef Code 	[startAfter="CopyCode"]
.segmentdef Data 	[startAfter="Code"]
.segmentdef RLEMatrix	[startAfter="Data"]
.segmentdef RLEColor	[startAfter="RLEMatrix"]
.segment MatrixBuf	[start=$4000, min=$4000, max=$43f7, virtual, fill]
smb1: .fill $3f8,0
.segment SprPtrs1	[start=$43f8, min=$43f8, max=$43ff, virtual, fill]
sprp1: .fill 8,0
.segment Sprites1	[startAfter="SprPtrs1"]
sprbank1:
#import "sprites.asm"
.segment ColorBuffer 	[startAfter="Sprites1", align=$100, virtual]
rmb: .fill 25 * 40, 0
.segmentdef InitCode 	[startAfter="Sprites1", modify="BasicUpstart", _start=init]
.segmentdef Code2 	[startAfter="InitCode"]
.segment BitmapBuf	[start=$6000, min=$6000, max=$7f3f, virtual, fill]
bmb1: .fill $1f40, 0
.segmentdef RLEBitmap	[startAfter="BitmapBuf"]
.segment MatrixBuf2 	[start=$c000, min=$c000, max=$c3f7, virtual, fill]
smb2: .fill $3f8,0
.segment SprPtrs2	[start=$c3f8, min=$c3f8, max=$c3ff, virtual, fill]
sprp2: .fill 8,0
.segment Sprites2	[startAfter="SprPtrs2", virtual]
sprbank2:
		.fill sprsize, 0

.segment BitmapBuf2	[start=$e000, min=$e000, max=$ff40, virtual, fill]
bmb2: .fill $1f40, 0

.file [name="ll.prg", segments="Code,Code2,Data,InitCode,Sprites1,RLEBitmap,RLEMatrix,RLEColor"]
