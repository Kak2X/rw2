; =============== WilyCastle_DoCutscene ===============
; In-engine cutscene at the start of the Wily Castle level.
; While there are a few actors associated to this, them and the player are controlled by this subroutine.
WilyCastle_DoCutscene:
	; Start from clean key state.
	xor  a
	ldh  [hJoyNewKeys], a
	ldh  [hJoyKeys], a
	
	;
	; ROOM $01 - Empty room.
	;
	
.waitFallR1:
	; Wait until the player lands on the ground
	call NonGame_Do
	ld   a, [wPlMode]
	or   a					; wPlMode != PL_MODE_GROUND?
	jr   nz, .waitFallR1	; If so, loop
	
	; Pause for a second
	ld   b, 60
	call NonGame_DoFor
	
	; Look back and forth 6 times (in practice 5, see below), turning around every half-a-second.
	; Note that by default the player faces right, so this would end with the player facing right...
	ld   b, $06				; B = Times left
.lookLoop:
	push bc
		ld   b, 30			; Wait half a second
		call NonGame_DoFor
		ld   a, [wPlDirH]	; Turn around
		xor  DIR_R
		ld   [wPlDirH], a
	pop  bc
	dec  b					; Did that 6 times?
	jr   nz, .lookLoop		; If not, loop
	
	; ...but as soon as we turned right before the end of the loop, immediately start moving left.
	; This hides the last turn, effectively it's the same as turning 5 times with a delay of half-a-second before moving.

	; Move towards the hole on the floor, to transition to the next room.
	ld   a, KEY_LEFT		; Move left...
	ldh  [hJoyKeys], a
	ld   b, $50				; For ~1.5 seconds
	call NonGame_DoFor
	
	
	;
	; ROOM $02 - Wily's trap.
	;
	; This room contains an instance of Act_WilyCastleCutscene on the right side of the screen,
	; which handles drawing Dr. Wily. That actor has absolutely no code though, it's all driven 
	; by this cutscene to avoid splitting up the cutscene code.
	; Since there are no other actors at first, it is assumed to be on the first slot.
	;
	
	; Wait until the player lands on the ground.
	; The vertical transition happens during this.
	xor  a
	ldh  [hJoyKeys], a
.waitFallR2:
	call NonGame_Do
	ld   a, [wPlMode]
	or   a					; wPlMode != PL_MODE_GROUND?
	jr   nz, .waitFallR2	; If so, loop
	
	; Pause for 3 seconds looking at Wily
	ld   a, DIR_R			; Face right upon landing.
	ld   [wPlDirH], a
	ld   b, 60*3
	call NonGame_DoFor
	
	;
	; Start inching forward, as Wily starts inching back.
	; For now, these actions are alternated.
	;
	ld   b, $02		; For two times...
.altMvLoop:
	push bc
		; Reset player and Wily movement
		xor  a
		ldh  [hJoyKeys], a
		ld   [wWilyWalkTimer], a
		
		; Move Wily back for ~2 seconds at 0.125px/frame (in total, 1 block back)
		ld   b, $80			; For 128 frames...
	.altWlLoop:
		call WilyCastle_DoCutscene_MoveWily
		call NonGame_Do
		dec  b				; Done moving?
		jr   nz, .altWlLoop	; If not, loop
		
		; Move player 1 block right
		ld   a, KEY_RIGHT
		ldh  [hJoyKeys], a
		ld   b, $10
		call NonGame_DoFor
		; Followed by an half-second pause
		xor  a
		ldh  [hJoyKeys], a
		ld   b, 30
		call NonGame_DoFor
	pop  bc
	dec  b				; Repeated the above twice?
	jr   nz, .altMvLoop	; If not, loop
	
	
	;
	; Move both the player and Wily right at the same time, 
	; until we reach the 2-block wide trap.
	;	
	ld   a, KEY_RIGHT		; Move right
	ldh  [hJoyKeys], a
