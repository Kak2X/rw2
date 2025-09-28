; =============== Act_Cannon ===============
; ID: ACT_CANNON
; A cannon firing balls in an arc.
Act_Cannon:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Cannon_Init
	dw Act_Cannon_PlFar
	dw Act_Cannon_Unshield
	dw Act_Cannon_Shoot
	dw Act_Cannon_Shield
	dw Act_Cannon_Cooldown
	DEF ACTRTN_CANNON_PLFAR = $01
	
; =============== Act_Cannon_Init ===============
Act_Cannon_Init:
	; Horizontally center between two blocks
	ldh  a, [hActCur+iActX]
	add  $08
	ldh  [hActCur+iActX], a
	jp   ActS_IncRtnId
	
; =============== Act_Cannon_PlFar ===============
Act_Cannon_PlFar:
	call ActS_FacePl
	
	; Activate when the player gets within four and half blocks
	call ActS_GetPlDistanceX
	cp   $48
	ret  nc
	
	; Set up the unshield animation.
	; Use sprites $00-$03, showing each for 12 frames (1/12 speed)
	ld   de, ($00 << 8)|$03
	ld   c, $0C
	call ActS_InitAnimRange
	
	; [POI] The cannon isn't set to be immediately vulnerable during the animation, which is both
	;       misleading and also inconsistent with what the shielding anim does.
	
	jp   ActS_IncRtnId
	
; =============== Act_Cannon_Unshield ===============
Act_Cannon_Unshield:
	call ActS_FacePl
	
	; Wait until the unshield animation is done (24 frames)
	call ActS_PlayAnimRange
	ret  z
	
	; Use frame $03, for the exposed cannon
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	; The exposed cannon is vulnerable
	ld   b, ACTCOLI_ENEMYHIT
	call ActS_SetColiType
	
	ld   a, $00
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Cannon_Shoot ===============
; Handles the shooting sequence.
; The cannon shoots twice during the course of 80 frames, after which it shields itself again.
Act_Cannon_Shoot:
	call ActS_FacePl
	
	; Tick on the animation timer, then check where we are in the animation.
	; The animation itself manually alternates between the two shooting sprites $03 and $02,
	; the latter being for the slightly retracted cannon ready to shoot.
	ldh  a, [hActCur+iActTimer]
	add  $01
	ldh  [hActCur+iActTimer], a
	
	;
	; $00-$1D -> Sprite $03
	;
	cp   $1E			; Timer >= $1E?
	jr   nc, .chkSh0	; If so, jump
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkSh0:
	;
	; $1E-$27 -> Sprite $02
	;     $28 -> Shoot a ball
	;
	cp   $28
	push af
		call z, Act_Cannon_SpawnShot
	pop  af
	jr   nc, .chkWait0
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkWait0:
	;
	; $28-$45 -> Sprite $03
	;
	cp   $46
	jr   nc, .chkSh1
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ret
.chkSh1:
	;
	; $46-$49 -> Sprite $02
	;     $50 -> Shoot a ball
	;
	cp   $50
	push af
		call z, Act_Cannon_SpawnShot
	pop  af
	jr   nc, .nextMode
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	ret
.nextMode:
	;
	; $50 -> Sprite $02, start shield anim
	;
	ld   a, $02
	ld   [wActCurSprMapBaseId], a
	
	; Set up the shield animation.
	; Use sprites $03-$06, at 1/12 speed
	ld   de, ($03 << 8)|$06
	ld   c, $0C
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_Cannon_Shield ===============
Act_Cannon_Shield:
	call ActS_FacePl
	; Wait until the shield animation is done (24 frames)
	call ActS_PlayAnimRange
	ret  z
	
	; Make invulnerable after it's over
	ld   a, $00
	call ActS_SetSprMapId
	
	ld   b, ACTCOLI_ENEMYREFLECT
	call ActS_SetColiType
	
	; Cooldown of 1 second before checking the player getting near again
	ld   a, 60
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Cannon_Cooldown ===============
Act_Cannon_Cooldown:
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	ld   a, ACTRTN_CANNON_PLFAR
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Cannon_SpawnShot ===============
Act_Cannon_SpawnShot:
	; Prepare the call to ActS_SpawnArcShot.
	; The cannonball should be thrown forwards, from the forward part of the cannon,
	; so its position variea depending on which direction it's facing.
	ld   bc, (LOW(-$08) << 8)|LOW(-$04)	; B = 8px left, C = 16px above
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R					; Facing right? (also, A = Same direction as cannon)
	jr   z, .spawnL					; If not, jump
	ld   bc, (LOW($08) << 8)|LOW(-$04)	; B = 8px right, C = 16px above
.spawnL:
	ld   de, ($02 << 8)|ACT_CANNONSHOT ; D = 2px/frame up, E = Actor Id
	jp   ActS_SpawnArcShot
	
