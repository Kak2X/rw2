; =============== Sc_DrawSprMap ===============
; Draws the specified cutscene sprite.
; See also: ActS_DrawSprMap
; IN
; - HL: Ptr to sprite mapping table
; - A: Sprite mapping ID
; - wTargetRelY: Y position
; - wTargetRelX: X position
; - wScBaseSprFlags: Base flags
Sc_DrawSprMap:
	;
	; Index the sprite mapping pointer from the table we've been passed.
	; HL = HL[A*2]
	;
	add  a			; * 2 for pointer table
	ld   b, $00
	ld   c, a
	add  hl, bc		; Seek to entry
	ld   e, [hl]	; Read out pointer to DE
	inc  hl
	ld   d, [hl]
	ld   l, e		; Move to HL
	ld   h, d
	
	;
	; Write the sprite mapping to the OAM mirror.
	;
	
	;--
	ld   de, wWorkOAM		; HL = Ptr to current OAM slot (could have been done simpler)
	ldh  a, [hWorkOAMPos]
	add  e
	ld   e, a
	ld   a, d
	adc  $00
	ld   d, a
	;--
	
	; The first byte of a mapping marks the number of individual OBJ they use.
	; Unlike other sprite mapping drawing routines, this neither allows blank sprite mappings
	; nor does it check if we're going over the sprite limit (since it's all controlled manually).
	; It also does not support flipping.
	ld   b, [hl]			; B = OBJCount
	inc  hl					; Seek to the OBJ table
.loop:
	; YPos = wTargetRelY + byte0
	ld   a, [wTargetRelY]	; A = Absolute Y
	add  [hl]				; Add relative Y
	ld   [de], a			; Write to OAM mirror
	inc  hl					; SrcPtr++
	inc  de					; DestPtr++
	
	; XPos = wTargetRelX + byte1
	ld   a, [wTargetRelX]
	add  [hl]
	ld   [de], a
	inc  hl
	inc  de
	
	; TileID = byte2
	ldi  a, [hl]
	ld   [de], a
	inc  de
	
	; Flags = wScBaseSprFlags ^ byte3
	; Unlike every other routine, this does merge them the proper way by xor'ing them.
	ld   a, [wScBaseSprFlags]
	xor  [hl]
	ld   [de], a
	inc  hl
	inc  de
	
	dec  b					; Finished copying all OBJ?
	jr   nz, .loop			; If not, loop
	
	ld   a, e				; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	ret
	
; =============== Credits_CastDrawName ===============
; Draws the enemy's name using sprites.
Credits_CastDrawName:

	;
	; Get ptr to the string for the current cast roll entry.
	; HL = Credits_CastTextPtrTbl[wCredRowId * 2]
	;
	ld   a, [wCredRowId]	; A = RowId * 2 (for ptr table)
	add  a
	ld   hl, Credits_CastTextPtrTbl	; HL = Ptr table base
	ld   b, $00		; BC = Index
	ld   c, a
	add  hl, bc		; Seek to entry
	ld   e, [hl]	; Read out to DE
	inc  hl
	ld   d, [hl]
	ld   l, e		; Move to HL
	ld   h, d
	
	;
	; Set starting coordinates for the text drawing loop.
	;
	
	; Y POSITION - Fixed
	; All lines start at Y position $48.
	DEF TEXT_BASE_Y = OBJ_OFFSET_Y+$38
	ld   a, TEXT_BASE_Y
	ld   [wCredTextY], a
	
	; X POSITION - String-specific.
	; The first byte of a string contains its left padding, in tiles.
	ld   a, [hl]	; Read byte0
	inc  hl			; Seek to first character
	and  $1F		; Filter out unwanted bits
	add  a			; *2
	add  a			; *4
	add  a			; *8 (TILE_H)
	ld   [wCredTextX], a
	ld   [wCredTextRowX], a	; Make a backup copy for restoring it on newlines
	
	;
	; Convert the text string into sprites.
	;
	
	;--
	; Start drawing writing them from the current OAM entry
	; HL = wWorkOAM + hWorkOAMPos
	ld   de, wWorkOAM
	ldh  a, [hWorkOAMPos]
	add  e
	ld   e, a
	ld   a, d
	adc  $00
	ld   d, a
	;--
.loop:
	; YPos = wCredTextY
	ld   a, [wCredTextY]
	ld   [de], a
	inc  de
	
	; XPos = wCredTextX
	ld   a, [wCredTextX]
	ld   [de], a
	; Write the next character 8 pixels ro the right
	; wCredTextX += 8
	add  TILE_H
	ld   [wCredTextX], a
	inc  de
	
	; TileID = byte2 - $20
	; The font in ROM is ASCII-like, but in VRAM it's located 32 tiles before that.
	ldi  a, [hl]		; Read character, seek to next
	sub  $20			; -32
	ld   [de], a		; Use that as tile ID
	inc  de
	
	; Flags = wScBaseSprFlags ^ byte3
	xor  a
	ld   [de], a
	inc  de
	
	; Check for a string terminator
	ld   a, [hl]		; Read next character
	cp   $2F			; Reached a newline character?
	call z, .newLine	; If so, move to the start of the next row
	cp   $2E			; Reached terminator?
	jr   nz, .loop		; If not, loop
	
	; Otherwise, we're done
	ld   a, e			; Save back new OAM write position
	ldh  [hWorkOAMPos], a
	ret
	
.newLine:
	; Text strings only have two lines at most.
	; We can get away with using an hardcoded Y location rather than doing it the proper way.
	ld   a, TEXT_BASE_Y+TILE_H
	ld   [wCredTextY], a
	; Seek back to the start of the row
	ld   a, [wCredTextRowX]
	ld   [wCredTextX], a
	
	inc  hl 		; Seek to next character
	ld   a, [hl]	; Read it before returning to the terminator check
	ret
	
; =============== ScAct_ApplySpeed ===============
; Moves the actor by its current speed.
; In short, actually moves the actor.
; IN
; - HL: Ptr to cutscene actor slot
ScAct_ApplySpeed:
	; Seek to vars
	ld   e, l				; DE = Ptr to iScActYSub (position)
	ld   d, h
	
	inc  hl ; iScActY		; HL = Ptr to iScActSpdYSub (speed)
	inc  hl ; iScActXSub
	inc  hl ; iScActX
	inc  hl ; iScActSpdYSub
	
	; Move vertically
	; iScActY* += iScActSpdY*
	ld   a, [de]	; Read iScActYSub
	add  [hl]		; Add iScActSpdYSub
	ld   [de], a	; Save back
	inc  hl ; iScActSpdY
	inc  de ; iScActY
	ld   a, [de]	; Read iScActY
	adc  [hl]		; Add speed + overflow
	ld   [de], a	; Save back
	inc  hl ; iScActSpdXSub
	inc  de ; iScActXSub
	
	; Move horizontally
	; iScActX* += iScActSpdX*
	ld   a, [de]
	add  [hl]
	ld   [de], a
	inc  hl
	inc  de
	ld   a, [de]
	adc  [hl]
	ld   [de], a
	inc  hl
	inc  de
	
	ret
	
