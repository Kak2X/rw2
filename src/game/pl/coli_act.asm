; =============== Pl_DoActColi ===============
; Checks for player collision against all actors.
; See also: Wpn_DoActColi
Pl_DoActColi:

	; Make a copy of this before it gets wiped right below.
	; The copy will be exclusively used by this subroutine.
	ld   a, [wActRjStandSlotPtr]
	ld   [wActRjStandLastSlotPtr], a
	
	; Reset slot markers.
	; There are generally used to signal to another actor that a specific type of collision has happened.
	; Actor code may check for these by comparing their actor slot pointer to what's specified in the markers,
	; and if it matches the actor knows the player has collided with it in some way.
	ld   a, ACTSLOT_NONE
	ld   [wActHurtSlotPtr], a
	ld   [wActPlatColiSlotPtr], a
	ld   [wActRjStandSlotPtr], a
	ld   [wActHelperColiSlotPtr], a
	
	;
	; Player collision box - Vertical radius.
	; 
	; Typically this is PLCOLI_V (12px pixels, aka 24px tall) unless the player is sliding.
	; In that case, the radius is halved.
	;
	ld   b, PLCOLI_V	; B = Normal radius
	ld   a, [wPlMode]
	cp   PL_MODE_SLIDE	; Are we sliding?
	jr   nz, .setPlH	; If not, skip
	srl  b				; Otherwise B /= 2
.setPlH:
	ld   a, b
	ld   [wPlColiBoxV], a
	
	;
	; As mentioned in Wpn_DoActColi, the bounding box checks require the origin to be centered.
	;
	ld   a, [wPlRelY]		; A = Player Y origin (bottom)
	sub  b					; Move up to center
	ld   [wPlCenterY], a	; Don't recalculate again
	
	
	;
	; Loop through all 16 actors, handling collision for any with overlapping bounding boxes.
	;
	xor  a					; Start from the first slot
.loop:
	; Prepare main slot pointer
	ld   d, HIGH(wAct)			; DE = Ptr to main slot (wAct)
	ld   e, a
	ld   [wActCurSlotPtr], a	; Save ptr for future use
	
	; Skip empty slots
	ld   a, [de]
	or   a						; iActId == 0?
	jr   z, .nextSlot			; If so, jump
	
	; Prepare collision data slot pointer.
	; This is exactly $100 bytes after DE.	
	ld   h, HIGH(wActColi)		; HL = Ptr to respective wActColi entry
	ld   l, e
	
	;
	; HORIZONTAL BOUNDING BOX CHECK
	;
	
	; Set up fields
	ld   a, e			; DE = Ptr to iActX
	add  iActX
	ld   e, a
	ld   a, [wPlRelX]	; B = wPlRelX
	ld   b, a
	
	; Calculate the absolute distance
	ld   a, [de]		; A = iActX
	sub  b				; Get distance (iActX - wPlRelX)
	jr   nc, .setDistX	; Is that a positive value? If so, skip
	xor  $FF			; Otherwise, convert to positive
	inc  a
	scf					; (leftover from other code that uses this flag)
.setDistX:
	ld   b, a			; B = Distance
	; If the player isn't horizontally overlapping with the collision box, seek to the next slot
	ldi  a, [hl]		; Get actor radius (A = iActColiBoxH, seek to iActColiBoxV)
	; [BUG] Off by one inconsistency with the block collision code
	add  PLCOLI_H+1		; Sum with player radius, that's the max distance (A += wWpnColiBoxH)
	cp   b				; MaxDistance - Distance < 0? (Distance > MaxDistance?)
	jr   c, .nextSlot	; If so, jump (not colliding, too far)
	
	;
	; VERTICAL BOUNDING BOX CHECK
	;
	
	inc  e ; iActYSub
	inc  e ; iActY
	ld   a, [wPlColiBoxV]	; C = wPlColiBoxV
	ld   c, a
	ld   a, [wPlCenterY]	; B = wPlCenterY
	ld   b, a
	
	; Calculate the absolute distance, like above
	ld   a, [de]			; A = iActY (origin, bottom)
	sub  [hl]				; A -= iActColiBoxV (middle)
	sub  b					; Get distance (iActY - wPlCenterY)
	jr   nc, .setDistY		; Is that a positive value? If so, skip
	xor  $FF				; Otherwise, convert to positive
	inc  a
	scf  					; (leftover from other code that uses this flag)
