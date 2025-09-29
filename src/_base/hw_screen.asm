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
	
