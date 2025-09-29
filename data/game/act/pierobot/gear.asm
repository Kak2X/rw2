; =============== Act_PieroBotGear ===============
; ID: ACT_PIEROGEAR
; Pierobot's Gear, what actually spawns Pierobot.
Act_PieroBotGear:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_PieroBotGear_Init
	dw Act_PieroBotGear_AirNoBot
	dw Act_PieroBotGear_AirBot
	dw Act_PieroBotGear_FallV
	dw Act_PieroBotGear_MoveH
	dw Act_PieroBotGear_TurnH
	
	
	DEF PIEROGEAR_FV EQU $17 ; Gear high, for relative positioning
	DEF ACTRTN_PIEROBOT_ONGEAR = $03
	DEF ACTRTN_PIEROBOT_GEARGONE = $04

; =============== Act_PieroBotGear_Init ===============
Act_PieroBotGear_Init:
	; For animating the cog, use frames $00-$01, at 1/8 speed.
	; This will be consistently done every routine.
	ld   c, $01
	call ActS_Anim2
	
	xor  a
	ldh  [hActCur+iPieroGearBotDead], a
	
	; Set Pierobot spawn delay
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_PieroBotGear_AirNoBot ===============
; Gear in the air, no Pierobot.
Act_PieroBotGear_AirNoBot:
	;
	; Wait for ~1 second animating the gear by itself.
	; Note this doesn't call Act_PieroBotGear_ChkCommon, making it impossible to actually destroy
	; the gear due to the +$10 offset. iPieroGearBotDead would need to be initially set to $FF for
	; that to work, since it hasn't spawned yet.
	;
	ld   c, $01
	call ActS_Anim2
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; Spawn Pierobot and set its properties up.
	; Once that's done, the two actors will have a 2-way link enabling to pass each other state.
	; Unlike other actors, no global variables are involved, since more can be onscreen at once.
	;
	ld   a, ACT_PIEROBOT
	ld   bc, ($00 << 8)|LOW(-$10) ; Basically $0000 because the Y position gets overwritten later
	call ActS_SpawnRel
	
	;
	; The first thing Pierobot will do is falling on top of the gear from offscreen.
	; To do so, its Y position needs to be reset to $00.
	;
	ld   a, l
	ldh  [hActCur+iPieroGearBotSlotPtr], a		; Also save the slot pointer for the bot, as part of the link
	add  iActY
	ld   l, a
	;--
	; [POI] Pointless, will be overwritten soon.
	ld   a, h
	ldh  [hActCur+iPieroGearBotDead], a
	;--
	xor  a
	ld   [hl], a ; iActY = $00
	
	;
	; Pierobot does not check for actor collision with the gear, as that would be slow.
	; Instead, calculate the target Y position where it should stop moving,
	; which is much faster and more accurate, given proper collision heights:
	; iPieroBotTargetY = iActY - $17
	;
	ld   a, iPieroBotTargetY-iActY		; Seek to iPieroBotTargetY
	ld   b, $00
	ld   c, a
	add  hl, bc
	ldh  a, [hActCur+iActY]				; Get gear's y position (bottom)
	sub  PIEROGEAR_FV					; -= height (top)
	ldi  [hl], a						; Set as target pos
	
	; Just as we know the bot's slot pointer, it should know ours.
	; This enables it to determine if the gear still exists, and if so, drop down.
	ld   a, [wActCurSlotPtr]
	ldi  [hl], a ; iPieroBotGearSlotPtr
	
	;--
	; [POI] This is never written to again, see its only use.
	xor  a
	ld   [hl], a ; iPieroBotUnusedFlag
	;--
	
	; The bot also notifies us when it dies
	ldh  [hActCur+iPieroGearBotDead], a
	
	; Set next delay 
	ld   a, $80
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_PieroBotGear_AirBot ===============
; Gear in the air, Pierobot jumping on it.
Act_PieroBotGear_AirBot:
	; Wait for ~2 seconds before dropping the gear.
	call Act_PieroBotGear_ChkCommon
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Pierobot is currently jumping on the gear, notify him to also drop.
	; This is perfectly timed with the end of one of Pierobot's jumps, making
	; it look like that jump caused the gear to fall off.
	
	; If he has died already, don't bother (but still make the gear drop)
	ldh  a, [hActCur+iPieroGearBotDead]
	and  a
	jp   nz, ActS_IncRtnId
	
	; Set the bot's routine
	ldh  a, [hActCur+iPieroGearBotSlotPtr]
	ld   l, a
	ld   h, HIGH(wAct)
	inc  hl ; iActRtnId
	ld   [hl], ACTRTN_PIEROBOT_ONGEAR
	
	; This should have been done before checking for iPieroGearBotDead
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	jp   ActS_IncRtnId
	
; =============== Act_PieroBotGear_FallV ===============
; Drop the gear until it touches the ground.
Act_PieroBotGear_FallV:
	call Act_PieroBotGear_ChkCommon
	call Act_PieroBotGear_ChkOffscreenV
	
	; Apply gravity until we touch a solid block, then roll towards the player at 0.75px/frame
	call ActS_ApplyGravityD_Coli
	ret  c
	call ActS_FacePl
	ld   bc, $00C0
	call ActS_SetSpeedX
	
	jp   ActS_IncRtnId
	
; =============== Act_PieroBotGear_MoveH ===============
; Gear rolls forward.
Act_PieroBotGear_MoveH:
	call Act_PieroBotGear_ChkCommon
	
	;
	; Move forward at 0.75px/frame, turn around if a solid wall is ahead
	;
	call ActS_MoveBySpeedX_Coli	; Solid wall hit?
	jp   nc, ActS_IncRtnId			; If so, advance to Act_PieroBotGear_TurnH
	
	;
	; If there's no ground below, start falling 
	;
	call ActS_GetGroundColi
	ld   a, [wColiGround]
	cp   %11					; No ground below on either block?
	ret  nz						; If not, return
								; Otherwise...
								
	; Give an extra push of 1 pixels forward
	ld   bc, $0100
	call ActS_SetSpeedX
	call ActS_MoveBySpeedX_Coli
	
	; Prepare gravity for falling down
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	jp   ActS_DecRtnId			; Return back to Act_PieroBotGear_FallV
	
; =============== Act_PieroBotGear_TurnH ===============
; Makes the gear turn horizontally.
Act_PieroBotGear_TurnH:
	call Act_PieroBotGear_ChkCommon
	call Act_PieroBotGear_ChkOffscreenH
	
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	
	jp   ActS_DecRtnId
	
; =============== Act_PieroBotGear_ChkCommon ===============
; Performs common actions on each routine.
Act_PieroBotGear_ChkCommon:
	; Animate the gear as normal
	ld   c, $01
	call ActS_Anim2
	
	;
	; When the gear explodes, notify Pierobot that we've died.
	; This will make the latter fall off the screen, as his "ground" was taken away.
	;
	call ActS_ChkExplodeNoChild		; Handle death
	ret  nc							; Gear exploded? If not, return
	
	; As the gear died, no more of that actor code should run when we return.
	; We're inside a subroutine though, so pop out the return value to return directly to ActS_Do.
	pop  hl
	
	; Don't notify Pierobot if he died already
	ldh  a, [hActCur+iPieroGearBotDead]
	and  a
	ret  nz
	
	; Otherwise, make Pierobot fall down by directly adjusting his routine
	ldh  a, [hActCur+iPieroGearBotSlotPtr]
	ld   l, a
	ld   h, HIGH(wAct)
	inc  hl ; iActRtnId
	ld   [hl], ACTRTN_PIEROBOT_GEARGONE
	ret
	
; =============== Act_PieroBotGear_ChkOffscreenV ===============
; Checks the gear went offscreen to the bottom.
; Because of the two way link, this actor needs to perform the check manually
; to make sure Pierobot gets despawned if the gear moves offscreen.
Act_PieroBotGear_ChkOffscreenV:
	ldh  a, [hActCur+iActY]
	cp   SCREEN_GAME_V+OBJ_OFFSET_Y+$0A		; iActY < $9A?
	ret  c									; If so, return
	jr   Act_PieroBotGear_Explode
	
; =============== Act_PieroBotGear_ChkOffscreenH ===============
; Like above, but with the horizontal position.
Act_PieroBotGear_ChkOffscreenH:
	ldh  a, [hActCur+iActX]
	cp   SCREEN_GAME_H+OBJ_OFFSET_X+$08		; iActY < $B0?
	ret  c									; If so, return
	; Fall-through
	
; =============== Act_PieroBotGear_Explode ===============
; Makes the gear explode, despawning Pierobot if he hasn't died already.
Act_PieroBotGear_Explode:
	; Visually explode the gear
	call ActS_Explode
	; Force return to the actor loop when returning.
	pop  hl
	
	; If Pierobot hasn't died yet, instantly despawn it.
	ldh  a, [hActCur+iPieroGearBotDead]
	and  a									; Died yet?
	ret  nz									; If so, return
	ldh  a, [hActCur+iPieroGearBotSlotPtr]
	ld   l, a								; Seek HL to the bot's iActId
	ld   h, HIGH(wAct)
	ld   [hl], $00 ; iActId					; Despawn
	ret
	
