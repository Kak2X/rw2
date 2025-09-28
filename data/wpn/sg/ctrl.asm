; =============== WpnCtrl_Sakugarne ===============
; Sakugarne.
; Useless pogo stick.
WpnCtrl_Sakugarne:
	xor  a
	ld   [wWpnUnlockMask], a
	ld   a, ACT_WPN_SG
	ld   [wActSpawnId], a
	call WpnCtrl_ChkSpawnHelper
	
	; If the player isn't riding the Sakugarne yet, don't do anything special.
	ld   a, [wWpnSGRide]
	or   a
	jp   z, WpnCtrl_Default
	
	;
	; When riding it and moving downwards, make the bottom of the Sakugarne deal damage.
	; This is done by attaching an invisible weapon shot with an hysterically small hitbox.
	; 
	ld   hl, wShot3		; Special purpose shot
	
	; If the player isn't falling, don't deal damage.
	ld   a, [wPlMode]
	cp   PL_MODE_FALL	; Is the player falling?
	jr   z, .dmg		; If so, jump
.noDmg:
	xor  a				; Despawn the shot
	ld   [hl], a
	ret
.dmg:
	; Spawn the shot
	ld   a, SHOT0_PROC|WPN_SG
	ldi  [hl], a		; iShotId
	xor  a
	ldi  [hl], a ; iShotWkTimer
	ldi  [hl], a ; iShotDir
	ldi  [hl], a ; iShotFlags
	
	; Centered to the player
	; XPos = PlX
	ldi  [hl], a ; iShotXSub
	ld   a, [wPlRelX]
	ldi  [hl], a ; iShotX
	
	; 4 pixels below the player
	; XPos = PlY + 4
	xor  a
	ldi  [hl], a ; iShotYSub
	ld   a, [wPlRelY]
	add  $04
	ldi  [hl], a ; iShotY
	
	; Use an invisible sprite
	ld   a, SHOTSPR_SG
	ldi  [hl], a ; iShotSprId
	
	; [POI] These are never used
	xor  a
	ldi  [hl], a ; iShot9
	ldi  [hl], a ; iShotA
	ldi  [hl], a ; iShotB
	ld   [hl], a ; iShotRealEnd
	ret
	
