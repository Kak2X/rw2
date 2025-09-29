; =============== Act_Shotman ===============
; ID: ACT_SHOTMAN
; Fires shots in an high or low arc.
Act_Shotman:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Shotman_Init
	dw Act_Shotman_ShotLow
	dw Act_Shotman_WaitShotHi
	dw Act_Shotman_ShotHi
	dw Act_Shotman_InitShotLow
	DEF ACTRTN_SHOTMAN_SHOTLOW = $01
; =============== Act_Shotman_Init ===============
; Sets up the initial low arc pattern.
Act_Shotman_Init:
	; Use sprite $00 (low arc)
	ld   a, $00
	call ActS_SetSprMapId
	
	; After six shots, switch to the high arc
	ld   a, $06
	ldh  [hActCur+iShotmanShotsLeft], a
	
	; Start the shooting sequence almost immediately, without any long delay like how it is between arcs.
	; Still wait the usual 32 frame cooldown, normally used between shots
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Shotman_ShotLow ===============
; Fire long shots in a low arc.
Act_Shotman_ShotLow:
	; Wait for the cooldown to elapse first
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Then spawn the shot
	ld   a, ACT_SHOTMANSHOT
	ld   bc, (LOW(-$0C) << 8)|LOW(-$08) ; 12px left, 8px up
	call ActS_SpawnRel
	ld   de, $0300 ; 3px/frame forward
	ld   bc, $0200 ; 2px/frame up
	call nc, Act_Shotman_SetShotSpeed
	
	; Set cooldown of 32 frames before the next shot
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	
	; If all six shots have been fired, delay for a bit and switch to an higher arc
	ld   hl, hActCur+iShotmanShotsLeft
	dec  [hl]				; ShotsLeft--
	ret  nz					; ShotsLeft != 0? If so, return
	
	; Fire six high arc shots
	ld   a, $06
	ldh  [hActCur+iShotmanShotsLeft], a
	; Use sprite $01 (transition to other arc)
	ld   a, $01
	call ActS_SetSprMapId
	; Show the transition sprite for 8 frames.
	; This means the next shot comes out in 32+8 = 40 frames
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Shotman_InitShowHi ===============
Act_Shotman_WaitShotHi:
	; Wait until the transition timer elapses
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Use sprite $02 (high arc)
	ld   a, $02
	call ActS_SetSprMapId
	; Normal 32 frame cooldown
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Shotman_ShotHi ===============
; Fire near shots in a high arc.
; See also: Act_Shotman_ShotLow
Act_Shotman_ShotHi:
	; Wait for the cooldown to elapse first
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Then spawn the shot
	ld   a, ACT_SHOTMANSHOT
	ld   bc, (LOW(-$0C) << 8)|LOW(-$0C) ; 12px left, 12px up
	call ActS_SpawnRel
	ld   de, $0080 ; 0.5px/frame forward
	ld   bc, $0380 ; 3.5px/frame up
	call nc, Act_Shotman_SetShotSpeed
	
	; Set cooldown of 32 frames before the next shot
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	
	; If all six shots have been fired, delay for a bit and switch back to the lower arc
	ld   hl, hActCur+iShotmanShotsLeft
	dec  [hl]				; ShotsLeft--
	ret  nz					; ShotsLeft != 0? If so, return
	
	; Fire six low arc shots
	ld   a, $06
	ldh  [hActCur+iShotmanShotsLeft], a
	; Use sprite $01 (transition to other arc)
	ld   a, $01
	call ActS_SetSprMapId
	; Show the transition sprite for 8 frames.
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId

; =============== Act_Shotman_InitShotLow ===============
Act_Shotman_InitShotLow:
	; Wait until the transition timer elapses
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Use sprite $02 (low arc)
	ld   a, $00
	call ActS_SetSprMapId
	; Normal 32 frame cooldown
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	ld   a, ACTRTN_SHOTMAN_SHOTLOW
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Shotman_SetShotSpeed ===============
; Sets the newly spawned shot's arc.
; IN
; - HL: Ptr to spawned shot slot
; - DE: Horizontal speed
; - BC: Vertical speed
Act_Shotman_SetShotSpeed:
	; Seek HL to iActSpdXSub
	ld   a, l
	add  iActSpdXSub
	ld   l, a
	; Write the properties over
	ld   [hl], e ; iActSpdXSub
	inc  hl
	ld   [hl], d ; iActSpdX
	inc  hl
	ld   [hl], c ; iActSpdYSub
	inc  hl
	ld   [hl], b ; iActSpdY
	ret
	
