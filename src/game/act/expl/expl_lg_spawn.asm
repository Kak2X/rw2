; =============== ActS_SpawnLargeExpl ===============
; Spawns the eight explosion particles when a player or boss dies.
; These originate from the player's position and move outwards.
ActS_SpawnLargeExpl:
	ld   a, ACT_EXPLLGPART			; Explosion particle
	ld   [wActSpawnId], a
	xor  a							; Not part of the layout
	ld   [wActSpawnLayoutPtr], a
	ld   b, $08						; Spawn 8 of them
	ld   hl, ActS_ExplTbl			; Reading their settings off a table
	
	; In a loop, spawn the base actor, then alter their speed values.
.loop:
	push hl
	push bc
		call ActS_Spawn	; Spawn with default settings
		ld   e, l		; DE = Potentially a ptr to iActId
		ld   d, h
	pop  bc
	pop  hl
	ret  c				; Could it spawn? If not, abort early
	
	; byte0 - Sprite mapping
	inc  de ; iActRtnId
	inc  de ; iActSprMap
	ldi  a, [hl]		; Read byte0, seek to next
	ld   [de], a
	
	; byte5 - H Speed
	inc  de ; iActLayoutPtr
	inc  de ; iActXSub
	inc  de ; iActX
	inc  de ; iActYSub
	inc  de ; iActY
	inc  de ; iActSpdXSub
	inc  hl ; byte2
	inc  hl ; byte3
	inc  hl ; byte4
	inc  hl ; byte5
	ldi  a, [hl] 		; Read byte5, seek to next
	ld   [de], a		; Set subpixel speed
	inc  de ; iActSpdX
	xor  a
	ld   [de], a		; iActSpdX = 0
	
	; byte6 - V Speed
	inc  de ; iActSpdYSub
	ldi  a, [hl]		; Read byte6, seek to byte0 of next entry
	ld   [de], a		; Set subpixel speed
	inc  de ; iActSpdY
	xor  a
	ld   [de], a		; iActSpdY = 0
	
	dec  b				; Spawned all 8 particles?
	jr   nz, .loop		; If not, loop
	ret
	
; =============== ActS_SpawnAbsorb ===============
; Spawns the eight explosion particles when absorbing a weapon.
; These move inwards from the sides of the screen towards the center,
; which is where the player is expected to be.
ActS_SpawnAbsorb:
	ld   a, ACT_EXPLLGPART			; Explosion particle
	ld   [wActSpawnId], a
	xor  a							; Not part of the layout
	ld   [wActSpawnLayoutPtr], a
	ld   b, $08						; Spawn 8 of them
	ld   hl, ActS_ExplTbl			; Reading their settings off a table

	; In a loop, spawn the base actor, then alter their starting position & speed values.
	; The only difference between this and ActS_SpawnLargeExpl is that this one copies
	; the starting positions and flips the particle directions.
.loop:
	push hl
	push bc
		call ActS_Spawn	; Spawn with default settings
		ld   e, l		; DE = Potentially a ptr to iActId
		ld   d, h
	pop  bc
	pop  hl
	ret  c				; Could it spawn? If not, abort early
	
	; byte0 - Sprite mapping
	inc  de ; iActRtnId
	inc  de ; iActSprMap
	ldi  a, [hl]			; Read byte0, seek to next
	xor  ACTDIR_R|ACTDIR_D	; Flip both directions to make them move inward	
	ld   [de], a
	
	;--
	; The X and Y positions retrieved from the table make the actor spawn from an edge of the screen.
	
	; byte1/2 - X Position
	inc  de ; iActLayoutPtr
	inc  de ; iActXSub
	ldi  a, [hl]	; Read byte1, seek to next
	ld   [de], a	; Set X subpixel pos
	inc  de ; iActX
	ldi  a, [hl]	; Read byte2, seek to next
	ld   [de], a	; Set X pos
	
	; byte2/3 - Y Position
	inc  de ; iActYSub
	ldi  a, [hl]	; Read byte3, seek to next
	ld   [de], a	; Set Y subpixel pos
	inc  de ; iActY
	ldi  a, [hl]	; Read byte4, seek to next
	ld   [de], a	; Set Y pos
	;--
	
	; byte5 - H Speed
	inc  de
	ldi  a, [hl] 		; Read byte5, seek to byte6
	ld   [de], a		; Set subpixel speed
	inc  de ; iActSpdX
	xor  a
	ld   [de], a		; iActSpdX = 0
	
	; byte6 - V Speed
	inc  de ; iActSpdYSub
	ldi  a, [hl]		; Read byte6, seek to byte0 of next entry
	ld   [de], a		; Set subpixel speed
	inc  de ; iActSpdY
	xor  a
	ld   [de], a		; iActSpdY = 0
	
	dec  b				; Spawned all 8 particles?
	jr   nz, .loop		; If not, loop
	ret
	
; =============== ActS_ExplTbl ===============
; Explosion particle table, contains settings for each of the 8 actors.
; Has settings used for both inwards and outwards explosions
MACRO mExplPart
	db \1 ; Directions (relative to outward explosion)
	dw \2 ; X Position
	dw \3 ; Y Position
	db \4 ; H Speed
	db \5 ; V Speed
ENDM
ActS_ExplTbl:
	;         DIR                X      Y     HSpd VSpd
	mExplPart $00,               $5800, $103C, $00, $FF
	mExplPart ACTDIR_R,          $8230, $21D0, $B4, $B4
	mExplPart ACTDIR_R,          $93C4, $4C00, $FF, $00
	mExplPart ACTDIR_R|ACTDIR_D, $8230, $7630, $B4, $B4
	mExplPart ACTDIR_D,          $5800, $87C4, $00, $FF
	mExplPart ACTDIR_D,          $2DD0, $7630, $B4, $B4
	mExplPart $00,               $1C3C, $4C00, $FF, $00
	mExplPart $00,               $2DD0, $21D0, $B4, $B4

