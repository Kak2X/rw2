; =============== Act_TopManShot ===============
; ID: ACT_SPINTOPSHOT
; Spinning top shot which moves into place, then targets the player. Spawned by Top Man.
Act_TopManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_TopManShot_Init
	dw Act_TopManShot_MoveU
	dw Act_TopManShot_Wait
	dw Act_TopManShot_MoveToPl

; =============== Act_TopManShot_Init ===============
Act_TopManShot_Init:
	; Animate spinning top.
	; Use sprites $00-$01 at 3/8 speed
	ld   c, $03
	call ActS_Anim2
	
	; Move diagonally up for ~1 second.
	ld   a, $30
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_TopManShot_MoveU ===============
; Moves the spinning top into position.
Act_TopManShot_MoveU:
	; Animate spinning top.
	ld   c, $03
	call ActS_Anim2
	
	; Move for that ~1 second.
	; The initial speed values come from Act_TopMan_SpawnShots.
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Wait half a second idling
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_TopManShot_Wait ===============
; Waits for a bit.
Act_TopManShot_Wait:
	; Animate spinning top
	ld   c, $03
	call ActS_Anim2
	
	; Wait for that half a second...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Take a snapshot of the player position
	call ActS_AngleToPl
	call ActS_DoubleSpd		; And move at double speed there
	jp   ActS_IncRtnId
	
; =============== Act_TopManShot_MoveToPl ===============
; Moves towards the player.
Act_TopManShot_MoveToPl:
	; Animate spinning top.
	ld   c, $03
	call ActS_Anim2
	
	; Move towards that player position, until we get offscreened
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
