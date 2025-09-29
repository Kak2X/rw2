SprMap_Cast_NeoMet:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $EE,$F8,$B8,$00 ; $00
	db $EE,$00,$B9,$00 ; $01
	db $F6,$F5,$ED,$00 ; $02
	db $F6,$FD,$EE,$00 ; $03
	db $F6,$05,$EF,$00 ; $04
	db $FE,$F0,$FD,$00 ; $05
	db $FE,$F8,$FE,$00 ; $06
	db $FE,$00,$DB,$00 ; $07
.end:

