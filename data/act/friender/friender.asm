; =============== Act_Friender ===============
; ID: ACT_FRIENDER
; Giant dog miniboss in Wood Man's stage.
Act_Friender:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Friender_Init
	dw Act_Friender_PreFire
	dw Act_Friender_Fire
	dw Act_Friender_FireCooldown
	dw Act_Friende_WaitNoAnim
	dw Act_Friender_WaitAnim
	DEF ACTRTN_FRIENDER_PREFIRE = $01
	
; =============== Act_Friender_Init ===============
Act_Friender_Init:
	; Draw the tilemap for the miniboss.
	call Act_BGBoss_ReqDraw
	
	; Wait for 16 frames before firing
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Friender_PreFire ===============
; Waits for a bit before determining the amount of shots to fire.
Act_Friender_PreFire:
	; Return if dead
	call Act_Friender_ChkExplode
	ret  c
	
	; Wait for it...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Use sprite with open mouth, as that's where the flame shot comes from
	ld   a, $02
	call ActS_SetSprMapId
	
	;--
	; [POI] Randomize the amount of indivudual flames spawned.
	;       Would have spawned anywhere between 3 and 6 of them...
	call Rand	; A = Rand() % 4 + 3
	and  $03
	add  $03
	; ...but we're discarding the result for an hardcoded amount!
	; Presumably because higher values run up against the sprite limit.
	ld   a, $04
	ldh  [hActCur+iFrienderShotsLeft], a
	;--
	
	jp   ActS_IncRtnId
	
; =============== Act_Friender_Fire ===============
; Fires a single flame shot.
Act_Friender_Fire:
	call Act_Friender_ChkExplode
	ret  c
	
	ld   a, ACT_FLAME
	ld   bc, (LOW(-$10)<<8)|$00		; 10px left
	call ActS_SpawnRel
	
	; Delay the next shot by 4 frames
	ld   a, $04
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Friender_FireCooldown ===============
; Handles cooldown between shots, determines if there are more to fire.
Act_Friender_FireCooldown:
	call Act_Friender_ChkExplode
	ret  c
	; Cooldown between shots..
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; If there are still shots left, go back to Act_Friender_Fire
	ld   hl, hActCur+iFrienderShotsLeft
	dec  [hl]
	jp   nz, ActS_DecRtnId
	
	; Otherwise, stop shooting for a while.
	
	; Display sprite $00 for 16 frames
	ld   a, $00
	call ActS_SetSprMapId
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Friende_WaitNoAnim ===============
; Idle, no animation.
Act_Friende_WaitNoAnim:
	call Act_Friender_ChkExplode
	ret  c
	
	; Wait for those 16 frames...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Display the leg animation for 32 frames
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Friender_WaitAnim ===============
; Idle, leg animation.
Act_Friender_WaitAnim:
	call Act_Friender_ChkExplode
	ret  c
	
	; Leg animation, use frames $00-$01 at 1/8 speed
	; When that stops (we go back to Act_Friender_PreFire) that's the tell that the enemy is about to fire again.
	ld   c, $01
	call ActS_Anim2
	
	; Wait for those 32 frames...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Return to Act_Friender_PreFire, waiting 16 more frames before shooting
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	ld   a, ACTRTN_FRIENDER_PREFIRE
	ldh  [hActCur+iActRtnId], a
	ret
	
