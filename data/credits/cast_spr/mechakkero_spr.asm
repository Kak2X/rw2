SprMap_Cast_Mechakkero:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $F1,$F8,$8D,$00 ; $00
	db $F1,$00,$8E,$00 ; $01
	db $F1,$08,$8F,$00 ; $02
	db $F9,$F8,$9D,$00 ; $03
	db $F9,$00,$9E,$00 ; $04
.end:

