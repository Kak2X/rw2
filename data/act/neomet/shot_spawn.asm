; =============== Act_NeoMet_SpawnShots ===============
; Spawns the individual shots that make up a Met's 3-way spreadshot.
Act_NeoMet_SpawnShots:

	;
	; FIRST SHOT
	;
	ld   a, ACT_NEOMETSHOT			
	ld   bc, ($00 << 8)|LOW(-$04)	; Spawn first shot 4px to the left of the Met
	call ActS_SpawnRel				; Could it spawn?
	ret  c							; If not, return
	;--
	; Every shot inherits the same direction as its parent (the Met)
	DEF tActDir = wTmpCF52
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	ld   [tActDir], a
	;--
	ld   bc, $00B4 ; $00.B4px/frame forwards
	ld   de, $00B4 ; $00.B4px/frame upwards
	call ActS_SetShotSpd
	
	;
	; For the remainder of the shots, call ActS_Spawn to reuse the spawn settings
	; that ActS_SpawnRel generated for us. Therefore, all of the shots will reuse
	; the same origin, which is 4px to the left of the Met.
	;
	
	;
	; SECOND SHOT
	;
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]
	ld   bc, $00FF ; Nearly 1px/frame forwards
	ld   de, $0000 ; No vertical movement
	call ActS_SetShotSpd
	
	;
	; THIRD SHOT
	;
	call ActS_Spawn
	ret  c
	ld   a, [tActDir]	; Set downwards direction
	or   ACTDIR_D 
	ld   bc, $00B4 ; $00.B4px/frame forwards
	ld   de, $00B4 ; $00.B4px/frame downwards
	jp   ActS_SetShotSpd
	
