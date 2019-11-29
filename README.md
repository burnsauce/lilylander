# LilyLander
A one-button C=64 game.

## Compatibility
Works on VICE in both NTSC and PAL modes
Probably works on the hardware, too

## Build Requirements
* make
* KickAss assembler
* python 2.7
 * Pillow

## Notes

* This is my first ever game
* I learned 6502 ML at the end of October 2019
* All code written from scratch
 * Initially in ACME, ported to KickAss
  * ACME blows up if you try to use references heavily
  * KickAss has functions (and pseudocommands!)
* Jumping frog sprites by me
* All other artwork by my loving wife, Panda! ```<3```
* Written in 30 days for the 2019 Game Off

### Design
* Double-buffered right-only scrolling engine
 * 1 px/frame
 * unrolled color RAM copy (codegen!)
* RLE-compressed half-screen multicolor bitmap
 * Stored in horizontal major order for column unpacking
* Entire engine in raster ISRs
 * No decoupling between game and frame and sprite logic
  * (An attempt was made, combined with sprite multiplexing, but it killed frame performance) 
* No fastloader :(

### Memory Map
```
   Memory Allocation

$0002-$007a Zeropage Variables        121 bytes
$007b-$00ba QSin Table                 64 bytes
	   69 bytes free at $00bb
$0100-$01ff Stack                     256 bytes
$0200-$0e30 CopyCode                 3121 bytes
$0e31-$2a91 Frame Code               7265 bytes
$2a92-$2aaa Main Loop                  25 bytes
$2aab-$2aea Quarter-Sin() table        64 bytes
$2aeb-$31ee RLE Matrix               1796 bytes
$31ef-$35fe RLE Matrix               1040 bytes
$35ff-$3bd8 RLE Color Ram            1498 bytes
$3bd9-$3e99 RLE Color Ram             705 bytes
	  358 bytes free at $3e9a
$4000-$43f7 MatrixBuf                1016 bytes
$43f8-$43ff SprPtrs1                    8 bytes
$4400-$4fff Sprites1                 3072 bytes
$5000-$53e7 ColorBuffer              1000 bytes
$5000-$53e8 init                     1001 bytes
$53e9-$5574 copyDblBitmap             396 bytes
$5575-$5651 copyDblMatrix             221 bytes
$5652-$56d0 unpackRamColumn           127 bytes
$56d1-$56f9 copyDblRam                 41 bytes
$56fa-$58de rleUnpackImage            485 bytes
$58df-$5ac3 rleUnpackTitle            485 bytes
$5ac4-$5b43 Level Data                128 bytes
$5b44-$5be3 Font Data                 160 bytes
	 1052 bytes free at $5be4
$6000-$7f3f BitmapBuf                8000 bytes
$7f40-$a872 RLE Bitmap              10547 bytes
$a873-$bcc9 RLE Bitmap               5207 bytes
	  822 bytes free at $bcca
$c000-$c3f7 MatrixBuf2               1016 bytes
$c3f8-$c3ff SprPtrs2                    8 bytes
$c400-$cfff Sprites2                 3072 bytes
	 4096 bytes free at $d000
$e000-$ff3f BitmapBuf2               8000 bytes
	  190 bytes free at $ff40
	 6397 total bytes free
```
