SprMap_Cast_GiantSpringer:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $D9,$E7,$B3,$00 ; $00
	db $D9,$EF,$B4,$00 ; $01
	db $D9,$F7,$B5,$00 ; $02
	db $E1,$E7,$C3,$00 ; $03
	db $E1,$EF,$C4,$00 ; $04
	db $E1,$F7,$C5,$00 ; $05
	db $E9,$EA,$D3,$00 ; $06
	db $E9,$F2,$D4,$00 ; $07
	db $E9,$FA,$D5,$00 ; $08
	db $F1,$F3,$D6,$00 ; $09
	db $F1,$FB,$E3,$00 ; $0A
	db $F9,$F4,$F0,$00 ; $0B
	db $F9,$FC,$F1,$00 ; $0C
	db $F9,$04,$F2,$00 ; $0D
.end:

