SprMap_PieroBot0:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$8C,$00 ; $00
	db $E9,$FC,$8D,$00 ; $01
	db $E9,$04,$8E,$00 ; $02
	db $F1,$F4,$9C,$00 ; $03
	db $F1,$FC,$9D,$00 ; $04
	db $F1,$04,$9E,$00 ; $05
	db $F9,$F4,$AC,$00 ; $06
	db $F9,$FC,$AD,$00 ; $07
	db $F9,$04,$AE,$00 ; $08
.end:

SprMap_PieroBot1:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$BC,$00 ; $00
	db $E9,$FC,$BD,$00 ; $01
	db $E9,$04,$BE,$00 ; $02
	db $F1,$F4,$CC,$00 ; $03
	db $F1,$FC,$CD,$00 ; $04
	db $F1,$04,$CE,$00 ; $05
	db $F9,$F4,$DC,$00 ; $06
	db $F9,$FC,$DD,$00 ; $07
	db $F9,$04,$DE,$00 ; $08
.end:

