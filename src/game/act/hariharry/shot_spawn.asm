; =============== Act_Hari_SpawnShots ===============
; Spawns the individual needles that make up Hari Harry's spread shot.
Act_Hari_SpawnShots:
	; #1 Left
	ld   a, ACT_HARISHOT
	ld   bc, (LOW(-$0E) << 8)|LOW(-$04) ; 14px left, 4px up
	call ActS_SpawnRel
	ret  c
	ld   a, ($00 << 3) ; Sprite 0 (h needle)
	ld   bc, $0180 ; 1.5px/frame left
	ld   de, $0000 ; no vertical
	call ActS_SetShotSpd
	
	; #2 Top-left
	ld   a, ACT_HARISHOT
	ld   bc, (LOW(-$08) << 8)|LOW(-$08) ; 8px left, 8px up
	call ActS_SpawnRel
	ret  c
	ld   a, ($01 << 3) ; Sprite 1 (diag needle)
	ld   bc, $010E ; ~1px/frame left
	ld   de, $010E ; ~1px/frame up
	call ActS_SetShotSpd
	
	; #3 Up
	ld   a, ACT_HARISHOT
	ld   bc, (LOW($00) << 8)|LOW(-$10) ; 16px up
	call ActS_SpawnRel
	ret  c
	ld   a, ($02 << 3) ; Sprite 2 (v needle)
	ld   bc, $0000 ; no horizontal
	ld   de, $0180 ; 1.5px/frame up
	call ActS_SetShotSpd
	
	; #4 Top-right
	ld   a, ACT_HARISHOT
	ld   bc, (LOW($08) << 8)|LOW(-$08) ; 8px right, 8px up
	call ActS_SpawnRel
	ret  c
	ld   a, ACTDIR_R|($01 << 3) ; Sprite 1 (diag needle)
	ld   bc, $010E ; ~1px/frame right
	ld   de, $010E ; ~1px/frame up
	call ActS_SetShotSpd
	
	; #5 Right
	ld   a, ACT_HARISHOT
	ld   bc, (LOW($0E) << 8)|LOW(-$04) ; 14px right, 4px up
	call ActS_SpawnRel
	ret  c
	ld   a, ACTDIR_R|($00 << 3) ; Sprite 0 (h needle)
	ld   bc, $0180 ; 1.5px/frame right
	ld   de, $0000 ; no vertical
	jp   ActS_SetShotSpd
	
