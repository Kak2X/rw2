SprMap_GiantSpringer_Move:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$B0,$00 ; $00
	db $E9,$FC,$B1,$00 ; $01
	db $E9,$04,$B2,$00 ; $02
	db $F1,$F4,$C0,$00 ; $03
	db $F1,$FC,$C1,$00 ; $04
	db $F1,$04,$C2,$00 ; $05
	db $F9,$F4,$D0,$00 ; $06
	db $F9,$FC,$D1,$00 ; $07
	db $F9,$04,$D2,$00 ; $08
.end:

SprMap_GiantSpringer_Shoot:
	db (.end-.start)/4 ; $0A OBJ
.start:
	db $E1,$FC,$F5,$00 ; $00
	db $E9,$F4,$B0,$00 ; $01
	db $E9,$FC,$B1,$00 ; $02
	db $E9,$04,$B2,$00 ; $03
	db $F1,$F4,$C0,$00 ; $04
	db $F1,$FC,$C1,$00 ; $05
	db $F1,$04,$C2,$00 ; $06
	db $F9,$F4,$D0,$00 ; $07
	db $F9,$FC,$D1,$00 ; $08
	db $F9,$04,$D2,$00 ; $09
.end:

SprMap_GiantSpringer_Out0:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $D9,$E7,$B3,$00 ; $00
	db $D9,$EF,$B4,$00 ; $01
	db $D9,$F7,$B5,$00 ; $02
	db $E1,$E7,$C3,$00 ; $03
	db $E1,$EF,$C4,$00 ; $04
	db $E1,$F7,$C5,$00 ; $05
	db $E9,$EA,$D3,$00 ; $06
	db $E9,$F2,$D4,$00 ; $07
	db $E9,$FA,$D5,$00 ; $08
	db $F1,$F3,$D6,$00 ; $09
	db $F1,$FB,$E3,$00 ; $0A
	db $F9,$F4,$F0,$00 ; $0B
	db $F9,$FC,$F1,$00 ; $0C
	db $F9,$04,$F2,$00 ; $0D
.end:

SprMap_GiantSpringer_Out1:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$F4,$B0,$00 ; $00
	db $E1,$FC,$B1,$00 ; $01
	db $E1,$04,$B2,$00 ; $02
	db $E9,$F4,$C0,$00 ; $03
	db $E9,$FC,$C1,$00 ; $04
	db $E9,$04,$C2,$00 ; $05
	db $F1,$F4,$E0,$00 ; $06
	db $F1,$FC,$E1,$00 ; $07
	db $F1,$04,$E2,$00 ; $08
	db $F9,$F4,$F0,$00 ; $09
	db $F9,$FC,$F1,$00 ; $0A
	db $F9,$04,$F2,$00 ; $0B
.end:

SprMap_GiantSpringer_Out2:
	db (.end-.start)/4 ; $0E OBJ
.start:
	db $D9,$02,$B5,$20 ; $00
	db $D9,$0A,$B4,$20 ; $01
	db $D9,$12,$B3,$20 ; $02
	db $E1,$02,$C5,$20 ; $03
	db $E1,$0A,$C4,$20 ; $04
	db $E1,$12,$C3,$20 ; $05
	db $E9,$FF,$D5,$20 ; $06
	db $E9,$07,$D4,$20 ; $07
	db $E9,$0F,$D3,$20 ; $08
	db $F1,$FD,$E3,$20 ; $09
	db $F1,$05,$D6,$20 ; $0A
	db $F9,$F4,$F0,$00 ; $0B
	db $F9,$FC,$F1,$00 ; $0C
	db $F9,$04,$F2,$00 ; $0D
.end:

