; =============== ActS_DrawSprMap ===============
; Draws an actor sprite mapping to the screen.
ActS_DrawSprMap:
	DEF tActSprFlags = wTmpCF52
	push af
		ld   a, BANK(ActS_SprMapPtrTbl) ; BANK $03
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	;
	; Actors with an invulnerability timer set should flash every 2 frames.
	; This will be used to calculate the effective OBJ flags value.
	; While we're here, also decrement that timer.
	;
	
	ld   a, [wActCurSlotPtr]	; HL = Ptr to current slot's iActColiInvulnTimer
	add  iActColiInvulnTimer	
	ld   l, a
	ld   h, HIGH(wActColi)
	
	ld   a, [hl]
	or   a						; iActColiInvulnTimer == 0?
	jr   z, .calcFlags			; If so, skip
	dec  [hl]					; iActColiInvulnTimer--
	
	; Shift the 2nd bit of the invuln timer (every 2 frames) into SPRB_OBP1
	and  $02					; Every 2 frames...
	sla  a						; ...bit2
	sla  a						; ...bit3
	sla  a						; ...bit4 (SPRB_OBP1)
	
	; And merge it with the player flags into the final value, to force all actors into
	; sharing the same SPR_BGPRIORITY flag as the player.
.calcFlags:
	; A will be 0 if we jumped to here (SPRB_OBP1 clear)
	ld   b, a					
	ld   a, [wPlSprFlags]
	or   b						
	ld   [tActSprFlags], a
	
	;--
	
	;
	; Find the sprite mapping associated with the current frame.
	; We have to go through two layers of pointer tables to get there.
	;
	
	;
	; FIRST ONE
	;
	; Indexed by actor IDs, each entry is a pointer to a table of other pointers.
	;
	
	; First, seek HL to the sprite mapping table associated to the current actor.
	ldh  a, [hActCur+iActId]
	and  $FF^ACTF_PROC			; Filter out active marker
	sla  a						; * 2
	ld   hl, ActS_SprMapPtrTbl
	ld   b, $00
	ld   c, a
	add  hl, bc					; Seek to the entry
	ldi  a, [hl]				; Read its pointer out to DE
	ld   e, a
	ld   a, [hl]
	ld   d, a
	ld   l, e					; and to HL
	ld   h, d
	
	;
	; SECOND ONE
	;
	; Indexed by sprite mapping ID, each entry is a pointer to the actual sprite mapping data.
	;
	; The index itself is not straightforward, two separate values are added together to make
	; it easier using relative offsets.
	; One of the values ("relative ID") is stored directly into the slot, the other ("base ID")
	; is a one-off that needs to be manually set each time the actor is processed.
	;
	
	; B = Base ID * 2
	ld   a, [wActCurSprMapBaseId]	; Read base ID
	sla  a							; Pointer table requirement
	ld   b, a
	; The relative ID is packed into just three bits of iActSprMap. (bits3-5)
	; This implies a big limit on the number of mappings animations can normally have.
	; A = (iActSprMap >> 2) & $0E
	ldh  a, [hActCur+iActSprMap]	
	srl  a							; Shift them down twice to bits1-5
	srl  a							; (not 3 times, due to pointer table reqs)
	and  $0E						; Filter out other bits
	add  b
	; Index the entry and read its pointer out to DE
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldi  a, [hl]
	ld   e, a
	ld   a, [hl]
	ld   d, a
	
	;--
	
	;
	; Write the sprite mapping to the OAM mirror.
	;
	
	ldh  a, [hWorkOAMPos]	; HL = Ptr to current OAM slot
	ld   l, a
	ld   h, HIGH(wWorkOAM)
	
	;
	; The first byte of a mapping marks the number of individual OBJ they use.
	; Invisible frames point to a dummy mapping with an OBJ count of 0, so
	; return early in that case.
	;
	ld   a, [de]			; A = OBJCount
	or   a					; OBJCount == 0?
	jp   z, .end			; If so, we're done
	inc  de					; Otherwise, seek to the OBJ table
	ld   b, a				; B = OBJCount
	
	;
	; What follows are <OBJCount> tables with 4 entries each, that directly follow the same structure the OAM OBJ:
	; - Rel. Y pos
	; - Rel. X pos
	; - Tile ID
	; - OBJ Flags
	;
	
	; Two completely separate loops are used to handle horizontal flipping.
	; This is due to the relative positions between individual OBJ being inverted,
	; and it's also faster to perform the check only once.
	;
	; Note that vertical flipping isn't supported. The ACTDIR_D flag is only used to 
	; determine the "forward" vertical direction, but doesn't affect how the sprite is drawn.
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a		; Actor facing right?
	jr   nz, .loopR			; If so, jump
