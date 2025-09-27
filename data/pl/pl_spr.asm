SprMap_Pl_Null:
	db (.end-.start)/4 ; $00 OBJ
.start:
.end:

SprMap_Pl_Walk0:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $E9,$F8,$00,$00 ; $00
	db $E9,$00,$01,$00 ; $01
	db $F1,$F5,$02,$00 ; $02
	db $F1,$FD,$03,$00 ; $03
	db $F1,$05,$04,$00 ; $04
	db $F9,$FC,$06,$00 ; $05
	db $F9,$04,$07,$00 ; $06
.end:

SprMap_Pl_Walk1:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $E9,$FA,$08,$00 ; $00
	db $E9,$02,$09,$00 ; $01
	db $F1,$FA,$0A,$00 ; $02
	db $F1,$02,$0B,$00 ; $03
	db $F9,$FF,$0C,$00 ; $04
.end:

SprMap_Pl_Walk2:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F8,$00,$00 ; $00
	db $E9,$00,$01,$00 ; $01
	db $F1,$F8,$0D,$00 ; $02
	db $F1,$00,$0E,$00 ; $03
	db $F1,$08,$0F,$00 ; $04
	db $F9,$F8,$10,$00 ; $05
	db $F9,$00,$11,$00 ; $06
	db $F9,$08,$12,$00 ; $07
.end:

SprMap_Pl_Idle:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$FA,$08,$00 ; $00
	db $E9,$02,$09,$00 ; $01
	db $F1,$F3,$13,$00 ; $02
	db $F1,$FB,$14,$00 ; $03
	db $F1,$03,$15,$00 ; $04
	db $F9,$F3,$16,$00 ; $05
	db $F9,$FB,$17,$00 ; $06
	db $F9,$03,$18,$00 ; $07
.end:

SprMap_Pl_Blink:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$FA,$45,$00 ; $00
	db $E9,$02,$09,$00 ; $01
	db $F1,$F3,$13,$00 ; $02
	db $F1,$FB,$4C,$00 ; $03
	db $F1,$03,$15,$00 ; $04
	db $F9,$F3,$16,$00 ; $05
	db $F9,$FB,$17,$00 ; $06
	db $F9,$03,$18,$00 ; $07
.end:

SprMap_Pl_SideStep:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$FA,$08,$00 ; $00
	db $E9,$02,$09,$00 ; $01
	db $F1,$F3,$13,$00 ; $02
	db $F1,$FB,$14,$00 ; $03
	db $F1,$03,$15,$00 ; $04
	db $F9,$F3,$3E,$00 ; $05
	db $F9,$FB,$17,$00 ; $06
	db $F9,$03,$18,$00 ; $07
.end:

SprMap_Pl_Jump:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F4,$21,$00 ; $00
	db $E9,$FC,$22,$00 ; $01
	db $E9,$04,$23,$00 ; $02
	db $F1,$F8,$24,$00 ; $03
	db $F1,$00,$25,$00 ; $04
	db $F9,$F5,$26,$00 ; $05
	db $F9,$FD,$27,$00 ; $06
	db $01,$FD,$28,$00 ; $07
.end:

SprMap_Pl_ClimbTop:
	db (.end-.start)/4 ; $05 OBJ
.start:
	db $F1,$F8,$41,$00 ; $00
	db $F1,$00,$41,$20 ; $01
	db $F9,$F8,$42,$00 ; $02
	db $F9,$00,$43,$00 ; $03
	db $01,$F8,$44,$00 ; $04
.end:

SprMap_Pl_Climb:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $E9,$F8,$29,$00 ; $00
	db $E9,$00,$2A,$00 ; $01
	db $F1,$F8,$2B,$00 ; $02
	db $F1,$00,$2C,$00 ; $03
	db $F9,$F8,$2D,$00 ; $04
	db $F9,$00,$2E,$00 ; $05
	db $01,$F8,$2F,$00 ; $06
.end:

SprMap_Pl_ThrowSlide:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $F1,$F8,$46,$00 ; $00
	db $F1,$00,$47,$00 ; $01
	db $F1,$08,$09,$00 ; $02
	db $F9,$F0,$48,$00 ; $03
	db $F9,$F8,$49,$00 ; $04
	db $F9,$00,$4A,$00 ; $05
	db $F9,$08,$4B,$00 ; $06
	db $01,$F5,$63,$00 ; $07
.end:

SprMap_Pl_ShootWalk0:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F8,$00,$00 ; $00
	db $E9,$00,$01,$00 ; $01
	db $F1,$F0,$19,$00 ; $02
	db $F1,$F5,$05,$00 ; $03
	db $F1,$FD,$03,$00 ; $04
	db $F1,$05,$04,$00 ; $05
	db $F9,$FC,$06,$00 ; $06
	db $F9,$04,$07,$00 ; $07
.end:

SprMap_Pl_ShootWalk1:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $E9,$FA,$08,$00 ; $00
	db $E9,$02,$09,$00 ; $01
	db $F1,$F0,$19,$00 ; $02
	db $F1,$FA,$76,$00 ; $03
	db $F1,$02,$0B,$00 ; $04
	db $F2,$F2,$63,$00 ; $05
	db $F9,$FF,$0C,$00 ; $06
.end:

SprMap_Pl_ShootWalk2:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F8,$00,$00 ; $00
	db $E9,$00,$01,$00 ; $01
	db $F1,$F0,$19,$00 ; $02
	db $F1,$F8,$77,$00 ; $03
	db $F1,$00,$78,$00 ; $04
	db $F9,$F8,$10,$00 ; $05
	db $F9,$00,$11,$00 ; $06
	db $F9,$08,$12,$00 ; $07
.end:

SprMap_Pl_ShootIdle:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F6,$08,$00 ; $00
	db $E9,$FE,$09,$00 ; $01
	db $F1,$EC,$19,$00 ; $02
	db $F1,$F4,$1A,$00 ; $03
	db $F1,$FC,$1B,$00 ; $04
	db $F1,$04,$1C,$00 ; $05
	db $F9,$F4,$1D,$00 ; $06
	db $F9,$FC,$1E,$00 ; $07
	db $F9,$04,$1F,$00 ; $08
.end:

SprMap_Pl_ShootJump:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$7A,$00 ; $00
	db $E9,$FC,$22,$00 ; $01
	db $E9,$04,$23,$00 ; $02
	db $F1,$F0,$19,$00 ; $03
	db $F1,$F8,$7B,$00 ; $04
	db $F1,$00,$25,$00 ; $05
	db $F9,$F5,$26,$00 ; $06
	db $F9,$FD,$27,$00 ; $07
	db $01,$FD,$28,$00 ; $08
.end:

SprMap_Pl_ShootClimb:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F8,$30,$00 ; $00
	db $E9,$00,$31,$00 ; $01
	db $F1,$F0,$19,$00 ; $02
	db $F1,$F8,$32,$00 ; $03
	db $F1,$00,$33,$00 ; $04
	db $F9,$F8,$2D,$00 ; $05
	db $F9,$00,$2E,$00 ; $06
	db $01,$F8,$2F,$00 ; $07
.end:

SprMap_Pl_ThrowWalk0:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F8,$00,$00 ; $00
	db $E9,$00,$01,$00 ; $01
	db $F1,$F0,$20,$00 ; $02
	db $F1,$F5,$05,$00 ; $03
	db $F1,$FD,$03,$00 ; $04
	db $F1,$05,$04,$00 ; $05
	db $F9,$FC,$06,$00 ; $06
	db $F9,$04,$07,$00 ; $07
.end:

SprMap_Pl_ThrowWalk1:
	db (.end-.start)/4 ; $07 OBJ
.start:
	db $E9,$FA,$08,$00 ; $00
	db $E9,$02,$09,$00 ; $01
	db $F1,$F0,$20,$00 ; $02
	db $F1,$FA,$76,$00 ; $03
	db $F1,$02,$0B,$00 ; $04
	db $F2,$F2,$63,$00 ; $05
	db $F9,$FF,$0C,$00 ; $06
.end:

SprMap_Pl_ThrowWalk2:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F8,$00,$00 ; $00
	db $E9,$00,$01,$00 ; $01
	db $F1,$F0,$20,$00 ; $02
	db $F1,$F8,$77,$00 ; $03
	db $F1,$00,$78,$00 ; $04
	db $F9,$F8,$10,$00 ; $05
	db $F9,$00,$11,$00 ; $06
	db $F9,$08,$12,$00 ; $07
.end:

SprMap_Pl_ThrowIdle:
	db (.end-.start)/4 ; $0A OBJ
.start:
	db $E9,$F6,$08,$00 ; $00
	db $E9,$FE,$09,$00 ; $01
	db $F1,$EC,$79,$00 ; $02
	db $F1,$F4,$3B,$00 ; $03
	db $F1,$FC,$1B,$00 ; $04
	db $F1,$04,$1C,$00 ; $05
	db $F9,$EC,$3C,$00 ; $06
	db $F9,$F4,$3D,$00 ; $07
	db $F9,$FC,$1E,$00 ; $08
	db $F9,$04,$1F,$00 ; $09
.end:

SprMap_Pl_ThrowJump:
	db (.end-.start)/4 ; $09 OBJ
.start:
	db $E9,$F4,$7A,$00 ; $00
	db $E9,$FC,$22,$00 ; $01
	db $E9,$04,$23,$00 ; $02
	db $F1,$F0,$20,$00 ; $03
	db $F1,$F8,$7B,$00 ; $04
	db $F1,$00,$25,$00 ; $05
	db $F9,$F5,$26,$00 ; $06
	db $F9,$FD,$27,$00 ; $07
	db $01,$FD,$28,$00 ; $08
.end:

SprMap_Pl_ThrowClimb:
	db (.end-.start)/4 ; $08 OBJ
.start:
	db $E9,$F8,$30,$00 ; $00
	db $E9,$00,$31,$00 ; $01
	db $F1,$F0,$20,$00 ; $02
	db $F1,$F8,$32,$00 ; $03
	db $F1,$00,$33,$00 ; $04
	db $F9,$F8,$2D,$00 ; $05
	db $F9,$00,$2E,$00 ; $06
	db $01,$F8,$2F,$00 ; $07
.end:

SprMap_Pl_Hurt:
	db (.end-.start)/4 ; $0A OBJ
.start:
	db $E9,$F3,$34,$00 ; $00
	db $E9,$FB,$35,$00 ; $01
	db $E9,$03,$36,$00 ; $02
	db $F1,$F3,$37,$00 ; $03
	db $F1,$FB,$38,$00 ; $04
	db $F1,$03,$39,$00 ; $05
	db $F9,$F3,$70,$00 ; $06
	db $F9,$FB,$71,$00 ; $07
	db $F9,$03,$73,$00 ; $08
	db $01,$FE,$3A,$00 ; $09
.end:

SprMap_Pl_SgIdle:
	db (.end-.start)/4 ; $0B OBJ
.start:
	db $D9,$FD,$50,$00 ; $00
	db $D9,$05,$51,$00 ; $01
	db $E1,$FD,$52,$00 ; $02
	db $E1,$05,$53,$00 ; $03
	db $E9,$F6,$54,$00 ; $04
	db $E9,$FE,$55,$00 ; $05
	db $E9,$06,$56,$00 ; $06
	db $F1,$F4,$57,$00 ; $07
	db $F1,$FC,$58,$00 ; $08
	db $F1,$04,$59,$00 ; $09
	db $F9,$FC,$5A,$00 ; $0A
.end:

SprMap_Pl_SgJump:
	db (.end-.start)/4 ; $0C OBJ
.start:
	db $D1,$FB,$50,$00 ; $00
	db $D1,$03,$51,$00 ; $01
	db $D9,$FB,$52,$00 ; $02
	db $D9,$03,$53,$00 ; $03
	db $E1,$F4,$54,$00 ; $04
	db $E1,$FC,$55,$00 ; $05
	db $E1,$04,$56,$00 ; $06
	db $E9,$FA,$5B,$00 ; $07
	db $E9,$02,$5C,$00 ; $08
	db $F1,$F8,$5D,$00 ; $09
	db $F1,$00,$5E,$00 ; $0A
	db $F9,$FC,$5F,$00 ; $0B
.end: