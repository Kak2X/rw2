; =============== Freeze_Do ===============
; [TCRF] Handles the freeze-frame pause feature, normally unused.
Freeze_Do:
	; The sound used when toggling this is unique to this subroutine,
	; making it normally unused.
	ld   a, SFX_FREEZETOGGLE
	mPlaySFX
	
	; Stay here until pressing SELECT to unpause
.loop:
	rst  $08 ; Wait frame
	call JoyKeys_Refresh
	ldh  a, [hJoyNewKeys]
	bit  KEYB_SELECT, a		; Pressed SELECT?
	jr   z, .loop			; If not, keep waiting
	
	ld   a, SFX_FREEZETOGGLE
	mPlaySFX
	ret
	
; =============== Game_Unused_RefillCur ===============
; [TCRF] Unreferenced code.
; Instantly refills all of the player's health and the current weapon's ammo.
; Supiciously located after the freeze frame handler.
Game_Unused_RefillCur:
	
	ld   a, BAR_MAX			; Fully refill...
	ld   [wPlHealth], a		; ... our health
	ld   [wWpnAmmoCur], a	; ... the current weapon's ammo
	
	ld   a, [wPlHealth]		; Redraw the health bar
	ld   c, $00
	call Game_AddBarDrawEv
	
	ld   a, [wWpnId]		; If a weapon is selected...
	or   a
	jr   z, .exec
	ld   a, [wWpnAmmoCur]	; ...redraw the weapon bar too
	ld   c, $01
	call Game_AddBarDrawEv
	
.exec:
	rst  $18 ; Wait bar update
	ret
	
