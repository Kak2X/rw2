; =============== Act_QuintDebris ===============
; ID: ACT_QUINT_DEBRIS
; Damaging debris spawned when Quint is on the ground.
Act_QuintDebris:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_QuintDebris_Init0
	dw Act_QuintDebris_Init1
	dw Act_QuintDebris_Init2
	dw Act_QuintDebris_Init3
	dw Act_QuintDebris_JumpU
	dw Act_QuintDebris_JumpD
	DEF ACTRTN_QUINTDEBRIS_JUMPU = $04

; =============== Act_QuintDebris_Init* ===============
; Four debris spawn at once, each with its own jump arc.
; Hence why there are four separate init routines, which are directly
; set by Act_Quint when it spawns the debris.
;

; =============== Act_QuintDebris_Init0 ===============
; ACTRTN_QUINTDEBRIS_INIT0
Act_QuintDebris_Init0:
	ld   bc, $0060						; 0.375px/frame left
	call ActS_SetSpeedX
	ld   bc, $0240						; 2.25px/frame up
	call ActS_SetSpeedY
	ldh  a, [hActCur+iActSprMap]
	and  $FF^(ACTDIR_R|ACTDIR_D)		; Set LEFT, UP directions
	ldh  [hActCur+iActSprMap], a
	ld   a, ACTRTN_QUINTDEBRIS_JUMPU	; Apply jump
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_QuintDebris_Init1 ===============
; ACTRTN_QUINTDEBRIS_INIT1
Act_QuintDebris_Init1:
	ld   bc, $0020						; 0.125px/frame left
	call ActS_SetSpeedX
	ld   bc, $02C0						; 2.75px/frame up
	call ActS_SetSpeedY
	ldh  a, [hActCur+iActSprMap]
	and  $FF^(ACTDIR_R|ACTDIR_D)		; Set LEFT, UP directions
	ldh  [hActCur+iActSprMap], a
	ld   a, ACTRTN_QUINTDEBRIS_JUMPU	; Apply jump
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_QuintDebris_Init2 ===============
; ACTRTN_QUINTDEBRIS_INIT2
Act_QuintDebris_Init2:
	ld   bc, $0020						; 0.125px/frame left
	call ActS_SetSpeedX
	ld   bc, $02C0						; 2.75px/frame up
	call ActS_SetSpeedY
	ldh  a, [hActCur+iActSprMap]
	and  $FF^(ACTDIR_R|ACTDIR_D)		; Set RIGHT, UP directions
	or   ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	ld   a, ACTRTN_QUINTDEBRIS_JUMPU	; Apply jump
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_QuintDebris_Init3 ===============
; ACTRTN_QUINTDEBRIS_INIT3
Act_QuintDebris_Init3:
	ld   bc, $0060						; 0.375px/frame right
	call ActS_SetSpeedX
	ld   bc, $0240						; 2.25px/frame up
	call ActS_SetSpeedY
	ldh  a, [hActCur+iActSprMap]
	and  $FF^(ACTDIR_R|ACTDIR_D)		; Set RIGHT, UP directions
	or   ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	jp   ActS_IncRtnId ; ACTRTN_QUINTDEBRIS_JUMPU	; Apply jump
	
; =============== Act_QuintDebris_JumpU ===============
; Jump, pre-peak.
Act_QuintDebris_JumpU:
	; Apply jump arc until we reach the peak of the jump 
	call ActS_MoveBySpeedX
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_IncRtnId			; Then start falling down
	
; =============== Act_QuintDebris_JumpD ===============
; Jump, post-peak.
Act_QuintDebris_JumpD:
	; Apply jump arc until we touch the ground 
	call ActS_MoveBySpeedX
	call ActS_ApplyGravityD_Coli
	ret  c
	jp   ActS_Explode			; Then explode
	