.setDistY:
	ld   b, a				; B = Distance
	; Do the bounds check
	ldi  a, [hl]			; A = iActColiBoxV, seek to iActColiType
	add  c					; A += wPlColiBoxV
	cp   b					; MaxDistance - Distance >= 0? (Distance <= MaxDistance?)
	call nc, Pl_OnActColi	; If so, we're in range. Handle collision.
							; Otherwise, seek to the next slot
.nextSlot:
	ld   a, [wActCurSlotPtr]	; A = Low byte of slot pointer
	add  iActEnd				; Next slot
	
	jr   nz, .loop				; Processed all 16 slots (overflowed back to $00?) If not, loop
	ret
	
; =============== Pl_OnActColi ===============
; Handles collision for the player against a specific actors.
; IN
; - HL: Ptr to the actor's collision type (iActColiType)
; - DE: Ptr to the actor's Y position (iActY)
Pl_OnActColi:

	;
	; Determine how to handle it depending on the actor's collision type.
	;
	
	ldi  a, [hl]			; A = iActColiType, seek to iActColiDamage/iActColiSubtype
	; Ignore intangible actors
	or   a					; A == ACTCOLI_PASS?
	ret  z					; If so, return
	; Actors with collision types >= $80 are enemies partially vulnerable on top (see Wpn_OnActColi.typePartial).
	; [POI] Note that this isn't the full range of values for this collision type, that would be $08-$FF.
	;       This causes the excluded range to fail all checks and not hurt the player at all.
	bit  ACTCOLIB_PARTIAL, a	; A >= $80?
	jr   nz, .coliEnemy		; If so, jump
	; Check non-enemy collision types elsewhere
	cp   ACTCOLI_PLATFORM	; A >= $04?
	jr   nc, .coliPlatform	; If so, jump
	
; --------------- .coliEnemy ---------------
; Enemy collision type, which causes the player to be damaged.
; Used by:
; - ACTCOLI_ENEMYPASS
; - ACTCOLI_ENEMYHIT
; - ACTCOLI_ENEMYREFLECT
.coliEnemy:

	; If cheating, we're invulnerable
	ldh  a, [hCheatMode]
	or   a
	ret  nz
	
	; If we're in the middle of mercy invincibility, well...
	ld   a, [wPlInvulnTimer]
	or   a
	ret  nz
	
	; Keep track of the actor slot we got hit by.
	; Exactly one actor makes use of this.
	ld   a, [wActCurSlotPtr]
	ld   [wActHurtSlotPtr], a
	
	; Play hurt SFX
	ld   a, SFX_DAMAGED
	mPlaySFX
	
	; Stay in the hurt pose for around half a second
	ld   a, $20
	ld   [wPlHurtTimer], a
	; With a full second of invulnerability afterwards
	ld   a, $3C
	ld   [wPlInvulnTimer], a
	
	;--
	;
	; Only PL_MODE_GROUND and PL_MODE_FALL support the hurt pose.
	; Force the player into the former to enable it.
	; (if we're in the air, it will transition to PL_MODE_FALL)
	;
	
	ld   a, [wPlMode]
	; Getting forced out of sliding could cause the player to get stuck.
	cp   PL_MODE_SLIDE
	jr   z, .decHealth
	; Don't get forced out of Rush Marine either, there might be pits.
	; It would also be the improper way of doing it, as just setting PL_MODE_GROUND
	; would cause the player and Rush Marine to be active at the same time.
	cp   PL_MODE_RM
	jr   z, .decHealth
	; Sakugarne has its own ride mode on top of the player's idle state,
	; so it needs no special checks
	xor  a ; PL_MODE_GROUND
	ld   [wPlMode], a
	;--
.decHealth:
	; Deal damage to the player
	ld   h, HIGH(wActColi)		; Seek HL to iActColiDamage 
	ld   a, [wActCurSlotPtr]
	add  iActColiDamage
	ld   l, a
	
	; wPlHealth -= iActColiDamage
	ld   a, [wPlHealth]			; A = Player health
	sub  [hl]					; Subtract the damage received
	jr   nc, .setHealth			; Did we underflow the health? If not, skip
	xor  a						; Otherwise, cap to 0
.setHealth:
	push af
		ld   [wPlHealth], a			; Save back the updated health
		
		ld   [wPlHealthBar], a		; Trigger redrawing the health bar
		ld   hl, wStatusBarRedraw
		set  BARID_PL, [hl]
	
	;
	; If we have no health left, explode the player.
	;
	pop  af			; Get wPlHealth
	or   a			; wPlHealth != 0?
	ret  nz			; If so, return
	
	; The explosions originate from the center of the player
	ld   a, [wPlRelX]		; X Origin = Player's X origin (center)
	ld   [wExplodeOrgX], a
	ld   a, [wPlRelY]		; Y Origin = Player's Y origin (bottom)
	sub  PLCOLI_V			; Move up to middle
	ld   [wExplodeOrgY], a
	
	; And trigger it
	ld   a, LVLEND_PLDEAD
	ld   [wLvlEnd], a
	ret
	
; --------------- .coliPlatform ---------------
; Solid platforms and helper items.
; Since these cannot damage the player, iActColiDamage gets reused as iActColiSubtype here.
.coliPlatform:
	cp   ACTCOLI_PLATFORM	; iActColiType == ACTCOLI_PLATFORM?
	jp   nz, .coliMagnet	; If not, jump
	
	; Check the collision subtype...
	ldd  a, [hl]		; A = iActColiSubtype, seek to iActColiType
	or   a				; A != ACTCOLISUB_TOPSOLID?
	jr   nz, .spinTop	; If so, jump
	
.topSolid:
	;
	; Generic top-solid platform.
	; 

	; Standing on Rush Jet disables collision with top-solid platforms
	ld   a, [wActRjStandLastSlotPtr]
	cp   ACTSLOT_NONE
	ret  nz
	
	; Try to snap to the top of the platform
	jp   .chkSnapTop
	
.spinTop:
	;
	; Spinning top, which moves the player back and forth.
	; 
	
	cp   ACTCOLISUB_SPINTOP	; A != ACTCOLISUB_SPINTOP?
	jr   nz, .helpers	; If so, jump
	
	; Standing on Rush Jet disables collision with spinning tops
	ld   a, [wActRjStandLastSlotPtr]
	cp   ACTSLOT_NONE
	ret  nz
	
	; Try to snap to the top of the platform
	call .chkSnapTop
	
	;
	; Handle the automatic player movement when colliding with one.
	; [BUG] This forgets to check if we're actually standing on the
	;       platform ("ret c" after the call above)
	;
	
	; Every 16 frames, alternate the player's horizontal direction (bit0)
	ldh  a, [hTimer]				; wPlDirH = (hTimer / $10) % 2
	swap a
	and  $01
	ld   [wPlDirH], a
	
	; Alter the player's speed by 0.5px/frame to that direction
	; iActSprMap has its direction flag on bit7
	; Rotate bit0 to bit7
	rrca 							; A = iActSprMap (Direction)
	ld   bc, $0080					; BC = 0.5px/frame
	call Pl_AdjSpeedByActDir	; Update the speed by BC
	
	; And actually move the player
	jp   Pl_MoveBySpeedX_Coli
	
.helpers:
	;
	; The remainder of subtypes are used by helper actors (Rush, Sakugarne).
	; Each helper actor has its own collision subtype.
	;
	
	; Only process this collision if the actor is fully active.
	; (ie: it must be spawned, and it must not be teleporting)
	ld   b, a
		ld   a, [wWpnHelperWarpRtn]
		cp   AHW_ACTIVE		; wWpnHelperWarpRtn != AHW_ACTIVE?
		ret  nz				; If so, return
	ld   a, b
	
	;
	; Rush Jet is a top-solid platform whose vertical position can be controlled
	; only when standing on it.
	;
	
	cp   ACTCOLISUB_RJ			; iActColiSubtype != ACTCOLISUB_RJ?
	jr   nz, .markHelperColi	; If so, skip
	
	; Try to snap to the top of Rush Jet
	call .chkSnapTop			; Are we standing on it now?
	jr   nc, .markHelperColi	; If not, skip
								; Otherwise...
							
	; Mark the player as standing on Rush Jet by flagging the actor slot.
	ld   a, [wActCurSlotPtr]
	ld   [wActRjStandSlotPtr], a
	
	; Move player 1px vertically depending on the direction held.
	; To go along with it, the actor also moves, but that's handled separately.
	ld   hl, wPlRelY			; HL = Ptr to wPlRelY
	ldh  a, [hJoyKeys]
	rla							; Holding DOWN?
	jr   nc, .chkRjD			; If not, jump
	inc  [hl]					; Otherwise, move 1px down
	jr   .markHelperColi
.chkRjD:
	rla  						; Holding UP?
	jr   nc, .markHelperColi	; If not, jump
	dec  [hl]					; Otherwise, move 1px up
	
.markHelperColi:
	; Signal out that collision has happened with the checked helper actor.
	; The actors themselves will check if they were collided with and activate their effects.
	
	; Their effects should only trigger when falling on them, on the way down.
	ld   a, [wPlMode]
	cp   PL_MODE_FALL				; wPlMode == PL_MODE_FALL?
	ret  nz							; If not, return
	ld   a, [wActCurSlotPtr]
	ld   [wActHelperColiSlotPtr], a
	ret
	
; --------------- .chkSnapTop ---------------
; Snaps the player to the top of the platform if they are above the platform's center point.
; Note that we can only get here when the player and platform collision boxes overlap.
;
; IN
; - HL: Ptr to iActColiType
; - DE: Ptr to the actor's Y position (iActY)
; OUT
; - C Flag: If set, the player is standing on the platform
.chkSnapTop:
	DEF tPlatColiV = wTmpCF52
	DEF tActY      = wTmpCF53
	
	; B = Vertical center position of the platform, absolute
	dec  l ; iActColiBoxV
	ld   a, [hl]			; B = iActColiBoxV
	ld   [tPlatColiV], a	; Save for later
	ld   b, a
	ld   a, [de]			; A = iActY (bottom)
	ld   [tActY], a			; Save for later
	sub  b					; Move to center
	ld   b, a
	
	; If the player is below that point, return
	ld   a, [wPlRelY]
	cp   b					; wPlRelY >= PlatCenter?
	ret  nc					; If so, return
	
	; Only if the player is on the ground or jumping.
	; [BUG] This forgets to account for the player sliding.
	ld   a, [wPlMode]
	cp   PL_MODE_CLIMB		; wPlMode >= PL_MODE_CLIMB?
	ret  nc					; If so, return
	
	;
	; If the player is standing on solid ground already, return.
	;
	; Standing on a solid ground means that both the bottom-left and bottom-right
	; edges of the collision box are on solid blocks (or ladder top tiles).
	;
	
	; Target the ground for both checks
	ld   a, [wPlRelY]		; Y Target = 1px below bottom border
	inc  a
	ld   [wTargetRelY], a
	
	; Check left sensor
	ld   a, [wPlRelX]			; X Target = Left (wPlRelX - PLCOLI_H)
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_TOPSOLID_START	; Is this a solid block on top? (A >= $21)
	ret  nc						; If so, return
	
	; Check right sensor
	ld   a, [wPlRelX]			; X Target = Right (wPlRelX + PLCOLI_H)
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId
	cp   BLOCKID_TOPSOLID_START	; Is this a solid block on top? (A >= $21)
	ret  nc						; If so, return
	
	;
	; All checks passed, snap the player to the top of the actor.
	;
	ld   a, [tPlatColiV]	; B = V Collision box radius
	ld   b, a
	ld   a, [tActY]			; A = Actor Y origin (bottom)
	sub  b					; to middle
	sub  b					; to top
	
	; Don't put the player directly above the border, but 2 pixels below,
	; to make sure the player keeps colliding with the platform even when
	; said platform moves down.
	; A consequence is that platforms can't move down faster than 1px/frame,
	; otherwise the player may stop overlapping with its collision box.
	inc  a
	inc  a
	ld   [wPlRelY], a		; Save back updated player pos
	
	; Mark the player as standing on this actor.
	ld   a, [wActCurSlotPtr]
	ld   [wActPlatColiSlotPtr], a
	
	scf  ; C Flag = Set
	ret
	
; --------------- .coliMagnet ---------------
; Magnetic Fields.
.coliMagnet:
	cp   ACTCOLI_MAGNET		; iActColiType == ACTCOLI_MAGNET?
	jr   nz, .coliItem		; If not, jump
	
	; This collision type is used by the magnetic fields in Magnet Man's stage.
	; While the actors use a small wave sprite, their actual collision box covers
	; the entire area that needs to attract the player to the right. 
	
	; Moves the player 0.5px/frame right on contact.
	; There are no magnetic fields that attract to the left, so the direction here is hardcoded.
	ld   a, ACTDIR_R	; Move right
	ld   bc, $0080		; Move 0.5px/frame
	jp   Pl_AdjSpeedByActDir
	
; --------------- .coliItem ---------------
; Collectable items.
.coliItem:
	cp   ACTCOLI_ITEM		; iActColiType == ACTCOLI_ITEM?
	ret  nz				; If not, return
	
	; The collision code to run depends on the item type we collected.
	; That is determined by the actor ID.
	ld   h, HIGH(wAct)	; Seek HL to iActId
	ld   a, [wActCurSlotPtr]
	ld   l, a
	ld   a, [hl]		; A = iActId
	; Force valid range, as items are all located within the first 8 actor IDs.
	and  $07
	
	push af ; Save untouched iActId
		
		; Despawn the item
		xor  a
		ld   [hl], a	; iActId
		
		inc  l ; iActRtnId
		inc  l ; iActSprMap
		inc  l ; iActLayoutPtr
		
		; If the item is part of the actor layout (ie: wasn't an enemy drop), permadespawn it.
		ld   a, [hl]			; Read location in actor layout
		or   a					; Is one set?
		jr   z, .execItemCode	; If not, skip
		ld   l, a				; Otherwise, seek HL to its location there
		ld   h, HIGH(wActDespawnTbl)
		ld   [hl], ACTL_NOSPAWN	; Mark the item as collected
		
.execItemCode:
	pop  af ; A = Collected iActId
	rst  $00 ; DynJump
	dw .noItem    ; ACT_EXPLSM (Not used)
	dw .extraLife ; ACT_1UP
	dw .ammoLg    ; ACT_AMMOLG
	dw .healthLg  ; ACT_HEALTHLG
	dw .healthSm  ; ACT_HEALTHSM
	dw .ammoSm    ; ACT_AMMOSM
	dw .etank     ; ACT_ETANK
	dw .noItem    ; ACT_EXPLLGPART (Not used)

; --------------- .extraLife ---------------
; 1-UP
.extraLife:
	; Cap lives to 9
	ld   a, [wPlLives]
	cp   $09			; wPlLives >= 9?
	ret  nc				; If so, return
	
	; Add an extra life
	inc  a
	ld   [wPlLives], a
	
	; Redraw the status bar
	ld   [wPlLivesView], a
	ld   hl, wStatusBarRedraw
	set  BARID_LIVES, [hl]
	
	; Obtain 2 coins
	ld   a, SFX_1UP
	mPlaySFX
	ret
	
; --------------- .ammoLg ---------------
; Large Weapon Energy
.ammoLg:
	ld   a, [wWpnAmmoInc]	; Add 9 bars of ammo
	add  BAR_UNIT*9
	ld   [wWpnAmmoInc], a
	ret
; --------------- .ammoSm ---------------
; Small Weapon Energy
.ammoSm:
	ld   a, [wWpnAmmoInc]	; Add 3 bars of ammo
	add  BAR_UNIT*3
	ld   [wWpnAmmoInc], a
	ret
	
; --------------- .healthLg ---------------
; Large Life Energy
.healthLg:
	ld   a, [wPlHealthInc]	; Add 9 bars of health
	add  BAR_UNIT*9
	ld   [wPlHealthInc], a
	ret
; --------------- .healthSm ---------------
; Small Life Energy
.healthSm:
	ld   a, [wPlHealthInc]	; Add 3 bars of health
	add  BAR_UNIT*3
	ld   [wPlHealthInc], a
	ret
	
; --------------- .etank ---------------
; E-Tank
.etank:
	; Cap E-Tanks to 4
	ld   a, [wETanks]
	cp   $04
	ret  nc
	
	; Add an E-Tank
	inc  a
	ld   [wETanks], a
	
	; Play whatever the E-Tank sound is supposed to be
	ld   a, SFX_ETANK
	mPlaySFX
	
; --------------- .noItem ---------------
; Placeholder entry.
.noItem:
	ret
	
