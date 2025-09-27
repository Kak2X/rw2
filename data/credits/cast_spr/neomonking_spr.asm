SprMap_Cast_NeoMonking:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$FC,$B1,$00 ; $00
	db $EB,$F4,$B0,$00 ; $01
	db $EB,$04,$B2,$00 ; $02
	db $F1,$FC,$C1,$00 ; $03
	db $F3,$F4,$C0,$00 ; $04
	db $F3,$04,$C2,$00 ; $05
	db $F9,$F4,$D0,$00 ; $06
	db $F9,$FC,$D1,$00 ; $07
	db $F9,$04,$D2,$00 ; $08
.end:

