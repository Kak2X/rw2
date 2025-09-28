; =============== Act_Wanaan ===============
; ID: ACT_WANAAN
; Retractable trap that activates when the player gets close.
Act_Wanaan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wanaan_Init
	dw Act_Wanaan_ChkDistance
	dw Act_Wanaan_Wait
	dw Act_Wanaan_MoveU
	dw Act_Wanaan_MoveD
	
	DEF ACTRTN_WANAAN_CHKDISTANCE = $01

; =============== Act_Wanaan_Init ===============
Act_Wanaan_Init:
	; Make intangible while retracted
	ld   b, ACTCOLI_PASS
	call ActS_SetColiType
	
	; The center of the pipe is 8px to the right
	ldh  a, [hActCur+iActX]
	add  $08
	ldh  [hActCur+iActX], a
	
	; Rise and retract at 2px/frame
	ld   bc, $0200
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Wanaan_ChkDistance ===============
Act_Wanaan_ChkDistance:
	; Do not activate if the player is below
	ld   a, [wPlRelY]		; B = PlY
	ld   b, a
	ldh  a, [hActCur+iActY]	; A = ActY
	sub  b					; ActY - PlY < 0? (ActY < PlY)
	ret  c					; If so, return
	
	; Wait for the player to get within 20px horizontally before activating
	call ActS_GetPlDistanceX
	cp   $14
	ret  nc
	
	; Delay activation by $1E frames
	ld   a, $1E
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wanaan_Wait ===============
Act_Wanaan_Wait:
	; Wait for it...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Show sprite
	ld   a, $01
	call ActS_SetSprMapId
	; Make tangible and invulnerable
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	; Move up for 16 frames
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wanaan_MoveU ===============
Act_Wanaan_MoveU:
	; Move up for 16 frames at 2px/frame (2 blocks up)
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Close grip
	ld   a, $02
	call ActS_SetSprMapId
	
	; Start retracting to the ground
	call ActS_FlipV
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wanaan_MoveD ===============
Act_Wanaan_MoveD:
	; Move down for 16 frames at 2px/frame (2 blocks up)
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; We're back inside the pipe
	
	; Hide sprite (its first is blank)
	ld   a, $00
	call ActS_SetSprMapId
	; Make intangible while retracted
	ld   b, ACTCOLI_PASS
	call ActS_SetColiType
	; Set direction for rising up
	call ActS_FlipV
	ld   a, ACTRTN_WANAAN_CHKDISTANCE
	ldh  [hActCur+iActRtnId], a
	ret
	
