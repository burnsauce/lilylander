.segment Stack	[start=$0100, min=$0100, max=$01ff, virtual] "Stack"
.fill $100, 0
//.segmentdef Free1	[start=$0200, min=$0200, max=$080f, virtual, fill]
.segment CopyCode	[startAfter="Stack", max=$0200 + $0bb9, virtual]
.label doColorRamCopy = $7f40
.fill $0bb9,0
.segmentdef Code 	[startAfter="CopyCode"]
.segmentdef Data 	[startAfter="Code"]
.segmentdef Free2	[startAfter="Buffer", max=$3fff, virtual]
.segment MatrixBuf	[start=$4000, min=$4000, max=$43f7, virtual]
.label smb1 = $4000
.fill $3f8,0
.segment SprPtrs1	[startAfter="MatrixBuf", max=$43ff, virtual]
.label sprp1 = $43f8
.fill 8,0
.segment Sprites1	[startAfter="SprPtrs1"]
.label sprbank1 = $4400
#import "sprites.asm"
.segmentdef Buffer 	[startAfter="Sprites1", align=$100]
.label rmb = *
.segmentdef InitCode 	[startAfter="Sprites1", modify="BasicUpstart", _start=init, align=$100]
//.segment Free3	[startAfter="Sprites1", max=$5fff, virtual]
.segment BitmapBuf	[start=$6000, min=$6000, max=$7f3f, virtual, fill]
.label bmb1 = $6000
.fill $1f40,0
.segment Free4	[startAfter="CopyCode", max=$bfff, virtual]
.segment MatrixBuf2 	[start=$c000, min=$c000, max=$c3f7, virtual, fill]
.label smb2 = $c000
.fill $3f8,0
.segment SprPtrs2	[startAfter="MatrixBuf2", max=$c3ff, virtual]
.label sprp2 = $c3f8
.fill 8,0
.segment Sprites2	[startAfter="SprPtrs2", virtual]
.label sprbank2 = $c400
		.fill sprsize, 0

.segment Free5	[startAfter="Sprites2", max=$dfff, virtual]
.segment BitmapBuf2	[start=$e000, min=$e000, max=$ff40, virtual, fill]
.label bmb2 = $e000
.fill $1f40, 0

.file [name="ll.prg", segments="Code,Data,InitCode,Sprites1"]
#import "disk.asm"
