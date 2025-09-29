; =============== ActS_SetShotSpd ===============
; Alters the newly spawned actor shot's speed.
; IN
; - A: Shot direction and sprite ID (iActSprMap)
; - HL: Ptr to spawned actor slot
; - BC: Horizontal speed (forward)
; - DE: Vertical speed (upwards unless the calling code manually changes iActSprMap after returning)
ActS_SetShotSpd:
	; Set shot direction
	inc  l ; iActRtnId
	inc  l ; iActSprMap
	ld   [hl], a ; iActSprMap
	
	; Set horizontal and vertical speed
	ld   a, l
	add  iActSpdXSub - iActSprMap
	ld   l, a
	ld   [hl], c ; C = iActSpdXSub
	inc  hl
	ld   [hl], b ; B = iActSpdX
	inc  hl
	ld   [hl], e ; E = iActSpdYSub
	inc  hl
	ld   [hl], d ; D = iActSpdY
	ret
	
