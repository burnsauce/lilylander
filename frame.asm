* = * "Frame Code"
.var frdiv = reserve(1)
.var frspd = reserve(1)

.const PRA       = $dc00
.const DDRA      = $dc02
.const PRB       = $dc01
.const DDRB      = $dc03

.var aniptr = reserve()
.var cfreq = reserve()
.var phase = reserve(1)
.var phcount = reserve(1)
.var jumping = reserve(1)
.var keyheld = reserve(1)
  
.const frameRaster = 1 

.macro scankey(col) {
          lda #((1 << col) ^ $ff)
          sta PRA
          lda PRB
          cmp #$ff
}

.macro animate() {
          jmp (aniptr)
}
.macro finishFrame() {
          asl $d019
          rti
}

noAnimation:
          finishFrame()
          
ph1ani:   pushFrogRight(frspd)
          pushFrogUp(3)
          lda #$02
          adc cfreq + 1
          sta cfreq + 1
          SIDfreqd(1, cfreq)
          finishFrame()
          
ph2ani:   pushFrogRight(frspd)
          lda #(frdiv / 2)
          sec
          sbc phcount
          bcs frogdown
          pushFrogUp(2)
          jmp ph2ani1
frogdown: pushFrogDown(2)
ph2ani1:  finishFrame()

ph3ani:   pushFrogRight(frspd)
          pushFrogDown(3)
          finishFrame()
          
.macro jmpsound() {
          lda #$00
          sta cfreq
          lda #$08
          sta cfreq + 1
          SIDvol(10)
          SIDtri(1)
          SIDadsr(1, 1, 7, 15, 2)
          SIDfreqd(1, cfreq)
          SIDgate(1, 1)
}
          
.macro jmpstop() {
          SIDgate(1, 0)
}

frameISR:
          moveLily()
	  lda keyheld
	  beq !+
	  jmp !++
!:        lda jumping
          beq !+
	  jmp skipkey
!:        lda #$ff
          sta DDRA
          lda #0
          sta DDRB
          scankey(0)
          bne holding
          scankey(1)
          bne holding
          scankey(2)
          bne holding
          scankey(3)
          bne holding
          scankey(4)
          bne holding
          scankey(5)
          bne holding
          scankey(6)
          bne holding
          scankey(7)
          bne holding
	  lda keyheld
	  bne jumpnow
          animate()
jumpnow: 
	  lda #1
	  sta jumping
	  sta phcount
	  lda powerLevel
	  lsr
	  lsr
	  clc
	  adc #1
	  sta frspd
	  lda #8
	  sta frdiv
	  lda #0
	  sta keyheld
	  jmp skipkey
holding:  lda #1
          sta keyheld
	  updatePower()
	  animate()
skipkey:  ldy phcount
          dey
          sty phcount
          beq !+
          animate()
// --------------- phase update ----------------
!:        ldy frdiv
          sty phcount
          lda phase          
          clc
          adc #1
          sta phase
          cmp #1
          beq !+
          jmp ph2
!:        jmpsound()
          loadSprite(frogj1, 0)
          loadSprite(frogj2, 1)
          loadSprite(frogj3, 2)
          loadSprite(blank, 3)
          setVector(aniptr, ph1ani)
          animate()
ph2:      cmp #2
          beq !+
          jmp ph3
!:        jmpstop()
          loadSprite(frogs1, 0)
          loadSprite(frogs2, 1)
          loadSprite(blank, 2)
          loadSprite(blank, 3)
          setVector(aniptr, ph2ani)
          animate()
ph3:      cmp #3
          beq !+
          jmp ph0

!:        loadSprite(frogf1, 0)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
          loadSprite(frogf2, 1)
          loadSprite(frogf4, 3)
          loadSprite(blank, 2)
          setVector(aniptr, ph3ani)
          animate()
ph0:      lda #0
          sta phase
          sta jumping
	  sta keyheld
          // TODO: check to see if landed
          //loadSprite(frog2, 2)
          //loadSprite(blank, 0)
          //loadSprite(blank, 1)
          //loadSprite(blank, 3)

          setVector(aniptr, noAnimation)
          //pushFrogRight(24)
	  initFrog()
	  resetPower()
          animate()

.macro initFrame() {
          ldy #frdiv
          sty phcount
          lda #0
          sta phase
          sta jumping
          sta keyheld
          sta powerLevel
	  initFrog()
          initLily()
          loadLevel(0)
          //createRasterBars(1)
          setVector(aniptr, noAnimation)
          //setFrameVector(frameISR)
          
          // trim the border
          lda $d016
          and #((1 << 3) ^ $ff)
          sta $d016
          // set interrupt vector
          sei
          lda #$7f
          sta $dc0d
	  lda #$80
          ora $d011
          sta $d011
          lda #frameRaster
          sta $d012
          
          setInterrupt(frameISR)
          lda #1
          sta $d01a
          cli
          
          //initRasterISR()
}
