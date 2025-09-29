SprMap_HammerJoe_SwClose0:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$F3,$8A,$00 ; $00
	db $E1,$FB,$8B,$00 ; $01
	db $E1,$03,$8C,$00 ; $02
	db $E9,$F3,$9A,$00 ; $03
	db $E9,$FB,$9B,$00 ; $04
	db $E9,$03,$9C,$00 ; $05
	db $F1,$F3,$AA,$00 ; $06
	db $F1,$FB,$AB,$00 ; $07
	db $F1,$03,$AC,$00 ; $08
	db $F9,$F4,$BA,$00 ; $09
	db $F9,$FC,$BB,$00 ; $0A
	db $F9,$04,$BC,$00 ; $0B
.end:

SprMap_HammerJoe_SwClose1:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$F5,$8A,$00 ; $00
	db $E1,$FD,$8B,$00 ; $01
	db $E1,$05,$8C,$00 ; $02
	db $E9,$F5,$9A,$00 ; $03
	db $E9,$FD,$9B,$00 ; $04
	db $E9,$05,$9C,$00 ; $05
	db $F1,$F5,$AA,$00 ; $06
	db $F1,$FD,$AB,$00 ; $07
	db $F1,$05,$AC,$00 ; $08
	db $F9,$F4,$BA,$00 ; $09
	db $F9,$FC,$BB,$00 ; $0A
	db $F9,$04,$BC,$00 ; $0B
.end:

SprMap_HammerJoe_SwOpen0:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$F3,$8A,$00 ; $00
	db $E1,$FB,$8B,$00 ; $01
	db $E1,$03,$8C,$00 ; $02
	db $E9,$F3,$8D,$00 ; $03
	db $E9,$FB,$8E,$00 ; $04
	db $E9,$03,$9C,$00 ; $05
	db $F1,$F3,$AA,$00 ; $06
	db $F1,$FB,$AB,$00 ; $07
	db $F1,$03,$AC,$00 ; $08
	db $F9,$F4,$BA,$00 ; $09
	db $F9,$FC,$BB,$00 ; $0A
	db $F9,$04,$BC,$00 ; $0B
.end:

SprMap_HammerJoe_SwOpen1:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $E1,$F5,$8A,$00 ; $00
	db $E1,$FD,$8B,$00 ; $01
	db $E1,$05,$8C,$00 ; $02
	db $E9,$F5,$8D,$00 ; $03
	db $E9,$FD,$8E,$00 ; $04
	db $E9,$05,$9C,$00 ; $05
	db $F1,$F5,$AA,$00 ; $06
	db $F1,$FD,$AB,$00 ; $07
	db $F1,$05,$AC,$00 ; $08
	db $F9,$F4,$BA,$00 ; $09
	db $F9,$FC,$BB,$00 ; $0A
	db $F9,$04,$BC,$00 ; $0B
.end:

SprMap_HammerJoe_Throw:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$EC,$BD,$00 ; $00
	db $E9,$F4,$BE,$00 ; $01
	db $E9,$FC,$BF,$00 ; $02
	db $F1,$EC,$CD,$00 ; $03
	db $F1,$F4,$CE,$00 ; $04
	db $F1,$FC,$CF,$00 ; $05
	db $F9,$F4,$DD,$00 ; $06
	db $F9,$FC,$DE,$00 ; $07
	db $F9,$04,$DF,$00 ; $08
.end:

