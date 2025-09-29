; =============== Act_NeoMonking ===============
; ID: ACT_NEOMONKING
Act_NeoMonking:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NeoMonking_WaitGround
	dw Act_NeoMonking_JumpCeil
	dw Act_NeoMonking_WaitCeil
	dw Act_NeoMonking_DropCeil
	dw Act_NeoMonking_InitJump
	dw Act_NeoMonking_JumpU
	dw Act_NeoMonking_JumpD
	DEF ACTRTN_NEOMONKING_INITJUMP = $04

; =============== Act_NeoMonking_WaitGround ===============
; Waits on the ground until the player gets close.
Act_NeoMonking_WaitGround:
	ld   c, $01
	call ActS_Anim2
	call ActS_FacePl
	
	; Wait until the player gets within 4 blocks
	call ActS_GetPlDistanceX
	cp   BLOCK_H*4
	ret  nc
	
	; Set 4px/frame jump speed
	ld   bc, $0400
	call ActS_SetSpeedY
	
	; Jump to the ceiling
	jp   ActS_IncRtnId
	
; =============== Act_NeoMonking_JumpCeil ===============
; Jumps up in the air.
Act_NeoMonking_JumpCeil:
	; Use frames $00-$01, at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	call ActS_FacePl
	
	; Move up at 4px/frame until a solid block is above
	call ActS_MoveBySpeedY	; Move up
	ldh  a, [hActCur+iActX]		; X Target: ActX
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Target: ActY - $18
	sub  $18
	ld   [wTargetRelY], a
	call Lvl_GetBlockId			; Is there a solid block there?
	ret  c						; If not, return
	jp   ActS_IncRtnId			; Start idling
	
; =============== Act_NeoMonking_WaitCeil ===============
; Holds on the ceiling until the player gets even closer.
Act_NeoMonking_WaitCeil:
	; Use frames $02-$05, at 1/8 speed
	ld   c, $01
	call ActS_Anim4
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	
	call ActS_FacePl
	
	; Wait until the player gets within 1 block
	call ActS_GetPlDistanceX
	cp   BLOCK_H
	ret  nc
	
.startJumpD:
	; Reset relative frame, in preparation for the next base 
	call ActS_ClrSprMapId
	
	; Reset gravity
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMonking_DropCeil ===============
; Jumps down from the ceiling.
Act_NeoMonking_DropCeil:
	; Use frame $06, no animation
	ld   a, $06
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity until we touch a solid block
	call ActS_ApplyGravityD_Coli
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_NeoMonking_InitJump ===============
; Sets up a jump towards the player.
Act_NeoMonking_InitJump:
	xor  a
	ldh  [hActCur+iActSprMap], a
	
	call ActS_FacePl		; Towards the player
	ld   bc, $0180			; 1.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0300			; 3px/frame jump
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_NeoMonking_JumpU ===============
; Handles jump arc while moving up.
Act_NeoMonking_JumpU:
	call ActS_MoveBySpeedX_Coli	; Move forward
	call nc, ActS_FlipH				; Touched a wall? If so, rebound
	call ActS_ApplyGravityU_Coli		; Move up
	ret  c							; Reached the peak? If not, return
	jp   ActS_IncRtnId				; Start moving down
	
; =============== Act_NeoMonking_JumpD ===============
; Handles jump arc while moving down.
Act_NeoMonking_JumpD:
	call ActS_MoveBySpeedX_Coli	; Move forward
	call nc, ActS_FlipH				; Touched a wall? If so, rebound
	call ActS_ApplyGravityD_Coli	; Move down
	ret  c							; Touched the ground? If not, return
	ld   a, ACTRTN_NEOMONKING_INITJUMP	; Otherwise, immediately set up a new jump
	ldh  [hActCur+iActRtnId], a		; Unlike RM3, these will never return to idling
	ret
	
