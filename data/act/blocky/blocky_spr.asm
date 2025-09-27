SprMap_BlockyHead_Idle:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$C4,$00 ; $00
	db $F1,$00,$C5,$00 ; $01
	db $F9,$F8,$D4,$00 ; $02
	db $F9,$00,$D5,$00 ; $03
.end:

SprMap_BlockyHead_Hit:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$E4,$00 ; $00
	db $F1,$00,$E5,$00 ; $01
	db $F9,$F8,$F4,$00 ; $02
	db $F9,$00,$F5,$00 ; $03
.end:

SprMap_BlockyBody:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$C6,$00 ; $00
	db $F1,$00,$C7,$00 ; $01
	db $F9,$F8,$D6,$00 ; $02
	db $F9,$00,$D7,$00 ; $03
.end:

