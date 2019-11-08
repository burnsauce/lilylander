!src "common.asm"
!macro macro_a .a, .b {
  lda .a
  sta .b
}

!macro macro_b .x, .y {
  +macro_a .y, .x
}

!macro macro_c .d, .e {
  +macro_b 49, <.d
}
