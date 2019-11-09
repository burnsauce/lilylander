rasterhi = $d011
rasterlo = $d012
ciaconf  = $dc0d
VICIRQ   = $d019
  
!macro rasterACK {
        asl VICIRQ
}

; requires a LITERAL
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
        lda+1 .offset
        asl
        tay
        lda lineNumbers, y
        sta rasterlo
        lda lineNumbers + 1, y
        ; we'll just store $80 in the second byte
        cmp #$80
        bne +
        ora rasterhi
        jmp ++
+       eor #$ff
        and rasterhi
++      sta rasterhi    
}

        
!macro setFrameVector .vector {
          +setVector frameVector, .vector
}
        
!macro finishRasterISR {
          ldy+1 currentRaster
          bmi +
          iny
          cpy+1 rasterCount
          bne +++
          jmp ++
+         ldy #0
          jmp +++
++        ;lda #0
          ;sta+1 currentRaster / not needed here
          ;!if frameVectorUsed != -1 {
            +copyInterrupt frameVector
            +setRasterLine 251
          ;} else {
          ;  +setInterrupt rasterVectors
          ;}
          +rasterACK
          rti
+++       sty+1 currentRaster
          +copyInterrupt rasterVectors, currentRaster
          +copyRasterLine currentRaster
          +rasterACK
          rti
}
        
!macro finishFrame {
          lda #-1
          sta currentRaster
          +finishRasterISR
}

noRasterISR
          +finishRasterISR
!set nextVector = 0

; .line is LITERAL
; .vector is, too
!macro addRasterISR .line, .vector {
          !if nextVector = RASTERCOUNT {
            !serious "Too many raster ISRs."
          }
          .lineaddr = nextVector * 2 + lineNumbers
          lda #<.line
          sta .lineaddr
          !if .line > 255 {
            lda #$80
            sta .lineaddr + 1
          } else {
            lda #0
            sta .lineaddr + 1
          }
          lda #<.vector
          sta nextVector * 2 + rasterVectors
          lda #>.vector
          sta nextVector * 2 + rasterVectors + 1
          
          !set nextVector = nextVector + 1
}
  
!macro createRasterBars .num {
          ;!if .num > 200 { !warn "Interrupt count exceeds viewable lines", .num }
          ;!if .num > 255 { !serious "Interrupt count exceeds 255", .num }
          ; create the common data
          +reserve ~rasterVectors, .num * 2
          +reserve ~lineNumbers, .num * 2
          +reserve ~frameVector
          +reserve ~rasterCount, 1
          !set RASTERCOUNT = .num
          +reserve ~currentRaster, 1
          ; init the data
          lda #.num
          sta+1 rasterCount
          lda #0
          sta+1 currentRaster
          lda #<noRasterISR
          ldy #>noRasterISR
          !for .i, .num {
            sta+1 rasterVectors + (.i - 1) * 2
            sty+1 rasterVectors + (.i - 1) * 2 + 1
          }
          ldy #0
          !for .i, .num  {
            lda #.i
            sta+1 lineNumbers + (.i - 1) * 2 
            sty+1 lineNumbers + (.i - 1) * 2 + 1
          }
}
        
!macro initRasterISR {
        sei
        LDA #$7f ; all timer conf set to value of bit 7 (0)
        sta ciaconf
        lda+1 rasterVectors
        sta $fffe
        lda+1 rasterVectors + 1
        sta $ffff
        ;todo
        +copyInterrupt rasterVectors
        ;+setRasterLine 0
        +copyRasterLine currentRaster
        lda #1
        sta $d01a
        cli
}
