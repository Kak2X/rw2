; =============== Act_MagnetMan ===============
; ID: ACT_MAGNETMAN
Act_MagnetMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_MagnetMan_InitFwdJump0
	dw Act_MagnetMan_JumpU
	dw Act_MagnetMan_JumpD
	dw Act_MagnetMan_InitFwdJump1
	dw Act_MagnetMan_JumpU
	dw Act_MagnetMan_JumpD
	dw Act_MagnetMan_ChkAttack
	dw Act_MagnetMan_JumpU
	dw Act_MagnetMan_InitSpawnMissile
	dw Act_MagnetMan_SpawnMissile
	dw Act_MagnetMan_InitSpawnMissile
	dw Act_MagnetMan_SpawnMissile
	dw Act_MagnetMan_InitSpawnMissile
	dw Act_MagnetMan_SpawnMissile
	dw Act_MagnetMan_JumpD
	dw Act_MagnetMan_InitCooldown
	dw Act_MagnetMan_Cooldown
	dw Act_MagnetMan_Attract
	DEF ACTRTN_MAGNETMAN_INITFWDJUMP0 = $01
	DEF ACTRTN_MAGNETMAN_INITCOOLDOWN = $10
	DEF ACTRTN_MAGNETMAN_ATTRACT = $12
	
; =============== Act_MagnetMan_InitFwdJump0 ===============
; Sets up the first of the two forward hops.
; These hops are notoriously hard to slide under due to misaligned sprite mappings.
Act_MagnetMan_InitFwdJump0:

	; X Speed = 1.375px/frame to the other side
	ld   bc, $0160			
	call ActS_SetSpeedX
	; For this to work it assumes Magnet Man to be at X positions $80-$8F when starting hops.
	ldh  a, [hActCur+iActX]
	and  ACTDIR_R					; Left side -> $00, Right side -> $80
	xor  ACTDIR_R					; Face the opposite side. That's our ACTDIR_*
	ldh  [hActCur+iActSprMap], a
	
	; Y Speed = 2px/frame
	ld   bc, $0200
	call ActS_SetSpeedY
	
	; Use jumping sprite $05
	ld   a, $05
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_MagnetMan_JumpU ===============
; Jump, pre-peak.
; This and the next routines are used to handle all jumps.
Act_MagnetMan_JumpU:
	; Apply gravity until the peak of the jump
	call ActS_MoveBySpeedX_Coli
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_MagnetMan_JumpD ===============
; Jump, post-peak.
Act_MagnetMan_JumpD:
	; Apply gravity until we touch the ground
	call ActS_MoveBySpeedX_Coli
	call ActS_ApplyGravityD_Coli
	ret  c
	
	; Then temporarily stand on the ground for 6 frames, using sprite $00
	ld   a, $06
	ldh  [hActCur+iActTimer], a
	ld   a, $00
	call ActS_SetSprMapId
	
	jp   ActS_IncRtnId
	
; =============== Act_MagnetMan_InitFwdJump1 ===============
; Sets up the second of the two forward hops.
Act_MagnetMan_InitFwdJump1:
	; Wait those 6 frames...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Y Speed = 3px/frame
	; This is the jump Rockman should slide under.
	ld   bc, $0300
	call ActS_SetSpeedY
	
	; (Keep same X speed as before)
	
	; Use jumping sprite $05
	ld   a, $05
	call ActS_SetSprMapId
	
	jp   ActS_IncRtnId ; Continue to another Act_MagnetMan_JumpU
	
; =============== Act_MagnetMan_ChkAttack ===============
; On the ground, determining the attack to perform.
Act_MagnetMan_ChkAttack:
	; Both attacks are done while facing the player.
	call ActS_FacePl
	
	;
	; Magnet Man has two attacks.
	; If the player is further away than 3 blocks, he has a 50% chance of attracting Rockman.
	; In any other case, he jumps straight up and fires three Magnet Missiles.
	;
	; The first attack is notoriously difficult to trigger when fighting the boss properly,
	; as having to slide under the second hop keeps the player within 3 blocks of distance.
	;
	
	; Don't attract if too close
	call ActS_GetPlDistanceX
	cp   $30				; DiffX >= $30?
	jr   nc, .chkAttr		; If so, jump
.missile:
	ld   bc, $0000			; Set jump straight up at 4.25px/frame
	call ActS_SetSpeedX
	ld   bc, $0440
	call ActS_SetSpeedY
	ld   a, $05				; Use jumping sprite
	call ActS_SetSprMapId
	jp   ActS_IncRtnId		; Next mode
	
.chkAttr:
	; 50% chance of attracting player
	call Rand				; A = Rand()
	bit  7, a				; A >= $80?
	jr   nz, .missile		; If so, jump
	
	ld   b, ACTCOLI_ENEMYREFLECT	; Make invulnerable while attracting
	call ActS_SetColiType
	ld   a, $03						; Use attract sprite $03 (part of an anim)
	call ActS_SetSprMapId
	ld   a, 60*3					; Waste 3 seconds doing this
	ldh  [hActCur+iActTimer], a
	ld   a, ACTRTN_MAGNETMAN_ATTRACT
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_MagnetMan_InitSpawnMissile ===============
; Sets up the timer for missile spawning, also used for cooldown.
Act_MagnetMan_InitSpawnMissile:
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_MagnetMan_SpawnMissile ===============
; Launches a Magnet Missile straight forward, which will home in down on the player.
; Called three times, alternated with the previous routine.
Act_MagnetMan_SpawnMissile:
	; Always face the player while in this pose, which is a bit pointless given those projectiles may hit a wall.
	call ActS_FacePl
	
	ldh  a, [hActCur+iActTimer]	; Timer--
	sub  $01
	ldh  [hActCur+iActTimer], a
	push af
		ld   b, a
			; Alternate between sprites $05 and $06 every 8 frames.
			; This is timed with the check below so that it switches to $06, the throw frame,
			; exactly when the Magnet Missile spawns.
			; wActCurSprMapBaseId = Timer / 8 % 2
			srl  a ; /2
			srl  a ; /4
			srl  a ; /8 (every 8 frames)
			and  $01 ; % 2 (offset $00 or $01, relative to the base set in Act_MagnetMan_ChkAttack.missile)
			; This isn't quite the way the base sprite mapping ID is supposed to be used, but it works out.
			ld   [wActCurSprMapBaseId], a
		ld   a, b
		
		; Spawn the Magnet Missile halfway through, whe the timer ticks down to $08
		cp   $08
		jr   nz, .chkEnd
		
		ld   a, ACT_MAGNETMISSILE
		ld   bc, ($00 << 8)|LOW(-$10) ; 16px up
		call ActS_SpawnRel
		ldh  a, [hActCur+iActSprMap]
		and  ACTDIR_R	; Make missile travel forward
		or   ACTDIR_D	; Prepare for downwards movement
		inc  l ; iActRtnId
		inc  l ; iActSprMap
		ld   [hl], a	; Save as spawned actor's sprite mapping flags
.chkEnd:
	pop  af	; A = Timer
	ret  nz	; Has it elapsed? If not, return
	
	jp   ActS_IncRtnId
	
; =============== Act_MagnetMan_InitCooldown ===============
; On the ground, set up the cooldown before looping.
Act_MagnetMan_InitCooldown:
	; Use sprite $00 for 6 frames
	ld   a, $06
	ldh  [hActCur+iActTimer], a
	ld   a, $00
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_MagnetMan_Cooldown ===============
; Ground cooldown.
Act_MagnetMan_Cooldown:
	; Wait on the ground for those 6 frames...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Loop pattern to the start
	ld   a, ACTRTN_MAGNETMAN_INITFWDJUMP0
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_MagnetMan_Attract ===============
; Attracts the player while invulnerable.
Act_MagnetMan_Attract:
	; Always face the player...
	call ActS_FacePl
	; ...and move the player the opposite direction we're facing.
	; Basically, move Rockman towards up at 0.5px/frame
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	xor  ACTDIR_R
	ld   bc, $0080
	call Pl_AdjSpeedByActDir
	
	; Getting hurt interrupts the attack
	ld   a, [wPlHurtTimer]
	or   a						; Player is hurt?
	jr   nz, .end				; If so, jump
	
	
	ldh  a, [hActCur+iActTimer]	; TImer--
	sub  $01
	ldh  [hActCur+iActTimer], a
	push af	; Save timer
		; Alternate between sprites $03 and $04 every 4 frames.
		; wActCurSprMapBaseId = Timer / 4 % 2
		srl  a ; /2
		srl  a ; /4 (every 4 frames)
		and  $01 ; % 2 (offset $00 or $01)
		ld   [wActCurSprMapBaseId], a
	pop  af	; A = Timer
	ret  nz	; Has it elapsed? If not, return
.end:
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	ld   a, ACTRTN_MAGNETMAN_INITCOOLDOWN
	ldh  [hActCur+iActRtnId], a
	ret
	
