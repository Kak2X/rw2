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

