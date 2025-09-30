; =============== Act_Wily2 ===============
; ID: ACT_WILY2
; 2nd phase of the Wily Machine.
Act_Wily2:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WilyIntro
	dw Act_Wily2_InitFire
	dw Act_Wily2_Fire
	dw Act_Wily2_InitMoveFwd
	dw Act_Wily2_MoveFwd
	dw Act_Wily2_Wait
	dw Act_Wily2_MoveBak
	dw Act_Wily2_Turn
	DEF ACTRTN_WILY2_INITFIRE = $01
	DEF ACTRTN_WILY2_MOVEBAK = $06
	DEF ACTRTN_WILY2_TURN = $07

; =============== Act_Wily2_InitFire ===============
; Sets up the shooting mode.
Act_Wily2_InitFire:

	; Allow damaging the Wily Machine from the top until 12px above its center point.
	; Make everything below reflect shots.
	ld   b, -$0C
	call ActS_SetColiType
	
	call Act_Wily2_ChkDeath
	
	; Fire two shots, with a cooldown of ~half a second
	ld   a, $02
	ldh  [hActCur+iWily2ShotsLeft], a
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily2_Fire ===============
; Shooting mode.
Act_Wily2_Fire:
	; Use firing sprite $02
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	
	call Act_Wily2_ChkDeath
	
	; Wait for the cooldown...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Fire an energy ball forward.
	; It's set to fire towards the player, but that's handled by the shot's init code.
	ld   a, ACT_WILY2SHOT
	ld   bc, ($00 << 8)|LOW(-$08) ; 8px up
	call ActS_SpawnRel
	
	; Set cooldown for next shot
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	
	; If we fired all of them, start moving
	ld   hl, hActCur+iWily2ShotsLeft
	dec  [hl]
	ret  nz
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily2_InitMoveFwd ===============
; Preparing to move forward.
Act_Wily2_InitMoveFwd:
	; Use frames $00-$01 at 1/8 speed to animate the treads.
	ld   c, $01
	call ActS_Anim2
	
	call Act_Wily2_ChkDeath
	
	; Wait for that ~half a sec of cooldown after the last shot...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Move forwards at 0.5px/frame for ~1.5 seconds
	ld   bc, $0080
	call ActS_SetSpeedX
	ld   a, $60
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily2_MoveFwd ===============
Act_Wily2_MoveFwd:
	; Animate the treads
	ld   c, $01
	call ActS_Anim2
	
	call Act_Wily2_ChkDeath

	; Move forward for the previously set amount
	call ActS_MoveBySpeedX
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; At this point, we're typically waiting near the center of the screen.
	
	
	; Spawn a boucing bomb
	ld   a, ACT_WILY2BOMB
	ld   bc, $0000
	call ActS_SpawnRel
	
	; For later, set up movement at -0.5px/frame
	; We won't actually move yet, but setting it here helps out Act_Wily2_ChkPlBehind (see below)
	ld   bc, -$0080
	call ActS_SetSpeedX
	
	; Wait ~2 seconds, typically near the center of the screen
	ld   a, $80
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily2_Wait ===============
; Waits a bit near the center of the screen, as cooldown after spawning a bomb. 
Act_Wily2_Wait:
	; *Only* check if the player has moved behind in the middle of moving backwards.
	; A consequence of this is that the turning routine doesn't need to either:
	; - Remember whatever we were doing before, since it will just skip to Act_Wily2_MoveBak
	; - Explicitly set the backwards speed, as it will always be already set to -0.5px/frame
	call Act_Wily2_ChkPlBehind
	
	call Act_Wily2_ChkDeath
	
	; Animate the treads
	ld   c, $01
	call ActS_Anim2
	
	; Wait for it...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Move back for ~1.5 seconds
	ld   a, $60
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily2_MoveBak ===============
Act_Wily2_MoveBak:
	; Animate the treads
	ld   c, $01
	call ActS_Anim2
	
	call Act_Wily2_ChkDeath
	
	; Move backwards at 0.5px/frame (for either ~1.5 or ~2 seconds, depending on how we got here)
	call ActS_MoveBySpeedX
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; For later, set up movement at 0.5px/frame
	ld   bc, $0080
	call ActS_SetSpeedX
	;--
	; [POI] Ignored, will be overwritten
	ld   a, $60
	ldh  [hActCur+iActTimer], a
	;--
	
	; Start firing shots again, looping the pattern
	ld   a, ACTRTN_WILY2_INITFIRE
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Wily2_Turn ===============
; Makes the Wily Machine turn around.
; After this is done, it will immediately move backwards, to the other side.
Act_Wily2_Turn:

	; Use turning sprite $03
	; This one actually remembers to clean up the relative sprite ID in iActSprMap.
	ld   hl, hActCur+iActSprMap
	res  3, [hl]	; with ActS_Anim2 used elsewhere, only bit3 is affected
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	call Act_Wily2_ChkDeath
	
	; Show the sprite for 16 frames...
	ldh  a, [hActCur+iActTimer]
	sub  a, $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Then turn around
	call ActS_FacePl
	
	; Move away from the player for ~2 seconds.
	; As the player might be very nearby, this is half a second longer than normal.
	ld   a, $80
	ldh  [hActCur+iActTimer], a
	ld   a, ACTRTN_WILY2_MOVEBAK
	ldh  [hActCur+iActRtnId], a
	ret 

