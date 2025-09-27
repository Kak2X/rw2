SprMap_HariHarry_Idle:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$D0,$00 ; $00
	db $E9,$FC,$D1,$00 ; $01
	db $E9,$04,$D2,$00 ; $02
	db $F1,$F4,$E0,$00 ; $03
	db $F1,$FC,$E1,$00 ; $04
	db $F1,$04,$E2,$00 ; $05
	db $F9,$F4,$F0,$00 ; $06
	db $F9,$FC,$F1,$00 ; $07
	db $F9,$04,$F2,$00 ; $08
.end:

SprMap_HariHarry_Shoot:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F4,$E3,$00 ; $00
	db $F1,$FC,$E4,$00 ; $01
	db $F1,$04,$E8,$00 ; $02
	db $F9,$F4,$F3,$00 ; $03
	db $F9,$FC,$F4,$00 ; $04
	db $F9,$04,$F8,$00 ; $05
.end:

SprMap_HariHarry_Roll0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$C6,$00 ; $00
	db $F1,$00,$C7,$00 ; $01
	db $F9,$F8,$D6,$00 ; $02
	db $F9,$00,$D7,$00 ; $03
.end:

SprMap_HariHarry_Roll1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$E6,$00 ; $00
	db $F1,$00,$E7,$00 ; $01
	db $F9,$F8,$F6,$00 ; $02
	db $F9,$00,$F7,$00 ; $03
.end:

