; =============== ActS_TrySpawnItemDrop ===============
; Spawns a random item drop from the current actor's location, if any.
ActS_TrySpawnItemDrop:
	call Rand			; Roll the dice
	
	; $4D-$FF: Nothing (~70%)
	cp   $4D			; A >= $4D?
	ret  nc				; If so, don't spawn anything
	
	; The order of the actor IDs directly influences their rarity.
	; The lower its ID, the rarer it is.
	
	; $26-$4C: Small Weapon Energy (~15%)
	ld   b, ACT_AMMOSM
	cp   $26
	jr   nc, .spawn
	
	; $0A-$25: Large Life Energy (~11%)
	dec  b ; ACT_HEALTHSM
	cp   $0A
	jr   nc, .spawn
	
	; $06-$09: Large Life Energy (~1.5%)
	dec  b ; ACT_HEALTHLG
	cp   $06
	jr   nc, .spawn
	
	; $03-$05: Large Weapon Energy (~1%)
	dec  b ; ACT_AMMOLG
	cp   $03
	jr   nc, .spawn
	
	; $00-$02: Extra Life (~1%)
	dec  b ; ACT_1UP
	
.spawn:
	ld   a, b
	ld   [wActSpawnId], a
	
	xor  a							; Not part of the actor layout
	ld   [wActSpawnLayoutPtr], a
	
	; Spawn the item at the same position of the current actor (which we just defeated)
	; Note that the actor code (Act_Item) will move it slightly above that location,
	; to make it closer to the center of the explosion.
	; A more accurate way would have been to offset wActSpawnY here, since we still
	; have the actor's collision radius at hand.
	ld   h, HIGH(wAct)			; Seek HL to iActX
	ld   a, [wActCurSlotPtr]
	add  iActX
	ld   l, a
	ldi  a, [hl]				; wActSpawnX = iActX
	ld   [wActSpawnX], a
	inc  l
	ld   a, [hl]				; wActSpawnY = iActY
	ld   [wActSpawnY], a
	
	call ActS_Spawn				; Did it spawn?
	ret  c						; If not, return
	
	; Items by default spawn as fixed collectables.
	; Make them item drops instead.
	inc  l ; iActRtnId
	ld   a, ACTRTN_ITEMDROP_INIT
	ld   [hl], a
	ret
	
