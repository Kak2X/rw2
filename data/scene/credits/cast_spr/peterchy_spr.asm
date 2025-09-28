SprMap_Cast_Peterchy:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$FC,$96,$00 ; $00
	db $F9,$F4,$A5,$00 ; $01
	db $F9,$FC,$A6,$00 ; $02
	db $F9,$04,$A5,$20 ; $03
.end:

