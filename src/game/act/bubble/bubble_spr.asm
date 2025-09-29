SprMap_Bubble:
	db (.end-.start)/4 ; $01 OBJ
.start:
	db $FD,$FD,$69,$00 ; $00
.end:

SprMap_Bubble_Pop:
	db (.end-.start)/4 ; $01 OBJ
.start:
	db $F9,$FC,$6A,$00 ; $00
.end:

