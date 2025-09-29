SprMap_WpnMgH:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F8,$F8,$5C,$00 ; $00
	db $F8,$00,$5D,$00 ; $01
	db $00,$F8,$5C,$40 ; $02
	db $00,$00,$5D,$40 ; $03
.end:

SprMap_WpnMgU:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F8,$F8,$5E,$00 ; $00
	db $F8,$00,$5E,$20 ; $01
	db $00,$F8,$5F,$00 ; $02
	db $00,$00,$5F,$20 ; $03
.end:

SprMap_WpnMgD:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F8,$F8,$5F,$40 ; $00
	db $F8,$00,$5F,$60 ; $01
	db $00,$F8,$5E,$40 ; $02
	db $00,$00,$5E,$60 ; $03
.end: