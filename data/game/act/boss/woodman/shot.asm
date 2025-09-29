; =============== Act_WoodManLeafShield ===============
; ID: ACT_LEAFSHIELD
; Single leaf, part of a set of four that makes up Wood Man's Leaf Shield.
Act_WoodManLeafShield:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WoodManLeafShield_Init
	dw Act_WoodManLeafShield_Around
	dw Act_WoodManLeafShield_Thrown

; =============== Act_WoodManLeafShield_Init ===============
Act_WoodManLeafShield_Init:
	;
	; Set the origin point for the leaf shield.
	; While the leaves are set to rotate around Wood Man, that *only* happens from the next routine.
	;
	; Currently, they have the same coordinates as Wood Man himself, so the shield origin point is 13px above that.
	;
	ldh  a, [hActCur+iActX]				; X Origin: Wood Man's X position (center)
	ldh  [hActCur+iLeafShieldOrgX], a	
	ldh  a, [hActCur+iActY]				; Y Origin: Wood Man's Y position - 13 (middle)
	sub  $0B
	ldh  [hActCur+iLeafShieldOrgY], a
	jp   ActS_IncRtnId
	
; =============== Act_WoodManLeafShield_Around ===============
; Leaf Shield rotates around Wood Man, without moving the origin point.
Act_WoodManLeafShield_Around:
	
	;
	; Handle the rotation sequence.
	;
	; This is accomplished with a table of sine values that loop every $40 entries.
	; Each value is a position relative to the shield's origin, when summed together 
	; you get the final position.
	;
	; The rotation pattern using the sine is accomplished by having the X index
	; shifted forward by $10 entries, through the base table pointer itself being ahead.
	; To account for that it means the table is $50 bytes large in total, with the last
	; $10 being identical to the first $10.
	;
	; This has a similar effect to what's done by ActS_ApplyCirclePath, except the positions
	; aren't relative to each other, but to an origin point.
	;
	
	; X POSITION
	; iActX = iLeafShieldOrgX + Act_WoodManLeafShield_SinePat.y[iActTimer % $40]
	ldh  a, [hActCur+iActTimer]
	and  $3F									; Wrap around every $40 entries
	ld   hl, Act_WoodManLeafShield_SinePat.x	; HL = Ptr to table base
	ld   b, $00									; BC = iActTimer % $40
	ld   c, a
	add  hl, bc									; HL = Ptr to rel. offset
	ldh  a, [hActCur+iLeafShieldOrgX]			; Get absolute coordinate
	add  [hl]									; += relative from entry, to get final pos
	ldh  [hActCur+iActX], a						; Overwrite
	
	; Y POSITION
	; iActY = iLeafShieldOrgX + Act_WoodManLeafShield_SinePat.y[iActTimer % $40]
	ld   hl, Act_WoodManLeafShield_SinePat.y	; Same thing but for the other coordinate
	ldh  a, [hActCur+iActTimer]
	and  $3F
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [hActCur+iLeafShieldOrgY]
	add  [hl]
	ldh  [hActCur+iActY], a
	
	; Increment table index for next time we get here
	ldh  a, [hActCur+iActTimer]
	add  $01
	ldh  [hActCur+iActTimer], a
	
	; Wait until we've been signaled by Act_WoodMan to throw the shield.
	; For performance reasons, we're given a movement speed to apply to the origin point.
	ld   a, [wLeafShieldOrgSpdX]
	and  a							; Any throw speed set yet?
	ret  z							; If not, wait
	
	;--
	; [POI] Not necessary, the leaves don't move forward through their normal speed.
	;       Instead, the origin is moved forward through the speed Act_WoodMan wrote to wLeafShieldOrgSpdX.
	;       Maybe there was simpler logic on throw at some point, that *did* simply move the leaves forward without rotating them?
	call ActS_FacePl
	ld   bc, $0100
	call ActS_SetSpeedX
	;--
	jp   ActS_IncRtnId
	
; =============== Act_WoodManLeafShield_Thrown ===============
; Leaf Shield rotates around the origin point, which moves forward.
Act_WoodManLeafShield_Thrown:
	;
	; Move the shield's origin forward
	;
	ld   hl, hActCur+iLeafShieldOrgX	; iLeafShieldOrgX += wLeafShieldOrgSpdX
	ld   a, [wLeafShieldOrgSpdX]
	add  [hl]
	ld   [hl], a
	
	;
	; Then do the usual process for rotating the leaves.
	;
	
	; X POSITION
	; iActX = iLeafShieldOrgX + Act_WoodManLeafShield_SinePat.y[iActTimer % $40]
	ldh  a, [hActCur+iActTimer]
	and  $3F									; Wrap around every $40 entries
	ld   hl, Act_WoodManLeafShield_SinePat.x	; HL = Ptr to table base
	ld   b, $00									; BC = iActTimer % $40
	ld   c, a
	add  hl, bc									; HL = Ptr to rel. offset
	ldh  a, [hActCur+iLeafShieldOrgX]			; Get absolute coordinate
	add  [hl]									; += relative from entry, to get final pos
	ldh  [hActCur+iActX], a						; Overwrite
	
	; Y POSITION
	; iActY = iLeafShieldOrgX + Act_WoodManLeafShield_SinePat.y[iActTimer % $40]
	ld   hl, Act_WoodManLeafShield_SinePat.y	; Same thing but for the other coordinate
	ldh  a, [hActCur+iActTimer]
	and  $3F
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [hActCur+iLeafShieldOrgY]
	add  [hl]
	ldh  [hActCur+iActY], a
	
	; Increment table index for next time we get here
	ldh  a, [hActCur+iActTimer]
	add  $01
	ldh  [hActCur+iActTimer], a
	
	ret
	
; =============== Act_WoodManLeafShield_SinePat ===============
; Leaf positions, relative to the shield's origin.
; See also: Act_WoodManLeafShield_Around
Act_WoodManLeafShield_SinePat:
.y: db $F0,$F0,$F0,$F1,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8,$FA,$FB,$FD,$FE ; $00 ;
.x:	db $00,$02,$03,$05,$06,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$0F,$10,$10 ; $10 ; $00
	db $10,$10,$10,$0F,$0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$06,$05,$03,$02 ; $20 ; $10
	db $00,$FE,$FD,$FB,$FA,$F8,$F7,$F6,$F5,$F4,$F3,$F2,$F1,$F1,$F0,$F0 ; $30 ; $20
	db $F0,$F0,$F0,$F1,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8,$FA,$FB,$FD,$FE ;     ; $30

; =============== Act_WoodManLeafRise ===============
; ID: ACT_LEAFRISE
; Leaf rising up from Wood Man.
Act_WoodManLeafRise:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WoodManLeafRise_Init
	dw Act_WoodManLeafRise_MoveU

; =============== Act_WoodManLeafRise_Init ===============
Act_WoodManLeafRise_Init:
	ldh  a, [hActCur+iActSprMap]	; Move up
	and  $FF^ACTDIR_D				; (clear down direction flag)
	ldh  [hActCur+iActSprMap], a
	ld   bc, $0200					; At 2px/frame
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_WoodManLeafRise_MoveU ===============
Act_WoodManLeafRise_MoveU:
	; Move up at 2px/frame, until they go offscreen.
	; Act_WoodMan waits for that before throwing the shield.
	call ActS_MoveBySpeedY
	ret
	
; =============== Act_WoodManLeafFall ===============
; ID: ACT_LEAFFALL
; Falling leaf, which moves back and forth.
Act_WoodManLeafFall:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WoodManLeafFall_Init
	dw Act_WoodManLeafFall_Move

; =============== Act_WoodManLeafFall_Init ===============
Act_WoodManLeafFall_Init:
	; Move down, and move right as initial horizontal direction
	ldh  a, [hActCur+iActSprMap]
	or   ACTDIR_R|ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	ld   bc, $0100			; 1px/frame horizontally
	call ActS_SetSpeedX
	ld   bc, $0060			; 0.375px/frame down
	call ActS_SetSpeedY
	ld   a, $10				; Turn every 16 frames
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_WoodManLeafFall_Move ===============
Act_WoodManLeafFall_Move:
	;
	; Move by the previously set speed
	;
	call ActS_MoveBySpeedX
	call ActS_MoveBySpeedY
	
	;
	; Turn every 16 frames
	;
	ldh  a, [hActCur+iActTimer]
	sub  $01						; TurnTimer--
	ldh  [hActCur+iActTimer], a	; Has it elapsed?
	ret  nz							; If not, keep moving at that direction
	
	ldh  a, [hActCur+iActSprMap]	; Otherwise, turn around horizontally
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	ld   a, $10						; Move for 16 frames to the other side
	ldh  [hActCur+iActTimer], a
	ret
	
