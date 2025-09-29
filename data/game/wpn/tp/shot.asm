; =============== Wpn_TopSpin ===============
; Top Spin.
; Weapon code for Top Spin when activated, which makes the player spin, making the whole body damage enemies.
;
; The "spinning player" is internally a weapon shot that tracks the player's position, giving the illusion
; of the player himself spinning.
; To go with it, the normal player's sprite is hidden during this.
Wpn_TopSpin:
	; If the player is hurt, cancel out of the attack
	ld   a, [wPlHurtTimer]
	or   a						; Did the player get hit?
	jr   z, .spin				; If not, jump
.abort:
	xor  a						; Otherwise, despawn the shot
	ldh  [hShotCur+iShotId], a
	ld   [wWpnTpActive], a		; and enable the normal player sprite
	ret
.spin:

	; Sync direction from player.
	; The effects of doing this are basically unnoticeable due to the very fast animation.
	ld   a, [wPlDirH]
	and  DIR_R				; Filter L/R bit
	ldh  [hShotCur+iShotDir], a
	
	; Sync position
	ld   a, [wPlRelX]			; iShotX = PlX (middle)
	ldh  [hShotCur+iShotX], a
	ld   a, [wPlRelY]			; iShotY = PlY (low)
	sub  $08					; (consistent with init code at WpnCtrl_TopSpin)
	ldh  [hShotCur+iShotY], a
	
	; Tick animation timer (cycles from 0 to 7)
	ldh  a, [hShotCur+iShotTpAnimTimer]
	inc  a								; Timer++
	and  $07							; Timer %= 8
	ldh  [hShotCur+iShotTpAnimTimer], a	; Save back
	
	; Use the timer as offset to the sprite mapping.
	; This has the effect of cycling the animation from SHOTSPR_TP0 to SHOTSPR_TP3
	srl  a						; Slowed down x2 (each sprite lasts 2 frames, 4 sprites)
	add  SHOTSPR_TP0				; Add base frame
	ldh  [hShotCur+iShotSprId], a
	
	jp   WpnS_DrawSprMap		; Draw the sprite
	
