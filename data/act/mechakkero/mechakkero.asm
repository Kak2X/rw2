; =============== Act_Mechakkero ===============
; ID: ACT_MECHAKKERO
; Hopping frog-like enemy that's hard to hit on the ground.
Act_Mechakkero:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Mechakkero_InitJump
	dw Act_Mechakkero_JumpU
	dw Act_Mechakkero_JumpD
	dw Act_Mechakkero_Wait0
	dw Act_Mechakkero_Wait1
	DEF ACTRTN_MECHAKKERO_INITJUMP = $00

; =============== Act_Mechakkero_InitJump ===============
; Initializes the jump
Act_Mechakkero_InitJump:
	; Set up jump speed
	ld   bc, $0100			; 1px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0200			; 2px/frame up
	call ActS_SetSpeedY
	
	; Face player when starting the jump
	call ActS_FacePl
	
	; Use jumping sprite
	ld   a, $02
	call ActS_SetSprMapId
	
	;--
	; [TCRF] This suggests the intention to wait for 1.5 seconds before jumping,
	;        similar to what Rockman 3 does, but the code isn't quite set up for that.
	ld   a, $5A
	ldh  [hActCur+iActTimer], a
	;--
	jp   ActS_IncRtnId
	
; =============== Act_Mechakkero_JumpU ===============
; Jump, before peak.
Act_Mechakkero_JumpU:
	; Move forward, turning around when hitting a solid wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Move up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_Mechakkero_JumpD ===============
; Jumps, after peak.
Act_Mechakkero_JumpD:
	; Move forward, turning around when hitting a solid wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Move down until we touch the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; After landing, stay on the ground for 24 frames.
	; For the first 12, use a sprite with half-closed eyes, for the latter fully open.
	
	; Use normal eyes sprite for 12 frames
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $0C
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Mechakkero_Wait0 ===============
; On the ground, normal eyes.
Act_Mechakkero_Wait0:
	; Wait for it...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Use open eyes sprite for 12 frames
	ld   a, $01
	call ActS_SetSprMapId
	ld   a, $0C
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Mechakkero_Wait1 ===============
; On the ground, open eyes.
Act_Mechakkero_Wait1:
	; Wait for it..
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	;--
	; [POI] Why return to this for a single frame?
	ld   a, $00					
	call ActS_SetSprMapId
	;--
	; Loop back to setting up the next jump
	ld   a, ACTRTN_MECHAKKERO_INITJUMP
	ldh  [hActCur+iActRtnId], a
	ret
	
