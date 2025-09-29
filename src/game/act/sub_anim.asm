; =============== ActS_SetSprMapId ===============
; Sets the current actor's base sprite mapping ID.
; IN
; - A: Sprite mapping ID ($00-$07)
ActS_SetSprMapId:
	; This is stored into bits3-5 of iActSprMap
	; B = A << 3
	sla  a		
	sla  a
	sla  a
	ld   b, a
	
	; Update iActSprMap
	ldh  a, [hActCur+iActSprMap]
	and  ACTDIR_R|ACTDIR_D			; Keep direction flags only
	or   b							; Merge with new ID
	ldh  [hActCur+iActSprMap], a
	ret
	
; =============== ActS_Anim2 ===============
; Animates the actor's 2 frame animation.
; This and all other animation functions work on the relative sprite mapping ID,
; so the actual sprite ID shown is offset by wActCurSprMapBaseId.
; IN
; - C: Animation speed
ActS_Anim2:
	
	ldh  a, [hActCur+iActSprMap]	; Preserve the old directions to B
	and  ACTDIR_R|ACTDIR_D
	ld   b, a
	
	;
	; This and other ActS_Anim* cycles are accomplished by adding an arbitrary value to the
	; animation timer stored in iActSprMap, then modulo-ing the result.
	;
	; This timer is stored in the lower 3 bits of iActSprMap, while the relative sprite 
	; mapping ID uses the next 3 bits after that. Therefore, it eventually will overflow,
	; triggering the frame change.
	;
	
	ldh  a, [hActCur+iActSprMap]
	add  c							; Add to anim timer
	and  $0F						; Force sprite mapping ID in range $00-$01
	or   b							; Add back old directions
	ldh  [hActCur+iActSprMap], a
	ret
	
; =============== ActS_Anim4 ===============
; Animates the actor's 4 frame animation.
; IN
; - C: Animation speed
ActS_Anim4:
	ldh  a, [hActCur+iActSprMap]	; Preserve the old directions to B
	and  ACTDIR_R|ACTDIR_D
	ld   b, a
	
	ldh  a, [hActCur+iActSprMap]
	add  c							; Add to anim timer
	and  $1F						; Force sprite mapping ID in range $00-$03
	or   b							; Add back old directions
	ldh  [hActCur+iActSprMap], a
	ret
	
; =============== ActS_AnimCustom ===============
; Animates the actor's frame cycle up to the specified frame.
; Used for actors with animation cycles not divisible by 2.
;
; IN
; - B: Max sprite mapping ID (exclusive)
; - C: Animation speed
ActS_AnimCustom:
	
	sla  b							; Shift max ID to proper place
	sla  b
	sla  b
	
	ldh  a, [hActCur+iActSprMap]	; Preserve the old directions to E
	and  ACTDIR_R|ACTDIR_D
	ld   e, a
	
	ldh  a, [hActCur+iActSprMap]
	add  c							; Add to anim timer
	ld   c, a						;--
		and  $07					; Preserve updated sub frame timer to D
		ld   d, a
	ld   a, c						;--
	
	and  $38						; Only keep the three sprite mapping ID bits
	cp   b							; Reached the target value?
	jr   nz, .save					; If not, jump
	xor  a							; Otherwise, loop it back to 0
	
.save:
	or   d							; Merge back subframe timer
	or   e							; Merge back directions
	ldh  [hActCur+iActSprMap], a
	ret
	
; =============== ActS_InitAnimRange ===============
; Sets up an actor's non-looping animation, using the consecutive range of sprite IDs specified.
; Each sprite lasts the same amount of time.
;
; Mainly used by boss intros.
;
; IN
; - D: Starting sprite mapping (inclusive)
; - E: Ending sprite mapping (inclusive)
; - C: Frame length
ActS_InitAnimRange:
	ld   a, $00
	ldh  [hActCur+iAnimRangeTimer], a
	; With the exception of the timer above, these fields will not be written back to during playback.
	ld   a, d
	ldh  [hActCur+iAnimRangeSprMapFrom], a
	ld   a, e
	ldh  [hActCur+iAnimRangeSprMapTo], a
	ld   a, c
	ldh  [hActCur+iAnimRangeFrameLen], a
	ret

; =============== ActS_PlayAnimRange ===============
; Handles the non-looping animation.
; Unlike other animation routines, this directly sets the base sprite ID to allow
; using a greater range of values, it also means the subroutine needs to be called
; every frame by the actor, otherwise the sprite is reset.
;
; OUT
; - Z Flag: If set, the animation hasn't finished playing
ActS_PlayAnimRange:

	; Advance its timer
	ldh  a, [hActCur+iAnimRangeTimer]
	add  $01
	ldh  [hActCur+iAnimRangeTimer], a
	
	; Get its fields out
	ldh  a, [hActCur+iAnimRangeSprMapFrom]	; D = Starting sprite / current
	ld   d, a   
	ldh  a, [hActCur+iAnimRangeSprMapTo]	; E = Ending sprite
	ld   e, a
	ldh  a, [hActCur+iAnimRangeFrameLen]	; C = Target frame length (will be multiplied for every frame)
	ld   c, a
	ld   b, a								; Separate copy to use as offset, which is used to multiply the above's running value
	
	;
	; What we want to calculate is this:
	; wActCurSprMapBaseId = MIN(iAnimRangeSprMapTo, iAnimRangeSprMapFrom + (iAnimRangeTimer / iAnimRangeFrameLen))
	;
	; The division is simulated through a loop, by finding how many times iAnimRangeFrameLen fits into iAnimRangeTimer.
	; Each loop increments the running copy of the sprite ID (initialized to iAnimRangeSprMapFrom).
	;
.loop:
	; If the timer has gone past the current target, check if we're done.
	; From the second sprite onwards, this will *always* trigger at least once.
	ldh  a, [hActCur+iAnimRangeTimer]
	cp   c								; Timer >= Target?
	jr   nc, .nextLoop					; If so, jump
	
.divFound:
	ld   a, d							; Set to wActCurSprMapBaseId the current sprite
	ld   [wActCurSprMapBaseId], a
	xor  a								; Z Flag = set
	or   a
	ret
	
.nextLoop:
	; Increment running sprite ID
	inc  d							
	
	; If we went *past* the last sprite, we're done
	ld   a, e
	cp   d							; LastSprite < CurSprite?
	jr   c, .done					; If so, we're done
	
	; Otherwise, set the division boundary for the target
	ld   a, c						; Target += iAnimRangeFrameLen
	add  b
	ld   c, a
	jr   .loop
	
.done:
	ld   a, e						; Cap the sprite ID to the last frame 
	ld   [wActCurSprMapBaseId], a
	ld   a, $01						; Z Flag = clear
	or   a
	ret
	
