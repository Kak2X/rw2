; =============== Pl_DoSlideSpeed ===============
; Updates the player's speed for sliding forwards.
Pl_DoSlideSpeed:
	ld   bc, $0180	; Slide speed: 1.5px/frame
	jr   Pl_DoMoveSpeed.chkDir
	
; =============== Pl_DoMoveSpeed ===============
; Updates the player's speed for moving forwards (walking or jumping).
Pl_DoMoveSpeed:
	ld   bc, $0100	; Normal speed: 1px/frame
.chkDir:
	; Depending on the direction the player is moving, set their direction and speed accordingly.
	ldh  a, [hJoyKeys]
	bit  KEYB_LEFT, a	; Holding left?
	jr   z, .chkR		; If not, jump
.dirL:
	xor  a				; Set facing left
	ld   [wPlDirH], a
	jr   Pl_DecSpeedX	; Speed -= BC
.chkR:
	bit  KEYB_RIGHT, a	; Holding right?
	ret  z				; If not, return (staying idle)
.dirR:
	ld   a, $01			; Set facing right
	ld   [wPlDirH], a
	jr   Pl_IncSpeedX	; Speed += BC
	
; =============== Pl_DoHurtSpeed ===============
; Updates the player's speed in the hurt pose.
Pl_DoHurtSpeed:
	; Specifically, it makes the player move back 0.25px/frame,
	; which is subtracted from the current speed.
	ld   bc, $0040			; BC = 0.25px/frame
	; Subtracting is relative to the direction the player's facing
	ld   a, [wPlDirH]
	or   a					; Facing left?
	jr   z, Pl_IncSpeedX		; If so, move right 
	jr   Pl_DecSpeedX		; Otherwise, move left
	
; =============== Pl_AdjSpeedByActDir ===============
; Updates the player's speed, towards the same direction the actor is facing.
; Used by enemies in Air Man's stage that blow the player away.
; IN
; - A: iActSprMap
; - BC: Offset
Pl_AdjSpeedByActDir:
	bit  ACTDIRB_R, a		; Is the actor facing right?
	jr   nz, Pl_IncSpeedX	; If so, move the player right
	; Fall-through
	
; =============== Pl_DecSpeedX ===============
; Decreases the player's horizontal speed by the specified amount.
; IN
; - BC: Offset
Pl_DecSpeedX:
	ld   a, [wPlSpdXSub]
	sub  c
	ld   [wPlSpdXSub], a
	ld   a, [wPlSpdX]
	sbc  b
	ld   [wPlSpdX], a
	ret
	
; =============== Pl_IncSpeedX ===============
; Increases the player's horizontal speed by the specified amount.
; IN
; - BC: Offset
Pl_IncSpeedX:
	ld   a, [wPlSpdXSub]
	add  c
	ld   [wPlSpdXSub], a
	ld   a, [wPlSpdX]
	adc  b
	ld   [wPlSpdX], a
	ret
	
; =============== Pl_MoveBySpeedX ===============
; Moves the player by its current horizontal speed.
; This and all other movement routines that go off the player's speed reset it before returning,
; so the speed needs to be "reconfirmed" every frame.
; This quirk does not exist for the actor version of the movement-by-speed routines.
Pl_MoveBySpeedX:
	ld   a, [wPlSpdX]	; A = H Speed
	or   a				; Speed already 0?
	ret  z				; If so, nothing to do
	
	; Determine which direction we're moving to through the speed's sign.
	; Speed is not relative to the direction the player is facing, rather,
	; negative speed always moves the player left, positive speed always to the right.
	; This is unlike actors, whose sprite direction usually affects their movement direction.
	bit  7, a			; Speed > 0? (MSB clear)  
	jr   z, .loopR		; If so, jump (move right)
	; The player's remaining speed is used as a loop counter, it must be positive.
	xor  $FF			; Otherwise, Speed = -Speed
	inc  a
	ld   [wPlSpdX], a
.loopL:
	; Movement happens pixel by pixel, doing the whole process for every step of movement.
	; Speed also doesn't persist, the pixel value is essentially guaranteed to be reset
	; when exiting the subroutine.
	call Pl_MoveL		; Move left 1px
	ld   hl, wPlSpdX	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopL		; If not, move again
	ret
.loopR:
	call Pl_MoveR		; Move right 1px
	ld   hl, wPlSpdX	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopR		; If not, move again
	ret
	
; =============== Pl_MoveBySpeedX_Coli ===============
; Variation of Pl_MoveBySpeedX that also checks for solid collision,
; preventing movement over solid blocks.
Pl_MoveBySpeedX_Coli:
	ld   a, [wPlSpdX]	; A = H Speed
	or   a				; Speed already 0?
	ret  z				; If so, nothing to do
	bit  7, a			; Speed > 0? (MSB clear)  
	jr   z, .loopR		; If so, jump (move right)
	xor  $FF			; Otherwise, Speed = -Speed
	inc  a
	ld   [wPlSpdX], a
.loopL:
	call Pl_MoveL_Coli	; Move left 1px, with solid collision checks
	ld   hl, wPlSpdX	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopL		; If not, move again
	ret
.loopR:
	call Pl_MoveR_Coli	; Move right 1px, with solid collision checks
	ld   hl, wPlSpdX	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopR		; If not, move again
	ret
	
; =============== Pl_MoveL_Coli ===============
; Moves the player 1 pixel to the left if there isn't a solid block in the way.
Pl_MoveL_Coli:
	;
	; The player typically is 24 pixels tall, meaning two blocks need to be checked.
	; The sensors are located 8 pixels apart, therefore 4 of them are needed.
	;
	
	; All of these sensors are located 1 pixel to the left
	; of the right border of the collision box.
	; This is enough given only one pixel of movement ever happens at a time.
	ld   a, [wPlRelX]		; XPos = PlX - 7
	sub  PLCOLI_H+1
	ld   [wTargetRelX], a
	
	;
	; Y Positions 0, 7 and 15 belong to the low block,
	; and must be always checked.
	;
	
	; LOW BLOCK, bottom
	ld   a, [wPlRelY]		; YPos = PlY
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	ld   [wPlColiBlockL], a	; Set it as left block (doesn't happen to be used)
	ret  nc					; Is the block empty? If not, return
	
	; LOW BLOCK, middle
	ld   a, [wPlRelY]		; YPos = PlY - 7
	sub  (8*1)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	ret  nc					; Is the block empty? If not, return
	
	; LOW BLOCK, top
	ld   a, [wPlRelY]		; YPos = PlY - 15
	sub  (8*2)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	ret  nc					; Is the block empty? If not, return
	
	;
	; Y position 23 belongs to the block above.
	; When sliding, the player's height is halved, and as such it fits within the low block.
	;
	ld   a, [wPlMode]
	cp   PL_MODE_SLIDE		; Player sliding?
	jr   z, Pl_MoveL		; If so, skip
	
	; HIGH BLOCK, middle
	ld   a, [wPlRelY]		; YPos = PlY - 23
	sub  (8*3)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	ret  nc					; Is the block empty? If not, return
	; Fall-through
	
; =============== Pl_MoveL ===============
; Moves the player 1 pixel to the left.
Pl_MoveL:

	;
	; The player's coordinates in this game directly map to the hardware sprites'
	; positions and as such are always relative to the screen.
	; Hence, special care must be taken to account for both the hardware offset
	; and to how, the player sprite doesn't really move when the screen also scrolls.
	;


	; Prevent moving off-screen to the left.
	ld   a, [wPlRelX]
	cp   OBJ_OFFSET_X + 8		; wPlRelX < 8?
	ret  c						; If so, return
	
	;
	; If we crossed a block boundary, decrement the current column number.
	;
.chkCross:
	ld   a, [wPlRelRealX]		; wPlRelRealX--
	dec  a
	ld   [wPlRelRealX], a
	and  BLOCK_H-1				; A %= BLOCK_H	
	cp   BLOCK_H-1				; A != BLOCK_H - 1?
	jr   nz, .chkMoveType		; If not, skip (didn't cross)
	
	ld   hl, wLvlColPl			; ColNum--
	dec  [hl]
	
	;--
	;
	; If the screen isn't locked, redraw the edge of the screen, spawning actors as needed.
	;
	; [POI] This being checked here is... odd.
	;       It only makes sense to perform the redraw when the viewport crosses a block
	;       boundary, not when the player does it!
	;       In practice, when the player does, the viewport also does it, so all it serves
	;       is calling LvlScroll_DrawEdgeL before hScrollX and wLvlColL get updated,
	;       which is proper behavior (due to actors getting shifted).
	;
	
	; Boss corridors and boss rooms lock the screen.
	; We can detect if we're in one of the two by checking if we're at least in a boss corridor, 
	; as in this game they only ever are at the end of a level.
	ld   a, [wBossMode]
	or   a							; In a boss corridor or boss room?
	jr   nz, .lock					; If so, skip
	
	; Then check for a standard screen lock, from the current column number.
	ld   h, HIGH(wLvlScrollLocks)	; HL = wLvlScrollLocks[ColNum]
	ld   a, [wLvlColPl]
	ld   l, a
	ld   a, [hl]					; A = Lock info
	bit  SLKB_OPEN, a				; Is the player on an unlocked column?
	call nz, LvlScroll_DrawEdgeL	; If so, do the redraw
	;--
	
.chkMoveType:

	;
	; Perform the actual player movement.
	; This can be done in two ways:
	; - If the screen is locked, move the player left
	; - If the screen isn't locked, move the viewport left
	;
	
	; Boss corridors and boss rooms lock the screen.
	ld   a, [wBossMode]
	or   a						; In a boss corridor or boss room?	
	jr   nz, .lock				; If so, skip
	
	; Then check for a standard screen lock, from the current column number.
	ld   h, HIGH(wLvlScrollLocks)	; HL = wLvlScrollLocks[ColNum]
	ld   a, [wLvlColPl]
	ld   l, a
	ld   a, [hl]				; A = Lock info
	bit  SLKB_OPEN, a			; Is scrolling unlocked for this column? 
	jr   nz, .noLock			; If so, jump
.lock:
	; Screen is locked.
	; Move the player left by 1 pixel.
	ld   hl, wPlRelX
	dec  [hl]
	ret
.noLock:
	; Screen is unlocked.
	; Keep the player at the current position, and instead...
	ld   hl, wActScrollX		; ...move all actors 1px to the right
	inc  [hl]
	ldh  a, [hScrollX]			; ...move the viewport left (scroll the screen right)
	dec  a
	ldh  [hScrollX], a
	; If the *viewport* crossed a block boundary, decrement the column base
	and  BLOCK_H-1				; A %= BLOCK_H	
	ldh  [hScrollXNybLow], a	; Keep this in sync
	cp   BLOCK_H-1				; A != BLOCK_H - 1? (went from $x0 to $xF)
	ret  nz						; If not, return (didn't cross)
	ld   hl, wLvlColL			; Otherwise, move to previous base col
	dec  [hl]
	ret

; =============== Pl_MoveR_Coli ===============
; Moves the player 1 pixel to the right if there isn't a solid block in the way.
; See also: Pl_MoveL_Coli
Pl_MoveR_Coli:

	;
	; Check for solid collision
	;
	ld   a, [wPlRelX]		; XPos = PlX + 7
	add  PLCOLI_H+1
	ld   [wTargetRelX], a
	
	; LOW BLOCK, bottom
	ld   a, [wPlRelY]		; YPos = PlY
	ld   [wTargetRelY], a
	call Lvl_GetBlockId		; A = Block ID
	ld   [wPlColiBlockR], a	; Set it as right block (used, unlike wPlColiBlockL)
	ret  nc					; Is the block empty? If not, return
	
	; LOW BLOCK, middle
	ld   a, [wPlRelY]		; YPos = PlY - 7
	sub  (8*1)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	
	; LOW BLOCK, top
	ld   a, [wPlRelY]		; YPos = PlY - 15
	sub  (8*2)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	
	; Check the top block only if not sliding
	ld   a, [wPlMode]
	cp   PL_MODE_SLIDE		; Player sliding?
	jr   z, Pl_MoveR		; If so, skip
	; HIGH BLOCK, middle
	ld   a, [wPlRelY]		; YPos = PlY - 23
	sub  (8*3)-1
	ld   [wTargetRelY], a
	call Lvl_GetBlockId
	ret  nc
	; Fall-through
	
; =============== Pl_MoveR ===============
; Moves the player 1 pixel to the right.
Pl_MoveR:

	; Prevent moving off-screen to the right.
	; (screen size + box radius + 1 pixel of movement - hardware offset)
	ld   a, [wPlRelX]
	cp   SCREEN_GAME_H+PLCOLI_H+1-OBJ_OFFSET_X	; wPlRelX >= $9F?
	ret  nc										; If so, return
	
	;
	; Perform the actual player movement.
	; This can be done in two ways:
	; - If the screen is locked, move the player right
	; - If the screen isn't locked, move the viewport right
	;
	ld   a, [wBossMode]
	or   a					; In a boss corridor or boss room?	
	jr   nz, .lock			; If so, skip
	; Then check for a standard screen lock, from the current column number.
	ld   h, HIGH(wLvlScrollLocks)	; HL = wLvlScrollLocks[ColNum]
	ld   a, [wLvlColPl]
	ld   l, a
	ld   a, [hl]			; A = Lock info
	bit  SLKB_OPEN, a
	jr   nz, .noLock
.lock:
	; Screen is locked.
	; Move the player right by 1 pixel.
	ld   hl, wPlRelX
	inc  [hl]
	jr   .chkCross
.noLock:
	; Screen is unlocked.
	; Keep the player at the current position, and instead...
	ld   hl, wActScrollX	; ...move all actors 1px to the left
	dec  [hl]
	ldh  a, [hScrollX]		; ...move the viewport right (scroll the screen left)
	inc  a
	ldh  [hScrollX], a
	; If the *viewport* crossed a block boundary, increment the column base
	and  BLOCK_H-1				; A %= BLOCK_H	
	ldh  [hScrollXNybLow], a	; Keep this in sync
	jr   nz, .chkCross			; Is it != 0? (went from $xF to $x0). If not, skip
	ld   hl, wLvlColL			; Otherwise, move to next base col
	inc  [hl]
.chkCross:
	;
	; If we crossed a block boundary, increment the current column number.
	;
	; Notice how these checks are happening at the end of the subroutine, compared
	; to Pl_MoveL where they took place at the start.
	;
	ld   a, [wPlRelRealX]		; wPlRelRealX++
	inc  a
	ld   [wPlRelRealX], a
	and  BLOCK_H-1				; A %= BLOCK_H	
	ret  nz						; Is it != 0? (went from $xF to $x0). If not, return
	ld   hl, wLvlColPl			; ColNum++
	inc  [hl]
	
	;
	; If the screen isn't locked, redraw the edge of the screen, spawning actors as needed.
	;
	; [POI] The same note from Pl_MoveL applies here, except we're at the end of the subroutine.
	;       Here, hScrollX and wLvlColL already got updated.
	; [BUG] That causes an off by one problem when spawning actors. They are already placed at the correct
	;       location, but due to scrolling happening during the frame, ActS_MoveByScrollX will trigger and move them left.
	;       This inconsistency was worked around in actors like Act_Goblin.
	;
	
	; Boss corridors and boss rooms lock the screen.
	ld   a, [wBossMode]
	or   a						; Went through a shutter? (!= BSMODE_NONE)
	ret  nz						; If so, return
	
	; Then check for a standard screen lock, from the current column number.
	ld   h, HIGH(wLvlScrollLocks)	; HL = wLvlScrollLocks[ColNum]
	ld   a, [wLvlColPl]
	ld   l, a
	ld   a, [hl]					; A = Lock info
	bit  SLKB_OPEN, a				; Is the player on an unlocked column?
	ret  z							; If not, return
	jp   LvlScroll_DrawEdgeR		; Otherwise, do the redraw
	
; =============== Pl_AlignToLadder ===============
; Adjusts the player's horizontal position to be centered to the ladder.
;
; This subroutine assumes for the screen to be perfectly aligned to a block boundary (ie: locked, ...),
; if it isn't it will break the screen's scrolling due to moving the player's position instead of the viewport's.
Pl_AlignToLadder:
	
	;
	; If the player perfectly aligned to the center of the ladder, there's nothing to do.
	;
	; Note that the checks are made against wPlRelX, which is shifted by 8 (OBJ_OFFSET_X)
	; and as such it shifts the center point and effectively swaps the left and right ranges.
	; Even though wPlRelRealX could have been used instead to make the checks more intuitive,
	; using wPlRelX is faster as it gives the movement amount for free once modulo'd (see .moveL/.moveR)
	;
	;               CENTER POINT | LEFT SIDE | RIGHT SIDE
	; wPlRelRealX |          $07 |   $00-$06 |    $08-$0F
	; wPlRelX     |          $0F |   $08-$0E |    $00-$07
	; DIFF        |              |        +8 |         -8
	;
	
	ld   a, [wPlRelX]		; Get player origin (center of the player)
	ld   b, a				; (Not necessary)
	and  BLOCK_H-1			; Get position within the block (ModX)
	cp   OBJ_OFFSET_X+$07	; Is it at the center of the block? (ModX == $0F? / ModRealX == $07?)
	ret  z					; If so, return
	
	; Determine if the player is on the left or right of the center point
	cp   $08				; Is the player on the left side? (ModX in range $08-$0F)
	jr   nc, .moveR			; If so, move right
	
.moveL:

	;
	; The player is on the right side of the block, and should be moved to the center point.
	; With wPlRelRealX, the center point is $07, and the player should be moved left by <ModRealX>-$07 px.
	;
	; However, since we're using wPlRelX, whose values are subtracted by 8 when pointing to the right side...
	; <ModRealX> - $07 => <ModX> + $08 - $07 => <ModX> + 1
	;
	; That's easier to calculate, it's just off by one to what we already have in the A register.
	;
	inc  a					; MoveAmount = ModX + 1
	ld   b, a
	
	; Move both the player position and its unoffsetted copy left
	ld   a, [wPlRelX]		; wPlRelX -= B
	sub  b
	ld   [wPlRelX], a
	ld   a, [wPlRelRealX]	; wPlRelRealX -= B
	ld   c, a				; Save the untouched wPlRelRealX
	sub  b
	ld   [wPlRelRealX], a
	
	; [TCRF] If the movement made the player cross a block boundary, decrement the column number.
	;        This will never happen, as to hold on a ladder the player's origin must be in a ladder block to begin with.
	xor  c					; Check for changes compared to the unmodified value
	bit  4, a				; Did we cross the $10-byte block boundary? (bit4 changed from last time)
	ret  z					; If not, return
	;--
	; Unreachable
	ld   hl, wLvlColPl		; Otherwise, decrement the column number
	dec  [hl]
	ret
	;--
	
.moveR:
	;
	; The player is on the left side of the block, and should be moved right to the center point.
	; Same thing as before, except happening the other way around as the values are added by $08 so:
	; 
	; $07 - <ModRealX> => $07 - (<ModX> - $08) => $0F - <ModX>
	;
	ld   b, a				; MoveAmount = $0F - ModX
	ld   a, $0F
	sub  b
	ld   b, a
	
	; Move both the player position and its unoffsetted copy right
	ld   a, [wPlRelX]		; wPlRelX -= B
	add  b
	ld   [wPlRelX], a
	ld   a, [wPlRelRealX]	; wPlRelRealX -= B
	ld   c, a
	add  b
	ld   [wPlRelRealX], a
	
	; [TCRF] If the movement made the player cross a block boundary, increment the column number.
	xor  c					; Check for changes compared to the unmodified value
	bit  4, a				; Did we cross the $10-byte block boundary? (bit4 changed from last time)
	ret  z					; If not, return
	;--
	; Unreachable
	ld   hl, wLvlColPl
	inc  [hl]
	ret
	;--
	
; =============== Pl_MoveByRmSpeedY ===============
; Moves the player by its current vertical speed when riding Rush Marine.
;
; Worth noting there's no Pl_MoveBySpeedY as the normal vertical movement mechanics don't have a need to it.
; For example, the player in the jump state always moves up, or in the falling state always down,
; with no way to influence the speed like with the horizontal one (ie: Air Man, conveyor belts, ...)
;
; Rush Marine is the exception, since it has vertical momentum... but why not use wPlSpdY directly?
Pl_MoveByRmSpeedY:
	ld   a, [wPlRmSpdY]	; A = V Speed
	or   a				; Speed already 0?
	ret  z				; If so, nothing to do
	
	bit  7, a			; Speed > 0? (MSB clear)  
	jp   z, .loopD		; If so, jump (move down)
	xor  $FF			; Otherwise, Speed = -Speed
	inc  a
	ld   [wPlRmSpdY], a
	
	; These loops are a lazy copy/paste that could have been avoided by directly subtracting/adding wPlRmSpdY to wPlRelY.
	; The loop was there in Pl_MoveBySpeedX because each frame needed to perform actions like checking for collision
	; or potentially scrolling the screen, but this merely alters wPlRelY.
.loopU:
	;--
	ld   hl, wPlRelY	; Move up 1px
	dec  [hl]
	;--
	ld   hl, wPlRmSpdY	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopU		; If not, move again
	ret
.loopD:
	;--
	ld   hl, wPlRelY	; Move down 1px
	inc  [hl]
	;--
	ld   hl, wPlRmSpdY	; Speed--
	dec  [hl]			; Elapsed the speed?
	jr   nz, .loopD		; If not, move again
	ret
	
