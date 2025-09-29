; =============== Act_Bee ===============
; ID: ACT_BEE
; Giant bee carrying a beehive coming from behind, which it drops
; on the ground to spawn many smaller bees.
Act_Bee:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Bee_InitChild
	dw Act_Bee_InitPath
	dw Act_Bee_MoveToTarget
	dw Act_Bee_MoveU
	dw Act_Bee_MoveD
	dw Act_Bee_FlyAway

; =============== Act_Bee_InitChild ===============
; Spawns the beehive.
Act_Bee_InitChild:
	; Spawn the child beehive directly below.
	; If the beehive couldn't spawn, don't continue and try again next frame.
	ld   a, ACT_BEEHIVE
	ld   bc, ($00 << 8)|$0C		; 12px below
	call ActS_SpawnRel			; Could it spawn?
	ret  c						; If not, return
	
	; Keep track of the slot the beehive spawned into.
	; By convention, tracked child slots are written into iAct0D/iActChildSlotPtr,
	; as some shared helper subroutines expect it to be there.
	ld   a, l
	ldh  [hActCur+iActChildSlotPtr], a
	jp   ActS_IncRtnId
	
; =============== Act_Bee_InitPath ===============
; Sets up the bee's initial horizontal path.
Act_Bee_InitPath:
	call ActS_ChkExplodeWithChild	; Did we defeat the bee?
	ret  c							; If so, return (bee and beehive despawned)
									; Otherwise...
	ld   c, $02				; Animate wings at 1/4
	call ActS_Anim2
	call ActS_FacePl		; Move towards the player
	
	; Set the 2px/frame forward speed, will be used immediately
	ld   bc, $0200			; 2px/frame forward
	call ActS_SetSpeedX
	
	; Set for later a 0.125px/frame vertical speed, it will be used
	; when the bee bobs when it's about to drop the hive
	ld   bc, $0020
	call ActS_SetSpeedY
	
	;
	; Set the target position for the bee, it will stop moving when it's reached.
	;
	; The bee will pick the opposite side of the screen while coming from behind,
	; to try place itself in front of the player at the time of this check.
	; Since the target is relative to the screen, attempting to outrun the bee
	; will move the target with it.
	; 
	ld   b, OBJ_OFFSET_X+$08						; B = 0-16 pixels from the left edge
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a								; Facing right?
	jr   z, .setTarget								; If not, jump (if facing left, the bee spawned on the right)
	ld   b, OBJ_OFFSET_X+SCREEN_GAME_H-BLOCK_H-$08	; B = 0-16 pixels from the right edge (bee spawned on the left)
.setTarget:
	ld   a, b
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId

; =============== Act_Bee_MoveToTarget ===============
; Move horizontally until it reaches the target.
Act_Bee_MoveToTarget:
	call ActS_ChkExplodeWithChild
	ret  c
	
	ld   c, $02	
	call ActS_Anim2
	
	; Move forward at 2px/frame
	call ActS_MoveBySpeedX
	
	; If we didn't reach the target yet, return.
	ldh  a, [hActCur+iActX]			; Get bee position
	and  $F0						; Check 16px wide range to avoid missing the pixel (clear low nybble)
	ld   b, a
	ldh  a, [hActCur+iActTimer]		; Get target
	and  $F0						; Check 16px ...
	cp   b							; Do the ranges match?
	ret  nz							; If not, return
	
	; Target reached, turn the other side (the player) and wait for a bit
	call ActS_FlipH
	ld   a, $00
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Bee_MoveU ===============
; Bob upwards for a bit, waiting.	
Act_Bee_MoveU:
	call ActS_ChkExplodeWithChild
	ret  c
	ld   c, $02
	call ActS_Anim2
	
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
	
; =============== Act_Bee_MoveD ===============
; Bob downwards for a bit, waiting.	
Act_Bee_MoveD:
	call ActS_ChkExplodeWithChild
	ret  c
	ld   c, $02
	call ActS_Anim2
	
	; Move down at 0.125px/frame
	call ActS_MoveBySpeedY
	
	; Do so for 40 frames
	ldh  a, [hActCur+iActTimer]
	add  $01
	ldh  [hActCur+iActTimer], a
	cp   $28
	ret  nz
	
	; Flip back to its original direction
	call ActS_FlipH
	jp   ActS_IncRtnId
	
; =============== Act_Bee_FlyAway ===============
; Move the bee horizontally in the same horizontal direction 
; from Act_Bee_MoveToTarget until it gets offscreened.
; Act_BeeHive is manually timed to drop itself during this mode.
Act_Bee_FlyAway:
	ld   c, $02
	call ActS_Anim2
	; Move forward at 2px/frame
	call ActS_MoveBySpeedX
	ret
	
