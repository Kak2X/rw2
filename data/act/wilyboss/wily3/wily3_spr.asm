SprMap_Wily3p_SkullUp:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $D9,$E8,$90,$00 ; $00
	db $D9,$F0,$C5,$00 ; $01
	db $E1,$E8,$A0,$00 ; $02
	db $E1,$F0,$F4,$00 ; $03
.end:

SprMap_Wily3p_SkullDown:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $D7,$ED,$F8,$00 ; $00
	db $DF,$ED,$F5,$00 ; $01
	db $E1,$E0,$90,$00 ; $02
	db $E1,$E8,$C5,$00 ; $03
	db $E9,$E0,$A0,$00 ; $04
	db $E9,$E8,$F4,$00 ; $05
.end:

SprMap_Wily3p_Arm0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $E9,$F8,$CC,$00 ; $00
	db $E9,$00,$CD,$00 ; $01
	db $F1,$F8,$DC,$00 ; $02
	db $F1,$00,$DD,$00 ; $03
.end:

SprMap_Wily3p_Arm1:
	db (.end-.start)/4 ; $02 OBJ
.start:
	db $E9,$F8,$BD,$00 ; $00
	db $E9,$00,$BE,$00 ; $01
.end:

SprMap_Wily3p_Tail0:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $F1,$08,$EB,$00 ; $00
	db $F1,$10,$EC,$00 ; $01
	db $F9,$08,$FB,$00 ; $02
	db $F9,$10,$FC,$00 ; $03
	db $F9,$18,$FD,$00 ; $04
.end:

SprMap_Wily3p_Tail1:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E1,$08,$CE,$00 ; $00
	db $E1,$10,$CF,$00 ; $01
	db $E9,$08,$DE,$00 ; $02
	db $E9,$10,$DF,$00 ; $03
	db $F1,$08,$EE,$00 ; $04
	db $F1,$10,$EF,$00 ; $05
	db $F9,$08,$FE,$00 ; $06
	db $F9,$10,$FF,$00 ; $07
.end:

