; =============== Wpn_AirShooter ===============
; Air Shooter.
; The weapon fires three whirlwinds at once that rise upwards.
; This is the code for an individual whirlwind.
Wpn_AirShooter:

	;
	; Each of the three shots has its own horizontal speed:
	; - 0: 1.0px/frame
	; - 1: 1.5px/frame
	; - 2: 2.0px/frame
	;
	; BC = Speed for the current shot
	;
	ldh  a, [hShotCur+iShotArNum]
	ld   bc, $0100		; BC = 1px/frame
	dec  a				; ShotNum == 0?
	jr   z, .moveH		; If so, jump
	ld   c, $80			; ...
	dec  a
	jr   z, .moveH
	ld   bc, $0200
	
.moveH:
	;
	; Move forward by the aforemented speed.
	;
	ld   hl, hShotCur+iShotXSub
	ldh  a, [hShotCur+iShotDir]	; # Get direction
	or   a						; # Facing right? (iShotDir != DIR_L)
	ld   a, [hl]				; Read cur subpixels
	jr   nz, .moveR				; # If so, jump
.moveL:
	; iShotX -= BC
	sub  c
	ldi  [hl], a ; iShotXSub
	ld   a, [hl] ; iShotX
	sbc  b
	ldi  [hl], a ; iShotX
	jr   .setY
.moveR:
	; iShotX += BC
	add  c						
	ldi  [hl], a ; iShotXSub
	ld   a, [hl] ; iShotX
	adc  b
	ldi  [hl], a ; iShotX
.setY:

	;
	; Move upwards at a fixed speed of 2px/frame
	;
	inc  hl ; iShotYSub
	dec  [hl]	; iShotY -= 2
	dec  [hl]
	
	;
	; Cycle between sprite mappings $01-$02
	; [TCRF] Off by one, this animation has a third frame that gets cut off.
	;
	inc  hl ; iShotSprId
	ld   a, [hl]		; A = iShotSprId++
	inc  a
	cp   SHOTSPR_AR2		; Reached the last frame? (should have been cp SHOTSPR_AR2+1)
	jr   c, .setSpr		; If not, jump
	ld   a, SHOTSPR_AR0	; Otherwise, reset to the first one
.setSpr:
	ld   [hl], a		; Save to iShotSprId
	
	jp   WpnS_DrawSprMap
	
