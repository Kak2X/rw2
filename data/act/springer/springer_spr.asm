SprMap_Springer_Idle:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$83,$00 ; $00
	db $F1,$00,$84,$00 ; $01
	db $F9,$F8,$93,$00 ; $02
	db $F9,$00,$94,$00 ; $03
.end:

SprMap_Springer_Out2:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $E9,$F8,$8A,$00 ; $00
	db $E9,$00,$8B,$00 ; $01
	db $F1,$F8,$9A,$00 ; $02
	db $F1,$00,$9B,$00 ; $03
	db $F9,$F8,$AA,$00 ; $04
	db $F9,$00,$AB,$00 ; $05
.end:

SprMap_Springer_Out1:
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

SprMap_Springer_Out3:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E1,$00,$86,$20 ; $00
	db $E1,$08,$85,$20 ; $01
	db $E9,$F8,$97,$20 ; $02
	db $E9,$00,$96,$20 ; $03
	db $E9,$08,$95,$20 ; $04
	db $F1,$F8,$A7,$20 ; $05
	db $F1,$00,$A6,$20 ; $06
	db $F9,$F8,$B7,$20 ; $07
	db $F9,$00,$B6,$20 ; $08
.end:

