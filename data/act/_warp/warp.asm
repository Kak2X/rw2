; =============== Act_Helper_Teleport ===============
; Routine shared by all helper item actors (Rush, Sakugarne), handles teleporting in and out.
Act_Helper_Teleport:
	ld   a, [wWpnHelperWarpRtn]
	dec  a
	rst  $00 ; DynJump
	dw Act_Helper_TeleportIn_Init
	dw Act_Helper_TeleportIn_MoveD
	dw Act_Helper_TeleportIn_MoveDChkSpawn
	dw Act_Helper_TeleportIn_Anim
	dw Act_Helper_TeleportIn_ChkSolid
	dw Act_Helper_TeleportOut_InitAnim
	dw Act_Helper_TeleportOut_Anim
	dw Act_Helper_TeleportOut_MoveU

; =============== Act_Helper_TeleportIn_Init ===============
; Teleport in - initialize.
Act_Helper_TeleportIn_Init:
	; Use teleport sprite $02.
	; By convention, all helper items need to define it there.
	ld   a, $02
	call ActS_SetSprMapId
	
	; Reset gravity in preparation of falling from the top of the screen
	xor  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  [hActCur+iActSpdY], a
	
	; Next mode
	ld   hl, wWpnHelperWarpRtn
	inc  [hl]
	
	;--
	; The Sakugarne uses two sets of graphics, one without the player, the other with the player baked in.
	; It is possible to spawn one while the 2nd set is loaded, so to be sure force load the 1st set.
	; See also: Act_Sakugarne_WaitPl
	
	ld   a, [wWpnId]
	cp   WPN_SG			; Are we using the Sakugarne?
	ret  nz				; If not, return
	
	; Otherwise, request the loading.
	; It will take 2 frames, which is well ahead of our limit given the teleport animation uses shared graphics.
	ld   hl, GFX_Wpn_SgCr ; Source GFX ptr
	ld   de, $8500 ; VRAM Destination ptr (2nd set)
	ld   bc, (BANK(GFX_Wpn_SgCr) << 8) | $08 ; Source GFX bank number + Number of tiles to copy
	jp   GfxCopy_Req
	;--
	
; =============== Act_Helper_TeleportIn_MoveD ===============
; Teleport in - move down.
Act_Helper_TeleportIn_MoveD:
	; Move down until it reaches 24px above the player.
	; This is a common threshold applicable for all helpers.
	call ActS_ApplySpeedDownY
	ldh  a, [hActCur+iActY]	; B = ActX
	ld   b, a
	ld   a, [wPlRelY]		; A = PlX - 24
	sub  $18
	cp   b					; Player is below the actor? (PlX - 24 > ActX)
	ret  nc					; If so, keep moving down
	
	; Otherwise, start the ground anim
	ld   hl, wWpnHelperWarpRtn
	inc  [hl]
	ret
	
; =============== Act_Helper_TeleportIn_MoveDChkSpawn ===============
; Teleport in - move down and check if the helper is viable to spawn at the current position.
; This will continue moving down the actor until the checks pass or it moves below the level.
Act_Helper_TeleportIn_MoveDChkSpawn:

	;
	; If the actor has reached below the level, teleport out on the spot.
	; This can be easily noticed by attempting to spawn something while facing a solid wall.
	;
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y+SCREEN_GAME_V		; iActY < $90?
	jr   c, .chkRc						; If so, keep trying
	
	ld   a, AHW_WARPOUT_INITANIM			; Otherwise, teleport out
	ld   [wWpnHelperWarpRtn], a
	ret
	
	;
	; Depending on the helper we're spawning, check for something different.
	;
.chkRc:
	ld   a, [wWpnId]
	cp   WPN_RC						; Spawned Rush Coil?
	jr   nz, .chkRm					; If not, jump
	
	; Continue moving down until a solid block is hit
	call ActS_ApplySpeedDownYColi
	ret  c
	; When reached, advance to the next routine
	ld   a, $00						; Init anim
	ldh  [hActCur+iActTimer], a
	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
	
.chkRm:
	cp   WPN_RM						; Spawned Rush Marine?
	jr   nz, .chkRj					; If not, jump
	
	; Continue moving down until the actor reaches the player
	call ActS_ApplySpeedDownY
	ldh  a, [hActCur+iActY]			; B = ActY
	ld   b, a
	ld   a, [wPlRelY]				; A = PlY
	cp   b							; Player is below the actor? (PlY > ActY)
	ret  nc							; If so, keep moving down
	
	ldh  [hActCur+iActY], a			; Otherwise, align with player position
	ld   a, $00						; Init anim
	ldh  [hActCur+iActTimer], a
	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
	
.chkRj:
	; Identical to Rush Marine
	cp   WPN_RJ						; Spawned Rush Jet?
	jr   nz, .chkSg					; If not, jump
	
	; Continue moving down until the actor reaches the player
	call ActS_ApplySpeedDownY
	ldh  a, [hActCur+iActY]			; B = ActY
	ld   b, a
	ld   a, [wPlRelY]				; A = PlY
	cp   b							; Player is below the actor? (PlY > ActY)
	ret  nc							; If so, keep moving down
	
	ldh  [hActCur+iActY], a			; Otherwise, align with player position
	ld   a, $00						; Init anim
	ldh  [hActCur+iActTimer], a
	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
.chkSg:
	; Otherwise, assume the Sakugarne (WPN_SG)
	; Identical to Rush Coil
	
	; Continue moving down until a solid block is hit
	call ActS_ApplySpeedDownYColi
	ret  c
	; When reached, advance to the next routine
	ld   a, $00						; Init anim
	ldh  [hActCur+iActTimer], a
	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
	
; =============== Act_Helper_TeleportIn_Anim ===============
; Teleport in - ground animation
Act_Helper_TeleportIn_Anim:
	ldh  a, [hActCur+iActTimer]	; Timer++
	add  $01
	ldh  [hActCur+iActTimer], a
	
	; Starting from a pre-incremented $00, this will animate from $00 to $05
	srl  a							; SprMapId = Timer / 2 
	ld   [wActCurSprMapBaseId], a
	cp   $05						; SprMapId == 5?
	ret  nz							; If not, return

	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
	
; =============== Act_Helper_TeleportIn_ChkSolid ===============
; Teleport in - solid ground check.
Act_Helper_TeleportIn_ChkSolid:
	ld   a, $05						; Stay on sprite $05 while checking
	ld   [wActCurSprMapBaseId], a
	
	; LEFT SIDE
	ldh  a, [hActCur+iActY]			; Y Sensor: ActY - 4 (low)
	sub  $04
	ld   [wTargetRelY], a
	ldh  a, [hActCur+iActX]			; X Sensor: ActX - 8 (left)
	sub  $08
	ld   [wTargetRelX], a
	call Lvl_GetBlockId				; Is there an empty block there?
	jr   nc, .warpOut				; If not, teleport out
	
	; RIGHT SIDE
	ldh  a, [hActCur+iActX]			; X Sensor: ActX + 8 (right)
	add  $08
	ld   [wTargetRelX], a
	call Lvl_GetBlockId				; Is there an empty block there?
	jr   nc, .warpOut				; If not, teleport out
	
.ok:
	; Checks passed!
	ld   a, $00						; Return to normal sprite
	call ActS_SetSprMapId
	call ActS_FacePl				; Face the opposite side as the player. As it's spawned in front, 
	call ActS_FlipH					; typically this causes it to face the same direction as the player.
	
	ld   a, AHW_ACTIVE				; Mark helper item as active
	ld   [wWpnHelperWarpRtn], a
	ld   a, SFX_TELEPORTIN			; PLay landing sound
	mPlaySFX
	ld   a, 60*3					; If the player doesn't interact within 3 seconds, automatically teleport it out
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
.warpOut:
	; If we got here, a solid block was in the way, so teleport out immediately.
	; For what's worth, as this is done after doing the ground animation, it will
	; look slightly different compared to teleport from moving below the level.
	ld   hl, wWpnHelperWarpRtn
	inc  [hl]
	ret
	
; =============== Act_Helper_TeleportOut_InitAnim ===============
; Teleport out - ground animation init. 
Act_Helper_TeleportOut_InitAnim:
	ld   a, $02					; Use normal teleport sprite
	call ActS_SetSprMapId
	ld   a, $0A					; Wait 8 frames (see below)
	ldh  [hActCur+iActTimer], a
	ld   a, $05					; Start from sprite $05
	ld   [wActCurSprMapBaseId], a
	ld   hl, wWpnHelperWarpRtn	; Next mode
	inc  [hl]
	ret
	
; =============== Act_Helper_TeleportOut_Anim ===============
; Teleport out - ground animation. 
Act_Helper_TeleportOut_Anim:
	ldh  a, [hActCur+iActTimer]	; Timer--
	sub  $01
	ldh  [hActCur+iActTimer], a
	
	; Starting from a pre-decremented $0A, this will animate from $04 to $01
	srl  a							; SprMapId = Timer / 2 
	ld   [wActCurSprMapBaseId], a
	or   a							; SprMapId == 0?
	ret  nz							; If not, return
	
	ld   a, $02						; Use normal teleport sprite $02
	call ActS_SetSprMapId
	
	ldh  a, [hActCur+iActSprMap]	; Move up at 4px/frame
	and  $FF^ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ld   bc, $0400
	call ActS_SetSpeedY
	ld   a, SFX_TELEPORTOUT			; Play teleport sound
	mPlaySFX
	ld   hl, wWpnHelperWarpRtn		; Next mode
	inc  [hl]
	ret
	
; =============== Act_Helper_TeleportOut_MoveU ===============
; Teleport out - moving up. 
Act_Helper_TeleportOut_MoveU:
	; Continue moving up until we reach the top of the screen
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y		; iActY >= $10?
	ret  nc					; If so, return
	; Then despawn and flag that there's no helper actor active
	xor  a
	ldh  [hActCur+iActId], a
	ld   [wWpnHelperWarpRtn], a
	ret
	
