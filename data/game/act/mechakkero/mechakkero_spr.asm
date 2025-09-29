SprMap_Mechakkero_Ground:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $F1,$F8,$8D,$00 ; $00
	db $F1,$00,$8E,$00 ; $01
	db $F1,$08,$8F,$00 ; $02
	db $F9,$F8,$9D,$00 ; $03
	db $F9,$00,$9E,$00 ; $04
.end:

SprMap_Mechakkero_GroundEye:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $F1,$F8,$AA,$00 ; $00
	db $F1,$00,$AB,$00 ; $01
	db $F1,$08,$AC,$00 ; $02
	db $F9,$F8,$BA,$00 ; $03
	db $F9,$00,$BB,$00 ; $04
.end:

SprMap_Mechakkero_Jump:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E1,$F8,$AD,$00 ; $00
	db $E1,$00,$AE,$00 ; $01
	db $E9,$F8,$BD,$00 ; $02
	db $E9,$00,$BE,$00 ; $03
	db $F1,$FF,$CD,$00 ; $04
	db $F1,$07,$CE,$00 ; $05
	db $F9,$FF,$DD,$00 ; $06
	db $F9,$07,$DE,$00 ; $07
.end:

