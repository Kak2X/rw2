; =============== Act_WoodMan ===============
Act_WoodMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_WoodMan_SpawnShield
	dw Act_WoodMan_Idle
	dw Act_WoodMan_SpawnRise
	dw Act_WoodMan_ThrowShield
	dw Act_WoodMan_SpawnFallLeaves
	dw Act_WoodMan_JumpU
	dw Act_WoodMan_JumpD
	dw Act_WoodMan_WaitShieldDespawn
	dw Act_WoodMan_WaitFallDespawn
	dw Act_WoodMan_Unused_Nop;X
	DEF ACTRTN_WOODMAN_INTRO = $00
	
; =============== Act_WoodMan_SpawnShield ===============
; Spawns the Leaf Shield.
Act_WoodMan_SpawnShield:
	; Don't throw it yet
	xor  a
	ld   [wLeafShieldOrgSpdX], a
	
	; After spawning it, idle for 16 frames (before spawning the rising leaves)
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	
	;
	; Spawn the Leaf Shield.
	; This is made of four individual leaf actors that rotate around Wood Man.
	;
	; There are $40 possible positions for the leaves (which wrap around), so to
	; have them evenly spaced out, their timer value is set to be $10 apart.
	; 
	; Since the leaves are small and the collision box is too, it's possible to
	; easily shoot through the shield, especially with the buster.
	;
	
	ld   a, ACT_LEAFSHIELD
	ld   bc, ($00 << 8)|$04	; 4px up
	call ActS_SpawnRel
	jp   c, ActS_IncRtnId
	ld   de, iActTimer
	add  hl, de
	ld   [hl], $10*0
	
	ld   a, ACT_LEAFSHIELD
	ld   bc, ($00 << 8)|$04	; 4px up
	call ActS_SpawnRel
	jp   c, ActS_IncRtnId
	ld   de, iActTimer
	add  hl, de
	ld   [hl], $10*1
	
	ld   a, ACT_LEAFSHIELD
	ld   bc, ($00 << 8)|$04	; 4px up
	call ActS_SpawnRel
	jp   c, ActS_IncRtnId
	ld   de, iActTimer
	add  hl, de
	ld   [hl], $10*2
	
	ld   a, ACT_LEAFSHIELD
	ld   bc, ($00 << 8)|$04	; 4px up
	call ActS_SpawnRel
	jp   c, ActS_IncRtnId
	ld   de, iActTimer
	add  hl, de
	ld   [hl], $10*3
	
	jp   ActS_IncRtnId
	
; =============== Act_WoodMan_Idle ===============
; Idle, on the ground.
Act_WoodMan_Idle:
	; Wait 16 frames in the idle animation
	call Act_WoodMan_AnimIdle
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Spawn three rising leaves
	ld   a, $03
	ldh  [hActCur+iWoodManRiseLeft], a
	; Wait 16 frames (total 32)
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_WoodMan_SpawnRise ===============
; Spawns rising leaves, while idling.
Act_WoodMan_SpawnRise:
	; Wait 16 frames in the idle animation (cooldown)
	call Act_WoodMan_AnimIdle
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Spawn a leaf moving straight up
	ld   a, ACT_LEAFRISE
	ld   bc, $0000
	call ActS_SpawnRel
	
	; Wait 16 frames before spawning another one
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	
	; If we haven't spawned all 3 leaves, loop this routine
	ld   hl, hActCur+iWoodManRiseLeft
	dec  [hl]
	ret  nz
	
	jp   ActS_IncRtnId
	
; =============== Act_WoodMan_ThrowShield ===============
; Waits for the rising leaves to despawn before throwing the shield.
Act_WoodMan_ThrowShield:
	;
	; Continue with the idle animation until all rising leaves have gone offscreen.
	;
	call Act_WoodMan_AnimIdle
	ld   a, ACT_LEAFRISE
	call ActS_CountById
	ld   a, b
	and  a			; Leaf count > 0?
	ret  nz			; If so, wait
	
	; Face the player in preparation for jumping towards him
	call ActS_FacePl
	
	;
	; Signal out to the shield actors to throw the shield forwards at 1px/frame.
	;
	; This signal is the movement speed for the shield's origin,
	; so it should be $01 if it's moving right, $FF if it's moving left.
	;
	; That's close to the return value of ActS_GetPlDistanceX, but it needs some mungling first.
	;
	call ActS_GetPlDistanceX	; C Flag = Player is on the right
	ld   a, $00					; Start from blank canvas ("xor a" clears the C flag, can't use it)
	sbc  a						; Treat C as -1 to have one of them with all bits flipped (R -> $FF, L -> $00)
	and  $02					; Only keep bit1 (R -> $02, L -> $00)
	dec  a						; Shift down into place, with equal distance (R -> $01, L -> $FF)
	ld   [wLeafShieldOrgSpdX], a
	
	; Wait ~half a second before
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_WoodMan_SpawnFallLeaves ===============
; Spawns the falling leaves and sets up the forward jump.
Act_WoodMan_SpawnFallLeaves:
	; Rise arms up for ~half a second...
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; ...before making three leaves SLOWLY fall down the screen.
	; These leaves fall from the top of the screen, moving back and forth
	; They all use the same Y position, while horizontally spread across the screen.
	
	ld   a, ACT_LEAFFALL
	ld   bc, ($00 << 8)|LOW(-$60) 	; [POI] 6 blocks above for testing, perhaps? Will be overwritten by Act_WoodMan_SetLeafFallPos
	call ActS_SpawnRel
	ld   a, OBJ_OFFSET_X+$10		; X Pos = $18
	call nc, Act_WoodMan_SetLeafFallPos
	
	ld   a, ACT_LEAFFALL
	ld   bc, $0000
	call ActS_SpawnRel
	ld   a, OBJ_OFFSET_X+$41		; X Pos = $49
	call nc, Act_WoodMan_SetLeafFallPos
	
	ld   a, ACT_LEAFFALL
	ld   bc, $0000
	call ActS_SpawnRel
	ld   a, OBJ_OFFSET_X+$70		; X Pos = $78
	call nc, Act_WoodMan_SetLeafFallPos
	
	;
	; Set up forward hop while the leaves are falling.
	;
	call ActS_FacePl		; Towards player
	ld   bc, $0080			; 0.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0200			; 2px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_WoodMan_JumpU ===============
; Jump, pre-peak.
Act_WoodMan_JumpU:
	; Use jumping sprite
	ld   a, $08
	ld   [wActCurSprMapBaseId], a
	
	; Move forward, stopping on solid walls
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving up, until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_WoodMan_JumpD ===============
; Jump, post-peak.
Act_WoodMan_JumpD:
	; Use jumping sprite
	ld   a, $08
	ld   [wActCurSprMapBaseId], a
	; Move forward, stopping on solid walls
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving down, until we touch solid ground
	call ActS_ApplySpeedDownYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_WoodMan_WaitShieldDespawn ===============
; Waits until the Leaf Shield has fully despawned.
Act_WoodMan_WaitShieldDespawn:
	ld   a, ACT_LEAFSHIELD
	call ActS_CountById		; Get leaf count
	ld   a, b 
	and  a					; Is it != 0?
	ret  nz					; If so, return
	
	jp   ActS_IncRtnId
	
; =============== Act_WoodMan_WaitFallDespawn ===============
; Waits until the falling leaves have fully despawned, then loops the pattern.
Act_WoodMan_WaitFallDespawn:
	ld   a, ACT_LEAFFALL
	call ActS_CountById
	ld   a, b
	and  a
	ret  nz
	; [BUG] Improper loop point
	ld   a, ACTRTN_WOODMAN_INTRO
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_WoodMan_Unused_Nop ===============
Act_WoodMan_Unused_Nop:
	ret
	
; =============== Act_WoodMan_AnimIdle ===============
; Handles the idle animation cycle while on the ground.
Act_WoodMan_AnimIdle:
	; Use sprites $03-$04 at 1/8 speed
	ldh  a, [hTimer]
	rrca ; /2
	rrca ; /4
	rrca ; /8 Every 8 frames...
	and  $01 ; Alternate between $00 and $01
	add  $03 ; Offset by $03
	ld   [wActCurSprMapBaseId], a
	ret
	
; =============== Act_WoodMan_SetLeafFallPos ===============
; Sets the spawn coordinates for the falling leaves.
; IN
; - HL: Ptr to spawned Act_WoodManLeafFall
; - A: X Position
Act_WoodMan_SetLeafFallPos:
	ld   de, iActX
	add  hl, de
	ldi  [hl], a				; iActX = A, seek to iActYSub
	inc  hl ; iActY
	ld   [hl], OBJ_OFFSET_Y+$20	; iActY = $30 (near the top of the screen)
	ret
	
