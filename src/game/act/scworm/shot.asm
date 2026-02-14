; =============== Act_ScwormShot ===============
; ID: ACT_SCWORMSHOT
; Pipe shot lobbed by Act_ScwormBase.
Act_ScwormShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_ScwormShot_Init
	dw Act_ScwormShot_MoveOut
	dw Act_ScwormShot_JumpU
	dw Act_ScwormShot_JumpD
	dw Act_ScwormShot_Ground

; =============== Act_ScwormShot_Init ===============
Act_ScwormShot_Init:
	; Set up animation for coming out of the tube.
	; This needs its own non-looping animation mainly since the spawner is too thin to clip the normal-sized shot.
	; Use sprites $00-$02 at 1/8 speed
	ld   de, ($00 << 8)|$02
	ld   c, $08
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_ScwormShot_MoveOut ===============
Act_ScwormShot_MoveOut:
	; Wait until the animation has finished
	call ActS_PlayAnimRange
	ret  z
	
	;
	; Then set up the jump towards the player.
	;
	
	; HORIZONTAL SPEED
	; SpdX = ((DiffX * 4) + (Rand() % $10)) / $10
	call ActS_FacePl			; Towards the player
	call ActS_GetPlDistanceX	; A = DiffX
	ld   l, a					; HL = A
	ld   h, $00
	add  hl, hl					; HL *= 2 (*2)
	add  hl, hl					; HL *= 2 (*4)
	IF REV_VER == VER_EU
		call Rand				; A = Rand()
	ELSE
		; Not necessary to push/pop hl
		push hl
			call Rand
		pop  hl
	ENDC
	and  $0F					; A %= $10
	ld   e, a					; DE = A
	ld   d, $00
	add  hl, de					; HL += DE
	ld   a, l					; Save finalized speed
	ldh  [hActCur+iActSpdXSub], a
	ld   a, h
	ldh  [hActCur+iActSpdX], a
	
	; VERTICAL SPEED
	ld   bc, $0300			; Fixed 3px/frame
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_ScwormShot_JumpU ===============
; Jump, pre-peak.
Act_ScwormShot_JumpU:
	call Act_ScwormShot_Anim
	; Move forward during the jump, stopping if there's a solid wall in the way
	call ActS_MoveBySpeedX_Coli
	; Apply gravity while moving up until we reach the peak, including hitting the ceiling
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_ScwormShot_JumpD ===============
; Jump, post-peak.
Act_ScwormShot_JumpD:
	call Act_ScwormShot_Anim
	; Move forward during the jump, stopping if there's a solid wall in the way
	call ActS_MoveBySpeedX_Coli
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplyGravityD_Coli
	ret  c
	; Stay on the ground for ~1 second
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_ScwormShot_Ground ===============
Act_ScwormShot_Ground:
	; Wait ~1 second animating on the ground
	call Act_ScwormShot_Anim
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; After that, despawn with a small explosion
	jp   ActS_Explode
	
; =============== Act_ScwormShot_Anim ===============
; Handles the animation cycle for the pipe.
; Uses frames $02-$03 at 1/8 speed
Act_ScwormShot_Anim:
	ldh  a, [hTimer]	; Get global timer
	rrca		; /2
	rrca		; /4
	rrca		; /8
	and  $01	; Animation is 2 frames long
	add  $02	; From $02
	ld   [wActCurSprMapBaseId], a
	ret
	
