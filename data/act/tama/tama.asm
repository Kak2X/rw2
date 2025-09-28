; =============== Act_Tama ===============
; ID: ACT_TAMA
; Giant cat miniboss in Top Man's stage.
Act_Tama:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Tama_InitTilemap
	dw Act_Tama_InitAttackType
	dw Act_Tama_ChkAttack
	dw Act_Tama_Throw0
	dw Act_Tama_Throw1
	dw Act_Tama_ThrowAfter
	DEF ACTRTN_TAMA_CHKATTACK = $02

; =============== Act_Tama_InitTilemap ===============
; Draws the tilemap for the miniboss.
Act_Tama_InitTilemap:
	call Act_BGBoss_ReqDraw
	jp   ActS_IncRtnId
	
; =============== Act_Tama_InitAttackType ===============
Act_Tama_InitAttackType:
	; Return if dead
	call Act_Tama_ChkExplode
	ret  c
	; First attack will be the Yarn Ball.
	; (While iTamaAttackType 0 is for the fleas, it will be pre-xor'd to 1)
	xor  a
	ldh  [hActCur+iTamaAttackType], a
	jp   ActS_IncRtnId
	
; =============== Act_Tama_ChkAttack ===============
Act_Tama_ChkAttack:
	; Return if dead
	call Act_Tama_ChkExplode
	ret  c
	
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Wait until no Yarn Balls or Fleas are onscreen
	ld   a, ACT_TAMABALL
	call ActS_CountById
	ld   a, b
	or   a					; Count != 0?
	ret  nz					; If so, wait
	ld   a, ACT_TAMAFLEA
	call ActS_CountById
	ld   a, b
	or   a					; Count != 0?
	ret  nz					; If so, wait
	
	; Start one of the two possible attacks
	
	; Set the delay for the throw animation, in case we're throwing the Yarn Ball next
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	
	; Alternate betwen attack types
	ldh  a, [hActCur+iTamaAttackType]
	xor  $01
	ldh  [hActCur+iTamaAttackType], a
	
	or   a						; iTamaAttackType != 0?
	jp   nz, ActS_IncRtnId		; If so, prepare to spawn the Yarn Ball
	jp   Act_Tama_SpawnFleas	; Otherwise, spawn fleas (and stay on Act_Tama_WaitAttack)
	
; =============== Act_Tama_Throw0 ===============
; First part of the throw sequence.
Act_Tama_Throw0:
	call Act_Tama_ChkExplode
	ret  c
	
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Wait for half a second in the same animation as Act_Tama_WaitAttack
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Wait another half a second in the next mode
	ld   a, 30
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Tama_Throw1 ===============
; Second part of the throw sequence.
Act_Tama_Throw1:
	call Act_Tama_ChkExplode
	ret  c
	
	; Use frames $02-$03 at 1/8 speed, the actual throw animation
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ld   c, $01
	call ActS_Anim2
	
	; Wait half a second before spawning the ball
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; This does nothing
	ld   a, $0F
	ldh  [hActCur+iActTimer], a
	
	; Finally spawn the Yarn Ball
	ld   a, ACT_TAMABALL
	ld   bc, (LOW(-$18) << 8)|LOW(-$04)	; 24px left, 4px up
	call ActS_SpawnRel
	jp   ActS_IncRtnId
	
; =============== Act_Tama_ThrowAfter ===============
; Cooldown
Act_Tama_ThrowAfter:
	call Act_Tama_ChkExplode
	ret  c
	
	; Use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	; Wait for the Yarn Ball to be destroyed
	ld   a, ACTRTN_TAMA_CHKATTACK
	ldh  [hActCur+iActRtnId], a
	ret
	
