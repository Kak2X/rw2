; =============== Act_ExplLgPart ===============
; ID: ACT_EXPLLGPART
; Individual particle for the large 8-way explosion displayed when either:
; - The player dies
; - A boss dies
; - Energy is being absorbed
; See also: ActS_SpawnLargeExpl, ActS_SpawnAbsorb
Act_ExplLgPart:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_ExplLgPart_Init
	dw Act_ExplLgPart_Move
; =============== Act_ExplLgPart_Init ===============
Act_ExplLgPart_Init:
	; Boss explosions and the weapon absorption particles move twice as fast.
	ld   a, [wLvlEnd]
	cp   LVLEND_PLDEAD			; Is the player exploding?
	call nz, ActS_DoubleSpd		; If not, speed up
	jp   ActS_IncRtnId
; =============== Act_ExplLgPart_Move ===============
Act_ExplLgPart_Move:
	ld   bc, ($03 << 8)|$01			; B = 3 frames, C = 1/8 speed
	call ActS_AnimCustom
	call ActS_ApplySpeedFwdX
	call ActS_ApplySpeedFwdY
	ret
	
