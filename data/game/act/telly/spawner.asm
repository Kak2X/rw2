; =============== Act_TellySpawner ===============
; ID: ACT_TELLYSPAWN
; Spawns Tellies every ~second at its location.
Act_TellySpawner:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_TellySpawner_Init
	dw Act_TellySpawner_Spawn
	dw Act_TellySpawner_Wait

; =============== Act_TellySpawner_Init ===============
; Sets the initial spawn delay.
Act_TellySpawner_Init:
	; Wait 32 frames before spawning the first one
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_TellySpawner_Spawn ===============
Act_TellySpawner_Spawn:
	; Wait the 32 frames, whenever they come from
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;--
	; Try again 32 frames later...
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	
	; ...if there are more than 3 tellies onscreen
	ld   a, ACT_TELLY
	call ActS_CountById
	ld   a, b
	cp   $03
	ret  nc
	;--
	
	; Checks passed, spawn the Telly at the spawner's location
	ld   a, ACT_TELLY
	ld   bc, $0000
	call ActS_SpawnRel
	
	; Wait for a few seconds before spawning another one
	ld   a, $FF
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_TellySpawner_Wait ===============
Act_TellySpawner_Wait:
	; Wait 255 frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Wait the usual additional 32 frames in Act_TellySpawner_Spawn
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_DecRtnId
	
