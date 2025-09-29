; =============== Act_Tama_SpawnFleas ===============
; Spawns the three fleas that jump from Tama once the Yarn ball is destroyed.
; Each of the fleas starts from the same position, but has a different jump arc.
Act_Tama_SpawnFleas:
	; FIRST FLEA
	ld   a, ACT_TAMAFLEA
	ld   bc, ($00 << 8)|LOW(-$14)	; 20px to the left
	call ActS_SpawnRel
	ret  c
	
	;--
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	ld   [tActDir], a
	;--
	ld   bc, $00C0 ; 0.75px/frame fwd
	ld   de, $0180 ; 1.5px/frame up
	call ActS_SetShotSpd
	
	; SECOND FLEA
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]
	ld   bc, $0100 ; 1px/frame fwd
	ld   de, $0200 ; 2px/frame up
	call ActS_SetShotSpd
	
	; THIRD FLEA
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]
	ld   bc, $0140 ; 1.25px/frame fwd
	ld   de, $0280 ; 2.5px/frame
	jp   ActS_SetShotSpd
	
