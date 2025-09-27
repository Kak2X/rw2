SprMap_HealthLg0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$74,$00 ; $00
	db $F1,$00,$74,$20 ; $01
	db $F9,$F8,$74,$40 ; $02
	db $F9,$00,$74,$60 ; $03
.end:

SprMap_HealthLg1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$6B,$00 ; $00
	db $F1,$00,$6B,$20 ; $01
	db $F9,$F8,$6B,$40 ; $02
	db $F9,$00,$6B,$60 ; $03
.end:

