SprMap_MagnetManShotH:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F2,$F8,$EC,$00 ; $00
	db $F2,$00,$ED,$00 ; $01
	db $FA,$F8,$EC,$40 ; $02
	db $FA,$00,$ED,$40 ; $03
.end:

SprMap_MagnetManShot_Unused_HV:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F2,$F8,$EE,$00 ; $00 ;X
	db $F2,$00,$EE,$20 ; $01 ;X
	db $FA,$F8,$EF,$00 ; $02 ;X
	db $FA,$00,$EF,$20 ; $03 ;X
.end:

SprMap_MagnetManShotV:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F2,$F8,$EF,$40 ; $00
	db $F2,$00,$EF,$60 ; $01
	db $FA,$F8,$EE,$40 ; $02
	db $FA,$00,$EE,$60 ; $03
.end:

