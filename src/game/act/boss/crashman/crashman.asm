; =============== Act_CrashMan ===============
; ID: ACT_CRASHMAN
Act_CrashMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_CrashMan_InitWalk
	dw Act_CrashMan_Walk
	dw Act_CrashMan_InitJump
	dw Act_CrashMan_JumpU
	dw Act_CrashMan_JumpShootD
	dw Act_CrashMan_JumpD1
	dw Act_CrashMan_JumpD2
	DEF ACTRTN_CRASHMAN_INTRO = $00
	
; =============== Act_CrashMan_InitWalk ===============
; Sets up walking.
Act_CrashMan_InitWalk:
	xor  a							; Reset walk cycle
	ldh  [hActCur+iCrashManWalkTimer], a
	ld   bc, $00E0					; Move 0.875px/frame forward
	call ActS_SetSpeedX
	ld   a, $80						; Walk for ~2 seconds at most
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_CrashMan_Walk ===============
; Walking on the ground.
Act_CrashMan_Walk:
	;
	; Animate walk cycle.
	; Use sprites $03-$06 at 1/8 speed.
	;
	ld   hl, hActCur+iCrashManWalkTimer
	ld   a, [hl]		; Get current walk timer
	inc  [hl]			; WalkTimer++
	rrca ; /2
	rrca ; /4
	rrca ; /8			; Advance anim every 8 frames
	and  $03			; 4 sprite cycle
	add  $03			; Starting at $03
	ld   [wActCurSprMapBaseId], a
	
	;
	; If the player is shooting, retaliate.
	; Specifically, if the player shot in the first slot is active, retaliate.
	; This leads to similar results to what RM2 did, which was going off a B button press.
	;
	ld   a, [wShot0]		; Get shot ID. If it's active, it will be >= $80
	add  a					; Does *2 overflow it?
	jp   c, ActS_IncRtnId	; If so, a shot is active, so cut the wait early
	
	;
	; After waiting ~2 seconds, retaliate on our own.
	; This is unlike RM2, where Crash Man can wait indefinitely until the player shoots.
	;
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a	; Timer--
	jp   z, ActS_IncRtnId			; Timer == 0? If so, jump
	
	; Move forward at 0.875px/frame, turning around when a solid wall is in the way
	call ActS_MoveBySpeedX_Coli	; Perform movement
	ret  c							; Hit a wall? If not, return
	;--								; Otherwise, flip
	; This is ActS_FlipH done manually, why.
	ld   hl, hActCur+iActSprMap
	ld   a, ACTDIR_R
	xor  [hl]
	ld   [hl], a
	;--
	ret
	
; =============== Act_CrashMan_InitJump ===============
; Sets up a jump directly at the player.
Act_CrashMan_InitJump:
	; Jump towards the player
	call ActS_FacePl
	; X Speed: (DiffX * 4)subpx/frame
	call ActS_GetPlDistanceX	; A = Diff
	ld   l, a
	ld   h, $00					; to HL
	add  hl, hl					; *2
	add  hl, hl					; *4
	ld   a, l					; Set result
	ldh  [hActCur+iActSpdXSub], a
	ld   a, h
	ldh  [hActCur+iActSpdX], a
	
	ld   bc, $0400			; Y Speed: 4px/frame
	call ActS_SetSpeedY
	
	jp   ActS_IncRtnId
	
; =============== Act_CrashMan_JumpU ===============
; Jump, pre-peak.
Act_CrashMan_JumpU:
	; Use jumping sprite
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	
	; Jump forward, stopping on solid blocks
	call ActS_MoveBySpeedX_Coli
	; Apply gravity while moving up, until we reach the peak
	call ActS_ApplyGravityU_Coli
	ret  c
	; Wait 8 frames before
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_CrashMan_JumpShootD ===============
; Jump, post-peak. (can shoot Crash Bomb)
Act_CrashMan_JumpShootD:
	; Use jumping sprite (identical to $07)
	ld   a, $08
	ld   [wActCurSprMapBaseId], a
	
	; Jump forward, stopping on solid blocks
	call ActS_MoveBySpeedX_Coli
	; Apply gravity while moving down...
	; No end check due to the high jump arc and level layout in the boss room,
	; not making it possible to touch the ground in this routine (or the next one).
	call ActS_ApplyGravityD_Coli
	
	; Wait for those 8 frames...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; Spawn a Crash Bomb, which travels diagonally, if one isn't already spawned.
	;
	; The spawn check goes off the explosion actor because by the time Crash Man gets to 
	; fire another bomb, even at the earliest possible time, the old Crash Bomb will have already exploded.
	;
	ld   a, ACT_CRASHBOMBEXPL
	call ActS_CountById
	ld   a, b				; A = Crash Bomb count
	and  a					; Is that != 0?
	jr   nz, .nextMode		; If so, skip
	
	ld   a, ACT_CRASHBOMB	; Otherwise, spawn at the current position
	ld   bc, $0000
	call ActS_SpawnRel
.nextMode:
	; Continue the jump down while displaying the shooting sprite $09 for 8 frames.
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_CrashMan_JumpD1 ===============
; Jump, post-peak (sprite $09).
Act_CrashMan_JumpD1:
	; Use jumping/shooting sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	; Jump forward, stopping on solid blocks
	call ActS_MoveBySpeedX_Coli
	; Apply gravity while moving down...
	call ActS_ApplyGravityD_Coli
	
	; Wait for those 8 frames...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Continue the jump down while displaying sprite $09 until we touch the ground
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_CrashMan_JumpD2 ===============
; Jump, post-peak (sprite $07).
Act_CrashMan_JumpD2:
	; Use jumping sprite 2
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; Jump forward, stopping on solid blocks
	call ActS_MoveBySpeedX_Coli
	; Apply gravity while moving down, until we touch a solid block.
	call ActS_ApplyGravityD_Coli
	ret  c
	; [BUG] Resetting to the intro, not Act_CrashMan_InitWalk
	ld   a, ACTRTN_CRASHMAN_INTRO
	ldh  [hActCur+iActRtnId], a
	ret
	
