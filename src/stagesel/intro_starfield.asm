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
	
