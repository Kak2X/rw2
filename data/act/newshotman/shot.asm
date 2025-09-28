; =============== Act_NewShotmanShotV ===============
; ID: ACT_NEWSHOTMANSHOTV
; New Shotman's vertical shot, spawned in pairs, which moves in an arc.
Act_NewShotmanShotV:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NewShotmanShotV_JumpU
	dw Act_NewShotmanShotV_JumpD
; =============== Act_NewShotmanShotV_JumpU ===============
; Jump, pre-peak.
Act_NewShotmanShotV_JumpU:
	; [POI] Bounce on solid walls
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId
; =============== Act_NewShotmanShotV_JumpD ===============
; Jump, post-peak.
Act_NewShotmanShotV_JumpD:
	; [POI] Bounce on solid walls
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Apply gravity while moving down until we hit the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	; Despawn when touching the ground
	jp   ActS_Explode
	
; =============== Act_NewShotmanShotH ===============
; ID: ACT_NEWSHOTMANSHOTH
; New Shotman's horizontal shot, which moves horizontally at a fixed 1px/frame speed.
Act_NewShotmanShotH:
	; Set up the speed the first time we get here
	ldh  a, [hActCur+iActRtnId]
	or   a				; Routine != 0?
	jr   nz, .move		; If so, jump
.init:
	ld   bc, $0100		; 1px/frame forward
	call ActS_SetSpeedX
	jp   ActS_IncRtnId
.move:
	; This is the same animation Act_NeoMetShot does, but inconsistently the vertical shot doesn't.
	ld   c, $01
	call ActS_Anim4
	; Move forward at 1px/frame
	call ActS_ApplySpeedFwdX
	ret
	
