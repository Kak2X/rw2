SprMap_WoodManLeafRise:
	db (.end-.start)/4 ; $02 OBJ
.start:
	db $F9,$F8,$C8,$00 ; $00
	db $F9,$00,$C9,$00 ; $01
.end:

SprMap_WoodManLeafFall:
	db (.end-.start)/4 ; $02 OBJ
.start:
	db $F1,$FC,$D8,$00 ; $00
	db $F9,$FC,$E8,$00 ; $01
.end:
