SprMap_Cast_Yambow:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $F1,$FC,$C0,$00 ; $00
	db $F1,$04,$C1,$00 ; $01
	db $F9,$F4,$C2,$00 ; $02
	db $F9,$FC,$C3,$00 ; $03
	db $F9,$04,$C4,$00 ; $04
.end:

