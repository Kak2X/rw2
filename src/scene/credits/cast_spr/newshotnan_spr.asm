SprMap_Cast_NewShotnan:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $E9,$F9,$D7,$00 ; $00
	db $E9,$01,$D8,$00 ; $01
	db $F1,$F9,$E7,$00 ; $02
	db $F1,$01,$E8,$00 ; $03
	db $F9,$F9,$F7,$00 ; $04
	db $F9,$01,$F8,$00 ; $05
.end:

