SprMap_Pipi0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$C2,$00 ; $00
	db $F1,$00,$C3,$00 ; $01
	db $F9,$F8,$D2,$00 ; $02
	db $F9,$00,$D3,$00 ; $03
.end:

SprMap_Pipi1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$E2,$00 ; $00
	db $F1,$00,$E3,$00 ; $01
	db $F9,$F8,$F2,$00 ; $02
	db $F9,$00,$F3,$00 ; $03
.end:

