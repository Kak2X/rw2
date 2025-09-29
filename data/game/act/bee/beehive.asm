; =============== Act_BeeHive ===============
; ID: ACT_BEEHIVE
; Beehive carried by a giant bee, when it drops it blows up, spawning smaller bees.
;
; Child actor for Act_Bee, but completely independent so its speed and timings need
; to be consistent with those from its parent.
Act_BeeHive:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BeeHive_InitPath
	dw Act_BeeHive_MoveToTarget
	dw Act_BeeHive_MoveU
	dw Act_BeeHive_MoveD
	dw Act_BeeHive_Drop

; =============== Act_BeeHive_InitPath ===============
; Identical to Act_Bee_InitPath except the hive doesn't animate and can't be hit.
; These differences also apply to the next routines.
Act_BeeHive_InitPath:
	call ActS_FacePl
	
	ld   bc, $0200			; 2px/frame forward speed
	call ActS_SetSpeedX
	
	ld   bc, $0020			; 0.125px/frame vertical speed
	call ActS_SetSpeedY
	
	; Set target pos
	ld   b, OBJ_OFFSET_X+$08
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a
	jr   z, .setTarget
	ld   b, OBJ_OFFSET_X+SCREEN_GAME_H-BLOCK_H-$08
.setTarget:
	ld   a, b
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_BeeHive_MoveToTarget ===============
; Move horizontally until it reaches the target.
Act_BeeHive_MoveToTarget:
	call ActS_MoveBySpeedX
	
	; Check target pos
	ldh  a, [hActCur+iActX]
	and  $F0
	ld   b, a
	ldh  a, [hActCur+iActTimer]
	and  $F0
	cp   b
	ret  nz
	
	; (Hive doesn't turn)
	ld   a, $00
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_BeeHive_MoveU ===============
; Bob upwards for a bit, waiting.		
Act_BeeHive_MoveU:
	; Move up at 0.125px/frame
	call ActS_MoveBySpeedY
	
	; Do so for 20 frames
	ldh  a, [hActCur+iActTimer]
	add  $01
	ldh  [hActCur+iActTimer], a
	cp   $14
	ret  nz
	
	; Move vertically after that
	call ActS_FlipV
	jp   ActS_IncRtnId
	
; =============== Act_BeeHive_MoveD ===============
; Bob downwards for a bit, waiting.	
Act_BeeHive_MoveD:
	; Move down at 0.125px/frame
	call ActS_MoveBySpeedY
	
	; Do so for 40 frames
	ldh  a, [hActCur+iActTimer]
	add  $01
	ldh  [hActCur+iActTimer], a
	cp   $28
	ret  nz
	
	; This is where the beehive and bee diverge.
	; Reset the hive's vertical speed, in preparation for dropping it on the ground.
	xor  a							; And sprite flags too
	ldh  [hActCur+iActSprMap], a
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_BeeHive_Drop ===============
; The beehive drops.
Act_BeeHive_Drop:
	; Continue falling down until hitting a solid block
	call ActS_ApplyGravityD_Coli
	ret  c
	
	; Once we do, immediately despawn the hive.
	xor  a
	ldh  [hActCur+iActId], a
	
	; Try to spawn five chibees around the hive.
	; These bees are what handle the hive explosion, as the hive itself has just despawned.
	ld   a, ACT_CHIBEE
	ld   bc, (-$10 << 8)|LOW(-$10)	; Top left		
	call ActS_SpawnRel
	ret  c
	ld   a, ACT_CHIBEE
	ld   bc, ($10 << 8)|LOW(-$10)	; Top right	
	call ActS_SpawnRel
	ret  c
	ld   a, ACT_CHIBEE
	ld   bc, (-$10 << 8)|$10	; Bottom left	
	call ActS_SpawnRel
	ret  c
	ld   a, ACT_CHIBEE
	ld   bc, ($10 << 8)|$10		; Bottom right	
	call ActS_SpawnRel
	ret  c
	ld   a, ACT_CHIBEE
	ld   bc, ($00 << 8)|$00		; Centered
	call ActS_SpawnRel
	ret
	
