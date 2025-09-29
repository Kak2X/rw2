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
	
