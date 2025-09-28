; =============== Act_TamaFlea ===============
; ID: ACT_TAMAFLEA
; Flea that jump out of Tama.
Act_TamaFlea:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_TamaFlea_Init
	dw Act_TamaFlea_JumpU
	dw Act_TamaFlea_JumpD
	dw Act_TamaFlea_Ground
	DEF ACTRTN_TAMAFLEA_INIT = $00
	
; =============== Act_TamaFlea_Init ===============
; Initializes some of the properties of the jump.
; Note that the speed isn't set here -- the first time we get here, our speed
; will be the one set by Act_Tama_SpawnFleas since each individual flea has
; their *first* jump at a different arc.
Act_TamaFlea_Init:
	; Use jumping sprite $01
	ld   a, $01
	call ActS_SetSprMapId
	; Always jump towards the player
	call ActS_FacePl
	jp   ActS_IncRtnId
	
; =============== Act_TamaFlea_JumpU ===============
; Jump, pre-peak.
Act_TamaFlea_JumpU:
	; Move forwards, turn if we hit a wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_TamaFlea_JumpD ===============
; Jump, post-peak.
Act_TamaFlea_JumpD:
	; Move forwards, turn if we hit a wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; The fleas, while on the ground, use a smaller sprite than their jumping one
	; so adjust the collision box to be smaller.
	ld   bc, $0303			; H Radius: 3, V Radius: 3
	call ActS_SetColiBox
	
	; Use standing sprite $00
	ld   a, $00
	call ActS_SetSprMapId
	
	; Delay the next jump by 1 second
	ld   a, 60
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_TamaFlea_Ground ===============
; Flea is on the ground.
Act_TamaFlea_Ground:
	; Wait for the second to pass before setting up a new jump
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Larger sprite when jumping (set in ACTRTN_TAMAFLEA_INIT) means larger collision box by 4px vertically
	ld   bc, $0305			; H Radius: 3, V Radius: 5
	call ActS_SetColiBox
	; Set up standard jump settings for the second jump onwards
	ld   bc, $0080			; 0.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0300			; 3px/frame up
	call ActS_SetSpeedY
	
	; Set jump settings shared with the first one
	ld   a, ACTRTN_TAMAFLEA_INIT
	ldh  [hActCur+iActRtnId], a
	ret

