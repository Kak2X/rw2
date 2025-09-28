; =============== Act_MetalManShot ===============
; ID: ACT_METALBLADE
; Boss version of the Metal Blade.	
Act_MetalManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_MetalManShot_TrackPl
	dw Act_MetalManShot_Move

; =============== Act_MetalManShot_TrackPl ===============
Act_MetalManShot_TrackPl:
	; Move towards the player's *origin* (bottom of the player).
	; This is the only actor that targets it over the center of the player.
	ld   b, $00
	call ActS_AngleToPlCustom
	call ActS_DoubleSpd
	jp   ActS_IncRtnId
	
; =============== Act_MetalManShot_Move ===============
Act_MetalManShot_Move:
	; Animate the shot
	ld   c, $01
	call ActS_Anim2
	
	; Move by the previously set position
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
