; =============== Act_TopMan_SpawnShots ===============
; Spawns the three spinning tops in Top Man's fight.
Act_TopMan_SpawnShots:
	; FIRST SHOT
	ld   a, ACT_SPINTOPSHOT
	ld   bc, ($00 << 8)|LOW(-$04) ; 4px left
	call ActS_SpawnRel
	ret  c
	;--
	; Top Man throws all three shots forwards, so they face the same direction as him
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	ld   [tActDir], a
	;--
	ld   bc, $00C0 ; 0.75px/frame forwards
	ld   de, $00C0 ; 0.75px/frame upwards
	call ActS_SetShotSpd
	
	; SECOND SHOT
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]
	ld   bc, $0120 ; 1.125px/frame forwards
	ld   de, $0120 ; 1.125px/frame forwards
	call ActS_SetShotSpd
	
	; THIRD SHOT
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]
	ld   bc, $0180 ; 1.5px/frame forwards
	ld   de, $0180 ; 1.5px/frame forwards
	jp   ActS_SetShotSpd
	
