rasterhi = $d011
rasterlo = $d012
ciaconf  = $dc0d
VICIRQ   = $d019


  
!macro rasterACK {
        asl VICIRQ
}
      
!macro setRasterLine .line {
          !if .line > 255 {
            lda #$80
            ora rasterhi
            sta rasterhi
            lda #<.line
            sta rasterlo
          } else {
            lda #$7f
            and rasterhi
            sta rasterhi
            lda #<.line
            sta rasterlo
          }
}
        
!macro copyRasterLine .offset {
        ldy+1 .offset
        lda lineNumbers, y
        sta rasterlo
}

        
!macro setFrameVector .vector {
          +setVector frameVector, .vector
}
        
finishRasterISR
          inc $d020
          ldy+1 currentRaster
          iny
          cpy+1 rasterCount
          bne +
          lda #0
          sta+1 currentRaster
          ;!if frameVectorUsed != -1 {
            +copyInterrupt frameVector
            +setRasterLine 201
          ;} else {
          ;  +setInterrupt rasterVectors
          ;}
          +rasterACK
          rti
+         sty+1 currentRaster
          +copyInterrupt rasterVectors, currentRaster
          +copyRasterLine currentRaster
          +rasterACK
          rti

finishFrame
          +copyInterrupt rasterVectors
          +copyRasterLine currentRaster 
          jmp finishRasterISR

          
          
!macro createRasterBars .num {
          ;!if .num > 200 { !warn "Interrupt count exceeds viewable lines", .num }
          ;!if .num > 255 { !serious "Interrupt count exceeds 255", .num }
          ; create the common data
          +reserve ~rasterVectors, .num * 2
          +reserve ~lineNumbers, .num
          +reserve ~frameVector
          +reserve ~rasterCount, 1
          +reserve ~currentRaster, 1
          ; init the data
          lda #.num
          sta+1 rasterCount
          lda #0
          sta+1 currentRaster
          lda #<finishRasterISR
          ldy #>finishRasterISR
          !for .i, .num {
            sta+1 rasterVectors + (.i - 1) * 2
            sty+1 rasterVectors + (.i - 1) * 2 + 1
          }
          !for .i, .num  {
            lda #.i
            sta+1 lineNumbers + .i - 1
          }     
}
        
initRasterISR
        sei
        LDA #$7f ; all timer conf set to value of bit 7 (0)
        sta ciaconf
        lda rasterVectors
        sta $fffe
        lda rasterVectors + 1
        sta $ffff
        ;+copyInterrupt rasterVectors
        +setRasterLine 0
        ;+copyRasterLine currentRaster
        lda #1
        sta $d01a
        cli
        rts
