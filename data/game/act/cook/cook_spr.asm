SprMap_Cook2:
	db (.end-.start)/4 ; $0A OBJ
.start:
	db $E1,$F4,$C7,$00 ; $00
	db $E1,$FC,$C8,$00 ; $01
	db $E1,$04,$C9,$00 ; $02
	db $E9,$F4,$D7,$00 ; $03
	db $E9,$FC,$D8,$00 ; $04
	db $E9,$04,$D9,$00 ; $05
	db $F1,$F4,$E4,$00 ; $06
	db $F1,$FC,$E5,$00 ; $07
	db $F9,$F4,$F4,$00 ; $08
	db $F9,$FC,$F5,$00 ; $09
.end:

SprMap_Cook1:
	db (.end-.start)/4 ; $0D OBJ
.start:
	db $E1,$F4,$C7,$00 ; $00
	db $E1,$FC,$C8,$00 ; $01
	db $E1,$04,$C9,$00 ; $02
	db $E9,$F4,$D7,$00 ; $03
	db $E9,$FC,$D8,$00 ; $04
	db $E9,$04,$D9,$00 ; $05
	db $F1,$F4,$E7,$00 ; $06
	db $F1,$FC,$E8,$00 ; $07
	db $F1,$04,$E9,$00 ; $08
	db $F9,$EC,$F6,$00 ; $09
	db $F9,$F4,$F7,$00 ; $0A
	db $F9,$FC,$F8,$00 ; $0B
	db $F9,$04,$F9,$00 ; $0C
.end:

SprMap_Cook3:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$F4,$C7,$00 ; $00
	db $E1,$FC,$C8,$00 ; $01
	db $E1,$04,$C9,$00 ; $02
	db $E9,$F4,$D7,$00 ; $03
	db $E9,$FC,$D8,$00 ; $04
	db $E9,$04,$D9,$00 ; $05
	db $F1,$F4,$C4,$00 ; $06
	db $F1,$FC,$C5,$00 ; $07
	db $F1,$04,$C6,$00 ; $08
	db $F9,$EC,$D4,$00 ; $09
	db $F9,$F4,$D5,$00 ; $0A
	db $F9,$04,$D6,$00 ; $0B
.end:

