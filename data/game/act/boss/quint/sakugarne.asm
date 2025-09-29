; =============== Act_QuintSakugarne ===============
; ID: ACT_QUINT_SG
; Sakugarne used during Quint's intro animation.
; This is not used during the fight itself, the Sakugarne Quint rides is baked into Quint itself.
Act_QuintSakugarne:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_QuintSakugarne_Init
	dw Act_QuintSakugarne_FallV
	dw Act_QuintSakugarne_InitJump
	dw Act_QuintSakugarne_JumpU
	dw Act_QuintSakugarne_JumpD
	dw Act_QuintSakugarne_WaitEnd

; =============== Act_QuintSakugarne_Init ===============
Act_QuintSakugarne_Init:
	; Reset gravity in preparation for falling down
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_QuintSakugarne_FallV ===============
; Drop from the top of the screen.
Act_QuintSakugarne_FallV:
	; Fall down until we touch the ground
	call ActS_ApplyGravityD_Coli
	ret  c
	; Wait 4 frames before setting up a jump
	ld   a, $04
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_QuintSakugarne_InitJump ===============
Act_QuintSakugarne_InitJump:
	; Show sprite $01 while waiting 4 frames...
	; (only for these few frames it's on the ground)
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; After that, set up a jump to the left.
	;
	
	; Signal out to Quint that he may also start jumping up, to make him catch the pogo stick.
	ld   a, $FF
	ldh  [hActCur+iQuintSgJumpOk], a
	
	ld   hl, hActCur+iActSprMap	; Jump right
	set  ACTDIRB_R, [hl]
	ld   bc, $0140				; 1.25px/frame to the right
	call ActS_SetSpeedX
	ld   bc, $0380				; 3.5px/frame up
	call ActS_SetSpeedY			; This is the same vertical speed Quint jumps at
	jp   ActS_IncRtnId
	
; =============== Act_QuintSakugarne_JumpU ===============
; Jump, pre-peak.
Act_QuintSakugarne_JumpU:
	; Apply jump arc until we reach the peak of the jump 
	call ActS_MoveBySpeedX
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_QuintSakugarne_JumpD ===============
; Jump, post-peak.
Act_QuintSakugarne_JumpD:
	; Apply jump arc until we reach X position $90.
	; That's the X position Quint is in.
	call ActS_MoveBySpeedX
	call ActS_ApplyGravityD_Coli
	ldh  a, [hActCur+iActX]
	cp   OBJ_OFFSET_X+$88	; iActX < $90?
	ret  c					; If so, wait
	
	; Wait for 4 frames before despawning.
	; This is timed with the end of Quint's intro animation,
	; as the Sakugarne is baked into his sprites there.
	ld   a, $04
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_QuintSakugarne_WaitEnd ===============
Act_QuintSakugarne_WaitEnd:
	; Wait those 4 frames...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Then despawn
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
