SprMap_Cast_PieroBot:
	db (.end-.start)/4 ; $12 OBJ
.start:
	db $D1,$F4,$8C,$00 ; $00
	db $D1,$FC,$8D,$00 ; $01
	db $D1,$04,$8E,$00 ; $02
	db $D9,$F4,$9C,$00 ; $03
	db $D9,$FC,$9D,$00 ; $04
	db $D9,$04,$9E,$00 ; $05
	db $E1,$F4,$AC,$00 ; $06
	db $E1,$FC,$AD,$00 ; $07
	db $E1,$04,$AE,$00 ; $08
	db $E9,$F4,$C0,$00 ; $09
	db $E9,$FC,$C1,$00 ; $0A
	db $E9,$04,$C0,$20 ; $0B
	db $F1,$F4,$D0,$00 ; $0C
	db $F1,$FC,$D1,$00 ; $0D
	db $F1,$04,$D0,$20 ; $0E
	db $F9,$F4,$C0,$40 ; $0F
	db $F9,$FC,$C1,$40 ; $10
	db $F9,$04,$C0,$60 ; $11
.end:

