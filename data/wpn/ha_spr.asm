SprMap_WpnHa:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F8,$F8,$5B,$00 ; $00
	db $F8,$00,$5C,$00 ; $01
	db $00,$F8,$5D,$00 ; $02
	db $00,$00,$5E,$00 ; $03
.end: