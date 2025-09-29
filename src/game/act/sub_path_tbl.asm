; =============== ActS_DistToSpdTbl ===============
; Maps every possible pair of distances to the respective speed values.
; Meant to be indexed using the current axis distance on the high nybble, and opposite axis distance on the lower nybble.
; See also: ActS_AngleToPlCustom
ActS_DistToSpdTbl:
	;  OPPOSITE AXIS ->                                                  | THIS AXIS                               
	;  $x0,$x1,$x2,$x3,$x4,$x5,$x6,$x7,$x8,$x9,$xA,$xB,$xC,$xD,$xE,$xF   v
	db $B4,$3E,$25,$19,$19,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$00,$00,$00 ; $0x
	db $F7,$B4,$6D,$56,$3E,$32,$32,$25,$25,$25,$19,$19,$19,$19,$19,$19 ; $1x
	db $FC,$E7,$B4,$83,$6D,$56,$4A,$3E,$3E,$32,$32,$32,$25,$25,$25,$25 ; $2x
	db $FE,$F0,$DB,$B4,$8E,$78,$6D,$56,$56,$4A,$3E,$3E,$3E,$32,$32,$32 ; $3x
	db $FE,$F7,$E7,$D4,$B4,$98,$83,$78,$62,$62,$56,$4A,$4A,$3E,$3E,$3E ; $4x
	db $FF,$FA,$F0,$E1,$CD,$B4,$98,$8E,$78,$6D,$62,$62,$56,$56,$4A,$4A ; $5x
	db $FF,$FA,$F4,$E7,$DB,$CD,$B4,$A2,$8E,$83,$78,$6D,$62,$62,$56,$56 ; $6x
	db $FF,$FC,$F7,$F0,$E1,$D4,$C5,$B4,$A2,$98,$83,$78,$78,$6D,$62,$62 ; $7x
	db $FF,$FC,$F7,$F0,$EC,$E1,$D4,$C5,$B4,$A2,$98,$8E,$83,$78,$6D,$6D ; $8x
	db $FF,$FC,$FA,$F4,$EC,$E7,$DB,$CD,$C5,$B4,$A2,$98,$8E,$83,$83,$78 ; $9x
	db $FF,$FE,$FA,$F7,$F0,$EC,$E1,$DB,$CD,$C5,$B4,$AB,$98,$8E,$8E,$83 ; $Ax
	db $FF,$FE,$FA,$F7,$F4,$EC,$E7,$E1,$D4,$CD,$BD,$B4,$AB,$A2,$98,$8E ; $Bx
	db $FF,$FE,$FC,$F7,$F4,$F0,$EC,$E1,$DB,$D4,$CD,$BD,$B4,$AB,$A2,$98 ; $Cx
	db $FF,$FE,$FC,$FA,$F7,$F0,$EC,$E7,$E1,$DB,$D4,$C5,$BD,$B4,$AB,$A2 ; $Dx
	db $FF,$FE,$FC,$FA,$F7,$F4,$F0,$EC,$E7,$DB,$D4,$CD,$C5,$BD,$B4,$AB ; $Ex
	db $FF,$FE,$FC,$FA,$F7,$F4,$F0,$EC,$E7,$E1,$DB,$D4,$CD,$C5,$BD,$B4 ; $Fx


; =============== ActS_ArcPathTbl ===============
; Table of speed values which, if cycled through every frame for both directions, allows actors to move in an arc.
; With careful flipping, it's also possible to make actors move on a circular path.
ActS_ArcPathTbl:
	;  $x0,$x1,$x2,$x3,$x4,$x5,$x6,$x7,$x8,$x9,$xA,$xB,$xC,$xD,$xE,$xF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE,$FD,$FC,$FB,$FA,$F9,$F8,$F7 ; $0x
	db $F6,$F5,$F3,$F2,$F1,$EF,$ED,$EC,$EA,$E8,$E6,$E4,$E2,$E0,$DE,$DB ; $1x
	db $D9,$D7,$D4,$D2,$CF,$CC,$CA,$C7,$C4,$C1,$BE,$BB,$B8,$B5,$B2,$AF ; $2x
	db $AB,$A8,$A5,$A1,$9E,$9A,$96,$93,$8F,$8B,$88,$84,$80,$7C,$78,$74 ; $3x
	db $70,$6C,$68,$64,$60,$5C,$58,$53,$4F,$4B,$47,$42,$3E,$3A,$35,$31 ; $4x
	db $2C,$28,$24,$1F,$1B,$16,$12,$0D,$09                             ; $5x
.end:
	; [POI] Table gets cut off, last two values are unused
	db $04,$00

