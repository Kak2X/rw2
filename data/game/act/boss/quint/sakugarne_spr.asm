SprMap_QuintSakugarne_Jump:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E1,$F4,$8D,$00 ; $00
	db $E1,$FC,$8E,$00 ; $01
	db $E1,$04,$8F,$00 ; $02
	db $E9,$F8,$BE,$00 ; $03
	db $E9,$00,$BF,$00 ; $04
	db $F1,$F8,$CE,$00 ; $05
	db $F1,$00,$CF,$00 ; $06
	db $F9,$FC,$DF,$00 ; $07
.end:

SprMap_QuintSakugarne_Ground:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $E9,$F5,$8D,$00 ; $00
	db $E9,$FD,$8E,$00 ; $01
	db $E9,$05,$8F,$00 ; $02
	db $F1,$F9,$9E,$00 ; $03
	db $F1,$01,$9F,$00 ; $04
	db $F9,$FC,$AF,$00 ; $05
.end:

