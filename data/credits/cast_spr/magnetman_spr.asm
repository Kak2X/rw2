SprMap_Cast_MagnetMan:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$80,$00 ; $00
	db $E9,$FC,$81,$00 ; $01
	db $E9,$04,$82,$00 ; $02
	db $F1,$F4,$90,$00 ; $03
	db $F1,$FC,$91,$00 ; $04
	db $F1,$04,$92,$00 ; $05
	db $F9,$F4,$A0,$00 ; $06
	db $F9,$FC,$A1,$00 ; $07
	db $F9,$04,$A2,$00 ; $08
.end:

