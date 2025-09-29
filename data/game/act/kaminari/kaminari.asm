; =============== Act_Kaminari ===============
; ID: ACT_KAMINARI
; Lightning bolt projectile thrown in an arc by Act_KaminariGoro.
Act_Kaminari:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Kaminari_Init
	dw Act_Kaminari_JumpU
	dw Act_Kaminari_JumpD

; =============== Act_Kaminari_Init ===============
; Sets up the jump arc.
Act_Kaminari_Init:
	
	; Immediately move 8px towards the player.
	; Typically this places it on Kaminari Goro's hand.
	call ActS_FacePl			; Move towards player
	ld   bc, $0800				; Move 8px forward
	call ActS_SetSpeedX
	call ActS_MoveBySpeedX	; And apply it
	
	; Set up jump arc
	ld   bc, $0100				; 1px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0200				; 2px/frame up
	call ActS_SetSpeedY
	
	jp   ActS_IncRtnId
	
; =============== Act_Kaminari_JumpU ===============
; Jump, pre-peak.
Act_Kaminari_JumpU:
	; Flash at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	; Continue the arc until we reach the peak of the jump
	call ActS_MoveBySpeedX
	call ActS_ApplyGravityU
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_Kaminari_JumpD ===============
; Jump, post-peak.
Act_Kaminari_JumpD:
	; Flash at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	
	; Continue the arc until we get offscreened
	call ActS_MoveBySpeedX
	call ActS_ApplyGravityD
	ret
	
