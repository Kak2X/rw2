SprMap_TopMan_Idle:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F5,$A0,$00 ; $00
	db $E9,$FD,$A1,$00 ; $01
	db $E9,$05,$A2,$00 ; $02
	db $F1,$F5,$B0,$00 ; $03
	db $F1,$FD,$B1,$00 ; $04
	db $F1,$05,$B2,$00 ; $05
	db $F9,$F5,$C0,$00 ; $06
	db $F9,$FD,$C1,$00 ; $07
	db $F9,$05,$C2,$00 ; $08
.end:

SprMap_TopMan_Throw0:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F3,$A0,$00 ; $00
	db $E9,$FB,$A1,$00 ; $01
	db $E9,$03,$A5,$00 ; $02
	db $F1,$F3,$B0,$00 ; $03
	db $F1,$FB,$B4,$00 ; $04
	db $F1,$03,$B5,$00 ; $05
	db $F9,$F3,$C3,$00 ; $06
	db $F9,$FB,$C4,$00 ; $07
	db $F9,$03,$C5,$00 ; $08
.end:

SprMap_TopMan_Throw1:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F5,$D0,$00 ; $00
	db $E9,$FD,$A1,$00 ; $01
	db $E9,$05,$A2,$00 ; $02
	db $F1,$F5,$E0,$00 ; $03
	db $F1,$FD,$B1,$00 ; $04
	db $F1,$05,$B2,$00 ; $05
	db $F9,$F5,$F0,$00 ; $06
	db $F9,$FD,$C1,$00 ; $07
	db $F9,$05,$C2,$00 ; $08
.end:

SprMap_TopMan_Spin0:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$D3,$20 ; $00
	db $E9,$FC,$D2,$20 ; $01
	db $E9,$04,$D1,$20 ; $02
	db $F1,$F4,$E3,$20 ; $03
	db $F1,$FC,$E2,$20 ; $04
	db $F1,$04,$E1,$20 ; $05
	db $F9,$F4,$F3,$20 ; $06
	db $F9,$FC,$F2,$20 ; $07
	db $F9,$04,$F1,$20 ; $08
.end:

SprMap_TopMan_Spin1:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$D6,$20 ; $00
	db $E9,$FC,$D5,$20 ; $01
	db $E9,$04,$D4,$20 ; $02
	db $F1,$F4,$E6,$20 ; $03
	db $F1,$FC,$E5,$20 ; $04
	db $F1,$04,$E4,$20 ; $05
	db $F9,$F4,$F6,$20 ; $06
	db $F9,$FC,$F5,$20 ; $07
	db $F9,$04,$F4,$20 ; $08
.end:

SprMap_TopMan_Spin2:
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

SprMap_TopMan_Spin3:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$D1,$00 ; $00
	db $E9,$FC,$D2,$00 ; $01
	db $E9,$04,$D3,$00 ; $02
	db $F1,$F4,$E1,$00 ; $03
	db $F1,$FC,$E2,$00 ; $04
	db $F1,$04,$E3,$00 ; $05
	db $F9,$F4,$F1,$00 ; $06
	db $F9,$FC,$F2,$00 ; $07
	db $F9,$04,$F3,$00 ; $08
.end:

