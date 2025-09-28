; =============== Act_Yambow ===============
; ID: ACT_YAMBOW
; Mosquito enemy, travels in a rectangular path around the player before charging in.
Act_Yambow:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Yambow_InitSpd
	dw Act_Yambow_PlFar
	dw Act_Yambow_MoveOppH0
	dw Act_Yambow_MoveOppH1
	dw Act_Yambow_WaitMoveD
	dw Act_Yambow_MoveD
	dw Act_Yambow_WaitCharge
	dw Act_Yambow_Charge

; =============== Act_Yambow_InitSpd ===============
Act_Yambow_InitSpd:
	; Set base movement speed, which won't be altered again.
	; (but specific routines will avoid moving the player with it)
	ld   bc, $0200		; 2px/frame horizontally
	call ActS_SetSpeedX
	ld   bc, $0280		; 2.5px/frame vertically
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_PlFar ===============
; Waits for the player to get close.
Act_Yambow_PlFar:
	; Unlike the NES game, this enemy is neither invisibile nor intangible
	; while the player is outside its trigger range.
	
	; Use frames $00-$01, at speed 1/4
	; This is used all the time by this actor.
	ld   c, $02
	call ActS_Anim2
	
	; Face the player while waiting
	call ActS_FacePl
	
	; Trigger when the player gets within 3 blocks
	call ActS_GetPlDistanceX
	cp   BLOCK_H*3
	ret  nc
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_MoveOppH0 ===============
; First part of moving to the other side of the screen.
; Moves the actor forward until it's on the same column as the player.
; This is split in two because the checks go off the player distance, an absolute value.
Act_Yambow_MoveOppH0:
	ld   c, $02
	call ActS_Anim2
	
	; Move forward at 2px/frame
	call ActS_ApplySpeedFwdX
	
	; Wait until the enemy moves above the player (within 16 pixels from the player)
	call ActS_GetPlDistanceX	; Get horz distance
	and  $F0					; Check block ranges
	or   a						; DiffX != $0x?
	ret  nz						; If so, return
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_MoveOppH1 ===============
; Second part of moving to the other side of the screen.
; Moves the actor away from the player, still moving forward.
Act_Yambow_MoveOppH1:
	ld   c, $02
	call ActS_Anim2
	
	; Move forward at 2px/frame
	call ActS_ApplySpeedFwdX
	
	; Wait until the enemy moves 3 blocks away from the player (on the other side it moved from)
	call ActS_GetPlDistanceX
	cp   BLOCK_H*3
	ret  c
	
	; Wait for half a second after moving
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_WaitMoveD ===============
; Waits before moving down and sets up downwards movement.
Act_Yambow_WaitMoveD:
	ld   c, $02
	call ActS_Anim2
	
	; Wait that half a second
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Hopefully face the player by doing this
	call ActS_FlipH
	
	; Make the enemy move down
	ldh  a, [hActCur+iActSprMap]
	or   ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_MoveD ===============
; Moves the actor down, until it's within 16px vertically from the player.
Act_Yambow_MoveD:
	ld   c, $02
	call ActS_Anim2
	
	; Move down at 2.5px/frame
	call ActS_ApplySpeedFwdY
	
	; Wait until the enemy moves within 16 pixels from the player
	call ActS_GetPlDistanceY	; Get vert distance
	and  $F0					; A /= $10
	swap a
	or   a						; DiffBlkY != 0?
	ret  nz						; If so, return
	
	; Wait half a second before charging
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_WaitCharge ===============
Act_Yambow_WaitCharge:
	ld   c, $02
	call ActS_Anim2
	
	; Wait that half a second
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	jp   ActS_IncRtnId
	
; =============== Act_Yambow_Charge ===============
Act_Yambow_Charge:
	ld   c, $02
	call ActS_Anim2
	; Charge forward at 2px/frame
	call ActS_ApplySpeedFwdX
	ret

