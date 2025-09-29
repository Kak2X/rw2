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
; Not actually defined as an interrupt, but it's closely related to the above.
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
	ldh  a, [hROMBank]
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
		; Don't alter hROMBank to save on some stack usage
		ld   a, BANK(Sound_Do) ; BANK $07
		ld   [MBC1RomBank], a
		call Sound_Do
		ldh  a, [hROMBank]
		ld   [MBC1RomBank], a
	pop  hl
	pop  de
	pop  bc
	pop  af
	reti
	
