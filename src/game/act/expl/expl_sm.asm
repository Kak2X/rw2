; =============== Act_ExplSm ===============
; ID: ACT_EXPLSM
; Small explosion.
;
; This actor isn't directly spawned in a level -- when defeating enemies, their actor ID
; gets replaced by ACT_EXPLSM, and so they keep most of their properties, such as
; coordinates and collision box (see below).
Act_ExplSm:
	; Typically, the first routine is used to initialize the actor
	ldh  a, [hActCur+iActRtnId]
	and  $7F
	rst  $00 ; DynJump
	dw Act_ExplSm_Init
	dw Act_ExplSm_Anim
	
; =============== Act_ExplSm_Init ===============
Act_ExplSm_Init:
	;
	; Place the explosion at the center of the actor that just died.
	;
	; Currently the explosion is at the previous actor's origin, so it needs
	; to be moved up by the vertical radius of the collision box.
	; Of course, this assumes the sprite mapping to not be weirdly offset from its origin.
	;
	ld   h, HIGH(wActColi)		; Seek HL to iActColiBoxV, vertical radius
	ld   a, [wActCurSlotPtr]
	ld   l, a
	inc  l ; iActColiBoxV
	ldh  a, [hActCur+iActY]		; Move the actor up by that
	sub  [hl]
	ldh  [hActCur+iActY], a
	
	mPlaySFX SFX_ENEMYDEAD		; Play explosion sound
	jp   ActS_IncRtnId
	
; =============== Act_ExplSm_Anim ===============
Act_ExplSm_Anim:
	; Advance the animation at 1/4 speed, every four frames.
	ldh  a, [hActCur+iActSprMap]
	add  $02						; Timer += 2
	and  $1F						; Force valid frame range
	ldh  [hActCur+iActSprMap], a
	
	; If we went past the last valid sprite, the animation is over.
	srl  a				; >> 3 to sprite ID
	srl  a
	srl  a
	and  $03			; Filter out other flags
	cp   $03			; Sprite ID reached $03?
	ret  nz				; If not, return
	jp   ActS_Despawn	; Otherwise, we're done
	
