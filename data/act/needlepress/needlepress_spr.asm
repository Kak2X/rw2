SprMap_NeedlePress0:
	db (.end-.start)/4 ; $02 OBJ
.start:
	db $F9,$F8,$A1,$00 ; $00
	db $F9,$00,$89,$00 ; $01
.end:

SprMap_NeedlePress1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$81,$00 ; $00
	db $F1,$00,$88,$00 ; $01
	db $F9,$F8,$91,$00 ; $02
	db $F9,$00,$98,$00 ; $03
.end:

SprMap_NeedlePress2:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E1,$F8,$80,$00 ; $00
	db $E1,$00,$E5,$00 ; $01
	db $E9,$F8,$90,$00 ; $02
	db $E9,$00,$F5,$00 ; $03
	db $F1,$F8,$A0,$00 ; $04
	db $F1,$00,$E9,$00 ; $05
	db $F9,$F8,$B0,$00 ; $06
	db $F9,$00,$F9,$00 ; $07
.end:

