; =============== Act_NeedleMan ===============
; ID: ACT_NEEDLEMAN
Act_NeedleMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_NeedleMan_InitChkAttack
	dw Act_NeedleMan_ChkAttack
	dw Act_NeedleMan_InitHeadExtend
	dw Act_NeedleMan_HeadExtend
	dw Act_NeedleMan_HeadRetract
	dw Act_NeedleMan_InitJump
	dw Act_NeedleMan_InitFwdJump
	dw Act_NeedleMan_JumpU
	dw Act_NeedleMan_JumpD
	dw Act_NeedleMan_InitThrJump
	dw Act_NeedleMan_JumpThrU
	dw Act_NeedleMan_JumpThrD
	dw Act_NeedleMan_ThrSpawn
	dw Act_NeedleMan_ThrCooldown
	DEF ACTRTN_NEEDLEMAN_INITCHKATTACK = $01
	DEF ACTRTN_NEEDLEMAN_INITHEADEXTEND = $03
	DEF ACTRTN_NEEDLEMAN_INITJUMP = $06
	DEF ACTRTN_NEEDLEMAN_INITFWDJUMP = $07
	DEF ACTRTN_NEEDLEMAN_JUMPU = $08
	DEF ACTRTN_NEEDLEMAN_0A = $0A
	DEF ACTRTN_NEEDLEMAN_JUMPTHRD = $0C

; =============== Act_NeedleMan_InitChkAttack ===============
; Sets up the delay before choosing an attack.
Act_NeedleMan_InitChkAttack:
	; Show ground sprite for 6 frames
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $06
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NeedleMan_ChkAttack ===============
; Chosses a random attack.
Act_NeedleMan_ChkAttack:
	; Stay on the ground for those 6 frames, before choosing an attack
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; Randomize the attack.
	; It's a 50/50 whether the boss attacks or jumps, specifically:
	;
	; - 25% Jump straight up
	; - 25% Forward jump
	; - 50% Proximity-based attack
	;   - If the player is within 4 blocks, use the headbutt
	;   - Otherwise, do a full jump straight up and throw needles
	;
	
	; Roll a value between $00 and $03
	call Rand	; A = (Rand() / 16) % 4
	swap a		; / 16
	and  $03	; % 4
	
.chkJump:
	; $00 - Jump straight up (25%)
	jr   nz, .chkFwdJump		; A == 0? If not, jump
	ld   a, ACTRTN_NEEDLEMAN_INITJUMP
	ldh  [hActCur+iActRtnId], a
	ret
.chkFwdJump:
	; $01 - Jump forward (25%)
	dec  a						; A == 1?
	jr   nz, .chkAtk			; If not, jump
	ld   a, ACTRTN_NEEDLEMAN_INITFWDJUMP
	ldh  [hActCur+iActRtnId], a
	ret
	
.chkAtk:
	; $02-$03 - Proximity-based attack ($50%)
	call ActS_GetPlDistanceX
	cp   BLOCK_H*4				; DiffX >= $40?
	jr   nc, .far				; If so, jump
.near:
	; Player is near, use headbutt
	ld   a, ACTRTN_NEEDLEMAN_INITHEADEXTEND
	ldh  [hActCur+iActRtnId], a
	ret
.far:
	; Player is far, jump and throw needles
	ld   a, ACTRTN_NEEDLEMAN_0A
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NeedleMan_InitHeadExtend ===============
; Sets up the headbutt attack, used when the player is nearby.
Act_NeedleMan_InitHeadExtend:
	; Face towards the player
	call ActS_FacePl
	
	; When extending, use sprites $02-$05 at 1/4 speed
	ld   de, ($02 << 8)|$05
	ld   c, $04
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_NeedleMan_HeadExtend ===============
; Headbutt, extend spikes.
Act_NeedleMan_HeadExtend:

	;
	; During the headbutt attack, use the sprite mapping ID as index to the collision box.
	; Note that, as radiuses are symmetrical, the collision box will also extend on the
	; other side... not like it matters since it's not possible to jump over Needle Man
	; without getting hit anyway.
	; 
	; [POI] What does matter however is the index used. While every frame in the animation
	;       has its own horizontal radius defined, most of them go unused since the index
	;       is only ever set to the first sprite of the range (iAnimRangeSprMapFrom).
	;
	;       This causes the needle to not have an hitbox while it's extending.
	;       The code for retracting has the opposite problem, with the extended hitbox lingering around.
	;
	
	; B = Act_NeedleMan_ColiXTbl[iAnimRangeSprMapFrom]
	;     In practice, always $0B
	ldh  a, [hActCur+iAnimRangeSprMapFrom]
	ld   hl, Act_NeedleMan_ColiXTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   b, [hl]			; Read horizntal radius
	ld   c, $0B				; Fixed vertical radius
	call ActS_SetColiBox
	
	; Wait until the animation finishes
	call ActS_PlayAnimRange
	ret  z
	
	; When retracting, use sprites $05-$08 at 1/4 speed
	ld   de, ($05 << 8)|$08
	ld   c, $04
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_NeedleMan_HeadRetract ===============
; Headbutt, retract spikes.
Act_NeedleMan_HeadRetract:

	; Set collision box for first frame
	ldh  a, [hActCur+iAnimRangeSprMapFrom]
	ld   hl, Act_NeedleMan_ColiXTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   b, [hl]
	ld   c, $0B
	call ActS_SetColiBox
	
	; Wait until the animation finishes
	call ActS_PlayAnimRange
	ret  z
	
	; Attack is done, restore the normal collision box
	ld   bc, ($0B << 8)|$0B		; 23x23
	call ActS_SetColiBox
	
	; Roll the dice for the next attack
	ld   a, ACTRTN_NEEDLEMAN_INITCHKATTACK
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NeedleMan_InitJump ===============
; Sets up a jump straight up.
Act_NeedleMan_InitJump:
	ld   bc, $0000			; No horz speed
	call ActS_SetSpeedX
	ld   bc, $0380			; 3.5px/frame up
	call ActS_SetSpeedY
	ld   a, ACTRTN_NEEDLEMAN_JUMPU
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NeedleMan_InitFwdJump ===============
; Sets up a forward jump.
Act_NeedleMan_InitFwdJump:
	ld   bc, $0100			; 1px/frame forward
	call ActS_SetSpeedX
	ld   bc, $0380			; 3.5px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_NeedleMan_JumpU ===============
; Jump, pre-peak.
Act_NeedleMan_JumpU:
	; Use jumping sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	; Apply gravity while moving up, until we reach the peak
	call ActS_MoveBySpeedX_Coli
	call ActS_ApplyGravityU_Coli
	ret  c
	jp   ActS_IncRtnId
	
; =============== Act_NeedleMan_JumpD ===============
; Jump, post-peak.
Act_NeedleMan_JumpD:
	; Use jumping sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	; Apply gravity while moving down, until we reach touch the ground
	call ActS_MoveBySpeedX_Coli
	call ActS_ApplyGravityD_Coli
	ret  c
	; Then check for a new attack
	ld   a, ACTRTN_NEEDLEMAN_INITCHKATTACK
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NeedleMan_InitThrJump ===============
; Needle attack - Set up straight up high jump near the ceiling.
Act_NeedleMan_InitThrJump:
	ld   bc, $0440			; 4.25px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_NeedleMan_JumpThrU ===============
; Needle attack - high jump, pre-peak.
Act_NeedleMan_JumpThrU:
	; Use jumping sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity while moving up, until we reach the peak
	call ActS_ApplyGravityU_Coli
	ret  c
	
	xor  a
	ld   [wNeedleSpawnTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NeedleMan_JumpThrD ===============
; Needle attack - high jump, post-peak.
Act_NeedleMan_JumpThrD:
	; Use jumping sprite
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	
	; Face the player in case he's passing under
	call ActS_FacePl
	
	;--
	;
	; Spawn a needle every 8 frames, over a period of $20 (32) frames.
	; This will end up spawning four equally spaced needles around the start of the descent.
	;
	ld   a, [wNeedleSpawnTimer]
	cp   $20					; Timer >= $20?
	jr   nc, .move				; If so, skip (we already spawned 4 needles)
	inc  a						; Timer++
	ld   [wNeedleSpawnTimer], a
	
	dec  a						; Go back to previous value
	and  $07					; Divisible by 8?
	jr   nz, .move				; If not, skip
	
	jp   ActS_IncRtnId			; Otherwise, spawn it!
	;--
.move:
	; Apply gravity while moving down, until we touch tne ground.
	call ActS_ApplyGravityD_Coli
	ret  c
	ld   a, ACTRTN_NEEDLEMAN_INITCHKATTACK
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NeedleMan_ThrSpawn ===============
; Spawns a needle.
Act_NeedleMan_ThrSpawn:
	ld   a, ACT_NEEDLECANNON
	ld   bc, ($00 << 8)|LOW(-$10)	; 16px up
	call ActS_SpawnRel
	
	; Cooldown of 6 frames after spawning needle
	ld   a, $06
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NeedleMan_ThrCooldown ===============
; Cooldown after spawning a needle.
Act_NeedleMan_ThrCooldown:
	; Wait those 6 frames.
	; While this happens, gravity is not processed, making Needle Man freeze in the air.
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	ld   a, ACTRTN_NEEDLEMAN_JUMPTHRD
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_NeedleMan_ColiXTbl ===============
; Maps each sprite to its collision box horizontal radius.
; Only used during the headbutt attack, so most entries go unused,
; on top of those unused by mistake (see Act_NeedleMan_HeadExtend).
Act_NeedleMan_ColiXTbl:
	db $0B ; $00 ;X
	db $0B ; $01 ;X
	db $0B ; $02 
	db $13 ; $03 ;X
	db $1B ; $04 ;X
	db $23 ; $05 
	db $1B ; $06 ;X
	db $13 ; $07 ;X
	db $0B ; $08 ;X
	db $0B ; $09 ;X

