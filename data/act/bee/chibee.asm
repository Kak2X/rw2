; =============== Act_Chibee ===============
; ID: ACT_CHIBEE
; Small bee homing into the player.
Act_Chibee:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Chibee_ExplAnim
	dw Act_Chibee_MoveLine
	dw Act_Chibee_MoveArc
	
	DEF ACTRTN_CHIBEE_MOVELINE = $01
	
; =============== Act_Chibee_ExplAnim ===============
; Animates the explosion effect, using identical code to Act_ExplSm_Anim.
; The first three sprite mappings for the small bee are explosion frames.
Act_Chibee_ExplAnim:
	; Advance the animation at 1/4 speed, every four frames.
	ldh  a, [hActCur+iActSprMap]
	add  $02						; Timer += 2
	and  $1F						; Force valid frame range
	ldh  [hActCur+iActSprMap], a
	
	; If we went past the last valid sprite, the animation is over.
	srl  a				; >> 3 to sprite ID
	srl  a
	srl  a
	and  $03			; Filter out other flags
	cp   $03			; Sprite ID reached $03?
	ret  nz				; If not, return
	jp   ActS_IncRtnId	; Otherwise, next mode
	
; =============== Act_Chibee_MoveLine ===============
; Moves the bee in a straight line towards the player.
Act_Chibee_MoveLine:
	; Use the 2-frame animation at $03-$04
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ld   c, $02
	call ActS_Anim2
	
	; Move the bee directly towards the player until it gets too close
	call ActS_AngleToPl
	ld   a, [tActPlYDiff]	; Get Y distance
	ld   b, a
	ld   a, [tActPlXDiff]	; Get X distance
	or   b					; Are both of them...
	cp   $10				; ...less than 16?
	jr   c, .nextMode		; If so, prepare circling around
	
.moveDiag:
	; Move diagonally at half speed
	call ActS_HalfSpdSub
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
.nextMode:
	call ActS_InitCirclePath
	jp   ActS_IncRtnId
	
; =============== Act_Chibee ===============
; Moves the bee in a circular path for ~3 seconds, then loops back to Act_Chibee_MoveLine.
Act_Chibee_MoveArc:
	; Use the 2-frame animation at $03-$04
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ld   c, $02
	call ActS_Anim2
	
	; Wait nearly 3 seconds before returning to the previous mode
	ldh  a, [hActCur+iActTimer]
	add  $01
	ldh  [hActCur+iActTimer], a
	cp   $B0							; Timer < $B0?
	jr   c, .doArc						; If so, skip
	ld   a, ACTRTN_CHIBEE_MOVELINE
	ldh  [hActCur+iActRtnId], a
	
.doArc:
	ld   a, ARC_SM						; Move along a small circular path
	call ActS_ApplyCirclePath
	call ActS_HalfSpdSub				; At half speed as always
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
