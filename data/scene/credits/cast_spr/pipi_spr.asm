SprMap_Cast_Pipi:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E1,$F8,$C2,$00 ; $00
	db $E1,$00,$C3,$00 ; $01
	db $E9,$F8,$D2,$00 ; $02
	db $E9,$00,$D3,$00 ; $03
	db $F1,$F8,$8E,$00 ; $04
	db $F1,$00,$8F,$00 ; $05
	db $F9,$F8,$9E,$00 ; $06
	db $F9,$00,$9F,$00 ; $07
.end:

