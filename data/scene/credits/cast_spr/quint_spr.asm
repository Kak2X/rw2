SprMap_Cast_Quint:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F5,$80,$00 ; $00
	db $E9,$FD,$81,$00 ; $01
	db $E9,$05,$82,$00 ; $02
	db $F1,$F5,$90,$00 ; $03
	db $F1,$FD,$91,$00 ; $04
	db $F1,$05,$92,$00 ; $05
	db $F9,$F5,$A0,$00 ; $06
	db $F9,$FD,$A1,$00 ; $07
	db $F9,$05,$A2,$00 ; $08
.end: