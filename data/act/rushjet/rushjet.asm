; =============== Act_RushJet ===============
; ID: ACT_WPN_RJ
; Rush Jet helper item.
Act_RushJet:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Helper_Teleport
	dw Act_RushJet_ChkSpawnPos
	dw Act_RushJet_WaitPl
	dw Act_RushJet_Ride
	DEF ACTRTN_RUSHJET_TELEPORT = $00

; =============== Act_RushJet_ChkSpawnPos ===============
; Determines if the location Rush Jet teleported into is viable.
; If it isn't, it will immediately teleport out before the player can get in.
Act_RushJet_ChkSpawnPos:

	ld   a, [wLvlWater]
	or   a					; Does the level have water?
	jr   z, .ok				; If not, skip checks (Act_Helper_Teleport already checked for solid blocks)
	
	; Rush must not have landed on a water block
	ldh  a, [hActCur+iActX]		; X Sensor: ActX (center)
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Sensor: ActY (bottom)
	ld   [wTargetRelY], a
	call Lvl_GetBlockId			; A = Block ID
	cp   BLOCKID_WATER			; Is it a water block?
	jr   z, .warpOut			; If so, jump (fail)
	cp   BLOCKID_WATERSPIKE		; Is it an underwater spike?
	jr   z, .warpOut			; If so, jump (fail)
.ok:
	jp   ActS_IncRtnId
.warpOut:
	ld   a, AHW_WARPOUT_INITANIM
	ld   [wWpnHelperWarpRtn], a
	jp   ActS_DecRtnId
	
; =============== Act_RushJet_WaitPl ===============
; Waiting for the player to stand on it.
Act_RushJet_WaitPl:

	; When 1 second remains, start flashing.
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	cp   60
	jr   nc, .chkColi
	
	; Flash every 4 frames.
	push af
		sla  a							; At double timer speed...
		and  %1000						; Every 8 frames... (/2)
		ld   [wActCurSprMapBaseId], a
	pop  af
	
	; If the timer fully elapsed, teleport out
	or   a
	jr   nz, .chkColi
	ld   a, AHW_WARPOUT_INITANIM
	ld   [wWpnHelperWarpRtn], a
	ld   a, ACTRTN_RUSHJET_TELEPORT
	ldh  [hActCur+iActRtnId], a
	ret
	
.chkColi:
	;
	; Check if Rush Jet should trigger.
	;
	
	; The player must have collided with this Rush Jet actor.
	ld   a, [wActCurSlotPtr]
	ld   b, a						; B = Current actor
	ld   a, [wActHelperColiSlotPtr]	; A = Helper actor the player fell on
	cp   b							; Do they match?
	ret  nz							; If not, return (not collided with)
	
	; When the player is on Rush Jet, move at 1px/frame in any direction
	ld   bc, $0100
	call ActS_SetSpeedX
	ld   bc, $0100
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_RushJet_Ride ===============
; Player is riding it.
;
; Rush Jet is simply a top solid platform that follows the player, whose height can be controlled while standing.
; The normal player modes and the Rush Jet actor collision code handle the rest, with very few RJ-specific checks in place:
; - Skipping the walk cycle when moving
; - Preventing sliding on Rush Jet, mainly to prevent falling off as the slide is faster than Rush Jet.
Act_RushJet_Ride:

	;
	; HORIZONTAL MOVEMENT
	;
	
	;
	; Always try to move Rush Jet at the player's horizontal position.
	; When standing on it, this is what allows to keep it in sync with the player's movement,
	; it's also the *only* part that's even done when not standing on it, with its speed 
	; allowing it to catch up as long as the player isn't sliding.
	;
	; By *only* part, we really mean it. Everything else is skipped, including the check
	; that makes it use up ammo, ala RM3 Rush Jet.
	;
	call ActS_GetPlDistanceX
	or   a							; DiffX == 0?
	jr   z, .chkStand				; If so, skip (we're precisely 
	call ActS_FacePl				; Move towards the player
	call ActS_ApplySpeedFwdXColi	; at 1px/frame, stopping on solid blocks
	
.chkStand:
	; Do the rest only if the player is standing on it
	ld   a, [wActCurSlotPtr]
	ld   b, a
	ld   a, [wActPlatColiSlotPtr]
	cp   b
	ret  nz
	
	;
	; VERTICAL MOVEMENT
	;
	
	; Do the checks by shifting the topmost KEY_* bits to the carry, one by one.
	ldh  a, [hJoyKeys]
	;--
	rla ; KEY_DOWN				; Holding DOWN?
	jr   nc, .chkMoveU			; If not, skip
.moveD:
	; If we touch the bottom of the screen, teleport out.
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y+SCREEN_GAME_V	; iActY > $90?
	jr   nc, .teleport				; If so, jump
	
	; Prevent moving towards water
	ld   a, [wLvlWater]
	or   a						; Level supports water?
	jr   z, .okMoveD			; If not, jump (ok)
	ldh  a, [hActCur+iActX]		; X Sensor: ActX (center)
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Sensor: ActY + 1 (ground)
	inc  a
	ld   [wTargetRelY], a
	call Lvl_GetBlockId			; A = Block ID
	cp   BLOCKID_WATER			; Is it a water block?
	jr   z, .chkAmmo			; If so, jump (fail)
	cp   BLOCKID_WATERSPIKE		; Is it an underwater spike?
	jr   z, .chkAmmo			; If so, jump (fail)
.okMoveD:
	; Confirm downwards movement at 1px/frame
	ldh  a, [hActCur+iActSprMap]
	or   ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	call ActS_ApplySpeedFwdYColi
	jr   .chkAmmo
	;--
	
.chkMoveU:
	rla ; KEY_UP				; Holding UP?
	jr   nc, .chkAmmo			; If not, skip
.moveU:
	; If we're near the top of the screen, prevent moving further up
	ld   a, [wPlRelY]
	cp   OBJ_OFFSET_Y+$08	; iActY < $18?
	jr   c, .chkAmmo		; If so, jump
	
	; Prevent moving up if there's a solid block above, using the same collision box
	; as the player, except taller.
	
	sub  (PLCOLI_V*2)		; Y Sensor: ActY - $18 (above the player)
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]		; X Sensor: ActX - $06 (left)
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; Is the block solid?
	jr   nc, .chkAmmo		; If so, jump (don't move)
	
	ld   a, [wPlRelX]		; X Sensor: ActX + $06 (right)
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; Is the block solid?
	jr   nc, .chkAmmo		; If so, jump (don't move)
.okMoveU:
	; Confirm upwards movement at 1px/frame
	ldh  a, [hActCur+iActSprMap]
	and  $FF^ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	call ActS_ApplySpeedFwdY
	;--
.chkAmmo:

	;
	; Ammo consumption rate: every 1 unit / 8 frames (1 bar / ~1 second).
	; Once it's fully consumed, teleport out, making the player fall down.
	;
	ld   a, [wWpnHelperUseTimer]	; Timer -= $20
	sub  $20
	ld   [wWpnHelperUseTimer], a
	call c, WpnS_UseAmmo			; Underflowed? If so, use it
	
	ld   a, [wWpnAmmoCur]
	or   a							; Any ammo left?
	ret  nz							; If so, return
.teleport:
	ld   a, AHW_WARPOUT_INITANIM	; Otherwise, teleport out
	ld   [wWpnHelperWarpRtn], a
	ld   a, ACTRTN_RUSHJET_TELEPORT
	ldh  [hActCur+iActRtnId], a
	ret
	
