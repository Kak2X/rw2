; =============== Act_GiantSpringer ===============
; ID: ACT_GSPRINGER
; Large Springer that fires homing missiles.	
Act_GiantSpringer:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_GiantSpringer_Init
	dw Act_GiantSpringer_Main
	dw Act_GiantSpringer_FallV
	dw Act_GiantSpringer_FireMissile
	dw Act_GiantSpringer_SpringOut
	DEF ACTRTN_GSPRINGER_MAIN = $01
	DEF ACTRTN_GSPRINGER_FIREMISSILE = $03
	DEF ACTRTN_GSPRINGER_SPRINGOUT = $04
	
	DEF DISTANCE_SPRINGOUT = $20
	
; =============== Act_GiantSpringer_Init ===============
Act_GiantSpringer_Init:
	; Move very slowly forward, at 0.0625px/frame
	ld   bc, $0010
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_GiantSpringer_Main ===============
; Main routine, handles checks for all actions.
Act_GiantSpringer_Main:
	; Always move towards the player
	call ActS_FacePl
	
	; Whenever the player gets nearby, activate the springout animation.
	; This is a misleading animation, as while it looks like an attack
	; the actor's collision box doesn't change at all.
	call ActS_GetPlDistanceX
	cp   DISTANCE_SPRINGOUT		; Distance >= $20?
	jr   nc, .far				; If so, jump
.near:
	ld   a, ACTRTN_GSPRINGER_SPRINGOUT
	ldh  [hActCur+iActRtnId], a
	ret
.far:

	; Try to immediately spawn a missile when outside its nearby range.
	; Typically this triggers immediately after the actor spawns.
	ld   a, ACT_GSPRINGERSHOT
	call ActS_CountById	; Find how many ACT_GSPRINGERSHOT active
	ld   a, b
	or   a				; Count != 0?
	jr   nz, .move	; If so, jump
	
	; Otherwise, do a round trip for spawning the missile before returning back here
	ld   a, $01					; Use shooting frame
	call ActS_SetSprMapId
	ld   a, 30					; Delay firing for half a second
	ldh  [hActCur+iActTimer], a
	ld   a, ACTRTN_GSPRINGER_FIREMISSILE
	ldh  [hActCur+iActRtnId], a
	ret
	
.move:
	; If we got here, just move towards the player
	call ActS_ApplySpeedFwdXColi
	
	; If there's no ground below, start falling
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   %11
	ret  nz
	; [TCRF] None are placed in ways that can fall off platforms.
	;       The rest of the subroutine and Act_GiantSpringer_FallV are unreachable.
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_GiantSpringer_FallV ===============
; Enemy falls off a platform.
Act_GiantSpringer_FallV:
	; Keep moving down until we hit solid ground.
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; Return to tracking the player
	ld   a, ACTRTN_GSPRINGER_MAIN
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_GiantSpringer_FireMissile ===============
; Enemy spawns the homing missile.
Act_GiantSpringer_FireMissile:
	; Wait for half a second before spawning the missile
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Launch the missile from the top
	ld   a, ACT_GSPRINGERSHOT
	ld   bc, ($00 << 8)|LOW(-$18) ; 24px above
	call ActS_SpawnRel
	
	; Return to tracking the player
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, ACTRTN_GSPRINGER_MAIN
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_GiantSpringer_SpringOut ===============
; Enemy is in its unretracted spring out animation.
Act_GiantSpringer_SpringOut:
	; Use frames $02-$05, at 1/8 speed
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ld   c, $01
	call ActS_Anim4
	
	; Retract the spring and return to to tracking the player when they go out of range
	call ActS_GetPlDistanceX
	cp   DISTANCE_SPRINGOUT		; Distance < $20?
	ret  c						; If so, keep springing
	
	; Return to tracking the player
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, ACTRTN_GSPRINGER_MAIN
	ldh  [hActCur+iActRtnId], a
	ret
	
