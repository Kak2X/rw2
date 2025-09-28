; =============== Wpn_CrashBomb ===============
; Crash Bomb
; A medium-sized projectile that sticks to walls, then explodes.
Wpn_CrashBomb:

	ldh  a, [hShotCur+iShotCrTimer]
	or   a					; Hit a solid block already?
	jr   nz, .solidHit		; If so, jump
	
	;
	; Move the bomb 2px/frame forward, while checking for collision with any solid blocks in the way.
	;
	
	; Y COLLISION TARGET = ShotY
	ldh  a, [hShotCur+iShotY]	
	ld   [wTargetRelY], a
	
	; X COLLISION TARGET = 1px in front of iShotX
	ld   hl, hShotCur+iShotX	
	ldh  a, [hShotCur+iShotDir]
	or   a						; # Facing right?
	ld   b, -$01				; B = 1px to the left
	jr   z, .chkMove			; # If not, jump
	ld   b, +$01				; B = 1px to the right
.chkMove:
	; Move 1px to the right twice, aborting early in case of collision
	call .moveFwd				; Move 1px right
	call c, .moveFwd			; Hit a solid block? If not, move again
	jp   c, WpnS_DrawSprMap		; Hit a solid block? If not, return
	
.solidHit:
	ld   hl, hShotCur+iShotCrTimer
	inc  [hl]			; Timer++
	
	;
	; After hitting a solid block, perform these actions in sequence:
	; - Flash for around 2.1 seconds ($00-$7F, after which it overflows to SHOTCR_EXPLODE)
	; - Exploding for 1 second ($80-$BC)
	; - Despawn
	;
	
	ld   a, [hl]
	cp   SHOTCR_EXPLODE+$3C		; Timer < $BC?
	jr   c, .chkFlash			; If so, jump
.despawn:						; Otherwise, despawn the shot
	xor  a
	ldh  [hShotCur+iShotId], a
	ret
	
.chkFlash:
	cp   SHOTCR_EXPLODE			; Timer >= $80?
	jr   nc, .explode			; If so, jump
.flash:
	; Flash the bomb by alternating between SHOTSPR_CRFLASH0 and SHOTSPR_CRFLASH1 every 8 frames.
	srl  a						; A = Timer / 8
	srl  a
	srl  a
	and  $01					; Filter valid range
	add  SHOTSPR_CRFLASH0		; Add base sprite
	ldh  [hShotCur+iShotSprId], a
	jp   WpnS_DrawSprMap
	
.explode:
	; Animate the explosion.
	; The explosion is not a separate object that deals damage, it's simply the Crash Bomb going
	; through a list of sprite mappings that have no effect on gameplay.
	; As a result, keeps the same collision box as before, making it very weak.
	;
	; Worth noting this could have been amended by simply adjusting the current shot's collision box
	; and flags right here.
	
	; Get table index
	and  $FF^SHOTCR_EXPLODE		; Remove MSB (as A is always >= $80)
	srl  a						; Slowed down x2
	
	; Read out sprite mapping ID from  .explTbl
	ld   hl, .explTbl			; Index .explTbl with it
	ld   b, $00
	ld   c, a			
	add  hl, bc
	ld   a, [hl]		
	ldh  [hShotCur+iShotSprId], a	; And set it as sprite
	jp   WpnS_DrawSprMap
	
; =============== .explTbl ===============
; Animation cycle for the Crash Bomb explosions.
; Needs to have as many entries as the amount of frames / 2 it executes .explode.
; The explosion lasts 1 second ($3C frames), so this table should have 30 entries.
.explTbl: 
	db SHOTSPR_CREXPL2 ; $00
	db SHOTSPR_CREXPL1 ; $02
	db SHOTSPR_CREXPL0 ; $04
	db SHOTSPR_CREXPL1 ; $06
	db SHOTSPR_CREXPL2 ; $08
	db SHOTSPR_CREXPL5 ; $0A
	db SHOTSPR_CREXPL4 ; $0C
	db SHOTSPR_CREXPL3 ; $0E
	db SHOTSPR_CREXPL4 ; $10
	db SHOTSPR_CREXPL5 ; $12
	db SHOTSPR_CREXPL8 ; $14
	db SHOTSPR_CREXPL7 ; $16
	db SHOTSPR_CREXPL6 ; $18
	db SHOTSPR_CREXPL7 ; $1A
	db SHOTSPR_CREXPL8 ; $1C
	db SHOTSPR_CREXPL2 ; $1E
	db SHOTSPR_CREXPL1 ; $20
	db SHOTSPR_CREXPL0 ; $22
	db SHOTSPR_CREXPL1 ; $24
	db SHOTSPR_CREXPL2 ; $26
	db SHOTSPR_CREXPL5 ; $28
	db SHOTSPR_CREXPL4 ; $2A
	db SHOTSPR_CREXPL3 ; $2C
	db SHOTSPR_CREXPL4 ; $2E
	db SHOTSPR_CREXPL5 ; $30
	db SHOTSPR_CREXPL8 ; $32
	db SHOTSPR_CREXPL7 ; $34
	db SHOTSPR_CREXPL6 ; $36
	db SHOTSPR_CREXPL7 ; $38
	db SHOTSPR_CREXPL8 ; $3A
	                  
; =============== .moveFwd ===============
; Moves the shot forward.
; IN
; - HL: Ptr to iShotX
; - B: Movement speed (1 or -1, depending on the direction)
; - wTargetRelY: iShotY
; OUT
; - C Flag: If set, it didn't hit a solid wall
.moveFwd:
	; Move shot forward
	ld   a, [hl]	; iShotX += B
	add  b
	ld   [hl], a
	
	; Perform the collision check at this new position
	ld   [wTargetRelX], a
	push bc
	push hl
		call Lvl_GetBlockId	; C Flag = Is empty?
	pop  hl
	pop  bc
	ret
	
