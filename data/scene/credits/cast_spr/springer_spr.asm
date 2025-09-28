SprMap_Cast_Springer:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E1,$F0,$85,$00 ; $00
	db $E1,$F8,$86,$00 ; $01
	db $E9,$F0,$95,$00 ; $02
	db $E9,$F8,$96,$00 ; $03
	db $E9,$00,$97,$00 ; $04
	db $F1,$F8,$A6,$00 ; $05
	db $F1,$00,$A7,$00 ; $06
	db $F9,$F8,$B6,$00 ; $07
	db $F9,$00,$B7,$00 ; $08
.end:

