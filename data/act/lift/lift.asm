; =============== Act_Lift ===============
; ID: ACT_LIFT0, ACT_LIFT1, ACT_LIFT2 
; Moving lifts in Crash Man's stage, with separate paths for each actor.
Act_Lift:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Lift_InitPath
	dw Act_Lift_InitPos
	dw Act_Lift_NextSeg
	dw Act_Lift_MoveH
	dw Act_Lift_MoveV
	DEF ACTRTN_LIFT_NEXTSEG = $02
	DEF ACTRTN_LIFT_MOVEH = $03
	DEF ACTRTN_LIFT_MOVEV = $04
	DEF LIFT_SPEED = $0080

; =============== Act_Lift_InitPath ===============
Act_Lift_InitPath:
	; Each actor ID has its own path assigned.
	; wActLiftPathId and wActLiftPathSeg being global variables means having multiple lifts on-screen won't work properly.
	ldh  a, [hActCur+iActId]	; wActLiftPathId = (iActId & $7F) - ACT_LIFT0
	and  $FF^ACTF_PROC
	sub  ACT_LIFT0
	ld   [wActLiftPathId], a
	
	jp   ActS_IncRtnId
	
; =============== Act_Lift_InitPos ===============
Act_Lift_InitPos:
	; Adjust the actor's position to make it stand on the rail
	ldh  a, [hActCur+iActX]		; 5 pixels right
	add  $05
	ldh  [hActCur+iActX], a
	ldh  a, [hActCur+iActY]		; 4 pixels up
	sub  $04
	ldh  [hActCur+iActY], a
	
	; Start from the first segment
	xor  a
	ld   [wActLiftPathSeg], a
	
	; Use slow movement speed of 0.5px/frame
	ld   bc, LIFT_SPEED
	call ActS_SetSpeedX
	ld   bc, LIFT_SPEED
	call ActS_SetSpeedY
	
	jp   ActS_IncRtnId
	
; =============== Act_Lift_NextSeg ===============
; Handles the next path segment.
Act_Lift_NextSeg:
	;
	; Read the next path segnent from the nested tables.
	; A = Act_Lift_PathPtrTbl[wActLiftPathId][wActLiftPathSeg]
	;
	
	; Seek to the path table for this actor
	ld   hl, Act_Lift_PathPtrTbl	; HL = Table base
	ld   a, [wActLiftPathId]		; BC = wActLiftPathId * 2 (ptr table)
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc						; Offset it
	ld   e, [hl]					; Read the pointer out to HL
	inc  hl
	ld   d, [hl]
	ld   l, e						; HL = Ptr to Act_Lift_Path*
	ld   h, d
	; Seek to the current segment of this path
	ld   a, [wActLiftPathSeg]		; BC = wActLiftPathSeg * 2 (2 byte entries)
	add  a
	ld   b, $00
	ld   c, a
	add  hl, bc						; Offset it
	
	; The path data ends with a single $FF terminator
	ldi  a, [hl]					; Read byte0, seek to byte1
	cp   $FF						; Is it the terminator?
	jr   nz, .readSeg				; If not, jump
.endSeg:
	xor  a							; Otherwise, loop to the start
	ld   [wActLiftPathSeg], a
	jr   Act_Lift_NextSeg
.readSeg:
	push af ; Save byte0 AND flags
		; byte0 - Apply the segment's movement directions
		and  ACTDIR_R|ACTDIR_D			; B = New directions
		ld   b, a
		ldh  a, [hActCur+iActSprMap]	; A = iActSprMap
		and  $FF^(ACTDIR_R|ACTDIR_D)	; Delete old directions
		or   b							; Merge with new ones
		ldh  [hActCur+iActSprMap], a
		
		; byte1 - How many frames the lift should move
		ld   a, [hl]					; Read byte1
		ld   a, a
		ldh  [hActCur+iActTimer], a	; Write directly to iActTimer
		
		; Use the next segment next time
		ld   hl, wActLiftPathSeg
		inc  [hl]
	pop  af ; A = byte0, C = A < $FF
	
	; Pick the correct movement routine depending on the direction we're moving to.
	; This needs to be defined in a separate bit because ACTDIR_R and ACTDIR_D merely tell
	; which directions the lift is facing, not where it moves.
	rrca 						; Is bit0 set?
	jp   c, ActS_IncRtnId 		; If so, jump (move horizontally) ACTRTN_LIFT_MOVEH
	ld   a, ACTRTN_LIFT_MOVEV	; Otherwise, move vertically
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Lift_MoveH ===============
; Moves the lift horizontally.
Act_Lift_MoveH:
	; Move actor horizontally
	call ActS_ApplySpeedFwdX
	;--
	; If the player is standing on the actor, make him move along with it.
	; Not needed with vertical movement due to how the top-platform collision works at low speed.
	ld   a, [wActCurSlotPtr]		; B = Current slot
	ld   b, a
	ld   a, [wActPlatColiSlotPtr]	; A = Slot the player is standing on
	cp   b							; Do they match?
	jr   nz, .tick					; If not, skip
									; Otherwise...
	ldh  a, [hActCur+iActSprMap]	; Move the same direction as the lift
	ld   bc, LIFT_SPEED				; With the same speed
	call Pl_SetSpeedByActDir
	;--
	
.tick:
	; Do the above for the specified amount of frames
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Handle the next segment when done
	ld   a, ACTRTN_LIFT_NEXTSEG
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Lift_MoveV ===============
; Moves the lift vertically.
Act_Lift_MoveV:
	; Move vertically for the specified amount of frames
	call ActS_ApplySpeedFwdY
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Handle the next segment when done
	ld   a, ACTRTN_LIFT_NEXTSEG
	ldh  [hActCur+iActRtnId], a
	ret
	
; =============== Act_Lift_PathPtrTbl ===============
; Maps each lift actor with its own path data.
Act_Lift_PathPtrTbl: 
	dw Act_Lift_Path0 ; ACT_LIFT0
	dw Act_Lift_Path1 ; ACT_LIFT1
	dw Act_Lift_Path2 ; ACT_LIFT2
	
	DEF LIFT_MV_V = $00 ; Move vertically
	DEF LIFT_MV_H = $01 ; Move horizontally

; =============== Act_Lift_Path0 ===============
Act_Lift_Path0:
	;    MV DIR   MV AXIS, TIME (at 0.5/frame, it's BLOCK_H/V * 2)
	db ACTDIR_D|LIFT_MV_V, $40 ; 2   blocks
	db ACTDIR_L|LIFT_MV_H, $E0 ; 7   blocks
	db ACTDIR_U|LIFT_MV_V, $40 ; 2   blocks
	db ACTDIR_R|LIFT_MV_H, $E0 ; 7   blocks
	db $FF
; =============== Act_Lift_Path1 ===============
Act_Lift_Path1:
	db ACTDIR_D|LIFT_MV_V, $80 ; 4   blocks
	db ACTDIR_L|LIFT_MV_H, $80 ; 4   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $20 ; 1   block
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_L|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_D|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_L|LIFT_MV_H, $60 ; 3   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $80 ; 4   blocks
	db $FF
; =============== Act_Lift_Path2 ===============
Act_Lift_Path2:
	db ACTDIR_D|LIFT_MV_V, $A0 ; 5   blocks
	db ACTDIR_L|LIFT_MV_H, $C0 ; 6   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $A0 ; 5   blocks
	db ACTDIR_U|LIFT_MV_V, $60 ; 3   blocks
	db ACTDIR_L|LIFT_MV_H, $20 ; 1   block
	db ACTDIR_D|LIFT_MV_V, $40 ; 2   blocks
	db ACTDIR_L|LIFT_MV_H, $60 ; 3   blocks
	db ACTDIR_U|LIFT_MV_V, $10 ; 0.5 blocks
	db ACTDIR_R|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_U|LIFT_MV_V, $10 ; 0.5 blocks
	db ACTDIR_L|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_U|LIFT_MV_V, $10 ; 0.5 blocks
	db ACTDIR_R|LIFT_MV_H, $40 ; 2   blocks
	db ACTDIR_U|LIFT_MV_V, $10 ; 0.5 blocks
	db ACTDIR_L|LIFT_MV_H, $60 ; 3   blocks
	db ACTDIR_U|LIFT_MV_V, $20 ; 1   block
	db ACTDIR_R|LIFT_MV_H, $C0 ; 6   blocks
	db $FF

