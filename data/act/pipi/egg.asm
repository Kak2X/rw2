; =============== Act_Egg ===============
; ID: ACT_EGG
; Egg carried/dropped by Pipi.
Act_Egg:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Egg_Init
	dw Act_Egg_MoveH
	dw Act_Egg_MoveHChkDrop
	dw Act_Egg_FallV

; =============== Act_Egg_Init ===============
Act_Egg_Init:
	; Move towards the player (same direction as the bird)
	call ActS_FacePl
	
	; Move at the same speed as the bird (0.75px/frame)
	ld   bc, $00C0
	call ActS_SetSpeedX
	
	; When dropped, start falling at 0.75px/frame too
	ld   bc, $00C0
	call ActS_SetSpeedY
	ldh  a, [hActCur+iActSprMap]
	or   ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	xor  a
	ldh  [hActCur+iEggBirdDead], a
	
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Egg_MoveH ===============
; Egg carried by the bird. Move horizontally, don't drop.
; Gives a ~1 second window after it gets spawned where the Egg can't drop.
; This prevents the egg from being dropped into walls at the side of 
; the screen, if any are there.
Act_Egg_MoveH:
	; Move the egg to sync itself with the bird.
	
	call ActS_ApplySpeedFwdX
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	jp   z, ActS_IncRtnId			; Timer elapsed? If so, jump
	
	; If the bird has died, also destroy the egg since it's still being carried.
	ldh  a, [hActCur+iEggBirdDead]
	and  a
	ret  z
	jp   ActS_Explode
	
; =============== Act_Egg_MoveHChkDrop ===============
; Egg carried by the bird. Move horizontally, check for drop.
Act_Egg_MoveHChkDrop:
	; Move horizontally until the egg gets within 3 blocks of the player.
	call ActS_ApplySpeedFwdX
	call ActS_GetPlDistanceX
	cp   $30					; Distance < $30?
	jp   c, ActS_IncRtnId		; If so, jump
	
	; If the bird has died, also destroy the egg since it's still being carried.
	ldh  a, [hActCur+iEggBirdDead]
	and  a
	ret  z
	jp   ActS_Explode
	
; =============== Act_Egg_FallV ===============
; Egg was dropped by the bird.
; From this point, shooting the bird won't affect the egg.
Act_Egg_FallV:
	; Apply gravity at 0.75px/frame
	call ActS_ApplySpeedFwdYColi
	
	; If the egg fell offscreen, despawn it
	ldh  a, [hActCur+iActY]
	cp   SCREEN_GAME_V+OBJ_OFFSET_Y+$0C
	jp   nc, .despawn
	
	;
	; Wait until it hits a solid block.
	; When that happens, explode and spawn six small birds.
	;
	call Lvl_GetBlockId
	ret  c
	
	ld   de, Act_Egg_CopipiSpreadTbl	; HL = Properties
	ld   b, $06				; B = Actors left
.loop:
	push bc ; Save remaining birds
	
		;
		; Spawn the bird exactly at the egg's position.
		;
		
		; HL = Ptr to Act_Copipi's slot
		push de
			ld   a, ACT_COPIPI
			ld   bc, $0000
			call ActS_SpawnRel
		pop  de
		
		inc  hl ; iActRtnId
		inc  hl ; iActSprMap
		
		; Reset their directions.
		; Doing this makes the speed defined in Act_Egg_CopipiSpreadTbl a bit misleading 
		; (ie: negative h speed moves right), so it's not clear why it's like this.
		ld   a, [hl]
		and  $FF^(ACTDIR_R|ACTDIR_D)
		ld   [hl], a
		
		;
		; Each bird has its own *initial* movement speed, used exclusively to show them
		; spreading out from the egg in a formation.
		; 
		; Copy the speed properties from the table.
		;
		
		; Seek to iActSpdXSub
		ld   a, iActSpdXSub-iActSprMap
		ld   b, $00
		ld   c, a
		add  hl, bc
		
		ld   a, [de]	; iActSpdXSub = byte0
		ld   [hl], a
		inc  hl
		inc  de
		ld   a, [de]	; iActSpdX = byte1
		ld   [hl], a
		inc  hl
		inc  de
		ld   a, [de]	; iActSpdYSub = byte2
		ld   [hl], a
		inc  hl
		inc  de
		ld   a, [de]	; iActSpdY = byte3
		ld   [hl], a
		inc  de			; Seek to byte0 of next entry
	pop  bc 		; Get remaining birds to spawn
	dec  b			; Have all spawned?
	jr   nz, .loop	; If not, loop
	; Finally, visibly explode
	jp   ActS_Explode
.despawn:
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
; =============== Act_Egg_CopipiSpreadTbl ===============
; Initial Speed for each spawned Copipi.
; Note that due to the bird's direction being forced into UP/LEFT, signs work the other way around.
Act_Egg_CopipiSpreadTbl:
	;       X       Y
	dw +$0000, -$00FF ; $00 ;                       ~1px/frame down
	dw -$00B4, +$00B4 ; $01 ; ~0.7px/frame right, ~0.7px/frame up 
	dw -$00FF, +$0000 ; $02 ;   ~1px/frame right
	dw +$0000, +$00FF ; $03 ;                       ~1px/frame up
	dw +$00FF, +$0000 ; $04 ;   ~1px/frame left
	dw +$00B4, +$00B4 ; $05 ; ~0.7px/frame left,  ~0.7px/frame up 