.sngMvLoop:
	call WilyCastle_DoCutscene_MoveWily	; Move Wily right
	call NonGame_Do						; Move Rockman right
	; It would have been slighly better had the trap activated at the center of the screen,
	; but the trap blocks are not solid, even before the explosion starts.
	ld   a, [wPlRelX]
	cp   OBJ_OFFSET_X+$48				; Reached the trap? (X position $50)				
	jr   c, .sngMvLoop					; If not, continue moving
	
	;
	; Stepped on the trap, make the two blocks on the ground explode.
	;
	
	ld   a, PL_MODE_FROZEN	; Freeze the player while doing this
	ld   [wPlMode], a
	
	; The graphics used by the explosion, for some reason, are part of the weapon GFX set containing Needle Cannon and
	; Metal Blade's shot graphics. Those strips are 16 tiles long, with the first half dedicated to these explosions.
	; Perhaps for that reason, the first 8 bytes of that get loaded to VRAM where the weapon graphics should be.
	ld   hl, GFX_Wpn_MeNe ; Source GFX ptr
	ld   de, $8500 ; VRAM Destination ptr
	ld   bc, (BANK(GFX_Wpn_MeNe) << 8)|$08 ; B = Source GFX bank number (BANK $02) C = Number of tiles to copy
	call GfxCopy_Req
	rst  $20 ; Wait GFX load
	
	; Spawn three explosions over the trap blocks.
	; Not spawned all at once since it wouldn't look good if their animations were in sync.
	
	; Shared properties.
	ld   a, ACT_GROUNDEXPL		; Spawn weird explosion
	ld   [wActSpawnId], a
	xor  a						; Not part of actor layout
	ld   [wActSpawnLayoutPtr], a
	ld   a, $88					; Y Position: Middle of lowest block
	ld   [wActSpawnY], a
	
	; LEFT BLOCK
	ld   a, $50					; X Position: Center of left block
	ld   [wActSpawnX], a
	call ActS_Spawn
	ld   b, $0F					; Wait 15 frames before spawning the next one
	call NonGame_DoFor
	
	; RIGHT BLOCK
	ld   a, $60					; X Position: Center of right block
	ld   [wActSpawnX], a
	call ActS_Spawn
	ld   b, $0F					; Wait 15 frames before spawning the next one
	call NonGame_DoFor
	
	; BETWEEN BLOCKS
	ld   a, $58					; X Position: Center of the screen
	ld   [wActSpawnX], a
	call ActS_Spawn
	ld   b, 60					; Wait a second before moving on
	call NonGame_DoFor
	
	;
	; Make the trap blocks visually disappear.
	; As the blocks were solid to begin with, this doesn't need to actually alter the level layout.
	;
	ld   hl, TilemapDef_WilyCastle_TrapGone
	ld   de, wTilemapBuf
	ld   bc, TilemapDef_WilyCastle_TrapGone.end-TilemapDef_WilyCastle_TrapGone
	call CopyMemory
	ld   a, $01					; Trigger event
	ld   [wTilemapEv], a
	
	;
	; Unlock the player controls.
	;
	; This is kinda poorly done. Setting PL_MODE_GROUND while in the air, with the cutscene having 
	; overridden hJoyNewKeys to be 0, would allow the player to make a full jump by holding A, escaping 
	; out of the trap. To prevent that, the player controls are still locked for 8 frames.
	;
	; [BUG] 8 frames however is not enough time to trigger the vertical transition.
	;       The player can hold START to enter the pause screen as soon as possible, switch weapons
	;       and see glitched explosion graphics since they were loaded to that area of VRAM.
	;
	xor  a ; PL_MODE_GROUND		
	ld   [wPlMode], a
	ld   b, $08
	jp   NonGame_DoFor
	
; =============== WilyCastle_DoCutscene_MoveWily ===============
; Makes Wily take a step backwards every 8 frames (0.125px/frame).
; Every step taken advances the walk cycle.
WilyCastle_DoCutscene_MoveWily:
	; Every 8 frames....
	ld   a, [wWilyWalkTimer]
	and  $07
	jr   nz, .incTimer
	
	ld   h, HIGH(wAct)	; HL = Wily's iActSprMap
	ld   l, iActSprMap
	
	; Cycle between sprites $00 - $01
	ld   a, [hl]
	xor  $08
	ld   [hl], a
	
	; Wily is facing Rockman, who's on the left.
	; To move backwards, move 1px to the right.
	inc  l ; iActLayoutPtr
	inc  l ; iActXSub
	inc  l ; iActX
	inc  [hl]			; iActX++
.incTimer:
	ld   hl, wWilyWalkTimer
	inc  [hl]
	ret
	
TilemapDef_WilyCastle_TrapGone: INCLUDE "data/scene/castle/trapgone_bg.asm"
.end:

