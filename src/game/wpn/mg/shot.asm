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