; =============== Module_Game ===============
; Gameplay loop.
; OUT
; - A: Reason the level has ended (wLvlEnd)
;      When exiting the subroutine, it can only happen the moment the player or boss explode.
Module_Game:
	rst  $08 ; Wait Frame
	
	;
	; Perform the palette animation immediately.
	; This uses hBGPAnim0 for 5 frames, hBGPAnim1 for 3 frames, then it loops.
	;
	ld   hl, hBGPAnim0	; HL = Ptr to 1st pal
	ldh  a, [hTimer]
	and  $07
	cp   $05			; (hTimer & 8) < 5?
	jr   c, .setPalAnim	; If so, keep 1st pal
	inc  hl				; Otherwise, switch to 2nd pal
.setPalAnim:
	ld   a, [hl]		; Read the palette
	ldh  [hBGP], a		; Save it
	
	
.pollKeys:
	; Poll for input
	call JoyKeys_Refresh
	
	;
	; Press START to open the pause menu.
	;
	; This and a few other features only have an activation check since the subroutine called
	; takes exclusive control, becoming the new main loop until we exit out of there.
	;
	; This being done here means it can be triggered at any given point, even during screen transitions,
	; which isn't allowed in most other games.
	;
.chkPause:
	ldh  a, [hJoyNewKeys]
	bit  KEYB_START, a		; Pressed START?
	jr   z, .chkFreeze		; If not, skip
	
	; Wait for any events that may be in progress, which can cause visible delays especially if this
	; is done immediately after starting a room transition.
	; This does need to happen though, since the pause menu needs to write to the tilemap during init
	; and we don't want to abruptly overwrite those in progress.
	call Ev_WaitAll
	call Pause_Do
	jr   Module_Game
	
.chkFreeze:
	;
	; Press SELECT to freeze-frame pause.
	;
	; [TCRF] Disabled unless the invulnerability cheat is enabled.
	;
	bit  KEYB_SELECT, a		; Pressed SELECT?
	jr   z, .doGame			; If not, skip
	ldh  a, [hCheatMode]
	or   a					; Is the cheat enabled?
	jr   z, .doGame			; If not, skip
	call Freeze_Do ; BANK $01
	jr   Module_Game
	
.doGame:
	; Prepare for drawing any sprites
	xor  a
	ldh  [hWorkOAMPos], a
	
	; Save the hTimer value from the start of the gameplay loop.
	; As hTimer is incremented during VBlank, at the end of the gameplay loop
	; they can be compared to check for lag frames.
	ldh  a, [hTimer]
	ld   [wStartTimer], a
	
	call Pl_Do 				; Run gameplay
	call Pl_DoActColi		; Process player-actor collision
	call WpnS_Do ; BANK $01 ; Process on-screen shots 
	
	;
	; Run actor code.
	; Actor code is all stored in BANK $02, but may call code in BANK $00 that triggers a bankswitch.
	; To make those subroutines properly return, set $02 as the default bank when executing actors.
	;
	push af
		ld   a, BANK(ActS_Do) ; BANK $02
		ldh  [hROMBankLast], a
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	call ActS_Do
	push af
		ld   a, $01
		ldh  [hROMBankLast], a
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	;
	; With actors processed and drawn, there are no further sprite mappings to draw this frame.
	; Finalize any remaining OBJ slots to $00, to avoid showing any leftovers from the last frame.
	;
	call OAM_ClearRest
	
	;
	; If hTimer does not match wStartTimer, it means a lag frame has occurred.
	; In that case, jump back to the main loop without waiting for a new frame,
	; in an attempt to catch up.
	; Refill processing is also skipped as they are run during VBlank.
	;
	ld   hl, hTimer			; HL = Ptr to hTimer
	ld   a, [wStartTimer]	; A = wStartTimer
	cp   [hl]				; wStartTimer != hTimer?
	jr   nz, .pollKeys		; If so, jump
	
	call Game_TickTime		; Tick gameplay clock & process refills
	
	;
	; If the level is marked as ended, determine if/how to exit out of here.
	; There are various ways a level can end, which can be influenced by the level we're in too.
	;
	ld   a, [wLvlEnd]
	or   a					; Anything written to wLvlEnd?
	jr   z, Module_Game		; If not, loop back
	
	push af ; Save wLvlEnd
		call Pl_StopTpAttack	; Weapon shots are still processed when dead, but cancel out Top Spin due to its overriding of the player sprite.
		call WpnS_SaveCurAmmo	; Force save current ammo, as normally this is only done when pausing 
		xor  a
		ld   [wPlSprFlags], a	; Reset miscellanous flags
		ld   [wLvlWater], a
		ld   [wActScrollX], a
	pop  af ; A = wLvlEnd
	
	;
	; Determine level end type.
	;
	
	; If someone exploded, exit out from the main gameplay loop entirely,
	; as the explosion/death sequence is handled separately to avoid handling the player.
	cp   LVLEND_BOSSDEAD+1		; wLvlEnd < $03?
	ret  c						; If so, return the wLvlEnd
	
	; All modes > $03 are used for the instant level transitions used by teleporters in Wily Castle.
	; These take the format of (LVL_* + 1) << 4, so to extract the level ID, do the opposite operations:
	swap a				; >>= 4
	dec  a				; - 1
	and  $03			; Only the first four levels can be used for this (which, by ID, are the RM3 bosses)
	ld   [wLvlId], a	; Set that as level ID
	
	ld   a, $01			; Return to the first room
	ld   [wLvlRoomId], a
	
	call Module_Game_InitScrOff	; Redo the full level initialization sequence
	call Module_Game_InitScrOn	; ""
	
	jp   Module_Game	; Back to the gameplay loop as if nothing happened
	
