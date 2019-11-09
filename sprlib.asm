sprtable = $07f8
spren    = $d015
sprmc    = $d01c
sprcolor = $d027
sprmc1   = $d025
sprmc2   = $d026
sprxhi   = $d010
sprxpos  = $d000
sprypos  = $d001

+reserve ~sprpos, 16
+reserve ~lsarg, 1

!macro setSpriteMC .mc1, .mc2 {
          lda #.mc1
          sta sprmc1
          lda #.mc2
          sta sprmc2
}
!macro loadSprite .location, .num {
          lda #.location
          sta sprtable + .num
          !set .location = (((.location + 1) * 64) - 1)
          !byte $ad ; lda absolute
          !byte <.location
          !byte >.location
          ;lda .location ; bugged???
          sta lsarg
          and #$80   ; multicolor

          beq +
          lda #(1 << .num) 
          ora sprmc
          sta sprmc
+         lda lsarg
          and #$0F ; color
          sta sprcolor + .num
          +enableSprite .num
}
        
!macro enableSprite .num {
          lda #(1 << .num)
          ora spren
          sta spren
}
!macro disableSprite .num {
          lda #((1 << .num) XOR $ff))
          and spren
          sta spren
}
!macro enableSprite {
          lda #$ff
          sta spren
}
!macro moveSprite .num, .x, .y {
          !if (.x > 255) {
          ; load the hi bit  
            lda #(1 << .num)
            ora sprxhi
            sta sprxhi
          }
          lda #<.x
          sta sprxpos + (.num * 2)
          lda #.y
          sta sprypos + (.num * 2)
}
!macro pushFrogRight .amt {
          lda $d000
          clc
          adc #.amt
          sta $d000
          sta $d004
          bcc .pfr1
          lda #(1 << 0) OR (1 << 2)
          ora sprxhi
          sta sprxhi
.pfr1     lda $d002
          clc
          adc #.amt
          sta $d002
          sta $d006
          bcc .pfr2
          lda #(1 << 1) OR (1 << 3)
          ora sprxhi
          sta sprxhi
.pfr2   
}
!macro pushFrogUp .amt {
          lda $d001
          sec
          sbc #.amt
          sta $d001
          sta $d003
          lda $d005
          sec
          sbc #.amt
          sta $d005
          sta $d007
}
!macro pushFrogDown .amt {
          lda $d001
          clc
          adc #.amt
          sta $d001
          sta $d003
          lda $d005
          clc
          adc #.amt
          sta $d005
          sta $d007
}