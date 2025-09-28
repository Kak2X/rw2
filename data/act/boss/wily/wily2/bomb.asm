; =============== Act_Wily2Bomb ===============
; ID: ACT_WILY2BOMB
; Bouncing bomb from the 2nd phase of the Wily Machine.
; Does explode.
Act_Wily2Bomb:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily2Bomb_Init
	dw Act_Wily2Bomb_JumpU
	dw Act_Wily2Bomb_JumpD
	dw Act_Wily2Bomb_InitShot
	dw Act_Wily2Bomb_Shot
	DEF ACTRTN_WILY2BOMB_INITSHOT = $03
	
; =============== Act_Wily2Bomb_Init ===============
Act_Wily2Bomb_Init:
	call ActS_FacePl		; Jump towards the player
	ld   bc, $0080			; 0.5px/frame forward
	call ActS_SetSpeedX
	; No vertical movement yet, just fall down the first time
	jp   ActS_IncRtnId
	
; =============== Act_Wily2Bomb_JumpU ===============
Act_Wily2Bomb_JumpU:
	; Apply jump arc until we reach the peak of the jump.
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId			; Then start falling down
	
; =============== Act_Wily2Bomb_JumpD ===============
Act_Wily2Bomb_JumpD:
	; Apply jump arc until we touch the ground 
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedDownYColi
	ret  c
	
	;
	; When touching the ground, explode only if the player has gone past the bomb.
	; Otherwise, do another high jump at 3.5px/frame.
	;
	
	ld   bc, $0380					; Prepare 3.5px/frame in case we go back to Act_Wily2Bomb_JumpU
	call ActS_SetSpeedY
	
	; Check if the player is behind the bomb, similarly to Act_Wily2_ChkPlBehind,
	; except simpler since the bomb is guaranteed to not animate (so there's no need to filter directions)
	ldh  a, [hActCur+iActSprMap]	; Save unmodified iActSprMap for later
	push af
		call ActS_FacePl			; Face the player. This may or may not modify the directions.
	pop  af
	ld   hl, hActCur+iActSprMap		; Get new iActSprMap
	cp   [hl]						; Are the new directions unchanged from the old ones?
	ld   [hl], a					; (restore original iActSprMap, as if ActS_FacePl was never called)
	jp   z, ActS_DecRtnId			; If so, return (go back doing another jump)
	
	;
	; Otherwise, explode!
	; This causes two shots to travel diagonally up in both directions.
	; The moving shot is handled by the next routine, so a second instance of the bomb
	; is spawned that directly starts there.
	;
	
	; LEFT SHOT
	; The current actor is already moving left, so use it as left shot.
	res  ACTDIRB_D, [hl]			; We were moving down though, so make it move up
	
	; RIGHT SHOT
	ld   a, ACT_WILY2BOMB			; Spawn a new bomb instance
	ld   bc, $0000
	call ActS_SpawnRel
	inc  hl ; iActRtnId				; Start in the explosion routine
	ld   [hl], ACTRTN_WILY2BOMB_INITSHOT
	inc  hl ; iActSprMap
	ldh  a, [hActCur+iActSprMap]	; Face right
	xor  ACTDIR_R					; Could have been "or"
	ld   [hl], a
	
	jp   ActS_IncRtnId				; Start left shot
	
; =============== Act_Wily2Bomb_InitShot ===============
Act_Wily2Bomb_InitShot:
	; [POI] The collision box is not being altered from the bomb, which is extremely misleading
	;       as the shot's sprite is 8x8 compared to the bomb's 16x16.
	ld   a, $01					; Use shot sprite
	call ActS_SetSprMapId
	ld   bc, $0100				; Move forward 1px/frame
	call ActS_SetSpeedX
	ld   bc, $0100				; Move up 1px/frame
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Wily2Bomb_Shot ===============
Act_Wily2Bomb_Shot:
	; Apply movement until it goes offscreen
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
