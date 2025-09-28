; =============== Act_FrienderFlame ===============
; ID: ACT_FLAME
; Flame projectile fired by Friender.
Act_FrienderFlame:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_FrienderFlame_Init
	dw Act_FrienderFlame_Move

; =============== Act_FrienderFlame_Init ===============
Act_FrienderFlame_Init:
	; Set the shot's initial movement speed
	ldh  a, [hActCur+iActSprMap]
	or   ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ld   bc, $01C0			; 1.75px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0300			; 3px/frame down (ACTDIR_D set)
	call ActS_SetSpeedY
	
	jp   ActS_IncRtnId
	
; =============== Act_FrienderFlame_Move ===============
Act_FrienderFlame_Move:
	; Apply the movement speed in an arc.
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	
	; Apply upwards gravity at 0.125px/frame
	ldh  a, [hActCur+iActSpdYSub]	; HL = iActSpdY*
	ld   l, a
	ldh  a, [hActCur+iActSpdY]
	ld   h, a
	ld   de, -$20					; Move $20 subpixels up
	add  hl, de
	ld   a, l						; Save back
	ldh  [hActCur+iActSpdYSub], a
	ld   a, h
	ldh  [hActCur+iActSpdY], a
	ret
	
