; =============== Act_Sakugarne ===============
; ID: ACT_WPN_SG
; Sakugarne helper item.
Act_Sakugarne:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Helper_Teleport
	dw Act_Sakugarne_WaitPl
	dw Act_Sakugarne_WaitGfxLoad
	dw Act_Sakugarne_Ride
	DEF ACTRTN_SAKUGARNE_TELEPORT = $00
	
; =============== Act_Sakugarne_WaitPl ===============
; Waiting for the player to ride it.
; See also: Act_RushCoil_WaitPl
Act_Sakugarne_WaitPl:

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
	jp   ActS_DecRtnId
	
.chkColi:
	;
	; Check if the Sakugarne should trigger.
	;
	
	; The player must have collided with this actor.
	ld   a, [wActHelperColiSlotPtr]
	ld   b, a						; B = Helper actor the player fell on
	ld   a, [wActCurSlotPtr]		; A = Current actor
	cp   b							; Do they match?
	ret  nz							; If not, return (not collided with)
	
	;
	; Player fell on the Sakugarne.
	;
	; Like when riding the Rush Marine, the normal player sprite is hidden, with the actor being
	; drawn with the player's graphics baked in, to save up on the amount of sprites drawn.
	;
	; However, keeping the playerless and w/player Sakugarne graphics loaded at the same time 
	; is a waste and also not possible, as in total they'd go over the 16 tile limit for weapon art sets.
	; Therefore, those two variations take up two separate sets, and we have to load the 2nd one.
	;
	
	; Since we're loading new GFX while the actor is onscreen, we have to hide it temporarily,
	; as long as it needs for the graphics to fully load.
	ld   a, $01
	call ActS_SetSprMapId
	
	; Start GFX load request
	ld   hl, GFX_Wpn_SgRide ; Source GFX ptr
	ld   de, $8500 ; VRAM Destination ptr (2nd set)
	ld   bc, (BANK(GFX_Wpn_SgRide) << 8) | $10 ; Source GFX bank number + Number of tiles to copy
	call GfxCopy_Req
	
	; Graphics are loaded 4 tiles/frame, so loading 16 tiles will take up 4 frames.
	ld   a, $04
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Sakugarne_WaitGfxLoad ===============
; Sets up the ride state.
Act_Sakugarne_WaitGfxLoad:
	; Wait 4 frames while the GFX set hopefully loads.
	; During this time the normal player sprite will still be visible.
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Same inconsistency as Rush Marine
	ld   a, [wPlRelX]			; ActX = PlX
	ldh  [hActCur+iActX], a
	ldh  a, [hActCur+iActY]		; PlY = ActY
	ld   [wPlRelY], a
	; The Sakugarne controls are handled by PL_MODE_GROUND and PL_MODE_FULLJUMP only.
	xor  a ; PL_MODE_GROUND
	ld   [wPlMode], a
	; Flag the Sakugarne as being riden.
	; This will hide the normal player sprite.
	inc  a
	ld   [wWpnSGRide], a		; wWpnSGRide = 1
	jp   ActS_IncRtnId
	
; =============== Act_Sakugarne_Ride ===============
; Player is riding it.
; Purely handles drawing the sprite and the ridiculous ammo usage.
Act_Sakugarne_Ride:
	; Sync Sakugarne with player's position
	ld   a, [wPlRelX]
	ldh  [hActCur+iActX], a
	ld   a, [wPlRelY]
	ldh  [hActCur+iActY], a
	
	; If we touch the bottom of the screen, teleport out.
	cp   OBJ_OFFSET_Y+SCREEN_GAME_V	; iActY > $90?
	jr   nc, .teleport				; If so, jump
	
	; Ammo consumption rate: every 1 unit / 4 frames (1 bar / ~half a second).
	ld   a, [wWpnHelperUseTimer]	; Timer -= $40
	sub  $40
	ld   [wWpnHelperUseTimer], a
	call c, WpnS_UseAmmo			; Underflowed? If so, use it
	
	ld   a, [wWpnAmmoCur]
	or   a							; Any ammo left?
	ret  nz							; If so, return
.teleport:
	xor  a ; PL_MODE_GROUND
	ld   [wPlMode], a				; Cut early any jump
	ld   [wWpnSGRide], a			; Disable ride mode & draw normal player sprite
	ld   a, AHW_WARPOUT_INITANIM	; Teleport the Sakugarne out
	ld   [wWpnHelperWarpRtn], a
	ld   a, ACTRTN_SAKUGARNE_TELEPORT
	ldh  [hActCur+iActRtnId], a
	ret
