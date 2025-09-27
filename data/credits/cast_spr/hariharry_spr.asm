SprMap_Cast_HariHarry:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$D0,$00 ; $00
	db $E9,$FC,$D1,$00 ; $01
	db $E9,$04,$D2,$00 ; $02
	db $F1,$F4,$E0,$00 ; $03
	db $F1,$FC,$E1,$00 ; $04
	db $F1,$04,$E2,$00 ; $05
	db $F9,$F4,$F0,$00 ; $06
	db $F9,$FC,$F1,$00 ; $07
	db $F9,$04,$F2,$00 ; $08
.end:

