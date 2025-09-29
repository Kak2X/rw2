SprMap_Cast_CrashMan:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$D4,$00 ; $00
	db $E9,$FC,$D5,$00 ; $01
	db $E9,$04,$D6,$00 ; $02
	db $F1,$F4,$E4,$00 ; $03
	db $F1,$FC,$E5,$00 ; $04
	db $F1,$04,$E6,$00 ; $05
	db $F9,$F4,$F4,$00 ; $06
	db $F9,$FC,$F5,$00 ; $07
	db $F9,$04,$F6,$00 ; $08
.end:

