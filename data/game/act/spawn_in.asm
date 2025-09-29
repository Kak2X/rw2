; =============== ActS_SpawnRel ===============
; Spawns the specified actor, positioned relative to the currently processed one.
;
; Useful to spawn projectiles relative to the actor's origin.
; Obviously requires an actor being processed.
;
; After this is called, a new actor can be spawned using the same template
; by calling ActS_Spawn directly.
;
; IN
; - A: Actor ID
; - B: Relative X pos
; - C: Relative Y pos
; OUT
; - HL: Pointer to the actor slot with the newly spawned one.
;       Only valid if the following flag is clear.
; - C Flag: If set, the actor couldn't be spawned (no free slot found)
ActS_SpawnRel:
	ld   [wActSpawnId], a
	
	; These manually spawned actors aren't part of the actor layout, so they don't have a pointer associated to them.
	; As a consequence, as soon they despawn in any way, they are gone permanently.
	xor  a
	ld   [wActSpawnLayoutPtr], a
	
	; Set spawn pos relative to current
	ldh  a, [hActCur+iActX]	; Read base pos
	add  b					; add ours
	ld   [wActSpawnX], a	; Set as X spawn
	ldh  a, [hActCur+iActY]	; Same for Y pos
	add  c
	ld   [wActSpawnY], a
	
	; Fall-through
	
; =============== ActS_Spawn ===============
; Spawns an actor.
; IN
; - wActSpawnId
; - wActSpawnLayoutPtr
; - wActSpawnX
; - wActSpawnY
; OUT
; - HL: Pointer to the actor slot with the newly spawned one.
;       Only valid if the following flag is clear.
; - C Flag: If set, the actor couldn't be spawned (no free slot found)
ActS_Spawn:

	;
	; Find the first empty slot.
	; There's enough space to store $10 actors at most.
	;
	ld   hl, wAct		; HL = Ptr to first slot
.loop:
	ld   a, [hl]		; A = iActId
	or   a				; iActId == 0?
	jr   z, .found		; If so, the slot is free 
	ld   a, l			; Otherwise, seek to the next one
	add  iActEnd		; HL += $10
	ld   l, a
	jr   nz, .loop		; Reached the end of the actor area? ($00) If not, loop
	scf  				; Otherwise, C Flag = Set
	ret
	
.found:
	;
	; Initialize the actor's properties
	;
	push hl
		push hl ; Save base slot ptr
			
			; Actor ID
			; This merges it with a flag that's mandatory to draw and execute the actor's code.
			ld   a, [wActSpawnId]	
			or   ACTF_PROC
			ldi  [hl], a ; iActId
			
			; Start from the first routine
			xor  a
			ldi  [hl], a ; iActRtnId

			; And from the first sprite mapping, with no flags
			ldi  [hl], a ; iActSprMap
			
			; Set the actor layout pointer
			ld   a, [wActSpawnLayoutPtr]
			ldi  [hl], a ; iActLayoutPtr
			
			; Set spawn coords
			xor  a
			ldi  [hl], a	; iActXSub
			ld   a, [wActSpawnX]
			ldi  [hl], a	; iActX
			xor  a
			ldi  [hl], a	; iActYSub
			ld   a, [wActSpawnY]
			ld   [hl], a	; iActY
			
			;
			; Copy the collision data with this actor over.
			; To give actors more free space in the main struct wAct, this is written to the separate table wActColi.
			;
			; The entries here are in the same exact order as those in wAct, so to switch between the two
			; all that's needed is to inc/dec the high byte of the slot pointer.
			; ie: $CD10 has its collision data at $CE10
			;
			push af
				ld   a, BANK(ActS_ColiTbl) ; BANK $03
				ldh  [hRomBank], a
				ld   [MBC1RomBank], a
			pop  af
			
			; BC = wActSpawnId * 10
			; Typical way of doing it, by separating the two nybbles in two separate registers
			; and swapping their order.
			ld   a, [wActSpawnId]
			ld   c, a
			swap a			; B = wActSpawnId >> 4
			and  $0F
			ld   b, a
			ld   a, c		; C = wActSpawnId << 4
			swap a
			and  $F0
			ld   c, a
			
			; HL = Ptr to collision table entry
			ld   hl, ActS_ColiTbl
			add  hl, bc
			
		; DE = Ptr to wActColi slot
		pop  de					; DE = Ptr to wAct slot
		ld   d, HIGH(wActColi)	; And seek to the respective wActColi one
		
		; Copy the next four bytes as-is
		; iActColiBoxH, iActColiBoxV, iActColiType, iActColiDamage
		ld   b, $04					; B = Bytes to copy
	.cpLoop:
		ldi  a, [hl]
		ld   [de], a
		inc  de
		dec  b
		jr   nz, .cpLoop
		
		
		;
		; Calculate the actor's health.
		; This is mainly specified in byte4, the actor's health value... 
		;
		ld   b, [hl]	; B = byte4 (Health)
		inc  hl
		
		; ...however, the health plays a part with actors that override the default death actions.
		; The default death handler for non-boss actors just converts the actor into an explosion and spawns a randomized item drop.
		; Any actor that needs to do anything else (ie: killing a child actor, notifying another actor, ...) must set the override flag to $01.
		;
		; As for how this is implemented, the death handler knows nothing about overrides, so the whole thing is hacked around the health system.
		; Actors that override the death sequence are given 16 more health, and their code is expected to check if their health goes below 17,
		; executing their death logic if so. This higher threshold prevents the normal death handler from kicking in.
		; There are a few helper subroutines that check for that threshold and kill the actor, such as ActS_ChkExplodeNoChild 
		; and ActS_ChkExplodeWithChild.
		ld   a, [hl]	; A = byte5 (Override default death)
		swap a			; *= $10, which has effect if 
		add  b			; Add it over to the health
		ld   [de], a	; Save to iActColiHealth
		inc  de
		
		; No initial invuln timer
		xor  a
		ld   [de], a ; iActColiInvulnTimer
		
	pop  hl ; HL = Ptr to newly spawned actor slot
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
