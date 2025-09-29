; =============== Act_RobbitCarrot ===============
; ID: ACT_CARROT
; Carrot thrown by Act_Robbit, moves in a line.
Act_RobbitCarrot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_RobbitCarrot_Init
	dw Act_RobbitCarrot_Move

; =============== Act_RobbitCarrot_Init ===============
Act_RobbitCarrot_Init:
	; Set up the carrot's speed to target the player's current position.
	call ActS_AngleToPl
	jp   ActS_IncRtnId
	
; =============== Act_RobbitCarrot_Move ===============
Act_RobbitCarrot_Move:
	; Keep targeting that old player position.
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	ret
	
