SprMap_Cast_TopMan:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$A0,$00 ; $00
	db $E9,$FC,$A1,$00 ; $01
	db $E9,$04,$A2,$00 ; $02
	db $F1,$F4,$B0,$00 ; $03
	db $F1,$FC,$B1,$00 ; $04
	db $F1,$04,$B2,$00 ; $05
	db $F9,$F4,$C0,$00 ; $06
	db $F9,$FC,$C1,$00 ; $07
	db $F9,$04,$C2,$00 ; $08
.end:

