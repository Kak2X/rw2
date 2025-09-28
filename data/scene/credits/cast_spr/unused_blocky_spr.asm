; This one is cut off on top of being unused, preventing the bottom block from being drawn.
; The topmost block is also drawn above the screen, so you can't see it.
SprMap_Cast_Unused_Blocky:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $C1,$F8,$C6,$00 ; $00 ;X
	db $C1,$00,$C7,$00 ; $01 ;X
	db $C9,$F8,$D6,$00 ; $02 ;X
	db $C9,$00,$D7,$00 ; $03 ;X
	db $D1,$F8,$C6,$00 ; $04 ;X
	db $D1,$00,$C7,$00 ; $05 ;X
	db $D9,$F8,$D6,$00 ; $06 ;X
	db $D9,$00,$D7,$00 ; $07 ;X
	db $E1,$F8,$C4,$00 ; $08 ;X
	db $E1,$00,$C5,$00 ; $09 ;X
	db $E9,$F8,$D4,$00 ; $0A ;X
	db $E9,$00,$D5,$00 ; $0B ;X
.end:
	db $F1,$F8,$C6,$00 ; $0C ;X
	db $F1,$00,$C7,$00 ; $0D ;X
	db $F9,$F8,$D6,$00 ; $0E ;X
	db $F9,$00,$D7,$00 ; $0F ;X

