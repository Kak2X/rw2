SprMap_Warp:
	db (.end-.start)/4 ; $03 OBJ
.start:
	db $E9,$FC,$4F,$00 ; $00
	db $F1,$FC,$4F,$00 ; $01
	db $F9,$FC,$4F,$00 ; $02
.end:

SprMap_WarpLand3:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $E7,$FC,$64,$00 ; $00
	db $EF,$FC,$64,$00 ; $01
	db $F9,$F8,$65,$00 ; $02
	db $F9,$00,$65,$20 ; $03
.end:

SprMap_WarpLand2:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $EB,$FC,$64,$00 ; $00
	db $F1,$FC,$64,$00 ; $01
	db $F9,$F8,$65,$00 ; $02
	db $F9,$00,$65,$20 ; $03
.end:

SprMap_WarpLand1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $EF,$FC,$64,$00 ; $00
	db $F3,$FC,$64,$00 ; $01
	db $F9,$F8,$65,$00 ; $02
	db $F9,$00,$65,$20 ; $03
.end:

SprMap_WarpLand0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F3,$F8,$65,$00 ; $00
	db $F3,$00,$65,$20 ; $01
	db $F9,$F8,$65,$00 ; $02
	db $F9,$00,$65,$20 ; $03
.end:

