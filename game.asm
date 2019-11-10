
.var lilypos = reserve(1)
.var lilystate = reserve(1)
.var lilymin = reserve(1)
.var lilymax = reserve(1)
.var lilyspeed = reserve(1)

.const lilyoffset  = 319 - 256

.macro loadLevel(lvl) {
//  !if .lvl = 0 {
          lda #100
          sta lilypos
          sta lilymin
          lda #254
          sta lilymax
          lda #1
          sta lilyspeed
          lda #0
          sta lilystate
}
        
.macro initLily() {
          loadSprite(lily1, 4)
          moveSprite(4, 0, 200)
          loadSprite(lily2, 5)
          moveSprite(5, 0, 200)
          loadSprite(lily3, 6)
          moveSprite(6, 0, 200 + 21)
          loadSprite(lily4, 7)
          moveSprite(7, 0, 200 + 21)
}
.macro initFrog() {
          .const startx = 35
          .const starty = 180
          loadSprite(blank, 0)
          loadSprite(blank, 1)
          loadSprite(frog2, 2)
          loadSprite(blank, 3)
          moveSprite(0, startx, starty)
          moveSprite(1, startx + 24, starty)
          moveSprite(2, startx, starty + 21)
          moveSprite(3, startx + 24, starty + 21)
          
          setSpriteMC(5, 2)
}
          
.macro moveLily() {
          lda lilystate
          and #1
          bne down
          lda lilypos
          clc
          adc lilyspeed
          bcs !+
          cmp lilymax
          bcc done                      
!:        lda #1
          ora lilystate
          sta lilystate
          lda lilymax
          jmp done
down:     lda lilypos
          sec
          sbc lilyspeed
          bcc !+
          cmp lilymin
          bcs done
!:        lda #$fe
          and lilystate
          sta lilystate
          lda lilymin
done:     sta lilypos
          clc
          adc #lilyoffset - 24
          sta $d008
          sta $d00C
          bcc !+
          lda #%01010000
          ora $d010
          jmp !++
!:        lda #%10101111
          and $d010
!:        sta $d010
          lda lilypos
          clc
          adc #lilyoffset
          sta $d00A
          sta $d00E
          bcc !+
          lda #%10100000
          ora $d010
          jmp !++
!:        lda #%01011111
          and $d010
!:        sta $d010
}