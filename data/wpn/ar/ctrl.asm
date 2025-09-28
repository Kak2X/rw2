; =============== WpnCtrl_AirShooter ===============
; Air Shooter.
; Spreadshot made up of 3 whirlwinds, travels diagonally up.
WpnCtrl_AirShooter:
	ld   a, WPU_AR
	ld   [wWpnUnlockMask], a
	
	; Shoot on B
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	jp   z, WpnCtrlS_End
	
	; All of the three individual shots must be despawned.
	; This gives a real limit of 1 shot onscreen.
	ld   hl, wShot0
	ld   a, [hl]
	ld   hl, wShot1
	or   [hl]
	ld   hl, wShot2
	or   [hl]
	jp   nz, WpnCtrlS_End
	
	; Use up ammo, if there isn't enough don't spawn any shots
	call WpnS_UseAmmo
	jp   c, WpnCtrlS_End
	
	;
	; Spawn the three shots in a loop.
	;
	ld   c, $03			; C = Shots left
	ld   hl, wShot0		; HL = From the first slot
.loop:
	ld   a, SHOT0_PROC|WPN_AR
	ldi  [hl], a ; iShotId
	
	; Set the shot number, needed to help distinguish between the three as each travels at its own speed. 
	ld   a, c
	ldi  [hl], a ; iShotWkTimer
	
	ld   a, [wPlDirH]
	and  DIR_R	; A = Shot direction
	ldi  [hl], a ; iShotDir
	
	; Spawn 14 pixels in front of the player
	ld   b, -$0E		; B = 14px to the left
	or   a				; Facing right?
	jr   z, .setX		; If not, jump
	ld   b, $0E+1		; B = 14px to the right
.setX:
	; Not deflected
	xor  a
	ldi  [hl], a ; iShotFlags
	
	; Set X position
	ldi  [hl], a ; iShotXSub
	ld   a, [wPlRelX]
	add  b
	ldi  [hl], a ; iShotX
	
	; Spawn 13 pixels above the player
	xor  a
	ldi  [hl], a ; iShotYSub
	ld   a, [wPlRelY]
	sub  $0B
	ldi  [hl], a ; iShotY
	
	; Set sprite
	ld   [hl], SHOTSPR_AR0 ; iShotSprId
	
	; Seek to next slot
	ld   a, l
	and  $F0		; Seek back to iShotId
	add  iShotEnd	; Next slot
	ld   l, a
	
	dec  c			; Done spawning all shots?
	jr   nz, .loop	; If not, loop
	
	jp   WpnCtrlS_StartShootAnim
	
