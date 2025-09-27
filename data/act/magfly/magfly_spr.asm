SprMap_MagFly0:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $F1,$F4,$80,$00 ; $00
	db $F1,$FC,$81,$00 ; $01
	db $F1,$04,$82,$00 ; $02
	db $F9,$F4,$90,$00 ; $03
	db $F9,$FC,$91,$00 ; $04
	db $F9,$04,$92,$00 ; $05
	db $01,$F8,$A0,$00 ; $06
	db $01,$00,$A1,$00 ; $07
.end:

SprMap_MagFly1:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $F1,$F4,$DD,$00 ; $00
	db $F1,$FC,$DE,$00 ; $01
	db $F1,$04,$DF,$00 ; $02
	db $F9,$F4,$ED,$00 ; $03
	db $F9,$FC,$EE,$00 ; $04
	db $F9,$04,$EF,$00 ; $05
	db $01,$F8,$FD,$00 ; $06
	db $01,$00,$FE,$00 ; $07
.end:

