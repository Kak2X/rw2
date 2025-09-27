SprMap_RushJet:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F4,$50,$00 ; $00
	db $F1,$FC,$51,$00 ; $01
	db $F1,$04,$52,$00 ; $02
	db $F9,$F4,$53,$00 ; $03
	db $F9,$FC,$54,$00 ; $04
	db $F9,$04,$55,$00 ; $05
.end:

