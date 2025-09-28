; =============== Act_Cook ===============
; ID: ACT_COOK
; Running chicken, spawned by Act_CookSpawner.
Act_Cook:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Cook_Init
	dw Act_Cook_Run
	dw Act_Cook_JumpD
	dw Act_Cook_JumpU
	DEF ACTRTN_COOK_JUMPU = $03
	
; =============== Act_Cook_Init ===============
Act_Cook_Init:
	ld   bc, $0120				; Run 1.125px/frame forwards
	call ActS_SetSpeedX
	xor  a						; Init gravity
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	; Jump after around half a second
	ld   a, $20					
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Cook_Run ===============
Act_Cook_Run:
	; Animate run cycle ($00-$03, at 1/8 speed)
	ld   c, $01
	call ActS_Anim4
	; Run forward
	call ActS_ApplySpeedFwdX
	; If there's no ground below, fall down
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   %11
	jp   z, ActS_IncRtnId
	
	; Wait half a second before triggering a jump
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	ldh  a, [hActCur+iActSprMap]	; Reset frame and timer
	and  ACTDIR_R|ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	ld   bc, $0300					; Start jump at 3px/frame
	call ActS_SetSpeedY
	
	ld   a, ACTRTN_COOK_JUMPU
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Cook_JumpD ===============
; Jump, post-peak.
Act_Cook_JumpD:
	; Force jumping sprite $01
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R|ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	
	; Continue moving forward while jumping
	call ActS_ApplySpeedFwdX
	; Move down until we touch solid ground, then return to running on the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	; Jump after around half a second of running
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_DecRtnId
	
; =============== Act_Cook_JumpU ===============
; Jump, pre-peak.
Act_Cook_JumpU:
	; Force jumping sprite $01
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R|ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	
	; Continue moving forward while jumping
	call ActS_ApplySpeedFwdX
	; Move up until we reach the peak of the jump, then go back to Act_Cook_JumpD
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_DecRtnId
	
