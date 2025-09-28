; =============== Act_KaminariCloud ===============
; ID: ACT_KAMINARICLOUD
; Rotating cloud platform the player can stand on.
Act_KaminariCloud:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_KaminariCloud_Init
	dw Act_KaminariCloud_Move

; =============== Act_KaminariCloud_Init ===============
Act_KaminariCloud_Init:
	; Start moving anticlockwise, from the top.
	call ActS_InitCirclePath
	ld   a, ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	
	; Spawn the child enemy on top of the cloud, which is the part that can be shot.
	ld   a, ACT_KAMINARIGORO
	ld   bc, ($00 << 8)|LOW(-$10) ; $10px up
	call ActS_SpawnRel
	
	; Share the cloud's slot pointer to the child, which it can use to sync its position.
	; To save time, it's already pointing to the X position.
	ld   de, iActGoroCloudXPtr	; HL = Seek to child iActGoroCloudXPtr
	add  hl, de
	ld   a, [wActCurSlotPtr]	; A = Low byte of ptr to cloud iActX
	add  iActX
	ld   [hl], a				; Save to iActGoroCloudXPtr
	
	jp   ActS_IncRtnId
	
; =============== Act_KaminariCloud_Move ===============
; Handles the rotation movement path.
Act_KaminariCloud_Move:
	;
	; Animate the propeller under the cloud.
	; Use sprites $00-$01 at 1/4 speed.
	;
	ldh  a, [hTimer]
	rrca ; /2			; Every 4 frames...
	rrca ; /4
	and  $01			; Alternate between $00 and $01
	ld   [wActCurSprMapBaseId], a
	
	;
	; Continue moving on the large circle path, at half speed.
	; ActS_ApplyCirclePath will automatically flip the cloud's direction as needed,
	; which is why it flips horizontally when it starts moving left.
	;
	ld   a, ARC_LG
	call ActS_ApplyCirclePath	; Use large path
	call ActS_HalfSpdSub		; At half speed
	call ActS_ApplySpeedFwdX	; Move the player
	call ActS_ApplySpeedFwdY
	
	;
	; If the player is standing on the cloud platform, drag him along with it.
	;
	ld   a, [wActCurSlotPtr]		; A = Our slot
	ld   b, a
	ld   a, [wActPlatColiSlotPtr]	; B = Slot the player is standing on
	cp   b							; Do they match?
	ret  nz							; If not, return
	; Otherwise, add the cloud's horizontal speed to player's, which keeps him horizontally aligned.
	; There's no need to do so for the vertical speed, as the way platform collision works accounts for it.
	ldh  a, [hActCur+iActSpdXSub]	; BC = Cloud horizontal speed
	ld   c, a
	ldh  a, [hActCur+iActSpdX]
	ld   b, a
	ldh  a, [hActCur+iActSprMap]	; A = Cloud direction
	jp   Pl_SetSpeedByActDir		; Move player by that
	
