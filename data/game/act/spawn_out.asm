; =============== ActS_Despawn ===============
; Despawns the current actor.
ActS_Despawn:

	;
	; When Rush Coil/Jet/Marine and the Sakugarne despawn, they have finished their teleport animation.
	; Clear that for later, otherwise they can't be called in again.
	;
	ldh  a, [hActCur+iActId]
	cp   ACTF_PROC|ACT_WPN_RC			; iActId < $E0?
	jr   c, .despawn	; If so, skip
	cp   ACTF_PROC|ACT_WPN_SG+1		; iActId >= $E4?
	jr   nc, .despawn	; If so, skip
	xor  a
	ld   [wWpnHelperWarpRtn], a
	
.despawn:
	; Mark the slot as free
	xor  a
	ldh  [hActCur+iActId], a
	
	; Allow the actor to respawn.
	; Since the actor is gone, it should be able to spawn again when scrolling towards its initial position.
	; Actors that call this subroutine and have a pointer set *always* do this.
	; If permadespawning is wanted (ie: collecting 1UPs) just mark the slot as free without doing anything else.
	ld   h, HIGH(wActLayoutFlags)			; (Could have been set later)
	ldh  a, [hActCur+iActLayoutPtr]
	or   a									; Is the actor part of the actor layout?
	ret  z									; If not, return (can't tell to respawn what's not there)
	ld   l, a								; Otherwise, seek HL to the wActLayoutFlags entry
	ld   a, [hl]
	res  ACTLB_NOSPAWN, a					; and disable nospawn flag
	ld   [hl], a
	ret
	
