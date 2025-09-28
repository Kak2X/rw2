; =============== Act_Robbit ===============
; ID: ACT_ROBBIT
; Hopping rabbit throwing carrots at the player.
Act_Robbit:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Robbit_InitJump
	dw Act_Robbit_JumpU
	dw Act_Robbit_JumpD
	dw Act_Robbit_Ground
	dw Act_Robbit_Cooldown
	DEF ACTRTN_ROBBIT_INITJUMP = $00
	
; =============== Act_Robbit_InitJump ===============
Act_Robbit_InitJump:
	call ActS_FacePl		; Jump towards the player
	ld   bc, $0100			; 1px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0240			; 2.25px/frame up
	call ActS_SetSpeedY
	ld   a, $01				; Use jumping sprite
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_Robbit_JumpU ===============
; Jump, pre-peak.
Act_Robbit_JumpU:
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedUpYColi
	ret  c
	; Reached the peak, start moving down
	jp   ActS_IncRtnId
	
; =============== Act_Robbit_JumpD ===============
; Jump, post-peak.
Act_Robbit_JumpD:
	call ActS_ApplySpeedFwdXColi
	call ActS_ApplySpeedDownYColi
	ret  c
	; We landed on ground.
	
	ld   a, $03						; Fire 3 carrots at the player
	ldh  [hActCur+iRobbitCarrotsLeft], a
	
	ld   a, $00						; Use standing sprite
	call ActS_SetSprMapId
	ld   a, $40						; ~1 second delay between shots, and at the start
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Robbit_Ground ===============
Act_Robbit_Ground:
	; Wait for cooldown before shooting
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Face the player every time we're about to shoot
	call ActS_FacePl
	
	ld   a, ACT_CARROT
	ld   bc, $0000
	call ActS_SpawnRel
	
	ld   hl, hActCur+iRobbitCarrotsLeft
	dec  [hl]							; # Ran out of carrots?
	ld   a, $40							; Cooldown of ~1 sec after shooting
	ldh  [hActCur+iActTimer], a
	ret  nz								; # If not, return
	jp   ActS_IncRtnId					; # Otherwise, wait that second before jumping
	
; =============== Act_Robbit_Cooldown ===============
Act_Robbit_Cooldown:
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	ld   a, ACTRTN_ROBBIT_INITJUMP
	ldh  [hActCur+iActRtnId], a
	ret
	
