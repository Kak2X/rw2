; =============== Act_Wily2Shot ===============
; ID: ACT_WILY2SHOT
; Diagonal energy ball thrown towards the player.
Act_Wily2Shot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily2Shot_Init
	dw Act_Wily2Shot_Move

; =============== Act_Wily2Shot_Init ===============
Act_Wily2Shot_Init:
	call ActS_AngleToPl	; Throw towards the player...
	call ActS_DoubleSpd	; ...at double speed
	jp   ActS_IncRtnId
	
; =============== Act_Wily2Shot_Move ===============
Act_Wily2Shot_Move:
	; Move the shot at the set speed until it goes offscreen
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	ret
	
