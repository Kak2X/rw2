; =============== Act_Mole ===============
; ID: ACT_MOLE
; Small enemy that drills into the ground vertically.
; Spawned by Act_MoleSpawner.
Act_Mole:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Mole_Init
	dw Act_Mole_DigBorder
	dw Act_Mole_DigSolid0
	dw Act_Mole_DigOut
	dw Act_Mole_DigAir
	dw Act_Mole_DigIn
	dw Act_Mole_DigSolid1

; =============== Act_Mole_Init ===============
Act_Mole_Init:
	;
	; Randomize the horizontal position of the mole.
	; The spawner has already randomized the vertical position but not the horizontal
	; once, since for the latter not all positions are accepted.
	;
	; This means that, currently, its X position is the same as the spawner's.
	; Offset that by a random value:
	; iActX += (Rand() * 5 / 16 - 2) * 16
	;
	
	call Rand	; Rand() will be a "subpixel" value
	ld   l, a	; HL = DE = Rand()
	ld   e, a
	xor  a
	ld   h, a
	ld   d, a
	add  hl, hl	; HL *= 2 (*2)
	add  hl, hl	; HL *= 2 (*4)
	add  hl, de ; HL += DE (*5)
	ld   a, h	; A = H - 2
	sub  $02
	add  a		; A *= 2 (*2)
	add  a		; A *= 2 (*4)
	add  a		; A *= 2 (*8)
	add  a		; A *= 2 (*16)
	
	ld   hl, hActCur+iActX	; HL = Ptr to iActX
	add  [hl]				; Add it to the offset
	ld   [hl], a			; Save back
	
	; If the mole would spawn too close to the player, try again next time.
	; When that happens, this can make the mole visibly move around.
	call ActS_GetPlDistanceX
	cp   $10
	ret  c
	
	; Otherwise, we can start moving fast, 2px/frame (see below)
	ld   bc, $0200
	call ActS_SetSpeedY
	
	ld   a, $02
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigBorder ===============
; First in a series of *sequential* routines that handle movement.
;
; It goes like this:
; - Dig fast through the empty border area
; - Dig fast through the ground
; - Slowly dig out of the ground
; - Move a bit faster when out
; - Slowly dig into the ground
; - Dig fast through the ground, into the offscreen
;
; As these are sequential, it can only handle the presence of a single tunnel,
; if there were a second one it'd be treated like solid ground.
Act_Mole_DigBorder:
	; Move at 2px/frame when not fully inside a block after spawning.
	; This is mainly here to account for the offscreen area being treated as blank space,
	; which would cause the second mode to end earlier than intended.
	call Act_Mole_ChkCommon
	and  a					; A == 0? (U solid, D solid)
	ret  nz					; If not, wait
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigSolid0 ===============
Act_Mole_DigSolid0:
	; Move at 2px/frame when inside a solid block, until we find an empty one either up or down
	call Act_Mole_ChkCommon
	and  a					; A == 0? (U solid, D solid)
	ret  z					; If so, wait

	ld   bc, $0020
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigOut ===============
Act_Mole_DigOut:
	; Move at 0.125px/frame when digging out of the ground, until we're fully outside
	call Act_Mole_ChkCommon
	cp   %11				; A == 3? (U blank, D blank)
	ret  nz					; If not, wait
	
	ld   bc, $0080
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigAir ===============
Act_Mole_DigAir:
	; Move at 0.5px/frame when moving in the air, until we find a solid block above or below
	call Act_Mole_ChkCommon
	cp   %11				; A == 3? (U blank, D blank)
	ret  z					; If so, wait
	
	ld   bc, $0020
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigIn ===============
Act_Mole_DigIn:
	; Move at 0.125px/frame when digging into the ground, until we're fully inside
	call Act_Mole_ChkCommon
	and  a					; A == 0? (U solid, D solid)
	ret  nz					; If not, wait

	ld   bc, $0200
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_Mole_DigSolid1 ===============
Act_Mole_DigSolid1:
	; Move at 2px/frame when inside a solid block, until we get offscreened
	call ActS_MoveBySpeedY
	ret
	
; =============== Act_Mole_ChkCommon ===============
; Performs common actions when moving.
; OUT
; - A: Collision Flags
;      ------UD
;      U - If set, the block above is not solid
;      D - If set, the block below is not solid
; - Z Flag: If set, the animation has advanced
Act_Mole_ChkCommon:
	; Set base sprite for animation (digging up or down)
	ldh  a, [hActCur+iMoleSprMapBaseId]
	ld   [wActCurSprMapBaseId], a
	
	; Move vertically by the specified speed
	call ActS_MoveBySpeedY
	
	;--
	;
	; Check for collision on both the top and bottom of the actor's bounding box,
	; storing the result into A.
	;
	
	; BOTTOM SENSOR
	ldh  a, [hActCur+iActX]	; X Sensor: ActX (center)
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]	; Y Sensor: ActY (bottom)
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; C Flag = Is empty?
	ld   a, $00
	adc  a					; Store the result to bit0
	ld   b, a				; Put here for later
	
	; TOP SENSOR
	ld   a, [wTargetRelY]	; Y Sensor: ActY - $0E (top)
	sub  $0E
	ld   [wTargetRelY], a
	push bc
		call Lvl_GetBlockId	; C Flag = Is empty?
		ld   a, $00
		adc  a				; Store the result to bit0
		add  a				; >>1 to bit1
	pop  bc
	add  b					; Merge with other check
	;--
	
	;
	; Handle the animation manually, at 1/2 speed.
	;
	ld   hl, hActCur+iActTimer
	dec  [hl]				; Animation timer elapsed?
	ret  nz					; If not, return
	push af
		; There are two animations, one for digging up, the other for digging down.
		; Both are made of 2 sprites, so flip bit0 to alternate between them.
		ldh  a, [hActCur+iMoleSprMapBaseId]
		xor  $01
		ldh  [hActCur+iMoleSprMapBaseId], a
		; Flip again after 2 frames
		ld   [hl], $02		; iActTimer = $02
	pop  af
	ret
	
