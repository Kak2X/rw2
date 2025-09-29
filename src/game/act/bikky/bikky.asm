; =============== Act_Bikky ===============
; ID: ACT_BIKKY
; Giant jumper robot.
Act_Bikky:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Bikky_Init
	dw Act_Bikky_GroundReflect
	dw Act_Bikky_GroundHit
	dw Act_Bikky_JumpU
	dw Act_Bikky_JumpD
	DEF ACTRTN_BIKKY_INIT = $00

; =============== Act_Bikky_Init ===============
; Initializes the jumps.
Act_Bikky_Init:
	; Set up jump speed for later
	ld   bc, $0080			; 0.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0300			; 3px/frame upwards
	call ActS_SetSpeedY
	
	; Start invulnerable
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	
	; With eyes closed
	ld   a, $00
	call ActS_SetSprMapId
	
	; Stay for one second like this
	ld   a, 60
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Bikky_GroundReflect ===============
; Stays on the ground, invulnerable.
Act_Bikky_GroundReflect:
	; Use frames $00-$01, at 1/8 speed, giving a shaking effect
	ld   c, $01
	call ActS_Anim2
	
	; Wait for the second...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; After the second passes, show its eyes and make it vulnerable
	ld   b, ACTCOLI_ENEMYHIT	; Vulnerable
	call ActS_SetColiType
	ld   a, $02					; Set frame $02
	call ActS_SetSprMapId
	
	; Small delay before jumping
	ld   a, $14
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Bikky_GroundHit ===============
; Stays on the ground, vulnerable.
Act_Bikky_GroundHit:
	; Wait for those 20 frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Set jumping sprite and jump towards the player.
	ld   a, $03
	call ActS_SetSprMapId
	call ActS_FacePl
	jp   ActS_IncRtnId
	
; =============== Act_Bikky_JumpU ===============
; Jumping, moving up.
Act_Bikky_JumpU:
	; Move forward, turn around if a wall is hit
	call ActS_MoveBySpeedX_Coli
	call nc, ActS_FlipH
	; Apply gravity, switch to next routine when reaching the peak of the jump
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_Bikky_JumpD ===============
; Jumping, moving down.
Act_Bikky_JumpD:
	; Move forward, turn around if a wall is hit
	call ActS_MoveBySpeedX_Coli
	call nc, ActS_FlipH
	; Apply gravity, return invulnerable on the ground and loop
	call ActS_ApplyGravityD_Coli
	ret  c
	ld   a, ACTRTN_BIKKY_INIT
	ldh  [hActCur+iActRtnId], a
	ret
	
