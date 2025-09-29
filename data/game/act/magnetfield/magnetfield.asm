; =============== Act_MagnetField ===============
; ID: ACT_MAGNETFIELD
; Magnetic field that always attracts the player to the right.
; The actual attraction itself is done by its collision type (ACTCOLI_MAGNET),
; this merely displays its wave animation near the visible magnet block.
Act_MagnetField:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_MagnetField_Init
	dw Act_MagnetField_Anim

; =============== Act_MagnetField_Init ===============
Act_MagnetField_Init:
	; In the actor layout, the magnet is placed directly inside the magnet block.
	; It instead should be placed vertically centered on its left.
	ldh  a, [hActCur+iActX]		; Move left 1 block
	sub  BLOCK_H
	ldh  [hActCur+iActX], a
	ldh  a, [hActCur+iActY]		; Move down by 4 pixels
	add  $04					; As it's around 1.5blocks tall, that will vertically center it.
	ldh  [hActCur+iActY], a
	jp   ActS_IncRtnId
	
; =============== Act_MagnetField_Anim ===============
Act_MagnetField_Anim:
	; Use frames $00-$03 at 1/8 speed
	ld   bc, ($03 << 8)|$01
	call ActS_AnimCustom
	ret
	
