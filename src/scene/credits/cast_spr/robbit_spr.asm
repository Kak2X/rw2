SprMap_Cast_Robbit:
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

