SprMap_Yambow0:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $F1,$FC,$C0,$00 ; $00
	db $F1,$04,$C1,$00 ; $01
	db $F9,$F4,$C2,$00 ; $02
	db $F9,$FC,$C3,$00 ; $03
	db $F9,$04,$C4,$00 ; $04
.end:

SprMap_Yambow1:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F4,$C5,$00 ; $00
	db $F1,$FC,$AD,$00 ; $01
	db $F1,$04,$DC,$00 ; $02
	db $F9,$F4,$B1,$00 ; $03
	db $F9,$FC,$FC,$00 ; $04
	db $F9,$04,$FF,$00 ; $05
.end:

