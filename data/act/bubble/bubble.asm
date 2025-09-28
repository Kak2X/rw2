; =============== Act_Bubble ===============
; ID: ACT_BUBBLE
; Air bubble spawned by the player when underwater.
Act_Bubble:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Bubble_Init
	dw Act_Bubble_MoveU
	dw Act_Bubble_Pop

; =============== Act_Bubble_Init ===============
Act_Bubble_Init:
	ld   bc, $0080			; 0.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0080			; 0.5px/frame up
	call ActS_SetSpeedY
	
	; Randomize time before turning the first time.
	call Rand					; iActTimer = (Rand & $F7) + $0F
	and  $FF^$08
	add  $0F
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Bubble_MoveU ===============
Act_Bubble_MoveU:
	; Turn horizontally every ~half a second
	ldh  a, [hActCur+iActTimer]	; iActTimer++
	add  $01
	ldh  [hActCur+iActTimer], a
	and  $1F						; Timer % $20 != 0?
	call z, ActS_FlipH				; If so, turn around
	
	; Move forward 0.5px/frame, turning if a solid wall is hit
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	
	; Move up 0.5px/frame
	call ActS_ApplySpeedFwdY
	
	; Continue doing the above until we exit out of a water block.
	; Typically this happens when the bubble hits the "ceiling" or a water surface.
	ldh  a, [hActCur+iActX]		; X Target: ActX (center)
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Target: ActY (bottom)
	ld   [wTargetRelY], a
	;--
	; [BUG] But why? The only reason this is typically unnoticed is that
	;       there usually are empty blocks above water ones.
	call Lvl_GetBlockId			; Is there a solid block?
	ret  nc						; If so, return
	;--
	cp   BLOCKID_WATER			; Is it a water block?
	ret  z						; If so, return
	cp   BLOCKID_WATERSPIKE		; Is it an underwater spike?
	ret  z						; If so, return
	
	; Then pop it. Show popped sprite for 8 frames
	ld   a, $01
	call ActS_SetSprMapId
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Bubble_Pop ===============
Act_Bubble_Pop:
	; Wait those 8 frames...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Then despawn
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
