; =============== Wpn_LeafShield ===============
; Leaf Shield.
; A shield made of 4 leaves that pierces through everything (but can get deflected).
; This is the code for an individual leaf.
; Code for all leaves is executed on the same frame, making sure they don't get misaligned.
Wpn_LeafShield:
	ldh  a, [hShotCur+iShotWdAnim]
	bit  SHOTWDB_ROTATE, a			; Intro anim done?
	jr   nz, Wpn_LeafShield_Main	; If so, jump
	; Fall-through
	
; =============== Wpn_LeafShield_Intro ===============
; When Leaf Shield spawns, the four leaves move into position from (what they intended to be) the center of the player.
; The animation goes by so quickly it's hard to notice without frame by frame, and the bugs don't help.
Wpn_LeafShield_Intro:


	
	ld   c, a ; Save iShotWdAnim
		;--
		;
		; Determine the leaf position, relative to the player.
		; B = 3 + (iShotWdAnim / 4) * 3
		;     IF (B >= $0C) B--
		;
		; bits2-3 of iShotWdAnim are used a timer for this animation.
		; With the above formula, for each frame of the animation, the leaves will be diagonally offset by:
		; Timer - Offset
		;     0 - $06
		;     1 - $09
		;     2 - $0B
		;     3 - $0E
		;
		; This gives the effect of the leaves moving, over time, from the player's origin to one of the four corners.
		;
		
		; A = 3 + (iShotWdAnim / 4) * 3
		; The lower 2 bits are unrelated to the timer.
		srl  a		; >> 2
		srl  a		;
		; Multiply it by 3
		ld   b, a	; Save this
		add  a		; A *= 2
		add  b		; A += B (*3)
		; Add base offset
		add  $03	; A += 3
		
		; To "slow down" the movement speed by the end, decrement any offset that would be >= $0C, which triggers once the timer ticks to 2.
		; Needless to say, it doesn't quite work when the whole animation is 4 frames long.
		cp   $0C		; A < $0C?
		jr   c, .setOff	; If so, jump
		dec  a			; Otherwise, A--
	.setOff:
		ld   b, a
		;--
		
	; The last two bits of iShotWdAnim identify the leaf number.
	; Each leaf moves to a particular corner.
	ld   a, c 	; A = iShotWdAnim
	and  %11	; Filter leaf number
	rst  $00 ; DynJump
	dw .moveUR
	dw .moveDR
	dw .moveDL
	dw .moveUL
.moveUR:
	; Set the leaf <B> pixels to the top-right of the player.
	; Will move to the top-right corner over time.
	ld   hl, hShotCur+iShotX
	ld   a, [wPlRelX]	; iShotX = wPlRelX + B
	add  b
	ldi  [hl], a
	inc  hl
	; [BUG] All of these intro movement routines target the wrong Y position.
	;       They intended to target the center of the player, but that requires subtracting
	;       the player's vertical radius (PLCOLI_V) to get there.
	;       (The main rotation code gets it right)
	ld   a, [wPlRelY]	; iShotY = wPlRelY - B
	sub  b
	ld   [hl], a
	jr   .nextTick
.moveDR:
	; See above, but to the bottom-right
	ld   hl, hShotCur+iShotX
	ld   a, [wPlRelX]
	add  b
	ldi  [hl], a
	inc  hl
	ld   a, [wPlRelY]
	add  b
	ld   [hl], a
	jr   .nextTick
.moveDL:
	; ... bottom-left
	ld   hl, hShotCur+iShotX
	ld   a, [wPlRelX]
	sub  b
	ldi  [hl], a
	inc  hl
	ld   a, [wPlRelY]
	add  b
	ld   [hl], a
	jr   .nextTick
.moveUL:
	; ... top-left
	ld   hl, hShotCur+iShotX
	ld   a, [wPlRelX]
	sub  b
	ldi  [hl], a
	inc  hl
	ld   a, [wPlRelY]
	sub  b
	ld   [hl], a
.nextTick:

	; Advance the animation timer.
	; Keep in mind the lower two bits are unrelated, hence the << 2's
	ldh  a, [hShotCur+iShotWdAnim]
	add  $01<<2			; Timer++
	cp   $04<<2			; Timer < $04?
	jr   c, .setAnim	; If so, just update the timer
	
	; Otherwise, prepare for the main rotation animation.
	
	; Calculate the rotation position index from the leaf number,
	; to evenly distribute the leaves around the circle.
	; PosId = LeafNum * $10 + 8 
	and  $03			; Get the leaf number
	swap a				; * 10
	add  $08			; + 8
	; Mark the intro as finished
	or   SHOTWD_ROTATE
.setAnim:
	ldh  [hShotCur+iShotWdAnim], a
	jp   WpnS_DrawSprMap
	
; =============== Wpn_LeafShield_Main ===============
; Main rotation state.
Wpn_LeafShield_Main:

	ld   d, a ; Save iShotWdAnim
	
		;
		; Rotate the leaf around a circle path.
		;
	
		; BC = Position index
		and  $FF^(SHOTWD_THROW|SHOTWD_ROTATE)
		ld   b, $00
		ld   c, a
		
		bit  SHOTWDB_THROW, d		; Is the shield thrown?
		jr   nz, .rotSelf			; If so, jump
		
	.rotPl:
		;
		; When the shield isn't thrown yet, rotate the leaf around the player.
		;
		ld   hl, Wpn_WdSinePat.x	; iShotX = wPlRelX + Wpn_WdSinePat.x[BC]
		add  hl, bc
		ld   a, [wPlRelX]			; From origin (horizontally centered)
		add  [hl]					; + offset
		ldh  [hShotCur+iShotX], a
		
		ld   hl, Wpn_WdSinePat.y	; iShotY = wPlRelY + Wpn_WdSinePat.y[BC] - PLCOLI_V
		add  hl, bc
		ld   a, [wPlRelY]			; From origin (bottom)
		add  [hl]					; + offset
		sub  PLCOLI_V				; Vertically centered
		ldh  [hShotCur+iShotY], a
		
		jr   .nextPos
	.rotSelf:
		;
		; When the shield is thrown, still rotate the leaves, but not around the player anymore.
		; This means the offsets used are relative to the previous position, necessitating
		; the use of a different set of tables.
		;
		ld   hl, Wpn_WdSelfPat.x	; iShotX += Wpn_WdSelfPat.x[BC]
		add  hl, bc
		ldh  a, [hShotCur+iShotX]
		add  [hl]
		ldh  [hShotCur+iShotX], a
		
		ld   hl, Wpn_WdSelfPat.y	; iShotY += Wpn_WdSelfPat.y[BC]
		add  hl, bc
		ldh  a, [hShotCur+iShotY]
		add  [hl]
		ldh  [hShotCur+iShotY], a
		
	.nextPos:
		; Increment the position index, cycling between $00 - $3F.
		ld   a, c
		inc  a		; PosId++
		and  $3F	; Loop around $40 to $00
		ld   c, a
		
	; Save back the updated index into iShotWdAnim
	ld   a, d							; A = iShotWdAnim
	and  SHOTWD_THROW|SHOTWD_ROTATE		; Keep flags
	or   c								; Merge with new index
	ldh  [hShotCur+iShotWdAnim], a		; Save back
	
.chkThrowCtrl:

	;
	; Pressing any directional key while the shield is around the player will throw it
	; to that particular direction.
	;

	; If the shield was already thrown, keep moving it to the previous direction
	bit  SHOTWDB_THROW, a
	jr   nz, .thrown
	
	
	; If no directional keys are being held, don't throw it
	ldh  a, [hJoyKeys]
	and  KEY_DOWN|KEY_UP|KEY_LEFT|KEY_RIGHT
	jp   z, WpnS_DrawSprMap
	
	; Otherwise, throw the shield in the respective direction.
	; Check the individual direction by shifting key bits into the carry.
	ld   b, DIR_D		; B = DIR_D
	rla 				; KEY_DOWN is set?
	jr   c, .setDir		; If so, move down
	dec  b				; B = DIR_U
	rla  				; KEY_UP is set?
	jr   c, .setDir		; If so, move up
	dec  b				; B = DIR_R
	rla  				; KEY_LEFT is set?
	jr   nc, .setDir	; If *NOT*, move right (B = DIR_R confirmed)
	dec  b				; Otherwise, B = DIR_L
.setDir:
	ld   a, b
	ldh  [hShotCur+iShotDir], a
	
	; Flag the shield has having been thrown
	ldh  a, [hShotCur+iShotWdAnim]
	or   SHOTWD_THROW
	ldh  [hShotCur+iShotWdAnim], a
	
	; [POI] Why does wWpnWdUseAmmoOnThrow exist?
	;       This could be speculated on but what we do know is that its value will always be $01 when we get here.
	ld   hl, wWpnWdUseAmmoOnThrow
	dec  [hl]					; UseLeft--
	call z, WpnS_UseAmmo		; Is it 0? If so, use up ammo (always taken)
	
.thrown:
	; The shield moves at 2px/frame in a straight line
	ldh  a, [hShotCur+iShotDir]
	rst  $00 ; DynJump
	dw .throwL
	dw .throwR
	dw .throwU
	dw .throwD
.throwL:
	ld   hl, hShotCur+iShotX
	dec  [hl]
	dec  [hl]
	jp   WpnS_DrawSprMap
.throwR:
	ld   hl, hShotCur+iShotX
	inc  [hl]
	inc  [hl]
	jp   WpnS_DrawSprMap
.throwU:
	ld   hl, hShotCur+iShotY
	dec  [hl]
	dec  [hl]
	jp   WpnS_DrawSprMap
.throwD:
	ld   hl, hShotCur+iShotY
	inc  [hl]
	inc  [hl]
	jp   WpnS_DrawSprMap
	
