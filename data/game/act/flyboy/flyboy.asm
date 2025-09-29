; =============== Act_FlyBoy ===============
; ID: ACT_FLYBOY
; An easy to miss propeller enemy that homes in the player.
; Spawned by Act_FlyBoySpawner, never part of the actor layout.
Act_FlyBoy:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_FlyBoy_Init
	dw Act_FlyBoy_JumpD
	dw Act_FlyBoy_Ground
	dw Act_FlyBoy_LiftOff
	dw Act_FlyBoy_JumpU
	DEF ACTRTN_FLYBOY_JUMPD = $01

; =============== Act_FlyBoy_Init ===============
Act_FlyBoy_Init:
	ld   a, $00				; Use normal sprite	
	call ActS_SetSprMapId
	ld   bc, $0040			; 0.25px/frame speed
	call ActS_SetSpeedX
	
	; Prepare for falling down, as these enemies are spawned in the air
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_FlyBoy_JumpD ===============
; Jump arc, post-peak.
Act_FlyBoy_JumpD:
	; (No animation, use sprite $00 while moving down)
	
	; Handle jump arc until touching the ground
	call ActS_MoveBySpeedX_Coli
	call ActS_ApplyGravityD_Coli
	ret  c
	; Wait 32 frames on the ground
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_FlyBoy_Ground ===============
; Grounded.
Act_FlyBoy_Ground:
	; While on the ground and also a bit after, the enemy tries to propel itself up.
	; This animation will play until after the next jump's peak.
	ld   c, $01
	call ActS_Anim2
	
	; Wait for it...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; After 32 frames, start slowly moving up for around 3 seconds
	ld   bc, $0040			; 0.25px/frame up
	call ActS_SetSpeedY
	ld   a, $C0				; ~3 seconds
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_FlyBoy_LiftOff ===============
; Slowly moving up.
Act_FlyBoy_LiftOff:
	; Continue with the propelling animation
	ld   c, $01
	call ActS_Anim2
	
	; Move slowly 0.25px/frame up for 3 seconds
	call ActS_MoveBySpeedYColi
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; Set up the jump arc for precisely targeting the player:
	; H Speed: (PlDistance * 4)*subpixels*/frame
	; V Speed: 2px/frame
	;
	call ActS_FacePl
	
	call ActS_GetPlDistanceX
	ld   c, a
	ld   b, $00
	call ActS_SetSpeedX
	call ActS_DoubleSpd	
	call ActS_DoubleSpd
	
	ld   bc, $0200
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_FlyBoy_JumpU ===============
; Jump arc, pre-peak.
Act_FlyBoy_JumpU:
	; Use flying animation ($00-$01) at 1/8 speed
	; This is only used when moving up.
	ld   c, $01
	call ActS_Anim2
	; Handle the jump arc until we reach the peak
	call ActS_MoveBySpeedX_Coli
	call ActS_ApplyGravityU_Coli
	ret  c
	; Start moving down then
	ld   a, ACTRTN_FLYBOY_JUMPD
	ldh  [hActCur+iActRtnId], a
	ret
	
