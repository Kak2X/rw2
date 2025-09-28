; =============== Wpn_Default ===============
; Default weapon.
; A small shot moving forwards at 2px/frame.
Wpn_Default:
	ld   hl, hShotCur+iShotX	; HL = Ptr to X pos
	ldh  a, [hShotCur+iShotDir]
	or   a						; Facing right?
	jr   nz, .moveR				; If so, jump
.moveL:
	dec  [hl]					; Move left 2px
	dec  [hl]
	jp   WpnS_DrawSprMap
.moveR:
	inc  [hl]					; Move right 2px
	inc  [hl]
	jp   WpnS_DrawSprMap
	
