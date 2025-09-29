; =============== Act_ScwormBase ===============
; ID: ACT_SCWORMBASE
; Small chute on the ground, lobs shots at the player.
Act_ScwormBase:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_ScwormBase_Init
	dw Act_ScwormBase_Shot
	
; =============== Act_ScwormBase_Init ===============
Act_ScwormBase_Init:
	; ~1 second cooldown between shots
	ld   a, $30
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_ScwormBase_Shot ===============
Act_ScwormBase_Shot:
	; Handle the cooldown
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	ld   a, $30						; Reset cooldown timer for next time
	ldh  [hActCur+iActTimer], a
	
	call ActS_GetPlDistanceX
	cp   BLOCK_H*4					; Is the player within 4 blocks?
	ret  nc							; If not, return
	
	ld   a, ACT_SCWORMSHOT
	ld   bc, ($00 << 8)|LOW(-$08) 	; Spawn shot 8px up
	call ActS_SpawnRel
	ret
	
