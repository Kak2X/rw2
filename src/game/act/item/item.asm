; =============== Act_Item ===============
; ID: ACT_1UP, ACT_AMMOLG, ACT_HEALTHLG, ACT_HEALTHSM, ACT_AMMOSM, ACT_ETANK
; Collectable Items.
; While these use the same actor code, their effects when collected by the player
; are handled separately by Pl_DoActColi.coliItem, which goes off their actor ID.
Act_Item:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_ItemFixed_Anim
	dw Act_ItemDrop_Init
	dw Act_ItemDrop_MoveU
	dw Act_ItemDrop_MoveD
	dw Act_ItemDrop_InitGround
	dw Act_ItemDrop_Ground
	dw Act_ItemDrop_Flash
	
; =============== Act_ItemFixed_Anim ===============
; Item directly part of the level, never despawns over time.
; This is the first routine since actors defined in the actor layout
; *always* spawn in their first routine, no exceptions.
Act_ItemFixed_Anim:
	; Every item has the same 2-frame animation, at 1/8 speed.
	; Those that don't animate, like E-Tanks, merely repeat the same two frames.
	ld   c, $01
	call ActS_Anim2
	ret
	
; =============== Act_ItemDrop_* ===============
; The rest of these routines are used to handle item drops from defeated enemies,
; which are spawned through ActS_TrySpawnItemDrop.
; These items fall down until they hit a solid block (but not actor platforms,
; for performance reasons) and despawn after some amount of time.
	
; =============== Act_ItemDrop_Init ===============
Act_ItemDrop_Init:
	;--
	; Try to move the actor a bit closer to the explosion.
	; This is the same thing done in Act_ExplSm_Init, except here it's not exactly accurate
	; given iActColiBoxV isn't inherited.
	ld   h, HIGH(wActColi)		; Seek HL to iActColiBoxV, vertical radius
	ld   a, [wActCurSlotPtr]
	ld   l, a
	inc  l ; iActColiBoxV
	ldh  a, [hActCur+iActY]		; Move the actor up by that
	sub  [hl]
	ldh  [hActCur+iActY], a
	;--
	ld   c, $01
	call ActS_Anim2
	ld   bc, $0300				; 3px/frame upwards speed
	call ActS_SetSpeedY
	ld   b, $00					; Cannot collect it while moving up
	call ActS_SetColiType
	jp   ActS_IncRtnId			; Next mode
	
; =============== Act_ItemDrop_MoveU ===============
; Move upwards until it hits a ceiling, reach the peak of the jump, or are near the top of the screen.
; The item can't be collected during this.
Act_ItemDrop_MoveU:
	ld   c, $01
	call ActS_Anim2
	
	;--
	; If our current speed would move us near the top of the screen, cut the jump
	ldh  a, [hActCur+iActSpdYSub]	; BC = Y Speed
	ld   c, a
	ldh  a, [hActCur+iActSpdY]
	ld   b, a
	ldh  a, [hActCur+iActYSub]		; Set carry from iActYSub - C
	sub  c
	ldh  a, [hActCur+iActY]			; A = iActY - B - carry
	sbc  b
	and  $F0						; Check block row range
	cp   $00						; Are we in the top row? ($00-$0F)
	jr   z, .setMoveD				; If so, cut the jump
	;--
	call ActS_ApplyGravityU_Coli		; Otherwise, apply gravity
	ret  c							; Did we move anywhere? If so, return
.setMoveD:							; Otherwise, we hit a solid block or gravity set our speed to 0
	ld   b, ACTCOLI_ITEM			; Make item tangible as it moves down
	call ActS_SetColiType
	jp   ActS_IncRtnId
	
; =============== Act_ItemDrop_MoveD ===============
; The item moves down.
Act_ItemDrop_MoveD:
	ld   c, $01
	call ActS_Anim2
	call ActS_ApplyGravityD_Coli	; Apply gravity
	ret  c							; Hit a solid block? If not, return
	jp   ActS_IncRtnId
	
; =============== Act_ItemDrop_InitGround ===============
; Prepares the item to be on the ground.
Act_ItemDrop_InitGround:
	ld   c, $01
	call ActS_Anim2
	ld   a, 3*60					; 3 seconds before flashing
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_ItemDrop_Ground ===============
; Item is on the ground.
; Once on the ground, it won't check for collision anymore.
Act_ItemDrop_Ground:
	ld   c, $01
	call ActS_Anim2
	
	ldh  a, [hActCur+iActTimer]	; Wait those 3 seconds
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	ld   a, 2*60					; 2 seconds before despawning
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_ItemDrop_Flash ===============
; Item is fading out.
Act_ItemDrop_Flash:
	; For this part, extend the animation to 3 frames, at 1/4 speed.
	; This third frame is fully blank, giving the effect of the item fading out.
	ld   bc, ($03 << 8)|$02			; B = 3 frames, C = 2/8 speed
	call ActS_AnimCustom
	
	ldh  a, [hActCur+iActTimer]	; Wait those 2 seconds
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	xor  a							; Despawn
	ldh  [hActCur+iActId], a
	ret
	
