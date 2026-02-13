; =============== Act_Wily3 ===============
; ID: ACT_WILY3
; 3rd phase of the Wily Machine, visually distinct from the others.
;
; Unlike the others, it is partially drawn with BG tiles, but as they are already part 
; of the level layout, we don't need to draw those ourselves.
;
; This sprite associated to this actor is the skull that extends after attacks,
; hence why it's the only part that flashes when hit; other parts are indepentently
; animated and use their own helper actor.
Act_Wily3:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily3_Nop
	dw Act_WilyIntro
	dw Act_Wily3_Init
	dw Act_Wily3_FireMissile
	dw Act_Wily3_FireMet
	dw Act_Wily3_WaitSkUp
	dw Act_Wily3_WaitSkDown
	DEF ACTRTN_WILY3_FIREMISSILE = $03

; =============== Act_Wily3_Nop ===============
; The Wily Machine doesn't do anything until Act_WilyCtrl_P3ScrollR sets our routine to Act_Wily3_Init.
; This is to make sure it only gets processed once it fully scrolls in.
Act_Wily3_Nop:
	ret
	
; =============== Act_Wily3_Init ===============
; Performs initialization, and sets up the delay for firing the missile.
Act_Wily3_Init:
	; Allow damaging the Wily Machine from the top until 16px above its center point.
	; Make everything below reflect shots.
	ld   b, -$10
	call ActS_SetColiType
	
	; Always face left, as that's the direction the BG tiles show
	ld   hl, hActCur+iActSprMap
	res  ACTDIRB_R, [hl]
	
	; Do not animate parts yet
	xor  a
	ldh  [hActCur+iWily3AnimPart], a
	
	; [POI] Pointless, this actor can't move as it uses BG tiles
	ld   bc, $0080
	call ActS_SetSpeedX
	
	; Wait 16 frames before firing the missile 
	ld   a, $10
	ldh  [hActCur+iActTimer], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Wily3_FireMissile ===============
; Fires an homing missile.
Act_Wily3_FireMissile:
	; Wait for it...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Spawn the homing missile
	ld   a, ACT_WILY3MISSILE
	ld   bc, ($00 << 8)|LOW(-$10) ; 16px up
	call ActS_SpawnRel
	
	; Raise the arm cannon forward
	ld   a, WILY3PART_SPR_ARM
	ldh  [hActCur+iWily3AnimPart], a
	
	; Cooldown of ~2 seconds before firing the Goombas
	ld   a, $80
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily3_FireMet ===============
; Fires multiple Mets.
Act_Wily3_FireMet:
	; Wait those ~2 seconds
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; Spawn four Mets at different jump arcs, which are spaced far enough that by the time
	; they reach the ground, they will have spread out across the room.
	;
	; The player will have to dodge them similarly to the falling leaves from Wood Man's fight,
	; however, unlike those these Mets continue moving horizontally, making dodging them a bit iffy.
	;
	
	ld   a, ACT_WILY3MET
	; Each one spawns at the same coordinates: 1 block right, 2 blocks up
	ld   bc, (LOW($10) << 8)|LOW(-$20)
	call ActS_SpawnRel
	; Their horizontal speed is what differs, which stays the same over time.
	; Meanwhile, their vertical speed is the same between all of them, making 
	; sure the Mets stay vertically aligned, and is also affected by gravity.
	ld   de, iActSpdXSub
	add  hl, de
	ld   [hl], LOW($0020)		; 0.125px/frame forward
	inc  hl
	ld   [hl], HIGH($0020)
	
	ld   a, ACT_WILY3MET
	ld   bc, (LOW($10) << 8)|LOW(-$20)
	call ActS_SpawnRel
	ld   de, iActSpdXSub
	add  hl, de
	ld   [hl], LOW($00E0)		; 0.875px/frame forward
	inc  hl
	ld   [hl], HIGH($00E0)
	
	ld   a, ACT_WILY3MET
	ld   bc, (LOW($10) << 8)|LOW(-$20)
	call ActS_SpawnRel
	ld   de, iActSpdXSub
	add  hl, de
	ld   [hl], LOW($0180)		; 1.5px/frame forward
	inc  hl
	ld   [hl], HIGH($0180)
	
	ld   a, ACT_WILY3MET
	ld   bc, (LOW($10) << 8)|LOW(-$20)
	call ActS_SpawnRel
	ld   de, iActSpdXSub
	add  hl, de
	ld   [hl], LOW($0220)		; 2.125px/frame forward
	inc  hl
	ld   [hl], HIGH($0220)
	
	; Raise the tail up
	ld   a, WILY3PART_SPR_TAIL
	ldh  [hActCur+iWily3AnimPart], a
	
	; Delay ~2 seconds after shooting, to wait for the Mets to have fallen offscreen
	ld   a, $80
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily3_WaitSkUp ===============
; Waits - skull retracted.
Act_Wily3_WaitSkUp:
	; Wait those ~2 seconds...
	; During this time, sprite
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Stay in the next routine for ~half a second
	ld   a, $20
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily3_WaitSkDown ===============
; Waits - skull extended.
Act_Wily3_WaitSkDown:
	; Extend the skull down by using sprite $01.
	; This is only a visual effect, it does nothing at all otherwise.
	ld   a, $01
	ld   [wActCurSprMapBaseId], a
	
	; Show that for ~half a second
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Then fire the homing missile, looping the pattern.
	ld   a, $80						; Delay that by ~2 secs
	ldh  [hActCur+iActTimer], a
	
	ld   a, ACTRTN_WILY3_FIREMISSILE
	ldh  [hActCur+iActRtnId], a		; Loop back. Exiting this routine retracts the skull.
	ret