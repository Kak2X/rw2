SprMap_Egg:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F7,$F8,$8E,$00 ; $00
	db $F7,$00,$8F,$00 ; $01
	db $FF,$F8,$9E,$00 ; $02
	db $FF,$00,$9F,$00 ; $03
.end:

