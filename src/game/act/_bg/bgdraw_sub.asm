; =============== Act_BGBoss_ReqDraw ===============
; Requests drawing a BG-based miniboss to the tilemap, relative to the actor's location.
; Used by Tama and Friender and meant to be called by their init routine, so hActCur will
; point to the miniboss actor slot.
Act_BGBoss_ReqDraw:
	;
	; Tama and Friender follow a convention that lets them get away with sharing the same
	; initialization code and even the same tilemap.
	;
	; Both minibosses are 5x4 tile rectangles, with their graphics tucked in the top-right
	; corner of the level's GFX set, all using unique tiles. Given levels don't load separate
	; art sets mid-level, all that's needed is generating the tiles for a tilemap event.
	;
	; This is all done all at once in a single event, so there is a limit to how many tiles
	; it could use.
	;
	
	call Act_BGBoss_GetRect			; Get rectancle bounds
	ld   de, Tilemap_Act_Miniboss	; DE = Tama/Friender tilemap
	jp   ActS_WriteTilemapToRect	; Write it to that rectangle
	
; =============== Act_Tama_ChkExplode ===============
; Checks if Tama has been defeated, and if so, makes it explode.
Act_Tama_ChkExplode:
	; If Tama dies, clear its BG portion from the tilemap.
	call ActS_ChkExplodeNoChild		; Is the boss dead?
	ret  nc							; If not, return
									; Otherwise...
	call Act_BGBoss_GetRect			; Get same rectangle bounds from when we wrote the boss to the tilemap
	ld   de, Tilemap_Act_TamaDead	; Write blank gray tiles to them, matching Top Man's background
	jr   ActS_WriteTilemapToRect
	
; =============== Act_Friender_ChkExplode ===============
; Checks if Friender has been defeated, and if so, makes it explode.
; See also: Act_Tama_ChkExplode
Act_Friender_ChkExplode:
	; If Friender dies, clear its BG portion from the tilemap
	call ActS_ChkExplodeNoChild
	ret  nc
	; These tiles match the interior background in Wood Man's stage
	call Act_BGBoss_GetRect
	ld   de, Tilemap_Act_FrienderDead
	jr   ActS_WriteTilemapToRect
	
; =============== Act_Goblin_ShowBody ===============
; Makes the large goblin platform appear, for Air Man's stage.
; This isn't just a visual effect, the level layout blocks do get updated.
Act_Goblin_ShowBody:
	;
	; TILEMAP UPDATE
	;
	;--
	; Get tilemap rectangle bounds for the Goblin platform.
	; See also: Act_BGBoss_GetRect
	ldh  a, [hActCur+iActX]		; X Origin (left): ActX - $14 
	sub  $14
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Origin (top): ActY - $14
	sub  $14
	ld   [wTargetRelY], a
	ld   a, $06					; Width: 6 tiles
	ld   [wRectCpWidth], a
	ld   a, $06					; Height: 6 tiles
	ld   [wRectCpHeight], a
	;--
	; Draw the platform tiles
	ld   de, Tilemap_Act_Goblin
	call ActS_WriteTilemapToRect
	
	;##
	;
	; LEVEL LAYOUT UPDATE
	;
	; The blocks placed around the actor are blank, and need to become solid.
	; The actual blocks used should have block16 data that matches what we just wrote to the tilemap.
	;
	
	;--
	;
	; For convenience, the origin was specified in pixels, since it's based on the actor's location.
	; As we need to write to the level layout, we need an offset to it though.
	; 
	
	; HORIZONTAL COMPONENT / LOW BYTE
	ldh  a, [hScrollXNybLow]; B = Block scroll offset (pixels)
	ld   b, a
	ld   a, [wTargetRelX]	; A = Origin X (pixels, relative to viewport)
	sub  OBJ_OFFSET_X		; Account for HW offset
	add  b					; Account for misaligned scrolling wLvlColL doesn't account for
	swap a					; Divide by $10 (BLOCK_H) to get the relative column number
	and  $0F				; ""
	ld   b, a				; Save it to B
	ld   a, [wLvlColL]		; Get base column number
	add  b					; Add the relative one
	ld   c, a				; Save result to C
	
	; VERTICAL COMPONENT / HIGH BYTE
	ld   a, [wTargetRelY]	; A = Origin Y
	sub  OBJ_OFFSET_Y		; Account for HW offset
	swap a					; Divide by $10 (BLOCK_V) to get the row number
	and  $0F				; ""
	ld   b, a				; Save result to B
	;--
	
	; Seek DE to that location in the level layout
	ld   hl, wLvlLayout
	add  hl, bc
	ld   e, l
	ld   d, h
	
	;
	; Copy the level layout part to the live level layout.
	; The blocks are ordered top to bottom, left to right.
	;
	ld   hl, LvlPart_Act_Goblin		; HL = Source data
	ld   b, $03					; B = Number of columns
.loop:
	push de			; Save column origin
		REPT 3
			ldi  a, [hl]		; Read from source, seek to next
			ld   [de], a		; Write to dest
			inc  d				; Move down 1 block
		ENDR
	pop  de			; Restore column origin
	inc  e 			; Move right 1 block, next column
	dec  b			; Copied all columns?
	jr   nz, .loop	; If not, loop
	ret
	
; =============== Act_BGBoss_GetRect ===============
; Gets the tilemap rectangle bounds for Tama and Friender.
; This will be used to tell ActS_WriteTilemapToRect where to start writing the tilemap
; for those minibosses, and how many tiles to copy.
Act_BGBoss_GetRect:
	ldh  a, [hActCur+iActX]	; X Origin (left): ActX - $12
	sub  $12
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]	; Y Origin (top): ActY - $1C
	sub  $1C
	ld   [wTargetRelY], a
	ld   a, $05				; Width: 5 tiles
	ld   [wRectCpWidth], a
	ld   a, $04				; Height: 4 tiles
	ld   [wRectCpHeight], a
	ret
	
; =============== ActS_ReqDrawTilemapToRect ===============
; Requests drawing the specified tilemap to a rectangle area of VRAM.
; IN
; - DE: Ptr to source tilemap
; - wTargetRelX: Dest. rectangle - Horizontal origin (pixels)
; - wTargetRelY: Dest. rectangle - Vertical origin (pixels)
; - wRectCpWidth: Dest. rectangle - Width (in tiles)
; - wRectCpHeight: Dest. rectangle - Height (in tiles)
ActS_WriteTilemapToRect:

	;
	; For convenience, the origin was specified in pixels, since it's based on the actor's location.
	; As we need to write to the tilemap, we need a tilemap destination pointer though.
	;
	
	;
	; VERTICAL COMPONENT
	; ScrEv_BGStripTbl[(hScrollY + wTargetRelY - OBJ_OFFSET_Y) / $08]
	;
	ldh  a, [hScrollY]		; B = Viewport Y (pixels)
	ld   b, a
	ld   a, [wTargetRelY]	; A = Origin Y (pixels, relative to viewport)
	sub  OBJ_OFFSET_Y		; Account for HW offset
	add  b					; Get absolute coordinate
	swap a					; Divide by $10 (BLOCK_V) to get block row/strip number
	and  $0F				; ""
	sla  a					; *2 for ptr table indexing
	ld   hl, ScrEv_BGStripTbl	; HL = Tilemap row pointers table
	ld   b, $00
	ld   c, a				; BC = What we calculated before
	add  hl, bc				; Seek to entry
	ldi  a, [hl]			; Read the pointer out to wRectCpDestPtr
	ld   [wRectCpDestPtrLow], a
	ld   a, [hl]
	ld   [wRectCpDestPtrHigh], a
	
	;
	; HORIZONTAL COMPONENT
	;	
	ldh  a, [hScrollX]		; B = Viewport X (pixels)
	ld   b, a
	;--
	; Readding the lower nybble to hScrollX, in light of the upcoming / $10,
	; will cause that result to be rounded to the nearest block boundary.
	;
	; ie: If hScrollX is $x0-$x7, it will be rounded down (low nybble won't overflow)
	;     If hScrollX is $x8-$xF, it will be rounded up (low nybble will overflow)
	ldh  a, [hScrollXNybLow]	; B = Viewport X (pixels, low nybble)
	add  b						; += hScrollX
	ld   b, a
	;--
	ld   a, [wTargetRelX]	; A = Origin X (pixels, relative to viewport)
	sub  OBJ_OFFSET_X		; Account for HW offset
	add  b					; Get absolute coordinate
	swap a					; Divide by $10 (BLOCK_H) to get column number
	and  $0F				; ""
	sla  a					; *2 as a column is 2 tiles wide
	ld   b, a				; Save offset to B
	
	; Move <B> tiles right from the start of the block row.
	; This will point to the top-left corner of a block, so it will never overflow.
	ld   a, [wRectCpDestPtrLow]
	add  b
	ld   [wRectCpDestPtrLow], a
	
	;
	; With the destination pointer ready, generate the event for drawing the tilemap.
	; The event will draw it column by column -- top to bottom, left to right.
	; The tilemap we want to draw, which is only made of raw time IDs, needs to be consistent
	; with that, by having the tiles in that order and following the width/height of the rectangle.
	;
	; This event will be executed all at once next VBLANK, which imposes a limit for how
	; much can be drawn.
	;
	ld   hl, wTilemapBuf		; HL = Ptr to event buffer
	ld   a, [wRectCpWidth]		; B = Columns remaining
	ld   b, a
.loop:							; For each column...
	; Current VRAM location we're pointing at
	ld   a, [wRectCpDestPtrHigh]
	ldi  [hl], a				; byte0 - VRAM Address (high)
	ld   a, [wRectCpDestPtrLow]
	ldi  [hl], a				; byte1 - VRAM Address (low)
	
	; byte2 - Flags + Tile count
	ld   a, [wRectCpHeight]		; Copy wRectCpHeight tiles
	or   BG_MVDOWN				; Write top to bottom
	ldi  [hl], a
	
	; byte3+ - Payload
	; Copy <wRectCpHeight> tiles from the source into the payload, as-is
	push bc
		ld   a, [wRectCpHeight]
		ld   b, a
	.loopCol:
		ld   a, [de]
		ldi  [hl], a
		inc  de
		dec  b
		jr   nz, .loopCol
	pop  bc
	
	;##
	;
	; Seek to the next column on the right, while accounting for the tilemap wrapping around.
	; This is slightly involved:
	; wRectCpDestPtrLow = (wRectCpDestPtrLow & $E0) | (wRectCpDestPtrLow++ & $1F)
	;
	;--
	; Accounting for wraparound wipes the upper three bits, so they need to be preserved.
	; These map to the low byte of the vertical component / row offset.
	; C = wRectCpDestPtrLow & $E0
	ld   a, [wRectCpDestPtrLow]	
	and  $FF^(BG_TILECOUNT_H-1)
	ld   c, a
	;--
	ld   a, [wRectCpDestPtrLow]	; Get column origin ptr
	inc  a						; Seek one tile right
	and  BG_TILECOUNT_H-1		; Account for row wraparound
	or   c						; Add back the lost bits
	ld   [wRectCpDestPtrLow], a
	;##
	
	dec  b						; Handled all columns?
	jr   nz, .loop				; If not, loop
	
	xor  a						; Write terminator
	ldi  [hl], a
	inc  a						; Trigger event
	ld   [wTilemapEv], a
	
	; Set C flag, for compatibility with a check the calling code makes
	scf  
	ret
	
Tilemap_Act_Miniboss:
	db $0B,$1B,$2B,$3B ; $00
	db $0C,$1C,$2C,$3C ; $01
	db $0D,$1D,$2D,$3D ; $02
	db $0E,$1E,$2E,$3E ; $03
	db $0F,$1F,$2F,$3F ; $04
Tilemap_Act_TamaDead:
	db $71,$71,$71,$71 ; $00
	db $71,$71,$71,$71 ; $01
	db $71,$71,$71,$71 ; $02
	db $71,$71,$71,$71 ; $03
	db $71,$71,$71,$71 ; $04
Tilemap_Act_FrienderDead:
	db $2A,$3A,$2A,$3A ; $00
	db $29,$39,$29,$39 ; $01
	db $2A,$3A,$2A,$3A ; $02
	db $29,$39,$29,$39 ; $03
	db $2A,$3A,$2A,$3A ; $04
Tilemap_Act_Goblin:
	db $0A,$1A,$2A,$3A,$4A,$4F ; $00
	db $0B,$1B,$2B,$3B,$4B,$48 ; $01
	db $0C,$1C,$2C,$3C,$4C,$49 ; $02
	db $0D,$1D,$2D,$3D,$4D,$49 ; $03
	db $0E,$1E,$2E,$3E,$4E,$02 ; $04
	db $22,$32,$21,$31,$01,$03 ; $05
LvlPart_Act_Goblin:
	db $22,$24,$34 ; $00
	db $23,$25,$35 ; $02
	db $2D,$2E,$2F ; $04
	
