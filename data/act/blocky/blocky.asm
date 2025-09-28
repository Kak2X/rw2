; =============== Act_BlockyHead ===============
; ID: ACT_BLOCKYHEAD
; Tower of blocks made up of four section.
; This is the head part, the second block in the tower, which usually controls other child sections.
Act_BlockyHead:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BlockyHead_Init
	dw Act_BlockyHead_Idle0
	dw Act_BlockyHead_FallV
	dw Act_BlockyHead_Ground
	dw Act_BlockyHead_WaitRise
	dw Act_BlockyHead_Idle1
	 
; =============== Act_BlockyHead_Init ===============
Act_BlockyHead_Init:
	; Move forward at 0.25px/frame
	ld   bc, $0040
	call ActS_SetSpeedX
	
	:
	; Set the block-specific properties, which are required for all of the four blocks.
	; BLOCK 2/4
	;
	
	;
	; The individual blocks (both head and body) move back and forth,
	; even ones start moving right, while odd one start moving left.
	;
	; The head is the second block, so it starts moving right.
	; bit4 determines the direction (if set, it moves right) and the lower bits are the timer.
	ld   a, $18
	ldh  [hActCur+iBlockyWaveTimer], a
	
	; This keeps track of the block's position relative to the master, which allows reusing the same
	; movement code between head and body parts (Act_Blocky_MoveMain).
	; Since we *are* the head block, that will be zero here.
	xor  a
	ldh  [hActCur+iBlockyRelY], a
	
	;
	; Spawn the other body parts, which are separate actors.
	; Note that there are two actor types for the body parts, one used before the head is hit once,
	; which is thrown on signal, the other after it gets rebuilt, which explodes on signal.
	;
	; [POI] Them being separate actors, especially when they move back and forth, means it's possible
	;       to offscreen individual sections of the tower, but that can't be fixed without making it
	;       possible for actors to opt out of getting offscreened.
	;
	;       Also, the code below doesn't check if the individual sections couldn't spawn, so care
	;       must be taken when placing it.
	;
	
	; BLOCK 1/4
	ld   a, ACT_BLOCKYBODY
	ld   bc, ($00 << 8)|LOW(-$10) ; 16px up
	call ActS_SpawnRel
	ld   de, iBlockyWaveTimer
	add  hl, de
	ld   [hl], $08 ; iBlockyWaveTimer | Move left
	inc  hl
	ld   [hl], -$10 ; iBlockyRelY | Needs to be consistent with what was passed to ActS_SpawnRel
	
	; BLOCK 3/4
	ld   a, ACT_BLOCKYBODY
	ld   bc, ($00 << 8)|LOW($10) ; 16px down
	call ActS_SpawnRel
	ld   de, iBlockyWaveTimer
	add  hl, de
	ld   [hl], $08 ; iBlockyWaveTimer | Move left
	inc  hl
	ld   [hl], $10 ; iBlockyRelY
	
	; BLOCK 4/4
	ld   a, ACT_BLOCKYBODY
	ld   bc, ($00 << 8)|LOW($20) ; 32px down
	call ActS_SpawnRel
	ld   de, iBlockyWaveTimer
	add  hl, de
	ld   [hl], $18 ; iBlockyWaveTimer | Move right
	inc  hl
	ld   [hl], $20 ; iBlockyRelY
	
	
	; Initialize global variables used for communication between head and body.
	; Side effect of doing this is that you can't have more than one Blocky on-screen.
	ld   hl, wActBlockyMode
	xor  a
	; Signal out to Act_BlockyBody idle mode
	ldi  [hl], a 				; wActBlockyMode = BLOCKY_IDLE0
	; Will be used later for Act_BlockyRise
	ldi  [hl], a 				; wActBlockyRiseDone
	; Initialize the base head position from iActY, which *all*	blocks use to keep themselves in sync
	; (For the most part, iActY won't be used directly)
	ldh  a, [hActCur+iActY]		; wActBlockyHeadY = iActY
	ldi  [hl], a
	
	; The head is vulnerable immediately
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	
	jp   ActS_IncRtnId
	
; =============== Act_BlockyHead_Idle0 ===============
; Main idle code before the enemy is hit once.
; This mainly moves the enemy forwards.
Act_BlockyHead_Idle0:
	
	;
	; Handle blinking animation
	; Uses frames $00-$01 with the following timing:
	;
	ldh  a, [hActCur+iBlockyWaveTimer]
	add  $08			; Shift timing by 8
	and  %01111100		; This mask zeroes out ranges $80-$83 and $00-$03, making them use the closed eyes
	sub  $01			; If the result was 0, set carry flag
	ld   a, $00
	adc  a				; Push carry into result, alternating between $00 and $01
	ld   [wActCurSprMapBaseId], a
	
	; Fall off empty blocks, if any, while moving forwards, bringing the body parts down with it.
	call Act_BlockyHead_ChkGround
	call Act_Blocky_MoveMain
	
	;
	; If hit by the player, fall to the ground while launching the body blocks forward.
	; Any hit from a weapon that doesn't clink will bring the health below the threshold.
	;
	call ActS_GetHealth
	cp   $11					; Health >= $11?
	ret  nc						; If so, wait
	
	; Signal out to throw the blocks
	ld   hl, wActBlockyMode		; wActBlockyMode = BLOCKYBODY_THROW
	inc  [hl]
	; Not necessary, already done
	inc  hl ; wActBlockyRiseDone
	ld   [hl], $00
	; Set shocked eyes (until the body blocks despawn)
	ld   a, $01
	call ActS_SetSprMapId
	; Make invulnerable until the tower recomposes itself
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	; Set the actor to be one hit from death
	ld   b, $11
	call ActS_SetHealth
	
	; Prepare for falling to the ground
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_BlockyHead_FallV ===============
; Head falling to the ground.
Act_BlockyHead_FallV:
	; Wait for the head to fall to the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	; Set initial check delay (see below)
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_BlockyHead_Ground ===============
; Head on the ground, waiting to rebuild itself.
Act_BlockyHead_Ground:
	
	;--
	;
	; The body parts, once they hit the ground, bounce a bit, then finally despawning when they hit the ground again.
	; Wait until all of them have despawned before starting to rebuild the tower. 
	; These checks are made every 16 frames to save time.
	;
	
	; Wait for those 16 frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Set a new delay in case the check below fails
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	; If any body parts are still active, wait
	ld   a, ACT_BLOCKYBODY
	call ActS_CountById
	ld   a, b
	and  a
	ret  nz
	;--
	
	;
	; Spawn the rising body blocks (Act_BlockyRise), which once finish rising they will 
	; start moving forward themselves, identically to Act_BlockyBody.
	; This is similar to what was done in Act_BlockyHead_Init, except the rising blocks
	; come from the bottom of the screen.
	;
	
	; BLOCK 2/4 (Head)
	; This is reset like in Act_BlockyHead_Init.
	ld   a, $18							; Start moving right
	ldh  [hActCur+iBlockyWaveTimer], a
	xor  a								; Head is base part
	ldh  [hActCur+iBlockyRelY], a

	; BLOCK 1/4
	; All other body blocks follow this template.
	ld   a, ACT_BLOCKYRISE
	; Use the head's position (currently on the ground) as reference point.
	ld   bc, $0000						
	call ActS_SpawnRel
	; Immediately replace the Y position to point off-screen below.
	; The positions chosen among the three blocks make a 3-block tower with no gaps inbetween.
	ld   de, iActY 								; DE = $07
	add  hl, de									; Seek to iActY
	ld   [hl], OBJ_OFFSET_Y+SCREEN_V+($10*0)	; Offscreen below
	; Set custom properties, identical to those in Act_BlockyHead_Init.
	dec  de										; DE = 06
	add  hl, de									; Seek to iActY+$06 = iBlockyWaveTimer
	ld   [hl], $08 ; iBlockyWaveTimer
	inc  hl
	ld   [hl], -$10 ; iBlockyRelY 
	
	; BLOCK 3/4
	ld   a, ACT_BLOCKYRISE
	ld   bc, $0000
	call ActS_SpawnRel
	ld   de, iActY
	add  hl, de
	ld   [hl], OBJ_OFFSET_Y+SCREEN_V+($10*1)
	dec  de
	add  hl, de
	ld   [hl], $08 ; iBlockyWaveTimer | Move left
	inc  hl
	ld   [hl], $10 ; iBlockyRelY
	
	; BLOCK 4/4
	ld   a, ACT_BLOCKYRISE
	ld   bc, $0000
	call ActS_SpawnRel
	ld   de, iActY
	add  hl, de
	ld   [hl], OBJ_OFFSET_Y+SCREEN_V+($10*2)
	dec  de
	add  hl, de
	ld   [hl], $18 ; iBlockyWaveTimer | Move right
	inc  hl
	ld   [hl], $20 ; iBlockyRelY
	
	ld   hl, wActBlockyMode
	xor  a
	; The new block types spawned have their own communication sequence
	ldi  [hl], a ; wActBlockyMode = BLOCKYRISE_REBUILD
	; Not necessary, it's already 0
	ld   [hl], a ; wActBlockyRiseDone
	jp   ActS_IncRtnId
	
; =============== Act_BlockyHead_WaitRise ===============
; Waiting for the blocks to rise up, then sets up movement.
Act_BlockyHead_WaitRise:
	; Wait until all Act_BlockyRise have finished moving.
	; Note that they always finish doing so on the same frame, so we'll read either $00 or $03
	ld   a, [wActBlockyRiseDone]
	cp   $03
	ret  nz
	
	; Set normal eye sprite
	ld   a, $00
	call ActS_SetSprMapId
	; Make head vulnerable again
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	; Signal to the body parts that normal movement is enabled.
	; This will cause them to move forward in sync.
	ld   hl, wActBlockyMode
	inc  [hl]				; wActBlockyMode = BLOCKYRISE_IDLE1
	
	jp   ActS_IncRtnId
	
; =============== Act_BlockyHead_Idle1 ===============
; Main idle code after the enemy is hit once.
; The actor explodes if hit again on the head.
Act_BlockyHead_Idle1:
	;--
	; Handle blinking animation, identically to Act_BlockyHead_Idle0
	ldh  a, [hActCur+iBlockyWaveTimer]
	add  $08
	and  $7C
	sub  $01
	ld   a, $00
	adc  a
	ld   [wActCurSprMapBaseId], a
	;--
	
	; Fall off empty blocks, if any, while moving forwards, bringing the body parts down with it
	call Act_BlockyHead_ChkGround
	call Act_Blocky_MoveMain
	
	; If hit another time, make the actor explode
	call ActS_ChkExplodeNoChild
	ret  nc
	; And signal that out to the body parts
	ld   hl, wActBlockyMode		; wActBlockyMode = BLOCKY_DEAD
	inc  [hl]
	ret
	
; =============== Act_Blocky_MoveMain ===============
; Handles normal block movement, used for both the head and body parts.
; The code being shared means it needs to account for their different positions.
Act_Blocky_MoveMain:

	;
	; Y POSITION
	;
	; The blocks don't typically move vertically, but they can fall off platforms.
	; To ensure the body parts are always kept in sync, the Y position is regenerated
	; based on the head's position:
	;
	; iActY = wActBlockyHeadY + iAct0E 
	;
	ld   a, [wActBlockyHeadY]		; A = Base Y pos of head
	ld   hl, hActCur+iBlockyRelY	; HL = Ptr to actor's Y offset (relative to the head)
	add  [hl]						; Add both to get the final value
	ldh  [hActCur+iActY], a
	
	;
	; X POSITION
	;
	; This is a bit more involved, as it is influenced by two factors:
	; - Normal forward movement
	; - The wave pattern
	;
	
	;
	; First, move forward at its normal 0.25px/frame speed
	;
	call ActS_ApplySpeedFwdX
	
	;
	; Then, move horizontally depending on the wave pattern location.
	;
	; In practice, alternate every 16 frames between moving left and right at 0.5px/frame.
	; This movement is applied directly to the horizontal position, which avoids having to adjust the speed.
	;

	; HL = (iBlockyWaveTimer / 16) % 2
	;      The result will either be $0100 or $0000.
	;      If it's $0100, the base movement speed of -0.5px (left) will become 0.5px (right).
	ldh  a, [hActCur+iBlockyWaveTimer]
	and  $10			; A = iBlockyWaveTimer & $10
	rrca 				; A >>= 4
	rrca 
	rrca 
	rrca 
	ld   h, a			; HL = A
	ld   l, $00
	
	ld   de, -$0080		; Get base 0.5px/frame left
	add  hl, de			; Make it move right, if the timer agrees
	
	; iActX += HL
	ldh  a, [hActCur+iActXSub]	; DE = Current speed
	ld   e, a
	ldh  a, [hActCur+iActX]
	ld   d, a
	add  hl, de					; Add new one
	ld   a, l					; Save back
	ldh  [hActCur+iActXSub], a
	ld   a, h
	ldh  [hActCur+iActX], a
	
	; Advance the wave timer
	ld   hl, hActCur+iBlockyWaveTimer
	inc  [hl]
	ret
	
; =============== Act_BlockyHead_ChkGround ===============
; Checks if the actor is touching the solid ground, and if so, makes it tall.
; This check only needs to be made by the head part, so it's tailored for that.
Act_BlockyHead_ChkGround:

	; LEFT CORNER
	ldh  a, [hActCur+iActX]	; X Target: ActX - $07 (left)
	sub  $07
	ld   [wTargetRelX], a
	
	; [BUG] The head block is the 2nd of the 4 blocks from the top, so 2 body blocks are below.
	;       As blocky's sections are are $10 pixels tall, that makes for the $20... which is off by one,
	;       so the actor sinks 1 pixel into the ground for what's worth.
	ldh  a, [hActCur+iActY]	; Y Target: ActX + $20 (ground - 1)
	add  BLOCK_V*2         
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	
	; RIGHT CORNER
	ldh  a, [hActCur+iActX]	; X Target: ActX + $07 (right)
	add  $07
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ret  nc
	
	; If we got here, there is no ground below, so fall at 2px/frame downwards by directly affecting the Y position.
	; Even though it's falling 2px at a time, it can't sink into the ground this way as that's a multiple of the block height.
	ld   hl, wActBlockyHeadY	; wActBlockyHeadY += $02
	inc  [hl]
	inc  [hl]
	ret
	
; =============== Act_BlockyBody ===============
; ID: ACT_BLOCKYBODY
; Invulnerable body section of Blocky, before the rebuild.
Act_BlockyBody:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BlockyBody_Init
	dw Act_BlockyBody_Idle
	dw Act_BlockyBody_JumpU
	dw Act_BlockyBody_JumpD
	dw Act_BlockyBody_Explode

; =============== Act_BlockyBody_Init ===============
Act_BlockyBody_Init:
	; Move forward at 0.25px/frame, the same speed as the head
	ld   bc, $0040
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_BlockyBody_Idle ===============
Act_BlockyBody_Idle:
	; Continue moving horizontally, like the head part
	call Act_Blocky_MoveMain
	
	;
	; Throw the blocks when we're signaled to.
	;
	
	; Wait for the signal first
	ld   a, [wActBlockyMode]
	and  a						; wActBlockyMode == BLOCKYBODY_IDLE0?
	ret  z						; If so, return
	
	xor  a
	ldh  [hActCur+iBlockyGroundBounce], a
	
	;
	; Each block in the tower is thrown in a different arc, and the speed values
	; are read from a table indexed by block ID.
	;
	; The block ID can be easily determined through the relative Y position to the head block,
	; which is unique for each and always a multiple of $10.
	; The topmost block has a negative -$10 value since it's above the head block, so that
	; needs to be counterbalanced:
	; BlockId = (iBlockyRelY + $10) / $10
	;
	; Each table entry is 4 bytes long (iActSpdXSub-iActSpdY) so:
	; Offset = (iBlockyRelY + $10) / $10 * $04
	;        = (iBlockyRelY + $10) / $04
	;
	ldh  a, [hActCur+iBlockyRelY]	
	add  $10						; Account for topmost block being -$10
	rrca 							; / $04
	rrca 							; ""
	ld   hl, Act_BlockyBody_ThrowSpdTbl	; HL = Table base
	ld   b, $00						; BC = Offset
	ld   c, a
	add  hl, bc						; Seek to entry
	; Copy the four speed values from the entry to the actor 
	ld   de, hActCur+iActSpdXSub
	REPT 4
		ldi  a, [hl]
		ld   [de], a
		inc  de
	ENDR
	
	; Throw the blocks in the direction of the player
	call ActS_FacePl
	
	jp   ActS_IncRtnId
	

; =============== Act_BlockyBody_JumpU ===============
; Jump, pre-peak.
Act_BlockyBody_JumpU:
	; Move forward
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_BlockyBody_JumpD ===============
; Jump, post-peak.
Act_BlockyBody_JumpD:
	; Move forward
	call ActS_ApplySpeedFwdXColi
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	;
	; When the blocks hit the ground the first time, make them jump directly up.
	; This second jump is handled by returning to Act_BlockyBody_JumpU with different speed values.
	;
	
	ldh  a, [hActCur+iBlockyGroundBounce]
	and  a					; Already bounced on the ground once?
	jp   nz, ActS_IncRtnId	; If so, explode
	inc  a					; Otherwise, set up the bounce
	ldh  [hActCur+iBlockyGroundBounce], a
	
	ld   bc, $0000			; No horizontal speed
	call ActS_SetSpeedX
	ld   bc, $0200			; 2px/frame up
	call ActS_SetSpeedY
	jp   ActS_DecRtnId		; Return to handling the pre-peak jump
	
; =============== Act_BlockyBody_Explode ===============
Act_BlockyBody_Explode:
	jp   ActS_Explode
	
; =============== Act_BlockyBody_ThrowSpdTbl ===============
; Table of speed values for each separate block, indexed by block number. (iBlockyRelY / $10) + $10
Act_BlockyBody_ThrowSpdTbl:
	;      X      Y
	dw $0280, $0300 ; 1/4
	dw $0000, $0000 ; 2/4 ; Unused dummy entry for the head block
	dw $0200, $0280 ; 3/4
	dw $0180, $0180 ; 4/4

; =============== Act_BlockyRise ===============
; ID: ACT_BLOCKYRISE
; Invulnerable body section of Blocky, after the rebuild.
Act_BlockyRise:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BlockyRise_Init
	dw Act_BlockyRise_Rise
	dw Act_BlockyRise_WaitMove
	dw Act_BlockyRise_Move

; =============== Act_BlockyRise_Init ===============
Act_BlockyRise_Init:
	; Rising blocks can't be moving down
	ldh  a, [hActCur+iActSprMap]
	and  $FF^ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	ld   bc, $0040			; Same 0.25px/frame forward speed as the other blocks
	call ActS_SetSpeedX
	ld   bc, $0200			; 2px/frame rising speed
	call ActS_SetSpeedY
	ld   a, $20				; Rise for 32 frames
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_BlockyRise_Rise ===============
Act_BlockyRise_Rise:
	; Rise up for those 32 frames
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; Signal that the block has risen up.
	; The head part is looping at Act_BlockyHead_WaitRise, waiting for all three to have done so.
	; When that's done, forward movement will start, which is signaled to us by having 
	; wActBlockyMode set to BLOCKYRISE_IDLE1.
	;
	ld   hl, wActBlockyRiseDone
	inc  [hl]
	
	jp   ActS_IncRtnId
	
; =============== Act_BlockyRise_WaitMove ===============
; Waits for the head part to have entered the second moving phase.
Act_BlockyRise_WaitMove:
	; Wait for movement
	ld   a, [wActBlockyMode]
	and  a				; wActBlockyMode == BLOCKYRISE_REBUILD?
	ret  z				; If so, return
						; Otherwise, it's at BLOCKYRISE_IDLE1, start moving
	jp   ActS_IncRtnId
	
; =============== Act_BlockyRise_Move ===============
Act_BlockyRise_Move:
	; Move forward the normal way
	call Act_Blocky_MoveMain
	
	; If the head part got hit (a second time) instadespawn the actor.
	ld   a, [wActBlockyMode]
	cp   BLOCKYRISE_DEAD
	ret  nz
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
