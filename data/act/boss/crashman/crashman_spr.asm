SprMap_CrashMan_Walk2:
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

SprMap_CrashMan_Walk1:
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

SprMap_CrashMan_Unused_Jump:
	; [TCRF] Duplicate of SprMap_CrashMan_Jump that expects its graphics at a different location than usual.
	db (.end-.start)/4 ; $0A OBJ
.start:
	db $E1,$F4,$C7,$00 ; $00 ;X
	db $E1,$FC,$C8,$00 ; $01 ;X
	db $E1,$04,$C9,$00 ; $02 ;X
	db $E9,$F4,$D7,$00 ; $03 ;X
	db $E9,$FC,$D8,$00 ; $04 ;X
	db $E9,$04,$D9,$00 ; $05 ;X
	db $F1,$FC,$E8,$00 ; $06 ;X
	db $F1,$04,$E9,$00 ; $07 ;X
	db $F9,$FC,$F8,$00 ; $08 ;X
	db $F9,$04,$F9,$00 ; $09 ;X
.end:

SprMap_CrashMan_Intro2:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$EC,$8A,$00 ; $00
	db $E1,$F4,$8B,$00 ; $01
	db $E9,$EC,$9A,$00 ; $02
	db $E9,$F4,$9B,$00 ; $03
	db $E9,$FC,$9C,$00 ; $04
	db $E9,$04,$9D,$00 ; $05
	db $F1,$F4,$AB,$00 ; $06
	db $F1,$FC,$AC,$00 ; $07
	db $F1,$04,$AD,$00 ; $08
	db $F9,$F4,$BB,$00 ; $09
	db $F9,$FC,$BC,$00 ; $0A
	db $F9,$04,$BD,$00 ; $0B
.end:

SprMap_CrashMan_Jump:
	db (.end-.start)/4 ; $0A OBJ
.start:
	db $E1,$F4,$87,$00 ; $00
	db $E1,$FC,$88,$00 ; $01
	db $E1,$04,$89,$00 ; $02
	db $E9,$F4,$97,$00 ; $03
	db $E9,$FC,$98,$00 ; $04
	db $E9,$04,$99,$00 ; $05
	db $F1,$FC,$A8,$00 ; $06
	db $F1,$04,$A9,$00 ; $07
	db $F9,$FC,$B8,$00 ; $08
	db $F9,$04,$B9,$00 ; $09
.end:

SprMap_CrashMan_Intro1:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$91,$00 ; $00
	db $E9,$FC,$92,$00 ; $01
	db $E9,$04,$93,$00 ; $02
	db $F1,$F4,$A1,$00 ; $03
	db $F1,$FC,$A2,$00 ; $04
	db $F1,$04,$A3,$00 ; $05
	db $F9,$F4,$B1,$00 ; $06
	db $F9,$FC,$B2,$00 ; $07
	db $F9,$04,$B3,$00 ; $08
.end:

SprMap_CrashMan_Idle:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$94,$00 ; $00
	db $E9,$FC,$95,$00 ; $01
	db $E9,$04,$96,$00 ; $02
	db $F1,$F4,$A4,$00 ; $03
	db $F1,$FC,$A5,$00 ; $04
	db $F1,$04,$A6,$00 ; $05
	db $F9,$F4,$B4,$00 ; $06
	db $F9,$FC,$B5,$00 ; $07
	db $F9,$04,$B6,$00 ; $08
.end:

SprMap_CrashMan_Walk0:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F4,$AE,$00 ; $00
	db $E9,$FC,$CE,$00 ; $01
	db $E9,$04,$CF,$00 ; $02
	db $F1,$F4,$BE,$00 ; $03
	db $F1,$FC,$DE,$00 ; $04
	db $F1,$04,$DF,$00 ; $05
	db $F9,$FC,$EE,$00 ; $06
	db $F9,$04,$EF,$00 ; $07
.end:

SprMap_CrashMan_JumpShoot:
	db (.end-.start)/4 ; $0B OBJ
.start:
	db $E1,$F9,$CB,$00 ; $00
	db $E1,$01,$CC,$00 ; $01
	db $E9,$F1,$DA,$00 ; $02
	db $E9,$F9,$DB,$00 ; $03
	db $E9,$01,$DC,$00 ; $04
	db $E9,$09,$DD,$00 ; $05
	db $F1,$F1,$EA,$00 ; $06
	db $F1,$F9,$EB,$00 ; $07
	db $F1,$01,$EC,$00 ; $08
	db $F1,$09,$ED,$00 ; $09
	db $F9,$01,$FC,$00 ; $0A
.end:

