SprMap_ExtraLife:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$4D,$00 ; $00
	db $F1,$00,$4D,$20 ; $01
	db $F9,$F8,$4E,$00 ; $02
	db $F9,$00,$4E,$20 ; $03
.end:

