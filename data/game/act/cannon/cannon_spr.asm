SprMap_Cannon_Closed:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F4,$82,$00 ; $00
	db $F1,$FC,$83,$00 ; $01
	db $F1,$04,$84,$00 ; $02
	db $F9,$F4,$92,$00 ; $03
	db $F9,$FC,$93,$00 ; $04
	db $F9,$04,$94,$00 ; $05
.end:

SprMap_Cannon_Opening0:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F4,$A2,$00 ; $00
	db $F1,$FC,$A3,$00 ; $01
	db $F1,$04,$84,$00 ; $02
	db $F9,$F4,$B2,$00 ; $03
	db $F9,$FC,$B3,$00 ; $04
	db $F9,$04,$94,$00 ; $05
.end:

SprMap_Cannon_Opening1:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F4,$A4,$00 ; $00
	db $F1,$FC,$A5,$00 ; $01
	db $F1,$04,$84,$00 ; $02
	db $F9,$F4,$B4,$00 ; $03
	db $F9,$FC,$B5,$00 ; $04
	db $F9,$04,$94,$00 ; $05
.end:

SprMap_Cannon_Open:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F4,$85,$00 ; $00
	db $F1,$FC,$86,$00 ; $01
	db $F1,$04,$84,$00 ; $02
	db $F9,$F4,$95,$00 ; $03
	db $F9,$FC,$96,$00 ; $04
	db $F9,$04,$94,$00 ; $05
.end:

