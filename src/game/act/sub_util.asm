; =============== ActS_CountById ===============
; Counts:
; - The active slots with the specified actor ID
; - Number of active slots
; Used to limit how many actors a parent can spawn.
;
; IN
; - A: Actor ID to match
; OUT
; - B: Actor count (with specified ID)
; - C: Actor count (total)
ActS_CountById:
	or   ACTF_PROC		; E = iActId to find
	ld   e, a			; (with the processing flag since all active slots have it)
	
	ld   bc, $0000		; Init counters
	ld   hl, wAct		; Start from first slot
.loop:
	ld   a, [hl]		; A = iActId
	or   a				; Is the slot empty?
	jr   z, .nextSlot	; If so, skip
	inc  c				; TotalCount++
	cp   e				; Does its ID match?
	jr   nz, .nextSlot	; If not, skip
	inc  b				; MatchCount++
.nextSlot:
	ld   a, l			; Seek to next slot
	add  iActEnd
	ld   l, a			; Overflowed back to the first one? 
	jr   nc, .loop		; If not, loop
	ret
	
; =============== ActS_SyncDirToSpawn ===============
; Makes the newly spawned actor face the same horizontal direction as its spawner.
; Can be used after an actor spawns another actor.
; IN
; - HL: Ptr to newly spawned actor slot
ActS_SyncDirToSpawn:
	inc  l ; iActRtnId
	inc  l ; iActSprMap
	ldh  a, [hActCur+iActSprMap]	; Get parent flags
	and  ACTDIR_R					; Filter direction
	ld   [hl], a					; Save to child iActSprMap
	ret
; =============== ActS_SyncRevDirToSpawn ===============
; Makes the newly spawned actor face the opposite horizontal direction as its spawner.
; Can be used after an actor spawns another actor.
; IN
; - HL: Ptr to newly spawned actor slot
ActS_SyncRevDirToSpawn:
	inc  l ; iActRtnId
	inc  l ; iActSprMap
	ldh  a, [hActCur+iActSprMap]	; Get parent flags
	and  ACTDIR_R					; Filter direction
	xor  ACTDIR_R					; Flip
	ld   [hl], a					; Save to child iActSprMap
	ret
; =============== ActS_SetSpeedX ===============
; Sets the current actor's horizontal speed.
; IN
; - BC: Speed (pixels + subpixels)
ActS_SetSpeedX:
	ld   a, c
	ldh  [hActCur+iActSpdXSub], a
	ld   a, b
	ldh  [hActCur+iActSpdX], a
	ret
; =============== ActS_SetSpeedY ===============
; Sets the current actor's vertical speed.
; IN
; - BC: Speed (pixels + subpixels)
ActS_SetSpeedY:
	ld   a, c
	ldh  [hActCur+iActSpdYSub], a
	ld   a, b
	ldh  [hActCur+iActSpdY], a
	ret
; =============== ActS_FlipH ===============
; Flips the current actor's horizontal direction.
ActS_FlipH:
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	ret
; =============== ActS_FlipV ===============
; Flips the current actor's vertical direction.
ActS_FlipV:
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ret
; =============== ActS_ClrSprMapId ===============
; Resets the current actor's relative sprite mapping to return to the first frame.
ActS_ClrSprMapId:
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R|ACTDIR_D	; Keep direction flags only
	ldh  [hActCur+iActSprMap], a
	ret
; =============== ActS_IncRtnId ===============
; Increments the current actor's routine ID.
ActS_IncRtnId:
	ld   hl, hActCur+iActRtnId
	inc  [hl]
	ret
; =============== ActS_DecRtnId ===============
; Decrements the current actor's routine ID.
ActS_DecRtnId:
	ld   hl, hActCur+iActRtnId
	dec  [hl]
	ret
; =============== ActS_GetPlDistanceX ===============
; Gets the horizontal distance between the current actor and the player.
; OUT
; - A: Horizontal distance (always positive)
; - C Flag: If set, the player is to the right of the actor.
ActS_GetPlDistanceX:
	ld   a, [wPlRelX]		; B = wPlRelX
	ld   b, a
	ldh  a, [hActCur+iActX]	; A = iActX
	sub  b					; A = iActX - wPlRelX
	jr   nc, .ret			; Did we underflow? (Player is to the right) If not, return
	xor  $FF				; Otherwise, flip the result's sign
	inc  a
	scf  					; and set the C flag since that xor cleared it
.ret:
	ret
; =============== ActS_GetPlDistanceY ===============
; Gets the vertical distance between the current actor and the player.
; OUT
; - A: Vertical distance (always positive)
; - C Flag: If set, the player is below the actor.
ActS_GetPlDistanceY:
	; See above, but for Y positions
	ld   a, [wPlRelY]
	ld   b, a
	ldh  a, [hActCur+iActY]
	sub  b
	jr   nc, .ret
	xor  $FF
	inc  a
	scf  
.ret:
	ret
	
; =============== ActS_FacePl ===============
; Makes the current actor face towards the player.
ActS_FacePl:
	
	; If the player is within $30px behind the left edge of the screen,
	; force it to face right, potentially preventing a despawn.
	; $D0-$DF is the offscreen range, so there's no inconsistency when
	; the actor is after the right edge of the screen.
	ldh  a, [hActCur+iActX]
	cp   -$30						; iActX < $D0?
	jr   c, .calcDir				; If so, jump
	
	ldh  a, [hActCur+iActSprMap]	; Otherwise, force right direcion
	set  ACTDIRB_R, a
	ldh  [hActCur+iActSprMap], a
	ret
	
.calcDir:
	;
	; Set the direction flag depending on the player being to the left or the right of the actor.
	;
	
	ld   a, [wPlRelX]				; B = wPlRelX
	ld   b, a
	ldh  a, [hActCur+iActX]			; A = iActX

	; Calculate the result flags of iActX < wPlRelX (player on the right of the actor?)
	; If it is, the C flag will be set, so we can push it out to the MSB
	; to turn it into the appropriate ACTDIR_* value.
	cp   b							; iActX < wPlRelX? if so, C flag = set
	rra  							; Shift C flag to MSB
	and  ACTDIR_R					; Filter other bits out		
	ld   b, a						; Set to B
	
	ldh  a, [hActCur+iActSprMap]
	res  ACTDIRB_R, a				; Clear old flag
	or   b							; Replace it with new value
	ldh  [hActCur+iActSprMap], a	; Save back
	ret
	
; =============== ActS_Unused_FacePlY ===============
; [TCRF] Unreferenced code.
; Makes the current actor face towards the player in the vertical direction.
ActS_Unused_FacePlY:
	;
	; Set the direction flag depending on the player being above or below the actor.
	;
	
	ld   a, [wPlRelY]				; B = wPlRelY
	ld   b, a
	ldh  a, [hActCur+iActY]			; A = iActY

	; Calculate the result flags of iActY < wPlRelY (player below of the actor?)
	; If it is, the C flag will be set, so we can push it out to the MSB
	; to turn it into the appropriate ACTDIR_* value.
	cp   b							; iActX < wPlRelX? if so, C flag = set
	rra  							; Shift C flag to MSB
	and  ACTDIR_D<<1				; Filter other bits out (offset by 1)
	srl  a							; >> 1 to compensate
	ld   b, a						; Set to B
	
	ldh  a, [hActCur+iActSprMap]
	res  ACTDIRB_D, a				; Clear old flag
	or   b							; Replace it with new value
	ldh  [hActCur+iActSprMap], a	; Save back
	ret

; =============== ActS_SetColiBox ===============
; Sets the current actor's collision box size.
; IN
; - B: Horizontal radius
; - C: Vertical radius
ActS_SetColiBox:
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ld   [hl], b ; iActColiBoxH
	inc  hl
	ld   [hl], c ; iActColiBoxV
	ret
	
; =============== ActS_SetColiType ===============
; Sets the current actor's collision type.
; IN
; - B: Collision type (ACTCOLI_*)
ActS_SetColiType:
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	add  iActColiType
	ld   l, a
	ld   [hl], b
	ret
	
; =============== ActS_SetHealth ===============
; Sets the current actor's health.
; IN
; - B: Health amount
ActS_SetHealth:
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	add  iActColiHealth
	ld   l, a
	ld   [hl], b
	ret
	
; =============== ActS_GetHealth ===============
; Gets the current actor's health.
; OUT
; - A: Health amount
ActS_GetHealth:
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	add  iActColiHealth
	ld   l, a
	ld   a, [hl]
	ret
	
