; =============== WpnCtrl_ChkSpawnHelper ===============
; Tries to spawn an item helper actor. (Rush, Sakugarne)
; IN
; - wActSpawnId: Actor ID
WpnCtrl_ChkSpawnHelper:
	; If there's not enough ammo to jump on Rush Coil, don't even bother calling him in
	call WpnS_HasAmmoForShot
	ret  c
	
	; If we didn't press B to call in Rush/Sakugarne, there's nothing to spawn
	ldh  a, [hJoyNewKeys]
	bit  KEYB_B, a
	ret  z
	
	; Don't spawn it if one is already active.
	; (this includes different helpers when teleporting out)
	ld   a, [wWpnHelperWarpRtn]
	or   a ; AHW_NONE
	ret  nz
	
	;
	; Passed the checks.
	; Spawn the actor from the top of the screen, as they teleport in to the player's vertical position.
	;
	
	xor  a					; Not part of the actor layout
	ld   [wActSpawnLayoutPtr], a
	
	; Spawn immediately offscreen above
	ld   a, OBJ_OFFSET_Y-1	; 1 pixel above the edge of the screen
	ld   [wActSpawnY], a
	
	; Spawn 24 pixels in front of the player
	ld   b, $18				; B = 24px to the right
	ld   a, [wPlDirH]
	and  DIR_R			; Facing right?
	jr   nz, .setX			; If so, skip
	ld   b, $E8				; B = 24px to the left
.setX:
	ld   a, [wPlRelX]		; XPos = PlX + B
	add  b
	ld   [wActSpawnX], a
	
	call ActS_Spawn			; Did it spawn?
	ret  c					; If not, return
	ld   a, AHW_WARPIN_INIT	; Otherwise, flag that an helper is onscreen, so no more can spawn
	ld   [wWpnHelperWarpRtn], a
	ret
	
