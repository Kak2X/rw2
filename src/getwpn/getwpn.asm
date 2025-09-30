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
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   de, TilemapDef_GetWpn
	call LoadTilemapDef
	push af
		ldh  a, [hROMBankLast]
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	call StartLCDOperation
	;--
	
	mPlayBGM BGM_WEAPONGET
	
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
	mPlaySFX SFX_BOSSBAR			; Play text writer sound
	
.wait:
	ld   a, $06			; Wait 6 frames between text printings
	call WaitFrames
	
	inc  de				; Move 1 tile right
	jr   .readChar		; Read next character
