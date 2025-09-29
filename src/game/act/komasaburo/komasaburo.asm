; =============== Act_Komasaburo ===============
; ID: ACT_KOMASABURO
; Spawns spinning tops.
Act_Komasaburo:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Komasaburo_Init
	dw Act_Komasaburo_InitIdle
	dw Act_Komasaburo_Idle
	dw Act_Komasaburo_Shoot
	dw Act_Komasaburo_AfterShoot
	DEF ACTRTN_KOMASABURO_INITIDLE = $01
	
; =============== Act_Komasaburo_Init ===============
Act_Komasaburo_Init:
	call ActS_FacePl
	; This actor is around two blocks wide and is intended to be spawned
	; between those two blocks, but the actor layout format isn't precise
	; enough for that, so move him right by 8px during init.
	ldh  a, [hActCur+iActX]
	add  $08
	ldh  [hActCur+iActX], a
	jp   ActS_IncRtnId
	
; =============== Act_Komasaburo_InitIdle ===============
; Sets up the delay before shooting.
Act_Komasaburo_InitIdle:
	; Use frames $00-$01, at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	
	; Wait for 60 seconds in the next mode
	ld   a, 60
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Komasaburo_Idle ===============
; Enemy is idle, waiting for a second before shooting.
Act_Komasaburo_Idle:
	; Use frames $00-$01, at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	
	; Wait for those 60 seconds before shooting
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	jp   ActS_IncRtnId
	
; =============== Act_Komasaburo_Shoot ===============
; Shoots a spinning top if there aren't too many of them.
Act_Komasaburo_Shoot:
	
	; If there are 3 or more spinning tops on screen, try again next frame.
	; Returning like this means the actor won't animate while waiting for one of them to despawn.
	ld   a, ACT_KOMA
	call ActS_CountById
	ld   a, b
	cp   $03		; Are there 3 or more spinning tops onscreen?
	ret  nc			; If so, return
	
	; Otherwise, spawn a new one directly at the parent's location.
	ld   a, ACT_KOMA
	ld   bc, $0000		; Directly on top
	call ActS_SpawnRel	; Could it spawn?
	jr   c, .setSpr		; If not, skip
	call ActS_SyncDirToSpawn ; Throw it forward (same direction as parent)
.setSpr:
	; Use shoot frame...
	ld   a, $02
	call ActS_SetSprMapId
	
	; ...for 12 frames
	ld   a, $0C
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Komasaburo_AfterShoot ===============
; Waits 12 frames in the shooting sprite, as cooldown.
Act_Komasaburo_AfterShoot:
	; After they pass, return to the start again, in its idle animation
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	ld   a, ACTRTN_KOMASABURO_INITIDLE
	ldh  [hActCur+iActRtnId], a
	ret
	
