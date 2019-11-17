.file [name="main.prg", segments="Code,Data,Graphics1,InitCode"]
.segmentdef Code [start=$810]
.segmentdef Data [startAfter="Code"]
.segmentdef Graphics1 [start=$4000]
.segmentdef Graphics2 [start=$C000]
.segmentdef Buffer [start=$8000]
.segmentdef InitCode [start=$8000, modify="BasicUpstart", _start=$8000]

.segment Buffer
.label	rmb = $8000
* = rmb "Color Ram Buffer" virtual
	.fill $3f8,0

.segment Graphics1
.label 	smb1 = $4000
* = smb1 "Screen Matrix Buffer 1" virtual
	.fill $3f8, 0
.label sprp1 = *

*=* + 8	"Bank 1 Sprites"
.label sprbank1 = *
#import "sprites.asm"

.label 	bmb1 = $6000
* = bmb1 "Bitmap Buffer 1" virtual
	.fill $1f40, 0


.segment Graphics2
.label 	smb2 = $c000
* = smb2 "Screen Matrix Buffer 2" virtual
	.fill $3f8, 0
.label sprp2 = *

*=* + 8	"Bank 2 Sprites" virtual
.label sprbank2 = *
	.fill sprdata_size, 0

.label 	bmb2 = $e000
*= 	bmb2 "Bitmap Buffer 2" virtual
	.fill $1f40, 0
