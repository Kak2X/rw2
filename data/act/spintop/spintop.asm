; =============== Act_SpinTopU ===============
; ID: ACT_SPINTOPU
; Large spinning top platform that moves up.
; This uses its own collision type ACTCOLI_PLATFORM -> ACTCOLISUB_SPINTOP, to act
; as a top-solid platform that spins the player around.
Act_SpinTopU:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_SpinTopU_Init
	dw Act_SpinTopU_Move
	
; =============== Act_SpinTopU_Init ===============
Act_SpinTopU_Init:
	; Move 0.5px/frame up
	ld   bc, $0080
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_SpinTopU_Move ===============
Act_SpinTopU_Move:
	; Use frames $00-$03 at 1/2 speed
	ld   c, $04
	call ActS_Anim4
	
	; Move up
	call ActS_ApplySpeedFwdY
	
	; When it goes off-screen above, make it wrap around to the bottom.
	; This makes it relatively safe to idle on the platform (spinning aside).
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y			; ActY == $10?
	ret  nz						; If not, return
	ld   a, OBJ_OFFSET_Y+SCREEN_GAME_V+BLOCK_V-1
	ldh  [hActCur+iActY], a		; Otherwise, ActY = $9F
	ret
	
; =============== Act_SpinTopD ===============
; ID: ACT_SPINTOPD
; Large spinning top platform that moves down.
Act_SpinTopD:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_SpinTopD_Init
	dw Act_SpinTopD_Move
	
; =============== Act_SpinTopD_Init ===============
Act_SpinTopD_Init:
	; Move 0.5px/frame down
	ld   bc, $0080
	call ActS_SetSpeedY
	call ActS_FlipV ; Move down
	jp   ActS_IncRtnId
	
; =============== Act_SpinTopD_Move ===============
Act_SpinTopD_Move:
	; Use frames $00-$03 at 1/2 speed
	ld   c, $04
	call ActS_Anim4
	call ActS_ApplySpeedFwdY
	
	; When it goes off-screen below, make it wrap around to the top.
	; The positions used are identical to those in Act_SpinTopU_Move,
	; except the other way around, making sure the platforms won't desync
	; once they are spawned,
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y+SCREEN_GAME_V+BLOCK_V-1
	ret  nz
	ld   a, OBJ_OFFSET_Y
	ldh  [hActCur+iActY], a
	ret
	
