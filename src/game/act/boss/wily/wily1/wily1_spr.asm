SprMap_Wily1p_Idle:
	db (.end-.start)/4 ; $16 OBJ
.start:
	db $D1,$F4,$81,$00 ; $00
	db $D1,$FC,$82,$00 ; $01
	db $D1,$04,$83,$00 ; $02
	db $D9,$EC,$90,$00 ; $03
	db $D9,$F4,$91,$00 ; $04
	db $D9,$FC,$92,$00 ; $05
	db $D9,$04,$93,$00 ; $06
	db $E1,$EC,$A0,$00 ; $07
	db $E1,$F4,$C1,$00 ; $08
	db $E1,$FC,$C2,$00 ; $09
	db $E1,$04,$C3,$00 ; $0A
	db $E1,$0C,$A4,$00 ; $0B
	db $E9,$F4,$D1,$00 ; $0C
	db $E9,$FC,$D2,$00 ; $0D
	db $E9,$04,$D3,$00 ; $0E
	db $F1,$F4,$E1,$00 ; $0F
	db $F1,$FC,$E2,$00 ; $10
	db $F1,$04,$E3,$00 ; $11
	db $F9,$EC,$F0,$00 ; $12
	db $F9,$F4,$F1,$00 ; $13
	db $F9,$FC,$F2,$00 ; $14
	db $F9,$04,$F3,$00 ; $15
.end:

SprMap_Wily1p_Jump:
	db (.end-.start)/4 ; $14 OBJ
.start:
	db $D1,$F4,$81,$00 ; $00
	db $D1,$FC,$82,$00 ; $01
	db $D1,$04,$83,$00 ; $02
	db $D9,$EC,$90,$00 ; $03
	db $D9,$F4,$91,$00 ; $04
	db $D9,$FC,$92,$00 ; $05
	db $D9,$04,$93,$00 ; $06
	db $E1,$EC,$A0,$00 ; $07
	db $E1,$F4,$C1,$00 ; $08
	db $E1,$FC,$C2,$00 ; $09
	db $E1,$04,$B0,$00 ; $0A
	db $E1,$0C,$A4,$00 ; $0B
	db $E9,$F4,$C0,$00 ; $0C
	db $E9,$FC,$D0,$00 ; $0D
	db $E9,$04,$E0,$00 ; $0E
	db $E9,$0C,$80,$00 ; $0F
	db $F1,$EC,$F0,$00 ; $10
	db $F1,$F4,$F1,$00 ; $11
	db $F1,$FC,$F2,$00 ; $12
	db $F1,$04,$F3,$00 ; $13
.end:

SprMap_Wily1p_Turn0:
	db (.end-.start)/4 ; $10 OBJ
.start:
	db $D1,$F4,$81,$00 ; $00
	db $D1,$FC,$82,$00 ; $01
	db $D1,$04,$83,$00 ; $02
	db $D9,$EC,$90,$00 ; $03
	db $D9,$F4,$91,$00 ; $04
	db $D9,$FC,$92,$00 ; $05
	db $D9,$04,$93,$00 ; $06
	db $E1,$EC,$A0,$00 ; $07
	db $E1,$F4,$C1,$00 ; $08
	db $E1,$FC,$C2,$00 ; $09
	db $E1,$04,$A3,$00 ; $0A
	db $E1,$0C,$A4,$00 ; $0B
	db $E9,$EC,$F0,$00 ; $0C
	db $E9,$F4,$F1,$00 ; $0D
	db $E9,$FC,$F2,$00 ; $0E
	db $E9,$04,$F3,$00 ; $0F
.end:

SprMap_Wily1p_Turn1:
	db (.end-.start)/4 ; $13 OBJ
.start:
	db $D1,$F4,$C6,$00 ; $00
	db $D1,$FC,$C7,$00 ; $01
	db $D1,$04,$C6,$20 ; $02
	db $D9,$EC,$D5,$00 ; $03
	db $D9,$F4,$D6,$00 ; $04
	db $D9,$FC,$D7,$00 ; $05
	db $D9,$04,$D6,$20 ; $06
	db $D9,$0C,$D5,$20 ; $07
	db $E1,$E4,$E4,$00 ; $08
	db $E1,$EC,$E5,$00 ; $09
	db $E1,$F4,$E6,$00 ; $0A
	db $E1,$FC,$E7,$00 ; $0B
	db $E1,$04,$E6,$20 ; $0C
	db $E1,$0C,$E5,$20 ; $0D
	db $E1,$14,$E4,$20 ; $0E
	db $E9,$F0,$F5,$00 ; $0F
	db $E9,$F8,$F6,$00 ; $10
	db $E9,$00,$F6,$20 ; $11
	db $E9,$08,$F5,$20 ; $12
.end:

SprMap_Wily1p_Unused_Jump1:
	; [TCRF] Unreferenced sprite of Wily Machine's 1st phase with straighter legs. 
	;        Its intended graphics are no longer in the ROM, being overwritten by Wily's cutscene sprite
	;        and parts of the intro to the 2nd phase of the Wily Machine.
	db (.end-.start)/4 ; $18 OBJ
.start:
	db $C9,$F4,$81,$00 ; $00 ;X
	db $C9,$FC,$82,$00 ; $01 ;X
	db $C9,$04,$83,$00 ; $02 ;X
	db $D1,$EC,$90,$00 ; $03 ;X
	db $D1,$F4,$91,$00 ; $04 ;X
	db $D1,$FC,$92,$00 ; $05 ;X
	db $D1,$04,$93,$00 ; $06 ;X
	db $D9,$EC,$A0,$00 ; $07 ;X
	db $D9,$F4,$C1,$00 ; $08 ;X
	db $D9,$FC,$C2,$00 ; $09 ;X
	db $D9,$04,$95,$00 ; $0A ;X
	db $D9,$0C,$A4,$00 ; $0B ;X
	db $E1,$F4,$85,$00 ; $0C ;X
	db $E1,$FC,$86,$00 ; $0D ;X
	db $E1,$04,$87,$00 ; $0E ;X
	db $E9,$FC,$96,$00 ; $0F ;X
	db $E9,$04,$97,$00 ; $10 ;X
	db $F1,$F4,$A5,$00 ; $11 ;X
	db $F1,$FC,$A6,$00 ; $12 ;X
	db $F1,$04,$A7,$00 ; $13 ;X
	db $F9,$EC,$B4,$00 ; $14 ;X
	db $F9,$F4,$B5,$00 ; $15 ;X
	db $F9,$FC,$B6,$00 ; $16 ;X
	db $F9,$04,$B7,$00 ; $17 ;X
.end:

