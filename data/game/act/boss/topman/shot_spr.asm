SprMap_TopManShot0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$80,$00 ; $00
	db $F1,$00,$81,$00 ; $01
	db $F9,$F8,$90,$00 ; $02
	db $F9,$00,$91,$00 ; $03
.end:

SprMap_TopManShot1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$82,$00 ; $00
	db $F1,$00,$83,$00 ; $01
	db $F9,$F8,$92,$00 ; $02
	db $F9,$00,$93,$00 ; $03
.end:

SprMap_TopManShot_Unused_2:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F9,$81,$20 ; $00 ;X
	db $F1,$01,$80,$20 ; $01 ;X
	db $F9,$F9,$91,$20 ; $02 ;X
	db $F9,$01,$90,$20 ; $03 ;X
.end:

