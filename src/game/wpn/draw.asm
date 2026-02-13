; =============== WpnS_DrawSprMap ===============
; Draws the sprite mapping for the shot.
WpnS_DrawSprMap:

	; Adjust the shot's X position in case of screen scrolling
	ld   a, [wActScrollX]		; iShotX += wActScrollX
	ld   b, a
	ldh  a, [hShotCur+iShotX]
	add  b
	ldh  [hShotCur+iShotX], a
	
.chkOffscrX:
	; Check if the movement made it go off-screen horizontally.
	; Despawn anything in the $A8-$F7 range.
	cp   SCREEN_H+$08	; iShotY < $A8?
	jr   c, .chkOffscrY	; If so, jump
	cp   -$08			; iShotY < $F8?
	jr   c, .despawn	; If so, jump
	
.chkOffscrY:
	; Also do a vertical off-screen check.
	; Despawn anything in the $98-$F7 range.
	ldh  a, [hShotCur+iShotY]
	cp   SCREEN_V+$08	; iShotY < $98?
	jr   c, .getPtr		; If so, jump
	cp   -$08			; iShotY < $F8?
	jr   c, .despawn	; If so, jump
	
.getPtr:
	; DE = Ptr to current wWorkOAM location
	ld   d, HIGH(wWorkOAM)
	ldh  a, [hWorkOAMPos]
	ld   e, a
	
	; Read out the sprite definition off the table
	; HL = WpnS_SprMapPtrTbl[iShotSprId*2]
	ldh  a, [hShotCur+iShotSprId]
	add  a				; *2 for word table
	ld   hl, WpnS_SprMapPtrTbl	; HL = Table base
	ld   b, $00			; BC = Offset
	ld   c, a
	add  hl, bc			; Index it
	ldi  a, [hl]		; Read out the pointer to HL
	ld   h, [hl]
	ld   l, a
	
	;
	; Write the sprite mapping to the OAM mirror.
	; See also: Relevant code in ActS_DrawSprMap since it's pretty much the same.
	;
	; This appears to be a little less optimized than the player and actor variants,
	; as it merges the two flip loops in a single path.
	;
	
	; Ignore blank sprite mappings
	ldi  a, [hl]
	or   a				; OBJCount == 0?
	ret  z				; If so, we're done
	
	ld   b, a			; B = OBJCount
.loop:					; For each individual OBJ...
	
	; YPos = iShotY + byte0
	ldh  a, [hShotCur+iShotY]	; A = Absolute Y
	add  [hl]					; += Relative Y (byte0)
	inc  hl						; Seek to byte1
	ld   [de], a				; Write to OAM mirror
	inc  de						; Seek to XPos
	
	; X POSITION
	; This is affected by the horizontal direction, since if it's facing right,
	; the whole sprite mapping needs to get flipped.
	;
	; XPos = iShotX + byte1 (facing left)
	; XPos = iShotX - byte1 - 8 (facing right)
	
	; Determine the shot's direction
	ldh  a, [hShotCur+iShotDir]	; # Read direction
	dec  a						; # Z Flag = Facing right? (DIR_R decremented to 0)
	ldi  a, [hl]				; Read byte1 while we're here
	jr   nz, .setX				; # If not, jump (facing left, keep raw byte1)
.invX:
	cpl  						; Otherwise, invert the rel. X position
	inc  a
	sub  TILE_H					; Account for tile width
.setX:
	; Set the X position
	ld   c, a					; C = Relative X
	ldh  a, [hShotCur+iShotX]	; A = Absolute X
	add  c						; Get final pos
	ld   [de], a				; Write to OAM mirror
	inc  de
	
	; TileID = byte2
	ldi  a, [hl]
	ld   [de], a
	inc  de
	
	; Flags = (byte3 | wPlSprFlags) (facing left)
	; Flags = (byte3 | wPlSprFlags) ^ SPR_XFLIP (facing right)
	ldh  a, [hShotCur+iShotDir]	; # Read direction
	dec  a						; # Z Flag = Facing right? (DIR_R decremented to 0)
	ldi  a, [hl]				; Read byte3 while we're here
	jr   nz, .setFlags			; # If not, jump (facing left, keep raw byte3)
	xor  SPR_XFLIP				; Horizontally flip the individual tile
.setFlags:
	ld   c, a					; C = Tile flags
	ld   a, [wPlSprFlags]		; A = BG priority flag for stage
	or   c						; Merge them
	ld   [de], a				; Write to OAM mirror 
	inc  de						; to next OBJ entry
	
	dec  b						; Finished copying all OBJ?
	jr   nz, .loop				; If not, loop
	
	ld   a, e					; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	ret
	
.despawn:
	xor  a
	ldh  [hShotCur+iShotId], a
	ret