; =============== ActS_MoveBySpeedX ===============
; Moves the actor forward by its current horizontal speed.
ActS_MoveBySpeedX:
	; BC = SpeedX
	ldh  a, [hActCur+iActSpdXSub]
	ld   c, a
	ldh  a, [hActCur+iActSpdX]
	ld   b, a
	
	; "Forward" has different meanings depending on the direction we're facing
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a			; Facing right?
	jr   nz, .moveR				; If so, jump
.moveL:
	; XPos -= SpeedX
	ldh  a, [hActCur+iActXSub]
	sub  c
	ldh  [hActCur+iActXSub], a
	ldh  a, [hActCur+iActX]
	sbc  b
	ldh  [hActCur+iActX], a
	
	;
	; Offscreen despawn check.
	; When actors are within range $D0-$DF, they are despawned for being offscreen.
	;
	; This leaves a window of:
	; - $30px to right of the screen
	; - $20px to the left of the screen
	;
	; Accounting for the hardware offset of 8px, that means there's a 40px area to around 
	; both sides of the screen where actors can be active, but outside of the visible screen.
	;
	and  $F0
	cp   $D0					; (iActX % $F0) == $D0?
	jp   z, ActS_Despawn		; If so, despawn it
	ret
	
.moveR:
	; XPos += SpeedX
	ldh  a, [hActCur+iActXSub]
	add  c
	ldh  [hActCur+iActXSub], a
	ldh  a, [hActCur+iActX]
	adc  b
	ldh  [hActCur+iActX], a
	
	; See above
	and  $F0
	cp   $D0
	jp   z, ActS_Despawn
	ret
	
; =============== ActS_MoveBySpeedX_Coli ===============
; Moves the actor forward by its current horizontal speed, while checking for solid collision. 
ActS_MoveBySpeedX_Coli:
	; Read out the actor's collision box size to a temp area
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   [wTmpColiBoxH], a
	ld   a, [hl]
	ld   [wTmpColiBoxV], a
	
	; BC = SpeedX
	ldh  a, [hActCur+iActSpdXSub]
	ld   c, a
	ldh  a, [hActCur+iActSpdX]
	ld   b, a
	
	; "Forward" has different meanings depending on the direction we're facing.
	; This will affect our horizontal collision targets, to make them point either
	; to the left or right border.
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a			; Facing right?
	jr   nz, .moveR				; If so, jump
.moveL:
	
	DEF tNewXPosSub = wTmpCF52
	DEF tNewXPos    = wTmpCF53
	
	;
	; Calculate the potential new X position
	; NewYPos = XPos - BC
	;
	ldh  a, [hActCur+iActXSub]
	sub  c
	ld   [tNewXPosSub], a
	ldh  a, [hActCur+iActX]
	sbc  b
	ld   [tNewXPos], a
	
	; Standard off-screen despawn check (see: ActS_MoveBySpeedX)
	and  $F0
	cp   $D0
	jp   z, ActS_Despawn
	
	;
	; The collision target is on the left border
	; wTargetRelX = tNewXPos - wTmpColiBoxH
	;
	ld   a, [wTmpColiBoxH]
	ld   b, a
	ld   a, [tNewXPos]
	sub  b
	ld   [wTargetRelX], a
	jr   .chkColi
.moveR:

	;
	; Calculate the potential new X position
	; NewYPos = XPos + BC
	;
	ldh  a, [hActCur+iActXSub]
	add  c
	ld   [tNewXPosSub], a
	ldh  a, [hActCur+iActX]
	adc  b
	ld   [tNewXPos], a
	
	; Standard off-screen despawn check (see: ActS_MoveBySpeedX)
	and  $F0
	cp   $D0
	jp   z, ActS_Despawn
	
	;
	; The collision target is on the right border
	; wTargetRelX = tNewXPos + wTmpColiBoxH
	;
	ld   a, [wTmpColiBoxH]
	ld   b, a
	ld   a, [tNewXPos]
	add  b
	ld   [wTargetRelX], a
	
.chkColi:

	;
	; Check for collision on the forward border.
	;
	; This goes off three sensors:
	; - Top-forward corner
	; - Middle-forward
	; - Bottom-forward corner
	;
	; If any if these points to a solid block, no movement is made.
	;
	
	;
	; BOTTOM-FWD
	; wTargetRelY = iActY
	;
	ldh  a, [hActCur+iActY]	
	ld   [wTargetRelY], a	; The origin is at the bottom, so it matches
	call Lvl_GetBlockId
	ret  nc
	
	;
	; MIDDLE-FWD
	; wTargetRelY -= wTmpColiBoxV
	;
	ld   a, [wTmpColiBoxV]
	ld   b, a
	ld   a, [wTargetRelY]
	sub  b					; subtract the vertical radius to get to the middle
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	
	;
	; TOP-FWD
	; wTargetRelY -= wTmpColiBoxV
	;
	ld   a, [wTmpColiBoxV]
	ld   b, a
	ld   a, [wTargetRelY]
	sub  b					; subtract the vertical radius again to get to the top
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	
	;
	; Passed the gauntlet, save the new position
	;
	ld   a, [tNewXPosSub]
	ldh  [hActCur+iActXSub], a
	ld   a, [tNewXPos]
	ldh  [hActCur+iActX], a
	ret
	
; =============== ActS_MoveBySpeedY ===============
; Moves the actor forward by its current vertical speed.
ActS_MoveBySpeedY:
	; BC = SpeedY
	ldh  a, [hActCur+iActSpdYSub]
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	ld   b, a
	
	; "Forward" has different meanings depending on the direction we're facing.
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_D, a				; Is the bit set?
	jr   nz, .moveD					; If so, we're moving down
	
.moveU:
	; YPos -= SpeedY
	ldh  a, [hActCur+iActYSub]
	sub  c
	ldh  [hActCur+iActYSub], a
	ldh  a, [hActCur+iActY]
	sbc  b
	ldh  [hActCur+iActY], a
	
	; If the actor in within vertical range $00-$0F, despawn it.
	; Accounting for the vertical offset of 16px, that's above the visible area of the screen.
	and  $F0				; $00-$0F
	cp   $00
	jp   z, ActS_Despawn
	ret
	
.moveD:
	; YPos += SpeedY
	ldh  a, [hActCur+iActYSub]
	add  c
	ldh  [hActCur+iActYSub], a
	ldh  a, [hActCur+iActY]
	adc  b
	ldh  [hActCur+iActY], a
	
	; If the actor in within vertical range $A0-$AF, despawn it.
	; Accounting for the vertical offset of 16px, this is 16px below the visible area of the gameplay screen.
	and  $F0				; $A0-$AF
	cp   $A0
	jp   z, ActS_Despawn
	ret
	
; =============== ActS_MoveBySpeedYColi ===============
; Moves the actor forward by the current vertical speed, while checking for solid collision.
; 
; See also: ActS_MoveBySpeedY, ActS_MoveBySpeedX_Coli
ActS_MoveBySpeedYColi:

	; Read out the actor's collision box size to a temp area
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   [wTmpColiBoxH], a
	ld   a, [hl]
	ld   [wTmpColiBoxV], a
	
	; BC = SpeedY
	ldh  a, [hActCur+iActSpdYSub]
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	ld   b, a
	
	DEF tNewYPosSub = wTmpCF52
	DEF tNewYPos    = wTmpCF53
	
	; "Forward" has different meanings depending on the direction we're facing.
	; We need to check for collision on either the top or bottom border, depending on that.
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_D, a			; Is the bit set?
	jr   nz, .moveD				; If so, we're moving down
	
.moveU:
	; YPos -= SpeedY
	ldh  a, [hActCur+iActYSub]
	sub  c
	ld   [tNewYPosSub], a
	ldh  a, [hActCur+iActY]
	sbc  b
	ld   [tNewYPos], a
	
	; Standard off-screen above check (see also: ActS_MoveBySpeedY)
	and  $F0				; $00-$0F
	cp   $00
	jp   z, ActS_Despawn
	
	; The sensors are at the top border.
	ld   a, [wTmpColiBoxV]	; Get vertical radius
	sla  a					; From radius to height
	ld   b, a
	ld   a, [tNewYPos]		; Get new Y pos
	sub  b					; Move up to the top border
	ld   [wTargetRelY], a	; That's the target
	
	jr   .chkColi
	
.moveD:
	; YPos += SpeedY
	ldh  a, [hActCur+iActYSub]
	add  c
	ld   [tNewYPosSub], a
	ldh  a, [hActCur+iActY]
	adc  b
	ld   [tNewYPos], a
	
	; Standard off-screen below check (see also: ActS_MoveBySpeedY)
	and  $F0				; $A0-$AF
	cp   $A0
	jp   z, ActS_Despawn
	
	; The sensors are 1 pixel below the bottom border,
	; as the actor shouldn't sink inside the solid block.
	ld   a, [tNewYPos]
	inc  a
	ld   [wTargetRelY], a
	
.chkColi:
	;
	; Check for collision on the previouly set border.
	;
	; Uses three sensors along that border:
	; - Left corner
	; - Center
	; - Right corner
	;
	; If any of them points to a solid block, the actor won't move there.
	;

	;
	; CENTER
	;
	ldh  a, [hActCur+iActX]
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ret  nc
	
	;
	; LEFT CORNER
	;
	ld   a, [wTmpColiBoxH]
	ld   b, a
	ldh  a, [hActCur+iActX]
	sub  b
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ret  nc
	
	;
	; RIGHT CORNER
	;
	ld   a, [wTmpColiBoxH]
	ld   b, a
	ldh  a, [hActCur+iActX]
	add  b
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	ret  nc
	
	; Save back the changes if we passed the checks
	ld   a, [tNewYPosSub]
	ldh  [hActCur+iActYSub], a
	ld   a, [wTmpCF53]
	ldh  [hActCur+iActY], a
	ret
	
; =============== ActS_Unused_ApplyGravityY ===============
; [TCRF] Unreferenced code.
; Applies gravity, depending on the actor's current vertical direction.
ActS_Unused_ApplyGravityY: 
	; "Forward" has different meanings depending on the direction we're facing
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_D, a				; Facing down?
	jr   nz, ActS_ApplyGravityD	; If so, jump

; =============== ActS_ApplyGravityU ===============
; Moves the current actor upwards by the current vertical speed.
; Applies downwards gravity at 0.125px/frame.
;
; This and ActS_ApplyGravityD typically work in pairs to handle vertical movement during jump arcs:
; - ActS_ApplyGravityU handles the upwards movement, pre-peak
; - ActS_ApplyGravityD handles the downwards movement, post-peak
;
; This isn't exactly convenient, with many actors having to define separate pre-peak and post-peak
; routines when they want to move on a jump arc.
; Separate actor routines being used is why ActS_Unused_ApplyGravityY doesn't have a chance to get called.
;
; OUT
; - C flag: If set, the peak of the jump was reached.
;           The calling code waits for this before switching to another routine that handles the jump post-peak.
ActS_ApplyGravityU:

	; Decrease updwards speed at 0.125px/frame
	; BC = YSpeed - $00.20
	ldh  a, [hActCur+iActSpdYSub]
	sub  $20
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	sbc  $00
	ld   b, a
	
	; If we didn't underflow the speed, apply it
	jr   nc, .moveUp
	
.end:
	; Otherwise, flip the vertical direction.
	; There's the assumption here that, since we were moving up, ACTDIR_D should be clear.
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_D				; Set ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	; And clear out the speed
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	; C Flag = Clear (can't move)
	ret
	
.moveUp:
	; Update the speed value
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	
	; YPos -= SpeedY
	ldh  a, [hActCur+iActYSub]
	sub  c
	ldh  [hActCur+iActYSub], a
	ldh  a, [hActCur+iActY]
	sbc  b
	ldh  [hActCur+iActY], a
	
	; Standard off-screen above check (see also: ActS_MoveBySpeedY)
	and  $F0
	cp   $00
	jp   z, ActS_Despawn
	
	scf  ; C Flag = Set (can move)
	ret
	
; =============== ActS_ApplyGravityD ===============
; Moves the current actor *downwards* by the current vertical speed.
; Applies downwards gravity at 0.125px/frame.
ActS_ApplyGravityD:

	; Increase downwards speed at 0.125px/frame
	; BC = YSpeed + $00.20
	ldh  a, [hActCur+iActSpdYSub]
	add  $20
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	adc  $00
	ld   b, a
	
	; Cap the movement to 4px/frame
	cp   $04			; YSpeed < 4?
	jr   c, .moveDown	; If so, jump
	ld   bc, $0400		; Otherwise, cap
.moveDown:
	
	; Update the speed value
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	
	; YPos += SpeedY
	ldh  a, [hActCur+iActYSub]
	add  c
	ldh  [hActCur+iActYSub], a
	ldh  a, [hActCur+iActY]
	adc  b
	ldh  [hActCur+iActY], a
	
	; Standard off-screen below check (see also: ActS_MoveBySpeedY)
	and  $F0
	cp   $A0
	jp   z, ActS_Despawn
	scf  
	ret
	
; =============== ActS_Unused_ApplyGravityY_Coli ===============
; [TCRF] Unreferenced code.
; Variation of ActS_Unused_ApplyGravityY that checks for solid collision.
ActS_Unused_ApplyGravityY_Coli: 
	; "Forward" has different meanings depending on the direction we're facing
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_D, a					; Facing down?
	jp   nz, ActS_ApplyGravityD_Coli	; If so, jump

; =============== ActS_ApplyGravityU_Coli ===============
; Variation of ActS_ApplyGravityU that checks for solid collision.
; When a solid block is hit, its speed is reset, cutting off the jump arc early.
;
; OUT
; - C flag: If set, the actor could move.
ActS_ApplyGravityU_Coli:

	; Read out the actor's collision box size to a temp area
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   [wTmpColiBoxH], a
	ld   a, [hl]
	ld   [wTmpColiBoxV], a
	
	;--
	;
	; Update the gravity the same way ActS_ApplyGravityU does it
	;
	
	; Decrease updwards speed at 0.125px/frame
	; BC = YSpeed - $00.20
	ldh  a, [hActCur+iActSpdYSub]
	sub  $20
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	sbc  $00
	ld   b, a
	
	; If we didn't underflow the speed, apply it
	jr   c, .startFallAuto
	
	; Update the speed value
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	;--
	
	
	DEF tNewYPosSub = wTmpCF52
	DEF tNewYPos    = wTmpCF53
	
	;
	; Calculate the potential new Y position
	; NewYPos = YPos - BC
	;
	ldh  a, [hActCur+iActYSub]
	sub  c
	ld   [tNewYPosSub], a
	ldh  a, [hActCur+iActY]
	sbc  b
	ld   [tNewYPos], a
	
	;
	; Check for top collision.
	;
	; If, with the new position, the actor's top border would collide with a solid
	; block, do not move and stop the vertical movement.
	;
	; This goes off three sensors, all 1 pixel below the actor's top border:
	; - Top-left corner
	; - Top-center
	; - Top-right corner
	;
	; If any if these points to a solid block, no movement is made and the jump ends.
	;
	;
	
	;
	; Y COMPONENT
	; 
	; Since the origin is at the bottom edge of the sprite's collision box, but collision sizes are half-width:
	; wTargetRelY = tNewYPos - (wTmpColiBoxV * 2) + 1
	;
	ld   a, [wTmpColiBoxV]		; Get collision
	sla  a						; From radius to height
	dec  a						; 1 pixel below the edge, for some reason. 
								; This is inconsistent with similar collision checks like the one in ActS_MoveBySpeedYColi.
	ld   b, a
	ld   a, [tNewYPos]			; Get new Y pos
	sub  b						; Move up to 1px below the edge
	ld   [wTargetRelY], a		; That's the target
	
	;
	; X COMPONENT, CENTER
	;
	; The origin is already at the center of an actor, so:
	; wTargetRelX = iActX
	;
	ldh  a, [hActCur+iActX]		
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; Is it a solid block?
	jr   nc, .startFall			; If so, we're done
	
	;
	; X COMPONENT, LEFT
	; wTargetRelX = iActX - wTmpColiBoxH
	;
	ld   a, [wTmpColiBoxH]		; Get horz radius
	ld   b, a
	ldh  a, [hActCur+iActX]		; Get X position
	sub  b						; Subtract the radius
	ld   [wTargetRelX], a		; We have the left border
	call Lvl_GetBlockId
	jr   nc, .startFall
	
	;
	; X COMPONENT, RIGHT
	; wTargetRelX = iActX + wTmpColiBoxH
	;
	ld   a, [wTmpColiBoxH]		; Get horz radius
	ld   b, a
	ldh  a, [hActCur+iActX]		; Get X position
	add  b						; Add the radius
	ld   [wTargetRelX], a		; We have the left border
	call Lvl_GetBlockId
	jr   nc, .startFall
	
	;
	; SAVE CHANGES
	;
	
	; Save the updated Y coords back.
	ld   a, [tNewYPosSub]		; iActYSub = tNewYPosSub
	ldh  [hActCur+iActYSub], a
	ld   a, [tNewYPos]			; iActY = tNewYPos
	ldh  [hActCur+iActY], a
	
	; If the new position would cause the actor to move off-screen above, despawn it.
	and  $F0					; YPos >= $00 && YPos <= $0F?
	cp   $00
	jp   z, ActS_Despawn		; If so, delete it
	
	scf		; C Flag = Set (move ok)  
	ret
.startFallAuto:
	ccf		; We got here with "jr c", clear that
.startFall:
	; Zero out the vertical speed & subpixel value.
	; This makes falling down start with a consistent gravity value.
	push af ; Preserve cleared carry flag (does it matter?)
		xor  a
		ldh  [hActCur+iActYSub], a
		ldh  [hActCur+iActSpdYSub], a
		ldh  [hActCur+iActSpdY], a
	pop  af
	ret
	
; =============== ActS_ApplyGravityD_Coli ===============
; Variation of ActS_ApplyGravityD that checks for solid collision.
; The actor will move until it either gets offscreened, or hits solid ground.
;
; OUT
; - C flag: If set, a solid block was hit.
;           Not set when it gets offscreened, but it won't make it past the end of the frame anyway.
ActS_ApplyGravityD_Coli:

	; Read out the actor's horizontal collision box size to a temp area
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   [wTmpColiBoxH], a
	
	;--
	;
	; Update the gravity the same way ActS_ApplyGravityD does it
	;
	
	; Increase downwards speed at 0.125px/frame
	; BC = YSpeed + $00.20
	ldh  a, [hActCur+iActSpdYSub]
	add  $20
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	adc  $00
	ld   b, a
	
	; Cap the movement to 4px/frame
	cp   $04			; YSpeed < 4?
	jr   c, .moveDown	; If so, jump
	ld   bc, $0400		; Otherwise, cap
.moveDown:

	; Update the speed value
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	
	DEF tNewYPosSub = wTmpCF52
	DEF tNewYPos    = wTmpCF53
	
	;
	; Calculate the potential new Y position
	; NewYPos = YPos + BC
	;
	ldh  a, [hActCur+iActYSub]
	add  c
	ld   [tNewYPosSub], a
	ldh  a, [hActCur+iActY]
	adc  b
	ld   [tNewYPos], a
	
	;
	; Check for collision on the bottom border:
	;
	; This goes off three sensors, all 1 pixel below the actor's top border:
	; - Bottom-left corner
	; - Bottom-center
	; - Bottom-right corner
	;
	; If any if these points to a solid block, movement stops and the actor is aligned to the ground.
	;
	
	inc  a						; The Y position is 1 pixel below the origin.
	ld   [wTargetRelY], a
	
	;
	; CENTER
	;
	ldh  a, [hActCur+iActX]		; wTargetRelX = origin
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, .stopFall
	
	;
	; LEFT
	;
	ld   a, [wTmpColiBoxH]		; wTargetRelX = origin - h radius
	ld   b, a
	ldh  a, [hActCur+iActX]
	sub  b
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, .stopFall
	
	;
	; RIGHT
	;
	ld   a, [wTmpColiBoxH]		; wTargetRelX = origin + h radius
	ld   b, a
	ldh  a, [hActCur+iActX]
	add  b
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	jr   nc, .stopFall
	
	; Save the updated Y coords back.
	ld   a, [tNewYPosSub]
	ldh  [hActCur+iActYSub], a
	ld   a, [tNewYPos]
	ldh  [hActCur+iActY], a
	
	; If the new position would cause the actor to move off-screen below, despawn it.
	and  $F0					; YPos >= $A0 && YPos <= $AF?
	cp   $A0
	jp   z, ActS_Despawn		; If so, delete it
	ret
	
.stopFall:
	; Zero out the vertical speed & subpixel value.
	xor  a
	ldh  [hActCur+iActYSub], a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	; Snap actor to the top of the 16x16 solid block
	ldh  a, [hActCur+iActY]
	or   $0F
	ldh  [hActCur+iActY], a
	ret
	
; =============== ActS_MoveByScrollX ===============
; Moves the current actor based on how much the player has scrolled the screen.
ActS_MoveByScrollX:
	
	; This is important since actor coordinates are relative to the screen,
	; so if the player scrolls it, actor positions need to be adjusted.
	
	ld   a, [wActScrollX]	; B = 
	ld   b, a
	ldh  a, [hActCur+iActX]
	add  b
	ldh  [hActCur+iActX], a
	
	; Standard off-screen despawn check (see: ActS_MoveBySpeedX)
	and  $F0
	cp   $D0
	ret  nz
	
