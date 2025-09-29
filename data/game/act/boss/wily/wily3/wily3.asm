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
	
; =============== Act_WilyShip ===============
; ID: N/A (run inside ACT_WILYCTRL)
;
; Wily's Spaceship, visible between the Wily Machine phases.
;
; This actor is used to animate the top half of the Wily Machine after its body explodes,
; and is then shown flying away and seamlessly attaching itself to the top of the next one.
; 
; To make the illusion work, the spaceship visually matches with the top half of the first
; two phases of the Wily Machine, and is positioned to precisely overlap with that part
; when it attaches or detaches itself -- most noticeable with Wily's sprite, which visually
; doesn't appear to change position, even though actors teleport around.
;
; The exception to this is the 3rd phase, which is why the spaceship doesn't visually attach
; itself there.
;
; This is not used as its own actor, instead it's run under Act_WilyCtrl, which is associated
; to the Wily Spaceship sprites. The main consequence is that it shouldn't interfere with that
; actor's routine, hence why a separate iWilyShipRtnId is being used.
;
; Used at the end of both the 1st and 2nd phases, however the calling code aborts them
; at different points.
Act_WilyShip:
	ldh  a, [hActCur+iWilyShipRtnId]
	rst  $00 ; DynJump
	dw Act_WilyShip_Init
	dw Act_WilyShip_Wait
	dw Act_WilyShip_MoveU
	dw Act_WilyShip_MoveR
	dw Act_WilyShip_MoveScrollR
	dw Act_WilyShip_MoveD
	dw Act_WilyShip_Nop

; =============== Act_WilyShip_Init ===============
; Sets up the various properties.
Act_WilyShip_Init:
	; Set up propeller animation (frames $00-$01 at 1/8 speed)
	ld   a, $00				; Start from $00, regardless of wherever we are
	call ActS_SetSprMapId
	ld   c, $01
	call ActS_Anim2
	
	; Face towards the player
	call ActS_FacePl
	
	; Stand still for ~2 seconds
	ld   a, $80
	ldh  [hActCur+iActTimer], a
	
	; Next mode
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_Wait ===============
; Ship stays still.
Act_WilyShip_Wait:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	; Wait for those ~2 seconds...
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Set up movement speed for later routines
	ld   bc, $0080			; 0.5px/frame horizontally
	call ActS_SetSpeedX
	ld   bc, $0080			; 0.5px/frame vertically
	call ActS_SetSpeedY
	
	; Move up
	ld   hl, hActCur+iActSprMap
	res  ACTDIRB_D, [hl]
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_MoveU ===============
; Move up until reaching the top of the screen.
Act_WilyShip_MoveU:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	; Move up at 0.5px/frame, until we're near the ceiling
	call ActS_MoveBySpeedY		; Move up
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y+$28			; ActY != $38?
	ret  nz							; If not, return
	; Otherwise, start moving right
	ld   hl, hActCur+iActSprMap		
	set  ACTDIRB_R, [hl]
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_MoveR ===============
; Move right, without scrolling the screen.
Act_WilyShip_MoveR:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	; Move the spaceship right at 0.5px/frame until it reaches X position $90,
	; which is barely enough before it starts going offscreen, which we want to avoid.
	ldh  a, [hActCur+iActX]
	cp   SCREEN_GAME_H+OBJ_OFFSET_X-$18		; ActX < $90?
	jp   c, ActS_MoveBySpeedX				; If so, just move
	
	; Prepare downwards movement for later
	ld   hl, hActCur+iActSprMap
	set  ACTDIRB_D, [hl]
	
	; But continue moving while scrolling the screen for ~2 seconds more
	ld   a, $80
	ldh  [hActCur+iActTimer], a
	
	; Switch to the next routine.
	; If we're in the transition between the 2nd and 3rd phases, at this point
	; the caller takes over and makes the ship actually move off-screen,
	; since it's not possible to attach it to the 3rd phase machine without looking wrong.
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_MoveScrollR ===============
; Move right, while scrolling the screen.
; First transition only.
Act_WilyShip_MoveScrollR:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	;
	; Move the screen (and the actor) right 0.5px/frame.
	;
	
	; First, apply the subpixel speed as normal
	ld   hl, hActCur+iActXSub		; HL = Ptr to subpixel X
	ldh  a, [hActCur+iActSpdXSub]	; A = Subpixel speed
	add  [hl]						; Move right by that
	ld   [hl], a					; Save back
	
	; If that overflowed, instead of incrementing iActX directly, scroll the screen 1px to the right.
	; The way this works assumes movement < 1px/frame, since it should not alter iActX.
	call c, Act_WilyShip_ScrollR
	
	; Do the above for ~2 seconds
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; After that, start moving down
	ld   hl, hActCur+iActSprMap
	res  ACTDIRB_R, [hl]			; Face left
	set  ACTDIRB_D, [hl]			; Move down
	
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_MoveD ===============
; Move down.
; First transition only.
Act_WilyShip_MoveD:
	; Animate propeller
	ld   c, $01
	call ActS_Anim2
	
	; Move down 0.5px/frame
	call ActS_MoveBySpeedY
	
	; Continue that until we reach the point where the body of the 2nd phase should be.
	ldh  a, [hActCur+iActY]
	cp   OBJ_OFFSET_Y+$60			; AcyY != $70?
	ret  nz							; If so, return
	
	; Switch to the next routine.
	; If we're in the transition between the 1st and 2nd phases, at this point the caller takes over.
	ld   hl, hActCur+iWilyShipRtnId
	inc  [hl]
	ret
	
; =============== Act_WilyShip_Nop ===============
; We never get here.
Act_WilyShip_Nop:
	ret
	
; =============== Act_WilyShip_ScrollR ===============
; Scrolls the screen to the right.
; IN
; - HL: Ptr to iActXSub
Act_WilyShip_ScrollR:
	; Scroll the screen to the right by 1 pixel
	push hl
		call Game_AutoScrollR_NoAct
	pop  hl
	
	;
	; If haven't reached the rightmost edge of the screen, also move 1px to the right.
	; Note that to even get here (through Act_WilyShip_MoveScrollR), iActX needs to be $90,
	; so we only get to increment it once -- then it becomes $91 and the check below always returns.
	;
	; What's the point of this? Was the requirement to get to Act_WilyShip_MoveScrollR lower than $90 at some point? 
	;
	ldh  a, [hActCur+iActX]	
	cp   SCREEN_GAME_H+OBJ_OFFSET_X-$18+1	; iActX >= $91?
	ret  nc									; If not, return
	inc  hl 			; iActXSub
	inc  [hl] 			; iActX++
	ret
	
