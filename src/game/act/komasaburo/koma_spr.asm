SprMap_Koma0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$89,$00 ; $00
	db $F1,$00,$8A,$00 ; $01
	db $F9,$F8,$99,$00 ; $02
	db $F9,$00,$9A,$00 ; $03
.end:

SprMap_Koma1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$8B,$00 ; $00
	db $F1,$00,$8C,$00 ; $01
	db $F9,$F8,$9B,$00 ; $02
	db $F9,$00,$9C,$00 ; $03
.end:

