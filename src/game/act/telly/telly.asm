; =============== Act_Telly ===============
; ID: ACT_TELLY
; Floating block that homes in on the player.
Act_Telly:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Telly_Init
	dw Act_Telly_Move

; =============== Act_Telly_Init ===============
Act_Telly_Init:
	
	ld   bc, $0601			; Play telly rotation animation (sprites $00-$06, at 1/8 speed)
	call ActS_AnimCustom
	
	call ActS_AngleToPl		; Take snapshot of player position
	call ActS_HalfSpdSub	; Move there at 1/4th of the speed
	call ActS_HalfSpdSub	;
	
	ld   a, $10				; Take next snapshot after 16 frames
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Telly_Move ===============
Act_Telly_Move:
	; Play telly rotation animation (sprites $00-$06, at 1/8 speed)
	ld   bc, $0601
	call ActS_AnimCustom
	
	; Move towards the player('s snapshot)
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	
	; After 16 frames pass, take a new snapshot
	ldh  a, [hActCur+iActTimer]
	sub  $01						; Timer--
	ldh  [hActCur+iActTimer], a
	ret  nz							; Timer != 0? If so, return
	call ActS_AngleToPl				; Take snapshot of player position
	call ActS_HalfSpdSub			; Move there at 1/4th of the speed
	call ActS_HalfSpdSub			;
	
	ld   a, $10						; Take next snapshot after 16 frames
	ldh  [hActCur+iActTimer], a
	ret
	
