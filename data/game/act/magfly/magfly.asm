; =============== Act_MagFly ===============
; ID: ACT_MAGFLY
; Flying Magnet that attracts the player.
Act_MagFly:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_MagFly_Init
	dw Act_MagFly_Move
	
; =============== Act_MagFly_Init ===============
Act_MagFly_Init:
	; Move 0.5px/frame forward
	ld   bc, $0080
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_MagFly_Move ===============
Act_MagFly_Move:
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Move forward
	call ActS_MoveBySpeedX
	
	;
	; Attract the player when they get close to its horizontal range.
	; This can't be done through the collision box as the magnet itself deals damage.
	;
	
	; Do not attract if the player is either hurt or invulnerable.
	; This causes the player to fall off when hitting the magnet directly.
	ld   a, [wPlHurtTimer]
	ld   b, a
	ld   a, [wPlInvulnTimer]
	or   b
	ret  nz
	
	; Only attract the player when on the ground or jumping.
	; This means it's possible to avoid getting attracted by sliding through.
	ld   a, [wPlMode]
	cp   PL_MODE_CLIMB
	ret  nc
	
	;--
	; A = Horizontal distance from player.
	; This is identical to ActS_GetPlDistanceX, except with wPlRelX 
	; and iActX swapped, which makes no difference.
	ldh  a, [hActCur+iActX]	; B = iActX
	ld   b, a
	ld   a, [wPlRelX]		; A = wPlRelX
	sub  b					; A = wPlRelX - iActX
	jr   nc, .chkDistance	; Did we underflow? (Player is to the left) If not, return
	xor  $FF				; Otherwise, flip the result's sign
	inc  a
	scf  					; and set the C flag since that xor cleared it
	;--
.chkDistance:
	; Don't attract if more than 4px away from the origin.
	; This makes the "collision box" for getting attracted infinitely tall, 7 pixels wide.
	cp   $04				; Distance >= $04?
	ret  nc					; If so, return
	
	; HORIZONTAL MOVEMENT
	; If we get here, always take the player for a ride
	ldh  a, [hActCur+iActSprMap]	; In the same direction as the magnet...
	ld   bc, $0080					; ...move 0.5px/frame
	call Pl_AdjSpeedByActDir
	
	; VERTICAL MOVEMENT
	; Do not move the player up if its center point is above the magnet's origin.
	ldh  a, [hActCur+iActY]		; Get actor Y pos
	add  PLCOLI_V				; Adding PLCOLI_V means the player's center will be the target
	ld   b, a
	ld   a, [wPlRelY]			; Get player Y pos
	cp   b						; PlY - PLCOLI_V < ActY?
	ret  c						; If so, return
	
	; Otherwise, force a 1px/frame upwards jump that can't be cut early.
	xor  a					; 0 subpx
	ld   [wPlSpdYSub], a
	inc  a					; 1px/frame
	ld   [wPlSpdY], a
	inc  a					; Player mode 2 (PL_MODE_FULLJUMP, forced jump)
	ld   [wPlMode], a
	ret
	
