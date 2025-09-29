SprMap_NeedleMan_Idle:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$FC,$81,$00 ; $00
	db $E9,$F4,$90,$00 ; $01
	db $E9,$FC,$91,$00 ; $02
	db $E9,$04,$92,$00 ; $03
	db $F1,$F4,$A0,$00 ; $04
	db $F1,$FC,$A1,$00 ; $05
	db $F1,$04,$A2,$00 ; $06
	db $F1,$0C,$A3,$00 ; $07
	db $F9,$F4,$B0,$00 ; $08
	db $F9,$FC,$B1,$00 ; $09
	db $F9,$04,$B2,$00 ; $0A
	db $F9,$0C,$B3,$00 ; $0B
.end:

SprMap_NeedleMan_Intro:
	db (.end-.start)/4 ; $0D OBJ
.start:
	db $E1,$EC,$8A,$00 ; $00
	db $E1,$F4,$8B,$00 ; $01
	db $E1,$FC,$8C,$00 ; $02
	db $E9,$EC,$9A,$00 ; $03
	db $E9,$F4,$9B,$00 ; $04
	db $E9,$FC,$9C,$00 ; $05
	db $E9,$04,$9D,$00 ; $06
	db $F1,$F4,$AB,$00 ; $07
	db $F1,$FC,$AC,$00 ; $08
	db $F1,$04,$AD,$00 ; $09
	db $F9,$F4,$BB,$00 ; $0A
	db $F9,$FC,$BC,$00 ; $0B
	db $F9,$04,$BD,$00 ; $0C
.end:

SprMap_NeedleMan_Extend0:
	db (.end-.start)/4 ; $0B OBJ
.start:
	db $E1,$F4,$85,$00 ; $00
	db $E1,$FC,$86,$00 ; $01
	db $E9,$EC,$94,$00 ; $02
	db $E9,$F4,$95,$00 ; $03
	db $E9,$FC,$96,$00 ; $04
	db $F1,$EC,$A4,$00 ; $05
	db $F1,$F4,$A5,$00 ; $06
	db $F1,$FC,$A6,$00 ; $07
	db $F9,$F4,$B5,$00 ; $08
	db $F9,$FC,$B6,$00 ; $09
	db $F9,$04,$B7,$00 ; $0A
.end:

SprMap_NeedleMan_Extend1:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$F4,$89,$00 ; $00
	db $E1,$FC,$86,$00 ; $01
	db $E9,$E4,$88,$00 ; $02
	db $E9,$F4,$99,$00 ; $03
	db $E9,$FC,$96,$00 ; $04
	db $ED,$EC,$A8,$00 ; $05
	db $F1,$E4,$98,$00 ; $06
	db $F1,$F4,$A9,$00 ; $07
	db $F1,$FC,$A6,$00 ; $08
	db $F9,$F4,$B9,$00 ; $09
	db $F9,$FC,$B6,$00 ; $0A
	db $F9,$04,$B7,$00 ; $0B
.end:

SprMap_NeedleMan_Extend2:
	db (.end-.start)/4 ; $0D OBJ
.start:
	db $E1,$F4,$89,$00 ; $00
	db $E1,$FC,$86,$00 ; $01
	db $E9,$DC,$88,$00 ; $02
	db $E9,$F4,$99,$00 ; $03
	db $E9,$FC,$96,$00 ; $04
	db $ED,$E4,$A8,$00 ; $05
	db $ED,$EC,$A8,$00 ; $06
	db $F1,$DC,$98,$00 ; $07
	db $F1,$F4,$A9,$00 ; $08
	db $F1,$FC,$A6,$00 ; $09
	db $F9,$F4,$B9,$00 ; $0A
	db $F9,$FC,$B6,$00 ; $0B
	db $F9,$04,$B7,$00 ; $0C
.end:

SprMap_NeedleMan_Extend4:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $E1,$F4,$89,$00 ; $00
	db $E1,$FC,$86,$00 ; $01
	db $E9,$D4,$88,$00 ; $02
	db $E9,$F4,$99,$00 ; $03
	db $E9,$FC,$96,$00 ; $04
	db $ED,$DC,$A8,$00 ; $05
	db $ED,$E4,$A8,$00 ; $06
	db $ED,$EC,$A8,$00 ; $07
	db $F1,$D4,$98,$00 ; $08
	db $F1,$F4,$A9,$00 ; $09
	db $F1,$FC,$A6,$00 ; $0A
	db $F9,$F4,$B9,$00 ; $0B
	db $F9,$FC,$B6,$00 ; $0C
	db $F9,$04,$B7,$00 ; $0D
.end:

SprMap_NeedleMan_Jump:
	db (.end-.start)/4 ; $0B OBJ
.start:
	db $E1,$F4,$C0,$00 ; $00
	db $E1,$FC,$C1,$00 ; $01
	db $E9,$F4,$D0,$00 ; $02
	db $E9,$FC,$D1,$00 ; $03
	db $E9,$04,$D2,$00 ; $04
	db $F1,$F4,$E0,$00 ; $05
	db $F1,$FC,$E1,$00 ; $06
	db $F1,$04,$E2,$00 ; $07
	db $F9,$F4,$F0,$00 ; $08
	db $F9,$FC,$F1,$00 ; $09
	db $F9,$04,$F2,$00 ; $0A
.end:

