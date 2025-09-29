; =============== Pl_Do ===============
; Main player code.
; Handles common actions to perform during gameplay, ending with handling the player's state.
Pl_Do:
	; Reset these for later
	xor  a
	ld   [wActScrollX], a
	ld   [wPlColiBlockL], a
	ld   [wPlColiBlockR], a
	; Fall-through
	
; =============== Pl_Do_Shutter ===============
; Handles the boss shutter effect.
; This goes along with the shutter event executed during VBlank.
Pl_Do_Shutter:
	ld   a, [wShutterMode]
	or   a									; In the middle of a shutter effect?
	jp   z, Pl_Do_ChkSpawnWaterBubble		; If not, jump
	dec  a									; Res = wShutterMode - 1
	rst  $00 ; DynJump
	dw Shutter_InitOpen
	dw Shutter_Open
	dw Shutter_MovePlR
	dw Shutter_Close
	dw Shutter_ScrollR
	
; =============== Shutter_InitOpen ===============
; Sets up the shutter opening animation.
; Mode $00
Shutter_InitOpen:

	;
	; Scan the *current* "room" for any actor art sets to load.
	; Used to request loading the boss graphics when going through
	; the second shutter, which will happen over time.
	;
	
	; As this is pointless to do when entering the boss corridor (1st shutter), it's skipped there.
	ld   a, [wBossMode]
	or   a							; First one we're going through? (wBossMode == BSMODE_NONE)
	call nz, ActS_ReqLoadRoomGFX	; If not, load the new room gfx
	
	;--
	;
	; Determine the tilemap origin point of the door animation and set it to wShutterBGPtr.
	; This will be 2 tiles to the left of the bottom-leftmost tile of the shutter, as from
	; this location a 16x8 strip tiles will be copied to the right to open the shutter.
	;
	; In practice, it uses the player's coordinates to determine the tilemap pointer
	; to the bottom-left tile of the block the player's origin is overlapping with.
	; As the player is forced to walk through shutters (no jumping) and the player's origin point
	; doesn't sink through the ground, no adjustments are needed to the player position.
	;
		
	;--
	;
	; POSITION OF BLOCKS
	;
	; Calculate to DE the tilemap grid offsets from the current player position.
	; Effectively the scroll position with the player's position, divided by the block's width/height.
	;
	
	; Y GRID OFFSET
	; D = (hScrollY + wPlRelY - OBJ_OFFSET_Y) / $10
	ld   a, [wPlRelY]
	sub  OBJ_OFFSET_Y		; Account for HW offset
	ld   b, a				; to B
	ldh  a, [hScrollY]		; Get Y scroll
	add  b					; Add player pos
	swap a					; / $10
	and  $0F				; ""
	ld   d, a
	
	; X GRID OFFSET
	; E = (hScrollX + wPlRelX - OBJ_OFFSET_X) / $10
	ld   a, [wPlRelX]
	sub  OBJ_OFFSET_X		; Account for HW offset
	ld   b, a				; to B
	ldh  a, [hScrollX]		; Get X scroll
	add  b					; Add player pos
	swap a					; / $10
	and  $0F				; ""
	ld   e, a
	;--
	
	;
	; TILEMAP STRIP POINTER
	;
	; Find the tilemap strip associated to the Y grid offset.
	; This will give the pointer to the first tile of the block row.
	;
	ld   hl, ScrEv_BGStripTbl	; HL = ScrEv_BGStripTbl
	ld   a, d					; BC = D * 2
	sla  a
	ld   b, $00
	ld   c, a
	add  hl, bc					; Index it
	
	;
	; FINALIZED TILEMAP PTR
	;
	; Add the X grid offset over, then seek 1 tile down to get the bottom-left tile of the block.
	;
	
	; C = byte0 + BG_TILECOUNT_H
	ldi  a, [hl]			; Read low byte (top-left)
	add  BG_TILECOUNT_H		; Move 1 tile down (bottom-left)
	ld   c, a
	;--
	; Set the high byte, as-is (it won't be affected by anything).
	; This could have been done after setting wShutterBGPtr_Low, for better org.
	ld   a, [hl]				; wShutterBGPtr_High = byte1	
	ld   [wShutterBGPtr_High], a
	;--
	; wShutterBGPtr_Low = (E * 2) + C
	ld   a, e					; Get grid offset	
	sla  a						; *2 as blocks are 2 tiles in width
	add  c						; Add the base row offset
	ld   [wShutterBGPtr_Low], a	; Save back
	
	;
	; Set the remaining settings and advance to the next mode.
	;
	DEF STEP_TIMER = $06 ; Frames between shutter anims
	DEF ROWS_LEFT  = $06 ; Number of 16x8 strips to animate (shutters are 3 blocks tall, 3*2 = 6)
	ld   a, STEP_TIMER			; 6 frame delay between steps
	ld   [wShutterTimer], a
	ld   a, ROWS_LEFT			; 6 step animation
	ld   [wShutterRowsLeft], a
	ld   hl, wShutterMode		; Next mode
	inc  [hl]
	jp   Pl_DoCtrl_NoMove		; Disable controls
	
; =============== Shutter_Open ===============
; Shutter opens up.
; Mode $01
Shutter_Open:
	; Wait if the delay is active.
	; During this delay, the boss graphics may load, if set.
	ld   a, [wShutterTimer]
	or   a					; Timer == 0?
	jr   z, .chkDraw		; If so, jump
	dec  a					; Otherwise, Timer--
	ld   [wShutterTimer], a
	
	jp   Pl_DoCtrl_NoMove	; and wait
	
.chkDraw:
	; If the shutter is fully opened, switch to the next mode
	ld   a, [wShutterRowsLeft]
	or   a					; RowsLeft == 0?
	jr   z, .nextMode		; If so, jump
.draw:
	dec  a					; RowsLeft--
	ld   [wShutterRowsLeft], a
	
	; Trigger the shutter effect, which is at VBlankHandler.shutOpen
	ld   a, STEP_TIMER		; Delay next anim by 6 frames
	ld   [wShutterTimer], a
	ld   a, SHUTTER_OPEN	; Open up by 1 strip
	ld   [wShutterEvMode], a
	ld   a, SFX_SHUTTER		; Play shutter SFX
	mPlaySFX
	
	jp   Pl_DoCtrl_NoMove

.nextMode:
	ld   a, $28				; Walk forward for $28 frames
	ld   [wShutterTimer], a
	ld   hl, wShutterMode	; Next mode
	inc  [hl]
	jp   Pl_DoCtrl_NoMove
	
; =============== Shutter_MovePlR ===============
; Player moves right, through the door.
; When it ends, it sets up the shutter closing animation.
; Mode $02
Shutter_MovePlR:

	; For the first $28 frames, scroll the screen right while animating the walk cycle.
	; The player will stay at the same relative X position, giving the illusion of walking forward.
	ld   hl, wShutterTimer
	dec  [hl]				; Timer has elapsed? 
	jr   z, .nextMode		; If so, jump
	
	call Game_AutoScrollR
	jp   Pl_AnimWalk
	
.nextMode:
	;--
	;
	; Seek the previously set tilemap pointer two tiles to the right to move over the closed shutter.
	; The caveats about looping mentioned in VBlankHandler.shutOpen also apply here, as this is 
	; basically the same code.
	;
	; This is done here to simplify the code executed in VBlankHandler.shutClose, so that it only
	; needs to move down rather than deal with any looping.
	;
	
	; Save the base row pointer elsewhere (no h offset)
	ld   a, [wShutterBGPtr_Low]
	and  $100-BG_TILECOUNT_H ; $E0
	ld   b, a
	; Seek 2 tiles right, looping the offset if needed
	ld   a, [wShutterBGPtr_Low]
	add  $02
	and  BG_TILECOUNT_H-1 ; $1F
	; Merge with base row pointer & save
	or   b
	ld   [wShutterBGPtr_Low], a
	;--
	
	ld   a, STEP_TIMER			; 6 frame delay between steps
	ld   [wShutterTimer], a
	ld   a, ROWS_LEFT			; 6 step animation
	ld   [wShutterRowsLeft], a
	ld   hl, wShutterMode		; Next mode
	inc  [hl]
	ld   a, PLSPR_IDLE			; Set standing frame
	ld   [wPlSprMapId], a
	jp   Pl_DoCtrl_NoMove
	
; =============== Shutter_Close ===============
; Shutter closes down.
; Mode $03
Shutter_Close:
	; Wait until the timer elapses on every step.
	ld   a, [wShutterTimer]
	or   a
	jr   z, .chkDraw
.stepWait:
	dec  a
	ld   [wShutterTimer], a
	jp   Pl_DoCtrl_NoMove
	
.chkDraw:

	; If the shutter is fully closed, switch to the next mode
	ld   a, [wShutterRowsLeft]
	or   a
	jr   z, .nextMode
.reqDraw:
	dec  a
	ld   [wShutterRowsLeft], a
	
	; Otherwise, trigger the shutter effect, which is at VBlankHandler.shutClose
	ld   a, STEP_TIMER		; Delay next anim by 6 frames
	ld   [wShutterTimer], a
	ld   a, SHUTTER_CLOSE	; Close down by 1 strip
	ld   [wShutterEvMode], a
	ld   a, SFX_SHUTTER		; Play shutter SFX
	mPlaySFX
	
	jp   Pl_DoCtrl_NoMove
	
.nextMode:
	;
	; Determine how much to scroll the screen right the next mode.
	; Because the scrolling isn't locked before entering a boss shutter,
	; it needs its own different value.
	;
	ld   b, $30				; B = Scroll amount the 1st time
	ld   a, [wBossMode]
	or   a					; 1st shutter we go through?
	jr   z, .setTimer		; If so, skip
	; [BUG] Off by one, this should have been $69.
	ld   b, $68				; B = Scroll amount the 2nd time
.setTimer:
	ld   a, b				; Set that to the timer
	ld   [wShutterTimer], a
	
	ld   hl, wShutterMode
	inc  [hl]				; Next mode
	jp   Pl_DoCtrl_NoMove

; =============== Shutter_ScrollR ===============
; Screen scrolls to the right.
; Mode $04
Shutter_ScrollR:
	; Make the screen scroll to the right
	call Game_AutoScrollR
	; Make the player move to the left, to compensate
	ld   hl, wPlRelX
	dec  [hl]					; since it's relative to the screen
	
	; Wait until the timer elapses before continuing
	ld   hl, wShutterTimer
	dec  [hl]					; Timer elapsed?
	jp   nz, Pl_DoCtrl_NoMove	; If not, jump
	
.end:
	; Otherwise, increment the boss (intro) mode routine.
	; Here, this is effectively used as a boolean flag to determine if it's the first time
	; the player goes through a door. It also affects the screen scrolling, as it is disabled if non-zero.
	;
	; The 2nd shutter we go through is important, as it advances the routine again, from BSMODE_CORRIDOR to BSMODE_INIT,
	; which lets boss actors start their intro sequence (every mode before BSMODE_INIT makes the boss do nothing).
	; 
	ld   hl, wBossMode			; wBossMode++
	inc  [hl]
	xor  a						; End shutter effect
	ld   [wShutterMode], a
	jp   Pl_DoCtrl_NoMove		; Don't move for one last time
	
; =============== Game_AutoScrollR ===============
; Scrolls the screen right by one pixel.
; Used during autoscrolling (ie: shutters, final boss) for movement
; independent from the player's position. 
Game_AutoScrollR:
	; Move all actors left
	ld   hl, wActScrollX
	dec  [hl]
	
; =============== Game_AutoScrollR_NoAct ===============
; Version of the above used by the final boss between phases, 
; to avoid interfering with its movement.
Game_AutoScrollR_NoAct:
	; Scroll the screen 1px right
	ldh  a, [hScrollX]
	inc  a
	ldh  [hScrollX], a
	; Update low nybble copy
	and  $0F
	ldh  [hScrollXNybLow], a
	
	; If we crossed a block boundary, increment the base column count 
	; and redraw the right screen's edge
	ret  nz		
	ld   hl, wLvlColL
	inc  [hl]
	
	jp   LvlScroll_DrawEdgeR
	
; =============== Pl_Do_ChkSpawnWaterBubble ===============
; Spawns a water bubble every ~1 sec when the player is underwater, around their location.
Pl_Do_ChkSpawnWaterBubble:

	; Every ~1 second... (1 sec + 4 frames)
	ldh  a, [hTimer]
	and  $3F			; hTimer % $40 != 0?
	jr   nz, .end		; If so, jump
	
	; If this level supports water...
	ld   a, [wLvlWater]
	or   a				; wLvlWater == 0?
	jr   z, .end		; If so, jump
	
	; Skip doing it if the player is in the middle of a screen transition.
	; These modes are in range $09-$0E
	ld   a, [wPlMode]
	cp   PL_MODE_CLIMBDTRSINIT	; wPlMode < $09?
	jr   c, .setTarget			; If so, jump (ok)
	cp   PL_MODE_FALLTRS+1		; wPlMode < $0F?
	jr   c, .end				; If so, jump (skipped)
.setTarget:

	; If the top of the player is touching a water block, spawn a water bubble.
	
	; X Sensor: Player's X origin (middle)
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	
	; Y Sensor: Player's Y origin - collision box height (top border)
	ld   a, [wPlRelY]		; Get Y origin
	sub  PLCOLI_V			; Subtract (vertical collision box radius) to get to the player's mouth
	ld   [wTargetRelY], a
	
	; Perform the block check.
	; Only two blocks are hardcoded to be water -- an empty one and an underwater spike (necessary for pits to work).
	call Lvl_GetBlockId		; A = Block ID at the target location
	cp   BLOCKID_WATER		; BlockId == $10?
	jr   z, .spawn			; If so, spawn it
	cp   BLOCKID_WATERSPIKE	; BlockId == $18?
	jr   nz, .end			; If not, don't spawn it
	
.spawn:
	ld   a, ACT_BUBBLE		; Actor ID
	ld   [wActSpawnId], a
	xor  a					; Not part of the actor layout
	ld   [wActSpawnLayoutPtr], a
	ld   a, [wTargetRelX]	; Spawn from where we checked for collision
	ld   [wActSpawnX], a
	ld   a, [wTargetRelY]
	ld   [wActSpawnY], a
	call ActS_Spawn			; and there
.end:
	; Fall-through
	
; =============== Pl_Do_DecHurtTimers ===============
; Ticks the hurt & invulerability timers.
Pl_Do_DecHurtTimers:
	; Tick hurt timer (1/2)
	; Mercy invincibility only starts after getting out of the hurt state,
	; so only tick its timer if the hurt one has elapsed.
	ld   a, [wPlHurtTimer]
	or   a
	jr   z, .tickInvuln
	dec  a
	ld   [wPlHurtTimer], a
	jr   Pl_DoCtrl
.tickInvuln:
	; Tick invulerability timer (2/2)
	ld   a, [wPlInvulnTimer]
	or   a
	jr   z, Pl_DoCtrl
	dec  a
	ld   [wPlInvulnTimer], a
	jr   Pl_DoCtrl
	
; =============== Pl_DoCtrl_NoMove ===============
; Variation of Pl_DoCtrl used when the shutter effect is active,
; to disable the player's controls when they aren't being overridden.
Pl_DoCtrl_NoMove:
	xor  a
	ldh  [hJoyKeys], a
	ldh  [hJoyNewKeys], a
	; Fall-through
	
; =============== Pl_DoCtrl ===============
; Handles the player state.
; Note that various actions don't have their own state, like walking or shooting.
Pl_DoCtrl:
	ld   a, [wPlMode]
	rst  $00 ; DynJump
	dw PlMode_Ground         ; PL_MODE_GROUND
	dw PlMode_Jump           ; PL_MODE_JUMP
	dw PlMode_FullJump       ; PL_MODE_FULLJUMP
	dw PlMode_Fall           ; PL_MODE_FALL
	dw PlMode_Climb          ; PL_MODE_CLIMB
	dw PlMode_ClimbInInit    ; PL_MODE_CLIMBININIT
	dw PlMode_ClimbIn        ; PL_MODE_CLIMBIN
	dw PlMode_ClimbOutInit   ; PL_MODE_CLIMBOUTINIT
	dw PlMode_ClimbOut       ; PL_MODE_CLIMBOUT
	dw PlMode_ClimbDTrsInit  ; PL_MODE_CLIMBDTRSINIT
	dw PlMode_ClimbDTrs      ; PL_MODE_CLIMBDTRS
	dw PlMode_ClimbUTrsInit  ; PL_MODE_CLIMBUTRSINIT
	dw PlMode_ClimbUTrs      ; PL_MODE_CLIMBUTRS
	dw PlMode_FallTrsInit    ; PL_MODE_FALLTRSINIT
	dw PlMode_FallTrs        ; PL_MODE_FALLTRS
	dw PlMode_Frozen         ; PL_MODE_FROZEN
	dw PlMode_Slide          ; PL_MODE_SLIDE
	dw PlMode_RushMarine     ; PL_MODE_RM
	dw PlMode_WarpInInit     ; PL_MODE_WARPININIT
	dw PlMode_WarpInMove     ; PL_MODE_WARPINMOVE
	dw PlMode_WarpInLand     ; PL_MODE_WARPINLAND
	dw PlMode_WarpOutInit    ; PL_MODE_WARPOUTINIT
	dw PlMode_WarpOutAnim    ; PL_MODE_WARPOUTANIM
	dw PlMode_WarpOutMove    ; PL_MODE_WARPOUTMOVE
	dw PlMode_WarpOutEnd     ; PL_MODE_WARPOUTEND
	dw PlMode_TeleporterInit ; PL_MODE_TLPINIT
	dw PlMode_Teleporter     ; PL_MODE_TLPANIM
	dw PlMode_TeleporterEnd  ; PL_MODE_TLPEND
	
; =============== PlMode_Ground ===============
; Player is on the ground, including when walking.
PlMode_Ground:

	;
	; SAKUGARNE "IDLE" STATE
	;
	
	; Not applicable if not riding one
	ld   a, [wWpnSGRide]
	or   a
	jr   z, .noSg
	
.sg:
	;
	; A -> Jump
	;
	; The pogo stick has a "delayed" jump mechanic caused by how, like actual pogo sticks,
	; you constantly jump even when idle, by a little bit.
	;
	; Since it's not possible to jump while in the air, it leaves a small window to perform
	; the high jump -- thankfully, unlike normal jumps, the A button can be held to 
	; automatically perform an high jump as soon as possible.
	ldh  a, [hJoyKeys]
	bit  KEYB_A, a			; Holding A?
	jr   nz, .sgJump		; If so, jump
.sgIdle:
	ld   bc, $0200			; Otherwise, use small 2px/frame jump
	ld   a, PLSPR_SG_IDLE	; Set idle frame
	jr   .sgSet
.sgJump:
	ld   bc, $0400			; Use high 4px/frame jump 
	ld   a, PLSPR_SG_JUMP	; Set jump frame
.sgSet:
	ld   [wPlSprMapId], a	; Save the new frame
	ld   a, c				; Save the jump speed
	ld   [wPlSpdYSub], a
	ld   a, b
	ld   [wPlSpdY], a
	ld   a, PL_MODE_FULLJUMP	; New mode
	ld   [wPlMode], a
	jp   Pl_DrawSprMap		; Draw the Sakugarne
	
.noSg:
	;
	; In the hurt pose, make the player move backwards and prevent him from shooting.
	;
	ld   a, [wPlHurtTimer]
	or   a					; Is the player hurt?
	jr   z, .notHurt		; If not, jump
.hurt:
	;--
	; If inside a top-solid block while hurt, try to fall down.
	; Normally this isn't necessary, as top-solid platforms while standing on the ground
	; should *always* count as solid... however getting hit sets the player state to grounded, even in the air.
	; Just in case we got hit in the air while jumping near the top of a ladder, fall down.
	call Pl_IsInTopSolidBlock	; Inside a top-solid block?
	jp   z, .startFall			; If so, jump
	;--
	; No WpnCtrl_Do call, preventing shots from being fired
	call Pl_DoConveyor
	call Pl_DoHurtSpeed ; Replaces Pl_DoMoveSpeed
	call Pl_MoveBySpeedX_Coli
	jp   .chkGround ; Skip very fat ahead
.notHurt:
	call WpnCtrl_Do ; BANK $01
	call Pl_DoConveyor
	call Pl_DoMoveSpeed
	call Pl_MoveBySpeedX_Coli
	
.chkSpike:
	;
	; Kill the player if it overlaps with a spike block.
	;
	; Note that, outside of the special case in vertical transitions that instakills the player
	; even with mercy invincibility on, this is the only place that checks for spikes.
	; This means that spikes only work properly on the ground -- if the player is in the air,
	; sliding, climbing, etc... they can safely pass through.
	;
	
	; Ignore spikes if the player has mercy invincibility
	ld   a, [wPlInvulnTimer]
	or   a
	jr   nz, .chkShutter
	
	; For the collision check, get the block 8 pixels above the player's origin.
	;
	; A consequence of only the center point being checked rather than the two
	; corners is that spikes with exposed sides won't quite work properly.
	; With one exception, no spike blocks have an empty block horizontally adjacent.
	
	; Y Sensor: Player's Y origin - 8 (low half)
	ld   a, [wPlRelY]
	sub  $08
	ld   [wTargetRelY], a
	; X Sensor: Player's X origin (middle)
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; Get block at that location
	
	; Spike blocks are in range $18-$1F.
	cp   BLOCKID_SPIKE_START	; A < $18?
	jr   c, .chkShutter			; If so, skip
	cp   BLOCKID_SPIKE_END		; A < $20?
	jp   c, PlColi_Spike		; If so, jump (die)
	
.chkShutter:
	;
	; RIGHT -> Activate the shutter if we touched a door block while walking.
	;
	
	; Only perform the check if we moved to the right this frame.
	; Pl_MoveR_Coli will have saved the block ID detected on the right to wPlColiBlockR.
	ld   a, [wPlColiBlockR]
	cp   BLOCKID_SHUTTER		; Are we walking towards a shutter block?
	jr   nz, .chkLadderU			; If not, skip
	
	; [POI] Attempt to teleport Rush/Sakugarne out.
	;       There is a problem with this, in that all actors are despawned when touching a door,
	;       and the way the game tries to wait for them just doesn't work.
	;       The only way to see this is to move towards the door for one frame only.
	call Wpn_StartHelperWarp	; Try to teleport Rush/Sakugarne out, *if they aren't teleporting out already*
	jr   c, .chkLadderU				; Did we teleport anything out? If so, skip (don't activate the shutter yet)
	
	; Only activate the shutter if standing on solid ground, as the shutter animations
	; uses that assumption to determine where to draw the shutter tiles on screen.
	
	; X Sensor: Player's X origin (middle)
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	; Y Sensor: Player's Y origin + 1 (ground)
	ld   a, [wPlRelY]
	inc  a
	ld   [wTargetRelY], a
	
	call Lvl_GetBlockId		; C Flag = Is the block empty?
	jr   c, .chkLadderU	; If so, skip
	
	; Checks passed, start the effect
	call ActS_DespawnAll	; Despawn all actors to prevent them from interfering
	
	xor  a					; Not necessary
	ld   [wPlColiBlockR], a
	ld   a, SHMODE_START	; Start the shutter sequence
	ld   [wShutterMode], a
	ld   a, PLSPR_IDLE		; Force standing sprite
	ld   [wPlSprMapId], a
	jp   Pl_DrawSprMap
	
	
.chkLadderU:

	;
	; UP -> Grab onto a ladder
	;
	; While no ladders are directly placed on the ground (which would still be supported),
	; it's possible to trigger this through Rush Jet or when walking off a platform directly into a ladder.
	;
	
	ldh  a, [hJoyKeys]
	bit  KEYB_UP, a			; Holding UP?
	jr   z, .chkLadderD		; If not, skip
	
	; The sensor for grabbing a ladder is always 15 pixels above the player's origin.
	; This is the same position used to detect if we're still on the ladder in PlMode_Climb.
	ld   a, [wPlRelY]
	; This check is not necessary, as the offscreen area above counts as unclimbable empty space,
	; which we aren't allowed to move into anyway (can't move above Y pos $18, which leaves enough space for the 15px sensor).
	; However, that's also the reason why ladders have poor collision detection near the top of the screen
	cp   OBJ_OFFSET_Y+$18	; Are we 24px within the top of the screen?
	jr   c, .chkLadderD		; If so, skip
	
	; Y Sensor: Player's Y origin - 15 pixels
	; This barely missed ladders 1 block above the ground.
	sub  BLOCK_V-1
	ld   [wTargetRelY], a
	; X Sensor: Player's X origin (middle)
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_LADDER		; Is there a ladder block?
	jr   nz, .chkLadderD	; If not, skip
							; Otherwise, we passed the checks
							
	call Pl_StopTpAttack	; Can't use Top Spin while climbing
	
	ld   a, PL_MODE_CLIMB	; Switch to climb
	ld   [wPlMode], a
	
	call Pl_AlignToLadder	; No misaligned grabs
	jp   Pl_DrawSprMap
	
.chkLadderD:
	;
	; DOWN -> Grab onto a ladder, if one is on the ground.
	;
	ldh  a, [hJoyKeys]
	bit  KEYB_DOWN, a			; Pressed DOWN?
	jr   z, .chkSlide				; If not, skip
	
	; X Sensor: Player's X origin (middle)
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	; Y Sensor: Player's Y origin + 1 pixel (ground)
	ld   a, [wPlRelY]
	inc  a
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	cp   BLOCKID_LADDERTOP		; Is there a ladder top block?
	jr   nz, .chkSlide			; If not, skip
								; Otherwise, we passed the checks
							
	ld   a, PL_MODE_CLIMBININIT	; Start climbing down from the top of a laddder
	ld   [wPlMode], a
	call Pl_AlignToLadder		; No misaligned grabs
	jp   Pl_DrawSprMap
	
.chkSlide:
	;
	; DOWN+A -> Slide
	;
	ldh  a, [hJoyNewKeys]
	bit  KEYB_A, a			; *Pressed* A?
	jr   z, .chkJump		; If not, skip
	ldh  a, [hJoyKeys]
	bit  KEYB_DOWN, a		; Holding DOWN?	
	jr   z, .chkJump		; If not, skip
	ld   a, [wActRjStandSlotPtr]
	cp   ACTSLOT_NONE		; Standing on Rush Jet? (!= ACTSLOT_NONE)
	jr   nz, .chkJump		; If so, skip
	
	; Prevent sliding if there's a solid block forward
	ld   a, [wPlDirH]
	or   a					; Facing right?
	jr   nz, .chkSlideR		; If so, jump
.chkSlideL:
	ld   a, [wPlRelX]		; X Sensor: 1 block to the left
	ld   [wPlSlideDustX], a	; # DustX = PlX
	sub  BLOCK_H
	ld   [wTargetRelX], a
	jr   .chkSlideSolid
.chkSlideR:
	ld   a, [wPlRelX]		; X Sensor: 1 block to the right
	ld   [wPlSlideDustX], a	; # DustX = PlX
	add  BLOCK_H
	ld   [wTargetRelX], a
.chkSlideSolid:
	; Y Sensor: *almost* 1 block above, but not quite.
	ld   a, [wPlRelY]		
	ld   [wPlSlideDustY], a	; # DustY = PlY
	sub  BLOCK_V-1			
	ld   [wTargetRelY], a
	
	call Lvl_GetBlockId		; Is there a solid block?
	jp   nc, .chkJump		; If so, skip
	
	ld   a, PL_MODE_SLIDE	; Start sliding
	ld   [wPlMode], a
	ld   a, $1E				; Slide for half a second
	ld   [wPlSlideTimer], a
	ld   a, $30				; Show dust for 48 frames
	ld   [wPlSlideDustTimer], a
	jp   Pl_DrawSprMap
	
.chkJump:

	;
	; A -> Jump
	;
	ldh  a, [hJoyNewKeys]
	bit  KEYB_A, a
	jr   z, .chkGround
	
	;
	; If there's a solid block above the player, don't jump.
	;
	
	; Top-left corner
	ld   a, [wPlRelY]		; Y Sensor: Top border
	sub  PLCOLI_V*2
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]		; X Sensor: Left border
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; C Flag = Is block empty?
	jr   nc, .chkGround		; If not, skip
	
	; Top-right corner
	ld   a, [wPlRelX]		; X Sensor: Right border
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; C Flag = Is block empty?
	jr   nc, .chkGround		; If not, skip
	
	ld   a, $80				; Set 3.5px/frame upwards speed
	ld   [wPlSpdYSub], a
	ld   a, $03
	ld   [wPlSpdY], a
	ld   a, PL_MODE_JUMP	; Start jump
	ld   [wPlMode], a
	jp   Pl_DrawSprMap
	
.chkGround:
	;
	; If there is no solid ground, start falling down.
	;
	call Pl_IsOnGround		; Make wColiGround
	ld   a, [wColiGround]	
	and  %11				; Keep only bits for the current frame
	cp   %11				; Are we fully on empty blocks?
	jr   nz, .chkWalk		; If not, skip
.startFall:
	ld   a, $00				; Start falling at 1px/frame
	ld   [wPlSpdYSub], a
	ld   a, $01
	ld   [wPlSpdY], a
	ld   a, PL_MODE_FALL
	ld   [wPlMode], a
	jp   Pl_DrawSprMap
	
.chkWalk:
	;
	; LEFT/RIGHT -> Animate the player's walk cycle
	;
	; We have moved the player before through Pl_MoveBySpeedX_Coli,
	; but that doesn't handle the walking animation.
	;
	
	; The player does not animate on Rush Jet
	ld   a, [wActRjStandSlotPtr]
	cp   ACTSLOT_NONE		; wActRjStandSlotPtr != ACTSLOT_NONE?
	jr   nz, .idleAnim		; If so, skip
	ldh  a, [hJoyKeys]
	and  KEY_LEFT|KEY_RIGHT	; Pressed left or right?
	jp   nz, Pl_AnimWalk	; If so, walk
	
.idleAnim:
	;
	; Finally, if no other actions are performed, handle the idle blinking animation.
	;
	; Rockman blinks for 12 frames, and then waits for a random amount of time before,
	; blinking again. This wait is 12 frames at the absolute minimum.
	;
	
	xor  a
	ld   [wPlWalkAnimTimer], a
	
	; If we're in the middle of the blink animation, handle that first.
	ld   a, [wPlBlinkTimer]
	or   a						; wPlBlinkTimer != 0?
	jr   nz, .decIdleTimer		; If so, skip
	
	; 3 in 256 chance of blinking.
	; If the check fails, it gets repeated the very next frame, and so on...
	call Rand					; A = Rand()
	cp   $03					; A >= $03?
	jr   nc, .setEyeOpen		; If so, skip
	
	; If the check passes, set the timer to $18 (+1, to account for the immediate dec).
	ld   a, ($0C*2)+1			; Delay = $19
	ld   [wPlBlinkTimer], a
.decIdleTimer:
	; The blinking sprite kicks in for the first 12 frames, until it ticks down to $0C.
	; The normal sprite is displayed afterwards, to ensure a minimum delay of 12 frames between blinks.
	dec  a						; Delay--
	ld   [wPlBlinkTimer], a
	cp   $0C					; Delay < $0C?
	jr   c, .setEyeOpen			; If so, don't blink
.setEyeClose:
	ld   a, PLSPR_BLINK
	ld   [wPlSprMapId], a
	jp   Pl_DrawSprMap
.setEyeOpen:
	ld   a, PLSPR_IDLE
	ld   [wPlSprMapId], a
	jp   Pl_DrawSprMap
	
; =============== PlMode_Jump ===============
; Player is doing a normal jump.
PlMode_Jump:
	call WpnCtrl_Do ; BANK $01
	; Handle horizontal movement
	call Pl_DoMoveSpeed
	call Pl_MoveBySpeedX_Coli
	
	ld   a, PLSPR_JUMP
	ld   [wPlSprMapId], a
	
	; If we stop holding A, cut the jump early.
	ldh  a, [hJoyKeys]
	bit  KEYB_A, a							; Holding A?
	jr   nz, PlMode_FullJump.chkLadderU		; If so, jump
	jp   PlMode_FullJump.startFall
	
; =============== PlMode_FullJump ===============
; Player is doing a full jump.
; Like PlMode_Jump, except it prevents the player from cutting the jump early.
; This makes it useful for things like the Sakugarne or the end of stage jumps.
PlMode_FullJump:
	call WpnCtrl_Do ; BANK $01
	; Handle horizontal movement
	call Pl_DoMoveSpeed
	call Pl_MoveBySpeedX_Coli
	
	; Don't let the player grab ladders while riding the Sakugarne 
	ld   a, [wWpnSGRide]
	or   a					; wWpnSGRide != 0?
	jr   nz, .tryMove		; If so, jump
	
	ld   a, PLSPR_JUMP
	ld   [wPlSprMapId], a
	
.chkLadderU:
	;
	; UP -> Grab onto a ladder
	;
	; Identical to the respective code in PlMode_Ground.
	;
	
	ldh  a, [hJoyKeys]
	bit  KEYB_UP, a			; Holding UP?
	jr   z, .tryMove		; If not, skip
	
	ld   a, [wPlRelY]
	cp   OBJ_OFFSET_Y+$18	; Are we 24px within the top of the screen?
	jr   c, .tryMove		; If so, skip
	
	; Y Sensor: Player's Y origin - 15 pixels
	sub  BLOCK_V-1
	ld   [wTargetRelY], a
	; X Sensor: Player's X origin (middle)
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_LADDER		; Is there a ladder block?
	jr   nz, .tryMove	; If not, skip
							; Otherwise, we passed the checks
							
	call Pl_StopTpAttack	; Can't use Top Spin while climbing
	
	ld   a, PL_MODE_CLIMB	; Switch to climb
	ld   [wPlMode], a
	
	call Pl_AlignToLadder	; No misaligned grabs
	jp   Pl_DrawSprMap

	
.tryMove:
	;
	; Move upwards until we hit a solid block or gravity reduces the vertical speed to 0.
	;
	
	; The ceiling check happens $18 pixels above the player's origin.
	; If the current position would make that check underflow, cut the jump early.
	; The player could easily walk on the ceiling or trigger the downwards screen transition otherwise.
	ld   a, [wPlRelY]
	cp   PLCOLI_V*2			; PlY < $18? 
	jp   c, .startFall			; If so, cut the jump
	
	; Get the updated position we're tentatively moving to, if the coming checks pass
	ld   a, [wPlSpdY]		; Get pixel speed
	ld   b, a
	ld   a, [wPlRelY]		; Get current Y
	sub  b					; Move up by the speed
	ld   [wPlNewRelY], a
	
	;
	; Cut the jump if there's a solid block above.
	; Three sensors are used for this check.
	;
	
	; Top
	sub  PLCOLI_V*2			; Y Sensor: wPlNewRelY - $18 (top border) 
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]		; X Sensor: wPlRelX (center)
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; Is there a solid block there?
	jr   nc, .alignToCeil	; If so, jump
	
	; For some reason, ceiling alignment only happens with the sensor above.
	; This causes the sides of a block adjacent to an empty one to have a lower ceiling.
	
	; Top-left
	ld   a, [wPlRelX]		; X Sensor: wPlRelX - $06 (left)
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; Is there a solid block there?
	jr   nc, .startFall		; If so, jump
	
	; Top-right
	ld   a, [wPlRelX]		; X Sensor: wPlRelX + $06 (right)
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, .startFall
	
	; Checks passed, confirm the new Y position
	ld   a, [wPlNewRelY]
	ld   [wPlRelY], a
	
	;
	; Apply gravity, by decrementing the player's speed.
	;
.grav:
	ld   a, [wLvlWater]
	or   a					; Water support enabled?
	jr   z, .gravNorm		; If not, skip
	ld   a, [wPlRelX]		; X Sensor: PlX (middle)
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]		; Y Sensor: PlY (bottom)
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	; If it's one of the two water blocks, apply lower gravity
	cp   BLOCKID_WATER
	jr   z, .gravLow
	cp   BLOCKID_WATERSPIKE
	jr   z, .gravLow
.gravNorm:
	; Apply normal gravity at 0.125px/frame
	ld   bc, $0020
	ld   a, [wPlSpdYSub]
	sub  c
	ld   [wPlSpdYSub], a
	ld   a, [wPlSpdY]
	sbc  b
	ld   [wPlSpdY], a
	; If our pixel speed ticked down to 0, start falling down.
	; Note this does not wait for the subpixels to become 0.
	or   a
	jr   z, .startFall
	jp   Pl_DrawSprMap
.gravLow:
	; Apply lower gravity at ~0.03px/frame
	ld   bc, $0008
	ld   a, [wPlSpdYSub]
	sub  c
	ld   [wPlSpdYSub], a
	ld   a, [wPlSpdY]
	sbc  b
	ld   [wPlSpdY], a
	; If our pixel speed ticked down to 0, start falling down.
	or   a
	jr   z, .startFall
	jp   Pl_DrawSprMap
	
.alignToCeil:
	; Align player to the vertical block boundary, pushing him up.
	ld   a, [wPlYCeilMask]	; B = Block alignment ($F0 for solid or $F8 for small platforms)
	ld   b, a
	ld   a, [wPlRelY]		; A = Y position
	sub  (PLCOLI_V*2)-1		; Move to top border
	and  b					; Align to the block boundary
	add  (PLCOLI_V*2)-1		; Move back to origin
	ld   [wPlRelY], a		; Save the changes
	
.startFall:
	; Start falling down from 1px/frame.
	; This initial speed gives less air time during the peak of the jump,
	; especially if the jump gets cut early.
	ld   a, $00
	ld   [wPlSpdYSub], a
	ld   a, $01
	ld   [wPlSpdY], a
	ld   a, PL_MODE_FALL
	ld   [wPlMode], a
	jp   Pl_DrawSprMap
	
; =============== PlMode_Fall ===============
; Player is in the air and moving down.
PlMode_Fall:
	;
	; In the hurt pose, make the player move backwards and prevent him from shooting,
	; similar to the respective codein PlMode_Ground.
	;
	ld   a, [wPlHurtTimer]
	or   a
	jr   z, .noHurt
.hurt:
	call Pl_DoHurtSpeed
	call Pl_MoveBySpeedX_Coli
	; [POI] This doesn't quite skip ahead far enough, allowing the player to "cancel" the hurt state by grabbing a ladder.
	;       (specifically, they don't handle it, but the hurt timer is still ticking down)
	jr   .setSpr
.noHurt:
	call WpnCtrl_Do ; BANK $01
	call Pl_DoMoveSpeed
	call Pl_MoveBySpeedX_Coli
.setSpr:
	; Do not let the player grab ladders while riding the Sakugarne
	ld   a, [wWpnSGRide]
	or   a
	jr   nz, .tryMove
	ld   a, PLSPR_JUMP		; Set jumping sprite in case we didn't go through PlMode_Jump
	ld   [wPlSprMapId], a
	
.chkLadderU:
	;
	; UP -> Grab onto a ladder
	;
	; Identical to the respective code in PlMode_Ground.
	;
	
	ldh  a, [hJoyKeys]
	bit  KEYB_UP, a			; Holding UP?
	jr   z, .tryMove		; If not, skip
	
	ld   a, [wPlRelY]
	cp   OBJ_OFFSET_Y+$18	; Are we 24px within the top of the screen?
	jr   c, .tryMove		; If so, skip
	
	; Y Sensor: Player's Y origin - 15 pixels
	sub  BLOCK_V-1
	ld   [wTargetRelY], a
	; X Sensor: Player's X origin (middle)
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_LADDER		; Is there a ladder block?
	jr   nz, .tryMove		; If not, skip
							; Otherwise, we passed the checks
							
	call Pl_StopTpAttack	; Can't use Top Spin while climbing
	
	ld   a, PL_MODE_CLIMB	; Switch to climb
	ld   [wPlMode], a
	
	call Pl_AlignToLadder	; No misaligned grabs
	jp   Pl_DrawSprMap
	
.tryMove:
	;
	; Move downwards until we hit a solid block or actor platform.
	;

	; If we landed on a top-solid actor platform, we're done
	ld   a, [wActPlatColiSlotPtr]
	cp   ACTSLOT_NONE				; wActPlatColiSlotPtr != ACTSLOT_NONE?
	jp   nz, .switchToGround		; If so, jump
	
	; Get the updated position we're tentatively moving to, if the coming checks pass
	ld   a, [wPlSpdY]		; Get pixel speed
	ld   b, a
	ld   a, [wPlRelY]		; Get current Y
	add  b					; Move down by the speed
	ld   [wPlNewRelY], a
	
	;
	; Stop falling if there's a solid block below.
	; Unlike the upwards movement code, only the two corner sensors are used for this check...
	;
	
	; If we're currently inside a top solid block, count it as an empty block.
	; This is to get ahead of the incoming solidity checks that count top-solid blocks as solid,
	; which would cause the player to be immediately aligned to the bottom of the block, but it 
	; doesn't quite work due to Pl_IsInTopSolidBlock requiring the player to be fully inside blocks.
	call Pl_IsInTopSolidBlock	; Currently inside such a block?
	jp   z, .chkPit				; If so, jump
	
	; Bottom-left
	ld   a, [wPlNewRelY]		; Y Sensor: wPlNewRelY (bottom)
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]			; X Sensor: wPlRelX - $06 (left)
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_TOPSOLID_START	; Is this block solid on top?
	jp   nc, .alignToFloor		; If so, jump
	
	; Bottom-right
	ld   a, [wPlRelX]			; X Sensor: wPlRelX + $06 (right)
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_TOPSOLID_START	; Is this block solid on top?
	jp   nc, .alignToFloor		; If so, jump
	
	
.chkPit:
	; Checks passed, confirm the new Y position
	ld   a, [wPlNewRelY]
	ld   [wPlRelY], a

	;
	; Moving to the bottom of the screen will either instakill the player or start a vertical transition,
	; depending on whether a spike block is present or not.
	;
	; Spike blocks on the bottom row of the level are the only way to define pits, as vertical transitions
	; can happen anywhere at any point -- it's up to the level designers to box the player in, typically
	; by using invisible spike blocks.
	;
	; There is a consequence to spikes and pits being one and the same -- the player dies immediately
	; upon touching them, even with mercy invincibility. This is an "inconsistency" with spikes that
	; are placed on a solid block, which respect it, but when they are placed at the bottom row
	; there can't be any solid block below.
	;

	; Must be offscreen, halfway through the "block" covered by the status bar
	cp   SCREEN_GAME_V+OBJ_OFFSET_Y+$08	; PlY < $98?
	jr   c, .grav						; If so, skip
	
	sub  BLOCK_H			; Y Sensor: 1 block above, to the last column
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]		; X Sensor: PlX
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	; Spike blocks are in range $18-$1F.
	cp   BLOCKID_SPIKE_START	; A < $18?
	jr   c, .startTrs			; If so, skip
	cp   BLOCKID_SPIKE_END		; A < $20?
	jp   c, PlColi_Spike		; If so, jump (die)
.startTrs:
	ld   a, PL_MODE_FALLTRSINIT	; Start downwards transition
	ld   [wPlMode], a
	jp   Pl_DrawSprMap
	
	;
	; Apply gravity, by incrementing the player's speed.
	; This uses the same gravity values as the respective code in PlMode_Jump.
	;
.grav:
	ld   a, [wLvlWater]
	or   a					; Water support enabled?
	jr   z, .gravNorm		; If not, skip
	ld   a, [wPlRelX]		; X Sensor: PlX (middle)
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]		; Y Sensor: PlY (bottom)
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	; If it's one of the two water blocks, apply lower gravity
	cp   BLOCKID_WATER
	jr   z, .gravLow
	cp   BLOCKID_WATERSPIKE
	jr   z, .gravLow
.gravNorm:
	; Apply normal gravity at 0.125px/frame
	ld   bc, $0020
	ld   a, [wPlSpdYSub]
	add  c
	ld   [wPlSpdYSub], a
	ld   a, [wPlSpdY]
	adc  b
	ld   [wPlSpdY], a
	; Cap speed to 4px/frame
	cp   $04				; Speed < 4?
	jp   c, Pl_DrawSprMap	; If so, skip
	xor  a					; Speed = 4
	ld   [wPlSpdYSub], a
	ld   a, $04
	ld   [wPlSpdY], a
	jp   Pl_DrawSprMap
.gravLow:
	; Apply lower gravity at ~0.03px/frame
	ld   bc, $0008
	ld   a, [wPlSpdYSub]
	add  c
	ld   [wPlSpdYSub], a
	ld   a, [wPlSpdY]
	adc  b
	ld   [wPlSpdY], a
	; Cap speed to 1px/frame
	cp   $01				; Speed < 1?
	jp   c, Pl_DrawSprMap	; If so, skip
	xor  a					; Speed = 1
	ld   [wPlSpdYSub], a
	ld   a, $01
	ld   [wPlSpdY], a
	jp   Pl_DrawSprMap
	
.alignToFloor:
	; We attempted to move into a solid block.
	; This means we're currently on an empty block that's right above a solid one,
	; so snap the player to the bottom of said empty block.
	ld   a, [wPlRelY]
	or   $0F
	ld   [wPlRelY], a
	
.switchToGround:
	call Pl_StopTpAttack		; Top Spin stops on the ground
	xor  a ; PL_MODE_GROUND		; Stand on ground
	ld   [wPlMode], a
	
	ld   a, [wWpnSGRide]		; Play landing sound if not riding the Sakugarne
	or   a
	jp   nz, Pl_DrawSprMap
	ld   a, SFX_LAND
	mPlaySFX
	jp   Pl_DrawSprMap
	
; =============== PlMode_Climb ===============
; Player is climbing a ladder (both idle and actual climbing).
PlMode_Climb:
	call WpnCtrl_Do ; BANK $01
	
	; Always use the same frame while climbing
	ld   a, PLSPR_CLIMB
	ld   [wPlSprMapId], a
	
.chkFall:
	;
	; If the player is no longer inside a ladder block, fall off the ladder.
	; Moving down a ladder doesn't check for empty block collision directly,
	; it is done here all the time instead.
	;
	ld   a, [wPlRelX]		; X Sensor: PlX (center)
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]		; Y Sensor: PlY - $0F (middle-top)
	sub  BLOCK_H-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		
	cp   BLOCKID_LADDER		; On a ladder or ladder top tile? (or all solids...)
	jr   nc, .chkFallMan	; If so, jump
	ld   a, PL_MODE_FALL	; Otherwise, we're on an empty block
	ld   [wPlMode], a		; so fall off the ladder (without setting a speed)
	jp   Pl_AnimClimb
	
.chkFallMan:
	;
	; A -> Fall off the ladder manually
	;
	ldh  a, [hJoyNewKeys]
	bit  KEYB_A, a
	jp   z, .chkTurn
	
	ld   a, $00				; 1px/frame fall
	ld   [wPlSpdYSub], a
	ld   a, $01
	ld   [wPlSpdY], a
	ld   a, PL_MODE_FALL
	ld   [wPlMode], a
	jp   Pl_DrawSprMap
	
.chkTurn:
	;
	; LEFT/RIGHT -> Change direction
	;
	
	; No change allowed while shooting
	ld   a, [wPlShootTimer]
	or   a
	jp   nz, Pl_DrawSprMap
	
	ldh  a, [hJoyKeys]
	bit  KEYB_LEFT, a	; Holding LEFT?
	jr   z, .chkTurnR	; If not, skip
	xor  a ; DIR_L
	ld   [wPlDirH], a
	jp   Pl_DrawSprMap
.chkTurnR:
	bit  KEYB_RIGHT, a	; Holding RIGHT?
	jr   z, .chkU		; If not, skip
	ld   a, DIR_R
	ld   [wPlDirH], a
	jp   Pl_DrawSprMap
	
.chkU:
	;
	; UP -> Climb up the ladder
	;
	ldh  a, [hJoyKeys]
	bit  KEYB_UP, a		; Holding UP?
	jr   z, .chkD		; If not, skip
	
	; If there's no ladder block above, start climbing it out.
	; That $18px is the same amount you automatically move to during the climb in animation.
	ld   a, [wPlRelY]				; Y Sensor: PlY - $18 (top)
	sub  PL_LADDER_BORDER_V
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]				; X Sensor: PlX (center)
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_LADDER				; On a ladder or ladder top tile? (or all solids...)
	jr   nc, .chkTrsU				; If so, continue climbing up
	ld   a, PL_MODE_CLIMBOUTINIT	; Otherwise, the ladder ended on the top
	ld   [wPlMode], a				; so start climbing to the top
	jp   Pl_AnimClimb
	
.chkTrsU:
	; If climbing up near the top of the screen, start a vertical transition
	ld   a, [wPlRelY]
	cp   OBJ_OFFSET_Y+$19	; PlY >= $29?
	jr   nc, .moveU			; If so, skip
	ld   a, PL_MODE_CLIMBUTRSINIT
	ld   [wPlMode], a
	jp   Pl_AnimClimb
.moveU:
	; Otherwise, move up as normal, at 0.75px/frame
	ld   a, [wPlRelYSub]
	sub  $C0
	ld   [wPlRelYSub], a
	ld   a, [wPlRelY]
	sbc  $00
	ld   [wPlRelY], a
	jp   Pl_AnimClimb
	
.chkD:
	;
	; DOWN -> Climb down the ladder
	;
	ldh  a, [hJoyKeys]
	bit  KEYB_DOWN, a		; Holding DOWN?
	jp   z, Pl_DrawSprMap	; If not, return
	
	; If there's a solid block below, start climbing it out.
	ld   a, [wPlRelX]		; X Sensor: PlX (center)
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]		; Y Sensor: PlY + 1 (ground)
	inc  a
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; Get block ID
	jr   c, .chkTrsD		; Is the block solid? If not, jump
	;--
	; [POI] None of the levels have ladders that connect to the ground.
	;       This part is unreachable.
	xor  a ; PL_MODE_GROUND
	ld   [wPlMode], a
	jp   Pl_AnimClimb
	;--
.chkTrsD:
	; If climbing down near the bottom of the screen, start a vertical transition
	ld   a, [wPlRelY]
	cp   SCREEN_GAME_V+OBJ_OFFSET_Y+$08	; PlY > $98?
	jp   c, .moveD						; If so, jump
	ld   a, PL_MODE_CLIMBDTRSINIT
	ld   [wPlMode], a
	jp   Pl_AnimClimb
	
.moveD:
	; Otherwise, move down as normal, at 0.75px/frame
	ld   a, [wPlRelYSub]
	add  $C0
	ld   [wPlRelYSub], a
	ld   a, [wPlRelY]
	adc  $00
	ld   [wPlRelY], a
	jp   Pl_AnimClimb
	
