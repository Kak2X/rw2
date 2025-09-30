; =============== Module_WilyStationCutscene ===============
; Cutscene showing Wily escaping from the Castle into the Station.
Module_WilyStationCutscene:

WilyStation_Sc1:
	;
	; SCENE 1
	;
	; Wily flies away from the Castle.
	;
	call WilyCastle_LoadVRAM
	call StartLCDOperation
	mPlayBGM BGM_WILYCASTLE
	
	; Wait for 2 seconds
	ld   a, 60*2
	call WaitFrames
	
	; Don't flip any sprites
	xor  a
	ld   [wScBaseSprFlags], a
	
	;
	; Spawn Wily's spaceship.
	; This does not use the normal actor system, instead it has its own version specific to cutscenes,
	; where everything is spawned/handled manually and expects to be loaded to fixed slots.
	;
	DEF tActWily = wScAct0
	ld   hl, tActWily
	xor  a
	; The spaceship spawns from one of the skull's eyes.
	; Y Position: $70
	ldi  [hl], a ; iScActYSub
	ld   a, OBJ_OFFSET_Y+$60
	ldi  [hl], a ; iScActY
	; X Position: $40
	xor  a
	ldi  [hl], a ; iScActXSub
	ld   a, OBJ_OFFSET_X+$38
	ldi  [hl], a ; iScActX
	; Vertical speed: 0.25px/frame up
	ld   bc, -$0040
	ld   [hl], c ; iScActSpdYSub = $C0
	inc  hl
	ld   [hl], b ; iScActSpdY = $FF
	inc  hl
	; Horizontal speed: Calculated later
	xor  a
	ldi  [hl], a ; iScActSpdXSub = $00
	ldi  [hl], a ; iScActSpdX = $00
	
	; Start at the first hotspot
	ldi  [hl], a ; wScWilyArcIdx
	ld   [wScWilyHotspotNum], a
	
.nextHotspot:	
	;
	; Wily's Spaceship moves back and forth horizontally in a sine wave pattern.
	;
	; To do this, we're reusing the sine arc table (ActS_ArcPathTbl) to gradually speed up and down,
	; using a small arc (advancing the index twice, akipping half of the values)
	; As the values for speeding up and down can be mirrored, only half of them are defined in the table.
	; 
	; With Wily starting from the center, that means we have the following hotspots (wScWilyHotspotNum):
	;  ID |    POS |   DIR | SPEED
	; $00 | Center | Right |  Down
	; $01 |  Right |  Left |    Up
	; $02 | Center |  Left |  Down
	; $03 |   Left | Right |    Up
	; [loops]
	; 
	; Notice the direction changing every 2 hotspots, but offset by 1 since we're starting from the center,
	; while the speed changes every other hotspot.
	;
	
	
	; Calculate the high byte of the speed (pixel speed), from the hotspot number.
	; As we're moving slower than 1px/frame, this directly maps to the hotspot direction:
	; - $00 when moving right
	; - $FF when moving left
	ld   a, [wScWilyHotspotNum]
	dec  a				; -1 as we start from the center
	rrca				; /2 as the direction changes every 2 hotspots
	and  $01			; %2 as "" (right -> $01, left -> $00)
	dec  a				; Shift the result down (right -> $00, left -> $FF)
	ld   [tActWily+iScActSpdX], a
	
	; After $2D frames we reach the next hotspot.
	; As we're advancing indexes twice each time, that's the half of the length of the path table (+1)
	DEF TURNTIMER = (ActS_ArcPathTbl.end-ActS_ArcPathTbl)/2 + 1
	ld   a, TURNTIMER
	ld   [wScWilyArcLeft], a
	
.sineLoop:

	;--
	;
	; DRAW SPRITES
	;

	xor  a				; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	; Even though multiple sizes exist, the game only ever draws the third one.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; UPDATE HORIZONTAL SPEED
	;
	; In practice:
	; - If speeding up, wScWilyArcIdx += 2
	; - If speeding down, wScWilyArcIdx -= 2
	; Then the speed is read from ActS_ArcPathTbl[wScWilyArcIdx], and adjusted for the current direction.
	; As wScWilyArcIdx doesn't get reset between hotspots and speeding up is alternated with speeding down,
	; the index will move back and forth from $00 to $58 without going out of range.
	;
	; The way the wScWilyArcIdx is updated is more complicated than it has any right to be.
	; Instead of precalculating the offset (+2 or -2) into a separate variable before .sineLoop and just updating the index by that,
	; *every frame* it does two sets of calculations:
	; - One that only returns +2 on even hotspots
	; - One that only returns -2 on odd hotspots
	; Worth noting the +2 happens only after moving Wily, meaning outdated values are used when moving right.
	;
	
	;--
	; On odd hotspots, decrement the index by -2.
	; When (wScWilyHotspotNum % 2) == 1 -> wScWilyArcIdx -= 2
	ld   a, [wScWilyHotspotNum]
	inc  a		; +1 as we start from the center (and inverts odd/even)
	and  $01	; %2 as speed dir changes every other hotspot (odd: $00, even: $01)
	dec  a		; -1 for decrementing the index (odd: $FF, even: $00)
	add  a		; *2 as we skip speed (odd: $FE, even: $00)
	; wScWilyArcIdx += A
	ld   hl, wScWilyArcIdx
	add  [hl]	; Only does anything in the odd case
	ld   [hl], a
	;--
	
	; Seek HL to the current speed
	ld   hl, ActS_ArcPathTbl	; HL = ActS_ArcPathTbl
	ld   a, [wScWilyArcIdx]
	ld   b, $00					; BC = wScWilyArcIdx
	ld   c, a
	add  hl, bc					; Seek to HL[BC]
	
	; The speed read from the table is relative to moving right.
	; When moving left, it needs to be reversed since there's no concept of directions here.
	; Since iScActSpdX is guaranteed to be either $00 or $FF, xoring the read value with that mostly works out:
	; - When moving right it will be $00, so the speed value is untouched.
	; - When moving left it will be $FF, so the speed value is reversed.
	;   However, not doing the mandatory "inc a" means Wily will gradually drift over to the left.
	ld   a, [tActWily+iScActSpdX]
	xor  [hl]
	ld   [tActWily+iScActSpdXSub], a
	
	;
	; MOVE WILY
	;
	ld   hl, tActWily			; Move the Wily actor
	call ScAct_ApplySpeed
	
	; When Wily's Spaceship nearly moves offscreen above, advance to the next scene
	ld   a, [tActWily+iScActY]
	cp   OBJ_OFFSET_Y+$08		; iScActY == $18?
	jr   z, WilyStation_Sc2		; If so, jump
	
	;
	; TICK TIMERS
	;
	
	;--
	; On even hotspots, increment the index by +2.
	; The same as the the one for -2, except we never decremented the result so it increases it.
	; When (wScWilyHotspotNum % 2) == 0, wScWilyArcIdx += 2
	ld   a, [wScWilyHotspotNum]
	inc  a		; +1 as we start from the center (and inverts odd/even)
	and  $01	; %2 as speed dir changes every other hotspot (odd: $00, even: $01)
	add  a		; *2 as we skip speed (odd: $00, even: $02)
	; wScWilyArcIdx += A
	ld   hl, wScWilyArcIdx
	add  [hl]	; Only does anything in the even case
	ld   [hl], a
	;--
	
	ld   hl, wScWilyArcLeft
	dec  [hl]					; Reached the next hotspot?
	jr   nz, .sineLoop			; If not, loop
	
	ld   hl, wScWilyHotspotNum
	inc  [hl]					; Increment hotspot number
	jr   .nextHotspot			; Recalculate direction
	
WilyStation_Sc2:
	;
	; SCENE 2
	;
	; Wily flies into the Station.
	;
	call WilyStation_LoadVRAM
	call StartLCDOperation
	
	; Wait for 2 seconds
	ld   a, 60*2
	call WaitFrames
	
	;
	; Spawn Wily's spaceship.
	; The spaceship is handled like in the first scene, except there's no looping logic.
	; Every hotspot has its own code, leading to big copypaste.
	;
	DEF tActWily = wScAct0
	ld   hl, tActWily
	xor  a
	; The spaceship spawns from offscreen below
	; Y Position: $98
	ldi  [hl], a ; iScActYSub
	ld   a, OBJ_OFFSET_Y+$88
	ldi  [hl], a ; iScActY
	; X Position: $40
	xor  a
	ldi  [hl], a ; iScActXSub
	ld   a, OBJ_OFFSET_X+$38
	ldi  [hl], a ; iScActX
	; Vertical speed: 0.25px/frame up
	ld   bc, -$0040
	ld   [hl], c ; iScActSpdYSub = $C0
	inc  hl
	ld   [hl], b ; iScActSpdY = $FF
	inc  hl
	; Horizontal speed: Calculated later
	xor  a
	ldi  [hl], a ; iScActSpdXSub = $00
	ldi  [hl], a ; iScActSpdX = $00
	; Start from start of the arc
	ldi  [hl], a ; wScWilyArcIdx
	
	;##
	;
	; SCENE 2a - Move Wily left, slowing down
	;	
	
	; Start moving left
	ld   a, $FF
	ld   [tActWily+iScActSpdX], a
	ld   a, TURNTIMER
	ld   [wScWilyArcLeft], a
	
.loopL0:
	;--
	;
	; DRAW SPRITES
	;

	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; MOVE WILY
	;
	
	; Use horizontal speed from ActS_ArcPathTbl[wScWilyArcIdx]
	ld   hl, ActS_ArcPathTbl	; HL = ActS_ArcPathTbl
	ld   a, [wScWilyArcIdx]
	ld   b, $00					; BC = wScWilyArcIdx
	ld   c, a
	add  hl, bc					; Seek to HL[BC]
	ld   a, [hl]				; Read entry
	xor  $FF					; Reverse speed for moving left
	ld   [tActWily+iScActSpdXSub], a
	
	; Move the Wily actor
	ld   hl, tActWily
	call ScAct_ApplySpeed
	
	; Slow down over time
	ld   hl, wScWilyArcIdx		; wScWilyArcIdx++
	inc  [hl]
	inc  [hl]
	
	;
	; TICK TIMERS
	;
	
	ld   hl, wScWilyArcLeft
	dec  [hl]					; Reached the next hotspot?
	jr   nz, .loopL0			; If not, loop
	
	;##
	;
	; SCENE 2b - Move Wily right, at double speed, speeding up
	;
	
	ld   a, TURNTIMER
	ld   [wScWilyArcLeft], a
.loopR0:
	;--
	;
	; DRAW SPRITES
	;

	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; MOVE WILY
	;
	
	; Speed up over time
	ld   hl, wScWilyArcIdx	; wScWilyArcIdx -= 2
	dec  [hl]
	dec  [hl]
	
	; Use horizontal speed
	; iScActSpdX* = ActS_ArcPathTbl[wScWilyArcIdx] * 2
	ld   a, [hl]
	ld   hl, ActS_ArcPathTbl	; HL = ActS_ArcPathTbl
	ld   b, $00					; BC = wScWilyArcIdx
	ld   c, a
	add  hl, bc					; Index it
	; The *2 means we can go faster than 1px/frame, so also set iScActSpdX
	ld   l, [hl]				; Read byte to HL
	ld   h, $00
	add  hl, hl					; *2, for double speed
	ld   a, l
	ld   [tActWily+iScActSpdXSub], a
	ld   a, h
	ld   [tActWily+iScActSpdX], a
	
	; Move the Wily actor
	ld   hl, tActWily
	call ScAct_ApplySpeed
	
	;
	; TICK TIMERS
	;
	
	ld   hl, wScWilyArcLeft
	dec  [hl]					; Reached the next hotspot?
	jr   nz, .loopR0			; If not, loop
	
	;##
	;
	; SCENE 2c - Move Wily right, at double speed, slowing down
	;
	ld   a, TURNTIMER
	ld   [wScWilyArcLeft], a
.loopR1:
	;--
	;
	; DRAW SPRITES
	;

	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; MOVE WILY
	;
	
	; Use horizontal speed
	; iScActSpdX* = ActS_ArcPathTbl[wScWilyArcIdx] * 2
	ld   hl, ActS_ArcPathTbl	; HL = ActS_ArcPathTbl
	ld   a, [wScWilyArcIdx]
	ld   b, $00					; BC = wScWilyArcIdx
	ld   c, a
	add  hl, bc					; Index it
	; The *2 means we can go faster than 1px/frame, so also set iScActSpdX
	ld   l, [hl]				; Read byte to HL
	ld   h, $00
	add  hl, hl					; *2, for double speed
	ld   a, l
	ld   [tActWily+iScActSpdXSub], a
	ld   a, h
	ld   [tActWily+iScActSpdX], a
	
	; Move the Wily actor
	ld   hl, tActWily
	call ScAct_ApplySpeed
	
	; Slow down over time
	ld   hl, wScWilyArcIdx		; wScWilyArcIdx++
	inc  [hl]
	inc  [hl]
	
	;
	; TICK TIMERS
	;
	
	ld   hl, wScWilyArcLeft
	dec  [hl]					; Reached the next hotspot?
	jr   nz, .loopR1			; If not, loop
	
	;##
	;
	; SCENE 2d - Move Wily left, speeding up
	;
	
	; Start moving left
	ld   a, $FF
	ld   [tActWily+iScActSpdX], a
	ld   a, TURNTIMER
	ld   [wScWilyArcLeft], a
.loopL1:
	; Speed up over time
	ld   hl, wScWilyArcIdx	; wScWilyArcIdx -= 2
	dec  [hl]
	dec  [hl]
	
	;--
	;
	; DRAW SPRITES
	;

	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; MOVE WILY
	;
	
	; Use horizontal speed from ActS_ArcPathTbl[wScWilyArcIdx]
	ld   hl, ActS_ArcPathTbl	; HL = ActS_ArcPathTbl
	ld   a, [wScWilyArcIdx]
	ld   b, $00					; BC = wScWilyArcIdx
	ld   c, a
	add  hl, bc					; Seek to HL[BC]
	ld   a, [hl]				; Read entry
	xor  $FF					; Reverse speed for moving left
	ld   [tActWily+iScActSpdXSub], a
	
	; Move the Wily actor
	ld   hl, tActWily
	call ScAct_ApplySpeed
	
	;
	; TICK TIMERS
	;
	
	ld   hl, wScWilyArcLeft
	dec  [hl]					; Reached the next hotspot?
	jr   nz, .loopL1			; If not, loop
	
	;##
	;
	; SCENE 2e - Wily entered through the skull's eye.
	;            Display the spaceship without drawing Wily for 2 seconds.
	;
	
	; Delete Wily sprite
	xor  a
	ldh  [hWorkOAMPos], a
	call OAM_ClearRest
	; Apply changes
	rst  $08 ; Wait Frame
	
	; Wait for 2 seconds
	ld   a, 60*2
	call WaitFrames
	
WilyStation_Sc3:
	;
	; SCENE 3
	;
	; Rockman enters the Wily Station from the main entrance.
	;
	
	ld   a, GFXSET_SPACE
	call GFXSet_Load
	ld   de, TilemapDef_WilyStationEntrance
	call LoadTilemapDef
	; Put the entrance offscreen to the right
	ld   a, $F0
	ldh  [hScrollX], a
	call StartLCDOperation
	;--
	
	;
	; SCENE 3a - Move Rockman right until the screen is about to scroll
	;
	
	; Set spawn coordinates for the player.
	; As this is the only sprite in this scene, its coordinates are directly written to wTargetRel*
	ld   a, OBJ_OFFSET_Y+$70	; Y position: $80 (around the bottom)
	ld   [wTargetRelY], a
	ld   a, OBJ_OFFSET_X-$08	; X position: $00 (offscreen left)
	ld   [wTargetRelX], a
.loopA:
	;--
	;
	; DRAW SPRITES
	;	
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a

	
	; Draw Rush Marine with Rockman inside.
	ld   hl, SprMapPtrTbl_ScPl
	xor  a
	call Sc_DrawSprMap
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; MOVE PLAYER
	;	
	
	; Move player 1px/frame right
	ld   a, [wTargetRelX]	; PlX++
	inc  a
	ld   [wTargetRelX], a
	cp   $40				; Reached X position $40?
	jr   nz, .loopA			; If not, loop
	
	;##
	;
	; SCENE 3b - Scroll the entrance to the Wily Station into view
	;
	
	; Sync over the current player location
	ld   hl, wScSt3PlY
	ld   a, [wTargetRelY]		; wScSt3PlY = wTargetRelY
	ldi  [hl], a
	ld   a, [wTargetRelX]		; wScSt3PlX = wTargetRelX
	ldi  [hl], a
	; Set initial jaw location (offscreen, right)
	ld   a, OBJ_OFFSET_Y+$78	; wScSt3SkullJawY
	ldi  [hl], a
	ld   a, OBJ_OFFSET_X+$C8	; wScSt3SkullJawX
	ld   [hl], a
.loopB:
	;--
	;
	; DRAW SPRITES
	;	
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a

	; Draw Rush Marine with Rockman inside
	ld   a, [wScSt3PlY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3PlX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScPl
	xor  a
	call Sc_DrawSprMap
	
	; Draw Wily Station entrance
	ld   a, [wScSt3SkullJawY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3SkullJawX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScSkullJaw
	xor  a
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; LOGIC
	;
	
	; Scroll screen 1px/frame to the right.
	; This scrolls in the entrance to the Wily Station from the right.
	ld   hl, wScSt3SkullJawX	; Move door sprite left to account for scrolling
	dec  [hl]
	ld   hl, hScrollX			; Move viewport right
	inc  [hl]
	; (Don't move the player)
	
	ldh  a, [hScrollX]
	cp   $21					; Reached the target scroll position?
	jr   nz, .loopB				; If not, loop
	
	;
	; SCENE 3c - Move the player right, while opening the entrance
	;
.loopC:
	;--
	;
	; DRAW SPRITES
	;	
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a

	; Draw Rush Marine with Rockman inside
	ld   a, [wScSt3PlY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3PlX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScPl
	xor  a
	call Sc_DrawSprMap
	
	; Draw Wily Station entrance
	ld   a, [wScSt3SkullJawY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3SkullJawX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScSkullJaw
	xor  a
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; LOGIC
	;
	
	; Move down the entrance jaw 1px/frame until it fully opens.
	ld   a, [wScSt3SkullJawY]	; Get Y pos
	cp   OBJ_OFFSET_Y+$90		; C Flag = Y Position < $A0
	adc  $00					; Move 1px down if it was
	ld   [wScSt3SkullJawY], a	; Save back
	
	; Move player right 1px/frame until it fully goes offscreen
	ld   a, [wScSt3PlX]			; PlX++
	inc  a
	ld   [wScSt3PlX], a
	cp   OBJ_OFFSET_X+$B8		; Reached offscreen?
	jr   nz, .loopC				; If not, loop
	
	;
	; SCENE 3d - Close the entrance
	;
.loopD:
	;--
	;
	; DRAW SPRITES
	;	
	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a

	; Draw Rush Marine with Rockman inside
	; Not necessary as it's fully offscreen
	ld   a, [wScSt3PlY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3PlX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScPl
	xor  a
	call Sc_DrawSprMap
	
	; Draw Wily Station entrance
	ld   a, [wScSt3SkullJawY]
	ld   [wTargetRelY], a
	ld   a, [wScSt3SkullJawX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScSkullJaw
	xor  a
	call Sc_DrawSprMap
	
	call OAM_ClearRest		; Done drawing
	rst  $08 ; Wait Frame
	;--
	
	;
	; LOGIC
	;
	
	; Move back up the entrance jaw 1px/frame to its original position
	ld   a, [wScSt3SkullJawY]	; JawY--
	dec  a
	ld   [wScSt3SkullJawY], a
	cp   OBJ_OFFSET_Y+$78		; Moved up to Y position $88?
	jr   nz, .loopD				; If not, loop
	
	;
	; SCENE 3e - Wait 3 seconds before ending the cutscene
	;
	ld   a, 60*3
	call WaitFrames
	ret
	
; =============== WilyStation_Unused_DrawWily ===============
; [TCRF] Unreferenced subroutine to draw Wily's Spaceship, identically to how it happens in the 1st and 2nd scenes.
;        Would have been useful to cut down on code duplication in there.
WilyStation_Unused_DrawWily: 
	;--
	;
	; DRAW SPRITES
	;

	xor  a					; Start drawing sprites
	ldh  [hWorkOAMPos], a
	
	; Draw the small Wily Spaceship.
	ld   a, [tActWily+iScActY]
	ld   [wTargetRelY], a
	ld   a, [tActWily+iScActX]
	ld   [wTargetRelX], a
	ld   hl, SprMapPtrTbl_ScWilyShipSm
	ld   a, $02
	call Sc_DrawSprMap
	
	jp   OAM_ClearRest		; Done drawing

