; =============== Act_RushMarine ===============
; ID: ACT_WPN_RM
; Rush Marine helper item.
Act_RushMarine:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Helper_Teleport
	dw Act_RushMarine_ChkSpawnPos
	dw Act_RushMarine_WaitPl
	dw Act_RushMarine_Ride
	DEF ACTRTN_RUSHMARINE_TELEPORT = $00

; =============== Act_RushMarine_ChkSpawnPos ===============
; Determines if the location Rush Marine teleported into is viable.
; If it isn't, it will immediately teleport out before the player can get in.
Act_RushMarine_ChkSpawnPos:

	;
	; Not applicable if the level doesn't have any water to begin with
	;
	ld   a, [wLvlWater]
	or   a
	jr   z, .warpOut
	
	;
	; Rush must have fully landed on a water block (both top and bottom)
	;
.chkBottom:
	ldh  a, [hActCur+iActX]		; X Sensor: ActX (center)
	ld   [wTargetRelX], a
	ldh  a, [hActCur+iActY]		; Y Sensor: ActY (bottom)
	ld   [wTargetRelY], a
	call Lvl_GetBlockId			; A = Block ID
	cp   BLOCKID_WATER			; Is it a water block?
	jr   z, .chkTop				; If so, jump (ok)
	cp   BLOCKID_WATERSPIKE		; Is it an underwater spike?
	jr   nz, .warpOut			; If not, jump (fail)
.chkTop:
	ldh  a, [hActCur+iActY]		; Y Sensor: ActY - $0F (top of block)
	sub  BLOCK_V-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId			; Do the same block checks
	cp   BLOCKID_WATER
	jp   z, ActS_IncRtnId
	cp   BLOCKID_WATERSPIKE
	jp   z, ActS_IncRtnId
	
.warpOut:
	ld   a, AHW_WARPOUT_INITANIM	; Checks failed, start teleporting
	ld   [wWpnHelperWarpRtn], a
	jp   ActS_DecRtnId
	
; =============== Act_RushMarine_WaitPl ===============
; Waiting for the player to ride it.
; See also: Act_RushCoil_WaitPl
Act_RushMarine_WaitPl:

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
	ld   a, ACTRTN_RUSHMARINE_TELEPORT
	ldh  [hActCur+iActRtnId], a
	ret
	
.chkColi:
	;
	; Check if Rush Marine should trigger.
	;
	
	; The player must have collided with this Rush Marine actor.
	ld   a, [wActHelperColiSlotPtr]
	ld   b, a						; B = Helper actor the player fell on
	ld   a, [wActCurSlotPtr]		; A = Current actor
	cp   b							; Do they match?
	ret  nz							; If not, return (not collided with)
	
	; Initialize momentum variables
	xor  a
	ld   [wPlRmSpdL], a
	ld   [wPlRmSpdR], a
	ld   [wPlRmSpdU], a
	ld   [wPlRmSpdD], a
	
	; Teleport the Rush Marine at the player's X position
	ld   a, [wPlRelX]
	ldh  [hActCur+iActX], a
	; Inconsistently, do the opposite with the Y position
	ldh  a, [hActCur+iActY]
	ld   [wPlRelY], a
	; Enter the ride state. This will hide the normal player sprite, only drawing Rush Marine.
	ld   a, PL_MODE_RM
	ld   [wPlMode], a
	jp   ActS_IncRtnId
	
; =============== Act_RushMarine_Ride ===============
; Player is riding it.
; This mostly handles drawing the sprite, while the controls are by PlMode_RushMarine.
Act_RushMarine_Ride:
	; Animate propeller (use frames $xx-$xx+1 at 1/8 speed)
	ld   c, $01
	call ActS_Anim2
	
	;
	; Flashing after getting hit, in differenr ways depending on how long has passed.
	; Keep in mind the Rush Marine ride state does not handle the hurt state at all,
	; so the player can keep moving Rush as normal during this.
	;
	; The sprite mappings for Rush Marine are grouped in pairs, since the propeller animation
	; is always done even when flashing, which may offset by 1 the result:
	;
	; ...
	; $08-$09: Hidden
	; $0A-$0B: Normal
	; $0C-$0D: Flashing (OBP1)
	; 
	
	;
	; Immediately after getting hurt, start flashing Rush Marine's palette every 2 frames.
	; This is done by alternating between sprite mappings $0A-$0B (normal) and $0C-$0D (inverted),
	; not by simply updating the sprite's palette (which isn't possible with the current system).
	;
.chkHurt:
	ld   a, [wPlHurtTimer]
	or   a					; Player got hurt?
	jr   z, .chkInvuln		; If not, skip
	ldh  a, [hTimer]		
	and  $02				; Each set has 2 sprites; this also causes the flashing to happen every 2 frames
	add  $0A				; Use $0A-0B (normal) or $0C-$0D (OBP1)
	jr   .setSpr
.chkInvuln:
	;
	; If the player is in mercy invulnerability, flash by hiding the sprite every 2 frames.
	;
	ld   a, [wPlInvulnTimer]
	or   a					; Player is invulnerable?
	jr   z, .noFlash		; If not, skip
	ldh  a, [hTimer]
	and  $02				; ...
	add  $08				; Use $08-09 (hide) or $0A-$0B (normal)
	jr   .setSpr
.noFlash:
	; Otherwise, display the normal sprites
	ld   a, $0A				; Use $0A-$0B
	
.setSpr:
	ld   [wActCurSprMapBaseId], a	; Apply sprite
	ld   a, [wPlRelX]				; Sync Rush Marine with player's position (latter set by PlMode_RushMarine)
	ldh  [hActCur+iActX], a
	ld   a, [wPlRelY]
	ldh  [hActCur+iActY], a
	
	; Face the same direction as the player
	ld   a, [wPlDirH]				; Get player direction (DIR_L or DIR_R, bit0)
	rrca 							; Shift to bit7
	and  ACTDIR_R					; Filter out other bits
	ld   b, a						; to B
	ldh  a, [hActCur+iActSprMap]	; Get actor sprite info
	and  $FF^ACTDIR_R				; Delete horizontal direction flag
	or   b							; Replace with the player's
	ldh  [hActCur+iActSprMap], a	; Save back
	
	;
	; Ammo consumption rate: every 1 unit / 16 frames (1 bar / ~2 seconds).
	; Once it's fully consumed, kick the player out.
	;
	; [POI] This address is only initialized when the level starts and never again.
	;       This can be theoretically used to avoid consuming weapon ammo by switching 
	;       out just in time and letting another weapon underflow the timer, in practice
	;       it's pointless and annoying to do.
	ld   a, [wWpnHelperUseTimer]	; Timer -= $10
	sub  $10
	ld   [wWpnHelperUseTimer], a
	call c, WpnS_UseAmmo			; Underflowed? If so, use it
	
	ld   a, [wWpnAmmoCur]
	or   a							; Any ammo left?
	ret  nz							; If so, return
	xor  a ; PL_MODE_GROUND			; Otherwise, force player out of the ride
	ld   [wPlMode], a
	ld   a, AHW_WARPOUT_INITANIM	; and teleport Rush out
	ld   [wWpnHelperWarpRtn], a
	ld   a, ACTRTN_RUSHMARINE_TELEPORT
	ldh  [hActCur+iActRtnId], a
	ret
	
