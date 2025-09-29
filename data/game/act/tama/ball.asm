; =============== Act_TamaBall ===============
; ID: ACT_TAMABALL
; Bouncing yarn ball thrown by Tama.
Act_TamaBall:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_TamaBall_InitSpdX
	dw Act_TamaBall_InitJump
	dw Act_TamaBall_JumpU
	dw Act_TamaBall_JumpD
	DEF ACTRTN_TAMABALL_INITJUMP = $01
	
; =============== Act_TamaBall_InitSpdX ===============
; Initializes the horizontal speed, which never changes.
Act_TamaBall_InitSpdX:
	; Move towards the player at 0.5px/frame
	call ActS_FacePl
	ld   bc, $0080
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_TamaBall_InitJump ===============
; Sets up the next jump.
Act_TamaBall_InitJump:
	; Set jump at 2px/frame
	ld   bc, $0200
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_TamaBall_JumpU ===============
; Jump, pre-peak.
Act_TamaBall_JumpU:
	; Move forwards, turn if we hit a wall
	call ActS_MoveBySpeedX_Coli
	call nc, ActS_FlipH
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_TamaBall_JumpD ===============
; Jump, post-peak.
Act_TamaBall_JumpD:
	; Move forwards, turn if we hit a wall
	call ActS_MoveBySpeedX_Coli
	call nc, ActS_FlipH
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplyGravityD_Coli
	ret  c
	; Then set up another jump
	ld   a, ACTRTN_TAMABALL_INITJUMP
	ldh  [hActCur+iActRtnId], a
	ret
	
