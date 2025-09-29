SprMap_GroundExpl0:
	db (.end-.start)/4 ; $01 OBJ
.start:
	db $FC,$FC,$50,$00 ; $00
.end:

SprMap_GroundExpl1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F8,$F8,$51,$00 ; $00
	db $F8,$00,$52,$00 ; $01
	db $00,$F8,$52,$60 ; $02
	db $00,$00,$51,$60 ; $03
.end:

SprMap_GroundExpl2:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $F4,$F8,$53,$00 ; $00
	db $F4,$00,$54,$00 ; $01
	db $FC,$F4,$55,$00 ; $02
	db $FC,$FC,$56,$00 ; $03
	db $FC,$04,$55,$60 ; $04
	db $04,$F8,$54,$60 ; $05
	db $04,$00,$53,$60 ; $06
.end:

