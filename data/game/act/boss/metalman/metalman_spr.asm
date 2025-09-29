SprMap_MetalMan_Intro1:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$D7,$00 ; $00
	db $E9,$FC,$D8,$00 ; $01
	db $E9,$04,$D9,$00 ; $02
	db $F1,$F4,$E7,$00 ; $03
	db $F1,$FC,$E8,$00 ; $04
	db $F1,$04,$E9,$00 ; $05
	db $F9,$F4,$F7,$00 ; $06
	db $F9,$FC,$F8,$00 ; $07
	db $F9,$04,$F9,$00 ; $08
.end:

SprMap_MetalMan_JumpU:
	db (.end-.start)/4 ; $0A OBJ
.start:
	db $E1,$F8,$CB,$00 ; $00
	db $E1,$00,$CC,$00 ; $01
	db $E9,$F0,$DA,$00 ; $02
	db $E9,$F8,$DB,$00 ; $03
	db $E9,$00,$DC,$00 ; $04
	db $E9,$08,$DD,$00 ; $05
	db $F1,$F8,$EB,$00 ; $06
	db $F1,$00,$EC,$00 ; $07
	db $F9,$F8,$FB,$00 ; $08
	db $F9,$00,$FC,$00 ; $09
.end:

SprMap_MetalMan_JumpD:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E1,$F8,$C2,$00 ; $00
	db $E1,$00,$C3,$00 ; $01
	db $E9,$F8,$D2,$00 ; $02
	db $E9,$00,$D3,$00 ; $03
	db $F1,$F8,$E2,$00 ; $04
	db $F1,$00,$E3,$00 ; $05
	db $F9,$F8,$F2,$00 ; $06
	db $F9,$00,$F3,$00 ; $07
.end:

SprMap_MetalMan_Walk0:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$D4,$00 ; $00
	db $E9,$FC,$D5,$00 ; $01
	db $E9,$04,$D6,$00 ; $02
	db $F1,$F4,$E4,$00 ; $03
	db $F1,$FC,$E5,$00 ; $04
	db $F1,$04,$E6,$00 ; $05
	db $F9,$F4,$F4,$00 ; $06
	db $F9,$FC,$F5,$00 ; $07
	db $F9,$04,$F6,$00 ; $08
.end:

SprMap_MetalMan_Walk1:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F4,$AD,$00 ; $00
	db $E9,$FC,$AE,$00 ; $01
	db $E9,$04,$AF,$00 ; $02
	db $F1,$F4,$BD,$00 ; $03
	db $F1,$FC,$BE,$00 ; $04
	db $F1,$04,$BF,$00 ; $05
	db $F9,$FC,$CE,$00 ; $06
	db $F9,$04,$CF,$00 ; $07
.end:

SprMap_MetalMan_Walk2:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$A4,$00 ; $00
	db $E9,$FC,$A5,$00 ; $01
	db $E9,$04,$A6,$00 ; $02
	db $F1,$F4,$B4,$00 ; $03
	db $F1,$FC,$B5,$00 ; $04
	db $F1,$04,$B6,$00 ; $05
	db $F9,$F4,$C4,$00 ; $06
	db $F9,$FC,$C5,$00 ; $07
	db $F9,$04,$C6,$00 ; $08
.end:

SprMap_MetalMan_JumpShoot:
	db (.end-.start)/4 ; $0A OBJ
.start:
	db $E5,$F4,$90,$00 ; $00
	db $E5,$FC,$91,$00 ; $01
	db $E5,$04,$92,$00 ; $02
	db $ED,$F4,$A0,$00 ; $03
	db $ED,$FC,$A1,$00 ; $04
	db $ED,$04,$A2,$00 ; $05
	db $F5,$F4,$B0,$00 ; $06
	db $F5,$FC,$B1,$00 ; $07
	db $F5,$04,$B2,$00 ; $08
	db $FD,$FC,$C1,$00 ; $09
.end:

SprMap_MetalMan_Intro2:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$A7,$00 ; $00
	db $E9,$FC,$A8,$00 ; $01
	db $E9,$04,$A9,$00 ; $02
	db $F1,$F4,$B7,$00 ; $03
	db $F1,$FC,$B8,$00 ; $04
	db $F1,$04,$B9,$00 ; $05
	db $F9,$F4,$C7,$00 ; $06
	db $F9,$FC,$C8,$00 ; $07
	db $F9,$04,$C9,$00 ; $08
.end:

SprMap_MetalMan_Idle:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$9A,$00 ; $00
	db $E9,$FC,$9B,$00 ; $01
	db $E9,$04,$9C,$00 ; $02
	db $F1,$F4,$AA,$00 ; $03
	db $F1,$FC,$AB,$00 ; $04
	db $F1,$04,$AC,$00 ; $05
	db $F9,$F4,$BA,$00 ; $06
	db $F9,$FC,$BB,$00 ; $07
	db $F9,$04,$BC,$00 ; $08
.end:

