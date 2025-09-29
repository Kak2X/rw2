; =============== Act_NeoMet ===============
; ID: ACT_NEOMET
; Rockman 2-style Met.
Act_NeoMet:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NeoMet_InitHide
	dw Act_NeoMet_WaitNotice
	dw Act_NeoMet_Notice
	dw Act_NeoMet_UnHide
	dw Act_NeoMet_Fire
	dw Act_NeoMet_PostFireWait
	dw Act_NeoMet_Walk
	dw Act_NeoMet_Fall
	DEF ACTRTN_NEOMET_INITHIDE = $00

; =============== Act_NeoMet_InitHide ===============
Act_NeoMet_InitHide:
	; When walking forwards, do so at 0.5px/frame
	ld   bc, $0080
	call ActS_SetSpeedX
	
	; Mets start out hiding inside their invulnerable hat
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	ld   a, $00
	call ActS_SetSprMapId
	
	; Wait for 1 second
	ld   a, 60
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_WaitNotice ===============
; Waits for 1 second before noticing the player.
Act_NeoMet_WaitNotice:
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_Notice ===============
; Waits for the player to get close.
Act_NeoMet_Notice:
	; Always face player while on the lookout
	call ActS_FacePl
	; If the player isn't within 4 blocks, return
	call ActS_GetPlDistanceX
	cp   BLOCK_H*4
	ret  nc
	; Set transition sprite
	ld   a, $01
	call ActS_SetSprMapId
	; Show it for 8 frames
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_UnHide ===============
; Rise up from shield.
Act_NeoMet_UnHide:
	; Wait those 8 frames first
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Set fully risen sprite
	ld   a, $02
	call ActS_SetSprMapId
	; Met isn't hiding anymore, make vulnerable
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	; Wait 20 frames before attacking
	ld   a, $14
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_Fire ===============
; Fire projectiles.
Act_NeoMet_Fire:
	; Wait for it...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Do spread shot
	call Act_NeoMet_SpawnShots
	; Wait for another second
	ld   a, 60
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_PostFireWait ===============
; Stands still after firing.
Act_NeoMet_PostFireWait:
	; Wait 1 second before walking forward
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Walk for $30 frames
	ld   a, $30
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_Walk ===============
; Slowly walk forward.
Act_NeoMet_Walk:
	; After almost a second of walking, hide instantly.
	; There is no transition sprite unlike when rising up.
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	jr   nz, .move
	ld   a, ACTRTN_NEOMET_INITHIDE
	ldh  [hActCur+iActRtnId], a
	ret
.move:
	; Use frames $03-$04, at 1/8 speed
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ld   c, $01
	call ActS_Anim2
	
	; Move forward at 0.5px/frame
	call ActS_MoveBySpeedX_Coli	; Solid wall hit?
	jp   nc, ActS_FlipH				; If so, turn around
	
	; If there's no solid ground above, start falling
	call ActS_GetGroundColi			; Calc collision flags
	ld   a, [wColiGround]
	cp   %11						; Are both blocks empty?
	ret  nz							; If not, return
	xor  a							; Otherwise, init fall speed
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_NeoMet_Fall ===============
; Falling mode, in case we walked off a platform.
Act_NeoMet_Fall:
	call ActS_ApplyGravityD_Coli	; Apply gravity
	ret  c							; Hit a solid block yet? If not, return
	ld   a, ACTRTN_NEOMET_INITHIDE	; Otherwise, hide immediately
	ldh  [hActCur+iActRtnId], a
	ret
	
