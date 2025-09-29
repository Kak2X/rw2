SprMap_CannonShot:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F3,$F8,$87,$00 ; $00
	db $F3,$00,$97,$00 ; $01
	db $FB,$F8,$97,$60 ; $02
	db $FB,$00,$97,$40 ; $03
.end:

