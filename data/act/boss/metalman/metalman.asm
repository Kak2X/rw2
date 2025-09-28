; =============== Act_MetalMan ===============
; ID: ACT_METALMAN
; See also: Act_CrashMan
Act_MetalMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_MetalMan_InitWalk
	dw Act_MetalMan_Walk
	dw Act_MetalMan_AtkJumpU
	dw Act_MetalMan_AtkJumpSpawnD
	dw Act_MetalMan_AtkJumpD
	dw Act_MetalMan_Unused_AtkJumpEndD
	dw Act_MetalMan_Unused_AtkJumpCooldown
	dw Act_MetalMan_Unused_08
	dw Act_MetalMan_InitJumpFwd
	dw Act_MetalMan_JumpFwdU
	dw Act_MetalMan_JumpFwdD
	DEF ACTRTN_METALMAN_WALK = $02
	DEF ACTRTN_METALMAN_ATKJUMPSPAWND = $04
	DEF ACTRTN_METALMAN_INITJUMPFWD = $09

; =============== Act_MetalMan_InitWalk ===============
; Sets up walking in place.
Act_MetalMan_InitWalk:
	xor  a							; Reset walk cycle
	ldh  [hActCur+iMetalManWalkTimer], a
	;--
	ld   a, $10						; Not used
	ldh  [hActCur+iActTimer], a
	;--
	jp   ActS_IncRtnId
	
; =============== Act_MetalMan_Walk ===============
; Walking in place on the ground.
Act_MetalMan_Walk:
	;
	; Animate walk cycle.
	; Use sprites $03-$06 at 1/8 speed.
	;
	ld   hl, hActCur+iMetalManWalkTimer
	ld   a, [hl]		; Get current walk timer
	inc  [hl]			; WalkTimer++
	rrca ; /2
	rrca ; /4
	rrca ; /8			; Advance anim every 8 frames
	and  $03			; 4 sprite cycle
	add  $03			; Starting at $03
	ld   [wActCurSprMapBaseId], a
	
	;
	; If the player gets within 2 blocks, jump forward, the other way.
	;
	call ActS_GetPlDistanceX
	cp   BLOCK_H*2							; DiffX < $20?
	jp   c, Act_MetalMan_SwitchToJumpFwd	; If so, jump
	
	;
	; If the player is shooting, retaliate.
	;
	ld   a, [wShot0]
	add  a				; wShotId < $80?
	ret  nc				; If so, return
	
	; Jump straight up, preparing to shoot three Metal Blades
	ld   bc, $0400		; 4px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_MetalMan_AtkJumpU ===============
; Metal Blade attack - Jump, pre-peak.
Act_MetalMan_AtkJumpU:
	; Use jumping sprite
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity while moving up, until we reach the peak
	call ActS_ApplySpeedUpYColi
	ret  c
	
	; Wait 4 frames before throwing one
	ld   a, $04
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_MetalMan_AtkJumpSpawnD ===============
; Metal Blade attack - Jump, post-peak, throw Metal Blade.
;
; This and the next mode are looped in sequence, attempting to throw as many
; Metal Blades as possible until we land on the ground.
; Due to the fixed jump height, we always end up throwing 3 of them.
Act_MetalMan_AtkJumpSpawnD:
	; Use jumping down sprite
	ld   a, $08
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity while moving down, until we touch the ground.
	; When that happens, the attack is over.
	call ActS_ApplySpeedDownYColi
	jp   nc, Act_MetalMan_SwitchToWalk
	
	; Wait those 4 frames before spawning a Metal Blade
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	ld   a, ACT_METALBLADE
	ld   bc, $0000
	call ActS_SpawnRel
	
	; Display throw sprite for 8 frames, while still falling down
	ld   a, $08
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_MetalMan_AtkJumpD ===============
; Metal Blade attack - Jump, post-peak, after throw cooldown.
Act_MetalMan_AtkJumpD:
	; Use jumping/throw sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity while moving down, until we touch tne ground
	call ActS_ApplySpeedDownYColi
	jp   nc, Act_MetalMan_SwitchToWalk
	
	; Wait those 8 frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Throw another Metal Blade after 16 frames
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	ld   a, ACTRTN_METALMAN_ATKJUMPSPAWND
	ldh  [hActCur+iActRtnId], a		; Back to previous routine
	ret
	
; =============== Act_MetalMan_Unused_* ===============
; [TCRF] Unused routines. All begin with a "ret" blocking their execution.
;        They appear to be incomplete code that would have made the attack more accurate to the NES counterpart.
;        This is similar to code found in Needle Man though, it might have been adapted from there.

; =============== Act_MetalMan_Unused_AtkJumpEndD ===============
; Metal Blade attack - Jump, post-peak. Don't throw more Metal Blades.
; It might have been used were the number of spawned Metal Blades capped.
Act_MetalMan_Unused_AtkJumpEndD:
	ret

	; Apply gravity while moving down, until we touch tne ground.
	call ActS_ApplySpeedDownYColi
	ret  c
	; Then return walking.
	ld   a, ACTRTN_METALMAN_WALK
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_MetalMan_Unused_InitAtkJumpCooldown ===============
; Metal Blsde attack - Set up cooldown after shooting.
; This is noticeably not done here, unlike the NES game.
Act_MetalMan_Unused_InitAtkJumpCooldown:
	; Cooldown of 16 frames, presumably after spawning the Metal Blade
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_MetalMan_Unused_AtkJumpCooldown ===============
; Waits 16 frames
Act_MetalMan_Unused_AtkJumpCooldown:
	ret  ; Ret'd out  
	
	; Use jumping sprite
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	
	; Wait those 10 frames.
	; While this happens, gravity is not processed, making Metal Man freeze in the air.
	ldh  a, [hActCur+iActTimer]
	sub  a, $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; And then...
	jp   ActS_IncRtnId
	
; =============== Act_MetalMan_Unused_08 ===============
Act_MetalMan_Unused_08:
	; Nothing!
	ret  

; =============== Act_MetalMan_InitJumpFwd ===============
; Sets up the jump to the other side.
Act_MetalMan_InitJumpFwd:
	; [POI] Since there's enough space, it is possible to trick Metal Man into jumping the wrong side.
	call ActS_FacePl		; Jump towards the player.
	ld   bc, $0180			; 1.5px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0380			; 3.5px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_MetalMan_JumpFwdU ===============
; Jump to other side, pre-peak.
Act_MetalMan_JumpFwdU:
	; Use jumping sprite
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	
	; [BUG] This isn't checking for solid collision, which would have been fine hadn't it been possible to
	;       trick Metal Man into jumping into the wall.
	call ActS_ApplySpeedFwdX
	; Apply gravity while moving up, until the peak of the jump
	call ActS_ApplySpeedUpYColi
	ret  c
	
	jp   ActS_IncRtnId
	
; =============== Act_MetalMan_JumpFwdD ===============
; Jump to other side, post-peak.
Act_MetalMan_JumpFwdD:
	; Use jumping sprite
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	; [BUG] See above. 
	call ActS_ApplySpeedFwdX
	; Apply gravity while moving down, until the peak of the jump
	call ActS_ApplySpeedDownYColi
	ret  c
	; Face the player as soon as we land
	call ActS_FacePl
	
	; Could have been omitted, to fall through Act_MetalMan_SwitchToWalk
	ld   a, ACTRTN_METALMAN_WALK
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_MetalMan_SwitchToWalk ===============
Act_MetalMan_SwitchToWalk:
	ld   a, ACTRTN_METALMAN_WALK
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_MetalMan_SwitchToJumpFwd ===============
Act_MetalMan_SwitchToJumpFwd:
	ld   a, ACTRTN_METALMAN_INITJUMPFWD
	ldh  [hActCur+iActRtnId], a
	ret
	
