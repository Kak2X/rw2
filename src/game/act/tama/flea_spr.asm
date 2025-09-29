SprMap_TamaFlea_Stand:
	db (.end-.start)/4 ; $01 OBJ
.start:
	db $F9,$FC,$E4,$00 ; $00
.end:

SprMap_TamaFlea_Jump:
	db (.end-.start)/4 ; $02 OBJ
.start:
	db $F1,$FC,$E3,$00 ; $00
	db $F9,$FC,$F3,$00 ; $01
.end:

