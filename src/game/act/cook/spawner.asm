; =============== Act_CookSpawner ===============
; ID: ACT_COOKSPAWN
; Spawns running chickens.
Act_CookSpawner:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_CookSpawner_Spawn
	dw Act_CookSpawner_Wait

; =============== Act_CookSpawner_Spawn ===============
; Tries to immediately spawn a chicken on the right side of the screen.
; There is a cooldown of ~1 second, but that only applies if the actor could spawn,
; if that fails it will retry every frame.
Act_CookSpawner_Spawn:
	; Set the ~1 sec cooldown, only applied on success
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	
	; If there's a chicken running around already, don't spawn a second one
	ld   a, ACT_COOK
	call ActS_CountById
	ld   a, b
	and  a
	jp   nz, ActS_IncRtnId
	
	; Spawn the chicken exclusively from the right side of the screen, close to the despawn range.
	ld   a, ACT_COOK
	ld   bc, $0000
	call ActS_SpawnRel		; Spawn directly on the spawner
	jp   c, ActS_IncRtnId	; Could it spawn? If not, don't spawn
	
	ld   a, l				; Seek to X position
	add  iActX
	ld   l, a
	ld   [hl],  SCREEN_GAME_H+OBJ_OFFSET_X+$08	; Point to off-screen right ($B0)
	
	; Spawned successfully, wait ~1 sec 
	jp   ActS_IncRtnId
	
; =============== Act_CookSpawner_Wait ===============
; Cooldown after spawning one.
Act_CookSpawner_Wait:
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	jp   ActS_DecRtnId

