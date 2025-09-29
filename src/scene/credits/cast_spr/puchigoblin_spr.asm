SprMap_Cast_PuchiGoblin:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$8B,$00 ; $00
	db $F1,$00,$8B,$20 ; $01
	db $F9,$F8,$9B,$00 ; $02
	db $F9,$00,$9B,$20 ; $03
.end:

