SprMap_Cast_HammerJoe:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$F3,$8A,$00 ; $00
	db $E1,$FB,$8B,$00 ; $01
	db $E1,$03,$8C,$00 ; $02
	db $E9,$F3,$8D,$00 ; $03
	db $E9,$FB,$8E,$00 ; $04
	db $E9,$03,$9C,$00 ; $05
	db $F1,$F3,$AA,$00 ; $06
	db $F1,$FB,$AB,$00 ; $07
	db $F1,$03,$AC,$00 ; $08
	db $F9,$F4,$BA,$00 ; $09
	db $F9,$FC,$BB,$00 ; $0A
	db $F9,$04,$BC,$00 ; $0B
.end:

