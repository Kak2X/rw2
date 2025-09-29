; =============== Act_Koma ===============
; ID: ACT_KOMA
; Spinning top projectile spawned by Act_Komasaburo.	
Act_Koma:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Koma_Init
	dw Act_Koma_MoveH
	dw Act_Koma_FallV
	DEF ACTRTN_KOMA_MOVEH = $01
	
; =============== Act_Koma_Init ===============
Act_Koma_Init:
	ld   bc, $0180				; 1.5px/frame forward
	call ActS_SetSpeedX
	ld   a, 60*3				; Explode after 3 seconds (outside of when they fall down)
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Koma_MoveH ===============
; Spinning top moves horizontally.
Act_Koma_MoveH:
	; Use frames $00-$01, at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	
	; When the life timer elapses, explode (without dropping items)
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	jr   nz, .moveH
	jp   ActS_Explode
.moveH:
	; Move horizontally, turning the other way when hitting a wall
	call ActS_MoveBySpeedX_Coli
	call nc, ActS_FlipH
	
	; If there's no ground below, start falling
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   %11
	ret  nz
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_Koma_FallV ===============
; Spinning top falls off a platform.
; During this time, the life timer is paused (ie: not handled).
Act_Koma_FallV:
	; Use frames $00-$01, at 1/4 speed
	ld   c, $02
	call ActS_Anim2
	
	; Keep moving down until we hit solid ground.
	call ActS_ApplyGravityD_Coli
	ret  c
	
	; Then return to moving forward
	ld   a, ACTRTN_KOMA_MOVEH
	ldh  [hActCur+iActRtnId], a
	ret
	
