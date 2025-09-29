SprMap_Sakugarne:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E1,$F4,$50,$00 ; $00
	db $E1,$FC,$51,$00 ; $01
	db $E1,$04,$52,$00 ; $02
	db $E9,$F8,$53,$00 ; $03
	db $E9,$00,$54,$00 ; $04
	db $F1,$F8,$55,$00 ; $05
	db $F1,$00,$56,$00 ; $06
	db $F9,$FC,$57,$00 ; $07
.end:

