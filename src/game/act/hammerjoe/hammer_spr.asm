SprMap_Hammer_Sw0:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $F4,$F4,$9F,$20 ; $00
	db $F4,$FC,$9E,$00 ; $01
	db $FC,$EC,$8F,$00 ; $02
	db $FC,$F4,$9D,$00 ; $03
	db $FC,$FC,$9D,$00 ; $04
.end:

SprMap_Hammer_Sw1:
	db (.end-.start)/4 ; $03 OBJ
.start:
	db $04,$F4,$9F,$60 ; $00
	db $04,$FC,$9E,$00 ; $01
	db $04,$04,$8F,$00 ; $02
.end:

SprMap_Hammer_Sw2:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $FC,$0C,$9D,$00 ; $00
	db $FC,$14,$9D,$00 ; $01
	db $FC,$1C,$8F,$00 ; $02
	db $04,$0C,$9E,$00 ; $03
	db $04,$14,$9F,$40 ; $04
.end:

SprMap_Hammer_Sw3:
	db (.end-.start)/4 ; $03 OBJ
.start:
	db $F4,$04,$8F,$00 ; $00
	db $F4,$0C,$9E,$00 ; $01
	db $F4,$14,$9F,$00 ; $02
.end:

SprMap_Hammer_Throw0:
	db (.end-.start)/4 ; $03 OBJ
.start:
	db $F9,$FC,$8F,$00 ; $00
	db $F9,$04,$AE,$00 ; $01
	db $F9,$0C,$AF,$00 ; $02
.end:

SprMap_Hammer_Throw1:
	db (.end-.start)/4 ; $03 OBJ
.start:
	db $F9,$FC,$8F,$00 ; $00
	db $F9,$04,$AE,$40 ; $01
	db $F9,$0C,$AF,$40 ; $02
.end:

