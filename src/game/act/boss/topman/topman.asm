; =============== Act_TopMan ===============
; ID: ACT_TOPMAN
Act_TopMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_TopMan_InitThrow
	dw Act_TopMan_Throw0
	dw Act_TopMan_Throw1
	dw Act_TopMan_SpawnTop
	dw Act_TopMan_Throw1
	dw Act_TopMan_InitSpin
	dw Act_TopMan_Spin
	dw Act_TopMan_Move
	DEF ACTRTN_TOPMAN_INTRO = $00

; =============== Act_TopMan_InitThrow ===============
; Initialize arm motion.
Act_TopMan_InitThrow:
	; Use sprite $00 for half a second
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	ld   a, $00
	call ActS_SetSprMapId
	
	jp   ActS_IncRtnId
	
; =============== Act_TopMan_Throw0 ===============
; Arm motion - sprite $00.
Act_TopMan_Throw0:
	; Wait that half a second
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Use sprite $02 for half a second
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	ld   a, $02
	call ActS_SetSprMapId
	
	jp   ActS_IncRtnId
	
; =============== Act_TopMan_Throw1 ===============
; Arm motion - sprite $02.
Act_TopMan_Throw1:
	; Wait that half a second
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Use sprite $01 for 15 frames
	ld   a, $0F
	ldh  [hActCur+iActTimer], a
	ld   a, $01
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_TopMan_SpawnTop ===============
Act_TopMan_SpawnTop:
	; Wait those 15 frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Cooldown of 2 seconds after spawning them, using sprite $02
	ld   a, 60*2
	ldh  [hActCur+iActTimer], a
	ld   a, $00
	call ActS_SetSprMapId
	
	; Spawn three spinning tops, which block shots.
	call Act_TopMan_SpawnShots
	jp   ActS_IncRtnId
	
; =============== Act_TopMan_InitSpin ===============
Act_TopMan_InitSpin:
	; Wait those 2 seconds before doing it
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Spin in place for 2 seconds
	ld   a, 60*2
	ldh  [hActCur+iActTimer], a
	ld   b, ACTCOLI_ENEMYREFLECT	; Reflect shots while spinning
	call ActS_SetColiType
	jp   ActS_IncRtnId
	
; =============== Act_TopMan_Spin ===============
Act_TopMan_Spin:
	; Use frames $03-$06 at 1/4 speed to animate the spin
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ld   c, $02
	call ActS_Anim4
	; Do that for aforemented 2 seconds
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Then start moving forward at 2px/frame, to the other side of the screen
	ld   bc, $0200
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_TopMan_Move ===============
Act_TopMan_Move:
	; Use frames $03-$06 at 1/4 speed to animate the spin
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ld   c, $02
	call ActS_Anim4
	
	; Move forward at 2px/frame until we reach the opposite side of the screen.
	; Specifically, until we're within 2 blocks from the edge of the screen.
	DEF OFFS = BLOCK_H*2
	call ActS_MoveBySpeedX
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a				; Facing right?
	jr   nz, .chkR					; If so, jump
.chkL:
	ldh  a, [hActCur+iActX]
	cp   OBJ_OFFSET_X+OFFS			; Top Man within 2 blocks from the left? (ActX < $18)
	jr   c, .loop					; If so, jump
	ret								; Otherwise, keep moving
.chkR:
	ldh  a, [hActCur+iActX]
	cp   OBJ_OFFSET_X+SCREEN_GAME_H-OFFS 	; Top Man within 2 blocks from the right? (ActX < $88)
	ret  c									; If not, keep moving
	
.loop:
	ld   b, ACTCOLI_ENEMYHIT		; Vulnerable when not spinning
	call ActS_SetColiType
	call ActS_FlipH					; Turn the other side
	; [BUG] This one is easy to notice, the player is likely in the air, so its vertical speed is reset.
	ld   a, ACTRTN_TOPMAN_INTRO		; Loop the pattern
	ldh  [hActCur+iActRtnId], a
	ret
	
	
