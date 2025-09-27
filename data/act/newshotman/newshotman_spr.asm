SprMap_NewShotman_Idle0:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $E9,$F9,$D7,$00 ; $00
	db $E9,$01,$D8,$00 ; $01
	db $F1,$F9,$E7,$00 ; $02
	db $F1,$01,$E8,$00 ; $03
	db $F9,$F9,$F7,$00 ; $04
	db $F9,$01,$F8,$00 ; $05
.end:

SprMap_NewShotman_Idle1:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $E9,$F9,$D9,$00 ; $00
	db $E9,$01,$DA,$00 ; $01
	db $F1,$F9,$E9,$00 ; $02
	db $F1,$01,$EA,$00 ; $03
	db $F9,$F9,$F9,$00 ; $04
	db $F9,$01,$FA,$00 ; $05
.end:

SprMap_NewShotman_Shoot:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F9,$EB,$00 ; $00
	db $F1,$01,$EC,$00 ; $01
	db $F9,$F9,$FB,$00 ; $02
	db $F9,$01,$FC,$00 ; $03
.end:

