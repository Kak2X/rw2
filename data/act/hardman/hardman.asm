; =============== Act_HardMan ===============
; ID: ACT_HARDMAN
; First of the eight normal bosses.
Act_HardMan:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_BossIntro
	dw Act_HardMan_InitPunchAnim
	dw Act_HardMan_PlayPunchAnim
	dw Act_HardMan_ThrowFist
	dw Act_HardMan_ThrowFist
	dw Act_HardMan_InitJump
	dw Act_HardMan_JumpU
	dw Act_HardMan_JumpD
	dw Act_HardMan_InitDropAnim
	dw Act_HardMan_PlayDropAnim
	dw Act_HardMan_Drop
	dw Act_HardMan_Shake
	dw Act_HardMan_InitRise
	dw Act_HardMan_RiseU
	dw Act_HardMan_RiseD
	dw Act_HardMan_Cooldown
	DEF ACTRTN_HARDMAN_INTRO = $00
	DEF ACTRTN_HARDMAN_INITDROPANIM = $08
	DEF ACTRTN_HARDMAN_SHAKE = $0B

; =============== Act_HardMan_InitPunchAnim ===============
; Set up fist throwing animation.
Act_HardMan_InitPunchAnim:
	; Already done by ActS_InitAnimRange
	ld   a, $00
	ldh  [hActCur+iActTimer], a
	
	; Throw the first towards the player
	call ActS_FacePl
	
	; Use sprites $00-$03 at 1/12 speed
	ld   de, ($00 << 8)|$03
	ld   c, $0C
	call ActS_InitAnimRange
	
	jp   ActS_IncRtnId
	
; =============== Act_HardMan_PlayPunchAnim ===============
; Plays the first throwing animation.
Act_HardMan_PlayPunchAnim:
	; Wait for it to finish first
	call ActS_PlayAnimRange			; Is it over?
	ret  z							; If not, return
	
	ld   a, $00						; Reset anim timer
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_HardMan_ThrowFist ===============
; Throws a fist.
; Executed twice in a row to throw two of them.
Act_HardMan_ThrowFist:
	; Always throw them towards the player, even if they try to pass through.
	call ActS_FacePl
	
	ldh  a, [hActCur+iActTimer]	; Timer++
	add  $01
	ldh  [hActCur+iActTimer], a
	
	;
	; Handle the timing sequence.
	;
	
.chkSpr3a:
	; $00-$0B: Continue using launching sprite $03
	cp   $0C					; Timer >= $0C?		
	jr   nc, .chkSpawn0			; If so, jump
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkSpawn0:
	; $18: Spawn first fist, while still using launching sprite $03
	cp   $18					; Timer == $18?
	jr   nz, .chkSpr3b			; If not, jump
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	
	ld   a, ACT_HARDKNUCKLE
	ld   bc, ($00 << 8)|LOW(-$09) ; 9px up
	call ActS_SpawnRel
	ret
	
.chkSpr3b:
	; $0C-$17: Continue using launching sprite $03
	;          This isn't any different than .chkSpr3.
	cp   $18					; Timer >= $18?
	jr   nc, .chkSpr5			; If so, jump
	ld   a, $03
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkSpr5:
	; $19-23: Use recoil sprite $05
	cp   $24
	jr   nc, .chkSpr4
	ld   a, $05
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkSpr4:
	; $24-2F: Use post recoil sprite $04
	cp   $30
	jr   nc, .chkEnd
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	ret
	
.chkEnd:
	; $30: Use front facing sprite $04
	ld   a, $04
	ld   [wActCurSprMapBaseId], a
	ld   a, $00						; Reset for next mode
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId				; Next mode
	
; =============== Act_HardMan_InitJump ===============
; Sets up an high jump directly at the player.
Act_HardMan_InitJump:
	; Delay it by half a second
	ldh  a, [hActCur+iActTimer]
	add  $01
	ldh  [hActCur+iActTimer], a
	cp   30
	ret  nz
	
	call ActS_FacePl			; Jump towards the player
	
	; X Speed: Act_HardMan_JumpXTbl[DiffX / 8]
	; Precomputed based on how far the player is, in 16px ranges.
	call ActS_GetPlDistanceX	; Get X distance
	swap a						; /16, to Group by column
	and  $0F					; ""
	add  a						; Each table entry is 2 bytes long
	ld   hl, Act_HardMan_JumpXTbl
	ld   b, $00
	ld   c, a
	add  hl, bc					; Index it
	ld   c, [hl]				; Read out to BC
	inc  hl
	ld   b, [hl]
	call ActS_SetSpeedX
	
	; Y Speed: 4.25px/frame
	ld   bc, $0440
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_HardMan_JumpU ===============
; Jump, pre-peak.
; This continues until either we reach the peak, or the player gets near.
Act_HardMan_JumpU:
	; Use jumping sprite
	ld   a, $06
	ld   [wActCurSprMapBaseId], a
	
	; If the player is within 4px away, interrupt the jump and start dropping down
	call ActS_GetPlDistanceX
	cp   $04
	jr   nc, .move
	ld   a, ACTRTN_HARDMAN_INITDROPANIM
	ldh  [hActCur+iActRtnId], a
	ret
.move:
	; Move forward, turning around if there's a solid wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Move up until we reach the peak of the jump
	call ActS_ApplySpeedUpYColi
	ret  c
	jp   ActS_IncRtnId ; Fall down then
	
; =============== Act_HardMan_JumpD ===============
; Jump, post-peak.
Act_HardMan_JumpD:
	; Use jumping sprite
	ld   a, $06
	ld   [wActCurSprMapBaseId], a
	
	; If the player is within 4px away, interrupt the jump and start dropping down
	call ActS_GetPlDistanceX
	cp   $04
	jr   nc, .move
	ld   a, ACTRTN_HARDMAN_INITDROPANIM
	ldh  [hActCur+iActRtnId], a
	ret
.move:
	; Move forward, turning around if there's a solid wall
	call ActS_ApplySpeedFwdXColi
	call nc, ActS_FlipH
	; Move down until we reach the touch the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; If we got all the way here, Hard Man failed to find the player.
	
	ld   a, 60					; Shake for a second
	ldh  [hActCur+iActTimer], a
	ld   a, PL_MODE_FROZEN		; Freeze the player while it happens
	ld   [wPlMode], a
	ldh  a, [hScrollY]			; Backup untouched coord
	ld   [wHardYShakeOrg], a
	ld   a, ACTRTN_HARDMAN_SHAKE
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_HardMan_InitDropAnim ===============
; Sets up the dropping animation, when the player is below.
Act_HardMan_InitDropAnim:
	; Use sprites $07-$09 at 1/12 speed
	ld   de, ($07 << 8)|$09
	ld   c, $0C
	call ActS_InitAnimRange
	jp   ActS_IncRtnId
	
; =============== Act_HardMan_PlayDropAnim ===============
; Play the dropping animation, during this time Hard Man will stay frozen in the air, to give time to the player.
Act_HardMan_PlayDropAnim:
	call ActS_PlayAnimRange
	ret  z
	jp   ActS_IncRtnId
	
; =============== Act_HardMan_Drop ===============
; Drops to the ground.
Act_HardMan_Drop:
	; Use sprite $09 from before
	ld   a, $09
	ld   [wActCurSprMapBaseId], a
	
	; Drop down until we touch the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	; When we do, freeze the player identically to Act_HardMan_JumpD 
	ld   a, 60					; Shake for a second
	ldh  [hActCur+iActTimer], a
	ld   a, PL_MODE_FROZEN		; Freeze the player while it happens
	ld   [wPlMode], a
	ldh  a, [hScrollY]			; Backup untouched coord
	ld   [wHardYShakeOrg], a
	ld   a, ACTRTN_HARDMAN_SHAKE
	ldh  [hActCur+iActRtnId], a
	; Fall-through!
	
; =============== Act_HardMan_Shake ===============
; Shakes the screen while the player is frozen.
Act_HardMan_Shake:
	; Use sprite $0A, which is halfway into the ground.
	ld   a, $0A
	ld   [wActCurSprMapBaseId], a
	
	; Shake the screen vertically for that second
	call Act_HardMan_SetShake
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; After it's done, restore the original scroll value
	ld   a, [wHardYShakeOrg]
	ldh  [hScrollY], a
	jp   ActS_IncRtnId
	
; =============== Act_HardMan_InitRise ===============
; Set up the small jump for exiting out of the ground (just visually).
Act_HardMan_InitRise:
	ld   a, $09				; Use rise up sprite $09
	ld   [wActCurSprMapBaseId], a
	
	ld   bc, $0200			; 2px/frame up
	call ActS_SetSpeedY
	jp   ActS_IncRtnId
	
; =============== Act_HardMan_RiseU ===============
; Rise jump, pre-peak.
Act_HardMan_RiseU:
	ld   a, $09				; Continue using rise up sprite $09
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity until we reach the peak of the jump
	call ActS_ApplySpeedUpYColi
	ret  c
	
	jp   ActS_IncRtnId
	
; =============== Act_HardMan_RiseD ===============
; Rise jump, post-peak.
Act_HardMan_RiseD:
	ld   a, $08				; Use rise down sprite $08
	ld   [wActCurSprMapBaseId], a
	
	; Apply gravity until we touch the ground
	call ActS_ApplySpeedDownYColi
	ret  c
	
	xor  a ; PL_MODE_GROUND		; Unfreeze the player
	ld   [wPlMode], a
	ld   a, $06					; Wait for 6 frames before looping
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_HardMan_Cooldown ===============
; Pre-loop cooldown.
Act_HardMan_Cooldown:
	; Wait 6 frames of cooldown using sprite $07
	ld   a, $07
	ld   [wActCurSprMapBaseId], a
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Then loop the pattern from the beginning.
	; [BUG] This is a common bug among all normal boss actors.
	;       When they need to loop the pattern, they improperly reset the routine to $00 rather than $01.
	;       That's a problem, because said routine is not supposed to be executed again in the middle of a boss fight,
	;       so when it ends up attempting to unlock the player's controls by the player state to PL_MODE_GROUND, leading
	;       to a oddities such as slides ending early or the jump getting cut off.
	ld   a, ACTRTN_HARDMAN_INTRO
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_HardMan_SetShake ===============
; Updates the screen shake effect.
Act_HardMan_SetShake:
	; B = hTimer % 4 - 1
	; Will shift the screen, in a loop, from -1 to +2.
	ldh  a, [hTimer]
	and  $03
	add  -1
	ld   b, a
	; hScrollY = wHardYShakeOrg + B
	ld   a, [wHardYShakeOrg]
	add  b
	ldh  [hScrollY], a
	ret
	
; =============== Act_HardMan_JumpXTbl ===============
; Horizontal speed for the jumps, depending on how far the player is.
; These account for the vertical jump speed being 4.25px/frame.
Act_HardMan_JumpXTbl:
	;  X SPD ; px/frame ; PL DISTANCE
	dw $0040 ; 0.25     ; $00-$0F 
	dw $0040 ; 0.25     ; $10-$1F 
	dw $0080 ; 0.5      ; $20-$2F 
	dw $00C0 ; 0.75     ; $30-$3F 
	dw $0100 ; 1        ; $40-$4F 
	dw $0140 ; 1.25     ; $50-$5F 
	dw $0180 ; 1.5      ; $60-$6F ;X
	dw $01C0 ; 1.75     ; $70-$7F ;X
	dw $0200 ; 2        ; $80-$8F ;X
	dw $0240 ; 2.25     ; $90-$9F ;X
	dw $0280 ; 2.5      ; $A0-$AF ;X
	dw $02C0 ; 2.75     ; $B0-$BF ;X
	dw $0300 ; 3        ; $C0-$CF ;X
	dw $0340 ; 3.25     ; $D0-$DF ;X
	dw $0380 ; 3.5      ; $E0-$EF ;X
	dw $03C0 ; 3.75     ; $F0-$FF ;X

