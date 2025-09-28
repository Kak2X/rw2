; =============== Act_AirManShot ===============
; ID: ACT_WHIRLWIND
; Whirlwind shot spawned by Air Man, part of a wave.
Act_AirManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_AirManShot_InitMoveToPos
	dw Act_AirManShot_MoveToPos
	dw Act_AirManShot_Wait
	dw Act_AirManShot_MoveFwd

; =============== Act_AirManShot_InitMoveToPos ===============
Act_AirManShot_InitMoveToPos:
	;
	; This whirlwind is currently directly overlapping Air Man.
	; It needs to move in a line into the position defined for the wave pattern.
	;
	; We don't have actual target coordinates though, what we do have is its speed values
	; used when moving into position. The whirlwind will be moved by that for ~1 second.
	; Read out those speed values from the table entry, indexed by path ID.
	;
	ldh  a, [hActCur+iAirManShotPathId]
	ld   l, a			; HL = PathId
	ld   h, $00
	add  hl, hl			; *2
	add  hl, hl			; *4 (Each entry is a pair of words)
	ld   de, Act_AirManShot_PathTbl
	add  hl, de			; Seek to entry
	ldi  a, [hl]		; Read the four bytes out
	ldh  [hActCur+iActSpdXSub], a
	ldi  a, [hl]
	ldh  [hActCur+iActSpdX], a
	ldi  a, [hl]
	ldh  [hActCur+iActSpdYSub], a
	ld   a, [hl]
	ldh  [hActCur+iActSpdY], a
	
	; Move for ~1 second
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_AirManShot_MoveToPos ===============
; Moves the whirlwind into position.
Act_AirManShot_MoveToPos:
	; Animate the whirlwind
	ld   bc, $0301			; Use frames $00-$02 at 1/4 speed
	call ActS_AnimCustom
	
	; Move diagonally forwards for $40 frames
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Wait ~1 second
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_AirManShot_Wait ===============
; Gives some time for the player to assess the pattern.
Act_AirManShot_Wait:
	; Animate the whirlwind
	ld   bc, $0301
	call ActS_AnimCustom
	
	; Wait for that ~1 second...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Start moving the whirlwind straight forward, at 1px/frame
	ld   bc, $0100			; 1px/frame horz
	call ActS_SetSpeedX
	ld   bc, $0000			; No vertical movement
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_AirManShot_MoveFwd ===============
; Moves the whirlwind straight forward.
; As this happens to all whirlwinds at once, the entire pattern gets moved forward.
Act_AirManShot_MoveFwd:
	; [BUG] We're forgetting to animate the whirlwind.
	; [POI] Ideally at this point we should tell Air Man to start blowing the player forward
	;       but that happens as soon as the whirlwinds spawn...
	
	; Move forward until it gets offscreened.
	; Air Main is waiting for that to happen before jumping forward.
	call ActS_ApplySpeedFwdX
	ret
	
