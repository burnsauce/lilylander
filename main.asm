// LilyLander
// (c) 2019 sliderule@gmail.com
//
// main.asm

#import "registers.asm"
#import "segments.asm"

.segment Code
#import "common.asm"
#import "zeropage.asm"
#import "unroll.asm"
#import "dblbuf.asm"
#import "sid.asm"
#import "rle.asm"
#import "bgdata.asm"
#import "sprmux.asm"
#import "frame.asm"
#import "init.asm"
#import "game.asm"

.segment Code "Main Loop"
ready:
	jsr updateGame
	copyDblRam()
	asl $d019
	cli
	mov #0 : frame_count
loop:	lda copy_request
	bne !+
	jmp ckframe
!:	cmp #11
	beq !+
	jmp chkm
!:	copyDblRam()
	jmp partdone
chkm:	cmp #10
	beq !+
	jmp chk9
!:	copyDblMatrix()
	jmp partdone
chk9:	cmp #9
	beq !+
	jmp chk8
!:	copyDblBitmapPart(0)
	jmp partdone
chk8:	cmp #8
	beq !+
	jmp chk7
!:	copyDblBitmapPart(1)
	jmp partdone
chk7:	cmp #7
	beq !+
	jmp chk6
!:	copyDblBitmapPart(2)
	jmp partdone
chk6:	cmp #6
	beq !+
	jmp chk5
!:	copyDblBitmapPart(3)
	jmp partdone
chk5:	cmp #5
	beq !+
	jmp chk4
!:	copyDblBitmapPart(4)
	jmp partdone
chk4:	cmp #4
	beq !+
	jmp chk3
!:	copyDblBitmapPart(5)
	jmp partdone
chk3:	cmp #3
	beq !+
	jmp chk2
!:	copyDblBitmapPart(6)
	jmp partdone
chk2:	cmp #2
	beq !+
	jmp chk1
!:	copyDblBitmapLastPart()
	jmp partdone
chk1:	decodeBitmapColumn()
partdone:	dec copy_request
ckframe:	lda frame_count
	cmp #2
	beq !+
	jmp loop
!:	lda copy_request
	beq !+
	jmp loop
!:	jsr updateGame
	mov #0 : frame_count
	jmp loop
