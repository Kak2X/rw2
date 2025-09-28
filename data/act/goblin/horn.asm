; =============== Act_GoblinHorn ===============
; ID: ACT_GOBLINHORN
; Retractable horns that only show up when the player is standing on the goblin platform.
; Spawned by Act_Goblin.
Act_GoblinHorn:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_GoblinHorn_Init
	dw Act_GoblinHorn_MoveU
	dw Act_GoblinHorn_Idle
	dw Act_GoblinHorn_MoveD

; =============== Act_GoblinHorn_Init ===============
Act_GoblinHorn_Init:
	; Move up at 0.125px/frame
	ld   hl, hActCur+iActSprMap
	res  ACTDIRB_D, [hl]
	ld   bc, $0020
	call ActS_SetSpeedY
	; Move for ~1 second 
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_GoblinHorn_MoveU ===============
; Horn emerges from the top of the platform.
Act_GoblinHorn_MoveU:
	; Move up at 0.125px/frame for that ~1 second (total movement: 1 block)
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Wait for ~1 second
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_GoblinHorn_Idle ===============
; Horn is idle
Act_GoblinHorn_Idle:
	; Wait for it
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Move down at 0.5px/frame
	ld   hl, hActCur+iActSprMap
	set  ACTDIRB_D, [hl]
	ld   bc, $0080
	call ActS_SetSpeedY
	
	; Move for 16 frames 
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_GoblinHorn_MoveD ===============
; Horn retracts, then despawns.
Act_GoblinHorn_MoveD:
	; Move down at 0.5px/frame for 16 frames (total movement: half a block)
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; After that, despawn the horn.
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
