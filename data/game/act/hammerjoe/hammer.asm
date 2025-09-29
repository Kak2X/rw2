; =============== Act_Hammer ===============
; ID: ACT_HAMMER
; Hammer thrown by Hammer Joe.
Act_Hammer:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Hammer_Swing
	dw Act_Hammer_InitThrow
	dw Act_Hammer_Throw

; =============== Act_Hammer_Swing ===============
Act_Hammer_Swing:
	; 4-frame swinging hammer anim at 1/4 speed (frames $00-$03)
	ld   c, $02
	call ActS_Anim4
	ret
	
; =============== Act_Hammer_InitThrow ===============
; Sets up the animation and position for the thrown hammer.
Act_Hammer_InitThrow:
	; Switch to frame $04 (part of the throw anim)
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	
	; Not actually vulnerable, it's set to be invulnerable to all weapons
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	
	;
	; As Hammer Joe's arm is logically moved forward when throwing, reposition the hammer...
	;
	
	; ...18px down
	ldh  a, [hActCur+iActY]
	add  $12
	ldh  [hActCur+iActY], a
	
	; ...and 20px forward
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a			; Facing right?
	jr   nz, .moveR				; If so, jump
.moveL:
	ldh  a, [hActCur+iActX]
	sub  $18
	ldh  [hActCur+iActX], a
	jp   ActS_IncRtnId
.moveR:
	ldh  a, [hActCur+iActX]
	add  $18
	ldh  [hActCur+iActX], a
	jp   ActS_IncRtnId
	
; =============== Act_Hammer_Throw ===============
; Hammer is thrown forward at 2px/frame.
Act_Hammer_Throw:
	; 2-frame animation at $04-$05 when moving through the air
	ld   c, $01
	call ActS_Anim2
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	; Move forward at 2px/frame.
	call ActS_MoveBySpeedX
	ret
	
