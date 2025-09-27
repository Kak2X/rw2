SprMap_RushCoil_Idle:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F4,$50,$00 ; $00
	db $E9,$FC,$51,$00 ; $01
	db $F1,$F4,$52,$00 ; $02
	db $F1,$FC,$53,$00 ; $03
	db $F1,$04,$54,$00 ; $04
	db $F9,$F4,$55,$00 ; $05
	db $F9,$FC,$56,$00 ; $06
	db $F9,$04,$57,$00 ; $07
.end:

SprMap_RushCoil_Spring:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$50,$00 ; $00
	db $E9,$FC,$58,$00 ; $01
	db $E9,$04,$59,$00 ; $02
	db $F1,$F4,$52,$00 ; $03
	db $F1,$FC,$53,$00 ; $04
	db $F1,$04,$5A,$00 ; $05
	db $F9,$F4,$55,$00 ; $06
	db $F9,$FC,$56,$00 ; $07
	db $F9,$04,$57,$00 ; $08
.end:

