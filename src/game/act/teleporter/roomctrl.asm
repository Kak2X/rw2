; =============== Act_TeleporterRoom ===============
; ID: ACT_TELEPORTCTRL
; This actor controls all four teleporters inside Wily's Castle.
Act_TeleporterRoom:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_TeleporterRoom_SpawnLights
	dw Act_TeleporterRoom_WaitPl

; =============== Act_TeleporterRoom_SpawnLights ===============
; Spawns flashing lights above active teleporters.
; These lights are purely a visual effect, teleporting is done by this actor.
Act_TeleporterRoom_SpawnLights:

	ld   b, $00								; B = Coords ID (top-left)
	ld   a, [wWpnUnlock0]
	and  WPU_HA								; Cleared Hard Man's stage?
	call z, Act_TeleporterRoom_SpawnLight	; If not, flash a light there
	
	ld   b, $01								; B = Top-right
	ld   a, [wWpnUnlock0]
	and  WPU_TP								; Cleared Top Man's stage?
	call z, Act_TeleporterRoom_SpawnLight	; ...
	
	ld   b, $02								; B = Bottom-left
	ld   a, [wWpnUnlock0]
	and  WPU_MG								; Cleared Magnet Man's stage?
	call z, Act_TeleporterRoom_SpawnLight	; ...
	
	ld   b, $03								; B = Bottom-right
	ld   a, [wWpnUnlock0]
	and  WPU_NE								; Cleared Needle Man's stage?
	call z, Act_TeleporterRoom_SpawnLight	; ...
	
	jp   ActS_IncRtnId
	
; =============== Act_TeleporterRoom_WaitPl ===============
; Waits for the player to enter a teleporter.
Act_TeleporterRoom_WaitPl:
	; If we're already in the middle of teleporting, don't retrigger it again
	ld   a, [wLvlWarpDest]
	or   a
	ret  nz
	
	;
	; Determine if the player is overlapping with any teleporter.
	; The teleporters trigger when precisely on the ground within 24px from the edge of the screen.
	;
	
	ld   a, [wPlRelX]	; B = PlX
	ld   b, a
	ld   a, [wPlRelY]	; C = PlY
	ld   c, a
	
.chkU:
	cp   OBJ_OFFSET_Y+$2F	; PlY == $3F? (standing on 4th block)
	jr   nz, .chkD			; If not, jump
	
.chkUL:
	; TOP-LEFT SECTION / HARD MAN (Y Pos: $3F, X Pos: < $20)
	ld   a, b
	cp   OBJ_OFFSET_X+$18	; PlX >= $20?
	jr   nc, .chkUR			; If so, check the right one
	
	ld   a, [wWpnUnlock0]
	and  WPU_HA				; Hard Man stage cleared?
	ret  nz					; If so, return
	
	ld   a, LVLEND_TLPHARD	; Otherwise, teleport there
	ld   [wLvlWarpDest], a
	ld   a, PL_MODE_TLPINIT
	ld   [wPlMode], a
	ret
	
.chkUR:
	; TOP-RIGHT SECTION / TOP MAN (Y Pos: $3F, X Pos: >= $90)
	ld   a, b
	cp   OBJ_OFFSET_X+SCREEN_GAME_H-$18	; PlX < $90?
	ret  c								; If so, return
	
	ld   a, [wWpnUnlock0]
	and  WPU_TP				; Top Man stage cleared?
	ret  nz					; If so, return
	ld   a, LVLEND_TLPTOP
	ld   [wLvlWarpDest], a
	ld   a, PL_MODE_TLPINIT
	ld   [wPlMode], a
	ret
	
.chkD:
	ld   a, c
	cp   OBJ_OFFSET_Y+$6F	; PlY == $7F? (standing on 8th block)
	ret  nz					; If not, return (no teleporter touched)
	
.chkDL:
	; BOTTOM-LEFT SECTION / MAGNET MAN (Y Pos: $7F, X Pos: < $20)
	ld   a, b
	cp   OBJ_OFFSET_X+$18	; PlX >= $20?
	jr   nc, .chkDR			; If so, check the right one
	
	ld   a, [wWpnUnlock0]
	and  WPU_MG				; Magnet Man stage cleared?
	ret  nz					; If so, return
	
	ld   a, LVLEND_TLPMAGNET	; Otherwise, teleport there
	ld   [wLvlWarpDest], a
	ld   a, PL_MODE_TLPINIT
	ld   [wPlMode], a
	ret
	
.chkDR:
	; BOTTOM-RIGHT SECTION / NEEDLE MAN (Y Pos: $7F, X Pos: >= $90)
	ld   a, b
	cp   OBJ_OFFSET_X+SCREEN_GAME_H-$18	; PlX < $90?
	ret  c								; If so, return
	
	ld   a, [wWpnUnlock0]
	and  WPU_NE				; Needle Man stage cleared?
	ret  nz					; If so, return
	ld   a, LVLEND_TLPNEEDLE
	ld   [wLvlWarpDest], a
	ld   a, PL_MODE_TLPINIT
	ld   [wPlMode], a
	ret

; =============== Act_TeleporterRoom_SpawnLight ===============
; Spawns a light, marking an active teleporter.
; IN
; - B: Light ID, determines position
Act_TeleporterRoom_SpawnLight:

	; HL = Act_TeleporterRoom_LightPosTbl[B*2]
	ld   a, b
	add  a
	ld   hl, Act_TeleporterRoom_LightPosTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	; Read out the coordinates from there
	ldi  a, [hl]
	ld   [wActSpawnX], a
	ld   a, [hl]
	ld   [wActSpawnY], a
	
	; Not part of the actor layout
	xor  a
	ld   [wActSpawnLayoutPtr], a
	
	ld   a, ACT_TELEPORTLIGHT
	ld   [wActSpawnId], a
	jp   ActS_Spawn
	
; =============== Act_TeleporterRoom_LightPosTbl ===============
; Coordinates for the lights, by teleporter number.
Act_TeleporterRoom_LightPosTbl:
	;                 X                 Y
	db OBJ_OFFSET_X+$14, OBJ_OFFSET_Y+$08 ; $00 (top-left, Hard)
	db OBJ_OFFSET_X+$84, OBJ_OFFSET_Y+$08 ; $01 (top-right, Top)
	db OBJ_OFFSET_X+$14, OBJ_OFFSET_Y+$48 ; $02 (bottom-left, Magnet)
	db OBJ_OFFSET_X+$84, OBJ_OFFSET_Y+$48 ; $03 (bottom-right, Needle)

