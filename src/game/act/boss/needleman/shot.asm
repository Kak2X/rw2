; =============== Act_NeedleManShot ===============
; ID: ACT_NEEDLECANNON
; Boss version of the Needle Cannon shot, which moves towards the player.
Act_NeedleManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NeedleManShot_TrackPl
	dw Act_NeedleManShot_Move

; =============== Act_NeedleManShot_TrackPl ===============
; Snapshot the player's position
Act_NeedleManShot_TrackPl:
	call ActS_AngleToPl
	call ActS_DoubleSpd
	jp   ActS_IncRtnId
	
; =============== Act_NeedleManShot_Move ===============
; Move towards that at double speed
Act_NeedleManShot_Move:
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	ret
	
