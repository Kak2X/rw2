SprMap_SpinTop0:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $ED,$F4,$C7,$00 ; $00
	db $ED,$FC,$C8,$00 ; $01
	db $ED,$04,$C9,$00 ; $02
	db $F5,$F4,$D7,$00 ; $03
	db $F5,$FC,$D8,$00 ; $04
	db $F5,$04,$D9,$00 ; $05
	db $FD,$FC,$CA,$00 ; $06
.end:

SprMap_SpinTop1:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $ED,$F4,$E7,$00 ; $00
	db $ED,$FC,$E8,$00 ; $01
	db $ED,$04,$E9,$00 ; $02
	db $F5,$F4,$F7,$00 ; $03
	db $F5,$FC,$F8,$00 ; $04
	db $F5,$04,$F9,$00 ; $05
	db $FD,$FC,$EA,$00 ; $06
.end:

SprMap_SpinTop2:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $ED,$F4,$E9,$20 ; $00
	db $ED,$FC,$E8,$20 ; $01
	db $ED,$04,$E7,$20 ; $02
	db $F5,$F4,$F9,$20 ; $03
	db $F5,$FC,$F8,$20 ; $04
	db $F5,$04,$F7,$20 ; $05
	db $FD,$FC,$EA,$20 ; $06
.end:

SprMap_SpinTop3:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $ED,$F4,$C9,$20 ; $00
	db $ED,$FC,$C8,$20 ; $01
	db $ED,$04,$C7,$20 ; $02
	db $F5,$F4,$D9,$20 ; $03
	db $F5,$FC,$D8,$20 ; $04
	db $F5,$04,$D7,$20 ; $05
	db $FD,$FC,$CA,$20 ; $06
.end:

