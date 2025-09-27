SprMap_Batton_Hide:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$FA,$A0,$00 ; $00
	db $F1,$02,$A1,$00 ; $01
	db $F9,$FA,$B0,$00 ; $02
	db $F9,$02,$B1,$00 ; $03
.end:

SprMap_Batton_Unhide0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F9,$C0,$00 ; $00
	db $F1,$01,$C1,$00 ; $01
	db $F9,$F9,$D0,$00 ; $02
	db $F9,$01,$D1,$00 ; $03
.end:

SprMap_Batton_Unhide1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F9,$B2,$40 ; $00
	db $F1,$01,$B3,$40 ; $01
	db $F9,$F9,$A2,$40 ; $02
	db $F9,$01,$A3,$40 ; $03
.end:

SprMap_Batton_Unhide2:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F9,$B4,$40 ; $00
	db $F1,$01,$B5,$40 ; $01
	db $F9,$F9,$A4,$40 ; $02
	db $F9,$01,$A5,$40 ; $03
.end:

SprMap_Batton_Unhide3:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F5,$80,$00 ; $00
	db $F1,$FD,$81,$00 ; $01
	db $F1,$05,$82,$00 ; $02
	db $F9,$F5,$90,$00 ; $03
	db $F9,$FD,$91,$00 ; $04
	db $F9,$05,$92,$00 ; $05
.end:

SprMap_Batton_Fly0:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F9,$A2,$00 ; $00
	db $F1,$01,$A3,$00 ; $01
	db $F9,$F9,$B2,$00 ; $02
	db $F9,$01,$B3,$00 ; $03
.end:

SprMap_Batton_Fly1:
	db (.end-.start)/4 ; $04 OBJ
.start:
	db $F1,$F9,$A4,$00 ; $00
	db $F1,$01,$A5,$00 ; $01
	db $F9,$F9,$B4,$00 ; $02
	db $F9,$01,$B5,$00 ; $03
.end:

SprMap_Batton_Fly2:
	db (.end-.start)/4 ; $06 OBJ
.start:
	db $F1,$F5,$83,$00 ; $00
	db $F1,$FD,$84,$00 ; $01
	db $F1,$05,$85,$00 ; $02
	db $F9,$F5,$93,$00 ; $03
	db $F9,$FD,$94,$00 ; $04
	db $F9,$05,$95,$00 ; $05
.end:

