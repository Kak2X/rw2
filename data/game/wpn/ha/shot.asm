; =============== Wpn_HardKnuckle ===============
; Hard Knuckle
; Slow moving fist which can be vertically adjusted.
Wpn_HardKnuckle:

	;
	; VERTICAL MOVEMENT
	; 
	; On its own, the fist moves only horizontally, not vertically.
	; By holding UP or DOWN, its vertical position be adjusted, at
	; the low speed of 0.125px/frame.
	;
	ldh  a, [hJoyKeys]
	rla 				; Holding DOWN?
	jr   c, .moveD		; If so, move up
	rla  				; Holding UP?
	jr   nc, .moveH	; If not, jump
.moveU:					; Otherwise, move down
	; Move 0.125px/frame up
	ld   hl, hShotCur+iShotYSub
	ld   a, [hl]
	sub  $20
	ldi  [hl], a
	ld   a, [hl]
	sbc  $00
	ld   [hl], a
	jr   .moveH
.moveD:
	; Move 0.125px/frame down
	ld   hl, hShotCur+iShotYSub
	ld   a, [hl]
	add  $20
	ldi  [hl], a
	ld   a, [hl]
	adc  $00
	ld   [hl], a
	
.moveH:
	;
	; HORIZONTAL MOVEMENT
	;
	; The fist speeds up over time.
	; Specifically, it has two movement phases depending on how much time has passed since it has spawned:
	; - The first 16 frames, it moves forward at 1px/frame
	; - From the 17th frame onwards, it moves at 1.5px/frame
	;
	
	ld   hl, hShotCur+iShotHaTimer
	ld   a, [hl]
	cp   $10				; Timer >= 16?
	jr   nc, .moveFastH		; If so, use fast movement
.moveSlowH:
	inc  [hl]				; Timer++
	
	ld   hl, hShotCur+iShotX
	ldh  a, [hShotCur+iShotDir]
	or   a					; Facing right?
	jr   nz, .moveSlowR		; If so, jump
.moveSlowL:
	dec  [hl]				; Facing left: Move left 1px
	jp   WpnS_DrawSprMap
.moveSlowR:
	inc  [hl]				; Facing right: Move right 1px
	jp   WpnS_DrawSprMap
	
.moveFastH:
	ld   hl, hShotCur+iShotXSub
	ldh  a, [hShotCur+iShotDir]
	or   a					; Facing right?
	jr   nz, .moveFastR		; If so, jump
.moveFastL:
	ld   a, [hl]			; Facing left: Move left 1.5px
	sub  $80
	ldi  [hl], a
	ld   a, [hl] ; iShotX
	sbc  $01
	ld   [hl], a
	jp   WpnS_DrawSprMap
.moveFastR:
	ld   a, [hl]			; Facing right: Move right 1.5px
	add  $80
	ldi  [hl], a
	ld   a, [hl] ; iShotX
	adc  $01
	ld   [hl], a
	jp   WpnS_DrawSprMap
	
