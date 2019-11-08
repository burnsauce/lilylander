!set nextVar = $2
!set savedVar = 0

machine_irq = $fffe

!macro reserve ~.name, .bytes {
          !if (.bytes = 1) AND (savedVar != 0) {
            .name = savedVar
            !set savedVar = 0
          } else {
            .name = nextVar
            !set nextVar = nextVar + .bytes
          }
}

!macro reserve ~.name {
          !if (nextVar % 2) != 0 {
            !set savedVar = nextVar
            !set nextVar = nextVar + 1
          }
          .name = nextVar
          !set nextVar = nextVar + 2
}
           
!macro setVector .sv_vector, .sv_target {
            lda #<.sv_target
            sta+1 .sv_vector
            lda #>.sv_target
            sta+1 .sv_vector + 1
}

!macro setInterrupt .si_vector {
          !if .si_vector AND $ff00 = 0 {
            lda #<.si_vector
            sta machine_irq
            lda #>.si_vector
            sta machine_irq + 1
          } else {
            lda+1 #<.si_vector
            sta machine_irq
            lda+1 #>.si_vector
            sta machine_irq + 1
          }
}
          
!macro copyInterrupt .ci2_vector, .ci2_offset {
            lda+1 .ci2_offset
            asl
            tay
            lda .ci2_vector, y
            sta machine_irq
            lda .ci2_vector + 1, y
            sta machine_irq + 1
}

!macro copyInterrupt .ci_vector {
            lda+1 .ci_vector
            sta machine_irq
            lda+1 .ci_vector + 1
            sta machine_irq + 1
}
       