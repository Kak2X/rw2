SprMap_ETank:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$7C,$00 ; $00
	db $F1,$00,$7D,$00 ; $01
	db $F9,$F8,$7C,$40 ; $02
	db $F9,$00,$7D,$40 ; $03
.end:

