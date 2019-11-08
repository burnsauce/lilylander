!src "raster.asm"
!src "sprlib.asm"
!src "game.asm"

frame_asm = *

frdiv     = 8
frspd     = 3

+reserve ~aniptr
+reserve ~cfreq
+reserve ~phase, 1
+reserve ~phcount, 1
+reserve ~jumping, 1
+reserve ~keyheld, 1

  
!macro scankey .col {
          lda #((1 << .col) XOR $ff)
          sta PRA
          lda PRB
          cmp #$ff
}

PRA       = $dc00
DDRA      = $dc02
PRB       = $dc01
DDRB      = $dc03

!macro animate {
          jmp (aniptr)
}

noAnimation
          +finishFrame
          
ph1ani    +pushFrogRight frspd
          +pushFrogUp 3
          lda #$02
          adc cfreq + 1
          sta cfreq + 1
          +SIDfreqd 1, cfreq
          +finishFrame
ph2ani    +pushFrogRight frspd
          lda #(frdiv / 2)
          sec
          sbc phcount
          bcs +
          +pushFrogUp 2
          jmp ++
+         +pushFrogDown 2
++        +finishFrame
ph3ani    +pushFrogRight frspd
          +pushFrogDown 3
          +finishFrame
          
!macro jmpsound {
          lda #$00
          sta cfreq
          lda #$08
          sta cfreq + 1
          +SIDvol 10
          +SIDtri 1
          +SIDadsr 1, 1, 7, 15, 2
          +SIDfreqd 1, cfreq
          +SIDgate 1, 1
}
          
!macro jmpstop {
          +SIDgate 1, 0
}

frameISR  lda #0
          sta $d012
          jsr moveLily
          lda jumping
          cmp #1
          beq skipkey
          lda #$ff
          sta DDRA
          lda #0
          sta DDRB
          +scankey 0
          bne +
          +scankey 1
          bne +
          +scankey 2
          bne +
          +scankey 3
          bne +
          +scankey 4
          bne +
          +scankey 5
          bne +
          +scankey 6
          bne +
          +scankey 7
          bne +
          +animate
+         lda #1
          sta jumping
skipkey   ldy phcount
          dey
          sty phcount
          cpy #0
          beq +
          +animate
; --------------- phase update ----------------
+         ldy #frdiv
          sty phcount
          lda phase          
          clc
          adc #1
          sta phase
          cmp #1
          beq +
          jmp ++
+         +jmpsound          ;phase 1: jumping
          +loadSprite frogj1, 0
          +loadSprite frogj2, 1
          +loadSprite frogj3, 2
          +loadSprite blank, 3
          +setVector aniptr, ph1ani
          +animate
++        cmp #2
          beq +
          jmp ++
+         +jmpstop           ;phase 2: soaring
          +loadSprite frogs1, 0
          +loadSprite frogs2, 1
          +loadSprite blank, 2
          +loadSprite blank, 3
          +setVector aniptr, ph2ani
          +animate
++        cmp #3
          beq +
          jmp ++
+         +loadSprite frogf1, 0    ;phase 3: falling
          +loadSprite frogf2, 1
          +loadSprite frogf4, 3
          +loadSprite blank, 2
          +setVector aniptr, ph3ani
          +animate
;+         cmp #4
;          bne +
;          +loadSprite frog2, 3     ;phase 4: landed
;          +loadSprite blank, 0
;          +loadSprite blank, 1
;          +loadSprite blank, 2
;          +setAnim noISR
;          +animate
++        lda #0
          sta phase             ;phase 0: sitting
          sta jumping
          ; TODO: check to see if landed
          +loadSprite frog2, 2
          +loadSprite blank, 0
          +loadSprite blank, 1
          +loadSprite blank, 3
          +setVector aniptr, noAnimation
          +pushFrogRight 24
          +animate

!macro initFrame {
          ldy #frdiv
          sty phcount
          lda #0
          sta phase
          sta jumping
          sta keyheld
          +initFrog
          +initLily
          +loadLevel 0
          +createRasterBars 2
          +setVector aniptr, noAnimation
          +setFrameVector frameISR
          
          ; set interrupt vector
          +initRasterISR
}

