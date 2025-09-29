; =============== Act_HardKnuckle ===============
; ID: ACT_HARDKNUCKLE
; Boss version of Hard Knuckle, a fist that homes in twice.
Act_HardKnuckle:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_HardKnuckle_SetMove0
	dw Act_HardKnuckle_Move0
	dw Act_HardKnuckle_SetMove1
	dw Act_HardKnuckle_WaitMove1
	dw Act_HardKnuckle_Move1

; =============== Act_HardKnuckle_SetMove0 ===============
; Set up 1st movement.
Act_HardKnuckle_SetMove0:
	; Take a snapshot of the player's current position, and use it as target
	ld   a, [wPlRelX]
	ld   [wHardFistTargetX], a
	ld   a, [wPlRelY]
	ld   [wHardFistTargetY], a
	; Set up speed values that also home in to that snapshot
	call ActS_AngleToPl
	call ActS_DoubleSpd
	jp   ActS_IncRtnId
	
; =============== Act_HardKnuckle_Move0 ===============
; 1st movement.
Act_HardKnuckle_Move0:
	; Move at the previously set speed
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	
	;
	; Keep moving until we reach around the target position.
	;
	
	; If the we aren't within 16px from the horizontal target, wait.
	ld   a, [wHardFistTargetX]	; B = X Target
	ld   b, a
	ldh  a, [hActCur+iActX]		; A = X Pos
	sub  b						; Get distance
	jr   nc, .chkX				; Underflowed? If not, skip
	xor  $FF					; Otherwise, make absolute
	inc  a
	scf  
.chkX:
	and  $F0					; Diff != $0x?
	ret  nz						; If so, return
	
	; If the we aren't within 16px from the vertical target, wait.
	ld   a, [wHardFistTargetY]
	ld   b, a
	ldh  a, [hActCur+iActY]
	sub  b
	jr   nc, .chkY
	xor  $FF
	inc  a
	scf  
.chkY:
	and  $F0
	ret  nz
	
	; Then, keep moving for 24 frames at the same speed, going a bit over the target
	ld   a, $18
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_HardKnuckle_SetMove1 ===============
; After 1st movement.
Act_HardKnuckle_SetMove1:
	; Keep moving for those 24 frames...
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Then take a new snapshot of the player location
	call ActS_AngleToPl
	call ActS_DoubleSpd
	
	; Stop for 6 frames
	ld   a, $06
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_HardKnuckle_WaitMove1 ===============
; Waits for those 6 frames before moving.
Act_HardKnuckle_WaitMove1:
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	jp   ActS_IncRtnId
	
; =============== Act_HardKnuckle_Move1 ===============
; Moves at the previously set speed, crossing over the target.
Act_HardKnuckle_Move1:
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	ret
	
