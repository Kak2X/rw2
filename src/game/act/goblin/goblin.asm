; =============== Act_Goblin ===============
; ID: ACT_GOBLIN
; Makes a goblin platform show up at the location it's placed on, and spawns any of its child objects.
; The only part of the goblin placed in the actor layout.
Act_Goblin:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Goblin_WaitPl
IF REV_VER == VER_EU
	dw Act_Goblin_WaitPl2
ENDC
	dw Act_Goblin_SpawnPuchi
	dw Act_Goblin_SpawnHorns

; =============== Act_Goblin_WaitPl ===============
Act_Goblin_WaitPl:
	; Don't interfere with level scrolling, since showing the body involves writing event data.
	; The EU version also checks for any existing tilemap events.
	IF REV_VER == VER_EU
		xor  a
		ld   hl, wLvlScrollEvMode
		or   [hl]
		ld   hl, wTilemapEv
		or   [hl]
		ret  nz
	ELSE
		ld   a, [wLvlScrollEvMode]
		and  a
		ret  nz
	ENDC

	
	; Don't do anything until the player gets within 4 blocks, which is far enough to not let
	; the player get inside the area where the Goblin is drawn.
	call ActS_GetPlDistanceX
	cp   BLOCK_H*4
	ret  nc
	
	; Draw the Goblin and write its blocks to the level layout
	call Act_Goblin_ShowBody
	
	; [BUG] The European version introduces a bug, as for some reason it draws the Goblin a second time when the player is within 3.5 blocks.
	;       This is pointless, and does not play well at all with the scrolling bug that offsets the actors' spawn position while sliding.
	IF REV_VER == VER_EU
		jp   ActS_IncRtnId
		
	; =============== Act_Goblin_WaitPl2 ===============
	Act_Goblin_WaitPl2:
		; Same logic as Act_Goblin_WaitPl, except with a 3.5 block threshold
		xor  a
		ld   hl, wLvlScrollEvMode
		or   [hl]
		ld   hl, wTilemapEv
		or   [hl]
		ret  nz
		
		call ActS_GetPlDistanceX
		cp   BLOCK_H*3+(BLOCK_H/2)
		ret  nc
		
		call Act_Goblin_ShowBody
	ENDC
	
	; First Petit Goblin spawns on the left
	xor  a
	ldh  [hActCur+iGoblinPuchiDir], a
	
	;
	; Set the initial delays for spawning Petit Goblins and making the horns rise, respectively.
	; These are shorter than the normal delays used from the 2nd, which *especially* affect the latter.
	;
	; Unlike most other delays, these are *concurrent*.
	; From this point onward, every frame the actor will alternate between checking to spawn the Petit Goblins
	; and checking to spawn the horns on the side. Any check that fails will switch to the other routine and return.
	; That is the reason two separate timers are at play here.
	;
	
	; Wait 16 frames before doing the spawn checks (normal delay is ~1 second)
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	
	; 16 frames are significantly shorter than the normal delay of ~2 seconds (as it needs to wait for the spikes)
	; which is set from the 2nd time onwards.
	;
	; That leaves a very little window to safely jump on the platform without getting hit without stopping,
	; especially considering how far the goblin's spawn check reaches.
	ld   a, $10
	ldh  [hActCur+iGoblinRiseDelay], a
	
	; From this point onward, alternate between spawning Petit Goblins and raising/spawning horns.
	jp   ActS_IncRtnId
	
; =============== Act_Goblin_SpawnPuchi ===============
Act_Goblin_SpawnPuchi:

	; Wait before trying to spawn them.
	ldh  a, [hActCur+iActTimer]
	sub  $01						; Timer--
	ldh  [hActCur+iActTimer], a
	jp   nz, ActS_IncRtnId			; Timer > 0? If so, switch
	
	; From the 2nd time onwards, delay spawns by ~1 second
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	
	; If the player isn't within 2 blocks, switch routines.
	; This maps to the player being in the horizontal range of the Goblin platform.
	call ActS_GetPlDistanceX
	cp   BLOCK_H*2				; DiffX >= $20?
	jp   nc, ActS_IncRtnId		; If so, switch
	
	; If there are already 3 on screen, don't spawn more
	ld   a, ACT_PUCHIGOBLIN
	call ActS_CountById
	ld   a, b
	cp   $03					; Count >= $03?
	jp   nc, ActS_IncRtnId		; If so, switch
	
	; Otherwise, spawn the Petit Goblin.
	; It will spawn directly on the center of the platform, so it will need to move horizontally out by itself.
	ld   a, ACT_PUCHIGOBLIN
	ld   bc, ($00 << 8)|LOW(-$02)	; 2px up
	call ActS_SpawnRel
	jp   c, ActS_IncRtnId
	
	; Altenate between making the Petit Goblin exit on the left and right sides
	inc  hl ; iActRtnId
	inc  hl ; iActSprMap
	
	ldh  a, [hActCur+iGoblinPuchiDir]	; Get our direction
	xor  [hl]							; Merge with iActSprMap (Could have been "or  [hl]", iActSprMap is 0)
	ld   [hl], a						; Save back to iActSprMap
	ldh  a, [hActCur+iGoblinPuchiDir]	; Flip spawn dir for next time
	xor  ACTDIR_R
	ldh  [hActCur+iGoblinPuchiDir], a
	jp   ActS_IncRtnId
	
; =============== Act_Goblin_SpawnHorns ===============
Act_Goblin_SpawnHorns:

	; Wait before trying to spawn them.
	ld   hl, hActCur+iGoblinRiseDelay
	dec  [hl]
	jp   nz, ActS_DecRtnId
	
	; From the 2nd time onwards, delay spawns by ~2 seconds
	ld   [hl], $80 ; iGoblinRiseDelay
	
	; Don't spawn the horns when the head origin is offscreen, as they'd risk wrapping around.
	ldh  a, [hActCur+iActX]
	cp   SCREEN_GAME_H+OBJ_OFFSET_X+$08
	ret  nc
	
	; LEFT HORN
	ld   a, ACT_GOBLINHORN
	ld   bc, (LOW(-$12) << 8)|LOW(-$18) ; 18px left, 24px up
	call ActS_SpawnRel			; Could it spawn?
	jp   c, ActS_DecRtnId		; If not, go back to Act_Goblin_SpawnPuchi
	
	;
	; There's a bug that shifts actors by 1 pixel when they're being scrolled to the right.
	; Normally actors should be spawned on horizontal pixel $08, the bug makes them spawn on $07.
	;
	; That's bad, as the actor's position is supposed to be consistent with the solid blocks, but
	; instead of just fixing the bug in Pl_MoveR, this actor opted to work around it with unfortunate code.
	;
	; This actor assumes the Goblin to be on the bugged $07 position.
	; The horn is 18px to the left of the Goblin, when converted to absolute, we land into
	; (7 - 18) % 8 = -3
	;
	; Meaning the horn is meant to be 3px to the left the 8x8 tile's left edge.
	; aka 5px to the right.
	;
	ld   de, iActX		; HL = Actor's X position
	add  hl, de
	ldh  a, [hScrollX]	
	and  $07			; A = Updated tile scroll offset (pixels)
	ld   b, a			;
	add  [hl]			; Add the actor's X pos
	and  $F8			; Align to tile boundary.
	sub  b				; After aligning, remove the scroll pos we added. This is the start of the tile.
	add  $05			; Add those 5 pixels
	ld   [hl], a		; Save to iActX

	
	; RIGHT HORN
	ld   a, ACT_GOBLINHORN
	ld   bc, (LOW($14) << 8)|LOW(-$18) ; 20px right, 24px up
	call ActS_SpawnRel
	jp   c, ActS_DecRtnId
	; See above, but with 3px to the right
	; (20 - 7) % 8 = 3
	ld   de, iActX
	add  hl, de
	ldh  a, [hScrollX]
	and  $07
	ld   b, a
	add  [hl]
	and  $F8
	sub  b
	add  $03
	ld   [hl], a
	
	jp   ActS_DecRtnId
	
