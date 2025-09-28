; =============== Act_Springer ===============
; ID: ACT_SPRINGER
; Springy enemy that travels on the ground, speeding up when the player is at its vertical position.
Act_Springer:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Springer_Init
	dw Act_Springer_MoveSlow
	dw Act_Springer_TurnSlow
	dw Act_Springer_MoveFast
	dw Act_Springer_TurnFast
	dw Act_Springer_InitSpring
	dw Act_Springer_Spring
	DEF ACTRTN_SPRINGER_MOVESLOW = $01
	DEF ACTRTN_SPRINGER_MOVEFAST = $03
	DEF ACTRTN_SPRINGER_INITSPRING = $05

; =============== Act_Springer_Init ===============
Act_Springer_Init:
	ld   a, $00
	call ActS_SetSprMapId
	
	; Always start moving to the left at 0.25px/frame
	ldh  a, [hActCur+iActSprMap]
	and  $FF^ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	ld   bc, $0040
	call ActS_SetSpeedX
	
	jp   ActS_IncRtnId
	
; =============== Act_Springer_MoveSlow ===============
; Horizontal movement, slow speed.
Act_Springer_MoveSlow:
	; When the player gets close, spring out
	call Act_Springer_IsPlNear
	jp   c, Act_Springer_SwitchToSpring
	
	; Move forward, turning when a solid block is ahead
	call ActS_ApplySpeedFwdXColi
	jp   nc, ActS_IncRtnId
	; Also turn if there's no ground ahead
	call ActS_GetBlockIdFwdGround
	jp   c, ActS_IncRtnId
	
	; If the player is at the same vertical position than us, switch to moving fast
	call ActS_GetPlDistanceY
	and  a						; DistanceY != 0?
	ret  nz						; If so, return
	ld   bc, $0200				; Otherwise, move fast at 2px/frame
	call ActS_SetSpeedX
	ld   a, ACTRTN_SPRINGER_MOVEFAST
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Springer_TurnSlow ===============
Act_Springer_TurnSlow:
	; Turn horizontally
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	; Loop back to Act_Springer_MoveSlow
	jp   ActS_DecRtnId
	
; =============== Act_Springer_MoveFast ===============
; Horizontal movement, fast speed.
; This is identical to Act_Springer_MoveSlow, minus the check at the end.
Act_Springer_MoveFast:
	; When the player gets close, spring out
	call Act_Springer_IsPlNear
	jp   c, Act_Springer_SwitchToSpring
	
	; Move forward, turning when a solid block is ahead
	call ActS_ApplySpeedFwdXColi
	jp   nc, ActS_IncRtnId
	; Also turn if there's no ground ahead
	call ActS_GetBlockIdFwdGround
	jp   c, ActS_IncRtnId
	
	; If the player is no longer at the same vertical position than us, switch to moving slow
	call ActS_GetPlDistanceY
	and  a						; DistanceY == 0?
	ret  z						; If so, return
	ld   bc, $0040				; Otherwise, move slow at 0.25px/frame
	call ActS_SetSpeedX
	ld   a, ACTRTN_SPRINGER_MOVESLOW
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Springer_TurnFast ===============
; Identical to Act_Springer_TurnSlow.
Act_Springer_TurnFast:
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	jp   ActS_DecRtnId
	
; =============== Act_Springer_InitSpring ===============
; Sets up the spring out effect, shown when the player gets close.
Act_Springer_InitSpring:
	; Spring out for 32 * 8 frames in total
	ld   a, $20	; 32 frames of animation (looped from the 4th)
	ldh  [hActCur+iSpringerAnimTimer], a
	ld   a, $08	; Each sprite shown for 8 frames
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Springer_Spring ===============
Act_Springer_Spring:

	; Do the animation cycle for the jack-o-box spring effect.
	; Even though it may not look like, the actor's collision box stays the same.
	
	; Uses frames $01-$04...
	ldh  a, [hActCur+iSpringerAnimTimer]
	and  $03
	inc  a
	ld   [wActCurSprMapBaseId], a
	
	; ...at 1/8 speed
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	ld   a, $08	
	ldh  [hActCur+iActTimer], a
	
	; If we've gone through the entire animation (all 32 frames), return to whatever we were doing before.
	; If the player is still nearby, it will instantly return to this routine, making the effect seem continuous.
	ldh  a, [hActCur+iSpringerAnimTimer]
	dec  a									; Timer--
	ldh  [hActCur+iSpringerAnimTimer], a	; Timer == 0?
	ret  nz									; If not, return
	ldh  a, [hActCur+iSpringerRtnBak]		; Otherwise, restore timer
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Springer_SwitchToSpring ===============
; Makes the enemy spring out, interrupting whatever routine the enemy was in.
Act_Springer_SwitchToSpring:
	; Keep track for restoring it later
	ldh  a, [hActCur+iActRtnId]
	ldh  [hActCur+iSpringerRtnBak], a
	
	ld   a, ACTRTN_SPRINGER_INITSPRING
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Springer_IsPlNear ===============
; Checks if the player is near.
; OUT
; - C Flag: If set, the player is near
Act_Springer_IsPlNear:
	call ActS_GetPlDistanceX
	cp   $07					; Player within 7 pixels horizontally?
	ret  nc						; If not, return (C Flag = No)
	call ActS_GetPlDistanceY	
	cp   $07					; Player within 7 pixels vertically?
	ret							; C Flag = It is
	
