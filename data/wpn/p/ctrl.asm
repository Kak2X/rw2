; =============== WpnCtrl_Default ===============
; The default weapon, a small shot that travels forward.
; Items such as Rush Coil reuse this for actual player shots.
WpnCtrl_Default:
	; Keep track of the weapon unlock bit for this shot. 
	; This value is only ever written to though.
	xor  a
	ld   [wWpnUnlockMask], a
	
	; If the player isn't pressing B, just exit (only process the shooting animation, if one is set)
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a			; Pressed B?
	jp   z, WpnCtrlS_End	; If not, we're done
	
	; Otherwise, find a free slot to spawn a shot. At most 3 shots can be on screen.
	; There's no special weapon property marking the number of on-screen shots,
	; this is all handled by repeated checks.
	ld   hl, wShot0
	ld   a, [hl]
	or   a					; Is there an active shot in the first slot?
	jr   z, .spawn			; If not, spawn it here
	ld   hl, wShot1
	ld   a, [hl]
	or   a					; "" second slot?
	jr   z, .spawn			; If not, spawn it here
	ld   hl, wShot2
	ld   a, [hl]
	or   a					; "" third slot?
	jp   nz, WpnCtrlS_End	; If so, all three shots are on-screen, return
	
.spawn:
	ld   a, SHOT0_PROC|WPN_P ; Shot ID
	ld   c, SHOTSPR_P ; Sprite ID
	; Fall-through
	
; =============== WpnCtrlS_SpawnShotFwd ===============
; Spawns a projectile that (initially) moves forward, starting from the player's hands.
; IN
; - A: Shot ID
; - C: Sprite ID
; - HL: Ptr to shot slot
WpnCtrlS_SpawnShotFwd:
	; Set the shot ID, which determines the code to execute for it.
	ldi  [hl], a	; iShotId
	
	; Shot-specific timer
	xor  a
	ldi  [hl], a	; iShotWkTimer
	
	; To move forward, the shot needs to face the same direction as the player.
	ld   a, [wPlDirH]
	and  $01		; Filter out other bits
	ldi  [hl], a	; iShotDir
	
	;
	; Make the shot originate from the player's hands.
	; This point is in front of the player, vertically centered.
	;
	
	; HORIZONTAL OFFSET - 14px in front of the player
	; The +1 discrepancy when facing right is due to the player sprite being visually offset 1 pixel there.
	ld   b, -PLCOLI_H-$08	; B = 14px to the left
	or   a ; DIR_L		; Facing left?
	jr   z, .setShot3		; If so, skip
	ld   b, PLCOLI_H+$08+1	; B = 15px to the right
.setShot3:
	; Not deflected
	xor  a
	ldi  [hl], a		; iShotFlags
	
	; Set the X coordinate, offsetted by the previously calculated value
	ldi  [hl], a		; iActXSub
	ld   a, [wPlRelX]
	add  b				; + offset
	ldi  [hl], a		; iShotX
	
	; VERTICAL OFFSET - Middle of the player
	; It's not possible to shoot while sliding, so this can always point to 12px above the origin.
	xor  a
	ldi  [hl], a		; iShotYSub
	ld   a, [wPlRelY]	; From origin (bottom)
	sub  PLCOLI_V		; - v radius (middle)
	ldi  [hl], a		; iShotY
	
	; Set specified sprite mapping ID
	ld   [hl], c		; iShotSprId
	
	jr   WpnCtrlS_StartShootAnim
	
