; =============== Wpn_MetalBlade ===============
; Metal Blade.
; 8-way shot replacement.
Wpn_MetalBlade:

	; Alternate between two animation frames (SHOTSPR_ME0, SHOTSPR_ME1)
	ldh  a, [hShotCur+iShotMeAnimTimer]
	xor  $01
	ldh  [hShotCur+iShotMeAnimTimer], a
	add  SHOTSPR_ME0
	ldh  [hShotCur+iShotSprId], a
	
	; Move 2px/frame according to its direction
	ldh  a, [hShotCur+iShotDir]
	rst  $00 ; DynJump
	dw .moveL ; DIR_L
	dw .moveR ; DIR_R
	dw .moveU ; DIR_U
	dw .moveD ; DIR_D
	dw .moveUL ; DIR_UL
	dw .moveUR ; DIR_UR
	dw .moveDL ; DIR_DL
	dw .moveDR ; DIR_DR

.moveL:
	ld   hl, hShotCur+iShotX	; iShotX -= 2
	dec  [hl]
	dec  [hl]
	jp   WpnS_DrawSprMap
	
.moveR:
	ld   hl, hShotCur+iShotX	; iShotX += 2
	inc  [hl]
	inc  [hl]
	jp   WpnS_DrawSprMap
	
.moveU:
	ld   hl, hShotCur+iShotY	; iShotY -= 2
	dec  [hl]
	dec  [hl]
	jp   WpnS_DrawSprMap
	
.moveD:
	ld   hl, hShotCur+iShotY	; iShotY += 2
	inc  [hl]
	inc  [hl]
	jp   WpnS_DrawSprMap
	
.moveUL:
	ld   hl, hShotCur+iShotX	; iShotX += 2
	dec  [hl]
	dec  [hl]
	inc  hl ; iShotYSub
	inc  hl ; iShotY
	dec  [hl]					; iShotY -= 2
	dec  [hl]
	jp   WpnS_DrawSprMap
	
.moveUR:
	ld   hl, hShotCur+iShotX	; iShotX += 2
	inc  [hl]
	inc  [hl]
	inc  hl ; iShotYSub
	inc  hl ; iShotY
	dec  [hl]					; iShotY -= 2
	dec  [hl]
	jp   WpnS_DrawSprMap
	
.moveDL:
	ld   hl, hShotCur+iShotX	; iShotX -= 2
	dec  [hl]
	dec  [hl]
	inc  hl ; iShotYSub
	inc  hl ; iShotY
	inc  [hl]					; iShotY += 2
	inc  [hl]
	jp   WpnS_DrawSprMap
	
.moveDR:
	ld   hl, hShotCur+iShotX	; iShotX += 2
	inc  [hl]
	inc  [hl]
	inc  hl ; iShotYSub
	inc  hl ; iShotY
	inc  [hl]					; iShotY += 2
	inc  [hl]
	jp   WpnS_DrawSprMap
	
