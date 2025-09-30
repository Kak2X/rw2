; =============== Game_TickTime ===============
; Updates the gameplay timer, which is measured in seconds.
;
; This subroutine is only executed when there's no lag frame, and it chains
; into others that have the same requirement.
Game_TickTime:
	ld   a, [wGameTimeSub]	; FrameCnt++
	inc  a
	ld   [wGameTimeSub], a
	cp   60					; FrameCnt == 60?
	jr   nz, .end			; If not, skip
	xor  a					; Otherwise, FrameCnt++
	ld   [wGameTimeSub], a
	ld   hl, wGameTime		; SecondCnt++
	inc  [hl]
.end:
; Fall-through
	
; =============== Game_DoRefill ===============
; Performs any timed refills, 1 unit of health at a time.
; Unlike other games, these can happen concurrently without stopping gameplay.
Game_DoRefill:
	
	; Don't process them if level scrolling or normal events are being run, as those take priority.
	; This is to make sure every step of the bar redraw visibly happens, to avoid choppy or incomplete refills.
	xor  a
	ld   hl, wLvlScrollEvMode
	or   [hl]				; wLvlScrollEvMode != 0?
	ld   hl, wTilemapEv
	or   [hl]				; || wTilemapEv != 0?
	ret  nz					; If so, return
	
.chkHealth:
	;
	; Player Health (BARID_PL)
	;
	ld   a, [wPlHealthInc]
	or   a					; Any more health to add?
	jr   z, .chkAmmo		; If not, skip
	dec  a					; Tick one down
	ld   [wPlHealthInc], a
	
	; Update the player's health
	ld   a, [wPlHealth]		; C = Old Health
	ld   c, a
	inc  a					; A = MIN(wPlHealth + 1, BAR_MAX)
	cp   BAR_MAX
	jr   c, .setHealth
	ld   a, BAR_MAX
.setHealth:
	ld   b, a				; B = New Health
	ld   [wPlHealth], a		; Save new health
	
	; Only play the refill sound and redraw the status bar when a new bar is added.
	; This is necessary because we're not incrementing health by a bar, but by a single unit of health,
	; and a single bar is worth 8 units. It doesn't make sense to waste time redrawing the same bar.
	
	; Checking bit3 after xoring between the old and new health will tell if it has changed.
	; If it did, we crossed an 8 unit boundary, so it needs a redraw.
	xor  c					
	and  $08				; ((NewHealth ^ OldHealth) & $08) == 0?
	jr   z, .chkAmmo		; If so, skip
	
	ld   a, b				; Set to draw the new amount of health
	ld   [wPlHealthBar], a
	ld   hl, wStatusBarRedraw	; Trigger redraw
	set  BARID_PL, [hl]
	mPlaySFX SFX_BAR			; Play refill sound

.chkAmmo:
	;
	; Weapon Ammo (BARID_WPN)
	; Almost identical to the one above, except for weapon ammo.
	;
	
	; Any more ammo to add?
	ld   a, [wWpnAmmoInc]
	or   a
	jr   z, .end
	dec  a
	ld   [wWpnAmmoInc], a
	;--
	; The default weapon has unlimited ammo, no need to redraw it.
	; [BUG] This is accidentally returning early instead of skipping to .end.
	;       If player's health is being refilled, it will prevent it from being redrawn
	;       while ammo is also being refilled.
	ld   a, [wWpnId]
	or   a
	ret  z
	;--
	
	; Update the weapon's ammo
	ld   a, [wWpnAmmoCur]
	ld   c, a
	inc  a
	cp   BAR_MAX
	jr   c, .setAmmo
	ld   a, BAR_MAX
.setAmmo:
	ld   b, a
	ld   [wWpnAmmoCur], a
	
	; Only redraw when crossing a 8 unit threshold
	xor  c
	and  $08
	ret  z
	
	; Trigger redraw & sfx
	ld   a, b
	ld   [wWpnAmmoBar], a
	ld   hl, wStatusBarRedraw
	set  BARID_WPN, [hl]
	mPlaySFX SFX_BAR
.end:
	; Fall-through
	
; =============== Game_ChkRedrawBar ===============
; Queues up redraw events for all parts of the status bar that need to be redrawn.
Game_ChkRedrawBar:
	
	ld   a, [wStatusBarRedraw]		; B = Redraw flags
	ld   b, a
	ld   hl, wPlHealthBar
	
	; Process the redraws in BARID_* order
	ld   c, BARID_PL				; C = Running BARID_* value
	ldi  a, [hl]					; Read wPlHealthBar, seek to wWpnAmmoBar
	bit  BARID_PL, b				; Need to redraw the health bar?
	call nz, Game_AddBarDrawEv		; If so, do it
	
	inc  c							; C = BARID_WPN
	ldi  a, [hl]					; Read wWpnAmmoBar, seek to wBossHealthBar
	bit  BARID_WPN, b				; Need to redraw the weapon bar?
	call nz, Game_AddBarDrawEv		; If so, do it
	
	inc  c							; C = BARID_BOSS
	ldi  a, [hl]					; Read wBossHealthBar, seek to wPlLivesView
	bit  BARID_BOSS, b				; Need to redraw the boss health bar?
	call nz, Game_AddBarDrawEv		; If so, do it
	
	ld   a, [hl]					; Read wPlLivesView
	bit  BARID_LIVES, b				; Need to redraw the lives indicator?
	call nz, Game_AddLivesDrawEv	; If so, do it
	
	; If anything was redrawn, trigger the bar redraw event
	ld   a, b
	or   a							; wStatusBarRedraw == 0?
	ret  z							; If so, return (nothing redrawn)
	
	xor  a							; Otherwise, reset redraw flags
	ld   [wStatusBarRedraw], a
	inc  a							; and trigger the event
	ld   [wTilemapBarEv], a
	ret
	
