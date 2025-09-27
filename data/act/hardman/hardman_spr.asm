SprMap_HardMan_Idle0:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $E2,$F8,$C1,$00 ; $00
	db $E2,$00,$C2,$00 ; $01
	db $EA,$F0,$D0,$00 ; $02
	db $EA,$F8,$D1,$00 ; $03
	db $EA,$00,$D2,$00 ; $04
	db $EA,$08,$D3,$00 ; $05
	db $F2,$F0,$E0,$00 ; $06
	db $F2,$F8,$E1,$00 ; $07
	db $F2,$00,$E2,$00 ; $08
	db $F2,$08,$E3,$00 ; $09
	db $FA,$F0,$F0,$00 ; $0A
	db $FA,$F8,$F1,$00 ; $0B
	db $FA,$00,$F2,$00 ; $0C
	db $FA,$08,$F3,$00 ; $0D
.end:

SprMap_HardMan_Idle1:
	db (.end-.start)/4 ; $10 OBJ
.start:
	db $E1,$F0,$84,$00 ; $00
	db $E1,$F8,$85,$00 ; $01
	db $E1,$00,$86,$00 ; $02
	db $E1,$08,$87,$00 ; $03
	db $E9,$F0,$94,$00 ; $04
	db $E9,$F8,$95,$00 ; $05
	db $E9,$00,$96,$00 ; $06
	db $E9,$08,$97,$00 ; $07
	db $F1,$F0,$A4,$00 ; $08
	db $F1,$F8,$A5,$00 ; $09
	db $F1,$00,$A6,$00 ; $0A
	db $F1,$08,$A7,$00 ; $0B
	db $F9,$F0,$B4,$00 ; $0C
	db $F9,$F8,$B5,$00 ; $0D
	db $F9,$00,$B6,$00 ; $0E
	db $F9,$08,$B7,$00 ; $0F
.end:

SprMap_HardMan_Idle2:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $E3,$F8,$81,$00 ; $00
	db $E3,$00,$82,$00 ; $01
	db $EB,$F0,$90,$00 ; $02
	db $EB,$F8,$91,$00 ; $03
	db $EB,$00,$92,$00 ; $04
	db $EB,$08,$93,$00 ; $05
	db $F3,$F0,$A0,$00 ; $06
	db $F3,$F8,$A1,$00 ; $07
	db $F3,$00,$A2,$00 ; $08
	db $F3,$08,$A3,$00 ; $09
	db $FB,$F0,$B0,$00 ; $0A
	db $FB,$F8,$B1,$00 ; $0B
	db $FB,$00,$B2,$00 ; $0C
	db $FB,$08,$B3,$00 ; $0D
.end:

SprMap_HardMan_PunchW:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E2,$F8,$C5,$00 ; $00
	db $E2,$00,$C6,$00 ; $01
	db $EA,$F8,$D5,$00 ; $02
	db $EA,$00,$D6,$00 ; $03
	db $F2,$F0,$E4,$00 ; $04
	db $F2,$F8,$E5,$00 ; $05
	db $F2,$00,$E6,$00 ; $06
	db $F2,$08,$E7,$00 ; $07
	db $FA,$F0,$F4,$00 ; $08
	db $FA,$F8,$F5,$00 ; $09
	db $FA,$00,$F6,$00 ; $0A
	db $FA,$08,$F7,$00 ; $0B
.end:

SprMap_HardMan_PunchN:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E2,$F8,$88,$00 ; $00
	db $E2,$00,$89,$00 ; $01
	db $EA,$F8,$98,$00 ; $02
	db $EA,$00,$99,$00 ; $03
	db $F2,$F0,$E4,$00 ; $04
	db $F2,$F8,$A8,$00 ; $05
	db $F2,$00,$A9,$00 ; $06
	db $F2,$08,$E7,$00 ; $07
	db $FA,$F0,$F4,$00 ; $08
	db $FA,$F8,$F5,$00 ; $09
	db $FA,$00,$F6,$00 ; $0A
	db $FA,$08,$F7,$00 ; $0B
.end:

SprMap_HardMan_Recoil:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E2,$F9,$C5,$00 ; $00
	db $E2,$01,$C6,$00 ; $01
	db $EA,$F9,$98,$00 ; $02
	db $EA,$01,$99,$00 ; $03
	db $F2,$F0,$E4,$00 ; $04
	db $F2,$F8,$B8,$00 ; $05
	db $F2,$00,$B9,$00 ; $06
	db $F2,$08,$8A,$00 ; $07
	db $FA,$F0,$F4,$00 ; $08
	db $FA,$F8,$F5,$00 ; $09
	db $FA,$00,$F6,$00 ; $0A
	db $FA,$08,$F7,$00 ; $0B
.end:

SprMap_HardMan_Jump:
	db (.end-.start)/4 ; $10 OBJ
.start:
	db $E1,$F0,$8C,$00 ; $00
	db $E1,$F8,$8D,$00 ; $01
	db $E1,$00,$8E,$00 ; $02
	db $E1,$08,$8C,$20 ; $03
	db $E9,$F0,$9C,$00 ; $04
	db $E9,$F8,$9D,$00 ; $05
	db $E9,$00,$9E,$00 ; $06
	db $E9,$08,$9C,$20 ; $07
	db $F1,$F0,$AC,$00 ; $08
	db $F1,$F8,$AD,$00 ; $09
	db $F1,$00,$AE,$00 ; $0A
	db $F1,$08,$AC,$20 ; $0B
	db $F9,$F0,$BC,$00 ; $0C
	db $F9,$F8,$BD,$00 ; $0D
	db $F9,$00,$BE,$00 ; $0E
	db $F9,$08,$BC,$20 ; $0F
.end:

SprMap_HardMan_Drop0:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $E1,$F8,$8B,$00 ; $00
	db $E1,$00,$8B,$20 ; $01
	db $E9,$F0,$9A,$00 ; $02
	db $E9,$F8,$9B,$00 ; $03
	db $E9,$00,$9B,$20 ; $04
	db $E9,$08,$9A,$20 ; $05
	db $F1,$F0,$AA,$00 ; $06
	db $F1,$F8,$AB,$00 ; $07
	db $F1,$00,$AB,$20 ; $08
	db $F1,$08,$AA,$20 ; $09
	db $F9,$F0,$BA,$00 ; $0A
	db $F9,$F8,$BB,$00 ; $0B
	db $F9,$00,$BB,$20 ; $0C
	db $F9,$08,$BA,$20 ; $0D
.end:

SprMap_HardMan_Drop1:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $E1,$F0,$BA,$40 ; $00
	db $E1,$F8,$BB,$40 ; $01
	db $E1,$00,$BB,$60 ; $02
	db $E1,$08,$BA,$60 ; $03
	db $E9,$F0,$AA,$40 ; $04
	db $E9,$F8,$AB,$40 ; $05
	db $E9,$00,$AB,$60 ; $06
	db $E9,$08,$AA,$60 ; $07
	db $F1,$F0,$9A,$40 ; $08
	db $F1,$F8,$9B,$40 ; $09
	db $F1,$00,$9B,$60 ; $0A
	db $F1,$08,$9A,$60 ; $0B
	db $F9,$F8,$8B,$40 ; $0C
	db $F9,$00,$8B,$60 ; $0D
.end:

SprMap_HardMan_Drop2:
	db (.end-.start)/4 ; $10 OBJ
.start:
	db $E1,$F0,$CC,$00 ; $00
	db $E1,$F8,$CD,$00 ; $01
	db $E1,$00,$CE,$00 ; $02
	db $E1,$08,$CF,$00 ; $03
	db $E9,$F0,$DC,$00 ; $04
	db $E9,$F8,$DD,$00 ; $05
	db $E9,$00,$DE,$00 ; $06
	db $E9,$08,$DF,$00 ; $07
	db $F1,$F0,$9C,$40 ; $08
	db $F1,$F8,$ED,$00 ; $09
	db $F1,$00,$EE,$00 ; $0A
	db $F1,$08,$9C,$60 ; $0B
	db $F9,$F0,$8C,$40 ; $0C
	db $F9,$F8,$FD,$00 ; $0D
	db $F9,$00,$FE,$00 ; $0E
	db $F9,$08,$8C,$60 ; $0F
.end:

SprMap_HardMan_Ground:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $F2,$F0,$E8,$00 ; $00
	db $F2,$F8,$E9,$00 ; $01
	db $F2,$00,$EA,$00 ; $02
	db $F2,$08,$EB,$00 ; $03
	db $FA,$F0,$F8,$00 ; $04
	db $FA,$F8,$F9,$00 ; $05
	db $FA,$00,$FA,$00 ; $06
	db $FA,$08,$FB,$00 ; $07
.end:

