; =============== Act_Peterchy ===============
; ID: ACT_PETERCHY
; Walker enemy.	
Act_Peterchy:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Peterchy_Init
	dw Act_Peterchy_MoveH
	dw Act_Peterchy_FallV
	DEF ACTRTN_PETERCHY_MOVEH = $01
	
; =============== Act_Peterchy_Init ===============
Act_Peterchy_Init:
	; Move at 0.5px/frame, starting towards the player
	ld   bc, $0080
	call ActS_SetSpeedX
	call ActS_FacePl
	jp   ActS_IncRtnId
	
; =============== Act_Peterchy_MoveH ===============
Act_Peterchy_MoveH:
	; Use frames $00-$06 at 1/4 speed
	ld   bc, ($06 << 8)|$02
	call ActS_AnimCustom
	
	; Move forward, turning around when hitting a wall
	call ActS_MoveBySpeedX_Coli
	call nc, ActS_FlipH
	
	; If there's no ground below, start falling
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   %11
	ret  nz
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_Peterchy_FallV ===============
Act_Peterchy_FallV:
	; Use frames $00-$06 at 1/4 speed
	ld   bc, ($06 << 8)|$02
	call ActS_AnimCustom
	
	; Keep moving down until we hit solid ground.
	call ActS_ApplyGravityD_Coli
	ret  c
	
	; Return to moving forwards
	ld   a, ACTRTN_PETERCHY_MOVEH
	ldh  [hActCur+iActRtnId], a
	ret
	
