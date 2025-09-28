; =============== Wpn_NeedleCannon ===============
; Needle Cannon.
; A normal shot that can be rapid-fired.
Wpn_NeedleCannon:
	
	; And due to the rapid-fire, for cooldown purposes it has to keep track
	; of how many frames have passed since the shot was spawned.
	ld   hl, hShotCur+iShotNeTimer
	inc  [hl]
	
	; Move forward 2px/frame, like a normal shot
	ld   l, LOW(hShotCur+iShotX)
	ldh  a, [hShotCur+iShotDir]
	or   a				; Facing right?
	jr   nz, .moveR		; If so, jump
.moveL:
	dec  [hl]
	dec  [hl]
	jp   WpnS_DrawSprMap
.moveR:
	inc  [hl]
	inc  [hl]
	jp   WpnS_DrawSprMap
	
