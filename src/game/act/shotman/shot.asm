; =============== Act_ShotmanShot ===============
; ID: ACT_SHOTMANSHOT
; Shotman's shot, which moves in an arc.
Act_ShotmanShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_ShotmanShot_JumpU
	dw Act_ShotmanShot_JumpD
; =============== Act_ShotmanShot_JumpU ===============
; Jump, pre-peak.
Act_ShotmanShot_JumpU:
	; Move shot forward at its set speed
	call ActS_MoveBySpeedX
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplyGravityU
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_ShotmanShot_JumpD ===============
; Jump, post-peak.
Act_ShotmanShot_JumpD:
	; Move shot forward at its set speed
	call ActS_MoveBySpeedX
	; Apply gravity while moving down
	call ActS_ApplyGravityD
	; The shot moves through the ground, despawning when it moves offscreen
	ret
	
