
!set initdone = *
!set ad1 = init
!set ad10000 = ad1 / 10000
!set ad1 = ad1 - (ad10000 * 10000)
!set ad1000 = ad1 / 1000
!set ad1 = ad1 - (ad1000 * 1000)
!set ad100 = ad1 / 100
!set ad1 = ad1 - (ad100 * 100)
!set ad10 = ad1 / 10
!set ad1 = ad1 - (ad10 * 10)

*=$801
bootstrap
; 10 SYS
!byte $0b,$08,$0a,$00,$9e
!if ad10000 > 0 {
  !byte $30 + ad10000
  !byte $30 + ad1000 
} else {
  !if ad1000 > 0 {
    !byte $30 + ad1000

  }
}
!byte $30 + ad100         ; A
!byte $30 + ad10          ; D
!byte $30 + ad1           ; R
!fill (lowaddr - *), 0
* = initdone