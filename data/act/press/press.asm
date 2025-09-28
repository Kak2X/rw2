; =============== Act_Press ===============
; ID: ACT_PRESS
; Metallic press that drops down when the player gets close.
Act_Press:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Press_Init
	dw Act_Press_WaitPl
	dw Act_Press_FallV
	dw Act_Press_MoveU
	dw Act_Press_Cooldown
	DEF ACTRTN_PRESS_WAITPL = $01

; =============== Act_Press_Init ===============
Act_Press_Init:
	; Place between two blocks
	ldh  a, [hActCur+iActX]
	add  $08
	ldh  [hActCur+iActX], a
	
	; Keep track of the spawn position as its target.
	; After the press falls down, it will slowly move back up to that point.
	ldh  a, [hActCur+iActY]
	ldh  [hActCur+iPressSpawnY], a
	
	; Initialize gravity for later
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_Press_WaitPl ===============
Act_Press_WaitPl:
	; Waits until the player gets within 2 blocks to drop
	call ActS_GetPlDistanceX
	cp   BLOCK_H*2
	ret  nc
	jp   ActS_IncRtnId
	
; =============== Act_Press_FallV ===============
Act_Press_FallV:
	; Apply gravity until we land on a solid block
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Start slowly moving up at 0.25px/frame
	ld   bc, $0040
	call ActS_SetSpeedY
	; Clear ACTDIR_D to move up
	ldh  a, [hActCur+iActSprMap]
	and  $FF^ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	jp   ActS_IncRtnId
	
; =============== Act_Press_MoveU ===============
Act_Press_MoveU:
	; Slowly move up until we reach the original spawn position
	call ActS_ApplySpeedFwdY		; Move up
	ldh  a, [hActCur+iActY]			; B = ActY
	ld   b, a
	ldh  a, [hActCur+iPressSpawnY]	; A = TargetY
	cp   b							; ActY == TargetY?
	ret  nz							; If not, return
	
	; Wait 1.5 seconds before dropping again, that's enough for the player to pass through
	ld   a, $5A
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Press_Cooldown ===============
Act_Press_Cooldown:
	; After waiting for that...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Return to waiting for the player to get here
	ld   a, ACTRTN_PRESS_WAITPL
	ldh  [hActCur+iActRtnId], a
	ret
	
