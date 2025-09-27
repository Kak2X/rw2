SprMap_MagnetMan_Idle:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$80,$00 ; $00
	db $E9,$FC,$81,$00 ; $01
	db $E9,$04,$82,$00 ; $02
	db $F1,$F4,$90,$00 ; $03
	db $F1,$FC,$91,$00 ; $04
	db $F1,$04,$92,$00 ; $05
	db $F9,$F4,$A0,$00 ; $06
	db $F9,$FC,$A1,$00 ; $07
	db $F9,$04,$A2,$00 ; $08
.end:

SprMap_MagnetMan_Intro1:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$F4,$83,$00 ; $00
	db $E1,$FC,$84,$00 ; $01
	db $E1,$04,$85,$00 ; $02
	db $E9,$F4,$93,$00 ; $03
	db $E9,$FC,$94,$00 ; $04
	db $E9,$04,$95,$00 ; $05
	db $F1,$F4,$A3,$00 ; $06
	db $F1,$FC,$A4,$00 ; $07
	db $F1,$04,$A5,$00 ; $08
	db $F9,$F4,$B3,$00 ; $09
	db $F9,$FC,$B4,$00 ; $0A
	db $F9,$04,$B5,$00 ; $0B
.end:

SprMap_MagnetMan_Intro2:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$87,$00 ; $00
	db $E9,$FC,$88,$00 ; $01
	db $E9,$04,$89,$00 ; $02
	db $F1,$F4,$97,$00 ; $03
	db $F1,$FC,$98,$00 ; $04
	db $F1,$04,$99,$00 ; $05
	db $F9,$F4,$A7,$00 ; $06
	db $F9,$FC,$A8,$00 ; $07
	db $F9,$04,$A9,$00 ; $08
.end:

SprMap_MagnetMan_Attract0:
	db (.end-.start)/4 ; $0D OBJ
.start:
	db $E9,$F4,$87,$00 ; $00
	db $E9,$FC,$88,$00 ; $01
	db $E9,$04,$89,$00 ; $02
	db $F1,$EC,$96,$00 ; $03
	db $F1,$F4,$97,$00 ; $04
	db $F1,$FC,$98,$00 ; $05
	db $F1,$04,$99,$00 ; $06
	db $F1,$0C,$9A,$00 ; $07
	db $F9,$EC,$A6,$00 ; $08
	db $F9,$F4,$A7,$00 ; $09
	db $F9,$FC,$A8,$00 ; $0A
	db $F9,$04,$A9,$00 ; $0B
	db $F9,$0C,$AA,$00 ; $0C
.end:

SprMap_MagnetMan_Attract1:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E9,$F4,$B7,$00 ; $00
	db $E9,$FC,$B8,$00 ; $01
	db $F1,$EC,$C6,$00 ; $02
	db $F1,$F4,$C7,$00 ; $03
	db $F1,$FC,$C8,$00 ; $04
	db $F1,$04,$C9,$00 ; $05
	db $F1,$0C,$CA,$00 ; $06
	db $F9,$EC,$D6,$00 ; $07
	db $F9,$F4,$D7,$00 ; $08
	db $F9,$FC,$D8,$00 ; $09
	db $F9,$04,$D9,$00 ; $0A
	db $F9,$0C,$DA,$00 ; $0B
.end:

SprMap_MagnetMan_Jump:
	db (.end-.start)/4 ; $0D OBJ
.start:
	db $E1,$EC,$C2,$00 ; $00
	db $E1,$F4,$C3,$00 ; $01
	db $E1,$FC,$C4,$00 ; $02
	db $E1,$04,$C5,$00 ; $03
	db $E9,$EC,$D2,$00 ; $04
	db $E9,$F4,$D3,$00 ; $05
	db $E9,$FC,$D4,$00 ; $06
	db $E9,$04,$D5,$00 ; $07
	db $F1,$F4,$E3,$00 ; $08
	db $F1,$FC,$E4,$00 ; $09
	db $F1,$04,$E5,$00 ; $0A
	db $F9,$F4,$F3,$00 ; $0B
	db $F9,$FC,$F4,$00 ; $0C
.end:

SprMap_MagnetMan_JumpThrow:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $E1,$F4,$8D,$00 ; $00
	db $E1,$FC,$8E,$00 ; $01
	db $E1,$04,$8F,$00 ; $02
	db $E9,$EC,$9C,$00 ; $03
	db $E9,$F4,$9D,$00 ; $04
	db $E9,$FC,$9E,$00 ; $05
	db $E9,$04,$9F,$00 ; $06
	db $F1,$EC,$AC,$00 ; $07
	db $F1,$F4,$AD,$00 ; $08
	db $F1,$FC,$AE,$00 ; $09
	db $F1,$04,$AF,$00 ; $0A
	db $F9,$F4,$BD,$00 ; $0B
	db $F9,$FC,$BE,$00 ; $0C
	db $F9,$04,$BF,$00 ; $0D
.end:

SprMap_MagnetMan_Unused_Intro3:
	db (.end-.start)/4 ; $0B OBJ
.start:
	db $E9,$F4,$8D,$00 ; $00 ;X
	db $E9,$FC,$8E,$00 ; $01 ;X
	db $E9,$04,$8F,$00 ; $02 ;X
	db $F1,$EC,$9C,$00 ; $03 ;X
	db $F1,$F4,$9D,$00 ; $04 ;X
	db $F1,$FC,$9E,$00 ; $05 ;X
	db $F1,$04,$9F,$00 ; $06 ;X
	db $F9,$EC,$AC,$00 ; $07 ;X
	db $F9,$F4,$CD,$00 ; $08 ;X
	db $F9,$FC,$CE,$00 ; $09 ;X
	db $F9,$04,$CF,$00 ; $0A ;X
.end:

