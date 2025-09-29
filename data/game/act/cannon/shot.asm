; =============== Act_CannonShot ===============
; ID: ACT_CANNONSHOT
; A cannon firing balls in an arc.
; Has identical code to Act_NewShotmanShotV.
Act_CannonShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_CannonShot_JumpU
	dw Act_CannonShot_JumpD
; =============== Act_CannonShot_JumpU ===============
; Jump, pre-peak.
Act_CannonShot_JumpU:
	; [POI] Bounce on solid walls
	call ActS_MoveBySpeedX_Coli
	call nc, ActS_FlipH
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_IncRtnId
; =============== Act_CannonShot_JumpD ===============
; Jump, post-peak.
Act_CannonShot_JumpD:
	; [POI] Bounce on solid walls
	call ActS_MoveBySpeedX_Coli
	call nc, ActS_FlipH
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplyGravityD_Coli
	ret  c
	; Despawn when touching the ground
	jp   ActS_Explode

