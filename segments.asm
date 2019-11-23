.file [name="ll.prg", segments="Code,Data,InitCode,FieldData,Graphics1,CopyCode"]

.segmentdef Code [start=$810]
.segmentdef Data [startAfter="Code"]

.segmentdef InitCode [start=$5000, modify="BasicUpstart", _start=init, align=$100]
.segment Buffer [start=$5000, align=$100, virtual] "Color Ram Buffer"
rmb:
	.fill $3f8,0

#import "disk.asm"

.segment BucketEmpty1 [start=$4c4c, virtual]
.fill 21, 0
.segment BucketEmpty2 [start=$4cc8, virtual]
.fill 21, 0
.segment BucketEmpty3 [start=$c84c, virtual]
.fill 21, 0
.segment BucketEmpty4 [start=$c8c8, virtual]
.fill 21, 0

.segment CopyCode [startAfter="Graphics1", virtual] "doColorRamCopy"
doColorRamCopy:
	.fill 6001, 0


.segment Graphics1 [start=$4000]
* = * "Screen Matrix Buffer 1" virtual
smb1:
	.fill $400, 0
.label sprp1 = * - 8

.align $40
sprbank1:
.segment Graphics1 "Sprites"
#import "sprites.asm"
.var sprsize = * - sprbank1

* = $6000 "Bitmap Buffer 1" virtual
bmb1:
	.fill $1f40, 0


.segment Graphics2 [start=$C000, virtual] "Screen Matrix Buffer 2"

smb2:
	.fill $400, 0
.label sprp2 = * - 8

.align $40
* = * "Bank 2 Sprites" virtual
sprbank2:
	.fill sprsize, 0

* = $e000 "Bitmap Buffer 2" virtual
bmb2:
	.fill $1f40, 0
