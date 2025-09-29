; =============== Module_Game_BossDead ===============
; Gameplay loop when the boss explodes.
Module_Game_BossDead:

	; Stop moving and fall down
	xor  a
	ldh  [hJoyKeys], a
	ldh  [hJoyNewKeys], a
	ld   [wPlMode], a
	
	;
	; Draw an empty health bar for the boss.
	;
	ld   [wBossHealthBar], a	; Draw empty health bar
	ld   hl, wStatusBarRedraw	; Trigger redraw
	set  BARID_BOSS, [hl]
	
	; Cutscene modes don't handle actor collision, so clear them all as they won't get updated.
	dec  a
	ld   [wActHurtSlotPtr], a
	ld   [wActPlatColiSlotPtr], a
	ld   [wActRjStandSlotPtr], a
	ld   [wActHelperColiSlotPtr], a
	; Also deleting all actors.
	call ActS_ForceDespawnAll
	
	mStopSnd				; Stop the music straight away
	
	;
	; Handle the explosion animation for ~3 seconds, similarly to the player but simpler.
	;
	ld   b, $C0				; Do the effect for ~3 seconds
.loop:
	ld   a, b
	push bc
		; Every ~1 second, spawn another set of explosions
		and  $3F			; Timer % $40 != 0?
		jr   nz, .doGame	; If so, skip
		
		ld   a, SFX_EXPLODE		; Play explosion sound on every spawn
		mPlaySFX
		ld   a, [wExplodeOrgX]	; Use the boss coordinates as origin
		ld   [wActSpawnX], a
		ld   a, [wExplodeOrgY]
		ld   [wActSpawnY], a
		call ActS_SpawnLargeExpl
	.doGame:
		call NonGame_Do
	pop  bc
	dec  b					; All ~3 seconds passed?
	jr   nz, .loop			; If not, loop
	
	;
	; Wait for two seconds while the jingle plays.
	;
	ld   a, BGM_STAGECLEAR
	mPlayBGM
	ld   b, 60*2
	call NonGame_DoFor
	
	;
	; Move the player towards the center of the screen.
	; This is just enough to support the flat boss rooms used in the game,
	; so if you put blocks in the way you softlock.
	;
.chkPlCenter:
	ld   b, KEY_RIGHT		; B = Move right
	ld   a, [wPlRelX]
	cp   OBJ_OFFSET_X+(SCREEN_GAME_H/2)	; Are we at the center already? (PlX == $58)
	jr   z, .jumpHi			; If so, we're done
	jr   c, .movePlCenter	; Are we to the left? (PlX < $58) If so, confirm moving right.
	ld   b, KEY_LEFT		; B = Move left (PlX > $58)
.movePlCenter:
	ld   a, b				; Fake joypad input
	ldh  [hJoyKeys], a
	call NonGame_Do			; Execute pseudo-gameplay
	jr   .chkPlCenter		; Loop back
	
	;
	; At the center of the screen, perform an high jump (which can't be cut early).
	; It is important the jump can't be cut early, since we can get away with zeroing out joypad input.
	;
.jumpHi:
	ld   a, PL_MODE_FULLJUMP	; Non-cancellable jump
	ld   [wPlMode], a
	ld   a, $03					; At 3.5px/frame
	ld   [wPlSpdY], a
	ld   a, $80
	ld   [wPlSpdYSub], a
	xor  a						; Stop horizontal movement
	ldh  [hJoyKeys], a
	ldh  [hJoyNewKeys], a
	
	; Continue with the jump as normal until we start falling, then freeze.
.waitFall:
	call NonGame_Do
	ld   a, [wPlMode]
	cp   PL_MODE_FALL			; Starting to fall down?
	jr   nz, .waitFall			; If not, loop
	
	;
	; Play the weapon absorbtion sequence.
	; This is merely the large explosion with alternate positions / speed values. 
	;
	ld   a, PL_MODE_FROZEN		; Freeze player during this
	ld   [wPlMode], a
	DEF TIME = 60*3
	ld   b, TIME				; For 3 seconds...
.abLoop:
	ld   a, b
	push bc
		; Every half a second, alternate between spawning and despawning the absorption effects.
		cp   TIME-(30*0)		; 0
		jr   z, .abSpawn
		cp   TIME-(30*1)		; 0.5
		jr   z, .abKill
		cp   TIME-(30*2)		; 1.0
		jr   z, .abSpawn
		cp   TIME-(30*3)		; 1.5
		jr   z, .abKill
		cp   TIME-(30*4)		; 2
		jr   z, .abSpawn
		cp   TIME-(30*5)		; 2.5
		jr   z, .abKill
		jr   .abPlay
	.abSpawn:
		call ActS_SpawnAbsorb		; Spawn the 8 explosion actors
		ld   a, SFX_WEAPONABSORB	; Play respective SFX
		mPlaySFX
		jr   .abPlay
	.abKill:
		call ActS_ForceDespawnAll	; Delete all actors
	.abPlay:
		call NonGame_Do				; Update screen
	pop  bc
	dec  b						; Done with the animation?
	jr   nz, .abLoop			; If not, loop
	
	;
	; Unlock player movement and wait for him to land on the ground.
	;
	ld   a, PL_MODE_FALL		; Unlock player
	ld   [wPlMode], a
.waitGrd:
	call NonGame_Do				; Update player
	ld   a, [wPlMode]
	or   a						; wPlMode != PL_MODE_GROUND?
	jr   nz, .waitGrd			; If so, loop
	
	;
	; Then start teleporting out.
	; By the end of the two seconds, the player should have finished teleporting out.
	;
	ld   a, PL_MODE_WARPOUTINIT
	ld   [wPlMode], a
	ld   b, 60*2
	jp   NonGame_DoFor
	
; =============== Lvl_SetCompleted ===============
; Marks the current level as completed, which unlocks its associated weapon.
Lvl_SetCompleted:
	; Read completion bit off the table, indexed by level ID
	ld   a, [wLvlId]			; HL = &Lvl_ClearBitTbl[wLvlId]
	ld   hl, Lvl_ClearBitTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	; Set that bit to wWpnUnlock0
	ld   a, [wWpnUnlock0]		; wWpnUnlock0 |= *HL
	or   [hl]
	ld   [wWpnUnlock0], a
	ret
	
; =============== ActS_ForceDespawnAll ===============
; Forcibly despawns all actors in an unsafe way.
; Only use when it's not necessary to respawn anything from the actor layout,
; such as when all actors despawn after killing a boss.
ActS_ForceDespawnAll:
	; Clear iActId from every slot
	ld   bc, ($10 << 8)|$00		; B = Number of slots, C = $00
	ld   de, iActEnd			; DE = Slot size ($10) 
	ld   hl, wAct+iActId		; HL = Ptr to first actor
.loop:
	ld   [hl], c				; Write $00 to iActId
	add  hl, de					; Seek to next slot
	dec  b						; Done this for all slots?
	jr   nz, .loop				; If not, loop
	ret
	
