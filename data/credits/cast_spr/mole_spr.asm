SprMap_Cast_Mole:
	db (.end-.start)/4 ; $03 OBJ
.start:
	db $E9,$FC,$89,$80 ; $00
	db $F1,$FC,$99,$80 ; $01
	db $F9,$FC,$A9,$80 ; $02
.end:

