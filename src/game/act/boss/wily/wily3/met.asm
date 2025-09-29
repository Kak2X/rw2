; =============== Act_Wily3Met ===============
; ID: ACT_WILY3MET
; Off-model Mets(?) launched up by the final boss. Four are spawned at once.
Act_Wily3Met:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily3Met_Init
	dw Act_Wily3Met_JumpU
	dw Act_Wily3Met_JumpD

; =============== Act_Wily3Met_Init ===============
Act_Wily3Met_Init:
	call ActS_FacePl		; Move towards the player
	ld   bc, $0440			; Y Speed: 4.25px/frame up
	call ActS_SetSpeedY
	; X Speed set by the spawner code in Act_Wily3, since it varies for each spawned instance of the set.
	jp   ActS_IncRtnId
	
; =============== Act_Wily3Met_JumpU ===============
; Jump, pre-peak.
Act_Wily3Met_JumpU:
	; (Use normal sprite $00)
	; Apply jump arc until we reach the peak of the jump.
	call ActS_MoveBySpeedX
	call ActS_ApplyGravityU
	ret  c
	jp   ActS_IncRtnId		; Then start falling down
	
; =============== Act_Wily3Met_JumpD ===============
; Jump, post-peak.
Act_Wily3Met_JumpD:
	; Use upside down sprite $01
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	; Apply jump arc until we get offscreened 
	call ActS_MoveBySpeedX
	call ActS_ApplyGravityD
	ret
	
