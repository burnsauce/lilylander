.const rasterhi = $d011
.const rasterlo = $d012
.const ciaconf  = $dc0d
.const VICIRQ   = $d019

.var rasterVectors = 0
.var lineNumbers = 0
.var frameVector = 0
.var rasterCount = 0
.var rasterNum   = 0
.var currentRaster = 0

.macro rasterACK() {
        asl VICIRQ
}

.macro setRasterLine(line) {
          .if (line > 255) {
            lda #$80
            ora rasterhi
            sta rasterhi
            lda #<line
            sta rasterlo
          } else {
            lda #$7f
            and rasterhi
            sta rasterhi
            lda #<line
            sta rasterlo
          }
}
 
.macro copyRasterLine(offset){
        lda offset
        asl
        tay
        lda lineNumbers, y
        sta rasterlo
        lda lineNumbers + 1, y
        // we'll just store $80 in the second byte
        beq !+
        ora rasterhi
        jmp !++
!:      lda #$7f
        and rasterhi
!:      sta rasterhi    
}

        
.macro setFrameVector(vector) {
          setVector(frameVector, vector)
}
        
.macro finishRasterISR() {
          lda #(rasterNum)
          sec
          sbc currentRaster
          bne frisr1
          copyInterrupt(frameVector)
          setRasterLine(251)
          rasterACK()
          rti
frisr1:   copyInterruptO(rasterVectors, currentRaster)
          copyRasterLine(currentRaster)
          inc currentRaster
          rasterACK()
          rti
}
        
.macro finishFrame() {
          lda #0
          sta currentRaster
          finishRasterISR()
}

noRasterISR:
          finishRasterISR()

.var nextVector = 0

.macro addRasterISR(line, vector) {
          //.errorif (line > rasterNum) "Too many raster lines"
          .var lineaddr = nextVector * 2 + lineNumbers
          lda #line
          sta lineaddr
          .if (line > 255) {
            lda #$80
            sta lineaddr + 1
          } else {
            lda #0
            sta lineaddr + 1
          }
          lda #<vector
          sta nextVector * 2 + rasterVectors
          lda #>vector
          sta nextVector * 2 + rasterVectors + 1
          
          .eval nextVector = nextVector + 1
}



.macro createRasterBars(num) {
          .eval rasterVectors = reserve(num * 2)
          .eval lineNumbers = reserve(num * 2)
          .eval frameVector = reserve()
          .eval rasterCount = reserve(1)
          .eval rasterNum = num
          .eval currentRaster = reserve(1)
          lda #num
          sta rasterCount
          lda #0
          sta currentRaster
          lda #<noRasterISR
          ldy #>noRasterISR
          .for(var i = 0; i < num; i++) {
            sta rasterVectors + i * 2
            sty rasterVectors + i * 2 + 1
          }
          ldy #0
          .for(var i = 0; i < num; i++)  {
            lda #i
            sta lineNumbers + i * 2 
            sty lineNumbers + i * 2 + 1
          }
}
        
.macro initRasterISR() {
        sei
        lda #$7f
        sta ciaconf
        copyInterrupt(rasterVectors)
        copyRasterLine(currentRaster)
        lda #1
        sta $d01a
        cli
}