.loopL:

	;
	; NO FLIPPING
	; Nothing special here.
	;
	
	; YPos = iActY + byte0
	ldh  a, [hActCur+iActY]	; C = Absolute Y
	ld   c, a
	ld   a, [de]			; A = Relative Y
	inc  de					; Seek to byte1 for later
	add  c					; Get final pos
	ldi  [hl], a			; Write to OAM mirror
	
	; XPos = iActX + byte1
	ldh  a, [hActCur+iActX]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	
	; TileID = byte2
	ld   a, [de]
	inc  de
	ldi  [hl], a
	
	; Flags = byte3 | tActSprFlags
	; Curiously, the base flags are OR'd with ours, compared to the usual way of XOR'ing them.
	; This prevents an actor from overriding all options.
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [tActSprFlags]
	or   c
	ldi  [hl], a
	
	; If we reached the end of the OAM mirror, stop drawing any further OBJ.
	; [POI] While this could have also been checked at the start of the subroutine,
	;       in practice it's not an issue.
	;       Of the two places that call this subroutine, one of them performs this check
	;       before calling it, while the other is called while the OAM mirror is empty.
	ld   a, l
	cp   OAM_SIZE			; HL == $DFA0?
	jr   z, .full			; If so, abort (we're full)
	dec  b					; Finished copying all OBJ?
	jr   nz, .loopL			; If not, loop
	
	ld   a, l				; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	jr   .end
	
.loopR:

	;
	; HORIZONTAL FLIPPING
	; This needs to flip the individual OBJ alongside the sprite mapping itself.
	;
	
	; YPos = iActY + byte0
	ldh  a, [hActCur+iActY]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	
	; XPos = -(iActX + byte1) - TILE_H
	; For flipping the sprite mapping
	ldh  a, [hActCur+iActX]	; C = Absolute X
	ld   c, a
	ld   a, [de]			; A = Relative X
	inc  de					; Seek to byte2 for later
	xor  $FF				; Invert the rel. X position (offset by -1)
	sub  TILE_H-1			; Account for tile width
	add  c					; Get final pos
	ldi  [hl], a			; Write to OAM mirror
	
	; TileID = byte2
	ld   a, [de]
	inc  de
	ldi  [hl], a
	
	; Flags = (byte3 | tActSprFlags) ^ SPR_XFLIP
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [tActSprFlags]
	or   c
	xor  SPR_XFLIP			; Flip the individual OBJ graphic
	ldi  [hl], a
	
	; If we reached the end of the OAM mirror, stop drawing any further OBJ.
	ld   a, l
	cp   OAM_SIZE			; HL == $DFA0?
	jr   z, .full			; If so, abort (we're full)
	dec  b					; Finished copying all OBJ?
	jr   nz, .loopR			; If not, loop
	
	ld   a, l				; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	jr   .end
	
.full:
	ldh  [hWorkOAMPos], a	; Save back current OAM ptr
	
	; Since any further actors won't draw and their processing order is the draw order,
	; on the next frame start processing them from the current slot.
	; Note that the remaining actors *will* still get processed, just not drawn.
	ld   a, [wActCurSlotPtr]
	ld   [wActLastDrawSlotPtr], a	; Mark end of OAM reached
.end:
	push af
		ldh  a, [hROMBankLast]
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