; =============== Act_Wily2_ChkPlBehind ===============
; Checks if the player is behind the player and if so, it makes it turn around.
; Nearly identical to Act_Wily1_ChkPlBehind except for:
; - Swapped b/c registers
; - Only the horizontal direction is filtered
;   (as this phase only moves horizontally, but it could have been like this in the 1st phase too)
Act_Wily2_ChkPlBehind:

	;##
	;
	; Check if the player is behind us.
	;
	
	ldh  a, [hActCur+iActSprMap]	; Save unmodified iActSprMap for later
	ld   c, a
	and  ACTDIR_R					; Filter old directions
	ld   b, a
	
	push bc
		call ActS_FacePl			; Face the player. This may or may not modify the directions.
	pop  bc
	
	ld   hl, hActCur+iActSprMap		; Get new iActSprMap
	ld   a, [hl]
	and  ACTDIR_R					; Filter new directions
	cp   b							; Are the new directions unchanged from the old ones?
	ld   [hl], c					; (restore original iActSprMap, as if ActS_FacePl was never called)
	ret  z							; If so, return
	;##
	
	;
	; Otherwise, it means the player is behind the Wily Machine, make it turn around.
	;
	
	ld   a, $10						; Stay in that mode for 16 frames
	ldh  [hActCur+iActTimer], a
	
	ld   hl, hActCur+iActRtnId		; Seek HL to iActRtnId
	;--
	; [POI] Copypaste from Act_Wily1_ChkPlBehind that's not applicable here,
	;       as after turning we switch to an hardcoded routine.
	;       iWily1RtnBak also points to iWily2ShotsLeft here.  
	ld   a, [hl]					; A = iActRtnId
	ldh  [hActCur+iWily1RtnBak], a	; Save a backup to restore once done
	;--
	ld   [hl], ACTRTN_WILY2_TURN
	
	; Prevent the rest of the routine from being executed.
	pop  hl
	ret

; =============== Act_Wily2_ChkDeath ===============
; Handles the death sequence for Wily Machine.
; This is identical to Act_Wily1_ChkDeath, except for the Y position for the ship,
; since the 2nd phase machine is shorter than the 1st.
Act_Wily2_ChkDeath:
	call ActS_GetHealth
	cp   $08					; Health >= $08?
	ret  nc						; If so, return
	
	ld   a, $FF					; Enable the Wily Ship
	ld   [wWilyPhaseDone], a
	
	ldh  a, [hActCur+iActY]		; Y Position: iActY - $10
	sub  $10
	ld   [wWilyShipY], a		; For Wily's ship
	ld   [wActSpawnY], a		; and the explosion
	ldh  a, [hActCur+iActX]
	
	ld   [wActSpawnX], a		; X Position: iActX
	ld   [wWilyShipX], a
	call ActS_SpawnLargeExpl
	
	mPlaySFX SFX_EXPLODE		; Play explosion sound
	
	; Return to the actor loop
	pop  hl
	jp   ActS_Explode
	
	
