; =============== Act_Wily1Nail ===============
; ID: ACT_WILY1NAIL
; Toenail fired forward, with a very misleading hitbox.
Act_Wily1Nail:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily1Nail_Init
	dw Act_Wily1Nail_Move

; =============== Act_Wily1Nail_Init ===============
; Set up horizontal movement towards the player at 2px/frame.
Act_Wily1Nail_Init:
	call ActS_FacePl
	ld   bc, $0200
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
; =============== Act_Wily1Nail_Move ===============
; Move forward until it gets offscreened.
Act_Wily1Nail_Move:
	call ActS_ApplySpeedFwdX
	ret
	
