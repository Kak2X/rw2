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
;Rst_PkgEv_RunSync:
	jp   PkgEv_RunSync
	mIncJunk "L000013"
; =============== RESET VECTOR $18 ===============
SECTION "Rst18", ROM0[$0018]
;Rst_PkgBarEv_RunSync:
	jp   PkgBarEv_RunSync
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
EntryPoint:;J
	di   
	xor  a
	ldh  [rIE], a
	ldh  a, [rLCDC]
	set  7, a
	ldh  [rLCDC], a
L00015A:;R
	ldh  a, [rLY]
	cp   $91
	jr   nz, L00015A
	xor  a
	ldh  [rLCDC], a
	ld   sp, $E000
	xor  a
	ld   hl, $C000
	ld   bc, MBC1RomBank
L00016D:;R
	ldi  [hl], a
	dec  c
	jr   nz, L00016D
	dec  b
	jr   nz, L00016D
	ld   bc, $7880
L000177:;R
	ldh  [c], a
	inc  c
	dec  b
	jr   nz, L000177
	ld   a, $55
	ld   hl, $FFFA
	cp   a, [hl]
	jr   z, L00018E
	ld   [hl], a
	xor  a
	ldh  [$FFFB], a
	ldh  [$FFFC], a
	ldh  [$FFFD], a
	ldh  [$FFFE], a
L00018E:;X
	push af
	ld   a, $01
	ldh  [$FF9D], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   c, $80
	ld   b, $0A
	ld   hl, $01C7
L0001A0:;R
	ldi  a, [hl]
	ldh  [c], a
	inc  c
	dec  b
	jr   nz, L0001A0
	call L0006C2
	xor  a
	ldh  [rSC], a
	ldh  [rIF], a
	ld   a, $05
	ldh  [rIE], a
	ld   a, $C3
	ldh  [rLCDC], a
	ld   a, STAT_LYC
	ldh  [rSTAT], a
	xor  a
	ldh  [rTIMA], a
	ldh  [rTMA], a
	ld   a, $04
	ldh  [rTAC], a
	ei   
	jp   L00266D
L0001C7: db $3E
L0001C8: db $DF
L0001C9: db $E0
L0001CA: db $46
L0001CB: db $3E
L0001CC: db $28
L0001CD: db $3D
L0001CE: db $20
L0001CF: db $FD
L0001D0: db $C9

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
	
; =============== PkgEv_RunSync ===============
; Triggers the tilemap packet write event, and waits in a loop until it has been processed.
; This and the following subroutines all involve VBlank events, so they may wait multiple frames for them to return.
PkgEv_RunSync:
	push af
		ld   a, $01
		ld   [wPkgEv], a
	.wait:
		rst  $08
		ld   a, [wPkgEv]
		or   a
		jr   nz, .wait
	pop  af
	ret

; =============== PkgBarEv_RunSync ===============
; Triggers the tilemap life/weapon bar redraw event, and waits in a loop until it has been processed.
PkgBarEv_RunSync:
	push af
		ld   a, $01
		ld   [wPkgBarEv], a
	.wait:
		rst  $08
		ld   a, [wPkgBarEv]
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
		rst  $08
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
	ld   hl, wPkgEv
	or   [hl]
	ld   hl, wPkgBarEv
	or   [hl]
	ld   hl, wShutterEvMode
	or   [hl]
	ld   hl, wGfxEvSrcBank
	or   [hl]
	ret  z
	; Otherwise, keep wasting frames
	rst  $08
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
	jr   z, .chkPkg					; If not, jump
	
	bit  SCREVB_SCROLLV, a			; Doing vertical scrolling? 
	jr   z, .scrollH				; If not, jump
.scrollV:
	call ScrEv_LvlScrollV
	jp   VBlankHandler_UpdateScreen
.scrollH:
	call ScrEv_LvlScrollH
	jp   VBlankHandler_UpdateScreen
	
.chkPkg:
	;
	; TILEMAP PACKET WRITE, generic.
	; Instant.
	;
	ld   a, [wPkgEv]
	or   a							; Enabled?
	jr   z, .chkBarPkg				; If not, jump
	
	ld   de, wPkgBuf
	call Scr_ApplyPkg
	
	xor  a
	ld   [wPkgEv], a
	jp   VBlankHandler_UpdateScreen
	
.chkBarPkg:
	;
	; TILEMAP PACKET WRITE, for redrawing the large life/weapon bars.
	; Instant.
	;
	ld   a, [wPkgBarEv]
	or   a							; Enabled?
	jr   z, .chkShut				; If not, jump
	
	ld   de, wPkgBarBuf
	call Scr_ApplyPkg
	
	xor  a
	ld   [wBarDrawQueued], a		; Signal out there's no bar to draw
	ld   [wPkgBarEv], a
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
	sbc  a, $00
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
	adc  a, $00
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
	; Code that needs to poll for inputs must manually call JoyKeys_Sync to sync those values.

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
	
L0003CC:;C
	push af
	call L00065F
	rst  $08
	call L0006D9
	pop  af
	push af
	add  a
	add  a
	ld   hl, $03EF
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ldh  [hBGP], a
	ldi  a, [hl]
	ldh  [hOBP0], a
	ldi  a, [hl]
	ldh  [hOBP1], a
	pop  af
	call L000413
	jp   L000682
L0003EF: db $E4
L0003F0: db $E4
L0003F1: db $E4
L0003F2: db $00;X
L0003F3: db $E4
L0003F4: db $1C
L0003F5: db $C4
L0003F6: db $00;X
L0003F7: db $E4
L0003F8: db $1C
L0003F9: db $C4
L0003FA: db $00;X
L0003FB: db $E4
L0003FC: db $1C
L0003FD: db $C4
L0003FE: db $00;X
L0003FF: db $E4
L000400: db $E4
L000401: db $E4
L000402: db $00;X
L000403: db $E4
L000404: db $1C
L000405: db $E4
L000406: db $00;X
L000407: db $E4
L000408: db $1C
L000409: db $E4
L00040A: db $00;X
L00040B: db $E4
L00040C: db $E4
L00040D: db $E4
L00040E: db $00;X
L00040F: db $1B
L000410: db $1C
L000411: db $E4
L000412: db $00;X
L000413:;C
	rst  $00
L000414: db $26
L000415: db $04
L000416: db $51
L000417: db $04
L000418: db $7C
L000419: db $04
L00041A: db $B0
L00041B: db $04
L00041C: db $08
L00041D: db $05
L00041E: db $3C
L00041F: db $05
L000420: db $67
L000421: db $05
L000422: db $86
L000423: db $05
L000424: db $D2
L000425: db $05
L000426:;I
	push af
	ld   a, $0A
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $7280
	ld   de, $8000
	ld   bc, $0080
	call L0006B9
	ld   hl, $6800
	ld   de, $9000
	ld   bc, $0800
	call L0006B9
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L000451:;I
	push af
	ld   a, $0A
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $7000
	ld   de, $8000
	ld   bc, $0800
	call L0006B9
	ld   hl, $7000
	ld   de, $9000
	ld   bc, $0800
	call L0006B9
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L00047C:;I
	push af
	ld   a, $0A
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $7000
	ld   de, $9000
	ld   bc, $0300
	call L0006B9
	push af
	ld   a, $09
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $7800
	ld   de, $9400
	ld   bc, $0200
	call L0006B9
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L0004B0:;I
	ld   hl, ActS_GFXReqTbl
	push af
	ldi  a, [hl]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   a, [hl]
	ld   h, a
	ld   l, $00
	ld   de, $8000
	ld   bc, $0800
	call L0006B9
	ld   hl, $3BFE
	ld   a, [$CF0A]
	sla  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	push af
	ldi  a, [hl]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   a, [hl]
	ld   h, a
	ld   l, $00
	ld   de, $9000
	ld   bc, $0500
	call L0006B9
	push af
	ld   a, $0A
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $7A00
	ld   de, $9500
	ld   bc, $0300
	call L0006B9
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L000508:;I
	push af
	ld   a, $0B
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $5800
	ld   de, $9000
	ld   bc, $0800
	call L0006B9
	push af
	ld   a, $09
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $7800
	ld   de, $8C00
	ld   bc, $0200
	call L0006B9
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L00053C:;I
	push af
	ld   a, $0C
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $6800
	ld   de, $8000
	ld   bc, $0800
	call L0006B9
	ld   hl, $4000
	ld   de, $8800
	ld   bc, $1000
	call L0006B9
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L000567:;I
	push af
	ld   a, $0C
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $5000
	ld   de, $8800
	ld   bc, $1000
	call L0006B9
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L000586:;I
	push af
	ld   a, $0B
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $7C00
	ld   de, $8400
	ld   bc, $0200
	call L0006B9
	ld   hl, $7C00
	ld   de, $9400
	ld   bc, $0200
	call L0006B9
	push af
	ld   a, $0A
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $7E00
	ld   de, $8600
	ld   bc, $0200
	call L0006B9
	ld   hl, $7E00
	ld   de, $9600
	ld   bc, $0200
	call L0006B9
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L0005D2:;I
	push af
	ld   a, $0B
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $4800
	ld   de, $8800
	ld   bc, $0800
	call L0006B9
	push af
	ld   a, $0C
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, $6800
	ld   de, $8000
	ld   bc, $0800
	call L0006B9
	ld   hl, $6000
	ld   de, $9000
	ld   bc, $0800
	call L0006B9
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L000612:;C
	ld   b, $08
L000614:;R
	ld   a, $D8
	ldh  [hBGP], a
	rst  $08
	rst  $08
	ld   a, $E4
	ldh  [hBGP], a
	rst  $08
	rst  $08
	dec  b
	jr   nz, L000614
	ret
L000624:;C
	ld   c, $09
L000626:;R
	ld   b, $3C
L000628:;R
	push bc
	ldh  a, [hTimer]
	and  $03
	jr   nz, L00063D
	ld   b, $E4
	call L000755
	cp   $20
	jr   nc, L00063A
	ld   b, $C0
L00063A:;R
	ld   a, b
	ldh  [hBGP], a
L00063D:;R
	rst  $08
	pop  bc
	dec  b
	jr   nz, L000628
	dec  c
	jr   nz, L000626
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
	
L00065F:;C
	ld   hl, $DF00
	ld   bc, $00A0
	jr   L00067A
L000667:;C
	ldh  a, [$FF97]
	cp   $A0
	ret  z
	ld   l, a
	ld   h, $DF
L00066F:;R
	xor  a
	ldi  [hl], a
	inc  l
	inc  l
	inc  l
	ld   a, l
	cp   $A0
	jr   c, L00066F
	ret
L00067A:;JCR
	xor  a
	ldi  [hl], a
	dec  bc
	ld   a, b
	or   c
	jr   nz, L00067A
	ret
L000682:;J
	call L0006C2
	ld   de, $9000
	ld   c, $00
L00068A:;R
	ld   a, [de]
	or   a
	jr   nz, L0006A8
	ld   l, e
	ld   h, d
	ld   b, $10
L000692:;R
	ldi  a, [hl]
	or   a
	jr   nz, L0006A8
	dec  b
	jr   nz, L000692
	ld   e, c
L00069A:;R
	ld   hl, $9800
	ld   bc, $0800
L0006A0:;R
	ld   a, e
	ldi  [hl], a
	dec  bc
	ld   a, b
	or   c
	jr   nz, L0006A0
	ret
L0006A8:;R
	inc  c
	ld   a, e
	add  $10
	ld   e, a
	ld   a, d
	adc  a, $00
	ld   d, a
	cp   $98
	jr   nz, L00068A
	ld   e, $80
	jr   L00069A
L0006B9:;JCR
	ldi  a, [hl]
	ld   [de], a
	inc  de
	dec  bc
	ld   a, b
	or   c
	jr   nz, L0006B9
	ret
L0006C2:;C
	ld   a, $FF
	ldh  [hWinY], a
	ldh  [hWinX], a
	ldh  [hLYC], a
	ldh  [hScrollX2], a
	xor  a
	ldh  [hScrollX], a
	ldh  [hScrollY], a
	ret
L0006D2:;C
	ldh  a, [rLCDC]
	or   $80
	ldh  [rLCDC], a
	ret
L0006D9:;C
	ldh  a, [rIE]
	ldh  [$FF8C], a
	res  0, a
	ldh  [rIE], a
L0006E1:;R
	ldh  a, [rLY]
	cp   $91
	jr   nz, L0006E1
	ldh  a, [rLCDC]
	res  7, a
	ldh  [rLCDC], a
	ldh  a, [$FF8C]
	ldh  [rIE], a
	ret
	
; =============== Scr_ApplyPkg ===============
; Applies a list of packets/update requests to the tilemap.
; IN
; - DE: Ptr to multiple packets stored in sequence, terminated by a null byte.
Scr_ApplyPkg:
	
	; A null byte marks the end of the packet list
	ld   a, [de]
	or   a
	ret  z
	
	; bytes0-1: Destination pointer
	ld   h, a
	inc  de
	ld   a, [de]
	ld   l, a
	inc  de
	
	; byte2: Number of bytes to write (capped to $3F)
	ld   a, [de]
	and  $3F
	ld   b, a
	
	; byte3: Writing mode (in upper two bits)
	; Determines the following:
	; - Writing direction (right or down)
	; - If <byte2> bytes should be copied from src to dest, or if a single byte from src should be repeated <byte2> times.
	; To simplify the if/else chain, these will be >> 6'd to the bottom
	ld   a, [de]
	inc  de
	rlca
	rlca 
	and  $03			; Filter out other bits
	
	;
	; Which writing mode are we using?
	;
.chkModeMR:
	; PKG_MVRIGHT, PKG_NOREPEAT
	jr   nz, .chkModeRR	; Mode == 0? If not, jump
.loop0:
	ld   a, [de]		; A = Byte from src
	ldi  [hl], a		; Write to dest, seek ptr right
	inc  de				; SrcPtr++
	dec  b				; Are we done?
	jr   nz, .loop0		; If not, loop
	jr   Scr_ApplyPkg	; Otherwise, process the next packet
	
.chkModeRR:
	; PKG_MVRIGHT, PKG_REPEAT
	dec  a				; Mode == 1?
	jr   nz, .chkModeMD	; If not, jump
	ld   a, [de]		; A = Single byte from src to repeat
	inc  de				; SrcPtr++
.loop1:
	ldi  [hl], a		; Write to dest, seek ptr right
	dec  b				; Are we done?
	jr   nz, .loop1		; If not, loop
	jr   Scr_ApplyPkg	; Otherwise, process the next packet
	
.chkModeMD:
	; PKG_MVDOWN, PKG_NOREPEAT
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
	jr   Scr_ApplyPkg	; Otherwise, process the next packet
	
.chkMode3:
	; PKG_MVDOWN, PKG_REPEAT
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
	jr   Scr_ApplyPkg	; Next packet
	
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
	rst  $08
	dec  a
	jr   nz, WaitFrames
	ret
	
; =============== JoyKeys_Sync ===============
; Updates the joypad input fieds from the updated polled value.
JoyKeys_Sync:
	ldh  a, [hJoyKeysRaw]	; B = Polled keys the current frame
	ld   b, a
	
	ldh  a, [hJoyKeys]		; A = Previously held keys
	xor  b					; Delete keys held both frames...
	and  b					; ...and keep the new ones only
	ldh  [hJoyNewKeys], a	; Update new keys
	
	ld   a, b				
	ldh  [hJoyKeys], a		; Copy the polled value directly to hJoyKeys
	ret
	
L000755:;C
	push hl
	push de
	push bc
	ld   hl, $FFFB
	ldi  a, [hl]
	or   [hl]
	inc  hl
	or   [hl]
	inc  hl
	or   [hl]
	call z, L00078B
	ld   b, $08
L000766:;R
	ld   hl, $FFFB
	ld   a, [hl]
	sla  a
	sla  a
	sla  a
	xor  [hl]
	sla  a
	sla  a
	ld   hl, $FFFE
	rl   [hl]
	dec  hl
	rl   [hl]
	dec  hl
	rl   [hl]
	dec  hl
	rl   [hl]
	dec  b
	jr   nz, L000766
	ld   a, [hl]
	pop  bc
	pop  de
	pop  hl
	ret
L00078B:;C
	ld   a, $48
	ldh  [$FFFB], a
	ld   a, $49
	ldh  [$FFFC], a
	ld   a, $52
	ldh  [$FFFD], a
	ld   a, $4F
	ldh  [$FFFE], a
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
L0007C6:;C
	push af
	ld   a, $05
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   a, [$CF0A]
	ld   hl, $4000
	ld   b, $00
	sla  a
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   e, a
	ld   a, [hl]
	ld   d, a
	ld   hl, $C000
L0007E2:;R
	ld   a, [de]
	inc  de
	bit  7, a
	jr   nz, L0007EB
	ldi  [hl], a
	jr   L0007F4
L0007EB:;R
	and  $7F
	ld   b, a
	ld   a, [de]
	inc  de
L0007F0:;R
	ldi  [hl], a
	dec  b
	jr   nz, L0007F0
L0007F4:;R
	ld   a, h
	cp   $CA
	jr   c, L0007E2
	ld   a, [$CF7F]
	or   a
	jr   nz, L00080B
	xor  a
	ld   hl, $DC00
	ld   bc, $0100
	call L00067A
	jr   L000818
L00080B:;R
	ld   l, $00
L00080D:;R
	ld   h, $DC
	ld   b, [hl]
	ld   h, $C8
	ld   a, [hl]
	or   b
	ld   [hl], a
	inc  l
	jr   nz, L00080D
L000818:;R
	ld   a, [$CF0A]
	ld   b, a
	ld   c, $00
	ld   hl, $7600
	add  hl, bc
	ld   de, $CA00
	ld   bc, $0100
	call L0006B9
	ld   hl, $0B78
	ld   a, [$CF0A]
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	ld   hl, $4020
	add  hl, de
	ld   e, l
	ld   d, h
	ld   hl, $CB00
	ld   b, $19
L000844:;R
	ld   a, [de]
	rrca 
	rrca 
	and  $80
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, [de]
	rrca 
	and  $80
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	ldi  [hl], a
	inc  de
	dec  b
	jr   nz, L000844
	ld   hl, $0B78
	ld   a, [$CF0A]
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	ld   hl, $4020
	add  hl, de
	ld   de, $CC00
	ld   bc, $0019
	call L0006B9
	ld   hl, $0B78
	ld   a, [$CF0A]
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	ld   hl, $4180
	add  hl, de
	ld   de, wRoomTrsU
	ld   bc, $0019
	call L0006B9
	ld   hl, $0B78
	ld   a, [$CF0A]
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	ld   hl, $4300
	add  hl, de
	ld   de, wRoomTrsD
	ld   bc, $0019
	call L0006B9
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L0008B6:;C
	ld   a, [$CF0A]
	add  a
	ld   hl, $3C24
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ldh  [hBGP], a
	ldh  [$FFB6], a
	ld   a, [hl]
	ldh  [$FFB7], a
	ld   b, $00
	ld   a, [$CF0A]
	cp   $07
	jr   nz, L0008D4
	ld   b, $80
L0008D4:;R
	ld   a, b
	ld   [$CF67], a
	ld   a, [$CF0A]
	ld   hl, $3C6A
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [$CF6F], a
	ld   a, $80
	ldh  [hLYC], a
	ldh  [hWinY], a
	xor  a
	ldh  [hScrollX2], a
	ld   a, $07
	ldh  [hWinX], a
	ret
L0008F4:;C
	ldh  a, [hScrollX]
	sub  $20
	swap a
	and  $0F
	ld   [$CF0D], a
	ldh  a, [hScrollY]
	swap a
	and  $0F
	ld   [wPl_Unk_Alt_Y], a
	ld   hl, $0B98
	ld   a, [wLvlRoomId]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [wLvlColL], a
	dec  a
	dec  a
	ld   hl, $C000
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   d, $00
L000921:;R
	ld   e, $00
L000923:;R
	push hl
	add  hl, de
	push de
	ld   a, [wPl_Unk_Alt_Y]
	add  d
	and  $0F
	ld   d, a
	ld   a, [$CF0D]
	add  e
	and  $0F
	ld   e, a
	ld   a, [hl]
	call ScrEv_DrawLvlBlock
	pop  de
	pop  hl
	inc  e
	ld   a, e
	cp   $0E
	jr   nz, L000923
	inc  d
	ld   a, d
	cp   $08
	jr   nz, L000921
	ld   de, $0BB2
	jp   Scr_ApplyPkg
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
	call L001C56
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	add  $0E
	ld   l, a
	ld   b, $B8
	jp   L001C61
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
	call L001C56
	ldh  a, [hScrEvLvlLayoutPtr_Low]
	sub  $0E
	ld   l, a
	ld   b, $E8
	jp   L001C61
	
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
	
	; Immediately load any new actor graphics, if any
	call ActS_LoadGFXForRoom
	
	; Fall-through

; =============== Game_Unk_CalcCurCol ===============
; Recalculates the column the player is currently on.
Game_Unk_CalcCurCol:

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
	
L000B78: db $00
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
	REPT LVL_ROOMCOUNT
		db ROOM_COLCOUNT * I
		DEF I = I + 1
	ENDR

L000BB2: db $9C
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
L000BED:;C
	xor  a
	ld   [$CFDE], a
	ld   [$CFDD], a
	ld   [$CFE9], a
L000BF7:;C
	ld   a, $02
	ld   [$CFE8], a
L000BFC:;C
	ld   a, $98
	ld   hl, $CFD1
	ld   b, $0C
L000C03:;R
	ldi  [hl], a
	dec  b
	jr   nz, L000C03
	ret
L000C08:;C
	ld   a, $12
	ld   [$CF1D], a
	ld   a, $FF
	ld   [$CF5D], a
	ld   [$CF4A], a
	ld   [$CF6A], a
	ld   [$CF6B], a
	xor  a
	ldh  [hScrollXNybLow], a
	ld   [$CF60], a
	ld   [$CF27], a
	ld   [$CF18], a
	ld   [$CF19], a
	ld   [$CF42], a
	ld   [$CF43], a
	ld   [$CF3A], a
	ld   [$CF45], a
	ld   [$CF44], a
	ld   [$CF49], a
	ld   [$CFDF], a
	ld   [$CFF1], a
	ld   [$CF5E], a
	ld   [$CF5F], a
	ld   [$CF7A], a
	ld   [$CFEA], a
	ld   [$CF6C], a
	ld   [$CF70], a
	ld   a, $98
	ld   [$CFD0], a
	ld   hl, $CFDD
	xor  a
	ld   [hl], a
	ld   a, [$CFDE]
	bit  4, a
	jr   z, L000C67
	set  0, [hl]
L000C67:;R
	bit  3, a
	jr   z, L000C6D
	set  1, [hl]
L000C6D:;R
	bit  1, a
	jr   z, L000C73
	set  2, [hl]
L000C73:;R
	ld   hl, $CC00
	ld   a, [wLvlRoomId]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	and  $03
	ld   hl, $0C98
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [wPlRelX], a
	ld   a, $0F
	ld   [wPlRelY], a
	ld   a, $01
	ld   [wPlDirH], a
	jp   Game_Unk_CalcCurCol
L000C98: db $58
L000C99: db $50
L000C9A: db $60;X
L000C9B: db $58
L000C9C:;C
	ld   a, [$CFD0]
	ld   c, $00
	call L003A25
	ld   a, [$CFE8]
	call L003A9A
	rst  $18
	call ActS_LoadGFXForRoom
	rst  $20
	ret
L000CB0:;C
	xor  a
	ld   [$CF31], a
	ld   [$CF3B], a
	ld   [$CF3C], a
	ld   a, [$CF49]
	or   a
	jp   z, L000DEC
	dec  a
	rst  $00
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
	ld   a, [$CF3A]
	or   a
	call nz, ActS_LoadGFXForRoom
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
	ld   [$CF3F], a
	ld   a, $06
	ld   [$CF40], a
	ld   hl, $CF49
	inc  [hl]
	jp   L000E4C
L000D1A:;I
	ld   a, [$CF3F]
	or   a
	jr   z, L000D27
	dec  a
	ld   [$CF3F], a
	jp   L000E4C
L000D27:;R
	ld   a, [$CF40]
	or   a
	jr   z, L000D42
	dec  a
	ld   [$CF40], a
	ld   a, $06
	ld   [$CF3F], a
	ld   a, $01
	ld   [wShutterEvMode], a
	ld   a, $0A
	ldh  [$FF99], a
	jp   L000E4C
L000D42:;R
	ld   a, $28
	ld   [$CF3F], a
	ld   hl, $CF49
	inc  [hl]
	jp   L000E4C
L000D4E:;I
	ld   hl, $CF3F
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
	ld   [$CF3F], a
	ld   a, $06
	ld   [$CF40], a
	ld   hl, $CF49
	inc  [hl]
	ld   a, $04
	ld   [$CF11], a
	jp   L000E4C
L000D81:;I
	ld   a, [$CF3F]
	or   a
	jr   z, L000D8E
	dec  a
	ld   [$CF3F], a
	jp   L000E4C
L000D8E:;R
	ld   a, [$CF40]
	or   a
	jr   z, L000DA9
	dec  a
	ld   [$CF40], a
	ld   a, $06
	ld   [$CF3F], a
	ld   a, $02
	ld   [wShutterEvMode], a
	ld   a, $0A
	ldh  [$FF99], a
	jp   L000E4C
L000DA9:;R
	ld   b, $30
	ld   a, [$CF3A]
	or   a
	jr   z, L000DB3
	ld   b, $68
L000DB3:;R
	ld   a, b
	ld   [$CF3F], a
	ld   hl, $CF49
	inc  [hl]
	jp   L000E4C
L000DBE:;I
	call L000DD7
	ld   hl, wPlRelX
	dec  [hl]
	ld   hl, $CF3F
	dec  [hl]
	jp   nz, L000E4C
	ld   hl, $CF3A
	inc  [hl]
	xor  a
	ld   [$CF49], a
	jp   L000E4C
L000DD7:;C
	ld   hl, $CF31
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
	ld   a, [$CF6F]
	or   a
	jr   z, L000E34
	ld   a, [$CF1D]
	cp   $09
	jr   c, L000E03
	cp   $0F
	jr   c, L000E34
L000E03:;R
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	ld   a, [wPlRelY]
	sub  $0C
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	cp   $10
	jr   z, L000E1C
	cp   $18
	jr   nz, L000E34
L000E1C:;R
	ld   a, $64
	ld   [$CF2D], a
	xor  a
	ld   [$CF2E], a
	ld   a, [$CF0D]
	ld   [$CF2B], a
	ld   a, [wPl_Unk_Alt_Y]
	ld   [$CF2C], a
	call L001D48
L000E34:;R
	ld   a, [$CF42]
	or   a
	jr   z, L000E40
	dec  a
	ld   [$CF42], a
	jr   L000E51
L000E40:;R
	ld   a, [$CF43]
	or   a
	jr   z, L000E51
	dec  a
	ld   [$CF43], a
	jr   L000E51
L000E4C:;J
	xor  a
	ldh  [hJoyKeys], a
	ldh  [hJoyNewKeys], a
L000E51:;R
	ld   a, [$CF1D]
	rst  $00
L000E55: db $8D
L000E56: db $0E
L000E57: db $68
L000E58: db $10
L000E59: db $7F
L000E5A: db $10
L000E5B: db $6F
L000E5C: db $11
L000E5D: db $A4
L000E5E: db $12
L000E5F: db $8A
L000E60: db $13
L000E61: db $A3
L000E62: db $13
L000E63: db $BA
L000E64: db $13
L000E65: db $D3
L000E66: db $13
L000E67: db $E9
L000E68: db $13
L000E69: db $00
L000E6A: db $14
L000E6B: db $23
L000E6C: db $14
L000E6D: db $39
L000E6E: db $14
L000E6F: db $5C
L000E70: db $14
L000E71: db $73
L000E72: db $14
L000E73: db $96
L000E74: db $14
L000E75: db $99
L000E76: db $14
L000E77: db $16
L000E78: db $15
L000E79: db $9B
L000E7A: db $16
L000E7B: db $AF
L000E7C: db $16
L000E7D: db $07
L000E7E: db $17
L000E7F: db $27
L000E80: db $17
L000E81: db $38
L000E82: db $17
L000E83: db $58
L000E84: db $17
L000E85: db $6C
L000E86: db $17
L000E87: db $6D
L000E88: db $17
L000E89: db $7E
L000E8A: db $17
L000E8B: db $9E
L000E8C: db $17
L000E8D:;I
	ld   a, [$CF6C]
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
	ld   [$CF11], a
	ld   a, c
	ld   [$CF1B], a
	ld   a, b
	ld   [$CF1A], a
	ld   a, $02
	ld   [$CF1D], a
	jp   L001AE9
L000EB8:;R
	ld   a, [$CF42]
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
	ld   a, [$CF43]
	or   a
	jr   nz, L000EFC
	ld   a, [wPlRelY]
	sub  $08
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	call L00332F
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
	ld   [$CF0D], a
	ld   a, [wPlRelY]
	inc  a
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	jr   c, L000F2E
	call L001BEB
	xor  a
	ld   [$CF3C], a
	ld   a, $01
	ld   [$CF49], a
	ld   a, $04
	ld   [$CF11], a
	jp   L001AE9
L000F2E:;R
	ldh  a, [hJoyKeys]
	bit  6, a
	jr   z, L000F5B
	ld   a, [wPlRelY]
	cp   $28
	jr   c, L000F5B
	sub  $0F
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	call L00332F
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
	ld   [$CF0D], a
	ld   a, [wPlRelY]
	inc  a
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	cp   $21
	jr   nz, L000F80
	ld   a, $05
	ld   [$CF1D], a
	call L001A45
	jp   L001AE9
L000F80:;R
	ldh  a, [hJoyNewKeys]
	bit  0, a
	jr   z, L000FD4
	ldh  a, [hJoyKeys]
	bit  7, a
	jr   z, L000FD4
	ld   a, [$CF6B]
	cp   $FF
	jr   nz, L000FD4
	ld   a, [wPlDirH]
	or   a
	jr   nz, L000FA6
	ld   a, [wPlRelX]
	ld   [$CF35], a
	sub  $10
	ld   [$CF0D], a
	jr   L000FB1
L000FA6:;R
	ld   a, [wPlRelX]
	ld   [$CF35], a
	add  $10
	ld   [$CF0D], a
L000FB1:;R
	ld   a, [wPlRelY]
	ld   [$CF36], a
	sub  $0F
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	jp   nc, L000FD4
	ld   a, $10
	ld   [$CF1D], a
	ld   a, $1E
	ld   [$CF2A], a
	ld   a, $30
	ld   [$CF27], a
	jp   L001AE9
L000FD4:;JR
	ldh  a, [hJoyNewKeys]
	bit  0, a
	jr   z, L00100E
	ld   a, [wPlRelY]
	sub  $18
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [$CF0D], a
	call L00332F
	jr   nc, L00100E
	ld   a, [wPlRelX]
	add  $06
	ld   [$CF0D], a
	call L00332F
	jr   nc, L00100E
	ld   a, $80
	ld   [$CF1B], a
	ld   a, $03
	ld   [$CF1A], a
	ld   a, $01
	ld   [$CF1D], a
	jp   L001AE9
L00100E:;JR
	call L001836
	ld   a, [$CF26]
	and  $03
	cp   $03
	jr   nz, L00102C
L00101A:;X
	ld   a, $00
	ld   [$CF1B], a
	ld   a, $01
	ld   [$CF1A], a
	ld   a, $03
	ld   [$CF1D], a
	jp   L001AE9
L00102C:;R
	ld   a, [$CF6B]
	cp   $FF
	jr   nz, L00103A
	ldh  a, [hJoyKeys]
	and  $30
	jp   nz, L001AAF
L00103A:;R
	xor  a
	ld   [$CF13], a
	ld   a, [$CF21]
	or   a
	jr   nz, L001050
	call L000755
	cp   $03
	jr   nc, L001060
	ld   a, $19
	ld   [$CF21], a
L001050:;R
	dec  a
	ld   [$CF21], a
	cp   $0C
	jr   c, L001060
	ld   a, $05
	ld   [$CF11], a
	jp   L001AE9
L001060:;R
	ld   a, $04
	ld   [$CF11], a
	jp   L001AE9
L001068:;I
	call L014000 ; BANK $01
	call L001895
	call L0018FE
	ld   a, $07
	ld   [$CF11], a
	ldh  a, [hJoyKeys]
	bit  0, a
	jr   nz, L001093
	jp   L00115D
L00107F:;I
	call L014000 ; BANK $01
	call L001895
	call L0018FE
	ld   a, [$CF6C]
	or   a
	jr   nz, L0010C0
	ld   a, $07
	ld   [$CF11], a
L001093:;R
	ldh  a, [hJoyKeys]
	bit  6, a
	jr   z, L0010C0
	ld   a, [wPlRelY]
	cp   $28
	jr   c, L0010C0
	sub  $0F
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	call L00332F
	cp   $20
	jr   nz, L0010C0
	call L0017D2
	ld   a, $04
	ld   [$CF1D], a
	call L001A45
	jp   L001AE9
L0010C0:;R
	ld   a, [wPlRelY]
	cp   $18
	jp   c, L00115D
	ld   a, [$CF1A]
	ld   b, a
	ld   a, [wPlRelY]
	sub  b
	ld   [$CF17], a
	sub  $18
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	call L00332F
	jr   nc, L00114E
	ld   a, [wPlRelX]
	sub  $06
	ld   [$CF0D], a
	call L00332F
	jr   nc, L00115D
	ld   a, [wPlRelX]
	add  $06
	ld   [$CF0D], a
	call L00332F
	jr   nc, L00115D
	ld   a, [$CF17]
	ld   [wPlRelY], a
	ld   a, [$CF6F]
	or   a
	jr   z, L001120
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	ld   a, [wPlRelY]
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	cp   $10
	jr   z, L001137
	cp   $18
	jr   z, L001137
L001120:;R
	ld   bc, $0020
	ld   a, [$CF1B]
	sub  c
	ld   [$CF1B], a
	ld   a, [$CF1A]
	sbc  a, b
	ld   [$CF1A], a
	or   a
	jr   z, L00115D
	jp   L001AE9
L001137:;R
	ld   bc, $0008
	ld   a, [$CF1B]
	sub  c
	ld   [$CF1B], a
	ld   a, [$CF1A]
	sbc  a, b
	ld   [$CF1A], a
	or   a
	jr   z, L00115D
	jp   L001AE9
L00114E:;R
	ld   a, [$CF1C]
	ld   b, a
	ld   a, [wPlRelY]
	sub  $17
	and  b
	add  $17
	ld   [wPlRelY], a
L00115D:;JR
	ld   a, $00
	ld   [$CF1B], a
	ld   a, $01
	ld   [$CF1A], a
	ld   a, $03
	ld   [$CF1D], a
	jp   L001AE9
L00116F:;I
	ld   a, [$CF42]
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
	ld   a, [$CF6C]
	or   a
	jr   nz, L0011BE
	ld   a, $07
	ld   [$CF11], a
	ldh  a, [hJoyKeys]
	bit  6, a
	jr   z, L0011BE
	ld   a, [wPlRelY]
	cp   $28
	jr   c, L0011BE
	sub  $0F
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	call L00332F
	cp   $20
	jr   nz, L0011BE
	call L0017D2
	ld   a, $04
	ld   [$CF1D], a
	call L001A45
	jp   L001AE9
L0011BE:;R
	ld   a, [$CF4A]
	cp   $FF
	jp   nz, L00128F
	ld   a, [$CF1A]
	ld   b, a
	ld   a, [wPlRelY]
	add  b
	ld   [$CF17], a
	call L00186E
	jp   z, L0011FD
	ld   a, [$CF17]
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [$CF0D], a
	call L00332F
	cp   $21
	jp   nc, L001287
	ld   a, [wPlRelX]
	add  $06
	ld   [$CF0D], a
	call L00332F
	cp   $21
	jp   nc, L001287
L0011FD:;J
	ld   a, [$CF17]
	ld   [wPlRelY], a
	cp   $98
	jr   c, L001226
	sub  $10
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	call L00332F
	cp   $18
	jr   c, L00121E
	cp   $20
	jp   c, L0017A5
L00121E:;R
	ld   a, $0D
	ld   [$CF1D], a
	jp   L001AE9
L001226:;R
	ld   a, [$CF6F]
	or   a
	jr   z, L001243
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	ld   a, [wPlRelY]
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	cp   $10
	jr   z, L001265
	cp   $18
	jr   z, L001265
L001243:;R
	ld   bc, $0020
	ld   a, [$CF1B]
	add  c
	ld   [$CF1B], a
	ld   a, [$CF1A]
	adc  a, b
	ld   [$CF1A], a
	cp   $04
	jp   c, L001AE9
	xor  a
	ld   [$CF1B], a
	ld   a, $04
	ld   [$CF1A], a
	jp   L001AE9
L001265:;R
	ld   bc, $0008
	ld   a, [$CF1B]
	add  c
	ld   [$CF1B], a
	ld   a, [$CF1A]
	adc  a, b
	ld   [$CF1A], a
	cp   $01
	jp   c, L001AE9
	xor  a
	ld   [$CF1B], a
	ld   a, $01
	ld   [$CF1A], a
	jp   L001AE9
L001287:;J
	ld   a, [wPlRelY]
	or   $0F
	ld   [wPlRelY], a
L00128F:;J
	call L0017D2
	xor  a
	ld   [$CF1D], a
	ld   a, [$CF6C]
	or   a
	jp   nz, L001AE9
	ld   a, $01
	ldh  [$FF99], a
	jp   L001AE9
L0012A4:;I
	call L014000 ; BANK $01
	ld   a, $09
	ld   [$CF11], a
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	ld   a, [wPlRelY]
	sub  $0F
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	cp   $20
	jr   nc, L0012C9
	ld   a, $03
	ld   [$CF1D], a
	jp   L001AD6
L0012C9:;R
	ldh  a, [hJoyNewKeys]
	bit  0, a
	jp   z, L0012E2
	ld   a, $00
	ld   [$CF1B], a
	ld   a, $01
	ld   [$CF1A], a
	ld   a, $03
	ld   [$CF1D], a
	jp   L001AE9
L0012E2:;J
	ld   a, [$CF22]
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
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	call L00332F
	cp   $20
	jr   nc, L001325
	ld   a, $07
	ld   [$CF1D], a
	jp   L001AD6
L001325:;R
	ld   a, [wPlRelY]
	cp   $29
	jr   nc, L001334
	ld   a, $0B
	ld   [$CF1D], a
	jp   L001AD6
L001334:;R
	ld   a, [$CF1F]
	sub  $C0
	ld   [$CF1F], a
	ld   a, [wPlRelY]
	sbc  a, $00
	ld   [wPlRelY], a
	jp   L001AD6
L001347:;R
	ldh  a, [hJoyKeys]
	bit  7, a
	jp   z, L001AE9
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	ld   a, [wPlRelY]
	inc  a
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
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
	ld   [$CF1D], a
	jp   L001AD6
L001377:;J
	ld   a, [$CF1F]
	add  $C0
	ld   [$CF1F], a
	ld   a, [wPlRelY]
	adc  a, $00
	ld   [wPlRelY], a
	jp   L001AD6
L00138A:;I
	ld   a, $08
	ld   [$CF11], a
	ld   a, [wPlRelY]
	add  $08
	ld   [wPlRelY], a
	ld   a, $06
	ld   [$CF1E], a
	ld   hl, $CF1D
	inc  [hl]
	jp   L001AE9
L0013A3:;I
	ld   hl, $CF1E
	dec  [hl]
	jp   nz, L001AE9
	ld   a, [wPlRelY]
	add  $10
	ld   [wPlRelY], a
	ld   a, $04
	ld   [$CF1D], a
	jp   L001AE9
L0013BA:;I
	ld   a, $08
	ld   [$CF11], a
	ld   a, [wPlRelY]
	sub  $10
	ld   [wPlRelY], a
	ld   a, $06
	ld   [$CF1E], a
	ld   hl, $CF1D
	inc  [hl]
	jp   L001AE9
L0013D3:;I
	ld   hl, $CF1E
	dec  [hl]
	jp   nz, L001AE9
	ld   a, [wPlRelY]
	sub  $08
	ld   [wPlRelY], a
	xor  a
	ld   [$CF1D], a
	jp   L001AE9
L0013E9:;I
	call L001BEB
	ld   a, $09
	ld   [$CF11], a
	ld   a, $01
	ld   [wScrollVDir], a
	call Game_Unk_StartRoomTrs
	ld   hl, $CF1D
	inc  [hl]
	jp   L001AD6
L001400:;I
	ld   a, [$CF1F]
	add  $40
	ld   [$CF1F], a
	ld   a, [wPlRelY]
	adc  a, $00
	sub  $02
	ld   [wPlRelY], a
	call Game_Unk_DoRoomTrs
	jp   nz, L001AD6
	ld   a, $04
	ld   [$CF1D], a
	call L001AD6
	jp   L001C25
L001423:;I
	call L001BEB
	ld   a, $09
	ld   [$CF11], a
	xor  a
	ld   [wScrollVDir], a
	call Game_Unk_StartRoomTrs
	ld   hl, $CF1D
	inc  [hl]
	jp   L001AD6
L001439:;I
	ld   a, [$CF1F]
	sub  $40
	ld   [$CF1F], a
	ld   a, [wPlRelY]
	sbc  a, $00
	add  $02
	ld   [wPlRelY], a
	call Game_Unk_DoRoomTrs
	jp   nz, L001AD6
	ld   a, $04
	ld   [$CF1D], a
	call L001AD6
	jp   L001C25
L00145C:;I
	call L001BEB
	ld   a, $07
	ld   [$CF11], a
	ld   a, $01
	ld   [wScrollVDir], a
	call Game_Unk_StartRoomTrs
	ld   hl, $CF1D
	inc  [hl]
	jp   L001AE9
L001473:;I
	ld   a, [$CF1B]
	add  $40
	ld   [$CF1B], a
	ld   a, [wPlRelY]
	adc  a, $00
	sub  $02
	ld   [wPlRelY], a
	call Game_Unk_DoRoomTrs
	jp   nz, L001AE9
	ld   a, $03
	ld   [$CF1D], a
	call L001AE9
	jp   L001C25
L001496:;I
	jp   L001AE9
L001499:;I
	ld   a, $0A
	ld   [$CF11], a
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
	ld   a, [$CF26]
	and  $03
	cp   $03
	jr   nz, L0014E2
	ld   a, $00
	ld   [$CF1B], a
	ld   a, $01
	ld   [$CF1A], a
	ld   a, $03
	ld   [$CF1D], a
	ld   hl, wPlRelY
	inc  [hl]
	jp   L001AE9
L0014E2:;R
	ld   a, [$CF2A]
	or   a
	jr   z, L0014EC
	dec  a
	ld   [$CF2A], a
L0014EC:;R
	ld   a, [wPlRelY]
	sub  $10
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [$CF0D], a
	call L00332F
	ret  nc
	ld   a, [wPlRelX]
	add  $06
	ld   [$CF0D], a
	call L00332F
	ret  nc
	ld   a, [$CF2A]
	or   a
	ret  nz
	xor  a
	ld   [$CF1D], a
	ret
L001516:;I
	call L014000 ; BANK $01
	ld   hl, $CF75
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
	ld   a, [$CF75]
	srl  a
	ld   [$CF76], a
	or   a
	jr   z, L001567
	ld   bc, $0100
	call L0018CC
	xor  a
	ld   [$CF75], a
	jr   L001567
L00155E:;R
	ld   a, [$CF75]
	ld   c, a
	ld   b, $00
	call L0018BD
L001567:;R
	ld   hl, $CF76
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
	ld   a, [$CF76]
	srl  a
	ld   [$CF75], a
	or   a
	jr   z, L0015B6
	ld   bc, $0100
	call L0018BD
	xor  a
	ld   [$CF76], a
	jr   L0015B6
L0015AD:;R
	ld   a, [$CF76]
	ld   c, a
	ld   b, $00
	call L0018CC
L0015B6:;R
	ld   hl, $CF77
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
	ld   [$CF77], a
	jr   L0015F9
L0015E6:;R
	ld   a, [$CF77]
	ld   b, a
	ld   a, [$CF68]
	sub  b
	ld   [$CF68], a
	ld   a, [$CF69]
	sbc  a, $00
	ld   [$CF69], a
L0015F9:;R
	ld   hl, $CF78
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
	ld   [$CF78], a
	jr   L00163B
L001628:;R
	ld   a, [$CF78]
	ld   b, a
	ld   a, [$CF68]
	add  b
	ld   [$CF68], a
	ld   a, [$CF69]
	adc  a, $00
	ld   [$CF69], a
L00163B:;R
	call L0018DB
	jp   L001A89
L001641:;C
	ld   [$CF0D], a
	ld   a, [wPlRelY]
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	cp   $10
	jr   z, L001654
	cp   $18
	ret  nz
L001654:;R
	ld   a, [wPlRelY]
	sub  $0F
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	cp   $10
	ret  z
	cp   $18
	ret
L001665:;C
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	call L00332F
	cp   $10
	jr   z, L001678
	cp   $18
	ret  nz
L001678:;R
	ld   a, [wPlRelX]
	sub  $0E
	ld   [$CF0D], a
	call L00332F
	cp   $10
	jr   z, L00168A
	cp   $18
	ret  nz
L00168A:;R
	ld   a, [wPlRelX]
	add  $0E
	ld   [$CF0D], a
	call L00332F
	cp   $10
	ret  z
	cp   $18
	ret
L00169B:;I
	ld   a, $00
	ld   [$CF1B], a
	ld   a, $01
	ld   [$CF1A], a
	ld   a, $31
	ld   [$CF11], a
	ld   hl, $CF1D
	inc  [hl]
	ret
L0016AF:;I
	ld   a, [wPlRelY]
	ld   b, a
	ld   a, [$CF1A]
	add  b
	ld   [$CF17], a
	cp   $48
	jr   c, L0016CF
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	ld   [$CF0D], a
	call L00332F
	jr   nc, L0016F4
	ld   a, [$CF17]
L0016CF:;R
	ld   [wPlRelY], a
	ld   bc, $0020
	ld   a, [$CF1B]
	add  c
	ld   [$CF1B], a
	ld   a, [$CF1A]
	adc  a, b
	ld   [$CF1A], a
	cp   $04
	jp   c, L001AE9
	xor  a
	ld   [$CF1B], a
	ld   a, $04
	ld   [$CF1A], a
	jp   L001AE9
L0016F4:;R
	ld   a, [wPlRelY]
	or   $0F
	ld   [wPlRelY], a
	ld   hl, $CF1D
	inc  [hl]
	xor  a
	ld   [$CF65], a
	jp   L001AE9
L001707:;I
	ld   a, [$CF65]
	inc  a
	ld   [$CF65], a
	srl  a
	cp   $05
	jr   z, L00171E
	ld   b, a
	ld   a, $31
	add  b
	ld   [$CF11], a
	jp   L001AE9
L00171E:;R
	ld   a, $0C
	ldh  [$FF99], a
	xor  a
	ld   [$CF1D], a
	ret
L001727:;I
	ld   a, $0A
	ld   [$CF65], a
	ld   a, $34
	ld   [$CF11], a
	ld   hl, $CF1D
	inc  [hl]
	jp   L001AE9
L001738:;I
	ld   a, [$CF65]
	dec  a
	ld   [$CF65], a
	srl  a
	jr   z, L00174D
	ld   b, a
	ld   a, $30
	add  b
	ld   [$CF11], a
	jp   L001AE9
L00174D:;R
	ld   a, $0D
	ldh  [$FF99], a
	ld   hl, $CF1D
	inc  [hl]
	jp   L001AE9
L001758:;I
	ld   a, [wPlRelY]
	sub  $04
	ld   [wPlRelY], a
	and  $F0
	jp   nz, L001AE9
	ld   hl, $CF1D
	inc  [hl]
	jp   L001AE9
L00176C:;I
	ret
L00176D:;I
	ld   a, $0A
	ld   [$CF65], a
	ld   a, $34
	ld   [$CF11], a
	ld   hl, $CF1D
	inc  [hl]
	jp   L001AE9
L00177E:;I
	ld   a, [$CF65]
	dec  a
	ld   [$CF65], a
	srl  a
	jr   z, L001793
	ld   b, a
	ld   a, $30
	add  b
	ld   [$CF11], a
	jp   L001AE9
L001793:;R
	ld   a, $0D
	ldh  [$FF99], a
	ld   hl, $CF1D
	inc  [hl]
	jp   L001AE9
L00179E:;I
	ld   a, [$CF7A]
	ld   [$CF60], a
	ret
L0017A5:;J
	ldh  a, [$FFF9]
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
	ld   [$CF63], a
	ld   a, [wPlRelY]
	sub  $0C
	ld   [$CF64], a
	ld   a, $01
	ld   [$CF60], a
	jp   L001AE9
L0017D2:;C
	ld   a, [$CFDF]
	cp   $04
	ret  nz
	xor  a
	ld   [$CFEA], a
	ld   [$CC60], a
	ret
L0017E0:;C
	ld   a, [$CF4A]
	cp   $FF
	ret  nz
	ld   a, [wPlRelY]
	inc  a
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [$CF0D], a
	call L00332F
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
	ld   [$CF0D], a
	call L00332F
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
	ld   a, [$CF4A]
	cp   $FF
	jr   z, L001842
	xor  a
	ld   [$CF26], a
	ret
L001842:;R
	ld   a, [wPlRelY]
	inc  a
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [$CF0D], a
	call L00332F
	cp   $21
	ld   hl, $CF26
	rl   [hl]
	ld   a, [wPlRelX]
	add  $06
	ld   [$CF0D], a
	call L00332F
	cp   $21
	ld   hl, $CF26
	rl   [hl]
	ret
L00186E:;C
	ld   a, [wPlRelY]
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [$CF0D], a
	call L00332F
	cp   $21
	ret  nz
	ld   a, [wPlRelX]
	add  $06
	ld   [$CF0D], a
	call L00332F
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
	ld   a, [$CF18]
	sub  c
	ld   [$CF18], a
	ld   a, [$CF19]
	sbc  a, b
	ld   [$CF19], a
	ret
L0018CC:;JCR
	ld   a, [$CF18]
	add  c
	ld   [$CF18], a
	ld   a, [$CF19]
	adc  a, b
	ld   [$CF19], a
	ret
L0018DB:;C
	ld   a, [$CF19]
	or   a
	ret  z
	bit  7, a
	jr   z, L0018F4
	xor  $FF
	inc  a
	ld   [$CF19], a
L0018EA:;R
	call L001961
	ld   hl, $CF19
	dec  [hl]
	jr   nz, L0018EA
	ret
L0018F4:;R
	call L0019F5
	ld   hl, $CF19
	dec  [hl]
	jr   nz, L0018F4
	ret
L0018FE:;JC
	ld   a, [$CF19]
	or   a
	ret  z
	bit  7, a
	jr   z, L001917
	xor  $FF
	inc  a
	ld   [$CF19], a
L00190D:;R
	call L001921
	ld   hl, $CF19
	dec  [hl]
	jr   nz, L00190D
	ret
L001917:;R
	call L0019B5
	ld   hl, $CF19
	dec  [hl]
	jr   nz, L001917
	ret
L001921:;C
	ld   a, [wPlRelX]
	sub  $07
	ld   [$CF0D], a
	ld   a, [wPlRelY]
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	ld   [$CF3B], a
	ret  nc
	ld   a, [wPlRelY]
	sub  $07
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	ret  nc
	ld   a, [wPlRelY]
	sub  $0F
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	ret  nc
	ld   a, [$CF1D]
	cp   $10
	jr   z, L001961
	ld   a, [wPlRelY]
	sub  $17
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
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
	ld   a, [$CF3A]
	or   a
	jr   nz, L00199B
	ld   h, $CB
	ld   a, [wLvl_Unk_CurCol]
	ld   l, a
	ld   a, [hl]
	bit  7, a
	call nz, L00094C
L00198A:;R
	ld   a, [$CF3A]
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
	ld   hl, $CF31
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
	ld   [$CF0D], a
	ld   a, [wPlRelY]
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	ld   [$CF3C], a
	ret  nc
	ld   a, [wPlRelY]
	sub  $07
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	ret  nc
	ld   a, [wPlRelY]
	sub  $0F
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	ret  nc
	ld   a, [$CF1D]
	cp   $10
	jr   z, L0019F5
	ld   a, [wPlRelY]
	sub  $17
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	ret  nc
L0019F5:;CR
	ld   a, [wPlRelX]
	cp   $9F
	ret  nc
	ld   a, [$CF3A]
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
	ld   hl, $CF31
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
	ld   a, [$CF3A]
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
	ld   a, [$CF69]
	or   a
	ret  z
	bit  7, a
	jp   z, L001AA4
	xor  $FF
	inc  a
	ld   [$CF69], a
L001A99:;X
	ld   hl, wPlRelY
	dec  [hl]
	ld   hl, $CF69
	dec  [hl]
	jr   nz, L001A99
	ret
L001AA4:;J
	ld   hl, wPlRelY
	inc  [hl]
	ld   hl, $CF69
	dec  [hl]
	jr   nz, L001AA4
	ret
L001AAF:;J
	ld   a, [$CF13]
	cp   $07
	jr   z, L001AC1
	inc  a
	ld   [$CF13], a
	ld   a, $06
	ld   [$CF11], a
	jr   L001AE9
L001AC1:;R
	ld   a, [$CF14]
	add  $08
	ld   [$CF14], a
	swap a
	srl  a
	srl  a
	and  $03
	ld   [$CF11], a
	jr   L001AE9
L001AD6:;JC
	ld   a, [$CF14]
	add  $06
	ld   [$CF14], a
	swap a
	srl  a
	srl  a
	and  $01
	ld   [wPlDirH], a
L001AE9:;JCR
	ld   a, [$CFEA]
	or   a
	jp   nz, L001B9D
	ld   a, [$CF42]
	or   a
	jr   z, L001B0D
	ldh  a, [hTimer]
	rra  
	jp   nc, L001B9D
	ld   a, [$CF1D]
	cp   $10
	jr   nc, L001B0D
	ld   a, [$CF6C]
	or   a
	jr   nz, L001B0D
	ld   a, $30
	jr   L001B22
L001B0D:;R
	ld   a, [$CF43]
	or   a
	jr   z, L001B1A
	ldh  a, [hTimer]
	rra  
	rra  
	jp   nc, L001B9D
L001B1A:;R
	ld   a, [$CF23]
	ld   b, a
	ld   a, [$CF11]
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
	ldh  a, [$FF97]
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
	ld   a, [$CF67]
	or   c
	ldi  [hl], a
	dec  b
	jr   nz, L001B4A
	ld   a, l
	ldh  [$FF97], a
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
	ld   a, [$CF67]
	or   c
	xor  $20
	ldi  [hl], a
	dec  b
	jr   nz, L001B6D
	ld   a, l
	ldh  [$FF97], a
L001B94:;R
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
L001B9D:;J
	ld   a, [$CF27]
	or   a
	ret  z
	dec  a
	ld   [$CF27], a
	swap a
	and  $03
	ld   hl, $1BD6
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   b, a
	ld   a, [$CF31]
	ld   c, a
	ld   h, $DF
	ldh  a, [$FF97]
	ld   l, a
	ld   a, [$CF36]
	sub  $07
	ldi  [hl], a
	ld   a, [$CF35]
	add  c
	ld   [$CF35], a
	sub  $04
	ldi  [hl], a
	ld   a, b
	ldi  [hl], a
	ld   a, [$CF67]
	ldi  [hl], a
	ld   a, l
	ldh  [$FF97], a
	ret
L001BD6: db $62
L001BD7: db $61
L001BD8: db $60
L001BD9:;C
	ld   a, $FF
	ld   [wActGfxId], a
	xor  a
	ld   [$CF37], a
	ld   hl, $CD00
	ld   bc, $0200
	jp   L00067A
L001BEB:;C
	ld   d, $C8
	ld   hl, $CD00
L001BF0:;R
	ld   a, [hl]
	or   a
	jr   z, L001C00
	push hl
	xor  a
	ldi  [hl], a
	inc  l
	inc  l
	ld   a, [hl]
	ld   e, a
	ld   a, [de]
	res  7, a
	ld   [de], a
	pop  hl
L001C00:;R
	ld   a, l
	add  $10
	ld   l, a
	jr   nz, L001BF0
	xor  a
	ld   [$CFF1], a
	ld   [$CF6C], a
	ld   a, [$CFDF]
	cp   $04
	ret  z
	xor  a
	ld   hl, $CC60
	ld   [hl], a
	ld   hl, $CC70
	ld   [hl], a
	ld   hl, $CC80
	ld   [hl], a
	ld   hl, $CC90
	ld   [hl], a
	ret
L001C25:;J
	ld   a, [wLvlRoomId]
	ld   hl, $CC00
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   c, $0A
	bit  0, a
	jr   z, L001C37
	inc  c
L001C37:;R
	ld   a, [wLvlColL]
	ld   l, a
	ld   b, $07
L001C3D:;R
	push hl
	push bc
	ld   h, $C8
	ld   a, [hl]
	bit  7, a
	jr   nz, L001C4B
	bit  4, a
	call nz, L001C6C
L001C4B:;R
	pop  bc
	pop  hl
	inc  l
	ld   a, b
	add  $10
	ld   b, a
	dec  c
	jr   nz, L001C3D
	ret
L001C56:;C
	ld   h, $C8
	ld   a, [hl]
	bit  7, a
	ret  nz
	bit  4, a
	ret  z
	jr   L001C6C
L001C61:;J
	ld   h, $C8
	ld   a, [hl]
	bit  7, a
	ret  nz
	bit  5, a
	ret  z
	jr   L001C6C
L001C6C:;CR
	set  7, a
	ld   [hl], a
	and  $07
	swap a
	add  $10
	or   $0F
	ld   [$CF2C], a
	ld   a, b
	add  $08
	ld   [$CF2B], a
	ld   h, $C9
	ld   a, [hl]
	ld   [$CF2D], a
	ld   a, l
	ld   [$CF2E], a
	jp   L001D48
L001C8D:;C
	ld   a, $07
	ld   [$CF2D], a
	xor  a
	ld   [$CF2E], a
	ld   b, $08
	ld   hl, $1CFD
L001C9B:;R
	push hl
	push bc
	call L001D48
	ld   e, l
	ld   d, h
	pop  bc
	pop  hl
	ret  c
	inc  de
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	inc  de
	inc  de
	inc  de
	inc  de
	inc  de
	inc  hl
	inc  hl
	inc  hl
	inc  hl
	ldi  a, [hl]
	ld   [de], a
	inc  de
	xor  a
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	xor  a
	ld   [de], a
	dec  b
	jr   nz, L001C9B
	ret
L001CC2:;C
	ld   a, $07
	ld   [$CF2D], a
	xor  a
	ld   [$CF2E], a
	ld   b, $08
	ld   hl, $1CFD
L001CD0:;R
	push hl
	push bc
	call L001D48
	ld   e, l
	ld   d, h
	pop  bc
	pop  hl
	ret  c
	inc  de
	inc  de
	ldi  a, [hl]
	xor  $C0
	ld   [de], a
	inc  de
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	xor  a
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
	xor  a
	ld   [de], a
	dec  b
	jr   nz, L001CD0
	ret
L001CFD: db $00
L001CFE: db $00
L001CFF: db $58
L001D00: db $3C
L001D01: db $10
L001D02: db $00
L001D03: db $FF
L001D04: db $80
L001D05: db $30
L001D06: db $82
L001D07: db $D0
L001D08: db $21
L001D09: db $B4
L001D0A: db $B4
L001D0B: db $80
L001D0C: db $C4
L001D0D: db $93
L001D0E: db $00
L001D0F: db $4C
L001D10: db $FF
L001D11: db $00
L001D12: db $C0
L001D13: db $30
L001D14: db $82
L001D15: db $30
L001D16: db $76
L001D17: db $B4
L001D18: db $B4
L001D19: db $40
L001D1A: db $00
L001D1B: db $58
L001D1C: db $C4
L001D1D: db $87
L001D1E: db $00
L001D1F: db $FF
L001D20: db $40
L001D21: db $D0
L001D22: db $2D
L001D23: db $30
L001D24: db $76
L001D25: db $B4
L001D26: db $B4
L001D27: db $00
L001D28: db $3C
L001D29: db $1C
L001D2A: db $00
L001D2B: db $4C
L001D2C: db $FF
L001D2D: db $00
L001D2E: db $00
L001D2F: db $D0
L001D30: db $2D
L001D31: db $D0
L001D32: db $21
L001D33: db $B4
L001D34: db $B4
L001D35:;C
	ld   [$CF2D], a
	xor  a
	ld   [$CF2E], a
	ldh  a, [$FFA5]
	add  b
	ld   [$CF2B], a
	ldh  a, [$FFA7]
	add  c
	ld   [$CF2C], a
L001D48:;JC
	ld   hl, $CD00
L001D4B:;R
	ld   a, [hl]
	or   a
	jr   z, L001D57
	ld   a, l
	add  $10
	ld   l, a
	jr   nz, L001D4B
	scf  
	ret
L001D57:;R
	push hl
	push hl
	ld   a, [$CF2D]
	or   $80
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ld   a, [$CF2E]
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, [$CF2B]
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   a, [$CF2C]
	ld   [hl], a
	push af
	ld   a, $03
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   a, [$CF2D]
	ld   c, a
	swap a
	and  $0F
	ld   b, a
	ld   a, c
	swap a
	and  $F0
	ld   c, a
	ld   hl, $4000
	add  hl, bc
	pop  de
	ld   d, $CE
	ld   b, $04
L001D93:;R
	ldi  a, [hl]
	ld   [de], a
	inc  de
	dec  b
	jr   nz, L001D93
	ld   b, [hl]
	inc  hl
	ld   a, [hl]
	swap a
	add  b
	ld   [de], a
	inc  de
	xor  a
	ld   [de], a
	pop  hl
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== ActS_LoadGFXForRoom ===============
; Loads the actor graphics for the current room.
ActS_LoadGFXForRoom:

	;
	; Each column in a level can be associated to a potential set of actor graphics,
	; with the table at wLvlGFXReqTbl maps every column to an art request ID.
	;
	; This subroutine scans a room worth of columns, loading the first set found.
	;

	; HL = Starting pointer (wLvlGFXReqTbl + wLvlColL)
	ld   a, [wLvlColL]
	ld   l, a
	; B = Number of entries to scan
	ld   b, ROOM_COLCOUNT
	
.loop:

	;
	; If there's a request at the current column, apply that.
	;
	; ??? However, there's a catch. If the same offset at wLvlUnkTblC800 is non-zero,
	; skip the entry. What's the point of this?
	;
	
	; Skip if an ??? entry is set
	ld   h, HIGH(wLvlUnkTblC800)
	ld   a, [hl]
	or   a
	jr   nz, .nextCol
	
	; Skip if there's no request for this column
	ld   h, HIGH(wLvlGFXReqTbl)
	ld   a, [hl]
	or   a
	jr   z, .nextCol
	
; IN
; - A: GFX request ID
.tryLoadBySetId:
	ld   hl, wActGfxId
	cp   a, [hl]		; Requesting the same set as last time?
	ret  z				; If so, return (graphics already loaded)
	
; IN
; - A: GFX request ID
.loadBySetId:
	ld   [wActGfxId], a	; Mark as the currently loaded set
	
	; Index the global request table and read out the settings
	ld   hl, ActS_GFXReqTbl
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
	call L001F2A
	cp   $11
	ret  nc
	call L001E11
	call L001E25
	ld   h, $CD
	ldh  a, [$FFAD]
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
	call L001F2A
	cp   $11
	ret  nc
	call L001E11
	call L001E25
	scf  
	ret
L001E11:;JC
	ld   a, $80
	ldh  [$FFA0], a
	xor  a
	ldh  [$FFA1], a
	ldh  [$FFA2], a
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	inc  l
	inc  l
	xor  a
	ld   [hl], a
	ret
L001E25:;JC
	call L000755
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
	ld   [$CF2D], a
	xor  a
	ld   [$CF2E], a
	ld   h, $CD
	ld   a, [$CF2F]
	add  $05
	ld   l, a
	ldi  a, [hl]
	ld   [$CF2B], a
	inc  l
	ld   a, [hl]
	ld   [$CF2C], a
	call L001D48
	ret  c
	inc  l
	ld   a, $01
	ld   [hl], a
	ret
L001E63:;C
	or   $80
	ld   e, a
	ld   bc, $0000
	ld   hl, $CD00
L001E6C:;R
	ld   a, [hl]
	or   a
	jr   z, L001E75
	inc  c
	cp   a, e
	jr   nz, L001E75
	inc  b
L001E75:;R
	ld   a, l
	add  $10
	ld   l, a
	jr   nc, L001E6C
	ret
L001E7C:;C
	inc  l
	inc  l
	ldh  a, [$FFA2]
	and  $80
	ld   [hl], a
	ret
L001E84:;C
	inc  l
	inc  l
	ldh  a, [$FFA2]
	and  $80
	xor  $80
	ld   [hl], a
	ret
L001E8E:;C
	ld   a, c
	ldh  [$FFA8], a
	ld   a, b
	ldh  [$FFA9], a
	ret
L001E95:;C
	ld   a, c
	ldh  [$FFAA], a
	ld   a, b
	ldh  [$FFAB], a
	ret
L001E9C:;JC
	ldh  a, [$FFA2]
	xor  $80
	ldh  [$FFA2], a
	ret
L001EA3:;C
	ldh  a, [$FFA2]
	xor  $40
	ldh  [$FFA2], a
	ret
L001EAA:;C
	ldh  a, [$FFA2]
	and  $C0
	ldh  [$FFA2], a
	ret
L001EB1:;J
	ld   hl, $FFA1
	inc  [hl]
	ret
L001EB6:;J
	ld   hl, $FFA1
	dec  [hl]
	ret
L001EBB:;C
	ld   a, [wPlRelX]
	ld   b, a
	ldh  a, [$FFA5]
	sub  b
	jr   nc, L001EC8
	xor  $FF
	inc  a
	scf  
L001EC8:;R
	ret
L001EC9:;C
	ld   a, [wPlRelY]
	ld   b, a
	ldh  a, [$FFA7]
	sub  b
	jr   nc, L001ED6
	xor  $FF
	inc  a
	scf  
L001ED6:;R
	ret
L001ED7:;C
	ldh  a, [$FFA5]
	cp   $D0
	jr   c, L001EE4
	ldh  a, [$FFA2]
	set  7, a
	ldh  [$FFA2], a
	ret
L001EE4:;R
	ld   a, [wPlRelX]
	ld   b, a
	ldh  a, [$FFA5]
	cp   a, b
	rra  
	and  $80
	ld   b, a
	ldh  a, [$FFA2]
	res  7, a
	or   b
	ldh  [$FFA2], a
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
L001F0C:;C
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	ld   [hl], b
	inc  hl
	ld   [hl], c
	ret
L001F16:;C
	ld   h, $CE
	ld   a, [$CF2F]
	add  $02
	ld   l, a
	ld   [hl], b
	ret
L001F20:;C
	ld   h, $CE
	ld   a, [$CF2F]
	add  $04
	ld   l, a
	ld   [hl], b
	ret
L001F2A:;C
	ld   h, $CE
	ld   a, [$CF2F]
	add  $04
	ld   l, a
	ld   a, [hl]
	ret
L001F34:;C
	sla  a
	sla  a
	sla  a
	ld   b, a
	ldh  a, [$FFA2]
	and  $C0
	or   b
	ldh  [$FFA2], a
	ret
L001F43:;C
	ldh  a, [$FFA2]
	and  $C0
	ld   b, a
	ldh  a, [$FFA2]
	add  c
	and  $0F
	or   b
	ldh  [$FFA2], a
	ret
L001F51:;C
	ldh  a, [$FFA2]
	and  $C0
	ld   b, a
	ldh  a, [$FFA2]
	add  c
	and  $1F
	or   b
	ldh  [$FFA2], a
	ret
L001F5F:;C
	sla  b
	sla  b
	sla  b
	ldh  a, [$FFA2]
	and  $C0
	ld   e, a
	ldh  a, [$FFA2]
	add  c
	ld   c, a
	and  $07
	ld   d, a
	ld   a, c
	and  $38
	cp   a, b
	jr   nz, L001F78
	xor  a
L001F78:;R
	or   d
	or   e
	ldh  [$FFA2], a
	ret
L001F7D:;C
	ld   a, $00
	ldh  [$FFAC], a
	ld   a, d
	ldh  [$FFAD], a
	ld   a, e
	ldh  [$FFAE], a
	ld   a, c
	ldh  [$FFAF], a
	ret
L001F8B:;C
	ldh  a, [$FFAC]
	add  $01
	ldh  [$FFAC], a
	ldh  a, [$FFAD]
	ld   d, a
	ldh  a, [$FFAE]
	ld   e, a
	ldh  a, [$FFAF]
	ld   c, a
	ld   b, a
L001F9B:;R
	ldh  a, [$FFAC]
	cp   a, c
	jr   nc, L001FA7
	ld   a, d
	ld   [$CF38], a
	xor  a
	or   a
	ret
L001FA7:;R
	inc  d
	ld   a, e
	cp   a, d
	jr   c, L001FB1
	ld   a, c
	add  b
	ld   c, a
	jr   L001F9B
L001FB1:;R
	ld   a, e
	ld   [$CF38], a
	ld   a, $01
	or   a
	ret
L001FB9:;C
	ld   b, $0C
L001FBB:;C
	ld   a, [wPlRelY]
	sub  b
	ld   b, a
	xor  a
	ld   [$CF26], a
	ldh  [$FFA9], a
	ldh  [$FFAB], a
	ldh  a, [$FFA7]
	sub  b
	jr   c, L001FD2
	ld   [$CF52], a
	jr   L001FE0
L001FD2:;R
	xor  $FF
	inc  a
	ld   [$CF52], a
	ld   a, [$CF26]
	set  6, a
	ld   [$CF26], a
L001FE0:;R
	ld   a, [wPlRelX]
	ld   b, a
	ldh  a, [$FFA5]
	sub  b
	jr   c, L001FEE
	ld   [$CF53], a
	jr   L001FFC
L001FEE:;R
	xor  $FF
	inc  a
	ld   [$CF53], a
	ld   a, [$CF26]
	set  7, a
	ld   [$CF26], a
L001FFC:;R
	ld   hl, $2512
	ld   a, [$CF53]
	and  $F0
	ld   b, a
	ld   a, [$CF52]
	and  $F0
	swap a
	or   b
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ldh  [$FFA8], a
	ld   hl, $2512
	ld   a, [$CF52]
	and  $F0
	ld   b, a
	ld   a, [$CF53]
	and  $F0
	swap a
	or   b
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ldh  [$FFAA], a
	ldh  a, [$FFA2]
	and  $3F
	ld   b, a
	ld   a, [$CF26]
	or   b
	ldh  [$FFA2], a
	ret
L002038:;C
	xor  a
	ldh  [$FFAC], a
	ld   a, $01
	ldh  [$FFAD], a
	xor  a
	ldh  [$FFAE], a
	ld   a, $58
	ldh  [$FFAF], a
	ret
L002047:;C
	ld   [$CF52], a
	xor  a
	ldh  [$FFA9], a
	ldh  [$FFAB], a
	ldh  a, [$FFAE]
	ld   hl, $2612
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ldh  [$FFA8], a
	ldh  a, [$FFAF]
	ld   hl, $2612
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ldh  [$FFAA], a
	ldh  a, [$FFAD]
	bit  1, a
	jr   nz, L002088
	ld   a, [$CF52]
	ld   b, a
	ldh  a, [$FFAE]
	add  b
	ldh  [$FFAE], a
	cp   $58
	jr   nz, L00209A
	ldh  a, [$FFAD]
	xor  $02
	ldh  [$FFAD], a
	ldh  a, [$FFA2]
	xor  $80
	ldh  [$FFA2], a
	jr   L00209A
L002088:;R
	ld   a, [$CF52]
	ld   b, a
	ldh  a, [$FFAE]
	sub  b
	ldh  [$FFAE], a
	or   a
	jr   nz, L00209A
	ldh  a, [$FFAD]
	xor  $02
	ldh  [$FFAD], a
L00209A:;R
	ldh  a, [$FFAD]
	bit  0, a
	jr   nz, L0020B9
	ld   a, [$CF52]
	ld   b, a
	ldh  a, [$FFAF]
	add  b
	ldh  [$FFAF], a
	cp   $58
	ret  nz
	ldh  a, [$FFAD]
	xor  $01
	ldh  [$FFAD], a
	ldh  a, [$FFA2]
	xor  $40
	ldh  [$FFA2], a
	ret
L0020B9:;R
	ld   a, [$CF52]
	ld   b, a
	ldh  a, [$FFAF]
	sub  b
	ldh  [$FFAF], a
	or   a
	ret  nz
	ldh  a, [$FFAD]
	xor  $01
	ldh  [$FFAD], a
	ret
L0020CB:;C
	ldh  a, [$FFA8]
	srl  a
	ldh  [$FFA8], a
	ldh  a, [$FFAA]
	srl  a
	ldh  [$FFAA], a
	ret
L0020D8:;C
	ldh  a, [$FFA8]
	sla  a
	ldh  [$FFA8], a
	ldh  a, [$FFA9]
	rl   a
	ldh  [$FFA9], a
	ldh  a, [$FFAA]
	sla  a
	ldh  [$FFAA], a
	ldh  a, [$FFAB]
	rl   a
	ldh  [$FFAB], a
	ret
L0020F1:;C
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	ldi  a, [hl]
	ld   b, a
	ldh  a, [$FFA7]
	inc  a
	ld   [wPl_Unk_Alt_Y], a
	ldh  a, [$FFA2]
	bit  7, a
	jr   nz, L00210E
	ldh  a, [$FFA5]
	sub  b
	ld   [$CF0D], a
	jp   L00332F
L00210E:;R
	ldh  a, [$FFA5]
	add  b
	ld   [$CF0D], a
	jp   L00332F
L002117:;C
	xor  a
	ld   [$CF26], a
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	ldi  a, [hl]
	ld   [$CF52], a
	ldh  a, [$FFA7]
	inc  a
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [$CF52]
	ld   b, a
	ldh  a, [$FFA5]
	sub  b
	ld   [$CF0D], a
	call L00332F
	ld   hl, $CF26
	rl   [hl]
	ld   a, [$CF52]
	ld   b, a
	ldh  a, [$FFA5]
	add  b
	ld   [$CF0D], a
	call L00332F
	ld   hl, $CF26
	rl   [hl]
	ret
L002150:;JC
	ldh  a, [$FFA8]
	ld   c, a
	ldh  a, [$FFA9]
	ld   b, a
	ldh  a, [$FFA2]
	bit  7, a
	jr   nz, L00216E
	ldh  a, [$FFA4]
	sub  c
	ldh  [$FFA4], a
	ldh  a, [$FFA5]
	sbc  a, b
	ldh  [$FFA5], a
	and  $F0
	cp   $D0
	jp   z, L00242F
	ret
L00216E:;R
	ldh  a, [$FFA4]
	add  c
	ldh  [$FFA4], a
	ldh  a, [$FFA5]
	adc  a, b
	ldh  [$FFA5], a
	and  $F0
	cp   $D0
	jp   z, L00242F
	ret
L002180:;C
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	ldi  a, [hl]
	ld   [$CF54], a
	ld   a, [hl]
	ld   [$CF55], a
	ldh  a, [$FFA8]
	ld   c, a
	ldh  a, [$FFA9]
	ld   b, a
	ldh  a, [$FFA2]
	bit  7, a
	jr   nz, L0021BA
	ldh  a, [$FFA4]
	sub  c
	ld   [$CF52], a
	ldh  a, [$FFA5]
	sbc  a, b
	ld   [$CF53], a
	and  $F0
	cp   $D0
	jp   z, L00242F
	ld   a, [$CF54]
	ld   b, a
	ld   a, [$CF53]
	sub  b
	ld   [$CF0D], a
	jr   L0021D8
L0021BA:;R
	ldh  a, [$FFA4]
	add  c
	ld   [$CF52], a
	ldh  a, [$FFA5]
	adc  a, b
	ld   [$CF53], a
	and  $F0
	cp   $D0
	jp   z, L00242F
	ld   a, [$CF54]
	ld   b, a
	ld   a, [$CF53]
	add  b
	ld   [$CF0D], a
L0021D8:;R
	ldh  a, [$FFA7]
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	ret  nc
	ld   a, [$CF55]
	ld   b, a
	ld   a, [wPl_Unk_Alt_Y]
	sub  b
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	ret  nc
	ld   a, [$CF55]
	ld   b, a
	ld   a, [wPl_Unk_Alt_Y]
	sub  b
	ld   [wPl_Unk_Alt_Y], a
	call L00332F
	ret  nc
	ld   a, [$CF52]
	ldh  [$FFA4], a
	ld   a, [$CF53]
	ldh  [$FFA5], a
	ret
L00220A:;C
	ldh  a, [$FFAA]
	ld   c, a
	ldh  a, [$FFAB]
	ld   b, a
	ldh  a, [$FFA2]
	bit  6, a
	jr   nz, L002228
	ldh  a, [$FFA6]
	sub  c
	ldh  [$FFA6], a
	ldh  a, [$FFA7]
	sbc  a, b
	ldh  [$FFA7], a
	and  $F0
	cp   $00
	jp   z, L00242F
	ret
L002228:;R
	ldh  a, [$FFA6]
	add  c
	ldh  [$FFA6], a
	ldh  a, [$FFA7]
	adc  a, b
	ldh  [$FFA7], a
	and  $F0
	cp   $A0
	jp   z, L00242F
	ret
L00223A:;C
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	ldi  a, [hl]
	ld   [$CF54], a
	ld   a, [hl]
	ld   [$CF55], a
	ldh  a, [$FFAA]
	ld   c, a
	ldh  a, [$FFAB]
	ld   b, a
	ldh  a, [$FFA2]
	bit  6, a
	jr   nz, L002276
	ldh  a, [$FFA6]
	sub  c
	ld   [$CF52], a
	ldh  a, [$FFA7]
	sbc  a, b
	ld   [$CF53], a
	and  $F0
	cp   $00
	jp   z, L00242F
	ld   a, [$CF55]
	sla  a
	ld   b, a
	ld   a, [$CF53]
	sub  b
	ld   [wPl_Unk_Alt_Y], a
	jr   L002290
L002276:;R
	ldh  a, [$FFA6]
	add  c
	ld   [$CF52], a
	ldh  a, [$FFA7]
	adc  a, b
	ld   [$CF53], a
	and  $F0
	cp   $A0
	jp   z, L00242F
	ld   a, [$CF53]
	inc  a
	ld   [wPl_Unk_Alt_Y], a
L002290:;R
	ldh  a, [$FFA5]
	ld   [$CF0D], a
	call L00332F
	ret  nc
	ld   a, [$CF54]
	ld   b, a
	ldh  a, [$FFA5]
	sub  b
	ld   [$CF0D], a
	call L00332F
	ret  nc
	ld   a, [$CF54]
	ld   b, a
	ldh  a, [$FFA5]
	add  b
	ld   [$CF0D], a
	call L00332F
	ret  nc
	ld   a, [$CF52]
	ldh  [$FFA6], a
	ld   a, [$CF53]
	ldh  [$FFA7], a
	ret
L0022C0: db $F0;X
L0022C1: db $A2;X
L0022C2: db $CB;X
L0022C3: db $77;X
L0022C4: db $20;X
L0022C5: db $31;X
L0022C6:;C
	ldh  a, [$FFAA]
	sub  $20
	ld   c, a
	ldh  a, [$FFAB]
	sbc  a, $00
	ld   b, a
	jr   nc, L0022DE
	ldh  a, [$FFA2]
	xor  $40
	ldh  [$FFA2], a
	xor  a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	ret
L0022DE:;R
	ld   a, c
	ldh  [$FFAA], a
	ld   a, b
	ldh  [$FFAB], a
	ldh  a, [$FFA6]
	sub  c
	ldh  [$FFA6], a
	ldh  a, [$FFA7]
	sbc  a, b
	ldh  [$FFA7], a
	and  $F0
	cp   $00
	jp   z, L00242F
	scf  
	ret
L0022F7:;C
	ldh  a, [$FFAA]
	add  $20
	ld   c, a
	ldh  a, [$FFAB]
	adc  a, $00
	ld   b, a
	cp   $04
	jr   c, L002308
	ld   bc, $0400
L002308:;R
	ld   a, c
	ldh  [$FFAA], a
	ld   a, b
	ldh  [$FFAB], a
	ldh  a, [$FFA6]
	add  c
	ldh  [$FFA6], a
	ldh  a, [$FFA7]
	adc  a, b
	ldh  [$FFA7], a
	and  $F0
	cp   $A0
	jp   z, L00242F
	scf  
	ret
L002321: db $F0;X
L002322: db $A2;X
L002323: db $CB;X
L002324: db $77;X
L002325: db $C2;X
L002326: db $A8;X
L002327: db $23;X
L002328:;C
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	ldi  a, [hl]
	ld   [$CF54], a
	ld   a, [hl]
	ld   [$CF55], a
	ldh  a, [$FFAA]
	sub  $20
	ld   c, a
	ldh  a, [$FFAB]
	sbc  a, $00
	ld   b, a
	jr   c, L00239D
	ld   a, c
	ldh  [$FFAA], a
	ld   a, b
	ldh  [$FFAB], a
	ldh  a, [$FFA6]
	sub  c
	ld   [$CF52], a
	ldh  a, [$FFA7]
	sbc  a, b
	ld   [$CF53], a
	ld   a, [$CF55]
	sla  a
	dec  a
	ld   b, a
	ld   a, [$CF53]
	sub  b
	ld   [wPl_Unk_Alt_Y], a
	ldh  a, [$FFA5]
	ld   [$CF0D], a
	call L00332F
	jr   nc, L00239E
	ld   a, [$CF54]
	ld   b, a
	ldh  a, [$FFA5]
	sub  b
	ld   [$CF0D], a
	call L00332F
	jr   nc, L00239E
	ld   a, [$CF54]
	ld   b, a
	ldh  a, [$FFA5]
	add  b
	ld   [$CF0D], a
	call L00332F
	jr   nc, L00239E
	ld   a, [$CF52]
	ldh  [$FFA6], a
	ld   a, [$CF53]
	ldh  [$FFA7], a
	and  $F0
	cp   $00
	jp   z, L00242F
	scf  
	ret
L00239D:;R
	ccf  
L00239E:;R
	push af
	xor  a
	ldh  [$FFA6], a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	pop  af
	ret
L0023A8:;C
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	ldi  a, [hl]
	ld   [$CF54], a
	ldh  a, [$FFAA]
	add  $20
	ld   c, a
	ldh  a, [$FFAB]
	adc  a, $00
	ld   b, a
	cp   $04
	jr   c, L0023C3
	ld   bc, $0400
L0023C3:;R
	ld   a, c
	ldh  [$FFAA], a
	ld   a, b
	ldh  [$FFAB], a
	ldh  a, [$FFA6]
	add  c
	ld   [$CF52], a
	ldh  a, [$FFA7]
	adc  a, b
	ld   [$CF53], a
	inc  a
	ld   [wPl_Unk_Alt_Y], a
	ldh  a, [$FFA5]
	ld   [$CF0D], a
	call L00332F
	jr   nc, L002413
	ld   a, [$CF54]
	ld   b, a
	ldh  a, [$FFA5]
	sub  b
	ld   [$CF0D], a
	call L00332F
	jr   nc, L002413
	ld   a, [$CF54]
	ld   b, a
	ldh  a, [$FFA5]
	add  b
	ld   [$CF0D], a
	call L00332F
	jr   nc, L002413
	ld   a, [$CF52]
	ldh  [$FFA6], a
	ld   a, [$CF53]
	ldh  [$FFA7], a
	and  $F0
	cp   $A0
	jp   z, L00242F
	ret
L002413:;R
	xor  a
	ldh  [$FFA6], a
	ldh  [$FFAA], a
	ldh  [$FFAB], a
	ldh  a, [$FFA7]
	or   $0F
	ldh  [$FFA7], a
	ret
L002421:;C
	ld   a, [$CF31]
	ld   b, a
	ldh  a, [$FFA5]
	add  b
	ldh  [$FFA5], a
	and  $F0
	cp   $D0
	ret  nz
L00242F:;J
	ldh  a, [$FFA0]
	cp   $E0
	jr   c, L00243D
	cp   $E4
	jr   nc, L00243D
	xor  a
	ld   [$CFF1], a
L00243D:;R
	xor  a
	ldh  [$FFA0], a
	ld   h, $C8
	ldh  a, [$FFA3]
	or   a
	ret  z
	ld   l, a
	ld   a, [hl]
	res  7, a
	ld   [hl], a
	ret
L00244C:;C
	push af
	ld   a, $03
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   a, [$CF2F]
	add  $05
	ld   l, a
	ld   h, $CE
	ld   a, [hl]
	or   a
	jr   z, L00246A
	dec  [hl]
	and  $02
	sla  a
	sla  a
	sla  a
L00246A:;R
	ld   b, a
	ld   a, [$CF67]
	or   b
	ld   [$CF52], a
	ldh  a, [$FFA0]
	and  $7F
	sla  a
	ld   hl, $4800
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   e, a
	ld   a, [hl]
	ld   d, a
	ld   l, e
	ld   h, d
	ld   a, [$CF38]
	sla  a
	ld   b, a
	ldh  a, [$FFA2]
	srl  a
	srl  a
	and  $0E
	add  b
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   e, a
	ld   a, [hl]
	ld   d, a
	ldh  a, [$FF97]
	ld   l, a
	ld   h, $DF
	ld   a, [de]
	or   a
	jp   z, L002508
	inc  de
	ld   b, a
	ldh  a, [$FFA2]
	bit  7, a
	jr   nz, L0024D4
L0024AE:;R
	ldh  a, [$FFA7]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	ldh  a, [$FFA5]
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
	ld   a, [$CF52]
	or   c
	ldi  [hl], a
	ld   a, l
	cp   $A0
	jr   z, L002500
	dec  b
	jr   nz, L0024AE
	ld   a, l
	ldh  [$FF97], a
	jr   L002508
L0024D4:;R
	ldh  a, [$FFA7]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	ldh  a, [$FFA5]
	ld   c, a
	ld   a, [de]
	inc  de
	xor  $FF
	sub  $07
	add  c
	ldi  [hl], a
	ld   a, [de]
	inc  de
	ldi  [hl], a
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [$CF52]
	or   c
	xor  $20
	ldi  [hl], a
	ld   a, l
	cp   $A0
	jr   z, L002500
	dec  b
	jr   nz, L0024D4
	ld   a, l
	ldh  [$FF97], a
	jr   L002508
L002500:;R
	ldh  [$FF97], a
	ld   a, [$CF2F]
	ld   [$CF30], a
L002508:;JR
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L002512: db $B4
L002513: db $3E
L002514: db $25
L002515: db $19
L002516: db $19
L002517: db $0D
L002518: db $0D
L002519: db $0D
L00251A: db $0D
L00251B: db $0D
L00251C: db $0D
L00251D: db $0D;X
L00251E: db $0D;X
L00251F: db $00
L002520: db $00;X
L002521: db $00;X
L002522: db $F7
L002523: db $B4
L002524: db $6D
L002525: db $56
L002526: db $3E
L002527: db $32
L002528: db $32
L002529: db $25
L00252A: db $25
L00252B: db $25
L00252C: db $19
L00252D: db $19;X
L00252E: db $19;X
L00252F: db $19;X
L002530: db $19;X
L002531: db $19;X
L002532: db $FC
L002533: db $E7
L002534: db $B4
L002535: db $83
L002536: db $6D
L002537: db $56
L002538: db $4A
L002539: db $3E
L00253A: db $3E
L00253B: db $32
L00253C: db $32
L00253D: db $32;X
L00253E: db $25;X
L00253F: db $25;X
L002540: db $25;X
L002541: db $25;X
L002542: db $FE
L002543: db $F0
L002544: db $DB
L002545: db $B4
L002546: db $8E
L002547: db $78
L002548: db $6D
L002549: db $56
L00254A: db $56
L00254B: db $4A
L00254C: db $3E
L00254D: db $3E;X
L00254E: db $3E;X
L00254F: db $32;X
L002550: db $32;X
L002551: db $32;X
L002552: db $FE
L002553: db $F7
L002554: db $E7
L002555: db $D4
L002556: db $B4
L002557: db $98
L002558: db $83
L002559: db $78
L00255A: db $62
L00255B: db $62
L00255C: db $56;X
L00255D: db $4A;X
L00255E: db $4A;X
L00255F: db $3E;X
L002560: db $3E;X
L002561: db $3E;X
L002562: db $FF
L002563: db $FA
L002564: db $F0
L002565: db $E1
L002566: db $CD
L002567: db $B4
L002568: db $98
L002569: db $8E
L00256A: db $78;X
L00256B: db $6D;X
L00256C: db $62;X
L00256D: db $62;X
L00256E: db $56;X
L00256F: db $56;X
L002570: db $4A;X
L002571: db $4A;X
L002572: db $FF
L002573: db $FA
L002574: db $F4
L002575: db $E7
L002576: db $DB
L002577: db $CD
L002578: db $B4
L002579: db $A2
L00257A: db $8E;X
L00257B: db $83;X
L00257C: db $78;X
L00257D: db $6D;X
L00257E: db $62;X
L00257F: db $62;X
L002580: db $56;X
L002581: db $56;X
L002582: db $FF
L002583: db $FC
L002584: db $F7
L002585: db $F0
L002586: db $E1
L002587: db $D4
L002588: db $C5
L002589: db $B4;X
L00258A: db $A2;X
L00258B: db $98;X
L00258C: db $83;X
L00258D: db $78;X
L00258E: db $78;X
L00258F: db $6D;X
L002590: db $62;X
L002591: db $62;X
L002592: db $FF
L002593: db $FC
L002594: db $F7
L002595: db $F0
L002596: db $EC
L002597: db $E1;X
L002598: db $D4;X
L002599: db $C5;X
L00259A: db $B4;X
L00259B: db $A2;X
L00259C: db $98;X
L00259D: db $8E;X
L00259E: db $83;X
L00259F: db $78;X
L0025A0: db $6D;X
L0025A1: db $6D;X
L0025A2: db $FF
L0025A3: db $FC
L0025A4: db $FA
L0025A5: db $F4
L0025A6: db $EC
L0025A7: db $E7;X
L0025A8: db $DB;X
L0025A9: db $CD;X
L0025AA: db $C5;X
L0025AB: db $B4;X
L0025AC: db $A2;X
L0025AD: db $98;X
L0025AE: db $8E;X
L0025AF: db $83;X
L0025B0: db $83;X
L0025B1: db $78;X
L0025B2: db $FF
L0025B3: db $FE
L0025B4: db $FA
L0025B5: db $F7
L0025B6: db $F0;X
L0025B7: db $EC;X
L0025B8: db $E1;X
L0025B9: db $DB;X
L0025BA: db $CD;X
L0025BB: db $C5;X
L0025BC: db $B4;X
L0025BD: db $AB;X
L0025BE: db $98;X
L0025BF: db $8E;X
L0025C0: db $8E;X
L0025C1: db $83;X
L0025C2: db $FF;X
L0025C3: db $FE;X
L0025C4: db $FA;X
L0025C5: db $F7;X
L0025C6: db $F4;X
L0025C7: db $EC;X
L0025C8: db $E7;X
L0025C9: db $E1;X
L0025CA: db $D4;X
L0025CB: db $CD;X
L0025CC: db $BD;X
L0025CD: db $B4;X
L0025CE: db $AB;X
L0025CF: db $A2;X
L0025D0: db $98;X
L0025D1: db $8E;X
L0025D2: db $FF;X
L0025D3: db $FE;X
L0025D4: db $FC;X
L0025D5: db $F7;X
L0025D6: db $F4;X
L0025D7: db $F0;X
L0025D8: db $EC;X
L0025D9: db $E1;X
L0025DA: db $DB;X
L0025DB: db $D4;X
L0025DC: db $CD;X
L0025DD: db $BD;X
L0025DE: db $B4;X
L0025DF: db $AB;X
L0025E0: db $A2;X
L0025E1: db $98;X
L0025E2: db $FF
L0025E3: db $FE;X
L0025E4: db $FC;X
L0025E5: db $FA;X
L0025E6: db $F7;X
L0025E7: db $F0;X
L0025E8: db $EC;X
L0025E9: db $E7;X
L0025EA: db $E1;X
L0025EB: db $DB;X
L0025EC: db $D4;X
L0025ED: db $C5;X
L0025EE: db $BD;X
L0025EF: db $B4;X
L0025F0: db $AB;X
L0025F1: db $A2;X
L0025F2: db $FF;X
L0025F3: db $FE;X
L0025F4: db $FC;X
L0025F5: db $FA;X
L0025F6: db $F7;X
L0025F7: db $F4;X
L0025F8: db $F0;X
L0025F9: db $EC;X
L0025FA: db $E7;X
L0025FB: db $DB;X
L0025FC: db $D4;X
L0025FD: db $CD;X
L0025FE: db $C5;X
L0025FF: db $BD;X
L002600: db $B4;X
L002601: db $AB;X
L002602: db $FF;X
L002603: db $FE;X
L002604: db $FC;X
L002605: db $FA;X
L002606: db $F7;X
L002607: db $F4;X
L002608: db $F0;X
L002609: db $EC;X
L00260A: db $E7;X
L00260B: db $E1;X
L00260C: db $DB;X
L00260D: db $D4;X
L00260E: db $CD;X
L00260F: db $C5;X
L002610: db $BD;X
L002611: db $B4;X
L002612: db $FF
L002613: db $FF
L002614: db $FF
L002615: db $FF
L002616: db $FF
L002617: db $FF
L002618: db $FF
L002619: db $FE
L00261A: db $FE
L00261B: db $FD
L00261C: db $FC
L00261D: db $FB
L00261E: db $FA
L00261F: db $F9
L002620: db $F8
L002621: db $F7
L002622: db $F6
L002623: db $F5
L002624: db $F3
L002625: db $F2
L002626: db $F1
L002627: db $EF
L002628: db $ED
L002629: db $EC
L00262A: db $EA
L00262B: db $E8
L00262C: db $E6
L00262D: db $E4
L00262E: db $E2
L00262F: db $E0
L002630: db $DE
L002631: db $DB
L002632: db $D9
L002633: db $D7
L002634: db $D4
L002635: db $D2
L002636: db $CF
L002637: db $CC
L002638: db $CA
L002639: db $C7
L00263A: db $C4
L00263B: db $C1
L00263C: db $BE
L00263D: db $BB
L00263E: db $B8
L00263F: db $B5
L002640: db $B2
L002641: db $AF
L002642: db $AB
L002643: db $A8
L002644: db $A5
L002645: db $A1
L002646: db $9E
L002647: db $9A
L002648: db $96
L002649: db $93
L00264A: db $8F
L00264B: db $8B
L00264C: db $88
L00264D: db $84
L00264E: db $80
L00264F: db $7C
L002650: db $78
L002651: db $74
L002652: db $70
L002653: db $6C
L002654: db $68
L002655: db $64
L002656: db $60
L002657: db $5C
L002658: db $58
L002659: db $53
L00265A: db $4F
L00265B: db $4B
L00265C: db $47
L00265D: db $42
L00265E: db $3E
L00265F: db $3A
L002660: db $35
L002661: db $31
L002662: db $2C
L002663: db $28
L002664: db $24
L002665: db $1F
L002666: db $1B
L002667: db $16
L002668: db $12
L002669: db $0D
L00266A: db $09
L00266B: db $04;X
L00266C: db $00;X
L00266D:;JR
	ld   sp, $E000
	push af
	ld   a, $01
	ldh  [$FF9D], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L000BED
	call L002B99
	jr   z, L00269E
	call L014CDD ; BANK $01
	jr   c, L00266D
	ld   a, [$CFDE]
	cp   $FF
	jp   z, L002752
	ld   a, [$CFDE]
	and  $E1
	jr   nz, L00270C
	ld   a, [$CFDE]
	cp   $1E
	jr   z, L0026E4
L00269E:;R
	call L002C0C
	ld   a, $01
	ld   [wLvlRoomId], a
	call L002AC7
	call L002ADE
L0026AC:;R
	call L0027C9
	cp   $02
	jr   z, L0026CC
	call L002862
	jr   c, L0026AC
	ld   a, [$CF6E]
	bit  1, a
	jr   z, L00269E
	ld   a, $01
	ld   [wLvlRoomId], a
	call L002AC7
	call L002ADE
	jr   L0026AC
L0026CC:;R
	call L00299F
	call L002A6F
	call L002FAA
	call L014F69 ; BANK $01
	call L000BFC
	ld   a, [$CFDE]
	and  $1E
	cp   $1E
	jr   nz, L00269E
L0026E4:;X
	call L003156
	call L003174
	call L0006D2
	ld   a, $10
	ldh  [$FF98], a
	call L000624
	ld   a, $01
	ld   [wLvlRoomId], a
	ld   a, $08
	ld   [$CF0A], a
	call L002AC7
	call L002ADE
	call L0031BE
	call L0032C6
	jr   L00271F
L00270C:;R
	ld   a, $03
	ld   [wLvlRoomId], a
	ld   a, $08
	ld   [$CF0A], a
	call L002AC7
	call L0032C6
	call L002ADE
L00271F:;R
	call L0027C9
	cp   $02
	jr   z, L00273F
	call L002862
	jr   c, L00271F
	ld   a, [$CF6E]
	bit  1, a
	jr   z, L00270C
	ld   a, $01
	ld   [wLvlRoomId], a
	call L002AC7
	call L002ADE
	jr   L00271F
L00273F:;R
	call L00299F
	call L002A6F
	call L002FAA
	call L014F69 ; BANK $01
	ld   a, [$CFDE]
	cp   $FF
	jr   nz, L00270C
L002752:;X
	ld   a, $04
	ld   [wLvlRoomId], a
	ld   a, $08
	ld   [$CF0A], a
	call L002AC7
	call L002ADE
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
	ld   [$CF0A], a
	call L002AC7
	call L002ADE
L002798:;R
	ld   hl, $CFDD
	set  3, [hl]
	call L0027C9
	cp   $02
	jr   z, L0027BD
	call L002862
	jr   c, L002798
	ld   a, [$CF6E]
	bit  1, a
	jr   z, L002785
L0027B0: db $3E;X
L0027B1: db $01;X
L0027B2: db $EA;X
L0027B3: db $0B;X
L0027B4: db $CF;X
L0027B5: db $CD;X
L0027B6: db $C7;X
L0027B7: db $2A;X
L0027B8: db $CD;X
L0027B9: db $DE;X
L0027BA: db $2A;X
L0027BB: db $18;X
L0027BC: db $DB;X
L0027BD:;R
	call L00299F
	call L01551D ; BANK $01
	call L015827 ; BANK $01
L0027C6: db $C3;X
L0027C7: db $C6;X
L0027C8: db $27;X
L0027C9:;JCR
	rst  $08
	ld   hl, $FFB6
	ldh  a, [hTimer]
	and  $07
	cp   $05
	jr   c, L0027D6
	inc  hl
L0027D6:;R
	ld   a, [hl]
	ldh  [hBGP], a
L0027D9:;R
	call JoyKeys_Sync
	ldh  a, [hJoyNewKeys]
	bit  3, a
	jr   z, L0027EA
	call Ev_WaitAll
	call L00375C
	jr   L0027C9
L0027EA:;R
	bit  2, a
	jr   z, L0027F8
	ldh  a, [$FFF9]
	or   a
	jr   z, L0027F8
L0027F3: db $CD;X
L0027F4: db $EC;X
L0027F5: db $51;X
L0027F6: db $18;X
L0027F7: db $D1;X
L0027F8:;R
	xor  a
	ldh  [$FF97], a
	ldh  a, [hTimer]
	ld   [$CF39], a
	call L000CB0
	call L00354A
	call L0143B4 ; BANK $01
	push af
	ld   a, BANK(L024000) ; BANK $02
	ldh  [$FF9D], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L024000
	push af
	ld   a, $01
	ldh  [$FF9D], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L000667
	ld   hl, hTimer
	ld   a, [$CF39]
	cp   a, [hl]
	jr   nz, L0027D9
	call L002AF3
	ld   a, [$CF60]
	or   a
	jr   z, L0027C9
	push af
	call L0017D2
	call L0039EF
	xor  a
	ld   [$CF67], a
	ld   [$CF6F], a
	ld   [$CF31], a
	pop  af
	cp   $03
	ret  c
	swap a
	dec  a
	and  $03
	ld   [$CF0A], a
	ld   a, $01
	ld   [wLvlRoomId], a
	call L002AC7
	call L002ADE
	jp   L0027C9
L002862:;C
	xor  a
	ld   [$CFF3], a
	ld   [$CFF2], a
	ld   [$CF71], a
	ld   hl, $CF70
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
	ldh  [$FF98], a
	ld   a, $06
	ldh  [$FF99], a
L002887:;R
	ld   a, [$CF63]
	ld   [$CF2B], a
	ld   a, [$CF64]
	ld   [$CF2C], a
	call L001C8D
L002896:;R
	rst  $08
	xor  a
	ldh  [$FF97], a
	call L0143B4 ; BANK $01
	push af
	ld   a, BANK(L024000) ; BANK $02
	ldh  [$FF9D], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L024000
	push af
	ld   a, $01
	ldh  [$FF9D], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L000667
	call L002AF3
	pop  bc
	dec  b
	jr   nz, L002873
	ld   a, [$CFE8]
	sub  $01
	ld   [$CFE8], a
	jr   c, L00292C
	ld   a, [$CF0A]
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
	cp   a, [hl]
	jr   nc, L002908
	dec  hl
	cp   a, [hl]
	jr   nc, L0028F3
	dec  hl
	cp   a, [hl]
	jr   nc, L0028F3
	dec  hl
L0028F3:;R
	ld   a, [hl]
	ld   [wLvlRoomId], a
	ld   a, $01
	ld   [$CF7F], a
	call L002AC7
	call L002ADE
	xor  a
	ld   [$CF7F], a
	scf  
	ret
L002908:;R
	ld   a, [hl]
	ld   [wLvlRoomId], a
	ld   a, $01
	ld   [$CF7F], a
	call L002AC7
	ld   b, $10
L002916:;R
	push bc
	call L000DD7
	pop  bc
	dec  b
	jr   nz, L002916
	call L002ADE
	ld   a, $01
	ld   [$CF3A], a
	xor  a
	ld   [$CF7F], a
	scf  
	ret
L00292C:;R
	ld   a, $04
	ldh  [$FF98], a
	call L014F69 ; BANK $01
	call L000BF7
	ld   a, $07
	call L0003CC
	ld   de, $2953
	call Scr_ApplyPkg
	call L0006D2
L002944:;R
	rst  $08
	call JoyKeys_Sync
	ldh  a, [hJoyNewKeys]
	and  $03
	jr   z, L002944
	ld   [$CF6E], a
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
	ld   [$CF1D], a
	ld   [$CF73], a
	ld   hl, $CF70
	set  2, [hl]
	dec  a
	ld   [$CF5D], a
	ld   [$CF4A], a
	ld   [$CF6B], a
	ld   [$CF6A], a
	call L002A81
	ld   a, $00
	ldh  [$FF98], a
	ld   b, $C0
L0029C5:;R
	ld   a, b
	push bc
	and  $3F
	jr   nz, L0029DE
	ld   a, $06
	ldh  [$FF99], a
	ld   a, [$CF63]
	ld   [$CF2B], a
	ld   a, [$CF64]
	ld   [$CF2C], a
	call L001C8D
L0029DE:;R
	call L002A97
	pop  bc
	dec  b
	jr   nz, L0029C5
	ld   a, $06
	ldh  [$FF98], a
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
	ld   [$CF1D], a
	ld   a, $03
	ld   [$CF1A], a
	ld   a, $80
	ld   [$CF1B], a
	xor  a
	ldh  [hJoyKeys], a
	ldh  [hJoyNewKeys], a
L002A17:;R
	call L002A97
	ld   a, [$CF1D]
	cp   $03
	jr   nz, L002A17
	ld   a, $0F
	ld   [$CF1D], a
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
	call L001CC2
	ld   a, $0F
	ldh  [$FF99], a
	jr   L002A50
L002A4D:;R
	call L002A81
L002A50:;R
	call L002A97
	pop  bc
	dec  b
	jr   nz, L002A28
	ld   a, $03
	ld   [$CF1D], a
L002A5C:;R
	call L002A97
	ld   a, [$CF1D]
	or   a
	jr   nz, L002A5C
	ld   a, $15
	ld   [$CF1D], a
	ld   b, $78
	jp   L002A90
L002A6F:;C
	ld   a, [$CF0A]
	ld   hl, $3C1A
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [$CFDE]
	or   [hl]
	ld   [$CFDE], a
	ret
L002A81:;C
	ld   bc, $1000
	ld   de, $0010
	ld   hl, $CD00
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
	rst  $08
	xor  a
	ldh  [$FF97], a
	call L000CB0
	call L0143B4 ; BANK $01
	push af
	ld   a, BANK(L024000); BANK $02
	ldh  [$FF9D], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L024000
	push af
	ld   a, $01
	ldh  [$FF9D], a
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L000667
	call L002AF3
	pop  bc
	pop  de
	pop  hl
	ret
L002AC7:;C
	ld   a, $03
	call L0003CC
	call L0007C6
	call L0008B6
	call L0008F4
	call L000C08
	call L001BD9
	jp   L001C25
L002ADE:;C
	call L0006D2
	call L000C9C
	ld   a, [$CF0A]
	ld   hl, $3C38
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   a, a
	ldh  [$FF98], a
	ret
L002AF3:;C
	ld   a, [$CF4C]
	inc  a
	ld   [$CF4C], a
	cp   $3C
	jr   nz, L002B06
	xor  a
	ld   [$CF4C], a
	ld   hl, $CF4D
	inc  [hl]
L002B06:;R
	xor  a
	ld   hl, wLvlScrollEvMode
	or   [hl]
	ld   hl, wPkgEv
	or   [hl]
	ret  nz
	ld   a, [$CFF3]
	or   a
	jr   z, L002B3B
	dec  a
	ld   [$CFF3], a
	ld   a, [$CFD0]
	ld   c, a
	inc  a
	cp   $98
	jr   c, L002B25
	ld   a, $98
L002B25:;R
	ld   b, a
	ld   [$CFD0], a
	xor  c
	and  $08
	jr   z, L002B3B
	ld   a, b
	ld   [$CF71], a
	ld   hl, $CF70
	set  0, [hl]
	ld   a, $07
	ldh  [$FF99], a
L002B3B:;R
	ld   a, [$CFF2]
	or   a
	jr   z, L002B6A
	dec  a
	ld   [$CFF2], a
	ld   a, [$CFDF]
	or   a
	ret  z
	ld   a, [$CFE0]
	ld   c, a
	inc  a
	cp   $98
	jr   c, L002B55
	ld   a, $98
L002B55:;R
	ld   b, a
	ld   [$CFE0], a
	xor  c
	and  $08
	ret  z
	ld   a, b
	ld   [$CF72], a
	ld   hl, $CF70
	set  1, [hl]
	ld   a, $07
	ldh  [$FF99], a
L002B6A:;R
	ld   a, [$CF70]
	ld   b, a
	ld   hl, $CF71
	ld   c, $00
	ldi  a, [hl]
	bit  0, b
	call nz, L003A25
	inc  c
	ldi  a, [hl]
	bit  1, b
	call nz, L003A25
	inc  c
	ldi  a, [hl]
	bit  2, b
	call nz, L003A25
	ld   a, [hl]
	bit  3, b
	call nz, L003A9A
	ld   a, b
	or   a
	ret  z
	xor  a
	ld   [$CF70], a
	inc  a
	ld   [wPkgBarEv], a
	ret
L002B99:;C
	xor  a
	call L0003CC
	push af
	ld   a, $04
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   de, $4000
	call Scr_ApplyPkg
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L0006D2
	ld   a, $01
	ldh  [$FF98], a
	ld   hl, $DF00
	ld   a, $68
	ldi  [hl], a
	ld   a, $2E
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ld   [hl], a
L002BC8:;R
	ld   a, [$DF00]
	xor  $08
	ld   [$DF00], a
L002BD0:;R
	rst  $08
	ldh  a, [hTimer]
	and  $03
	jr   nz, L002BE5
	ld   b, $E4
	call L000755
	cp   $20
	jr   nc, L002BE2
	ld   b, $C0
L002BE2:;R
	ld   a, b
	ldh  [hBGP], a
L002BE5:;R
	ldh  a, [hTimer]
	and  $1C
	srl  a
	srl  a
	ld   [$DF02], a
	call JoyKeys_Sync
	ldh  a, [hJoyNewKeys]
	and  $CD
	jr   z, L002BD0
	and  $C4
	jr   z, L002C03
	ld   a, $12
	ldh  [$FF99], a
	jr   L002BC8
L002C03:;R
	xor  a
	ldh  [$FFF9], a
	ld   a, [$DF00]
	and  $08
	ret
L002C0C:;C
	ld   a, $01
	call L0003CC
	push af
	ld   a, $04
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   de, $5000
	call Scr_ApplyPkg
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   a, [$CFDE]
	rra  
	ld   c, a
	ld   b, $04
L002C30:;R
	push bc
	srl  c
	jr   nc, L002C40
	ld   a, b
	dec  a
	call L002F80
	ld   de, wScrEvRows
	call Scr_ApplyPkg
L002C40:;R
	pop  bc
	srl  c
	dec  b
	jr   nz, L002C30
	ld   a, $07
	ldh  [hWinX], a
	ld   a, $48
	ldh  [hWinY], a
	ld   a, $01
	call L0006D2
	ld   a, $02
	ldh  [$FF98], a
	xor  a
	ld   [$CF66], a
L002C5B:;R
	rst  $08
	call L002CAA
	call JoyKeys_Sync
	ldh  a, [hJoyNewKeys]
	ld   c, a
	or   a
	jr   z, L002C5B
	ld   a, [$CF66]
	ld   b, a
	ld   a, c
	and  $09
	jr   z, L002C88
	ld   a, b
	xor  $04
	ld   [$CF0A], a
	ld   hl, $3C1A
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   b, [hl]
	ld   a, [$CFDE]
	and  b
	jr   nz, L002C5B
	jp   L002D15
L002C88:;R
	ld   a, c
	and  $30
	jr   z, L002C99
	ld   a, b
	xor  $01
	ld   [$CF66], a
	ld   a, $12
	ldh  [$FF99], a
	jr   L002C5B
L002C99:;R
	ld   a, c
	and  $C0
	jr   z, L002C5B
	ld   a, b
	xor  $02
	ld   [$CF66], a
	ld   a, $12
	ldh  [$FF99], a
	jr   L002C5B
L002CAA:;C
	ld   a, [$CF66]
	and  $03
	swap a
	ld   hl, $2CD5
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   de, $DF00
	ld   bc, $0010
	call L0006B9
	ldh  a, [hTimer]
	sla  a
	and  $10
	ld   b, $04
	ld   hl, $DF03
L002CCC:;R
	ldi  [hl], a
	inc  l
	inc  l
	inc  l
	dec  b
	jr   nz, L002CCC
	xor  a
	ret
L002CD5: db $18
L002CD6: db $18
L002CD7: db $3F
L002CD8: db $00
L002CD9: db $40
L002CDA: db $18
L002CDB: db $3F
L002CDC: db $00
L002CDD: db $18
L002CDE: db $40
L002CDF: db $3F
L002CE0: db $00
L002CE1: db $40
L002CE2: db $40
L002CE3: db $3F
L002CE4: db $00
L002CE5: db $18
L002CE6: db $68
L002CE7: db $3F
L002CE8: db $00
L002CE9: db $40
L002CEA: db $68
L002CEB: db $3F
L002CEC: db $00
L002CED: db $18
L002CEE: db $90
L002CEF: db $3F
L002CF0: db $00
L002CF1: db $40
L002CF2: db $90
L002CF3: db $3F
L002CF4: db $00
L002CF5: db $68
L002CF6: db $18
L002CF7: db $3F
L002CF8: db $00
L002CF9: db $90
L002CFA: db $18
L002CFB: db $3F
L002CFC: db $00
L002CFD: db $68
L002CFE: db $40
L002CFF: db $3F
L002D00: db $00
L002D01: db $90
L002D02: db $40
L002D03: db $3F
L002D04: db $00
L002D05: db $68
L002D06: db $68
L002D07: db $3F
L002D08: db $00
L002D09: db $90
L002D0A: db $68
L002D0B: db $3F
L002D0C: db $00
L002D0D: db $68
L002D0E: db $90
L002D0F: db $3F
L002D10: db $00
L002D11: db $90
L002D12: db $90
L002D13: db $3F
L002D14: db $00
L002D15:;J
	ld   hl, $3C12
	ld   a, [$CF0A]
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	call ActS_LoadGFXForRoom.loadBySetId
	call L00065F
	ld   a, $03
	ldh  [$FF98], a
	call L000612
	rst  $20
	ld   a, [$CF0A]
	call L002F80
	rst  $10
	call L001BD9
	ld   a, [$CF0A]
	add  $68
	ld   [$CF2D], a
	xor  a
	ld   [$CF2E], a
	ld   a, [$CF0A]
	and  $03
	add  a
	ld   hl, $2F28
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   [$CF2B], a
	ld   a, [hl]
	ld   [$CF2C], a
	call L001D48
	call L002EC4
	ld   b, $24
L002D61:;R
	ld   hl, hScrollY
	inc  [hl]
	inc  [hl]
	ld   hl, hWinY
	inc  [hl]
	inc  [hl]
	call L002E00
	dec  b
	jr   nz, L002D61
	ld   d, $98
	ld   e, $E0
	ld   b, $09
L002D77:;R
	call L002F0F
	ld   a, e
	sub  $20
	ld   e, a
	ld   a, d
	sbc  a, $00
	ld   d, a
	call L002E00
	dec  b
	jr   nz, L002D77
	ld   d, $9C
	ld   e, $20
	ld   b, $09
L002D8E:;R
	call L002F0F
	ld   a, e
	add  $20
	ld   e, a
	ld   a, d
	adc  a, $00
	ld   d, a
	call L002E00
	dec  b
	jr   nz, L002D8E
	ld   b, $18
L002DA1:;R
	ld   hl, hScrollY
	dec  [hl]
	dec  [hl]
	ld   hl, hWinY
	dec  [hl]
	dec  [hl]
	call L002E00
	dec  b
	jr   nz, L002DA1
L002DB1:;R
	call L002E00
	ldh  a, [$FFA1]
	cp   $06
	jr   nz, L002DB1
	ld   hl, $7C00
	ld   de, $9400
	ld   bc, $0B20
	call GfxCopy_Req
	ld   a, $08
	call L002DF7
	ld   a, [$CF0A]
	add  a
	ld   b, a
	add  a
	add  a
	add  b
	ld   hl, $2F30
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   de, wScrEvRows
	ld   a, $99
	ld   [de], a
	inc  de
	ld   a, $A5
	ld   [de], a
	inc  de
	ld   a, $0A
	ld   [de], a
	inc  de
	ld   bc, $000A
	call L0006B9
	xor  a
	ld   [de], a
	inc  a
	ld   [wPkgEv], a
	ld   a, $B4
L002DF7:;CR
	push af
	call L002E00
	pop  af
	dec  a
	jr   nz, L002DF7
	ret
L002E00:;C
	push hl
	push de
	push bc
	xor  a
	ldh  [$FF97], a
	ld   hl, $CD00
	ld   de, $FFA0
	ld   b, $10
L002E0E:;R
	ldi  a, [hl]
	ld   [de], a
	inc  de
	dec  b
	jr   nz, L002E0E
	ld   a, $00
	ld   [$CF38], a
	call L002E35
	call L00244C
	ld   hl, $FFA0
	ld   de, $CD00
	ld   b, $10
L002E27:;R
	ldi  a, [hl]
	ld   [de], a
	inc  de
	dec  b
	jr   nz, L002E27
	call L000667
	rst  $08
	pop  bc
	pop  de
	pop  hl
	ret
L002E35:;C
	ldh  a, [$FFA1]
	rst  $00
L002E38: db $46
L002E39: db $2E
L002E3A: db $70
L002E3B: db $2E
L002E3C: db $80
L002E3D: db $2E
L002E3E: db $90
L002E3F: db $2E
L002E40: db $9A
L002E41: db $2E
L002E42: db $AC
L002E43: db $2E
L002E44: db $C0
L002E45: db $2E
L002E46:;I
	ld   a, [$CF0A]
	rrca 
	and  $80
	xor  $80
	ldh  [$FFA2], a
	ld   bc, $01A0
	ld   a, [$CF0A]
	bit  1, a
	jr   z, L002E5D
	ld   bc, $03B0
L002E5D:;R
	xor  a
	ldh  [$FFA8], a
	inc  a
	ldh  [$FFA9], a
	ld   a, c
	ldh  [$FFAA], a
	ld   a, b
	ldh  [$FFAB], a
	ld   a, $28
	ldh  [$FFAC], a
	jp   L001EB1
L002E70:;I
	ldh  a, [$FFAC]
	sub  $01
	ldh  [$FFAC], a
	call L002150
	call L0022C6
	ret  c
	jp   L001EB1
L002E80:;I
	call L002150
	call L0022F7
	ldh  a, [$FFAC]
	sub  $01
	ldh  [$FFAC], a
	ret  nz
	jp   L001EB1
L002E90:;I
	xor  a
	ldh  [$FFA2], a
	ld   a, $20
	ldh  [$FFAC], a
	jp   L001EB1
L002E9A:;I
	ldh  a, [$FFAC]
	sub  $01
	ldh  [$FFAC], a
	ret  nz
	ld   de, $0002
	ld   c, $1E
	call L001F7D
	jp   L001EB1
L002EAC:;I
	call L002ED9
	call L001F8B
	ret  z
	ld   a, $00
	ld   [$CF38], a
	ld   a, $01
	call L001F34
	jp   L001EB1
L002EC0:;I
	call L002ED9
	ret
L002EC4:;C
	ld   b, $18
	ld   hl, $CF90
L002EC9:;R
	call L000755
	and  $F8
	ldi  [hl], a
	call L000755
	and  $F8
	ldi  [hl], a
	dec  b
	jr   nz, L002EC9
	ret
L002ED9:;C
	ld   h, $DF
	ldh  a, [$FF97]
	ld   l, a
	ld   de, $CF90
	ld   b, $18
L002EE3:;R
	push bc
	ld   c, $01
	ld   a, b
	cp   $0C
	jr   c, L002EED
	ld   c, $02
L002EED:;R
	ld   a, [de]
	sub  c
	ld   [de], a
	inc  de
	ld   b, a
	ld   a, [de]
	add  c
	ld   [de], a
	inc  de
	cp   $38
	jr   c, L002EFE
	cp   $78
	jr   c, L002F07
L002EFE:;R
	ldi  [hl], a
	ld   a, b
	ldi  [hl], a
	ld   a, $25
	add  c
	ldi  [hl], a
	xor  a
	ldi  [hl], a
L002F07:;R
	pop  bc
	dec  b
	jr   nz, L002EE3
	ld   a, l
	ldh  [$FF97], a
	ret
L002F0F:;C
	ld   hl, wScrEvRows
	ld   [hl], d
	inc  l
	ld   [hl], e
	ld   a, $54
	ld   [$DD02], a
	ld   a, $14
	ld   [$DD03], a
	xor  a
	ld   [$DD04], a
	inc  a
	ld   [wPkgEv], a
	ret
L002F28: db $30
L002F29: db $3B
L002F2A: db $80
L002F2B: db $3B
L002F2C: db $30
L002F2D: db $8C
L002F2E: db $80
L002F2F: db $8C
L002F30: db $40;X
L002F31: db $48;X
L002F32: db $41;X
L002F33: db $52;X
L002F34: db $44;X
L002F35: db $40;X
L002F36: db $4D;X
L002F37: db $41;X
L002F38: db $4E;X
L002F39: db $40;X
L002F3A: db $40;X
L002F3B: db $54;X
L002F3C: db $4F;X
L002F3D: db $50;X
L002F3E: db $40;X
L002F3F: db $40;X
L002F40: db $4D;X
L002F41: db $41;X
L002F42: db $4E;X
L002F43: db $40;X
L002F44: db $4D;X
L002F45: db $41;X
L002F46: db $47;X
L002F47: db $4E;X
L002F48: db $45;X
L002F49: db $54;X
L002F4A: db $40;X
L002F4B: db $4D;X
L002F4C: db $41;X
L002F4D: db $4E;X
L002F4E: db $4E;X
L002F4F: db $45;X
L002F50: db $45;X
L002F51: db $44;X
L002F52: db $4C;X
L002F53: db $45;X
L002F54: db $40;X
L002F55: db $4D;X
L002F56: db $41;X
L002F57: db $4E;X
L002F58: db $43
L002F59: db $4C
L002F5A: db $41
L002F5B: db $53
L002F5C: db $48
L002F5D: db $40
L002F5E: db $40
L002F5F: db $4D
L002F60: db $41
L002F61: db $4E
L002F62: db $4D
L002F63: db $45
L002F64: db $54
L002F65: db $41
L002F66: db $4C
L002F67: db $40
L002F68: db $40
L002F69: db $4D
L002F6A: db $41
L002F6B: db $4E
L002F6C: db $40
L002F6D: db $57
L002F6E: db $4F
L002F6F: db $4F
L002F70: db $44
L002F71: db $40
L002F72: db $4D
L002F73: db $41
L002F74: db $4E
L002F75: db $40
L002F76: db $40
L002F77: db $41
L002F78: db $49
L002F79: db $52
L002F7A: db $40
L002F7B: db $40
L002F7C: db $4D
L002F7D: db $41
L002F7E: db $4E
L002F7F: db $40
L002F80:;C
	and  $03
	add  a
	ld   hl, $2FA2
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   e, [hl]
	inc  hl
	ld   d, [hl]
	ld   hl, wScrEvRows
	ld   b, $04
L002F92:;R
	ld   [hl], d
	inc  hl
	ld   [hl], e
	inc  hl
	ld   a, $C4
	ldi  [hl], a
	ld   a, $1F
	ldi  [hl], a
	inc  e
	dec  b
	jr   nz, L002F92
	ld   [hl], a
	ret
L002FA2: db $43
L002FA3: db $98
L002FA4: db $4D
L002FA5: db $98
L002FA6: db $63
L002FA7: db $9C
L002FA8: db $6D
L002FA9: db $9C
L002FAA:;C
	ld   a, $04
	call L0003CC
	push af
	ld   a, $04
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   de, $5180
	call Scr_ApplyPkg
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	call L0006D2
	ld   a, $07
	ldh  [$FF98], a
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
	ld   a, [$CF0A]
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
	ld   [$CF7B], a
	ld   a, d
	ld   [$CF7C], a
L003012:;R
	ldi  a, [hl]
	ld   b, a
	cp   $2E
	ret  z
	cp   $20
	jr   z, L003052
	cp   $2F
	jr   nz, L003033
	ld   a, [$CF7B]
	add  $20
	ld   [$CF7B], a
	ld   e, a
	ld   a, [$CF7C]
	adc  a, $00
	ld   [$CF7C], a
	ld   d, a
	jr   L003012
L003033:;R
	ld   a, d
	ld   [wScrEvRows], a
	ld   a, e
	ld   [$DD01], a
	ld   a, $01
	ld   [$DD02], a
	ld   a, b
	or   $80
	ld   [$DD03], a
	xor  a
	ld   [$DD04], a
	inc  a
	ld   [wPkgEv], a
	ld   a, $0B
	ldh  [$FF99], a
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
	ld   a, $05
	call L0003CC
	push af
	ld   a, $04
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   de, $53C0
	call Scr_ApplyPkg
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ret
L003174:;C
	ld   hl, $3180
	ld   de, $DF00
	ld   bc, $0020
	jp   L0006B9
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
	ld   a, $06
	call L0003CC
	push af
	ld   a, $04
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   de, $5540
	call Scr_ApplyPkg
	push af
	ldh  a, [$FF9D]
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
	ld   a, [$CF1D]
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
	ld   a, [$CF1D]
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
	ld   [$CF79], a
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
	ld   [$CF1D], a
	ld   hl, $4F00
	ld   de, $8500
	ld   bc, $0B08
	call GfxCopy_Req
	rst  $20
	ld   a, $7B
	ld   [$CF2D], a
	xor  a
	ld   [$CF2E], a
	ld   a, $88
	ld   [$CF2C], a
	ld   a, $50
	ld   [$CF2B], a
	call L001D48
	ld   b, $0F
	call L002A90
	ld   a, $60
	ld   [$CF2B], a
	call L001D48
	ld   b, $0F
	call L002A90
	ld   a, $58
	ld   [$CF2B], a
	call L001D48
	ld   b, $3C
	call L002A90
	ld   hl, $32B7
	ld   de, wScrEvRows
	ld   bc, $000F
	call L0006B9
	ld   a, $01
	ld   [wPkgEv], a
	xor  a
	ld   [$CF1D], a
	ld   b, $08
	jp   L002A90
L00329F:;C
	ld   a, [$CF79]
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
	ld   hl, $CF79
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
	ld   a, [$CFDE]
	and  $40
	call nz, L0032EF
	ld   b, $01
	ld   a, [$CFDE]
	and  $01
	call nz, L0032EF
	ld   b, $02
	ld   a, [$CFDE]
	and  $80
	call nz, L0032EF
	ld   b, $03
	ld   a, [$CFDE]
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
	call Scr_ApplyPkg
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
L00332F:;JC
	ld   a, $F0
	ld   [$CF1C], a
	ldh  a, [hScrollXNybLow]
	add  $18
	ld   c, a
	ld   a, [$CF0D]
	add  c
	and  $F0
	cp   $F0
	jr   nc, L003369
	swap a
	and  $0F
	ld   b, a
	ld   a, [wLvlColL]
	sub  $02
	add  b
	ld   c, a
	ld   a, [wPl_Unk_Alt_Y]
	sub  $10
	cp   $80
	jr   nc, L00336C
	swap a
	and  $0F
	ld   b, a
	ld   hl, $C000
	add  hl, bc
	ld   a, [hl]
	cp   $3C
	jr   nc, L00336F
	cp   $22
	ret
L003369:;R
	ld   a, $22
	ret
L00336C:;R
	xor  a
	scf  
	ret
L00336F:;R
	ld   a, [wPl_Unk_Alt_Y]
	and  $0F
	cp   $08
	jr   nc, L003381
	ld   a, $F8
	ld   [$CF1C], a
	ld   a, [hl]
	cp   $22
	ret
L003381:;R
	ld   a, [hl]
	scf  
	ret
L003384:;C
	xor  a
L003385:;R
	ld   d, $CD
	ld   e, a
	ld   [$CF2F], a
	ld   a, [de]
	or   a
	jr   z, L0033CF
	and  $7F
	ld   [$CF62], a
	ld   h, $CE
	ld   l, e
	ld   a, e
	add  $05
	ld   e, a
	ld   a, [$CFEC]
	ld   c, a
	ldh  a, [$FFA5]
	ld   b, a
	ld   a, [de]
	ld   [$CF2B], a
	sub  b
	jr   nc, L0033AD
	xor  $FF
	inc  a
	scf  
L0033AD:;R
	ld   b, a
	ldi  a, [hl]
	add  c
	cp   a, b
	jr   c, L0033CF
	ld   a, [$CFED]
	ld   c, a
	ldh  a, [$FFA7]
	ld   b, a
	inc  e
	inc  e
	ld   a, [de]
	sub  [hl]
	ld   [$CF2C], a
	sub  b
	jr   nc, L0033C8
	xor  $FF
	inc  a
	scf  
L0033C8:;R
	ld   b, a
	ldi  a, [hl]
	add  c
	cp   a, b
	call nc, L0033D7
L0033CF:;R
	ld   a, [$CF2F]
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
	ld   a, [$CF2C]
	add  b
	ld   b, a
	ldh  a, [$FFA7]
	cp   a, b
	jp   nc, L003508
L0033F1:;R
	inc  l
	inc  l
	ldd  a, [hl]
	or   a
	ret  nz
	push hl
	ld   a, [$CFDF]
	cp   $0C
	jr   nz, L003406
	ld   a, [$CF6C]
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
	ld   a, [$CF62]
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
	ld   [$CFEE], a
	push af
	ldh  a, [$FF9D]
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	pop  hl
	ld   a, [$CFEE]
	or   a
	jp   z, L003508
	ld   b, a
	ld   a, e
	cp   $09
	jr   nz, L003455
	ld   a, $00
	ld   [$CF1B], a
	ld   a, $02
	ld   [$CF1A], a
	ld   a, $02
	ld   [$CF1D], a
L003455:;R
	ld   a, [hl]
	sub  b
	jr   z, L00349F
	jr   c, L00349F
	ldi  [hl], a
	ld   [$CF61], a
	push hl
	ld   a, [$CFEF]
	cp   $02
	jr   nc, L00346A
	xor  a
	ldh  [$FFA0], a
L00346A:;R
	ld   a, [$CFDF]
	cp   $04
	call z, L003A0B
	pop  hl
	ld   [hl], $0C
	ld   a, $03
	ldh  [$FF99], a
	ld   a, [$CF45]
	or   a
	ret  z
	ld   a, [$CF62]
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
	ld   a, [$CF61]
	add  a
	add  a
	add  a
	ld   [$CF73], a
	ld   hl, $CF70
	set  2, [hl]
	ret
L00349F:;R
	ld   a, [$CFEF]
	cp   $01
	jr   nc, L0034A9
	xor  a
	ldh  [$FFA0], a
L0034A9:;R
	ld   a, [$CFDF]
	cp   $04
	call z, L003A0B
	ld   h, $CD
	ld   a, [$CF2F]
	ld   l, a
	ld   a, $80
	ldi  [hl], a
	xor  a
	ldi  [hl], a
	ldi  [hl], a
	ld   h, $CE
	ld   a, [$CF2F]
	ld   l, a
	inc  l
	inc  l
	xor  a
	ld   [hl], a
	ld   a, [$CF45]
	or   a
	jp   z, L001E25
	ld   a, [$CF62]
	cp   $50
	ret  c
	cp   $54
	jr   c, L0034DE
	cp   $68
	ret  c
	cp   $70
	ret  nc
L0034DE:;R
	ld   a, [$CF60]
	cp   $01
	jr   z, L0034FE
	ld   h, $CD
	ld   a, [$CF2F]
	add  $05
	ld   l, a
	ld   a, [hl]
	ld   [$CF63], a
	inc  l
	inc  l
	ld   a, [hl]
	sub  $0C
	ld   [$CF64], a
	ld   a, $02
	ld   [$CF60], a
L0034FE:;X
	xor  a
	ld   [$CF73], a
	ld   hl, $CF70
	set  2, [hl]
	ret
L003508:;J
	ld   a, [$CFDF]
	cp   $04
	jr   nz, L003514
	ld   a, $05
	ldh  [$FF99], a
	ret
L003514:;R
	cp   $08
	jr   nz, L003522
	ldh  a, [$FFA1]
	bit  7, a
	ret  nz
	ld   a, $80
	ldh  [$FFA1], a
	ret
L003522:;R
	ld   a, [$CF6C]
	or   a
	jr   z, L00353C
	ld   a, $00
	ld   [$CF1B], a
	ld   a, $02
	ld   [$CF1A], a
	ld   a, $02
	ld   [$CF1D], a
	ld   a, $05
	ldh  [$FF99], a
	ret
L00353C:;R
	xor  a
	ldh  [$FFA1], a
	ldh  a, [$FFA3]
	or   $80
	ldh  [$FFA3], a
	ld   a, $05
	ldh  [$FF99], a
	ret
L00354A:;C
	ld   a, [$CF6B]
	ld   [$CF24], a
	ld   a, $FF
	ld   [$CF5D], a
	ld   [$CF4A], a
	ld   [$CF6B], a
	ld   [$CF6A], a
	ld   b, $0C
	ld   a, [$CF1D]
	cp   $10
	jr   nz, L003569
	srl  b
L003569:;R
	ld   a, b
	ld   [$CF7D], a
	ld   a, [wPlRelY]
	sub  b
	ld   [$CF7E], a
	xor  a
L003575:;R
	ld   d, $CD
	ld   e, a
	ld   [$CF2F], a
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
	cp   a, b
	jr   c, L0035B3
	inc  e
	inc  e
	ld   a, [$CF7D]
	ld   c, a
	ld   a, [$CF7E]
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
	cp   a, b
	call nc, L0035BB
L0035B3:;R
	ld   a, [$CF2F]
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
	ldh  a, [$FFF9]
	or   a
	ret  nz
	ld   a, [$CF43]
	or   a
	ret  nz
	ld   a, [$CF2F]
	ld   [$CF5D], a
	ld   a, $13
	ldh  [$FF99], a
	ld   a, $20
	ld   [$CF42], a
	ld   a, $3C
	ld   [$CF43], a
	ld   a, [$CF1D]
	cp   $10
	jr   z, L0035F2
	cp   $11
	jr   z, L0035F2
	xor  a
	ld   [$CF1D], a
L0035F2:;R
	ld   h, $CE
	ld   a, [$CF2F]
	add  $03
	ld   l, a
	ld   a, [$CFD0]
	sub  [hl]
	jr   nc, L003601
	xor  a
L003601:;R
	push af
	ld   [$CFD0], a
	ld   [$CF71], a
	ld   hl, $CF70
	set  0, [hl]
	pop  af
	or   a
	ret  nz
	ld   a, [wPlRelX]
	ld   [$CF63], a
	ld   a, [wPlRelY]
	sub  $0C
	ld   [$CF64], a
	ld   a, $01
	ld   [$CF60], a
	ret
L003624:;R
	cp   $04
	jp   nz, L0036D9
	ldd  a, [hl]
	or   a
	jr   nz, L003636
	ld   a, [$CF24]
	cp   $FF
	ret  nz
	jp   L003689
L003636:;R
	cp   $01
	jr   nz, L003656
	ld   a, [$CF24]
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
	ld   a, [$CFF1]
	cp   $FF
	ret  nz
	ld   a, b
	cp   $04
	jr   nz, L00367C
	call L003689
	jr   nc, L00367C
	ld   a, [$CF2F]
	ld   [$CF6B], a
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
	ld   a, [$CF1D]
	cp   $03
	ret  nz
	ld   a, [$CF2F]
	ld   [$CF6A], a
	ret
L003689:;JC
	dec  l
	ld   a, [hl]
	ld   [$CF52], a
	ld   b, a
	ld   a, [de]
	ld   [$CF53], a
	sub  b
	ld   b, a
	ld   a, [wPlRelY]
	cp   a, b
	ret  nc
	ld   a, [$CF1D]
	cp   $04
	ret  nc
	ld   a, [wPlRelY]
	inc  a
	ld   [wPl_Unk_Alt_Y], a
	ld   a, [wPlRelX]
	sub  $06
	ld   [$CF0D], a
	call L00332F
	cp   $21
	ret  nc
	ld   a, [wPlRelX]
	add  $06
	ld   [$CF0D], a
	call L00332F
	cp   $21
	ret  nc
	ld   a, [$CF52]
	ld   b, a
	ld   a, [$CF53]
	sub  b
	sub  b
	inc  a
	inc  a
	ld   [wPlRelY], a
	ld   a, [$CF2F]
	ld   [$CF4A], a
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
	ld   a, [$CF2F]
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
	rst  $00
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
	ld   a, [$CFE8]
	cp   $09
	ret  nc
	inc  a
	ld   [$CFE8], a
	ld   [$CF74], a
	ld   hl, $CF70
	set  3, [hl]
	ld   a, $09
	ldh  [$FF99], a
	ret
L003729:;I
	ld   a, [$CFF2]
	add  $48
	ld   [$CFF2], a
	ret
L003732:;I
	ld   a, [$CFF2]
	add  $18
	ld   [$CFF2], a
	ret
L00373B:;I
	ld   a, [$CFF3]
	add  $48
	ld   [$CFF3], a
	ret
L003744:;I
	ld   a, [$CFF3]
	add  $18
	ld   [$CFF3], a
	ret
L00374D:;I
	ld   a, [$CFE9]
	cp   $04
	ret  nc
	inc  a
	ld   [$CFE9], a
	ld   a, $08
	ldh  [$FF99], a
	ret
L00375C:;C
	call L0039EF
	ld   a, [$CFDF]
	push af
	ld   hl, $CFD0
	ld   de, wScrEvRows
	ld   c, $00
	ldi  a, [hl]
	call L003AD9
	ld   a, [$CFDD]
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
	rst  $10
	ld   de, wScrEvRows
	ld   a, [$CFDE]
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
	rst  $10
L00379B:;R
	ld   de, wScrEvRows
	ld   a, [$CFDD]
	and  $08
	jr   z, L0037AD
	ld   a, [$CFDC]
	ld   c, $0C
	call L003AD9
L0037AD:;R
	ld   hl, $3B5F
	call L003B9B
	ld   a, $07
	ld   [de], a
	inc  de
	call L003B9B
	ld   a, [$CFE9]
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
	rst  $10
	xor  a
	ldh  [$FF97], a
	ld   a, [$CF1D]
	cp   $11
	jr   z, L0037EA
	ld   a, [$CF6C]
	or   a
	jr   nz, L0037EA
	call L001AE9
L0037EA:;R
	call L000667
	ld   bc, $0A20
	ld   hl, $7800
	ld   de, $8800
	call GfxCopy_Req
	ld   a, $0C
	ldh  [$FF99], a
	ld   b, $10
	ldh  a, [hLYC]
L003801:;R
	sub  $08
	ldh  [hLYC], a
	ldh  [hWinY], a
	rst  $08
	dec  b
	jr   nz, L003801
L00380B:;JR
	call L003B63
	ldh  a, [hJoyNewKeys]
	and  $F9
	jr   z, L00380B
	and  $09
	ld   a, [$CFDF]
	jr   nz, L00385D
	ldh  a, [hJoyNewKeys]
	rla  
	jr   c, L00382F
	rla  
	jr   c, L003846
	ld   a, [$CFDF]
	xor  $01
	call L003BA2
	jr   c, L00385D
	jr   L003832
L00382F:;R
	ld   a, [$CFDF]
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
	ld   a, [$CFDF]
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
	ld   a, [$CFDF]
	add  a
	add  a
	ld   hl, $3B2B
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   de, wScrEvRows
	call L003B9B
	ld   a, $02
	ld   [de], a
	inc  de
	call L003B9B
	xor  a
	ld   [de], a
	rst  $10
	pop  af
	ld   [$CFDF], a
	ldh  a, [hJoyNewKeys]
	and  $09
	jr   nz, L003886
	jr   L00380B
L003886:;R
	ld   a, [$CFDF]
	cp   $0D
	jr   c, L0038E0
	ld   a, [$CFE9]
	or   a
	jp   z, L00380B
	ld   a, [$CFD0]
	cp   $98
	jp   nc, L00380B
	ld   a, [$CFE9]
	dec  a
	ld   [$CFE9], a
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
	rst  $10
	ld   a, [$CFD0]
L0038BA:;R
	add  $08
	cp   $98
	jr   c, L0038C2
	ld   a, $98
L0038C2:;R
	ld   [$CFD0], a
	ld   c, $00
	call L003A25
	rst  $18
	ld   de, wScrEvRows
	call L003AD9
	rst  $10
	ld   a, $07
	ldh  [$FF99], a
	ld   a, [$CFD0]
	cp   $98
	jr   c, L0038BA
	jp   L00380B
L0038E0:;R
	ld   a, [$CFDF]
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
	ld   a, [$CFDF]
	or   a
	jr   z, L00390B
	ld   hl, $CFD0
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ld   [$CFE0], a
L00390B:;R
	xor  a
	ld   [wBarDrawQueued], a
	ld   a, [$CFDF]
	or   a
	ld   a, [$CFE0]
	jr   nz, L00391A
	ld   a, $FF
L00391A:;R
	ld   c, $01
	call L003A25
	rst  $18
	ld   hl, $CF70
	res  1, [hl]
	ld   a, [$CFDF]
	ld   b, a
	pop  af
	cp   a, b
	jr   z, L003933
	call L0039A0
	call L0039C2
L003933:;R
	ld   a, [$CFDF]
	ld   b, a
	ld   a, [$CF6C]
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
	ldh  [$FF99], a
	ld   b, $10
	ldh  a, [hLYC]
L003956:;R
	add  $08
	ldh  [hLYC], a
	ldh  [hWinY], a
	rst  $08
	dec  b
	jr   nz, L003956
	ld   a, [wActGfxId]
	ld   hl, ActS_GFXReqTbl
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
	rst  $20
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
	rst  $20
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
	ld   a, [$CF1D]
	cp   $11
	jr   nz, L0039AB
	xor  a
	ld   [$CF1D], a
L0039AB:;R
	xor  a
	ld   [$CC60], a
	ld   [$CC70], a
	ld   [$CC80], a
	ld   [$CC90], a
	ld   [$CFE4], a
	ld   [$CFEA], a
	ld   [$CF6C], a
	ret
L0039C2:;C
	ld   hl, $CD00
L0039C5:;R
	ld   a, [hl]
	cp   $E0
	jr   c, L0039E7
	cp   $E4
	jr   nc, L0039E7
	ld   a, [$CFF1]
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
	ld   [$CFF1], a
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
	ld   a, [$CFDF]
	or   a
	ret  z
	ld   hl, $CFD0
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [$CFE0]
	ld   [hl], a
	ret
L003A00:;C
	push bc
	ld   a, [$CFF0]
	ld   b, a
	ld   a, [$CFE0]
	cp   a, b
	pop  bc
	ret
L003A0B:;JC
	push hl
	push bc
	ld   a, [$CFF0]
	ld   b, a
	ld   a, [$CFE0]
	sub  b
	jr   c, L003A22
	ld   [$CFE0], a
	ld   [$CF72], a
	ld   hl, $CF70
	set  1, [hl]
L003A22:;R
	pop  bc
	pop  hl
	ret
L003A25:;C
	push af
	push bc
	push de
	push hl
	ld   [$CFE2], a
	ld   b, $00
	sla  c
	ld   hl, $3A94
	add  hl, bc
	ld   e, l
	ld   d, h
	ld   h, $DE
	ld   a, [wBarDrawQueued]
	ld   l, a
	ld   b, $64
	call L003A52
	inc  de
	ld   b, $68
	call L003A52
	xor  a
	ld   [hl], a
	ld   a, l
	ld   [wBarDrawQueued], a
	pop  hl
	pop  de
	pop  bc
	pop  af
	ret
L003A52:;C
	push de
	ld   a, $9C
	ldi  [hl], a
	ld   a, [de]
	ldi  [hl], a
	ld   a, $05
	ldi  [hl], a
	ld   c, $05
	ld   a, [$CFE2]
	cp   $99
	jr   c, L003A68
	ld   a, $5D
	jr   L003A8E
L003A68:;R
	add  $07
	srl  a
	srl  a
	srl  a
	push af
	srl  a
	srl  a
	jr   z, L003A80
	ld   d, a
	ld   a, b
	add  $04
L003A7B:;R
	ldi  [hl], a
	dec  c
	dec  d
	jr   nz, L003A7B
L003A80:;R
	pop  af
	and  $03
	jr   z, L003A88
	add  b
	ldi  [hl], a
	dec  c
L003A88:;R
	ld   a, c
	or   a
	jr   z, L003A92
	ld   a, $73
L003A8E:;R
	ldi  [hl], a
	dec  c
	jr   nz, L003A8E
L003A92:;R
	pop  de
	ret
L003A94: db $07
L003A95: db $27
L003A96: db $00
L003A97: db $20
L003A98: db $0F
L003A99: db $2F
L003A9A:;C
	push af
	push de
	push hl
	add  a
	ld   d, $00
	ld   e, a
	ld   hl, $3AC5
	add  hl, de
	ld   e, l
	ld   d, h
	ld   h, $DE
	ld   a, [wBarDrawQueued]
	ld   l, a
	ld   a, $9C
	ldi  [hl], a
	ld   a, $0E
	ldi  [hl], a
	ld   a, $82
	ldi  [hl], a
	ld   a, [de]
	ldi  [hl], a
	inc  de
	ld   a, [de]
	ldi  [hl], a
	xor  a
	ld   [hl], a
	ld   a, l
	ld   [wBarDrawQueued], a
	pop  hl
	pop  de
	pop  af
	ret
L003AC5: db $5A
L003AC6: db $5C
L003AC7: db $51
L003AC8: db $52
L003AC9: db $53
L003ACA: db $54
L003ACB: db $53
L003ACC: db $55
L003ACD: db $56
L003ACE: db $57
L003ACF: db $58
L003AD0: db $55
L003AD1: db $58
L003AD2: db $59
L003AD3: db $5A
L003AD4: db $52
L003AD5: db $5B
L003AD6: db $59
L003AD7: db $5B
L003AD8: db $55
L003AD9:;C
	push bc
	push hl
	push af
	ld   b, $00
	sla  c
	sla  c
	ld   hl, $3B2B
	add  hl, bc
	call L003B9B
	ld   a, $07
	ld   [de], a
	inc  de
	call L003B9B
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
	ld   a, [$CFDF]
	add  a
	add  a
	ld   hl, $3B2B
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   de, wScrEvRows
	call L003B9B
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
	rst  $10
	jp   JoyKeys_Sync
L003B97:;R
	rst  $08
	jp   JoyKeys_Sync
L003B9B:;C
	ldi  a, [hl]
	ld   [de], a
	inc  de
	ldi  a, [hl]
	ld   [de], a
	inc  de
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
	ld   a, [$CFDD]
	swap a
	rla  
	jr   L003BCF
L003BBB:;R
	cp   $04
	jr   nc, L003BC5
	ld   b, a
	ld   a, [$CFDD]
	jr   L003BCB
L003BC5:;R
	sub  $03
	ld   b, a
	ld   a, [$CFDE]
L003BCB:;R
	rra  
	dec  b
	jr   nz, L003BCB
L003BCF:;R
	ld   a, c
	pop  bc
	ret
; =============== ActS_GFXReqTbl ===============
; Defines the sets of actor graphics usable during levels.
MACRO mActGfxDef
	db BANK(\1), HIGH(\1)
ENDM
ActS_GFXReqTbl:
	mActGfxDef L0B4000 ; $00 
	mActGfxDef L0B4800 ; $01 ;X Not loaded this way
	mActGfxDef L084000 ; $02 
	mActGfxDef L084800 ; $03 
	mActGfxDef L085000 ; $04 
	mActGfxDef L085800 ; $05 
	mActGfxDef L086000 ; $06 
	mActGfxDef L086800 ; $07 
	mActGfxDef L087000 ; $08 
	mActGfxDef L087800 ; $09 
	mActGfxDef L094000 ; $0A 
	mActGfxDef L094800 ; $0B 
	mActGfxDef L095000 ; $0C 
	mActGfxDef L095800 ; $0D 
	mActGfxDef L096000 ; $0E 
	mActGfxDef L096800 ; $0F 
	mActGfxDef L097000 ; $10 
	mActGfxDef L0B6800 ; $11 
	mActGfxDef L0B6800 ; $12 
	mActGfxDef L0B5000 ; $13 
	mActGfxDef L0C7000 ; $14 
	mActGfxDef L0C7800 ; $15 
	mActGfxDef L097B00 ; $16 
	mActGfxDef L0A4000 ; $17 
	mActGfxDef L0A4500 ; $18 
	mActGfxDef L0A4A00 ; $19 
	mActGfxDef L0A4F00 ; $1A 
	mActGfxDef L0A5400 ; $1B 
	mActGfxDef L0A5900 ; $1C 
	mActGfxDef L0A5E00 ; $1D 
	mActGfxDef L0B6000 ; $1E 
	mActGfxDef L0A6300 ; $1F 


L003C12: db $14;X
L003C13: db $15;X
L003C14: db $06;X
L003C15: db $08;X
L003C16: db $0A
L003C17: db $0C
L003C18: db $0E
L003C19: db $10
L003C1A: db $40
L003C1B: db $01
L003C1C: db $80
L003C1D: db $20
L003C1E: db $10
L003C1F: db $08
L003C20: db $04
L003C21: db $02
L003C22: db $00;X
L003C23: db $00;X
L003C24: db $E4
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
L003C38: db $0B
L003C39: db $0D
L003C3A: db $0E
L003C3B: db $0F
L003C3C: db $08
L003C3D: db $0A
L003C3E: db $0C
L003C3F: db $09
L003C40: db $11
L003C41: db $01
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
L003C6A: db $00
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