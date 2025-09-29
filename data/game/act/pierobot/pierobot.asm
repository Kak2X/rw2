; =============== Act_PieroBot ===============
; ID: ACT_PIEROBOT
; Jester, hopping on the gear and rolling on it.
Act_PieroBot:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_PieroBot_Init
	dw Act_PieroBot_JumpD
	dw Act_PieroBot_JumpU
	dw Act_PieroBot_OnGear
	dw Act_PieroBot_InitGearGone
	dw Act_PieroBot_GearGone

; =============== Act_PieroBot_Init ===============
Act_PieroBot_Init:
	call Act_PieroBot_ChkCommon
	; Initialize gravity
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_PieroBot_JumpD ===============
; Part of the jumping loop, post-peak.
; This comes first because we first drop from offscreen.
; Pierobot will continuously jump on the gear until the gear forces our routine to Act_PieroBot_OnGear.
Act_PieroBot_JumpD:
	call Act_PieroBot_ChkCommon
	
	;
	; Apply gravity while moving down until we reach the target Y position (top of the gear)
	;
	call ActS_ApplyGravityD
	ldh  a, [hActCur+iPieroBotTargetY]	; A = GearY
	ld   hl, hActCur+iActY				; HL = Ptr to BotY
	cp   [hl]							; GearY >= BotY?
	ret  nc								; If so, return (we're still above the gear)
	ld   [hl], a						; Otherwise, align to target
	ld   bc, $0200						; And set up jump at 2px/frame
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_PieroBot ===============
; Part of the jumping loop, pre-peak.
Act_PieroBot_JumpU:
	call Act_PieroBot_ChkCommon
	; Apply gravity while moving up until we reach the peak
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_DecRtnId
	
; =============== Act_PieroBot_OnGear ===============
; Main routine, rolling on the gear.
Act_PieroBot_OnGear:
	call Act_PieroBot_ChkCommon
	
	;
	; Force Pierobot to stay on top of the gear, perfectly centered on it.
	; This is the routine run when the gear rolls, execution will stay indefinitely
	; here until said gear dies, which forces our routine to Act_PieroBot_InitGearGone.
	;
	
	; HL = Ptr to gear's X position
	ldh  a, [hActCur+iPieroBotGearSlotPtr]
	add  iActX
	ld   l, a
	ld   h, HIGH(wAct)
	
	; X Position = Gear X (center)
	ldi  a, [hl]
	ldh  [hActCur+iActX], a
	inc  hl ; iActY
	
	; Y Position = Gear Y - $17 (top)
	ld   a, [hl]				; Get gear's iActY
	sub  PIEROGEAR_FV			; Move to top of gear
	ldh  [hActCur+iActY], a		; Stand on that
	ret
	
; =============== Act_PieroBot_InitGearGone ===============
; Sets up vertical gravity after the gear dies.
Act_PieroBot_InitGearGone:
	call Act_PieroBot_ChkCommon
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	jp   ActS_IncRtnId
	
; =============== Act_PieroBot_GearGone ===============
Act_PieroBot_GearGone:
	; When the gear is gone, make Pierobot fall off until he gets offscreened below.
	; Don't even let solid blocks stop his movement.
	call Act_PieroBot_ChkCommon
	call ActS_ApplyGravityD
	ret
	
; =============== Act_PieroBot_ChkCommon ===============
; Performs common actions on each routine.
; See also: Act_PieroBotGear_ChkCommon
Act_PieroBot_ChkCommon:
	; Animate hopping, use frames $00-$01 at 1/8 speed
	ld   c, $01
	call ActS_Anim2
	
	;
	; When Pierobot explodes, notify the gear that we've died.
	; This prevents the gear from attempting to notify a despawned actor.
	;
	call ActS_ChkExplodeNoChild		; Handle death
	ret  nc							; Gear exploded? If not, return
	
	; Return to actor loop
	pop  bc
	
	;--
	; [POI] iPieroBotUnusedFlag is always zero, and the check is a copy/paste from Act_PieroBotGear_ChkCommon.
	ldh  a, [hActCur+iPieroBotUnusedFlag]
	and  a
	ret  nz
	;--
	
	; Notify the gear
	ldh  a, [hActCur+iPieroBotGearSlotPtr]	; Seek HL to the gear's iPieroGearBotDead
	add  iPieroGearBotDead
	ld   l, a
	ld   h, HIGH(wAct)
	ld   [hl], $FF							; Flag with nonzero value
	ret
	
