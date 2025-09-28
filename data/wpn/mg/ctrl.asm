; =============== WpnCtrl_MagnetMissile ===============
; Magnet Missile.
; A magnet fired forward, it can rotate 90° towards enemies.
WpnCtrl_MagnetMissile:
	ld   a, WPU_MG
	ld   [wWpnUnlockMask], a
	
	; Check for shoot button
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; Max 2 shots on-screen
	ld   hl, wShot0
	ld   a, [hl]
	or   a
	jr   z, .chkAmmo
	ld   hl, wShot1
	ld   a, [hl]
	or   a
	jp   nz, WpnCtrlS_End
	
.chkAmmo:
	; Use up (more) ammo (than you'd think), if there isn't enough don't spawn the shot
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
	; This is fired forward
	ld   a, SHOT0_PROC|WPN_MG ; A = Shot ID
	ld   c, SHOTSPR_MGH ; C = Sprite ID
	jp   WpnCtrlS_SpawnShotFwd

