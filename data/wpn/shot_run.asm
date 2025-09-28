; =============== WpnS_Do ===============
; Processes all active weapon shots.
WpnS_Do:

	; Return to the idle state when the freeze timer elapses.
	; This is exclusively used by Hard Knucle to freeze the player after shooting (see WpnCtrl_HardKnuckle),
	; and it's up to us to re-enable the player controls here.
	; It's also notoriously buggy, but... the location of the bug is elsewhere (see Game_StartRoomTrs & ScrEv_LvlScrollH)
	ld   a, [wWpnHaFreezeTimer]
	or   a					; Is the timer already elapsed?
	jr   z, .chkSlots		; If so, skip
	dec  a					; Otherwise, timer--
	ld   [wWpnHaFreezeTimer], a
	jr   nz, .chkSlots		; Did it elapse *now*? (A = 0)
	ld   [wPlMode], a		; If so, unlock the player's controls (A = PL_MODE_GROUND)
	
.chkSlots:
	; Check each of the individual shot slots, processing all that are active.
	ld   hl, wShot0		; HL = Ptr to slot
	ld   a, [hl]		; Read iShotId
	or   a				; Is the slot active?
	call nz, WpnS_ProcSlot	; If so, process it
	
	ld   hl, wShot1		; Do the same for the other shots
	ld   a, [hl]
	or   a
	call nz, WpnS_ProcSlot
	
	ld   hl, wShot2
	ld   a, [hl]
	or   a
	call nz, WpnS_ProcSlot
	
	ld   hl, wShot3
	ld   a, [hl]
	or   a
	call nz, WpnS_ProcSlot
	
	ret
	
; =============== WpnS_ProcSlot ===============
; Processes a weapon shot slot.
; IN
; - HL: Ptr to slot
WpnS_ProcSlot:
	push hl	; Save slot ptr (source)
	
		;
		; Copy the shot to a working area for processing.
		; That's the same area used by actors, since it's free space at this point.
		;
		
		; Worth noting the slot struct is only $0D bytes long, but it is aligned to a $10-byte boundary for convenience.
		ld   de, hShotCur	; DE = Working area (destination)
		ld   b, iShotRealEnd		; B = Bytes to copy
	.wkInLoop:
		ldi  a, [hl]		; Read byte from slot, SlotPtr++
		ld   [de], a		; Copy over to wk
		inc  de				; WkPtr++
		dec  b				; Are we done?
		jr   nz, .wkInLoop	; If not, loop
		;--
		
		; Execute the weapon-specific code
		call WpnS_ExecCode
		
		; Deflected shots deal no damage
		ldh  a, [hShotCur+iShotFlags]
		bit  SHOT3B_DEFLECT, a	; Is the shot deflected?
		call z, Wpn_DoActColi	; If not, check for collision against all actors
	;--
	
	; 
	; Save back the changes made to the working area into the slot.
	;
	pop  de 			; DE = Slot ptr (destination)
	ld   hl, hShotCur	; HL = Working area (source)
	ld   b, iShotRealEnd		; B = Bytes to copy
.wkOutLoop:
	ldi  a, [hl]		; Read byte from wk, WkPtr++
	ld   [de], a		; Copy back to slot
	inc  de				; SlotPtr++
	dec  b				; Are we done?
	jr   nz, .wkOutLoop	; If not, loop
	
	ret
	
; =============== WpnS_ExecCode ===============
; Executes weapon-specific shot code.
WpnS_ExecCode:

	; If a shot is deflected, execute the generic deflect code
	ldh  a, [hShotCur+iShotFlags]
	bit  SHOT3B_DEFLECT, a		; Is the shot deflected
	jr   nz, Wpn_Deflected		; If so, jump
	
	; Otherwise, execute the normal shot's code
	ldh  a, [hShotCur+iShotId]	; A = iShotId
	and  $FF^SHOT0_PROC			; Filter out flag
	rst  $00 ; DynJump
	dw Wpn_Default       ; WPN_P 
	dw Wpn_Default       ; WPN_RC ;X
	dw Wpn_Default       ; WPN_RM ;X
	dw Wpn_Default       ; WPN_RJ ;X
	dw Wpn_TopSpin       ; WPN_TP
	dw Wpn_AirShooter    ; WPN_AR
	dw Wpn_LeafShield    ; WPN_WD
	dw Wpn_MetalBlade    ; WPN_ME
	dw Wpn_CrashBomb     ; WPN_CR
	dw Wpn_NeedleCannon  ; WPN_NE
	dw Wpn_HardKnuckle   ; WPN_HA
	dw Wpn_MagnetMissile ; WPN_MG
	dw Wpn_Default       ; WPN_SG

; =============== Wpn_Deflected ===============
; Deflected shot.
; Moves diagonally up.
Wpn_Deflected:

	; Move upwards ~2.lpx/frame
	ldh  a, [hShotCur+iShotYSub]
	sub  $1C
	ldh  [hShotCur+iShotYSub], a
	ldh  a, [hShotCur+iShotY]
	sbc  $02
	ldh  [hShotCur+iShotY], a
	
	; If the shot went off-screen to the top, despawn it.
	; Specifically, if its Y position is between $00-$0F, it's treated as off-screen.
	; Not particularly necessary, given WpnS_DrawSprMap performs an offscreen check on its own. 
	and  $F0			; Check 16px ranges
	cp   $00			; In the topmost range? (offscreen)
	jr   nz, .moveH		; If not, jump
.despawn:
	xor  a				; Otherwise, clear iShotId. This despawns the shot by marking the slot as free. 
	ldh  [hShotCur+iShotId], a
	ret
	
.moveH:
	; Move backwards ~2.lpx/frame
	ldh  a, [hShotCur+iShotDir]
	or   a						; Facing right?
	jr   z, .moveR				; If not, jump
.moveL:
	; Facing right -> move left
	ldh  a, [hShotCur+iShotXSub]
	sub  $1C
	ldh  [hShotCur+iShotXSub], a
	ldh  a, [hShotCur+iShotX]
	sbc  $02
	ldh  [hShotCur+iShotX], a
	jp   WpnS_DrawSprMap
.moveR:
	; Facing left -> move right
	ldh  a, [hShotCur+iShotXSub]
	add  $1C
	ldh  [hShotCur+iShotXSub], a
	ldh  a, [hShotCur+iShotX]
	adc  $02
	ldh  [hShotCur+iShotX], a
	jp   WpnS_DrawSprMap
	
