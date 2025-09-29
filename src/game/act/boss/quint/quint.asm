; =============== Act_Quint ===============
; ID: ACT_QUINT
;
; Quint, the poor man's Blues.
Act_Quint:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Quint_Init
	dw Act_Quint_IntroStand
	dw Act_Quint_IntroWaitSg
	dw Act_Quint_IntroJumpU
	dw Act_Quint_JumpD
	dw Act_Quint_InitGround
	dw Act_Quint_GroundDebris
	dw Act_Quint_GroundWait
	dw Act_Quint_JumpU
	dw Act_Quint_DeadFall
	dw Act_Quint_WarpLand
	dw Act_Quint_WarpMove
	dw Act_Quint_PlWarpOut
	dw Act_Quint_EndLvl
	DEF ACTRTN_QUINT_JUMPD = $04
	DEF ACTRTN_QUINT_DEADFALL = $09
	
; =============== Act_Quint_Init ===============
Act_Quint_Init:
	; Stand on the ground (show sprite $00) for ~2 seconds
	ld   a, $80
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Quint_IntroStand ===============
; Waiting on the ground, standing.
Act_Quint_IntroStand:

	;
	; [POI] At no point does the collision box or type for Quint ever change.
	;       This makes it possible to already damage him before the intro animation even ends.
	;       It's even possible to defeat him, but he won't teleport out until the intro ends,
	;       due to Act_Quint_ChkDeath not getting called there.
	;       Since Quint doesn't ride on the Sakugarne yet, it makes its hitbox very misleading.
	;

	; Wait for it...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; After those ~2 seconds, spawn the Sakugarne, which will drop from the top of the screen.
	;
	; Note that this newly spawned actor is *only* used for this intro -- the Sakugarne shown
	; when the Quint is riding it is fully handled here.
	;
	
	; Raise both hands arms up as it falls down
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	; Spawn the Sakugarne...
	ld   a, ACT_QUINT_SG
	ld   bc, $0000
	call ActS_SpawnRel
	ld   de, iActX ; $05
	add  hl, de
	ld   [hl], $60		; ...at the center of the screen
	inc  hl ; iActYSub
	inc  hl ; iActY
	ld   [hl], $40		; ...directly materializing around the top of the screen, but still onscreen (why not from $00?)
	inc  de ; $06
	add  hl, de			; Seek to iQuintSgJumpOk
	ld   [hl], $00		; Initialize the signal that tells us when to jump
	; Keep track of the slot ptr to iQuintSgJumpOk (only the low byte was needed)
	ld   a, l
	ldh  [hActCur+iQuintSgJumpOkPtrLow], a
	ld   a, h
	ldh  [hActCur+iQuintSgJumpOkPtrHigh], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Quint_IntroWaitSg ===============
; Waits for the Sakugarne to reach a particular position.
Act_Quint_IntroWaitSg:
	; Keep using same sprite as before
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	; Wait for the Sakugarne actor to signal us when to jump
	ldh  a, [hActCur+iQuintSgJumpOkPtrLow]	; HL = Ptr to iQuintSgJumpOk
	ld   l, a
	ldh  a, [hActCur+iQuintSgJumpOkPtrHigh]
	ld   h, a
	ld   a, [hl]	; A = iQuintSgJumpOk
	and  a			; A == 0?
	ret  z			; If so, return
	
	ld   bc, $0380			; Set up high jump at 3.5px/frame
	call ActS_SetSpeedY		; This is the same vertical speed the Sakugarne jumps at
	jp   ActS_IncRtnId
	
; =============== Act_Quint_IntroJumpU ===============
; Jumps towards the Sakugarne.
Act_Quint_IntroJumpU:
	; Use normal jumping sprite
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	
	; Move up, until we reach the peak of the jump
	call ActS_ApplyGravityU_Coli
	ret  c
	; Then start falling straight down
	ld   bc, $0000
	call ActS_SetSpeedX
	
	; From now on, Quint is riding the Sakugarne.
	jp   ActS_IncRtnId
	
; =============== Act_Quint_JumpD ===============
; Jump, post-peak.
; This is the start of the boss pattern.
Act_Quint_JumpD:
	call Act_Quint_ChkDeath
	ret  c
	
	; Use sakugarne jumping sprite
	ld   a, $05
	ld   [wActCurSprMapBaseId], a
	
	; Move forward, stopping on solid walls
	call ActS_MoveBySpeedX_Coli
	; Move up, until we touch the ground
	call ActS_ApplyGravityD_Coli
	ret  c
	
	; Then wait 8 frames idling
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Quint_InitGround ===============
; Idle on the ground, while riding the Sakugarne.
Act_Quint_InitGround:
	call Act_Quint_ChkDeath
	ret  c
	
	; Show sprite $06 for 8 frames
	; This already accounts for the 2-frame $05-$06 1/8 animation (see Act_Quint_GroundDebris).
	ld   a, $06
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; After that, set up the spawned debris
	ld   a, $0C								; Number of times we loop to Act_Quint_GroundDebris
	ldh  [hActCur+iQuintDebrisTimer], a
	ld   a, $08								; Cooldown between spawn attempts
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Quint_GroundDebris ===============
; Ground cycle - spawn debris.
;
; This and the next routine alternate every 8 frames, to spawn the debris multiple times between jumps.
; Another effect is in the sprites used, as this one uses $05 and the other one $06, for manually
; handling the animation of using sprites $05-$06 at 1/8 speed.
Act_Quint_GroundDebris:
	call Act_Quint_ChkDeath
	ret  c
	
	; Show sprite $05 for 8 frames.
	ld   a, $05
	ld   [wActCurSprMapBaseId], a
	; Wait those 8 frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Set timer for the 2nd frame of the animation.
	; Between the two cooldowns, 16 frames will pass before the next spawn check.
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	
	;
	; Spawn the debris only if its timer is >= 6 and divisible by 2.
	; In practice, this makes it spawn the debris 4 times (at ticks $0C, $0A, $08, $06),
	; with a longer cooldown period later.
	;
	ldh  a, [hActCur+iQuintDebrisTimer]
	cp   $06					; iQuintDebrisTimer < 6?
	jp   c, ActS_IncRtnId		; If so, jump
	rrca 						; iQuintDebrisTimer % 2 != 0?
	jp   nc, ActS_IncRtnId		; If so, jump

	;
	; Passed all the checks, spawn four separate debris actors that hurt the player.
	; The four debris have all different horizontal position and speed, with
	; the latter being determined by its unique init routines (see also: Act_QuintDebris)
	;
	
	; $00
	ld   a, ACT_QUINT_DEBRIS
	ld   bc, (LOW(-$06) << 8)|$00 ; 6px left
	call ActS_SpawnRel ; ACTRTN_QUINTDEBRIS_INIT0
	
	; $01
	ld   a, ACT_QUINT_DEBRIS
	ld   bc, (LOW(-$02) << 8)|$00 ; 2px left
	call ActS_SpawnRel
	inc  hl ; iActRtnId
	ld   [hl], ACTRTN_QUINTDEBRIS_INIT1
	
	; $02
	ld   a, ACT_QUINT_DEBRIS
	ld   bc, (LOW($02) << 8)|$00 ; 2px right
	call ActS_SpawnRel
	inc  hl ; iActRtnId
	ld   [hl], ACTRTN_QUINTDEBRIS_INIT2
	
	; $03
	ld   a, ACT_QUINT_DEBRIS
	ld   bc, (LOW($06) << 8)|$00 ; 6px right
	call ActS_SpawnRel
	inc  hl ; iActRtnId
	ld   [hl], ACTRTN_QUINTDEBRIS_INIT3
	
	jp   ActS_IncRtnId
	
