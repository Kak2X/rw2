; =============== Wpn_DespawnAllShots ===============
; Initializes the weapon shot memory, used when a different weapon is selected.
; Clears all weapon shots and resets weapon-specific variables.
Wpn_DespawnAllShots:
	; Force the player out of the Rush Marine ride
	ld   a, [wPlMode]
	cp   PL_MODE_RM		; Riding Rush Marine?
	jr   nz, .clrWpn	; If not, skip
	xor  a				; Otherwise, reset state to idle
	ld   [wPlMode], a
	
.clrWpn:
	; Delete all 4 possible on-screen shots
	xor  a
	ld   [wShot0], a
	ld   [wShot1], a
	ld   [wShot2], a
	ld   [wShot3], a
	; Reset additional weapon-related globals
	ld   [wWpnNePos], a
	; Force out of Top Spin's spin state or the Sakugarne
	ld   [wWpnTpActive], a
	ld   [wWpnSGRide], a
	ret
	
; =============== Wpn_StartHelperWarp ===============
; Makes the first found helper (Rush or Sakugarne) teleport out.
; Used when a different weapon is selected.
; OUT
; - C flag: If set, an item was found and set to be teleported out
Wpn_StartHelperWarp:
	;
	; Only a single helper actor can be active at once.
	; Find the first one.
	;
	ld   hl, wAct		; Start from first actor slot
.loop:

	; Actor IDs between $E0-$E3 are reserved to the helpers.
	; If the actor ID for the slot is outside this range, seek to the next.
	ld   a, [hl]		; A = iActId
	cp   ACTF_PROC|ACT_WPN_RC		; A < ACT_WPN_RC?
	jr   c, .next		; If so, skip
	cp   ACTF_PROC|ACT_WPN_SG+1		; A >= ACT_E4?
	jr   nc, .next		; If so, skip
	
	; If the actor is already in the middle of teleporting out, there's nothing to do.
	ld   a, [wWpnHelperWarpRtn]
	cp   AHW_WARPOUT_INITANIM
	jr   z, .notFound
	cp   AHW_WARPOUT_ANIM
	jr   z, .notFound
	cp   AHW_WARPOUT_MOVEU
	jr   z, .notFound
	
.found:
	; Otherwise, we found an active helper.
	; Make it teleport out.
	
	inc  l				; Seek to iActRtnId
	xor  a
	ld   [hl], a		; iActRtnId = 0
	
	ld   a, AHW_WARPOUT_INITANIM
	ld   [wWpnHelperWarpRtn], a
	
	scf ; C Flag = set
	ret
	
.next:
	; Seek to next entry
	ld   a, l			; HL += $10
	add  iActEnd
	ld   l, a
	; If the low byte overflowed to $00, we reached the end of wAct.
	jr   nz, .loop		; Reached the end? If not, loop
	
.notFound:
	xor  a ; C Flag = clear
	ret
	
