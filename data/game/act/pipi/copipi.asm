; =============== Act_Copipi ===============
; ID: ACT_COPIPI
; Small bird that spawns from an egg.
Act_Copipi:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Copipi_InitSpread
	dw Act_Copipi_Spread
	dw Act_Copipi_Fly

; =============== Act_Copipi_InitSpread ===============
Act_Copipi_InitSpread:
	; How long the birds should spread out
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Copipi_Spread ===============
; Animates the small bird spreading out from the egg's origin.
Act_Copipi_Spread:
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Move from the egg into the initial formation
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	
	; Wait for those 32 frames...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Once that's all done, target the player's position at the time of the check.
	call ActS_AngleToPl
	jp   ActS_IncRtnId
	
; =============== Act_Copipi_Fly ===============
Act_Copipi_Fly:
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	; Move hopefully towards the player
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	ret
	
