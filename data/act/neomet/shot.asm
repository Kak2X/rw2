; =============== Act_NeoMetShot ===============
; ID: ACT_NEOMETSHOT
; Neo Metall's shot, spawned in three, can be horizontal or diagonal.
Act_NeoMetShot:
	; The shot has a 4-frame animation which rotates the "shine" on the sprite.
	ld   c, $01
	call ActS_Anim4
	; Apply movement in both directions
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY ; Could be 0 too
	ret
	
