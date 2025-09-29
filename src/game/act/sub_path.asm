; =============== ActS_AngleToPl ===============
; Makes the actor move slowly at an angle towards the player.
; Used by actors that "track" a snapshot of the player's position, like carrots.
ActS_AngleToPl:

	; Target is 12 pixels above the player's origin.
	; This corresponds to the center of their body.
	ld   b, PLCOLI_V	
	
	; Fall-through
	
; =============== ActS_AngleToPlCustom ===============
; See above, but with a custom vertical offset.
; Used exclusively by the boss version of Metal Blades to track the player's origin rather than center of the body.
;
; IN
; - B: Target Y offset, relative to the player's origin
ActS_AngleToPlCustom:

	
	;
	; We are indexing a table of speed values by the current distance range between the actor and the player.
	; This table is set up to make the object travel at the same speed regardless of the angle it moves to.
	;
	; While the player may move later on, the speed values won't be updated manually.
	;
	; That needs an index first, which is split into the two coordinates.
	;
	
	;
	; PREPARATIONS
	;
	
	DEF tSprMapFlags = wColiGround
	DEF tActPlYDiff = wTmpCF52
	DEF tActPlXDiff = wTmpCF53
	
	; Shift the target Y coordinate up by <B> pixels.
	; If we got here from ActS_SetSpeedToPl, that makes it track the middle of the player.
	ld   a, [wPlRelY]
	sub  b
	ld   b, a
	
	; Reset speed & direction since we're writing those
	xor  a
	ld   [tSprMapFlags], a		; Default to upwards, left
	ldh  [hActCur+iActSpdX], a
	ldh  [hActCur+iActSpdY], a
	
	
.calcYDiff:
	;
	; Y COORDINATE
	;
	; tActPlYDiff = ABS(iActY - (wPlRelY - B))
	;
	
	; Find the distance between the actor's and player's Y coordinates.
	; In case that would be negative (player below the actor), invert it and set the downwards direction flag.
	
	ldh  a, [hActCur+iActY]		; A = iActY
	sub  b						; - TargetY
	jr   c, .plBelow			; Is that negative? (TargetY > iActY) If so, jump
.plAbove:
	ld   [tActPlYDiff], a		; Write the absolute distance
	jr   .calcXDiff
.plBelow:
	xor  $FF					; Invert to positive
	inc  a
	ld   [tActPlYDiff], a		; Write the absolute distance
	ld   a, [tSprMapFlags]		; Flag downwards movement
	set  ACTDIRB_D, a
	ld   [tSprMapFlags], a
	
.calcXDiff:
	;
	; X COORDINATE
	;
	; tActPlYDiff = ABS(iActX - wPlRelX)
	;
	
	; Identical to the above basically, except the X coordinate always points to the origin.
	ld   a, [wPlRelX]			; B = TargetX
	ld   b, a
	ldh  a, [hActCur+iActX]		; A = iActX
	sub  b						; - TargetX
	jr   c, .plRight			; Is that negative? (TargetX > iActX) If so, jump
.plLeft:
	ld   [tActPlXDiff], a		; Write the absolute distance
	jr   .findSpeed
.plRight:
	xor  $FF					; Invert to positive
	inc  a
	ld   [tActPlXDiff], a		; Write the absolute distance
	ld   a, [tSprMapFlags]		; Flag movement to the right
	set  ACTDIRB_R, a
	ld   [tSprMapFlags], a
	
	
.findSpeed:
	;
	; Read the subpixel speed values for both axes.
	;
	; The table of speed values is set up in a specific sawtooth pattern that allows
	; to get the complementary speed values for any given combination of distances.
	;
	; It also expects the index to be set up in a very specific way:
	; - The upper nybble should be the distance on the same axis of the speed value we want
	; - The lower nybble should be the distance on the opposite axis
	;
	; For example, if we want the *horizontal* speed, the upper nybble should contain the *horizontal* distance,
	; while the lower nybble the *vertical* distance.
	;
	; As a result, the table entries are split in groups of $10, each for any of the possible "same axis" distances.
	; The downwards sawtooth pattern used in all of them makes sure that, as the distance on the opposite
	; axis grows, the speed on the main one gets reduced.
	;
	; To go with that, the speed values across different groups is specifically chosen so that swapping
	; the nybbles of the index will give out the complementary speed for the other axis.
	; 
	; To cut down on the table size, only the upper nybbles of each distance is kept, 
	; essentially dividing the playfield into a 16x16 grid of unique speed values.
	;

	;
	; X SPEED
	;
	ld   hl, ActS_DistToSpdTbl		; HL = Table base
	ld   a, [tActPlXDiff]			; X Diff is high nybble (& $F0)
	and  $F0
	ld   b, a
	ld   a, [tActPlYDiff]			; Y Diff is low nybble (/ $10)
	and  $F0
	swap a
	or   b							; Merge the two
	; At this point, the A register could have been saved elsewhere to avoid having to recalculate it later.
	; Pushing it here, then later on "pop af" and "swap a" was all that would've been needed to get the Y SPEED index.
	ld   b, $00
	ld   c, a
	add  hl, bc						; Index the table with it
	ld   a, [hl]
	ldh  [hActCur+iActSpdXSub], a	; Got the horizontal speed
	
	;
	; Y SPEED
	;
	ld   hl, ActS_DistToSpdTbl		; HL = Table base
	ld   a, [tActPlYDiff]			; Y Diff is high nybble (& $F0)
	and  $F0
	ld   b, a
	ld   a, [tActPlXDiff]			; X Diff is low nybble (/ $10)
	and  $F0
	swap a
	or   b							; Merge the two
	ld   b, $00
	ld   c, a
	add  hl, bc						; Index the table with it
	ld   a, [hl]
	ldh  [hActCur+iActSpdYSub], a	; Got the vertical speed
	
	; Save the updated direction flags, to let routines that move actors 
	; along the current direction to target the player properly.
	ldh  a, [hActCur+iActSprMap]
	and  $FF^(ACTDIR_R|ACTDIR_D)	; Delete directions from old value
	ld   b, a
	ld   a, [tSprMapFlags]			; Get new directions
	or   b							; Merge with old value
	ldh  [hActCur+iActSprMap], a	; Save back
	ret
	
	
; =============== ActS_InitCirclePath ===============
; Initializes the data for the circular path.
ActS_InitCirclePath:

	; Not used here, presumably leftover copypaste from ActS_InitAnimRange
	xor  a
	ldh  [hActCur+iActTimer], a
	
	;
	; Set the initial ActS_ArcPathTbl indexes & direction for both axes.
	;
	; These are respectively set to:
	; - X index: Increase index, start from the lowest value
	; - Y index: Decrease index, start from the highest value
	;
	; The indexes move back and forth from 0 to 88, and the closer one is to 0, 
	; the faster the actor will move to that particular direction.
	; 
	; The way the indexes are offsetted alongside the logic for flipping the actor
	; when it reaches its lowest speed makes for a circular path.
	;
	ld   a, ADR_INC_IDX|ADR_DEC_IDY	; Set index directions
	ldh  [hActCur+iArcIdDir], a
	xor  a							; Move fast horz
	ldh  [hActCur+iArcIdX], a
	ld   a, ARC_MAX					; Move slow vert
	ldh  [hActCur+iArcIdY], a
	ret
	
; =============== ActS_ApplyCirclePath ===============
; Moves the current actor along a circular path.
; IN
; - A: Circle size (ARC_*)
;      The higher this is, the smaller the arc is.
ActS_ApplyCirclePath:
	DEF tArcSize = wTmpCF52
	; Save this for later
	ld   [tArcSize], a
	
	;
	; Get the actor's speed from the table for the current indexes.
	;
	; Note that the speed is relative to the current direction, meaning
	; this *could* be used to handle both clockwise and anticlockwise paths.
	;
	
	; Speed values here are all subpixel-based
	xor  a
	ldh  [hActCur+iActSpdX], a
	ldh  [hActCur+iActSpdY], a
	
	; iActSpdXSub = ActS_ArcPathTbl[iArcIdX]
	ldh  a, [hActCur+iArcIdX]
	ld   hl, ActS_ArcPathTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ldh  [hActCur+iActSpdXSub], a
	
	; iActSpdYSub = ActS_ArcPathTbl[iArcIdY]
	ldh  a, [hActCur+iArcIdY]
	ld   hl, ActS_ArcPathTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	ldh  [hActCur+iActSpdYSub], a
	
	;
	; Update the indexes to the next value, flipping the direction as needed only
	; when the speed reaches near 0.
	; This flip timing is important to make the actor move on a proper circular path.
	;
	
	;
	; HORIZONTAL INDEX
	;
	
.updX:
	ldh  a, [hActCur+iArcIdDir]
	bit  ADRB_DEC_IDX, a			; Decreasing the X index?
	jr   nz, .decX					; If so, jump
.incX:
	;
	; Increase the index by the arc size value amount we passed to the subroutine.
	; If it reaches the maximum value of ARC_MAX, make the actor turn horizontally
	; and, from the next frame, start decreasing the indexes.
	;
	; The higher this "size value" is, the more values are skipped, leading to smaller arcs
	; as the rotation will complete sooner. Hence why ARC_LG is $01 while ARC_SM is $02.
	; However, as it will also take half the time to do a full rotations, actors may want to
	; counterbalance it by calling ActS_HalfSpdSub after this subroutine returns.
	;
	
	ld   a, [tArcSize]				; iArcIdX += tArcSize
	ld   b, a
	ldh  a, [hActCur+iArcIdX]
	add  b
	ldh  [hActCur+iArcIdX], a
	
	; The equality check here brings an assumption.
	; ARC_MAX needs to be a multiple of tArcSize, otherwise we miss the specific value we check for.
	cp   ARC_MAX					; iArcIdX == ARC_MAX? (lowest speed)
	jr   nz, .updY					; If not, skip
	
	ldh  a, [hActCur+iArcIdDir]		; Start decreasing the index next time
	xor  ADR_DEC_IDX
	ldh  [hActCur+iArcIdDir], a
	ldh  a, [hActCur+iActSprMap]	; Turn around
	xor  ACTDIR_R
	ldh  [hActCur+iActSprMap], a
	jr   .updY
	
.decX:
	;
	; Decrease the index by the arc size we passed to the subroutine.
	; If it reaches the minimum value of start increasing the indexes.
	;
	
	ld   a, [tArcSize]				; iArcIdX -= tArcSize
	ld   b, a
	ldh  a, [hActCur+iArcIdX]
	sub  b
	ldh  [hActCur+iArcIdX], a
	
	or   a							; iArcIdX == 0? (max speed)
	jr   nz, .updY					; If not, skip
	
	ldh  a, [hActCur+iArcIdDir]		; Start increasing the index next time
	xor  ADR_DEC_IDX
	ldh  [hActCur+iArcIdDir], a
	
	
.updY:
	;
	; VERTICAL INDEX
	; Identical to the other one, just for the other axis.
	;
	ldh  a, [hActCur+iArcIdDir]
	bit  ADRB_DEC_IDY, a
	jr   nz, .decY
	
.incY:
	ld   a, [tArcSize]				; iArcIdY += tArcSize
	ld   b, a
	ldh  a, [hActCur+iArcIdY]
	add  b
	ldh  [hActCur+iArcIdY], a
	
	cp   ARC_MAX					; iArcIdY == ARC_MAX? (lowest speed)
	ret  nz							; If not, return
	
	ldh  a, [hActCur+iArcIdDir]		; Start decreasing the index next time
	xor  ADR_DEC_IDY
	ldh  [hActCur+iArcIdDir], a
	ldh  a, [hActCur+iActSprMap]	; Turn around
	xor  ACTDIR_D
	ldh  [hActCur+iActSprMap], a
	ret
	
.decY:
	ld   a, [tArcSize]				; iArcIdY -= tArcSize
	ld   b, a
	ldh  a, [hActCur+iArcIdY]
	sub  b
	ldh  [hActCur+iArcIdY], a
	or   a
	ret  nz
	ldh  a, [hActCur+iArcIdDir]		; Start increasing the index next time
	xor  ADR_DEC_IDY
	ldh  [hActCur+iArcIdDir], a
	ret
	
; =============== ActS_HalfSpdSub ===============
; Halves the actor's *subpixel* speed.
; Only the subpixel speed is affected, this assumes the pixel speed is both zero.
; Code that goes through ActS_AngleToPl is a good candidate. 
ActS_HalfSpdSub:
	; iActSpdXSub /= 2
	ldh  a, [hActCur+iActSpdXSub]
	srl  a
	ldh  [hActCur+iActSpdXSub], a
	; iActSpdYSub /= 2
	ldh  a, [hActCur+iActSpdYSub]
	srl  a
	ldh  [hActCur+iActSpdYSub], a
	ret
	
; =============== ActS_DoubleSpd ===============
; Doubles the actor's speed.
ActS_DoubleSpd:
	; iActSpdX *= 2
	ldh  a, [hActCur+iActSpdXSub]
	sla  a							; *2 sub
	ldh  [hActCur+iActSpdXSub], a
	ldh  a, [hActCur+iActSpdX]
	rl   a							; *2 main, shift in carry
	ldh  [hActCur+iActSpdX], a
	; iActSpdY *= 2
	ldh  a, [hActCur+iActSpdYSub]
	sla  a
	ldh  [hActCur+iActSpdYSub], a
	ldh  a, [hActCur+iActSpdY]
	rl   a
	ldh  [hActCur+iActSpdY], a
	ret
	
