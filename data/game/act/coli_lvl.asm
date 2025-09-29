; =============== ActS_GetBlockIdFwdGround ===============
; Gets the block ID that collides with the actor's forward ground sensor.
; OUT
; - A: Block ID
; - C Flag: If set, the block is not solid
; - wPlYCeilMask: Ceiling collision mask
ActS_GetBlockIdFwdGround:
	; This is basically a wrapper to Lvl_GetBlockId
	
	; B = Actor's collision box width 
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   b, a
	
	; Y Target is on the ground
	ldh  a, [hActCur+iActY]
	inc  a					; one pixel below the origin
	ld   [wTargetRelY], a
	
	; X Target depends on whatever direction we're facing
	ldh  a, [hActCur+iActSprMap]
	bit  ACTDIRB_R, a		; Facing right?
	jr   nz, .chkR			; If so, it's on the right corner
.chkL:						; Otherwise, the left corner
	ldh  a, [hActCur+iActX]
	sub  b					
	ld   [wTargetRelX], a
	jp   Lvl_GetBlockId		; Bottom-left
.chkR:
	ldh  a, [hActCur+iActX]
	add  b
	ld   [wTargetRelX], a
	jp   Lvl_GetBlockId		; Bottom-right
	
; =============== ActS_GetGroundColi ===============
; Gets ground solidity flags for the current actor.
; Used exclusively to detect if the actor has moved off solid ground.
; OUT
; - wColiGround: Bitmask containing the ground solidity info.
;                Each bit, if set, marks that there's no solid ground at that position.
;                ------LR
;                L -> Bottom-left corner
;                R -> Bottom-right corner
;   In practice, this is only used by some actors that need to know if there's any
;   solid ground below (ie: both bits set) to make them fall down.
ActS_GetGroundColi:

	; Reset return value
	xor  a
	ld   [wColiGround], a
	
	DEF tActColiH = wTmpCF52
	
	; Read out the actor's collision box width to a temp area
	ld   h, HIGH(wActColi)
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ldi  a, [hl]
	ld   [tActColiH], a
	
	;
	; Do the collision checks and store their result into wColiGround.
	;
	; This needs to detect if there's currently any solid block on the ground in either direction.
	; To do that, two sensors are needed, one on each side, both on the ground.
	;
	; There is no center sensor here, but it doesn't matter.
	;
	
	; Y coordinate of the sensor is fixed, it's one pixel below the origin
	ldh  a, [hActCur+iActY]
	inc  a
	ld   [wTargetRelY], a
	
	; LEFT SIDE
	ld   a, [tActColiH]			; Get radius width
	ld   b, a
	ldh  a, [hActCur+iActX]		; Get X position
	sub  b						; Move to left border
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; Solid block there? (if not, C flag set)
	
	ld   hl, wColiGround		; Shift to bit0
	rl   [hl]
	
	; RIGHT SIDE
	ld   a, [tActColiH]			; Get radius width
	ld   b, a
	ldh  a, [hActCur+iActX]		; Get X position
	add  b						; Move to right border
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; Solid block there? (if not, C flag set)
	
	ld   hl, wColiGround		; Shift to bit0, and the L one to bit1
	rl   [hl]
	ret
	
