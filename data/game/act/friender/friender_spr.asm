SprMap_Friender_Idle:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $D7,$00,$88,$00 ; $00
	db $D7,$08,$89,$00 ; $01
	db $DF,$08,$99,$00 ; $02
	db $E1,$EC,$86,$00 ; $03
	db $E1,$F4,$87,$00 ; $04
	db $E9,$EC,$96,$00 ; $05
	db $E9,$F4,$97,$00 ; $06
	db $F1,$EC,$A6,$00 ; $07
	db $F1,$F4,$A7,$00 ; $08
	db $F1,$02,$8C,$00 ; $09
	db $F9,$FC,$9B,$00 ; $0A
	db $F9,$04,$9C,$00 ; $0B
.end:

SprMap_Friender_Warn:
	db (.end-.start)/4 ; $0D OBJ
.start:
	db $D3,$07,$8A,$00 ; $00
	db $DB,$08,$9A,$00 ; $01
	db $E3,$08,$AA,$00 ; $02
	db $E4,$EC,$86,$00 ; $03
	db $E4,$F4,$87,$00 ; $04
	db $E9,$06,$8D,$00 ; $05
	db $EC,$EC,$96,$00 ; $06
	db $EC,$F4,$97,$00 ; $07
	db $F1,$06,$9D,$00 ; $08
	db $F4,$EC,$A6,$00 ; $09
	db $F4,$F4,$A7,$00 ; $0A
	db $F9,$FE,$AC,$00 ; $0B
	db $F9,$06,$AD,$00 ; $0C
.end:

SprMap_Friender_Shoot:
	db (.end-.start)/4 ; $0D OBJ
.start:
	db $D3,$07,$8A,$00 ; $00
	db $DB,$08,$9A,$00 ; $01
	db $E3,$08,$AA,$00 ; $02
	db $E4,$EC,$86,$00 ; $03
	db $E4,$F4,$87,$00 ; $04
	db $E9,$06,$8D,$00 ; $05
	db $EC,$EC,$96,$00 ; $06
	db $EC,$F4,$97,$00 ; $07
	db $F1,$06,$9D,$00 ; $08
	db $F4,$EC,$A6,$00 ; $09
	db $F4,$F4,$A7,$00 ; $0A
	db $F9,$FE,$AC,$00 ; $0B
	db $F9,$06,$AD,$00 ; $0C
.end:

