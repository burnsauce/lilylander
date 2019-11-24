.file [name="ll.prg", segments="Code,Data,CopyCode,Graphics1,InitCode"]
.segmentdef Code [start=$810]
.segmentdef Data [startAfter="Code"]
.segmentdef Graphics1 [start=$4000]
.segmentdef CopyCode [startAfter="Graphics1", virtual]
.segmentdef Graphics2 [start=$C000]
.segmentdef Buffer [startAfter="Data", align=$100]
.segmentdef InitCode [startAfter="Data", modify="BasicUpstart", _start=init, align=$100]

#import "disk.asm"

.segment CopyCode "doColorRamCopy"
.label doColorRamCopy = *
	.fill 6001, 0
.segment CopyCode "doBufferRamCopy"
.label doBufferRamCopy = *
	.fill 6001, 0

.segment Buffer
.label	rmb = *
* = rmb "Color Ram Buffer" virtual
	.fill $3f8,0

.segment Graphics1
.label 	smb1 = $4000
* = smb1 "Screen Matrix Buffer 1" virtual
	.fill $3f8, 0
.label sprp1 = *

.align $40
.label sprbank1 = *
* = * "Sprites"
#import "sprites.asm"
.label sprsize = * - sprbank1

.label 	bmb1 = $6000
* = bmb1 "Bitmap Buffer 1" virtual
	.fill $1f40, 0


.segment Graphics2
.label 	smb2 = $c000
* = smb2 "Screen Matrix Buffer 2" virtual
	.fill $3f8, 0
.label sprp2 = *

.align $40
.label sprbank2 = *
* = * "Bank 2 Sprites" virtual
	.fill sprsize, 0

.label 	bmb2 = $e000
*= 	bmb2 "Bitmap Buffer 2" virtual
	.fill $1f40, 0
