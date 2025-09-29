SprMap_Cast_Scworm:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $E9,$F8,$8A,$00 ; $00
	db $F1,$F8,$9A,$00 ; $01
	db $F1,$00,$8C,$00 ; $02
	db $F9,$F8,$98,$00 ; $03
	db $F9,$00,$99,$00 ; $04
.end:

