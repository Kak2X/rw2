SprMap_Press:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $B1,$FC,$81,$80 ; $00
	db $B9,$FC,$81,$80 ; $01
	db $C1,$FC,$81,$80 ; $02
	db $C9,$FC,$81,$80 ; $03
	db $D1,$FC,$81,$80 ; $04
	db $D9,$FC,$91,$80 ; $05
	db $E1,$FC,$81,$80 ; $06
	db $E9,$FC,$81,$80 ; $07
	db $F1,$F4,$A0,$80 ; $08
	db $F1,$FC,$A1,$80 ; $09
	db $F1,$04,$A2,$80 ; $0A
	db $F9,$F4,$B0,$80 ; $0B
	db $F9,$FC,$B1,$80 ; $0C
	db $F9,$04,$B2,$80 ; $0D
.end:

