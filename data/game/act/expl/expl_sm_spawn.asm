; =============== ActS_ChkExplodeWithChild ===============
; Checks if the actor has been defeated, and if so, makes it explode alongside its child.
;
; Used for actors that directly spawn a single child actor that work together.
; (ie: defeating a bee that's carrying a beehive should also despawn the latter)
;
; This cannot be used when there is more than one child actor at play, such as with Blocky's 
; 3 invulnerable sections, so those must handle it manually.
;
; OUT
; - C Flag: If set, the actor exploded
ActS_ChkExplodeWithChild:

	; Actors that keep track of a child slot die when their health reaches $10, not $00.
	; This is because actor health is decremented by the weapon shot collision code,
	; but that does not account for child actors, so if we used the normal thresold of $00,
	; only the parent would have died.
	; Which works for us, given actors that call ActS_ChkExplodeWithChild are assumed to be
	; those that perform special actions on death, and are given $10 more health for it.
	
	; The leads into the assumption that no weapon should deal more than 16 damage to these actors.

	call ActS_GetHealth
	cp   $11					; Health >= $11?
	ret  nc						; If so, return
	call ActS_Explode			; Otherwise, blow it up
	call ActS_TrySpawnItemDrop	; and maybe drop some items
	
	; Also despawn the child actor, but without showing an explosion.
	ld   h, HIGH(wAct)			; HL = Ptr to child slot
	ldh  a, [hActCur+iActChildSlotPtr]
	ld   l, a
	xor  a
	ldi  [hl], a ; wActId		; Despawn the actor
	
	;##
	; This part doesn't affect anything, as despawning the actor means it won't get drawn or executed.
	
	ldi  [hl], a ; iActRtnId
	ldi  [hl], a ; iActSprMap, seek to iActLayoutPtr
	
	; Move the child actor 4px above 
	ld   a, l					; Seek to iActY
	add  iActY-iActLayoutPtr
	ld   l, a
	ld   a, [hl]				; iActY -= 4
	sub  $04
	ld   [hl], a
	;##
	
	scf							; C Flag = Set
	ret
	
; =============== ActS_ChkExplodeNoChild ===============
; Variation of ActS_ChkExplodeWithChild used when the child actor doesn't need
; to be affected by the parent's death anymore, or when the actor needs to perform
; code on death, that otherwise wouldn't be executed with the normal death routine.
;
; This exists due to the health value still accounting for the $10 threshold.
;
; OUT
; - C Flag: If set, the actor exploded
ActS_ChkExplodeNoChild:
	call ActS_GetHealth
	cp   $11					; Health >= $11?
	ret  nc						; If so, return
	call ActS_Explode			; Otherwise, blow it up
	call ActS_TrySpawnItemDrop	; and maybe drop some items
	scf							; C Flag = Set
	ret
	
; =============== ActS_Explode ===============
; Makes the current actor explode.
; Specifically, it converts the currently processed actor into an explosion,
; using equivalent code to what Wpn_OnActColi.actDeadTp does.
ActS_Explode:
	; Replace ID with the explosion one
	ld   a, ACTF_PROC|ACT_EXPLSM
	ldh  [hActCur+iActId], a
	
	xor  a
	ldh  [hActCur+iActRtnId], a
	ldh  [hActCur+iActSprMap], a
	
	; Make the actor intangible, as explosions shouldn't damage the player.
	ld   h, HIGH(wActColi)		; HL = Ptr to respective collision entry
	ld   a, [wActCurSlotPtr]
	ld   l, a
	
	inc  l ; iActColiBoxV
	inc  l ; iActColiType
	xor  a
	ld   [hl], a				; Set ACTCOLI_PASS
	ret
	
