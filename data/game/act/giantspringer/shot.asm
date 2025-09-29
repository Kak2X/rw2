; =============== Act_GiantSpringerShot ===============
; ID: ACT_GSPRINGERSHOT
; Homing missile fired by Giant Springers.
Act_GiantSpringerShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_GiantSpringerShot_InitMoveU
	dw Act_GiantSpringerShot_MoveU
	dw Act_GiantSpringerShot_Arc
	dw Act_GiantSpringerShot_MoveLine

; =============== Act_GiantSpringerShot_InitMoveU ===============
; After the missile spawns, it rises straight up a a few frames.
Act_GiantSpringerShot_InitMoveU:
	; For 15 frames...
	ld   a, $0F
	ldh  [hActCur+iActTimer], a
	; Move up at 1px/frame
	ld   bc, $0100
	call ActS_SetSpeedY
	; Use vertical missile sprite
	ld   a, $02
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_GiantSpringerShot_MoveU ===============
; Moves the missile up, then sets up the arc.
Act_GiantSpringerShot_MoveU:
	; Handle the upwards movement set up before
	call ActS_MoveBySpeedY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
		
	;--
	; Not necessary, done below
	ld   a, $00
	ldh  [hActCur+iActTimer], a
	;--
	
	;
	; After that is done, prepare the settings for the circular path.
	; This does not go through ActS_InitCirclePath since that one makes it start moving horizontally (start from top to l/r),
	; while we, due to having just finished moving straight up, want to start it moving vertically (start from l/r to top)
	; so that horizontal movement will be gradual.
	;

	
	
	; PATH DIRECTION
	; The missile always moves away from the player on its first rotation.
	
	;##
	; This is identical to ActS_GetPlDistanceX, except with wPlRelX and iActX swapped.
	; The distance is not used directly, there's a bit more code than needed.
	ldh  a, [hActCur+iActX]	; B = iActX
	ld   b, a
	ld   a, [wPlRelX]		; A = wPlRelX
	sub  b					; wPlRelX >= iActX?
	jr   nc, .setArc		; If so, jump (player on the right, carry clear)
	;--
	; This bit is unnecessary, all we care for is the carry flag, which is alredy set when going here.
	xor  $FF				; Otherwise, flip the result's sign
	inc  a
	scf  					; and set the C flag since that xor cleared it
	;--
	;##
.setArc:
	; Using the carry as direction means that:
	; - If the player is on the left, the carry will be set, making the missile move right
	; - If the player is on the right, the carry will be clear, making the missile move left
	rra  					; Shift carry into place
	and  ACTDIR_R			; Use that as direction.
	ldh  [hActCur+iActSprMap], a
	
	ld   a, ADR_DEC_IDX|ADR_INC_IDY	; Set index directions
	ldh  [hActCur+iArcIdDir], a
	ld   a, ARC_MAX					; Move slow horz
	ldh  [hActCur+iArcIdX], a
	xor  a							; Move fast vert
	ldh  [hActCur+iArcIdY], a
	
	ldh  [hActCur+iActTimer], a
	; Use horizontal missile sprite
	ld   a, $00
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_GiantSpringerShot_Arc ===============
; Moves the missile in a circular path, until the player gets close.
Act_GiantSpringerShot_Arc:
	;--
	; [POI] There's nothing using the timer here, including ActS_ApplyCirclePath.
	ldh  a, [hActCur+iActTimer]	; Timer++
	add  $01
	ldh  [hActCur+iActTimer], a
	cp   $B0						; Timer < $B0?
	jp   c, doArc					; If so, skip
	ld   a, $00						; Timer = 0
	ldh  [hActCur+iActTimer], a
	;--
doArc:
	; Move missile around a small arc
	ld   a, ARC_SM
	call ActS_ApplyCirclePath
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	
	;
	; Determine when to stop the circular movement and start moving directly towards the player.
	; It needs to pass a gauntlet of checks first.
	;
	
	; The missile is shound not be near the top or bottom of the circle (X speed at its max value)
	; as at that time it's traveling nearly horizontally
	ldh  a, [hActCur+iActSpdXSub]
	cp   $FF
	ret  nz
	
	; Player should not be too close horizontally (< $30px) ...
	call ActS_GetPlDistanceX
	cp   $30
	ret  c
	
	; But also not too far vertically (>= $40)
	;--
	; ActS_GetPlDistanceY, but relative to the player's vertical center. 
	ld   a, [wPlRelY]		; B = PlY - $0C (center)
	sub  PLCOLI_V
	ld   b, a
	ldh  a, [hActCur+iActY]	; A = ActY (bottom)
	sub  b					; Do the distance calc
	jr   nc, .chkDiffY
	xor  $FF				; Force absolute
	inc  a
	scf  
	;--
.chkDiffY:
	cp   $40				; DiffY >= $40?
	ret  nc					; If so, return
	
	; The missile must travel towards the same direction as the player.
	; Otherwise it could do a instant 180°, which would break the illusion of momentum.
	ld   a, [wPlRelX]			; B = PlX
	ld   b, a
	ldh  a, [hActCur+iActX]		; A = ActX
	cp   b						; ActX < PlX?
	jr   c, .plR				; If so, jump (player is on the right)
	
.plL:
	; Player is on the left, so the missile should be also facing left
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a			; Is the missile facing right?
	ret  nz						; If so, return
	call ActS_AngleToPl			; Get the speed values to target the player
	jp   ActS_IncRtnId			; Start moving in a straight line with those values
	
.plR:
	; Player is on the right, so the missile should be also facing right
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a			; Is the missile facing right?
	ret  z						; If not, return
	call ActS_AngleToPl
	jp   ActS_IncRtnId
	
; =============== Act_GiantSpringerShot_MoveLine ===============
; Moves the missile along a straight line.
; It targets a snapshot of the player's old position at the time of the check.
Act_GiantSpringerShot_MoveLine:
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	ret
	
