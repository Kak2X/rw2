SprMap_Cast_WoodMan:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E9,$F0,$D0,$00 ; $00
	db $E9,$F8,$D1,$00 ; $01
	db $E9,$00,$D2,$00 ; $02
	db $E9,$08,$D3,$00 ; $03
	db $F1,$F0,$E0,$00 ; $04
	db $F1,$F8,$E1,$00 ; $05
	db $F1,$00,$E2,$00 ; $06
	db $F1,$08,$E3,$00 ; $07
	db $F9,$F0,$F0,$00 ; $08
	db $F9,$F8,$F1,$00 ; $09
	db $F9,$00,$F2,$00 ; $0A
	db $F9,$08,$F3,$00 ; $0B
.end:

