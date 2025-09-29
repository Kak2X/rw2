; =============== Game_Main ===============
; Main sequence of operations.
Game_Main:
	ld   sp, WRAM_End
	push af
		ld   a, BANK(Module_Password) ; BANK $01
		ldh  [hROMBankLast], a
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	call Pl_ResetAllProgress
	
	call Module_Title				; Wait for response
	jr   z, Game_Main_ToStageSel	; GAME START selected? If so, jump
.toPassword:
	call Module_Password 	; Is the password invalid?
	jr   c, Game_Main		; If so, return to the title screen
	
	; Otherwise, decide where to go to next.
	
	; If all 8 bosses are defeated, warp to the pre-Quint room
	ld   a, [wWpnUnlock0]
	cp   WPU_MG|WPU_HA|WPU_NE|WPU_CR|WPU_ME|WPU_WD|WPU_AR|WPU_TP
	jp   z, Game_Main_ToPreQuint
	
	; If any, but not all, of the second set of bosses is defeated,
	; warp to the teleport room
	ld   a, [wWpnUnlock0]
	and  WPU_MG|WPU_HA|WPU_NE|WPU_TP
	jr   nz, Game_Main_ToTeleport
	
	; If the first set of bosses is defeated, but noone in the second,
	; warp to the Wily Castle cutscene.
	ld   a, [wWpnUnlock0]
	cp   WPU_CR|WPU_ME|WPU_WD|WPU_AR
	jr   z, Game_Main_ToWilyCastle
	
	; Fall-through the first set otherwise.
	; The level end modes for each of these can chain into the next.
	
; =============== Game_Main_ToStageSel ===============
; Currently at the first set of bosses.
; These are chosen through a character select screen, with ammo being refilled after every stage.
Game_Main_ToStageSel:
	call Module_StageSel
	
	; Prepare for gameplay.
.startLvl:	
	; Start from the actual first room.
	; Room ID $00, by convention, is kept completely empty.
	ld   a, $01
	ld   [wLvlRoomId], a
	
	; Load everything
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	
.toGame:
	; Handle gameplay loop until someone dies
	call Module_Game
	cp   LVLEND_BOSSDEAD		; Did the boss explode?
	jr   z, .bossDead			; If so, jump
	
.plDead:
	; The player has died, animate his explosion animation. 
	; It also takes care of reloading the level, taking permadespawns into account.
	; In case we ran out of lives, the game over sequence runs under Module_Game_PlDead.
	call Module_Game_PlDead			; Did we game over?
	jr   c, .toGame					; If not, respawn
	; A -> Stage Select
	ld   a, [wGameOverSel]
	bit  KEYB_B, a					; Pressed B?
	jr   z, Game_Main_ToStageSel	; If not, we pressed A. Return to the stage select.
	; B -> Continue
	; Fully reload the level, identically to .startLvl
	ld   a, $01						
	ld   [wLvlRoomId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	jr   .toGame
	
.bossDead:
	; Boss has died (1st boss)
	call Module_Game_BossDead
	call Lvl_SetCompleted
	call Module_GetWpn
	call Module_PasswordView ; BANK $01
	call Pl_RefillAllWpn	; Refill weapons
	
	; If the first set of bosses is defeated, advance to Wily's Castle
	ld   a, [wWpnUnlock0]
	and  WPU_CR|WPU_ME|WPU_WD|WPU_AR	; Filter only 1st set
	cp   WPU_CR|WPU_ME|WPU_WD|WPU_AR	; Defeated all of them?
	jr   nz, Game_Main_ToStageSel		; If not, return to the stage select
	
; =============== Game_Main_ToWilyCastle ===============
; Just accessed Wily Castle, so show the cutscene.
; From this point onward, no ammo is refilled after every stage.	
Game_Main_ToWilyCastle:

	;
	; Display the Wily Castle cutscene
	;
	call WilyCastle_LoadVRAM	; Prepare VRAM
	call WilyCastle_DrawRockman
	call StartLCDOperation
	ld   a, BGM_WILYINTRO		; Play BGM
	mPlayBGM
	call FlashBGPalLong			; Display for 9 seconds
	
	;
	; Load in the Wily Castle level, starting with an in-engine cutscene.
	; The cutscene is executed under pseudo-gameplay, and when it finishes
	; it directly transitions to gameplay.
	;
	ld   a, $01				; From first room
	ld   [wLvlRoomId], a
	ld   a, LVL_CASTLE		; In Wily Castle
	ld   [wLvlId], a
	
	call Module_Game_InitScrOff	; Load the level
	call Module_Game_InitScrOn
	call WilyCastle_DoCutscene
	;--
	; [BUG] This cannot be called at this point, and it won't do anything anyway as no boss from the 2nd set is defeated yet.
	call WilyCastle_CloseWonTeleporters
	;--
	jr   Game_Main_ToTeleport.toGame
	
; =============== Game_Main_ToTeleport ===============
; Directly returned to the teleporter room in Wily's Castle.
; This happens after exiting any of the 2nd set of levels.
Game_Main_ToTeleport:
	ld   a, $03			; Third room is the teleporter room
	ld   [wLvlRoomId], a
	ld   a, LVL_CASTLE	; In Wily Castle
	ld   [wLvlId], a
	; Load the level...
	call Module_Game_InitScrOff
	call WilyCastle_CloseWonTeleporters	; ...showing closed teleporters
	call Module_Game_InitScrOn
	
.toGame:
	; Handle gameplay loop until someone dies
	call Module_Game
	cp   LVLEND_BOSSDEAD		; Did the boss explode?
	jr   z, .bossDead			; If so, jump
	
.plDead:
	; The player has died 
	call Module_Game_PlDead			; Did we game over?
	jr   c, .toGame					; If not, respawn
	; A -> Stage Select
	ld   a, [wGameOverSel]
	bit  KEYB_B, a					; Pressed B?
	jr   z, Game_Main_ToTeleport	; If not, we pressed A. Return to the teleporter room
	; B -> Continue
	; Fully reload the current level
	ld   a, $01						
	ld   [wLvlRoomId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	jr   .toGame
	
.bossDead:
	; Boss has died (2nd boss)
	call Module_Game_BossDead
	call Lvl_SetCompleted
	call Module_GetWpn
	call Module_PasswordView ; BANK $01
	; (No weapon refill)
	
	; If the second set of bosses is also defeated, advance to the Quint fight
	ld   a, [wWpnUnlock0]
	cp   WPU_MG|WPU_HA|WPU_NE|WPU_TP|WPU_CR|WPU_ME|WPU_WD|WPU_AR	; Defeated every bormal boss?
	jr   nz, Game_Main_ToTeleport		; If not, return to the teleport room
	; Fall-through
	
; =============== Game_Main_ToPreQuint ===============
; Directly returned to the teleporter room in Wily's Castle, when all bosses are defeated.
Game_Main_ToPreQuint:
	;
	; When all bosses are defeated, we spawn in a separate copy of the teleporter room
	; where all doors are closed and there's an hole in the ground to the Quint Fight.
	;
	; The closed teleporters here use actual blocks rather than being just something 
	; drawn to the tilemap over open teleporters... and inconsistently they are solid here.
	;
	ld   a, $04				; 1 room after the normal teleporter room
	ld   [wLvlRoomId], a
	ld   a, LVL_CASTLE		; In Wily Castle
	ld   [wLvlId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	
.toGame:
	; Handle gameplay loop until someone dies
	call Module_Game
	cp   LVLEND_BOSSDEAD
	jr   z, .bossDead
.plDead:
	; The player has died 
	call Module_Game_PlDead			; Did we game over?
	jr   c, .toGame					; If not, respawn
	; A -> Stage Select
	;      Does the same thing as continuing
	ld   a, [wGameOverSel]
	bit  KEYB_B, a					; Pressed B?
	jr   z, Game_Main_ToPreQuint	; If not, we pressed A. Return to the teleporter room
	; B -> Continue
	ld   a, $04						
	ld   [wLvlRoomId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	jr   .toGame
.bossDead:
	call Module_GetWpn
	; Fall-through to cutscene
	
; =============== Game_Main_ToWilyStation ===============
; Start with the final level, Wily Station, and displaying its cutscene.
Game_Main_ToWilyStation:
	; Show cutscene
	call Module_WilyStationCutscene ; BANK $01
	
	; Spawn at the final level
	ld   a, $01
	ld   [wLvlRoomId], a
	ld   a, LVL_STATION
	ld   [wLvlId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
.toGame:
	; When loading a level, Game_Init recalculates wWpnUnlock1, but it skips touching the Sakugarne bit
	; since it's not tied to having obtained any other weapon (can't check for all 8 weapons either).
	; A level ID check could have been made there to avoid splitting up the wWpnUnlock1 writes, but they didn't.
	ld   hl, wWpnUnlock1
	set  WPUB_SG, [hl]
	
	; Handle gameplay loop until someone dies
	call Module_Game
	cp   LVLEND_BOSSDEAD		; Did the boss explode?
	jr   z, .bossDead			; If so, jump
	
.plDead:
	; The player has died 
	call Module_Game_PlDead			; Did we game over?
	jr   c, .toGame					; If not, respawn
	; A -> Stage Select
	;      Shows the cutscene again, that's the only difference compared to continuing
	ld   a, [wGameOverSel]
	bit  KEYB_B, a					; Pressed B?
	jr   z, Game_Main_ToWilyStation	; If not, we pressed A. Return to the station cutscene
	; B -> Continue
	ld   a, $01						
	ld   [wLvlRoomId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	jr   .toGame
.bossDead:
	; Run the normal boss defeat code, which is why Rockman tries to absorb Wily's missile
	call Module_Game_BossDead
	; Run ending and credits scenes
	call Module_Ending ; BANK $01
	call Module_Credits ; BANK $01
	; [POI] We never get here, the credits never return.
.end:
	jp   .end

