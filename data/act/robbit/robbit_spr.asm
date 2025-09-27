SprMap_Robbit_Idle:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E1,$FC,$CB,$00 ; $00
	db $E9,$F4,$DA,$00 ; $01
	db $E9,$FC,$DB,$00 ; $02
	db $F1,$F4,$EA,$00 ; $03
	db $F1,$FC,$EB,$00 ; $04
	db $F1,$04,$EC,$00 ; $05
	db $F9,$F4,$FA,$00 ; $06
	db $F9,$FC,$FB,$00 ; $07
	db $F9,$04,$FC,$00 ; $08
.end:

SprMap_Robbit_Jump:
	db (.end-.start)/4 ; $0A OBJ
.start:
	db $E1,$F2,$CD,$00 ; $00
	db $E1,$FA,$CE,$00 ; $01
	db $E1,$02,$CF,$00 ; $02
	db $E9,$F2,$DD,$00 ; $03
	db $E9,$FA,$DE,$00 ; $04
	db $E9,$02,$DF,$00 ; $05
	db $F1,$F8,$EE,$00 ; $06
	db $F1,$00,$EF,$00 ; $07
	db $F9,$F8,$FE,$00 ; $08
	db $F9,$00,$FF,$00 ; $09
.end:

