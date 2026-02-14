; =============== Pl_ResetAllProgress ===============
; Resets all progress from the game.
; ie: when starting a new game
Pl_ResetAllProgress:
	xor  a
	ld   [wWpnUnlock0], a
	ld   [wWpnUnlock1], a
	ld   [wETanks], a
	
; =============== Pl_ResetLivesAndWpnAmmo ===============
; Resets the player's lives and all ammo.
; ie: after entering a password or continuing from a game over
Pl_ResetLivesAndWpnAmmo:
	ld   a, $02
	ld   [wPlLives], a
	
; =============== Pl_RefillAllWpn ===============
; Refills all of the weapon ammo.
Pl_RefillAllWpn:
	ld   a, BAR_MAX							; A = Max ammo value
	ld   hl, wWpnAmmo_Start					; HL = From the first weapon
	ld   b, wWpnAmmo_End - wWpnAmmo_Start	; B = Bytes to reset
.loop:
	ldi  [hl], a	; Write it over in a loop
	dec  b
	jr   nz, .loop
	ret
	
; =============== Pl_Init ===============
; Initializes the player entity.
Pl_Init:
	
	; Start by warping in
	ld   a, PL_MODE_WARPININIT
	ld   [wPlMode], a
	
	; Reset player collision markers
	ld   a, ACTSLOT_NONE
	ld   [wActHurtSlotPtr], a
	ld   [wActPlatColiSlotPtr], a
	ld   [wActHelperColiSlotPtr], a
	ld   [wActRjStandSlotPtr], a
	
	; Initialize a bunch of variables, mostly to clean up from last time
	xor  a
	ldh  [hScrollXNybLow], a
	ld   [wLvlEnd], a
	ld   [wPlSlideDustTimer], a
	ld   [wPlSpdXSub], a
	ld   [wPlSpdX], a
	ld   [wPlHurtTimer], a
	ld   [wPlInvulnTimer], a
	ld   [wBossMode], a
	ld   [wBossDmgEna], a
	ld   [wBossIntroHealth], a
	ld   [wShutterMode], a
	ld   [wWpnId], a 			; Start with the buster always
	
	; [BUG] The European version properly resets weapon-related variables.
	;       This mainly fixes a bug where dying while the Leaf Shield is active makes it persist after respawning.
	IF REV_VER == VER_EU
		ld   [wShot0], a
		ld   [wShot1], a
		ld   [wShot2], a
		ld   [wShot3], a
		ld   [wPlShootTimer], a
		ld   [wPlShootType], a
		ld   [wWpnHaFreezeTimer], a
		ld   [wWpnNePos], a
		ld   [wWpnTpActive], a
		ld   [wWpnSGRide], a
	ENDC
	
	ld   [wWpnHelperWarpRtn], a
	ld   [wWpnHelperUseTimer], a
	ld   [wUnused_CF5F], a
	ld   [wLvlWarpDest], a
	; The non-EU one only cleared the absolute minimum, which isn't enough
	IF REV_VER != VER_EU
		ld   [wWpnTpActive], a
		ld   [wWpnSGRide], a
	ENDC
	ld   [wStatusBarRedraw], a
	
	; Start with full health
	ld   a, BAR_MAX
	ld   [wPlHealth], a
	
	;
	; Determine the automatic weapon unlocks, which aren't stored in the password.
	;
	ld   hl, wWpnUnlock1
	; Start fresh
	xor  a
	ld   [hl], a
	; Defeating Crash Man unlocks Rush Coil
.chkRC:
	ld   a, [wWpnUnlock0]	
	bit  WPUB_CR, a		; Crash Bomb unlocked?
	jr   z, .chkRM		; If not, skip
	set  WPUB_RC, [hl]	; Otherwise, enable Rush Coil
.chkRM:
	; Defeating Metal Man unlocks Rush Marine
	bit  WPUB_ME, a
	jr   z, .chkRJ
	set  WPUB_RM, [hl]
.chkRJ:
	; Defeating Air Man unlocks Rush Jet
	bit  WPUB_AR, a
	jr   z, .setPlPos
	set  WPUB_RJ, [hl]
	; NOTE: The Sakugarne unlock is set right before loading the final level.
	
.setPlPos:
	;
	; Set the player's spawn coordinates.
	; They are actually ever so slightly different (by 8 pixels on either side)
	; depending on the current room's scroll locks.
	;
	; This takes advantage of the ROM format of scroll lock data.
	; The byte defining the scroll lock options for the current room
	; can be used as an index to the table of X spawn positions
	; 
	
	; A = wLvlScrollLocksRaw[wLvlRoomId]
	ld   hl, wLvlScrollLocksRaw
	ld   a, [wLvlRoomId]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	; A = .spawnPosTbl[A & 3]
	and  $03
	ld   hl, .spawnPosTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	
	ld   [wPlRelX], a	; Use that as spawn X position
	ld   a, $0F			; Spawn from the top always
	ld   [wPlRelY], a
	ld   a, $01			; Face right
	ld   [wPlDirH], a
	
	; Finally, recalculate the current column number.
	; This expects the updated wLvlColL which Lvl_DrawFullScreen set.
	jp   Game_CalcCurLvlCol
	
.spawnPosTbl	
	db $58 ; Both locked - Center of the room
	db $50 ; Left locked - Slightly to the left
	db $60 ; Right locked - Slightly to the right [POI] Not used
	db $58 ; None locked - Center of the room

; =============== Pl_RunInitEv ===============
; Performs any event-based VRAM updates that need to be executed immediately after the screen is turned on.
; These are actions that, while happen while the level loads, can also individually happen in the middle of gameplay.
Pl_RunInitEv:

	;
	; The default status bar tilemap we loaded before contains placeholder values.
	;
	ld   a, [wPlHealth]		; Redraw health bar
	ld   c, BARID_PL
	call Game_AddBarDrawEv
	ld   a, [wPlLives]		; Redraw lives indicator
	call Game_AddLivesDrawEv
	rst  $18 ; Wait bar update
	
	;
	; Load the actor graphics for the room the player has spawned in, using the same code for room transitions.
	; This is the cause of the noticeable delay before the player is warped in, since the copy happens during
	; VBlank and there isn't anything else (ie: the screen scrolling during a transition) to mask the load times.
	;
	call ActS_ReqLoadRoomGFX
	rst  $20 ; Wait GFX load
	ret
