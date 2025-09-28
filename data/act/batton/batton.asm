; =============== Act_Batton ===============
; ID: ACT_BATTON
; Bat enemy that homes in on the player, and hangs invulnerable on ceilings.
Act_Batton:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Batton_InitCeil
	dw Act_Batton_Ceil
	dw Act_Batton_ToFlight
	dw Act_Batton_Fly
	dw Act_Batton_InitFlyU
	dw Act_Batton_FlyU
	dw Act_Batton_InitCeil2
	DEF ACTRTN_BATTON_INITCEIL = $00
	
; =============== Act_Batton_InitCeil ===============
Act_Batton_InitCeil:
	; Wait 4 seconds on the ceiling, invulnerable
	ld   a, 60*4
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Batton_Ceil ===============
Act_Batton_Ceil:
	; Wait for it...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; The transition to flight anim starts with sprite $01 (and ends at $04)
	ld   a, $01
	ldh  [hActCur+iBattonFlySprMapId], a
	; Show the transition sprite for 8 frames (the bat is still invulnerable)
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Batton_ToFlight ===============
Act_Batton_ToFlight:
	;--
	;
	; Handle the ceiling-to-flight animation.
	; When it ends, start flying immediately.
	;
	
	; Display the previously set transition sprite
	ldh  a, [hActCur+iBattonFlySprMapId]
	ld   [wActCurSprMapBaseId], a
	
	; Wait those 8 frames, and then...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	ld   a, $08								; Reset the anim timer
	ldh  [hActCur+iActTimer], a
	
	ldh  a, [hActCur+iBattonFlySprMapId]	; Advance through the animation
	inc  a
	ldh  [hActCur+iBattonFlySprMapId], a
	cp   $05				; Went past the last transition sprite?
	ret  nz					; If not, return (continue looping)
							; Otherwise, prepare flight mode
	;--
	
	; Target the player at half speed
	call ActS_AngleToPl
	call ActS_HalfSpdSub
	
	; Make vulnerable
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	
	; Advance the flight animation cycle every 8 frames (1/8 speed)
	ld   a, $08
	ldh  [hActCur+iBattonFlyAnimTimer], a
	
	; To save time, only re-check the player's position every 16 frames
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Batton_Fly ===============
Act_Batton_Fly:
	; Animate flight
	call Act_Batton_AnimFlight
	; Move towards the player
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	
	; If the player got hit by the bat, start moving straight up
	ld   a, [wActHurtSlotPtr]	; B = Actor slot that hurt the player
	ld   b, a
	ld   a, [wActCurSlotPtr]	; A = Current actor slot
	cp   b						; Do they match?
	jp   z, ActS_IncRtnId		; If so, advance to Act_Batton_InitFlyU
	
	; Otherwise, adjust the target speed every 16 frames.
	; This is often enough to smoothly home in towards the player, but not too often
	; that we waste time every frame (especially with multiple bats on screen)
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	call ActS_AngleToPl			; Target the player at half speed
	call ActS_HalfSpdSub		; still at half speed
	ld   a, $10					; Perform next update 16 frames later
	ldh  [hActCur+iActTimer], a
	ret
	
; =============== Act_Batton_InitFlyU ===============
Act_Batton_InitFlyU:
	; Fly straight up at 0.5px/frame, which is faster than the normal movement
	ldh  a, [hActCur+iActSprMap]
	and  $FF^ACTDIR_D				; Clear down flag, to move up
	ldh  [hActCur+iActSprMap], a
	ld   bc, $0080
	call ActS_SetSpeedY
	
	; Reset flight anim cycle
	ld   a, $08
	ldh  [hActCur+iBattonFlyAnimTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Batton_FlyU ===============
Act_Batton_FlyU:
	; Animate flight
	call Act_Batton_AnimFlight
	
	;
	; Fly up until we either reach a solid block, the top of the room, or the white leaves.
	; When we do so, immediately start clinging without any transition animation.
	;
	call ActS_ApplySpeedFwdYColi	; Move upwards at 0.5px/frame
	; SOLID CHECK
	jp   nc, ActS_IncRtnId			; Solid block above? If so, start clinging
	
	; SCREEN TOP CHECK
	ldh  a, [hActCur+iActY]		; Y Sensor: ActY - $08 (low)
	sub  $08
	ld   [wTargetRelY], a
	and  $F0					; Check row ranges
	cp   $10					; In 2nd row? (A >= $10 && A <= $1F)
	jp   z, ActS_IncRtnId		; If so, start clinging
	
	; WHITE LEAF BLOCK CHECK
	; These are otherwise empty blocks the player can pass through, which only make sense on Wood Man's stage.
	ldh  a, [hActCur+iActX]		; X Sensor: ActX (center)
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; A = Block ID at that location
	cp   BLOCKID_WLEAF			; Check the three blocks...
	jp   z, ActS_IncRtnId
	cp   BLOCKID_WLEAFL
	jp   z, ActS_IncRtnId
	cp   BLOCKID_WLEAFR
	jp   z, ActS_IncRtnId
	
	; If all checks failed, keep moving up
	ret
	
; =============== Act_Batton_InitCeil2 ===============
; Performs pre-cling cleanup Act_Batton_InitCeil didn't need to do when it spawned.
Act_Batton_InitCeil2:
	; Make invulnerable
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	; Init the rest of the clinging bit
	ld   a, ACTRTN_BATTON_INITCEIL
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Batton_AnimFlight ===============
; Handles the flight animation.
; This uses sprites $05-$07 at 1/8 speed-
Act_Batton_AnimFlight:
	ldh  a, [hActCur+iBattonFlySprMapId]	; Set current sprite
	ld   [wActCurSprMapBaseId], a
	
	ld   hl, hActCur+iBattonFlyAnimTimer
	dec  [hl]								; Timer--, has it elapsed?
	ret  nz									; If not, return
	ld   [hl], $08							; Set next delay
	ldh  a, [hActCur+iBattonFlySprMapId]	; Advance animation
	inc  a
	ldh  [hActCur+iBattonFlySprMapId], a
	cp   $08								; Went past the last sprite?
	ret  nz									; If not, return
	ld   a, $05								; Otherwise, wrap around
	ldh  [hActCur+iBattonFlySprMapId], a
	ret
	
