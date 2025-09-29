SprMap_Cast_Matasaburo:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $E1,$F8,$C8,$00 ; $00
	db $E1,$00,$C9,$00 ; $01
	db $E9,$F0,$D7,$00 ; $02
	db $E9,$F8,$D8,$00 ; $03
	db $E9,$00,$D9,$00 ; $04
	db $E9,$08,$DA,$00 ; $05
	db $F1,$F0,$E7,$00 ; $06
	db $F1,$F8,$E8,$00 ; $07
	db $F1,$00,$E9,$00 ; $08
	db $F1,$08,$EA,$00 ; $09
	db $F9,$F0,$F7,$00 ; $0A
	db $F9,$F8,$F8,$00 ; $0B
	db $F9,$00,$F9,$00 ; $0C
	db $F9,$08,$FA,$00 ; $0D
.end:

