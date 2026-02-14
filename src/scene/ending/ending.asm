; =============== Module_Ending ===============
; Ending cutscene.
Module_Ending:
	
Ending_Sc1:
	;
	; SCENE 1
	;
	; Wily escapes from the station, with Rockman chasing him and shooting him down.
	;
	
	; Load the space scene
	ld   a, GFXSET_SPACE
	call GFXSet_Load
	
	ld   de, TilemapDef_WilyStationEntrance
	call LoadTilemapDef
	; Make entrance visible on the right side of the screen
	ld   a, $20
	ldh  [hScrollX], a
	call StartLCDOperation
	
	; Load the same explosion graphics used in the Wily Castle cutscene, at the same address.
	; A consequence is that GFXSET_SPACE will need to be reloaded when moving to the 2nd scene.
	ld   hl, GFX_Wpn_MeNe ; Source GFX ptr
	ld   de, $8500 ; VRAM Destination ptr
	ld   bc, (BANK(GFX_Wpn_MeNe) << 8)|$08 ; B = Source GFX bank number (BANK $02) C = Number of tiles to copy
	call GfxCopy_Req

	mPlayBGM BGM_TITLE
	
	;
	; Spawn the two actors.
	; During the course of this sequence, until Wily explodes, only two will ever be visible
	; on screen at the same time, so that's how many we need.
	;
	
	; Wily and the Player use the same slot (can't have them both onscreen)
	DEF tActWily     = wScAct0
	DEF tActPl       = wScAct0
	; The entrance and the missile use the same slot 
	DEF tActSkullJaw = wScAct1
	DEF tActMissile  = wScAct1
	
	; WILY SPACESHIP
	ld   hl, tActWily
	xor  a
	ld   de, ((OBJ_OFFSET_Y+$70) << 8)|(OBJ_OFFSET_X+$B8)
	; Y position: $80 (around bottom)
	ldi  [hl], a ; iScActYSub
	ld   [hl], d ; iScActY
	inc  hl
	; X position: $C0 (offscreen right)
	ldi  [hl], a ; iScActXSub
	ld   [hl], e ; iScActX
	inc  hl
	ldi  [hl], a ; iScActSpdYSub
	ldi  [hl], a ; iScActSpdY
	ldi  [hl], a ; iScActSpdXSub
	ldi  [hl], a ; iScActSpdX
	
	; ENTRANCE DOOR
	ld   de, ((OBJ_OFFSET_Y+$78) << 8)|(OBJ_OFFSET_X+$98)
	; Y position: $88 (around bottom)
	ldi  [hl], a ; iScActYSub
	ld   [hl], d ; iScActY
	inc  hl
	; X position: $A8 (right)
	ldi  [hl], a ; iScActXSub
	ld   [hl], e ; iScActX
	inc  hl
	ldi  [hl], a ; iScActSpdYSub
	ldi  [hl], a ; iScActSpdY
	ldi  [hl], a ; iScActSpdXSub
	ldi  [hl], a ; iScActSpdX
	
	; MISC INIT 
	ldi  [hl], a ; wScEd1ScrollSpdX
	ldi  [hl], a ; wScEd1FramesLeft
	ldi  [hl], a ; wScAct0SprMapBaseId
	ldi  [hl], a ; wScAct1SprMapBaseId
	ldi  [hl], a ; wScEvSrcPtr_Low
	ldi  [hl], a ; wScEvSrcPtr_High
	ldi  [hl], a ; wScEvEna
	ldi  [hl], a ; $CD05
	
	;
	; SCENE 1a - Open the entrance skull
	;
	ld   a, $01				; Move 1px/frame down
	ld   [tActSkullJaw+iScActSpdY], a
	ld   a, $18				; For 24 frames
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1b - Make Wily escape
	;
	ld   a, -$02			; Move Wily 2px/frame left
	ld   [tActWily+iScActSpdX], a
	ld   a, $00				; Keep entrance opened
	ld   [tActSkullJaw+iScActSpdY], a
	ld   a, $02				; Use Wily Sprite
	ld   [wScAct0SprMapBaseId], a
	ld   a, $70				; For ~2 seconds (enough to move from offscreen right to offscreen left)
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1c - Make Rockman escape #1
	;            Scroll screen, pre-redraw.
	;	
	ld   a, OBJ_OFFSET_X+$A8	; Start offscreen right
	ld   [tActPl+iScActX], a
	ld   a, LOW(-$80)			; Move player 0.5px/frame left
	ld   [tActPl+iScActSpdXSub], a
	ld   a, HIGH(-$80)
	ld   [tActPl+iScActSpdX], a
	ld   a, $02					; Close entrance 2px/frame up
	ld   [tActSkullJaw+iScActSpdX], a
	ld   a, -$02				; Scrols screen at 2px/frame left
	ld   [wScEd1ScrollSpdX], a
	ld   a, $04					; Use Rockman sprite
	ld   [wScAct0SprMapBaseId], a
	ld   a, $10					; For 16 frames only
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1d - Make Rockman escape #2
	;            Scroll screen, redraw tilemap edge.
	;
	xor  a						; Stop moving the Jaw
	ld   [tActSkullJaw+iScActSpdX], a
	; Trigger redraw of the tilemap to erase the Wily Station, allowing for looping scrolling stars.
	; This event starts while part of the Station is still visible, but with the way the event happens
	; over multiple frames, by the time it'd write over the visible part we have already scrolled it offscreen.
	ld   hl, TilemapDef_Ending_Space
	ld   a, l					; Set event source
	ld   [wScEvSrcPtr_Low], a
	ld   a, h
	ld   [wScEvSrcPtr_High], a
	ld   a, $FF					; Trigger event
	ld   [wScEvEna], a
	ld   a, $50					; For ~1.5 seconds
	ld   [wScEd1FramesLeft], a
	; While this happens, the player keeps moving 0.5px/frame left.
	call EndingSc1_AnimFor
	
	;
	; SCENE 1d - Move player slightly above, while still moving right.
	;            This is so the missile, which spawns later, can hit Wily while moving in a straight line.
	;
	ld   a, LOW(-$40)			; Move 0.125px/frame up (while still moving 0.5px/frame left)
	ld   [tActPl+iScActSpdYSub], a
	ld   a, HIGH(-$40)
	ld   [tActPl+iScActSpdY], a
	ld   a, $40					; For ~1 second
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1e - The player is in place, stop moving #1
	;	
	xor  a						; Stop moving
	ld   [tActPl+iScActSpdYSub], a
	ld   [tActPl+iScActSpdY], a
	ld   [tActPl+iScActSpdXSub], a
	ld   [tActPl+iScActSpdX], a
	ld   a, $40					; For ~1 second
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1f - The player is in place, stop moving #2
	;	
	xor  a						; Not necessary
	ld   [tActPl+iScActSpdYSub], a
	ld   [tActPl+iScActSpdY], a
	ld   a, $80					; For ~2 seconds
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1g - Spawn missile
	;
	ld   a, [tActPl+iScActY]	; Missile Y: 8px below player
	add  $08
	ld   [tActMissile+iScActY], a
	ld   a, [tActPl+iScActX]	; Missile X: Same as player (middle)
	ld   [tActMissile+iScActX], a
	ld   a, $02					; Use missile sprite
	ld   [wScAct1SprMapBaseId], a
	ld   a, $80					; For ~2 seconds
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1h - Fire missile, scrolling the player out to the right.
	;            Actually doesn't alter the starfield scrolling screen, which is a missed opportunity,
	;            it's only the player moving to the right to give the effect.
	;	
	ld   a, $01					; Move player 1px/frame right
	ld   [tActPl+iScActSpdX], a
	ld   a, $80					; For ~2 seconds
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1i - Fire missile, scrolling Wily in from the left.
	;            Making Wily show up required scrolling the player out first.
	;	
	ld   a, [tActPl+iScActY]	; Move Wily 10px below player
	add  $10
	ld   [tActWily+iScActY], a
	ld   a, $01					; Move Wily 1px/frame right
	ld   [tActWily+iScActSpdX], a
	ld   a, $02					; Use Wily sprite
	ld   [wScAct0SprMapBaseId], a
	ld   a, $80					; For ~2 seconds
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	;
	; SCENE 1j - Despawn missile
	;	
	xor  a						; Stop moving Wily
	ld   [tActWily+iScActSpdX], a
	ld   a, $10					; For 16 frames
	ld   [wScEd1FramesLeft], a
	call EndingSc1_AnimFor
	
	
	;
	; SCENE 1k - Make Wily blow up while flashing.
	;
	; This effect displays several sprites while flashing Wily's palette.
	; This is not supported by EndingSc1_AnimFor, which is why it's all done
	; manually and uses its own format for tracking sprites.
	;

	; Save the spaceship position elsewhere
	ld   a, [tActWily+iScActY]
	ld   [wScEd1WilyY], a
	ld   a, [tActWily+iScActX]
	ld   [wScEd1WilyX], a
	
	;
	; Spawn the 4 explosions
	;
	
	; EXPLOSION 0
	ld   hl, wScEdExpl0
	xor  a
	; Initially, hide all the explosions by placing them with both coords 0.
	ldi  [hl], a ; iScExplY
	ldi  [hl], a ; iScExplX
	; Start with hidden explosion sprite
	ld   [hl], $04 ; iScExplSprMapId
	inc  hl
	; After $28 frames, show this explosion.
	; When the timer elapses, EndingSc1_AnimExpl gets called, which properly initializes the coordinates.
	; Every explosion has its initial timer set to an unique value, to avoid having them animate in sync.
	ld   [hl], $28 ; iScExplTimer
	inc  hl
	
	; EXPLOSION 1
	ldi  [hl], a ; iScExplY
	ldi  [hl], a ; iScExplX
	ld   [hl], $04 ; iScExplSprMapId
	inc  hl
	ld   [hl], $20 ; iScExplTimer
	inc  hl
	
	; EXPLOSION 2
	ldi  [hl], a ; iScExplY
	ldi  [hl], a ; iScExplX
	ld   [hl], $04 ; iScExplSprMapId
	inc  hl
	ld   [hl], $18 ; iScExplTimer
	inc  hl
	
	; EXPLOSION 3
	ldi  [hl], a ; iScExplY
	ldi  [hl], a ; iScExplX
	ld   [hl], $04 ; iScExplSprMapId
	inc  hl
	ld   [hl], $10 ; iScExplTimer
	inc  hl
	
	
	; Do this scene for ~4 seconds
	ld   a, $FF
	ld   [wScEdWilyExplTimer], a
	
.loop:
	;--
	;
	; DRAW SPRITES
	;
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	;
	; Draw Wily's spaceship
	;
	ld   a, [wScEd1WilyY]
	ld   [wTargetRelY], a
	ld   a, [wScEd1WilyX]
	ld   [wTargetRelX], a
	; Flash Wily's palette every 4 frames
	ld   a, [wScEdWilyExplTimer] ; (1/16)
	add  a ; << 1 (1/8)
	add  a ; << 1 (1/4)
	and  SPR_OBP1 ; Filter bit
	ld   [wScBaseSprFlags], a
	; Draw the same Wily sprite.
	; This doesn't animate it, but it's hard to notice between the flashing and explosions.
	ld   hl, SprMapPtrTbl_ScPl
	ld   a, $02
	call Sc_DrawSprMap
	
	;
	; Draw all four explosions
	;
	xor  a						; Draw with normal palette
	ld   [wScBaseSprFlags], a
	
	ld   hl, wScEdExpl0			; HL = Ptr to first explosion
	ld   b, $04					; B = Number of explosions
.drExLoop:
	push bc ; Save count
		ldi  a, [hl]			; Y Position: iScExplY
		ld   [wTargetRelY], a
		ldi  a, [hl]			; X Position: iScExplX
		ld   [wTargetRelX], a
		ldi  a, [hl]			; Sprite mapping ID: iScExplSprMapId
		inc  hl					; Skip past iScExplTimer, into the next iScExplY
		push hl					; Save slot ptr
			ld   hl, SprMapPtrTbl_ScExpl
			call Sc_DrawSprMap
		pop  hl					; Restore slot ptr
	pop  bc				; B = ExplLeft
	dec  b				; Processed them all?
	jr   nz, .drExLoop	; If not, loop
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; ANIMATE EXPLOSIONS
	;
	ld   hl, wScEdExpl0			; HL = Ptr to first explosion
	ld   b, $04					; B = Number of explosions
.animLoop:
	inc  hl ; iScExplX
	inc  hl ; iScExplSprMapId
	inc  hl ; iScExplTimer
	; If iScExplTimer elapsed, advance the animation for this explosion
	push hl
		dec  [hl]					; iScExplTimer--
		call z, EndingSc1_AnimExpl	; iScExplTimer == 0? If so, animate
	pop  hl
	inc  hl ; Seek to next explosion's iScExplY
	dec  b 				; Done animating them all?
	jr   nz, .animLoop	; If not, loop
	
	; Do scrolling starfield
	ld   hl, hScrollX	; 2px/frame
	dec  [hl]
	dec  [hl]
	
	ld   a, [wScEdWilyExplTimer]
	dec  a							; Timer--
	ld   [wScEdWilyExplTimer], a	; Has it elapsed?
	jr   nz, .loop					; If not, loop
	
Ending_Sc2:	
	;
	; SCENE 2
	;
	; Wily dies.
	;
	
	;--
	ld   a, GFXSET_SPACE
	call GFXSet_Load
	
	ld   de, TilemapDef_Earth
	call LoadTilemapDef
	
	call StartLCDOperation
	;--
	
	mPlayBGM BGM_STAGESELECT

	
	;--
	; [POI] Not necessary, the small explosions aren't loaded or used here.
	; EXPLOSION 0
	ld   hl, wScEdExpl0
	xor  a
	ld   de, ($80 << 8)|$40
	ldi  [hl], a ; iScExplY
	ld   [hl], d ; iScExplX
	inc  hl
	ldi  [hl], a ; iScExplSprMapId
	ld   [hl], e ; iScExplTimer
	inc  hl
	
	; EXPLOSION 1
	ldi  [hl], a ; iScExplY
	ldi  [hl], a ; iScExplX
	ldi  [hl], a ; iScExplSprMapId
	ldi  [hl], a ; iScExplTimer
	;--

	
	;##
	;
	; SCENE 2a - Wily crashes into the Earth
	;
	
	; Set Wily's initial position (top-right)
	ld   a, OBJ_OFFSET_Y+$30
	ld   [wTargetRelY], a
	ld   a, OBJ_OFFSET_X+$98
	ld   [wTargetRelX], a
	
	xor  a
	ld   [wScEdWilyExplTimer], a
.crLoop:
	;--
	;
	; DRAW SPRITES
	;
	xor  a				; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw Wily fireball
	; Use sprites $00-$01 at 1/8 speed, based on Wily's vertical postion.
	ld   hl, SprMapPtrTbl_ScWilyCrash
	ld   a, [wTargetRelY]
	rrca ; /2
	rrca ; /4 (at half speed movement, that's 1/8)
	and  $01 ; Use sprites $00-$01
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	;--

	;
	; Move at 0.5px/frame down-left
	;
	rst  $08 ; Wait Frame	; Every 2 frames...
	rst  $08 ; Wait Frame
	
	ld   hl, wTargetRelY	; Move 1px down
	inc  [hl]
	ld   hl, wTargetRelX	; Move 1px left
	dec  [hl]
	
	; Crash into the earth when reaching Y position $90, around the bottom
	ld   a, [wTargetRelY]
	cp   OBJ_OFFSET_Y+$80
	jr   nz, .crLoop
	
	;##
	;
	; SCENE 2b - Wily crashes
	;
	
	xor  a				; Init timer
	ld   [wScEdWilyExplTimer], a
	
	mStopSnd			; Play nuke SFX
	mPlaySFX SFX_UFOCRASH
	
.nkLoop:
	;--
	;
	; DRAW SPRITES
	;
	
	xor  a				; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the skull nuke
	; Use sprites $00-$07 at 1/16 speed
	ld   hl, SprMapPtrTbl_ScWilyNuke
	ld   a, [wScEdWilyExplTimer]
	rrca ; /2
	rrca ; /4
	rrca ; /8 
	rrca ; /16 
	and  $07 ; Use sprites $00-$07
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	; Execute the above for $80 frames (~2 seconds)
	ld   hl, wScEdWilyExplTimer
	inc  [hl]			; Timer++
	ld   a, [hl]
	add  a				; Timer * 2 overflows? (Timer < $80)
	jr   nc, .nkLoop	; If not, loop
	
	; Wait 2 seconds before starting the credits
	ld   a, 60*2
	call WaitFrames
	ret
	
; =============== EndingSc1_AnimFor ===============
; Animates the ending scene with scrolling starts for the specified amount of frames.
; This does not support Wily's explosions, so it can't be used for that part.
; IN
; - wScEd1FramesLeft: How many frames to execute it
EndingSc1_AnimFor:
	call EndingSc1_Anim
	
	; Move both actors, whatever they may be
	ld   hl, wScAct0
	call ScAct_ApplySpeed
	ld   hl, wScAct1
	call ScAct_ApplySpeed
	
	; Scroll the screen/starfield horizontally by the specified amount
	ld   hl, wScEd1ScrollSpdX
	ldh  a, [hScrollX]
	add  [hl]
	ldh  [hScrollX], a
	
	inc  hl 					; Seek to wScEd1FramesLeft
	ld   hl, wScEd1FramesLeft 	; (Not necessary)
	dec  [hl]					; Executed it for all frames?
	jr   nz, EndingSc1_AnimFor			; If not, loop
	ret
	
; =============== EndingSc1_Anim ===============
; Draws the sprite mappings for all cutscene actors in the scrolling stars sequence.
; This also handles updating the tilemap for the scrolling starfield.
EndingSc1_Anim:
	xor  a						; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	;
	; DRAW ACTOR 0 (Player or Wily)
	;
	ld   a, [wScAct0+iScActY]
	ld   [wTargetRelY], a
	ld   a, [wScAct0+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScPl
	;--
	; Alternate between wScAct0SprMapBaseId and (wScAct0SprMapBaseId+1) at 1/4 speed
	ld   a, [wScEd1FramesLeft]
	rrca ; /2
	rrca ; /4
	and  $01	; 2 frames anim ($00-$01)
	ld   b, a	; to B
	ld   a, [wScAct0SprMapBaseId]	; Get base ID
	add  b							; Add relative
	;--
	call Sc_DrawSprMap			; Draw it
	
	;
	; DRAW ACTOR 1 (Skull Jaw or Crayola Missile)
	;
	ld   a, [wScAct1+iScActY]
	ld   [wTargetRelY], a
	ld   a, [wScAct1+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScSkullJaw
	;--
	; Alternate between wScAct0SprMapBaseId and (wScAct0SprMapBaseId+1) at 1/4 speed.
	; This is used to animate the Missile, but because this is also done while drawing the Skull Jaw,
	; which has no animation, the latter has a duplicate entry in the sprite mapping table.
	ld   a, [wScEd1FramesLeft]
	rrca 
	rrca 
	and  $01
	ld   b, a
	ld   a, [wScAct1SprMapBaseId]
	add  b
	;--
	call Sc_DrawSprMap
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;##
	
	;
	; TILEMAP EDGE REDRAW
	; 
	; Used to redraw part of the tilemap when scrolling the starfield right.
	;
	; This is because the tilemap loaded in this scene (TilemapDef_WilyStationEntrance) contains
	; the entrance to the Wily Station on the right, which needs to get overwritten by stars.
	;
	; This only needs to be triggered exactly once during the whole sequence, as soon as the entrance
	; is scrolled out of view, then no further updates are necessary. 
	;
	
	ld   a, [wScEvEna]
	and  a				; Tilemap update triggered/in progress?
	ret  z				; If not, return
	; The EU version also makes sure another tilemap event somehow isn't in progress.
	; This really cannot happen as the ending scene is timed to prevent this scenario, but just in case...
	IF REV_VER == VER_EU
		ld   a, [wTilemapEv]
		and  a
		ret  nz
	ENDC
	
	;
	; As a large amount of tiles need to be written, this event is processed over multiple frames.
	; Unlike with GFX updates, there's no system in place for doing so with tilemaps, although
	; the way events are chained until reaching an end terminator would work very well for it.
	;
	; The event this uses is stored in ROM at TilemapDef_Ending_Space, which defines multiple commands for writing
	; columns to the tilemap. As each command can be executed as an indivudual event, copy that
	; to the buffer, stick and end terminator, and trigger it. The next frame copy the next command
	; from where we last left off, and so on until we reach the terminator in ROM.
	;
	; Similar multi-frame events are handled manually later on, in the credits sequence.
	;
	
	ld   a, [wScEvSrcPtr_Low]		; HL = Source event (where we last left off)
	ld   l, a
	ld   a, [wScEvSrcPtr_High]
	ld   h, a
	ld   de, wTilemapBuf			; DE = Destination
	ld   bc, $0015					; BC = Event size (3-byte header + 18 tiles)
	call CopyMemory					; Copy to event buffer
	xor  a							; Write terminator
	ld   [de], a
	inc  a							; Trigger event
	ld   [wTilemapEv], a
	ld   a, l						; Save back what we reached
	ld   [wScEvSrcPtr_Low], a
	ld   a, h
	ld   [wScEvSrcPtr_High], a
	
	ld   a, [hl]
	and  a							; Did we reach the null terminator?
	ret  nz							; If not, return (trigger another event next frame)
	ld   [wScEvEna], a			; Otherwise, we're done
	ret
	
; =============== EndingSc1_AnimExpl ===============
; Animattes a single explosion for Wily's spaceship.
; IN
; - HL: Ptr to iScExplTimer
EndingSc1_AnimExpl:
	; Reset animation timer to $08
	; This sets the animation speed to 1/8
	ld   [hl], $08
	
	; Advance animation cycle ($00-$02)
	dec  hl ; iScExplSprMapId
	ld   a, [hl]	; SprId++
	inc  a
	ld   [hl], a
	cp   $03		; Went out of range?
	ret  c			; If not, return
	
	; Otherwise, "respawn" the explosion
	ld   [hl], $00	; Reset to first sprite
	
	;
	; Randomize the spawn coordinates, anywhere from +$18 to -$20 within Wily's Spaceship.
	;
	
	; X POSITION
	dec  hl ; iScExplX
	; C = (Rand & $38) - $20
	call Rand	; Randomize
	and  $38	; Filter in range
	sub  $20	; Offset in both directions
	ld   c, a
	; iScExplX = wScEd1WilyX + C
	ld   a, [wScEd1WilyX]
	add  c
	ld   [hl], a
	
	; Y POSITION
	dec  hl ; iScExplY
	; C = (Rand & $38) - $20
	call Rand	; Randomize
	and  $38	; Filter in range
	sub  $20	; Offset in both directions
	ld   c, a
	; iScExplY = wScEd1WilyY + C
	ld   a, [wScEd1WilyY]
	add  c
	ld   [hl], a
	
	mPlaySFX SFX_EXPLODE	; Play explosion SFX
	ret
	
