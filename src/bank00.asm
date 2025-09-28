; =============== RESET VECTOR $00 ===============
; Jump table handler.
; A table of pointers is expected to follow the "rst $00" instruction, which will be indexed using A.
; Execution will jump to the returned pointer. 
; IN
; - A: Index to the pointer table
SECTION "Rst00", ROM0[$0000]
;Rst_DynJump:
	jp   DynJump
	mIncJunk "L000003"
; =============== RESET VECTOR $08 ===============
SECTION "Rst08", ROM0[$0008]
;Rst_EndOfFrame:
	jp   EndOfFrame
	mIncJunk "L00000B"
; =============== RESET VECTOR $10 ===============
SECTION "Rst10", ROM0[$0010]
;Rst_TilemapEv_RunSync:
	jp   TilemapEv_RunSync
	mIncJunk "L000013"
; =============== RESET VECTOR $18 ===============
SECTION "Rst18", ROM0[$0018]
;Rst_TilemapBarEv_RunSync:
	jp   TilemapBarEv_RunSync
	mIncJunk "L00001B"
; =============== RESET VECTOR $20 ===============
SECTION "Rst20", ROM0[$0020]
;Rst_GfxCopyEv_Wait:
	jp   GfxCopyEv_Wait
	mIncJunk "L000023"
; =============== RESET VECTOR $28 ===============
; Not used.
SECTION "Rst28", ROM0[$0028]
	ret
	mIncJunk "L000029"
; =============== RESET VECTOR $30 ===============
; Not used.
SECTION "Rst30", ROM0[$0030]
	ret
	mIncJunk "L000031"
; =============== RESET VECTOR $38 ===============
; Not used.
SECTION "Rst38", ROM0[$0038]
	ret
	mIncJunk "L000039"
; =============== VBLANK INTERRUPT ===============
SECTION "VBlankInt", ROM0[$0040]
	jp   VBlankHandler
	mIncJunk "L000043"
; =============== LCDC/STAT INTERRUPT ===============
SECTION "LCDCInt", ROM0[$0048]
	jp   LCDCHandler
	mIncJunk "L00004B"
; =============== TIMER INTERRUPT ===============
SECTION "TimerInt", ROM0[$0050]
	jp   TimerHandler
	mIncJunk "L000053"
; =============== SERIAL INTERRUPT ===============
; Not used.
SECTION "SerialInt", ROM0[$0058]
	reti
	mIncJunk "L000059"
; =============== JOYPAD INTERRUPT ===============
; Not used.
SECTION "JoyInt", ROM0[$0060]
	reti
	mIncJunk "L000061"
	
SECTION "EntryPoint", ROM0[$0100]
; =============== HW ENTRY POINT ===============
	nop  
	jp   EntryPoint
; =============== GAME HEADER ===============
	; logo
	db   $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	db   $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	db   $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E
	db   " ROCKMAN WORLD2"	; title
	db   $20	; DMG - classic gameboy
	dw   $0000	; new license
	db   $00	; SGB flag: not SGB capable
	db   $01	; cart type: MBC1
	db   $03	; ROM size: 256KiB
	db   $00	; RAM size: 0KiB
	db   $00	; destination code: Japanese
	db   $08	; old license: not SGB capable
	db   $00	; mask ROM version number
	db   $B6	; header check
	dw   $650E	; global check
	
; =============== EntryPoint ===============
EntryPoint:
	; Disable interrupts to prevent VBlank from triggering
	di   
	xor  a
	ldh  [rIE], a
	
	; Turn off the LCD after waiting for VBlank
	ldh  a, [rLCDC]
	set  LCDCB_ENABLE, a
	ldh  [rLCDC], a
.waitVBlank:
	ldh  a, [rLY]
	cp   LY_VBLANK+1
	jr   nz, .waitVBlank
	xor  a
	ldh  [rLCDC], a
	
	; Set stack pointer at the very bottom of WRAM (lower half of wWorkOAM)
	ld   sp, WRAM_End
	
	;
	; Clear all of WRAM ($C000-$DFFF)
	;
	xor  a
	ld   hl, WRAM_Begin
	ld   bc, WRAM_End-WRAM_Begin
.wclrLoop:;R
	ldi  [hl], a
	dec  c
	jr   nz, .wclrLoop
	dec  b
	jr   nz, .wclrLoop
	
	;
	; Clear most of HRAM ($FF80-$FFF7)
	;	
	ld   bc, ($78 << 8) | LOW(HRAM_Begin)
.hclrLoop:
	ldh  [c], a
	inc  c
	dec  b
	jr   nz, .hclrLoop
	
	;
	; Initialize the RNG state on cold boot only.
	; [POI] This accounts for warm boot, but this game doesn't have a soft-reset key combination.
	;
	
	; If hWarmBootFlag already contains $55, assume warm boot
	ld   a, $55
	ld   hl, hWarmBootFlag	; Seek to hWarmBootFlag
	cp   [hl]			; hWarmBootFlag == $55?
	jr   z, .warmBoot		; If so, jump (we never do)
	ld   [hl], a			; Otherwise, write $55 there...
	; ...and reset the RNG state.
	; This sequence being fully blank tells the Rand subroutine to properly seed the LFSR with real values.
	xor  a
	ldh  [hRandSt0], a
	ldh  [hRandSt1], a
	ldh  [hRandSt2], a
	ldh  [hRandSt3], a
.warmBoot:

	; BANK $01 is the default switchable bank, so it gets put into hRomBankLast.
	; Outside of actor processing, which temporarily repoints it to BANK $02,
	; this will not be changed to anything else, so when subroutines restore
	; the last ROM bank loaded, they assume it will point there.
	push af
		ld   a, $01
		ldh  [hRomBankLast], a
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; Copy OAMDMA routine
	ld   c, LOW(hOAMDMA)
	ld   b, OAMDMA_Code.end-OAMDMA_Code
	ld   hl, OAMDMA_Code
.oamCpLoop:
	ldi  a, [hl]
	ldh  [c], a
	inc  c
	dec  b
	jr   nz, .oamCpLoop
	
	call Scroll_Reset	; Reset screen to top-left
	
	xor  a
	ldh  [rSC], a		; Disable serial
	ldh  [rIF], a		; Discard any pending interrupts
	
	; Enable VBlank (obvious) and the Timer (sound driver)
	ld   a, I_VBLANK|I_TIMER
	ldh  [rIE], a
	
	; Enable the screen
	ld   a, LCDC_PRIORITY|LCDC_OBJENABLE|LCDC_WTILEMAP|LCDC_ENABLE
	ldh  [rLCDC], a
	
	; Set up the STAT interrupt to only trigger on LYC.
	; Therefore, toggling I_STAT from rIE will be enough to toggle LYC.
	ld   a, STAT_LYC
	ldh  [rSTAT], a
	
	; Set the lowest possible sound driver speed
	xor  a
	ldh  [rTIMA], a
	ldh  [rTMA], a
	ld   a, rTAC_ON|rTAC_4096_HZ
	ldh  [rTAC], a
	
	; Done setting up
	ei
	jp   Game_Main
	
; =============== OAMDMA_Code ===============
; OAMDMA routine, copied to HRAM at boot.
OAMDMA_Code:
	ld   a, HIGH(wWorkOAM)	; wWorkOAM-$DF9F
	ldh  [rDMA], a			; Send over to OAM
	ld   a, $28				; and wait
.wait:
	dec  a
	jr   nz, .wait
	ret
.end:

; =============== DynJump ===============
; Code for the Rst_DynJump reset vector.
; IN
; - A: Index to the pointer table
; - SP-2: Pointer table
DynJump:
	add  a			; *2 as pointers are words
	pop  hl			; HL = Base address of ptr table; fix stack from rst $00 usage
	ld   e, a		; DE = Offset
	ld   d, $00
	add  hl, de		; Do the indexing
	ldi  a, [hl]	; Read the pointer out to HL
	ld   h, [hl]
	ld   l, a
	jp   hl			; Jump to it
	
; =============== EndOfFrame ===============
; Marks the frame as being finished, and waits for a new one before returning.
EndOfFrame:
	push af
		; Tell VBlank we're done (there's no lag frame)
		ld   a, $01
		ldh  [hFrameEnd], a
		; Wait in a loop until the VBlank handler resets the flag.
		; The loop is due to other interrupts potentially waking us up from the halt.
	.wait:
		halt 
		ldh  a, [hFrameEnd]
		or   a
		jr   nz, .wait
	pop  af
	ret
	
; =============== TilemapEv_RunSync ===============
; Triggers the tilemap write event, and waits in a loop until it has been processed.
; This and the following subroutines all involve VBlank events, so they may wait multiple frames for them to return.
TilemapEv_RunSync:
	push af
		ld   a, $01
		ld   [wTilemapEv], a
	.wait:
		rst  $08 ; Wait Frame
		ld   a, [wTilemapEv]
		or   a
		jr   nz, .wait
	pop  af
	ret

; =============== TilemapBarEv_RunSync ===============
; Triggers the tilemap life/weapon bar redraw event, and waits in a loop until it has been processed.
TilemapBarEv_RunSync:
	push af
		ld   a, $01
		ld   [wTilemapBarEv], a
	.wait:
		rst  $08 ; Wait Frame
		ld   a, [wTilemapBarEv]
		or   a
		jr   nz, .wait
	pop  af
	ret
	
; =============== GfxCopyEv_Wait ===============
; Waits until all of the requested graphics have been copied, if any.
GfxCopyEv_Wait:
	push af
	.wait:
		ld   a, [wGfxEvSrcBank]
		or   a					; Is the event still active?
		jr   z, .done			; If not, we're done
		rst  $08 ; Wait Frame
		jr   .wait
.done:
	pop  af
	ret
	
; =============== Ev_WaitAll ===============
; Waits until every event / screen transfer is finished.
Ev_WaitAll:
	; If all of the transfers are done, return
	xor  a
	ld   hl, wLvlScrollEvMode
	or   [hl]
	ld   hl, wTilemapEv
	or   [hl]
	ld   hl, wTilemapBarEv
	or   [hl]
	ld   hl, wShutterEvMode
	or   [hl]
	ld   hl, wGfxEvSrcBank
	or   [hl]
	ret  z
	; Otherwise, keep wasting frames
	rst  $08 ; Wait Frame
	jr   Ev_WaitAll
	
; =============== VBlankHandler ===============
VBlankHandler:
	push af
	push bc
	push de
	push hl
	
	;
	; Screen Event handlers ("OBJ/VRAM Transfer events")
	;
	
	; Don't even bother executing them unless there's enough time left.
	; Might be in case of the timer interrupt firing right before VBlank.
	ldh  a, [rLY]
	cp   LY_VBLANK		; rLY == $90?
	jr   z, .chkEv		; If so, jump
	cp   LY_VBLANK+1	; rLY == $91?
	jr   z, .chkEv		; If so, jump
	
	; Otherwise, skip ahead
	jp   VBlankHandler_UpdateScreen
	
.chkEv:
	; Update sprites, easy
	call hOAMDMA
	
	;
	; Update VRAM, if needed.
	; There's a whole load of different wats of doing it, but only one can be processed at a time.
	; Given the lack of VBLANK time, some of these are executed across multiple frames.
	;
.chkScroll:
	;
	; STANDARD COLUMN/ROW SCROLLING (what's used during gameplay)
	; Multi-frame.
	;
	
	ld   a, [wLvlScrollEvMode]
	or   a							; Requesting draw for scrolling the screen?
	jr   z, .chkBg					; If not, jump
	
	bit  SCREVB_SCROLLV, a			; Doing vertical scrolling? 
	jr   z, .scrollH				; If not, jump
.scrollV:
	call ScrEv_LvlScrollV
	jp   VBlankHandler_UpdateScreen
.scrollH:
	call ScrEv_LvlScrollH
	jp   VBlankHandler_UpdateScreen
	
.chkBg:
	;
	; TILEMAP WRITE, generic.
	; Instant.
	;
	ld   a, [wTilemapEv]
	or   a							; Enabled?
	jr   z, .chkBarBg				; If not, jump
	
	ld   de, wTilemapBuf
	call LoadTilemapDef
	
	xor  a
	ld   [wTilemapEv], a
	jp   VBlankHandler_UpdateScreen
	
.chkBarBg:
	;
	; TILEMAP WRITE, for redrawing the large life/weapon bars.
	; Instant.
	;
	ld   a, [wTilemapBarEv]
	or   a							; Enabled?
	jr   z, .chkShut				; If not, jump
	
	ld   de, wTilemapBarBuf
	call LoadTilemapDef
	
	xor  a
	ld   [wBarQueuePos], a		; Signal out there's no bar to draw
	ld   [wTilemapBarEv], a
	jp   VBlankHandler_UpdateScreen
	
.chkShut:
	;
	; BOSS SHUTTER EFFECT
	;
	; This is a special effect performed on the tilemap.
	; Unlike others, while seemingly multi-frame to the player, it will actually only write
	; a 1x2 strip at a time before turning itself off, and as such needs to be manually set.
	;
	; Part of the reason this is the case is due to the shutter animation being slow, with
	; updates happening every few frames, which the game uses to sneak in GFX load requests
	; for the boss graphics.
	;
	ld   a, [wShutterEvMode]
	or   a ; SHUTTER_NONE	; No shutter mode active?
	jr   z, .chkGfxCp		; If so, nothing to do here
	cp   SHUTTER_CLOSE		; Shutter closing?
	jr   z, .shutClose		; If so, jump
							; Otherwise, it's opening (SHUTTER_OPEN)
.shutOpen:
	;
	; When opening the shutter, the background tiles "behind" need to be revealed.
	; This is accomplished in a very simple way, by copying a 2x1 strip to the left
	; of the shutter and pasting it over.
	;
	; This allows repeating patterns, like in Metal Man's stage, to look correct.
	; Worth noting that the initial wShutterBGPtr is the bottom-left tile of block
	; the player's origin was colliding with when the shutter was activated.
	;

	; Read 2x1 strip to the left of the tilemap.
	ld   a, [wShutterBGPtr_Low]		; Read ptr to tilemap
	ld   l, a
	ld   a, [wShutterBGPtr_High]
	ld   h, a
	ldi  a, [hl]					; Read out the two tiles to DE
	ld   d, a
	ldd  a, [hl]
	ld   e, a
	
	;--
	; Seek to the tilemap two tiles to the right to move over the closed shutter.
	; This is slightly involved due to having to account for horizontal looping.
	; The same exact thing is done later when preparing the tilemap pointer for .shutClose.

	; Save the base row pointer elsewhere (no h offset)
	ld   a, l			
	and  $100-BG_TILECOUNT_H ; $E0
	ld   b, a
	; Seek 2 tiles right, looping the offset if needed
	ld   a, l
	add  $02
	and  BG_TILECOUNT_H-1 ; $1F
	; Merge with base row pointer & save
	or   b
	ld   l, a
	;--
	
	; Write the two tiles over the shutter
	ld   a, d
	ldi  [hl], a
	ld   a, e
	ldd  [hl], a
	
	; Next time the effect is triggered, do it for the row above.
	ld   a, [wShutterBGPtr_Low]
	sub  BG_TILECOUNT_H
	ld   [wShutterBGPtr_Low], a
	ld   a, [wShutterBGPtr_High]
	sbc  $00
	ld   [wShutterBGPtr_High], a
	
	; Effect done
	xor  a
	ld   [wShutterEvMode], a
	
	jp   VBlankHandler_UpdateScreen
	
.shutClose:

	;
	; When closing the shutter, all we need is writing hardcoded shutter tiles while moving down.
	; 

	; Unlike .shutOpen, the tilemap pointer does point directly to where the shutter should be
	; drawn, so there's no horizontal looping to handle. 
	; Code at Shutter_MovePlR already moved us 2 tiles to the right, but it did *not* move us
	; vertically, meaning we need to pre-increment this pointer.
	; So, seek down by 1 row!
	ld   a, [wShutterBGPtr_Low]
	add  BG_TILECOUNT_H
	ld   [wShutterBGPtr_Low], a
	ld   l, a
	ld   a, [wShutterBGPtr_High]
	adc  $00
	ld   [wShutterBGPtr_High], a
	ld   h, a
	
	; Write the shutter tiles
	ld   a, TILEID_SHUTTER_L
	ldi  [hl], a
	ld   a, TILEID_SHUTTER_R
	ldd  [hl], a
	
	; Effect done
	xor  a
	ld   [wShutterEvMode], a
	
	jp   VBlankHandler_UpdateScreen
	
.chkGfxCp:
	;
	; GFX COPY
	; 4 tiles/frame
	;
	; These operations are started by requesting one through GfxCopy_Req.
	;
	ld   a, [wGfxEvSrcBank]
	or   a								; Enabled?
	jr   z, VBlankHandler_UpdateScreen	; If not, jump (no VRAM transfers)
	ld   [MBC1RomBank], a				; Switch to the GFX bank
	
	; HL = Source GFX pointer
	ld   a, [wGfxEvSrcPtr_Low]
	ld   l, a
	ld   a, [wGfxEvSrcPtr_High]
	ld   h, a
	
	; DE = Destination VRAM pointer
	ld   a, [wGfxEvDestPtr_Low]
	ld   e, a
	ld   a, [wGfxEvDestPtr_High]
	ld   d, a
	
	; B = Tiles to copy.
	;     This is 4 at most, and the amount processed is subtracted from the remaining count.
	ld   b, $04							; B = Max tiles copied
	ld   a, [wGfxEvTilesLeft]			; A = Remaining total tiles
	cp   $05							; Is it > 4?
	jr   nc, .gfxLeftGt4				; If so, process 4 and update the total left
.gfxLeftMax4:
	ld   b, a							; Otherwise, process all that's left
	xor  a								; LEFT = 0
	ld   [wGfxEvSrcBank], a
.gfxLeftGt4:
	ld   a, [wGfxEvTilesLeft]			; LEFT -= 4
	sub  b
	ld   [wGfxEvTilesLeft], a
	
	;
	; Copy the tiles over
	;
.gfxCpLoop:
	ld   c, TILESIZE
.tileCpLoop:
	ldi  a, [hl]
	ld   [de], a
	inc  de
	dec  c
	jr   nz, .tileCpLoop
	dec  b
	jr   nz, .gfxCpLoop
	
	;
	; Write back the updated source/dest ptrs to continue where we left off next frame.
	;
	ld   a, l
	ld   [wGfxEvSrcPtr_Low], a
	ld   a, h
	ld   [wGfxEvSrcPtr_High], a
	ld   a, e
	ld   [wGfxEvDestPtr_Low], a
	ld   a, d
	ld   [wGfxEvDestPtr_High], a
	
	; Restore main bank
	ldh  a, [hRomBank]
	ld   [MBC1RomBank], a
	
VBlankHandler_UpdateScreen:
	;
	; Update BG scroll position
	;
	ldh  a, [hScrollY]
	ldh  [rSCY], a
	ldh  a, [hScrollX]
	ldh  [rSCX], a
	
	;
	; Update WINDOW scroll position ("lower half", typically the status bar)
	;
	ldh  a, [hWinY]
	cp   SECT_DISABLE	; Is it enabled?
	jr   z, .noWin		; If not, disable the layer outright
.setWin:
	ldh  [rWY], a		; Sync pos
	ldh  a, [hWinX]
	ldh  [rWX], a
	ldh  a, [rLCDC]		; Enable WINDOW
	or   LCDC_WENABLE
	ldh  [rLCDC], a
	jr   .setPal
.noWin:
	ldh  a, [rLCDC]		; Disable WINDOW
	and  $FF^LCDC_WENABLE
	ldh  [rLCDC], a
	
.setPal:
	;
	; Sync palettes
	;
	ldh  a, [hBGP]
	ldh  [rBGP], a
	ldh  a, [hOBP0]
	ldh  [rOBP0], a
	ldh  a, [hOBP1]
	ldh  [rOBP1], a
	
	; Since we're (basically) at the top of the screen now, re-enable sprites.
	; They were previously disabled by LCDCHandler to make the status bar cover everything.
	ldh  a, [rLCDC]
	or   LCDC_OBJENABLE
	ldh  [rLCDC], a
	
.chkSect:
	;
	; Update LYC trigger for setting up some of the status bar effects.
	; This is usually set to the same value as hWinY.
	;
	ldh  a, [hLYC]
	cp   SECT_DISABLE	; Is the scanline number set?
	jr   z, .noLyc		; If not, disable the LYC interrupt
.setLyc:
	ldh  [rLYC], a		; Set scanline trigger
	; Setting I_STAT is enough to enable/disable LYC since rSTAT is initialized to STAT_LYC
	; and never ever changes.
	ldh  a, [rIE]		; Enable scanline trigger
	or   I_STAT			
	ldh  [rIE], a
	jr   .getJoyKeys
.noLyc:
	ldh  a, [rIE]		; Disable scanline trigger
	and  $FF^I_STAT
	ldh  [rIE], a
	
.getJoyKeys:
	;
	; Poll for Joypad input.
	;
	
	; Get the directional key status
	ld   a, HKEY_SEL_DPAD
	ldh  [rJOYP], a
	ldh  a, [rJOYP]		; Stabilize the inputs
	ldh  a, [rJOYP]
	cpl  				; Reverse the bits as the hardware marks pressed keys as '0'. We need the opposite.
	and  $0F			; ----DULR | Only use the actual keypress values (stored in the lower nybble)
	swap a				; DULR----
	ld   b, a			; Save to B
	
	; Reset
	ld   a, HKEY_SEL_BTN
	ldh  [rJOYP], a
	
	; Get the button status
	ldh  a, [rJOYP]		; Stabilize the inputs
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	ldh  a, [rJOYP]
	cpl
	and  $0F			; ----SCBA
	; Merge the nybbles
	or   b				; DULRSCBA
	ldh  [hJoyKeysRaw], a
	
	; Reset
	ld   a, HKEY_SEL_BTN|HKEY_SEL_DPAD
	ldh  [rJOYP], a
	
	; For (presumably?) performance reason, VBlank does not actually set the actual hJoyKeys/hJoyNewKeys values.
	; Code that needs to poll for inputs must manually call JoyKeys_Refresh to sync those values.

.end:
	; Tick global timer
	ld   hl, hTimer
	inc  [hl]
	
	; We're done, a new frame can start
	xor  a
	ldh  [hFrameEnd], a
	
	pop  hl
	pop  de
	pop  bc
	pop  af
	reti
	
; =============== LCDCHandler ===============
; LCDC interrupt, reserved to handle some of the status bar properties.
LCDCHandler:
	push af
		; [POI] This is intended to set the X position of the status bar,
		;       however it does nothing since that is drawn on the WINDOW layer.
		ldh  a, [hScrollX2]
		ldh  [rSCX], a
		; Use fixed palette
		ld   a, $E4
		ldh  [rBGP], a
		; Hide sprites since the status bar should be on top of everything.
		; This has the effect of cutting off sprites that partially overlap with it.
		ldh  a, [rLCDC]
		and  $FF^LCDC_OBJENABLE
		ldh  [rLCDC], a
	pop  af
	reti
	
; =============== TimerHandler ===============
; Timer interrupt, which is reserved to the sound driver.
TimerHandler:
	push af
	push bc
	push de
	push hl
		; Don't alter hRomBank to save on some stack usage
		ld   a, BANK(L074000) ; BANK $07
		ld   [MBC1RomBank], a
		call L074000
		ldh  a, [hRomBank]
		ld   [MBC1RomBank], a
	pop  hl
	pop  de
	pop  bc
	pop  af
	reti
	
; =============== GFXSet_Load ===============
; Loads a set of graphics and wipes the tilemaps clean.
;
; Each has a specific palette assigned, as well as custom code
; used for uploading graphics to VRAM.
;
; After calling the subroutine, typically you'd want to load in
; the tilemaps as needed (ie: passing them to LoadTilemapDef).
;
; IN
; - A: Set ID (GFXSET_*)
GFXSet_Load:
	;
	; Stop the screen first, since we're going to write a bunch to VRAM.
	;
	push af
		call OAM_ClearAll	; Start fresh, deleting any old sprites
		rst  $08 ; Wait Frame, to visually see the sprites being gone
		call StopLCDOperation ; Only then stop the screen
	pop  af
	
	;
	; Apply the color palette.
	;
	push af
		; Index .palTbl by scene ID
		add  a				; Each entry is 4 bytes long
		add  a
		ld   hl, .palTbl	; Seek to .palTbl[A]
		ld   b, $00
		ld   c, a
		add  hl, bc
		
		; Apply the entry's palettes
		ldi  a, [hl]	; byte0 - BG Palette
		ldh  [hBGP], a
		ldi  a, [hl]	; byte1 - OBJ Palette 0
		ldh  [hOBP0], a
		ldi  a, [hl]	; byte2 - OBJ Palette 1
		ldh  [hOBP1], a
	pop  af
	
	;
	; Run the set-specific GFX loader code
	;
	call .exec
	
	;
	; With the GFX loaded, clear the tilemaps using the first blank tile found.
	;
	jp   ClearTilemaps
	
; =============== .palTbl ===============
; Palettes associated with each set of graphics.	
.palTbl:
	;     BG ,OBJ0,OBJ1, PAD
.set0: db $E4, $E4, $E4, $00 ; GFXSET_TITLE
.set1: db $E4, $1C, $C4, $00 ; GFXSET_STAGESEL
.set2: db $E4, $1C, $C4, $00 ; GFXSET_PASSWORD
.set3: db $E4, $1C, $C4, $00 ; GFXSET_LEVEL (Gets overwritten by Lvl_InitSettings / Lvl_PalTbl)
.set4: db $E4, $E4, $E4, $00 ; GFXSET_GETWPN
.set5: db $E4, $1C, $E4, $00 ; GFXSET_CASTLE
.set6: db $E4, $1C, $E4, $00 ; GFXSET_STATION
.set7: db $E4, $E4, $E4, $00 ; GFXSET_GAMEOVER
.set8: db $1B, $1C, $E4, $00 ; GFXSET_SPACE

; =============== .exec ===============
; Jump table to set-specific init code.
; IN
; - A: Set ID (GFXSET_*)
.exec:
	rst  $00 ; DynJump
	dw LoadGFX_Title       ; GFXSET_TITLE
	dw LoadGFX_StageSel    ; GFXSET_STAGESEL
	dw LoadGFX_Password    ; GFXSET_PASSWORD
	dw LoadGFX_Level       ; GFXSET_LEVEL
	dw LoadGFX_GetWpn      ; GFXSET_GETWPN
	dw LoadGFX_WilyCastle  ; GFXSET_CASTLE
	dw LoadGFX_WilyStation ; GFXSET_STATION
	dw LoadGFX_GameOver    ; GFXSET_GAMEOVER
	dw LoadGFX_Space       ; GFXSET_SPACE
	
; =============== LoadGFX_Title ===============
LoadGFX_Title:
	push af
		ld   a, BANK(GFX_TitleCursor) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_TitleCursor	; HL = Source ptr
	ld   de, $8000				; DE = Destination ptr
	ld   bc, $0080				; BC = Bytes to copy
	call CopyMemory				; Go!
	
	ld   hl, GFX_Title
	ld   de, $9000
	ld   bc, $0800
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== LoadGFX_StageSel ===============	
LoadGFX_StageSel:
	push af
		ld   a, BANK(GFX_Password) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; This copies $800 bytes starting from GFX_Password.
	; This effectively loads:
	; - GFX_Password for the borders/backdrop
	; - GFX_Title_Dots & GFX_TitleCursor, which are useless but are in the way
	; - GFX_StageSel, containing the cursor and the boss portraits.
	ASSERT GFX_StageSel - GFX_Password == $300, "GFX_StageSel is required to be $300 bytes after GFX_Password"
	
	; On top of that, even though there's only one tile used for sprites before the boss loads in,
	; that whole set gets loaded twice for both OBJ and BG.

	ld   hl, GFX_Password
	ld   de, $8000			; For OBJ
	ld   bc, $0800
	call CopyMemory
	
	ld   hl, GFX_Password
	ld   de, $9000			; For BG
	ld   bc, $0800
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== LoadGFX_Password ===============	
LoadGFX_Password:
	push af
		ld   a, BANK(GFX_Password) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; Loads in $100 bytes more than intended.
	; This makes it load GFX_TitleCursor, which isn't necessary.
	ld   hl, GFX_Password
	ld   de, $9000
	ld   bc, $0300
	call CopyMemory
	
	push af
		ld   a, BANK(GFX_SmallFont) ; BANK $09
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_SmallFont
	ld   de, $9400
	ld   bc, $0200
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== LoadGFX_Level ===============
; GFX loader for levels.
; This is an unique one, as it needs to load different graphics depending on the current level.
LoadGFX_Level:
	
	;
	; First, load the player graphics.
	; These are always at GFX_Player, but for some reason, its pointer is defined 
	; in the actor art set table, as its first entry.
	;
	ld   hl, ActS_GFXSetTbl		; Seek to first table entry
	push af
		ldi  a, [hl]			; Read bank number ($0B), seek to high byte of art pointer
		ldh  [hRomBank], a		
		ld   [MBC1RomBank], a	; Bankswitch
	pop  af
	
	ld   a, [hl]				; HL = Source ptr (GFX_Player)
	ld   h, a
	ld   l, $00
	ld   de, $8000				; DE = Destination ptr (1st section)
	ld   bc, $0800				; BC = Bytes to copy
	call CopyMemory
	
	;
	; Load the level graphics.
	; These are defined in a separate table using the same format as ActS_GFXSetTbl,
	; except they are indexed by level ID and these graphics are $500 bytes long.
	;
	ld   hl, Lvl_GFXSetTbl		; HL = Table base ptr
	ld   a, [wLvlId]			; BC = wLvlId * 2
	sla  a
	ld   b, $00
	ld   c, a
	add  hl, bc					; Index it
	
	push af
		ldi  a, [hl]			; Read bank number (byte0)
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a	; Bankswitch
	pop  af
	
	ld   a, [hl]				; Read ptr high byte (byte1)
	ld   h, a
	ld   l, $00					; Low byte is hardcoded $00
	ld   de, $9000				; DE = Destination ptr (3rd section)
	ld   bc, $0500				; BC = Bytes to copy
	call CopyMemory
	
	;
	; Load shared graphics (status bar, ...)
	;
	push af
	ld   a, BANK(GFX_BgShared) ; BANK $0A
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, GFX_BgShared
	ld   de, $9500
	ld   bc, $0300
	call CopyMemory
	
	; We're done, restore the default bank
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== LoadGFX_GetWpn ===============
LoadGFX_GetWpn:
	push af
		ld   a, BANK(GFX_GetWpn) ; BANK $0B
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   hl, GFX_GetWpn
	ld   de, $9000
	ld   bc, $0800
	call CopyMemory
	
	push af
		ld   a, BANK(GFX_SmallFont) ; BANK $09
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   hl, GFX_SmallFont
	ld   de, $8C00
	ld   bc, $0200
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== LoadGFX_WilyCastle ===============
LoadGFX_WilyCastle:
	push af
		ld   a, BANK(GFX_SpaceOBJ) ; BANK $0C
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_SpaceOBJ
	ld   de, $8000
	ld   bc, $0800
	call CopyMemory
	
	ld   hl, GFX_WilyCastle
	ld   de, $8800
	ld   bc, $1000
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== LoadGFX_WilyCastle ===============
LoadGFX_WilyStation:
	push af
		ld   a, BANK(GFX_WilyStation) ; BANK $0C
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_WilyStation
	ld   de, $8800
	ld   bc, $1000
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== LoadGFX_WilyCastle ===============
LoadGFX_GameOver:
	push af
		ld   a, BANK(GFX_NormalFont) ; BANK $0B
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_NormalFont
	ld   de, $8400
	ld   bc, $0200
	call CopyMemory
	
	ld   hl, GFX_NormalFont
	ld   de, $9400
	ld   bc, $0200
	call CopyMemory
	
	push af
		ld   a, BANK(GFX_Unused_HexFont) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; [TCRF] Why is this being loaded on the game over screen ... ?
	
	ld   hl, GFX_Unused_HexFont
	ld   de, $8600
	ld   bc, $0200
	call CopyMemory
	
	ld   hl, GFX_Unused_HexFont
	ld   de, $9600
	ld   bc, $0200
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== LoadGFX_Space ===============
LoadGFX_Space:
	push af
		ld   a, BANK(Marker_GFX_Wpn) ; BANK $0B
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; This copies $800 bytes starting from Marker_GFX_Wpn, to loads all weapon sets at once.
	; What we actually need though are some graphics scattered here and there:
	; - Rush Marine's sprite from GFX_Wpn_RcWdHa, which is reused as a spaceship...
	; - ...with a few altered tiles stored within GFX_Wpn_Rj.
	; - The explosion in GFX_Wpn_MeNe, which is also used when the ground explodes during
	;   the Wily Castle cutscene.
	ASSERT GFX_Wpn_RcWdHa-Marker_GFX_Wpn == $000, "GFX_Wpn_RcWdHa should at the same location as Marker_GFX_Wpn"
	ASSERT GFX_Wpn_Rm-Marker_GFX_Wpn     == $100, "GFX_Wpn_Rm should be $100 bytes from Marker_GFX_Wpn"
	ASSERT GFX_Wpn_MeNe-Marker_GFX_Wpn   == $700, "GFX_Wpn_MeNe should be $700 bytes from Marker_GFX_Wpn"
	ld   hl, Marker_GFX_Wpn
	ld   de, $8800
	ld   bc, $0800
	call CopyMemory
	
	push af
		ld   a, BANK(GFX_SpaceOBJ) ; BANK $0C
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_SpaceOBJ
	ld   de, $8000
	ld   bc, $0800
	call CopyMemory
	
	ld   hl, GFX_Space
	ld   de, $9000
	ld   bc, $0800
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== FlashBGPal ===============
; Flashes the BG palette 8 times, every 2 frames.
; This takes exclusive control for 32 frames.
FlashBGPal:
	; In a loop, flash between $D8 and $E4, ending with the latter when we return.
	; This does not keep track or restore the existing palette, instead it relies on the 
	; default BG palette being basically always $E4 (see GFXSet_Load.palTbl).
	ld   b, $08		; B = Flashes remaining
.loop:
	ld   a, $D8		; Flash palette
	ldh  [hBGP], a
	rst  $08 		; Wait 2 frames
	rst  $08
	ld   a, $E4		; Restore palette
	ldh  [hBGP], a
	rst  $08		; Wait 2 frames
	rst  $08
	dec  b			; Are we done?
	jr   nz, .loop	; If not, loop
	ret
	
; =============== FlashBGPalLong ===============
; Randomly flashes the BG palette for 9 seconds every 4 frames, taking exclusive control.
; Exclusively used by the Wily Castle cutscene.
FlashBGPalLong:
	ld   c, $09		; For 9 seconds...
.loop:
	ld   b, 60		; For each frame...
.secLoop:
	push bc
		
		; Every 4 frames...
		ldh  a, [hTimer]
		and  $03			; hTimer % 4 != 0?
		jr   nz, .wait		; If so, skip
		
		; ... 1/8 chance of flashing the palette
		ld   b, $E4			; B = Normal palette
		call Rand			; A = Rand()
		cp   $20			; A >= $20?
		jr   nc, .setPal	; If so, skip
		ld   b, $C0			; B = Flashed palette
	.setPal:
		ld   a, b			; Update the BG palette
		ldh  [hBGP], a
		
	.wait:
		rst  $08 ; Wait Frame
	pop  bc
	dec  b					; Second ticked down?
	jr   nz, .secLoop		; If not, jump
	dec  c					; All seconds ticked down?
	jr   nz, .loop			; If not, jump
	ret
	
; =============== GfxCopy_Req ===============
; Requests a GFX copy operation to be performed starting from the next VBlank.
; IN
; -  C: Number of tiles to copy
; -  B: Source GFX bank number
; - HL: Source GFX ptr
; - DE: VRAM Destination ptr
GfxCopy_Req:
	ld   a, l
	ld   [wGfxEvSrcPtr_Low], a
	ld   a, h
	ld   [wGfxEvSrcPtr_High], a
	ld   a, e
	ld   [wGfxEvDestPtr_Low], a
	ld   a, d
	ld   [wGfxEvDestPtr_High], a
	ld   a, c
	ld   [wGfxEvTilesLeft], a
	ld   a, b
	ld   [wGfxEvSrcBank], a
	ret

; =============== OAM_ClearAll ===============
; Zeroes out the entirety of the OAM mirror.
OAM_ClearAll:
	ld   hl, wWorkOAM
	ld   bc, OAM_SIZE
	jr   ZeroMemory
	
; =============== OAM_ClearRest ===============
; Zeroes out the remaining/unused part of the OAM mirror.
OAM_ClearRest:
	; Don't do anything if it's filled
	ldh  a, [hWorkOAMPos]
	cp   OAM_SIZE			; Pointing to the end of WorkOAM?
	ret  z					; If so, return
	
	; Otherwise, clear memory from (wWorkOAM+hWorkOAMPos) to (hWorkOAMPos+OAM_SIZE)
	ld   l, a				; HL = Starting address
	ld   h, HIGH(wWorkOAM)
.loop:
	xor  a					; A = Byte to write
	ldi  [hl], a			; Clear first OBJ byte only (that's enough to disable the sprite), seek to next
	inc  l					; Skip to next entry
	inc  l
	inc  l
	ld   a, l
	cp   OAM_SIZE			; Reached the end of WorkOAM?
	jr   c, .loop			; If not, loop
	ret
	
; =============== ZeroMemory ===============
; Zeroes out the specified memory range.
; IN
; - HL: Starting address
; - BC: Number of bytes
ZeroMemory:
	xor  a
	ldi  [hl], a		; Clear address, seek to next
	dec  bc				; BytesLeft--
	ld   a, b
	or   c				; BytesLeft != 0?
	jr   nz, ZeroMemory	; If so, loop
	ret

; =============== ClearTilemaps ===============
; Clears the BG and WINDOW tilemaps using the first blank tile found.
ClearTilemaps:
	; Since we're wiping them clear...
	call Scroll_Reset
	
	;
	; Find the first fully blank tile (all 0s), from tile $00 to $7F.
	; This makes the subroutine "just work" regardless of whatever graphics are stored in VRAM,
	; and without having to pass in a tile ID manually.
	;
	ld   de, $9000		; HL = Ptr to tile graphics
	ld   c, $00			; C = Respective tile ID
.loop:

	; If the first byte of the tile is non-zero, it's not blank (don't waste time on the loop)
	ld   a, [de]		; Read first byte
	or   a				; Is the it non-zero?
	jr   nz, .seekNext	; If so, jump
	
	; Otherwise, check every byte of the tile.
	ld   l, e			; So copy it to HL
	ld   h, d
	ld   b, TILESIZE	; B = Bytes to check
.tcLoop:
	ldi  a, [hl]		; Read byte
	or   a				; != 0?
	jr   nz, .seekNext	; If so, it's not blank
	dec  b				; Checked all bytes?
	jr   nz, .tcLoop	; If not, loop
	
	;--
	;
	; Found a blank tile!
	; Overwrite all tilemaps with it.
	;
.found:
	ld   e, c			; E = Blank tile ID
.clrTilemaps:
	ld   hl, BGMap_Begin				; HL = Destination ptr
	ld   bc, WINDOWMap_End-BGMap_Begin	; BC = Bytes to write
.clrLoop:
	ld   a, e
	ldi  [hl], a		; Write blank tile, DestPtr++
	dec  bc				; BytesLeft--
	ld   a, b
	or   c				; Overwrote everything?
	jr   nz, .clrLoop	; If not, loop
	ret
	;--
	
.seekNext:
	; Tile isn't blank, seek to the next.
	; TileId++
	inc  c				
	; VramPtr += TILESIZE
	ld   a, e			
	add  TILESIZE
	ld   e, a
	ld   a, d
	adc  $00
	ld   d, a
	
	; If we haven't found any blank tile between $9000-$9800,
	; peter out by using tile ID $80 ($8800).
	cp   HIGH(Tiles_End)	; Reached the end of the GFX area?
	jr   nz, .loop			; If not, continue searching
	ld   e, $80
	jr   .clrTilemaps
	
; =============== CopyMemory ===============
; Copies the specified amount of bytes from the source to the destination.
; IN
; - HL: Source ptr
; - DE: Destination ptr
; - BC: Bytes to copy
CopyMemory:
	ldi  a, [hl]	; Read src, Src++
	ld   [de], a	; Write to dest
	inc  de			; Dest++
	dec  bc			; BytesLeft--
	ld   a, b
	or   c				; Copied everything?
	jr   nz, CopyMemory	; If not, jump
	ret
	
; =============== Scroll_Reset ===============
; Resets the screen coordinates.
Scroll_Reset:
	; Disable the WINDOW and screen split
	ld   a, SECT_DISABLE
	ldh  [hWinY], a
	ldh  [hWinX], a
	ldh  [hLYC], a
	ldh  [hScrollX2], a
	; Reset viewport to top-left corner
	xor  a
	ldh  [hScrollX], a
	ldh  [hScrollY], a
	ret
	
; =============== StartLCDOperation ===============
; Enables the screen output.
StartLCDOperation:
	ldh  a, [rLCDC]
	or   LCDC_ENABLE
	ldh  [rLCDC], a
	ret
	
; =============== StopLCDOperation ===============
; Disables the screen output in a safe way.
;
; This will wait for VBlank before stopping the LCD.
StopLCDOperation:
	ldh  a, [rIE]		; Backup the interrupt enable flag
	ldh  [hIE], a	
	
	res  IB_VBLANK, a	; Prevent the VBlank interrupt from triggering
	ldh  [rIE], a
.waitVBlank:
	ldh  a, [rLY]		; Wait for it...
	cp   LY_VBLANK+1
	jr   nz, .waitVBlank
	
	ldh  a, [rLCDC]		; Disable the LCD
	res  LCDCB_ENABLE, a
	ldh  [rLCDC], a
	
	ldh  a, [hIE]		; Restore VBlank interrupt
	ldh  [rIE], a
	ret
	
; =============== LoadTilemapDef ===============
; Applies one or more chained tilemaps definitions (TilemapDef) to VRAM. 
; These are applied all at once in a single frame, so if processing them over a period
; of time is wanted (akin to the GFX event), that needs to be manually done by
; writing to the buffer only a single command.
;
; IN
; - DE: Ptr to one or more TilemapDef stored in sequence, terminated by a null byte.
LoadTilemapDef:
	
	; A null byte marks the end of the TilemapDef list
	ld   a, [de]
	or   a
	ret  z
	
	; bytes0-1: Destination pointer
	ld   h, a		; High byte first
	inc  de
	ld   a, [de]	; Low byte next
	ld   l, a
	inc  de
	
	; byte2: Writing mode + Number of bytes to write
	;        FORMAT: DRCCCCCC
	;        - C: Number of bytes to write ($00-$3F)
	;        - R: Repeat mode (if clear, <C> bytes should be copied from src to dest;
	;                          if set, the next byte should be repeated <C> tiles)
	;        - D: Writing direction (if clear, Right; if set, Down)
	
	; B = Number of bytes to write
	ld   a, [de]
	and  $3F
	ld   b, a
	
	; A = Writing flags
	; To simplify the if/else chain, these will be >> 6'd to the bottom
	ld   a, [de]		
	inc  de
	rlca
	rlca 
	and  $03			; Filter out count bits
	
	; byte3+: payload
	
	;
	; Which writing mode are we using?
	;
.chkModeMR:
	; BG_MVRIGHT, BG_NOREPEAT
	jr   nz, .chkModeRR	; Mode == 0? If not, jump
.loop0:
	ld   a, [de]		; A = Byte from src
	ldi  [hl], a		; Write to dest, seek ptr right
	inc  de				; SrcPtr++
	dec  b				; Are we done?
	jr   nz, .loop0		; If not, loop
	jr   LoadTilemapDef	; Otherwise, process the next TilemapDef
	
.chkModeRR:
	; BG_MVRIGHT, BG_REPEAT
	dec  a				; Mode == 1?
	jr   nz, .chkModeMD	; If not, jump
	ld   a, [de]		; A = Single byte from src to repeat
	inc  de				; SrcPtr++
.loop1:
	ldi  [hl], a		; Write to dest, seek ptr right
	dec  b				; Are we done?
	jr   nz, .loop1		; If not, loop
	jr   LoadTilemapDef	; Otherwise, process the next TilemapDef
	
.chkModeMD:
	; BG_MVDOWN, BG_NOREPEAT
	dec  a				; Mode == 2?
	jr   nz, .chkMode3	; If not, jump
.loop2:
	ld   a, [de]		; A = Byte from src
	ld   [hl], a		; Write to dest
	inc  de				; SrcPtr++
	;--
	ld   a, b			; Seek tilemap pointer down 1 row 
		ld   bc, BG_TILECOUNT_H
		add  hl, bc
	ld   b, a
	;--
	dec  b				; Are we done?
	jr   nz, .loop2		; If not, loop
	jr   LoadTilemapDef	; Otherwise, process the next TilemapDef
	
.chkMode3:
	; BG_MVDOWN, BG_REPEAT
.loop3:
	ld   a, [de]		; A = Read same byte from src (could have been done outside the loop)
	ld   [hl], a		; Write to dest
	;--
	ld   a, b			; Seek tilemap pointer down 1 row 
		ld   bc, BG_TILECOUNT_H
		add  hl, bc
	ld   b, a
	;--
	dec  b				; Are we done?
	jr   nz, .loop3		; If not, loop
	inc  de				; DestPtr++ now that the repeat is done
	jr   LoadTilemapDef	; Next TilemapDef
	
; =============== Unused_WaitSeconds ===============
; [TCRF] Unreferenced code.
; Delays execution for a number of seconds.
; IN
; - A: Number of seconds to wait
Unused_WaitSeconds: 
	push af
		ld   a, 60
		call WaitFrames
	pop  af
	dec  a
	jr  nz, Unused_WaitSeconds
	ret
	
; =============== WaitFrames ===============
; Delays execution for a number of frames.
; IN
; - A: Number of frames to wait
WaitFrames:
	rst  $08 ; Wait Frame
	dec  a
	jr   nz, WaitFrames
	ret
	
; =============== JoyKeys_Refresh ===============
; Updates the joypad input fieds from the updated polled value.
JoyKeys_Refresh:
	ldh  a, [hJoyKeysRaw]	; B = Polled keys the current frame
	ld   b, a
	
	ldh  a, [hJoyKeys]		; A = Previously held keys
	xor  b					; Delete keys held both frames...
	and  b					; ...and keep the new ones only
	ldh  [hJoyNewKeys], a	; Update new keys
	
	ld   a, b				
	ldh  [hJoyKeys], a		; Copy the polled value directly to hJoyKeys
	ret
	
; =============== Rand ===============
; Generates a random number.
;
; This uses a 32bit LFSR, with the output value being the topmost byte.
; Each time this subroutine is called, 8 bits are shifted in from the left, which
; produces an entirely new number.
;
; OUT
; - A: Random number
Rand:
	push hl
	push de
	push bc
	
		; If all four bytes are zeroed out, seed them
		ld   hl, hRandSt0
		ldi  a, [hl]		; hRandSt0 ...
		or   [hl]			; & hRandSt1 ...
		inc  hl
		or   [hl]			; & hRandSt2 ...
		inc  hl
		or   [hl]			; & hRandSt3 == 0?
		call z, .init		; If so, seed them
		
		;--
		; Shift the 32bit value left 8 times.
		;
		; Specifically, each iteration is done by rotating in sequence the individual bytes to the left,
		; with the shifted out MSB getting shifted back in the LSB of the next byte...
		ld   b, $08			; For each bit...
	.loop:
		
		; ... but there's still something missing. Which bit gets shifted in the lowest byte?
		; That's calculated based on the previous output (hRandSt0, the topmost byte):
		; A = MSB(((hRandSt0 << 3) ^ hRandSt0) << 1)
		ld   hl, hRandSt0
		ld   a, [hl]		
		sla  a
		sla  a
		sla  a
		xor  [hl]
		sla  a
		; One last << 1 to shift the MSB into the carry, ready to be rotated
		sla  a
		
		; Rotate the 32bit value left, from lowest to high bit.
		ld   hl, hRandSt3
		rl   [hl]
		dec  hl
		rl   [hl]
		dec  hl
		rl   [hl]
		dec  hl
		rl   [hl]
		
		dec  b				; Done for all 8 bits?
		jr   nz, .loop		; If not, loop
		;--
		
		; The output value is now fully shifted out, return it.
		ld   a, [hl]	; A = hRandSt0
	pop  bc
	pop  de
	pop  hl
	ret
.init:
	ld   a, $48
	ldh  [hRandSt0], a
	ld   a, $49
	ldh  [hRandSt1], a
	ld   a, $52
	ldh  [hRandSt2], a
	ld   a, $4F
	ldh  [hRandSt3], a
	ret
	
; =============== Unused_Mul8 ===============
; [TCRF] Unreferenced code.
; Performs multiplication with an 8-bit multiplicand.
; IN
; - E: Multiplicand 
; - D: Multiplier
; OUT
; - DE: Result
Unused_Mul8:
	push af
	push hl
	push bc
		; Multiplication performed through looped addition
		ld   hl, $0000	; Result = 0
		ld   c, d		; C = Loop count (Multiplier)
		ld   d, $00		; DE = Value added (Multiplicand, with high byte $00)
	.loop:
		ld   a, c
		or   a			; Are we done?
		jr   z, .done	; If so, jump
		add  hl, de		; Result += Multiplicand
		dec  c			; LoopCount--
		jr   .loop		; Check again
	.done:
		ld   e, l		; DE = Result
		ld   d, h
	pop  bc
	pop  hl
	pop  af
	ret
	
; =============== Unused_Mul16 ===============
; [TCRF] Unreferenced code.
; Performs multiplication with a 16-bit multiplicand.
; IN
; - DE: Multiplicand 
; - A: Multiplier
; OUT
; - DE: Result
Unused_Mul16:
	push hl
	push bc
		ld   hl, $0000	; Result = 0
		ld   c, a		; C = Loop count (Multiplier)
	.loop:
		ld   a, c
		or   a			; Are we done?
		jr   z, .done	; If so, jump
		add  hl, de		; Result += Multiplicand
		dec  c			; LoopCount--
		jr   .loop		; Check again
	.done:
		ld   e, l		; DE = Result
		ld   d, h
	pop  bc
	pop  hl
	ret  

; =============== Lvl_LoadData ===============
; Loads all of the data for the currently selected level.
Lvl_LoadData:
	push af
		ld   a, BANK(Lvl_LayoutPtrTbl) ; BANK $05
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	;
	; LEVEL LAYOUT
	;
	; This is compressed using RLE, and once decompressed it takes up $A00 bytes.
	; In the same archive, it packs:
	; - Actual level layout ($800 bytes)
	;   This is a straight 256x8 level map, taking up $800 bytes uncompressed.
	;   The entire level is loaded all at once and the data is read/ordered as-is.
	;   This has a few implications:
	;   - There's no hard concept of rooms loading their own layout data
	;   - Room transitions simply work by warping the player to another point of the same map.
	; - Actor layout ($200 bytes)
	;   Split into two $100 tables, all indexed by column number.
	;   The first contains the Y position & nospawn flag of the actor, while the second one
	;   has a mix of Actor IDs and GFX set IDs.
	;   A few notes:
	;   - The X position isn't stored anywhere here.
	;     Instead, the index to the actor layout represents the column number, and the actor is spawned at its center.
	;     This means there can be at most one actor/column.
	;     Actors that don't want to spawn at the center of the column have their init code adjust the position.
	;   - The game determines if a given entry is for a GFX set ID
	;     by checking for the respective value in the first table to be 0. 
	;   - The nospawn flag is always set to 0 in the compressed data, otherwise the actor wouldn't load.
	;     In RAM, this helps to avoid respawning on-screen actors or to permanently delete actors (see below)
	;     
	
	; DE = Ptr to compressed level layout data
	ld   a, [wLvlId]
	ld   hl, Lvl_LayoutPtrTbl 	; BANK $05
	ld   b, $00					; BC = wLvlId * 2
	sla  a
	ld   c, a
	add  hl, bc
	ldi  a, [hl]	; Read ptr out to DE
	ld   e, a
	ld   a, [hl]
	ld   d, a
	
	; Decompress it to wLvlLayout.
	; The RLE format takes advantage of how the decompressed data never has the MSB set, allowing for some shortcuts.
	; The bytes are read in sequence, and:
	; - If the MSB isn't set, the current byte is copied directly to the destination.
	; - If the MSB is set, the next byte is repeated <current byte> times.
	;
	; These is no explicit length to this data, instead decompression ends when moving
	; outside the buffer.
	
	ld   hl, wLvlLayout
.nextCmdL:
	ld   a, [de]		; Read command byte
	inc  de				; SrcPtr++
	bit  7, a			; Is the MSB set?
	jr   nz, .repL		; If so, it's a repeated copy
.uncL:
	ldi  [hl], a		; Otherwise, it's a raw byte. Copy it as-is, DestPtr++
	jr   .chkEndL
.repL:
	and  $7F			; Filter out MSB
	ld   b, a			; B = Repeat count
	ld   a, [de]		; Read single byte
	inc  de				; SrcPtr++
.repLoopL:
	ldi  [hl], a		; Copy the same byte over, DestPtr++
	dec  b				; Done the repeated copy?
	jr   nz, .repLoopL	; If not, loop it
.chkEndL:
	ld   a, h
	cp   HIGH(wLvlLayoutDecode_End)			; Reached the end?
	jr   c, .nextCmdL
	
	
.restPerm:
	;
	; PERMADESPAWNS
	;
	; The nospawn flag for actors starts out as 0, is set when one spawns, and normally unset when one despawns.
	; This prevents actors that are currently on-screen from being reloaded, any actor with the nospawn flag set
	; is skipped.
	;
	; There wouldn't need to be anything else to do if that was it but some actors, like 1UPs, need to permanently
	; despawn once collected. This is accomplished by them despawning without clearning the nospawn flag.
	; However, when the level reloads after the player has died, the actor layout is fully reset, and so are the nospawn flags.
	;
	; To enforce permadespawns, the nospawn data is also stored into a separate buffer, which is applied after the level loads.
	; If this is the first time we load the level however, that's not necessary -- moreover, that memory range is dirty and 
	; needs to be wiped clean.
	;
	ld   a, [wPlRespawn]
	or   a							; Reloading after player death?
	jr   nz, .loadPerm				; If so, jump
.initPerm:
	xor  a							; Otherwise, initialize the table
	ld   hl, wActDespawnTbl
	ld   bc, $0100
	call ZeroMemory
	jr   .loadBlocks
.loadPerm:
	; Merge the entirety of wActDespawnTbl into the live table at wActLayoutFlags. 
	ld   l, $00						; For each byte...
.loopColl:
	ld   h, HIGH(wActDespawnTbl)	; B = Backup
	ld   b, [hl]
	ld   h, HIGH(wActLayoutFlags) 	; A = Live
	ld   a, [hl]
	or   b							; Merge backup nospawn flag
	ld   [hl], a					; Save back to main
	inc  l							; Restored all $100?
	jr   nz, .loopColl				; If not, loop
	
.loadBlocks:
	;
	; 16x16 BLOCK DEFINITIONS
	;
	; These define, for every block, the four 8x8 tiles they use.
	;
	; This data is stored uncompressed in a table indexed by level ID, where each entry
	; is $100 bytes long (enough space for defining $40 blocks).
	;
	ld   a, [wLvlId]		; BC = wLvlId * $100
	ld   b, a
	ld   c, $00
	ld   hl, Lvl_BlockTbl 	; BANK $05
	add  hl, bc				; Seek to the block table entry
	ld   de, wLvlBlocks
	ld   bc, $0100
	call CopyMemory			; Copy it over
	
	;--
	
	;
	; The remainder of the level data is all stored (in the ROM, at least) in a way that uses 1 byte for each room.
	; Rooms in this game are simply groups of 10 columns (the horizontal width of a screeen) starting from the leftmost one.
	;
	; As the level width is fixed, so is the max number of rooms in a level ($19), therefore, given the same level ID,
	; the offsets to each set of data are the same.
	;
	; Instead of using pointer tables, a single table at Lvl_RoomColOffsetTbl is used containing multiples of the room count.
	; When indexed by level ID, it will return said offset for each of the tables.
	; (of course, it would have been better to push/pop the offset instead of always recalculating it...)
	;
	
	; OUT
	; - DE: Data offset
	MACRO mGetLvlOffset
		ld   hl, Lvl_RoomColOffsetTbl	; HL = Base table
		ld   a, [wLvlId]
		add  a							; BC = wLvlId * 2
		ld   b, $00
		ld   c, a
		add  hl, bc						; Seek to entry
		ld   e, [hl]					; Read out offset value to DE
		inc  hl
		ld   d, [hl]
	ENDM
	
	;
	; SCROLL LOCKS (UNPACK)
	;
	; Marks which screens the camera is free to scroll towards.
	; While this data is stored in RAM at wLvlScrollLocks on a per-column basis ($00 -> no scroll, $80 -> scroll),
	; in the ROM it has a granularity of half a room.
	;
	; Specifically, it's packed into $19 bytes, with byte mapping to a single room.
	; Of that byte, only two bits are used: bit1 for the left side, bit0 for the right.
	;
	
	; DE = Ptr to scroll lock data
	mGetLvlOffset				; DE = Data offset
	ld   hl, Lvl_ScreenLockTbl	; BANK $05
	add  hl, de					; Seek to level scroll data
	ld   e, l					; DE = HL
	ld   d, h
	
	; Unpack the data to RAM
	ld   hl, wLvlScrollLocks	; HL = Starting address
	ld   b, $19					; B = Rooms left
.lockLoop:						; For each byte...

	; LEFT SIDE
	ld   a, [de]		; Read byte
	rrca 				; shift bit1 to bit0
	rrca 				; shift bit0 to bit7
	and  $80			; Remove other bits
	REPT ROOM_COLCOUNT/2	
		ldi  [hl], a	; Apply it for the left half of the room
	ENDR
	
	; RIGHT SIDE
	ld   a, [de]		; Reread same byte
	rrca 				; shift bit0 to bit7
	and  $80			; Remove other bits
	REPT ROOM_COLCOUNT/2	
		ldi  [hl], a	; Apply it for the right half of the room
	ENDR
	
	inc  de				; SrcPtr++
	dec  b				; Done for all rooms?
	jr   nz, .lockLoop	; If not, loop
	
	;
	; SCREEN LOCKS (RAW)
	;
	; This will be later used to determine the player's spawn position on the current room.
	;
	mGetLvlOffset					; DE = Data offset
	ld   hl, Lvl_ScreenLockTbl
	add  hl, de
	ld   de, wLvlScrollLocksRaw
	ld   bc, $0019
	call CopyMemory
	
	;
	; ROOM TRANSITIONS (UPWARDS)
	;
	; For each room, a target room ID is defined when performing a transition to the room above.
	; These can only be performed by climbing up a ladder.
	;
	; It's always possible to perform transitions at any point, it's up to the level designer
	; to include ladders that allow doing one.
	;
	mGetLvlOffset
	ld   hl, Lvl_RoomTrsUTbl		
	add  hl, de
	ld   de, wRoomTrsU
	ld   bc, $0019
	call CopyMemory
	
	;
	; ROOM TRANSITIONS (DOWNWARDS)
	;
	; Like above, but when moving down. Ladders aren't even required here.
	;
	; As with upwards transitions, it's always possible to do them at any point of any room, 
	; here doubly so since you don't need to be on a ladder. 
	; It's up to the level designer to restrict it with solid blocks or (invisible) spikes.
	;
	; Worth noting that there isn't a real concept of pits either. To kill the player instead
	; of triggering the transition, spikes need to be manually placed on the bottom row.
	; Spikes placed there have special behavior that instakills the player regardless of
	; invulnerability status, to really prevent the transition from being triggered.
	;
	mGetLvlOffset
	ld   hl, Lvl_RoomTrsDTbl
	add  hl, de
	ld   de, wRoomTrsD
	ld   bc, $0019
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== Lvl_InitSettings ===============
; Initializes additional level properties.
Lvl_InitSettings:
	
	;
	; LEVEL PALETTE (ANIMATION)
	;
	; Overrides the fixed palette loaded by GFXSET_LEVEL.
	;
	; Each level has two palettes assigned, to allow for simple palette animations.
	; This is always enabled -- levels which don't use it merely define two identical palettes.
	;
	
	ld   a, [wLvlId]	; HL = Lvl_PalTbl[wLvlId * 2]
	add  a
	ld   hl, Lvl_PalTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	ldi  a, [hl]		; Read 1st pal
	ldh  [hBGP], a
	ldh  [hBGPAnim0], a
	ld   a, [hl]		; Read 2nd pal
	ldh  [hBGPAnim1], a
	
	;
	; AIR MAN's stage is hardcoded to use BG priority,
	; to make the clouds appear in front.
	;
	ld   b, $00
	ld   a, [wLvlId]
	cp   LVL_AIR
	jr   nz, .setBGPri
	ld   b, SPR_BGPRIORITY
.setBGPri:
	ld   a, b
	ld   [wPlSprFlags], a
	
	;
	; WATER SUPPORT
	;
	; Levels that don't have any water disable this to save on processing time.
	;
	ld   a, [wLvlId]	; wLvlWater = Lvl_WaterFlagTbl[wLvlId]
	ld   hl, Lvl_WaterFlagTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [wLvlWater], a
	
	;
	; STATUS BAR POSITION
	;
	ld   a, $80
	ldh  [hLYC], a		; Set status bar at the bottom
	ldh  [hWinY], a		; ""
	xor  a
	ldh  [hScrollX2], a	; Not necessary
	ld   a, $07
	ldh  [hWinX], a		; Docked to the left
	ret
	
; =============== Lvl_DrawFullScreen ===============
; Draws the entire visible screen to the tilemap, as well as setting the current position within the level.
Lvl_DrawFullScreen:

	;
	; The main constraint here is that the following need to be consistent with each other:
	; 1) The position of the blocks within the grid (ScrEv_DrawLvlBlock)
	; 2) Block IDs being used
	; 3) Current level position, for collision (wLvlColL)
	;    This MUST point to the leftmost column currently visible (*not* the tilemap)
	;
	; The screen is drawn starting from 2 blocks to the left of the current room,
	; to account for the seam position when redrawing the screen during horizontal scrolling.
	; This influences both #1 and #2, which need to be subtracted by 2.
	;
	
	;--
	;
	; #1 POSITION OF BLOCKS
	;
	; Calculate to DE the tilemap grid offsets from the current scroll position.
	; Effectively the scroll position divided by the block's width/height.
	;
	; Note that while the code here accounts for the screen positions being potentially anything,
	; in practice, since the scroll is always reset when we get here, they will always be:
	; - wTargetRelY: 0
	; - wTargetRelX: -2
	;
	
	; X GRID OFFSET
	; wTargetRelX = (hScrollX / 16) - 2
	ldh  a, [hScrollX]
	sub  $20			; 2 blocks behind
	swap a				; / $10
	and  $0F			; ""
	ld   [wTargetRelX], a
	
	; Y GRID OFFSET
	; wTargetRelY = hScrollY / 16
	ldh  a, [hScrollY]
	swap a
	and  $0F
	ld   [wTargetRelY], a
	;--
	
	;
	; #2 BLOCK IDS USED
	;
	; Seek HL to the first block in the room, minus 2.
	;
	
	; Since we're starting from the first row, just find the column associated with the current room.
	ld   hl, Lvl_RoomColTbl
	ld   a, [wLvlRoomId]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	; While we're here, set the un-offsetted value as the current level position.
	ld   [wLvlColL], a 		
	; Start from 2 blocks behind, as above
	dec  a
	dec  a
	; Index the level layout using that.
	ld   hl, wLvlLayout	; HL = Level layout
	ld   b, $00			; BC = Room offset
	ld   c, a
	add  hl, bc
	
	;
	; Draw the blocks in a loop, left to right, top to bottom.
	;
	; Due to the specific level width used ($100 blocks), which fits exactly into a byte,
	; moving down a block can be accomplished by just incrementing the high byte of the pointer.
	;
	ld   d, $00			; For each row...
.loopRow:
	ld   e, $00			; For each block in the row...
.loopBlk:
	push hl ; Save base level layout ptr
	
		; HL = Ptr to current block ID
		add  hl, de
		
		; Calculate the final 16x16 grid position for the current block.
		push de
			; Y POSITION = (wTargetRelY + D) & $0F
			ld   a, [wTargetRelY]		; Read base offset (always 0)
			add  d				; Add row iteration
			and  $0F			; Enforce valid range
			ld   d, a
			; X POSITION = (wTargetRelX + E) & $0F
			ld   a, [wTargetRelX]		; Read base offset (always -2)
			add  e				; Add col iteration
			and  $0F			; Enforce valid range
			ld   e, a
			
			ld   a, [hl]		; A = Block ID
			call ScrEv_DrawLvlBlock
		pop  de	
	pop  hl
	
	inc  e				; Move 1 block right
	ld   a, e
	cp   $0E			; Drawn all 14 blocks in the row?
	jr   nz, .loopBlk	; If not, loop
	inc  d				; Move 1 block down
	ld   a, d
	cp   $08			; Drawn all 8 rows?
	jr   nz, .loopRow	; If not, draw the next one
	
	; Finally, draw the base status bar tilemap.
	; Its values will be drawn later.
	ld   de, TilemapDef_StatusBar
	jp   LoadTilemapDef
	
	
DEF EDGECOL = 2                                      ; Offscreen offset
DEF EDGE_L = BLOCK_H * EDGECOL                       ; LvlScroll_DrawEdgeL
DEF EDGE_R = SCREEN_GAME_H + BLOCK_H * (EDGECOL - 1) ; LvlScroll_DrawEdgeR | - 1 due to SCREEN_GAME_H contributing

; =============== LvlScroll_DrawEdgeL ===============
; Redraws the left seam of the screen when scrolling left.
; Triggered when the viewport passes a block boundary (wLvlColL decremented).
; It also spawns actors residing in the new column.
; See also: LvlScroll_DrawEdgeR
LvlScroll_DrawEdgeL:

	;
	; Determine the initial grid offset for the left edge of the screen.
	;
	; The seam is at the 2nd column before the left edge of the screen (-2).
	; It's not the column immediately to the left (-1) as that would make the seam visible;
	; this affects how subroutines that end up drawing a full screen (ie: Lvl_DrawFullScreen)
	; as they need to draw 1 block off-screen in both directions due to the seam position.
	;
	; See also: ScrEv_LvlScrollH.
	;
	

	; X GRID OFFSET
	; hScrEvOffH = (hScrollX / 16) - 2
	ldh  a, [hScrollX]
	sub  EDGE_L				; 2 blocks to the left
	swap a					; / $10
	and  $0F				; ""
	ldh  [hScrEvOffH], a
	
	; LEVEL LAYOUT PTR (low byte)
	; Thanks to the fixed level width of $100 blocks, this is just the
	; column number - 2.
	ld   a, [wLvlColL]
	sub  EDGECOL
	ldh  [hScrEvLvlLayoutPtr_Low], a
	
	; Y GRID OFFSET
	; hScrEvOffV = hScrollY / 16
	ldh  a, [hScrollY]		; Just the top of the viewport
	swap a					; / $10
	and  $0F				; ""
	ldh  [hScrEvOffV], a
	
	; LEVEL LAYOUT PTR (high byte)
	; Topmost row, so always at $C0xx.
	ld   a, HIGH(wLvlLayout)
	ldh  [hScrEvLvlLayoutPtr_High], a
	
	; Trigger event
	ld   a, $01
	ld   [wLvlScrollEvMode], a
	
	;
	; Spawn the actor if one is defined on the new column.
	;
	
	; The offset to the actor layout data is low byte of the level layout pointer.
	; This is due to its format, where each column can only have one actor assigned
	; to it, and levels always are $100 blocks in width, a convenient number.
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	ld   l, a
	; Spawn the actor horizontally centered on the column (hence the +8)
	ld   b, -EDGE_L + $08
	call ActS_SpawnColEdge		; Try to spawn if one's in here
	
	;
	; Spawn the actor coming from the other (right) side of the screen, if one is defined.
	; This is from the same "main" column used by the other routine, LvlScroll_DrawEdgeR.
	;
	; The actor that would be spawned really is defined on the opposite column,
	; but it only spawns when the screen is scrolled away due to actor being
	; flagged with ACTLB_SPAWNBEHIND.
	;
	
	; The base actor layout offset points to two columns behind the leftmost border.
	; To seek to two columns *after* the *rightmost* border...
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	add  SCREEN_GAME_BLOCKCOUNT_H + EDGECOL * 2	; Width of the screen + (Left edge + Right edge)
	ld   l, a
	; The actor position is relative to the screen and not to the left edge,
	; so it doesn't have to multiply EDGECOL by 2.
	ld   b, (SCREEN_GAME_H + (EDGECOL * BLOCK_H)) - $08 ; Width of the screen + Right edge (centered to prev block)
	jp   ActS_SpawnColEdgeBehind
	
; =============== LvlScroll_DrawEdgeR ===============
; Redraws the right seam of the screen when scrolling right.
; Triggered when the viewport passes a block boundary (wLvlColL incremented).
; It also spawns actors residing in the new column.
LvlScroll_DrawEdgeR:

	;
	; Determine the initial grid offset for the right edge of the screen.
	;
	; The seam is at the 2nd column after the right edge of the screen (11), for the same reason
	; mentioned in LvlScroll_DrawEdgeL.
	;
	; Effectively this has the same offsets as LvlScroll_DrawEdgeL except the other way around,
	; so it necessitates a few logic changes.
	;
	
	; X GRID OFFSET
	; hScrEvOffH = (hScrollX / 16) + 11
	ldh  a, [hScrollX]
	add  EDGE_R	; 2 blocks to the right of the right border
	swap a							; / $10
	and  $0F						; ""
	ldh  [hScrEvOffH], a
	
	; LEVEL LAYOUT PTR (low byte)
	; Thanks to the fixed level width of $100 blocks, this is just the
	; column number + 11.
	ld   a, [wLvlColL]
	add  (SCREEN_GAME_BLOCKCOUNT_H - 1) + EDGECOL
	ldh  [hScrEvLvlLayoutPtr_Low], a
	
	; Y GRID OFFSET
	; hScrEvOffV = hScrollY / 16
	ldh  a, [hScrollY]				; Just the top of the viewport
	swap a							; / $10
	and  $0F						; ""
	ldh  [hScrEvOffV], a
	
	; LEVEL LAYOUT PTR (high byte)
	; Topmost row, so always at $C0xx.
	ld   a, HIGH(wLvlLayout)
	ldh  [hScrEvLvlLayoutPtr_High], a
	
	; Trigger event
	ld   a, $01
	ld   [wLvlScrollEvMode], a
	
	;
	; Spawn the actor if one is defined on the new column.
	;
	
	; Actor layout offset is the low byte of the level layout ptr, as is
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	ld   l, a
	; Horizontally center on the column
	ld   b, EDGE_R + $08
	call ActS_SpawnColEdge
	
	;
	; Spawn the actor coming from the other (left) side of the screen, if one is defined.
	; This is from the same "main" column used by the other routine, LvlScroll_DrawEdgeL.
	;
	
	; The base actor layout offset points to the 2nd column after the right border.
	; To seek to two columns *before* the *leftmost* border...
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	sub  SCREEN_GAME_BLOCKCOUNT_H + EDGECOL * 2
	; The actor position is relative to the screen and not to the left edge,
	; so it doesn't have to multiply EDGECOL by 2.
	ld   l, a	; L = NewCol - 14
	ld   b, -(EDGECOL * BLOCK_H) + $08
	jp   ActS_SpawnColEdgeBehind
	
; =============== ScrEv_LvlScrollH ===============
; Updates the tilemap for horizontal scrolling during gameplay,
; by drawing 2 blocks at a time across 4 frames.
ScrEv_LvlScrollH:
	; HL = Pointer to level layout
	ldh  a, [hScrEvLvlLayoutPtr_High]
	ld   h, a
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	ld   l, a
	; E = Horizontal offset in 2x2 grid
	ldh  a, [hScrEvOffH]
	ld   e, a
	; D = Vertical offset in 2x2 grid
	ldh  a, [hScrEvOffV]
	ld   d, a
	; B = Number of blocks to draw
	ld   b, $02
.loop:
	; Draw blocks in a loop
	push hl
	push de
	push bc
		ld   a, [hl]			; A = Block ID
		call ScrEv_DrawLvlBlock
	pop  bc
	pop  de
	pop  hl
	
	inc  h		; Seek down by 1 block
	;--
	; [POI] Does not account for the vertical offset wrapping around.
	inc  d		; Seek down to next vertical offset
	;--
	dec  b
	jr   nz, .loop
	
	; Save the updated struct source and vertical offset
	ld   a, h
	ldh  [hScrEvLvlLayoutPtr_High], a
	ld   a, d
	ldh  [hScrEvOffV], a
	
	; To cover draw an entire vertical column, this process should be repeated 4 times.
	; Keep in mind wLvlScrollEvMode is initialized to $01, so this loop is indeed taken 4 times,
	; which matches with the gameplay screen's height (2 * 4 = 8, SCREEN_GAME_BLOCKCOUNT_V)
	ld   hl, wLvlScrollEvMode
	inc  [hl]					; LoopCount++
	ld   a, [hl]
	cp   $04+1					; Looped 4 times yet?
	ret  nz						; If not, return
	xor  a						; Otherwise, the event is over
	ld   [hl], a
	ret
	
; =============== ScrEv_DrawLvlBlock ===============
; Draws a 16x16 level block to the specified location in the tilemap.
;
; This treats the entire BG tilemap as a fixed grid of 16x16 block as the parameters get multiplied by 2,
; and as such it's not possible to write a block across grid boundaries.
;
; IN
; - A: Block ID
; - D: Vertical offset ($00-$0F)
; - E: Horizontal offset ($00-$0F)
ScrEv_DrawLvlBlock:

	;
	; Save the four tile IDs the block uses to a temporary location.
	;
	sla  a						; Index = BlockId * 4	
	sla  a
	ld   h, HIGH(wLvlBlocks)	; Seek to block def
	ld   l, a
	ldi  a, [hl]				; Copy the entry elsewhere
	ld   [wTmpTileIdUL], a
	ldi  a, [hl]
	ld   [wTmpTileIdDL], a
	ldi  a, [hl]
	ld   [wTmpTileIdUR], a
	ld   a, [hl]
	ld   [wTmpTileIdDR], a
	
	;
	; Calculate the destination ptr to the tilemap based on the given offsets.
	; HL = ScrEv_BGStripTbl[D * 2] + (E * 2)
	;
	
	; BC = Base to tilemap strip (left corner)
	; Tilemap strip pointers are already 2 tiles apart vertically, so the result
	; doesn't need to get multiplied by 2...
	ld   hl, ScrEv_BGStripTbl	; HL = Table base
	ld   a, d					; BC = D * 2 | ...but the table offset *does*, as we're indexing a ptr table
	sla  a
	ld   b, $00
	ld   c, a
	add  hl, bc			; Index it
	ldi  a, [hl]		; Read out ptr to BC
	ld   c, a
	ld   a, [hl]
	ld   b, a
	; Add the horizontal offset to this pointer.
	ld   a, e			; C += E * 2
	sla  a
	add  c
	ld   c, a
	; Move to HL
	ld   l, c			
	ld   h, b
	
	;
	; Perform the tilemap writes.
	;
	
	; Write the upper half of the block
	ld   a, [wTmpTileIdUL]
	ldi  [hl], a
	ld   a, [wTmpTileIdUR]
	ld   [hl], a
	
	; Seek down down 1 row
	ld   bc, BG_TILECOUNT_H-1
	add  hl, bc
	
	; Write the lower half
	ld   a, [wTmpTileIdDL]
	ldi  [hl], a
	ld   a, [wTmpTileIdDR]
	ld   [hl], a
	ret
	
; =============== Game_StartRoomTrs ===============
; This subroutine handles the initial setup for vertical screen transitions.
Game_StartRoomTrs:

	;
	; Levels in this game are maps 256 blocks (columns) wide and 8 blocks (rows) tall, loaded all at once.
	;
	; This makes room transitions different compared to other NES/GB games, since there isn't any more 
	; data to load. Therefore, all they do at a base level is warping the player to another point in 
	; the same map.
	;
	; However, to cut down on the number of unique warps, this game does use a different concept
	; of "rooms", namely groups of 10 columns (which is the gameplay screen's width) starting from
	; the leftmost one.
	;
	; When moving vertically, there are two sets of room transitions defined, one for each vertical
	; direction, indexed by room ID.
	; These can point to completely arbitrary rooms, allowing for infinite loops, one-sided transitions 
	; or side-paths, but none of the levels pull these tricks off.
	;
	; Note that there's no special behavior when moving horizontally.
	;
	
	;
	; Pick the appropriate transition table & settings depending on which direction we're scrolling to
	;
	; Initial properties:
	; - hScrEvLvlLayoutPtr_High: Starting location for reading blocks
	; - HL: Room transition table
	; - E: Target for drawing tiles, relative to the vertical scroll position
	;
	ld   a, [wScrollVDir]
	or   a					; Scrolling up? (SCROLLV_UP)
	jr   z, .optU			; If so, jump
.optD:
	ld   a, HIGH(wLvlLayout)		; When scrolling down, the blocks are read from top to bottom
	ldh  [hScrEvLvlLayoutPtr_High], a
	ld   hl, wRoomTrsD
	ld   e, SCREEN_GAME_V ; $80 ; Right below the screen
	jr   .getRoomNum
.optU:
	ld   a, HIGH(wLvlLayout_End-1)	; When scrolling up, the blocks are read from bottom to top
	ldh  [hScrEvLvlLayoutPtr_High], a
	ld   hl, wRoomTrsU
	ld   e, -BLOCK_TILECOUNT_V * TILE_H ; $E0 ; Right above the screen
	
	;
	; Calculate the room ID.
	; Note that Room ID $00 is not used and kept blank, with $0A being the starting column.
	;
	; A = Room ID (wLvlColL / $0A)
	;
.getRoomNum:
	ld   b, $00
	ld   a, [wLvlColL]
.divLoop:
	cp   ROOM_COLCOUNT
	jr   c, .divDone
	inc  b
	sub  ROOM_COLCOUNT
	jr   .divLoop
.divDone:
	ld   a, b
	
	; Use the room ID to index the transition table and save the result to wLvlRoomId...
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [wLvlRoomId], a
	
	; ...and use that to get the associated starting column off a precalculated table.
	ld   hl, Lvl_RoomColTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [wLvlColL], a
	
	;
	; Determine the starting settings needed for updating the tilemap:
	; - Source column to read the tiles from
	; - Destination offsets for the block grid
	;   Unlike the horizontal scroll code that has an hard dependency on ScrEv_DrawLvlBlock,
	;   it's not required to use block grid offsets (which are /2 compared to normal ones),
	;   but for consistency we do and the event code expects them.
	;
	; These are easily calculated from the current column & scroll positions.
	;
	
	; The horizontal location is offset by -1, to draw one more column to the left of the screen,
	; since columns that close aren't redrawn when scrolling left.
	; This needs to affect both hScrEvLvlLayoutPtr_Low and hScrEvOffH to avoid inconsistencies between
	; the visible tilemap and actual level collision.
	dec  a					; Move one column left
	ldh  [hScrEvLvlLayoutPtr_Low], a
	
	; Horizontal block grid offset.
	; hScrEvOffH = (hScrollX - $10) / $10
	ldh  a, [hScrollX]
	sub  $10				; Move one column left
	swap a					; This divides the scroll by $10, the width of a block in pixels
	and  $0F				; Delete garbage in upper nybble
	ldh  [hScrEvOffH], a
	
	; Vertical block grid offset.
	; This should point to one of the two vertical edges of the screen.
	; hScrEvOffV = (hScrollY + E) >> 4
	ldh  a, [hScrollY]		; Start from top-left pos of gameplay screen
	add  e					; Add vertical offset to get edge
	swap a
	and  $0F
	ldh  [hScrEvOffV], a
	
	; Reset vertical transition counter, in preparation of calling Game_DoRoomTrs
	xor  a
	ldh  [hTrsRowsProc], a
	; [BUG] wWpnHaFreezeTimer should be reset too, to prevent it from aborting the transition early.
	;       Aborting the vertical transitions can't break the level or actor layout given everything
	;       is loaded at once, but what it *does* do is keep a bad hScrollY value.
	;       Horizontal scrolling does not account for it, and if the screen is scrolled in such a way
	;       that the tilemap wraps around vertically, you'll be using out of bounds tilemap row pointers
	;       which are all $FFFF and corrupt HRAM, leading to broken sound and eventually a freeze caused
	;       by writing to $FFFF itself.
	
	; Immediately start a request to load any new actor graphics, if any
	call ActS_ReqLoadRoomGFX
	
	; Fall-through

; =============== Game_CalcCurLvlCol ===============
; Recalculates the column the player is currently on.
Game_CalcCurLvlCol:

	;
	; Get column count, relative to the left edge of the screen.
	; Effetively the player's relative X position / column width in pixels.
	;

	; Account for the hardware offset.
	; Since other subroutines that real with movement need it,
	; save it separately to avoid doing that subtraction again.
	ld   a, [wPlRelX]			; B = wPlRelRealX = wPlRelX - $08
	sub  OBJ_OFFSET_X
	ld   [wPlRelRealX], a
	
	; Determine how many columns are there to the left of the player
	swap a						; B /= $10
	and  $0F
	ld   b, a
	
	;
	; Add that to the absolute column number of the leftmost column
	;
	ld   a, [wLvlColL]			; wLvlColPl = wLvlColL + B
	add  b
	ld   [wLvlColPl], a
	ret
	
; =============== Game_DoRoomTrs ===============
; This subroutine handles the loop code for vertical screen transitions.
; OUT
; - Z: If set, the transition is finished.
Game_DoRoomTrs:
	
	;
	; Set up tile ID data for the level scrolling event (ScrEv_LvlScrollV).
	;
	; During the transition 8 of them will trigger, each redrawing a single row (2 tiles tall).
	; That's enough to redraw the entire height of the gameplay screen, and it's also small enough
	; that we can get away with firing the events as soon as possible, without worrying about
	; writing over part of the visible screen.
	;
	
	ldh  a, [hTrsRowsProc]
	cp   SCREEN_GAME_BLOCKCOUNT_V	; Have we written all 8 strips?
	jr   nc, .scroll				; If so, we're done with tilemap updates, just scroll the viewport
	ld   a, [wLvlScrollEvMode]
	or   a							; Are we in the middle of the previously set screen event?
	jr   nz, .scroll				; If so, don't interrupt it
	
	;
	; Save to hScrEvVDestPtr_* where to start writing tiles.
	;
	; [BUG] There's an oversight in here, the code should have checked if we were scrolling up, and if so,
	;       make hScrEvVDestPtr_Low point to the bottom row.
	;       Instead, since the top row is always drawn first, garbage is visible for two frames when scrolling up.
	;
	
	ld   hl, ScrEv_BGStripTbl		; Index the base table
	ldh  a, [hScrEvOffV]
	and  $0F						; Force in range
	sla  a							; Index by vertical grid offset * 2
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]					; Read out the ptr to hScrEvVDestPtr_*
	ldh  [hScrEvVDestPtr_Low], a
	ld   a, [hl]
	ldh  [hScrEvVDestPtr_High], a
	
	;
	; Generate the list of tile IDs that ScrEv_LvlScrollV will later write across multiple frames.
	;
	; Self explainatory, this, in a loop, reads a block ID from the level layout and uses it to
	; index the block table, which tells the 4 tile IDs used for any given block.
	;
	ldh  a, [hScrEvLvlLayoutPtr_High]	; HL = Level layout ptr
	ld   h, a
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	ld   l, a
	ld   de, wScrEvRows					; DE = Destination buffer
	ld   b, LVLSCROLLV_BLOCKCOUNT		; B  = Blocks to copy ($0C, $30 tiles total, $18/$20 in width)
.loop:
	ldi  a, [hl]				; A = Block ID
	push hl						; Save ptr for later
		push de
			; Seek HL to the table entry
			sla  a				; L = A*4, as each entry is 4 bytes long
			sla  a
			ld   h, HIGH(wLvlBlocks)
			ld   l, a
			
			; Copy over the 4 tile IDs.
			; The dest buffer directly mirrors what will be drawn to the screen,
			; so some fudging around with that ptr is needed.
			
			; 0 - TOP-LEFT
			ldi  a, [hl]		; Read byte0
			ld   [de], a		; Write to tile buffer
			ld   a, e			; Seek buffer ptr down
			xor  BG_TILECOUNT_H			
			ld   e, a
			
			; 1 - BOTTOM-LEFT
			ldi  a, [hl]
			ld   [de], a
			ld   a, e			; Seek buffer ptr up & right
			xor  BG_TILECOUNT_H+1
			ld   e, a
			
			; 2 - TOP-RIGHT
			ldi  a, [hl]
			ld   [de], a
			ld   a, e			; Seek buffer ptr down
			xor  BG_TILECOUNT_H			
			ld   e, a
			
			; 3 - BOTTOM-RIGHT
			ld   a, [hl]
			ld   [de], a
		pop  de
	pop  hl						; HL = Level layout ptr
	
	; Since only $0C blocks are being written, there's no need to worry about crossing over the $20 boundary.
	ld   a, e					; Seek buffer ptr right by 2 tiles
	add  $02
	ld   e, a
	dec  b						; Done processing all blocks?
	jr   nz, .loop				; If not, loop
	
	ld   a, SCREV_SCROLLV		; Start redraw event				
	ld   [wLvlScrollEvMode], a
	
	ld   hl, hTrsRowsProc		; Another row processed
	inc  [hl]
	
.scroll:

	;
	; Scroll the screen 2px every frame in the appropriate direction.
	;
	; The height of the gameplay screen ($80) neatly fits two of them on the tilemap.
	; It also allows us to easily check if we've finished scrolling the screen, by 
	; just checking when we reach a $80 boundary.
	;
	
	ld   a, [wScrollVDir]
	or   a						; wScrollVDir == SCROLLV_UP?
	jr   z, .scrollUp			; If so, jump
.scrollDown:
	ldh  a, [hScrollY]			; hScrollY += 2
	add  $02
	ldh  [hScrollY], a
	and  $7F					; Reached a $80 boundary?
	ret							; Z Flag = Yes
.scrollUp:
	ldh  a, [hScrollY]			; hScrollY -= 2
	sub  $02
	ldh  [hScrollY], a
	and  $7F					; Reached a $80 boundary?
	ret							; Z Flag = Yes
	
; =============== ScrEv_LvlScrollV ===============
; Updates the tilemap for vertical scrolling during gameplay.
; Works alongside Game_DoRoomTrs, which feeds its data.
ScrEv_LvlScrollV:

	; This event lasts three frames.
	; Until it is finished, Game_DoRoomTrs isn't allowed to send any more data.
	ld   a, [wLvlScrollEvMode]
	cp   SCREV_SCROLLV+0
	jr   z, .copyRow0
	cp   SCREV_SCROLLV+1
	jr   z, .setNextStrip
	cp   SCREV_SCROLLV+2
	jr   z, .copyRow1
	ret ; We never get here
	
; --------------- FRAME 0 ---------------
; Copies the first row of tiles to the tilemap.
.copyRow0:

	; HL = Source tile IDs
	ld   hl, wScrEvRows
	
	; DE = Destination tilemap ptr
	;      Tiles will be written starting from here, seeking the tilemap pointer right.
	;      The high byte is fixed, while the low byte is recalculated each iteration (see below)
	ldh  a, [hScrEvVDestPtr_High]	
	ld   d, a
	
	; C = Horizontal offset to the destination
	;     This is guaranteed to be in range $00-$1F
	ldh  a, [hScrEvOffH]
	sla  a							; *2'd like with h scrolling
	ld   c, a
	
	; B = Number of tiles to copy ($18)
	ld   b, LVLSCROLLV_BLOCKCOUNT * BLOCK_TILECOUNT_H
	
.loop0:
	; Calculate the low byte of the dest ptr
	ldh  a, [hScrEvVDestPtr_Low]	; E = hScrEvVDestPtr_Low + C
	add  c
	ld   e, a
	
	; Perform the copy
	ldi  a, [hl]				; Read from src, src++
	ld   [de], a				; Copy to dest
	
	; Seek the tilemap ptr right, enforcing that it loops the row.
	ld   a, c					; C++ (in looped range $00-$20)
	inc  a
	and  BG_TILECOUNT_H-1 ; $1F			
	ld   c, a
	
	dec  b						; Copied all bytes?
	jr   nz, .loop0				; If not, loop
	
	ld   hl, wLvlScrollEvMode	; Next part
	inc  [hl]
	ret
	
; --------------- FRAME 1 ---------------
; Setup for the next frame (and more)
.setNextStrip:
	; Switch the destination to the other row of the tilemap strip.
	ldh  a, [hScrEvVDestPtr_Low]
	xor  BG_TILECOUNT_H
	ldh  [hScrEvVDestPtr_Low], a
	
	;
	; Seek the source level layout & vertical offsets either "up" or "down", depending on the scroll direction.
	;
	; This is made very easy for us, as level layouts are stored in such a way where decrementing/incrementing
	; the high byte of the pointer is all that's needed to seek to the block above or below.
	; Same for the vertical offset, since it's straight up an index to a table of tilemap ptrs.
	;
	; Doing this isn't immediately necessary for the next frame, but it must be done for Game_DoRoomTrs
	; by the time the event finishes.
	;
	
	ld   a, [wScrollVDir]
	or   a						; wScrollVDir == SCROLLV_UP?
	jr   z, .seekUp				; If so, jump
.seekDown:
	ld   hl, hScrEvLvlLayoutPtr_High	; Seek to block below
	inc  [hl]
	ld   hl, hScrEvOffV		; StripId++
	inc  [hl]
	ld   hl, wLvlScrollEvMode	; Next part
	inc  [hl]
	ret
.seekUp:
	ld   hl, hScrEvLvlLayoutPtr_High	; Seek to block above
	dec  [hl]
	ld   hl, hScrEvOffV		; StripId--
	dec  [hl]
	ld   hl, wLvlScrollEvMode	; Next part
	inc  [hl]
	ret
	
; --------------- FRAME 2 ---------------
; Copies the second row of tiles to the tilemap.
; This is identical to #0 except for the source ptr.
.copyRow1:
	ld   hl, wScrEvRows+BG_TILECOUNT_H		; HL = $DD20
	
	;--
	; This is 100% identical to the respective code in .frame0
	ldh  a, [hScrEvVDestPtr_High]
	ld   d, a
	ldh  a, [hScrEvOffH]		
	sla  a
	ld   c, a
	ld   b, LVLSCROLLV_BLOCKCOUNT * BLOCK_TILECOUNT_H
.loop2:
	ldh  a, [hScrEvVDestPtr_Low]
	add  c
	ld   e, a
	ldi  a, [hl]
	ld   [de], a
	ld   a, c
	inc  a
	and  BG_TILECOUNT_H-1 ; $1F
	ld   c, a
	dec  b
	jr   nz, .loop2
	;--

	; Transfer done, let Game_DoRoomTrs send more data, if any
	xor  a
	ld   [wLvlScrollEvMode], a
	ret
	
; =============== Lvl_RoomColOffsetTbl ===============
Lvl_RoomColOffsetTbl: 
	DEF I = 0
	; [POI] Only entries $00-$09 are used, as that's the amount of levels.
	REPT $10
		dw LVL_ROOMCOUNT * I
		DEF I = I + 1
	ENDR

; =============== Lvl_RoomColTbl ===============
; Maps each Room ID to an initial wLvlColL value.
; [POI] The last two values happen to not be used, and the first room is never used.
Lvl_RoomColTbl:
	DEF I = 0
	REPT LVL_ROOMCOUNT + 1
		db ROOM_COLCOUNT * I
		DEF I = I + 1
	ENDR

TilemapDef_StatusBar: INCLUDE "data/game/statusbar_bg.asm"

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
	
; =============== Game_Init ===============
; Initialize all of the needed gameplay variables
Game_Init:
	
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
	ld   [wWpnHelperWarpRtn], a
	ld   [wWpnHelperUseTimer], a
	ld   [wUnused_CF5F], a
	ld   [wLvlWarpDest], a
	ld   [wWpnTpActive], a
	ld   [wWpnSGRide], a
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

; =============== Game_RunInitEv ===============
; Performs any event-based VRAM updates that need to be executed immediately after the screen is turned on.
; These are actions that, while happen while the level loads, can also individually happen in the middle of gameplay.
Game_RunInitEv:

	;
	; The default status bar tilemap we loaded before contains placeholder values.
	;
	ld   a, [wPlHealth]		; Redraw health bar
	ld   c, $00
	call Game_AddBarDrawEv
	ld   a, [wPlLives]		; Redraw lives indicator
	call Game_AddLivesDrawEv
	rst  $18 ; Wait bar update
	
	;
	; Load the actor graphics using the same code for room transitions.
	; This is the cause of the noticeable delay before the player is warped in,
	; since the copy happens during VBlank and there isn't anything else 
	; (ie: the screen scrolling during a transition) to mask the load times.
	;
	call ActS_ReqLoadRoomGFX
	rst  $20 ; Wait GFX load
	ret
	
; =============== Game_Do ===============
; Main gameplay code.
; Handles common actions to perform during gameplay, ending with handling the player's state.
Game_Do:
	; Reset these for later
	xor  a
	ld   [wActScrollX], a
	ld   [wPlColiBlockL], a
	ld   [wPlColiBlockR], a
	; Fall-through
	
; =============== Game_Do_Shutter ===============
; Handles the boss shutter effect.
; This goes along with the shutter event executed during VBlank.
Game_Do_Shutter:
	ld   a, [wShutterMode]
	or   a									; In the middle of a shutter effect?
	jp   z, Game_Do_ChkSpawnWaterBubble		; If not, jump
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
	
; =============== Game_Do_ChkSpawnWaterBubble ===============
; Spawns a water bubble every ~1 sec when the player is underwater, around their location.
Game_Do_ChkSpawnWaterBubble:

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
	
; =============== Game_Do_DecHurtTimers ===============
; Ticks the hurt & invulerability timers.
Game_Do_DecHurtTimers:
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
	; No Pl_DoWpnCtrl call, preventing shots from being fired
	call Pl_DoConveyor
	call Pl_DoHurtSpeed ; Replaces Pl_DoMoveSpeed
	call Pl_BgColiApplySpeedX
	jp   .chkGround ; Skip very fat ahead
.notHurt:
	call Pl_DoWpnCtrl ; BANK $01
	call Pl_DoConveyor
	call Pl_DoMoveSpeed
	call Pl_BgColiApplySpeedX
	
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
	; Pl_BgColiMoveR will have saved the block ID detected on the right to wPlColiBlockR.
	ld   a, [wPlColiBlockR]
	cp   BLOCKID_SHUTTER		; Are we walking towards a shutter block?
	jr   nz, .chkLadderU			; If not, skip
	
	; [POI] Attempt to teleport Rush/Sakugarne out.
	;       There is a problem with this, in that all actors are despawned when touching a door,
	;       and the way the game tries to wait for them just doesn't work.
	;       The only way to see this is to move towards the door for one frame only.
	call Pause_StartHelperWarp	; Try to teleport Rush/Sakugarne out, *if they aren't teleporting out already*
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
	; We have moved the player before through Pl_BgColiApplySpeedX,
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
	call Pl_DoWpnCtrl ; BANK $01
	; Handle horizontal movement
	call Pl_DoMoveSpeed
	call Pl_BgColiApplySpeedX
	
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
	call Pl_DoWpnCtrl ; BANK $01
	; Handle horizontal movement
	call Pl_DoMoveSpeed
	call Pl_BgColiApplySpeedX
	
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
	call Pl_BgColiApplySpeedX
	; [POI] This doesn't quite skip ahead far enough, allowing the player to "cancel" the hurt state by grabbing a ladder.
	;       (specifically, they don't handle it, but the hurt timer is still ticking down)
	jr   .setSpr
.noHurt:
	call Pl_DoWpnCtrl ; BANK $01
	call Pl_DoMoveSpeed
	call Pl_BgColiApplySpeedX
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
	call Pl_DoWpnCtrl ; BANK $01
	
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
	call Pl_BgColiApplySpeedX
	
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
	call Pl_DoWpnCtrl ; BANK $01
	
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
	call Pl_ApplySpeedX
	jp   Pl_ApplyRmSpeedY
	
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
	
; =============== PlColi_Spike ===============
; Handles collision with a spike block.
PlColi_Spike:
	;
	; [TCRF] When cheating, spikes become bouncy pits.
	;
	ldh  a, [hCheatMode]
	or   a
	jr   z, .explode
.bounce:
	ld   a, PL_MODE_FULLJUMP	; Jump up at 5px/frame
	ld   [wPlMode], a
	ld   a, $05
	ld   [wPlSpdY], a
	ld   a, $00
	ld   [wPlSpdYSub], a
	jp   Pl_DrawSprMap
	
.explode:
	; Otherwise, trigger an explosion from the center of the player.
	; [BUG] Actor collision is still processed for this frame, which can lead to oddities
	;       such as entering Rush Marine the same frame of touching a spike.
	
	ld   a, [wPlRelX]		; X Target = PlX (center)
	ld   [wExplodeOrgX], a
	ld   a, [wPlRelY]		; Y Target = PlY (bottom)
	sub  PLCOLI_V			; -= radius (center)
	ld   [wExplodeOrgY], a
	ld   a, LVLEND_PLDEAD	; Trigger death
	ld   [wLvlEnd], a

	jp   Pl_DrawSprMap
	
; =============== Pl_StopTpAttack ===============
; Makes the player stop spinning.
Pl_StopTpAttack:
	ld   a, [wWpnId]
	cp   WPN_TP				; Are we using Top Spin?
	ret  nz					; If not, return
	xor  a
	ld   [wWpnTpActive], a	; Stop Top Spin's attack (will enable the player's sprite)
	ld   [wShot0], a		; Despawn the weapon shot, which is what deals damage
	ret
	
; =============== Pl_DoConveyor ===============
; Handles automatic movement if standing on a conveyor belt.
Pl_DoConveyor:
	; Ignore if standing on an actor platform
	ld   a, [wActPlatColiSlotPtr]
	cp   ACTSLOT_NONE
	ret  nz
	
	;
	; If either of the player's left or right ground sensors point to a
	; conveyor belt block, update the movement speed accordingly.
	;
	; Updating the current speed makes it account for instances where the
	; player's speed isn't 0 (ie: moving or sliding), however keep in mind
	; that, when idle, the player's speed is reset.
	;
	
.chkL:
	; Check the left sensor
	ld   a, [wPlRelY]		; YPos = PlY + 1 (ground)
	inc  a
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]		; XPos = PlX - 6 (left)
	sub  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; A = Block ID
	ld   bc, $0080			; BC = 0.5px/frame
	cp   BLOCKID_CONVEDGE_R	; BlockID < First conveyor block?
	jr   c, .chkR			; If so, skip to checking the right sensor
	jp   z, Pl_IncSpeedX		; BlockID == Right arrow? If so, move right
	cp   BLOCKID_CONVEDGE_L	; BlockID == Left arrow?
	jp   z, Pl_DecSpeedX		; If so, move left
	cp   BLOCKID_CONVMID_R	; BlockID == Right conveyor?
	jp   z, Pl_IncSpeedX		; If so, move right
	cp   BLOCKID_CONVMID_L	; BlockID == Left conveyor?
	jp   z, Pl_DecSpeedX		; If so, move left
.chkR:
	; Check the right sensor, with identical logic otherwise
	ld   a, [wPlRelX]		; XPos = PlX + 6 (right)
	add  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; ...
	ld   bc, $0080
	cp   BLOCKID_CONVEDGE_R
	jr   c, .ret
	jp   z, Pl_IncSpeedX
	cp   BLOCKID_CONVEDGE_L
	jp   z, Pl_DecSpeedX
	cp   BLOCKID_CONVMID_R
	jp   z, Pl_IncSpeedX
	cp   BLOCKID_CONVMID_L
	jp   z, Pl_DecSpeedX
.ret:
	ret
	
; =============== Pl_IsOnGround ===============
; Checks if the player is on solid ground.
; OUT
; - wColiGround: Collision flags
;                ------LR
;                L - If set, the left block is not solid
;                R - If set, the right block is not solid
;                If any of them is set, the player is on solid ground.
Pl_IsOnGround:

	; If the player is standing on an actor platform, that counts as solid ground
	ld   a, [wActPlatColiSlotPtr]
	cp   ACTSLOT_NONE			; wActPlatColiSlotPtr == ACTSLOT_NONE?
	jr   z, .calcFlags			; If so, jump
	xor  a						; Set both blocks as solid
	ld   [wColiGround], a
	ret
.calcFlags:
	ld   a, [wPlRelY]			; YPos = PlY + 1 (ground)
	inc  a
	ld   [wTargetRelY], a
	
	; Check bottom-left block
	ld   a, [wPlRelX]			; XPos = PlX - 6 (left border)
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; A = Block ID
	cp   BLOCKID_TOPSOLID_START	; C Flag = Is empty? (A < BLOCKID_TOPSOLID_START)
	ld   hl, wColiGround
	rl   [hl]					; << in result
	
	; Check bottom-right block
	ld   a, [wPlRelX]			; XPos = PlX + 6 (right border)
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; A = Block ID
	cp   BLOCKID_TOPSOLID_START	; C Flag = Is empty? (A < BLOCKID_TOPSOLID_START)
	ld   hl, wColiGround
	rl   [hl]					; << in result
	ret
	
; =============== Pl_IsInTopSolidBlock ===============
; Checks if the player is inside a top-solid block.
; The ladder top block is the only one like this.
; OUT
; - Z Flag: If set, the player is inside one
Pl_IsInTopSolidBlock:

	; [BUG] This subroutine is exclusively used by code handling bottom/ground collision
	;       to let the player fall through the non-top part of top-solid platforms
	;       by performing the check before the standard collision one is done, where
	;       top-solid blocks are treated as fully solid.
	;
	;       To count as being inside a top-solid block, the game checks if *both*
	;       the left and right sensors point to one, giving 4px of leeway to pass the checks.
	;       This logic is not adequate enough to cover all cases.
	;       While this is enough if one of the sensors points to a solid block, it is not
	;       when the other is empty, leading to solid ground being detected where there isn't
	;       any, making the player visibly warp to the bottom of the block.

	
	; Check if the block to the left of the player, at origin level, is a ladder top block.
	; If it isn't, return early
	ld   a, [wPlRelY]		; YPos = PlY (body)
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]		; XPos = PlX - 6 (left border)
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; A = Block ID
	cp   BLOCKID_LADDERTOP	; Is it a ladder top block?
	ret  nz					; If not, return (Z Flag = Clear)
	
	; Do the same but to the right of the player
	ld   a, [wPlRelX]		; XPos = PlX + 6 (right border)
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; A = Block ID
	cp   BLOCKID_LADDERTOP	; Is it a ladder top block?
	ret						; Z Flag = Yes
	
; =============== Pl_DoSlideSpeed ===============
; Updates the player's speed for sliding forwards.
Pl_DoSlideSpeed:
	ld   bc, $0180	; Slide speed: 1.5px/frame
	jr   Pl_DoMoveSpeed.chkDir
	
; =============== Pl_DoMoveSpeed ===============
; Updates the player's speed for moving forwards (walking or jumping).
Pl_DoMoveSpeed:
	ld   bc, $0100	; Normal speed: 1px/frame
.chkDir:
	; Depending on the direction the player is moving, set their direction and speed accordingly.
	ldh  a, [hJoyKeys]
	bit  KEYB_LEFT, a	; Holding left?
	jr   z, .chkR		; If not, jump
.dirL:
	xor  a				; Set facing left
	ld   [wPlDirH], a
	jr   Pl_DecSpeedX	; Speed -= BC
.chkR:
	bit  KEYB_RIGHT, a	; Holding right?
	ret  z				; If not, return (staying idle)
.dirR:
	ld   a, $01			; Set facing right
	ld   [wPlDirH], a
	jr   Pl_IncSpeedX	; Speed += BC
	
; =============== Pl_DoHurtSpeed ===============
; Updates the player's speed in the hurt pose.
Pl_DoHurtSpeed:
	; Specifically, it makes the player move back 0.25px/frame,
	; which is subtracted from the current speed.
	ld   bc, $0040			; BC = 0.25px/frame
	; Subtracting is relative to the direction the player's facing
	ld   a, [wPlDirH]
	or   a					; Facing left?
	jr   z, Pl_IncSpeedX		; If so, move right 
	jr   Pl_DecSpeedX		; Otherwise, move left
	
; =============== Pl_SetSpeedByActDir ===============
; Updates the player's speed, towards the same direction the actor is facing.
; Used by enemies in Air Man's stage that blow the player away.
; IN
; - A: iActSprMap
; - BC: Offset
Pl_SetSpeedByActDir:
	bit  ACTDIRB_R, a		; Is the actor facing right?
	jr   nz, Pl_IncSpeedX	; If so, move the player right
	; Fall-through
	
; =============== Pl_DecSpeedX ===============
; Decreases the player's horizontal speed by the specified amount.
; IN
; - BC: Offset
Pl_DecSpeedX:
	ld   a, [wPlSpdXSub]
	sub  c
	ld   [wPlSpdXSub], a
	ld   a, [wPlSpdX]
	sbc  b
	ld   [wPlSpdX], a
	ret
	
; =============== Pl_IncSpeedX ===============
; Increases the player's horizontal speed by the specified amount.
; IN
; - BC: Offset
Pl_IncSpeedX:
	ld   a, [wPlSpdXSub]
	add  c
	ld   [wPlSpdXSub], a
	ld   a, [wPlSpdX]
	adc  b
	ld   [wPlSpdX], a
	ret
	
; =============== Pl_ApplySpeedX ===============
; Applies the horizontal movement speed for the current frame.
; In short, actually moves the player horizontally.
Pl_ApplySpeedX:
	ld   a, [wPlSpdX]	; A = H Speed
	or   a				; Speed already 0?
	ret  z				; If so, nothing to do
	
	; Determine which direction we're moving to through the speed's sign.
	; Speed is not relative to the direction the player is facing, rather,
	; negative speed always moves the player left, positive speed always to the right.
	; This is unlike actors, whose sprite direction usually affects their movement direction.
	bit  7, a			; Speed > 0? (MSB clear)  
	jr   z, .loopR		; If so, jump (move right)
	; The player's remaining speed is used as a loop counter, it must be positive.
	xor  $FF			; Otherwise, Speed = -Speed
	inc  a
	ld   [wPlSpdX], a
.loopL:
	; Movement happens pixel by pixel, doing the whole process for every step of movement.
	; Speed also doesn't persist, the pixel value is essentially guaranteed to be reset
	; when exiting the subroutine.
	call Pl_MoveL		; Move left 1px
	ld   hl, wPlSpdX	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopL		; If not, move again
	ret
.loopR:
	call Pl_MoveR		; Move right 1px
	ld   hl, wPlSpdX	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopR		; If not, move again
	ret
	
; =============== Pl_BgColiApplySpeedX ===============
; Variation of Pl_ApplySpeedX that also checks for solid collision,
; preventing movement over solid blocks.
Pl_BgColiApplySpeedX:
	ld   a, [wPlSpdX]	; A = H Speed
	or   a				; Speed already 0?
	ret  z				; If so, nothing to do
	bit  7, a			; Speed > 0? (MSB clear)  
	jr   z, .loopR		; If so, jump (move right)
	xor  $FF			; Otherwise, Speed = -Speed
	inc  a
	ld   [wPlSpdX], a
.loopL:
	call Pl_BgColiMoveL	; Move left 1px, with solid collision checks
	ld   hl, wPlSpdX	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopL		; If not, move again
	ret
.loopR:
	call Pl_BgColiMoveR	; Move right 1px, with solid collision checks
	ld   hl, wPlSpdX	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopR		; If not, move again
	ret
	
; =============== Pl_BgColiMoveL ===============
; Moves the player 1 pixel to the left if there isn't a solid block in the way.
Pl_BgColiMoveL:
	;
	; The player typically is 24 pixels tall, meaning two blocks need to be checked.
	; The sensors are located 8 pixels apart, therefore 4 of them are needed.
	;
	
	; All of these sensors are located 1 pixel to the left
	; of the right border of the collision box.
	; This is enough given only one pixel of movement ever happens at a time.
	ld   a, [wPlRelX]		; XPos = PlX - 7
	sub  PLCOLI_H+1
	ld   [wTargetRelX], a
	
	;
	; Y Positions 0, 7 and 15 belong to the low block,
	; and must be always checked.
	;
	
	; LOW BLOCK, bottom
	ld   a, [wPlRelY]		; YPos = PlY
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	ld   [wPlColiBlockL], a	; Set it as left block (doesn't happen to be used)
	ret  nc					; Is the block empty? If not, return
	
	; LOW BLOCK, middle
	ld   a, [wPlRelY]		; YPos = PlY - 7
	sub  (8*1)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	ret  nc					; Is the block empty? If not, return
	
	; LOW BLOCK, top
	ld   a, [wPlRelY]		; YPos = PlY - 15
	sub  (8*2)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	ret  nc					; Is the block empty? If not, return
	
	;
	; Y position 23 belongs to the block above.
	; When sliding, the player's height is halved, and as such it fits within the low block.
	;
	ld   a, [wPlMode]
	cp   PL_MODE_SLIDE		; Player sliding?
	jr   z, Pl_MoveL		; If so, skip
	
	; HIGH BLOCK, middle
	ld   a, [wPlRelY]		; YPos = PlY - 23
	sub  (8*3)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	ret  nc					; Is the block empty? If not, return
	; Fall-through
	
; =============== Pl_MoveL ===============
; Moves the player 1 pixel to the left.
Pl_MoveL:

	;
	; The player's coordinates in this game directly map to the hardware sprites'
	; positions and as such are always relative to the screen.
	; Hence, special care must be taken to account for both the hardware offset
	; and to how, the player sprite doesn't really move when the screen also scrolls.
	;


	; Prevent moving off-screen to the left.
	ld   a, [wPlRelX]
	cp   OBJ_OFFSET_X + 8		; wPlRelX < 8?
	ret  c						; If so, return
	
	;
	; If we crossed a block boundary, decrement the current column number.
	;
.chkCross:
	ld   a, [wPlRelRealX]		; wPlRelRealX--
	dec  a
	ld   [wPlRelRealX], a
	and  BLOCK_H-1				; A %= BLOCK_H	
	cp   BLOCK_H-1				; A != BLOCK_H - 1?
	jr   nz, .chkMoveType		; If not, skip (didn't cross)
	
	ld   hl, wLvlColPl			; ColNum--
	dec  [hl]
	
	;--
	;
	; If the screen isn't locked, redraw the edge of the screen, spawning actors as needed.
	;
	; [POI] This being checked here is... odd.
	;       It only makes sense to perform the redraw when the viewport crosses a block
	;       boundary, not when the player does it!
	;       In practice, when the player does, the viewport also does it, so all it serves
	;       is calling LvlScroll_DrawEdgeL before hScrollX and wLvlColL get updated,
	;       which is proper behavior (due to actors getting shifted).
	;
	
	; Boss corridors and boss rooms lock the screen.
	; We can detect if we're in one of the two by checking if we're at least in a boss corridor, 
	; as in this game they only ever are at the end of a level.
	ld   a, [wBossMode]
	or   a							; In a boss corridor or boss room?
	jr   nz, .lock					; If so, skip
	
	; Then check for a standard screen lock, from the current column number.
	ld   h, HIGH(wLvlScrollLocks)	; HL = wLvlScrollLocks[ColNum]
	ld   a, [wLvlColPl]
	ld   l, a
	ld   a, [hl]					; A = Lock info
	bit  SLKB_OPEN, a				; Is the player on an unlocked column?
	call nz, LvlScroll_DrawEdgeL	; If so, do the redraw
	;--
	
.chkMoveType:

	;
	; Perform the actual player movement.
	; This can be done in two ways:
	; - If the screen is locked, move the player left
	; - If the screen isn't locked, move the viewport left
	;
	
	; Boss corridors and boss rooms lock the screen.
	ld   a, [wBossMode]
	or   a						; In a boss corridor or boss room?	
	jr   nz, .lock				; If so, skip
	
	; Then check for a standard screen lock, from the current column number.
	ld   h, HIGH(wLvlScrollLocks)	; HL = wLvlScrollLocks[ColNum]
	ld   a, [wLvlColPl]
	ld   l, a
	ld   a, [hl]				; A = Lock info
	bit  SLKB_OPEN, a			; Is scrolling unlocked for this column? 
	jr   nz, .noLock			; If so, jump
.lock:
	; Screen is locked.
	; Move the player left by 1 pixel.
	ld   hl, wPlRelX
	dec  [hl]
	ret
.noLock:
	; Screen is unlocked.
	; Keep the player at the current position, and instead...
	ld   hl, wActScrollX		; ...move all actors 1px to the right
	inc  [hl]
	ldh  a, [hScrollX]			; ...move the viewport left (scroll the screen right)
	dec  a
	ldh  [hScrollX], a
	; If the *viewport* crossed a block boundary, decrement the column base
	and  BLOCK_H-1				; A %= BLOCK_H	
	ldh  [hScrollXNybLow], a	; Keep this in sync
	cp   BLOCK_H-1				; A != BLOCK_H - 1? (went from $x0 to $xF)
	ret  nz						; If not, return (didn't cross)
	ld   hl, wLvlColL			; Otherwise, move to previous base col
	dec  [hl]
	ret

; =============== Pl_BgColiMoveR ===============
; Moves the player 1 pixel to the right if there isn't a solid block in the way.
; See also: Pl_BgColiMoveL
Pl_BgColiMoveR:

	;
	; Check for solid collision
	;
	ld   a, [wPlRelX]		; XPos = PlX + 7
	add  PLCOLI_H+1
	ld   [wTargetRelX], a
	
	; LOW BLOCK, bottom
	ld   a, [wPlRelY]		; YPos = PlY
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	ld   [wPlColiBlockR], a	; Set it as right block (used, unlike wPlColiBlockL)
	ret  nc					; Is the block empty? If not, return
	
	; LOW BLOCK, middle
	ld   a, [wPlRelY]		; YPos = PlY - 7
	sub  (8*1)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	
	; LOW BLOCK, top
	ld   a, [wPlRelY]		; YPos = PlY - 15
	sub  (8*2)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	
	; Check the top block only if not sliding
	ld   a, [wPlMode]
	cp   PL_MODE_SLIDE		; Player sliding?
	jr   z, Pl_MoveR		; If so, skip
	; HIGH BLOCK, middle
	ld   a, [wPlRelY]		; YPos = PlY - 23
	sub  (8*3)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	; Fall-through
	
; =============== Pl_MoveR ===============
; Moves the player 1 pixel to the right.
Pl_MoveR:

	; Prevent moving off-screen to the right.
	; (screen size + box radius + 1 pixel of movement - hardware offset)
	ld   a, [wPlRelX]
	cp   SCREEN_GAME_H+PLCOLI_H+1-OBJ_OFFSET_X	; wPlRelX >= $9F?
	ret  nc										; If so, return
	
	;
	; Perform the actual player movement.
	; This can be done in two ways:
	; - If the screen is locked, move the player right
	; - If the screen isn't locked, move the viewport right
	;
	ld   a, [wBossMode]
	or   a					; In a boss corridor or boss room?	
	jr   nz, .lock			; If so, skip
	; Then check for a standard screen lock, from the current column number.
	ld   h, HIGH(wLvlScrollLocks)	; HL = wLvlScrollLocks[ColNum]
	ld   a, [wLvlColPl]
	ld   l, a
	ld   a, [hl]			; A = Lock info
	bit  SLKB_OPEN, a
	jr   nz, .noLock
.lock:
	; Screen is locked.
	; Move the player right by 1 pixel.
	ld   hl, wPlRelX
	inc  [hl]
	jr   .chkCross
.noLock:
	; Screen is unlocked.
	; Keep the player at the current position, and instead...
	ld   hl, wActScrollX	; ...move all actors 1px to the left
	dec  [hl]
	ldh  a, [hScrollX]		; ...move the viewport right (scroll the screen left)
	inc  a
	ldh  [hScrollX], a
	; If the *viewport* crossed a block boundary, increment the column base
	and  BLOCK_H-1				; A %= BLOCK_H	
	ldh  [hScrollXNybLow], a	; Keep this in sync
	jr   nz, .chkCross			; Is it != 0? (went from $xF to $x0). If not, skip
	ld   hl, wLvlColL			; Otherwise, move to next base col
	inc  [hl]
.chkCross:
	;
	; If we crossed a block boundary, increment the current column number.
	;
	; Notice how these checks are happening at the end of the subroutine, compared
	; to Pl_MoveL where they took place at the start.
	;
	ld   a, [wPlRelRealX]		; wPlRelRealX++
	inc  a
	ld   [wPlRelRealX], a
	and  BLOCK_H-1				; A %= BLOCK_H	
	ret  nz						; Is it != 0? (went from $xF to $x0). If not, return
	ld   hl, wLvlColPl			; ColNum++
	inc  [hl]
	
	;
	; If the screen isn't locked, redraw the edge of the screen, spawning actors as needed.
	;
	; [POI] The same note from Pl_MoveL applies here, except we're at the end of the subroutine.
	;       Here, hScrollX and wLvlColL already got updated.
	; [BUG] That causes an off by one problem when spawning actors. They are already placed at the correct
	;       location, but due to scrolling happening during the frame, ActS_MoveByScrollX will trigger and move them left.
	;       This inconsistency was worked around in actors like Act_Goblin.
	;
	
	; Boss corridors and boss rooms lock the screen.
	ld   a, [wBossMode]
	or   a						; Went through a shutter? (!= BSMODE_NONE)
	ret  nz						; If so, return
	
	; Then check for a standard screen lock, from the current column number.
	ld   h, HIGH(wLvlScrollLocks)	; HL = wLvlScrollLocks[ColNum]
	ld   a, [wLvlColPl]
	ld   l, a
	ld   a, [hl]					; A = Lock info
	bit  SLKB_OPEN, a				; Is the player on an unlocked column?
	ret  z							; If not, return
	jp   LvlScroll_DrawEdgeR		; Otherwise, do the redraw
	
; =============== Pl_AlignToLadder ===============
; Adjusts the player's horizontal position to be centered to the ladder.
;
; This subroutine assumes for the screen to be perfectly aligned to a block boundary (ie: locked, ...),
; if it isn't it will break the screen's scrolling due to moving the player's position instead of the viewport's.
Pl_AlignToLadder:
	
	;
	; If the player perfectly aligned to the center of the ladder, there's nothing to do.
	;
	; Note that the checks are made against wPlRelX, which is shifted by 8 (OBJ_OFFSET_X)
	; and as such it shifts the center point and effectively swaps the left and right ranges.
	; Even though wPlRelRealX could have been used instead to make the checks more intuitive,
	; using wPlRelX is faster as it gives the movement amount for free once modulo'd (see .moveL/.moveR)
	;
	;               CENTER POINT | LEFT SIDE | RIGHT SIDE
	; wPlRelRealX |          $07 |   $00-$06 |    $08-$0F
	; wPlRelX     |          $0F |   $08-$0E |    $00-$07
	; DIFF        |              |        +8 |         -8
	;
	
	ld   a, [wPlRelX]		; Get player origin (center of the player)
	ld   b, a				; (Not necessary)
	and  BLOCK_H-1			; Get position within the block (ModX)
	cp   OBJ_OFFSET_X+$07	; Is it at the center of the block? (ModX == $0F? / ModRealX == $07?)
	ret  z					; If so, return
	
	; Determine if the player is on the left or right of the center point
	cp   $08				; Is the player on the left side? (ModX in range $08-$0F)
	jr   nc, .moveR			; If so, move right
	
.moveL:

	;
	; The player is on the right side of the block, and should be moved to the center point.
	; With wPlRelRealX, the center point is $07, and the player should be moved left by <ModRealX>-$07 px.
	;
	; However, since we're using wPlRelX, whose values are subtracted by 8 when pointing to the right side...
	; <ModRealX> - $07 => <ModX> + $08 - $07 => <ModX> + 1
	;
	; That's easier to calculate, it's just off by one to what we already have in the A register.
	;
	inc  a					; MoveAmount = ModX + 1
	ld   b, a
	
	; Move both the player position and its unoffsetted copy left
	ld   a, [wPlRelX]		; wPlRelX -= B
	sub  b
	ld   [wPlRelX], a
	ld   a, [wPlRelRealX]	; wPlRelRealX -= B
	ld   c, a				; Save the untouched wPlRelRealX
	sub  b
	ld   [wPlRelRealX], a
	
	; [TCRF] If the movement made the player cross a block boundary, decrement the column number.
	;        This will never happen, as to hold on a ladder the player's origin must be in a ladder block to begin with.
	xor  c					; Check for changes compared to the unmodified value
	bit  4, a				; Did we cross the $10-byte block boundary? (bit4 changed from last time)
	ret  z					; If not, return
	;--
	; Unreachable
	ld   hl, wLvlColPl		; Otherwise, decrement the column number
	dec  [hl]
	ret
	;--
	
.moveR:
	;
	; The player is on the left side of the block, and should be moved right to the center point.
	; Same thing as before, except happening the other way around as the values are added by $08 so:
	; 
	; $07 - <ModRealX> => $07 - (<ModX> - $08) => $0F - <ModX>
	;
	ld   b, a				; MoveAmount = $0F - ModX
	ld   a, $0F
	sub  b
	ld   b, a
	
	; Move both the player position and its unoffsetted copy right
	ld   a, [wPlRelX]		; wPlRelX -= B
	add  b
	ld   [wPlRelX], a
	ld   a, [wPlRelRealX]	; wPlRelRealX -= B
	ld   c, a
	add  b
	ld   [wPlRelRealX], a
	
	; [TCRF] If the movement made the player cross a block boundary, increment the column number.
	xor  c					; Check for changes compared to the unmodified value
	bit  4, a				; Did we cross the $10-byte block boundary? (bit4 changed from last time)
	ret  z					; If not, return
	;--
	; Unreachable
	ld   hl, wLvlColPl
	inc  [hl]
	ret
	;--
	
; =============== Pl_ApplyRmSpeedY ===============
; Applies the vertical movement speed for the current frame when riding Rush Marine.
;
; Worth noting there's no Pl_ApplySpeedY as the movement mechanics almost always only allow moving
; to one vertical direction at a time (ie: when jumping you only move up, when falling only down, ...)
; and can't be influenced by factors that influence horizontal movement such as conveyor belts or Air Man.
;
; Rush Marine is the exception, since it has vertical momentum... but why not use wPlSpdY directly.
Pl_ApplyRmSpeedY:
	ld   a, [wPlRmSpdY]	; A = V Speed
	or   a				; Speed already 0?
	ret  z				; If so, nothing to do
	
	bit  7, a			; Speed > 0? (MSB clear)  
	jp   z, .loopD		; If so, jump (move down)
	xor  $FF			; Otherwise, Speed = -Speed
	inc  a
	ld   [wPlRmSpdY], a
	
	; These loops are a lazy copy/paste that could have been avoided by directly subtracting/adding wPlRmSpdY to wPlRelY.
	; The loop was there in Pl_ApplySpeedX because each frame needed to perform actions like checking for collision
	; or potentially scrolling the screen, but this merely alters wPlRelY.
.loopU:
	;--
	ld   hl, wPlRelY	; Move up 1px
	dec  [hl]
	;--
	ld   hl, wPlRmSpdY	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopU		; If not, move again
	ret
.loopD:
	;--
	ld   hl, wPlRelY	; Move down 1px
	inc  [hl]
	;--
	ld   hl, wPlRmSpdY	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopD		; If not, move again
	ret
	
; =============== Pl_AnimWalk ===============
; Animates the player's walk cycle, and redraws its sprite.
Pl_AnimWalk:
	
	;
	; The player's walk animation is split in two parts.
	; Starting from a standstill, when holding left or right:
	; - The first 7 frames the player uses a sidestep sprite
	; - From the 8th frame, the proper walk cycle begins
	;
	; Unlike other games, the sidestep is a purely visual effect that does not affect or delay the controls in any way.
	;
	
	; Which animation are we in?
	ld   a, [wPlWalkAnimTimer]
	cp   $07					; wPlWalkAnimTimer == $07?
	jr   z, .walkAnim			; If so, jump (walk cycle on)
.sidestep:
	inc  a						; Otherwise, wPlWalkAnimTimer++
	ld   [wPlWalkAnimTimer], a

	ld   a, PLSPR_SIDESTEP		; Set sidestep frame
	ld   [wPlSprMapId], a
	jr   Pl_DrawSprMap			; Draw it
	
.walkAnim:

	;
	; This animation is done by cycling through the four PLSPR_WALK* sprites, advancing after 64 frames.
	; These four sprites are in slots $00-$03.
	; 
	
	; Advance animation timer
	ld   a, [wPlAnimTimer]
	add  $08
	ld   [wPlAnimTimer], a
	
	; Shift down bits6-7 to bit0-1 and use it as relative sprite mapping IDs.
	swap a ; >> 4
	srl  a ; >> 1 (5)
	srl  a ; >> 1 (6)
	and  $03
	ld   [wPlSprMapId], a
	jr   Pl_DrawSprMap
	
; =============== Pl_AnimClimb ===============
; Animates the player's ladder climbing cycle, and redraws its sprite.
Pl_AnimClimb:

	;
	; This animation is done by flipping the player's direction every 64 frames.
	; The player's sprite is assumed to already be the climbing one when we get here.
	;
	; [POI] Setting the direction without restoring it after drawing the sprite
	;       has some side effects, like inconsistent shot directions or Pipi spawn locations.
	;       
	
	; Advance animation timer
	ld   a, [wPlAnimTimer]
	add  $06
	ld   [wPlAnimTimer], a
	
	; Shift down bit6 ($40) to bit0 and use it as direction.
	swap a ; >> 4
	srl  a ; >> 1 (5)
	srl  a ; >> 1 (6)
	and  $01			; Filter out other bits
	ld   [wPlDirH], a	; That's the direction
	
	; Fall-through
	
; =============== Pl_DrawSprMap ===============
; Draws the sprite mapping for the player.
Pl_DrawSprMap:

	; Top Spin's spin state is internally a weapon shot, so it's not drawn here.
	ld   a, [wWpnTpActive]
	or   a					; Top spin is active?
	jp   nz, .chkDust		; If so, skip
	
.chkHurt:
	;
	; When hurt, the player flashes and their frame is forced to the hurt one,
	; unless the current state would look odd with it.
	;

	; Not applicable when not hurt
	ld   a, [wPlHurtTimer]
	or   a					; Are we hurt?
	jr   z, .notHurt		; If not, skip
	
	; Flash sprite every other frame
	ldh  a, [hTimer]
	rra  					; hTimer % 2 == 0?
	jp   nc, .chkDust		; If so, jump
	
	; Force the player to use the hurt frame, except when their state is PL_MODE_SLIDE or above.
	; Those don't account for the player being hurt, so that frame would look odd.
	ld   a, [wPlMode]
	cp   PL_MODE_SLIDE		; wPlMode >= PL_MODE_SLIDE?
	jr   nc, .notHurt		; If so, jump
	ld   a, [wWpnSGRide]
	or   a					; Riding the Sakugarne?
	jr   nz, .notHurt		; If so, jump
	
	; Force hurt frame
	ld   a, PLSPR_HURT
	jr   .drawPl
	
.notHurt:
	;
	; During mercy invulnerability, flash sprite every 2 frames
	;
	ld   a, [wPlInvulnTimer]
	or   a					; Are we invulerable?
	jr   z, .getIdx			; If not, skip
	ldh  a, [hTimer]
	rra
	rra   					; (hTimer / 2) % 2 == 0? 
	jp   nc, .chkDust		; If so, jump
	
.getIdx:
	;
	; Build the index to the player's sprite mapping table.
	; A = wPlSprMapId | wPlShootType
	;
	; Since wPlShootType will be $00, $10 or $20, this enforces a specific frame order,
	; with those >= $30 being wPlShootType-independent.
	;
	ld   a, [wPlShootType]
	ld   b, a
	ld   a, [wPlSprMapId]
	or   b
	
.drawPl:

	;
	; Find the sprite mapping associated to the current frame.
	; There's a single table here unlike with actors, as there's only one player.
	;
	push af
		ld   a, BANK(Pl_SprMapPtrTbl) ; BANK $03
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   hl, Pl_SprMapPtrTbl	; HL = Ptr table base
	ld   b, $00					; BC = A * 2
	sla  a
	ld   c, a
	add  hl, bc					; Index it
	ldi  a, [hl]				; Read out to DE
	ld   e, a
	ld   a, [hl]
	ld   d, a
	
	;
	; Write the sprite mapping to the OAM mirror.
	; See also: Relevant code in ActS_DrawSprMap since it's pretty much the same.
	;
	
	ld   h, HIGH(wWorkOAM)	; HL = Ptr to current OAM slot
	ldh  a, [hWorkOAMPos]
	ld   l, a
	
	; Ignore blank sprite mappings
	ld   a, [de]
	or   a					; OBJCount == 0?
	jp   z, .drawPlEnd		; If so, we're done
	inc  de					; Otherwise, seek to the OBJ table
	ld   b, a				; B = OBJCount
	
	; Check for horizontal flip
	ld   a, [wPlDirH]
	or   a					; Player facing right?
	jr   nz, .loopR			; If so, jump
	
.loopL:
	;
	; NO FLIPPING
	; Nothing special here.
	;
	
	; YPos = wPlRelY + byte0
	ld   a, [wPlRelY]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	
	; XPos = wPlRelX + byte1
	ld   a, [wPlRelX]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	
	; TileID = byte2
	ld   a, [de]
	inc  de
	ldi  [hl], a
	
	; Flags = byte3 | wPlSprFlags
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [wPlSprFlags]
	or   c
	ldi  [hl], a
	
	; [POI] No full OAM check here, since these mappings are assumed to not be that big.
	dec  b					; Finished copying all OBJ?
	jr   nz, .loopL			; If not, loop
	
	ld   a, l				; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	jr   .drawPlEnd
	
.loopR:
	;
	; HORIZONTAL FLIPPING
	; Flips individual OBJ + the sprite mapping itself.
	;
	
	; YPos = wPlRelY + byte0
	ld   a, [wPlRelY]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	
	; XPos = -(wPlRelX + byte1) - TILE_H + 1
	; For flipping the sprite mapping
	; [POI] This is offset 1 pixel to the right compared to actor sprites.
	;       The consequences are that actors or shots that spawn from the
	;       player might need to be also offset by +1 when facing right.
	ld   a, [wPlRelX]	; C = Absolute X
	ld   c, a
	ld   a, [de]		; A = Relative X
	inc  de				; Seek to byte2 for later
	xor  $FF			; Invert the rel. X position (offset by -1)
	sub  TILE_H-2		; Account for tile width - 1
	add  c				; Get final pos
	ldi  [hl], a		; Write to OAM mirror
	
	; TileID = byte2
	ld   a, [de]
	inc  de
	ldi  [hl], a
	
	; Flags = (byte3 | wPlSprFlags) ^ SPR_XFLIP
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [wPlSprFlags]
	or   c
	xor  SPR_XFLIP
	ldi  [hl], a
	
	dec  b					; Finished copying all OBJ?
	jr   nz, .loopR			; If not, loop
	ld   a, l				; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	
.drawPlEnd:
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
.chkDust:
	;
	; Draw the dust particle caused by sliding, if needed.
	;
	ld   a, [wPlSlideDustTimer]
	or   a							; Timer has elapsed?
	ret  z							; If so, return
	dec  a							; Otherwise, Timer--
	ld   [wPlSlideDustTimer], a
	
	;
	; The animation frame picked is the timer's upper nybble.
	; This has two consequences:
	; - The animation advances every 16 frames
	; - Since it's a countdown timer, entries in the tile ID table are stored in reverse
	;
	swap a							; A /= 16
	and  $03						; Force valid range
	ld   hl, .dustTileTbl			; HL = Tile ID Table
	ld   b, $00						; BC = A
	ld   c, a
	add  hl, bc
	
	ld   a, [hl]					; B = Tile ID
	ld   b, a
	ld   a, [wActScrollX]			; C = wActScrollX
	ld   c, a
	
	ld   h, HIGH(wWorkOAM)			; HL = Ptr to current OAM slot
	ldh  a, [hWorkOAMPos]
	ld   l, a
	
	
	; Y POSITION
	
	; The dust sprite should be vertically aligned with the player, so:
	; YPos = wPlSlideDustY - (TILE_H - 1)
	;
	; wPlSlideDustY is a copy of wPlRelY, and since the player's origin is at the 
	; bottom border, the sprite is manually offsetted by TILE_H-1.
	ld   a, [wPlSlideDustY]
	sub  TILE_H-1
	ldi  [hl], a
	
	; X POSITION
	; 4 pixels to the left of the player's origin
	; XPos = wPlSlideDustX - $04
	
	; The screen can scroll horizontally, so adjust wPlSlideDustX as needed
	ld   a, [wPlSlideDustX]		; wPlSlideDustX += wActScrollX
	add  c
	ld   [wPlSlideDustX], a
	
	sub  $04					; XPos = wPlSlideDustX - $04
	ldi  [hl], a
	
	; TileId = B
	ld   a, b
	ldi  [hl], a
	
	; Flags = wPlSprFlags
	ld   a, [wPlSprFlags]
	ldi  [hl], a
	
	ld   a, l					; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	ret
	
; =============== .dustTileTbl ===============
; Table of tile IDs for the dust particle animation, stored in reverse.
.dustTileTbl:
	db $62
	db $61
	db $60

; =============== ActS_ClearAll ===============
; Prepares the actor memory.
ActS_ClearAll:
	; Delete the last loaded GFX marker
	ld   a, $FF
	ld   [wActGfxId], a
	
	; Start processing actors from the first slot
	xor  a
	ld   [wActStartSlotPtr], a
	
	; Delete everything old from the actor area
	ld   hl, wAct
	ld   bc, wAct_End-wAct
	jp   ZeroMemory
	
; =============== ActS_DespawnAll ===============
; Despawns all of the current actors.
; Mostly used at the start of room transitions.
; See also: ActS_Despawn
ActS_DespawnAll:
	ld   d, HIGH(wActLayoutFlags)	; DE = Actor layout (high byte)
	ld   hl, wAct					; HL = Current actors
.loop:
	ld   a, [hl]					; Read iActId
	or   a							; Is this slot active?
	jr   z, .next					; If not, skip it
	push hl							; Otherwise...
		; Mark it as empty
		xor  a						
		ldi  [hl], a				; iActId
		inc  l						; iActRtnId
		inc  l						; iActSprMap
		
		; Allow the actor to respawn if scrolled back in
		ld   a, [hl]				; DE = iActLayoutPtr (low byte)
		ld   e, a
		ld   a, [de]				; Read flags associated to this slot
		res  ACTLB_NOSPAWN, a		; Clear nospawn flag
		ld   [de], a				; Save back
	pop  hl							; Restore base slot ptr
.next:
	ld   a, l						; Seek to the next slot
	add  iActEnd
	ld   l, a
	jr   nz, .loop					; Done all 16? If not, loop
	
	; By despawning all actors, we also despawned Rush & the Sakugarne.
	; Clear out their flags that affect the player.
	xor  a
	ld   [wWpnHelperWarpRtn], a		; Rush/SG no longer there, can be recalled
	ld   [wWpnSGRide], a			; Disable pogo movement mode
	
	; Remove all weapon shots.
	
	; Top Spin is melee weapon, and its "shot" is allowed to move through rooms.
	ld   a, [wWpnId]
	cp   WPN_TP
	ret  z
	
	; The rest get deleted though
	xor  a
	ld   hl, wShot0+iShotId
	ld   [hl], a
	ld   hl, wShot1+iShotId
	ld   [hl], a
	ld   hl, wShot2+iShotId
	ld   [hl], a
	ld   hl, wShot3+iShotId
	ld   [hl], a
	ret
	
; =============== ActS_SpawnRoom ===============
; Spawns all of the actors in the current room.
; Meant to be called when the level loads or after a room transition
; to immediately spawn all actors that would be visible.
ActS_SpawnRoom:

	;
	; As a room is made of 10 columns (width of a screen), this will spawn any actors
	; defined on the 10 columns after the current one.
	;
	; In case the screen is locked to the right, one extra column is loaded for
	; the same reason it is done when drawing a full screen (the seam's position).
	;

	; A = Current room locks
	ld   a, [wLvlRoomId]
	ld   hl, wLvlScrollLocksRaw
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	
	ld   c, ROOM_COLCOUNT
	bit  0, a				; Is the screen locked to the right? (bit0 clear)
	jr   z, .setStart		; If so, skip (load 10 columns)
	inc  c					; Otherwise, make that 11
	
.setStart:
	
	; Start from the current column number.
	ld   a, [wLvlColL]		; HL = &wActLayoutFlags[wLvlColL]
	ld   l, a				;     (high byte set later)
	
	; Set the initial (relative) X position, which is autocalculated and *NOT* stored in the actor layout.
	; Since there is 1 actor/column, as we loop to the next column, this will be increased by the block width.
	;
	; The value being hardcoded means there's a big assumption about the screen being aligned to the block
	; boundary, which is one of the reasons levels shouldn't allow misaligned transitions
	; (otherwise actors' X positions would be offset incorrectly).
	;
	; This value is initialized to 7 rather than 0 to account for the actor's horizontal origin being at the center of the block.
	; What it does *NOT* account is the offset applied by the hardware, since actor positions and sprite positions
	; are one and the same. (ActS_SpawnFromLayout takes care of that)
	ld   b, $07				; B = Initial X pos
	
.loop:
	push hl
	push bc
		ld   h, HIGH(wActLayoutFlags) 	; Set the high byte
		ld   a, [hl]					; Read spawn flags
		bit  ACTLB_NOSPAWN, a			; Is the actor prevented from spawning?
		jr   nz, .skip					; If so, skip it (already on-screen or already collected)
		bit  ACTLB_SPAWNNORM, a			; Does this actor spawn normally?
		call nz, ActS_SpawnFromLayout	; If so, spawn it
.skip:
	pop  bc
	pop  hl
	
	inc  l				; Seek to the next actor layout entry, for the next column
	ld   a, b			; Spawn next actor to the next column
	add  BLOCK_H
	ld   b, a
	
	dec  c				; Done all columns?
	jr   nz, .loop		; If not, loop
	ret
	
; =============== ActS_SpawnColEdge ===============
; Spawns the actor, if one is defined, for the column that got scrolled in.
; IN
; - L: Actor layout pointer
; - B: X Position
ActS_SpawnColEdge:
	ld   h, HIGH(wActLayoutFlags)
	ld   a, [hl]
	bit  ACTLB_NOSPAWN, a			; Is the actor prevented from spawning?
	ret  nz							; If so, return
	bit  ACTLB_SPAWNNORM, a			; Does this actor spawn normally?
	ret  z							; If not, return
	jr   ActS_SpawnFromLayout
	
; =============== ActS_SpawnColEdgeBehind ===============
; Spawns the actor, if one is defined, for the column opposite to the one that got scrolled in.
; Intended to only spawn actors that spawn from behind the screen, such as
; the large bees in Hard Man's stage.
; These actors are flagged with their own flag so that they are only spawned this way.
; IN
; - L: Actor layout pointer
; - B: X Position
ActS_SpawnColEdgeBehind:
	ld   h, HIGH(wActLayoutFlags)
	ld   a, [hl]
	bit  ACTLB_NOSPAWN, a			; Is the actor prevented from spawning?
	ret  nz							; If so, return
	bit  ACTLB_SPAWNBEHIND, a		; Does this actor spawn from behind?
	ret  z							; If not, return
	jr   ActS_SpawnFromLayout
	
	
; =============== ActS_SpawnFromLayout ===============
; Spawns an actor from an actor layout entry.
; IN
; - HL: Ptr to an wActLayoutFlags entry
; -  A: Value dereferenced from the above
; -  B: X Position
ActS_SpawnFromLayout:
	; The actor is being spawned, not to repeat that since it'll be active
	set  ACTLB_NOSPAWN, a
	ld   [hl], a
	
	;
	; Prepare the call to ActS_Spawn
	;
	
	; Y POSITION
	; Stored in bits0-2 of the wActLayoutFlags entry, representing the row number to spawn on.
	and  $07			; Filter unwanted bits out
	swap a				; From row number to pixels (A *= BLOCK_V)
	add  OBJ_OFFSET_Y	; Actor positions are sprite positions, so get offsetted by the hardware
	or   BLOCK_V-1		; Actor origin is at the bottom, so align it
	ld   [wActSpawnY], a
	
	; X POSITION
	; Comes from the loop itself, already accounts for that origin being at the center.
	ld   a, b
	add  OBJ_OFFSET_X		; It does not account for the hardware offset though
	ld   [wActSpawnX], a
	
	; ACTOR ID
	; Stored in the respective wActLayoutIds entry 
	ld   h, HIGH(wActLayoutIds)
	ld   a, [hl]
	ld   [wActSpawnId], a
	
	; ACTOR LAYOUT POINTER
	; Needed to know where to clear ACTLB_NOSPAWN on despawn.
	ld   a, l
	ld   [wActSpawnLayoutPtr], a
	
	jp   ActS_Spawn
	
; =============== ActS_SpawnLargeExpl ===============
; Spawns the eight explosion particles when a player or boss dies.
; These originate from the player's position and move outwards.
ActS_SpawnLargeExpl:
	ld   a, ACT_EXPLLGPART			; Explosion particle
	ld   [wActSpawnId], a
	xor  a							; Not part of the layout
	ld   [wActSpawnLayoutPtr], a
	ld   b, $08						; Spawn 8 of them
	ld   hl, ActS_ExplTbl			; Reading their settings off a table
	
	; In a loop, spawn the base actor, then alter their speed values.
.loop:
	push hl
	push bc
		call ActS_Spawn	; Spawn with default settings
		ld   e, l		; DE = Potentially a ptr to iActId
		ld   d, h
	pop  bc
	pop  hl
	ret  c				; Could it spawn? If not, abort early
	
	; byte0 - Sprite mapping
	inc  de ; iActRtnId
	inc  de ; iActSprMap
	ldi  a, [hl]		; Read byte0, seek to next
	ld   [de], a
	
	; byte5 - H Speed
	inc  de ; iActLayoutPtr
	inc  de ; iActXSub
	inc  de ; iActX
	inc  de ; iActYSub
	inc  de ; iActY
	inc  de ; iActSpdXSub
	inc  hl ; byte2
	inc  hl ; byte3
	inc  hl ; byte4
	inc  hl ; byte5
	ldi  a, [hl] 		; Read byte5, seek to next
	ld   [de], a		; Set subpixel speed
	inc  de ; iActSpdX
	xor  a
	ld   [de], a		; iActSpdX = 0
	
	; byte6 - V Speed
	inc  de ; iActSpdYSub
	ldi  a, [hl]		; Read byte6, seek to byte0 of next entry
	ld   [de], a		; Set subpixel speed
	inc  de ; iActSpdY
	xor  a
	ld   [de], a		; iActSpdY = 0
	
	dec  b				; Spawned all 8 particles?
	jr   nz, .loop		; If not, loop
	ret
	
; =============== ActS_SpawnAbsorb ===============
; Spawns the eight explosion particles when absorbing a weapon.
; These move inwards from the sides of the screen towards the center,
; which is where the player is expected to be.
ActS_SpawnAbsorb:
	ld   a, ACT_EXPLLGPART			; Explosion particle
	ld   [wActSpawnId], a
	xor  a							; Not part of the layout
	ld   [wActSpawnLayoutPtr], a
	ld   b, $08						; Spawn 8 of them
	ld   hl, ActS_ExplTbl			; Reading their settings off a table

	; In a loop, spawn the base actor, then alter their starting position & speed values.
	; The only difference between this and ActS_SpawnLargeExpl is that this one copies
	; the starting positions and flips the particle directions.
.loop:
	push hl
	push bc
		call ActS_Spawn	; Spawn with default settings
		ld   e, l		; DE = Potentially a ptr to iActId
		ld   d, h
	pop  bc
	pop  hl
	ret  c				; Could it spawn? If not, abort early
	
	; byte0 - Sprite mapping
	inc  de ; iActRtnId
	inc  de ; iActSprMap
	ldi  a, [hl]			; Read byte0, seek to next
	xor  ACTDIR_R|ACTDIR_D	; Flip both directions to make them move inward	
	ld   [de], a
	
	;--
	; The X and Y positions retrieved from the table make the actor spawn from an edge of the screen.
	
	; byte1/2 - X Position
	inc  de ; iActLayoutPtr
	inc  de ; iActXSub
	ldi  a, [hl]	; Read byte1, seek to next
	ld   [de], a	; Set X subpixel pos
	inc  de ; iActX
	ldi  a, [hl]	; Read byte2, seek to next
	ld   [de], a	; Set X pos
	
	; byte2/3 - Y Position
	inc  de ; iActYSub
	ldi  a, [hl]	; Read byte3, seek to next
	ld   [de], a	; Set Y subpixel pos
	inc  de ; iActY
	ldi  a, [hl]	; Read byte4, seek to next
	ld   [de], a	; Set Y pos
	;--
	
	; byte5 - H Speed
	inc  de
	ldi  a, [hl] 		; Read byte5, seek to byte6
	ld   [de], a		; Set subpixel speed
	inc  de ; iActSpdX
	xor  a
	ld   [de], a		; iActSpdX = 0
	
	; byte6 - V Speed
	inc  de ; iActSpdYSub
	ldi  a, [hl]		; Read byte6, seek to byte0 of next entry
	ld   [de], a		; Set subpixel speed
	inc  de ; iActSpdY
	xor  a
	ld   [de], a		; iActSpdY = 0
	
	dec  b				; Spawned all 8 particles?
	jr   nz, .loop		; If not, loop
	ret
	
; =============== ActS_ExplTbl ===============
; Explosion particle table, contains settings for each of the 8 actors.
; Has settings used for both inwards and outwards explosions
MACRO mExplPart
	db \1 ; Directions (relative to outward explosion)
	dw \2 ; X Position
	dw \3 ; Y Position
	db \4 ; H Speed
	db \5 ; V Speed
ENDM
ActS_ExplTbl:
	;         DIR                X      Y     HSpd VSpd
	mExplPart $00,               $5800, $103C, $00, $FF
	mExplPart ACTDIR_R,          $8230, $21D0, $B4, $B4
	mExplPart ACTDIR_R,          $93C4, $4C00, $FF, $00
	mExplPart ACTDIR_R|ACTDIR_D, $8230, $7630, $B4, $B4
	mExplPart ACTDIR_D,          $5800, $87C4, $00, $FF
	mExplPart ACTDIR_D,          $2DD0, $7630, $B4, $B4
	mExplPart $00,               $1C3C, $4C00, $FF, $00
	mExplPart $00,               $2DD0, $21D0, $B4, $B4

; =============== ActS_SpawnRel ===============
; Spawns the specified actor, positioned relative to the currently processed one.
;
; Useful to spawn projectiles relative to the actor's origin.
; Obviously requires an actor being processed.
;
; After this is called, a new actor can be spawned using the same template
; by calling ActS_Spawn directly.
;
; IN
; - A: Actor ID
; - B: Relative X pos
; - C: Relative Y pos
; OUT
; - HL: Pointer to the actor slot with the newly spawned one.
;       Only valid if the following flag is clear.
; - C Flag: If set, the actor couldn't be spawned (no free slot found)
ActS_SpawnRel:
	ld   [wActSpawnId], a
	
	; These manually spawned actors aren't part of the actor layout, so they don't have a pointer associated to them.
	; As a consequence, as soon they despawn in any way, they are gone permanently.
	xor  a
	ld   [wActSpawnLayoutPtr], a
	
	; Set spawn pos relative to current
	ldh  a, [hActCur+iActX]	; Read base pos
	add  b					; add ours
	ld   [wActSpawnX], a	; Set as X spawn
	ldh  a, [hActCur+iActY]	; Same for Y pos
	add  c
	ld   [wActSpawnY], a
	
	; Fall-through
	
; =============== ActS_Spawn ===============
; Spawns an actor.
; IN
; - wActSpawnId
; - wActSpawnLayoutPtr
; - wActSpawnX
; - wActSpawnY
; OUT
; - HL: Pointer to the actor slot with the newly spawned one.
;       Only valid if the following flag is clear.
; - C Flag: If set, the actor couldn't be spawned (no free slot found)
ActS_Spawn:

	;
	; Find the first empty slot.
	; There's enough space to store $10 actors at most.
	;
	ld   hl, wAct		; HL = Ptr to first slot
.loop:
	ld   a, [hl]		; A = iActId
	or   a				; iActId == 0?
	jr   z, .found		; If so, the slot is free 
	ld   a, l			; Otherwise, seek to the next one
	add  iActEnd		; HL += $10
	ld   l, a
	jr   nz, .loop		; Reached the end of the actor area? ($00) If not, loop
	scf  				; Otherwise, C Flag = Set
	ret
	
.found:
	;
	; Initialize the actor's properties
	;
	push hl
		push hl ; Save base slot ptr
			
			; Actor ID
			; This merges it with a flag that's mandatory to draw and execute the actor's code.
			ld   a, [wActSpawnId]	
			or   ACTF_PROC
			ldi  [hl], a ; iActId
			
			; Start from the first routine
			xor  a
			ldi  [hl], a ; iActRtnId

			; And from the first sprite mapping, with no flags
			ldi  [hl], a ; iActSprMap
			
			; Set the actor layout pointer
			ld   a, [wActSpawnLayoutPtr]
			ldi  [hl], a ; iActLayoutPtr
			
			; Set spawn coords
			xor  a
			ldi  [hl], a	; iActXSub
			ld   a, [wActSpawnX]
			ldi  [hl], a	; iActX
			xor  a
			ldi  [hl], a	; iActYSub
			ld   a, [wActSpawnY]
			ld   [hl], a	; iActY
			
			;
			; Copy the collision data with this actor over.
			; To give actors more free space in the main struct wAct, this is written to the separate table wActColi.
			;
			; The entries here are in the same exact order as those in wAct, so to switch between the two
			; all that's needed is to inc/dec the high byte of the slot pointer.
			; ie: $CD10 has its collision data at $CE10
			;
			push af
				ld   a, BANK(ActS_ColiTbl) ; BANK $03
				ldh  [hRomBank], a
				ld   [MBC1RomBank], a
			pop  af
			
			; BC = wActSpawnId * 10
			; Typical way of doing it, by separating the two nybbles in two separate registers
			; and swapping their order.
			ld   a, [wActSpawnId]
			ld   c, a
			swap a			; B = wActSpawnId >> 4
			and  $0F
			ld   b, a
			ld   a, c		; C = wActSpawnId << 4
			swap a
			and  $F0
			ld   c, a
			
			; HL = Ptr to collision table entry
			ld   hl, ActS_ColiTbl
			add  hl, bc
			
		; DE = Ptr to wActColi slot
		pop  de					; DE = Ptr to wAct slot
		ld   d, HIGH(wActColi)	; And seek to the respective wActColi one
		
		; Copy the next four bytes as-is
		; iActColiBoxH, iActColiBoxV, iActColiType, iActColiDamage
		ld   b, $04					; B = Bytes to copy
	.cpLoop:
		ldi  a, [hl]
		ld   [de], a
		inc  de
		dec  b
		jr   nz, .cpLoop
		
		
		;
		; Calculate the actor's health.
		; This is mainly specified in byte4, the actor's health value... 
		;
		ld   b, [hl]	; B = byte4 (Health)
		inc  hl
		
		; ...however, the health plays a part with actors that override the default death actions.
		; The default death handler for non-boss actors just converts the actor into an explosion and spawns a randomized item drop.
		; Any actor that needs to do anything else (ie: killing a child actor, notifying another actor, ...) must set the override flag to $01.
		;
		; As for how this is implemented, the death handler knows nothing about overrides, so the whole thing is hacked around the health system.
		; Actors that override the death sequence are given 16 more health, and their code is expected to check if their health goes below 17,
		; executing their death logic if so. This higher threshold prevents the normal death handler from kicking in.
		; There are a few helper subroutines that check for that threshold and kill the actor, such as ActS_ChkExplodeNoChild 
		; and ActS_ChkExplodeWithChild.
		ld   a, [hl]	; A = byte5 (Override default death)
		swap a			; *= $10, which has effect if 
		add  b			; Add it over to the health
		ld   [de], a	; Save to iActColiHealth
		inc  de
		
		; No initial invuln timer
		xor  a
		ld   [de], a ; iActColiInvulnTimer
		
	pop  hl ; HL = Ptr to newly spawned actor slot
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== ActS_ReqLoadRoomGFX ===============
; Loads the actor graphics for the current room.
; Specifically, it triggers requests to load the graphics during VBlank,
; so they may take a couple of frames to fully load.
;
; Occasionally used to load generic sprite GFX sets.
ActS_ReqLoadRoomGFX:

	;
	; Each column in a level can be associated to a potential set of actor graphics,
	; with the table at wActLayoutIds potentially being able to map every column to an art request ID.
	;
	; This subroutine scans a room worth of columns, loading the first set found.
	; In practice, generally the actor layout is optimized to deliver a set ID immediately.
	;

	; HL = Starting pointer (wActLayoutIds + wLvlColL)
	ld   a, [wLvlColL]
	ld   l, a
	; B = Number of entries to scan
	ld   b, ROOM_COLCOUNT
	
.loop:

	;
	; If there's a request at the current column, apply that.
	;
	; As you may have noticed, this data is stored inside wActLayoutIds, which has the other important
	; purpose of defining actor IDs.
	;
	; How to distinguish between the two? 
	; Actors need to define some data in their respective wActLayoutFlags entry.
	; Art sets don't make use of it, and they MUST have this entry zeroed out.
	;
	
	; Otherwise we treat it as an actor ID (ie: not what we're looking for), so we skip to the next column
	ld   h, HIGH(wActLayoutFlags)
	ld   a, [hl]
	or   a
	jr   nz, .nextCol
	
	; Skip if there's no art set defined for this column
	ld   h, HIGH(wActLayoutIds)
	ld   a, [hl]
	or   a
	jr   z, .nextCol
	
; IN
; - A: Actor GFX set ID
.tryLoadBySetId:
	ld   hl, wActGfxId
	cp   [hl]			; Requesting the same set as last time?
	ret  z				; If so, return (graphics already loaded)
	
; IN
; - A: Actor GFX set ID
.loadBySetId:
	ld   [wActGfxId], a	; Mark as the currently loaded set
	
	; Index the set table and read out its entry
	ld   hl, ActS_GFXSetTbl
	sla  a				; 2 bytes/entry
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	; These requests are dumb, as there's no concept of loading actor GFX
	; at a dynamic address -- instead, the entire $80 tile area is copied over
	; directly from ROM with no way to mix and match, kinda like a CHR-ROM game.
	
	ld   b, [hl]		; B = [byte0] Source GFX bank number
	ld   c, $80			; C = Number of tiles to copy
	inc  hl
	ld   a, [hl]		; HL = [byte1] Source GFX ptr, with low byte hardcoded to $00
	ld   h, a
	ld   l, $00
	ld   de, $8800		; DE = VRAM Destination ptr
	jp   GfxCopy_Req	; Set up the request and return
	
.nextCol:
	inc  l				; Seek to the next column
	dec  b				; Checked all columns?
	jr   nz, .loop		; If not, loop
	ret ; We never get here

; =============== ActS_ChkExplodeWithChild ===============
; Checks if the actor has been defeated, and if so, makes it explode alongside its child.
;
; Used for actors that directly spawn a single child actor that work together.
; (ie: defeating a bee that's carrying a beehive should also despawn the latter)
;
; This cannot be used when there is more than one child actor at play, such as with Blocky's 
; 3 invulnerable sections, so those must handle it manually.
;
; OUT
; - C Flag: If set, the actor exploded
ActS_ChkExplodeWithChild:

	; Actors that keep track of a child slot die when their health reaches $10, not $00.
	; This is because actor health is decremented by the weapon shot collision code,
	; but that does not account for child actors, so if we used the normal thresold of $00,
	; only the parent would have died.
	; Which works for us, given actors that call ActS_ChkExplodeWithChild are assumed to be
	; those that perform special actions on death, and are given $10 more health for it.
	
	; The leads into the assumption that no weapon should deal more than 16 damage to these actors.

	call ActS_GetHealth
	cp   $11					; Health >= $11?
	ret  nc						; If so, return
	call ActS_Explode			; Otherwise, blow it up
	call ActS_TrySpawnItemDrop	; and maybe drop some items
	
	; Also despawn the child actor, but without showing an explosion.
	ld   h, HIGH(wAct)			; HL = Ptr to child slot
	ldh  a, [hActCur+iActChildSlotPtr]
	ld   l, a
	xor  a
	ldi  [hl], a ; wActId		; Despawn the actor
	
	;##
	; This part doesn't affect anything, as despawning the actor means it won't get drawn or executed.
	
	ldi  [hl], a ; iActRtnId
	ldi  [hl], a ; iActSprMap, seek to iActLayoutPtr
	
	; Move the child actor 4px above 
	ld   a, l					; Seek to iActY
	add  iActY-iActLayoutPtr
	ld   l, a
	ld   a, [hl]				; iActY -= 4
	sub  $04
	ld   [hl], a
	;##
	
	scf							; C Flag = Set
	ret
	
; =============== ActS_ChkExplodeNoChild ===============
; Variation of ActS_ChkExplodeWithChild used when the child actor doesn't need
; to be affected by the parent's death anymore, or when the actor needs to perform
; code on death, that otherwise wouldn't be executed with the normal death routine.
;
; This exists due to the health value still accounting for the $10 threshold.
;
; OUT
; - C Flag: If set, the actor exploded
ActS_ChkExplodeNoChild:
	call ActS_GetHealth
	cp   $11					; Health >= $11?
	ret  nc						; If so, return
	call ActS_Explode			; Otherwise, blow it up
	call ActS_TrySpawnItemDrop	; and maybe drop some items
	scf							; C Flag = Set
	ret
	
; =============== ActS_Explode ===============
; Makes the current actor explode.
; Specifically, it converts the currently processed actor into an explosion,
; using equivalent code to what Wpn_OnActColi.actDeadTp does.
ActS_Explode:
	; Replace ID with the explosion one
	ld   a, ACTF_PROC|ACT_EXPLSM
	ldh  [hActCur+iActId], a
	
	xor  a
	ldh  [hActCur+iActRtnId], a
	ldh  [hActCur+iActSprMap], a
	
	; Make the actor intangible, as explosions shouldn't damage the player.
	ld   h, HIGH(wActColi)		; HL = Ptr to respective collision entry
	ld   a, [wActCurSlotPtr]
	ld   l, a
	
	inc  l ; iActColiBoxV
	inc  l ; iActColiType
	xor  a
	ld   [hl], a				; Set ACTCOLI_PASS
	ret
	
; =============== ActS_TrySpawnItemDrop ===============
; Spawns a random item drop from the current actor's location, if any.
ActS_TrySpawnItemDrop:
	call Rand			; Roll the dice
	
	; $4D-$FF: Nothing (~70%)
	cp   $4D			; A >= $4D?
	ret  nc				; If so, don't spawn anything
	
	; The order of the actor IDs directly influences their rarity.
	; The lower its ID, the rarer it is.
	
	; $26-$4C: Small Weapon Energy (~15%)
	ld   b, ACT_AMMOSM
	cp   $26
	jr   nc, .spawn
	
	; $0A-$25: Large Life Energy (~11%)
	dec  b ; ACT_HEALTHSM
	cp   $0A
	jr   nc, .spawn
	
	; $06-$09: Large Life Energy (~1.5%)
	dec  b ; ACT_HEALTHLG
	cp   $06
	jr   nc, .spawn
	
	; $03-$05: Large Weapon Energy (~1%)
	dec  b ; ACT_AMMOLG
	cp   $03
	jr   nc, .spawn
	
	; $00-$02: Extra Life (~1%)
	dec  b ; ACT_1UP
	
.spawn:
	ld   a, b
	ld   [wActSpawnId], a
	
	xor  a							; Not part of the actor layout
	ld   [wActSpawnLayoutPtr], a
	
	; Spawn the item at the same position of the current actor (which we just defeated)
	; Note that the actor code (Act_Item) will move it slightly above that location,
	; to make it closer to the center of the explosion.
	; A more accurate way would have been to offset wActSpawnY here, since we still
	; have the actor's collision radius at hand.
	ld   h, HIGH(wAct)			; Seek HL to iActX
	ld   a, [wActCurSlotPtr]
	add  iActX
	ld   l, a
	ldi  a, [hl]				; wActSpawnX = iActX
	ld   [wActSpawnX], a
	inc  l
	ld   a, [hl]				; wActSpawnY = iActY
	ld   [wActSpawnY], a
	
	call ActS_Spawn				; Did it spawn?
	ret  c						; If not, return
	
	; Items by default spawn as fixed collectables.
	; Make them item drops instead.
	inc  l ; iActRtnId
	ld   a, ACTRTN_ITEMDROP_INIT
	ld   [hl], a
	ret
	
; =============== ActS_CountById ===============
; Counts:
; - The active slots with the specified actor ID
; - Number of active slots
; Used to limit how many actors a parent can spawn.
;
; IN
; - A: Actor ID to match
; OUT
; - B: Actor count (with specified ID)
; - C: Actor count (total)
ActS_CountById:
	or   ACTF_PROC		; E = iActId to find
	ld   e, a			; (with the processing flag since all active slots have it)
	
	ld   bc, $0000		; Init counters
	ld   hl, wAct		; Start from first slot
.loop:
	ld   a, [hl]		; A = iActId
	or   a				; Is the slot empty?
	jr   z, .nextSlot	; If so, skip
	inc  c				; TotalCount++
	cp   e				; Does its ID match?
	jr   nz, .nextSlot	; If not, skip
	inc  b				; MatchCount++
.nextSlot:
	ld   a, l			; Seek to next slot
	add  iActEnd
	ld   l, a			; Overflowed back to the first one? 
	jr   nc, .loop		; If not, loop
	ret
	
; =============== ActS_SyncDirToSpawn ===============
; Makes the newly spawned actor face the same horizontal direction as its spawner.
; Can be used after an actor spawns another actor.
; IN
; - HL: Ptr to newly spawned actor slot
ActS_SyncDirToSpawn:
	inc  l ; iActRtnId
	inc  l ; iActSprMap
	ldh  a, [hActCur+iActSprMap]	; Get parent flags
	and  ACTDIR_R					; Filter direction
	ld   [hl], a					; Save to child iActSprMap
	ret
; =============== ActS_SyncRevDirToSpawn ===============
; Makes the newly spawned actor face the opposite horizontal direction as its spawner.
; Can be used after an actor spawns another actor.
; IN
; - HL: Ptr to newly spawned actor slot
ActS_SyncRevDirToSpawn:
	inc  l ; iActRtnId
	inc  l ; iActSprMap
	ldh  a, [hActCur+iActSprMap]	; Get parent flags
	and  ACTDIR_R					; Filter direction
	xor  ACTDIR_R					; Flip
	ld   [hl], a					; Save to child iActSprMap
	ret
; =============== ActS_SetSpeedX ===============
; Sets the current actor's horizontal speed.
; IN
; - BC: Speed (pixels + subpixels)
ActS_SetSpeedX:
	ld   a, c
	ldh  [hActCur+iActSpdXSub], a
	ld   a, b
	ldh  [hActCur+iActSpdX], a
	ret
; =============== ActS_SetSpeedY ===============
; Sets the current actor's vertical speed.
; IN
; - BC: Speed (pixels + subpixels)
ActS_SetSpeedY:
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	ret
; =============== ActS_FlipH ===============
; Flips the current actor's horizontal direction.
ActS_FlipH:
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	ret
; =============== ActS_FlipV ===============
; Flips the current actor's vertical direction.
ActS_FlipV:
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ret
; =============== ActS_ClrSprMapId ===============
; Resets the current actor's relative sprite mapping to return to the first frame.
ActS_ClrSprMapId:
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R|ACTDIR_D	; Keep direction flags only
	ldh  [hActCur+iActSprMap], a
	ret
; =============== ActS_IncRtnId ===============
; Increments the current actor's routine ID.
ActS_IncRtnId:
	ld   hl, hActCur+iActRtnId
	inc  [hl]
	ret
; =============== ActS_DecRtnId ===============
; Decrements the current actor's routine ID.
ActS_DecRtnId:
	ld   hl, hActCur+iActRtnId
	dec  [hl]
	ret
; =============== ActS_GetPlDistanceX ===============
; Gets the horizontal distance between the current actor and the player.
; OUT
; - A: Horizontal distance (always positive)
; - C Flag: If set, the player is to the right of the actor.
ActS_GetPlDistanceX:
	ld   a, [wPlRelX]		; B = wPlRelX
	ld   b, a
	ldh  a, [hActCur+iActX]	; A = iActX
	sub  b					; A = iActX - wPlRelX
	jr   nc, .ret			; Did we underflow? (Player is to the right) If not, return
	xor  $FF				; Otherwise, flip the result's sign
	inc  a
	scf  					; and set the C flag since that xor cleared it
.ret:
	ret
; =============== ActS_GetPlDistanceY ===============
; Gets the vertical distance between the current actor and the player.
; OUT
; - A: Vertical distance (always positive)
; - C Flag: If set, the player is below the actor.
ActS_GetPlDistanceY:
	; See above, but for Y positions
	ld   a, [wPlRelY]
	ld   b, a
	ldh  a, [hActCur+iActY]
	sub  b
	jr   nc, .ret
	xor  $FF
	inc  a
	scf  
.ret:
	ret
	
; =============== ActS_FacePl ===============
; Makes the current actor face towards the player.
ActS_FacePl:
	
	; If the player is within $30px behind the left edge of the screen,
	; force it to face right, potentially preventing a despawn.
	; $D0-$DF is the offscreen range, so there's no inconsistency when
	; the actor is after the right edge of the screen.
	ldh  a, [hActCur+iActX]
	cp   -$30						; iActX < $D0?
	jr   c, .calcDir				; If so, jump
	
	ldh  a, [hActCur+iActSprMap]	; Otherwise, force right direcion
	set  ACTDIRB_R, a
	ldh  [hActCur+iActSprMap], a
	ret
	
.calcDir:
	;
	; Set the direction flag depending on the player being to the left or the right of the actor.
	;
	
	ld   a, [wPlRelX]				; B = wPlRelX
	ld   b, a
	ldh  a, [hActCur+iActX]			; A = iActX

	; Calculate the result flags of iActX < wPlRelX (player on the right of the actor?)
	; If it is, the C flag will be set, so we can push it out to the MSB
	; to turn it into the appropriate ACTDIR_* value.
	cp   b							; iActX < wPlRelX? if so, C flag = set
	rra  							; Shift C flag to MSB
	and  ACTDIR_R					; Filter other bits out		
	ld   b, a						; Set to B
	
	ldh  a, [hActCur+iActSprMap]
	res  ACTDIRB_R, a				; Clear old flag
	or   b							; Replace it with new value
	ldh  [hActCur+iActSprMap], a	; Save back
	ret
	
; =============== ActS_Unused_FacePlY ===============
; [TCRF] Unreferenced code.
; Makes the current actor face towards the player in the vertical direction.
ActS_Unused_FacePlY:
	;
	; Set the direction flag depending on the player being above or below the actor.
	;
	
	ld   a, [wPlRelY]				; B = wPlRelY
	ld   b, a
	ldh  a, [hActCur+iActY]			; A = iActY

	; Calculate the result flags of iActY < wPlRelY (player below of the actor?)
	; If it is, the C flag will be set, so we can push it out to the MSB
	; to turn it into the appropriate ACTDIR_* value.
	cp   b							; iActX < wPlRelX? if so, C flag = set
	rra  							; Shift C flag to MSB
	and  ACTDIR_D<<1				; Filter other bits out (offset by 1)
	srl  a							; >> 1 to compensate
	ld   b, a						; Set to B
	
	ldh  a, [hActCur+iActSprMap]
	res  ACTDIRB_D, a				; Clear old flag
	or   b							; Replace it with new value
	ldh  [hActCur+iActSprMap], a	; Save back
	ret

; =============== ActS_SetColiBox ===============
; Sets the current actor's collision box size.
; IN
; - B: Horizontal radius
; - C: Vertical radius
ActS_SetColiBox:
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ld   [hl], b ; iActColiBoxH
	inc  hl
	ld   [hl], c ; iActColiBoxV
	ret
	
; =============== ActS_SetColiType ===============
; Sets the current actor's collision type.
; IN
; - B: Collision type (ACTCOLI_*)
ActS_SetColiType:
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	add  iActColiType
	ld   l, a
	ld   [hl], b
	ret
	
; =============== ActS_SetHealth ===============
; Sets the current actor's health.
; IN
; - B: Health amount
ActS_SetHealth:
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	add  iActColiHealth
	ld   l, a
	ld   [hl], b
	ret
	
; =============== ActS_GetHealth ===============
; Gets the current actor's health.
; OUT
; - A: Health amount
ActS_GetHealth:
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	add  iActColiHealth
	ld   l, a
	ld   a, [hl]
	ret
	
; =============== ActS_SetSprMapId ===============
; Sets the current actor's base sprite mapping ID.
; IN
; - A: Sprite mapping ID ($00-$07)
ActS_SetSprMapId:
	; This is stored into bits3-5 of iActSprMap
	; B = A << 3
	sla  a		
	sla  a
	sla  a
	ld   b, a
	
	; Update iActSprMap
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R|ACTDIR_D			; Keep direction flags only
	or   b							; Merge with new ID
	ldh  [hActCur+iActSprMap], a
	ret
	
; =============== ActS_Anim2 ===============
; Animates the actor's 2 frame animation.
; This and all other animation functions work on the relative sprite mapping ID,
; so the actual sprite ID shown is offset by wActCurSprMapBaseId.
; IN
; - C: Animation speed
ActS_Anim2:
	
	ldh  a, [hActCur+iActSprMap]	; Preserve the old directions to B
	and  ACTDIR_R|ACTDIR_D
	ld   b, a
	
	;
	; This and other ActS_Anim* cycles are accomplished by adding an arbitrary value to the
	; animation timer stored in iActSprMap, then modulo-ing the result.
	;
	; This timer is stored in the lower 3 bits of iActSprMap, while the relative sprite 
	; mapping ID uses the next 3 bits after that. Therefore, it eventually will overflow,
	; triggering the frame change.
	;
	
	ldh  a, [hActCur+iActSprMap]
	add  c							; Add to anim timer
	and  $0F						; Force sprite mapping ID in range $00-$01
	or   b							; Add back old directions
	ldh  [hActCur+iActSprMap], a
	ret
	
; =============== ActS_Anim4 ===============
; Animates the actor's 4 frame animation.
; IN
; - C: Animation speed
ActS_Anim4:
	ldh  a, [hActCur+iActSprMap]	; Preserve the old directions to B
	and  ACTDIR_R|ACTDIR_D
	ld   b, a
	
	ldh  a, [hActCur+iActSprMap]
	add  c							; Add to anim timer
	and  $1F						; Force sprite mapping ID in range $00-$03
	or   b							; Add back old directions
	ldh  [hActCur+iActSprMap], a
	ret
	
; =============== ActS_AnimCustom ===============
; Animates the actor's frame cycle up to the specified frame.
; Used for actors with animation cycles not divisible by 2.
;
; IN
; - B: Max sprite mapping ID (exclusive)
; - C: Animation speed
ActS_AnimCustom:
	
	sla  b							; Shift max ID to proper place
	sla  b
	sla  b
	
	ldh  a, [hActCur+iActSprMap]	; Preserve the old directions to E
	and  ACTDIR_R|ACTDIR_D
	ld   e, a
	
	ldh  a, [hActCur+iActSprMap]
	add  c							; Add to anim timer
	ld   c, a						;--
		and  $07					; Preserve updated sub frame timer to D
		ld   d, a
	ld   a, c						;--
	
	and  $38						; Only keep the three sprite mapping ID bits
	cp   b							; Reached the target value?
	jr   nz, .save					; If not, jump
	xor  a							; Otherwise, loop it back to 0
	
.save:
	or   d							; Merge back subframe timer
	or   e							; Merge back directions
	ldh  [hActCur+iActSprMap], a
	ret
	
; =============== ActS_InitAnimRange ===============
; Sets up an actor's non-looping animation, using the consecutive range of sprite IDs specified.
; Each sprite lasts the same amount of time.
;
; Mainly used by boss intros.
;
; IN
; - D: Starting sprite mapping (inclusive)
; - E: Ending sprite mapping (inclusive)
; - C: Frame length
ActS_InitAnimRange:
	ld   a, $00
	ldh  [hActCur+iAnimRangeTimer], a
	; With the exception of the timer above, these fields will not be written back to during playback.
	ld   a, d
	ldh  [hActCur+iAnimRangeSprMapFrom], a
	ld   a, e
	ldh  [hActCur+iAnimRangeSprMapTo], a
	ld   a, c
	ldh  [hActCur+iAnimRangeFrameLen], a
	ret

; =============== ActS_PlayAnimRange ===============
; Handles the non-looping animation.
; Unlike other animation routines, this directly sets the base sprite ID to allow
; using a greater range of values, it also means the subroutine needs to be called
; every frame by the actor, otherwise the sprite is reset.
;
; OUT
; - Z Flag: If set, the animation hasn't finished playing
ActS_PlayAnimRange:

	; Advance its timer
	ldh  a, [hActCur+iAnimRangeTimer]
	add  $01
	ldh  [hActCur+iAnimRangeTimer], a
	
	; Get its fields out
	ldh  a, [hActCur+iAnimRangeSprMapFrom]	; D = Starting sprite / current
	ld   d, a   
	ldh  a, [hActCur+iAnimRangeSprMapTo]	; E = Ending sprite
	ld   e, a
	ldh  a, [hActCur+iAnimRangeFrameLen]	; C = Target frame length (will be multiplied for every frame)
	ld   c, a
	ld   b, a								; Separate copy to use as offset, which is used to multiply the above's running value
	
	;
	; What we want to calculate is this:
	; wActCurSprMapBaseId = MIN(iAnimRangeSprMapTo, iAnimRangeSprMapFrom + (iAnimRangeTimer / iAnimRangeFrameLen))
	;
	; The division is simulated through a loop, by finding how many times iAnimRangeFrameLen fits into iAnimRangeTimer.
	; Each loop increments the running copy of the sprite ID (initialized to iAnimRangeSprMapFrom).
	;
.loop:
	; If the timer has gone past the current target, check if we're done.
	; From the second sprite onwards, this will *always* trigger at least once.
	ldh  a, [hActCur+iAnimRangeTimer]
	cp   c								; Timer >= Target?
	jr   nc, .nextLoop					; If so, jump
	
.divFound:
	ld   a, d							; Set to wActCurSprMapBaseId the current sprite
	ld   [wActCurSprMapBaseId], a
	xor  a								; Z Flag = set
	or   a
	ret
	
.nextLoop:
	; Increment running sprite ID
	inc  d							
	
	; If we went *past* the last sprite, we're done
	ld   a, e
	cp   d							; LastSprite < CurSprite?
	jr   c, .done					; If so, we're done
	
	; Otherwise, set the division boundary for the target
	ld   a, c						; Target += iAnimRangeFrameLen
	add  b
	ld   c, a
	jr   .loop
	
.done:
	ld   a, e						; Cap the sprite ID to the last frame 
	ld   [wActCurSprMapBaseId], a
	ld   a, $01						; Z Flag = clear
	or   a
	ret
	
; =============== ActS_AngleToPl ===============
; Makes the actor move slowly at an angle towards the player.
; Used by actors that "track" a snapshot of the player's position, like carrots.
ActS_AngleToPl:

	; Target is 12 pixels above the player's origin.
	; This corresponds to the center of their body.
	ld   b, PLCOLI_V	
	
	; Fall-through
	
; =============== ActS_AngleToPlCustom ===============
; See above, but with a custom vertical offset.
; Used exclusively by the boss version of Metal Blades to track the player's origin rather than center of the body.
;
; IN
; - B: Target Y offset, relative to the player's origin
ActS_AngleToPlCustom:

	
	;
	; We are indexing a table of speed values by the current distance range between the actor and the player.
	; This table is set up to make the object travel at the same speed regardless of the angle it moves to.
	;
	; While the player may move later on, the speed values won't be updated manually.
	;
	; That needs an index first, which is split into the two coordinates.
	;
	
	;
	; PREPARATIONS
	;
	
	DEF tSprMapFlags = wColiGround
	DEF tActPlYDiff = wTmpCF52
	DEF tActPlXDiff = wTmpCF53
	
	; Shift the target Y coordinate up by <B> pixels.
	; If we got here from ActS_SetSpeedToPl, that makes it track the middle of the player.
	ld   a, [wPlRelY]
	sub  b
	ld   b, a
	
	; Reset speed & direction since we're writing those
	xor  a
	ld   [tSprMapFlags], a		; Default to upwards, left
	ldh  [hActCur+iActSpdX], a
	ldh  [hActCur+iActSpdY], a
	
	
.calcYDiff:
	;
	; Y COORDINATE
	;
	; tActPlYDiff = ABS(iActY - (wPlRelY - B))
	;
	
	; Find the distance between the actor's and player's Y coordinates.
	; In case that would be negative (player below the actor), invert it and set the downwards direction flag.
	
	ldh  a, [hActCur+iActY]		; A = iActY
	sub  b						; - TargetY
	jr   c, .plBelow			; Is that negative? (TargetY > iActY) If so, jump
.plAbove:
	ld   [tActPlYDiff], a		; Write the absolute distance
	jr   .calcXDiff
.plBelow:
	xor  $FF					; Invert to positive
	inc  a
	ld   [tActPlYDiff], a		; Write the absolute distance
	ld   a, [tSprMapFlags]		; Flag downwards movement
	set  ACTDIRB_D, a
	ld   [tSprMapFlags], a
	
.calcXDiff:
	;
	; X COORDINATE
	;
	; tActPlYDiff = ABS(iActX - wPlRelX)
	;
	
	; Identical to the above basically, except the X coordinate always points to the origin.
	ld   a, [wPlRelX]			; B = TargetX
	ld   b, a
	ldh  a, [hActCur+iActX]		; A = iActX
	sub  b						; - TargetX
	jr   c, .plRight			; Is that negative? (TargetX > iActX) If so, jump
.plLeft:
	ld   [tActPlXDiff], a		; Write the absolute distance
	jr   .findSpeed
.plRight:
	xor  $FF					; Invert to positive
	inc  a
	ld   [tActPlXDiff], a		; Write the absolute distance
	ld   a, [tSprMapFlags]		; Flag movement to the right
	set  ACTDIRB_R, a
	ld   [tSprMapFlags], a
	
	
.findSpeed:
	;
	; Read the subpixel speed values for both axes.
	;
	; The table of speed values is set up in a specific sawtooth pattern that allows
	; to get the complementary speed values for any given combination of distances.
	;
	; It also expects the index to be set up in a very specific way:
	; - The upper nybble should be the distance on the same axis of the speed value we want
	; - The lower nybble should be the distance on the opposite axis
	;
	; For example, if we want the *horizontal* speed, the upper nybble should contain the *horizontal* distance,
	; while the lower nybble the *vertical* distance.
	;
	; As a result, the table entries are split in groups of $10, each for any of the possible "same axis" distances.
	; The downwards sawtooth pattern used in all of them makes sure that, as the distance on the opposite
	; axis grows, the speed on the main one gets reduced.
	;
	; To go with that, the speed values across different groups is specifically chosen so that swapping
	; the nybbles of the index will give out the complementary speed for the other axis.
	; 
	; To cut down on the table size, only the upper nybbles of each distance is kept, 
	; essentially dividing the playfield into a 16x16 grid of unique speed values.
	;

	;
	; X SPEED
	;
	ld   hl, ActS_DistToSpdTbl		; HL = Table base
	ld   a, [tActPlXDiff]			; X Diff is high nybble (& $F0)
	and  $F0
	ld   b, a
	ld   a, [tActPlYDiff]			; Y Diff is low nybble (/ $10)
	and  $F0
	swap a
	or   b							; Merge the two
	; At this point, the A register could have been saved elsewhere to avoid having to recalculate it later.
	; Pushing it here, then later on "pop af" and "swap a" was all that would've been needed to get the Y SPEED index.
	ld   b, $00
	ld   c, a
	add  hl, bc						; Index the table with it
	ld   a, [hl]
	ldh  [hActCur+iActSpdXSub], a	; Got the horizontal speed
	
	;
	; Y SPEED
	;
	ld   hl, ActS_DistToSpdTbl		; HL = Table base
	ld   a, [tActPlYDiff]			; Y Diff is high nybble (& $F0)
	and  $F0
	ld   b, a
	ld   a, [tActPlXDiff]			; X Diff is low nybble (/ $10)
	and  $F0
	swap a
	or   b							; Merge the two
	ld   b, $00
	ld   c, a
	add  hl, bc						; Index the table with it
	ld   a, [hl]
	ldh  [hActCur+iActSpdYSub], a	; Got the vertical speed
	
	; Save the updated direction flags, to let routines that move actors 
	; along the current direction to target the player properly.
	ldh  a, [hActCur+iActSprMap]
	and  $FF^(ACTDIR_R|ACTDIR_D)	; Delete directions from old value
	ld   b, a
	ld   a, [tSprMapFlags]			; Get new directions
	or   b							; Merge with old value
	ldh  [hActCur+iActSprMap], a	; Save back
	ret
	
	
; =============== ActS_InitCirclePath ===============
; Initializes the data for the circular path.
ActS_InitCirclePath:

	; Not used here, presumably leftover copypaste from ActS_InitAnimRange
	xor  a
	ldh  [hActCur+iActTimer], a
	
	;
	; Set the initial ActS_ArcPathTbl indexes & direction for both axes.
	;
	; These are respectively set to:
	; - X index: Increase index, start from the lowest value
	; - Y index: Decrease index, start from the highest value
	;
	; The indexes move back and forth from 0 to 88, and the closer one is to 0, 
	; the faster the actor will move to that particular direction.
	; 
	; The way the indexes are offsetted alongside the logic for flipping the actor
	; when it reaches its lowest speed makes for a circular path.
	;
	ld   a, ADR_INC_IDX|ADR_DEC_IDY	; Set index directions
	ldh  [hActCur+iArcIdDir], a
	xor  a							; Move fast horz
	ldh  [hActCur+iArcIdX], a
	ld   a, ARC_MAX					; Move slow vert
	ldh  [hActCur+iArcIdY], a
	ret
	
; =============== ActS_ApplyCirclePath ===============
; Moves the current actor along a circular path.
; IN
; - A: Circle size (ARC_*)
;      The higher this is, the smaller the arc is.
ActS_ApplyCirclePath:
	DEF tArcSize = wTmpCF52
	; Save this for later
	ld   [tArcSize], a
	
	;
	; Get the actor's speed from the table for the current indexes.
	;
	; Note that the speed is relative to the current direction, meaning
	; this *could* be used to handle both clockwise and anticlockwise paths.
	;
	
	; Speed values here are all subpixel-based
	xor  a
	ldh  [hActCur+iActSpdX], a
	ldh  [hActCur+iActSpdY], a
	
	; iActSpdXSub = ActS_ArcPathTbl[iArcIdX]
	ldh  a, [hActCur+iArcIdX]
	ld   hl, ActS_ArcPathTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ldh  [hActCur+iActSpdXSub], a
	
	; iActSpdYSub = ActS_ArcPathTbl[iArcIdY]
	ldh  a, [hActCur+iArcIdY]
	ld   hl, ActS_ArcPathTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ldh  [hActCur+iActSpdYSub], a
	
	;
	; Update the indexes to the next value, flipping the direction as needed only
	; when the speed reaches near 0.
	; This flip timing is important to make the actor move on a proper circular path.
	;
	
	;
	; HORIZONTAL INDEX
	;
	
.updX:
	ldh  a, [hActCur+iArcIdDir]
	bit  ADRB_DEC_IDX, a			; Decreasing the X index?
	jr   nz, .decX					; If so, jump
.incX:
	;
	; Increase the index by the arc size value amount we passed to the subroutine.
	; If it reaches the maximum value of ARC_MAX, make the actor turn horizontally
	; and, from the next frame, start decreasing the indexes.
	;
	; The higher this "size value" is, the more values are skipped, leading to smaller arcs
	; as the rotation will complete sooner. Hence why ARC_LG is $01 while ARC_SM is $02.
	; However, as it will also take half the time to do a full rotations, actors may want to
	; counterbalance it by calling ActS_HalfSpdSub after this subroutine returns.
	;
	
	ld   a, [tArcSize]				; iArcIdX += tArcSize
	ld   b, a
	ldh  a, [hActCur+iArcIdX]
	add  b
	ldh  [hActCur+iArcIdX], a
	
	; The equality check here brings an assumption.
	; ARC_MAX needs to be a multiple of tArcSize, otherwise we miss the specific value we check for.
	cp   ARC_MAX					; iArcIdX == ARC_MAX? (lowest speed)
	jr   nz, .updY					; If not, skip
	
	ldh  a, [hActCur+iArcIdDir]		; Start decreasing the index next time
	xor  ADR_DEC_IDX
	ldh  [hActCur+iArcIdDir], a
	ldh  a, [hActCur+iActSprMap]	; Turn around
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	jr   .updY
	
.decX:
	;
	; Decrease the index by the arc size we passed to the subroutine.
	; If it reaches the minimum value of start increasing the indexes.
	;
	
	ld   a, [tArcSize]				; iArcIdX -= tArcSize
	ld   b, a
	ldh  a, [hActCur+iArcIdX]
	sub  b
	ldh  [hActCur+iArcIdX], a
	
	or   a							; iArcIdX == 0? (max speed)
	jr   nz, .updY					; If not, skip
	
	ldh  a, [hActCur+iArcIdDir]		; Start increasing the index next time
	xor  ADR_DEC_IDX
	ldh  [hActCur+iArcIdDir], a
	
	
.updY:
	;
	; VERTICAL INDEX
	; Identical to the other one, just for the other axis.
	;
	ldh  a, [hActCur+iArcIdDir]
	bit  ADRB_DEC_IDY, a
	jr   nz, .decY
	
.incY:
	ld   a, [tArcSize]				; iArcIdY += tArcSize
	ld   b, a
	ldh  a, [hActCur+iArcIdY]
	add  b
	ldh  [hActCur+iArcIdY], a
	
	cp   ARC_MAX					; iArcIdY == ARC_MAX? (lowest speed)
	ret  nz							; If not, return
	
	ldh  a, [hActCur+iArcIdDir]		; Start decreasing the index next time
	xor  ADR_DEC_IDY
	ldh  [hActCur+iArcIdDir], a
	ldh  a, [hActCur+iActSprMap]	; Turn around
	xor  ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ret
	
.decY:
	ld   a, [tArcSize]				; iArcIdY -= tArcSize
	ld   b, a
	ldh  a, [hActCur+iArcIdY]
	sub  b
	ldh  [hActCur+iArcIdY], a
	or   a
	ret  nz
	ldh  a, [hActCur+iArcIdDir]		; Start increasing the index next time
	xor  ADR_DEC_IDY
	ldh  [hActCur+iArcIdDir], a
	ret
	
; =============== ActS_HalfSpdSub ===============
; Halves the actor's *subpixel* speed.
; Only the subpixel speed is affected, this assumes the pixel speed is both zero.
; Code that goes through ActS_AngleToPl is a good candidate. 
ActS_HalfSpdSub:
	; iActSpdXSub /= 2
	ldh  a, [hActCur+iActSpdXSub]
	srl  a
	ldh  [hActCur+iActSpdXSub], a
	; iActSpdYSub /= 2
	ldh  a, [hActCur+iActSpdYSub]
	srl  a
	ldh  [hActCur+iActSpdYSub], a
	ret
	
; =============== ActS_DoubleSpd ===============
; Doubles the actor's speed.
ActS_DoubleSpd:
	; iActSpdX *= 2
	ldh  a, [hActCur+iActSpdXSub]
	sla  a							; *2 sub
	ldh  [hActCur+iActSpdXSub], a
	ldh  a, [hActCur+iActSpdX]
	rl   a							; *2 main, shift in carry
	ldh  [hActCur+iActSpdX], a
	; iActSpdY *= 2
	ldh  a, [hActCur+iActSpdYSub]
	sla  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  a, [hActCur+iActSpdY]
	rl   a
	ldh  [hActCur+iActSpdY], a
	ret
	
; =============== ActS_GetBlockIdFwdGround ===============
; Gets the block ID that collides with the actor's forward ground sensor.
; OUT
; - A: Block ID
; - C Flag: If set, the block is not solid
; - wPlYCeilMask: Ceiling collision mask
ActS_GetBlockIdFwdGround:
	; This is basically a wrapper to Lvl_GetBlockId
	
	; B = Actor's collision box width 
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   b, a
	
	; Y Target is on the ground
	ldh  a, [hActCur+iActY]
	inc  a					; one pixel below the origin
	ld   [wTargetRelY], a
	
	; X Target depends on whatever direction we're facing
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a		; Facing right?
	jr   nz, .chkR			; If so, it's on the right corner
.chkL:						; Otherwise, the left corner
	ldh  a, [hActCur+iActX]
	sub  b					
	ld   [wTargetRelX], a
	jp   Lvl_GetBlockId		; Bottom-left
.chkR:
	ldh  a, [hActCur+iActX]
	add  b
	ld   [wTargetRelX], a
	jp   Lvl_GetBlockId		; Bottom-right
	
; =============== ActS_GetGroundColi ===============
; Gets ground solidity flags for the current actor.
; Used exclusively to detect if the actor has moved off solid ground.
; OUT
; - wColiGround: Bitmask containing the ground solidity info.
;                Each bit, if set, marks that there's no solid ground at that position.
;                ------LR
;                L -> Bottom-left corner
;                R -> Bottom-right corner
;   In practice, this is only used by some actors that need to know if there's any
;   solid ground below (ie: both bits set) to make them fall down.
ActS_GetGroundColi:

	; Reset return value
	xor  a
	ld   [wColiGround], a
	
	DEF tActColiH = wTmpCF52
	
	; Read out the actor's collision box width to a temp area
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   [tActColiH], a
	
	;
	; Do the collision checks and store their result into wColiGround.
	;
	; This needs to detect if there's currently any solid block on the ground in either direction.
	; To do that, two sensors are needed, one on each side, both on the ground.
	;
	; There is no center sensor here, but it doesn't matter.
	;
	
	; Y coordinate of the sensor is fixed, it's one pixel below the origin
	ldh  a, [hActCur+iActY]
	inc  a
	ld   [wTargetRelY], a
	
	; LEFT SIDE
	ld   a, [tActColiH]			; Get radius width
	ld   b, a
	ldh  a, [hActCur+iActX]		; Get X position
	sub  b						; Move to left border
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; Solid block there? (if not, C flag set)
	
	ld   hl, wColiGround		; Shift to bit0
	rl   [hl]
	
	; RIGHT SIDE
	ld   a, [tActColiH]			; Get radius width
	ld   b, a
	ldh  a, [hActCur+iActX]		; Get X position
	add  b						; Move to right border
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; Solid block there? (if not, C flag set)
	
	ld   hl, wColiGround		; Shift to bit0, and the L one to bit1
	rl   [hl]
	ret
	
; =============== ActS_ApplySpeedFwdX ===============
; Moves the actor forward by the current horizontal speed.
ActS_ApplySpeedFwdX:
	; BC = SpeedX
	ldh  a, [hActCur+iActSpdXSub]
	ld   c, a
	ldh  a, [hActCur+iActSpdX]
	ld   b, a
	
	; "Forward" has different meanings depending on the direction we're facing
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a			; Facing right?
	jr   nz, .moveR				; If so, jump
.moveL:
	; XPos -= SpeedX
	ldh  a, [hActCur+iActXSub]
	sub  c
	ldh  [hActCur+iActXSub], a
	ldh  a, [hActCur+iActX]
	sbc  b
	ldh  [hActCur+iActX], a
	
	;
	; Offscreen despawn check.
	; When actors are within range $D0-$DF, they are despawned for being offscreen.
	;
	; This leaves a window of:
	; - $30px to right of the screen
	; - $20px to the left of the screen
	;
	; Meaning it's easier to offscreen actors when moving right.
	;
	and  $F0
	cp   $D0					; (iActX % $F0) == $D0?
	jp   z, ActS_Despawn		; If so, despawn it
	ret
	
.moveR:
	; XPos += SpeedX
	ldh  a, [hActCur+iActXSub]
	add  c
	ldh  [hActCur+iActXSub], a
	ldh  a, [hActCur+iActX]
	adc  b
	ldh  [hActCur+iActX], a
	
	; See above
	and  $F0
	cp   $D0
	jp   z, ActS_Despawn
	ret
	
; =============== ActS_ApplySpeedFwdXColi ===============
; Moves the actor forward by the current horizontal speed, while checking for solid collision. 
ActS_ApplySpeedFwdXColi:
	; Read out the actor's collision box size to a temp area
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   [wTmpColiBoxH], a
	ld   a, [hl]
	ld   [wTmpColiBoxV], a
	
	; BC = SpeedX
	ldh  a, [hActCur+iActSpdXSub]
	ld   c, a
	ldh  a, [hActCur+iActSpdX]
	ld   b, a
	
	; "Forward" has different meanings depending on the direction we're facing.
	; This will affect our horizontal collision targets, to make them point either
	; to the left or right border.
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a			; Facing right?
	jr   nz, .moveR				; If so, jump
.moveL:
	
	DEF tNewXPosSub = wTmpCF52
	DEF tNewXPos    = wTmpCF53
	
	;
	; Calculate the potential new X position
	; NewYPos = XPos - BC
	;
	ldh  a, [hActCur+iActXSub]
	sub  c
	ld   [tNewXPosSub], a
	ldh  a, [hActCur+iActX]
	sbc  b
	ld   [tNewXPos], a
	
	; Standard off-screen despawn check (see: ActS_ApplySpeedFwdX)
	and  $F0
	cp   $D0
	jp   z, ActS_Despawn
	
	;
	; The collision target is on the left border
	; wTargetRelX = tNewXPos - wTmpColiBoxH
	;
	ld   a, [wTmpColiBoxH]
	ld   b, a
	ld   a, [tNewXPos]
	sub  b
	ld   [wTargetRelX], a
	jr   .chkColi
.moveR:

	;
	; Calculate the potential new X position
	; NewYPos = XPos + BC
	;
	ldh  a, [hActCur+iActXSub]
	add  c
	ld   [tNewXPosSub], a
	ldh  a, [hActCur+iActX]
	adc  b
	ld   [tNewXPos], a
	
	; Standard off-screen despawn check (see: ActS_ApplySpeedFwdX)
	and  $F0
	cp   $D0
	jp   z, ActS_Despawn
	
	;
	; The collision target is on the right border
	; wTargetRelX = tNewXPos + wTmpColiBoxH
	;
	ld   a, [wTmpColiBoxH]
	ld   b, a
	ld   a, [tNewXPos]
	add  b
	ld   [wTargetRelX], a
	
.chkColi:

	;
	; Check for collision on the forward border.
	;
	; This goes off three sensors:
	; - Top-forward corner
	; - Middle-forward
	; - Bottom-forward corner
	;
	; If any if these points to a solid block, no movement is made.
	;
	
	;
	; BOTTOM-FWD
	; wTargetRelY = iActY
	;
	ldh  a, [hActCur+iActY]	
	ld   [wTargetRelY], a	; The origin is at the bottom, so it matches
	call Lvl_GetBlockId
	ret  nc
	
	;
	; MIDDLE-FWD
	; wTargetRelY -= wTmpColiBoxV
	;
	ld   a, [wTmpColiBoxV]
	ld   b, a
	ld   a, [wTargetRelY]
	sub  b					; subtract the vertical radius to get to the middle
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	
	;
	; TOP-FWD
	; wTargetRelY -= wTmpColiBoxV
	;
	ld   a, [wTmpColiBoxV]
	ld   b, a
	ld   a, [wTargetRelY]
	sub  b					; subtract the vertical radius again to get to the top
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	
	;
	; Passed the gauntlet, save the new position
	;
	ld   a, [tNewXPosSub]
	ldh  [hActCur+iActXSub], a
	ld   a, [tNewXPos]
	ldh  [hActCur+iActX], a
	ret
	
; =============== ActS_ApplySpeedFwdY ===============
; Moves the actor forward by the current vertical speed.
ActS_ApplySpeedFwdY:
	; BC = SpeedY
	ldh  a, [hActCur+iActSpdYSub]
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	ld   b, a
	
	; "Forward" has different meanings depending on the direction we're facing.
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_D, a				; Is the bit set?
	jr   nz, .moveD					; If so, we're moving down
	
.moveU:
	; YPos -= SpeedY
	ldh  a, [hActCur+iActYSub]
	sub  c
	ldh  [hActCur+iActYSub], a
	ldh  a, [hActCur+iActY]
	sbc  b
	ldh  [hActCur+iActY], a
	
	; Standard off-screen above check (see also: ActS_ApplySpeedUpY)
	and  $F0				; $00-$0F
	cp   $00
	jp   z, ActS_Despawn
	ret
	
.moveD:
	; YPos += SpeedY
	ldh  a, [hActCur+iActYSub]
	add  c
	ldh  [hActCur+iActYSub], a
	ldh  a, [hActCur+iActY]
	adc  b
	ldh  [hActCur+iActY], a
	
	; Standard off-screen below check (see also: ActS_ApplySpeedDownY)
	and  $F0				; $A0-$AF
	cp   $A0
	jp   z, ActS_Despawn
	ret
	
; =============== ActS_ApplySpeedFwdYColi ===============
; Moves the actor forward by the current vertical speed, while checking for solid collision.
; 
; See also: ActS_ApplySpeedFwdY, ActS_ApplySpeedFwdXColi
ActS_ApplySpeedFwdYColi:

	; Read out the actor's collision box size to a temp area
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   [wTmpColiBoxH], a
	ld   a, [hl]
	ld   [wTmpColiBoxV], a
	
	; BC = SpeedY
	ldh  a, [hActCur+iActSpdYSub]
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	ld   b, a
	
	DEF tNewYPosSub = wTmpCF52
	DEF tNewYPos    = wTmpCF53
	
	; "Forward" has different meanings depending on the direction we're facing.
	; We need to check for collision on either the top or bottom border, depending on that.
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_D, a			; Is the bit set?
	jr   nz, .moveD				; If so, we're moving down
	
.moveU:
	; YPos -= SpeedY
	ldh  a, [hActCur+iActYSub]
	sub  c
	ld   [tNewYPosSub], a
	ldh  a, [hActCur+iActY]
	sbc  b
	ld   [tNewYPos], a
	
	; Standard off-screen above check (see also: ActS_ApplySpeedUpY)
	and  $F0				; $00-$0F
	cp   $00
	jp   z, ActS_Despawn
	
	; The sensors are at the top border.
	ld   a, [wTmpColiBoxV]	; Get vertical radius
	sla  a					; From radius to height
	ld   b, a
	ld   a, [tNewYPos]		; Get new Y pos
	sub  b					; Move up to the top border
	ld   [wTargetRelY], a	; That's the target
	
	jr   .chkColi
	
.moveD:
	; YPos += SpeedY
	ldh  a, [hActCur+iActYSub]
	add  c
	ld   [tNewYPosSub], a
	ldh  a, [hActCur+iActY]
	adc  b
	ld   [tNewYPos], a
	
	; Standard off-screen below check (see also: ActS_ApplySpeedDownY)
	and  $F0				; $A0-$AF
	cp   $A0
	jp   z, ActS_Despawn
	
	; The sensors are 1 pixel below the bottom border,
	; as the actor shouldn't sink inside the solid block.
	ld   a, [tNewYPos]
	inc  a
	ld   [wTargetRelY], a
	
.chkColi:
	;
	; Check for collision on the previouly set border.
	;
	; Uses three sensors along that border:
	; - Left corner
	; - Center
	; - Right corner
	;
	; If any of them points to a solid block, the actor won't move there.
	;

	;
	; CENTER
	;
	ldh  a, [hActCur+iActX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ret  nc
	
	;
	; LEFT CORNER
	;
	ld   a, [wTmpColiBoxH]
	ld   b, a
	ldh  a, [hActCur+iActX]
	sub  b
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ret  nc
	
	;
	; RIGHT CORNER
	;
	ld   a, [wTmpColiBoxH]
	ld   b, a
	ldh  a, [hActCur+iActX]
	add  b
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ret  nc
	
	; Save back the changes if we passed the checks
	ld   a, [tNewYPosSub]
	ldh  [hActCur+iActYSub], a
	ld   a, [wTmpCF53]
	ldh  [hActCur+iActY], a
	ret
	
; =============== ActS_Unused_ApplySpeedFwdY ===============
; [TCRF] Unreferenced code.
; Moves the actor forward by the current vertical speed.
ActS_Unused_ApplySpeedFwdY: 
	; "Forward" has different meanings depending on the direction we're facing
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_D, a				; Facing down?
	jr   nz, ActS_ApplySpeedDownY	; If so, jump

; =============== ActS_ApplySpeedUpY ===============
; Moves the current actor *upwards* by the current vertical speed.
; Applies downwards gravity at 0.125px/frame.
;
; "Upwards" highly emphasized, this is the other way around
; compared to the more normal ActS_ApplySpeedDownY, where the speed gets
; added to the vertical position, moving you down instead.
;
; OUT
; - C flag: If set, the actor could move.
;           If clear, it couldn't (its vertical speed has been reduced to 0)
;           Typically the calling code should check for this 
;           and switch to somewhere else.
ActS_ApplySpeedUpY:

	; Decrease updwards speed at 0.125px/frame
	; BC = YSpeed - $00.20
	ldh  a, [hActCur+iActSpdYSub]
	sub  $20
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	sbc  $00
	ld   b, a
	
	; If we didn't underflow the speed, apply it
	jr   nc, .moveUp
	
.end:
	; Otherwise, flip the vertical direction.
	; There's the assumption here that, since we were moving up, ACTDIR_D should be clear.
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_D				; Set ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	; And clear out the speed
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	; C Flag = Clear (can't move)
	ret
	
.moveUp:
	; Update the speed value
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	
	; YPos -= SpeedY
	ldh  a, [hActCur+iActYSub]
	sub  c
	ldh  [hActCur+iActYSub], a
	ldh  a, [hActCur+iActY]
	sbc  b
	ldh  [hActCur+iActY], a
	
	; If the actor in within vertical range $00-$0F, despawn it.
	; This is the very top of the room.
	and  $F0
	cp   $00
	jp   z, ActS_Despawn
	
	scf  ; C Flag = Set (can move)
	ret
	
; =============== ActS_ApplySpeedDownY ===============
; Moves the current actor *downwards* by the current vertical speed.
; Applies downwards gravity at 0.125px/frame.
ActS_ApplySpeedDownY:

	; Increase downwards speed at 0.125px/frame
	; BC = YSpeed + $00.20
	ldh  a, [hActCur+iActSpdYSub]
	add  $20
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	adc  $00
	ld   b, a
	
	; Cap the movement to 4px/frame
	cp   $04			; YSpeed < 4?
	jr   c, .moveDown	; If so, jump
	ld   bc, $0400		; Otherwise, cap
.moveDown:
	
	; Update the speed value
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	
	; YPos += SpeedY
	ldh  a, [hActCur+iActYSub]
	add  c
	ldh  [hActCur+iActYSub], a
	ldh  a, [hActCur+iActY]
	adc  b
	ldh  [hActCur+iActY], a
	
	; If the actor in within vertical range $A0-$AF, despawn it.
	; This is 32px below the bottom of the gameplay screen.
	and  $F0
	cp   $A0
	jp   z, ActS_Despawn
	scf  
	ret
	
; =============== ActS_Unused_ApplySpeedFwdYColi ===============
; [TCRF] Unreferenced code.
; Moves the actor forward by the current vertical speed, while checking for solid collision. 
ActS_Unused_ApplySpeedFwdYColi: 
	; "Forward" has different meanings depending on the direction we're facing
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_D, a					; Facing down?
	jp   nz, ActS_ApplySpeedDownYColi	; If so, jump

; =============== ActS_ApplySpeedUpYColi ===============
; Moves the current actor *upwards* by the current vertical speed, applying gravity.
; Gravity is reset is a solid block is hit, ending movement.
;
; Effectively a version of ActS_ApplySpeedUpY that checks for solid collision.
;
; OUT
; - C flag: If set, the actor could move.
ActS_ApplySpeedUpYColi:

	; Read out the actor's collision box size to a temp area
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   [wTmpColiBoxH], a
	ld   a, [hl]
	ld   [wTmpColiBoxV], a
	
	;--
	;
	; Update the gravity the same way ActS_ApplySpeedUpY does it
	;
	
	; Decrease updwards speed at 0.125px/frame
	; BC = YSpeed - $00.20
	ldh  a, [hActCur+iActSpdYSub]
	sub  $20
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	sbc  $00
	ld   b, a
	
	; If we didn't underflow the speed, apply it
	jr   c, .startFallAuto
	
	; Update the speed value
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	;--
	
	
	DEF tNewYPosSub = wTmpCF52
	DEF tNewYPos    = wTmpCF53
	
	;
	; Calculate the potential new Y position
	; NewYPos = YPos - BC
	;
	ldh  a, [hActCur+iActYSub]
	sub  c
	ld   [tNewYPosSub], a
	ldh  a, [hActCur+iActY]
	sbc  b
	ld   [tNewYPos], a
	
	;
	; Check for top collision.
	;
	; If, with the new position, the actor's top border would collide with a solid
	; block, do not move and stop the vertical movement.
	;
	; This goes off three sensors, all 1 pixel below the actor's top border:
	; - Top-left corner
	; - Top-center
	; - Top-right corner
	;
	; If any if these points to a solid block, no movement is made and the jump ends.
	;
	;
	
	;
	; Y COMPONENT
	; 
	; Since the origin is at the bottom edge of the sprite's collision box, but collision sizes are half-width:
	; wTargetRelY = tNewYPos - (wTmpColiBoxV * 2) + 1
	;
	ld   a, [wTmpColiBoxV]		; Get collision
	sla  a						; From radius to height
	dec  a						; 1 pixel below the edge, for some reason. 
								; This is inconsistent with similar collision checks like the one in ActS_ApplySpeedFwdYColi.
	ld   b, a
	ld   a, [tNewYPos]			; Get new Y pos
	sub  b						; Move up to 1px below the edge
	ld   [wTargetRelY], a		; That's the target
	
	;
	; X COMPONENT, CENTER
	;
	; The origin is already at the center of an actor, so:
	; wTargetRelX = iActX
	;
	ldh  a, [hActCur+iActX]		
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; Is it a solid block?
	jr   nc, .startFall			; If so, we're done
	
	;
	; X COMPONENT, LEFT
	; wTargetRelX = iActX - wTmpColiBoxH
	;
	ld   a, [wTmpColiBoxH]		; Get horz radius
	ld   b, a
	ldh  a, [hActCur+iActX]		; Get X position
	sub  b						; Subtract the radius
	ld   [wTargetRelX], a		; We have the left border
	call Lvl_GetBlockId
	jr   nc, .startFall
	
	;
	; X COMPONENT, RIGHT
	; wTargetRelX = iActX + wTmpColiBoxH
	;
	ld   a, [wTmpColiBoxH]		; Get horz radius
	ld   b, a
	ldh  a, [hActCur+iActX]		; Get X position
	add  b						; Add the radius
	ld   [wTargetRelX], a		; We have the left border
	call Lvl_GetBlockId
	jr   nc, .startFall
	
	;
	; SAVE CHANGES
	;
	
	; Save the updated Y coords back.
	ld   a, [tNewYPosSub]		; iActYSub = tNewYPosSub
	ldh  [hActCur+iActYSub], a
	ld   a, [tNewYPos]			; iActY = tNewYPos
	ldh  [hActCur+iActY], a
	
	; If the new position would cause the actor to move off-screen above, despawn it.
	and  $F0					; YPos >= $00 && YPos <= $0F?
	cp   $00
	jp   z, ActS_Despawn		; If so, delete it
	
	scf		; C Flag = Set (move ok)  
	ret
.startFallAuto:
	ccf		; We got here with "jr c", clear that
.startFall:
	; Zero out the vertical speed & subpixel value.
	; This makes falling down start with a consistent gravity value.
	push af ; Preserve cleared carry flag (does it matter?)
		xor  a
		ldh  [hActCur+iActYSub], a
		ldh  [hActCur+iActSpdYSub], a
		ldh  [hActCur+iActSpdY], a
	pop  af
	ret
	
; =============== ActS_ApplySpeedDownYColi ===============
; Moves the current actor *downwards* by the current vertical speed, applying gravity.
; Gravity is reset is a solid block is hit, ending movement.
;
; Like ActS_ApplySpeedUpYColi but for ActS_ApplySpeedDownY.
;
; OUT
; - C flag: If set, the actor could move.
ActS_ApplySpeedDownYColi:

	; Read out the actor's horizontal collision box size to a temp area
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   [wTmpColiBoxH], a
	
	;--
	;
	; Update the gravity the same way ActS_ApplySpeedDownY does it
	;
	
	; Increase downwards speed at 0.125px/frame
	; BC = YSpeed + $00.20
	ldh  a, [hActCur+iActSpdYSub]
	add  $20
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	adc  $00
	ld   b, a
	
	; Cap the movement to 4px/frame
	cp   $04			; YSpeed < 4?
	jr   c, .moveDown	; If so, jump
	ld   bc, $0400		; Otherwise, cap
.moveDown:

	; Update the speed value
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	
	DEF tNewYPosSub = wTmpCF52
	DEF tNewYPos    = wTmpCF53
	
	;
	; Calculate the potential new Y position
	; NewYPos = YPos + BC
	;
	ldh  a, [hActCur+iActYSub]
	add  c
	ld   [tNewYPosSub], a
	ldh  a, [hActCur+iActY]
	adc  b
	ld   [tNewYPos], a
	
	;
	; Check for collision on the bottom border:
	;
	; This goes off three sensors, all 1 pixel below the actor's top border:
	; - Bottom-left corner
	; - Bottom-center
	; - Bottom-right corner
	;
	; If any if these points to a solid block, movement stops and the actor is aligned to the ground.
	;
	
	inc  a						; The Y position is 1 pixel below the origin.
	ld   [wTargetRelY], a
	
	;
	; CENTER
	;
	ldh  a, [hActCur+iActX]		; wTargetRelX = origin
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, .stopFall
	
	;
	; LEFT
	;
	ld   a, [wTmpColiBoxH]		; wTargetRelX = origin - h radius
	ld   b, a
	ldh  a, [hActCur+iActX]
	sub  b
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, .stopFall
	
	;
	; RIGHT
	;
	ld   a, [wTmpColiBoxH]		; wTargetRelX = origin + h radius
	ld   b, a
	ldh  a, [hActCur+iActX]
	add  b
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, .stopFall
	
	; Save the updated Y coords back.
	ld   a, [tNewYPosSub]
	ldh  [hActCur+iActYSub], a
	ld   a, [tNewYPos]
	ldh  [hActCur+iActY], a
	
	; If the new position would cause the actor to move off-screen above, despawn it.
	and  $F0					; YPos >= $A0 && YPos <= $AF?
	cp   $A0
	jp   z, ActS_Despawn		; If so, delete it
	ret
	
.stopFall:
	; Zero out the vertical speed & subpixel value.
	xor  a
	ldh  [hActCur+iActYSub], a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	; Snap actor to the top of the 16x16 solid block
	ldh  a, [hActCur+iActY]
	or   $0F
	ldh  [hActCur+iActY], a
	ret
	
; =============== ActS_MoveByScrollX ===============
; Moves the current actor based on how much the player has scrolled the screen.
ActS_MoveByScrollX:
	
	; This is important since actor coordinates are relative to the screen,
	; so if the player scrolls it, actor positions need to be adjusted.
	
	ld   a, [wActScrollX]	; B = 
	ld   b, a
	ldh  a, [hActCur+iActX]
	add  b
	ldh  [hActCur+iActX], a
	
	; Standard off-screen despawn check (see: ActS_ApplySpeedFwdX)
	and  $F0
	cp   $D0
	ret  nz
	
; =============== ActS_Despawn ===============
; Despawns the current actor.
ActS_Despawn:

	;
	; When Rush Coil/Jet/Marine and the Sakugarne despawn, they have finished their teleport animation.
	; Clear that for later, otherwise they can't be called in again.
	;
	ldh  a, [hActCur+iActId]
	cp   ACTF_PROC|ACT_WPN_RC			; iActId < $E0?
	jr   c, .despawn	; If so, skip
	cp   ACTF_PROC|ACT_WPN_SG+1		; iActId >= $E4?
	jr   nc, .despawn	; If so, skip
	xor  a
	ld   [wWpnHelperWarpRtn], a
	
.despawn:
	; Mark the slot as free
	xor  a
	ldh  [hActCur+iActId], a
	
	; Allow the actor to respawn.
	; Since the actor is gone, it should be able to spawn again when scrolling towards its initial position.
	; Actors that call this subroutine and have a pointer set *always* do this.
	; If permadespawning is wanted (ie: collecting 1UPs) just mark the slot as free without doing anything else.
	ld   h, HIGH(wActLayoutFlags)			; (Could have been set later)
	ldh  a, [hActCur+iActLayoutPtr]
	or   a									; Is the actor part of the actor layout?
	ret  z									; If not, return (can't tell to respawn what's not there)
	ld   l, a								; Otherwise, seek HL to the wActLayoutFlags entry
	ld   a, [hl]
	res  ACTLB_NOSPAWN, a					; and disable nospawn flag
	ld   [hl], a
	ret
	
; =============== ActS_DrawSprMap ===============
; Draws an actor sprite mapping to the screen.
ActS_DrawSprMap:
	DEF tActSprFlags = wTmpCF52
	push af
		ld   a, BANK(ActS_SprMapPtrTbl) ; BANK $03
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	;
	; Actors with an invulnerability timer set should flash every 2 frames.
	; This will be used to calculate the effective OBJ flags value.
	; While we're here, also decrement that timer.
	;
	
	ld   a, [wActCurSlotPtr]	; HL = Ptr to current slot's iActColiInvulnTimer
	add  iActColiInvulnTimer	
	ld   l, a
	ld   h, HIGH(wActColi)
	
	ld   a, [hl]
	or   a						; iActColiInvulnTimer == 0?
	jr   z, .calcFlags			; If so, skip
	dec  [hl]					; iActColiInvulnTimer--
	
	; Shift the 2nd bit of the invuln timer (every 2 frames) into SPRB_OBP1
	and  $02					; Every 2 frames...
	sla  a						; ...bit2
	sla  a						; ...bit3
	sla  a						; ...bit4 (SPRB_OBP1)
	
	; And merge it with the player flags into the final value, to force all actors into
	; sharing the same SPR_BGPRIORITY flag as the player.
.calcFlags:
	; A will be 0 if we jumped to here (SPRB_OBP1 clear)
	ld   b, a					
	ld   a, [wPlSprFlags]
	or   b						
	ld   [tActSprFlags], a
	
	;--
	
	;
	; Find the sprite mapping associated with the current frame.
	; We have to go through two layers of pointer tables to get there.
	;
	
	;
	; FIRST ONE
	;
	; Indexed by actor IDs, each entry is a pointer to a table of other pointers.
	;
	
	; First, seek HL to the sprite mapping table associated to the current actor.
	ldh  a, [hActCur+iActId]
	and  $FF^ACTF_PROC			; Filter out active marker
	sla  a						; * 2
	ld   hl, ActS_SprMapPtrTbl
	ld   b, $00
	ld   c, a
	add  hl, bc					; Seek to the entry
	ldi  a, [hl]				; Read its pointer out to DE
	ld   e, a
	ld   a, [hl]
	ld   d, a
	ld   l, e					; and to HL
	ld   h, d
	
	;
	; SECOND ONE
	;
	; Indexed by sprite mapping ID, each entry is a pointer to the actual sprite mapping data.
	;
	; The index itself is not straightforward, two separate values are added together to make
	; it easier using relative offsets.
	; One of the values ("relative ID") is stored directly into the slot, the other ("base ID")
	; is a one-off that needs to be manually set each time the actor is processed.
	;
	
	; B = Base ID * 2
	ld   a, [wActCurSprMapBaseId]	; Read base ID
	sla  a							; Pointer table requirement
	ld   b, a
	; The relative ID is packed into just three bits of iActSprMap. (bits3-5)
	; This implies a big limit on the number of mappings animations can normally have.
	; A = (iActSprMap >> 2) & $0E
	ldh  a, [hActCur+iActSprMap]	
	srl  a							; Shift them down twice to bits1-5
	srl  a							; (not 3 times, due to pointer table reqs)
	and  $0E						; Filter out other bits
	add  b
	; Index the entry and read its pointer out to DE
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   e, a
	ld   a, [hl]
	ld   d, a
	
	;--
	
	;
	; Write the sprite mapping to the OAM mirror.
	;
	
	ldh  a, [hWorkOAMPos]	; HL = Ptr to current OAM slot
	ld   l, a
	ld   h, HIGH(wWorkOAM)
	
	;
	; The first byte of a mapping marks the number of individual OBJ they use.
	; Invisible frames point to a dummy mapping with an OBJ count of 0, so
	; return early in that case.
	;
	ld   a, [de]			; A = OBJCount
	or   a					; OBJCount == 0?
	jp   z, .end			; If so, we're done
	inc  de					; Otherwise, seek to the OBJ table
	ld   b, a				; B = OBJCount
	
	;
	; What follows are <OBJCount> tables with 4 entries each, that directly follow the same structure the OAM OBJ:
	; - Rel. Y pos
	; - Rel. X pos
	; - Tile ID
	; - OBJ Flags
	;
	
	; Two completely separate loops are used to handle horizontal flipping.
	; This is due to the relative positions between individual OBJ being inverted,
	; and it's also faster to perform the check only once.
	;
	; Note that vertical flipping isn't supported. The ACTDIR_D flag is only used to 
	; determine the "forward" vertical direction, but doesn't affect how the sprite is drawn.
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a		; Actor facing right?
	jr   nz, .loopR			; If so, jump
.loopL:

	;
	; NO FLIPPING
	; Nothing special here.
	;
	
	; YPos = iActY + byte0
	ldh  a, [hActCur+iActY]	; C = Absolute Y
	ld   c, a
	ld   a, [de]			; A = Relative Y
	inc  de					; Seek to byte1 for later
	add  c					; Get final pos
	ldi  [hl], a			; Write to OAM mirror
	
	; XPos = iActX + byte1
	ldh  a, [hActCur+iActX]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	
	; TileID = byte2
	ld   a, [de]
	inc  de
	ldi  [hl], a
	
	; Flags = byte3 | tActSprFlags
	; Curiously, the base flags are OR'd with ours, compared to the usual way of XOR'ing them.
	; This prevents an actor from overriding all options.
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [tActSprFlags]
	or   c
	ldi  [hl], a
	
	; If we reached the end of the OAM mirror, stop drawing any further OBJ.
	; [POI] While this could have also been checked at the start of the subroutine,
	;       in practice it's not an issue.
	;       Of the two places that call this subroutine, one of them performs this check
	;       before calling it, while the other is called while the OAM mirror is empty.
	ld   a, l
	cp   OAM_SIZE			; HL == $DFA0?
	jr   z, .full			; If so, abort (we're full)
	dec  b					; Finished copying all OBJ?
	jr   nz, .loopL			; If not, loop
	
	ld   a, l				; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	jr   .end
	
.loopR:

	;
	; HORIZONTAL FLIPPING
	; This needs to flip the individual OBJ alongside the sprite mapping itself.
	;
	
	; YPos = iActY + byte0
	ldh  a, [hActCur+iActY]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	
	; XPos = -(iActX + byte1) - TILE_H
	; For flipping the sprite mapping
	ldh  a, [hActCur+iActX]	; C = Absolute X
	ld   c, a
	ld   a, [de]			; A = Relative X
	inc  de					; Seek to byte2 for later
	xor  $FF				; Invert the rel. X position (offset by -1)
	sub  TILE_H-1			; Account for tile width
	add  c					; Get final pos
	ldi  [hl], a			; Write to OAM mirror
	
	; TileID = byte2
	ld   a, [de]
	inc  de
	ldi  [hl], a
	
	; Flags = (byte3 | tActSprFlags) ^ SPR_XFLIP
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [tActSprFlags]
	or   c
	xor  SPR_XFLIP			; Flip the individual OBJ graphic
	ldi  [hl], a
	
	; If we reached the end of the OAM mirror, stop drawing any further OBJ.
	ld   a, l
	cp   OAM_SIZE			; HL == $DFA0?
	jr   z, .full			; If so, abort (we're full)
	dec  b					; Finished copying all OBJ?
	jr   nz, .loopR			; If not, loop
	
	ld   a, l				; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	jr   .end
	
.full:
	ldh  [hWorkOAMPos], a	; Save back current OAM ptr
	
	; Since any further actors won't draw and their processing order is the draw order,
	; on the next frame start processing them from the current slot.
	; Note that the remaining actors *will* still get processed, just not drawn.
	ld   a, [wActCurSlotPtr]
	ld   [wActLastDrawSlotPtr], a	; Mark end of OAM reached
.end:
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== ActS_DistToSpdTbl ===============
; Maps every possible pair of distances to the respective speed values.
; Meant to be indexed using the current axis distance on the high nybble, and opposite axis distance on the lower nybble.
; See also: ActS_AngleToPlCustom
ActS_DistToSpdTbl:
	;  OPPOSITE AXIS ->                                                  | THIS AXIS                               
	;  $x0,$x1,$x2,$x3,$x4,$x5,$x6,$x7,$x8,$x9,$xA,$xB,$xC,$xD,$xE,$xF   v
	db $B4,$3E,$25,$19,$19,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$00,$00,$00 ; $0x
	db $F7,$B4,$6D,$56,$3E,$32,$32,$25,$25,$25,$19,$19,$19,$19,$19,$19 ; $1x
	db $FC,$E7,$B4,$83,$6D,$56,$4A,$3E,$3E,$32,$32,$32,$25,$25,$25,$25 ; $2x
	db $FE,$F0,$DB,$B4,$8E,$78,$6D,$56,$56,$4A,$3E,$3E,$3E,$32,$32,$32 ; $3x
	db $FE,$F7,$E7,$D4,$B4,$98,$83,$78,$62,$62,$56,$4A,$4A,$3E,$3E,$3E ; $4x
	db $FF,$FA,$F0,$E1,$CD,$B4,$98,$8E,$78,$6D,$62,$62,$56,$56,$4A,$4A ; $5x
	db $FF,$FA,$F4,$E7,$DB,$CD,$B4,$A2,$8E,$83,$78,$6D,$62,$62,$56,$56 ; $6x
	db $FF,$FC,$F7,$F0,$E1,$D4,$C5,$B4,$A2,$98,$83,$78,$78,$6D,$62,$62 ; $7x
	db $FF,$FC,$F7,$F0,$EC,$E1,$D4,$C5,$B4,$A2,$98,$8E,$83,$78,$6D,$6D ; $8x
	db $FF,$FC,$FA,$F4,$EC,$E7,$DB,$CD,$C5,$B4,$A2,$98,$8E,$83,$83,$78 ; $9x
	db $FF,$FE,$FA,$F7,$F0,$EC,$E1,$DB,$CD,$C5,$B4,$AB,$98,$8E,$8E,$83 ; $Ax
	db $FF,$FE,$FA,$F7,$F4,$EC,$E7,$E1,$D4,$CD,$BD,$B4,$AB,$A2,$98,$8E ; $Bx
	db $FF,$FE,$FC,$F7,$F4,$F0,$EC,$E1,$DB,$D4,$CD,$BD,$B4,$AB,$A2,$98 ; $Cx
	db $FF,$FE,$FC,$FA,$F7,$F0,$EC,$E7,$E1,$DB,$D4,$C5,$BD,$B4,$AB,$A2 ; $Dx
	db $FF,$FE,$FC,$FA,$F7,$F4,$F0,$EC,$E7,$DB,$D4,$CD,$C5,$BD,$B4,$AB ; $Ex
	db $FF,$FE,$FC,$FA,$F7,$F4,$F0,$EC,$E7,$E1,$DB,$D4,$CD,$C5,$BD,$B4 ; $Fx


; =============== ActS_ArcPathTbl ===============
; Table of speed values which, if cycled through every frame for both directions, allows actors to move in an arc.
; With careful flipping, it's also possible to make actors move on a circular path.
ActS_ArcPathTbl:
	;  $x0,$x1,$x2,$x3,$x4,$x5,$x6,$x7,$x8,$x9,$xA,$xB,$xC,$xD,$xE,$xF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE,$FD,$FC,$FB,$FA,$F9,$F8,$F7 ; $0x
	db $F6,$F5,$F3,$F2,$F1,$EF,$ED,$EC,$EA,$E8,$E6,$E4,$E2,$E0,$DE,$DB ; $1x
	db $D9,$D7,$D4,$D2,$CF,$CC,$CA,$C7,$C4,$C1,$BE,$BB,$B8,$B5,$B2,$AF ; $2x
	db $AB,$A8,$A5,$A1,$9E,$9A,$96,$93,$8F,$8B,$88,$84,$80,$7C,$78,$74 ; $3x
	db $70,$6C,$68,$64,$60,$5C,$58,$53,$4F,$4B,$47,$42,$3E,$3A,$35,$31 ; $4x
	db $2C,$28,$24,$1F,$1B,$16,$12,$0D,$09                             ; $5x
.end:
	; [POI] Table gets cut off, last two values are unused
	db $04,$00

; =============== Game_Main ===============
; Main sequence of operations.
Game_Main:
	ld   sp, WRAM_End
	push af
		ld   a, BANK(Module_Password) ; BANK $01
		ldh  [hRomBankLast], a
		ldh  [hRomBank], a
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
	
	call Game_Do ; Run gameplay
	call Pl_DoActColi ; Process player-actor collision
	call WpnS_Do ; BANK $01 ; Process on-screen shots 
	
	;
	; Run actor code.
	; Actor code is all stored in BANK $02, but may call code in BANK $00 that triggers a bankswitch.
	; To make those subroutines properly return, set $02 as the default bank when executing actors.
	;
	push af
		ld   a, BANK(ActS_Do) ; BANK $02
		ldh  [hRomBankLast], a
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	call ActS_Do
	push af
		ld   a, $01
		ldh  [hRomBankLast], a
		ldh  [hRomBank], a
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
	
; =============== Module_Game_PlDead ===============
; Gameplay loop when the player explodes.
; OUT
; - C Flag: If set, the player has not game overed.
; - wGameOverSel: Game Over selection, if the above is clear.
Module_Game_PlDead:
	
	;
	; Draw an empty health bar for the player.
	;
	xor  a
	ld   [wPlHealthInc], a		; Stop health refills, if any (Game_TickTime still called)
	ld   [wWpnAmmoInc], a		; Stop ammo refills, if any ""
	ld   [wPlHealthBar], a		; Zero out visible health
	ld   hl, wStatusBarRedraw	; Draw empty health bar
	set  BARID_PL, [hl]
	
	;
	; Handle the death sequence.
	; This mainly animates the slow large explosions, which unlike other games *always* happen on death.
	; Typically other games would skip it for pit deaths, but not this one (also because pits really are spikes).
	;
	ld   b, 60*3			; Do the effect for 3 seconds
.loop:						; As the timer ticks down to 0...
	push bc
		ld   a, b			
		cp   60*3			; immediately -> spawn 1st explosion, with SFX
		jr   z, .explode0
		cp   60*1+30		; after 1.5 seconds -> spawn 2nd explosion, with no SFX
		jr   z, .explode1
		jr   .playExpl
	.explode0:
		; The first explosion that spawns also plays its respective sound effect
		mStopSnd			; And kill the level music
		ld   a, SFX_EXPLODE
		mPlaySFX
	.explode1:
		; Use the origin coordinates set when we died.
		ld   a, [wExplodeOrgX]
		ld   [wActSpawnX], a
		ld   a, [wExplodeOrgY]
		ld   [wActSpawnY], a
		call ActS_SpawnLargeExpl
		
	.playExpl:
		rst  $08 ; Wait Frame
		
		;
		; Process/draw moving entities such as weapon shots and actors, just not the player.
		;
		
		xor  a						; Start drawing sprites
		ldh  [hWorkOAMPos], a
		
		call WpnS_Do ; BANK $01		; Process/draw shots
		push af
			ld   a, BANK(ActS_Do) ; BANK $02
			ldh  [hRomBankLast], a
			ldh  [hRomBank], a
			ld   [MBC1RomBank], a
		pop  af
		
		call ActS_Do				; Process/draw actors, including the explosion
		
		push af
			ld   a, $01
			ldh  [hRomBankLast], a
			ldh  [hRomBank], a
			ld   [MBC1RomBank], a
		pop  af
		
		call OAM_ClearRest			; Drawn everything
		call Game_TickTime			; Tick gameplay clock
		
	pop  bc				; B = Timer
	dec  b				; Has it elapsed?
	jr   nz, .loop		; If not, keep showing the anim
	
	;
	; Explosion animation has ended.
	; If we ran out of lives, show the password screen (then game over).
	;
	ld   a, [wPlLives]	; Lives--
	sub  $01
	ld   [wPlLives], a	; Did we ran out? (underflowed)
	jr   c, .gameOver		; If so, jump
	
	;
	; Otherwise, respawn at the appropriate checkpoint.
	; Every level has exactly four checkpoints assigned to it, of which:
	; - The first one is typically the start of the level
	; - The last one is assumed to be inside a boss corridor
	;
	; This data is stored inside a table indexed by level ID.
	; The four room IDs are ordered from lowest to highest, so we read them in reverse order,
	; stopping at the first that's behind the one the player reached. If all checks fail, peter out at the first checkpoint.
	;
	; This has a few implications on the level design, as room transitions need to take checkpoints in mind
	; when the path forward involves moving left, due to the linear nature of the level layout.
	;
	; There's also an oversight in here, which does need the player to commit to it though.
	; Nowhere in here does the game keep track of the last checkpoint reached, all calculations are around the player's position
	; within the level, so if you die to a checkpoint, respawn, then move behind the checkpoint and die again, you get sent further back.
	;
	
	ld   a, [wLvlId]	; A = Level ID
	add  a				; *4 as that's the entry size (how many checkpoints a level can have)
	add  a				; (that will make bits0-1 empty)
	or   $03			; Start checking from the last entry
	ld   hl, Lvl_CheckpointTbl
	ld   b, $00
	ld   c, a
	add  hl, bc			; Seek HL to last entry
	;--
	; Calculate the room ID, identically to Game_StartRoomTrs
	; A = Room ID (wLvlColL / $0A)
.getRoomNum:
	ld   b, $00
	ld   a, [wLvlColL]
.divLoop:
	cp   ROOM_COLCOUNT
	jr   c, .divDone
	inc  b
	sub  ROOM_COLCOUNT
	jr   .divLoop
.divDone:
	ld   a, b
	;--
	; Check from latest to earliest checkpoint, the first one that's smaller than our room ID.
	cp   [hl]			; RoomId >= Checkpoint3?
	jr   nc, .setBoss	; If so, use it
	dec  hl				; Seek to previous checkpoint
	cp   [hl]			; RoomId >= Checkpoint2?
	jr   nc, .setRoom	; ...
	dec  hl
	cp   [hl]			; RoomId >= Checkpoint1?
	jr   nc, .setRoom	; ...
	dec  hl				; Otherwise, use the first checkpoint (typically the start of the level)
.setRoom:
	;
	; Normal respawn.
	;
	ld   a, [hl]		; Respawn at that room
	ld   [wLvlRoomId], a
	
	; Reload the level with the respawn flag set, to preserve collected/permanently despawned items
	ld   a, $01			
	ld   [wPlRespawn], a
		call Module_Game_InitScrOff
		call Module_Game_InitScrOn
	xor  a
	ld   [wPlRespawn], a
	
	scf  ; C flag = Set
	ret
	
.setBoss:
	;
	; Boss corridor respawn, mostly the same as normal respawns.
	;
	ld   a, [hl]		; Respawn at that room
	ld   [wLvlRoomId], a
	
	ld   a, $01			; Reload level as respawn
	ld   [wPlRespawn], a
		call Module_Game_InitScrOff
		;--
		; For inexplicable reasons, by conventions the boss corridors are not perfectly aligned 
		; to room boundaries, with the room before being 1 block longer than it should.
		; On top of not making it possible to use screen locks with the 1st shutter, it also 
		; forces us to adjust the screen right by those 16 pixels.
		ld   b, $10
	.bsShLoop:
		push bc
			call Game_AutoScrollR	; Move 1px right
		pop  bc
		dec  b						; Moved all 16px?
		jr   nz, .bsShLoop			; If not, loop
		;--
		call Module_Game_InitScrOn
		
		; Set the appropriate boss mode, this locks the screen and makes
		; closing the 2nd shutter activate the boss.
		ld   a, BSMODE_CORRIDOR
		ld   [wBossMode], a
	xor  a
	ld   [wPlRespawn], a
	
	scf  ; C flag = Set
	ret
	
.gameOver:
	;
	; No more lives left, do the game over sequence.
	;
	
	; PASSWORD SCREEN
	ld   a, BGM_PASSWORD
	mPlayBGM
	call Module_PasswordView ; BANK $01
	
	; GAME OVER
	call Pl_ResetLivesAndWpnAmmo	; Reset lives/ammo to default
	ld   a, GFXSET_GAMEOVER			; Load Game Over font...
	call GFXSet_Load
	ld   de, TilemapDef_GameOver	; ...and the tilemap
	call LoadTilemapDef
	call StartLCDOperation
.gmoLoop:
	rst  $08 ; Wait Frame
	call JoyKeys_Refresh
	; Wait in a loop until either A or B are pressed.
	; A -> Stage Select
	; B -> Continue
	ldh  a, [hJoyNewKeys]
	and  KEY_B|KEY_A				; A or B pressed?
	jr   z, .gmoLoop				; If not, loop
	ld   [wGameOverSel], a			; Save selection as keys
	xor  a  ; C flag = Clear
	ret
	
TilemapDef_GameOver: INCLUDE "data/gameover/gameover_bg.asm"

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
	
; =============== NonGame_DoFor ===============
; Runs the pseudo-gameplay loop for the specified amount of frames.
; IN
; - B: Number of frames
NonGame_DoFor:
	call NonGame_Do
	dec  b
	jr   nz, NonGame_DoFor
	ret
	
; =============== NonGame_Do ===============
; Pseudo-gameplay.
; Cut down version of the gameplay loop (Module_Game) with no player interaction that executes for a single frame.
; This makes it useful for cutscene modes, as it lets the caller determine when to pause of exit out of "gameplay"
; rather than doing it indirectly through actors. Note that when doing so, whatever sprites set by the last call 
; to NonGame_Do stay on screen, which is useful for freeze pausing. 
;
; As it's meant for cutscene modes, this does not poll for player controls, typically they are faked by the caller.
; Note that when this subroutine isn't called, the previous sprites stay on screen.
NonGame_Do:
	push hl
	push de
	push bc
		rst  $08 ; Wait Frame
		
		; [BUG] This is forgetting to animate palettes.
		;       It's why defeating Metal Man stops the conveyor belt's animation.
		; [POI] Player-actor collision is ignored. Not needed during cutscenes anyway.
		
		; Prepare for drawing any sprites, overwriting what was there before.
		xor  a
		ldh  [hWorkOAMPos], a
		
		call Game_Do ; Run gameplay
		call WpnS_Do ; BANK $01 ; Process on-screen shots 
		
		; Run actor code
		push af
			ld   a, BANK(ActS_Do); BANK $02
			ldh  [hRomBankLast], a
			ldh  [hRomBank], a
			ld   [MBC1RomBank], a
		pop  af
		call ActS_Do
		push af
			ld   a, $01
			ldh  [hRomBankLast], a
			ldh  [hRomBank], a
			ld   [MBC1RomBank], a
		pop  af
		
		call OAM_ClearRest	; Rest wait
		call Game_TickTime	; Tick gameplay clock & process refills
	pop  bc
	pop  de
	pop  hl
	ret
	
; =============== Module_Game_InitScrOff ===============
; Initializes the level data while the screen is turned off.
Module_Game_InitScrOff:
	ld   a, GFXSET_LEVEL
	call GFXSet_Load		; Turns the screen off
	call Lvl_LoadData		; Load level data
	call Lvl_InitSettings	; Load settings
	call Lvl_DrawFullScreen ; Draw spawn screen
	call Game_Init			; Initialize gameplay
	call ActS_ClearAll		; Delete any remaining actors
	jp   ActS_SpawnRoom		; and write new ones for the current room
	
; =============== Module_Game_InitScrOn ===============
; Initializes the level data while the screen is turned on.
; Almost always called immediately after Module_Game_InitScrOff.
Module_Game_InitScrOn:
	call StartLCDOperation	; Turns the screen on
	call Game_RunInitEv		; Finish up events
	
	; Finally, request playing the level's BGM
	ld   a, [wLvlId]		; hBGMSet = Lvl_BGMTbl[wLvlId]
	ld   hl, Lvl_BGMTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   a, a				; [POI] What?
	mPlayBGM
	ret
	
; =============== Game_TickTime ===============
; Updates the gameplay timer, which is measured in seconds.
;
; This subroutine is only executed when there's no lag frame, and it chains
; into others that have the same requirement.
Game_TickTime:
	ld   a, [wGameTimeSub]	; FrameCnt++
	inc  a
	ld   [wGameTimeSub], a
	cp   60					; FrameCnt == 60?
	jr   nz, .end			; If not, skip
	xor  a					; Otherwise, FrameCnt++
	ld   [wGameTimeSub], a
	ld   hl, wGameTime		; SecondCnt++
	inc  [hl]
.end:
; Fall-through
	
; =============== Game_DoRefill ===============
; Performs any timed refills, 1 unit of health at a time.
; Unlike other games, these can happen concurrently without stopping gameplay.
Game_DoRefill:
	
	; Don't process them if level scrolling or normal events are being run, as those take priority.
	; This is to make sure every step of the bar redraw visibly happens, to avoid choppy or incomplete refills.
	xor  a
	ld   hl, wLvlScrollEvMode
	or   [hl]				; wLvlScrollEvMode != 0?
	ld   hl, wTilemapEv
	or   [hl]				; || wTilemapEv != 0?
	ret  nz					; If so, return
	
.chkHealth:
	;
	; Player Health (BARID_PL)
	;
	ld   a, [wPlHealthInc]
	or   a					; Any more health to add?
	jr   z, .chkAmmo		; If not, skip
	dec  a					; Tick one down
	ld   [wPlHealthInc], a
	
	; Update the player's health
	ld   a, [wPlHealth]		; C = Old Health
	ld   c, a
	inc  a					; A = MIN(wPlHealth + 1, BAR_MAX)
	cp   BAR_MAX
	jr   c, .setHealth
	ld   a, BAR_MAX
.setHealth:
	ld   b, a				; B = New Health
	ld   [wPlHealth], a		; Save new health
	
	; Only play the refill sound and redraw the status bar when a new bar is added.
	; This is necessary because we're not incrementing health by a bar, but by a single unit of health,
	; and a single bar is worth 8 units. It doesn't make sense to waste time redrawing the same bar.
	
	; Checking bit3 after xoring between the old and new health will tell if it has changed.
	; If it did, we crossed an 8 unit boundary, so it needs a redraw.
	xor  c					
	and  $08				; ((NewHealth ^ OldHealth) & $08) == 0?
	jr   z, .chkAmmo		; If so, skip
	
	ld   a, b				; Set to draw the new amount of health
	ld   [wPlHealthBar], a
	ld   hl, wStatusBarRedraw	; Trigger redraw
	set  BARID_PL, [hl]
	ld   a, SFX_BAR			; Play refill sound
	mPlaySFX

.chkAmmo:
	;
	; Weapon Ammo (BARID_WPN)
	; Almost identical to the one above, except for weapon ammo.
	;
	
	; Any more ammo to add?
	ld   a, [wWpnAmmoInc]
	or   a
	jr   z, .end
	dec  a
	ld   [wWpnAmmoInc], a
	;--
	; The default weapon has unlimited ammo, no need to redraw it.
	; [BUG] This is accidentally returning early instead of skipping to .end.
	;       If player's health is being refilled, it will prevent it from being redrawn
	;       while ammo is also being refilled.
	ld   a, [wWpnId]
	or   a
	ret  z
	;--
	
	; Update the weapon's ammo
	ld   a, [wWpnAmmoCur]
	ld   c, a
	inc  a
	cp   BAR_MAX
	jr   c, .setAmmo
	ld   a, BAR_MAX
.setAmmo:
	ld   b, a
	ld   [wWpnAmmoCur], a
	
	; Only redraw when crossing a 8 unit threshold
	xor  c
	and  $08
	ret  z
	
	; Trigger redraw & sfx
	ld   a, b
	ld   [wWpnAmmoBar], a
	ld   hl, wStatusBarRedraw
	set  BARID_WPN, [hl]
	ld   a, SFX_BAR
	mPlaySFX
.end:
	; Fall-through
	
; =============== Game_ChkRedrawBar ===============
; Queues up redraw events for all parts of the status bar that need to be redrawn.
Game_ChkRedrawBar:
	
	ld   a, [wStatusBarRedraw]		; B = Redraw flags
	ld   b, a
	ld   hl, wPlHealthBar
	
	; Process the redraws in BARID_* order
	ld   c, BARID_PL				; C = Running BARID_* value
	ldi  a, [hl]					; Read wPlHealthBar, seek to wWpnAmmoBar
	bit  BARID_PL, b				; Need to redraw the health bar?
	call nz, Game_AddBarDrawEv		; If so, do it
	
	inc  c							; C = BARID_WPN
	ldi  a, [hl]					; Read wWpnAmmoBar, seek to wBossHealthBar
	bit  BARID_WPN, b				; Need to redraw the weapon bar?
	call nz, Game_AddBarDrawEv		; If so, do it
	
	inc  c							; C = BARID_BOSS
	ldi  a, [hl]					; Read wBossHealthBar, seek to wPlLivesView
	bit  BARID_BOSS, b				; Need to redraw the boss health bar?
	call nz, Game_AddBarDrawEv		; If so, do it
	
	ld   a, [hl]					; Read wPlLivesView
	bit  BARID_LIVES, b				; Need to redraw the lives indicator?
	call nz, Game_AddLivesDrawEv	; If so, do it
	
	; If anything was redrawn, trigger the bar redraw event
	ld   a, b
	or   a							; wStatusBarRedraw == 0?
	ret  z							; If so, return (nothing redrawn)
	
	xor  a							; Otherwise, reset redraw flags
	ld   [wStatusBarRedraw], a
	inc  a							; and trigger the event
	ld   [wTilemapBarEv], a
	ret
	
; =============== Module_Title ===============
; Title screen module.
; OUT
; - Z Flag: If set, GAME START was selected. PASS WORD otherwise.
Module_Title:
	;
	; Load VRAM
	;
	xor  a ; GFXSET_TITLE
	call GFXSet_Load
	push af
		ld   a, BANK(TilemapDef_Title) ; BANK $04
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   de, TilemapDef_Title
	call LoadTilemapDef
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	call StartLCDOperation
	;--
	
	ld   a, BGM_TITLE
	mPlayBGM
	
	;
	; Define the cursor sprite.
	; Its Y position also doubles as the selected option.
	;
	ld   hl, wCursorObj
	ld   a, $68		; Y Position
	ldi  [hl], a
	ld   a, $2E		; X Position
	ldi  [hl], a
	xor  a
	ldi  [hl], a	; Tile ID	
	ld   [hl], a	; Attribute
	
	; For some reason the selection change code is right here,
	; getting executed once before even making a choice.
	; This means that, to have GAME START selected by default,
	; the initial Y position from above actually points to PASS WORD.
	
.changeSel:
	; Switch between GAME START and PASS WORD
	; by alternating between Y positions $60 and $68
	ld   a, [wCursorObj+iObjY]
	xor  $08
	ld   [wCursorObj+iObjY], a
	
.loop:
	rst  $08 ; Wait Frame
	
	;--
	; This is 100% identical to the respective code in FlashBGPalLong.
	; 1/8 chance of flashing palette every 4 frames.
	ldh  a, [hTimer]
	and  $03
	jr   nz, .wait
	ld   b, $E4
	call Rand
	cp   $20
	jr   nc, .setPal
	ld   b, $C0
.setPal:
	ld   a, b
	ldh  [hBGP], a
.wait:
	;--
	
	; Animate the cursor every 4 frames
	; by cycling its tile ID from 0 to 7, then wrapping back.
	ldh  a, [hTimer]
	and  $1C			; iObjTileId = (hTimer / 4) % 8
	srl  a
	srl  a
	ld   [wCursorObj+iObjTileId], a
	
	; Check for player input
	call JoyKeys_Refresh
	ldh  a, [hJoyNewKeys]
	and  KEY_DOWN|KEY_UP|KEY_START|KEY_SELECT|KEY_A	; Pressed any of the keys that matter? 
	jr   z, .loop									; If not, loop
	and  KEY_DOWN|KEY_UP|KEY_SELECT					; Pressed any of the toggle keys?
	jr   z, .sel									; If not, we've definitely pressed A or START
	; Otherwise, toggle the selection
	ld   a, SFX_CURSORMOVE
	mPlaySFX
	jr   .changeSel
.sel:
	; [POI] Disable the invulnerability cheat.
	;       Curiously, this address wasn't reset at boot, it only gets written to here.
	;       Presumably you could hold something to enable the cheat mode here?
IF CHEAT_ON
	ld   a, $01
ELSE
	xor  a
ENDC
	ldh  [hCheatMode], a
	
	; If GAME START is selected, the cursor's Y position will be $60.
	; As $60 & 8 is 0, it will return the Z flag.
	ld   a, [wCursorObj+iObjY]
	and  $08
	ret
	
; =============== Module_StageSel ===============
; Stage Select screen.
Module_StageSel:
	;--
	;
	; Load VRAM
	;
	ld   a, GFXSET_STAGESEL
	call GFXSet_Load
	push af
		ld   a, BANK(TilemapDef_StageSel) ; BANK $04
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   de, TilemapDef_StageSel
	call LoadTilemapDef
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	;
	; Clear portraits of defeated bosses
	;
	ld   a, [wWpnUnlock0]
	
	; We only want the completion status of the first set of bosses.
	; For some reason Top Man takes up bit0, with the first set of bosses coming next.
	rra						; Shift out Top Man
	
	; Shift the four bits one by one
	ld   c, a				; C = First set completion in low nybble
	ld   b, $04				; B = Remaining bits to check
.bossClrLoop:
	push bc					; Save count
		srl  c					; >> boss bit out to carry
		jr   nc, .bossNotDone	; Is the boss cleared? If not, skip
		
		; Otherwise, wipe the portrait
		ld   a, b			; A = Pic index
		dec  a
		call StageSel_MkEmptyPicTilemap		; Build the tilemap
		ld   de, wTilemapBuf
		call LoadTilemapDef	; Execute it immediately
.bossNotDone:
	pop  bc					; Restore count
	srl  c					; Redo this due to the pop
	dec  b					; Are we done?
	jr   nz, .bossClrLoop	; If not, loop
	
	; The lower half of the stage select is drawn on the WINDOW,
	; to allow the screen split effect when selecting a stage.
	ld   a, $07				; Left corner
	ldh  [hWinX], a
	ld   a, SCREEN_V/2		; Middle
	ldh  [hWinY], a
	
	ld   a, $01				; [POI] Useless line
	call StartLCDOperation
	;--
	
	ld   a, BGM_STAGESELECT
	mPlayBGM
	
	xor  a
	ld   [wStageSelCursor], a
.loop:
	;
	; MAIN LOOP
	;
	
	rst  $08 ; Wait Frame
	
	call StageSel_DrawCursor
	call JoyKeys_Refresh
	
	ldh  a, [hJoyNewKeys]
	ld   c, a				; C = hJoyNewKeys
	or   a					; Pressed any keys?
	jr   z, .loop			; If not, loop
	
	ld   a, [wStageSelCursor]
	ld   b, a				; B = wStageSelCursor
	
.chkStageSel:
	;
	; START or A -> Select a stage
	;
	ld   a, c
	and  KEY_START|KEY_A	; Pressing START or A?
	jr   z, .chkMoveH		; If not, skip
	
	; For whatever reason, the first set of bosses takes up level IDs $04-$07,
	; while the second set takes up $00-$03.
	; That's the other way around from the cursor position, so toggle bit2.
	; Other than that, this implies a requirement that the cursor positions
	; and level IDs should be consistent.
	ld   a, b				; wLvlId = wStageSelCursor ^ $04
	xor  %100
	ld   [wLvlId], a
	
	;
	; Prevent revisiting completed stages
	;
	
	; Find the completion bit to this stage
	; B = Lvl_ClearBitTbl[wLvlId]
	ld   hl, Lvl_ClearBitTbl
	ld   b, $00
	ld   c, a
	add  hl, bc	
	ld   b, [hl]
	; If it's set in our completion flags, disregard the selection and return
	ld   a, [wWpnUnlock0]
	and  b					; wWpnUnlock0 & B != 0?
	jr   nz, .loop			; If so, we've already beaten it
	
	jp   StageSel_BossIntro
.chkMoveH:
	;
	; LEFT/RIGHT -> Move cursor horizontally
	;
	ld   a, c
	and  KEY_LEFT|KEY_RIGHT	; Pressing L o R?
	jr   z, .chkMoveV		; If not, skip
	
	; The cursor is only able to move on a 2x2 grid.
	; Therefore, all we need here is toggling bit 0.
	ld   a, b
	xor  %01
	ld   [wStageSelCursor], a
	
	ld   a, SFX_CURSORMOVE
	mPlaySFX
	jr   .loop
	
.chkMoveV:
	;
	; UP/DOWN -> Move cursor vertically
	;
	ld   a, c
	and  KEY_DOWN|KEY_UP	; Pressing U or D?
	jr   z, .loop			; If not, nothing else to do
	
	; Like the one above, but with the other bit
	ld   a, b
	xor  %10
	ld   [wStageSelCursor], a
	
	ld   a, SFX_CURSORMOVE
	mPlaySFX
	jr   .loop
	
; =============== StageSel_DrawCursor ===============
; Draws the cursor sprite for the stage select.
StageSel_DrawCursor:
	; The sprites for the cursor are hardcoded for each position.
	; Since the cursor is made of 4 sprites, and each sprite takes up 4 bytes,
	; that's $10 bytes for each position.
	ld   a, [wStageSelCursor]
	and  $03				; Force valid range 0-3
	swap a					; * $10
	ld   hl, StageSel_CursorSprTbl
	ld   b, $00
	ld   c, a
	add  hl, bc				; Seek to entry we want
	
	ld   de, wWorkOAM		; Copy those $10 bytes over
	ld   bc, $0010
	call CopyMemory
	
	;
	; Thankfully the palette animation isn't hardcoded.
	; Every 8 frames, switch between OBP0 & OBP1.
	;
	
	; Turn hTimer into iObjAttr
	ldh  a, [hTimer]		
	sla  a
	and  SPR_OBP1 ; $10			; A = iObjAttr
	
	; Overwrite all flags with this
	ld   b, $04					; B = Sprites to edit
	ld   hl, wWorkOAM+iObjAttr	; HL = First sprite
.loop:
	ldi  [hl], a				; Set flags, seek to iObjY
	inc  l						; ...iObjX
	inc  l						; ...iObjTileId
	inc  l						; ...iObjAttr
	dec  b						; Are we there yet?
	jr   nz, .loop				; If not, loop
	
	xor  a	; Ok I guess
	ret
	
; =============== StageSel_CursorSprTbl ===============
StageSel_CursorSprTbl:
	INCLUDE "data/stagesel/cursor_rspr.asm"
	
; =============== StageSel_BossIntro ===============
; Handles a stage getting selected.
StageSel_BossIntro:
	
	; Start a request to load the graphics for this boss.
	ld   hl, StageSel_BossGfxTbl	; HL = StageSel_BossGfxTbl
	ld   a, [wLvlId]				; BC = wLvlId
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]					; Read OBJ GFX set ID
	call ActS_ReqLoadRoomGFX.loadBySetId
	
	; Delete cursor sprites
	call OAM_ClearAll
	
	; The stage intro sound plays immediately, there's no separate selection sound.
	ld   a, BGM_STAGESTART
	mPlayBGM
	
	; Flash the palette for 32 frames.
	; This is enough time to let the boss graphics fully load.
	call FlashBGPal
	rst  $20 ; But just in case, ensure they are fully loaded
	
	; Blank out the selected portrait, as the boss sprite will spawn there.
	; This makes the sprite stand out more, for the little time it stays there.
	ld   a, [wLvlId]
	call StageSel_MkEmptyPicTilemap
	rst  $10 ; Wait tilemap load
	
	;--
	;
	; Spawn the boss actor for the intro.
	; This is actually the same exact one used during gameplay, but its normal code won't be executed.
	;
	
	; Delete any old actors, enabling their processing
	call ActS_ClearAll
	
	; Boss actors are indexed start at $68, indexed by level ID
	ld   a, [wLvlId]				; wActSpawnId = wLvlId + $68
	add  ACT_BOSS_START
	ld   [wActSpawnId], a
	
	; Doesn't need to respawn and it's not gameplay anyway
	xor  a
	ld   [wActSpawnLayoutPtr], a
	
	; Set the spawn position depending on the level id.
	; HL = StageSel_BossActStartPosTbl[(wLvlId % 4) * 2]
	ld   a, [wLvlId]	
	and  $03			; Force valid range, with the effect of not breaking in case the second set of bosses is selected
	add  a				; Coords are 2 bytes
	ld   hl, StageSel_BossActStartPosTbl
	ld   b, $00
	ld   c, a
	add  hl, bc			; Seek to entry
	ldi  a, [hl]		; wActSpawnX = byte0
	ld   [wActSpawnX], a
	ld   a, [hl]		; wActSpawnX = byte1
	ld   [wActSpawnY], a
	
	call ActS_Spawn
	;--
	
	; Prepare the starfield effect for later
	call Starfield_InitPos
	
	;
	; Open up the two halves of the selection screen at 2px/frame.
	;
	ld   b, $24			; For $24 frames...
.openLoop:
	; Scroll the BG viewport down.
	; This will scroll the top half up.
	ld   hl, hScrollY
	inc  [hl]
	inc  [hl]
	
	; Scroll the WINDOW layer down.
	; This will scroll the bottom half down.
	ld   hl, hWinY
	inc  [hl]
	inc  [hl]
	
	call StageSel_DoAct	; Handle boss actor
	dec  b				; Are we done?
	jr   nz, .openLoop	; If not, loop
	
	;
	; With the two halves fully scrolled out, write the starfield background, one row at a time.
	; This replaces everything above or below the horizontal bar.
	;
	
	; TOP HALF
	ld   d, HIGH($98E0)			; DE = Write address
	ld   e, LOW($98E0)
	ld   b, $09					; B = Number of columns
.loopU:
	call Starfield_ReqDrawBG	; Req tilemap update 
	
	ld   a, e					; Move up 1 row
	sub  BG_TILECOUNT_H
	ld   e, a
	ld   a, d
	sbc  $00
	ld   d, a
	
	call StageSel_DoAct			; Handle boss actor
	dec  b						; Written all rows?
	jr   nz, .loopU				; If not, loop
	;--
	
	; BOTTOM HALF
	ld   d, HIGH($9C20)			; DE = Write address
	ld   e, LOW($9C20)
	ld   b, $09
.loopD:
	call Starfield_ReqDrawBG
	
	ld   a, e					; Move down 1 row
	add  BG_TILECOUNT_H
	ld   e, a
	ld   a, d
	adc  $00
	ld   d, a
	
	call StageSel_DoAct			; Handle boss actor
	dec  b						; Written all rows?
	jr   nz, .loopD				; If not, loop
	;--
	
	
	;
	; Close the two halves of the selection screen at 2px/frame.
	; The opposite of what we did before, but for less frames, to
	; make the white backdrop visible.
	;
	ld   b, $18			; For $18 frames...
.closeLoop:
	; Scroll the BG viewport up.
	; This will scroll the top half down.
	ld   hl, hScrollY
	dec  [hl]
	dec  [hl]
	
	; Scroll the WINDOW layer up.
	; This will scroll the bottom half up.
	ld   hl, hWinY
	dec  [hl]
	dec  [hl]
	
	call StageSel_DoAct	; Handle boss actor
	dec  b				; Are we done?
	jr   nz, .closeLoop	; If not, loop
	
	;
	; Wait for the boss intro animation to finish before continuing
	;
.waitAnimEnd:
	call StageSel_DoAct
	ldh  a, [hActCur+iActRtnId]
	cp   $06				; Reached the last actor routine?
	jr   nz, .waitAnimEnd	; If not, wait
	
	;
	; Display the boss' name.
	; 
	
	; Load the font to VRAM
	ld   hl, GFX_NormalFont	; Source GFX ptr
	ld   de, $9400				; VRAM Destination ptr
	ld   bc, (BANK(GFX_NormalFont) << 8) | $20 ; BANK $0B | Number of tiles to copy
	call GfxCopy_Req
	; Normally we would call GfxCopyEv_Wait, but that wouldn't animate the starfield.
	; The 32 tiles should load within 8 frames, so wait that much.
	ld   a, $08
	call .waitFrames
	
	; Seek HL to the boss' name.
	; Boss names are hardcoded to 10 characters, stored in a table indexed by level ID.
	DEF BOSSNAME_LEN EQU 10
	ld   a, [wLvlId]			
	add  a		; * 2
	ld   b, a				
	add  a		; * 4
	add  a		; * 8
	add  b		; * 10
	ld   hl, StageSel_BossNameTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	; Write it out to the tilemap
	ld   de, wTilemapBuf
	ld   a, HIGH($99A5)		; byte0 - VRAM Address (high)
	ld   [de], a
	inc  de
	ld   a, LOW($99A5)		; byte1 - VRAM Address (low)
	ld   [de], a
	inc  de
	ld   a, BOSSNAME_LEN	; byte2 - Flags + Tile count
	ld   [de], a
	inc  de
	ld   bc, BOSSNAME_LEN	; Boss name
	call CopyMemory
	xor  a					; Write terminator
	ld   [de], a
	
	inc  a					; Trigger request
	ld   [wTilemapEv], a
	
	; Wait for 3 seconds
	ld   a, 3*60
	
; IN
; - A: Number of frames
.waitFrames:
	push af
		call StageSel_DoAct
	pop  af
	dec  a
	jr   nz, .waitFrames
	ret
	
; =============== StageSel_DoAct ===============
; Handles actor processing during the boss intro screen.
; This will wait a frame before returning.
StageSel_DoAct:
	push hl
	push de
	push bc
		
		; We're going to draw sprites
		xor  a
		ldh  [hWorkOAMPos], a
		
		;--
		; This screen only has one actor at the first slot.
		; Copy the first slot to the proc area.
		ld   hl, wAct
		ld   de, hActCur+iActId
		ld   b, iActEnd
	.cpInLoop:
		ldi  a, [hl]
		ld   [de], a
		inc  de
		dec  b
		jr   nz, .cpInLoop
		;--
		
		; Perform any changes in the proc area.
		
		ld   a, $00						; Act_StageSelBoss will set this as needed.
		ld   [wActCurSprMapBaseId], a
		
		; This call here is the main reason why this intro screen has a specific
		; version of the actor processing subroutine.
		; The normal (gameplay) code associated to the actor can't be executed here.
		call Act_StageSelBoss
		
		; Draw the boss
		call ActS_DrawSprMap
		
		;--
		; Save back the changes from the proc area to the actor slot.
		ld   hl, hActCur+iActId
		ld   de, wAct
		ld   b, iActEnd
	.cpOutLoop:
		ldi  a, [hl]
		ld   [de], a
		inc  de
		dec  b
		jr   nz, .cpOutLoop
		;--
		
		; Frame done
		call OAM_ClearRest
		rst  $08 ; Wait Frame
	
	pop  bc
	pop  de
	pop  hl
	ret
	
; =============== Act_StageSelBoss ===============
; ACTOR IDs: N/A
; Special code for animating the bosses after selecting a stage.
Act_StageSelBoss:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_StageSelBoss_Init
	dw Act_StageSelBoss_JumpUp
	dw Act_StageSelBoss_JumpDown
	dw Act_StageSelBoss_JumpLand
	dw Act_StageSelBoss_WaitAnim
	dw Act_StageSelBoss_IntroAnim
	dw Act_StageSelBoss_Starfield

; =============== Act_StageSelBoss ===============
; RTN $00
; Sets up the direction and initial movement speed.
Act_StageSelBoss_Init:

	;
	; Make the boss face the proper direction.
	; Bosses on the left (bit0 clear) will face right (ACTDIRB_R set).
	; Bosses on the right (bit0 set) will face left (ACTDIRB_R clear).
	;
	ld   a, [wLvlId]
	; bit0 determines odd/even values, bit7 determines the direction for iActSprMap
	; rotate right bit0 to bit7
	rrca		
	; Filter out unwanted bits
	and  ACTDIR_R
	; Other way around
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	
	;
	; BC = Jump speed.
	; This will be reduced over time.
	; Bosses on the top (bit1 clear) use a lower jump arc compared to those at the bottom.
	;
	ld   bc, $01A0		; BC = 1.6px/frame
	ld   a, [wLvlId]
	bit  1, a			; Boss pic on top?
	jr   z, .setSpeed	; If not, skip
	ld   bc, $03B0		; BC = 2.7px/frame
	
.setSpeed:
	; 1px/frame forward
	xor  a
	ldh  [hActCur+iActSpdXSub], a
	inc  a
	ldh  [hActCur+iActSpdX], a
	; BC/frame speed upwards
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	; The total jump arc will take up $28 frames
	ld   a, $28
	ldh  [hActCur+iActTimer], a
	
	; Next mode
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_JumpUp ===============
; RTN $01
; Jump arc - upwards movement.
Act_StageSelBoss_JumpUp:
	; iActTimer--
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	
	; Continue jump arc
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedUpY	; Reached the peak?
	ret  c					; If not, return
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_JumpDown ===============
; RTN $02
; Jump arc - downwards movement.
Act_StageSelBoss_JumpDown:
	; Continue jump arc
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedDownY
	
	; Wait for the timer to tick down before continuing
	; iActTimer--
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_JumpLand ===============
; RTN $03
; Jump arc - landed from the jump.
Act_StageSelBoss_JumpLand:
	; Make boss face left
	xor  a
	ldh  [hActCur+iActSprMap], a
	
	; Delay next mode for 32 frames
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_WaitAnim ===============
; RTN $04
; Delay while the two halves are closing back.
Act_StageSelBoss_WaitAnim:

	; Wait for those 32 frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Set up the intro animation.
	; Every single intro uses the first three sprite mapping IDs.
	; Use sprites $00-$02 at 1/30 speed
	ld   de, ($00 << 8)|$02
	ld   c, 30
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_IntroAnim ===============
; RTN $05
; Performs the boss' animation while the starfield scrolls.
Act_StageSelBoss_IntroAnim:
	call Starfield_Do
	call ActS_PlayAnimRange		; Is it done?
	ret  z						; If not, return
								
	ld   a, $00					; Restore 1st frame
	ld   [wActCurSprMapBaseId], a
	
	ld   a, $01
	call ActS_SetSprMapId
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_Starfield ===============
; RTN $06
; Just displays the starfield.
; This will keep doing it while, elsewhere, the boss' name gets written.
Act_StageSelBoss_Starfield:
	call Starfield_Do
	ret
	
; =============== Starfield_InitPos ===============	
; Initializes the starfield position with random coordinates.
Starfield_InitPos:
	; Each star has two bytes assigned (X and Y coordinates, in that order).
	ld   b, $18						; B = Number of stars
	ld   hl, wStageSelStarfieldPos	; HL = Starting address
.loop:
	REPT 2
		call Rand			
		and  $F8		; Align to 8x8 grid
		ldi  [hl], a
	ENDR
	dec  b				; Finished?
	jr   nz, .loop		; If not, loop
	ret

; =============== Starfield_Do ===============
; Handles the scrolling starfield.
; This generates the 18 individual star sprites, updating
; their position as needed.
Starfield_Do:
	ld   h, HIGH(wWorkOAM)			; HL = Destination address
	ldh  a, [hWorkOAMPos]			; (write from current OAM pos)
	ld   l, a
	ld   de, wStageSelStarfieldPos	; DE = Source address
	ld   b, $18						; B = Number of stars
.loop:
	push bc
	
		;
		; Update the star location, saving it back directly to wStageSelStarfieldPos
		;
	
		; All of the stars move diagonally down/left.
		; Half of them at 1px/frame, the other at 2px/frame.
		; This also doubles as the tile ID offset for the sprite tile,
		; since it fits well enough, with having larger stars move
		; faster than the smaller ones.
		ld   c, $01			; C = 1x Speed
		ld   a, b
		cp   $18/2			; StarsLeft < HalfPoint?
		jr   c, .setPos		; If so, jump
		ld   c, $02			; Otherwise, C = 2x Speed
		
	.setPos:
		; Move star left
		ld   a, [de]	; byte0 -= C
		sub  c
		ld   [de], a
		inc  de
		ld   b, a		; B = Updated X pos
		
		; Move star down
		ld   a, [de]	; byte1 += C
		add  c
		ld   [de], a	; A = Updated Y pos
		inc  de
		
		; Avoid drawing stars over the middle section.
		cp   $38		; YPos < $38?
		jr   c, .draw	; If so, draw (top section)
		cp   $78		; YPos < $78?
		jr   c, .chkEnd	; If so, skip (middle section)
						; Otherwise, draw (bottom section)
	.draw:
		;
		; Write the sprite data directly
		;
		ldi  [hl], a	; iObjY = A
		ld   a, b		; iObjX = B
		ldi  [hl], a
		ld   a, $25		; iObjTileId = $25 + C
		add  c
		ldi  [hl], a	
		xor  a			; iObjAttr = 0
		ldi  [hl], a
		
.chkEnd:
	pop  bc				; Restore count
	dec  b				; Are we done?
	jr   nz, .loop		; If not, loop
	; Save back the updated sprite count
	ld   a, l
	ldh  [hWorkOAMPos], a
	ret
	
; =============== Starfield_ReqDrawBG ===============
; Requests drawing a single row of black tiles.
; After all rows are drawn, the starfield sprites will be shown over these.
; IN
; - Ptr to the tilemap
Starfield_ReqDrawBG:
	ld   hl, wTilemapBuf
	ld   [hl], d			; byte0 - VRAM Address (high)
	inc  l
	ld   [hl], e			; byte1 - VRAM Address (low)
	ld   a, $54				; byte2 - Flags + Tile count
	ld   [wTilemapBuf+iTilemapDefOpt], a
	ld   a, $14				; byte3 - Tile ID (black tile)
	ld   [wTilemapBuf+iTilemapDefPayload], a
	xor  a					; Write terminator
	ld   [wTilemapBuf+iTilemapDefPayload+1], a
	
	inc  a					; Trigger event
	ld   [wTilemapEv], a
	ret
	
; =============== StageSel_BossActStartPosTbl ===============
; Spawn positions for boss actors for each picture.
StageSel_BossActStartPosTbl: 
	;    X    Y
	db $30, $3B ; Top-Left (LVL_CRASH, LVL_HARD)
	db $80, $3B ; Top-Right (LVL_METAL, LVL_TOP)
	db $30, $8C ; Bottom-Left (LVL_WOOD, LVL_MAGNET)
	db $80, $8C ; Bottom-Right (LVL_AIR, LVL_NEEDLE)

; =============== StageSel_BossNameTbl ===============
; Boss names, indexed by level ID.
; Each of these is hardcoded to be 10 characters long.
; [TCRF] This explicitly accounts for the second set of bosses.
StageSel_BossNameTbl:
SETCHARMAP generic
	db " HARD MAN " ; LVL_HARD
	db " TOP  MAN " ; LVL_TOP
	db "MAGNET MAN" ; LVL_MAGNET
	db "NEEDLE MAN" ; LVL_NEEDLE
	db "CLASH  MAN" ; LVL_CRASH
	db "METAL  MAN" ; LVL_METAL
	db " WOOD MAN " ; LVL_WOOD
	db " AIR  MAN " ; LVL_AIR

; =============== StageSel_MkEmptyPicTilemap ===============
; Builds the TilemapDef for clearing out the specified boss pic.
; IN
; - A: Boss picture ID ($00-$04)
StageSel_MkEmptyPicTilemap:
	;
	; DE = Ptr to tilemap associated with the pic
	;
	and  $03			; Enforce valid range
	add  a				; Pointer table index
	ld   hl, StageSel_PicPosPtrTbl
	ld   b, $00
	ld   c, a
	add  hl, bc			; Index it 
	ld   e, [hl]		; Read out ptr to DE
	inc  hl
	ld   d, [hl]
	
	; Generate the tilemap.
	; The tilemap system doesn't really play well with square tilemaps, 
	; so to clear a block of 4x4 tiles, 4 separate TilemapDef need to 
	; be generated, each clearing a single column of 4 tiles.
	ld   hl, wTilemapBuf
	ld   b, $04
.loop:
	ld   [hl], d		; byte0 - VRAM Address (high)
	inc  hl
	ld   [hl], e		; byte1 - VRAM Address (low)
	inc  hl
	ld   a, BG_MVDOWN|BG_REPEAT|$04		; byte2 - Flags + Tile count
	ldi  [hl], a
	ld   a, $1F			; byte3 - Tile ID (gray blank tile)
	ldi  [hl], a
	inc  e				; Seek tile to the right
	dec  b				; Generated all four?
	jr   nz, .loop		; If not, loop
	ld   [hl], a		; Write terminator
	ret
	
; =============== StageSel_PicPosPtrTbl ===============
StageSel_PicPosPtrTbl:
	dw $9843 ; CRASH MAN / HARD MAN
	dw $984D ; METAL MAN / TOP MAN
	dw $9C63 ; WOOD MAN / MAGNET MAN
	dw $9C6D ; AIR MAN / NEEDLE MAN
	
; =============== Module_GetWpn ===============
; Get Weapon screen.
Module_GetWpn:
	;--
	;
	; Load VRAM
	;
	
	ld   a, GFXSET_GETWPN
	call GFXSet_Load
	
	push af
		ld   a, BANK(TilemapDef_GetWpn) ; BANK $04
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   de, TilemapDef_GetWpn
	call LoadTilemapDef
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	call StartLCDOperation
	;--
	
	ld   a, BGM_WEAPONGET
	mPlayBGM
	
	;
	; Scroll the Rockman/Rush picture to the left until it's fully onscreen.
	; Scrolled 0.25px/frame to the right for 96 frames - 24px right in total.
	;
	ld   b, $60			; For $60 frames...
	ld   hl, hScrollX
.scrollPic:
	inc  [hl]			; Move viewport 1px to the right (scroll 1px left)
	ld   a, $04			; Wait 4 frames
	call WaitFrames
	dec  b				; Done moving?
	jr   nz, .scrollPic	; If not, loop
	; Wait a second after finishing moving
	ld   a, 60
	call WaitFrames
	
	;
	; Write the unlock text to the tilemap, one character at a time.
	;
	
	; This is split into two parts, the common "YOU GOT" string and a level-specific one with the weapon's name.
	; Start with the former.
	ld   hl, Txt_GetWpn_YouGot	; HL = String source ptr
	ld   de, $98CC		; DE = Tilemap destination ptr 
	call GetWpn_WriteTxt		
	
	; Then the level specific one.
	; HL = GetWpn_LvlTextPtrTbl[wLvlId * 2]
	ld   a, [wLvlId]	; A = wLvlId * 2
	add  a
	ld   hl, GetWpn_LvlTextPtrTbl	; HL = Table base
	ld   b, $00
	ld   c, a
	add  hl, bc			; Index it
	ld   e, [hl]		; Read ptr out to HL
	inc  hl
	ld   d, [hl]
	ld   l, e
	ld   h, d
	
	ld   de, $98EC		; DE = Tilemap destination ptr 
	call GetWpn_WriteTxt
	
	; Wait 5 seconds on the fully realized screen
	ld   a, 60*3
	call WaitFrames
	ld   a, 60*2
	jp   WaitFrames
	
; =============== GetWpn_WriteTxt ===============
; Writes an ASCII $2E-terminated string to the tilemap, one character at a time.
; IN
; - DE: Row pointer
GetWpn_WriteTxt:
	; Save base tilemap pointer.
	ld   a, e
	ld   [wGetWpnDestPtr_Low], a
	ld   a, d
	ld   [wGetWpnDestPtr_High], a
	
.readChar:
	ldi  a, [hl]		; Read character, seek to next
	ld   b, a			; Save copy here
	cp   $2E			; Reached terminator?
	ret  z				; If so, return
	cp   $20			; Reached space character?
	jr   z, .wait		; If so, skip updating the tilemap
	cp   $2F			; Reached a newline character?
	jr   nz, .chNorm	; If *not*, we have a normal character. Jump.
	
.chkNewline:
	; Move the base tilemap pointer one tile down, and use it as new current pointer.
	ld   a, [wGetWpnDestPtr_Low]	; wGetWpnDestPtr += $20
	add  BG_TILECOUNT_H
	ld   [wGetWpnDestPtr_Low], a
	ld   e, a						; DE = wGetWpnDestPtr
	ld   a, [wGetWpnDestPtr_High]
	adc  $00
	ld   [wGetWpnDestPtr_High], a
	ld   d, a
	jr   .readChar
.chNorm:

	;
	; Generate the event for writing a single tile, then trigger it.
	;

	; bytes0-1: Destination pointer
	ld   a, d						; From DE
	ld   [wTilemapBuf+iTilemapDefPtr_High], a
	ld   a, e
	ld   [wTilemapBuf+iTilemapDefPtr_Low], a
	
	; byte2: Writing mode + Number of bytes to write
	ld   a, $01						; Write one tile only
	ld   [wTilemapBuf+iTilemapDefOpt], a
	
	; byte3+: payload
	; While the font is stored as ASCII in ROM and in VRAM it's loaded in the 2nd section at that location,
	; said section itself starts at $80, shifting them that much.
	ld   a, b						; Read character
	or   $80						; += 2nd section base
	ld   [wTilemapBuf+iTilemapDefPayload], a
	
	; Write terminator
	xor  a
	ld   [wTilemapBuf+iTilemapDefPayload+1], a
	
	inc  a							; Trigger event
	ld   [wTilemapEv], a
	ld   a, SFX_BOSSBAR				; Play text writer sound
	mPlaySFX
	
.wait:
	ld   a, $06			; Wait 6 frames between text printings
	call WaitFrames
	
	inc  de				; Move 1 tile right
	jr   .readChar		; Read next character
	
SETCHARMAP getwpn
Txt_GetWpn_YouGot:
	db " YOU GOT\0"
	
; =============== GetWpn_LvlTextPtrTbl ===============
; Maps levels to their weapon unlock string.
GetWpn_LvlTextPtrTbl:
	dw Txt_GetWpn_Hard   ; LVL_HARD     
	dw Txt_GetWpn_Top    ; LVL_TOP      
	dw Txt_GetWpn_Magnet ; LVL_MAGNET   
	dw Txt_GetWpn_Needle ; LVL_NEEDLE   
	dw Txt_GetWpn_Crash  ; LVL_CRASH    
	dw Txt_GetWpn_Metal  ; LVL_METAL    
	dw Txt_GetWpn_Wood   ; LVL_WOOD     
	dw Txt_GetWpn_Air    ; LVL_AIR      
	dw Txt_GetWpn_Quint  ; LVL_CASTLE   

Txt_GetWpn_Hard:
	db "  HARD\n"
	db "   KNUCKLE\0"
Txt_GetWpn_Top:
	db "  TOP\n" 
	db "   SPIN\0"
Txt_GetWpn_Magnet:
	db "  MAGNET\n"
	db "   MISSILE\0"
Txt_GetWpn_Needle:
	db "  NEEDLE\n"
	db "   CANNON\0"
Txt_GetWpn_Crash:
	db "  CLASH\n"
	db "   BOMB\n"
	db "\n"
	db "   AND\n"
	db " RUSH COIL\0"
Txt_GetWpn_Metal:
	db "  METAL\n"
	db "   BLADE\n"
	db "\n"
	db "   AND\n"
	db "RUSH MARINE\0"
Txt_GetWpn_Wood: 
	db "  LEAF\n"
	db "   SHIELD\0"
Txt_GetWpn_Air:
	db "  AIR\n"
	db "   SHOOTER\n"
	db "\n"
	db "   AND\n"
	db " RUSH JET\0"
Txt_GetWpn_Quint: 
	db "  QUINT\n"
	db "   ITEM\n"
	db "\n"
	db "\n"
	db "  SAKUGARNE\0"

; =============== WilyCastle_LoadVRAM ===============
; Loads the Wily Castle scene, used for two cutscenes.
WilyCastle_LoadVRAM:
	ld   a, GFXSET_CASTLE
	call GFXSet_Load
	
	push af
		ld   a, BANK(TilemapDef_WilyCastle) ; BANK $04
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   de, TilemapDef_WilyCastle
	call LoadTilemapDef
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== WilyCastle_DrawRockman ===============
; Draws Rockman's sprite for the Wily Castle cutscene.
; Presumably because it's a fixed sprite that doesn't animate,
; it's defined as raw OBJ data rather than as a sprite mapping.
WilyCastle_DrawRockman:
	ld   hl, WilyCastle_RockmanSpr
	ld   de, wWorkOAM
	ld   bc, WilyCastle_RockmanSpr.end-WilyCastle_RockmanSpr
	jp   CopyMemory
; =============== WilyCastle_RockmanSpr ===============
WilyCastle_RockmanSpr: 
	INCLUDE "data/castle/pl_rspr.asm"
.end:

; =============== WilyStation_LoadVRAM ===============
; Loads the Wily Station scene.
WilyStation_LoadVRAM:
	ld   a, GFXSET_STATION
	call GFXSet_Load
	push af
		ld   a, BANK(TilemapDef_WilyStation) ; BANK $04
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   de, TilemapDef_WilyStation
	call LoadTilemapDef
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
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
	
TilemapDef_WilyCastle_TrapGone: INCLUDE "data/game/castlesc_trapgone_bg.asm"
.end:

; =============== WilyCastle_CloseWonTeleporters ===============
; Closes teleporter doors leading to already completed levels.
;
; This is purely a visual effect, the actor associated to the teleporter room (Act_TeleporterRoom)
; is what handles warping and performs the level completion checks on its own.
; Should only be called when the screen is disabled and the teleporter room is already drawn to the tilemap.
WilyCastle_CloseWonTeleporters:
	ld   b, $00						; B = Coords ID (top-left)
	ld   a, [wWpnUnlock0]
	and  WPU_HA						; Cleared Hard Man's stage?
	call nz, WilyCastle_CloseDoor	; If so, close this teleporter
	
	ld   b, $01						; B = Top-right
	ld   a, [wWpnUnlock0]
	and  WPU_TP						; Cleared Top Man's stage?
	call nz, WilyCastle_CloseDoor	; ...
	
	ld   b, $02						; B = Bottom-left
	ld   a, [wWpnUnlock0]
	and  WPU_MG						; Cleared Magnet Man's stage?
	call nz, WilyCastle_CloseDoor	; ...
	
	ld   b, $03						; B = Bottom-right
	ld   a, [wWpnUnlock0]
	and  WPU_NE						; Cleared Needle Man's stage?
	call nz, WilyCastle_CloseDoor	; ...
	
	ret
	
; =============== WilyCastle_CloseDoor ===============
; Closes a specific teleporter door.
; IN
; - B: Teleporter ID
WilyCastle_CloseDoor:

	;
	; The closed teleporter door takes up a 6x4 area in the tilemap.
	; It's a 6-tile wide strip vertically repeated 4 times, so we can use events to write it like that.
	;
	; As we expect the screen to be disabled, we can apply them instantly.
	;

	; Get starting position in the tilemap for drawing the closed door.
	; DE = WilyCastle_DoorTilemapPtr[B * 2]
	ld   a, b			; Index = B * 2
	add  a
	ld   hl, WilyCastle_DoorTilemapPtr	; HL = Table base
	ld   b, $00
	ld   c, a
	add  hl, bc			; Offset it it
	ld   e, [hl]		; Read out to DE
	inc  hl
	ld   d, [hl]
	
	ld   b, $06								; B = Columns left to draw
	ld   hl, Tilemap_WilyCastle_ClosedDoor	; HL = Ptr to first tile ID
	
.loop:	; For each column...
	push hl ; Save ptr to tile ID
		push de ; Save tilemap ptr to column origin (topmost tile)
		push bc ; Save tiles left
		
			ld   c, [hl]			; C = Tile ID to write
			
			;--
			;
			; Generate the event
			;
			ld   hl, wTilemapBuf	; HL = Where to write the event
			
			; bytes0-1: Destination pointer
			; This is the tilemap pointer we indexed from WilyCastle_DoorTilemapPtr.
			ld   [hl], d		
			inc  hl
			ld   [hl], e
			inc  hl
			
			; byte2: Writing mode + Number of bytes to write
			ld   a, BG_MVDOWN|BG_REPEAT|$04
			ldi  [hl], a			; Repeat tile 4 times vertically
			
			; byte3+: payload
			ld   a, c				; The tile ID read from the table
			ldi  [hl], a
			
			; Write terminator
			xor  a
			ld   [hl], a
			;--
			
			; Instantly apply the event to the tilemap, since the screen is disabled.
			ld   de, wTilemapBuf
			call LoadTilemapDef
		
		;
		; Advance to next entry.
		;
		pop  bc ; B = Tiles left
		
		; Destination tilemap pointer
		pop  de	; Reset to start of the column
		inc  de ; Move 1 tile right
	; Source tile ID table
	pop  hl	; Get ptr to tile ID
	inc  hl ; Seek to next one
	
	dec  b			; Wrote all tiles?
	jr   nz, .loop	; If not, loop
	ret
	
; =============== WilyCastle_DoorTilemapPtr ===============
; Starting tilemap position for the door blocks in the teleport room.
; This assumes that the room is loaded to the upper half of the tilemap, meaning its ID should not be divisible by 2.
WilyCastle_DoorTilemapPtr: 
	dw $9840 ; $00 (top-left, Hard)
	dw $984E ; $01 (top-right, Top)
	dw $9940 ; $02 (bottom-left, Magnet)
	dw $994E ; $03 (bottom-right, Needle)

; =============== Tilemap_WilyCastle_ClosedDoor ===============
Tilemap_WilyCastle_ClosedDoor:
	db $2A,$72,$0D,$0E,$0F,$2F

; =============== Lvl_GetBlockId ===============
; Gets the block ID the sensor coordinates are pointing to and performs basic collision checks.
; The sensors are typically the player's coordinates offset by a particular value.
;
; IN
; - wTargetRelX: X sensor position, relative to the screen's position
; - wTargetRelY: Y sensor position, relative to the screen's position
; OUT
; - A: Block ID
; - C Flag: If set, the block is not solid
; - wPlYCeilMask: Ceiling collision mask
Lvl_GetBlockId:

	; Initialize the ceiling collision mask to the default value for fully solid blocks.
	; This will be updated later on in case we're checking the lower half of a small platform.
	; Note there's only one caller that actually uses this (the ceiling check while jumping).
	ld   a, $F0
	ld   [wPlYCeilMask], a
	
	
	;
	; Build the offset to the level layout.
	;
	; These are mainly generated by dividing the target position by the block width/height.
	;
	; Because actor positions directly map to raw sprite positions, they don't account
	; for the hardware offset, which needs to get subtracted here.
	;
	

	;##
	;
	; X COMPONENT
	;
	; C = wLvlColL - 2 + ((wTargetRelX + (hScrollX % 16) + 32 - OBJ_OFFSET_X) / 16)
	;     Absolute        Relative        Scroll offset within block
	;
	; This is offsetted by 2 blocks in an attempt to do a crude offscreen check that
	; matches how the one for actors works.
	;
	; In practice it doesn't seem to have any effect, as the calling code does a better job
	; with doing proper off-screen checks.
	;
	
	;
	; Calculate the relative block count first
	;
	
	; The horizontal position, unlike the vertical one, can scroll, so it doesn't necessarily start from the start of the block.
	; Since our target positions are relative to the screen, the scroll offset within the leftmost column must be accounted for.
	ldh  a, [hScrollXNybLow]	; C = (hScrollX & $0F) + $18
	add  $20-OBJ_OFFSET_X		; Account for HW offset, and the +2 for the offscreen check
	ld   c, a
	
	ld   a, [wTargetRelX]		; A = (wTargetRelX + C) & $F0
	add  c						; Add that to the target
	
	; At face value we're considering range $F0-$FF as off-screen.
	; Due to the offset of 2 blocks, it's actually checking range $D0-$DF, which is the exact same offscreen range for actors.
	and  $F0					
	cp   $F0					; A >= $F0?
	jr   nc, .solid				; if so, jump
	
	swap a						; Divide by block width to get the count
	and  $0F					; (Not necessary, already did "and $F0" before the swap)
	ld   b, a
	
	;
	; Then calculate the absolute block count.
	;
	ld   a, [wLvlColL]			; Get absolute block count for the leftmost column
	sub  $02					; -2 to counterbalance the +2 from the relative block count
	add  b						; Add the relative one, fixed for partial scroll
	ld   c, a					; To C
	
	;##
	
	;
	; Y COMPONENT (high byte)
	;
	; B = (wTargetRelY - OBJ_OFFSET_Y) / BLOCK_H
	;
	; This is simpler since levels are only 8 blocks tall and there's no way to scroll the screen vertically 
	;
	
	ld   a, [wTargetRelY]		; A = wTargetRelY - $10
	sub  OBJ_OFFSET_Y
	; Also performs its own off-screen check, which is more useful.
	; In practice, anything below or above the level is treated as empty.
	cp   $80					; A >= $80?
	jr   nc, .empty				; If so, jump
	
	swap a						; Divide by block height to get the count
	and  $0F
	ld   b, a					; Now BC has the full wLvlLayout offset
	
	;##
	
	; Read the block off the level layout
	ld   hl, wLvlLayout
	add  hl, bc
	ld   a, [hl]
	
	;
	; BLOCK ID CHECK
	;
	; Determine if the block is solid and store it to the C flag.
	; There's not much to it, all blocks before $22 are empty, the rest are solid.
	;
	; Typically the caller performs more exhaustive block ID checks as needed (ie: for water blocks, ladders).
	; The only special blocks we do check for are the half-solid platforms (see below).
	;
	;

	cp   BLOCKID_HALF_START		; A >= $3C?
	jr   nc, .chkHalfSolid		; If so, it's an half-solid platform
								; Otherwise, it's fully solid or empty
.std:
	cp   BLOCKID_SOLID_START	; Set < result to C flag
	ret
	
.solid:
	ld   a, BLOCKID_SOLID_START	; A = Block ID
	ret							; C Flag = Always clear when we get here
	
.empty:
	xor  a ;BLOCKID_EMPTY_START	; A = Block ID
	scf							; C Flag = Always set
	ret
	
.chkHalfSolid:
	;
	; For half-solid blocks, the upper half is solid, while the bottom half is empty.
	;
	; Given the target Y position is always relative to the top of the screen,
	; the Y position within a block is simply wTargetRelY % 16.
	; If that is >= 8, we're pointing to the empty bottom half, otherwise it's the solid top half.
	;
	ld   a, [wTargetRelY]		; Get Y position on screen
	and  $0F					; Get Y position within block
	cp   $08					; Pointing to the lower half?
	jr   nc, .halfEmpty			; If so, jump (empty)
	
.halfSolid:
	ld   a, $F8					; Otherwise, use half-height solid collision.
	ld   [wPlYCeilMask], a		; This only affects the ceiling check while jumping.
	ld   a, [hl]				; A = Block ID
	cp   BLOCKID_SOLID_START	; C Flag = Always clear
	ret
	
.halfEmpty:
	ld   a, [hl]				; A = Block ID
	scf  						; C Flag = Always set
	ret
	; =============== Wpn_DoActColi ===============
; Checks a shot for collision against all actors.
Wpn_DoActColi:
	DEF tActCenterX = wActSpawnX
	DEF tActCenterY = wActSpawnY
	; Loop through all 16 actors
	xor  a		; Start from the first slot
.loop:
	; Prepare main slot pointer
	ld   d, HIGH(wAct)			; DE = Ptr to main slot (wAct)
	ld   e, a
	ld   [wActCurSlotPtr], a	; Save ptr for future use
	
	; Skip empty slots
	ld   a, [de]
	or   a						; iActId == 0?
	jr   z, .nextSlot			; If so, jump
	
	and  $FF^ACTF_PROC	; Save original actor ID (without flags) for future reference
	ld   [wTmpColiActId], a		; as it might get replaced with an explosion if it gets defeated.
	
	; Prepare collision data slot pointer.
	; This is exactly $100 bytes after DE.
	ld   h, HIGH(wActColi)		; HL = Ptr to respective wActColi entry
	ld   l, e
	
	;##
	;
	; BOUNDING BOX CHECKS
	;
	; In general, these are performed by calculating the distance between the actor and a shot,
	; then checking if it's less than the sum of their collision box radiuses.
	; If it is, the shot is overlapping with the actor on that particular axis.
	; The shot overlaps with the actor when the checks pass for both axes.
	; 
	; Since the actors and shots can potentially be at any position, for this to work the calculation
	; should be the same regardless of their relative position to each other. That is to say,
	; the origins of actors and shots should be perfectly centered, so that the distance between
	; the origin and its border alongside a specific axis will always be its respective bounding box radius.
	;
	; The horizontal origins are already centered and don't need adjusting, but the vertical ones for actors
	; (and the player) do, as they are at the bottom, so they need to be subtracted by the vertical radius.
	;
	
	
	;
	; HORIZONTAL BOUNDING BOX CHECK
	;

	; Set up fields
	ld   a, e					; DE = Ptr to iActX
	add  iActX
	ld   e, a
	ld   a, [wWpnColiBoxH]		; C = wWpnColiBoxH
	ld   c, a
	ldh  a, [hShotCur+iShotX]	; B = iShotX
	ld   b, a
	
	; Calculate the absolute distance
	ld   a, [de]				; A = iActX
	ld   [tActCenterX], a		; (Not used)
	sub  b						; Get distance (iActX - iShotX)
	jr   nc, .setDistX			; Is that a positive value? If so, skip
	xor  $FF					; Otherwise, convert to positive
	inc  a
	scf 
.setDistX:
	ld   b, a					; B = Distance
	; If the shot isn't horizontally overlapping with the collision box, seek to the next slot.
	ldi  a, [hl]				; Get actor radius (A = iActColiBoxH, seek to iActColiBoxV)
	add  c						; Sum with shot radius, that's the max distance (A += wWpnColiBoxH)
	cp   b						; MaxDistance - Distance < 0? (Distance > MaxDistance?)
	jr   c, .nextSlot			; If so, jump (not colliding, too far)
	
	;
	; VERTICAL BOUNDING BOX CHECK
	; 
	
	; Set up fields
	ld   a, [wWpnColiBoxV]		; C = wWpnColiBoxV
	ld   c, a
	ldh  a, [hShotCur+iShotY]	; B = iShotY
	ld   b, a
	inc  e ; iActYSub
	inc  e ; iActY
	
	; Calculate the absolute distance, like above
	ld   a, [de]				; A = iActY
	;--
	; The actor's origin is at the bottom of the sprite.
	; For the distance calculation, pretend it's centered by subtracting its vertical radius.
	sub  [hl]					; A -= iActColiBoxV
	ld   [tActCenterY], a		; Save centered value for a later check
	;--
	sub  b						; Get distance (iActY - iShotY)
	jr   nc, .setDistY			; Is that a positive value? If so, skip
	xor  $FF					; Otherwise, convert to positive
	inc  a
	scf
.setDistY:
	ld   b, a					; B = Distance
	; Do the bounds check
	ldi  a, [hl]				; A = iActColiBoxV, seek to iActColiType
	add  c						; A += wWpnColiBoxV
	cp   b						; MaxDistance - Distance >= 0? (Distance <= MaxDistance?)
	call nc, Wpn_OnActColi		; If so, we're in range. Handle collision.
								; Otherwise, seek to the next slot
	;##
.nextSlot:
	
	ld   a, [wActCurSlotPtr]	; A = Low byte of slot pointer
	add  iActEnd				; Next slot
	
	jr   nz, .loop				; Processed all 16 slots (overflowed back to $00?) If not, loop
	ret
	
; =============== Wpn_OnActColi ===============
; Handles collision for a shot against a specific actors.
; IN
; - HL: Ptr to the actor's collision type (iActColiType)
Wpn_OnActColi:

	;
	; Determine how to handle it depending on the actor's collision type.
	;
	ldi  a, [hl]				; A = iActColiType, seek to iActColiDamage
	; ACTCOLI_PASS and ACTCOLI_ENEMYPASS are completely intangible by shots.
	; Shots should pass through them, so return.
	cp   ACTCOLI_ENEMYHIT		; A < ACTCOLI_ENEMYHIT?
	ret  c						; If so, return
	; ACTCOLI_ENEMYHIT is for vulnerable enemies (can hit)
	jr   z, .typeEnemyHit		; A == ACTCOLI_ENEMYHIT? If so, jump
	; ACTCOLI_ENEMYREFLECT is for invulerable enemies (always deflect)
	cp   ACTCOLI_ENEMYREFLECT	; A == ACTCOLI_ENEMYREFLECT
	jp   z, .deflect
	; ACTCOLI_PLATFORM, ACTCOLI_MAGNET, ACTCOLI_ITEM and ACTCOLI_UNUSED_PASS2 are for special collisions not used by enemies.
	; ACTCOLI_UNUSED_PASS2 is unused and acts like a duplicate of ACTCOLI_PASS.
	; Shots pass through them.
	cp   ACTCOLI_8_START		; A < ACTCOLI_8_START?
	ret  c						; If so, return
	
; --------------- .typePartial ---------------
.typePartial:
	;
	; All types above ACTCOLI_UNUSED_PASS2 are used for "partially resistant" collision.
	; The collision type is treated as an offset relative to the vertical center of the actor.
	;
	; The actor will be damaged only if the shot's position is below that point.
	;
	; Used by Quint, the final boss and Pickelman Bull.
	;
	
	; B = Absolute threshold point (relative to the screen)
	ld   b, a				; B = Relative thresold value (iActColiType)
	ld   a, [tActCenterY]	; A = Actor's Y position
	add  b					; ActPos += Rel, to get the actual threshold
	ld   b, a
	
	; If you shoot anywhere below that point, deflect it
	ldh  a, [hShotCur+iShotY]	; A = iShotY
	cp   b						; iShotY >= Threshold?
	jp   nc, .deflect			; If so, it's deflected
	
	; Otherwise, deal damage
	
; --------------- .typeEnemyHit ---------------
.typeEnemyHit:
	
	; If the actor has mercy invincibility, ignore the collision.
	; [POI] Unlike other games, the shot does not get despawned when this happens
	;       which is the reason rapid-fired shots may pass through enemies.
	inc  l ; iActColiHealth
	inc  l ; iActColiInvulnTimer
	ldd  a, [hl]	; A = iActColiInvulnTimer, seek to iActColiHealth
	or   a			; Invuln != 0?
	ret  nz			; If so, return
	
	
	push hl
		;
		; Determine how weak the actor is to the weapon shot.
		;
		; This data is stored from the 6th byte of a ActS_ColiTbl entry, roughly
		; ordered by weapon ID.
		; To save space, this data isn't *exactly* in the same order as WPN_*, 
		; as it skips over weapons that can't do damage like the items.
		;
		; Therefore, first calculate the weapon index relative to the 6th byte.
		;
		
		; There's a special case with the Sakugarne item, since the player can fire normal shots when not riding it.
		; Those shots should not count as Sakugarne shots.
		ld   a, [wWpnId]
		cp   WPN_SG				; Sakugarne selected?
		jr   nz, .idxSubItems	; If not, jump
		ld   a, [wWpnSGRide]
		or   a					; Actually riding it?
		jr   z, .idxUseDefault	; If not, treat it as the default weapon
		; Otherwise, use the Sakugarne index.
		; + 3 to balance out the - 3 below
		; - iRomActColiDmgP to balance out the base index added later
		ld   a, iRomActColiDmgSg - iRomActColiDmgP + 3
	.idxSubItems:
		; The three items are skipped and shift almost all entries up by 3.
		; If we were using a default weapon or Rush (IDs 0 to 3), this will cause the index
		; to either fall back to 0 (P Shooter), or underflow.
		; If it underflowed, fall back to the P Shooter entry too.
		; This which works out, given Rush forms allow to fire normal shots in some way or another.
		sub  $03				; A -= 3
		jr   nc, .calcColiIdx	; Underflowed? If not, skip
	.idxUseDefault:
		xor  a ; iRomActColiDmgP - iRomActColiDmgP
	.calcColiIdx:
		ld   e, a				; E = Struct index (- iRomActColiDmgP)
		
		; Seek to the value we're looking for in the actor collision table.
		; Each entry is $10 bytes long, so:
		; BC = (wTmpColiActId * $10) + iRomActColiDmgP + E
		ld   a, [wTmpColiActId]
		ld   c, a
			swap a		; B = wTmpColiActId >> 4
			and  $0F
			ld   b, a
		ld   a, c		
		swap a			; A = wTmpColiActId << 4
		and  $F0
		or   iRomActColiDmgP	; From first weapon entry
		add  e			; Add the struct index
		ld   c, a		; Save to C
		
		; Read the byte to wWpnActDmg
		ld   hl, ActS_ColiTbl
		add  hl, bc
		push af
			ld   a, BANK(ActS_ColiTbl) ; BANK $03
			ldh  [hRomBank], a
			ld   [MBC1RomBank], a
		pop  af
		ld   a, [hl]
		ld   [wWpnActDmg], a
		push af
			ldh  a, [hRomBankLast] ; Back to BANK $01
			ldh  [hRomBank], a
			ld   [MBC1RomBank], a
		pop  af
		
	pop  hl
	
	; If this weapon deals zero damage to the actor (enemy is immune to it), deflect the shot.
	ld   a, [wWpnActDmg]
	or   a					; wWpnActDmg == 0?
	jp   z, .deflect			; If so, deflect it
	ld   b, a				; B = Damage dealt
	
	;--
	;
	; The Sakugarne always rebounds on contact with another enemy.
	; This same exact check will be repeated other times, such as when the enemy is immune,
	; with the same result.
	;
	ld   a, e				; A = Struct index
	cp   iRomActColiDmgSg - iRomActColiDmgP	; Pointing to the Sakugarne?
	jr   nz, .decHealth		; If not, skip
	; Otherwise, do a jump at 2px/frame
	ld   a, $00
	ld   [wPlSpdYSub], a
	ld   a, $02
	ld   [wPlSpdY], a
	ld   a, PL_MODE_FULLJUMP
	ld   [wPlMode], a
	;--
.decHealth:

	; Deal damage to the actor.
	ld   a, [hl]			; A = iActColiHealth (Enemy health)
	sub  b					; Subtract the damage inflicted
	jr   z, .actDead		; If the enemy has no health left, jump
	jr   c, .actDead		; Same it if has underflowed
	
; --------------- .actHit ---------------
.actHit:
	ldi  [hl], a			; Save back the updated health to iActColiInvulnTimer, seek to iActColiInvulnTimer
	ld   [wBossHealth], a	; Set this one in case we're in the boss room
	push hl
		; When the actor survives the hit, despawn the shot if doesn't fully pierce
		ld   a, [wWpnPierceLvl]
		cp   WPNPIERCE_ALWAYS	; Does this weapon always pierce? (wWpnPierceLvl >= 2)
		jr   nc, .actHitTp		; If so, skip
		xor  a					; Otherwise, despawn the shot
		ldh  [hShotCur+iShotId], a
	.actHitTp:
		
		; If we're using Top Spin, use up ammo on contact.
		; This is only the case with bosses, as enemies are set to either die in 1 hit (.actDead),
		; or completely resist the attack.
		ld   a, [wWpnId]
		cp   WPN_TP
		call z, WpnS_UseAmmo
		

	; Give 12 frames of mercy invincibility to non-boss enemies.
	; This is a bit excessive, although keep in mind the flashing animation is directly tied to this invulerability period.
	pop  hl
	ld   [hl], $0C	; iActColiInvulnTimer = $12
	
	; Play hit sound
	ld   a, SFX_ENEMYHIT
	mPlaySFX
	
	;
	; If we hit a boss, make that invulnerability period last longer,
	; and also redraw the status bar.
	;
	
	; For performance, boss damage checks aren't always enabled
	ld   a, [wBossDmgEna]
	or   a
	ret  z
	
	; Check for the actor ID ranges used by bosses
	ld   a, [wTmpColiActId]
	; Final bosses in range $50-$53 (Quint and the three Wily Machine forms) 
	cp   ACT_SPECBOSS_START		; ID < $50?
	ret  c						; If so, return
	cp   ACT_SPECBOSS_END		; ID < $54?
	jr   c, .bossHit			; If so, jump
	; Main bosses in range $68-$6F
	cp   ACT_BOSS_START			; ID < $68?
	ret  c						; If so, return
	cp   ACT_BOSS_END			; ID >= $70?
	ret  nc						; If so, return
.bossHit:
	; Half a second of mercy invulerability
	ld   [hl], $1E				; iActColiInvulnTimer = $1E
	
	; Redraw the boss' health bar.
	; This boss health value, unlike most others, is measured in bars and not in units of health.
	; wBossHealthBar expects the latter, so...
	ld   a, [wBossHealth]		; Get units of health
	add  a						; A *= 8, as each bar is worth 8 units
	add  a
	add  a
	ld   [wBossHealthBar], a	; Set bar redraw value
	ld   hl, wStatusBarRedraw	; Trigger redraw
	set  BARID_BOSS, [hl]
	ret
	
; --------------- .actDead ---------------
.actDead:
	; When the actor dies from the hit, despawn the shot only if never pierces.
	; This allows shots that only pierce when the actor dies to pass through.
	ld   a, [wWpnPierceLvl]
	cp   WPNPIERCE_LASTHIT	; wWpnPierceLvl >= $01? (wWpnPierceLvl != WPNPIERCE_NONE)
	jr   nc, .actDeadTp		; If so, skip
	xor  a					; Otherwise, despawn the shot
	ldh  [hShotCur+iShotId], a
	
.actDeadTp:
	; Top Spin uses up ammo on successful contact
	; (and only when it destroys the enemy, which it did if we got here)
	ld   a, [wWpnId]
	cp   WPN_TP
	call z, WpnS_UseAmmo
	
	;
	; Convert the defeated actor into an explosion.
	; The explosion actor will make use of the inherited properties
	; to position itself to the center of its collision box.
	;
	
	ld   h, HIGH(wAct)			; HL = Ptr to actor slot
	ld   a, [wActCurSlotPtr]
	ld   l, a
	
	; Replace ID with the explosion one
	ld   a, ACTF_PROC|ACT_EXPLSM
	ldi  [hl], a ; iActId
	
	xor  a
	ldi  [hl], a ; iActRtnId
	ldi  [hl], a ; iActSprMap
	
	; Make the actor intangible, as explosions shouldn't damage the player.
	ld   h, HIGH(wActColi)		; HL = Ptr to respective collision entry
	ld   a, [wActCurSlotPtr]
	ld   l, a
	
	inc  l ; iActColiBoxV
	inc  l ; iActColiType
	xor  a
	ld   [hl], a				; Set ACTCOLI_PASS
	
	;
	; If the actor we just defeated was a boss.
	; These are nearly the same checks used for .bossHit
	;

	; For performance, boss damage checks aren't always enabled.
	; If they aren't, roll the dice and try to spawn an item.
	ld   a, [wBossDmgEna]
	or   a
	jp   z, ActS_TrySpawnItemDrop
	;--
	
	; Check for the actor ID ranges used by bosses
	ld   a, [wTmpColiActId]
	; Final bosses in range $50-$53 (Quint and the three Wily Machine forms) 
	; [POI] Quint never has wBossDmgEna enabled, so we'll never get there.
	cp   ACT_SPECBOSS_START		; ID < $50?
	ret  c						; If so, return
	cp   ACT_SPECBOSS_END		; ID < $54?
	jr   c, .bossDead			; If so, jump
	; Main bosses in range $68-$6F
	cp   ACT_BOSS_START			; ID < $68?
	ret  c						; If so, return
	cp   ACT_BOSS_END			; ID >= $70?
	ret  nc						; If so, return
	
.bossDead:
	; In case of a double KO, do not trigger the boss' explosion animation as it'd give the victory to the player.
	; However, still hide the health bar as the boss was converted to an explosion actor already.
	ld   a, [wLvlEnd]
	cp   LVLEND_PLDEAD			; Player has exploded already?
	jr   z, .bossClrBar			; If so, skip
	
	; The explosions should originate from the center of the boss.
	; As bosses are generally the same height as the player, and also have their
	; origin at the bottom, the player's radius can be reused to get to the center.
	ld   h, HIGH(wAct)		; HL = Ptr to slot's iActX
	ld   a, [wActCurSlotPtr]
	add  iActX
	ld   l, a
	ld   a, [hl]			; X Origin = Actor's X origin (middle)
	ld   [wExplodeOrgX], a
	inc  l ; iActYSub
	inc  l ; iActY
	ld   a, [hl]			; Y Origin = Actor's Y origin (bottom)
	sub  PLCOLI_V			; More or less move up to middle
	ld   [wExplodeOrgY], a
	
	; And trigger it
	ld   a, LVLEND_BOSSDEAD
	ld   [wLvlEnd], a
	
.bossClrBar:
	; Draw an health bar with no energy left.
	xor  a
	ld   [wBossHealthBar], a
	ld   hl, wStatusBarRedraw
	set  BARID_BOSS, [hl]
	ret
	
; --------------- .deflect ---------------
; The shot dealt no damage.
; Most weapons just get their shots deflected, a few have special handling though.
.deflect:
	;
	; Top Spin continues as normal if an enemy resistant to it is hit.
	; Chances are the player gets hit when this happens, due to the player's collision box
	; being barely covered by Top Spin's.
	;
	ld   a, [wWpnId]
	cp   WPN_TP				; Using Top Spin?
	jr   nz, .deflectCr		; If not, jump
	; At least no weapon ammo is consumed.
	ld   a, SFX_DEFLECT
	mPlaySFX
	ret
.deflectCr:
	;
	; Crash Bombs explode on contact against a resistant enemy.
	;
	cp   WPN_CR				; Using Crash Bombs?
	jr   nz, .deflectSg		; If not, jump
	
	ldh  a, [hShotCur+iShotWkTimer]
	bit  SHOTCRB_EXPLODE, a			; Is it exploding already?
	ret  nz							; If so, return
	ld   a, SHOTCR_EXPLODE			; Otherwise, overwrite the timer to point
	ldh  [hShotCur+iShotWkTimer], a	; to the start of the explosion phase
	ret
	
.deflectSg:
	;
	; As before, the Sakugarne always rebounds on contact with another enemy.
	;
	ld   a, [wWpnSGRide]
	or   a					; Riding the Sakugarne?
	jr   z, .deflectNorm	; If not, jump
	; Do jump at 2px/frame
	ld   a, $00
	ld   [wPlSpdYSub], a
	ld   a, $02
	ld   [wPlSpdY], a
	ld   a, PL_MODE_FULLJUMP
	ld   [wPlMode], a
	; Play deflect sound
	ld   a, SFX_DEFLECT
	mPlaySFX
	ret
	
.deflectNorm:
	;
	; Any other weapon gets deflected as normal.
	;
	
	; Reset timer
	xor  a
	ldh  [hShotCur+iShotWkTimer], a
	; Mark the shot as being deflected
	ldh  a, [hShotCur+iShotFlags]
	or   SHOT3_DEFLECT
	ldh  [hShotCur+iShotFlags], a
	; Play respective sound
	ld   a, SFX_DEFLECT
	mPlaySFX
	ret
	
; =============== Pl_DoActColi ===============
; Checks for player collision against all actors.
; See also: Wpn_DoActColi
Pl_DoActColi:

	; Make a copy of this before it gets wiped right below.
	; The copy will be exclusively used by this subroutine.
	ld   a, [wActRjStandSlotPtr]
	ld   [wActRjStandLastSlotPtr], a
	
	; Reset slot markers.
	; There are generally used to signal to another actor that a specific type of collision has happened.
	; Actor code may check for these by comparing their actor slot pointer to what's specified in the markers,
	; and if it matches the actor knows the player has collided with it in some way.
	ld   a, ACTSLOT_NONE
	ld   [wActHurtSlotPtr], a
	ld   [wActPlatColiSlotPtr], a
	ld   [wActRjStandSlotPtr], a
	ld   [wActHelperColiSlotPtr], a
	
	;
	; Player collision box - Vertical radius.
	; 
	; Typically this is PLCOLI_V (12px pixels, aka 24px tall) unless the player is sliding.
	; In that case, the radius is halved.
	;
	ld   b, PLCOLI_V	; B = Normal radius
	ld   a, [wPlMode]
	cp   PL_MODE_SLIDE	; Are we sliding?
	jr   nz, .setPlH	; If not, skip
	srl  b				; Otherwise B /= 2
.setPlH:
	ld   a, b
	ld   [wPlColiBoxV], a
	
	;
	; As mentioned in Wpn_DoActColi, the bounding box checks require the origin to be centered.
	;
	ld   a, [wPlRelY]		; A = Player Y origin (bottom)
	sub  b					; Move up to center
	ld   [wPlCenterY], a	; Don't recalculate again
	
	
	;
	; Loop through all 16 actors, handling collision for any with overlapping bounding boxes.
	;
	xor  a					; Start from the first slot
.loop:
	; Prepare main slot pointer
	ld   d, HIGH(wAct)			; DE = Ptr to main slot (wAct)
	ld   e, a
	ld   [wActCurSlotPtr], a	; Save ptr for future use
	
	; Skip empty slots
	ld   a, [de]
	or   a						; iActId == 0?
	jr   z, .nextSlot			; If so, jump
	
	; Prepare collision data slot pointer.
	; This is exactly $100 bytes after DE.	
	ld   h, HIGH(wActColi)		; HL = Ptr to respective wActColi entry
	ld   l, e
	
	;
	; HORIZONTAL BOUNDING BOX CHECK
	;
	
	; Set up fields
	ld   a, e			; DE = Ptr to iActX
	add  iActX
	ld   e, a
	ld   a, [wPlRelX]	; B = wPlRelX
	ld   b, a
	
	; Calculate the absolute distance
	ld   a, [de]		; A = iActX
	sub  b				; Get distance (iActX - wPlRelX)
	jr   nc, .setDistX	; Is that a positive value? If so, skip
	xor  $FF			; Otherwise, convert to positive
	inc  a
	scf					; (leftover from other code that uses this flag)
.setDistX:
	ld   b, a			; B = Distance
	; If the player isn't horizontally overlapping with the collision box, seek to the next slot
	ldi  a, [hl]		; Get actor radius (A = iActColiBoxH, seek to iActColiBoxV)
	; [BUG] Off by one inconsistency with the block collision code
	add  PLCOLI_H+1		; Sum with player radius, that's the max distance (A += wWpnColiBoxH)
	cp   b				; MaxDistance - Distance < 0? (Distance > MaxDistance?)
	jr   c, .nextSlot	; If so, jump (not colliding, too far)
	
	;
	; VERTICAL BOUNDING BOX CHECK
	;
	
	inc  e ; iActYSub
	inc  e ; iActY
	ld   a, [wPlColiBoxV]	; C = wPlColiBoxV
	ld   c, a
	ld   a, [wPlCenterY]	; B = wPlCenterY
	ld   b, a
	
	; Calculate the absolute distance, like above
	ld   a, [de]			; A = iActY (origin, bottom)
	sub  [hl]				; A -= iActColiBoxV (middle)
	sub  b					; Get distance (iActY - wPlCenterY)
	jr   nc, .setDistY		; Is that a positive value? If so, skip
	xor  $FF				; Otherwise, convert to positive
	inc  a
	scf  					; (leftover from other code that uses this flag)
.setDistY:
	ld   b, a				; B = Distance
	; Do the bounds check
	ldi  a, [hl]			; A = iActColiBoxV, seek to iActColiType
	add  c					; A += wPlColiBoxV
	cp   b					; MaxDistance - Distance >= 0? (Distance <= MaxDistance?)
	call nc, Pl_OnActColi	; If so, we're in range. Handle collision.
							; Otherwise, seek to the next slot
.nextSlot:
	ld   a, [wActCurSlotPtr]	; A = Low byte of slot pointer
	add  iActEnd				; Next slot
	
	jr   nz, .loop				; Processed all 16 slots (overflowed back to $00?) If not, loop
	ret
	
; =============== Pl_OnActColi ===============
; Handles collision for the player against a specific actors.
; IN
; - HL: Ptr to the actor's collision type (iActColiType)
; - DE: Ptr to the actor's Y position (iActY)
Pl_OnActColi:

	;
	; Determine how to handle it depending on the actor's collision type.
	;
	
	ldi  a, [hl]			; A = iActColiType, seek to iActColiDamage/iActColiSubtype
	; Ignore intangible actors
	or   a					; A == ACTCOLI_PASS?
	ret  z					; If so, return
	; Actors with collision types >= $80 are enemies partially vulnerable on top (see Wpn_OnActColi.typePartial).
	; [POI] Note that this isn't the full range of values for this collision type, that would be $08-$FF.
	;       This causes the excluded range to fail all checks and not hurt the player at all.
	bit  ACTCOLIB_PARTIAL, a	; A >= $80?
	jr   nz, .coliEnemy		; If so, jump
	; Check non-enemy collision types elsewhere
	cp   ACTCOLI_PLATFORM	; A >= $04?
	jr   nc, .coliPlatform	; If so, jump
	
; --------------- .coliEnemy ---------------
; Enemy collision type, which causes the player to be damaged.
; Used by:
; - ACTCOLI_ENEMYPASS
; - ACTCOLI_ENEMYHIT
; - ACTCOLI_ENEMYREFLECT
.coliEnemy:

	; If cheating, we're invulnerable
	ldh  a, [hCheatMode]
	or   a
	ret  nz
	
	; If we're in the middle of mercy invincibility, well...
	ld   a, [wPlInvulnTimer]
	or   a
	ret  nz
	
	; Keep track of the actor slot we got hit by.
	; Exactly one actor makes use of this.
	ld   a, [wActCurSlotPtr]
	ld   [wActHurtSlotPtr], a
	
	; Play hurt SFX
	ld   a, SFX_DAMAGED
	mPlaySFX
	
	; Stay in the hurt pose for around half a second
	ld   a, $20
	ld   [wPlHurtTimer], a
	; With a full second of invulnerability afterwards
	ld   a, $3C
	ld   [wPlInvulnTimer], a
	
	;--
	;
	; Only PL_MODE_GROUND and PL_MODE_FALL support the hurt pose.
	; Force the player into the former to enable it.
	; (if we're in the air, it will transition to PL_MODE_FALL)
	;
	
	ld   a, [wPlMode]
	; Getting forced out of sliding could cause the player to get stuck.
	cp   PL_MODE_SLIDE
	jr   z, .decHealth
	; Don't get forced out of Rush Marine either, there might be pits.
	; It would also be the improper way of doing it, as just setting PL_MODE_GROUND
	; would cause the player and Rush Marine to be active at the same time.
	cp   PL_MODE_RM
	jr   z, .decHealth
	; Sakugarne has its own ride mode on top of the player's idle state,
	; so it needs no special checks
	xor  a ; PL_MODE_GROUND
	ld   [wPlMode], a
	;--
.decHealth:
	; Deal damage to the player
	ld   h, HIGH(wActColi)		; Seek HL to iActColiDamage 
	ld   a, [wActCurSlotPtr]
	add  iActColiDamage
	ld   l, a
	
	; wPlHealth -= iActColiDamage
	ld   a, [wPlHealth]			; A = Player health
	sub  [hl]					; Subtract the damage received
	jr   nc, .setHealth			; Did we underflow the health? If not, skip
	xor  a						; Otherwise, cap to 0
.setHealth:
	push af
		ld   [wPlHealth], a			; Save back the updated health
		
		ld   [wPlHealthBar], a		; Trigger redrawing the health bar
		ld   hl, wStatusBarRedraw
		set  BARID_PL, [hl]
	
	;
	; If we have no health left, explode the player.
	;
	pop  af			; Get wPlHealth
	or   a			; wPlHealth != 0?
	ret  nz			; If so, return
	
	; The explosions originate from the center of the player
	ld   a, [wPlRelX]		; X Origin = Player's X origin (center)
	ld   [wExplodeOrgX], a
	ld   a, [wPlRelY]		; Y Origin = Player's Y origin (bottom)
	sub  PLCOLI_V			; Move up to middle
	ld   [wExplodeOrgY], a
	
	; And trigger it
	ld   a, LVLEND_PLDEAD
	ld   [wLvlEnd], a
	ret
	
; --------------- .coliPlatform ---------------
; Solid platforms and helper items.
; Since these cannot damage the player, iActColiDamage gets reused as iActColiSubtype here.
.coliPlatform:
	cp   ACTCOLI_PLATFORM	; iActColiType == ACTCOLI_PLATFORM?
	jp   nz, .coliMagnet	; If not, jump
	
	; Check the collision subtype...
	ldd  a, [hl]		; A = iActColiSubtype, seek to iActColiType
	or   a				; A != ACTCOLISUB_TOPSOLID?
	jr   nz, .spinTop	; If so, jump
	
.topSolid:
	;
	; Generic top-solid platform.
	; 

	; Standing on Rush Jet disables collision with top-solid platforms
	ld   a, [wActRjStandLastSlotPtr]
	cp   ACTSLOT_NONE
	ret  nz
	
	; Try to snap to the top of the platform
	jp   .chkSnapTop
	
.spinTop:
	;
	; Spinning top, which moves the player back and forth.
	; 
	
	cp   ACTCOLISUB_SPINTOP	; A != ACTCOLISUB_SPINTOP?
	jr   nz, .helpers	; If so, jump
	
	; Standing on Rush Jet disables collision with spinning tops
	ld   a, [wActRjStandLastSlotPtr]
	cp   ACTSLOT_NONE
	ret  nz
	
	; Try to snap to the top of the platform
	call .chkSnapTop
	
	;
	; Handle the automatic player movement when colliding with one.
	; [BUG] This forgets to check if we're actually standing on the
	;       platform ("ret c" after the call above)
	;
	
	; Every 16 frames, alternate the player's horizontal direction (bit0)
	ldh  a, [hTimer]				; wPlDirH = (hTimer / $10) % 2
	swap a
	and  $01
	ld   [wPlDirH], a
	
	; Alter the player's speed by 0.5px/frame to that direction
	; iActSprMap has its direction flag on bit7
	; Rotate bit0 to bit7
	rrca 							; A = iActSprMap (Direction)
	ld   bc, $0080					; BC = 0.5px/frame
	call Pl_SetSpeedByActDir	; Update the speed by BC
	
	; And actually move the player
	jp   Pl_BgColiApplySpeedX
	
.helpers:
	;
	; The remainder of subtypes are used by helper actors (Rush, Sakugarne).
	; Each helper actor has its own collision subtype.
	;
	
	; Only process this collision if the actor is fully active.
	; (ie: it must be spawned, and it must not be teleporting)
	ld   b, a
		ld   a, [wWpnHelperWarpRtn]
		cp   AHW_ACTIVE		; wWpnHelperWarpRtn != AHW_ACTIVE?
		ret  nz				; If so, return
	ld   a, b
	
	;
	; Rush Jet is a top-solid platform whose vertical position can be controlled
	; only when standing on it.
	;
	
	cp   ACTCOLISUB_RJ			; iActColiSubtype != ACTCOLISUB_RJ?
	jr   nz, .markHelperColi	; If so, skip
	
	; Try to snap to the top of Rush Jet
	call .chkSnapTop			; Are we standing on it now?
	jr   nc, .markHelperColi	; If not, skip
								; Otherwise...
							
	; Mark the player as standing on Rush Jet by flagging the actor slot.
	ld   a, [wActCurSlotPtr]
	ld   [wActRjStandSlotPtr], a
	
	; Move player 1px vertically depending on the direction held.
	; To go along with it, the actor also moves, but that's handled separately.
	ld   hl, wPlRelY			; HL = Ptr to wPlRelY
	ldh  a, [hJoyKeys]
	rla							; Holding DOWN?
	jr   nc, .chkRjD			; If not, jump
	inc  [hl]					; Otherwise, move 1px down
	jr   .markHelperColi
.chkRjD:
	rla  						; Holding UP?
	jr   nc, .markHelperColi	; If not, jump
	dec  [hl]					; Otherwise, move 1px up
	
.markHelperColi:
	; Signal out that collision has happened with the checked helper actor.
	; The actors themselves will check if they were collided with and activate their effects.
	
	; Their effects should only trigger when falling on them, on the way down.
	ld   a, [wPlMode]
	cp   PL_MODE_FALL				; wPlMode == PL_MODE_FALL?
	ret  nz							; If not, return
	ld   a, [wActCurSlotPtr]
	ld   [wActHelperColiSlotPtr], a
	ret
	
; --------------- .chkSnapTop ---------------
; Snaps the player to the top of the platform if they are above the platform's center point.
; Note that we can only get here when the player and platform collision boxes overlap.
;
; IN
; - HL: Ptr to iActColiType
; - DE: Ptr to the actor's Y position (iActY)
; OUT
; - C Flag: If set, the player is standing on the platform
.chkSnapTop:
	DEF tPlatColiV = wTmpCF52
	DEF tActY      = wTmpCF53
	
	; B = Vertical center position of the platform, absolute
	dec  l ; iActColiBoxV
	ld   a, [hl]			; B = iActColiBoxV
	ld   [tPlatColiV], a	; Save for later
	ld   b, a
	ld   a, [de]			; A = iActY (bottom)
	ld   [tActY], a			; Save for later
	sub  b					; Move to center
	ld   b, a
	
	; If the player is below that point, return
	ld   a, [wPlRelY]
	cp   b					; wPlRelY >= PlatCenter?
	ret  nc					; If so, return
	
	; Only if the player is on the ground or jumping.
	; [BUG] This forgets to account for the player sliding.
	ld   a, [wPlMode]
	cp   PL_MODE_CLIMB		; wPlMode >= PL_MODE_CLIMB?
	ret  nc					; If so, return
	
	;
	; If the player is standing on solid ground already, return.
	;
	; Standing on a solid ground means that both the bottom-left and bottom-right
	; edges of the collision box are on solid blocks (or ladder top tiles).
	;
	
	; Target the ground for both checks
	ld   a, [wPlRelY]		; Y Target = 1px below bottom border
	inc  a
	ld   [wTargetRelY], a
	
	; Check left sensor
	ld   a, [wPlRelX]			; X Target = Left (wPlRelX - PLCOLI_H)
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_TOPSOLID_START	; Is this a solid block on top? (A >= $21)
	ret  nc						; If so, return
	
	; Check right sensor
	ld   a, [wPlRelX]			; X Target = Right (wPlRelX + PLCOLI_H)
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_TOPSOLID_START	; Is this a solid block on top? (A >= $21)
	ret  nc						; If so, return
	
	;
	; All checks passed, snap the player to the top of the actor.
	;
	ld   a, [tPlatColiV]	; B = V Collision box radius
	ld   b, a
	ld   a, [tActY]			; A = Actor Y origin (bottom)
	sub  b					; to middle
	sub  b					; to top
	
	; Don't put the player directly above the border, but 2 pixels below,
	; to make sure the player keeps colliding with the platform even when
	; said platform moves down.
	; A consequence is that platforms can't move down faster than 1px/frame,
	; otherwise the player may stop overlapping with its collision box.
	inc  a
	inc  a
	ld   [wPlRelY], a		; Save back updated player pos
	
	; Mark the player as standing on this actor.
	ld   a, [wActCurSlotPtr]
	ld   [wActPlatColiSlotPtr], a
	
	scf  ; C Flag = Set
	ret
	
; --------------- .coliMagnet ---------------
; Magnetic Fields.
.coliMagnet:
	cp   ACTCOLI_MAGNET		; iActColiType == ACTCOLI_MAGNET?
	jr   nz, .coliItem		; If not, jump
	
	; This collision type is used by the magnetic fields in Magnet Man's stage.
	; While the actors use a small wave sprite, their actual collision box covers
	; the entire area that needs to attract the player to the right. 
	
	; Moves the player 0.5px/frame right on contact.
	; There are no magnetic fields that attract to the left, so the direction here is hardcoded.
	ld   a, ACTDIR_R	; Move right
	ld   bc, $0080		; Move 0.5px/frame
	jp   Pl_SetSpeedByActDir
	
; --------------- .coliItem ---------------
; Collectable items.
.coliItem:
	cp   ACTCOLI_ITEM		; iActColiType == ACTCOLI_ITEM?
	ret  nz				; If not, return
	
	; The collision code to run depends on the item type we collected.
	; That is determined by the actor ID.
	ld   h, HIGH(wAct)	; Seek HL to iActId
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ld   a, [hl]		; A = iActId
	; Force valid range, as items are all located within the first 8 actor IDs.
	and  $07
	
	push af ; Save untouched iActId
		
		; Despawn the item
		xor  a
		ld   [hl], a	; iActId
		
		inc  l ; iActRtnId
		inc  l ; iActSprMap
		inc  l ; iActLayoutPtr
		
		; If the item is part of the actor layout (ie: wasn't an enemy drop), permadespawn it.
		ld   a, [hl]			; Read location in actor layout
		or   a					; Is one set?
		jr   z, .execItemCode	; If not, skip
		ld   l, a				; Otherwise, seek HL to its location there
		ld   h, HIGH(wActDespawnTbl)
		ld   [hl], ACTL_NOSPAWN	; Mark the item as collected
		
.execItemCode:
	pop  af ; A = Collected iActId
	rst  $00 ; DynJump
	dw .noItem    ; ACT_EXPLSM (Not used)
	dw .extraLife ; ACT_1UP
	dw .ammoLg    ; ACT_AMMOLG
	dw .healthLg  ; ACT_HEALTHLG
	dw .healthSm  ; ACT_HEALTHSM
	dw .ammoSm    ; ACT_AMMOSM
	dw .etank     ; ACT_ETANK
	dw .noItem    ; ACT_EXPLLGPART (Not used)

; --------------- .extraLife ---------------
; 1-UP
.extraLife:
	; Cap lives to 9
	ld   a, [wPlLives]
	cp   $09			; wPlLives >= 9?
	ret  nc				; If so, return
	
	; Add an extra life
	inc  a
	ld   [wPlLives], a
	
	; Redraw the status bar
	ld   [wPlLivesView], a
	ld   hl, wStatusBarRedraw
	set  BARID_LIVES, [hl]
	
	; Obtain 2 coins
	ld   a, SFX_1UP
	mPlaySFX
	ret
	
; --------------- .ammoLg ---------------
; Large Weapon Energy
.ammoLg:
	ld   a, [wWpnAmmoInc]	; Add 9 bars of ammo
	add  BAR_UNIT*9
	ld   [wWpnAmmoInc], a
	ret
; --------------- .ammoSm ---------------
; Small Weapon Energy
.ammoSm:
	ld   a, [wWpnAmmoInc]	; Add 3 bars of ammo
	add  BAR_UNIT*3
	ld   [wWpnAmmoInc], a
	ret
	
; --------------- .healthLg ---------------
; Large Life Energy
.healthLg:
	ld   a, [wPlHealthInc]	; Add 9 bars of health
	add  BAR_UNIT*9
	ld   [wPlHealthInc], a
	ret
; --------------- .healthSm ---------------
; Small Life Energy
.healthSm:
	ld   a, [wPlHealthInc]	; Add 3 bars of health
	add  BAR_UNIT*3
	ld   [wPlHealthInc], a
	ret
	
; --------------- .etank ---------------
; E-Tank
.etank:
	; Cap E-Tanks to 4
	ld   a, [wETanks]
	cp   $04
	ret  nc
	
	; Add an E-Tank
	inc  a
	ld   [wETanks], a
	
	; Play whatever the E-Tank sound is supposed to be
	ld   a, SFX_ETANK
	mPlaySFX
	
; --------------- .noItem ---------------
; Placeholder entry.
.noItem:
	ret
	
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
		ld   a, SFX_TELEPORTIN	
		mPlaySFX
		
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
		ld   a, SFX_BAR
		mPlaySFX
		
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
	call Pause_ClrShots
	call Pause_StartHelperWarp
	
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
	
	ld   a, SFX_TELEPORTOUT
	mPlaySFX
	
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
	
; =============== Pause_WpnGfxPtrTbl ===============
; Maps each weapon to its graphics.
;
; Specifically, it maps the selected weapon (wWpnId/WPN_*) to the high byte of a pointer to a weapon art set.
; These sets of graphics are all in BANK $0B, are all $100 bytes long, and are all aligned to a $100 byte boundary,
; making their low byte always be $00.
;
; To save space, graphics for multiple weapons may be stored into the same art set.
Pause_WpnGfxPtrTbl:
	db HIGH(GFX_Player+$500) ; WPN_P ; [POI] This could point anywhere, it doesn't matter. It points to a completely blank area inside GFX_Player.
	db HIGH(GFX_Wpn_RcWdHa) ; WPN_RC
	db HIGH(GFX_Wpn_Rm) ; WPN_RM
	db HIGH(GFX_Wpn_Rj) ; WPN_RJ
	db HIGH(GFX_Wpn_Tp) ; WPN_TP
	db HIGH(GFX_Wpn_Ar) ; WPN_AR
	db HIGH(GFX_Wpn_RcWdHa) ; WPN_WD
	db HIGH(GFX_Wpn_MeNe) ; WPN_ME
	db HIGH(GFX_Wpn_Sg) ; WPN_CR
	db HIGH(GFX_Wpn_MeNe) ; WPN_NE
	db HIGH(GFX_Wpn_RcWdHa) ; WPN_HA
	db HIGH(GFX_Wpn_Ar) ; WPN_MG
	db HIGH(GFX_Wpn_Sg) ; WPN_SG (wWpnSGRide = $00)
	db HIGH(GFX_Wpn_SgRide) ; WPN_SG (wWpnSGRide = $01)


; =============== Pause_ClrShots ===============
; Clears all weapon shots and resets weapon-specific variables.
; Used when a different weapon is selected.
Pause_ClrShots:
	; Force the player out of the Rush Marine ride
	ld   a, [wPlMode]
	cp   PL_MODE_RM		; Riding Rush Marine?
	jr   nz, .clrWpn	; If not, skip
	xor  a				; Otherwise, reset state to idle
	ld   [wPlMode], a
	
.clrWpn:
	; Delete all 4 possible on-screen shots
	xor  a
	ld   [wShot0], a
	ld   [wShot1], a
	ld   [wShot2], a
	ld   [wShot3], a
	; Reset additional weapon-related globals
	ld   [wWpnNePos], a
	; Force out of Top Spin's spin state or the Sakugarne
	ld   [wWpnTpActive], a
	ld   [wWpnSGRide], a
	ret
	
; =============== Pause_StartHelperWarp ===============
; Makes the first found helper (Rush or Sakugarne) teleport out.
; Used when a different weapon is selected.
; OUT
; - C flag: If set, an item was found and set to be teleported out
Pause_StartHelperWarp:
	;
	; Only a single helper actor can be active at once.
	; Find the first one.
	;
	ld   hl, wAct		; Start from first actor slot
.loop:

	; Actor IDs between $E0-$E3 are reserved to the helpers.
	; If the actor ID for the slot is outside this range, seek to the next.
	ld   a, [hl]		; A = iActId
	cp   ACTF_PROC|ACT_WPN_RC		; A < ACT_WPN_RC?
	jr   c, .next		; If so, skip
	cp   ACTF_PROC|ACT_WPN_SG+1		; A >= ACT_E4?
	jr   nc, .next		; If so, skip
	
	; If the actor is already in the middle of teleporting out, there's nothing to do.
	ld   a, [wWpnHelperWarpRtn]
	cp   AHW_WARPOUT_INITANIM
	jr   z, .notFound
	cp   AHW_WARPOUT_ANIM
	jr   z, .notFound
	cp   AHW_WARPOUT_MOVEU
	jr   z, .notFound
	
.found:
	; Otherwise, we found an active helper.
	; Make it teleport out.
	
	inc  l				; Seek to iActRtnId
	xor  a
	ld   [hl], a		; iActRtnId = 0
	
	ld   a, AHW_WARPOUT_INITANIM
	ld   [wWpnHelperWarpRtn], a
	
	scf ; C Flag = set
	ret
	
.next:
	; Seek to next entry
	ld   a, l			; HL += $10
	add  iActEnd
	ld   l, a
	; If the low byte overflowed to $00, we reached the end of wAct.
	jr   nz, .loop		; Reached the end? If not, loop
	
.notFound:
	xor  a ; C Flag = clear
	ret
	
; =============== WpnS_SaveCurAmmo ===============
; Saves the current weapon's ammo back to the array.
WpnS_SaveCurAmmo:
	; Nothing to save if no weapon is selected
	ld   a, [wWpnId]
	or   a
	ret  z
	
	; Otherwise, wWpnAmmoTbl[wWpnId] = wWpnAmmoCur
	ld   hl, wWpnAmmoTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [wWpnAmmoCur]
	ld   [hl], a
	ret
	
; =============== WpnS_HasAmmoForShot ===============
; Checks if the player has enough ammo to fire the weapon.
; OUT
; - C Flag: If set, there's not enough ammo
WpnS_HasAmmoForShot:
	push bc
		ld   a, [wWpnShotCost]	; B = Ammo cost for a shot
		ld   b, a
		ld   a, [wWpnAmmoCur]	; A = Current ammo
		cp   b					; C Flag = CurAmmo < ShotCost?
	pop  bc
	ret
	
; =============== WpnS_UseAmmo ===============
; Uses up ammo for a weapon shot.
WpnS_UseAmmo:
	push hl
	push bc
		; Subtract the cost of a shot to the current ammo.
		; A = wWpnAmmoCur - wWpnShotCost
		ld   a, [wWpnShotCost]
		ld   b, a
		ld   a, [wWpnAmmoCur]
		sub  b
		; If we underflowed, we don't have enough ammo to fire a shot.
		jr   c, .end
		
		; Otherwise, save the updated ammo
		ld   [wWpnAmmoCur], a
		
		; And redraw the ammo bar
		ld   [wWpnAmmoBar], a		; Set bar redraw value
		ld   hl, wStatusBarRedraw	; Request redraw
		set  BARID_WPN, [hl]
.end:
	pop  bc
	pop  hl
	ret
	
; =============== Game_AddBarDrawEv ===============
; Appends an health/ammo bar redraw request to the buffer.
;
; Specifically, it generates two TilemapDef for redrawing the specified large gauge,
; one for each row, and writes them into the buffer from the previous location.
; This does *NOT* trigger the request, that has to be done manually.
;
; IN
; - A: Value (<= BAR_MAX)
; - C: Gauge ID (BARID_*), determines the position
Game_AddBarDrawEv:
	push af
	push bc
	push de
	push hl
		; Save the value to draw for later
		DEF tBarValue = wTmpCFE2
		ld   [tBarValue], a		
		
		; Seek DE to the pair of tilemap pointers, indexed by gauge ID.
		; DE = &Game_BarPosTbl[C * 2]
		ld   b, $00					; BC = C * 2
		sla  c						; 2 byte entries
		ld   hl, Game_BarPosTbl		
		add  hl, bc					; Seek to the entry
		ld   e, l					; Move ptr to DE
		ld   d, h
		
		; Seek HL to the current write buffer position.
		; HL = wTilemapBarBuf + wBarQueuePos
		ld   h, HIGH(wTilemapBarBuf)
		ld   a, [wBarQueuePos]
		ld   l, a
		
		; Write the top half of the gauge.
		; This uses tile IDs $65-$68 to represent 1 to 4 vertical bars respectively.
		; The base tile ID is relative to 0 through, so we pass in $64.
		ld   b, $64
		call Game_MkBarRowDrawEv
		
		; Write the bottom half.
		inc  de			; Use the next dest pointer
		ld   b, $68		; Tile IDs $69-$6C)
		call Game_MkBarRowDrawEv
		
		;
		; Write the event terminator, and set queue position at the current location.
		;
		; If another request is sent before the current one can be processed, it allows 
		; them to be concatenated to the previous ones, as the terminator will be overwritten.
		;
		xor  a					; Write terminator
		ld   [hl], a
		ld   a, l				; Save current pos
		ld   [wBarQueuePos], a
	pop  hl
	pop  de
	pop  bc
	pop  af
	ret
	
; =============== Game_MkBarRowDrawEv ===============
; Writes a tilemap event for drawing a single row of a large gauge.
; IN
; - DE: Ptr to destination tilemap ptr
; - A: Bar value
; - B: Base tile ID
Game_MkBarRowDrawEv:
	push de
	
		;
		; Write the TilemapDef header.
		;

		; bytes0-1: Destination pointer
		ld   a, HIGH(WINDOWMap_Begin) ; Hardcoded to draw on the WINDOW
		ldi  [hl], a
		ld   a, [de]		; Read low byte of pointer from table
		ldi  [hl], a
		
		; byte2: Writing mode + Number of bytes to write
		ld   a, $05			; Gauge width of 5 tiles, all unique
		ldi  [hl], a
		
		; byte3+: payload
		
		;
		; The main event.
		; Convert the numeric value we want to represent to the 5 tiles IDs.
		;
		; Each tile can represent 4 bars at most, with each bar representing 8 units of health/ammo.
		; With BAR_MAX being $98, that means at most $98/$08 = 19 bars will be drawn, which
		; fits into the limit of 5 tiles we have.
		;
		; As all gauges grow left to right, they are divided in three parts, in this order:
		; - Fully filled (uses tile B+4)
		; - Partially filled (may use any between B+1 - B+3)
		; - Empty (uses tile $73)
		;
		
		;
		; There's also a special case: 
		; If the bar value is set to anything over BAR_MAX, the gauge is wiped out with white tiles.
		; Handled by skipping directly to the third part with altered parameters.
		;
		ld   c, $05			; C = Tiles left. This will be decremented for any tile we draw at any point.
		ld   a, [tBarValue]
		cp   BAR_MAX+1		; tBarValue <= $98?
		jr   c, .calcBars	; If so, jump (draw normally)
		ld   a, $5D			; Otherwise, use the tile ID of a blank tile
		jr   .loopE			; and overwrite all 5 with it
		
	.calcBars:
		
		; As each bar represents 8 units, divide the value 8 before doing anything else.
		; A = CEIL(A/8)
		add  $07			; This is how the CEIL is accomplished.
							; It guarantees that anything in the remainder ("partial bars") shows up as one extra bar.
		srl  a				; >> 1 (/2)
		srl  a				; >> 1 (/4)
		srl  a				; >> 1 (/8)
		
	.stFill:
		;
		; FULLY FILLED TILES
		;
		; Now we're working with individual bars.
		; Each tile can represent 4 bars at most, so BarCount/4 will give the number of filled tiles.
		;
		push af ; Save bar count
			srl  a			; >> 1 (/2)
			srl  a			; >> 1 (/4)
			jr   z, .stPart ; Are there less than 4 bars left? If so, skip ahead
			
		.drawFill:
			ld   d, a		; D = Fill tiles left
			ld   a, b		; A = Fill tile ID
			add  $04		;     (+4 compared to the base)
		.loopF:
			ldi  [hl], a	; Write the tile
			dec  c			; TilesLeft--
			dec  d			; FillLeft--
			jr   nz, .loopF
			
	.stPart:
		;
		; PARTIALLY FILLED TILE
		;
		; Contains the remainder of the above, in a single tile.
		; If that is 0, we skip ahead as it's not supported here.
		;
		pop  af 			; Restore bar count
		and  $03			; Get remainder
		jr   z, .stEmpty	; Is it 0? If so, skip ahead
		add  b				; Otherwise, add the base tile ID
		ldi  [hl], a		; and draw the single partial tile
		dec  c				; TilesLeft--
		
	.stEmpty:
	
		;
		; EMPTY TILES
		;
		; Keep drawing black tiles until TilesLeft elapses.
		;
		ld   a, c
		or   a				; Is it already 0?
		jr   z, .end		; If so, we're done
		ld   a, $73			; A = Black tile ID
	.loopE:
		ldi  [hl], a		; Draw to tilemap
		dec  c				; Are we done?
		jr   nz, .loopE		; If not, loop
.end:
	pop  de
	ret
	
; =============== Game_BarPosTbl ===============
; Starting locations on the tilemap of the large gauges, as low bytes of the WINDOW pointers.
Game_BarPosTbl: 
	;  TOP  BOTTOM
	db LOW($9C07), LOW($9C27) ; BARID_PL
	db LOW($9C00), LOW($9C20) ; BARID_WPN
	db LOW($9C0F), LOW($9C2F) ; BARID_BOSS

; =============== Game_AddLivesDrawEv ===============
; Appends a redraw request for the lives indicator to the buffer.
; See also: Game_AddBarDrawEv
; IN
; - A: Number of lives (0-9)
Game_AddLivesDrawEv:
	push af
	push de
	push hl
	
		; Index Game_LivesFontMaps by the number of lives passed in.
		add  a						; 2 tiles in a 8x16 digit
		ld   d, $00
		ld   e, a
		ld   hl, Game_LivesFontMaps
		add  hl, de					; Game_LivesFontMaps[A*2]
		ld   e, l					; DE will point to the entry
		ld   d, h
		
		; Write from the previous buffer location
		ld   h, HIGH(wTilemapBarBuf)
		ld   a, [wBarQueuePos]
		ld   l, a
		
		; bytes0-1: Destination pointer.
		ld   a, HIGH($9C0E)
		ldi  [hl], a
		ld   a, LOW($9C0E)
		ldi  [hl], a
		
		; byte2: Writing mode + Number of bytes to write
		ld   a, BG_MVDOWN|$02		; 2 tiles, drawn vertically
		ldi  [hl], a
		
		; Read out the two tile IDs from the table entry
		ld   a, [de]				; byte0
		ldi  [hl], a
		inc  de
		ld   a, [de]				; byte1
		ldi  [hl], a
		
		; Write end terminator
		xor  a
		ld   [hl], a
		
		; Update buffer write location
		ld   a, l
		ld   [wBarQueuePos], a
	pop  hl
	pop  de
	pop  af
	ret
	
; =============== Game_LivesFontMaps ===============
; Tile IDs used by each 8x16 digit.
Game_LivesFontMaps:
	;  TOP  BOTTOM
	db $5A, $5C ; 0
	db $51, $52 ; 1
	db $53, $54 ; 2
	db $53, $55 ; 3
	db $56, $57 ; 4
	db $58, $55 ; 5
	db $58, $59 ; 6
	db $5A, $52 ; 7
	db $5B, $59 ; 8
	db $5B, $55 ; 9
	
; =============== Pause_AddBarDrawEv ===============
; Appends a *small* health/ammo bar draw request to the buffer.
; Used on the pause menu exclusively to render the gauges.
; See also: Game_AddBarDrawEv
; IN
; - A: Bar value
; - C: Weapon selection ID (WPN_*)
; - DE: Tilemap destination ptr
Pause_AddBarDrawEv:
	;
	; These gauges are handled similarly to the large ones, and most of the draw code is very similar too.
	; They have the following differences though:
	; - These gauges are 1-tile tall.
	;   With no repeated draw being necessary, the equivalent to Game_MkBarRowDrawEv is directly inlined.
	; - The weapon name (2 tiles) is displayed to the left of the bar.
	; - There's no blanking feature when drawing values > BAR_MAX. 
	;   Attempting to do so will instead cap it back.
	;
	push bc
	push hl
		push af
			
			;
			; Build the TilemapDef starting from the weapon's name.
			; The table containing this data, indexed by WPN_*, also contains the tilemap pointer.
			; After drawing the tilemap name (2 bytes), the bar will be immediately drawn to the right.
			;
		
			; bytes0-1: Destination pointer
			ld   b, $00				; BC = C * 4
			sla  c					
			sla  c
			ld   hl, Pause_BarTbl	; HL = Table base
			add  hl, bc				; Seek to entry (starts with vram pointer)
			call CopyWord			; Write the word value, seek pointers ahead
			
			; byte2: Writing mode + Number of bytes to write
			ld   a, $07				; Gauge width of 5 tiles + 2 for the weapon name
			ld   [de], a
			inc  de
			
			; byte3+: payload
			call CopyWord			; Copy weapon name, seek pointers ahead
			
			;
			; We're now pointing two tiles to the right from the origin point.
			; Set up the tilemap event to draw the small gauge at the current location.
			;
			
			ld   c, $05			; C = Tiles left
			
		; [POI] Unreachable failsafe, cap the value to BAR_MAX
		pop  af					; A = Bar value
		cp   BAR_MAX+1			; tBarValue <= $98?
		jr   c, .calcBars		; If so, jump
		ld   a, $98				; Otherwise, cap

	.calcBars:
		; The same code as Game_MkBarRowDrawEv, but with hardcoded tile ID ranges
		
		; Each bar represents 8 units
		; A = CEIL(A/8)
		add  $07			; CEIL
		srl  a				; >> 1 (/2)
		srl  a				; >> 1 (/4)
		srl  a				; >> 1 (/8)
	
	.stFill:
		; Filled: Draw BarCount/4 filled tiles 
		push af ; Save bar count
			srl  a			; >> 1 (/2)
			srl  a			; >> 1 (/4)
			jr   z, .stPart	; Are there less than 4 bars left? If so, skip ahead
			
		.drawFill:
			ld   b, a		; D = Fill tiles left
			ld   a, $84		; A = Fill tile ID
		.loopF:
			ld   [de], a	; Write the tile
			inc  de
			dec  c			; TilesLeft--
			dec  b			; FillLeft--
			jr   nz, .loopF
			
	.stPart:
		; Partially Filled: Remainder of the above
		pop  af 			; Restore bar count
		and  $03			; Get remainder
		jr   z, .stEmpty	; Is it 0? If so, skip ahead
		add  $80			; Otherwise, add the base tile ID
		ld   [de], a		; and draw the single partial tile
		inc  de
		dec  c				; TilesLeft--
		
	.stEmpty:
		; Empty: Keep drawing until TilesLeft elapses
		ld   a, c
		or   a				; Is it already 0?
		jr   z, .end		; If so, we're done
		ld   a, $80			; A = Black bar tile ID
	.loopE:
		ld   [de], a		; Draw to tilemap
		inc  de
		dec  c				; Are we done?
		jr   nz, .loopE		; If not, loop
	.end:
		xor  a				; Write the end terminator
		ld   [de], a
	pop  hl
	pop  bc
	ret
	
; =============== Pause_BarTbl ===============
; Defines the location and name for each entry in the pause screen, indexed by weapon ID / current selection.
; The tilemap pointer refers to where the name gets written, while the gauge is drawn two tiles to the right.
MACRO mPBarDef
	db HIGH(\1),LOW(\1) ; Tilemap pointer (reverse order)
	db \2 ; Weapon name
ENDM
Pause_BarTbl:
	SETCHARMAP pause
	mPBarDef $9C62, "P " ; WPN_P 
.wpn:
	mPBarDef $9C6B, "RC" ; WPN_RC
	mPBarDef $9CA2, "RM" ; WPN_RM
	mPBarDef $9CAB, "RJ" ; WPN_RJ
	mPBarDef $9CE2, "TP" ; WPN_TP
	mPBarDef $9CEB, "AR" ; WPN_AR
	mPBarDef $9D22, "WD" ; WPN_WD
	mPBarDef $9D2B, "ME" ; WPN_ME
	mPBarDef $9D62, "CL" ; WPN_CR
	mPBarDef $9D6B, "NE" ; WPN_NE
	mPBarDef $9DA2, "HA" ; WPN_HA
	mPBarDef $9DAB, "MG" ; WPN_MG
	mPBarDef $9DE2, "SG" ; WPN_SG
.en:
	mPBarDef $9DEB, "EN" ; WPN_EN
	
; =============== Pause_FlashWpnName ===============
; Flashes the selected weapon's name every 8 frames.
; This also polls for input.
Pause_FlashWpnName:
	; Every 8 frames...
	ldh  a, [hTimer]
	and  $07
	jr   nz, .noChange
	
	;
	; Build the TilemapDef for the weapon name only.
	; The table containing this data, indexed by WPN_*, also contains the tilemap pointer.
	; After drawing the tilemap name (2 bytes), the bar will be immediately drawn to the right.
	;
	
	; bytes0-1: Destination pointer
	ld   a, [wWpnId]		; A = wWpnId * 4
	add  a
	add  a
	ld   hl, Pause_BarTbl	; HL = Table base
	ld   b, $00				
	ld   c, a
	add  hl, bc				; Seek to entry (starts with vram pointer)
	ld   de, wTilemapBuf	; DE = Event data buffer
	call CopyWord			; Write the word value, seek pointers ahead
	
	; byte2: Writing mode + Number of bytes to write
	ld   a, $02				; 2 tiles for the weapon name
	ld   [de], a
	inc  de
	
	; byte3+: payload
	
	; Alternate between the actual weapon name and two blank tiles every other 8 frames
	ldh  a, [hTimer]
	and  $08				; hTimer % 8 != 0?
	jr   nz, .wpnName		; If so, jump
.blankName:
	ld   a, $70				; A = Blank tile
	ld   [de], a			; Set it as first char
	inc  de					; EvPtr++
	jr   .setChar2			; Set it as second char
.wpnName:
	ldi  a, [hl]			; Read first char
	ld   [de], a			; Write it over
	inc  de					; EvPtr++
	ldi  a, [hl]			; Read second char
.setChar2:
	ld   [de], a			; Write it over
	inc  de					; EvPtr++
	xor  a					; Write terminator
	ld   [de], a
	
	rst  $10 ; Wait tilemap load
	jp   JoyKeys_Refresh
	
.noChange:
	rst  $08 ; Wait Frame
	jp   JoyKeys_Refresh
	
; =============== CopyWord ===============
; Copies two bytes from the source to the destination,
; advancing both appropriately.
; IN
; - HL: Ptr to source
; - DE: Ptr to destination
CopyWord:
REPT 2
	ldi  a, [hl]	; Read src, Src++
	ld   [de], a	; Write to dest
	inc  de			; Dest++
ENDR
	ret
	
; =============== Pause_CanMoveSel ===============
; Checks if the cursor can move to the specified location.
; In practice, it mostly checks if the weapons are unlocked.
; IN
; - A: Current weapon / Cursor selection (WPN_*)
; OUT
; - C flag: If set, the cursor can move.
;           (ie: the weapon is unlocked)
Pause_CanMoveSel:
	; The basic player weapon is always selectable
	or   a ; WPN_P	; Selecting the default weapon?
	jr   nz, .chkTank	; If not, skip
	scf  				; Otherwise, C Flag = Set
	ret
.chkTank:
	; And so are E-Tanks
	cp   WPN_EN
	jr   nz, .chkWpns
	scf  
	ret
.chkWpns:
	; The rest is all unlockable weapons/items.
	; This opts to do checks by shifting the relevant bit to the carry, and it assumes
	; that cursor poin a way that can't be represented by the WPUB_* constants,
	push bc
		ld   c, a ; Save cursor pos
			; Sakugarne requires bit3 of wWpnUnlock1
			; This is just a manual check, as it's the exception to the convention (see .chkItems)
			cp   WPN_SG			; Selecting Sakugarne?
			jr   nz, .chkItems		; If not, skip
			ld   a, [wWpnUnlock1]	; Get unlock bits
			swap a					; << 4
			rla  					; << 1 (bit3 shifted)
			jr   .end
		.chkItems:
			; The first four selections are for the items, stored in wWpnUnlock1 (alongside WPN_P, which was checked before).
			; This and .chkNormWpn need WPN_* and WPUB_* to be consistent, due to how the selection number doubles
			; as how many times to shift bits right.
			cp   WPN_TP				; wWpnId >= WPN_TP
			jr   nc, .chkNormWpn	; If so, skip 
			ld   b, a				; Res = wWpnUnlock1 >> A
			ld   a, [wWpnUnlock1]
			jr   .loopBit
		.chkNormWpn:
			; Normal boss weapon, stored in wWpnUnlock0.
			; Offset by -1 since one extra shift is needed to shift into the carry.
			; (.chkItems didn't need to as WPN_P being $00 already provided that extra shift)
			sub  WPN_TP-1		; Res = wWpnUnlock0 >> A - 3
			ld   b, a
			ld   a, [wWpnUnlock0]
		.loopBit:
			rra  					; A >>= 1
			dec  b					; Done shifting?
			jr   nz, .loopBit		; If not, loop
	.end:
		ld   a, c ; Restore cursor pos
	pop  bc
	ret
	
MACRO mGfxDef2
	db BANK(\1), HIGH(\1)
ENDM
; =============== ActS_GFXSetTbl ===============
; Sets of actor graphics usable during levels.
; These each set has a fixed size of $800 bytes.
ActS_GFXSetTbl:
	mGfxDef2 GFX_Player       ; $00 ; ACTGFX_PLAYER    ; 
	mGfxDef2 GFX_Wpn_RcWdHa   ; $01 ; ACTGFX_SPACE1    ; [POI] Only loaded manually by LoadGFX_Space, not through here.
	mGfxDef2 GFX_ActLvlHard   ; $02 ; ACTGFX_LVLHARD   ; 
	mGfxDef2 GFX_Bikky        ; $03 ; ACTGFX_BIKKY     ; 
	mGfxDef2 GFX_ActLvlTop    ; $04 ; ACTGFX_LVLTOP    ; 
	mGfxDef2 GFX_ActLvlMagnet ; $05 ; ACTGFX_LVLMAGNET ; 
	mGfxDef2 GFX_MagnetMan    ; $06 ; ACTGFX_MAGNETMAN ; 
	mGfxDef2 GFX_ActLvlNeedle ; $07 ; ACTGFX_LVLNEEDLE ; 
	mGfxDef2 GFX_NeedleMan    ; $08 ; ACTGFX_NEEDLEMAN ; 
	mGfxDef2 GFX_ActLvlCrash  ; $09 ; ACTGFX_LVLCRASH  ; 
	mGfxDef2 GFX_CrashMan     ; $0A ; ACTGFX_CRASHMAN  ; 
	mGfxDef2 GFX_ActLvlMetal  ; $0B ; ACTGFX_LVLMETAL  ; 
	mGfxDef2 GFX_MetalMan     ; $0C ; ACTGFX_METALMAN  ; 
	mGfxDef2 GFX_ActLvlWood   ; $0D ; ACTGFX_LVLWOOD   ; 
	mGfxDef2 GFX_WoodMan      ; $0E ; ACTGFX_WOODMAN   ; 
	mGfxDef2 GFX_ActLvlAir    ; $0F ; ACTGFX_LVLAIR    ; 
	mGfxDef2 GFX_AirMan       ; $10 ; ACTGFX_AIRMAN    ; 
	mGfxDef2 GFX_Wily         ; $11 ; ACTGFX_WILY0     ;
	mGfxDef2 GFX_Wily         ; $12 ; ACTGFX_WILY1     ; [POI] Clone of the above 
	mGfxDef2 GFX_Quint        ; $13 ; ACTGFX_QUINT     ; 
	mGfxDef2 GFX_HardMan      ; $14 ; ACTGFX_HARDMAN   ; 
	mGfxDef2 GFX_TopMan       ; $15 ; ACTGFX_TOPMAN    ;
	
; =============== Lvl_GFXSetTbl ===============
; Maps each stage to their graphics.
; These have a fixed size of $500 bytes, as the remaining $300 are taken up by GFX_BgShared.
Lvl_GFXSetTbl:
	mGfxDef2 GFX_LvlHard    ; $00 ; LVL_HARD
	mGfxDef2 GFX_LvlTop     ; $01 ; LVL_TOP
	mGfxDef2 GFX_LvlMagnet  ; $02 ; LVL_MAGNET
	mGfxDef2 GFX_LvlNeedle  ; $03 ; LVL_NEEDLE
	mGfxDef2 GFX_LvlCrash   ; $04 ; LVL_CRASH
	mGfxDef2 GFX_LvlMetal   ; $05 ; LVL_METAL
	mGfxDef2 GFX_LvlWood    ; $06 ; LVL_WOOD
	mGfxDef2 GFX_LvlAir     ; $07 ; LVL_AIR
	mGfxDef2 GFX_LvlCastle  ; $08 ; LVL_CASTLE
	mGfxDef2 GFX_LvlStation ; $09 ; LVL_STATION

; =============== StageSel_BossGfxTbl ===============
; Maps each stage to its boss graphics (entries to ActS_GFXSetTbl)
; [TCRF] This explicitly accounts for the second set of bosses being selected.
StageSel_BossGfxTbl:
	db ACTGFX_HARDMAN   ; LVL_HARD  
	db ACTGFX_TOPMAN    ; LVL_TOP   
	db ACTGFX_MAGNETMAN ; LVL_MAGNET
	db ACTGFX_NEEDLEMAN ; LVL_NEEDLE
	db ACTGFX_CRASHMAN  ; LVL_CRASH 
	db ACTGFX_METALMAN  ; LVL_METAL 
	db ACTGFX_WOODMAN   ; LVL_WOOD  
	db ACTGFX_AIRMAN    ; LVL_AIR   

; =============== Lvl_ClearBitTbl ===============
; Maps each stage to its own completion bit in wWpnUnlock0.
Lvl_ClearBitTbl: 
	db WPU_HA ; LVL_HARD
	db WPU_TP ; LVL_TOP
	db WPU_MG ; LVL_MAGNET
	db WPU_NE ; LVL_NEEDLE
	db WPU_CR ; LVL_CRASH
	db WPU_ME ; LVL_METAL
	db WPU_WD ; LVL_WOOD
	db WPU_AR ; LVL_AIR
	db $00    ; LVL_CASTLE (unselectable)
	db $00    ; LVL_STATION (unselectable)

; =============== Lvl_PalTbl ===============
; Palettes associated to each stage, see Lvl_InitSettings.
; Every stage has a 2-frame animated palette, most use the same one
; and repeat the same colors twice, disabling the animation.
Lvl_PalTbl:
	db $E4,$E4 ; LVL_HARD
	db $E4,$E4 ; LVL_TOP
	db $E4,$E4 ; LVL_MAGNET
	db $E4,$E4 ; LVL_NEEDLE
	db $E4,$E4 ; LVL_CRASH
	db $E0,$EC ; LVL_METAL
	db $E4,$E4 ; LVL_WOOD
	db $E1,$E1 ; LVL_AIR
	db $E4,$E4 ; LVL_CASTLE
	db $E4,$E4 ; LVL_STATION

; =============== Lvl_BGMTbl ===============
; Assigns music tracks to each level.
Lvl_BGMTbl:
	db BGM_HARDMAN    ; LVL_HARD   
	db BGM_TOPMAN     ; LVL_TOP    
	db BGM_MAGNETMAN  ; LVL_MAGNET 
	db BGM_NEEDLEMAN  ; LVL_NEEDLE 
	db BGM_CRASHMAN   ; LVL_CRASH  
	db BGM_METALMAN   ; LVL_METAL  
	db BGM_WOODMAN    ; LVL_WOOD   
	db BGM_AIRMAN     ; LVL_AIR    
	db BGM_WILYCASTLE ; LVL_CASTLE 
	db BGM_TITLE      ; LVL_STATION
	
; =============== Lvl_BGMTbl ===============
; Assigns checkpoints to each level, as room IDs.
; Each level has a fixed number of four checkpoints, which MUST be sequential.
; To have less checkpoints, entries are either duplicated or marked with $20, which is higher than the last reachable room ID.
Lvl_CheckpointTbl:
	db $01,$0B,$11,$15 ; LVL_HARD
	db $01,$0A,$10,$16 ; LVL_TOP
	db $01,$07,$0E,$16 ; LVL_MAGNET
	db $01,$06,$11,$17 ; LVL_NEEDLE
	db $01,$08,$0E,$17 ; LVL_CRASH
	db $01,$07,$12,$17 ; LVL_METAL
	db $01,$09,$10,$15 ; LVL_WOOD
	db $01,$09,$09,$16 ; LVL_AIR
	db $04,$20,$20,$20 ; LVL_CASTLE
	db $01,$0A,$0A,$16 ; LVL_STATION

; =============== Lvl_WaterFlagTbl ===============
; Marks which levels have water.
Lvl_WaterFlagTbl:
	db $00 ; LVL_HARD
	db $01 ; LVL_TOP
	db $00 ; LVL_MAGNET
	db $00 ; LVL_NEEDLE
	db $00 ; LVL_CRASH
	db $00 ; LVL_METAL
	db $01 ; LVL_WOOD
	db $00 ; LVL_AIR
	db $00 ; LVL_CASTLE
	db $01 ; LVL_STATION

; =============== ScrEv_BGStripTbl ===============
; Pointers to 2-row tall tilemap strips.
ScrEv_BGStripTbl:
	dw $9800 ; $00
	dw $9840 ; $01
	dw $9880 ; $02
	dw $98C0 ; $03
	dw $9900 ; $04
	dw $9940 ; $05
	dw $9980 ; $06
	dw $99C0 ; $07
	dw $9A00 ; $08
	dw $9A40 ; $09
	dw $9A80 ; $0A
	dw $9AC0 ; $0B
	dw $9B00 ; $0C
	dw $9B40 ; $0D
	dw $9B80 ; $0E
	dw $9BC0 ; $0F
	mIncJunk "L003C94"