SprMap_Chibee_Expl0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F8,$F8,$A9,$00 ; $00
	db $F8,$00,$A9,$20 ; $01
	db $00,$F8,$A9,$40 ; $02
	db $00,$00,$A9,$60 ; $03
.end:

SprMap_Chibee_Expl1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F8,$F8,$A8,$00 ; $00
	db $F8,$00,$A8,$20 ; $01
	db $00,$F8,$A8,$40 ; $02
	db $00,$00,$A8,$60 ; $03
.end:

SprMap_Chibee_Expl2:
	db (.end-.start)/4 ; $01 OBJ
.start:
	db $FC,$FC,$A7,$00 ; $00
.end:

SprMap_Chibee_Unused_Expl3:
	db (.end-.start)/4 ; $01 OBJ
.start:
	db $FC,$FC,$A6,$00 ; $00 ;X
.end:

SprMap_Chibee_Fly0:
	db (.end-.start)/4 ; $03 OBJ
.start:
	db $F3,$FF,$99,$00 ; $00
	db $F9,$F8,$96,$00 ; $01
	db $F9,$00,$97,$00 ; $02
.end:

SprMap_Chibee_Fly1:
	db (.end-.start)/4 ; $02 OBJ
.start:
	db $F9,$F8,$96,$00 ; $00
	db $F9,$00,$97,$00 ; $01
.end:

