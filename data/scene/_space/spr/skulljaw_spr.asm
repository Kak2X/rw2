SprMap_ScSkullJaw:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E1,$F8,$4E,$00 ; $00
	db $E9,$F8,$5E,$00 ; $01
	db $E9,$00,$5F,$00 ; $02
	db $F1,$F0,$6D,$00 ; $03
	db $F1,$F8,$6E,$00 ; $04
	db $F1,$00,$6F,$00 ; $05
	db $F9,$F0,$7D,$00 ; $06
	db $F9,$F8,$7E,$00 ; $07
	db $F9,$00,$7F,$00 ; $08
.end: