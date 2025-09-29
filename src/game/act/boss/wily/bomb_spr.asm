SprMap_WilyBomb:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$84,$00 ; $00
	db $F1,$00,$84,$20 ; $01
	db $F9,$F8,$94,$00 ; $02
	db $F9,$00,$94,$20 ; $03
.end:

