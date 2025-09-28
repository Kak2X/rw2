; =============== Act_Wily1Bomb ===============
; ID: ACT_WILY1BOMB
; Bouncing bomb from the 1st phase of the Wily Machine.
; Does not explode.
Act_Wily1Bomb:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily1Bomb_Init
	dw Act_Wily1Bomb_JumpU
	dw Act_Wily1Bomb_JumpD

; =============== Act_Wily1Bomb_Init ===============
Act_Wily1Bomb_Init:
	call ActS_FacePl		; Jump towards the player
	ld   bc, $0100			; 1px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0300			; 3px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Wily1Bomb_JumpU ===============
Act_Wily1Bomb_JumpU:
	; Apply jump arc until we reach the peak of the jump.
	; This does not check for solid walls while going forward,
	; so they it will phase through
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedUpY
	ret  c
	jp   ActS_IncRtnId		; Then start falling down
	
; =============== Act_Wily1Bomb_JumpD ===============
Act_Wily1Bomb_JumpD:
	; Apply jump arc until we touch the ground 
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedDownYColi
	ret  c
	
	ld   bc, $0300			; Then start another identical jump
	call ActS_SetSpeedY
	jp   ActS_DecRtnId		; looping
	