; =============== Act_Quint_GroundWait ===============
; Ground cycle - debris end check.
Act_Quint_GroundWait:
	call Act_Quint_ChkDeath
	ret  c
	
	; Use sprite $06, as part of the animation
	ld   a, $06
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Wait 8 more frames (total 16) before spawning debris, in case we loop back.
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	; Loop back if we aren't done spawning debris.
	ld   hl, hActCur+iQuintDebrisTimer
	dec  [hl]					; Timer--
	jp   nz, ActS_DecRtnId		; Timer != 0? If so, go back to Act_Quint_GroundDebris
	
	;
	; Otherwise, set up the next Sakugarne jump, directly targeting the player.
	;
	
	call ActS_FacePl			; Towards the player
	call ActS_GetPlDistanceX	; X Speed = ((DiffX * 4) / $10) px/frame
	ld   l, a
	ld   h, $00
	add  hl, hl
	add  hl, hl
	ld   a, l
	ldh  [hActCur+iActSpdXSub], a
	ld   a, h
	ldh  [hActCur+iActSpdX], a
	ld   bc, $0380				; Y Speed = 3.5px/frame
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Quint_JumpU ===============
; Jump, pre-peak.
Act_Quint_JumpU:
	call Act_Quint_ChkDeath
	ret  c
	
	; Use sakugarne jumping sprite
	ld   a, $05
	ld   [wActCurSprMapBaseId], a
	
	; Move forward, stopping on solid walls
	call ActS_MoveBySpeedX_Coli
	; Move up, until we reach the peak of the jump
	call ActS_ApplyGravityU_Coli
	ret  c
	
	; Then start falling down
	ld   a, ACTRTN_QUINT_JUMPD
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Quint_DeadFall ===============
; Defeat sequence - fall down.
Act_Quint_DeadFall:
	; Fall on the ground in the standing frame.
	; This is usually barely noticeable, since Quint is likely already on the ground.
	call ActS_ApplyGravityD_Coli
	ret  c
	
	; Start the ground teleport animation
	; Use sprites $07-$0A at 1/4 speed
	ld   de, ($07 << 8)|$0A
	ld   c, $04
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_Quint_WarpLand ===============
; Defeat sequence - ground animation.
Act_Quint_WarpLand:
	; Play the ground teleport animation, once that's done...
	call ActS_PlayAnimRange
	ret  z
	; ...move up at 4px/frame
	ld   hl, hActCur+iActSprMap
	res  ACTDIRB_D, [hl]
	ld   bc, $0400
	call ActS_SetSpeedY
	; ...play appropriate sound effect
	ld   c, SFX_FIREHIT_B
	mPlaySFX
	jp   ActS_IncRtnId
	
; =============== Act_Quint_WarpMove ===============
; Defeat sequence - moving.
Act_Quint_WarpMove:
	; Use teleport sprite
	ld   a, $0B
	ld   [wActCurSprMapBaseId], a
	
	; Move up until we reach Y position $18
	call ActS_MoveBySpeedY
	ldh  a, [hActCur+iActY]
	cp   $18				; iActY >= $18?
	ret  nc					; If so, return
	xor  a					; Otherwise, offscreen it above
	ldh  [hActCur+iActY], a
	jp   ActS_IncRtnId		; and teleport the player as soon as possible
	
; =============== Act_Quint_PlWarpOut ===============
; Defeat sequence - teleport player out.
Act_Quint_PlWarpOut:
	; Wait until the player has touched the ground before teleporting out
	ld   a, [wPlMode]
	or   a						; wPlMode == PL_MODE_GROUND?
	ret  nz						; If not, wait
	ld   a, PL_MODE_WARPOUTINIT	; Otherwise, start the teleport
	ld   [wPlMode], a
	
	ld   a, 60						; Wait for a second before ending the level
	ldh  [hActCur+iActTimer], a	; It should be enough to let the player fully teleport out
	jp   ActS_IncRtnId
	
; =============== Act_Quint_EndLvl ===============
; Defeat sequence - end level.
Act_Quint_EndLvl:
	; Wait for that second...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Then end the lemvel
	ld   a, LVLEND_BOSSDEAD
	ld   [wLvlEnd], a
	ret
	
; =============== Act_Quint_ChkDeath ===============
; Handles the death checks for Quint.
; OUT
; - C Flag: If set, Quint has been defeated
Act_Quint_ChkDeath:
	; As this boss doesn't have a visible health bar, it can use the normal $10 threshold
	; used by actors that perform special actions on death.
	call ActS_GetHealth
	cp   $11						; Health >= $11?
	ret  nc							; If so, return (C Flag = clear)
	
	ld   a, ACTRTN_QUINT_DEADFALL	; Otherwise, start teleporting out
	ldh  [hActCur+iActRtnId], a
	scf  							; C Flag = Set
	ret								; In practice, the above could have been "pop af"
	
