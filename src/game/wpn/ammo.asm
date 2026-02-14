; =============== WpnS_SaveCurAmmo ===============
; Saves the current weapon's ammo back to the array.
WpnS_SaveCurAmmo:
	; Nothing to save if no weapon is selected
	ld   a, [wWpnId]
	or   a
	ret  z
	
	; Otherwise, wWpnAmmoTbl[wWpnId] = wWpnAmmoCur
	ld   hl, wWpnAmmoTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [wWpnAmmoCur]
	ld   [hl], a
	ret
	
; =============== WpnS_HasAmmoForShot ===============
; Checks if the player has enough ammo to fire the weapon.
; OUT
; - C Flag: If set, there's not enough ammo
WpnS_HasAmmoForShot:
	push bc
		ld   a, [wWpnShotCost]	; B = Ammo cost for a shot
		ld   b, a
		ld   a, [wWpnAmmoCur]	; A = Current ammo
		cp   b					; C Flag = CurAmmo < ShotCost?
	pop  bc
	ret
	
; =============== WpnS_UseAmmo ===============
; Uses up ammo for a weapon shot.
WpnS_UseAmmo:
	IF REV_VER == VER_EU
		; Ignore if the level is over, as the player has no control.
		ld   a, [wLvlEnd]
		or   a
		ret  nz
	ENDC
	push hl
	push bc
		; Subtract the cost of a shot to the current ammo.
		; A = wWpnAmmoCur - wWpnShotCost
		ld   a, [wWpnShotCost]
		ld   b, a
		ld   a, [wWpnAmmoCur]
		sub  b
		; If we underflowed, we don't have enough ammo to fire a shot.
		jr   c, .end
		
		; Otherwise, save the updated ammo
		ld   [wWpnAmmoCur], a
		
		; And redraw the ammo bar
		ld   [wWpnAmmoBar], a		; Set bar redraw value
		ld   hl, wStatusBarRedraw	; Request redraw
		set  BARID_WPN, [hl]
.end:
	pop  bc
	pop  hl
	ret
	
