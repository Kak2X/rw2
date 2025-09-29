; =============== Act_Block ===============
; ID: ACT_BLOCK0, ACT_BLOCK1, ACT_BLOCK2, ACT_BLOCK3
; Appearing block, in four separately timed variants.
Act_Block:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Block_Hide
	dw Act_Block_DelayShow
	dw Act_Block_Solid0
	dw Act_Block_Solid1
	dw Act_Block_Solid2
	dw Act_Block_Solid3
	DEF ACTRTN_BLOCK_HIDE = $00

; =============== Act_Block_Hide ===============
; Hides the block in an intangible state until it's time to make it appear.
Act_Block_Hide:
	; Hide the block and make it intangible.
	ld   b, ACTCOLI_PASS
	call ActS_SetColiType
	ld   a, $00
	call ActS_SetSprMapId
	
	;
	; Determine if the block's timing currently makes it visible, and if so, advance the routine.
	;
	; There are four separate actor IDs for the disappearing block. Given groups of four seconds,
	; each actor starts appearing on a specific one, in order.
	;
	; ie: 
	; - ACT_BLOCK0 starts it sequence at wGameTime % 4 == 0
	; - ACT_BLOCK1 starts it sequence at wGameTime % 4 == 1
	;   and so on
	;
	
	; Get the block number that can currently activate
	ld   a, [wGameTime]			; B = wGameTime % 4
	and  $03
	ld   b, a
	
	; Get the block number of this actor, off its ID
	ldh  a, [hActCur+iActId]	; B = (iActId & $7F) - ACT_BLOCK0
	and  $FF^ACTF_PROC
	sub  ACT_BLOCK0
	
	cp   b						; Do the block numbers match? 
	ret  nz						; If not, return (keep waiting)
	
	;
	; [BUG] If we got here on the first try, the blocks can desync since we may get here at any
	;       possible frame of the second, but the delay always waits for a fixed amount of time.
	;       
	;		Because of how much time a block needs to wait after it hides itself, any desync
	;       fixes itself the second time we get here (see wGameTime shift markers below)
	;
	
	; Delay appearing for a second 
	; This should have delayed for 60 - wGameTimeSub.
	ld   a, 60
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Block_DelayShow ===============
Act_Block_DelayShow:
	; Wait for a second before making the block show up
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; [wGameTime shift = $01/$04]
	
	ld   a, SFX_BLOCK			; Play block appear sound
	mPlaySFX
	ld   b, ACTCOLI_PLATFORM	; Make platform tangible
	call ActS_SetColiType
	
	ld   a, 10					; For next mode
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Block_Solid0 ===============
; First of four routines that manually handle the block's animation.
; ActS_Anim* is not being used because not only the amount of time to wait on each sprite is
; higher than what it supports, each sprite is also displayed for a different amount of frames.
;
; Use visible sprite $01 for 10 frames
Act_Block_Solid0:
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; [wGameTime shift = $01.$0A/$04]
	
	ld   a, 10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Block_Solid1 ===============
; Use visible sprite $02 for 10 frames
Act_Block_Solid1:
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; [wGameTime shift = $01.$14/$04]
	
	ld   a, 20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Block_Solid2 ===============
; Use visible sprite $03 for 20 frames
Act_Block_Solid2:
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; [wGameTime shift = $01.$28/$04]
	
	ld   a, 60
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Block_Solid3 ===============
; Use visible sprite $04 for a second
Act_Block_Solid3:
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; [wGameTime shift = $02.$28/$04]
	; That leaves over a second of buffer from $04, fixing any desync.
	
	ld   a, ACTRTN_BLOCK_HIDE
	ldh  [hActCur+iActRtnId], a
	ret
	
