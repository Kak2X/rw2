; =============== Act_PickelmanBull ===============
; ID: ACT_PICKELBULL
; Pickelman riding a bulldozer.
Act_PickelmanBull:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_PickelmanBull_Init
	dw Act_PickelmanBull_MoveFwd
	dw Act_PickelmanBull_Shake

; =============== Act_PickelmanBull_Init ===============
Act_PickelmanBull_Init:
	; Move forward 0.5px/frame
	ld   bc, $0080
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
	
; =============== Act_PickelmanBull_MoveFwd ===============
; Moves the bulldozer forward.
Act_PickelmanBull_MoveFwd:
	; Animate wheels
	ld   c, $01
	call ActS_Anim2
	
	; Move forward
	call ActS_ApplySpeedFwdXColi	; Hit a solid wall?
	jp   nc, ActS_FlipH				; If so, turn
	call ActS_GetBlockIdFwdGround	; Is there no ground forward?
	jp   c, ActS_FlipH				; If so, turn
	
	; This forward movement happens for a random amount of frames.
	; Each time we get there, there's a ~3% chance of shaking for a bit.
	call Rand		; A = Rand()
	cp   $08		; A >= $09?
	ret  nc			; If so, return
					; 1/32 chance of getting here
	
	; Stutter for half a second
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_PickelmanBull_Shake ===============
; Shakes the bulldozer.
Act_PickelmanBull_Shake:
	; Still animate wheels
	ld   c, $01
	call ActS_Anim2
	
	; Go back to moving forward after the 30 frames pass
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	jp   z, ActS_DecRtnId
	
	; Alternate between moving left and right every 4 frames, at 1px/frame.
	ldh  a, [hActCur+iActTimer]	; A = Timer
	ld   hl, hActCur+iActX			; HL = Ptr to iActX
	bit  2, a						; Timer & 4 == 0?
	jr   z, .moveR					; If so, move right
.moveL:
	dec  [hl]						; iActX--
	ret
.moveR:
	inc  [hl]						; iActX++
	ret
	
