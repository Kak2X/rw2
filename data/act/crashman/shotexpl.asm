; =============== Act_CrashManShotExpl ===============
; ID: ACT_CRASHBOMBEXPL
; Large explosion caused by the boss version of the Crash Bombs.
; Unlike the player ones, these are an actual entity that hurts (the player) and have a larger than expected collision box.
Act_CrashManShotExpl:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_CrashManShotExpl_Init
	dw Act_CrashManShotExpl_Anim

; =============== Act_CrashManShotExpl_Init ===============
Act_CrashManShotExpl_Init:
	; Show for ~half a second
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_CrashManShotExpl_Anim ===============
Act_CrashManShotExpl_Anim:
	; The explosion is simply a 4-frame looping animation
	ld   c, $01
	call ActS_Anim4
	
	; Display the above, maintaining the oversized hitbox, for that ~half a second.
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Then despawn the explosion.
	; It should have been done by simply resetting iActId, and not by using the normal explosion,
	; which looks out of place compared to the larger explosion animation we were playing.
	jp   ActS_Explode
	