; =============== PlMode_ClimbInInit ===============
; Initializes the climb in effect.
; This is a transition to climbing, triggered by pressing DOWN when
; standing on the top of a ladder.
PlMode_ClimbInInit:
	ld   a, PLSPR_CLIMBTOP	; Set climb transition sprite
	ld   [wPlSprMapId], a
	
	; By the time the climb in effect is done, we should have automatically moved down by $18 pixels.
	; That's the height of the player's collision box.
	ld   a, [wPlRelY]		; Immediately move 8px down
	add  PL_LADDER_IN0
	ld   [wPlRelY], a
	ld   a, $06				; Stay in the next mode for 6 frames
	ld   [wPlClimbInTimer], a
	ld   hl, wPlMode		; Switch to PL_MODE_CLIMBIN
	inc  [hl]
	jp   Pl_DrawSprMap
; =============== PlMode_ClimbIn ===============
; Climb in effect.
; A simple delay that displays the transition sprite for 6 frames,
; before switching to the actual climbing mode.
PlMode_ClimbIn:
	; Don't do anything until the delay elapses
	ld   hl, wPlClimbInTimer
	dec  [hl]
	jp   nz, Pl_DrawSprMap
	
	ld   a, [wPlRelY]		; Move down the remaining $10px
	add  PL_LADDER_IN1
	ld   [wPlRelY], a
	
	ld   a, PL_MODE_CLIMB	; Enable climbing controls
	ld   [wPlMode], a
	jp   Pl_DrawSprMap
	
; =============== PlMode_ClimbOutInit ===============
; Initializes the climb out effect.
; This is a transition when climbing to the top of a ladder, triggered by 
; pressing UP near the top.	
PlMode_ClimbOutInit:
	ld   a, PLSPR_CLIMBTOP	; Set climb transition sprite
	ld   [wPlSprMapId], a
	
	ld   a, [wPlRelY]		; Immediately move $10px up
	sub  PL_LADDER_IN1
	ld   [wPlRelY], a
	
	ld   a, $06				; Stay in the next mode for 6 frames
	ld   [wPlClimbInTimer], a
	ld   hl, wPlMode		; Switch to PL_MODE_CLIMBOUT
	inc  [hl]
	jp   Pl_DrawSprMap
; =============== PlMode_ClimbOut ===============
; Climb out effect.
PlMode_ClimbOut:
	; Don't do anything until the delay elapses
	ld   hl, wPlClimbInTimer
	dec  [hl]
	jp   nz, Pl_DrawSprMap
	
	ld   a, [wPlRelY]		; Move down the remaining $08px
	sub  PL_LADDER_IN0
	ld   [wPlRelY], a
	
	xor  a					; Switch to PL_MODE_GROUND
	ld   [wPlMode], a
	jp   Pl_DrawSprMap
	
; =============== PlMode_ClimbDTrsInit ===============
; Initializes a downwards transition while climbing a ladder.
PlMode_ClimbDTrsInit:
	; Delete all on-screen actors so we don't need to handle them
	call ActS_DespawnAll
	
	ld   a, PLSPR_CLIMB		; Set climbing frame
	ld   [wPlSprMapId], a
	ld   a, SCROLLV_DOWN	; Start downwards transition
	ld   [wScrollVDir], a
	call Game_StartRoomTrs
	ld   hl, wPlMode		; Switch to PL_MODE_CLIMBDTRS
	inc  [hl]
	jp   Pl_AnimClimb
	
; =============== PlMode_ClimbDTrs ===============
; Handles the vertical transition loop.
PlMode_ClimbDTrs:
	; Move the player down at 0.25px/frame...
	ld   a, [wPlRelYSub]
	add  $40
	ld   [wPlRelYSub], a
	ld   a, [wPlRelY]
	adc  $00
	; ...while also scrolling him up 2px/frame, to account for the viewport
	; being scrolled down that much by the transition code at Game_DoRoomTrs
	sub  $02				
	ld   [wPlRelY], a
	
	; The viewport needs to scroll down $80px, which will take $40 frames at 2px/frame.
	; With the player moving at 0.25px/frame, by the end of the transition the player
	; will have visually moved one block to the bottom ($00.40 * $40 = $10).
	call Game_DoRoomTrs		; Process the transition
	jp   nz, Pl_AnimClimb	; Has it finished? If not, jump
	ld   a, PL_MODE_CLIMB	; Otherwise, go back
	ld   [wPlMode], a
	call Pl_AnimClimb
	jp   ActS_SpawnRoom		; Spawn onscreen actors
	
; =============== PlMode_ClimbUTrsInit ===============
; Initializes an upwards transition while climbing a ladder.
; See also: PlMode_ClimbDTrsInit
PlMode_ClimbUTrsInit:
	call ActS_DespawnAll
	ld   a, PLSPR_CLIMB
	ld   [wPlSprMapId], a
	xor  a ; SCROLLV_UP		; Start upwards transition
	ld   [wScrollVDir], a
	call Game_StartRoomTrs
	ld   hl, wPlMode		; Switch to PL_MODE_CLIMBUTRS
	inc  [hl]
	jp   Pl_AnimClimb
	
; =============== PlMode_ClimbUTrs ===============
; Handles the vertical transition loop.	
PlMode_ClimbUTrs:

	; Move the player up at 0.25px/frame
	ld   a, [wPlRelYSub]
	sub  $40
	ld   [wPlRelYSub], a
	ld   a, [wPlRelY]
	sbc  $00
	add  $02				; Also scroll him down 2px/frame
	ld   [wPlRelY], a
	
	call Game_DoRoomTrs		; Process the transition
	jp   nz, Pl_AnimClimb	; Has it finished? If not, jump
	ld   a, PL_MODE_CLIMB	; Otherwise, go back
	ld   [wPlMode], a
	call Pl_AnimClimb
	jp   ActS_SpawnRoom		; Spawn onscreen actors
	
; =============== PlMode_FallTrsInit ===============
; Initializes a downwards transition while falling.
; See also: PlMode_ClimbDTrsInit
PlMode_FallTrsInit:
	call ActS_DespawnAll
	
	ld   a, PLSPR_JUMP
	ld   [wPlSprMapId], a
	
	ld   a, SCROLLV_DOWN
	ld   [wScrollVDir], a
	
	call Game_StartRoomTrs
	ld   hl, wPlMode
	inc  [hl] ; PL_MODE_FALLTRS
	jp   Pl_DrawSprMap
	
; =============== PlMode_FallTrs ===============
; Handles the vertical transition loop.		
PlMode_FallTrs:
	; Move the player down at 0.25px/frame...
	ld   a, [wPlSpdYSub]
	add  $40
	ld   [wPlSpdYSub], a
	ld   a, [wPlRelY]
	adc  $00
	sub  $02			; Also scroll him up 2px/frame
	ld   [wPlRelY], a
	
	call Game_DoRoomTrs		; Process the transition
	jp   nz, Pl_DrawSprMap	; Has it finished? If not, jump
	ld   a, PL_MODE_FALL	; Otherwise, go back
	ld   [wPlMode], a
	call Pl_DrawSprMap
	jp   ActS_SpawnRoom		; Spawn onscreen actors
	
; =============== PlMode_Frozen ===============
; Only draws the current player's frame without doing anything.
; Used to freeze the player in their previous pose, such as after firing Hard Knuckle
; or during boss intros, and it's up to external code to unfreeze him.
PlMode_Frozen:
	jp   Pl_DrawSprMap
	
; =============== PlMode_Slide ===============
; Player is sliding on the ground.
PlMode_Slide:
	; [POI] The hurt state should have been checked here to avoid movement.
	
	ld   a, PLSPR_SLIDE
	ld   [wPlSprMapId], a
	
	; We're on ground so conveyor belts apply
	call Pl_DoConveyor
	
	; 
	; LEFT/RIGHT -> Move to the respective direction
	;
	; Movement happens through Pl_DoSlideSpeed, which reuses much of the same code as Pl_DoMoveSpeed.
	; Sliding moves the player forward automatically, but that subroutine checks for the currently
	; held keys before moving, so if we're not holding an horizontal direction, fake keypresses.
	;
	ldh  a, [hJoyKeys]			; B = hJoyKeys
	ld   b, a
	and  KEY_LEFT|KEY_RIGHT		; Holding L or R?
	jr   nz, .move				; If so, we're already holding something
	ld   a, [wPlDirH]			; Otherwise, force our keys to be the direction we're facing
	or   a						; Facing right?
	jr   nz, .dirR				; If so, jump
.dirL:
	set  KEYB_LEFT, b
	jr   .setKey
.dirR:
	set  KEYB_RIGHT, b
.setKey:
	ld   a, b
	ldh  [hJoyKeys], a
.move:
	call Pl_DoSlideSpeed
	call Pl_MoveBySpeedX_Coli
	
	call Pl_DrawSprMap
	
	;
	; If there is no ground below the player, make him fall.
	; Annoyingly, there's no special version of Pl_IsOnGround used for sliding,
	; so it's not possible to slide through 1 block gaps.
	;
	call Pl_IsOnGround		; Make wColiGround
	ld   a, [wColiGround]
	and  %11				; Filter this frame's bits
	cp   %11				; Are both blocks below empty?
	jr   nz, .decTimer		; If not, skip
	
	ld   a, $00				; Otherwise, start falling at 1px/frame
	ld   [wPlSpdYSub], a
	ld   a, $01
	ld   [wPlSpdY], a
	ld   a, PL_MODE_FALL
	ld   [wPlMode], a
	; There'd be 1-frame window letting the player slide back into the gap.
	; Fix that by moving the player 1 pixel below, enough to prevent any slides
	; due to the code detecting a solid block in the way.
	ld   hl, wPlRelY
	inc  [hl]
	jp   Pl_DrawSprMap
	
.decTimer:
	; wPlSlideTimer-- if not already elapsed.
	; As long as this doesn't elapse, the slide won't end.
	ld   a, [wPlSlideTimer]
	or   a
	jr   z, .chkSolid
	dec  a
	ld   [wPlSlideTimer], a
.chkSolid:

	; 
	; Prevent the slide from ending if there's a low ceiling in the way.
	; This can cause the slide timer to stall at 0 until we move out of the low ceiling.
	;
	
	; Top-left
	ld   a, [wPlRelY]		; Y Sensor: 1 block above
	sub  BLOCK_V
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]		; X Sensor: Left border
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; Solid block detected?
	ret  nc					; If so, return
	; Top-right
	ld   a, [wPlRelX]		; X Sensor: Right border
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; Solid block detected?
	ret  nc					; If so, return
	
	; [POI] There is a massive omission here, it's not possible to jump out of slides.
	;       There's just no code to for it, and the check could have been easily added
	;       here, as we're sure there's no ceiling in the way.
	;
	;       A secondary omission is not ending the slide if a solid block is in front.
	;
	
	;
	; End the slide if its timer has elapsed.
	;
	ld   a, [wPlSlideTimer]
	or   a
	ret  nz
	xor  a ; PL_MODE_GROUND
	ld   [wPlMode], a
	ret
	
; =============== PlMode_RushMarine ===============
; Rush Marine ride mode.
; This mode is special, as it works in conjunction with the Rush Marine actor.
; This player mode handles the controls, while the actor handles the sprites being drawn.
PlMode_RushMarine:
	; Rush Marine can fire normal shots.
	; Unfortunately there's no animation for it, but there's no space left for it in VRAM.
	call WpnCtrl_Do ; BANK $01
	
	;
	; Rush Marine has its own momentum system, handling speed by itself.
	;
	; Holding a direction will progressively make the player go faster,
	; and turning around is not instant, the player's speed gradually moves the other way.
	;
	; This is accomplished by having four sets of speed values for each direction,
	; each increasing by $00.08px/frame when holding that direction, and decreasing
	; by $00.04px/frame when releasing it.
	; The speed values are all in subpixels, and as such are capped to nearly 1px/frame.
	; Finally, all speed values get applied, allowing them to cancel each other out.
	;

DEF RMSPD_INC EQU $08
DEF RMSPD_DEC EQU $04
	
.chkL:
	ld   hl, wPlRmSpdL			; HL = Left speed 
	ldh  a, [hJoyKeys]
	bit  KEYB_LEFT, a			; Holding left?
	jr   z, .decSpdL			; If not, slow down
.incSpdL:
	; The direction the player is facing is immediately updated, regardless of its speed.
	xor  a
	ld   [wPlDirH], a
	ld   a, [hl]				; wPlRmSpdL += $08
	add  RMSPD_INC
	ld   [hl], a
	jr   nc, .chkColiL			; Overflowed? If not, skip
	ld   [hl], $FF				; Cap back to nearly 1px/frame
	jr   .chkColiL
.decSpdL:
	ld   a, [hl]
	or   a						; Do we have any left speed?
	jr   z, .chkR				; If not, skip
	sub  RMSPD_DEC					; wPlRmSpdL -= $04
	ld   [hl], a
	jr   nc, .chkColiL			; Did we underflow? If not, skip
	xor  a						; Cap back to 0
	ld   [hl], a
	jr   .chkR
	
.chkColiL:
	;
	; Rush Marine bounces at half speed in the opposite direction when hitting a non-water block.
	; This doubles as the solid collision check.
	; It's also specific to horizontal movement.
	;
	ld   a, [wPlRelX]			; X Sensor: PlX - $0F (1px to the left of the left border)
	sub  RMCOLI_H+1
	call PlRm_IsWaterBlockH		; Is there a water block to the left?
	jr   z, .setSpdL			; If so, jump
								; Otherwise...
								
	; Bounce away at half speed, overwriting the right speed.
	ld   a, [wPlRmSpdL]			; wPlRmSpdR = wPlRmSpdL / 2
	srl  a
	ld   [wPlRmSpdR], a
	
	; If we were moving too slow, neither moving left nor the bounce would have an effect.
	or   a						; wPlRmSpdR == 0?
	jr   z, .chkR				; If so, skip
								; Otherwise...
	ld   bc, $0100				; ...move 1px away from the wall
	call Pl_IncSpeedX
	xor  a						; ...prevent the previous, higher speed from interfering with the bounce
	ld   [wPlRmSpdL], a
	jr   .chkR					; No movement to the left
.setSpdL:
	ld   a, [wPlRmSpdL]			; Decrease the player's speed by those subpixels
	ld   c, a
	ld   b, $00
	call Pl_DecSpeedX
	
	;
	; The same exact thing is done with all other directions, minus the bouncing effect for vertical movement.
	;
.chkR:
	ld   hl, wPlRmSpdR			; HL = Right speed 
	ldh  a, [hJoyKeys]
	bit  KEYB_RIGHT, a			; Holding right?
	jr   z, .decSpdR			; If not, slow down
.incSpdR:
	ld   a, DIR_R
	ld   [wPlDirH], a
	ld   a, [hl]				; wPlRmSpdR += $08
	add  RMSPD_INC
	ld   [hl], a
	jr   nc, .chkColiR			; Overflowed? If not, skip
	ld   [hl], $FF				; Cap back to nearly 1px/frame
	jr   .chkColiR
.decSpdR:
	ld   a, [hl]
	or   a						; Do we have any right speed?
	jr   z, .chkU				; If not, skip
	sub  RMSPD_DEC					; wPlRmSpdR -= $04
	ld   [hl], a
	jr   nc, .chkColiR			; Did we underflow? If not, skip
	xor  a						; Cap back to 0
	ld   [hl], a
	jr   .chkU
.chkColiR:
	ld   a, [wPlRelX]			; X Sensor: PlX + $0F (1px to the right of the right border)
	add  RMCOLI_H+1
	call PlRm_IsWaterBlockH		; Is there a water block to the right?
	jr   z, .setSpdR			; If so, jump
	
	ld   a, [wPlRmSpdR]			; wPlRmSpdL = wPlRmSpdR / 2
	srl  a
	ld   [wPlRmSpdL], a
	or   a						; wPlRmSpdL == 0?
	jr   z, .chkU				; If so, skip
	
	ld   bc, $0100				; Move 1px away from the wall
	call Pl_DecSpeedX
	xor  a						; Don't interfere with the bounce
	ld   [wPlRmSpdR], a
	jr   .chkU
.setSpdR:
	ld   a, [wPlRmSpdR]			; Increase the player's speed by those subpixels
	ld   c, a
	ld   b, $00
	call Pl_IncSpeedX
	
.chkU:
	ld   hl, wPlRmSpdU			; HL = Up speed 
	ldh  a, [hJoyKeys]
	bit  KEYB_UP, a				; Holding up?
	jr   z, .decSpdU			; If not, slow down
.incSpdU:
	; No vertical direction to set
	ld   a, [hl]				; wPlRmSpdU += $08
	add  RMSPD_INC
	ld   [hl], a
	jr   nc, .chkColiU			; Overflowed? If not, skip
	ld   [hl], $FF				; Cap back to nearly 1px/frame
	jr   .chkColiU
.decSpdU:
	ld   a, [hl]
	or   a						; Do we have any up speed?
	jr   z, .chkD				; If not, skip
	sub  RMSPD_DEC					; wPlRmSpdU -= $04
	ld   [hl], a
	jr   nc, .chkColiU			; Did we underflow? If not, skip
	xor  a						; Cap back to 0
	ld   [hl], a
	jr   .chkD
.chkColiU:
	ld   a, [wPlRelY]			; Y Sensor: PlY - $10 (1 block above top border)
	sub  RMCOLI_FV+1					
	call PlRm_IsWaterBlockV		; Is there a water block above?
	jr   z, .setSpdU			; If so, jump
	xor  a						; Otherwise, just immediately stop moving.
	ld   [wPlRmSpdU], a			; No bounce effect here
	jr   .chkD
.setSpdU:
	; Decrement Rush Marine's speed by those subpixels.
	; Instead of directly affecting the player's speed, this is stored into a separate variable,
	; which could have been avoided had entering Rush Marine reset the player's speed (in Act_RushMarine_WaitPl).
	; The logic is otherwise the same as Pl_DecSpeedX.
	ld   a, [wPlRmSpdU]			; B = Upwards speed
	ld   b, a
	ld   a, [wPlRmSpdYSub]		; wPlRmSpdY* -= B
	sub  b
	ld   [wPlRmSpdYSub], a
	ld   a, [wPlRmSpdY]
	sbc  $00
	ld   [wPlRmSpdY], a
	
.chkD:
	ld   hl, wPlRmSpdD			; HL = Down speed 
	ldh  a, [hJoyKeys]
	bit  KEYB_DOWN, a			; Holding down?
	jr   z, .decSpdD			; If not, slow down
.incSpdD:
	ld   a, [hl]				; wPlRmSpdD += $08
	add  RMSPD_INC
	ld   [hl], a
	jr   nc, .chkColiD			; Overflowed? If not, skip
	ld   [hl], $FF				; Cap back to nearly 1px/frame
	jr   .chkColiD
.decSpdD:
	ld   a, [hl]
	or   a						; Do we have any up speed?
	jr   z, .move				; If not, skip
	sub  RMSPD_DEC				; wPlRmSpdD -= $04
	ld   [hl], a
	jr   nc, .chkColiD			; Did we underflow? If not, skip
	xor  a						; Cap back to 0
	ld   [hl], a
	jr   .move
.chkColiD:
	ld   a, [wPlRelY]			; Y Sensor: PlY + 1 (ground)
	inc  a
	call PlRm_IsWaterBlockV		; Is there a water block below?
	jr   z, .setSpdD			; If so, jump
	xor  a						; Otherwise, just immediately stop moving.
	ld   [wPlRmSpdD], a			; No bounce effect here
	jr   .move
.setSpdD:
	; Increment Rush Marine's speed by those subpixels.
	ld   a, [wPlRmSpdD]			; B = Downwards speed
	ld   b, a
	ld   a, [wPlRmSpdYSub]		; wPlRmSpdY* += B
	add  b
	ld   [wPlRmSpdYSub], a
	ld   a, [wPlRmSpdY]
	adc  $00
	ld   [wPlRmSpdY], a
.move:
	; Finally, move the player by the speed we've calculated
	call Pl_MoveBySpeedX
	jp   Pl_MoveByRmSpeedY
	
; =============== PlRm_IsWaterBlockH ===============
; Horizontal collision check for Rush Marine.
; Checks if there's a water block at the specified horizontal position,
; as Rush Marine can only move through them.
; IN
; - A: Horizontal position
; OUT
; - Z Flag: If set, there's a water block (can move)
PlRm_IsWaterBlockH:
	;
	; Treat Rush Marine as being 16 pixels tall for this check.
	; This is actually smaller than the player's hitbox.
	;
	ld   [wTargetRelX], a	; X Sensor: Custom
	ld   a, [wPlRelY]		; Y Sensor: PlY (bottom)
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	cp   BLOCKID_WATER		; Is there a water block?
	jr   z, .chkHi			; If so, jump
	cp   BLOCKID_WATERSPIKE	; ""
	ret  nz					; If not, return
.chkHi:
	ld   a, [wPlRelY]		; Y Sensor: PlY - $0F (top)
	sub  RMCOLI_FV
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	cp   BLOCKID_WATER
	ret  z
	cp   BLOCKID_WATERSPIKE	; Z Flag = Is water block
	ret
	
; =============== PlRm_IsWaterBlockV ===============
; Vertical collision check for Rush Marine.
; Checks if there's a water block at the specified vertical position.
; IN
; - A: Vertical position
; OUT
; - Z Flag: If set, there's a water block (can move)
PlRm_IsWaterBlockV:
	;
	; Treat Rush Marine as being 24 pixels long for this check.
	; This is much larger than the player's normal hitbox.
	;
	ld   [wTargetRelY], a	; Y Sensor: Custom
	ld   a, [wPlRelX]		; X Sensor: PlX (center)
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_WATER
	jr   z, .chkL
	cp   BLOCKID_WATERSPIKE
	ret  nz
.chkL:
	ld   a, [wPlRelX]		; X Sensor: PlX - $0E (left)
	sub  RMCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_WATER
	jr   z, .chkR
	cp   BLOCKID_WATERSPIKE
	ret  nz
.chkR:
	ld   a, [wPlRelX]		; X Sensor: PlX + $0E (right)
	add  RMCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_WATER
	ret  z
	cp   BLOCKID_WATERSPIKE
	ret
	
; =============== PlMode_WarpInInit ===============
; Initializes the teleport from the top of the screen.
; The player spawns in this mode.
PlMode_WarpInInit:
	ld   a, $00				; Initial speed is 1px/frame
	ld   [wPlSpdYSub], a
	ld   a, $01
	ld   [wPlSpdY], a
	ld   a, PLSPR_WARP
	ld   [wPlSprMapId], a
	ld   hl, wPlMode		; Start moving next frame
	inc  [hl]				; PL_MODE_WARPINMOVE
	ret
; =============== PlMode_WarpInMove ===============
; Teleports the player down until a solid block is reached.
PlMode_WarpInMove:

	; Get the updated position we're tentatively moving to, if the coming checks pass
	ld   a, [wPlRelY]		; wPlNewRelY = wPlRelY + wPlSpdY
	ld   b, a
	ld   a, [wPlSpdY]
	add  b
	ld   [wPlNewRelY], a
	
	; Always go through the first three blocks even if they are solid.
	; This allows us to teleport even when a ceiling is in the way.
	cp   OBJ_OFFSET_Y+(BLOCK_H*3)+$08 	; wPlNewRelY < $48?
	jr   c, .moveD						; If so, skip
	
	; Below that, as soon as we touch a solid block, start the landing sequence.
	ld   [wTargetRelY], a		; Y Sensor: New PlY (new bottom)
	ld   a, [wPlRelX]			; X Sensor: PlX (center)
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; Found a solid block?
	jr   nc, .nextMode			; If so, jump
	ld   a, [wPlNewRelY]		; Otherwise, confirm the new position
.moveD:
	ld   [wPlRelY], a
	
	; Apply downwards gravity at 0.125px/frame
	ld   bc, $0020
	ld   a, [wPlSpdYSub]
	add  c
	ld   [wPlSpdYSub], a
	ld   a, [wPlSpdY]
	adc  b
	ld   [wPlSpdY], a
	
	; Cap gravity to 4px/frame
	cp   $04
	jp   c, Pl_DrawSprMap
	xor  a
	ld   [wPlSpdYSub], a
	ld   a, $04
	ld   [wPlSpdY], a
	jp   Pl_DrawSprMap
	
.nextMode:
	; Align to block boundary
	ld   a, [wPlRelY]
	or   $0F
	ld   [wPlRelY], a
	; Start landing sequence
	ld   hl, wPlMode
	inc  [hl] ; PL_MODE_WARPINLAND
	; Start animation from first frame
	xor  a ; PLSPR_WARP
	ld   [wPlWarpAnimTimer], a
	jp   Pl_DrawSprMap
	
; =============== PlMode_WarpInLand ===============
; Landing animation after the player teleports down.
PlMode_WarpInLand:
	;
	; This animation uses PLSPR_WARP and the four PLSPR_WARPLAND* frames at $31-$35.
	; Advance the animation every 2 frames, and when it ends give the player control.
	;
	; This is the resulting calculation:
	; wPlSprMapId = PLSPR_WARP + (wPlWarpAnimTimer / 2)
	;
	
	; *Pre-increment* the animation timer.
	ld   a, [wPlWarpAnimTimer]
	inc  a
	ld   [wPlWarpAnimTimer], a
	
	srl  a									; A /= 2 to slow down x2
	cp   PLSPR_WARP_END-PLSPR_WARP_START	; Went past the last valid frame? (A == $05)
	jr   z, .end							; If so, we're done
	
	ld   b, a					; Otherwise, calculate the sprite ID
	ld   a, PLSPR_WARP_START	; Get base
	add  b						; Add relative
	ld   [wPlSprMapId], a		; Save back
	jp   Pl_DrawSprMap
.end:
	ld   a, SFX_TELEPORTIN		; Play landing sound
	mPlaySFX
	xor  a ; PL_MODE_GROUND
	ld   [wPlMode], a
	ret
	
; =============== PlMode_WarpOutInit ===============
; Initializes the teleport out animation, used when a level is completed.
; These are like PlMode_WarpIn*, except in reverse.
PlMode_WarpOutInit:
	; The initial frame in this animation is PLSPR_WARPLAND2, not PLSPR_WARPLAND3.
	; PLSPR_WARPLAND3 is skipped due to the timer at $0A ($0A/2 = 5) getting immediately decremented ($09/2 = 4)
	ld   a, $0A
	ld   [wPlWarpAnimTimer], a
	ld   a, PLSPR_WARPLAND2
	ld   [wPlSprMapId], a
	; Start anim next frame
	ld   hl, wPlMode
	inc  [hl] ; PL_MODE_WARPOUTANIM
	jp   Pl_DrawSprMap
	
; =============== PlMode_WarpOutAnim ===============
; Animates the player warping out, a reverse version of PlMode_WarpInAnim.
PlMode_WarpOutAnim:
	;
	; *Pre-decrement* the animation timer.
	; wPlSprMapId = PLSPR_WARP_START + (wPlWarpAnimTimer / 2) - 1
	;
	; The combination of pre-decrementing and decrementing to begin with the timer leads to two quirks:
	; - PLSPR_WARPLAND3 is skipped as explained before
	; - When (animation timer / 2) ticks down to 0, the reverse landing animation ends and we start moving up.
	;   Since 1 will be the last value, the base frame needs to counterbalance it with a -1.
	;
	ld   a, [wPlWarpAnimTimer]
	dec  a
	ld   [wPlWarpAnimTimer], a
	
	srl  a						; Slow animation down x2.
	jr   z, .end				; Timer counted down to 0? (PLSPR_WARP_START) If so, start moving up
	ld   b, a					; Otherwise, calculate the sprite ID
	ld   a, PLSPR_WARP_START-1	; Get base
	add  b						; Add relative
	ld   [wPlSprMapId], a		; Save back
	jp   Pl_DrawSprMap
.end:
	ld   a, SFX_TELEPORTOUT		; Play teleport sound
	mPlaySFX
	ld   hl, wPlMode
	inc  [hl] ; PL_MODE_WARPOUTMOVE
	jp   Pl_DrawSprMap
	
; =============== PlMode_WarpOutMove ===============
; Teleports the player up until he reaches the top of the screen.
PlMode_WarpOutMove:
	; Move up at a fixed 4px/frame
	ld   a, [wPlRelY]
	sub  $04
	ld   [wPlRelY], a
	; When we reach the range $00-$0F (offscreen above), stop moving
	and  $F0				; (PlY & $F0) != 0?
	jp   nz, Pl_DrawSprMap	; If so, continue moving
	ld   hl, wPlMode		; Otherwise, advance to waiting
	inc  [hl]
	jp   Pl_DrawSprMap
	
; =============== PlMode_WarpOutEnd ===============
; Teleporting animation finished, nothing else to do.
; The level end handler will perform the appropriate action after waiting for a while.
PlMode_WarpOutEnd:
	ret
	
; =============== PlMode_TeleporterInit ===============
; Initializes the Wily Teleporter animation.
; Identical to PlMode_WarpOutInit.
PlMode_TeleporterInit:
	ld   a, $0A
	ld   [wPlWarpAnimTimer], a
	ld   a, PLSPR_WARPLAND2
	ld   [wPlSprMapId], a
	ld   hl, wPlMode
	inc  [hl] ; PL_MODE_TLPANIM
	jp   Pl_DrawSprMap
	
; =============== PlMode_Teleporter ===============
; Animates the player warping out.
; Identical to PlMode_WarpOutAnim.
PlMode_Teleporter:
	ld   a, [wPlWarpAnimTimer]
	dec  a
	ld   [wPlWarpAnimTimer], a
	srl  a
	jr   z, .end
	ld   b, a
	ld   a, PLSPR_WARP_START-1
	add  b
	ld   [wPlSprMapId], a
	jp   Pl_DrawSprMap
.end:
	ld   a, SFX_TELEPORTOUT
	mPlaySFX
	ld   hl, wPlMode
	inc  [hl] ; PL_MODE_TLPEND
	jp   Pl_DrawSprMap
	
; =============== PlMode_TeleporterEnd ===============
; Triggers the warp to the level previouly specified to wLvlWarpDest when entering the teleporter.
PlMode_TeleporterEnd:
	ld   a, [wLvlWarpDest]
	ld   [wLvlEnd], a
	ret
	
