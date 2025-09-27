SprMap_TamaBall:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F3,$F8,$E2,$00 ; $00
	db $F3,$00,$E2,$20 ; $01
	db $FB,$F8,$E2,$40 ; $02
	db $FB,$00,$E2,$60 ; $03
.end:

