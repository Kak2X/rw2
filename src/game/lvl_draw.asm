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
	
