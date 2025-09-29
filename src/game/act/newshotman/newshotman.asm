; =============== Act_NewShotman ===============
; ID: ACT_NEWSHOTMAN
; Front-facing variant of the Shotman, alternates between firing horizontally and at an arc.
Act_NewShotman:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NewShotman_InitMain
	dw Act_NewShotman_Main
REPT 3 ; 3 horizontal shots
	dw Act_NewShotman_SetSpawnDelayH
	dw Act_NewShotman_SpawnH
ENDR
	dw Act_NewShotman_AfterSpawnH
	dw Act_NewShotman_AfterSpawnV
	DEF ACTRTN_NEWSHOTMAN_INITMAIN = $00
	DEF ACTRTN_NEWSHOTMAN_SPAWNH = $03
	DEF ACTRTN_NEWSHOTMAN_AFTERSPAWNV = 2*3 + $03 ; $09

; =============== Act_NewShotman_InitMain ===============
Act_NewShotman_InitMain:
	; Use frames $00-$01, at 1/8 speed 
	xor  a
	ldh  [hActCur+iActSprMap], a
	ld   c, $01
	call ActS_Anim2
	
	; Set delay for triggering horizontal attack
	ld   a, 60
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NewShotman_Main ===============
; Default idle routine.
Act_NewShotman_Main:
	; Use frames $00-$01, at 1/8 speed 
	ld   c, $01
	call ActS_Anim2
	
	; Every $80 frames, alternate between attacks
	ldh  a, [hTimer]
	bit  7, a			; Timer < $80?
	jr   z, .tryHorz		; If so, jump
	
.tryVert:
	; Only trigger the vertical attack within 3 blocks, fall back to the horizontal one otherwise.
	call ActS_GetPlDistanceX
	cp   BLOCK_H*3
	jr   nc, .tryHorz
	
	; Use sprite $02 while shooting up
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	
	; Cooldown of half a second after spawning the shots
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	
	; Spawn the two vertical shots, one on each side.
	xor  a									; A = Sprite $00, Moving left
	ld   de, ($01 << 8)|ACT_NEWSHOTMANSHOTV ; D = 1px/frame up, E = Actor Id
	ld   bc, ($00 << 8)|LOW(-$10)			; B = Same X pos, C = 16px above
	call ActS_SpawnArcShot
	
	ld   a, ACTDIR_R						; A = Sprite $00, Moving right
	ld   de, ($01 << 8)|ACT_NEWSHOTMANSHOTV	; D = 1px/frame up, E = Actor Id
	ld   bc, ($00 << 8)|LOW(-$10)			; B = Same X pos, C = 16px above
	call ActS_SpawnArcShot
	
	; Switch to after-shot cooldown
	ld   a, ACTRTN_NEWSHOTMAN_AFTERSPAWNV
	ldh  [hActCur+iActRtnId], a
	ret
	
.tryHorz:
	; Wait until the second ticks down before triggering the horizontal attack.
	; This is mainly useful if we came here from .tryVert, as it gives a window of opportunity
	; for the vertical attack to trigger.
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Otherwise, prepare the horizontal attack.
	jp   ActS_IncRtnId
	
; =============== Act_NewShotman_SetSpawnDelayH ===============
; Sets up the delay between horizontal shots.
Act_NewShotman_SetSpawnDelayH:
	; Use frames $00-$01, at 1/8 speed 
	ld   c, $01
	call ActS_Anim2
	; Half a second cooldown between shots
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NewShotman_SpawnH ===============
; Fires an horizontal shot on each side.
Act_NewShotman_SpawnH:
	; While waiting, use frames $00-$01, at 1/8 speed 
	ld   c, $01
	call ActS_Anim2
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Then, fire both shots on each side.
	; These are aligned to the small chutes at the side of the enemy.
	
	ld   a, ACT_NEWSHOTMANSHOTH
	ld   bc, (LOW(-$08) << 8)|LOW(-$08) ; 8px left, 8px up
	call ActS_SpawnRel
	jr   c, .nextMode
	; As this actor visually faces forward and has symmetrical attacks, it never sets an explicit horizontal direction.
	; This means it's internally always facing left, so calling the following alo makes the shot face/move left.
	call ActS_SyncDirToSpawn
	
	; RIGHT SIDE
	ld   a, ACT_NEWSHOTMANSHOTH
	ld   bc, (LOW($08) << 8)|LOW(-$08) ; 8px right, 8px up
	call ActS_SpawnRel
	jr   c, .nextMode
	call ActS_SyncRevDirToSpawn ; Face right
	
.nextMode:
	jp   ActS_IncRtnId
	
; =============== Act_NewShotman_AfterSpawnH ===============
; Returns to the main routine after the horizontal shots are all spawned.
Act_NewShotman_AfterSpawnH:
	; Use frames $00-$01, at 1/8 speed 
	ld   c, $01
	call ActS_Anim2
	ld   a, ACTRTN_NEWSHOTMAN_INITMAIN
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NewShotman_AfterSpawnV ===============
; Cooldown after spawning vertical shots.
Act_NewShotman_AfterSpawnV:
	; Use sprite $02 for 30 seconds (previously set in Act_NewShotman_InitMain)
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; After the cooldown elapses, do the horizontal attack.
	; Unlike when the horizontal attack starts on its own, the first shot is delayed by a second.
	; (the ther two ones still delay by half a second)
	ld   a, 60
	ldh  [hActCur+iActTimer], a
	ld   a, ACTRTN_NEWSHOTMAN_SPAWNH
	ldh  [hActCur+iActRtnId], a
	ret
	
