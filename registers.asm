* = $d000 "VIC Registers" virtual

SPR0X:		.byte 0
SPR0Y:		.byte 0
SPR1X:		.byte 0
SPR1Y:		.byte 0
SPR2X:		.byte 0
SPR2Y:		.byte 0
SPR3X:		.byte 0
SPR3Y:		.byte 0
SPR4X:		.byte 0
SPR4Y:		.byte 0
SPR5X:		.byte 0
SPR5Y:		.byte 0
SPR6X:		.byte 0
SPR6Y:		.byte 0
SPR7X:		.byte 0
SPR7Y:		.byte 0
SPRMSX:		.byte 0
YSCROL:		.byte 0
RASTER:		.byte 0
LPX:		.byte 0
LPY:		.byte 0
SPREN:		.byte 0
XSCROL:		.byte 0
SPRYEX:		.byte 0
VICMEM:		.byte 0
RASIRQ:		.byte 0
RASIE:		.byte 0
SPRPRI:		.byte 0
SPRMC:		.byte 0
SPRXX:		.byte 0
SPRSPRC:	.byte 0
SPRDATAC:	.byte 0
BORDERC:	.byte 0
BG0COL:		.byte 0
BG1COL:		.byte 0
BG2COL:		.byte 0
BG3COL:		.byte 0
SPRMC0:		.byte 0
SPRMC1:		.byte 0
SPR0COL:	.byte 0
SPR1COL:	.byte 0
SPR2COL:	.byte 0
SPR3COL:	.byte 0
SPR4COL:	.byte 0
SPR5COL:	.byte 0
SPR6COL:	.byte 0
SPR7COL:	.byte 0

* = $d400 "SID Registers" virtual
V1FREQ:		.word 0
V1PWDUTY:	.word 0
V1CTRL:		.byte 0
V1AD:		.byte 0
V1SR:		.byte 0
V2FREQ:		.word 0
V2PWDUTY:	.word 0
V2CTRL:		.byte 0
V2AD:		.byte 0
V2SR:		.byte 0
V3FREQ:		.word 0
V3PWDUTY:	.word 0
V3CTRL:		.byte 0
V3AD:		.byte 0
V3SR:		.byte 0
FCUT:		.word 0
FRES:		.byte 0
FVOL:		.byte 0
PADDLEX:	.byte 0
PADDLEY:	.byte 0
OSC3V:		.byte 0
ENV3V:		.byte 0

*= $d800 "Color Memory" virtual
COLORMEM:	.fill $dc00 - *, 0

*= $dc00 "CIA 1" virtual
CIA1_PRA:	.byte 0
CIA1_PRB:	.byte 0
CIA1_PRADDR:	.byte 0
CIA1_PRBDDR:	.byte 0
CIA1_TIMERA:	.word 0
CIA1_TIMERB:	.word 0
CIA1_RTC10MS:	.byte 0
CIA1_RTCS:	.byte 0
CIA1_RTCM:	.byte 0
CIA1_RTCH:	.byte 0
CIA1_SSR:	.byte 0
CIA1_ICR:	.byte 0
CIA1_TCA:	.byte 0
CIA1_TCB:	.byte 0


*= $dd00 "CIA 2" virtual
CIA2_PRA:	.byte 0
CIA2_PRB:	.byte 0
CIA2_PRADDR:	.byte 0
CIA2_PRBDDR:	.byte 0
CIA2_TIMERA:	.word 0
CIA2_TIMERB:	.word 0
CIA2_RTC10MS:	.byte 0
CIA2_RTCS:	.byte 0
CIA2_RTCM:	.byte 0
CIA2_RTCH:	.byte 0
CIA2_SSR:	.byte 0
CIA2_ICR:	.byte 0
CIA2_TCA:	.byte 0
CIA2_TCB:	.byte 0




