; =============== Act_AirMan ===============
; ID: ACT_AIRMAN
Act_AirMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_AirMan_Init
	dw Act_AirMan_Idle
	dw Act_AirMan_SpawnShot
	dw Act_AirMan_WaitShotDespawn
	dw Act_AirMan_InitJump0
	dw Act_AirMan_Jump0U
	dw Act_AirMan_Jump0D
	dw Act_AirMan_Jump1U
	dw Act_AirMan_Jump1D
	dw Act_AirMan_Reset
	DEF ACTRTN_AIRMAN_INIT = $01
	DEF ACTRTN_AIRMAN_SPAWNSHOT = $03
	
; =============== Act_AirMan_Init ===============
Act_AirMan_Init:
	; Do three consecutive waves of whirlwind patterns before jumping to the other side
	ld   a, $03
	ldh  [hActCur+iAirManWavesLeft], a
	; Set movement speed for later, when jumping forward
	ld   bc, $0100
	call ActS_SetSpeedX
	; Wait ~1 second idling before spawning the whirlwinds
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_AirMan_Idle ===============
; Idle on the ground.
Act_AirMan_Idle:
	; Animate fan on the ground.
	; Use sprites $03-$04 at 1/4 speed
	ldh  a, [hTimer]
	rrca ; /2
	rrca ; /4 Every 4 frames...
	and  $01 ; Alternate between $00 and $01
	add  $03 ; Offset by $03
	ld   [wActCurSprMapBaseId], a
	
	; Wait that ~1 second before doing anythinh...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; 
	; Randomize the wave pattern
	; There are four patterns, each one having four whirlwinds that have specific "paths",
	; all stored in a single table, so...
	;
	
	; Build base path ID, to the start of a random pattern
	call Rand	; Randomize value
	and  $03	; 4 patterns total (25% chance for any pattern)
	add  a		; 4 shots in a pattern
	add  a		; ""
	ldh  [hActCur+iAirManPatId], a
	
	; Initialize relative path ID, will be decremented every frame.
	; The whirlwind that gets spawned will use the path iAirManPatId + iActTimer - 1.
	ld   a, $04
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_AirMan_SpawnShot ===============
; Spawns the whirlwinds that are part of the picked pattern, 1 at a time in reverse order.
; As a pattern is made up of four whirlwinds, this will take four frames.
Act_AirMan_SpawnShot:
	; Use different frame while spawning
	ld   a, $05
	ld   [wActCurSprMapBaseId], a
	
	;
	; Spawn the whirlwind and set up its properties, most importantly its speed.
	;
	ld   a, ACT_WHIRLWIND
	ld   bc, $0000
	call ActS_SpawnRel
	inc  hl ; iActRtnId
	inc  hl ; iActSprMap
	; Move to the same direction Air Man is facing
	ldh  a, [hActCur+iActSprMap]
	ld   [hl], a
	; Write the path ID, will be used to index Act_AirManShot_PathTbl
	ld   de, iAirManShotPathId-iActSprMap	; Seek HL to iAirManShotPathId
	add  hl, de
	ldh  a, [hActCur+iAirManPatId]			; Read base path ID
	ld   b, a
	ldh  a, [hActCur+iActTimer]			; Read relative path ID
	dec  a									; - 1
	add  b									; Add base to it
	ld   [hl], a							; Save result to iAirManShotPathId
	
	; Do the above 4 times in a row, to quickly spawn all whirlwinds without spiking the CPU
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Then wait for the wind to despawn, polling every 16 frames
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_AirMan_WaitShotDespawn ===============
; Stay on the ground, while blowing until the wind until they all despawn.
Act_AirMan_WaitShotDespawn:

	;
	; Blow the player back immediately after all the whirlwinds spawn.
	; This is *not* what RM2 did. In that game, the player is blown back only when
	; the whirlwinds start moving forward *after* they get into position.
	;
	; This should have waited $80 frames before starting to blow the player back,
	; to be consistent with both RM2 and Act_AirManShot's timing.
	;
	ldh  a, [hActCur+iActSprMap]
	ld   bc, $00C0					; 0.75px/frame
	call Pl_AdjSpeedByActDir
	
	; Animate fan
	; Use sprites $03-$04 at 1/4 speed
	ldh  a, [hTimer]
	rrca ; /2
	rrca ; /4 Every 4 frames...
	and  $01 ; Alternate between $00 and $01
	add  $03 ; Offset by $03
	ld   [wActCurSprMapBaseId], a
	
	; Poll every 16 frames...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Set next check delay
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	
	; Keep waiting if all whirlwinds haven't been offscreened yet
	ld   a, ACT_WHIRLWIND
	call ActS_CountById
	ld   a, b		; Get ACT_WHIRLWIND count
	and  a			; Count != 0?
	ret  nz			; If so, return
	
	; 
	; Randomize another wave pattern, identically to before.
	;
	ld   hl, hActCur+iAirManWavesLeft
	dec  [hl]						; Any waves left?
	jp   z, ActS_IncRtnId			; If not, start jumping forward
	
	; Randomize base path ID
	call Rand
	and  $03
	add  a
	add  a
	ldh  [hActCur+iAirManPatId], a
	; Switch to spawning another wave
	ld   a, ACTRTN_AIRMAN_SPAWNSHOT
	ldh  [hActCur+iActRtnId], a
	; Initialize relative path ID
	ld   a, $04
	ldh  [hActCur+iActTimer], a
	ret
	
; =============== Act_AirMan_InitJump0 ===============
; The remaining modes handle the two consecutive jumps the player should move under.
Act_AirMan_InitJump0:
	ld   bc, $0240			; 2.25px/frame fprward
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_AirMan_Jump0U ===============
; Jump, pre-peak.
Act_AirMan_Jump0U:
	; Use jumping frame
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; Handle gravity moving up until the peak of the jump
	call ActS_MoveBySpeedX_Coli
	call ActS_ApplyGravityU_Coli
	ret  c
	
	jp   ActS_IncRtnId
	
; =============== Act_AirMan_Jump0D ===============
; Jump, post-peak.
Act_AirMan_Jump0D:
	; Use jumping frame
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; Handle gravity moving down until we touch the ground
	call ActS_MoveBySpeedX_Coli
	call ActS_ApplyGravityD_Coli
	ret  c
	; Set up second, higher jump at 3px/frame
	ld   bc, $0300
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_AirMan_Jump1U ===============
; High jump, pre-peak.
Act_AirMan_Jump1U:
	; Use jumping frame
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; Handle gravity moving up until the peak of the jump
	call ActS_MoveBySpeedX_Coli
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_AirMan_Jump1D ===============
; High jump, post-peak.
Act_AirMan_Jump1D:
	; Use jumping frame
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; Handle gravity moving down until we touch the ground
	call ActS_MoveBySpeedX_Coli
	call ActS_ApplyGravityD_Coli
	ret  c
	; Flip horizontally
	ldh  a, [hActCur+iActSprMap]
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	;--
	; Not necessary
	ld   a, $03
	ldh  [hActCur+iAirManWavesLeft], a
	;--
	jp   ActS_IncRtnId
	
; =============== Act_AirMan_Reset ===============
; Loop pattern to the start.
Act_AirMan_Reset:
	ld   a, ACTRTN_AIRMAN_INIT
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_AirManShot_PathTbl ===============
; Defines the initial speed values a whirlwind can follow.
; When it spawns, a shot will move in a straight line using these speed for $40 frames (~1 second),
; effectively defining the "path" it will take.
Act_AirManShot_PathTbl:
	;  X SPD  Y SPD ;  ID
	; PATTERN 1
	dw $00CC, $00CC ; $00
	dw $0088, $0088 ; $01
	dw $00CC, $0044 ; $02
	dw $0110, $0044 ; $03
	; PATTERN 2
	dw $0044, $0000 ; $04
	dw $0110, $00CC ; $05
	dw $00CC, $0088 ; $06
	dw $0110, $0088 ; $07
	; PATTERN 3
	dw $0110, $0000 ; $08
	dw $0110, $00CC ; $09
	dw $0044, $0088 ; $0A
	dw $0088, $00CC ; $0B
	; PATTERN 4
	dw $0110, $0044 ; $0C
	dw $0110, $0088 ; $0D
	dw $0066, $0000 ; $0E
	dw $00CC, $00CC ; $0F

