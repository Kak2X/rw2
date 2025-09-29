; =============== WpnCtrl_LeafShield ===============
; Leaf Shield.
; Four leaves that rotate around the player and can never be destroyed (but can be deflected).
WpnCtrl_LeafShield:
	ld   a, WPU_WD
	ld   [wWpnUnlockMask], a
	
	; Return if not pressing B
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; Leaf Shield is made up of four leaves, each being its own individual shot.
	; This is necessary since each leaf can get deflected without affecting the others.
	; Only spawn a new shield if all of the leaves are despawned.
	ld   hl, wShot0
	ld   a, [hl]
	ld   hl, wShot1
	or   [hl]
	ld   hl, wShot2
	or   [hl]
	ld   hl, wShot3
	or   [hl]
	jp   nz, WpnCtrlS_End
	
	; Don't spawn if there isn't enough ammo
	call WpnS_HasAmmoForShot
	jp   c, WpnCtrlS_End
	
	; Use up ammo when throwing the shield
	ld   a, $01
	ld   [wWpnWdUseAmmoOnThrow], a
	
	;
	; Spawn the four leaves.
	;
	ld   c, $04			; C = Leaves left
	ld   hl, wShot0		; From the first slot...
.loop:
	ld   a, SHOT0_PROC|WPN_WD
	ldi  [hl], a ; iShotId
	
	; iShotWkTimer = C - 1
	ld   a, c
	dec  a
	ldi  [hl], a ; iShotWkTimer
	
	; Direction is irrelevant until the shield is thrown
	inc  hl ; iShotDir
	
	; Not deflected
	xor  a
	ldi  [hl], a ; iShotFlags
	
	; Place the shield at the center of the player
	ldi  [hl], a ; iShotX
	ld   a, [wPlRelX]
	ldi  [hl], a ; iShotX
	xor  a
	ldi  [hl], a ; iShotYSub
	ld   a, [wPlRelY]
	sub  PLCOLI_V-1
	ldi  [hl], a ; iShotY
	
	; Set sprite
	ld   [hl], SHOTSPR_WD ; iShotSprId
	
	; Seek to next slot
	ld   a, l
	and  $F0
	add  iShotEnd
	ld   l, a
	
	dec  c			; Spawned all leaves?
	jr   nz, .loop	; If not, loop
	jp   WpnCtrlS_StartShootAnim
	
