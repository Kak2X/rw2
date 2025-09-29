; =============== Act_Pipi ===============
; ID: ACT_PIPI
; A bird that drops eggs.
; Only spawned by Act_PipiSpawner, which takes care of spawning it from the correct side.
Act_Pipi:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Pipi_InitWait
	dw Act_Pipi_Wait
	dw Act_Pipi_Move

; =============== Act_Pipi_InitWait ===============
Act_Pipi_InitWait:
	; Save an original copy of the offscreen X position here (see Act_Pipi_Wait)
	ldh  a, [hActCur+iActX]
	ldh  [hActCur+iPipiSpawnX], a
	
	; Wait 64 frames before coming from the side of the screen
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Pipi_Wait ===============
; Waits offscreen.
Act_Pipi_Wait:

	; Force the bird to stay offscreen, in case we're scrolling the screen (ie: Air Man's stage)
	ldh  a, [hActCur+iPipiSpawnX]
	ldh  [hActCur+iActX], a
	
	; Wait for 64 frames 
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz

	; [BUG] This is forgetting to call ActS_ChkExplodeNoChild.
	;       This causes the death handler to be delayed until it gets to the next mode,
	;       which sounds odd when you can hear something getting hit multiple times offscreen.
	
	
	; Face the player, as that's not done by the spawner
	call ActS_FacePl
	
	; Move 0.75px/frame towards the player
	ld   bc, $00C0
	call ActS_SetSpeedX
	
	; Spawn the egg right below the actor
	ld   a, ACT_EGG
	ld   bc, $0008		; 8px below bird
	call ActS_SpawnRel
	; Keep track of the actor slot containing the egg
	ld   a, l
	ldh  [hActCur+iPipiEggSlotPtr_Low], a
	ld   a, h
	ldh  [hActCur+iPipiEggSlotPtr_High], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Pipi_Move ===============
; Moves horizontally in a straight line, until it gets offscreened the other side.
Act_Pipi_Move:
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Move horizontally 
	call ActS_MoveBySpeedX
	
	; When the actor's health goes below the threshold, destroy it and notify the egg.
	; This lets the egg decide whether it should be destroyed automatically.
	call ActS_ChkExplodeNoChild		; Handle death
	ret  nc							; Did it happen? If not, return
	
	ld   a, ACT_EGG
	call ActS_CountById
	ld   a, b
	and  a							; Any eggs onscreen?
	ret  z							; If not, return
	
	; Seek HL to the egg's iEggBirdDead
	ldh  a, [hActCur+iPipiEggSlotPtr_Low]	
	add  iEggBirdDead
	ld   l, a
	ldh  a, [hActCur+iPipiEggSlotPtr_High]
	ld   h, a
	ld   [hl], $FF					; Flag as dead
	ret
	
