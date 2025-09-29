; =============== Act_HariHarry ===============
; ID: ACT_HARI
; Hari Harry, a porcupine shooting needles that's invulnerable while rolling.
Act_HariHarry:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_HariHarry_InitIdle
	dw Act_HariHarry_Idle
	dw Act_HariHarry_InitShoot
	dw Act_HariHarry_Shoot
	dw Act_HariHarry_InitShoot
	dw Act_HariHarry_Shoot
	dw Act_HariHarry_InitMove
	dw Act_HariHarry_MoveH
	dw Act_HariHarry_FallV
	DEF ACTRTN_HARI_INITSHOOT = $02
	DEF ACTRTN_HARI_MOVEH = $07

; =============== Act_HariHarry_InitIdle ===============
Act_HariHarry_InitIdle:
	; The enemy is initially idle for two seconds, vulnerable to shots
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	
	ld   bc, $0180			; 1.5px/frame forward when moving
	call ActS_SetSpeedX
	
	ld   a, 60*2			; Wait idle for 2 seconds
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_Idle ===============
Act_HariHarry_Idle:
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_InitShoot ===============
; Prepare for shooting the needles.
Act_HariHarry_InitShoot:
	ld   a, $00
	ldh  [hActCur+iActTimer], a
	; Face the player in preparation for moving after shooting them
	call ActS_FacePl
	; Reset sprite to idle in case we got here after rolling
	ld   a, $00
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_Shoot ===============
; Enemy shoots the needles.
; This will happen twice on each cycle.
Act_HariHarry_Shoot:
	;
	; Shoot the needles right in the middle of the shooting sprite range (see below)
	;
	ldh  a, [hActCur+iActTimer]
	add  $01
	ldh  [hActCur+iActTimer], a
	cp   $18				; Timer == $18?
	jr   nz, .chkAnim		; If not, skip
	
	push af
		call Act_Hari_SpawnShots
	pop  af
	
.chkAnim:

	;
	; For the animation, alternate between the idle and shooting sprites every 16 frames.
	; This will switch it 3 times effectively:
	; $00-$0F -> Idle
	; $10-$1F -> Shoot
	; $20-$2F -> Idle
	; $30 -> (Next mode)
	;
	srl  a	; A >>= 4 for 16-frame ranges
	srl  a
	srl  a
	srl  a
	
	cp   ($30 >> 4)		; iActTimer == $30?	
	jr   z, .nextMode	; If so, next mode
.tryAnimShoot:
	and  $01			; Alternate between idle and shoot
	ld   a, a
	ld   [wActCurSprMapBaseId], a
	ret
.nextMode:
	ld   a, $00
	ld   [wActCurSprMapBaseId], a
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_InitMove ===============
; Sets up rolling forward.
Act_HariHarry_InitMove:
	; Roll towards the player for 1.5 seconds, while invulnerable
	ld   a, $5A
	ldh  [hActCur+iActTimer], a
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	call ActS_FacePl
	
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_MoveH ===============
; Roll forwards.
Act_HariHarry_MoveH:
	; Use frames $02-$03 at 1/8 speed
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ld   c, $01
	call ActS_Anim2
	
	; Wait for half a second before returning to shoot
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	jr   nz, .move
	
.endRoll:
	; Make vulnerable again when upright
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	; Prepare to shoot once more
	ld   a, ACTRTN_HARI_INITSHOOT
	ldh  [hActCur+iActRtnId], a
	ret
	
.move:
	; Move forward, turning around when hitting a wall
	call ActS_MoveBySpeedX_Coli
	call nc, ActS_FlipH
	
	; If there's no ground below, start falling
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   $03
	ret  nz
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	jp   ActS_IncRtnId
	
; =============== Act_HariHarry_FallV ===============
; Falls down in the air.
; During this, the rolling timer does not tick down.
Act_HariHarry_FallV:
	; Use frames $02-$03 at 1/8 speed
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ld   c, $01
	call ActS_Anim2
	
	; Keep moving down until we hit solid ground.
	call ActS_ApplyGravityD_Coli
	ret  c
	
	; Return to rolling forwards
	ld   a, ACTRTN_HARI_MOVEH
	ldh  [hActCur+iActRtnId], a
	ret	
	
