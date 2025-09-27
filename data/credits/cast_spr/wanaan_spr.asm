SprMap_Cast_Wanaan:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E1,$F8,$CB,$80 ; $00
	db $E1,$00,$CC,$80 ; $01
	db $E9,$F8,$DB,$80 ; $02
	db $E9,$00,$DC,$80 ; $03
	db $F1,$F8,$EB,$80 ; $04
	db $F1,$00,$EC,$80 ; $05
	db $F9,$F8,$FB,$80 ; $06
	db $F9,$00,$FC,$80 ; $07
.end:

