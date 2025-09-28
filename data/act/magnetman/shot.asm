; =============== Act_MagnetManShot ===============
; ID: ACT_MAGNETMISSILE
; Magnet that moves horizontally, then straight down when it sees the player.
; As it's thrown by Magnet Man on the ceiling, it doesn't ever need to move up.
Act_MagnetManShot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_MagnetManShot_Init
	dw Act_MagnetManShot_MoveNoChkH
	dw Act_MagnetManShot_MoveChkH
	dw Act_MagnetManShot_MoveD

; =============== Act_MagnetManShot_Init ===============
Act_MagnetManShot_Init:
	ld   bc, $0200				; Move forward at 2px/frame
	call ActS_SetSpeedX
	ld   a, $0C					; Move for 12 frames with no checks	
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_MagnetManShot_MoveNoChkH ===============
; Move forward without checking if the player is below.
; This cooldown period prevents the magnets from directly moving down when
; the player is under Magnet Man.
Act_MagnetManShot_MoveNoChkH:
	; Move forward at 2px/frame for 12 frames
	call ActS_ApplySpeedFwdXColi		; Touched a solid block?
	jr   nc, Act_MagnetManShot_Explode	; If so, explode
	ldh  a, [hActCur+iActTimer]
	sub  $01							; Timer--
	ldh  [hActCur+iActTimer], a		; Timer != 0?
	ret  nz								; If so, return
	jp   ActS_IncRtnId
	
; =============== Act_MagnetManShot_MoveChkH ===============
; Move forward, checking for the player's position.
Act_MagnetManShot_MoveChkH:
	; Move forward at 2px/frame, explode if touching a solid block
	call ActS_ApplySpeedFwdXColi
	jr   nc, Act_MagnetManShot_Explode
	
	; If the player is below, halt and drop down
	call ActS_GetPlDistanceX
	cp   $04			; DiffX >= $04?
	ret  nc				; If so, return
	
	ld   bc, $0200		; Drop down at 2px/frame
	call ActS_SetSpeedY
	ld   a, $02			; Use downward-facing sprite
	call ActS_SetSprMapId
	jp   ActS_IncRtnId
	
; =============== Act_MagnetManShot_MoveD ===============
; Move down until we touch solid ground, then explode.
Act_MagnetManShot_MoveD:
	call ActS_ApplySpeedFwdYColi
	jr   nc, Act_MagnetManShot_Explode
	ret
	
; =============== Act_MagnetManShot_Explode ===============
Act_MagnetManShot_Explode:
	jp   ActS_Explode
	
