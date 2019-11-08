;!ifdef main_asm !eof
;main_asm = 1
; LilyLander
; (c) 2019 sliderule@gmail.com
;
; main.asm
;
; MEMORY MAP
;
; 0002 - 00FF - zeropage variables 
; 0400 - 07FE - video char buffer
; 0801 - 0810 - BASIC loader
; 0810 - 121b - code
; 2000 - 3f40 - bitmap
; 3f40 - 4328 - character ram
; 4328 - 4710 - color ram
; 4710 - cfff - free 
; d000 - dfff - I/O
; e000 - fffd - free
; fffe - ffff - IRQ vector
!zone main
; CONSTANTS ------------------------------------


;!cpu 6510
        
*= $810
lowaddr
!src "common.asm"
!src "bg.asm"
!src "sid.asm"
!src "game.asm"
!src "frame.asm"

; VARIABLES ------------------------------------
;+reserve ~args, 4

;!warn "Parsing init ", *        
; INIT --------------------------------------
kcls      = $ff81
init      jsr kcls
          +initBackground
          +initFrame
          
          lda #$35        ; disable the BASIC /K ROM
          sta $01
          
loop      jmp loop

; BOOTSTRAPPING --------------------------------
!src "bootstrap.asm"

; SUBROUTINES -------------------------------



; ISRs -------------------------------------------        

!set highest_code = *


          