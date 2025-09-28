SprMap_WpnAr0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F8,$F8,$50,$00 ; $00
	db $F8,$00,$51,$00 ; $01
	db $00,$F8,$52,$00 ; $02
	db $00,$00,$53,$00 ; $03
.end:

SprMap_WpnAr1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F8,$F8,$54,$00 ; $00
	db $F8,$00,$55,$00 ; $01
	db $00,$F8,$56,$00 ; $02
	db $00,$00,$57,$00 ; $03
.end:

; [TCRF] Unused, by mistake.
SprMap_WpnAr2:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F8,$F8,$58,$00 ; $00 ;X
	db $F8,$00,$59,$00 ; $01 ;X
	db $00,$F8,$5A,$00 ; $02 ;X
	db $00,$00,$5B,$00 ; $03 ;X
.end: