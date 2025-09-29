; =============== WpnCtrl_HardKnuckle ===============
; Hard Knuckle
; Large fist fired forward, its vertical position can be adjusted over time.
WpnCtrl_HardKnuckle:
	ld   a, WPU_HA
	ld   [wWpnUnlockMask], a
	
	; Check for shoot button
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; Max 1 shot on-screen
	ld   hl, wShot0
	ld   a, [hl]
	or   a
	jp   nz, WpnCtrlS_End
	
	; Use up ammo, if there isn't enough don't spawn the shot
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
	;--
	; Freeze the player for 16 frames after firing the shot.
	; This countdown timer is global, ticking down every time shots are processed in WpnS_Do.
	ld   a, PL_MODE_FROZEN
	ld   [wPlMode], a		; Freeze player
	ld   a, $10
	ld   [wWpnHaFreezeTimer], a	; Return to PL_MODE_GROUND after $10 frames
	;--
	
	; Shoot the fist forward
	ld   a, SHOT0_PROC|WPN_HA ; Shot ID
	ld   c, SHOTSPR_HA ; Sprite ID
	jp   WpnCtrlS_SpawnShotFwd
	
