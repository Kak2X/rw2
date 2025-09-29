; =============== WpnCtrl_NeedleCannon ===============
; Needle Cannon.
; Rapid-fire weapon with shots that alternate between two vertical positions.
WpnCtrl_NeedleCannon:
	ld   a, WPU_NE
	ld   [wWpnUnlockMask], a
	
	; Needle cannon has autofire, the B button can be held.
	ldh  a, [hJoyKeys]
	bit  KEYB_B, a			; Holding B?
	jp   z, WpnCtrlS_End	; If not, return
	
	;
	; Max 3 shots on-screen
	;
	ld   hl, wShot0
	ld   a, [hl]
	or   a					; Is the first slot empty?
	jr   z, .chkCooldown			; If so, jump
	ld   hl, wShot1
	ld   a, [hl]
	or   a
	jr   z, .chkCooldown
	ld   hl, wShot2
	ld   a, [hl]
	or   a
	jp   nz, WpnCtrlS_End
	
	;
	; Enforce a cooldown period of 10 frames between shots.
	; 
	; However, the way the cooldown timer is handled is... weird. 
	; It would have made sense to have it as a global variable, instead it makes use of the shot-specific timer in iShotNeTimer.
	; 
	; This means we have to loop through all shots and check if any have spawned in the last 10 frames.
	; If any did, return and don't spawn a new one.
	;
.chkCooldown:
	ld   de, wShot0			; DE = First slot
	ld   b, $03				; B = Slots left
.loopCo:
	; Ignore empty slots
	ld   a, [de]
	or   a					; Is the slot free?
	jr   z, .nextCo			; If so, skip
	; If the shot is too new, return
	inc  e					; Seek to iShotNeTimer
	ld   a, [de]
	cp   $0A				; iShotNeTimer < $0A?
	jp   c, WpnCtrlS_End	; If so, return
	dec  e
.nextCo:
	; Seek to next slot
	ld   a, e				; DE += $10
	add  iShotEnd
	ld   e, a
	dec  b					; Checked all slots?
	jr   nz, .loopCo		; If not, loop
	
	; Check for ammo
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
.spawn:
	; Spawn the shot.
	ld   a, SHOT0_PROC|WPN_NE
	ldi  [hl], a ; iShotId
	xor  a
	ldi  [hl], a ; iShotNeTimer
	
	; Face same direction as player
	ld   a, [wPlDirH]
	and  DIR_R
	ldi  [hl], a ; iShotDir
	
	; X POSITION
	; Spawn 14px in front of the player
	ld   b, -$0E	; B = 14px to the left
	or   a			; Facing right?
	jr   z, .setX	; If not, jump
	ld   b, $0E+1	; B = 14px to the right
.setX:
	; Not deflected
	xor  a
	ldi  [hl], a ; iShotFlags
	
	; XPos = PlX + B
	ldi  [hl], a ; iShotXSub
	ld   a, [wPlRelX]
	add  b
	ldi  [hl], a ; iShotX
	
	; Y POSITION
	; The vertical position alternates between 9px and 14px every other shot,
	; starting with 9px (wWpnNePos is initialized to 0, which gets flipped to 1)
	xor  a		
	ldi  [hl], a ; iShotYSub
	
	ld   a, [wWpnNePos]	; # Flip direction marker in bit0
	xor  $01
	ld   [wWpnNePos], a
	rra  				; # C Flag = wWpnNePos % 2
	ld   a, [wPlRelY]	; A = PlY
	jr   c, .y0			; # Every other frame alternate between...
.y1:
	sub  $0E			; ...14px above 
	jr   .setY
.y0:
	sub  $09			; ...9px above
.setY:
	ldi  [hl], a ; iShotY
	
	; Set sprite
	ld   a, SHOTSPR_NE
	ld   [hl], a ; iShotSprId
	
	jp   WpnCtrlS_StartShootAnim
	
