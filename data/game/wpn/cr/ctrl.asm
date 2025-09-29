; =============== WpnCtrl_CrashBomb ===============
; Crash Bomb.
; A shot fired forward that eats up copious amounts of energy with an explosion just for show.
WpnCtrl_CrashBomb:
	ld   a, WPU_CR
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
	
	; Eat up wild amountx of ammo, chances are there's not enough to spawn a shot
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
	; Only fired forward
	ld   a, SHOT0_PROC|WPN_CR ; Shot ID
	ld   c, SHOTSPR_CRMOVE ; Sprite ID
	jp   WpnCtrlS_SpawnShotFwd
	
