; =============== Act_RushCoil ===============
; ID: ACT_WPN_RC
; Rush Coil helper item.
Act_RushCoil:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Helper_Teleport
	dw Act_RushCoil_WaitPl

; =============== Act_RushCoil_WaitPl ===============
Act_RushCoil_WaitPl:
	;
	; The timer is initially set to 3 seconds.
	; When 1 second remains, start flashing.
	;
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	cp   60
	jr   nc, .chkColi
	
	; Flash by alternating between frames $00 and $08 every 4 frames.
	; iActSprMap is guaranteed to be $00 when we get here.
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
	jp   ActS_DecRtnId		; Back to Act_Helper_Teleport
	
.chkColi:
	;
	; Check if Rush Coil should trigger.
	;
	
	; The player must have collided with this Rush Coil actor.
	; This collision is checked by Pl_DoActColi.markHelperColi, and only triggers if the player is falling on it.
	ld   a, [wActHelperColiSlotPtr]
	ld   b, a						; B = Helper actor the player fell on
	ld   a, [wActCurSlotPtr]		; A = Current actor
	cp   b							; Do they match?
	ret  nz							; If not, return (not collided with)
	
	; If Rush has already bounced the player up, don't do it again.
	ldh  a, [hActCur+iActSprMap]
	bit  3, a						; Is Rush's spring sprite used? ($01)
	ret  nz							; If so, return (already bounced up)
	
	or   $08						; Use spring sprite
	ldh  [hActCur+iActSprMap], a
	ld   a, PL_MODE_FULLJUMP		; Trigger player jump
	ld   [wPlMode], a
	ld   a, $04						; at 4.5px/frame
	ld   [wPlSpdY], a
	ld   a, $80
	ld   [wPlSpdYSub], a
	jp   WpnS_UseAmmo				; Use ammo for the trouble
	
