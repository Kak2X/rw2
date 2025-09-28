SprMap_Cast_Telly:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$C1,$00 ; $00
	db $F1,$00,$C1,$20 ; $01
	db $F9,$F8,$C1,$40 ; $02
	db $F9,$00,$C1,$60 ; $03
.end: