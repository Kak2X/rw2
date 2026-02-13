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