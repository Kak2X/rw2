; =============== Act_Wily1 ===============
; ID: ACT_WILY1
; 1st phase of the Wily Machine.
Act_Wily1:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WilyIntro
	dw Act_Wily1_InitJump
	dw Act_Wily1_JumpU
	dw Act_Wily1_JumpD
	dw Act_Wily1_WaitBomb
	dw Act_Wily1_WaitNail
	dw Act_Wily1_Turn0
	dw Act_Wily1_Turn1
	dw Act_Wily1_Turn2
	dw Act_Wily1_Turn3
	dw Act_Wily1_Turn4
	DEF ACTRTN_WILY1_INITJUMP = $01
	DEF ACTRTN_WILY1_TURN0 = $06

; =============== Act_Wily1_InitJump ===============
; Sets up the jump towards the player
Act_Wily1_InitJump:
	call Act_Wily1_ChkDeath
	call Act_Wily1_ChkPlBehind
	
	; X Speed = (DiffX * 4 / $10) px/frame
	call ActS_GetPlDistanceX
	ld   l, a
	ld   h, $00
	add  hl, hl
	add  hl, hl
	ld   a, l
	ldh  [hActCur+iActSpdXSub], a
	ld   a, h
	ldh  [hActCur+iActSpdX], a
	
	; Y Speed = 3.5px/frame
	ld   bc, $0380
	call ActS_SetSpeedY
	
	call ActS_FacePl
	
	jp   ActS_IncRtnId

; =============== Act_Wily1_JumpU ===============
; Jump, pre-peak.
Act_Wily1_JumpU:
	call Act_Wily1_ChkDeath
	
	; Use jumping sprite $01
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	; Move forward, stopping on solid walls
	call ActS_MoveBySpeedX_Coli
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_JumpD ===============
; Jump, post-peak.
Act_Wily1_JumpD:
	call Act_Wily1_ChkDeath
	
	; Use landing sprite $00 (no separate one post-peak)
	ld   a, $00
	ld   [wActCurSprMapBaseId], a
	; Move forward, stopping on solid walls
	call ActS_MoveBySpeedX_Coli
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplyGravityD_Coli
	ret  c
	
	; When we do, immediately spawn a bouncing bomb
	ld   a, ACT_WILY1BOMB
	ld   bc, $0000
	call ActS_SpawnRel
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_WaitBomb ===============
Act_Wily1_WaitBomb:
	call Act_Wily1_ChkDeath
	
	; If the player is behind at any point, start turning around
	call Act_Wily1_ChkPlBehind
	
	; Wait for the bomb to despawn before...
	ld   a, ACT_WILY1BOMB
	call ActS_CountById
	ld   a, b
	and  a
	ret  nz
	
	; ...firing the nail immediately
	ld   a, ACT_WILY1NAIL
	ld   bc, $0000
	call ActS_SpawnRel
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_WaitNail ===============
Act_Wily1_WaitNail:
	call Act_Wily1_ChkDeath
	
	; If the player is behind at any point, start turning around
	call Act_Wily1_ChkPlBehind
	
	; Wait for the nail to despawn before...
	ld   a, ACT_WILY1NAIL
	call ActS_CountById
	ld   a, b
	and  a
	ret  nz
	
	; ...starting another jump towards the player, looping the pattern
	ld   a, ACTRTN_WILY1_INITJUMP
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Wily1_Turn0 ===============
; The remainder of routines handle the turning animation.
; Mainly due to limitations with the default animation routines, this is handled manually.
;
; The animation uses frames $00,$02,$03 each displayed for 16 frames,
; then the actor turns and does it in reverse.
Act_Wily1_Turn0:
	call Act_Wily1_ChkDeath
	
	; Use sprite $00 for 16 frames
	ld   a, $00
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_Turn1 ===============
Act_Wily1_Turn1:
	call Act_Wily1_ChkDeath
	
	; Use sprite $02 for 16 frames
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_Turn2 ===============
Act_Wily1_Turn2:
	call Act_Wily1_ChkDeath
	
	; Use sprite $03 for 16 frames
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; The Wily Machine is now facing the camera, and it needs to continue turning.
	; Finally turn the actor at this point, then play back the animation in reverse.
	call ActS_FacePl
	
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_Turn3 ===============
Act_Wily1_Turn3:
	call Act_Wily1_ChkDeath
	
	; Use sprite $02 for 16 frames
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily1_Turn4 ===============
Act_Wily1_Turn4:
	call Act_Wily1_ChkDeath
	
	; Use sprite $00 for 16 frames
	ld   a, $00
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Go back to whatever we were doing before
	ldh  a, [hActCur+iWily1RtnBak]
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Wily1_ChkPlBehind ===============
; Checks if the player is behind the player and if so, it makes it turn to the other side.
; The actor return to whatever it was doing after it finishes turning.
Act_Wily1_ChkPlBehind:

	;##
	;
	; Overly complicated code to check if the player is behind us.
	;
	; This could have been done the sane way by comparing the player and actor's position,
	; then checking for the appropriate directional flag.
	;
	; Instead, it saves the directions, makes the actor face the player (which may update them)
	; and then checks if the directions are different compared to before.
	;
	
	ldh  a, [hActCur+iActSprMap]	; Save unmodified iActSprMap for later
	ld   b, a
	and  ACTDIR_R|ACTDIR_D			; Filter old directions
	ld   c, a
	
	push bc
		call ActS_FacePl			; Face the player. This may or may not modify the directions.
	pop  bc
	
	ld   hl, hActCur+iActSprMap		; Get new iActSprMap
	ld   a, [hl]
	and  ACTDIR_R|ACTDIR_D			; Filter new directions
	cp   c							; Are the new directions unchanged from the old ones?
	ld   [hl], b					; (restore original iActSprMap, as if ActS_FacePl was never called)
	ret  z							; If so, return
	;##
	
	;
	; Otherwise, it means the player is behind the Wily Machine, make it slowly turn to the other side.
	; The actor will properly turn to the player in the middle of that sequence.
	;
	
	ld   a, $10						; Show for 16 frames
	ldh  [hActCur+iActTimer], a
	
	ld   hl, hActCur+iActRtnId		; Seek HL to iActRtnId
	ld   a, [hl]					; A = iActRtnId
	ldh  [hActCur+iWily1RtnBak], a	; Save a backup to restore once done
	ld   [hl], ACTRTN_WILY1_TURN0
	
	; Prevent the rest of the routine from being executed.
	pop  hl
	ret
	
; =============== Act_Wily1_ChkDeath ===============
; Handles the death sequence for Wily Machine.
Act_Wily1_ChkDeath:

	;
	; The 1st and 2nd phases are specifically set to die at 7 health or less,
	; to prevent the generic death code from running.
	; Normally the threshold is set at 16, but that is way too high for boss actors,
	; which have 19 health.
	; When that happens:
	; - Spawn a large explosion
	; - Reposition the Wily Ship actor and enable it
	;
	; The explosion and Wily Ship are set to use the same position, which is specifically
	; picked to make the effect of attaching and detaching the ship look seamless.
	;
	; See also: Act_WilyCtrl
	;
	call ActS_GetHealth
	cp   $08					; Health >= $08?
	ret  nc						; If so, return
	
	ld   a, $FF					; Enable the Wily Ship
	ld   [wWilyPhaseDone], a
	
	ldh  a, [hActCur+iActY]		; Y Position: iActY - $18
	sub  $18
	ld   [wWilyShipY], a		; For Wily's ship
	ld   [wActSpawnY], a		; and the explosion
	ldh  a, [hActCur+iActX]
	
	ld   [wActSpawnX], a		; X Position: iActX
	ld   [wWilyShipX], a
	call ActS_SpawnLargeExpl
	
	ld   a, SFX_EXPLODE			; Play explosion sound
	mPlaySFX
	
	; Return to the actor loop
	pop  hl
	jp   ActS_Explode
	
