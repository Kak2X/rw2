SprMap_Telly0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$C1,$00 ; $00
	db $F1,$00,$C1,$20 ; $01
	db $F9,$F8,$C1,$40 ; $02
	db $F9,$00,$C1,$60 ; $03
.end:

SprMap_Telly1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$D0,$00 ; $00
	db $F1,$00,$D1,$00 ; $01
	db $F9,$F8,$D0,$40 ; $02
	db $F9,$00,$D1,$40 ; $03
.end:

SprMap_Telly2:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$E6,$00 ; $00
	db $F1,$00,$C0,$20 ; $01
	db $F9,$F8,$E6,$40 ; $02
	db $F9,$00,$C0,$60 ; $03
.end:

SprMap_Telly3:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$C0,$00 ; $00
	db $F1,$00,$C0,$20 ; $01
	db $F9,$F8,$C0,$40 ; $02
	db $F9,$00,$C0,$60 ; $03
.end:

SprMap_Telly4:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$C0,$00 ; $00
	db $F1,$00,$E6,$20 ; $01
	db $F9,$F8,$C0,$40 ; $02
	db $F9,$00,$E6,$60 ; $03
.end:

SprMap_Telly5:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F8,$D1,$20 ; $00
	db $F1,$00,$D0,$20 ; $01
	db $F9,$F8,$D1,$60 ; $02
	db $F9,$00,$D0,$60 ; $03
.end:

