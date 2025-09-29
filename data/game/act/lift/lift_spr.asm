SprMap_Lift:
	db (.end-.start)/4 ; $02 OBJ
.start:
	db $F9,$F8,$E0,$00 ; $00
	db $F9,$00,$E1,$00 ; $01
.end:

