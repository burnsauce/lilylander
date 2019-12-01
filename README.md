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

$0002-$007c Zeropage Variables        123 bytes
$007d-$00bc QSin Table                 64 bytes
           67 bytes free at $00bd
$0100-$01ff Stack                     256 bytes
$0200-$0e30 CopyCode                 3121 bytes
$0e31-$2b09 Frame Code               7385 bytes
$2b0a-$2b22 Main Loop                  25 bytes
$2b23-$2b62 Quarter-Sin() table        64 bytes
$2b63-$2c27 SFX Data                  197 bytes
$2c28-$332b RLE Matrix               1796 bytes
$332c-$373c RLE Matrix               1041 bytes
$373d-$3d16 RLE Color Ram            1498 bytes
$3d17-$3fd5 RLE Color Ram             703 bytes
           42 bytes free at $3fd6
$4000-$43f7 MatrixBuf                1016 bytes
$43f8-$43ff SprPtrs1                    8 bytes
$4400-$4fff Sprites1                 3072 bytes
$5000-$53e7 ColorBuffer              1000 bytes
$5000-$53ec init                     1005 bytes
           19 bytes free at $53ed
$5400-$5a6b song.prg                 1644 bytes
$5a6c-$5bf7 DblBuf Code               396 bytes
$5bf8-$5dd0 rleUnpackImage            473 bytes
$5dd1-$5fa9 rleUnpackTitle            473 bytes
           86 bytes free at $5faa
$6000-$7f3f BitmapBuf                8000 bytes
$7f40-$a872 RLE Bitmap              10547 bytes
$a873-$bcc1 RLE Bitmap               5199 bytes
$bcc2-$bd41 Level Data                128 bytes
$bd42-$bde1 Font Data                 160 bytes
$bde2-$bf56 DblBuf Code               373 bytes
          169 bytes free at $bf57
$c000-$c3f7 MatrixBuf2               1016 bytes
$c3f8-$c3ff SprPtrs2                    8 bytes
$c400-$cfff Sprites2                 3072 bytes
         4096 bytes free at $d000
$e000-$ff3f BitmapBuf2               8000 bytes
          190 bytes free at $ff40
         4479 total bytes free
```
