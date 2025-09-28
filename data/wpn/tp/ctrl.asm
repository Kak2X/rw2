; =============== WpnCtrl_TopSpin ===============
; Top Spin.
; Melee weapon activated in the air.
WpnCtrl_TopSpin:
	ld   a, WPU_TP
	ld   [wWpnUnlockMask], a
	
	; Top Spin is activated by pressing B in the air.
	; It will then stay active for the remainder of the jump.
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a				; Pressed B?
	jp   z, WpnCtrlS_End			; If not, return
	
	; Only allowed when the player is in the air ($01-$03)
	; (PL_MODE_JUMP, PL_MODE_FULLJUMP, PL_MODE_FALL)
	ld   a, [wPlMode]
	or   a ; PL_MODE_GROUND	; wPlMode == $00?
	jp   z, WpnCtrlS_End		; If so, return
	cp   PL_MODE_FALL+1		; wPlMode >= $04?
	jp   nc, WpnCtrlS_End	; If so, return
	
	; If it's already active, don't reactivate it
	ld   a, [wWpnTpActive]
	or   a
	jp   nz, WpnCtrlS_End
	
	; If there isn't enough ammo to use it, don't do it either.
	; Note that Top Spin only uses up ammo on contact, not on activation.
	call WpnS_HasAmmoForShot
	jp   c, WpnCtrlS_End
	
	;
	; If we got here, we can activate Top Spin.
	; This will visually cause Rockman to spin, and his whole body will deal damage to enemies weak to it.
	;
	; What *actually* happens is that the player sprite is hidden and a weapon shot is spawned
	; to the player's location, which has a sprite showing the player spinning, will track the
	; player's position on its own, and is the part that deals damage.
	;
	ld   hl, wShot0					; Fixed slot
	ld   a, SHOT0_PROC|WPN_TP
	ld   [wWpnTpActive], a			; Enable Top Spin mode, which hides the normal player sprite
	ldi  [hl], a ; iShotId
	xor  a
	ldi  [hl], a ; iShotWkTimer
	
	; Face same direction as player
	ld   a, [wPlDirH]
	and  DIR_R
	ldi  [hl], a ; iShotDir
	
	; Not deflected
	xor  a
	ldi  [hl], a ; iShotFlags
	
	; XPos: PlX
	inc  hl ; iShotXSub
	ld   a, [wPlRelX]
	ldi  [hl], a ; iShotX
	
	; YPos: PlY - 8
	inc  hl ; iShotYSub
	ld   a, [wPlRelY]
	sub  $08
	ldi  [hl], a ; iShotY
	
	; Set initial Top Spin sprite
	ld   a, SHOTSPR_TP0
	ld   [hl], a ; iShotSprId
	
	jp   WpnCtrlS_StartShootAnim
	
