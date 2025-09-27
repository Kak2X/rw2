SprMap_Wily3MetU:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$C4,$00 ; $00
	db $F1,$00,$C4,$20 ; $01
	db $F9,$F8,$D4,$00 ; $02
	db $F9,$00,$D4,$20 ; $03
.end:

SprMap_Wily3MetD:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$D4,$40 ; $00
	db $F1,$00,$D4,$60 ; $01
	db $F9,$F8,$C4,$40 ; $02
	db $F9,$00,$C4,$60 ; $03
.end:

