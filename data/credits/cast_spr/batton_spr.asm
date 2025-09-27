SprMap_Cast_Batton:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F5,$83,$00 ; $00
	db $F1,$FD,$84,$00 ; $01
	db $F1,$05,$85,$00 ; $02
	db $F9,$F5,$93,$00 ; $03
	db $F9,$FD,$94,$00 ; $04
	db $F9,$05,$95,$00 ; $05
.end:

