; =============== Wpn_DoActColi ===============
; Checks a shot for collision against all actors.
Wpn_DoActColi:
	DEF tActCenterX = wActSpawnX
	DEF tActCenterY = wActSpawnY
	; Loop through all 16 actors
	xor  a		; Start from the first slot
.loop:
	; Prepare main slot pointer
	ld   d, HIGH(wAct)			; DE = Ptr to main slot (wAct)
	ld   e, a
	ld   [wActCurSlotPtr], a	; Save ptr for future use
	
	; Skip empty slots
	ld   a, [de]
	or   a						; iActId == 0?
	jr   z, .nextSlot			; If so, jump
	
	and  $FF^ACTF_PROC	; Save original actor ID (without flags) for future reference
	ld   [wTmpColiActId], a		; as it might get replaced with an explosion if it gets defeated.
	
	; Prepare collision data slot pointer.
	; This is exactly $100 bytes after DE.
	ld   h, HIGH(wActColi)		; HL = Ptr to respective wActColi entry
	ld   l, e
	
	;##
	;
	; BOUNDING BOX CHECKS
	;
	; In general, these are performed by calculating the distance between the actor and a shot,
	; then checking if it's less than the sum of their collision box radiuses.
	; If it is, the shot is overlapping with the actor on that particular axis.
	; The shot overlaps with the actor when the checks pass for both axes.
	; 
	; Since the actors and shots can potentially be at any position, for this to work the calculation
	; should be the same regardless of their relative position to each other. That is to say,
	; the origins of actors and shots should be perfectly centered, so that the distance between
	; the origin and its border alongside a specific axis will always be its respective bounding box radius.
	;
	; The horizontal origins are already centered and don't need adjusting, but the vertical ones for actors
	; (and the player) do, as they are at the bottom, so they need to be subtracted by the vertical radius.
	;
	
	
	;
	; HORIZONTAL BOUNDING BOX CHECK
	;

	; Set up fields
	ld   a, e					; DE = Ptr to iActX
	add  iActX
	ld   e, a
	ld   a, [wWpnColiBoxH]		; C = wWpnColiBoxH
	ld   c, a
	ldh  a, [hShotCur+iShotX]	; B = iShotX
	ld   b, a
	
	; Calculate the absolute distance
	ld   a, [de]				; A = iActX
	ld   [tActCenterX], a		; (Not used)
	sub  b						; Get distance (iActX - iShotX)
	jr   nc, .setDistX			; Is that a positive value? If so, skip
	xor  $FF					; Otherwise, convert to positive
	inc  a
	scf 
.setDistX:
	ld   b, a					; B = Distance
	; If the shot isn't horizontally overlapping with the collision box, seek to the next slot.
	ldi  a, [hl]				; Get actor radius (A = iActColiBoxH, seek to iActColiBoxV)
	add  c						; Sum with shot radius, that's the max distance (A += wWpnColiBoxH)
	cp   b						; MaxDistance - Distance < 0? (Distance > MaxDistance?)
	jr   c, .nextSlot			; If so, jump (not colliding, too far)
	
	;
	; VERTICAL BOUNDING BOX CHECK
	; 
	
	; Set up fields
	ld   a, [wWpnColiBoxV]		; C = wWpnColiBoxV
	ld   c, a
	ldh  a, [hShotCur+iShotY]	; B = iShotY
	ld   b, a
	inc  e ; iActYSub
	inc  e ; iActY
	
	; Calculate the absolute distance, like above
	ld   a, [de]				; A = iActY
	;--
	; The actor's origin is at the bottom of the sprite.
	; For the distance calculation, pretend it's centered by subtracting its vertical radius.
	sub  [hl]					; A -= iActColiBoxV
	ld   [tActCenterY], a		; Save centered value for a later check
	;--
	sub  b						; Get distance (iActY - iShotY)
	jr   nc, .setDistY			; Is that a positive value? If so, skip
	xor  $FF					; Otherwise, convert to positive
	inc  a
	scf
.setDistY:
	ld   b, a					; B = Distance
	; Do the bounds check
	ldi  a, [hl]				; A = iActColiBoxV, seek to iActColiType
	add  c						; A += wWpnColiBoxV
	cp   b						; MaxDistance - Distance >= 0? (Distance <= MaxDistance?)
	call nc, Wpn_OnActColi		; If so, we're in range. Handle collision.
								; Otherwise, seek to the next slot
	;##
.nextSlot:
	
	ld   a, [wActCurSlotPtr]	; A = Low byte of slot pointer
	add  iActEnd				; Next slot
	
	jr   nz, .loop				; Processed all 16 slots (overflowed back to $00?) If not, loop
	ret
	
; =============== Wpn_OnActColi ===============
; Handles collision for a shot against a specific actors.
; IN
; - HL: Ptr to the actor's collision type (iActColiType)
Wpn_OnActColi:

	;
	; Determine how to handle it depending on the actor's collision type.
	;
	ldi  a, [hl]				; A = iActColiType, seek to iActColiDamage
	; ACTCOLI_PASS and ACTCOLI_ENEMYPASS are completely intangible by shots.
	; Shots should pass through them, so return.
	cp   ACTCOLI_ENEMYHIT		; A < ACTCOLI_ENEMYHIT?
	ret  c						; If so, return
	; ACTCOLI_ENEMYHIT is for vulnerable enemies (can hit)
	jr   z, .typeEnemyHit		; A == ACTCOLI_ENEMYHIT? If so, jump
	; ACTCOLI_ENEMYREFLECT is for invulerable enemies (always deflect)
	cp   ACTCOLI_ENEMYREFLECT	; A == ACTCOLI_ENEMYREFLECT
	jp   z, .deflect
	; ACTCOLI_PLATFORM, ACTCOLI_MAGNET, ACTCOLI_ITEM and ACTCOLI_UNUSED_PASS2 are for special collisions not used by enemies.
	; ACTCOLI_UNUSED_PASS2 is unused and acts like a duplicate of ACTCOLI_PASS.
	; Shots pass through them.
	cp   ACTCOLI_8_START		; A < ACTCOLI_8_START?
	ret  c						; If so, return
	
; --------------- .typePartial ---------------
.typePartial:
	;
	; All types above ACTCOLI_UNUSED_PASS2 are used for "partially resistant" collision.
	; The collision type is treated as an offset relative to the vertical center of the actor.
	;
	; The actor will be damaged only if the shot's position is below that point.
	;
	; Used by Quint, the final boss and Pickelman Bull.
	;
	
	; B = Absolute threshold point (relative to the screen)
	ld   b, a				; B = Relative thresold value (iActColiType)
	ld   a, [tActCenterY]	; A = Actor's Y position
	add  b					; ActPos += Rel, to get the actual threshold
	ld   b, a
	
	; If you shoot anywhere below that point, deflect it
	ldh  a, [hShotCur+iShotY]	; A = iShotY
	cp   b						; iShotY >= Threshold?
	jp   nc, .deflect			; If so, it's deflected
	
	; Otherwise, deal damage
	
; --------------- .typeEnemyHit ---------------
.typeEnemyHit:
	
	; If the actor has mercy invincibility, ignore the collision.
	; [POI] Unlike other games, the shot does not get despawned when this happens
	;       which is the reason rapid-fired shots may pass through enemies.
	inc  l ; iActColiHealth
	inc  l ; iActColiInvulnTimer
	ldd  a, [hl]	; A = iActColiInvulnTimer, seek to iActColiHealth
	or   a			; Invuln != 0?
	ret  nz			; If so, return
	
	
	push hl
		;
		; Determine how weak the actor is to the weapon shot.
		;
		; This data is stored from the 6th byte of a ActS_ColiTbl entry, roughly
		; ordered by weapon ID.
		; To save space, this data isn't *exactly* in the same order as WPN_*, 
		; as it skips over weapons that can't do damage like the items.
		;
		; Therefore, first calculate the weapon index relative to the 6th byte.
		;
		
		; There's a special case with the Sakugarne item, since the player can fire normal shots when not riding it.
		; Those shots should not count as Sakugarne shots.
		ld   a, [wWpnId]
		cp   WPN_SG				; Sakugarne selected?
		jr   nz, .idxSubItems	; If not, jump
		ld   a, [wWpnSGRide]
		or   a					; Actually riding it?
		jr   z, .idxUseDefault	; If not, treat it as the default weapon
		; Otherwise, use the Sakugarne index.
		; + 3 to balance out the - 3 below
		; - iRomActColiDmgP to balance out the base index added later
		ld   a, iRomActColiDmgSg - iRomActColiDmgP + 3
	.idxSubItems:
		; The three items are skipped and shift almost all entries up by 3.
		; If we were using a default weapon or Rush (IDs 0 to 3), this will cause the index
		; to either fall back to 0 (P Shooter), or underflow.
		; If it underflowed, fall back to the P Shooter entry too.
		; This which works out, given Rush forms allow to fire normal shots in some way or another.
		sub  $03				; A -= 3
		jr   nc, .calcColiIdx	; Underflowed? If not, skip
	.idxUseDefault:
		xor  a ; iRomActColiDmgP - iRomActColiDmgP
	.calcColiIdx:
		ld   e, a				; E = Struct index (- iRomActColiDmgP)
		
		; Seek to the value we're looking for in the actor collision table.
		; Each entry is $10 bytes long, so:
		; BC = (wTmpColiActId * $10) + iRomActColiDmgP + E
		ld   a, [wTmpColiActId]
		ld   c, a
			swap a		; B = wTmpColiActId >> 4
			and  $0F
			ld   b, a
		ld   a, c		
		swap a			; A = wTmpColiActId << 4
		and  $F0
		or   iRomActColiDmgP	; From first weapon entry
		add  e			; Add the struct index
		ld   c, a		; Save to C
		
		; Read the byte to wWpnActDmg
		ld   hl, ActS_ColiTbl
		add  hl, bc
		push af
			ld   a, BANK(ActS_ColiTbl) ; BANK $03
			ldh  [hROMBank], a
			ld   [MBC1RomBank], a
		pop  af
		ld   a, [hl]
		ld   [wWpnActDmg], a
		push af
			ldh  a, [hROMBankLast] ; Back to BANK $01
			ldh  [hROMBank], a
			ld   [MBC1RomBank], a
		pop  af
		
	pop  hl
	
	; If this weapon deals zero damage to the actor (enemy is immune to it), deflect the shot.
	ld   a, [wWpnActDmg]
	or   a					; wWpnActDmg == 0?
	jp   z, .deflect			; If so, deflect it
	ld   b, a				; B = Damage dealt
	
	;--
	;
	; The Sakugarne always rebounds on contact with another enemy.
	; This same exact check will be repeated other times, such as when the enemy is immune,
	; with the same result.
	;
	ld   a, e				; A = Struct index
	cp   iRomActColiDmgSg - iRomActColiDmgP	; Pointing to the Sakugarne?
	jr   nz, .decHealth		; If not, skip
	; Otherwise, do a jump at 2px/frame
	ld   a, $00
	ld   [wPlSpdYSub], a
	ld   a, $02
	ld   [wPlSpdY], a
	ld   a, PL_MODE_FULLJUMP
	ld   [wPlMode], a
	;--
.decHealth:

	; Deal damage to the actor.
	ld   a, [hl]			; A = iActColiHealth (Enemy health)
	sub  b					; Subtract the damage inflicted
	jr   z, .actDead		; If the enemy has no health left, jump
	jr   c, .actDead		; Same it if has underflowed
	
; --------------- .actHit ---------------
.actHit:
	ldi  [hl], a			; Save back the updated health to iActColiInvulnTimer, seek to iActColiInvulnTimer
	ld   [wBossHealth], a	; Set this one in case we're in the boss room
	push hl
		; When the actor survives the hit, despawn the shot if doesn't fully pierce
		ld   a, [wWpnPierceLvl]
		cp   WPNPIERCE_ALWAYS	; Does this weapon always pierce? (wWpnPierceLvl >= 2)
		jr   nc, .actHitTp		; If so, skip
		xor  a					; Otherwise, despawn the shot
		ldh  [hShotCur+iShotId], a
	.actHitTp:
		
		; If we're using Top Spin, use up ammo on contact.
		; This is only the case with bosses, as enemies are set to either die in 1 hit (.actDead),
		; or completely resist the attack.
		ld   a, [wWpnId]
		cp   WPN_TP
		call z, WpnS_UseAmmo
		

	; Give 12 frames of mercy invincibility to non-boss enemies.
	; This is a bit excessive, although keep in mind the flashing animation is directly tied to this invulerability period.
	pop  hl
	ld   [hl], $0C	; iActColiInvulnTimer = $12
	
	; Play hit sound
	ld   c, SFX_ENEMYHURT
	mPlaySFX
	
	;
	; If we hit a boss, make that invulnerability period last longer,
	; and also redraw the status bar.
	;
	
	; For performance, boss damage checks aren't always enabled
	ld   a, [wBossDmgEna]
	or   a
	ret  z
	
	; Check for the actor ID ranges used by bosses
	ld   a, [wTmpColiActId]
	; Final bosses in range $50-$53 (Quint and the three Wily Machine forms) 
	cp   ACT_SPECBOSS_START		; ID < $50?
	ret  c						; If so, return
	cp   ACT_SPECBOSS_END		; ID < $54?
	jr   c, .bossHit			; If so, jump
	; Main bosses in range $68-$6F
	cp   ACT_BOSS_START			; ID < $68?
	ret  c						; If so, return
	cp   ACT_BOSS_END			; ID >= $70?
	ret  nc						; If so, return
.bossHit:
	; Half a second of mercy invulerability
	ld   [hl], $1E				; iActColiInvulnTimer = $1E
	
	; Redraw the boss' health bar.
	; This boss health value, unlike most others, is measured in bars and not in units of health.
	; wBossHealthBar expects the latter, so...
	ld   a, [wBossHealth]		; Get units of health
	add  a						; A *= 8, as each bar is worth 8 units
	add  a
	add  a
	ld   [wBossHealthBar], a	; Set bar redraw value
	ld   hl, wStatusBarRedraw	; Trigger redraw
	set  BARID_BOSS, [hl]
	ret
	
; --------------- .actDead ---------------
.actDead:
	; When the actor dies from the hit, despawn the shot only if never pierces.
	; This allows shots that only pierce when the actor dies to pass through.
	ld   a, [wWpnPierceLvl]
	cp   WPNPIERCE_LASTHIT	; wWpnPierceLvl >= $01? (wWpnPierceLvl != WPNPIERCE_NONE)
	jr   nc, .actDeadTp		; If so, skip
	xor  a					; Otherwise, despawn the shot
	ldh  [hShotCur+iShotId], a
	
.actDeadTp:
	; Top Spin uses up ammo on successful contact
	; (and only when it destroys the enemy, which it did if we got here)
	ld   a, [wWpnId]
	cp   WPN_TP
	call z, WpnS_UseAmmo
	
	;
	; Convert the defeated actor into an explosion.
	; The explosion actor will make use of the inherited properties
	; to position itself to the center of its collision box.
	;
	
	ld   h, HIGH(wAct)			; HL = Ptr to actor slot
	ld   a, [wActCurSlotPtr]
	ld   l, a
	
	; Replace ID with the explosion one
	ld   a, ACTF_PROC|ACT_EXPLSM
	ldi  [hl], a ; iActId
	
	xor  a
	ldi  [hl], a ; iActRtnId
	ldi  [hl], a ; iActSprMap
	
	; Make the actor intangible, as explosions shouldn't damage the player.
	ld   h, HIGH(wActColi)		; HL = Ptr to respective collision entry
	ld   a, [wActCurSlotPtr]
	ld   l, a
	
	inc  l ; iActColiBoxV
	inc  l ; iActColiType
	xor  a
	ld   [hl], a				; Set ACTCOLI_PASS
	
	;
	; If the actor we just defeated was a boss.
	; These are nearly the same checks used for .bossHit
	;

	; For performance, boss damage checks aren't always enabled.
	; If they aren't, roll the dice and try to spawn an item.
	ld   a, [wBossDmgEna]
	or   a
	jp   z, ActS_TrySpawnItemDrop
	;--
	
	; Check for the actor ID ranges used by bosses
	ld   a, [wTmpColiActId]
	; Final bosses in range $50-$53 (Quint and the three Wily Machine forms) 
	; [POI] Quint never has wBossDmgEna enabled, so we'll never get there.
	cp   ACT_SPECBOSS_START		; ID < $50?
	ret  c						; If so, return
	cp   ACT_SPECBOSS_END		; ID < $54?
	jr   c, .bossDead			; If so, jump
	; Main bosses in range $68-$6F
	cp   ACT_BOSS_START			; ID < $68?
	ret  c						; If so, return
	cp   ACT_BOSS_END			; ID >= $70?
	ret  nc						; If so, return
	
.bossDead:
	; In case of a double KO, do not trigger the boss' explosion animation as it'd give the victory to the player.
	; However, still hide the health bar as the boss was converted to an explosion actor already.
	ld   a, [wLvlEnd]
	cp   LVLEND_PLDEAD			; Player has exploded already?
	jr   z, .bossClrBar			; If so, skip
	
	; The explosions should originate from the center of the boss.
	; As bosses are generally the same height as the player, and also have their
	; origin at the bottom, the player's radius can be reused to get to the center.
	ld   h, HIGH(wAct)		; HL = Ptr to slot's iActX
	ld   a, [wActCurSlotPtr]
	add  iActX
	ld   l, a
	ld   a, [hl]			; X Origin = Actor's X origin (middle)
	ld   [wExplodeOrgX], a
	inc  l ; iActYSub
	inc  l ; iActY
	ld   a, [hl]			; Y Origin = Actor's Y origin (bottom)
	sub  PLCOLI_V			; More or less move up to middle
	ld   [wExplodeOrgY], a
	
	; And trigger it
	ld   a, LVLEND_BOSSDEAD
	ld   [wLvlEnd], a
	
.bossClrBar:
	; Draw an health bar with no energy left.
	xor  a
	ld   [wBossHealthBar], a
	ld   hl, wStatusBarRedraw
	set  BARID_BOSS, [hl]
	ret
	
; --------------- .deflect ---------------
; The shot dealt no damage.
; Most weapons just get their shots deflected, a few have special handling though.
.deflect:
	;
	; Top Spin continues as normal if an enemy resistant to it is hit.
	; Chances are the player gets hit when this happens, due to the player's collision box
	; being barely covered by Top Spin's.
	;
	ld   a, [wWpnId]
	cp   WPN_TP				; Using Top Spin?
	jr   nz, .deflectCr		; If not, jump
	; At least no weapon ammo is consumed.
	ld   c, SFX_SCOREEND
	mPlaySFX
	ret
.deflectCr:
	;
	; Crash Bombs explode on contact against a resistant enemy.
	;
	cp   WPN_CR				; Using Crash Bombs?
	jr   nz, .deflectSg		; If not, jump
	
	ldh  a, [hShotCur+iShotWkTimer]
	bit  SHOTCRB_EXPLODE, a			; Is it exploding already?
	ret  nz							; If so, return
	ld   a, SHOTCR_EXPLODE			; Otherwise, overwrite the timer to point
	ldh  [hShotCur+iShotWkTimer], a	; to the start of the explosion phase
	ret
	
.deflectSg:
	;
	; As before, the Sakugarne always rebounds on contact with another enemy.
	;
	ld   a, [wWpnSGRide]
	or   a					; Riding the Sakugarne?
	jr   z, .deflectNorm	; If not, jump
	; Do jump at 2px/frame
	ld   a, $00
	ld   [wPlSpdYSub], a
	ld   a, $02
	ld   [wPlSpdY], a
	ld   a, PL_MODE_FULLJUMP
	ld   [wPlMode], a
	; Play deflect sound
	ld   c, SFX_SCOREEND
	mPlaySFX
	ret
	
.deflectNorm:
	;
	; Any other weapon gets deflected as normal.
	;
	
	; Reset timer
	xor  a
	ldh  [hShotCur+iShotWkTimer], a
	; Mark the shot as being deflected
	ldh  a, [hShotCur+iShotFlags]
	or   SHOT3_DEFLECT
	ldh  [hShotCur+iShotFlags], a
	; Play respective sound
	ld   c, SFX_SCOREEND
	mPlaySFX
	ret
	
