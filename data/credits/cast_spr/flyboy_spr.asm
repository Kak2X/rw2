SprMap_Cast_FlyBoy:
	db (.end-.start)/4 ; $0B OBJ
.start:
	db $E1,$F4,$80,$00 ; $00
	db $E1,$FC,$81,$00 ; $01
	db $E1,$04,$82,$00 ; $02
	db $E9,$FC,$93,$00 ; $03
	db $E9,$04,$94,$00 ; $04
	db $E9,$0C,$95,$00 ; $05
	db $F1,$FC,$A3,$00 ; $06
	db $F1,$04,$A4,$00 ; $07
	db $F9,$F4,$B0,$00 ; $08
	db $F9,$FC,$B3,$00 ; $09
	db $F9,$04,$B2,$00 ; $0A
.end:

