; =============== Act_Wily3Missile ===============
; ID: ACT_WILY3MISSILE
; Missile that initially homes in on the player.
Act_Wily3Missile:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily3Missile_Init
	dw Act_Wily3Missile_TrackPl
	dw Act_Wily3Missile_Move

; =============== Act_Wily3Missile_Init ===============
Act_Wily3Missile_Init:
	; Home in for the first ~second
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily3Missile_TrackPl ===============
Act_Wily3Missile_TrackPl:
	call ActS_AngleToPl			; Track player position
	call ActS_ApplySpeedFwdX	; Move precisely there
	call ActS_ApplySpeedFwdY	; ""
	ldh  a, [hActCur+iActTimer]
	sub  $01					; Done with this part?
	ldh  [hActCur+iActTimer], a
	ret  nz						; If not, return
	jp   ActS_IncRtnId
	
; =============== Act_Wily3Missile_Move ===============
Act_Wily3Missile_Move:
	; Continue moving with the last tracked speed values (last tracked player position)
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
