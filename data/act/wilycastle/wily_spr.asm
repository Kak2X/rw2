SprMap_Wily_Stand:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$A5,$00 ; $00
	db $E9,$FC,$A6,$00 ; $01
	db $E9,$04,$A7,$00 ; $02
	db $F1,$F4,$B5,$00 ; $03
	db $F1,$FC,$B6,$00 ; $04
	db $F1,$04,$B7,$00 ; $05
	db $F9,$F4,$AF,$00 ; $06
	db $F9,$FC,$BF,$00 ; $07
	db $F9,$04,$ED,$00 ; $08
.end:

SprMap_Wily_Walk:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$A5,$00 ; $00
	db $E9,$FC,$A6,$00 ; $01
	db $E9,$04,$A7,$00 ; $02
	db $F1,$F4,$B5,$00 ; $03
	db $F1,$FC,$B6,$00 ; $04
	db $F1,$04,$B7,$00 ; $05
	db $F9,$F4,$D8,$00 ; $06
	db $F9,$FC,$E8,$00 ; $07
	db $F9,$04,$F9,$00 ; $08
.end:

SprMap_Wily_Unused_Eyebrows:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$A5,$00 ; $00 ;X
	db $E9,$FC,$B4,$00 ; $01 ;X
	db $E9,$04,$A7,$00 ; $02 ;X
	db $F1,$F4,$B5,$00 ; $03 ;X
	db $F1,$FC,$B6,$00 ; $04 ;X
	db $F1,$04,$B7,$00 ; $05 ;X
	db $F9,$F4,$AF,$00 ; $06 ;X
	db $F9,$FC,$BF,$00 ; $07 ;X
	db $F9,$04,$ED,$00 ; $08 ;X
.end:

