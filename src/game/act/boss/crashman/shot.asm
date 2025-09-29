; =============== Act_CrashManShot ===============
; ID: ACT_CRASHBOMB
; Boss version of the Crash Bomb.
; It needs to explode fast enough to win the spawn check Act_CrashMan_JumpShootD makes over ACT_CRASHBOMBEXPL.
Act_CrashManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_CrashManShot_TrackPl
	dw Act_CrashManShot_MoveToPl
	dw Act_CrashManShot_SetExplDelay
	dw Act_CrashManShot_WaitExpl
	dw Act_CrashManShot_Explode

; =============== Act_CrashManShot_TrackPl ===============
; Take a snapshot of the player's position.
; Unlike the RM2 counterpart, which just moves diagonally down, this directly targets the player.
Act_CrashManShot_TrackPl:
	call ActS_AngleToPl
	call ActS_DoubleSpd
	jp   ActS_IncRtnId
	
; =============== Act_CrashManShot_MoveToPl ===============
Act_CrashManShot_MoveToPl:
	; Move until we hit a solid wall
	call ActS_MoveBySpeedX_Coli
	jp   nc, ActS_IncRtnId
	call ActS_MoveBySpeedYColi
	jp   nc, ActS_IncRtnId
	ret
	
; =============== Act_CrashManShot_SetExplDelay ===============
Act_CrashManShot_SetExplDelay:
	; Explode in ~half a second
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_CrashManShot_WaitExpl ===============
Act_CrashManShot_WaitExpl:
	; Wait for that ~half a second...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	jp   ActS_IncRtnId
	
; =============== Act_CrashManShot_Explode ===============
Act_CrashManShot_Explode:
	; Spawn a large explosion with a misleadingly larger collision box directly over us.
	ld   a, ACT_CRASHBOMBEXPL
	ld   bc, $0000
	call ActS_SpawnRel
	
	; Alongside an extra small explosion to replace the bomb, which looks out of place once you notice it.
	jp   ActS_Explode
	
