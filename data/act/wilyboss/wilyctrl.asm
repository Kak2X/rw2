; =============== Act_WilyCtrl ===============
; ID: ACT_WILYCTRL
; Master actor for the final boss.
; Takes care of spawning the actors for the individual phases as needed.
;
; The Wily Spaceship sprites are associated to this actor, so its code (Act_WilyShip)
; runs as part of it, with the necessary measures to not cause conflicts.
Act_WilyCtrl:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_WilyCtrl_P1Init
	dw Act_WilyCtrl_P1Wait
	dw Act_WilyCtrl_P2Intro0
	dw Act_WilyCtrl_P2Intro1
	dw Act_WilyCtrl_P2Wait
	dw Act_WilyCtrl_P3Intro0
	dw Act_WilyCtrl_P3Intro_MoveR
	dw Act_WilyCtrl_P3Spawn
	dw Act_WilyCtrl_P3ScrollR
	dw Act_WilyCtrl_Despawn

; =============== Act_WilyCtrl_P1Init ===============
; Wily Machine - Prepare 1st phase.
Act_WilyCtrl_P1Init:

	;
	; Hide the Wily Spaceship during the 1st phase.
	;
	ld   b, ACTCOLI_PASS		; Make intangible
	call ActS_SetColiType
	xor  a						; Disable defeat trigger (see Act_WilyCtrl_P1Wait)
	ld   [wWilyPhaseDone], a
	ld   a, OBJ_OFFSET_Y+$88	; Hide under the ground
	ldh  [hActCur+iActY], a
	
	;
	; Spawn the 1st phase of the Wily Machine directly above the spawner.
	; As actors are executed even during shutter effects, this will spawn
	; the Wily Machine before it gets scrolled in, avoiding pop-ins.
	;
	; This also hides the fact that the Wily Spaceship is visible for one frame,
	; as that happens offscreen.
	;
	ld   a, ACT_WILY1			; Spawn the actor for the 1st phase...
	ld   bc, $0000				; ...with the same X pos as the spawner
	call ActS_SpawnRel
	ld   de, iActY
	add  hl, de					; ...on the ground (Y position $80)
	ld   [hl], OBJ_OFFSET_Y+$70
	
	jp   ActS_IncRtnId
	
; =============== Act_WilyCtrl_P1Wait ===============
; Wily Machine - Wait 1st phase.
Act_WilyCtrl_P1Wait:
	
	;
	; Wait, hidden, until Act_Wily1 signals to us that it's been destroyed.
	; wWilyPhaseDone is set when Act_Wily1_ChkDeath detects that the boss has less than 8 bars of health.
	;
	ld   a, $02					; Hide the Wily Spaceship (use blank sprite mapping)
	ld   [wActCurSprMapBaseId], a
	ld   a, [wWilyPhaseDone]
	and  a						; Was the 1st phase defeated?
	ret  z						; If not, return
	
	;
	; 1st phase defeated.
	;
	xor  a						; Disable trigger for next time
	ld   [wWilyPhaseDone], a
	ld   a, [wWilyShipY]		; Sync the spaceship coordinates
	ldh  [hActCur+iActY], a		; from whatever Act_Wily1_ChkDeath set them
	ld   a, [wWilyShipX]
	ldh  [hActCur+iActX], a
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType		; With the ship visible, take damage for running into it
	xor  a						; Reset routine
	ldh  [hActCur+iWilyShipRtnId], a
	jp   ActS_IncRtnId
	
; =============== Act_WilyCtrl_P2Intro0 ===============
; Wily Machine - 2nd phase intro #0
Act_WilyCtrl_P2Intro0:
	;
	; Animate the Wily Spaceship.
	;
	; When that's about to scroll the screen right, spawn the intro actor for the 2nd phase.
	;
	call Act_WilyShip
	
	ldh  a, [hActCur+iWilyShipRtnId]	; Read ship routine
	cp   ACTRTN_WILYSHIP_MOVESCROLLR	; Just got set to ACTRTN_WILYSHIP_MOVESCROLLR?
	ret  nz								; If not, return
	
	; Otherwise, spawn the body of the 2nd phase, used for the intro.
	ld   a, ACT_WILY2INTRO				
	ld   bc, $0000
	call ActS_SpawnRel
	
	; Make the body spawn on the ground, offscreen to the right.
	; While we're at it also keep track of the pointer to the spawned slot.
	
	; Seek HL to child's X position
	; HL += iActX
	ld   a, l			
	ldh  [hActCur+iWilyCtrlChildPtrLow], a		; # Save child slot ptr
	add  iActX
	ld   l, a
	ld   a, h
	ldh  [hActCur+iWilyCtrlChildPtrHigh], a		; # Save child slot ptr
	; Set coords
	ld   [hl], SCREEN_GAME_H+OBJ_OFFSET_X+$18	; iActX = $C0
	inc  hl ; iActYSub
	inc  hl ; iActY
	ld   [hl], OBJ_OFFSET_Y+$70 				; iActY = $80
	
	jp   ActS_IncRtnId
	
; =============== Act_WilyCtrl_P2Intro1 ===============
; Wily Machine - 2nd phase intro #1
Act_WilyCtrl_P2Intro1:
	; Continue animating the spaceship from where we left off.
	call Act_WilyShip
	ldh  a, [hActCur+iWilyShipRtnId]
	cp   ACTRTN_WILYSHIP_END			; Did the animation just end?
	ret  nz								; If not, return
	
	;
	; Animation over, the spaceship has attached itself.
	; Prepare for the 2nd phase.
	;
	
	; Despawn ACT_WILY2INTRO
	ldh  a, [hActCur+iWilyCtrlChildPtrLow]
	ld   l, a
	ldh  a, [hActCur+iWilyCtrlChildPtrHigh]
	ld   h, a
	ld   [hl], $00
	
	ld   a, OBJ_OFFSET_Y+$88	; Hide under the ground
	ldh  [hActCur+iActY], a
	ld   b, ACTCOLI_PASS		; Make intangible
	call ActS_SetColiType
	; Boss intros alter wBossMode after they're done.
	; Since we're chaining bosses, we have to reset it to the expected value, 
	; otherwise it will get skipped and the boss health bar won't refill.
	ld   a, BSMODE_INIT
	ld   [wBossMode], a
	
	; Spawn the actual 2nd phase actor
	ld   a, ACT_WILY2
	ld   bc, ($00 << 8)|LOW(-$18) ; 24px up
	call ActS_SpawnRel
	
	jp   ActS_IncRtnId
	
; =============== Act_WilyCtrl_P2Wait ===============
; Wily Machine - Wait 2nd phase.
; See also: Act_WilyCtrl_P1Wait
Act_WilyCtrl_P2Wait:
	;
	; Wait, hidden, until Act_Wily2 signals to us that it's been destroyed.
	;
	ld   a, $02					; Hide the Wily Spaceship (use blank sprite mapping)
	ld   [wActCurSprMapBaseId], a
	ld   a, [wWilyPhaseDone]
	and  a						; Was the 1st phase defeated?
	ret  z						; If not, return
	
	;
	; 2nd phase defeated.
	;
	xor  a						; Disable trigger
	ld   [wWilyPhaseDone], a
	ld   a, [wWilyShipY]		; Sync the spaceship coordinates
	ldh  [hActCur+iActY], a		; from whatever Act_Wily2_ChkDeath set them
	ld   a, [wWilyShipX]
	ldh  [hActCur+iActX], a
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType		; With the ship visible, take damage for running into it
	xor  a						; Reset routine
	ldh  [hActCur+iWilyShipRtnId], a
	
	;
	; Load the GFX for the BG portion of the final boss.
	;
	; These graphics completely replace the GFX set with the one from Wily's Castle,
	; as that one is empty enough it could squeeze those graphics in.
	;
	; To make the whole thing work, the only tile shown on screen is for a simple horizontal
	; pipe (tile $04), which is the same between GFX_LvlCastle and GFX_LvlStation.
	; For some reason this is copying $80 tiles, which is more than it needs to, and so it
	; carries a copy of GFX_BgShared in the last $30 tiles.
	ld   bc, (BANK(GFX_LvlCastle) << 8) | $80 ; Source GFX bank number + Number of tiles to copy
	ld   hl, GFX_LvlCastle ; Source GFX ptr
	ld   de, $9000 ; VRAM Destination ptr (start of 3rd section)
	call GfxCopy_Req
	jp   ActS_IncRtnId
	
; =============== Act_WilyCtrl_P3Intro0 ===============
; Wily Machine - 3rd phase intro #0
Act_WilyCtrl_P3Intro0:
	;
	; Animate the Wily Spaceship.
	;
	; When that's about to scroll the screen right, take over the animation.
	;
	call Act_WilyShip
	ldh  a, [hActCur+iAct0D]
	cp   ACTRTN_WILYSHIP_MOVESCROLLR
	ret  nz
	
	; Move right for ~1.5 seconds
	ld   a, $60
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_WilyCtrl_P3Intro_MoveR ===============
; Wily Machine - 3rd phase intro - move spaceship right, to offscreen.
Act_WilyCtrl_P3Intro_MoveR:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	; Move the spaceship right 0.5px/frame for those ~1.5 seconds
	call ActS_ApplySpeedFwdX
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; At this point, the spaceship should be fully offscreen.
	; Wait ~half a second doing nothing to simulate the docking happening.
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_WilyCtrl_P3Spawn ===============
; Wily Machine - 3rd phase intro - spawn actors.
Act_WilyCtrl_P3Spawn:
	; Wait for that ~half a second...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; Spawn the actual 3rd phase actor.
	; This will be stuck in the first routine, which does nothing, 
	; until Act_WilyCtrl_P3ScrollR finishes scrolling the screen.
	;
	ld   a, ACT_WILY3
	ld   bc, $0000
	call ActS_SpawnRel
	; Save to our struct the slot pointer to iWily3AnimPart, used by ACT_WILY3PART to check for animation signals.
	; This will be copied over to the spawned ACT_WILY3PART (see next spawns).
	ld   a, l
	add  iWily3AnimPart
	ldh  [hActCur+iWilyCtrl3PartAnimPtr], a
	; Set shared properties
	xor  a						; iWily3AnimPart = 0 (no signal)
	call Act_WilyCtrl_Set3Prop
	
	;
	; Spawn the accessory parts for the arm and tail.
	;
	ld   a, ACT_WILY3PART
	ld   bc, $0000
	call ActS_SpawnRel
	ld   a, WILY3PART_SPR_ARM ; iWily3PartSprMapId
	call Act_WilyCtrl_Set3Prop
	
	ld   a, ACT_WILY3PART
	ld   bc, $0000
	call ActS_SpawnRel
	ld   a, WILY3PART_SPR_TAIL ; iWily3PartSprMapId
	call Act_WilyCtrl_Set3Prop
	
	; Scroll the screen right at 0.5px/frame
	ld   a, $80
	ldh  [hActCur+iActSpdXSub], a
	
	jp   ActS_IncRtnId
	
; =============== Act_WilyCtrl_P3ScrollR ===============
; Wily Machine - 3rd phase intro - scroll screen.
; See also: Act_WilyShip_MoveScrollR
Act_WilyCtrl_P3ScrollR:

	;
	; Currently, Act_Wily3 is frozen in a dummy routine that does nothing,
	; so its movement needs to be done here.
	;

	;--
	;
	; Move the screen right 0.5px/frame, adjusting the actor to compensate.
	;

	; First, apply the subpixel speed as normal
	ldh  a, [hActCur+iActSpdXSub]	; A = Subpixel speed
	ld   hl, hActCur+iActXSub		; HL = Ptr to subpixel X
	add  [hl]						; Move right by that
	ld   [hl], a					; Save back
	
	; If that overflowed, instead of incrementing iActX directly, scroll the screen 1px to the right.
	; The way this works assumes movement < 1px/frame, since it should not alter iActX.
	jr   nc, .chkEnd
	; Scroll screen 1px right
	; This is not calling the normal Game_AutoScrollR because it leads to inconsistent results
	; when run from actor code, since ActS_MoveByScrollX would only get called for the actors
	; not processed yet.
	call Game_AutoScrollR_NoAct
	; Move final boss actor 1px left to adjust.
	; Both spawned parts will sync to the updated position by themselves.
	ldh  a, [hActCur+iWilyCtrl3PartAnimPtr]
	sub  iWily3AnimPart-iActX
	ld   l, a
	ld   h, HIGH(wAct)	; HL = Ptr to Act_Wily3's iActX
	dec  [hl]			; iActX--
.chkEnd:
	;--
	
	;
	; If Act_Wily3's position has reached $88, it has finished moving,
	; so unlock it from its frozen state.
	;
	ldh  a, [hActCur+iWilyCtrl3PartAnimPtr]
	sub  iWily3AnimPart-iActX
	ld   l, a
	ld   h, HIGH(wAct)		; HL = Ptr to Act_Wily3's iActX
	ld   a, [hl]			; Read it
	cp   OBJ_OFFSET_X+$80	; iActX != $88?
	ret  nz					; If so, return
	
	; Unlock Act_Wily3, by incrementing its routine
	ldh  a, [hActCur+iWilyCtrl3PartAnimPtr]
	sub  iWily3AnimPart-iActRtnId
	ld   l, a
	ld   h, HIGH(wAct)		; HL = Ptr to Act_Wily3's iActRtnId
	ld   [hl], ACTRTN_WILY3_INIT
	
	; Like before, allow the boss intro to happen
	ld   a, BSMODE_INIT
	ld   [wBossMode], a
	jp   ActS_IncRtnId
	
; =============== Act_WilyCtrl_Despawn ===============
Act_WilyCtrl_Despawn:
	xor  a
	ldh  [hActCur+iActId], a
	ret
	
; =============== Act_WilyCtrl_Set3Prop ===============
; Sets properties to the newly spawned 3rd phase actors.
; IN
; - HL: Ptr to newly spawned Act_Wily3 or Act_Wily3Part
; -  A: For Act_Wily3Part, it's the base sprite mapping ID (iWily3PartSprMapId).
;       That value acts as an unique identifier for the animation signal, and is never changed.
;       For Act_Wily3, it's the part animation signal (iWily3AnimPart)
;       When the sprite mapping ID of a part is written there, the actor with a matching iWily3PartSprMapId will animate.
Act_WilyCtrl_Set3Prop:
	;
	; All of the 3rd phase actors we spawn have the same coordinates.
	; Initially they spawn off-screen to the right, as their intro animation scrolls them in.
	;
	ld   de, iActX
	add  hl, de
	ld   [hl], OBJ_OFFSET_X+SCREEN_GAME_H+$20 ; iActX = $C8
	inc  hl ; iActYSub
	inc  hl ; iActY
	ld   [hl], OBJ_OFFSET_Y+$70 ; iActY = $80
	
	;
	; Save the sprite mapping ID related to the part, or initialize the signal.
	;
	ld   de, iWily3PartSprMapId-iActY
	add  hl, de
	ldi  [hl], a ; iWily3AnimPart / iWily3PartSprMapId
	
	;
	; Share to the Act_Wily3Part the pointer to Act_Wily3's iWily3AnimPart.
	; Act_Wily3Part will poll on this to know when to animate.
	;
	ldh  a, [hActCur+iWilyCtrl3PartAnimPtr]
	ld   [hl], a ; iWily3PartAnimPtr
	ret
	
