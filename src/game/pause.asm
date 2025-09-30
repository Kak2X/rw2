; =============== Pause_Do ===============
; Main loop of the pause menu.
Pause_Do:
	; Save any changes immediately, before wWpnId can change
	call WpnS_SaveCurAmmo
	
	;
	; Draw the pause menu.
	;
	; This involves small bars for the player's health and all of the unlocked weapons,
	; as well as drawing the E-Tanks in sequence.
	;
	; As usual, the writes are performed during VBlank, using the TilemapDef system,
	; and to minimize the waiting time groups of bars are applied at once.
	;
	ld   a, [wWpnId]
	push af						; Save wWpnId for much later
	
		; PLAYER HEALTH
	.plBar:
		ld   hl, wPlHealth		; HL = Ptr to value
		ld   de, wTilemapBuf	; DE = Ptr to write buffer
		ld   c, $00				; C = Selection (WPN_*)
		ldi  a, [hl]			; Read wPlHealth, seek to wWpnAmmoRC
		call Pause_AddBarDrawEv	; Draw the weapon name & small lifebar
		
		; RUSH ITEMS
		; These are on the first three bits of wWpnUnlock1.
		; The way this is done by shifting bits right and incrementing the selection 
		; absolutely requires wWpnUnlock1, wWpnId and the weapon array to be consistent.
		; ie: RC, RM and RJ are in the same order both in WPU_* and WPN_*, even though
		; they start at different indexes. This pattern is also required for the 8 main weapons.
	.rushBars:
		ld   a, [wWpnUnlock1]	; B = Item unlock bitmask
		ld   b, a
		ld   a, $03				; A = Bits to check (bit0-2)
	.loop1:
		push af 				; Save count
			inc  c						; SelId++
			ldi  a, [hl]				; A = Weapon ammo, seek to next one
			srl  b						; Shift the respective weapon unlock bit to the carry
			call c, Pause_AddBarDrawEv	; Is the weapon unlocked? If so, draw its indicator
		pop  af					; Restore count
		dec  a					; Checked all Rush bits?
		jr   nz, .loop1			; If not, loop
		rst  $10 ; Wait tilemap load
		
		; 8 MAIN WEAPONS
		; See the one above
	.mainBars:
		ld   de, wTilemapBuf	; Reset buffer pos
		ld   a, [wWpnUnlock0]
		or   a					; Are any unlocked?		
		jr   z, .sgBar			; If not, skip
		ld   b, a
		ld   a, $08				; A = Bits to check (all)
	.loop0:
		push af
			inc  c
			ldi  a, [hl]
			srl  b
			call c, Pause_AddBarDrawEv
		pop  af
		dec  a
		jr   nz, .loop0
		rst  $10 ; Wait tilemap load
	
	.sgBar:
		; SAKUGARNE
		ld   de, wTilemapBuf	; Reset buffer pos
		ld   a, [wWpnUnlock1]
		and  WPU_SG				; Pogo unlocked?
		jr   z, .etanks			; If not, skip
		ld   a, [wWpnAmmoSG]
		ld   c, WPN_SG
		call Pause_AddBarDrawEv
		
	.etanks:

		; E TANKS
		; "EN" text, followed by right-aligned E-Tank icons drawn in sequence for each one collected.
		
		; bytes0-1: Destination pointer
		ld   hl, Pause_BarTbl.en
		call CopyWord
		
		; byte2: Writing mode + Number of bytes to write
		ld   a, $07				; Max 4 Tanks + 2 for "EN" + 1 for blank padding
		ld   [de], a
		
		; byte3+: payload
		inc  de					; Copy "EN" text
		call CopyWord
		
		;
		; Now draw the E-Tank icons, aligned to the right.
		; Because events can't draw tiles from right to left, this needs to calculate
		; the padding length first, draw blank tiles over it, then the E-Tank icons.
		;
		
		; Draw (5 - wETanks) blank tiles from the current location.
		; This will malfunction when wETanks >= 5.
		ld   a, [wETanks]	; C = wETanks
		ld   c, a
		ld   a, $05			; B = 5 - wETanks
		sub  c
		ld   b, a
		ld   a, $70			; A = Tile to draw
	.etPadLoop:
		ld   [de], a
		inc  de
		dec  b
		jr   nz, .etPadLoop
		
		; Draw (wETanks) E-Tank icons from the current location
		ld   a, c
		or   a				; wETanks == 0?
		jr   z, .etDone		; If so, skip
		ld   a, $98			; A = Tile to draw
	.etIcoLoop:
		ld   [de], a
		inc  de
		dec  c
		jr   nz, .etIcoLoop
		
	.etDone:
		xor  a				; Write terminator
		ld   [de], a
		rst  $10 ; Wait tilemap load
		
		;	
		; Delete all sprites except for Rockman and his shots.
		;
		; This is accomplished by clearing OAM, then redrawing the player.
		;
		
		xor  a
		ldh  [hWorkOAMPos], a
		
		; The Rush Marine ride state does not get drawn through Pl_DrawSprMap, and so it gets skipped.
		ld   a, [wPlMode]
		cp   PL_MODE_RM			; Inside Rush Marine?
		jr   z, .skipDraw		; If so, skip
		
		; [POI] The Sakugarne ride state is also skipped, even though it is supported by Pl_DrawSprMap.
		;       Leftover from an earlier iteration, or just a mistake?
		ld   a, [wWpnSGRide]
		or   a					; Riding sakugarne?
		jr   nz, .skipDraw		; If so, skip
		
		call Pl_DrawSprMap
		
	.skipDraw:
		call OAM_ClearRest
		
		;
		; Copy the pause screen graphics for the small bars and weapon text.
		;
		; This happens over 8 frames, while the status bar is being scrolled up (which takes 16 frames),
		; so to minimize graphical corruption, GFX_Pause is laid out in such a way where the graphics
		; that scroll into view earlier are stored earlier (and so are loaded earlier).
		;
		; This could have been avoided entirely by keeping the font graphics always loaded, had
		; the actor art sets been better optimized.
		;
		ld   bc, (BANK(GFX_Pause) << 8) | $20 ; Source GFX bank number + Number of tiles to copy
		ld   hl, GFX_Pause ; Source GFX ptr
		ld   de, $8800 ; VRAM Destination ptr (start of 2nd section)
		call GfxCopy_Req
		
		; Play pause sound
		mPlaySFX SFX_TELEPORTIN	
		
		; Scroll the status bar up 8px at a time until it reaches the top of the screen, while GFX_Pause loads in.
		; The status bar is assumed to be at Y position $80 at the start of the loop, so... 
		ld   b, $10			; B = 16 tiles ($10 * 8 = $80)
		ldh  a, [hLYC]
	.inLoop:
		sub  $08			
		ldh  [hLYC], a		; Move status bar effect target 1 tile up
		ldh  [hWinY], a		; Scroll status bar 1 tile up
		rst  $08 ; Wait Frame
		dec  b				; Are we done?
		jr   nz, .inLoop	; If not, loop
		
		;
		; MAIN LOOP
		;
	.main:
		call Pause_FlashWpnName		; and poll inputs
		; Wait until we press anything we look for
		ldh  a, [hJoyNewKeys]
		and  KEY_DOWN|KEY_UP|KEY_LEFT|KEY_RIGHT|KEY_START|KEY_A
		jr   z, .main
		; A/START: Select weapon
		and  KEY_START|KEY_A		; ## Pressed A or START?
		ld   a, [wWpnId]			; (A = Selected entry)
		jr   nz, .redrawName		; ## If so, skip ahead
		
		; DOWN: Move cursor down
		ldh  a, [hJoyNewKeys]
		rla
		jr   c, .selUp
		; UP: Move cursor up
		rla  
		jr   c, .selDown
		
		; LEFT/RIGHT: Move cursor horizontally.
		; There are only two columns, so this can get away with toggling the lowest bit of the cursor position.
		; Of course, this requires the cursor positions to be ordered left to right, top to bottom.
		ld   a, [wWpnId]
		xor  $01					; Move to other column
		call Pause_CanMoveSel		; Can we move there?
		jr   c, .redrawName			; If so, jump
		jr   .selUp2				; Otherwise, try to move up from there
		
		DEF PAUSESCR_COLS = 2
		DEF PAUSESCR_ROWS = 7
		DEF PAUSESCR_OOB  = WPN_EN+1
	.selUp:
		ld   a, [wWpnId]			; A = wWpnId
	.selUp2:
		; This may need to repeat the check several times, since we move row by row and weapons may not be unlocked.
		; Just in case, a limit to the amount of times it can repeat the check is made, which corresponds to the
		; number of rows - 1.
		ld   b, PAUSESCR_ROWS-1		; B = LoopCount
	.selUpLoop:
		add  PAUSESCR_COLS			; A += 2 (column count)
		cp   PAUSESCR_OOB			; Went out of bounds?
		jr   c, .selUpChk			; If not, skip
		sub  PAUSESCR_OOB			; Otherwise, wrap back to the top
	.selUpChk:
		call Pause_CanMoveSel		; Can we move there?
		jr   c, .redrawName			; If so, jump
		dec  b						; Otherwise, try to move up again
		jr   nz, .selUpLoop			; Reached the loop limit? If not, loop
		jr   .main					; Otherwise, give up and stay at the current location
		
	.selDown:
		; Same thing, but for moving down
		ld   a, [wWpnId]
		ld   b, PAUSESCR_ROWS-1
	.selDownLoop:
		sub  PAUSESCR_COLS
		cp   PAUSESCR_OOB
		jr   c, .selDownChk
		add  PAUSESCR_OOB
	.selDownChk:
		call Pause_CanMoveSel
		jr   c, .redrawName
		dec  b
		jr   nz, .selDownLoop
		jr   .main
		
	.redrawName:
		; Force redraw the current weapon name, in case it's in the middle of flashing.
		; Needed when either moving the cursor or selecting an option.
		; This is the same code used in Pause_FlashWpnName, but simplified.
		push af ; Save new cursor pos
			ld   a, [wWpnId]		; A = wWpnId * 4
			add  a
			add  a
			ld   hl, Pause_BarTbl	; HL = Table base
			ld   b, $00
			ld   c, a
			add  hl, bc				; Seek to entry (starts with vram pointer)
			; bytes0-1: Destination pointer
			ld   de, wTilemapBuf	; DE = Event data buffer
			call CopyWord			; Write the word value, seek pointers ahead
			
			; byte2: Writing mode + Number of bytes to write
			ld   a, $02				; 2 tiles for the weapon name
			ld   [de], a
			inc  de
			
			; byte3+: payload
			call CopyWord			; Copy those tiles
			
			; Write terminator
			xor  a
			ld   [de], a
			
			rst  $10 ; Wait tilemap load
		pop  af ; Restore new cursor pos
		ld   [wWpnId], a		; and apply it
		
		; If we pressed A or START, select the current option
		ldh  a, [hJoyNewKeys]
		and  KEY_START|KEY_A
		jr   nz, .doSel
		; Otherwise return to the main loop
		jr   .main
		
	.doSel:
		ld   a, [wWpnId]
		cp   WPN_EN			; wWpnId < WPN_EN?
		jr   c, .selWpn		; If so, jump (weapon selected)
		
	.selETank:
		;
		; E-TANK SELECTED
		;
		; Removes a tank from the inventory, refills the player's life and returns to the menu's main loop.
		;
		
		; If no tanks are left, don't do anything
		ld   a, [wETanks]
		or   a
		jp   z, .main
		
		; If the player already is at max health, don't do anything
		ld   a, [wPlHealth]
		cp   BAR_MAX
		jp   nc, .main
		
		; Checks passed, perform the refill
		
		; Remove 1 tank from the player
		ld   a, [wETanks]
		dec  a
		ld   [wETanks], a
		
		;
		; Replace the leftmost tank icon with a blank tile
		;
		ld   b, a				; B = wETanks
		ld   hl, wTilemapBuf	; HL = Event buffer
		
		; bytes0-1: Destination pointer
		; $9DF1 is the location in the tilemap of the rightmost E-Tank.
		; Subtract the updated wETanks for the location of the tile to blank.
		ld   a, HIGH($9DF1)
		ldi  [hl], a
		ld   a, LOW($9DF1)
		sub  b					; $9DF1 - wETanks
		ldi  [hl], a
		
		; byte2: Writing mode + Number of bytes to write
		ld   a, $01				; 1 tile
		ldi  [hl], a
		
		; byte3+: payload
		ld   a, $70				; Blank tile ID
		ldi  [hl], a
		
		xor  a					; Write terminator
		ld   [hl], a
		rst  $10 ; Wait tilemap load
		
		;
		; In a loop, refill the player's health 1 bar at a time, until it reaches the max value.
		;
		ld   a, [wPlHealth]
	.healthLoop:
		add  $08				; wPlHealth += 1 bar
		cp   BAR_MAX			; Reached the max value?
		jr   c, .setHealth		; If not, jump
		ld   a, BAR_MAX			; Otherwise, cap it
	.setHealth:
		ld   [wPlHealth], a		; Update health
		
		; Update large health bar
		ld   c, $00
		call Game_AddBarDrawEv
		rst  $18 ; Wait bar update
		
		; Update small health bar
		ld   de, wTilemapBuf
		call Pause_AddBarDrawEv
		rst  $10 ; Wait tilemap load
		
		; Play refill sound
		mPlaySFX SFX_BAR
		
		ld   a, [wPlHealth]
		cp   BAR_MAX			; Reached the max health value?
		jr   c, .healthLoop		; If not, loop
		jp   .main				; Otherwise, we're done
	.selWpn:
		;
		; WEAPON SELECTED
		;
		; Loads in the graphics for the weapon, updates the screen and closes the menu.
		;
		
		;
		; Weapon name
		;
		; As keeping the entire font loaded during gameplay would be a waste, two tiles are reserved for the weapon name.
		; Whenever a new weapon is selected, a subset of the font is copied there, while the tilemap never gets updated.
		;
		
		; Seek to the tile IDs for the font from its Pause_BarTbl entry
		ld   a, [wWpnId]					; A = wWpnId * 4
		add  a
		add  a
		ld   hl, Pause_BarTbl+iPBar_Tiles	; HL = Pause_BarTbl+2
		ld   b, $00							; BC = A
		ld   c, a
		add  hl, bc							; Seek to there
		
		; Copy GFX for the first tile
		ldi  a, [hl]						; A = 1st tile id
		ld   de, $9600						; DE = Destination ptr
		call Pause_CopyFontTileGFX
		
		; Copy GFX for the second tile
		ld   a, [hl]						; A = 2nd tile id
		ld   de, $9610						; DE = Destination ptr
		call Pause_CopyFontTileGFX
		
		;
		; Set the active weapon's ammo if the selected weapon uses ammo.
		; wWpnAmmoCur = wWpnAmmoTbl[wWpnId]
		;
		ld   a, [wWpnId]
		or   a ; WPN_P				; Default weapon selected?
		jr   z, .selDrawBar			; If so, skip
		ld   hl, wWpnAmmoTbl
		ld   b, $00					; Index by wWpnId
		ld   c, a
		add  hl, bc
		ld   a, [hl]				; Read saved ammo
		ld   [wWpnAmmoCur], a		; Save to cache
		
	.selDrawBar:
		;
		; Draw the weapon's ammo bar.
		;
		xor  a						; Just in case
		ld   [wBarQueuePos], a
		ld   a, [wWpnId]
		or   a ; WPN_P				; # Default weapon selected?
		ld   a, [wWpnAmmoCur]		; A = Weapon ammo
		jr   nz, .selBarEv			; # If not, jump
		ld   a, $FF					; Otherwise, A = Value higher than BAR_MAX
									; This will tell Game_AddBarDrawEv to clear the weapon bar with blank tiles.
	.selBarEv:
		ld   c, BARID_WPN			; Draw the weapon bar
		call Game_AddBarDrawEv
		rst  $18 ; Wait bar update
		
		; If a previous weapon bar redraw request was pending, cancel it since it will be outdated
		ld   hl, wStatusBarRedraw
		res  BARID_WPN, [hl]
	
		;
		; If the weapon changed:
		; - Delete all on-screen shots
		; - Reset weapon-related fields
		; - Make any helpers (Rush/Sakugarne) teleport out on the spot
		;
		ld   a, [wWpnId]	; B = New wWpnId
		ld   b, a
	pop  af					; A = Old wWpnId
	cp   b					; Has it changed?
	jr   z, .loadGfx		; If not, skip
	call Wpn_DespawnAllShots
	call Wpn_StartHelperWarp
	
.loadGfx:
	;
	; Load the set of graphics for the selected weapon.
	;
	; Each WPN_* value is mapped to a set of graphics, each being 16 tiles long and getting loaded to $8500-$85FF.
	; All weapon graphics fit into this limit (with multiple weapons being stored on the same set, even), except for the Sakugarne.
	; Therefore, its graphics are split in two. One set is loaded when riding it, the other when not, and so:
	; SetId = wWpnId + wWpnSGRide
	;
	; What this means is the set for the ridden Sakugarne must come immediately after the standalone one.
	; Thankfully, after WPN_SG comes WPN_EN, which is not for a weapon. 
	;
	
	;--
	; HL = Source GFX ptr
	ld   a, [wWpnId]			; Build index
	ld   b, a
	ld   a, [wWpnSGRide]	
	add  b
	
	ld   hl, Pause_WpnGfxPtrTbl	; Get table base
	ld   b, $00
	ld   c, a
	add  hl, bc					; Index it
	
	ld   h, [hl]				; Read high byte
	ld   l, $00					; Low byte is always 0
	;--
	
	ld   de, $8500 ; VRAM Destination ptr
	ld   bc, (BANK(Marker_GFX_Wpn) << 8)|$10 ; BANK $0B ; Source GFX bank number, Number of tiles to copy
	call GfxCopy_Req
	
	mPlaySFX SFX_TELEPORTOUT
	
	;
	; Scroll the status bar down 8px at a time until it reaches the bottom of the screen.
	; Unlike when the status bar was being scrolled up, the enemy GFX cannot be reloaded while doing this,
	; as it'd overwrite the pause screen font while it'd still be visible.
	;
	ld   b, $10			; B = 16 tiles ($10 * 8 = $80)
	ldh  a, [hLYC]
.outLoop:
	add  $08			
	ldh  [hLYC], a		; Move status bar effect target 1 tile down
	ldh  [hWinY], a		; Scroll status bar 1 tile down
	rst  $08 ; Wait Frame
	dec  b				; Are we done?
	jr   nz, .outLoop	; If not, loop
		
	;
	; Reload the top half of the current actor GFX set.
	; Since we know that exactly $20 tiles were overwritten from the top of the art set,
	; we can just load the first $20 tiles.
	;
	ld   a, [wActGfxId]
	ld   hl, ActS_GFXSetTbl	; HL = ActS_GFXSetTbl
	sla  a					; BC = wActGfxId * 2
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	ld   b, [hl]		; B = [byte0] Source GFX bank number
	ld   c, $20			; C = Number of tiles to copy
	inc  hl
	ld   a, [hl]		; HL = [byte1] Source GFX ptr, with low byte hardcoded to $00
	ld   h, a
	ld   l, $00
	ld   de, $8800		; DE = VRAM Destination ptr
	call GfxCopy_Req	; Set up the request and return
	
	rst  $20 ; Wait GFX load
	ret
	
; =============== Pause_CopyFontTileGFX ===============
; Copies a single font tile graphic to the specified location in VRAM.
; IN
; - A: Tile ID
; - DE: VRAM Destination ptr
Pause_CopyFontTileGFX:
	push hl
	
		;--
		; Convert the tile ID to a pointer pointing to its respective graphic within GFX_Pause.
		; Effectively does this, but with some shortcuts:
		; HL = GFX_Pause + ((A - $80) * TILESIZE)
		
		; As usual, this multiplication is done by swapping the nybbles and spreading them across
		; the two bytes the other way around, but it also needs to cap them and add the GFX_Pause base.
		swap a					; Just do it once here
		ld   l, a				; Save that for later
		
		;
		; HIGH BYTE
		;
		
		; Tile IDs for the font are assumed to all be in the $80-$9F range, since that's where GFX_Pause gets loaded to.
		; We're using them as index, so it's preferable to bring them down to $00-$1F by removing the MSB.
		; Since we also need to extract what previously was the high nybble (now swapped to low nybble)
		; into the high byte, we can do both at once by keeping only the lowest 3 bits.
		and  $07
		
		; There's an assumption here.
		; GFX_Pause must stored on a byte boundary that doesn't make it conflict with the index, since it's using
		; "or" rather than "and". In practice, it should be stored on a $200-byte boundary, given it's $200 bytes long.
		ASSERT GFX_Pause % $200 == 0, "GFX_Pause should be stored on a $200 byte boundary"
		or   HIGH(GFX_Pause)	; Add the base value
		ld   h, a
		
		;
		; LOW BYTE
		;
		
		ld   a, l				; Get back the swapped value
		and  $F0				; New high nybble in low byte
		; The same assumption from before applies here.
		; Since GFX_Pause must be aligned to $200 anyway, its low byte will always be $00,
		; so there's no need to either "or" or "and" with $00.
		ld   l, a
		;--
		
		ld   bc, (BANK(GFX_Pause) << 8)|$01 ; BANK $0A ; Source GFX bank number, Number of tiles to copy
		call GfxCopy_Req
		rst  $20 ; Wait GFX load
	pop  hl
	ret
