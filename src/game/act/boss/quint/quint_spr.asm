SprMap_Quint_Idle:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F5,$80,$00 ; $00
	db $E9,$FD,$81,$00 ; $01
	db $E9,$05,$82,$00 ; $02
	db $F1,$F5,$90,$00 ; $03
	db $F1,$FD,$91,$00 ; $04
	db $F1,$05,$92,$00 ; $05
	db $F9,$F5,$A0,$00 ; $06
	db $F9,$FD,$A1,$00 ; $07
	db $F9,$05,$A2,$00 ; $08
.end:

SprMap_Quint_Unused_PrepJump0:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F0,$B0,$00 ; $00 ;X
	db $E9,$F8,$B1,$00 ; $01 ;X
	db $E9,$00,$B2,$00 ; $02 ;X
	db $F1,$F0,$C0,$00 ; $03 ;X
	db $F1,$F8,$C1,$00 ; $04 ;X
	db $F1,$00,$C2,$00 ; $05 ;X
	db $F9,$F5,$D0,$00 ; $06 ;X
	db $F9,$FD,$D1,$00 ; $07 ;X
	db $F9,$05,$D2,$00 ; $08 ;X
.end:

SprMap_Quint_Unused_PrepJump1:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F5,$B3,$00 ; $00 ;X
	db $E9,$FD,$B4,$00 ; $01 ;X
	db $E9,$05,$B5,$00 ; $02 ;X
	db $F1,$F5,$C3,$00 ; $03 ;X
	db $F1,$FD,$C4,$00 ; $04 ;X
	db $F1,$05,$C5,$00 ; $05 ;X
	db $F9,$F5,$D3,$00 ; $06 ;X
	db $F9,$FD,$D4,$00 ; $07 ;X
	db $F9,$05,$D5,$00 ; $08 ;X
.end:

SprMap_Quint_PrepJump2:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F5,$83,$00 ; $00
	db $E9,$FD,$84,$00 ; $01
	db $E9,$05,$85,$00 ; $02
	db $F1,$F5,$93,$00 ; $03
	db $F1,$FD,$94,$00 ; $04
	db $F1,$05,$95,$00 ; $05
	db $F9,$F5,$A3,$00 ; $06
	db $F9,$FD,$A4,$00 ; $07
	db $F9,$05,$A5,$00 ; $08
.end:

SprMap_Quint_Jump:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E1,$F4,$89,$00 ; $00
	db $E1,$FC,$8A,$00 ; $01
	db $E1,$04,$8B,$00 ; $02
	db $E9,$F7,$9A,$00 ; $03
	db $E9,$FF,$9B,$00 ; $04
	db $F1,$F8,$AA,$00 ; $05
	db $F1,$00,$AB,$00 ; $06
	db $F9,$00,$BB,$00 ; $07
.end:

SprMap_Quint_SgJump:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $D1,$F9,$87,$00 ; $00
	db $D1,$01,$88,$00 ; $01
	db $D9,$F9,$97,$00 ; $02
	db $D9,$01,$98,$00 ; $03
	db $E1,$F4,$A6,$00 ; $04
	db $E1,$FC,$A7,$00 ; $05
	db $E1,$04,$A8,$00 ; $06
	db $E9,$FA,$CA,$00 ; $07
	db $E9,$02,$CB,$00 ; $08
	db $F1,$F8,$DA,$00 ; $09
	db $F1,$00,$DB,$00 ; $0A
	db $F9,$FC,$DF,$00 ; $0B
.end:

SprMap_Quint_SgGround:
	db (.end-.start)/4 ; $0B OBJ
.start:
	db $D9,$FB,$87,$00 ; $00
	db $D9,$03,$88,$00 ; $01
	db $E1,$FB,$97,$00 ; $02
	db $E1,$03,$98,$00 ; $03
	db $E9,$F6,$A6,$00 ; $04
	db $E9,$FE,$A7,$00 ; $05
	db $E9,$06,$A8,$00 ; $06
	db $F1,$F4,$B6,$00 ; $07
	db $F1,$FC,$B7,$00 ; $08
	db $F1,$04,$B8,$00 ; $09
	db $F9,$FC,$C7,$00 ; $0A
.end:

