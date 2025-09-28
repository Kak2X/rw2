SprMap_Cast_HardMan:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $E2,$F8,$C1,$00 ; $00
	db $E2,$00,$C2,$00 ; $01
	db $EA,$F0,$D0,$00 ; $02
	db $EA,$F8,$D1,$00 ; $03
	db $EA,$00,$D2,$00 ; $04
	db $EA,$08,$D3,$00 ; $05
	db $F2,$F0,$E0,$00 ; $06
	db $F2,$F8,$E1,$00 ; $07
	db $F2,$00,$E2,$00 ; $08
	db $F2,$08,$E3,$00 ; $09
	db $FA,$F0,$F0,$00 ; $0A
	db $FA,$F8,$F1,$00 ; $0B
	db $FA,$00,$F2,$00 ; $0C
	db $FA,$08,$F3,$00 ; $0D
.end:

