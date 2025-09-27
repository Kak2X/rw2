SprMap_NeoMet_Hide:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $F6,$F8,$B8,$00 ; $00
	db $F6,$00,$B9,$00 ; $01
	db $FE,$F6,$C8,$00 ; $02
	db $FE,$FE,$C9,$00 ; $03
	db $FE,$06,$B6,$00 ; $04
.end:

SprMap_NeoMet_Trs0:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $F2,$F8,$B8,$00 ; $00
	db $F2,$00,$B9,$00 ; $01
	db $FA,$F6,$D8,$00 ; $02
	db $FA,$FE,$D9,$00 ; $03
	db $FA,$06,$B7,$00 ; $04
.end:

SprMap_NeoMet_Trs1:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $EE,$F8,$B8,$00 ; $00
	db $EE,$00,$B9,$00 ; $01
	db $F6,$F6,$CA,$00 ; $02
	db $F6,$FE,$CB,$00 ; $03
	db $F6,$06,$CC,$00 ; $04
	db $FE,$F8,$DA,$00 ; $05
	db $FE,$00,$DB,$00 ; $06
.end:

SprMap_NeoMet_Walk0:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $EE,$F8,$B8,$00 ; $00
	db $EE,$00,$B9,$00 ; $01
	db $F6,$F7,$EA,$00 ; $02
	db $F6,$FF,$EB,$00 ; $03
	db $F6,$07,$EC,$00 ; $04
	db $FE,$F8,$FA,$00 ; $05
	db $FE,$00,$FB,$00 ; $06
.end:

SprMap_NeoMet_Walk1:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $EE,$F8,$B8,$00 ; $00
	db $EE,$00,$B9,$00 ; $01
	db $F6,$F5,$ED,$00 ; $02
	db $F6,$FD,$EE,$00 ; $03
	db $F6,$05,$EF,$00 ; $04
	db $FE,$F0,$FD,$00 ; $05
	db $FE,$F8,$FE,$00 ; $06
	db $FE,$00,$DB,$00 ; $07
.end:

