SprMap_Shotman_Low:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$D8,$00 ; $00
	db $E9,$FC,$C9,$00 ; $01
	db $E9,$04,$CA,$00 ; $02
	db $F1,$F4,$E8,$00 ; $03
	db $F1,$FC,$E9,$00 ; $04
	db $F1,$04,$EA,$00 ; $05
	db $F9,$F4,$F8,$00 ; $06
	db $F9,$FC,$F9,$00 ; $07
	db $F9,$04,$FA,$00 ; $08
.end:

SprMap_Shotman_Adjust:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$CB,$00 ; $00
	db $E9,$FC,$CC,$00 ; $01
	db $E9,$04,$CD,$00 ; $02
	db $F1,$F4,$DB,$00 ; $03
	db $F1,$FC,$DC,$00 ; $04
	db $F1,$04,$DD,$00 ; $05
	db $F9,$F4,$F8,$00 ; $06
	db $F9,$FC,$F9,$00 ; $07
	db $F9,$04,$FA,$00 ; $08
.end:

SprMap_Shotman_High:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$EB,$00 ; $00
	db $E9,$FC,$EC,$00 ; $01
	db $E9,$04,$ED,$00 ; $02
	db $F1,$F4,$FB,$00 ; $03
	db $F1,$FC,$FC,$00 ; $04
	db $F1,$04,$FD,$00 ; $05
	db $F9,$F4,$F8,$00 ; $06
	db $F9,$FC,$F9,$00 ; $07
	db $F9,$04,$FA,$00 ; $08
.end:

