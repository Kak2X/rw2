; =============== PlColi_Spike ===============
; Handles collision with a spike block.
PlColi_Spike:
	;
	; [TCRF] When cheating, spikes become bouncy pits.
	;
	ldh  a, [hCheatMode]
	or   a
	jr   z, .explode
.bounce:
	ld   a, PL_MODE_FULLJUMP	; Jump up at 5px/frame
	ld   [wPlMode], a
	ld   a, $05
	ld   [wPlSpdY], a
	ld   a, $00
	ld   [wPlSpdYSub], a
	jp   Pl_DrawSprMap
	
.explode:
	; Otherwise, trigger an explosion from the center of the player.
	; [BUG] Actor collision is still processed for this frame, which can lead to oddities
	;       such as entering Rush Marine the same frame of touching a spike.
	
	ld   a, [wPlRelX]		; X Target = PlX (center)
	ld   [wExplodeOrgX], a
	ld   a, [wPlRelY]		; Y Target = PlY (bottom)
	sub  PLCOLI_V			; -= radius (center)
	ld   [wExplodeOrgY], a
	ld   a, LVLEND_PLDEAD	; Trigger death
	ld   [wLvlEnd], a

	jp   Pl_DrawSprMap
	
; =============== Pl_StopTpAttack ===============
; Makes the player stop spinning.
Pl_StopTpAttack:
	ld   a, [wWpnId]
	cp   WPN_TP				; Are we using Top Spin?
	ret  nz					; If not, return
	xor  a
	ld   [wWpnTpActive], a	; Stop Top Spin's attack (will enable the player's sprite)
	ld   [wShot0], a		; Despawn the weapon shot, which is what deals damage
	ret
	
; =============== Pl_DoConveyor ===============
; Handles automatic movement if standing on a conveyor belt.
Pl_DoConveyor:
	; Ignore if standing on an actor platform
	ld   a, [wActPlatColiSlotPtr]
	cp   ACTSLOT_NONE
	ret  nz
	
	;
	; If either of the player's left or right ground sensors point to a
	; conveyor belt block, update the movement speed accordingly.
	;
	; Updating the current speed makes it account for instances where the
	; player's speed isn't 0 (ie: moving or sliding), however keep in mind
	; that, when idle, the player's speed is reset.
	;
	
.chkL:
	; Check the left sensor
	ld   a, [wPlRelY]		; YPos = PlY + 1 (ground)
	inc  a
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]		; XPos = PlX - 6 (left)
	sub  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; A = Block ID
	ld   bc, $0080			; BC = 0.5px/frame
	cp   BLOCKID_CONVEDGE_R	; BlockID < First conveyor block?
	jr   c, .chkR			; If so, skip to checking the right sensor
	jp   z, Pl_IncSpeedX		; BlockID == Right arrow? If so, move right
	cp   BLOCKID_CONVEDGE_L	; BlockID == Left arrow?
	jp   z, Pl_DecSpeedX		; If so, move left
	cp   BLOCKID_CONVMID_R	; BlockID == Right conveyor?
	jp   z, Pl_IncSpeedX		; If so, move right
	cp   BLOCKID_CONVMID_L	; BlockID == Left conveyor?
	jp   z, Pl_DecSpeedX		; If so, move left
.chkR:
	; Check the right sensor, with identical logic otherwise
	ld   a, [wPlRelX]		; XPos = PlX + 6 (right)
	add  $06
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; ...
	ld   bc, $0080
	cp   BLOCKID_CONVEDGE_R
	jr   c, .ret
	jp   z, Pl_IncSpeedX
	cp   BLOCKID_CONVEDGE_L
	jp   z, Pl_DecSpeedX
	cp   BLOCKID_CONVMID_R
	jp   z, Pl_IncSpeedX
	cp   BLOCKID_CONVMID_L
	jp   z, Pl_DecSpeedX
.ret:
	ret
	
; =============== Pl_IsOnGround ===============
; Checks if the player is on solid ground.
; OUT
; - wColiGround: Collision flags
;                ------LR
;                L - If set, the left block is not solid
;                R - If set, the right block is not solid
;                If any of them is set, the player is on solid ground.
Pl_IsOnGround:

	; If the player is standing on an actor platform, that counts as solid ground
	ld   a, [wActPlatColiSlotPtr]
	cp   ACTSLOT_NONE			; wActPlatColiSlotPtr == ACTSLOT_NONE?
	jr   z, .calcFlags			; If so, jump
	xor  a						; Set both blocks as solid
	ld   [wColiGround], a
	ret
.calcFlags:
	ld   a, [wPlRelY]			; YPos = PlY + 1 (ground)
	inc  a
	ld   [wTargetRelY], a
	
	; Check bottom-left block
	ld   a, [wPlRelX]			; XPos = PlX - 6 (left border)
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; A = Block ID
	cp   BLOCKID_TOPSOLID_START	; C Flag = Is empty? (A < BLOCKID_TOPSOLID_START)
	ld   hl, wColiGround
	rl   [hl]					; << in result
	
	; Check bottom-right block
	ld   a, [wPlRelX]			; XPos = PlX + 6 (right border)
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId			; A = Block ID
	cp   BLOCKID_TOPSOLID_START	; C Flag = Is empty? (A < BLOCKID_TOPSOLID_START)
	ld   hl, wColiGround
	rl   [hl]					; << in result
	ret
	
; =============== Pl_IsInTopSolidBlock ===============
; Checks if the player is inside a top-solid block.
; The ladder top block is the only one like this.
; OUT
; - Z Flag: If set, the player is inside one
Pl_IsInTopSolidBlock:

	; [BUG] This subroutine is exclusively used by code handling bottom/ground collision
	;       to let the player fall through the non-top part of top-solid platforms
	;       by performing the check before the standard collision one is done, where
	;       top-solid blocks are treated as fully solid.
	;
	;       To count as being inside a top-solid block, the game checks if *both*
	;       the left and right sensors point to one, giving 4px of leeway to pass the checks.
	;       This logic is not adequate enough to cover all cases.
	;       While this is enough if one of the sensors points to a solid block, it is not
	;       when the other is empty, leading to solid ground being detected where there isn't
	;       any, making the player visibly warp to the bottom of the block.

	
	; Check if the block to the left of the player, at origin level, is a ladder top block.
	; If it isn't, return early
	ld   a, [wPlRelY]		; YPos = PlY (body)
	ld   [wTargetRelY], a
	ld   a, [wPlRelX]		; XPos = PlX - 6 (left border)
	sub  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; A = Block ID
	cp   BLOCKID_LADDERTOP	; Is it a ladder top block?
	ret  nz					; If not, return (Z Flag = Clear)
	
	; Do the same but to the right of the player
	ld   a, [wPlRelX]		; XPos = PlX + 6 (right border)
	add  PLCOLI_H
	ld   [wTargetRelX], a
	call Lvl_GetBlockId		; A = Block ID
	cp   BLOCKID_LADDERTOP	; Is it a ladder top block?
	ret						; Z Flag = Yes
	
