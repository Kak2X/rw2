; =============== Act_Wily2Intro ===============
; ID: ACT_WILY2INTRO
; Body of the 2nd phase Wily Machine, used in the intro cutscene before the Wily attaches itself to it. 
Act_Wily2Intro:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily2Intro_Init
	dw Act_Wily2Intro_Move
	dw Act_Wily2Intro_Wait

; =============== Act_Wily2Intro_Init ===============
Act_Wily2Intro_Init:
	; Move left 0.5px/frame 
	ld   bc, $0080
	call ActS_SetSpeedX
	;--
	; [POI] This was intended to make the actor face left, but it's writing to the wrong address.
	;       It also doesn't matter as the actor is already facing left.
	ld   hl, hActCur+iAct0D
	res  ACTDIRB_R, [hl]
	;--
	
	jp   ActS_IncRtnId
; =============== Act_Wily2Intro_Move ===============
Act_Wily2Intro_Move:
	; Move forward at 0.5px/frame until we reach the target coordinate.
	call ActS_MoveBySpeedX
	ldh  a, [hActCur+iActX]
	cp   OBJ_OFFSET_X+$88	; iActX != $90?
	ret  nz					; If so, return
	jp   ActS_IncRtnId		; Otherwise, stop moving
	
; =============== Act_Wily2Intro_Wait ===============
Act_Wily2Intro_Wait:
	; Wait forever until Wily's Spaceship attaches itself,
	; at which point Act_WilyCtrl will despawn us.
	ret
	
