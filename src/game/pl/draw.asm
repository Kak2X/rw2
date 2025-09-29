; =============== Pl_AnimWalk ===============
; Animates the player's walk cycle, and redraws its sprite.
Pl_AnimWalk:
	
	;
	; The player's walk animation is split in two parts.
	; Starting from a standstill, when holding left or right:
	; - The first 7 frames the player uses a sidestep sprite
	; - From the 8th frame, the proper walk cycle begins
	;
	; Unlike other games, the sidestep is a purely visual effect that does not affect or delay the controls in any way.
	;
	
	; Which animation are we in?
	ld   a, [wPlWalkAnimTimer]
	cp   $07					; wPlWalkAnimTimer == $07?
	jr   z, .walkAnim			; If so, jump (walk cycle on)
.sidestep:
	inc  a						; Otherwise, wPlWalkAnimTimer++
	ld   [wPlWalkAnimTimer], a

	ld   a, PLSPR_SIDESTEP		; Set sidestep frame
	ld   [wPlSprMapId], a
	jr   Pl_DrawSprMap			; Draw it
	
.walkAnim:

	;
	; This animation is done by cycling through the four PLSPR_WALK* sprites, advancing after 64 frames.
	; These four sprites are in slots $00-$03.
	; 
	
	; Advance animation timer
	ld   a, [wPlAnimTimer]
	add  $08
	ld   [wPlAnimTimer], a
	
	; Shift down bits6-7 to bit0-1 and use it as relative sprite mapping IDs.
	swap a ; >> 4
	srl  a ; >> 1 (5)
	srl  a ; >> 1 (6)
	and  $03
	ld   [wPlSprMapId], a
	jr   Pl_DrawSprMap
	
; =============== Pl_AnimClimb ===============
; Animates the player's ladder climbing cycle, and redraws its sprite.
Pl_AnimClimb:

	;
	; This animation is done by flipping the player's direction every 64 frames.
	; The player's sprite is assumed to already be the climbing one when we get here.
	;
	; [POI] Setting the direction without restoring it after drawing the sprite
	;       has some side effects, like inconsistent shot directions or Pipi spawn locations.
	;       
	
	; Advance animation timer
	ld   a, [wPlAnimTimer]
	add  $06
	ld   [wPlAnimTimer], a
	
	; Shift down bit6 ($40) to bit0 and use it as direction.
	swap a ; >> 4
	srl  a ; >> 1 (5)
	srl  a ; >> 1 (6)
	and  $01			; Filter out other bits
	ld   [wPlDirH], a	; That's the direction
	
	; Fall-through
	
; =============== Pl_DrawSprMap ===============
; Draws the sprite mapping for the player.
Pl_DrawSprMap:

	; Top Spin's spin state is internally a weapon shot, so it's not drawn here.
	ld   a, [wWpnTpActive]
	or   a					; Top spin is active?
	jp   nz, .chkDust		; If so, skip
	
.chkHurt:
	;
	; When hurt, the player flashes and their frame is forced to the hurt one,
	; unless the current state would look odd with it.
	;

	; Not applicable when not hurt
	ld   a, [wPlHurtTimer]
	or   a					; Are we hurt?
	jr   z, .notHurt		; If not, skip
	
	; Flash sprite every other frame
	ldh  a, [hTimer]
	rra  					; hTimer % 2 == 0?
	jp   nc, .chkDust		; If so, jump
	
	; Force the player to use the hurt frame, except when their state is PL_MODE_SLIDE or above.
	; Those don't account for the player being hurt, so that frame would look odd.
	ld   a, [wPlMode]
	cp   PL_MODE_SLIDE		; wPlMode >= PL_MODE_SLIDE?
	jr   nc, .notHurt		; If so, jump
	ld   a, [wWpnSGRide]
	or   a					; Riding the Sakugarne?
	jr   nz, .notHurt		; If so, jump
	
	; Force hurt frame
	ld   a, PLSPR_HURT
	jr   .drawPl
	
.notHurt:
	;
	; During mercy invulnerability, flash sprite every 2 frames
	;
	ld   a, [wPlInvulnTimer]
	or   a					; Are we invulerable?
	jr   z, .getIdx			; If not, skip
	ldh  a, [hTimer]
	rra
	rra   					; (hTimer / 2) % 2 == 0? 
	jp   nc, .chkDust		; If so, jump
	
.getIdx:
	;
	; Build the index to the player's sprite mapping table.
	; A = wPlSprMapId | wPlShootType
	;
	; Since wPlShootType will be $00, $10 or $20, this enforces a specific frame order,
	; with those >= $30 being wPlShootType-independent.
	;
	ld   a, [wPlShootType]
	ld   b, a
	ld   a, [wPlSprMapId]
	or   b
	
.drawPl:

	;
	; Find the sprite mapping associated to the current frame.
	; There's a single table here unlike with actors, as there's only one player.
	;
	push af
		ld   a, BANK(Pl_SprMapPtrTbl) ; BANK $03
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   hl, Pl_SprMapPtrTbl	; HL = Ptr table base
	ld   b, $00					; BC = A * 2
	sla  a
	ld   c, a
	add  hl, bc					; Index it
	ldi  a, [hl]				; Read out to DE
	ld   e, a
	ld   a, [hl]
	ld   d, a
	
	;
	; Write the sprite mapping to the OAM mirror.
	; See also: Relevant code in ActS_DrawSprMap since it's pretty much the same.
	;
	
	ld   h, HIGH(wWorkOAM)	; HL = Ptr to current OAM slot
	ldh  a, [hWorkOAMPos]
	ld   l, a
	
	; Ignore blank sprite mappings
	ld   a, [de]
	or   a					; OBJCount == 0?
	jp   z, .drawPlEnd		; If so, we're done
	inc  de					; Otherwise, seek to the OBJ table
	ld   b, a				; B = OBJCount
	
	; Check for horizontal flip
	ld   a, [wPlDirH]
	or   a					; Player facing right?
	jr   nz, .loopR			; If so, jump
	
.loopL:
	;
	; NO FLIPPING
	; Nothing special here.
	;
	
	; YPos = wPlRelY + byte0
	ld   a, [wPlRelY]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	
	; XPos = wPlRelX + byte1
	ld   a, [wPlRelX]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	
	; TileID = byte2
	ld   a, [de]
	inc  de
	ldi  [hl], a
	
	; Flags = byte3 | wPlSprFlags
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [wPlSprFlags]
	or   c
	ldi  [hl], a
	
	; [POI] No full OAM check here, since these mappings are assumed to not be that big.
	dec  b					; Finished copying all OBJ?
	jr   nz, .loopL			; If not, loop
	
	ld   a, l				; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	jr   .drawPlEnd
	
.loopR:
	;
	; HORIZONTAL FLIPPING
	; Flips individual OBJ + the sprite mapping itself.
	;
	
	; YPos = wPlRelY + byte0
	ld   a, [wPlRelY]
	ld   c, a
	ld   a, [de]
	inc  de
	add  c
	ldi  [hl], a
	
	; XPos = -(wPlRelX + byte1) - TILE_H + 1
	; For flipping the sprite mapping
	; [POI] This is offset 1 pixel to the right compared to actor sprites.
	;       The consequences are that actors or shots that spawn from the
	;       player might need to be also offset by +1 when facing right.
	ld   a, [wPlRelX]	; C = Absolute X
	ld   c, a
	ld   a, [de]		; A = Relative X
	inc  de				; Seek to byte2 for later
	xor  $FF			; Invert the rel. X position (offset by -1)
	sub  TILE_H-2		; Account for tile width - 1
	add  c				; Get final pos
	ldi  [hl], a		; Write to OAM mirror
	
	; TileID = byte2
	ld   a, [de]
	inc  de
	ldi  [hl], a
	
	; Flags = (byte3 | wPlSprFlags) ^ SPR_XFLIP
	ld   a, [de]
	inc  de
	ld   c, a
	ld   a, [wPlSprFlags]
	or   c
	xor  SPR_XFLIP
	ldi  [hl], a
	
	dec  b					; Finished copying all OBJ?
	jr   nz, .loopR			; If not, loop
	ld   a, l				; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	
.drawPlEnd:
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
.chkDust:
	;
	; Draw the dust particle caused by sliding, if needed.
	;
	ld   a, [wPlSlideDustTimer]
	or   a							; Timer has elapsed?
	ret  z							; If so, return
	dec  a							; Otherwise, Timer--
	ld   [wPlSlideDustTimer], a
	
	;
	; The animation frame picked is the timer's upper nybble.
	; This has two consequences:
	; - The animation advances every 16 frames
	; - Since it's a countdown timer, entries in the tile ID table are stored in reverse
	;
	swap a							; A /= 16
	and  $03						; Force valid range
	ld   hl, .dustTileTbl			; HL = Tile ID Table
	ld   b, $00						; BC = A
	ld   c, a
	add  hl, bc
	
	ld   a, [hl]					; B = Tile ID
	ld   b, a
	ld   a, [wActScrollX]			; C = wActScrollX
	ld   c, a
	
	ld   h, HIGH(wWorkOAM)			; HL = Ptr to current OAM slot
	ldh  a, [hWorkOAMPos]
	ld   l, a
	
	
	; Y POSITION
	
	; The dust sprite should be vertically aligned with the player, so:
	; YPos = wPlSlideDustY - (TILE_H - 1)
	;
	; wPlSlideDustY is a copy of wPlRelY, and since the player's origin is at the 
	; bottom border, the sprite is manually offsetted by TILE_H-1.
	ld   a, [wPlSlideDustY]
	sub  TILE_H-1
	ldi  [hl], a
	
	; X POSITION
	; 4 pixels to the left of the player's origin
	; XPos = wPlSlideDustX - $04
	
	; The screen can scroll horizontally, so adjust wPlSlideDustX as needed
	ld   a, [wPlSlideDustX]		; wPlSlideDustX += wActScrollX
	add  c
	ld   [wPlSlideDustX], a
	
	sub  $04					; XPos = wPlSlideDustX - $04
	ldi  [hl], a
	
	; TileId = B
	ld   a, b
	ldi  [hl], a
	
	; Flags = wPlSprFlags
	ld   a, [wPlSprFlags]
	ldi  [hl], a
	
	ld   a, l					; Save back current OAM ptr
	ldh  [hWorkOAMPos], a
	ret
	
; =============== .dustTileTbl ===============
; Table of tile IDs for the dust particle animation, stored in reverse.
.dustTileTbl:
	db $62
	db $61
	db $60

