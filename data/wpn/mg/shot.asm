; =============== Wpn_MagnetMissile ===============
; Magnet Missile.
; A magnet fired forward, which can lock in vertically once to any actor.
Wpn_MagnetMissile:

	; If we locked on to something before, continue moving vertically
	ldh  a, [hShotCur+iShotMgMoveV]
	or   a				; Moving vertically?
	jr   nz, .moveV		; If so, jump
	
.scanAct:

	;
	; Find if there any suitable actor to vertically lock on at the current horizontal location.
	;
	
	ldh  a, [hShotCur+iShotX]	; B = X Position searched for
	ld   b, a
	

	ld   hl, wAct		; From the first actor...
.loopAct:
	; Ignore empty slots
	ldi  a, [hl]		; A = iActId, seek to iActRtnId
	or   a				; Is the slot empty?
	jr   z, .nextAct	; If so, skip to the next one
	
	; Only try to target actors that aren't fully invulnerable.
	; Unfortunately, this has both a bug and a design flaw.
	; - This does not actually check if the actor is *immune* to Magnet Missile,
	;   so it may target otherwise defeatable actors that reflect Magnet Missile.
	; - It tries to target invulnerable enemies (see below)
	ld   e, l			; DE = Ptr to iActRtnId
	ld   d, h
	inc  d				; Seek to iActColiBoxV
	inc  e				; Seek to iActColiType
	ld   a, [de]		; Read iActColiType
	
	; Actors with collision types >= $80 are partially vulnerable on top (see Wpn_OnActColi.typePartial),
	; which is good enough for us.
	; [POI] Note that this isn't the full range of values for this collision type.
	;       The actual range is $08-$FF, and as a result Magnet Missile won't target partially vulnerable
	;       actors in ranges $08-$7F. The actors using this collision type don't use that range though.
	bit  ACTCOLIB_PARTIAL, a	; Is this a partially vulnerable actor?
	jr   nz, .calcDistX		; If so, jump (ok)
	
	; Target vulnerable enemies
	cp   ACTCOLI_ENEMYHIT		; iActColiType == ACTCOLI_ENEMYHIT?
	jr   z, .calcDistX	; If so, jump (ok)
	
	; [BUG] Target invulnerable enemies
	; This is pretty egregious, it's specifically checking if the actor uses the collision type for
	; invulnerable enemies (ie: Hanging battons or Mets hiding) and... only skips targeting it if that's not the case.
	; What this should have done instead is jumping unconditionally to .nextAct.
	cp   ACTCOLI_ENEMYREFLECT		; iActColiType == ACTCOLI_ENEMYREFLECT?
	jr   nz, .nextAct	; If not, seek to the next slot
	
.calcDistX:
	inc  l ; iActSprMap
	inc  l ; iActLayoutPtr
	inc  l ; iActXSub
	inc  l ; iActX
	
	; If the shot is within 5 pixels from the actor, we found a target
	ldi  a, [hl] 		; A = iActX, seek to iActYSub
	sub  b				; Find distance (-= iShotX)
	; Distance should be absolute
	jr   nc, .chkDistX	; Did we underflow? If not, skip
	cpl  				; Otherwise, force positive sign
	inc  a
.chkDistX:
	cp   $05			; Distance < 5?
	jr   c, .foundAct	; If so, jump
	
.nextAct:
	; Seek to the next slot
	ld   a, l
	and  $F0			; Move back to iActId
	add  iActEnd		; To next slot
	ld   l, a			; Overflowed back to the first slot? (all 16 slots checked)
	jr   nz, .loopAct	; If not, loop
	
	; No suitable actor found, keep moving forward
	jr   .moveH
	
.foundAct:
	;
	; Found a suitable actor to lock on to.
	; Determine if it's above or below us, and set the shot's direction accordingly.
	;
	ldh  a, [hShotCur+iShotY]	; A = iShotY
	inc  l 						; Seek HL to iActY
	cp   [hl]					; iShotY > iActY? (Shot is below actor?)
	ld   a, DIR_U				; # A = DIR_U
	jr   nc, .setDirV			; If so, jump (shot should move up, keep DIR_U)
	inc  a						; # A = DIR_D (the actor is below, move shot down)
.setDirV:
	ldh  [hShotCur+iShotDir], a
	
	; Flag that we're moving vertically now
	ld   hl, hShotCur+iShotMgMoveV
	inc  [hl]
	
	; Immediately start moving vertically
	jr   .moveV
	
.moveH:
	;
	; Not locked in to anything yet.
	; Move forwards 2px/frame.
	;
	ld   hl, hShotCur+iShotX	; Seek HL to iShotX
	ldh  a, [hShotCur+iShotDir]
	or   a						; Facing right?
	jr   nz, .moveR				; If so, jump
.moveL:
	ld   a, [hl]
	sub  $02
	ld   [hl], a
	jp   WpnS_DrawSprMap
.moveR:
	ld   a, [hl]
	add  $02
	ld   [hl], a
	jp   WpnS_DrawSprMap
	
.moveV:
	;
	; Locked in to an actor above or below.
	; Move vertically 2px/frame.
	;
	ld   hl, hShotCur+iShotY	; Seek HL to iShotY
	ldh  a, [hShotCur+iShotDir]
	rra							; DIR_D is $03, when >> 1'd it will set the carry
	jr   c, .moveD				; Is it set? If so, jump
.moveU:
	dec  [hl]					; iShotY -= 2
	dec  [hl]
	ld   a, SHOTSPR_MGU
	ldh  [hShotCur+iShotSprId], a
	jp   WpnS_DrawSprMap
.moveD:
	inc  [hl]					; iShotY += 2
	inc  [hl]
	ld   a, SHOTSPR_MGD
	ldh  [hShotCur+iShotSprId], a
	jp   WpnS_DrawSprMap
	
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
	
; =============== WpnS_SprMapPtrTbl ===============
; Points to all weapon shot sprite mappings.
WpnS_SprMapPtrTbl:
	dw SprMap_WpnP        ; SHOTSPR_P
	dw SprMap_WpnAr0      ; SHOTSPR_AR0
	dw SprMap_WpnAr1      ; SHOTSPR_AR1
	dw SprMap_WpnAr2      ; SHOTSPR_AR2 ; [TCRF] Unused sprite mapping
	dw SprMap_WpnWd       ; SHOTSPR_WD
	dw SprMap_WpnMe0      ; SHOTSPR_ME0
	dw SprMap_WpnMe1      ; SHOTSPR_ME1
	dw SprMap_WpnCrMove   ; SHOTSPR_CRMOVE
	dw SprMap_WpnCrFlash0 ; SHOTSPR_CRFLASH0
	dw SprMap_WpnCrFlash1 ; SHOTSPR_CRFLASH1
	dw SprMap_WpnCrExpl0  ; SHOTSPR_CREXPL0
	dw SprMap_WpnCrExpl1  ; SHOTSPR_CREXPL1
	dw SprMap_WpnCrExpl2  ; SHOTSPR_CREXPL2
	dw SprMap_WpnCrExpl3  ; SHOTSPR_CREXPL3
	dw SprMap_WpnCrExpl4  ; SHOTSPR_CREXPL4
	dw SprMap_WpnCrExpl5  ; SHOTSPR_CREXPL5
	dw SprMap_WpnCrExpl6  ; SHOTSPR_CREXPL6
	dw SprMap_WpnCrExpl7  ; SHOTSPR_CREXPL7
	dw SprMap_WpnCrExpl8  ; SHOTSPR_CREXPL8
	dw SprMap_WpnNe       ; SHOTSPR_NE
	dw SprMap_WpnHa       ; SHOTSPR_HA
	dw SprMap_WpnMgH      ; SHOTSPR_MGH
	dw SprMap_WpnMgU      ; SHOTSPR_MGU
	dw SprMap_WpnMgD      ; SHOTSPR_MGD
	dw SprMap_WpnTp0      ; SHOTSPR_TP0
	dw SprMap_WpnTp1      ; SHOTSPR_TP1
	dw SprMap_WpnTp2      ; SHOTSPR_TP2
	dw SprMap_WpnTp1      ; SHOTSPR_TP3
	dw SprMap_WpnSg       ; SHOTSPR_SG
	
