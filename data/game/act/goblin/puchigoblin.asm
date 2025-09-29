; =============== Act_PuchiGoblin ===============
; ID: ACT_PUCHIGOBLIN
; Petit Goblin, the small flying enemies that spawn from the goblin head.
; Spawned by Act_Goblin.
Act_PuchiGoblin:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_PuchiGoblin_Init
	dw Act_PuchiGoblin_MoveOutH
	dw Act_PuchiGoblin_MoveU
	dw Act_PuchiGoblin_TrackPl

; =============== Act_PuchiGoblin_Init ===============
Act_PuchiGoblin_Init:
	; Instantly move a block away.
	; Why this wasn't done by the spawner directly?
	ld   bc, $1000
	call ActS_SetSpeedX
	call ActS_MoveBySpeedX
	
	; Move out 0.25px/frame from the side of the Goblin
	ld   bc, $0040
	call ActS_SetSpeedX
	
	; Do that for $40 frames; by the end it will have moved another block
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_PuchiGoblin_MoveOutH ===============
Act_PuchiGoblin_MoveOutH:
	; Use frames $00-$01 for animating the flight
	ld   c, $01
	call ActS_Anim2
	
	; Move forward for those $40 frames
	call ActS_MoveBySpeedX
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Start moving 1.25px/frame up for 32 frames (40px)
	ld   bc, $0140
	call ActS_SetSpeedY
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_PuchiGoblin_MoveU ===============
Act_PuchiGoblin_MoveU:
	ld   c, $01
	call ActS_Anim2
	
	; Move up for those 32 frames
	call ActS_MoveBySpeedY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; From this point, track the player's position every 16 frames
	call ActS_AngleToPl
	call ActS_HalfSpdSub	; Move at 1/4th of the speed
	call ActS_HalfSpdSub
	
	ld   a, $10				; Next tracking in
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_PuchiGoblin_TrackPl ===============
Act_PuchiGoblin_TrackPl:
	ld   c, $01
	call ActS_Anim2
	
	; Move towards the snapshop of the player position
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	
	; Wait those 16 frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Take a new snapshot
	call ActS_AngleToPl
	call ActS_HalfSpdSub
	call ActS_HalfSpdSub
	; Take the next one after 16 frames
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	ret
	
