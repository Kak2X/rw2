; =============== WpnCtrl_MetalBlade ===============
; Metal Blade.
; 8-way buster replacement.
WpnCtrl_MetalBlade:
	ld   a, WPU_ME
	ld   [wWpnUnlockMask], a
	
	; Check for shoot button
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; Max 3 shots on screen
	ld   hl, wShot0
	ld   a, [hl]
	or   a
	jr   z, .chkAmmo
	ld   hl, wShot1
	ld   a, [hl]
	or   a
	jr   z, .chkAmmo
	ld   hl, wShot2
	ld   a, [hl]
	or   a
	jp   nz, WpnCtrlS_End
	
.chkAmmo:
	; Use up ammo, if there isn't enough don't spawn the shot
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
.spawn:
	; Spawn the Metal Blade projectile.
	ld   a, SHOT0_PROC|WPN_ME
	ldi  [hl], a ; iShotId
	
	xor  a
	ldi  [hl], a ; iShotWkTimer
	
	;
	; Metal Blades can be thrown in all 8 directions.
	; Check which one to set.
	;
	
	; If not holding any key, shoot forward like other weapons.
	; This also filters out non-directional keys for the detailed check.
	ldh  a, [hJoyKeys]
	and  KEY_DOWN|KEY_UP|KEY_LEFT|KEY_RIGHT	; Holding a directional key?
	jr   nz, .chkDirEx						; If so, jump
.chkDir:
	; Forward depends on the player's direction
	ld   a, [wPlDirH]	; C = wPlDirH & DIR_R
	and  DIR_R
	ld   c, a
	jr   .setDir
.chkDirEx:
	; Otherwise, perform the detailed check starting from diagonals.
	ld   c, DIR_DR			; C = DIR_DR
	cp   KEY_DOWN|KEY_RIGHT		; Holding Down-Right?
	jr   z, .dirFound			; If so, jump (key found)
	dec  c 						; C = DIR_DL
	cp   KEY_DOWN|KEY_LEFT		; ...
	jr   z, .dirFound
	dec  c						; C = DIR_UR
	cp   KEY_UP|KEY_RIGHT
	jr   z, .dirFound
	dec  c						; C = DIR_UL
	cp   KEY_UP|KEY_LEFT
	jr   z, .dirFound
	
	; Then all individual directions, bit by bit
	dec  c						; C = DIR_D
	rla  ; KEYB_DOWN			; Shift KEYB_DOWN into the carry
	jr   c, .dirFound			; Is it set? If so, jump
	dec  c						; C = DIR_U
	rla  ; KEYB_UP
	jr   c, .dirFound
	
	; The bits here are stored in a different order between DIR_* and KEY_*,
	; requiring a small switchup.
	dec  c						; C = DIR_R
	rla  ; KEYB_LEFT			; Is the left button pressed set?
	jr   nc, .dirFound			; If *NOT*, we're holding right (keep DIR_R)
	dec  c						; Otherwise, C = DIR_L
.dirFound:
	ld   a, c
.setDir:
	ldi  [hl], a ; iShotDir
	
	; Not deflected
	xor  a
	ldi  [hl], a ; iShotFlags
	
	;
	; Each direction uses different spawn coordinates for the shot.
	;
	
	; X POSITION
	ldi  [hl], a ; iShotXSub	; No subpixels
	; Index Wpn_MePosXTbl by direction and read out the offset to B
	ld   a, LOW(Wpn_MePosXTbl)	; E = LOW(Wpn_MePosXTbl) + C
	add  c
	ld   e, a
	ld   a, HIGH(Wpn_MePosXTbl)	; D = HIGH(Wpn_MePosXTbl)	+ (Carry)
	adc  $00
	ld   d, a
	ld   a, [de]				; B = X Offset
	ld   b, a
	; That offset is relative to the player, as usual
	ld   a, [wPlRelX]
	add  b
	ldi  [hl], a ; iShotX
	
	; Y POSITION
	; Same thing, but with a different table.
	xor  a
	ldi  [hl], a ; iShotYSub
	ld   a, LOW(Wpn_MePosYTbl)
	add  c
	ld   e, a
	ld   a, HIGH(Wpn_MePosYTbl)
	adc  $00
	ld   d, a
	ld   a, [de]
	ld   b, a
	ld   a, [wPlRelY]
	add  b
	ldi  [hl], a ; iShotY
	
	; Set sprite
	ld   [hl], SHOTSPR_ME0 ; iShotSprId
	
	; [POI] For some reason, this does not go through WpnCtrlS_StartShootAnim, opting to manually set the fields.
	;       In doing so, it forgets to play a sound effect and it also sets the wrong shooting animation,
	;       which WpnCtrlS_StartShootAnim/Wpn_ShootTypeTbl would have gotten right.
	ld   a, $0C					; Same timing as WpnCtrlS_StartShootAnim 
	ld   [wPlShootTimer], a
	ld   a, PSA_SHOOT
	ld   [wPlShootType], a
	ret
	
