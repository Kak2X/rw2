SprMap_Cast_Cannon:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F4,$82,$00 ; $00
	db $F1,$FC,$83,$00 ; $01
	db $F1,$04,$84,$00 ; $02
	db $F9,$F4,$92,$00 ; $03
	db $F9,$FC,$93,$00 ; $04
	db $F9,$04,$94,$00 ; $05
.end:

