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

