SprMap_BeeHive:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F4,$F4,$94,$00 ; $00
	db $F4,$FC,$95,$00 ; $01
	db $F4,$04,$94,$20 ; $02
	db $FC,$F4,$A4,$00 ; $03
	db $FC,$FC,$A5,$00 ; $04
	db $FC,$04,$A4,$20 ; $05
.end:

