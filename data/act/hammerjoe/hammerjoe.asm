; =============== Act_HammerJoe ===============
; ID: ACT_HAMMERJOE
; Sniper Joe throwing hammers forward.
Act_HammerJoe:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_HammerJoe_Init
	dw Act_HammerJoe_Swing
	dw Act_HammerJoe_Throw
	DEF ACTRTN_HAMMERJOE_INIT = $00
	DEF ACTRTN_HAMMER_INITTHROW = $01

; =============== Act_HammerJoe_Init ===============
Act_HammerJoe_Init:
	; Spawn Hammer Joe's hammer immediately.
	; [BUG] Unlike with bees, no check if made if the hammer could actually spawn.
	;       Hammer Joe's placement makes it impossible to trigger, but if it could,
	;       the first slot would be treated as the hammer.
	ld   a, ACT_HAMMER
	ld   bc, ($00 << 8)|LOW(-$1E)	; 30px above, right above the top of the collision box
	call ActS_SpawnRel
	ld   a, l						; Keep track of child
	ldh  [hActCur+iActChildSlotPtr], a
	
	; The hammer moves 2px/frame forward
	add  iActSpdXSub
	ld   l, a
	ld   a, $00
	ldi  [hl], a ; iActSpdXSub
	ld   a, $02
	ld   [hl], a ; iActSpdX
	
	ld   a, $00
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_HammerJoe_Swing ===============
; Swing the hammer while invulnerable.
Act_HammerJoe_Swing:
	;--
	; Not necessary given it's invulnerable here
	call ActS_ChkExplodeWithChild
	ret  c
	;--
	
	; Hammer Joe itself only has a 2-frame animation, it's the hammer that has four.
	ld   c, $01
	call ActS_Anim2
	
	; Always face the player while swinging
	call ActS_FacePl
	
	;--
	;
	; Make the hammer do so too.
	;
	
	; HL = Ptr to hammer iActSprMap
	ld   h, HIGH(wAct)			
	ldh  a, [hActCur+iActChildSlotPtr]
	inc  a ; iActRtnId
	inc  a ; iActSprMap
	ld   l, a
	
	; B = Joe's direction
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R
	ld   b, a
	
	ld   a, [hl]		; Read hammer iActSprMap
	and  $FF^ACTDIR_R	; Delete direction flag
	or   b				; Merge with ours
	ld   [hl], a		; Save back
	;--
	

	ldh  a, [hActCur+iActTimer]	; Timer++
	add  $01
	ldh  [hActCur+iActTimer], a
	
	;
	; After 1 second, open Joe's eyes and make him vulnerable.
	; Half a second after that, throw the hammer forward.
	;
	ld   b, ACTCOLI_ENEMYREFLECT
	cp   60+30						; Timer == $5A? (half a second passed after $3C)
	jr   z, .throw					; If so, jump
	cp   60							; Timer < $3C? (second hasn't passed yet)
	jr   c, .setColi				; If so, jump
.openEyes:
	ld   a, $02						; Use frames $02-$03, with eye open	
	ld   [wActCurSprMapBaseId], a
	ld   b, ACTCOLI_ENEMYHIT		; Make vulnerable
.setColi:
	ld   b, b
	call ActS_SetColiType
	ret
.throw:

	ld   a, $00
	ldh  [hActCur+iActTimer], a
	
	; Reset animation frame
	call ActS_ClrSprMapId
	
	; Advance the child hammer's routine to throw it forward
	ld   h, HIGH(wAct)				 ; HL = Ptr to hammer iActRtnId
	ldh  a, [hActCur+iActChildSlotPtr]
	inc  a
	ld   l, a
	ld   a, ACTRTN_HAMMER_INITTHROW
	ldi  [hl], a
	
	jp   ActS_IncRtnId
	
; =============== Act_HammerJoe_Throw ===============
; Wait a second before looping to the start.
Act_HammerJoe_Throw:
	; If defeated during this, also kill off the hammer
	call ActS_ChkExplodeWithChild
	ret  c
	
	; Use throw frame
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	
	; Wait for one second
	ldh  a, [hActCur+iActTimer]
	add  $01
	ldh  [hActCur+iActTimer], a
	cp   60
	ret  nz
	
	; Make invulnerable again
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	
	; Back to start
	ld   a, ACTRTN_HAMMERJOE_INIT
	ldh  [hActCur+iActRtnId], a
	ret
	
