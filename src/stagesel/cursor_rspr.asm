	;  Y   X   ID  FLG
StageSel_CursorCrash:
	db $18,$18,$3F,$00 ; $00
	db $40,$18,$3F,$00 ; $01
	db $18,$40,$3F,$00 ; $02
	db $40,$40,$3F,$00 ; $03
StageSel_CursorMetal:
	db $18,$68,$3F,$00 ; $00
	db $40,$68,$3F,$00 ; $01
	db $18,$90,$3F,$00 ; $02
	db $40,$90,$3F,$00 ; $03
StageSel_CursorWood:
	db $68,$18,$3F,$00 ; $00
	db $90,$18,$3F,$00 ; $01
	db $68,$40,$3F,$00 ; $02
	db $90,$40,$3F,$00 ; $03
StageSel_CursorAir:
	db $68,$68,$3F,$00 ; $00
	db $90,$68,$3F,$00 ; $01
	db $68,$90,$3F,$00 ; $02
	db $90,$90,$3F,$00 ; $03