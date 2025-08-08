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
	; With one exception, hRomBankLast will always contain that value, so when
	; subroutines restore the last ROM bank loaded, they assume it will point there.
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
	; Code at L000D5A already moved us 2 tiles to the right, but it did *not* move us
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
		; [POI] (are there other uses) ??? This is intended to set the X position of the status bar,
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
.set3: db $E4, $1C, $C4, $00 ; GFXSET_LEVEL (Gets overwritten by Lvl_InitSettings)
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
	
; The graphics being loaded are sometimes cropped from larger graphic sets.
; For example, GFX_TitleCursor is directly inside GFX_StageSel,
; while GFX_StageSel itself loads less tiles in the password screen code.
	
; =============== LoadGFX_Title ===============
LoadGFX_Title:
	push af
		ld   a, BANK(GFX_TitleCursor) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; !!! PARTIAL
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
		ld   a, BANK(GFX_StageSel) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; GFX_StageSel contains both the BG and OBJ graphics, so it needs to be loaded twice.

	ld   hl, GFX_StageSel
	ld   de, $8000			; For OBJ
	ld   bc, $0800
	call CopyMemory
	
	ld   hl, GFX_StageSel
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
		ld   a, BANK(GFX_StageSel) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; !!! PARTIAL (crops out boss pics)
	ld   hl, GFX_StageSel
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
	ld   a, BANK(GFX_LvlShared) ; BANK $0A
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, GFX_LvlShared
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
		ld   a, BANK(GFX_Space0OBJ) ; BANK $0C
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_Space0OBJ
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
		ld   a, BANK(GFX_GameOverFont) ; BANK $0B
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_GameOverFont
	ld   de, $8400
	ld   bc, $0200
	call CopyMemory
	
	ld   hl, GFX_GameOverFont
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
		ld   a, BANK(GFX_Space1OBJ) ; BANK $0B
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_Space1OBJ
	ld   de, $8800
	ld   bc, $0800
	call CopyMemory
	
	push af
		ld   a, BANK(GFX_Space0OBJ) ; BANK $0C
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_Space0OBJ
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
; Applies one or more tilemaps definitions (TilemapDef) to VRAM. 
;
; TODO!!! This is also used to load a tiny amount of graphics occasionally.
;         Depending on how often it gets done, this might need to get renamed.
;
; IN
; - DE: Ptr to one or more TilemapDef stored in sequence, terminated by a null byte.
LoadTilemapDef:
	
	; A null byte marks the end of the TilemapDef list
	ld   a, [de]
	or   a
	ret  z
	
	; bytes0-1: Destination pointer
	ld   h, a
	inc  de
	ld   a, [de]
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
L00079C: db $F5;X
L00079D: db $E5;X
L00079E: db $C5;X
L00079F: db $21;X
L0007A0: db $00;X
L0007A1: db $00;X
L0007A2: db $4A;X
L0007A3: db $16;X
L0007A4: db $00;X
L0007A5: db $79;X
L0007A6: db $B7;X
L0007A7: db $28;X
L0007A8: db $04;X
L0007A9: db $19;X
L0007AA: db $0D;X
L0007AB: db $18;X
L0007AC: db $F8;X
L0007AD: db $5D;X
L0007AE: db $54;X
L0007AF: db $C1;X
L0007B0: db $E1;X
L0007B1: db $F1;X
L0007B2: db $C9;X
L0007B3: db $E5;X
L0007B4: db $C5;X
L0007B5: db $21;X
L0007B6: db $00;X
L0007B7: db $00;X
L0007B8: db $4F;X
L0007B9: db $79;X
L0007BA: db $B7;X
L0007BB: db $28;X
L0007BC: db $04;X
L0007BD: db $19;X
L0007BE: db $0D;X
L0007BF: db $18;X
L0007C0: db $F8;X
L0007C1: db $5D;X
L0007C2: db $54;X
L0007C3: db $C1;X
L0007C4: db $E1;X
L0007C5: db $C9;X

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
	;   - Room transitions simply work by warping the player to another point of the same level.
	; - Actor layout ($200 bytes)
	;   Split into two $100 tables, all indexed by column number.
	;   The first contains the Y position & nospawn flag of the actor, while the second one
	;   has a mix of Actor IDs and GFX set IDs.
	;   A few notes:
	;   - The X position isn't stored anywhere here.
	;     Instead, the index to the actor layout represents the column number.
	;     This means there can be at most one actor/column.
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
	; The RLE format takes advantage of how the data never has the MSB set, allowing for some shortcuts.
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
	ld   [wActCurSprFlags], a
	
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
	;    ??? This MUST point to the leftmost column currently visible (*not* the tilemap)
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
	
L00094C:;C
	ldh  a, [hScrollX]
	sub  $20
	swap a
	and  $0F
	ldh  [hScrEvOffH], a
	ld   a, [wLvlColL]
	sub  $02
	ldh  [hScrEvLvlLayoutPtr_Low], a
	ldh  a, [hScrollY]
	swap a
	and  $0F
	ldh  [hScrEvOffV], a
	ld   a, $C0
	ldh  [hScrEvLvlLayoutPtr_High], a
	ld   a, $01
	ld   [wLvlScrollEvMode], a
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	ld   l, a
	ld   b, $E8
	call ActS_SpawnColEdge4
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	add  $0E
	ld   l, a
	ld   b, $B8
	jp   ActS_SpawnColEdge5
L000980:;J
	ldh  a, [hScrollX]
	add  $B0
	swap a
	and  $0F
	ldh  [hScrEvOffH], a
	ld   a, [wLvlColL]
	add  $0B
	ldh  [hScrEvLvlLayoutPtr_Low], a
	ldh  a, [hScrollY]
	swap a
	and  $0F
	ldh  [hScrEvOffV], a
	ld   a, $C0
	ldh  [hScrEvLvlLayoutPtr_High], a
	ld   a, $01
	ld   [wLvlScrollEvMode], a
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	ld   l, a
	ld   b, $B8
	call ActS_SpawnColEdge4
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	sub  $0E
	ld   l, a
	ld   b, $E8
	jp   ActS_SpawnColEdge5
	
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
	inc  d		; Seek down to next vertical offset
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
	
; =============== Game_Unk_StartRoomTrs ===============
; This subroutine handles the initial setup for vertical screen transitions.
Game_Unk_StartRoomTrs:

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
	
	; ???
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
	
	; Reset vertical transition counter, in preparation of calling Game_Unk_DoRoomTrs
	xor  a
	ldh  [hTrsRowsProc], a
	
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

	; The target position is 8px to the left of the player, because ??? (origin quirk likely)
	ld   a, [wPlRelX]			; B = wPl_Unk_Alt_X = wPlRelX - $08
	sub  $08
	ld   [wPl_Unk_Alt_X], a
	
	; Determine how many columns are there to the left of the player
	swap a						; B /= $10
	and  $0F
	ld   b, a
	
	;
	; Add that to the absolute column number of the leftmost column
	;
	ld   a, [wLvlColL]			; wLvl_Unk_CurCol = wLvlColL + B
	add  b
	ld   [wLvl_Unk_CurCol], a
	ret
	
; =============== Game_Unk_DoRoomTrs ===============
; This subroutine handles the loop code for vertical screen transitions.
; OUT
; - Z: If set, the transition is finished.
Game_Unk_DoRoomTrs:
	
	;
	; Set up tile ID data for the level scrolling event (ScrEv_LvlScrollV).
	;
	; During the transition 8 of them will trigger, each redrawing a single row (2 tiles tall).
	; That's enough to redraw the entire height of the gameplay screen, and it's also small enough
	; that we can get away with firing the events as soon as possible, without worrying about
	; writing over part of the visible screen.
	;
	
	ldh  a, [hTrsRowsProc]
	cp   SCREEN_GAME_BLOCKCOUNT_V		; Have we written all 8 strips?
	jr   nc, .scroll				; If so, we're done with tilemap updates, just scroll the viewport
	ld   a, [wLvlScrollEvMode]
	or   a							; Are we in the middle of the previously set screen event?
	jr   nz, .scroll				; If so, don't interrupt it
	
	;
	; Save to hScrEvVDestPtr_* where to start writing tiles.
	;
	; [POI] There's an oversight in here, the code should have checked if we were scrolling up, and if so,
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
; Works alongside Game_Unk_DoRoomTrs, which feeds its data.
ScrEv_LvlScrollV:

	; This event lasts three frames.
	; Until it is finished, Game_Unk_DoRoomTrs isn't allowed to send any more data.
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
	; Doing this isn't immediately necessary for the next frame, but it must be done for Game_Unk_DoRoomTrs
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

	; Transfer done, let Game_Unk_DoRoomTrs send more data, if any
	xor  a
	ld   [wLvlScrollEvMode], a
	ret
	
Lvl_RoomColOffsetTbl: db $00
L000B79: db $00
L000B7A: db $19
L000B7B: db $00
L000B7C: db $32
L000B7D: db $00
L000B7E: db $4B
L000B7F: db $00
L000B80: db $64
L000B81: db $00
L000B82: db $7D
L000B83: db $00
L000B84: db $96
L000B85: db $00
L000B86: db $AF
L000B87: db $00
L000B88: db $C8
L000B89: db $00
L000B8A: db $E1
L000B8B: db $00
L000B8C: db $FA;X
L000B8D: db $00;X
L000B8E: db $13;X
L000B8F: db $01;X
L000B90: db $2C;X
L000B91: db $01;X
L000B92: db $45;X
L000B93: db $01;X
L000B94: db $5E;X
L000B95: db $01;X
L000B96: db $77;X
L000B97: db $01;X

; =============== Lvl_RoomColTbl ===============
; Maps each Room ID to an initial wLvlColL value.
; [POI] The last two values happen to not be used, and the first room is never used.
Lvl_RoomColTbl:
	DEF I = 0
	REPT LVL_ROOMCOUNT + 1
		db ROOM_COLCOUNT * I
		DEF I = I + 1
	ENDR

TilemapDef_StatusBar: db $9C
L000BB3: db $00
L000BB4: db $14
L000BB5: db $5D
L000BB6: db $5D
L000BB7: db $5D
L000BB8: db $5D
L000BB9: db $5D
L000BBA: db $5E
L000BBB: db $5F
L000BBC: db $68
L000BBD: db $68
L000BBE: db $68
L000BBF: db $68
L000BC0: db $68
L000BC1: db $6D
L000BC2: db $6F
L000BC3: db $53
L000BC4: db $5D
L000BC5: db $5D
L000BC6: db $5D
L000BC7: db $5D
L000BC8: db $5D
L000BC9: db $9C
L000BCA: db $20
L000BCB: db $14
L000BCC: db $5D
L000BCD: db $5D
L000BCE: db $5D
L000BCF: db $5D
L000BD0: db $5D
L000BD1: db $60
L000BD2: db $61
L000BD3: db $6C
L000BD4: db $6C
L000BD5: db $6C
L000BD6: db $6C
L000BD7: db $6C
L000BD8: db $6E
L000BD9: db $50
L000BDA: db $54
L000BDB: db $5D
L000BDC: db $5D
L000BDD: db $5D
L000BDE: db $5D
L000BDF: db $5D
L000BE0: db $9C
L000BE1: db $40
L000BE2: db $CF
L000BE3: db $5D
L000BE4: db $9C
L000BE5: db $53
L000BE6: db $CF
L000BE7: db $5D
L000BE8: db $9E
L000BE9: db $20
L000BEA: db $54
L000BEB: db $5D
L000BEC: db $00

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
	ld   a, PL_MODE_WARPIN
	ld   [wPlMode], a
	
	; ???
	ld   a, $FF
	ld   [wCF5D_Unk_ActTargetSlot], a
	ld   [wCF4A_Unk_ActTargetSlot], a
	ld   [wCF6A_Unk_ActTargetSlot], a
	ld   [wCF6B_Unk_ActCurSlotPtrCopy], a
	
	; Initialize a bunch of variables, mostly to clean up from last time
	xor  a
	ldh  [hScrollXNybLow], a
	ld   [wLvlEnd], a
	ld   [wPlSlideDustTimer], a
	ld   [wPlSpdXSub], a
	ld   [wPlSpdX], a
	ld   [wPlHurtTimer], a
	ld   [wPlInvulnTimer], a
	ld   [wNoScroll], a
	ld   [wBossDmgEna], a
	ld   [wBossIntroHealth], a
	ld   [wShutterMode], a
	ld   [wWpnSel], a 			; Start with the buster always
	ld   [wWpnItemWarp], a
	ld   [wWpnSGUseTimer], a
	ld   [wUnk_Unused_CF5F], a
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
	bit  WPNB_CR, a		; Crash Bomb unlocked?
	jr   z, .chkRM		; If not, skip
	set  WPNB_RC, [hl]	; Otherwise, enable Rush Coil
.chkRM:
	; Defeating Metal Man unlocks Rush Marine
	bit  WPNB_ME, a
	jr   z, .chkRJ
	set  WPNB_RM, [hl]
.chkRJ:
	; Defeating Air Man unlocks Rush Jet
	bit  WPNB_AR, a
	jr   z, .setPlPos
	set  WPNB_RJ, [hl]
	; NOTE: The Sakugarne unlock is set later on, at ???
	
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
	
L000CB0:;C
	xor  a
	ld   [wActScrollX], a
	ld   [wPlColiBlockL], a
	ld   [$CF3C], a
	ld   a, [wShutterMode]
	or   a
	jp   z, L000DEC
	dec  a
	rst  $00 ; DynJump
L000CC3: db $CD
L000CC4: db $0C
L000CC5: db $1A
L000CC6: db $0D
L000CC7: db $4E
L000CC8: db $0D
L000CC9: db $81
L000CCA: db $0D
L000CCB: db $BE
L000CCC: db $0D
L000CCD:;I
	ld   a, [wNoScroll]
	or   a
	call nz, ActS_ReqLoadRoomGFX
	ld   a, [wPlRelY]
	sub  $10
	ld   b, a
	ldh  a, [hScrollY]
	add  b
	swap a
	and  $0F
	ld   d, a
	ld   a, [wPlRelX]
	sub  $08
	ld   b, a
	ldh  a, [hScrollX]
	add  b
	swap a
	and  $0F
	ld   e, a
	ld   hl, $3C74
	ld   a, d
	sla  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	add  $20
	ld   c, a
	ld   a, [hl]
	ld   [wShutterBGPtr_High], a
	ld   a, e
	sla  a
	add  c
	ld   [wShutterBGPtr_Low], a
	ld   a, $06
	ld   [wShutterTimer], a
	ld   a, $06
	ld   [wShutterRowsLeft], a
	ld   hl, wShutterMode
	inc  [hl]
	jp   L000E4C
L000D1A:;I
	ld   a, [wShutterTimer]
	or   a
	jr   z, L000D27
	dec  a
	ld   [wShutterTimer], a
	jp   L000E4C
L000D27:;R
	ld   a, [wShutterRowsLeft]
	or   a
	jr   z, L000D42
	dec  a
	ld   [wShutterRowsLeft], a
	ld   a, $06
	ld   [wShutterTimer], a
	ld   a, $01
	ld   [wShutterEvMode], a
	ld   a, $0A
	ldh  [hSFXSet], a
	jp   L000E4C
L000D42:;R
	ld   a, $28
	ld   [wShutterTimer], a
	ld   hl, wShutterMode
	inc  [hl]
	jp   L000E4C
L000D4E:;I
	ld   hl, wShutterTimer
	dec  [hl]
	jr   z, L000D5A
	call L000DD7
	jp   L001AAF
L000D5A:;R
	ld   a, [wShutterBGPtr_Low]
	and  $E0
	ld   b, a
	ld   a, [wShutterBGPtr_Low]
	add  $02
	and  $1F
	or   b
	ld   [wShutterBGPtr_Low], a
	ld   a, $06
	ld   [wShutterTimer], a
	ld   a, $06
	ld   [wShutterRowsLeft], a
	ld   hl, wShutterMode
	inc  [hl]
	ld   a, $04
	ld   [wPlSprMapId], a
	jp   L000E4C
L000D81:;I
	ld   a, [wShutterTimer]
	or   a
	jr   z, L000D8E
	dec  a
	ld   [wShutterTimer], a
	jp   L000E4C
L000D8E:;R
	ld   a, [wShutterRowsLeft]
	or   a
	jr   z, L000DA9
	dec  a
	ld   [wShutterRowsLeft], a
	ld   a, $06
	ld   [wShutterTimer], a
	ld   a, $02
	ld   [wShutterEvMode], a
	ld   a, $0A
	ldh  [hSFXSet], a
	jp   L000E4C
L000DA9:;R
	ld   b, $30
	ld   a, [wNoScroll]
	or   a
	jr   z, L000DB3
	ld   b, $68
L000DB3:;R
	ld   a, b
	ld   [wShutterTimer], a
	ld   hl, wShutterMode
	inc  [hl]
	jp   L000E4C
L000DBE:;I
	call L000DD7
	ld   hl, wPlRelX
	dec  [hl]
	ld   hl, wShutterTimer
	dec  [hl]
	jp   nz, L000E4C
	ld   hl, wNoScroll
	inc  [hl]
	xor  a
	ld   [wShutterMode], a
	jp   L000E4C
L000DD7:;C
	ld   hl, wActScrollX
	dec  [hl]
L000DDB:;C
	ldh  a, [hScrollX]
	inc  a
	ldh  [hScrollX], a
	and  $0F
	ldh  [hScrollXNybLow], a
	ret  nz
	ld   hl, wLvlColL
	inc  [hl]
	jp   L000980
L000DEC:;J
	ldh  a, [hTimer]
	and  $3F
	jr   nz, L000E34
	ld   a, [wLvlWater]
	or   a
	jr   z, L000E34
	ld   a, [wPlMode]
	cp   $09
	jr   c, L000E03
	cp   $0F
	jr   c, L000E34
L000E03:;R
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]
	sub  $0C
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	cp   $10
	jr   z, L000E1C
	cp   $18
	jr   nz, L000E34
L000E1C:;R
	ld   a, $64
	ld   [wActSpawnId], a
	xor  a
	ld   [wActSpawnLayoutPtr], a
	ld   a, [wTargetRelX]
	ld   [wActSpawnX], a
	ld   a, [wTargetRelY]
	ld   [wActSpawnY], a
	call ActS_Spawn
L000E34:;R
	ld   a, [wPlHurtTimer]
	or   a
	jr   z, L000E40
	dec  a
	ld   [wPlHurtTimer], a
	jr   L000E51
L000E40:;R
	ld   a, [wPlInvulnTimer]
	or   a
	jr   z, L000E51
	dec  a
	ld   [wPlInvulnTimer], a
	jr   L000E51
L000E4C:;J
	xor  a
	ldh  [hJoyKeys], a
	ldh  [hJoyNewKeys], a
L000E51:;R
	ld   a, [wPlMode]
	rst  $00 ; DynJump
	dw L000E8D ; PL_MODE_00
	dw L001068 ; PL_MODE_01
	dw L00107F ; PL_MODE_02
	dw L00116F ; PL_MODE_03
	dw L0012A4 ; PL_MODE_04
	dw L00138A ; PL_MODE_05
	dw L0013A3 ; PL_MODE_06
	dw L0013BA ; PL_MODE_07
	dw L0013D3 ; PL_MODE_08
	dw L0013E9 ; PL_MODE_09
	dw L001400 ; PL_MODE_0A
	dw L001423 ; PL_MODE_0B
	dw L001439 ; PL_MODE_0C
	dw L00145C ; PL_MODE_0D
	dw L001473 ; PL_MODE_0E
	dw L001496 ; PL_MODE_0F
	dw L001499 ; PL_MODE_SLIDE
	dw L001516 ; PL_MODE_RM
	dw L00169B ; PL_MODE_WARPIN
	dw L0016AF ; PL_MODE_13
	dw L001707 ; PL_MODE_14
	dw L001727 ; PL_MODE_15
	dw L001738 ; PL_MODE_16
	dw L001758 ; PL_MODE_17
	dw L00176C ; PL_MODE_18
	dw L00176D ; PL_MODE_19
	dw L00177E ; PL_MODE_1A
	dw L00179E ; PL_MODE_1B
L000E8D:;I
	ld   a, [wWpnSGRide]
	or   a
	jr   z, L000EB8
	ldh  a, [hJoyKeys]
	bit  0, a
	jr   nz, L000EA0
	ld   bc, $0200
	ld   a, $1C
	jr   L000EA5
L000EA0:;R
	ld   bc, $0400
	ld   a, $1D
L000EA5:;R
	ld   [wPlSprMapId], a
	ld   a, c
	ld   [wPlSpdY], a
	ld   a, b
	ld   [wPlSpdYSub], a
	ld   a, $02
	ld   [wPlMode], a
	jp   L001AE9
L000EB8:;R
	ld   a, [wPlHurtTimer]
	or   a
	jr   z, L000ED0
	call L00186E
	jp   z, L00101A
	call L0017E0
	call L0018AE
	call L0018FE
	jp   L00100E
L000ED0:;R
	call L014000 ; BANK $01
	call L0017E0
	call L001895
	call L0018FE
	ld   a, [wPlInvulnTimer]
	or   a
	jr   nz, L000EFC
	ld   a, [wPlRelY]
	sub  $08
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $18
	jr   c, L000EFC
	cp   $20
	jp   c, L0017A5
L000EFC:;R
	ld   a, [$CF3C]
	cp   $38
	jr   nz, L000F2E
	call L0039C2
	jr   c, L000F2E
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]
	inc  a
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	jr   c, L000F2E
	call ActS_DespawnAll
	xor  a
	ld   [$CF3C], a
	ld   a, $01
	ld   [wShutterMode], a
	ld   a, $04
	ld   [wPlSprMapId], a
	jp   L001AE9
L000F2E:;R
	ldh  a, [hJoyKeys]
	bit  6, a
	jr   z, L000F5B
	ld   a, [wPlRelY]
	cp   $28
	jr   c, L000F5B
	sub  $0F
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $20
	jr   nz, L000F5B
L000F4D: db $CD;X
L000F4E: db $D2;X
L000F4F: db $17;X
L000F50: db $3E;X
L000F51: db $04;X
L000F52: db $EA;X
L000F53: db $1D;X
L000F54: db $CF;X
L000F55: db $CD;X
L000F56: db $45;X
L000F57: db $1A;X
L000F58: db $C3;X
L000F59: db $E9;X
L000F5A: db $1A;X
L000F5B:;R
	ldh  a, [hJoyKeys]
	bit  7, a
	jr   z, L000F80
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]
	inc  a
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	cp   $21
	jr   nz, L000F80
	ld   a, $05
	ld   [wPlMode], a
	call L001A45
	jp   L001AE9
L000F80:;R
	ldh  a, [hJoyNewKeys]
	bit  0, a
	jr   z, L000FD4
	ldh  a, [hJoyKeys]
	bit  7, a
	jr   z, L000FD4
	ld   a, [wCF6B_Unk_ActCurSlotPtrCopy]
	cp   $FF
	jr   nz, L000FD4
	ld   a, [wPlDirH]
	or   a
	jr   nz, L000FA6
	ld   a, [wPlRelX]
	ld   [wPlSlideDustX], a
	sub  $10
	ld   [wTargetRelX], a
	jr   L000FB1
L000FA6:;R
	ld   a, [wPlRelX]
	ld   [wPlSlideDustX], a
	add  $10
	ld   [wTargetRelX], a
L000FB1:;R
	ld   a, [wPlRelY]
	ld   [wPlSlideDustY], a
	sub  $0F
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	jp   nc, L000FD4
	ld   a, $10
	ld   [wPlMode], a
	ld   a, $1E
	ld   [wPlSlideTimer], a
	ld   a, $30
	ld   [wPlSlideDustTimer], a
	jp   L001AE9
L000FD4:;JR
	ldh  a, [hJoyNewKeys]
	bit  0, a
	jr   z, L00100E
	ld   a, [wPlRelY]
	sub  $18
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, L00100E
	ld   a, [wPlRelX]
	add  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, L00100E
	ld   a, $80
	ld   [wPlSpdY], a
	ld   a, $03
	ld   [wPlSpdYSub], a
	ld   a, $01
	ld   [wPlMode], a
	jp   L001AE9
L00100E:;JR
	call L001836
	ld   a, [wColiGround]
	and  $03
	cp   $03
	jr   nz, L00102C
L00101A:;X
	ld   a, $00
	ld   [wPlSpdY], a
	ld   a, $01
	ld   [wPlSpdYSub], a
	ld   a, $03
	ld   [wPlMode], a
	jp   L001AE9
L00102C:;R
	ld   a, [wCF6B_Unk_ActCurSlotPtrCopy]
	cp   $FF
	jr   nz, L00103A
	ldh  a, [hJoyKeys]
	and  $30
	jp   nz, L001AAF
L00103A:;R
	xor  a
	ld   [wPlWalkAnimMode], a
	ld   a, [wPlBlinkChkDelay]
	or   a
	jr   nz, L001050
	call Rand
	cp   $03
	jr   nc, L001060
	ld   a, $19
	ld   [wPlBlinkChkDelay], a
L001050:;R
	dec  a
	ld   [wPlBlinkChkDelay], a
	cp   $0C
	jr   c, L001060
	ld   a, $05
	ld   [wPlSprMapId], a
	jp   L001AE9
L001060:;R
	ld   a, $04
	ld   [wPlSprMapId], a
	jp   L001AE9
L001068:;I
	call L014000 ; BANK $01
	call L001895
	call L0018FE
	ld   a, $07
	ld   [wPlSprMapId], a
	ldh  a, [hJoyKeys]
	bit  0, a
	jr   nz, L001093
	jp   L00115D
L00107F:;I
	call L014000 ; BANK $01
	call L001895
	call L0018FE
	ld   a, [wWpnSGRide]
	or   a
	jr   nz, L0010C0
	ld   a, $07
	ld   [wPlSprMapId], a
L001093:;R
	ldh  a, [hJoyKeys]
	bit  6, a
	jr   z, L0010C0
	ld   a, [wPlRelY]
	cp   $28
	jr   c, L0010C0
	sub  $0F
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $20
	jr   nz, L0010C0
	call L0017D2
	ld   a, $04
	ld   [wPlMode], a
	call L001A45
	jp   L001AE9
L0010C0:;R
	ld   a, [wPlRelY]
	cp   $18
	jp   c, L00115D
	ld   a, [wPlSpdYSub]
	ld   b, a
	ld   a, [wPlRelY]
	sub  b
	ld   [wPl_Unk_RelY_Copy], a
	sub  $18
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, L00114E
	ld   a, [wPlRelX]
	sub  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, L00115D
	ld   a, [wPlRelX]
	add  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, L00115D
	ld   a, [wPl_Unk_RelY_Copy]
	ld   [wPlRelY], a
	ld   a, [wLvlWater]
	or   a
	jr   z, L001120
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	cp   $10
	jr   z, L001137
	cp   $18
	jr   z, L001137
L001120:;R
	ld   bc, $0020
	ld   a, [wPlSpdY]
	sub  c
	ld   [wPlSpdY], a
	ld   a, [wPlSpdYSub]
	sbc  b
	ld   [wPlSpdYSub], a
	or   a
	jr   z, L00115D
	jp   L001AE9
L001137:;R
	ld   bc, $0008
	ld   a, [wPlSpdY]
	sub  c
	ld   [wPlSpdY], a
	ld   a, [wPlSpdYSub]
	sbc  b
	ld   [wPlSpdYSub], a
	or   a
	jr   z, L00115D
	jp   L001AE9
L00114E:;R
	ld   a, [wPlYCeilMask]
	ld   b, a
	ld   a, [wPlRelY]
	sub  $17
	and  b
	add  $17
	ld   [wPlRelY], a
L00115D:;JR
	ld   a, $00
	ld   [wPlSpdY], a
	ld   a, $01
	ld   [wPlSpdYSub], a
	ld   a, $03
	ld   [wPlMode], a
	jp   L001AE9
L00116F:;I
	ld   a, [wPlHurtTimer]
	or   a
	jr   z, L00117D
	call L0018AE
	call L0018FE
	jr   L001186
L00117D:;R
	call L014000 ; BANK $01
	call L001895
	call L0018FE
L001186:;R
	ld   a, [wWpnSGRide]
	or   a
	jr   nz, L0011BE
	ld   a, $07
	ld   [wPlSprMapId], a
	ldh  a, [hJoyKeys]
	bit  6, a
	jr   z, L0011BE
	ld   a, [wPlRelY]
	cp   $28
	jr   c, L0011BE
	sub  $0F
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $20
	jr   nz, L0011BE
	call L0017D2
	ld   a, $04
	ld   [wPlMode], a
	call L001A45
	jp   L001AE9
L0011BE:;R
	ld   a, [wCF4A_Unk_ActTargetSlot]
	cp   $FF
	jp   nz, L00128F
	ld   a, [wPlSpdYSub]
	ld   b, a
	ld   a, [wPlRelY]
	add  b
	ld   [wPl_Unk_RelY_Copy], a
	call L00186E
	jp   z, L0011FD
	ld   a, [wPl_Unk_RelY_Copy]
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $21
	jp   nc, L001287
	ld   a, [wPlRelX]
	add  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $21
	jp   nc, L001287
L0011FD:;J
	ld   a, [wPl_Unk_RelY_Copy]
	ld   [wPlRelY], a
	cp   $98
	jr   c, L001226
	sub  $10
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $18
	jr   c, L00121E
	cp   $20
	jp   c, L0017A5
L00121E:;R
	ld   a, $0D
	ld   [wPlMode], a
	jp   L001AE9
L001226:;R
	ld   a, [wLvlWater]
	or   a
	jr   z, L001243
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	cp   $10
	jr   z, L001265
	cp   $18
	jr   z, L001265
L001243:;R
	ld   bc, $0020
	ld   a, [wPlSpdY]
	add  c
	ld   [wPlSpdY], a
	ld   a, [wPlSpdYSub]
	adc  b
	ld   [wPlSpdYSub], a
	cp   $04
	jp   c, L001AE9
	xor  a
	ld   [wPlSpdY], a
	ld   a, $04
	ld   [wPlSpdYSub], a
	jp   L001AE9
L001265:;R
	ld   bc, $0008
	ld   a, [wPlSpdY]
	add  c
	ld   [wPlSpdY], a
	ld   a, [wPlSpdYSub]
	adc  b
	ld   [wPlSpdYSub], a
	cp   $01
	jp   c, L001AE9
	xor  a
	ld   [wPlSpdY], a
	ld   a, $01
	ld   [wPlSpdYSub], a
	jp   L001AE9
L001287:;J
	ld   a, [wPlRelY]
	or   $0F
	ld   [wPlRelY], a
L00128F:;J
	call L0017D2
	xor  a
	ld   [wPlMode], a
	ld   a, [wWpnSGRide]
	or   a
	jp   nz, L001AE9
	ld   a, $01
	ldh  [hSFXSet], a
	jp   L001AE9
L0012A4:;I
	call L014000 ; BANK $01
	ld   a, $09
	ld   [wPlSprMapId], a
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]
	sub  $0F
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	cp   $20
	jr   nc, L0012C9
	ld   a, $03
	ld   [wPlMode], a
	jp   L001AD6
L0012C9:;R
	ldh  a, [hJoyNewKeys]
	bit  0, a
	jp   z, L0012E2
	ld   a, $00
	ld   [wPlSpdY], a
	ld   a, $01
	ld   [wPlSpdYSub], a
	ld   a, $03
	ld   [wPlMode], a
	jp   L001AE9
L0012E2:;J
	ld   a, [wPlShootTimer]
	or   a
	jp   nz, L001AE9
	ldh  a, [hJoyKeys]
	bit  5, a
	jr   z, L0012F6
	xor  a
	ld   [wPlDirH], a
	jp   L001AE9
L0012F6:;R
	bit  4, a
	jr   z, L001302
	ld   a, $01
	ld   [wPlDirH], a
	jp   L001AE9
L001302:;R
	ldh  a, [hJoyKeys]
	bit  6, a
	jr   z, L001347
	ld   a, [wPlRelY]
	sub  $18
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $20
	jr   nc, L001325
	ld   a, $07
	ld   [wPlMode], a
	jp   L001AD6
L001325:;R
	ld   a, [wPlRelY]
	cp   $29
	jr   nc, L001334
	ld   a, $0B
	ld   [wPlMode], a
	jp   L001AD6
L001334:;R
	ld   a, [wPlRelYSub]
	sub  $C0
	ld   [wPlRelYSub], a
	ld   a, [wPlRelY]
	sbc  $00
	ld   [wPlRelY], a
	jp   L001AD6
L001347:;R
	ldh  a, [hJoyKeys]
	bit  7, a
	jp   z, L001AE9
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]
	inc  a
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	jr   c, L001367
L001360: db $AF;X
L001361: db $EA;X
L001362: db $1D;X
L001363: db $CF;X
L001364: db $C3;X
L001365: db $D6;X
L001366: db $1A;X
L001367:;R
	ld   a, [wPlRelY]
	cp   $98
	jp   c, L001377
	ld   a, $09
	ld   [wPlMode], a
	jp   L001AD6
L001377:;J
	ld   a, [wPlRelYSub]
	add  $C0
	ld   [wPlRelYSub], a
	ld   a, [wPlRelY]
	adc  $00
	ld   [wPlRelY], a
	jp   L001AD6
L00138A:;I
	ld   a, $08
	ld   [wPlSprMapId], a
	ld   a, [wPlRelY]
	add  $08
	ld   [wPlRelY], a
	ld   a, $06
	ld   [wPl_CF1E_DelayTimer], a
	ld   hl, wPlMode
	inc  [hl]
	jp   L001AE9
L0013A3:;I
	ld   hl, wPl_CF1E_DelayTimer
	dec  [hl]
	jp   nz, L001AE9
	ld   a, [wPlRelY]
	add  $10
	ld   [wPlRelY], a
	ld   a, $04
	ld   [wPlMode], a
	jp   L001AE9
L0013BA:;I
	ld   a, $08
	ld   [wPlSprMapId], a
	ld   a, [wPlRelY]
	sub  $10
	ld   [wPlRelY], a
	ld   a, $06
	ld   [wPl_CF1E_DelayTimer], a
	ld   hl, wPlMode
	inc  [hl]
	jp   L001AE9
L0013D3:;I
	ld   hl, wPl_CF1E_DelayTimer
	dec  [hl]
	jp   nz, L001AE9
	ld   a, [wPlRelY]
	sub  $08
	ld   [wPlRelY], a
	xor  a
	ld   [wPlMode], a
	jp   L001AE9
L0013E9:;I
	call ActS_DespawnAll
	ld   a, $09
	ld   [wPlSprMapId], a
	ld   a, $01
	ld   [wScrollVDir], a
	call Game_Unk_StartRoomTrs
	ld   hl, wPlMode
	inc  [hl]
	jp   L001AD6
L001400:;I
	ld   a, [wPlRelYSub]
	add  $40
	ld   [wPlRelYSub], a
	ld   a, [wPlRelY]
	adc  $00
	sub  $02
	ld   [wPlRelY], a
	call Game_Unk_DoRoomTrs
	jp   nz, L001AD6
	ld   a, $04
	ld   [wPlMode], a
	call L001AD6
	jp   ActS_SpawnRoom
L001423:;I
	call ActS_DespawnAll
	ld   a, $09
	ld   [wPlSprMapId], a
	xor  a
	ld   [wScrollVDir], a
	call Game_Unk_StartRoomTrs
	ld   hl, wPlMode
	inc  [hl]
	jp   L001AD6
L001439:;I
	ld   a, [wPlRelYSub]
	sub  $40
	ld   [wPlRelYSub], a
	ld   a, [wPlRelY]
	sbc  $00
	add  $02
	ld   [wPlRelY], a
	call Game_Unk_DoRoomTrs
	jp   nz, L001AD6
	ld   a, $04
	ld   [wPlMode], a
	call L001AD6
	jp   ActS_SpawnRoom
L00145C:;I
	call ActS_DespawnAll
	ld   a, $07
	ld   [wPlSprMapId], a
	ld   a, $01
	ld   [wScrollVDir], a
	call Game_Unk_StartRoomTrs
	ld   hl, wPlMode
	inc  [hl]
	jp   L001AE9
L001473:;I
	ld   a, [wPlSpdY]
	add  $40
	ld   [wPlSpdY], a
	ld   a, [wPlRelY]
	adc  $00
	sub  $02
	ld   [wPlRelY], a
	call Game_Unk_DoRoomTrs
	jp   nz, L001AE9
	ld   a, $03
	ld   [wPlMode], a
	call L001AE9
	jp   ActS_SpawnRoom
L001496:;I
	jp   L001AE9
L001499:;I
	ld   a, $0A
	ld   [wPlSprMapId], a
	call L0017E0
	ldh  a, [hJoyKeys]
	ld   b, a
	and  $30
	jr   nz, L0014B7
	ld   a, [wPlDirH]
	or   a
	jr   nz, L0014B2
	set  5, b
	jr   L0014B4
L0014B2:;R
	set  4, b
L0014B4:;R
	ld   a, b
	ldh  [hJoyKeys], a
L0014B7:;R
	call L001890
	call L0018FE
	call L001AE9
	call L001836
	ld   a, [wColiGround]
	and  $03
	cp   $03
	jr   nz, L0014E2
	ld   a, $00
	ld   [wPlSpdY], a
	ld   a, $01
	ld   [wPlSpdYSub], a
	ld   a, $03
	ld   [wPlMode], a
	ld   hl, wPlRelY
	inc  [hl]
	jp   L001AE9
L0014E2:;R
	ld   a, [wPlSlideTimer]
	or   a
	jr   z, L0014EC
	dec  a
	ld   [wPlSlideTimer], a
L0014EC:;R
	ld   a, [wPlRelY]
	sub  $10
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ret  nc
	ld   a, [wPlRelX]
	add  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ret  nc
	ld   a, [wPlSlideTimer]
	or   a
	ret  nz
	xor  a
	ld   [wPlMode], a
	ret
L001516:;I
	call L014000 ; BANK $01
	ld   hl, wPlRmSpdL
	ldh  a, [hJoyKeys]
	bit  5, a
	jr   z, L001530
	xor  a
	ld   [wPlDirH], a
	ld   a, [hl]
	add  $08
	ld   [hl], a
	jr   nc, L00153D
	ld   [hl], $FF
	jr   L00153D
L001530:;R
	ld   a, [hl]
	or   a
	jr   z, L001567
	sub  $04
	ld   [hl], a
	jr   nc, L00153D
	xor  a
	ld   [hl], a
	jr   L001567
L00153D:;R
	ld   a, [wPlRelX]
	sub  $0F
	call L001641
	jr   z, L00155E
	ld   a, [wPlRmSpdL]
	srl  a
	ld   [wPlRmSpdR], a
	or   a
	jr   z, L001567
	ld   bc, $0100
	call L0018CC
	xor  a
	ld   [wPlRmSpdL], a
	jr   L001567
L00155E:;R
	ld   a, [wPlRmSpdL]
	ld   c, a
	ld   b, $00
	call L0018BD
L001567:;R
	ld   hl, wPlRmSpdR
	ldh  a, [hJoyKeys]
	bit  4, a
	jr   z, L00157F
	ld   a, $01
	ld   [wPlDirH], a
	ld   a, [hl]
	add  $08
	ld   [hl], a
	jr   nc, L00158C
	ld   [hl], $FF
	jr   L00158C
L00157F:;R
	ld   a, [hl]
	or   a
	jr   z, L0015B6
	sub  $04
	ld   [hl], a
	jr   nc, L00158C
	xor  a
	ld   [hl], a
	jr   L0015B6
L00158C:;R
	ld   a, [wPlRelX]
	add  $0F
	call L001641
	jr   z, L0015AD
	ld   a, [wPlRmSpdR]
	srl  a
	ld   [wPlRmSpdL], a
	or   a
	jr   z, L0015B6
	ld   bc, $0100
	call L0018BD
	xor  a
	ld   [wPlRmSpdR], a
	jr   L0015B6
L0015AD:;R
	ld   a, [wPlRmSpdR]
	ld   c, a
	ld   b, $00
	call L0018CC
L0015B6:;R
	ld   hl, wPlRmSpdU
	ldh  a, [hJoyKeys]
	bit  6, a
	jr   z, L0015C9
	ld   a, [hl]
	add  $08
	ld   [hl], a
	jr   nc, L0015D6
	ld   [hl], $FF
	jr   L0015D6
L0015C9:;R
	ld   a, [hl]
	or   a
	jr   z, L0015F9
	sub  $04
	ld   [hl], a
	jr   nc, L0015D6
L0015D2: db $AF;X
L0015D3: db $77;X
L0015D4: db $18;X
L0015D5: db $23;X
L0015D6:;R
	ld   a, [wPlRelY]
	sub  $10
	call L001665
	jr   z, L0015E6
	xor  a
	ld   [wPlRmSpdU], a
	jr   L0015F9
L0015E6:;R
	ld   a, [wPlRmSpdU]
	ld   b, a
	ld   a, [wPlRmSpdYSub]
	sub  b
	ld   [wPlRmSpdYSub], a
	ld   a, [wPlRmSpdY]
	sbc  $00
	ld   [wPlRmSpdY], a
L0015F9:;R
	ld   hl, wPlRmSpdD
	ldh  a, [hJoyKeys]
	bit  7, a
	jr   z, L00160C
	ld   a, [hl]
	add  $08
	ld   [hl], a
	jr   nc, L001619
	ld   [hl], $FF
	jr   L001619
L00160C:;R
	ld   a, [hl]
	or   a
	jr   z, L00163B
	sub  $04
	ld   [hl], a
	jr   nc, L001619
	xor  a
	ld   [hl], a
	jr   L00163B
L001619:;R
	ld   a, [wPlRelY]
	inc  a
	call L001665
	jr   z, L001628
	xor  a
	ld   [wPlRmSpdD], a
	jr   L00163B
L001628:;R
	ld   a, [wPlRmSpdD]
	ld   b, a
	ld   a, [wPlRmSpdYSub]
	add  b
	ld   [wPlRmSpdYSub], a
	ld   a, [wPlRmSpdY]
	adc  $00
	ld   [wPlRmSpdY], a
L00163B:;R
	call L0018DB
	jp   L001A89
L001641:;C
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	cp   $10
	jr   z, L001654
	cp   $18
	ret  nz
L001654:;R
	ld   a, [wPlRelY]
	sub  $0F
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	cp   $10
	ret  z
	cp   $18
	ret
L001665:;C
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $10
	jr   z, L001678
	cp   $18
	ret  nz
L001678:;R
	ld   a, [wPlRelX]
	sub  $0E
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $10
	jr   z, L00168A
	cp   $18
	ret  nz
L00168A:;R
	ld   a, [wPlRelX]
	add  $0E
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $10
	ret  z
	cp   $18
	ret
L00169B:;I
	ld   a, $00
	ld   [wPlSpdY], a
	ld   a, $01
	ld   [wPlSpdYSub], a
	ld   a, $31
	ld   [wPlSprMapId], a
	ld   hl, wPlMode
	inc  [hl]
	ret
L0016AF:;I
	ld   a, [wPlRelY]
	ld   b, a
	ld   a, [wPlSpdYSub]
	add  b
	ld   [wPl_Unk_RelY_Copy], a
	cp   $48
	jr   c, L0016CF
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, L0016F4
	ld   a, [wPl_Unk_RelY_Copy]
L0016CF:;R
	ld   [wPlRelY], a
	ld   bc, $0020
	ld   a, [wPlSpdY]
	add  c
	ld   [wPlSpdY], a
	ld   a, [wPlSpdYSub]
	adc  b
	ld   [wPlSpdYSub], a
	cp   $04
	jp   c, L001AE9
	xor  a
	ld   [wPlSpdY], a
	ld   a, $04
	ld   [wPlSpdYSub], a
	jp   L001AE9
L0016F4:;R
	ld   a, [wPlRelY]
	or   $0F
	ld   [wPlRelY], a
	ld   hl, wPlMode
	inc  [hl]
	xor  a
	ld   [wPlWarpSprMapRelId], a
	jp   L001AE9
L001707:;I
	ld   a, [wPlWarpSprMapRelId]
	inc  a
	ld   [wPlWarpSprMapRelId], a
	srl  a
	cp   $05
	jr   z, L00171E
	ld   b, a
	ld   a, $31
	add  b
	ld   [wPlSprMapId], a
	jp   L001AE9
L00171E:;R
	ld   a, $0C
	ldh  [hSFXSet], a
	xor  a
	ld   [wPlMode], a
	ret
L001727:;I
	ld   a, $0A
	ld   [wPlWarpSprMapRelId], a
	ld   a, $34
	ld   [wPlSprMapId], a
	ld   hl, wPlMode
	inc  [hl]
	jp   L001AE9
L001738:;I
	ld   a, [wPlWarpSprMapRelId]
	dec  a
	ld   [wPlWarpSprMapRelId], a
	srl  a
	jr   z, L00174D
	ld   b, a
	ld   a, $30
	add  b
	ld   [wPlSprMapId], a
	jp   L001AE9
L00174D:;R
	ld   a, $0D
	ldh  [hSFXSet], a
	ld   hl, wPlMode
	inc  [hl]
	jp   L001AE9
L001758:;I
	ld   a, [wPlRelY]
	sub  $04
	ld   [wPlRelY], a
	and  $F0
	jp   nz, L001AE9
	ld   hl, wPlMode
	inc  [hl]
	jp   L001AE9
L00176C:;I
	ret
L00176D:;I
	ld   a, $0A
	ld   [wPlWarpSprMapRelId], a
	ld   a, $34
	ld   [wPlSprMapId], a
	ld   hl, wPlMode
	inc  [hl]
	jp   L001AE9
L00177E:;I
	ld   a, [wPlWarpSprMapRelId]
	dec  a
	ld   [wPlWarpSprMapRelId], a
	srl  a
	jr   z, L001793
	ld   b, a
	ld   a, $30
	add  b
	ld   [wPlSprMapId], a
	jp   L001AE9
L001793:;R
	ld   a, $0D
	ldh  [hSFXSet], a
	ld   hl, wPlMode
	inc  [hl]
	jp   L001AE9
L00179E:;I
	ld   a, [wLvlWarpDest]
	ld   [wLvlEnd], a
	ret
L0017A5:;J
	ldh  a, [hInvulnCheat]
	or   a
	jr   z, L0017BC
L0017AA: db $3E;X
L0017AB: db $02;X
L0017AC: db $EA;X
L0017AD: db $1D;X
L0017AE: db $CF;X
L0017AF: db $3E;X
L0017B0: db $05;X
L0017B1: db $EA;X
L0017B2: db $1A;X
L0017B3: db $CF;X
L0017B4: db $3E;X
L0017B5: db $00;X
L0017B6: db $EA;X
L0017B7: db $1B;X
L0017B8: db $CF;X
L0017B9: db $C3;X
L0017BA: db $E9;X
L0017BB: db $1A;X
L0017BC:;R
	ld   a, [wPlRelX]
	ld   [wExplodeOrgX], a
	ld   a, [wPlRelY]
	sub  $0C
	ld   [wExplodeOrgY], a
	ld   a, $01
	ld   [wLvlEnd], a
	jp   L001AE9
L0017D2:;C
	ld   a, [wWpnSel]
	cp   $04
	ret  nz
	xor  a
	ld   [wWpnTpActive], a
	ld   [wShot0], a
	ret
L0017E0:;C
	ld   a, [wCF4A_Unk_ActTargetSlot]
	cp   $FF
	ret  nz
	ld   a, [wPlRelY]
	inc  a
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ld   bc, $0080
	cp   $30
	jr   c, L001811
	jp   z, L0018CC
	cp   $31
	jp   z, L0018BD
	cp   $32
	jp   z, L0018CC
	cp   $33
	jp   z, L0018BD
L001811:;R
	ld   a, [wPlRelX]
	add  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ld   bc, $0080
	cp   $30
	jr   c, L001835
	jp   z, L0018CC
	cp   $31
	jp   z, L0018BD
	cp   $32
	jp   z, L0018CC
	cp   $33
	jp   z, L0018BD
L001835:;R
	ret
L001836:;C
	ld   a, [wCF4A_Unk_ActTargetSlot]
	cp   $FF
	jr   z, L001842
	xor  a
	ld   [wColiGround], a
	ret
L001842:;R
	ld   a, [wPlRelY]
	inc  a
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $21
	ld   hl, wColiGround
	rl   [hl]
	ld   a, [wPlRelX]
	add  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $21
	ld   hl, wColiGround
	rl   [hl]
	ret
L00186E:;C
	ld   a, [wPlRelY]
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $21
	ret  nz
	ld   a, [wPlRelX]
	add  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $21
	ret
L001890:;C
	ld   bc, $0180
	jr   L001898
L001895:;C
	ld   bc, $0100
L001898:;R
	ldh  a, [hJoyKeys]
	bit  5, a
	jr   z, L0018A4
	xor  a
	ld   [wPlDirH], a
	jr   L0018BD
L0018A4:;R
	bit  4, a
	ret  z
	ld   a, $01
	ld   [wPlDirH], a
	jr   L0018CC
L0018AE:;C
	ld   bc, $0040
	ld   a, [wPlDirH]
	or   a
	jr   z, L0018CC
	jr   L0018BD
L0018B9:;JC
	bit  7, a
	jr   nz, L0018CC
L0018BD:;JCR
	ld   a, [wPlSpdXSub]
	sub  c
	ld   [wPlSpdXSub], a
	ld   a, [wPlSpdX]
	sbc  b
	ld   [wPlSpdX], a
	ret
L0018CC:;JCR
	ld   a, [wPlSpdXSub]
	add  c
	ld   [wPlSpdXSub], a
	ld   a, [wPlSpdX]
	adc  b
	ld   [wPlSpdX], a
	ret
L0018DB:;C
	ld   a, [wPlSpdX]
	or   a
	ret  z
	bit  7, a
	jr   z, L0018F4
	xor  $FF
	inc  a
	ld   [wPlSpdX], a
L0018EA:;R
	call L001961
	ld   hl, wPlSpdX
	dec  [hl]
	jr   nz, L0018EA
	ret
L0018F4:;R
	call L0019F5
	ld   hl, wPlSpdX
	dec  [hl]
	jr   nz, L0018F4
	ret
L0018FE:;JC
	ld   a, [wPlSpdX]
	or   a
	ret  z
	bit  7, a
	jr   z, L001917
	xor  $FF
	inc  a
	ld   [wPlSpdX], a
L00190D:;R
	call L001921
	ld   hl, wPlSpdX
	dec  [hl]
	jr   nz, L00190D
	ret
L001917:;R
	call L0019B5
	ld   hl, wPlSpdX
	dec  [hl]
	jr   nz, L001917
	ret
L001921:;C
	ld   a, [wPlRelX]
	sub  $07
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ld   [wPlColiBlockL], a
	ret  nc
	ld   a, [wPlRelY]
	sub  $07
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	ld   a, [wPlRelY]
	sub  $0F
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	ld   a, [wPlMode]
	cp   $10
	jr   z, L001961
	ld   a, [wPlRelY]
	sub  $17
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
L001961:;CR
	ld   a, [wPlRelX]
	cp   $10
	ret  c
	ld   a, [wPl_Unk_Alt_X]
	dec  a
	ld   [wPl_Unk_Alt_X], a
	and  $0F
	cp   $0F
	jr   nz, L00198A
	ld   hl, wLvl_Unk_CurCol
	dec  [hl]
	ld   a, [wNoScroll]
	or   a
	jr   nz, L00199B
	ld   h, $CB
	ld   a, [wLvl_Unk_CurCol]
	ld   l, a
	ld   a, [hl]
	bit  7, a
	call nz, L00094C
L00198A:;R
	ld   a, [wNoScroll]
	or   a
	jr   nz, L00199B
	ld   h, $CB
	ld   a, [wLvl_Unk_CurCol]
	ld   l, a
	ld   a, [hl]
	bit  7, a
	jr   nz, L0019A0
L00199B:;R
	ld   hl, wPlRelX
	dec  [hl]
	ret
L0019A0:;R
	ld   hl, wActScrollX
	inc  [hl]
	ldh  a, [hScrollX]
	dec  a
	ldh  [hScrollX], a
	and  $0F
	ldh  [hScrollXNybLow], a
	cp   $0F
	ret  nz
	ld   hl, wLvlColL
	dec  [hl]
	ret
L0019B5:;C
	ld   a, [wPlRelX]
	add  $07
	ld   [wTargetRelX], a
	ld   a, [wPlRelY]
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ld   [$CF3C], a
	ret  nc
	ld   a, [wPlRelY]
	sub  $07
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	ld   a, [wPlRelY]
	sub  $0F
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	ld   a, [wPlMode]
	cp   $10
	jr   z, L0019F5
	ld   a, [wPlRelY]
	sub  $17
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
L0019F5:;CR
	ld   a, [wPlRelX]
	cp   $9F
	ret  nc
	ld   a, [wNoScroll]
	or   a
	jr   nz, L001A0C
	ld   h, $CB
	ld   a, [wLvl_Unk_CurCol]
	ld   l, a
	ld   a, [hl]
	bit  7, a
	jr   nz, L001A12
L001A0C:;R
	ld   hl, wPlRelX
	inc  [hl]
	jr   L001A25
L001A12:;R
	ld   hl, wActScrollX
	dec  [hl]
	ldh  a, [hScrollX]
	inc  a
	ldh  [hScrollX], a
	and  $0F
	ldh  [hScrollXNybLow], a
	jr   nz, L001A25
	ld   hl, wLvlColL
	inc  [hl]
L001A25:;R
	ld   a, [wPl_Unk_Alt_X]
	inc  a
	ld   [wPl_Unk_Alt_X], a
	and  $0F
	ret  nz
	ld   hl, wLvl_Unk_CurCol
	inc  [hl]
	ld   a, [wNoScroll]
	or   a
	ret  nz
	ld   h, $CB
	ld   a, [wLvl_Unk_CurCol]
	ld   l, a
	ld   a, [hl]
	bit  7, a
	ret  z
	jp   L000980
L001A45:;C
	ld   a, [wPlRelX]
	ld   b, a
	and  $0F
	cp   $0F
	ret  z
	cp   $08
	jr   nc, L001A6C
	inc  a
	ld   b, a
	ld   a, [wPlRelX]
	sub  b
	ld   [wPlRelX], a
	ld   a, [wPl_Unk_Alt_X]
	ld   c, a
	sub  b
	ld   [wPl_Unk_Alt_X], a
	xor  c
	bit  4, a
	ret  z
L001A67: db $21;X
L001A68: db $10;X
L001A69: db $CF;X
L001A6A: db $35;X
L001A6B: db $C9;X
L001A6C:;R
	ld   b, a
	ld   a, $0F
	sub  b
	ld   b, a
	ld   a, [wPlRelX]
	add  b
	ld   [wPlRelX], a
	ld   a, [wPl_Unk_Alt_X]
	ld   c, a
	add  b
	ld   [wPl_Unk_Alt_X], a
	xor  c
	bit  4, a
	ret  z
L001A84: db $21;X
L001A85: db $10;X
L001A86: db $CF;X
L001A87: db $34;X
L001A88: db $C9;X
L001A89:;J
	ld   a, [wPlRmSpdY]
	or   a
	ret  z
	bit  7, a
	jp   z, L001AA4
	xor  $FF
	inc  a
	ld   [wPlRmSpdY], a
L001A99:;X
	ld   hl, wPlRelY
	dec  [hl]
	ld   hl, wPlRmSpdY
	dec  [hl]
	jr   nz, L001A99
	ret
L001AA4:;J
	ld   hl, wPlRelY
	inc  [hl]
	ld   hl, wPlRmSpdY
	dec  [hl]
	jr   nz, L001AA4
	ret
L001AAF:;J
	ld   a, [wPlWalkAnimMode]
	cp   $07
	jr   z, L001AC1
	inc  a
	ld   [wPlWalkAnimMode], a
	ld   a, $06
	ld   [wPlSprMapId], a
	jr   L001AE9
L001AC1:;R
	ld   a, [wPlAnimTimer]
	add  $08
	ld   [wPlAnimTimer], a
	swap a
	srl  a
	srl  a
	and  $03
	ld   [wPlSprMapId], a
	jr   L001AE9
L001AD6:;JC
	ld   a, [wPlAnimTimer]
	add  $06
	ld   [wPlAnimTimer], a
	swap a
	srl  a
	srl  a
	and  $01
	ld   [wPlDirH], a
L001AE9:;JCR
	ld   a, [wWpnTpActive]
	or   a
	jp   nz, L001B9D
	ld   a, [wPlHurtTimer]
	or   a
	jr   z, L001B0D
	ldh  a, [hTimer]
	rra  
	jp   nc, L001B9D
	ld   a, [wPlMode]
	cp   $10
	jr   nc, L001B0D
	ld   a, [wWpnSGRide]
	or   a
	jr   nz, L001B0D
	ld   a, $30
	jr   L001B22
L001B0D:;R
	ld   a, [wPlInvulnTimer]
	or   a
	jr   z, L001B1A
	ldh  a, [hTimer]
	rra  
	rra  
	jp   nc, L001B9D
L001B1A:;R
	ld   a, [wPlShootType]
	ld   b, a
	ld   a, [wPlSprMapId]
	or   b
L001B22:;R
	push af
	ld   a, $03
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $4900
	ld   b, $00
	sla  a
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   e, a
	ld   a, [hl]
	ld   d, a
	ld   h, $DF
	ldh  a, [hWorkOAMPos]
	ld   l, a
	ld   a, [de]
	or   a
	jp   z, L001B94
	inc  de
	ld   b, a
	ld   a, [wPlDirH]
	or   a
	jr   nz, L001B6D
L001B4A:;R
	ld   a, [wPlRelY]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	ld   a, [wPlRelX]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	ld   a, [de]
	inc  de
	ldi  [hl], a
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [wActCurSprFlags]
	or   c
	ldi  [hl], a
	dec  b
	jr   nz, L001B4A
	ld   a, l
	ldh  [hWorkOAMPos], a
	jr   L001B94
L001B6D:;R
	ld   a, [wPlRelY]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	ld   a, [wPlRelX]
	ld   c, a
	ld   a, [de]
	inc  de
	xor  $FF
	sub  $06
	add  c
	ldi  [hl], a
	ld   a, [de]
	inc  de
	ldi  [hl], a
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [wActCurSprFlags]
	or   c
	xor  $20
	ldi  [hl], a
	dec  b
	jr   nz, L001B6D
	ld   a, l
	ldh  [hWorkOAMPos], a
L001B94:;R
	push af
	ldh  a, [hRomBankLast]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
L001B9D:;J
	ld   a, [wPlSlideDustTimer]
	or   a
	ret  z
	dec  a
	ld   [wPlSlideDustTimer], a
	swap a
	and  $03
	ld   hl, $1BD6
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   b, a
	ld   a, [wActScrollX]
	ld   c, a
	ld   h, $DF
	ldh  a, [hWorkOAMPos]
	ld   l, a
	ld   a, [wPlSlideDustY]
	sub  $07
	ldi  [hl], a
	ld   a, [wPlSlideDustX]
	add  c
	ld   [wPlSlideDustX], a
	sub  $04
	ldi  [hl], a
	ld   a, b
	ldi  [hl], a
	ld   a, [wActCurSprFlags]
	ldi  [hl], a
	ld   a, l
	ldh  [hWorkOAMPos], a
	ret
L001BD6: db $62
L001BD7: db $61
L001BD8: db $60

; =============== ActS_ClearAll ===============
; Prepares the actor memory.
ActS_ClearAll:
	; Delete the last loaded GFX marker
	ld   a, $FF
	ld   [wActGfxId], a
	
	; Start processing actors from the first slot
	xor  a
	ld   [wActStartEndSlotPtr], a
	
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
	ld   [wWpnItemWarp], a			; Rush/SG no longer there, can be recalled
	ld   [wWpnSGRide], a			; Disable pogo movement mode
	
	; Remove all weapon shots/actors.
	
	; Top Spin is melee weapon, and its "shot" is allowed to move through rooms.
	ld   a, [wWpnSel]
	cp   WPNSEL_TP
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
	; In case the screen is locked to the right, one extra column is loaded. (??? why)
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
	; What it does *NOT* account is the offset applied to the hardware, since actor positions and sprite positions
	; are one and the same. (ActS_SpawnFromLayout takes care of that)
	ld   b, $07				; B = Initial X pos
	
.loop:
	push hl
	push bc
		ld   h, HIGH(wActLayoutFlags) 	; Set the high byte
		ld   a, [hl]					; Read spawn flags
		bit  ACTLB_NOSPAWN, a			; Is the actor prevented from spawning?
		jr   nz, .skip					; If so, skip it (already on-screen or already collected)
		bit  ACTLB_SPAWN4, a			; Is the 4th bit set?
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
	
; =============== ActS_SpawnColEdge4 ===============
; Spawns the actor, if one is defined, for the column that got scrolled in.
; ??? Uses the 4th bit like the room spawn code.
; IN
; - L: Actor layout pointer
; - B: X Position
ActS_SpawnColEdge4:
	ld   h, HIGH(wActLayoutFlags)
	ld   a, [hl]
	bit  ACTLB_NOSPAWN, a			; Is the actor prevented from spawning?
	ret  nz							; If so, return
	bit  ACTLB_SPAWN4, a			; Is the 4th bit set?
	ret  z							; If not, return
	jr   ActS_SpawnFromLayout
	
; =============== ActS_SpawnColEdge1 ===============
; Spawns the actor, if one is defined, for the column that got scrolled in.
; ??? Uses the 5th bit unlike the room spawn code.
; IN
; - L: Actor layout pointer
; - B: X Position
ActS_SpawnColEdge5:
	ld   h, HIGH(wActLayoutFlags)
	ld   a, [hl]
	bit  ACTLB_NOSPAWN, a			; Is the actor prevented from spawning?
	ret  nz							; If so, return
	bit  ACTLB_SPAWN5, a			; Is the 5th bit set?
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
	ld   a, ACT_EXPLPART			; Explosion particle
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
	ld   a, ACT_EXPLPART			; Explosion particle
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
; IN
; - A: Actor ID
; - B: Relative X pos
; - C: Relative Y pos
; OUT
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
			; ??? Enforce visibility flag, also preventing the slot from being marked as free
			ld   a, [wActSpawnId]	
			or   ACT_UNK_PROCFLAG
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
		
		; ???
		; For reasons unknown to man, the two digits of the actor's health
		; are stored separately in the ROM.
		ld   b, [hl]	; Read low nybble (byte4)
		inc  hl
		ld   a, [hl]	; Read high nybble (byte5)
		swap a			; Swap it where it belongs
		add  b			; Merge them
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
; TODO: This and the related table ActS_GFXSetTbl might be better called Lvl_ReqLoadRoomObjGFX / Lvl_ObjGFXSetTbl or Obj_GFXSetTbl
;       ACTGFX_HARDMAN -> OBJGFX_HARDMAN
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

L001DE4:;C
	call ActS_GetHealth
	cp   $11
	ret  nc
	call L001E11
	call L001E25
	ld   h, $CD
	ldh  a, [hActCur+iAct0D]
	ld   l, a
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, l
	add  $04
	ld   l, a
	ld   a, [hl]
	sub  $04
	ld   [hl], a
	scf  
	ret
L001E03:;C
	call ActS_GetHealth
	cp   $11
	ret  nc
	call L001E11
	call L001E25
	scf  
	ret
L001E11:;JC
	ld   a, $80
	ldh  [hActCur+iActId], a
	xor  a
	ldh  [hActCur+iActRtnId], a
	ldh  [hActCur+iActSprMap], a
	ld   h, $CE
	ld   a, [wActCurSlotPtr]
	ld   l, a
	inc  l
	inc  l
	xor  a
	ld   [hl], a
	ret
L001E25:;JC
	call Rand
	cp   $4D
	ret  nc
	ld   b, $05
	cp   $26
	jr   nc, L001E41
	dec  b
	cp   $0A
	jr   nc, L001E41
	dec  b
	cp   $06
	jr   nc, L001E41
	dec  b
	cp   $03
	jr   nc, L001E41
	dec  b
L001E41:;R
	ld   a, b
	ld   [wActSpawnId], a
	xor  a
	ld   [wActSpawnLayoutPtr], a
	ld   h, $CD
	ld   a, [wActCurSlotPtr]
	add  $05
	ld   l, a
	ldi  a, [hl]
	ld   [wActSpawnX], a
	inc  l
	ld   a, [hl]
	ld   [wActSpawnY], a
	call ActS_Spawn
	ret  c
	inc  l
	ld   a, $01
	ld   [hl], a
	ret
L001E63:;C
	or   $80
	ld   e, a
	ld   bc, $0000
	ld   hl, wAct
L001E6C:;R
	ld   a, [hl]
	or   a
	jr   z, L001E75
	inc  c
	cp   e
	jr   nz, L001E75
	inc  b
L001E75:;R
	ld   a, l
	add  $10
	ld   l, a
	jr   nc, L001E6C
	ret
	
; =============== ActS_Unk_ResetSprMap ===============
; IN
; - HL: Ptr to ???
L001E7C:;C
	inc  l
	inc  l
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	ld   [hl], a
	ret
	
; =============== ActS_Unk_ResetSprMapFlip ===============
; IN
; - HL: Ptr to ???
L001E84:;C
	inc  l
	inc  l
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	xor  ACTDIR_R
	ld   [hl], a
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
; Resets the current actor's sprite mapping to return to the first frame.
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
	
L001EF7: db $FA;X
L001EF8: db $16;X
L001EF9: db $CF;X
L001EFA: db $47;X
L001EFB: db $F0;X
L001EFC: db $A7;X
L001EFD: db $B8;X
L001EFE: db $1F;X
L001EFF: db $E6;X
L001F00: db $80;X
L001F01: db $CB;X
L001F02: db $3F;X
L001F03: db $47;X
L001F04: db $F0;X
L001F05: db $A2;X
L001F06: db $CB;X
L001F07: db $B7;X
L001F08: db $B0;X
L001F09: db $E0;X
L001F0A: db $A2;X
L001F0B: db $C9;X

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
	; This timer is stored in the lower 3 bits of iActSprMap, while the sprite mapping ID 
	; uses the next 3 bits after that. Therefore, it eventually will overflow, triggering
	; the frame change.
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
	
; =============== Act_Boss_InitIntro ===============
; Sets up the necessary data to play a boss intro.
;
; Intros all use two different sprite mappings, each lasting the same amount of frames.
; This applies to both the gameplay and in the stage select screen.
;
; Note that the sprite mappings specified are all relative to the current one (iActSprMap).
;
; IN
; - D: 1st sprite mapping
; - E: 2nd sprite mapping
; - C: Frame length
Act_Boss_InitIntro:
	ld   a, $00
	ldh  [hActCur+iBossIntroTimer], a
	; With the exception of the timer above, these fields will not be written back to during playback.
	ld   a, d
	ldh  [hActCur+iBossIntroSprMap0], a
	ld   a, e
	ldh  [hActCur+iBossIntroSprMap1], a
	ld   a, c
	ldh  [hActCur+iBossIntroFrameLen], a
	ret

; =============== Act_Boss_PlayIntro ===============
; Handles the boss intro's timing, updating the sprite mapping frame.
;
; OUT
; - Z Flag: If set, the intro hasn't finished playing
Act_Boss_PlayIntro:

	; Advance its timer
	ldh  a, [hActCur+iBossIntroTimer]
	add  $01
	ldh  [hActCur+iBossIntroTimer], a
	
	; Get its fields out
	ldh  a, [hActCur+iBossIntroSprMap0]		; D = 1st sprite mapping ID / current
	ld   d, a								;     
	ldh  a, [hActCur+iBossIntroSprMap1]		; E = 2nd ""
	ld   e, a
	ldh  a, [hActCur+iBossIntroFrameLen]	; C = Target frame length / (*2)
	ld   c, a

	ld   b, a								; Separate copy to use as offset
.loop:

	; If the timer has gone past the target, check if we're done.
	; During playback of the second frame, this will *always* trigger the first time.
	ldh  a, [hActCur+iBossIntroTimer]
	cp   c									; Timer >= Target?
	jr   nc, .timerGtC						; If so, jump
	
.notDone:
	ld   a, d								; Set to wActCurSprMapRelId the current frame
	ld   [wActCurSprMapRelId], a
	xor  a									; Z Flag = set
	or   a
	ret
	
.timerGtC:
	;
	; Note how there's nothing keeping track of the current frame ID in a sensible way.
	; Instead, when a frame ends, we hack around the checks above to make them work
	; for the next frame, in a loop.
	; During playback of the second frame, we'll always have to get here at least once.
	;

	; Switch to the next frame
	inc  d							
	
	; If we've went past the 2nd frame, we're done
	ld   a, e
	cp   d							; 2ndFrame < CurFrame? 
	jr   c, .done					; If so, we're done
	
	; Otherwise, multiply the target frame by 2, then recheck
	ld   a, c						; Target += Target
	add  b
	ld   c, a
	jr   .loop
	
.done:
	ld   a, e						; Set to wActCurSprMapRelId the 2nd frame for consistency
	ld   [wActCurSprMapRelId], a
	ld   a, $01						; Z Flag = clear
	or   a
	ret
	
; =============== ActS_AngleToPl ===============
; Makes the actor move slowly at an angle towards the player.
; Used by actors that "track" a snapshot of the player's position, like carrots.
ActS_AngleToPl:

	; Target is 12 pixels above the player's origin.
	; This corresponds to the center of their body.
	ld   b, $0C		
	
	; Fall-through
	
; =============== ActS_AngleToPlCustom ===============
; See above, but with a custom vertical offset.
; Used exclusively by ??? to track the player's origin rather than center of the body.
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

	; Not used here, presumably leftover copypaste from Act_Boss_InitIntro
	xor  a
	ldh  [hActCur+iActTimer0C], a
	
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
; - A: Movement speed (1 or 2)
ActS_ApplyCirclePath:
	DEF tArcSpd = wTmpCF52
	; Save this for later
	ld   [tArcSpd], a
	
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
	; Increase the index by the speed amount we passed to the subroutine.
	; If it reaches the maximum value of ARC_MAX, make the actor turn horizontally
	; and, from the next frame, start decreasing the indexes.
	;
	
	ld   a, [tArcSpd]				; iArcIdX += tArcSpd
	ld   b, a
	ldh  a, [hActCur+iArcIdX]
	add  b
	ldh  [hActCur+iArcIdX], a
	
	; The equality check here brings an assumption.
	; ARC_MAX needs to be a multiple of tArcSpd, otherwise we miss the specific value we check for.
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
	; Decrease the index by the speed amount we passed to the subroutine.
	; If it reaches the minimum value of start increasing the indexes.
	;
	
	ld   a, [tArcSpd]				; iArcIdX -= tArcSpd
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
	ld   a, [tArcSpd]				; iArcIdY += tArcSpd
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
	ld   a, [tArcSpd]				; iArcIdY -= tArcSpd
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
L0022C0: db $F0;X
L0022C1: db $A2;X
L0022C2: db $CB;X
L0022C3: db $77;X
L0022C4: db $20;X
L0022C5: db $31;X

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
	
L002321: db $F0;X
L002322: db $A2;X
L002323: db $CB;X
L002324: db $77;X
L002325: db $C2;X
L002326: db $A8;X
L002327: db $23;X

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
	; Since the origin is at the bottom edge of the sprite's collosion box, but collision sizes are half-width:
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
	; This forces the actor to start falling down ???
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
	cp   ACT_E0			; iActId < $E0?
	jr   c, .despawn	; If so, skip
	cp   ACT_E4			; iActId >= $E4?
	jr   nc, .despawn	; If so, skip
	xor  a
	ld   [wWpnItemWarp], a
	
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
	
	; And merge it with the base flags into the final value
.calcFlags:
	; A will be 0 if we jumped to here (SPRB_OBP1 clear)
	; Note this isn't using xor b, so if the object is already using OBP1, the flash won't be visible.
	ld   b, a					
	ld   a, [wActCurSprFlags]
	or   b						
	ld   [wTmpCF52], a
	
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
	and  $FF^ACT_UNK_PROCFLAG	; Filter out ??? visibility flag
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
	; One of the values ("base ID") is stored directly into the slot, the other ("relative ID")
	; is a one-off that needs to be manually set each time the actor is processed.
	; On top of that, the base ID is packed into just three bits of iActSprMap.
	;
	
	; B = Relative ID * 2
	ld   a, [wActCurSprMapRelId]		; Read relative ID
	sla  a							; Pointer table requirement
	ld   b, a
	; The base ID is packed into just three bits of iActSprMap. (bits3-5)
	; This implies a big limit on the number of mappings actors can normally have.
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
	
	; Flags = byte3 | wTmpCF52
	; Curiously, the base flags are OR'd with ours, compared to the usual way of XOR'ing them.
	; This prevents you from overriding all options.
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [wTmpCF52]
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
	
	; Flags = (byte3 | wTmpCF52) ^ SPR_XFLIP
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [wTmpCF52]
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
	
	call Module_Title		; Wait for response
	jr   z, .toStageSel		; GAME START selected? If so, jump
.toPassword:
	call Module_Password 	; Is the password invalid?
	jr   c, Game_Main		; If so, return to the title screen
	
	; Otherwise, decide where to go to next
	
	; If all 8 bosses are defeated, warp to the pre-Quint room
	ld   a, [wWpnUnlock0]
	cp   WPN_MG|WPN_HA|WPN_NE|WPN_CR|WPN_ME|WPN_WD|WPN_AR|WPN_TP
	jp   z, Game_Main_ToPreQuint
	
	; If any, but not all, of the second set of bosses is defeated,
	; warp to the teleport room
	ld   a, [wWpnUnlock0]
	and  WPN_MG|WPN_HA|WPN_NE|WPN_TP
	jr   nz, Game_Main_ToTeleport
	
	; If the first set of bosses is defeated, but noone in the second,
	; warp to the Wily Castle cutscene.
	ld   a, [wWpnUnlock0]
	cp   WPN_CR|WPN_ME|WPN_WD|WPN_AR
	jr   z, Game_Main_ToWilyCastle
	
.toStageSel:
	call Module_StageSel
	
	; Prepare for gameplay.
	
	; Start from the actual first room.
	; Room ID $00, by convention, is kept completely empty.
	ld   a, $01
	ld   [wLvlRoomId], a
	
	; Load everything
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	
L0026AC:;R
	call L0027C9
	cp   $02
	jr   z, L0026CC
	call L002862
	jr   c, L0026AC
	ld   a, [wGameOverSel]
	bit  1, a
	jr   z, Game_Main.toStageSel
	ld   a, $01
	ld   [wLvlRoomId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	jr   L0026AC
L0026CC:;R
	call L00299F
	call L002A6F
	call L002FAA
	call L014F69 ; BANK $01
	call Pl_RefillAllWpn
	ld   a, [wWpnUnlock0]
	and  $1E
	cp   $1E
	jr   nz, Game_Main.toStageSel
Game_Main_ToWilyCastle:;X
	call L003156
	call L003174
	call StartLCDOperation
	ld   a, $10
	ldh  [hBGMSet], a
	call FlashBGPalLong
	ld   a, $01
	ld   [wLvlRoomId], a
	ld   a, $08
	ld   [wLvlId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	call L0031BE
	call L0032C6
	jr   L00271F
Game_Main_ToTeleport:;R
	ld   a, $03
	ld   [wLvlRoomId], a
	ld   a, $08
	ld   [wLvlId], a
	call Module_Game_InitScrOff
	call L0032C6
	call Module_Game_InitScrOn
L00271F:;R
	call L0027C9
	cp   $02
	jr   z, L00273F
	call L002862
	jr   c, L00271F
	ld   a, [wGameOverSel]
	bit  1, a
	jr   z, Game_Main_ToTeleport
	ld   a, $01
	ld   [wLvlRoomId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	jr   L00271F
L00273F:;R
	call L00299F
	call L002A6F
	call L002FAA
	call L014F69 ; BANK $01
	ld   a, [wWpnUnlock0]
	cp   $FF
	jr   nz, Game_Main_ToTeleport
Game_Main_ToPreQuint:;X
	ld   a, $04
	ld   [wLvlRoomId], a
	ld   a, $08
	ld   [wLvlId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	call L0027C9
	cp   $02
	jr   z, L002782
L002769: db $CD;X
L00276A: db $62;X
L00276B: db $28;X
L00276C: db $38;X
L00276D: db $F4;X
L00276E: db $FA;X
L00276F: db $6E;X
L002770: db $CF;X
L002771: db $CB;X
L002772: db $4F;X
L002773: db $28;X
L002774: db $DD;X
L002775: db $3E;X
L002776: db $04;X
L002777: db $EA;X
L002778: db $0B;X
L002779: db $CF;X
L00277A: db $CD;X
L00277B: db $C7;X
L00277C: db $2A;X
L00277D: db $CD;X
L00277E: db $DE;X
L00277F: db $2A;X
L002780: db $18;X
L002781: db $E0;X
L002782:;R
	call L002FAA
L002785:;R
	call L01521F ; BANK $01
	ld   a, $01
	ld   [wLvlRoomId], a
	ld   a, $09
	ld   [wLvlId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
L002798:;R
	ld   hl, wWpnUnlock1
	set  3, [hl]
	call L0027C9
	cp   $02
	jr   z, L0027BD
	call L002862
	jr   c, L002798
	ld   a, [wGameOverSel]
	bit  1, a
	jr   z, L002785
	ld   a, $01
	ld   [wLvlRoomId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	jr   L002798
L0027BD:;R
	call L00299F
	call L01551D ; BANK $01
	call L015827 ; BANK $01
L0027C6: db $C3;X
L0027C7: db $C6;X
L0027C8: db $27;X
L0027C9:;JCR
	rst  $08 ; Wait Frame
	
	; Alternate between the two palettes.
	; This uses hBGPAnim0 for 5 frames, hBGPAnim1 for 3 frames, then it loops.
	ld   hl, hBGPAnim0	; HL = Ptr to 1st pal
	ldh  a, [hTimer]
	and  $07
	cp   $05			; (hTimer & 8) < 5?
	jr   c, .setPalAnim	; If so, keep 1st pal
	inc  hl				; Otherwise, switch to 2nd pal
.setPalAnim:
	ld   a, [hl]		; Read the palette
	ldh  [hBGP], a		; Save it
L0027D9:;R
	call JoyKeys_Refresh
	ldh  a, [hJoyNewKeys]
	bit  3, a
	jr   z, L0027EA
	call Ev_WaitAll
	call L00375C
	jr   L0027C9
L0027EA:;R
	bit  2, a
	jr   z, L0027F8
	ldh  a, [hInvulnCheat]
	or   a
	jr   z, L0027F8
L0027F3: db $CD;X
L0027F4: db $EC;X
L0027F5: db $51;X
L0027F6: db $18;X
L0027F7: db $D1;X
L0027F8:;R
	xor  a
	ldh  [hWorkOAMPos], a
	ldh  a, [hTimer]
	ld   [wUnk_FrameStartTimer], a
	call L000CB0
	call L00354A
	call L0143B4 ; BANK $01
	push af
	ld   a, BANK(L024000) ; BANK $02
	ldh  [hRomBankLast], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L024000
	push af
	ld   a, $01
	ldh  [hRomBankLast], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call OAM_ClearRest
	ld   hl, hTimer
	ld   a, [wUnk_FrameStartTimer]
	cp   [hl]
	jr   nz, L0027D9
	call L002AF3
	ld   a, [wLvlEnd]
	or   a
	jr   z, L0027C9
	push af
	call L0017D2
	call L0039EF
	xor  a
	ld   [wActCurSprFlags], a
	ld   [wLvlWater], a
	ld   [wActScrollX], a
	pop  af
	cp   $03
	ret  c
	swap a
	dec  a
	and  $03
	ld   [wLvlId], a
	ld   a, $01
	ld   [wLvlRoomId], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	jp   L0027C9
L002862:;C
	xor  a
	ld   [wPlHealthInc], a
	ld   [wWpnAmmoInc], a
	ld   [wPlHealthBar], a
	ld   hl, wStatusBarRedraw
	set  0, [hl]
	ld   b, $B4
L002873:;R
	push bc
	ld   a, b
	cp   $B4
	jr   z, L00287F
	cp   $5A
	jr   z, L002887
	jr   L002896
L00287F:;R
	ld   a, $00
	ldh  [hBGMSet], a
	ld   a, $06
	ldh  [hSFXSet], a
L002887:;R
	ld   a, [wExplodeOrgX]
	ld   [wActSpawnX], a
	ld   a, [wExplodeOrgY]
	ld   [wActSpawnY], a
	call ActS_SpawnLargeExpl
L002896:;R
	rst  $08 ; Wait Frame
	xor  a
	ldh  [hWorkOAMPos], a
	call L0143B4 ; BANK $01
	push af
	ld   a, BANK(L024000) ; BANK $02
	ldh  [hRomBankLast], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L024000
	push af
	ld   a, $01
	ldh  [hRomBankLast], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call OAM_ClearRest
	call L002AF3
	pop  bc
	dec  b
	jr   nz, L002873
	ld   a, [wPlLives]
	sub  $01
	ld   [wPlLives], a
	jr   c, L00292C
	ld   a, [wLvlId]
	add  a
	add  a
	or   $03
	ld   hl, $3C42
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   b, $00
	ld   a, [wLvlColL]
L0028DD:;R
	cp   $0A
	jr   c, L0028E6
	inc  b
	sub  $0A
	jr   L0028DD
L0028E6:;R
	ld   a, b
	cp   [hl]
	jr   nc, L002908
	dec  hl
	cp   [hl]
	jr   nc, L0028F3
	dec  hl
	cp   [hl]
	jr   nc, L0028F3
	dec  hl
L0028F3:;R
	ld   a, [hl]
	ld   [wLvlRoomId], a
	ld   a, $01
	ld   [wPlRespawn], a
	call Module_Game_InitScrOff
	call Module_Game_InitScrOn
	xor  a
	ld   [wPlRespawn], a
	scf  
	ret
L002908:;R
	ld   a, [hl]
	ld   [wLvlRoomId], a
	ld   a, $01
	ld   [wPlRespawn], a
	call Module_Game_InitScrOff
	ld   b, $10
L002916:;R
	push bc
	call L000DD7
	pop  bc
	dec  b
	jr   nz, L002916
	call Module_Game_InitScrOn
	ld   a, $01
	ld   [wNoScroll], a
	xor  a
	ld   [wPlRespawn], a
	scf  
	ret
L00292C:;R
	ld   a, $04
	ldh  [hBGMSet], a
	call L014F69 ; BANK $01
	call Pl_ResetLivesAndWpnAmmo
	ld   a, GFXSET_GAMEOVER
	call GFXSet_Load
	ld   de, $2953
	call LoadTilemapDef
	call StartLCDOperation
L002944:;R
	rst  $08 ; Wait Frame
	call JoyKeys_Refresh
	ldh  a, [hJoyNewKeys]
	and  $03
	jr   z, L002944
	ld   [wGameOverSel], a
	xor  a
	ret
L002953: db $98
L002954: db $44
L002955: db $0C
L002956: db $20
L002957: db $47
L002958: db $41
L002959: db $4D
L00295A: db $45
L00295B: db $20
L00295C: db $20
L00295D: db $4F
L00295E: db $56
L00295F: db $45
L002960: db $52
L002961: db $20
L002962: db $98
L002963: db $C4
L002964: db $0C
L002965: db $20
L002966: db $20
L002967: db $41
L002968: db $20
L002969: db $42
L00296A: db $55
L00296B: db $54
L00296C: db $54
L00296D: db $4F
L00296E: db $4E
L00296F: db $20
L002970: db $20
L002971: db $99
L002972: db $04
L002973: db $0C
L002974: db $53
L002975: db $54
L002976: db $41
L002977: db $47
L002978: db $45
L002979: db $20
L00297A: db $53
L00297B: db $45
L00297C: db $4C
L00297D: db $45
L00297E: db $43
L00297F: db $54
L002980: db $99
L002981: db $84
L002982: db $0C
L002983: db $20
L002984: db $20
L002985: db $42
L002986: db $20
L002987: db $42
L002988: db $55
L002989: db $54
L00298A: db $54
L00298B: db $4F
L00298C: db $4E
L00298D: db $20
L00298E: db $20
L00298F: db $99
L002990: db $C4
L002991: db $0C
L002992: db $20
L002993: db $20
L002994: db $43
L002995: db $4F
L002996: db $4E
L002997: db $54
L002998: db $49
L002999: db $4E
L00299A: db $55
L00299B: db $45
L00299C: db $20
L00299D: db $20
L00299E: db $00
L00299F:;C
	xor  a
	ldh  [hJoyKeys], a
	ldh  [hJoyNewKeys], a
	ld   [wPlMode], a
	ld   [wBossHealthBar], a
	ld   hl, wStatusBarRedraw
	set  2, [hl]
	dec  a
	ld   [wCF5D_Unk_ActTargetSlot], a
	ld   [wCF4A_Unk_ActTargetSlot], a
	ld   [wCF6B_Unk_ActCurSlotPtrCopy], a
	ld   [wCF6A_Unk_ActTargetSlot], a
	call L002A81
	ld   a, $00
	ldh  [hBGMSet], a
	ld   b, $C0
L0029C5:;R
	ld   a, b
	push bc
	and  $3F
	jr   nz, L0029DE
	ld   a, $06
	ldh  [hSFXSet], a
	ld   a, [wExplodeOrgX]
	ld   [wActSpawnX], a
	ld   a, [wExplodeOrgY]
	ld   [wActSpawnY], a
	call ActS_SpawnLargeExpl
L0029DE:;R
	call L002A97
	pop  bc
	dec  b
	jr   nz, L0029C5
	ld   a, $06
	ldh  [hBGMSet], a
	ld   b, $78
	call L002A90
L0029EE:;R
	ld   b, $10
	ld   a, [wPlRelX]
	cp   $58
	jr   z, L002A03
	jr   c, L0029FB
	ld   b, $20
L0029FB:;R
	ld   a, b
	ldh  [hJoyKeys], a
	call L002A97
	jr   L0029EE
L002A03:;R
	ld   a, $02
	ld   [wPlMode], a
	ld   a, $03
	ld   [wPlSpdYSub], a
	ld   a, $80
	ld   [wPlSpdY], a
	xor  a
	ldh  [hJoyKeys], a
	ldh  [hJoyNewKeys], a
L002A17:;R
	call L002A97
	ld   a, [wPlMode]
	cp   $03
	jr   nz, L002A17
	ld   a, $0F
	ld   [wPlMode], a
	ld   b, $B4
L002A28:;R
	ld   a, b
	push bc
	cp   $B4
	jr   z, L002A44
	cp   $96
	jr   z, L002A4D
	cp   $78
	jr   z, L002A44
	cp   $5A
	jr   z, L002A4D
	cp   $3C
	jr   z, L002A44
	cp   $1E
	jr   z, L002A4D
	jr   L002A50
L002A44:;R
	call ActS_SpawnAbsorb
	ld   a, $0F
	ldh  [hSFXSet], a
	jr   L002A50
L002A4D:;R
	call L002A81
L002A50:;R
	call L002A97
	pop  bc
	dec  b
	jr   nz, L002A28
	ld   a, $03
	ld   [wPlMode], a
L002A5C:;R
	call L002A97
	ld   a, [wPlMode]
	or   a
	jr   nz, L002A5C
	ld   a, $15
	ld   [wPlMode], a
	ld   b, $78
	jp   L002A90
L002A6F:;C
	ld   a, [wLvlId]
	ld   hl, $3C1A
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [wWpnUnlock0]
	or   [hl]
	ld   [wWpnUnlock0], a
	ret
L002A81:;C
	ld   bc, $1000
	ld   de, $0010
	ld   hl, wAct
L002A8A:;R
	ld   [hl], c
	add  hl, de
	dec  b
	jr   nz, L002A8A
	ret
L002A90:;JCR
	call L002A97
	dec  b
	jr   nz, L002A90
	ret
L002A97:;C
	push hl
	push de
	push bc
	rst  $08 ; Wait Frame
	xor  a
	ldh  [hWorkOAMPos], a
	call L000CB0
	call L0143B4 ; BANK $01
	push af
	ld   a, BANK(L024000); BANK $02
	ldh  [hRomBankLast], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L024000
	push af
	ld   a, $01
	ldh  [hRomBankLast], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call OAM_ClearRest
	call L002AF3
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
	ldh  [hBGMSet], a
	ret
	
L002AF3:;C
	ld   a, [wGameTimeSub]
	inc  a
	ld   [wGameTimeSub], a
	cp   $3C
	jr   nz, L002B06
	xor  a
	ld   [wGameTimeSub], a
	ld   hl, wGameTime
	inc  [hl]
L002B06:;R
	xor  a
	ld   hl, wLvlScrollEvMode
	or   [hl]
	ld   hl, wTilemapEv
	or   [hl]
	ret  nz
	ld   a, [wPlHealthInc]
	or   a
	jr   z, L002B3B
	dec  a
	ld   [wPlHealthInc], a
	ld   a, [wPlHealth]
	ld   c, a
	inc  a
	cp   $98
	jr   c, L002B25
	ld   a, $98
L002B25:;R
	ld   b, a
	ld   [wPlHealth], a
	xor  c
	and  $08
	jr   z, L002B3B
	ld   a, b
	ld   [wPlHealthBar], a
	ld   hl, wStatusBarRedraw
	set  0, [hl]
	ld   a, $07
	ldh  [hSFXSet], a
L002B3B:;R
	ld   a, [wWpnAmmoInc]
	or   a
	jr   z, L002B6A
	dec  a
	ld   [wWpnAmmoInc], a
	ld   a, [wWpnSel]
	or   a
	ret  z
	ld   a, [wWpnAmmoCur]
	ld   c, a
	inc  a
	cp   $98
	jr   c, L002B55
	ld   a, $98
L002B55:;R
	ld   b, a
	ld   [wWpnAmmoCur], a
	xor  c
	and  $08
	ret  z
	ld   a, b
	ld   [wWpnAmmoBar], a
	ld   hl, wStatusBarRedraw
	set  1, [hl]
	ld   a, $07
	ldh  [hSFXSet], a
L002B6A:;R
	ld   a, [wStatusBarRedraw]
	ld   b, a
	ld   hl, wPlHealthBar
	ld   c, $00
	ldi  a, [hl]
	bit  0, b
	call nz, Game_AddBarDrawEv
	inc  c
	ldi  a, [hl]
	bit  1, b
	call nz, Game_AddBarDrawEv
	inc  c
	ldi  a, [hl]
	bit  2, b
	call nz, Game_AddBarDrawEv
	ld   a, [hl]
	bit  3, b
	call nz, Game_AddLivesDrawEv
	ld   a, b
	or   a
	ret  z
	xor  a
	ld   [wStatusBarRedraw], a
	inc  a
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
	ldh  [hBGMSet], a
	
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
	ldh  [hSFXSet], a
	jr   .changeSel
.sel:
	; [POI] Disable the invulnerability cheat.
	;       Curiously, this address wasn't reset at boot, it only gets written to here.
	;       Presumably you could hold something to enable the cheat mode here?
	xor  a
	ldh  [hInvulnCheat], a
	
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
	ldh  [hBGMSet], a
	
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
	; B = StageSel_LvlBitTbl[wLvlId]
	ld   hl, StageSel_LvlBitTbl
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
	ldh  [hSFXSet], a
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
	ldh  [hSFXSet], a
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
StageSel_CursorCrash:
	db $18,$18,$3F,$00
	db $40,$18,$3F,$00
	db $18,$40,$3F,$00
	db $40,$40,$3F,$00
StageSel_CursorMetal:
	db $18,$68,$3F,$00
	db $40,$68,$3F,$00
	db $18,$90,$3F,$00
	db $40,$90,$3F,$00
StageSel_CursorWood:
	db $68,$18,$3F,$00
	db $90,$18,$3F,$00
	db $68,$40,$3F,$00
	db $90,$40,$3F,$00
StageSel_CursorAir:
	db $68,$68,$3F,$00
	db $90,$68,$3F,$00
	db $68,$90,$3F,$00
	db $90,$90,$3F,$00
	
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
	ldh  [hBGMSet], a
	
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
	ld   hl, GFX_GameOverFont	; Source GFX ptr
	ld   de, $9400				; VRAM Destination ptr
	ld   bc, (BANK(GFX_GameOverFont) << 8) | $20 ; BANK $0B | Number of tiles to copy
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
		ld   [wActCurSprMapRelId], a
		
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
	ldh  [hActCur+iActTimer0C], a
	
	; Next mode
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_JumpUp ===============
; RTN $01
; Jump arc - upwards movement.
Act_StageSelBoss_JumpUp:
	; iActTimer0C--
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	
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
	; iActTimer0C--
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
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
	ldh  [hActCur+iActTimer0C], a
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_WaitAnim ===============
; RTN $04
; Delay while the two halves are closing back.
Act_StageSelBoss_WaitAnim:

	; Wait for those 32 frames
	ldh  a, [hActCur+iActTimer0C]
	sub  $01
	ldh  [hActCur+iActTimer0C], a
	ret  nz
	
	; Set up the intro animation.
	; Every single intro uses the two same sprite mapping IDs.
	ld   de, ($00 << 8)|$02
	ld   c, $1E
	call Act_Boss_InitIntro
	
	jp   ActS_IncRtnId
	
; =============== Act_StageSelBoss_IntroAnim ===============
; RTN $05
; Performs the boss' animation while the starfield scrolls.
Act_StageSelBoss_IntroAnim:
	call Starfield_Do
	call Act_Boss_PlayIntro		; Is it done?
	ret  z						; If not, return
								
	ld   a, $00					; Restore 1st frame
	ld   [wActCurSprMapRelId], a
	
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
SETCHARMAP bossname
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
	
L002FAA:;C
	ld   a, GFXSET_GETWPN
	call GFXSet_Load
	push af
	ld   a, $04
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   de, $5180
	call LoadTilemapDef
	push af
	ldh  a, [hRomBankLast]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call StartLCDOperation
	ld   a, $07
	ldh  [hBGMSet], a
	ld   b, $60
	ld   hl, hScrollX
L002FD3:;R
	inc  [hl]
	ld   a, $04
	call WaitFrames
	dec  b
	jr   nz, L002FD3
	ld   a, $3C
	call WaitFrames
	ld   hl, $305A
	ld   de, $98CC
	call L00300A
	ld   a, [wLvlId]
	add  a
	ld   hl, $3063
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	ld   l, e
	ld   h, d
	ld   de, $98EC
	call L00300A
	ld   a, $B4
	call WaitFrames
	ld   a, $78
	jp   WaitFrames
L00300A:;C
	ld   a, e
	ld   [wGetWpnDestPtr_Low], a
	ld   a, d
	ld   [wGetWpnDestPtr_High], a
L003012:;R
	ldi  a, [hl]
	ld   b, a
	cp   $2E
	ret  z
	cp   $20
	jr   z, L003052
	cp   $2F
	jr   nz, L003033
	ld   a, [wGetWpnDestPtr_Low]
	add  $20
	ld   [wGetWpnDestPtr_Low], a
	ld   e, a
	ld   a, [wGetWpnDestPtr_High]
	adc  $00
	ld   [wGetWpnDestPtr_High], a
	ld   d, a
	jr   L003012
L003033:;R
	ld   a, d
	ld   [wScrEvRows], a
	ld   a, e
	ld   [$DD01], a
	ld   a, $01
	ld   [wTilemapBuf+iTilemapDefOpt], a
	ld   a, b
	or   $80
	ld   [wTilemapBuf+iTilemapDefPayload], a
	xor  a
	ld   [$DD04], a
	inc  a
	ld   [wTilemapEv], a
	ld   a, $0B
	ldh  [hSFXSet], a
L003052:;R
	ld   a, $06
	call WaitFrames
	inc  de
	jr   L003012
L00305A: db $20
L00305B: db $59
L00305C: db $4F
L00305D: db $55
L00305E: db $20
L00305F: db $47
L003060: db $4F
L003061: db $54
L003062: db $2E
L003063: db $75
L003064: db $30
L003065: db $87
L003066: db $30
L003067: db $95
L003068: db $30
L003069: db $A9
L00306A: db $30
L00306B: db $BC
L00306C: db $30
L00306D: db $DF
L00306E: db $30
L00306F: db $04
L003070: db $31
L003071: db $15
L003072: db $31
L003073: db $38
L003074: db $31
L003075: db $20
L003076: db $20
L003077: db $48
L003078: db $41
L003079: db $52
L00307A: db $44
L00307B: db $2F
L00307C: db $20
L00307D: db $20
L00307E: db $20
L00307F: db $4B
L003080: db $4E
L003081: db $55
L003082: db $43
L003083: db $4B
L003084: db $4C
L003085: db $45
L003086: db $2E
L003087: db $20
L003088: db $20
L003089: db $54
L00308A: db $4F
L00308B: db $50
L00308C: db $2F
L00308D: db $20
L00308E: db $20
L00308F: db $20
L003090: db $53
L003091: db $50
L003092: db $49
L003093: db $4E
L003094: db $2E
L003095: db $20
L003096: db $20
L003097: db $4D
L003098: db $41
L003099: db $47
L00309A: db $4E
L00309B: db $45
L00309C: db $54
L00309D: db $2F
L00309E: db $20
L00309F: db $20
L0030A0: db $20
L0030A1: db $4D
L0030A2: db $49
L0030A3: db $53
L0030A4: db $53
L0030A5: db $49
L0030A6: db $4C
L0030A7: db $45
L0030A8: db $2E
L0030A9: db $20
L0030AA: db $20
L0030AB: db $4E
L0030AC: db $45
L0030AD: db $45
L0030AE: db $44
L0030AF: db $4C
L0030B0: db $45
L0030B1: db $2F
L0030B2: db $20
L0030B3: db $20
L0030B4: db $20
L0030B5: db $43
L0030B6: db $41
L0030B7: db $4E
L0030B8: db $4E
L0030B9: db $4F
L0030BA: db $4E
L0030BB: db $2E
L0030BC: db $20
L0030BD: db $20
L0030BE: db $43
L0030BF: db $4C
L0030C0: db $41
L0030C1: db $53
L0030C2: db $48
L0030C3: db $2F
L0030C4: db $20
L0030C5: db $20
L0030C6: db $20
L0030C7: db $42
L0030C8: db $4F
L0030C9: db $4D
L0030CA: db $42
L0030CB: db $2F
L0030CC: db $2F
L0030CD: db $20
L0030CE: db $20
L0030CF: db $20
L0030D0: db $41
L0030D1: db $4E
L0030D2: db $44
L0030D3: db $2F
L0030D4: db $20
L0030D5: db $52
L0030D6: db $55
L0030D7: db $53
L0030D8: db $48
L0030D9: db $20
L0030DA: db $43
L0030DB: db $4F
L0030DC: db $49
L0030DD: db $4C
L0030DE: db $2E
L0030DF: db $20
L0030E0: db $20
L0030E1: db $4D
L0030E2: db $45
L0030E3: db $54
L0030E4: db $41
L0030E5: db $4C
L0030E6: db $2F
L0030E7: db $20
L0030E8: db $20
L0030E9: db $20
L0030EA: db $42
L0030EB: db $4C
L0030EC: db $41
L0030ED: db $44
L0030EE: db $45
L0030EF: db $2F
L0030F0: db $2F
L0030F1: db $20
L0030F2: db $20
L0030F3: db $20
L0030F4: db $41
L0030F5: db $4E
L0030F6: db $44
L0030F7: db $2F
L0030F8: db $52
L0030F9: db $55
L0030FA: db $53
L0030FB: db $48
L0030FC: db $20
L0030FD: db $4D
L0030FE: db $41
L0030FF: db $52
L003100: db $49
L003101: db $4E
L003102: db $45
L003103: db $2E
L003104: db $20
L003105: db $20
L003106: db $4C
L003107: db $45
L003108: db $41
L003109: db $46
L00310A: db $2F
L00310B: db $20
L00310C: db $20
L00310D: db $20
L00310E: db $53
L00310F: db $48
L003110: db $49
L003111: db $45
L003112: db $4C
L003113: db $44
L003114: db $2E
L003115: db $20
L003116: db $20
L003117: db $41
L003118: db $49
L003119: db $52
L00311A: db $2F
L00311B: db $20
L00311C: db $20
L00311D: db $20
L00311E: db $53
L00311F: db $48
L003120: db $4F
L003121: db $4F
L003122: db $54
L003123: db $45
L003124: db $52
L003125: db $2F
L003126: db $2F
L003127: db $20
L003128: db $20
L003129: db $20
L00312A: db $41
L00312B: db $4E
L00312C: db $44
L00312D: db $2F
L00312E: db $20
L00312F: db $52
L003130: db $55
L003131: db $53
L003132: db $48
L003133: db $20
L003134: db $4A
L003135: db $45
L003136: db $54
L003137: db $2E
L003138: db $20
L003139: db $20
L00313A: db $51
L00313B: db $55
L00313C: db $49
L00313D: db $4E
L00313E: db $54
L00313F: db $2F
L003140: db $20
L003141: db $20
L003142: db $20
L003143: db $49
L003144: db $54
L003145: db $45
L003146: db $4D
L003147: db $2F
L003148: db $2F
L003149: db $2F
L00314A: db $20
L00314B: db $20
L00314C: db $53
L00314D: db $41
L00314E: db $4B
L00314F: db $55
L003150: db $47
L003151: db $41
L003152: db $52
L003153: db $4E
L003154: db $45
L003155: db $2E
L003156:;C
	ld   a, GFXSET_CASTLE
	call GFXSet_Load
	push af
	ld   a, $04
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   de, $53C0
	call LoadTilemapDef
	push af
	ldh  a, [hRomBankLast]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L003174:;C
	ld   hl, $3180
	ld   de, wWorkOAM
	ld   bc, $0020
	jp   CopyMemory
L003180: db $70
L003181: db $80
L003182: db $30
L003183: db $00
L003184: db $70
L003185: db $88
L003186: db $31
L003187: db $00
L003188: db $78
L003189: db $80
L00318A: db $40
L00318B: db $00
L00318C: db $78
L00318D: db $88
L00318E: db $41
L00318F: db $00
L003190: db $80
L003191: db $80
L003192: db $6B
L003193: db $00
L003194: db $80
L003195: db $88
L003196: db $6C
L003197: db $00
L003198: db $88
L003199: db $80
L00319A: db $7B
L00319B: db $00
L00319C: db $88
L00319D: db $88
L00319E: db $7C
L00319F: db $00
L0031A0:;C
	ld   a, GFXSET_STATION
	call GFXSet_Load
	push af
	ld   a, $04
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   de, $5540
	call LoadTilemapDef
	push af
	ldh  a, [hRomBankLast]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L0031BE:;C
	xor  a
	ldh  [hJoyNewKeys], a
	ldh  [hJoyKeys], a
L0031C3:;R
	call L002A97
	ld   a, [wPlMode]
	or   a
	jr   nz, L0031C3
	ld   b, $3C
	call L002A90
	ld   b, $06
L0031D3:;R
	push bc
	ld   b, $1E
	call L002A90
	ld   a, [wPlDirH]
	xor  $01
	ld   [wPlDirH], a
	pop  bc
	dec  b
	jr   nz, L0031D3
	ld   a, $20
	ldh  [hJoyKeys], a
	ld   b, $50
	call L002A90
	xor  a
	ldh  [hJoyKeys], a
L0031F1:;R
	call L002A97
	ld   a, [wPlMode]
	or   a
	jr   nz, L0031F1
	ld   a, $01
	ld   [wPlDirH], a
	ld   b, $B4
	call L002A90
	ld   b, $02
L003206:;R
	push bc
	xor  a
	ldh  [hJoyKeys], a
	ld   [wUnk_CF79_FlipTimer], a
	ld   b, $80
L00320F:;R
	call L00329F
	call L002A97
	dec  b
	jr   nz, L00320F
	ld   a, $10
	ldh  [hJoyKeys], a
	ld   b, $10
	call L002A90
	xor  a
	ldh  [hJoyKeys], a
	ld   b, $1E
	call L002A90
	pop  bc
	dec  b
	jr   nz, L003206
	ld   a, $10
	ldh  [hJoyKeys], a
L003231:;R
	call L00329F
	call L002A97
	ld   a, [wPlRelX]
	cp   $50
	jr   c, L003231
	ld   a, $0F
	ld   [wPlMode], a
	ld   hl, $4F00
	ld   de, $8500
	ld   bc, $0B08
	call GfxCopy_Req
	rst  $20 ; Wait GFX load
	ld   a, $7B
	ld   [wActSpawnId], a
	xor  a
	ld   [wActSpawnLayoutPtr], a
	ld   a, $88
	ld   [wActSpawnY], a
	ld   a, $50
	ld   [wActSpawnX], a
	call ActS_Spawn
	ld   b, $0F
	call L002A90
	ld   a, $60
	ld   [wActSpawnX], a
	call ActS_Spawn
	ld   b, $0F
	call L002A90
	ld   a, $58
	ld   [wActSpawnX], a
	call ActS_Spawn
	ld   b, $3C
	call L002A90
	ld   hl, $32B7
	ld   de, wScrEvRows
	ld   bc, $000F
	call CopyMemory
	ld   a, $01
	ld   [wTilemapEv], a
	xor  a
	ld   [wPlMode], a
	ld   b, $08
	jp   L002A90
L00329F:;C
	ld   a, [wUnk_CF79_FlipTimer]
	and  $07
	jr   nz, L0032B2
	ld   h, $CD
	ld   l, $02
	ld   a, [hl]
	xor  $08
	ld   [hl], a
	inc  l
	inc  l
	inc  l
	inc  [hl]
L0032B2:;R
	ld   hl, wUnk_CF79_FlipTimer
	inc  [hl]
	ret
L0032B7: db $9B
L0032B8: db $C8
L0032B9: db $04
L0032BA: db $18
L0032BB: db $19
L0032BC: db $18
L0032BD: db $19
L0032BE: db $9B
L0032BF: db $E8
L0032C0: db $04
L0032C1: db $28
L0032C2: db $29
L0032C3: db $28
L0032C4: db $29
L0032C5: db $00
L0032C6:;C
	ld   b, $00
	ld   a, [wWpnUnlock0]
	and  $40
	call nz, L0032EF
	ld   b, $01
	ld   a, [wWpnUnlock0]
	and  $01
	call nz, L0032EF
	ld   b, $02
	ld   a, [wWpnUnlock0]
	and  $80
	call nz, L0032EF
	ld   b, $03
	ld   a, [wWpnUnlock0]
	and  $20
	call nz, L0032EF
	ret
L0032EF:;C
	ld   a, b
	add  a
	ld   hl, $3321
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	ld   b, $06
	ld   hl, $3329
L003300:;R
	push hl
	push de
	push bc
	ld   c, [hl]
	ld   hl, wScrEvRows
	ld   [hl], d
	inc  hl
	ld   [hl], e
	inc  hl
	ld   a, $C4
	ldi  [hl], a
	ld   a, c
	ldi  [hl], a
	xor  a
	ld   [hl], a
	ld   de, wScrEvRows
	call LoadTilemapDef
	pop  bc
	pop  de
	inc  de
	pop  hl
	inc  hl
	dec  b
	jr   nz, L003300
	ret
L003321: db $40
L003322: db $98
L003323: db $4E
L003324: db $98
L003325: db $40
L003326: db $99
L003327: db $4E;X
L003328: db $99;X
L003329: db $2A
L00332A: db $72
L00332B: db $0D
L00332C: db $0E
L00332D: db $0F
L00332E: db $2F

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
L003384:;C
	xor  a
L003385:;R
	ld   d, $CD
	ld   e, a
	ld   [wActCurSlotPtr], a
	ld   a, [de]
	or   a
	jr   z, L0033CF
	and  $7F
	ld   [wTmpColiActId], a
	ld   h, $CE
	ld   l, e
	ld   a, e
	add  $05
	ld   e, a
	ld   a, [$CFEC]
	ld   c, a
	ldh  a, [hActCur+iActX]
	ld   b, a
	ld   a, [de]
	ld   [wActSpawnX], a
	sub  b
	jr   nc, L0033AD
	xor  $FF
	inc  a
	scf  
L0033AD:;R
	ld   b, a
	ldi  a, [hl]
	add  c
	cp   b
	jr   c, L0033CF
	ld   a, [$CFED]
	ld   c, a
	ldh  a, [hActCur+iActY]
	ld   b, a
	inc  e
	inc  e
	ld   a, [de]
	sub  [hl]
	ld   [wActSpawnY], a
	sub  b
	jr   nc, L0033C8
	xor  $FF
	inc  a
	scf  
L0033C8:;R
	ld   b, a
	ldi  a, [hl]
	add  c
	cp   b
	call nc, L0033D7
L0033CF:;R
	ld   a, [wActCurSlotPtr]
	add  $10
	jr   nz, L003385
	ret
L0033D7:;C
	ldi  a, [hl]
	cp   $02
	ret  c
	jr   z, L0033F1
	cp   $03
	jp   z, L003508
	cp   $08
	ret  c
	ld   b, a
	ld   a, [wActSpawnY]
	add  b
	ld   b, a
	ldh  a, [hActCur+iActY]
	cp   b
	jp   nc, L003508
L0033F1:;R
	inc  l
	inc  l
	ldd  a, [hl]
	or   a
	ret  nz
	push hl
	ld   a, [wWpnSel]
	cp   $0C
	jr   nz, L003406
	ld   a, [wWpnSGRide]
	or   a
	jr   z, L00340A
	ld   a, $0C
L003406:;R
	sub  $03
	jr   nc, L00340B
L00340A:;X
	xor  a
L00340B:;R
	ld   e, a
	ld   a, [wTmpColiActId]
	ld   c, a
	swap a
	and  $0F
	ld   b, a
	ld   a, c
	swap a
	and  $F0
	or   $06
	add  e
	ld   c, a
	ld   hl, $4000
	add  hl, bc
	push af
	ld   a, $03
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   a, [hl]
	ld   [wWpnActDmg], a
	push af
	ldh  a, [hRomBankLast]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	pop  hl
	ld   a, [wWpnActDmg]
	or   a
	jp   z, L003508
	ld   b, a
	ld   a, e
	cp   $09
	jr   nz, L003455
	ld   a, $00
	ld   [wPlSpdY], a
	ld   a, $02
	ld   [wPlSpdYSub], a
	ld   a, $02
	ld   [wPlMode], a
L003455:;R
	ld   a, [hl]
	sub  b
	jr   z, L00349F
	jr   c, L00349F
	ldi  [hl], a
	ld   [wBossHealth], a
	push hl
	ld   a, [wWpnPierceLvl]
	cp   $02
	jr   nc, L00346A
	xor  a
	ldh  [hActCur+iActId], a
L00346A:;R
	ld   a, [wWpnSel]
	cp   $04
	call z, L003A0B
	pop  hl
	ld   [hl], $0C
	ld   a, $03
	ldh  [hSFXSet], a
	ld   a, [wBossDmgEna]
	or   a
	ret  z
	ld   a, [wTmpColiActId]
	cp   $50
	ret  c
	cp   $54
	jr   c, L00348E
	cp   $68
	ret  c
	cp   $70
	ret  nc
L00348E:;R
	ld   [hl], $1E
	ld   a, [wBossHealth]
	add  a
	add  a
	add  a
	ld   [wBossHealthBar], a
	ld   hl, wStatusBarRedraw
	set  2, [hl]
	ret
L00349F:;R
	ld   a, [wWpnPierceLvl]
	cp   $01
	jr   nc, L0034A9
	xor  a
	ldh  [hActCur+iActId], a
L0034A9:;R
	ld   a, [wWpnSel]
	cp   $04
	call z, L003A0B
	ld   h, $CD
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ld   a, $80
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ld   h, $CE
	ld   a, [wActCurSlotPtr]
	ld   l, a
	inc  l
	inc  l
	xor  a
	ld   [hl], a
	ld   a, [wBossDmgEna]
	or   a
	jp   z, L001E25
	ld   a, [wTmpColiActId]
	cp   $50
	ret  c
	cp   $54
	jr   c, L0034DE
	cp   $68
	ret  c
	cp   $70
	ret  nc
L0034DE:;R
	ld   a, [wLvlEnd]
	cp   $01
	jr   z, L0034FE
	ld   h, $CD
	ld   a, [wActCurSlotPtr]
	add  $05
	ld   l, a
	ld   a, [hl]
	ld   [wExplodeOrgX], a
	inc  l
	inc  l
	ld   a, [hl]
	sub  $0C
	ld   [wExplodeOrgY], a
	ld   a, $02
	ld   [wLvlEnd], a
L0034FE:;X
	xor  a
	ld   [wBossHealthBar], a
	ld   hl, wStatusBarRedraw
	set  2, [hl]
	ret
L003508:;J
	ld   a, [wWpnSel]
	cp   $04
	jr   nz, L003514
	ld   a, $05
	ldh  [hSFXSet], a
	ret
L003514:;R
	cp   $08
	jr   nz, L003522
	ldh  a, [hActCur+iActRtnId]
	bit  7, a
	ret  nz
	ld   a, $80
	ldh  [hActCur+iActRtnId], a
	ret
L003522:;R
	ld   a, [wWpnSGRide]
	or   a
	jr   z, L00353C
	ld   a, $00
	ld   [wPlSpdY], a
	ld   a, $02
	ld   [wPlSpdYSub], a
	ld   a, $02
	ld   [wPlMode], a
	ld   a, $05
	ldh  [hSFXSet], a
	ret
L00353C:;R
	xor  a
	ldh  [hActCur+iActRtnId], a
	ldh  a, [hActCur+iActLayoutPtr]
	or   $80
	ldh  [hActCur+iActLayoutPtr], a
	ld   a, $05
	ldh  [hSFXSet], a
	ret
; =============== Pl_DoActColi ===============
; Checks for player collision against all actors.
L00354A:;C
	ld   a, [wCF6B_Unk_ActCurSlotPtrCopy]
	ld   [wPl_Unk_ActCurSlotPtrCopyOfCopy], a
	ld   a, $FF
	ld   [wCF5D_Unk_ActTargetSlot], a
	ld   [wCF4A_Unk_ActTargetSlot], a
	ld   [wCF6B_Unk_ActCurSlotPtrCopy], a
	ld   [wCF6A_Unk_ActTargetSlot], a
	ld   b, $0C
	ld   a, [wPlMode]
	cp   $10
	jr   nz, L003569
	srl  b
L003569:;R
	ld   a, b
	ld   [wPlColiBoxV], a
	ld   a, [wPlRelY]
	sub  b
	ld   [wPlCenterY], a
	xor  a
L003575:;R
	ld   d, $CD
	ld   e, a
	ld   [wActCurSlotPtr], a
	ld   a, [de]
	or   a
	jr   z, L0035B3
	ld   h, $CE
	ld   l, e
	ld   a, e
	add  $05
	ld   e, a
	ld   a, [wPlRelX]
	ld   b, a
	ld   a, [de]
	sub  b
	jr   nc, L003592
	xor  $FF
	inc  a
	scf  
L003592:;R
	ld   b, a
	ldi  a, [hl]
	add  $07
	cp   b
	jr   c, L0035B3
	inc  e
	inc  e
	ld   a, [wPlColiBoxV]
	ld   c, a
	ld   a, [wPlCenterY]
	ld   b, a
	ld   a, [de]
	sub  [hl]
	sub  b
	jr   nc, L0035AC
	xor  $FF
	inc  a
	scf  
L0035AC:;R
	ld   b, a
	ldi  a, [hl]
	add  c
	cp   b
	call nc, L0035BB
L0035B3:;R
	ld   a, [wActCurSlotPtr]
	add  $10
	jr   nz, L003575
	ret
L0035BB:;C
	ldi  a, [hl]
	or   a
	ret  z
	bit  7, a
	jr   nz, L0035C6
	cp   $04
	jr   nc, L003624
L0035C6:;R
	ldh  a, [hInvulnCheat]
	or   a
	ret  nz
	ld   a, [wPlInvulnTimer]
	or   a
	ret  nz
	ld   a, [wActCurSlotPtr]
	ld   [wCF5D_Unk_ActTargetSlot], a
	ld   a, $13
	ldh  [hSFXSet], a
	ld   a, $20
	ld   [wPlHurtTimer], a
	ld   a, $3C
	ld   [wPlInvulnTimer], a
	ld   a, [wPlMode]
	cp   $10
	jr   z, L0035F2
	cp   $11
	jr   z, L0035F2
	xor  a
	ld   [wPlMode], a
L0035F2:;R
	ld   h, $CE
	ld   a, [wActCurSlotPtr]
	add  $03
	ld   l, a
	ld   a, [wPlHealth]
	sub  [hl]
	jr   nc, L003601
	xor  a
L003601:;R
	push af
	ld   [wPlHealth], a
	ld   [wPlHealthBar], a
	ld   hl, wStatusBarRedraw
	set  0, [hl]
	pop  af
	or   a
	ret  nz
	ld   a, [wPlRelX]
	ld   [wExplodeOrgX], a
	ld   a, [wPlRelY]
	sub  $0C
	ld   [wExplodeOrgY], a
	ld   a, $01
	ld   [wLvlEnd], a
	ret
L003624:;R
	cp   $04
	jp   nz, L0036D9
	ldd  a, [hl]
	or   a
	jr   nz, L003636
	ld   a, [wPl_Unk_ActCurSlotPtrCopyOfCopy]
	cp   $FF
	ret  nz
	jp   L003689
L003636:;R
	cp   $01
	jr   nz, L003656
	ld   a, [wPl_Unk_ActCurSlotPtrCopyOfCopy]
	cp   $FF
	ret  nz
	call L003689
	ldh  a, [hTimer]
	swap a
	and  $01
	ld   [wPlDirH], a
	rrca 
	ld   bc, $0080
	call L0018B9
	jp   L0018FE
L003656:;R
	ld   b, a
	ld   a, [wWpnItemWarp]
	cp   $FF
	ret  nz
	ld   a, b
	cp   $04
	jr   nz, L00367C
	call L003689
	jr   nc, L00367C
	ld   a, [wActCurSlotPtr]
	ld   [wCF6B_Unk_ActCurSlotPtrCopy], a
	ld   hl, wPlRelY
	ldh  a, [hJoyKeys]
	rla  
	jr   nc, L003678
	inc  [hl]
	jr   L00367C
L003678:;R
	rla  
	jr   nc, L00367C
	dec  [hl]
L00367C:;R
	ld   a, [wPlMode]
	cp   $03
	ret  nz
	ld   a, [wActCurSlotPtr]
	ld   [wCF6A_Unk_ActTargetSlot], a
	ret
L003689:;JC
	dec  l
	ld   a, [hl]
	ld   [wTmpCF52], a
	ld   b, a
	ld   a, [de]
	ld   [wTmpCF53], a
	sub  b
	ld   b, a
	ld   a, [wPlRelY]
	cp   b
	ret  nc
	ld   a, [wPlMode]
	cp   $04
	ret  nc
	ld   a, [wPlRelY]
	inc  a
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $21
	ret  nc
	ld   a, [wPlRelX]
	add  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   $21
	ret  nc
	ld   a, [wTmpCF52]
	ld   b, a
	ld   a, [wTmpCF53]
	sub  b
	sub  b
	inc  a
	inc  a
	ld   [wPlRelY], a
	ld   a, [wActCurSlotPtr]
	ld   [wCF4A_Unk_ActTargetSlot], a
	scf  
	ret
L0036D9:;J
	cp   $05
	jr   nz, L0036E5
	ld   a, $80
	ld   bc, $0080
	jp   L0018B9
L0036E5:;R
	cp   $06
	ret  nz
	ld   h, $CD
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ld   a, [hl]
	and  $07
	push af
	xor  a
	ld   [hl], a
	inc  l
	inc  l
	inc  l
	ld   a, [hl]
	or   a
	jr   z, L003700
	ld   l, a
	ld   h, $DC
	ld   [hl], $80
L003700:;R
	pop  af
	rst  $00 ; DynJump
L003702: db $5B;X
L003703: db $37;X
L003704: db $12
L003705: db $37
L003706: db $29
L003707: db $37
L003708: db $3B
L003709: db $37
L00370A: db $44
L00370B: db $37
L00370C: db $32
L00370D: db $37
L00370E: db $4D
L00370F: db $37
L003710: db $5B;X
L003711: db $37;X
L003712:;I
	ld   a, [wPlLives]
	cp   $09
	ret  nc
	inc  a
	ld   [wPlLives], a
	ld   [wPlLivesView], a
	ld   hl, wStatusBarRedraw
	set  3, [hl]
	ld   a, $09
	ldh  [hSFXSet], a
	ret
L003729:;I
	ld   a, [wWpnAmmoInc]
	add  $48
	ld   [wWpnAmmoInc], a
	ret
L003732:;I
	ld   a, [wWpnAmmoInc]
	add  $18
	ld   [wWpnAmmoInc], a
	ret
L00373B:;I
	ld   a, [wPlHealthInc]
	add  $48
	ld   [wPlHealthInc], a
	ret
L003744:;I
	ld   a, [wPlHealthInc]
	add  $18
	ld   [wPlHealthInc], a
	ret
L00374D:;I
	ld   a, [wETanks]
	cp   $04
	ret  nc
	inc  a
	ld   [wETanks], a
	ld   a, $08
	ldh  [hSFXSet], a
	ret
L00375C:;C
	call L0039EF
	ld   a, [wWpnSel]
	push af
	ld   hl, wPlHealth
	ld   de, wScrEvRows
	ld   c, $00
	ldi  a, [hl]
	call L003AD9
	ld   a, [wWpnUnlock1]
	ld   b, a
	ld   a, $03
L003775:;R
	push af
	inc  c
	ldi  a, [hl]
	srl  b
	call c, L003AD9
	pop  af
	dec  a
	jr   nz, L003775
	rst  $10 ; Wait tilemap load
	ld   de, wScrEvRows
	ld   a, [wWpnUnlock0]
	or   a
	jr   z, L00379B
	ld   b, a
	ld   a, $08
L00378E:;R
	push af
	inc  c
	ldi  a, [hl]
	srl  b
	call c, L003AD9
	pop  af
	dec  a
	jr   nz, L00378E
	rst  $10 ; Wait tilemap load
L00379B:;R
	ld   de, wScrEvRows
	ld   a, [wWpnUnlock1]
	and  $08
	jr   z, L0037AD
	ld   a, [wWpnAmmoSG]
	ld   c, $0C
	call L003AD9
L0037AD:;R
	ld   hl, $3B5F
	call CopyWord
	ld   a, $07
	ld   [de], a
	inc  de
	call CopyWord
	ld   a, [wETanks]
	ld   c, a
	ld   a, $05
	sub  c
	ld   b, a
	ld   a, $70
L0037C4:;R
	ld   [de], a
	inc  de
	dec  b
	jr   nz, L0037C4
	ld   a, c
	or   a
	jr   z, L0037D4
	ld   a, $98
L0037CF:;R
	ld   [de], a
	inc  de
	dec  c
	jr   nz, L0037CF
L0037D4:;R
	xor  a
	ld   [de], a
	rst  $10 ; Wait tilemap load
	xor  a
	ldh  [hWorkOAMPos], a
	ld   a, [wPlMode]
	cp   $11
	jr   z, L0037EA
	ld   a, [wWpnSGRide]
	or   a
	jr   nz, L0037EA
	call L001AE9
L0037EA:;R
	call OAM_ClearRest
	ld   bc, $0A20
	ld   hl, $7800
	ld   de, $8800
	call GfxCopy_Req
	ld   a, $0C
	ldh  [hSFXSet], a
	ld   b, $10
	ldh  a, [hLYC]
L003801:;R
	sub  $08
	ldh  [hLYC], a
	ldh  [hWinY], a
	rst  $08 ; Wait Frame
	dec  b
	jr   nz, L003801
L00380B:;JR
	call L003B63
	ldh  a, [hJoyNewKeys]
	and  $F9
	jr   z, L00380B
	and  $09
	ld   a, [wWpnSel]
	jr   nz, L00385D
	ldh  a, [hJoyNewKeys]
	rla  
	jr   c, L00382F
	rla  
	jr   c, L003846
	ld   a, [wWpnSel]
	xor  $01
	call L003BA2
	jr   c, L00385D
	jr   L003832
L00382F:;R
	ld   a, [wWpnSel]
L003832:;R
	ld   b, $06
L003834:;R
	add  $02
	cp   $0E
	jr   c, L00383C
	sub  $0E
L00383C:;R
	call L003BA2
	jr   c, L00385D
	dec  b
	jr   nz, L003834
	jr   L00380B
L003846:;R
	ld   a, [wWpnSel]
	ld   b, $06
L00384B:;R
	sub  $02
	cp   $0E
	jr   c, L003853
	add  $0E
L003853:;R
	call L003BA2
	jr   c, L00385D
	dec  b
	jr   nz, L00384B
	jr   L00380B
L00385D:;R
	push af
	ld   a, [wWpnSel]
	add  a
	add  a
	ld   hl, $3B2B
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   de, wScrEvRows
	call CopyWord
	ld   a, $02
	ld   [de], a
	inc  de
	call CopyWord
	xor  a
	ld   [de], a
	rst  $10 ; Wait tilemap load
	pop  af
	ld   [wWpnSel], a
	ldh  a, [hJoyNewKeys]
	and  $09
	jr   nz, L003886
	jr   L00380B
L003886:;R
	ld   a, [wWpnSel]
	cp   $0D
	jr   c, L0038E0
	ld   a, [wETanks]
	or   a
	jp   z, L00380B
	ld   a, [wPlHealth]
	cp   $98
	jp   nc, L00380B
	ld   a, [wETanks]
	dec  a
	ld   [wETanks], a
	ld   b, a
	ld   hl, wScrEvRows
	ld   a, $9D
	ldi  [hl], a
	ld   a, $F1
	sub  b
	ldi  [hl], a
	ld   a, $01
	ldi  [hl], a
	ld   a, $70
	ldi  [hl], a
	xor  a
	ld   [hl], a
	rst  $10 ; Wait tilemap load
	ld   a, [wPlHealth]
L0038BA:;R
	add  $08
	cp   $98
	jr   c, L0038C2
	ld   a, $98
L0038C2:;R
	ld   [wPlHealth], a
	ld   c, $00
	call Game_AddBarDrawEv
	rst  $18 ; Wait bar update
	ld   de, wScrEvRows
	call L003AD9
	rst  $10 ; Wait tilemap load
	ld   a, $07
	ldh  [hSFXSet], a
	ld   a, [wPlHealth]
	cp   $98
	jr   c, L0038BA
	jp   L00380B
L0038E0:;R
	ld   a, [wWpnSel]
	add  a
	add  a
	ld   hl, $3B2D
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   de, $9600
	call L00397C
	ld   a, [hl]
	ld   de, $9610
	call L00397C
	ld   a, [wWpnSel]
	or   a
	jr   z, L00390B
	ld   hl, wPlHealth
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [wWpnAmmoCur], a
L00390B:;R
	xor  a
	ld   [wBarQueuePos], a
	ld   a, [wWpnSel]
	or   a
	ld   a, [wWpnAmmoCur]
	jr   nz, L00391A
	ld   a, $FF
L00391A:;R
	ld   c, $01
	call Game_AddBarDrawEv
	rst  $18 ; Wait bar update
	ld   hl, wStatusBarRedraw
	res  1, [hl]
	ld   a, [wWpnSel]
	ld   b, a
	pop  af
	cp   b
	jr   z, L003933
	call L0039A0
	call L0039C2
L003933:;R
	ld   a, [wWpnSel]
	ld   b, a
	ld   a, [wWpnSGRide]
	add  b
	ld   hl, $3992
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   h, [hl]
	ld   l, $00
	ld   de, $8500
	ld   bc, $0B10
	call GfxCopy_Req
	ld   a, $0D
	ldh  [hSFXSet], a
	ld   b, $10
	ldh  a, [hLYC]
L003956:;R
	add  $08
	ldh  [hLYC], a
	ldh  [hWinY], a
	rst  $08 ; Wait Frame
	dec  b
	jr   nz, L003956
	ld   a, [wActGfxId]
	ld   hl, ActS_GFXSetTbl
	sla  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   b, [hl]
	ld   c, $20
	inc  hl
	ld   a, [hl]
	ld   h, a
	ld   l, $00
	ld   de, $8800
	call GfxCopy_Req
	rst  $20 ; Wait GFX load
	ret
L00397C:;C
	push hl
	swap a
	ld   l, a
	and  $07
	or   $78
	ld   h, a
	ld   a, l
	and  $F0
	ld   l, a
	ld   bc, $0A01
	call GfxCopy_Req
	rst  $20 ; Wait GFX load
	pop  hl
	ret
L003992: db $45
L003993: db $48
L003994: db $49
L003995: db $4A
L003996: db $4B
L003997: db $4E
L003998: db $48
L003999: db $4F
L00399A: db $4D
L00399B: db $4F
L00399C: db $48
L00399D: db $4E
L00399E: db $4D
L00399F: db $4C
L0039A0:;C
	ld   a, [wPlMode]
	cp   $11
	jr   nz, L0039AB
	xor  a
	ld   [wPlMode], a
L0039AB:;R
	xor  a
	ld   [wShot0], a
	ld   [wShot1], a
	ld   [wShot2], a
	ld   [wShot3], a
	ld   [wWpnNePos], a
	ld   [wWpnTpActive], a
	ld   [wWpnSGRide], a
	ret
L0039C2:;C
	ld   hl, wAct
L0039C5:;R
	ld   a, [hl]
	cp   $E0
	jr   c, L0039E7
	cp   $E4
	jr   nc, L0039E7
	ld   a, [wWpnItemWarp]
	cp   $06
	jr   z, L0039ED
	cp   $07
	jr   z, L0039ED
	cp   $08
	jr   z, L0039ED
	inc  l
	xor  a
	ld   [hl], a
	ld   a, $06
	ld   [wWpnItemWarp], a
	scf  
	ret
L0039E7:;R
	ld   a, l
	add  $10
	ld   l, a
	jr   nz, L0039C5
L0039ED:;R
	xor  a
	ret
L0039EF:;C
	ld   a, [wWpnSel]
	or   a
	ret  z
	ld   hl, wPlHealth
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [wWpnAmmoCur]
	ld   [hl], a
	ret
L003A00:;C
	push bc
	ld   a, [wWpnShotCost]
	ld   b, a
	ld   a, [wWpnAmmoCur]
	cp   b
	pop  bc
	ret
L003A0B:;JC
	push hl
	push bc
	ld   a, [wWpnShotCost]
	ld   b, a
	ld   a, [wWpnAmmoCur]
	sub  b
	jr   c, L003A22
	ld   [wWpnAmmoCur], a
	ld   [wWpnAmmoBar], a
	ld   hl, wStatusBarRedraw
	set  1, [hl]
L003A22:;R
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
		add  b				; Otherwise, draw add the base tile ID
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
	
L003AD9:;C
	push bc
	push hl
	push af
	ld   b, $00
	sla  c
	sla  c
	ld   hl, $3B2B
	add  hl, bc
	call CopyWord
	ld   a, $07
	ld   [de], a
	inc  de
	call CopyWord
	ld   c, $05
	pop  af
	cp   $99
	jr   c, L003AF9
L003AF7: db $3E;X
L003AF8: db $98;X
L003AF9:;R
	add  $07
	srl  a
	srl  a
	srl  a
	push af
	srl  a
	srl  a
	jr   z, L003B11
	ld   b, a
	ld   a, $84
L003B0B:;R
	ld   [de], a
	inc  de
	dec  c
	dec  b
	jr   nz, L003B0B
L003B11:;R
	pop  af
	and  $03
	jr   z, L003B1B
	add  $80
	ld   [de], a
	inc  de
	dec  c
L003B1B:;R
	ld   a, c
	or   a
	jr   z, L003B26
	ld   a, $80
L003B21:;R
	ld   [de], a
	inc  de
	dec  c
	jr   nz, L003B21
L003B26:;R
	xor  a
	ld   [de], a
	pop  hl
	pop  bc
	ret
L003B2B: db $9C
L003B2C: db $62
L003B2D: db $85
L003B2E: db $97
L003B2F: db $9C
L003B30: db $6B
L003B31: db $86
L003B32: db $87
L003B33: db $9C
L003B34: db $A2
L003B35: db $86
L003B36: db $88
L003B37: db $9C
L003B38: db $AB
L003B39: db $86
L003B3A: db $89
L003B3B: db $9C
L003B3C: db $E2
L003B3D: db $91
L003B3E: db $85
L003B3F: db $9C
L003B40: db $EB
L003B41: db $8A
L003B42: db $86
L003B43: db $9D
L003B44: db $22
L003B45: db $92
L003B46: db $8B
L003B47: db $9D
L003B48: db $2B
L003B49: db $88
L003B4A: db $8C
L003B4B: db $9D
L003B4C: db $62
L003B4D: db $87
L003B4E: db $8F
L003B4F: db $9D
L003B50: db $6B
L003B51: db $90
L003B52: db $8C
L003B53: db $9D
L003B54: db $A2
L003B55: db $8E
L003B56: db $8A
L003B57: db $9D
L003B58: db $AB
L003B59: db $88
L003B5A: db $8D
L003B5B: db $9D
L003B5C: db $E2
L003B5D: db $93
L003B5E: db $8D
L003B5F: db $9D
L003B60: db $EB
L003B61: db $8C
L003B62: db $90
L003B63:;C
	ldh  a, [hTimer]
	and  $07
	jr   nz, L003B97
	ld   a, [wWpnSel]
	add  a
	add  a
	ld   hl, $3B2B
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   de, wScrEvRows
	call CopyWord
	ld   a, $02
	ld   [de], a
	inc  de
	ldh  a, [hTimer]
	and  $08
	jr   nz, L003B8B
	ld   a, $70
	ld   [de], a
	inc  de
	jr   L003B8F
L003B8B:;R
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldi  a, [hl]
L003B8F:;R
	ld   [de], a
	inc  de
	xor  a
	ld   [de], a
	rst  $10 ; Wait tilemap load
	jp   JoyKeys_Refresh
L003B97:;R
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
	
L003BA2:;C
	or   a
	jr   nz, L003BA7
	scf  
	ret
L003BA7:;R
	cp   $0D
	jr   nz, L003BAD
	scf  
	ret
L003BAD:;R
	push bc
	ld   c, a
	cp   $0C
	jr   nz, L003BBB
	ld   a, [wWpnUnlock1]
	swap a
	rla  
	jr   L003BCF
L003BBB:;R
	cp   $04
	jr   nc, L003BC5
	ld   b, a
	ld   a, [wWpnUnlock1]
	jr   L003BCB
L003BC5:;R
	sub  $03
	ld   b, a
	ld   a, [wWpnUnlock0]
L003BCB:;R
	rra  
	dec  b
	jr   nz, L003BCB
L003BCF:;R
	ld   a, c
	pop  bc
	ret
	
MACRO mGfxDef2
	db BANK(\1), HIGH(\1)
ENDM
; =============== ActS_GFXSetTbl ===============
; Sets of actor graphics usable during levels.
; These each set has a fixed size of $800 bytes.
ActS_GFXSetTbl:
	mGfxDef2 GFX_Player    ; $00 ; ACTGFX_PLAYER    ; 
	mGfxDef2 GFX_Space1OBJ ; $01 ; ACTGFX_SPACE1    ; [POI] Only loaded manually, not through here
	mGfxDef2 L084000       ; $02 ; ACTGFX_02        ; 
	mGfxDef2 L084800       ; $03 ; ACTGFX_03        ; 
	mGfxDef2 L085000       ; $04 ; ACTGFX_04        ; 
	mGfxDef2 L085800       ; $05 ; ACTGFX_05        ; 
	mGfxDef2 GFX_MagnetMan ; $06 ; ACTGFX_MAGNETMAN ; 
	mGfxDef2 L086800       ; $07 ; ACTGFX_07        ; 
	mGfxDef2 GFX_NeedleMan ; $08 ; ACTGFX_NEEDLEMAN ; 
	mGfxDef2 L087800       ; $09 ; ACTGFX_09        ; 
	mGfxDef2 GFX_CrashMan  ; $0A ; ACTGFX_CRASHMAN  ; 
	mGfxDef2 L094800       ; $0B ; ACTGFX_0B        ; 
	mGfxDef2 GFX_MetalMan  ; $0C ; ACTGFX_METALMAN  ; 
	mGfxDef2 L095800       ; $0D ; ACTGFX_0D        ; 
	mGfxDef2 GFX_WoodMan   ; $0E ; ACTGFX_WOODMAN   ; 
	mGfxDef2 L096800       ; $0F ; ACTGFX_0F        ; 
	mGfxDef2 GFX_AirMan    ; $10 ; ACTGFX_AIRMAN    ; 
	mGfxDef2 L0B6800       ; $11 ; ACTGFX_11        ; 
	mGfxDef2 L0B6800       ; $12 ; ACTGFX_12        ; 
	mGfxDef2 L0B5000       ; $13 ; ACTGFX_13        ; 
	mGfxDef2 GFX_HardMan   ; $14 ; ACTGFX_HARDMAN   ; 
	mGfxDef2 GFX_TopMan    ; $15 ; ACTGFX_TOPMAN    ; 
													; 
; =============== Lvl_GFXSetTbl ===============
; Maps each stage to their graphics.
; These have a fixed size of $500 bytes, as the remaining $300 are taken up by GFX_LvlShared.
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

; =============== StageSel_LvlBitTbl ===============
; Maps each stage to its own completion bit in wWpnUnlock0.
StageSel_LvlBitTbl: 
	db WPN_HA ; LVL_HARD
	db WPN_TP ; LVL_TOP
	db WPN_MG ; LVL_MAGNET
	db WPN_NE ; LVL_NEEDLE
	db WPN_CR ; LVL_CRASH
	db WPN_ME ; LVL_METAL
	db WPN_WD ; LVL_WOOD
	db WPN_AR ; LVL_AIR
	db $00    ; LVL_CASTLE (unselectable)
	db $00    ; LVL_STATION (unselectable)

Lvl_PalTbl: db $E4
L003C25: db $E4
L003C26: db $E4
L003C27: db $E4
L003C28: db $E4
L003C29: db $E4
L003C2A: db $E4
L003C2B: db $E4
L003C2C: db $E4
L003C2D: db $E4
L003C2E: db $E0
L003C2F: db $EC
L003C30: db $E4
L003C31: db $E4
L003C32: db $E1
L003C33: db $E1
L003C34: db $E4
L003C35: db $E4
L003C36: db $E4
L003C37: db $E4

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
	
L003C42: db $01;X
L003C43: db $0B;X
L003C44: db $11;X
L003C45: db $15;X
L003C46: db $01
L003C47: db $0A
L003C48: db $10
L003C49: db $16
L003C4A: db $01
L003C4B: db $07
L003C4C: db $0E
L003C4D: db $16
L003C4E: db $01;X
L003C4F: db $06;X
L003C50: db $11;X
L003C51: db $17
L003C52: db $01;X
L003C53: db $08
L003C54: db $0E
L003C55: db $17
L003C56: db $01
L003C57: db $07
L003C58: db $12
L003C59: db $17
L003C5A: db $01
L003C5B: db $09
L003C5C: db $10
L003C5D: db $15
L003C5E: db $01
L003C5F: db $09
L003C60: db $09
L003C61: db $16
L003C62: db $04;X
L003C63: db $20;X
L003C64: db $20;X
L003C65: db $20;X
L003C66: db $01
L003C67: db $0A
L003C68: db $0A
L003C69: db $16
Lvl_WaterFlagTbl: db $00
L003C6B: db $01
L003C6C: db $00
L003C6D: db $00
L003C6E: db $00
L003C6F: db $00
L003C70: db $01
L003C71: db $00
L003C72: db $00
L003C73: db $01

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