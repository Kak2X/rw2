; =============== Act_Matasaburo ===============
; ID: ACT_MATASABURO
; Large enemy that blows the player away.
Act_Matasaburo:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Matasaburo_Init
	dw Act_Matasaburo_Blow0
	dw Act_Matasaburo_Blow1

; =============== Act_Matasaburo_Init ===============
Act_Matasaburo_Init:
	; Stay in the next routine for ~1 second 
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Matasaburo_Blow0 ===============
Act_Matasaburo_Blow0:
	;
	; Try to blow the player to backwards.
	;
	
	call ActS_GetPlDistanceX
	; As this actor can only face left, blow the player only if he's on the left side.
	jr   c, .anim			; Player is on the right? If so, skip
	; Don't blow away if too far away
	cp   BLOCK_H*6			; DiffX >= $60?			
	jr   nc, .anim			; If so, jump
	; Checks passed, push player left at 0.5px/frame
	ld   a, $00
	ld   bc, $0080
	call Pl_AdjSpeedByActDir
	
.anim:
	;
	; Animate the fan (using sprites $00-$01)
	; wActCurSprMapBaseId = (hTimer / 4) % 2
	;
	ldh  a, [hTimer]
	rrca 
	rrca 
	and  $01
	ld   [wActCurSprMapBaseId], a
	
	; After ~1 second, switch to the next mode
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; 16 frames in the next mode
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Matasaburo_Blow1 ===============
; Nearly identical to Act_Matasaburo_Blow0 except for the sprites used in the animation.
Act_Matasaburo_Blow1:
	;
	; Try to blow the player to backwards.
	;
	
	call ActS_GetPlDistanceX
	; As this actor can only face left, blow the player only if he's on the left side.
	jr   c, .anim			; Player is on the right? If so, skip
	; Don't blow away if too far away
	cp   BLOCK_H*6			; DiffX >= $60?			
	jr   nc, .anim			; If so, jump
	; Checks passed, push player left at 0.5px/frame
	ld   a, $00
	ld   bc, $0080
	call Pl_AdjSpeedByActDir
	
.anim:
	;
	; Animate the fan (using sprites $02-$03)
	; These have the enemy hold their arms up.
	; wActCurSprMapBaseId = (hTimer / 4) % 2 + 2
	;
	ldh  a, [hTimer]
	rrca 
	rrca 
	and  $01
	add  $02
	ld   [wActCurSprMapBaseId], a
	
	; After 16 frames, switch to the previous mode
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; ~1 second, consistent with the init routine
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_DecRtnId

