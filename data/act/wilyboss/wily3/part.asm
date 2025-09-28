; =============== Act_Wily3Part ===============
; ID: ACT_WILY3PART
; Animates the secondary parts of Wily Machine's 3rd phase.
; These parts only have two frames of animation, with the second one being triggered by Act_Wily3.
;
; Two separate instances are spawned, one for animating the arms, one for the tail.
; These are purely visual effects, they don't affect the fight at all.
Act_Wily3Part:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_Wily3Part_Intro
	dw Act_Wily3Part_Spr0
	dw Act_Wily3Part_Spr1

; =============== Act_Wily3Part_Intro ===============
; Displays the parts during the 3rd phase intro.
Act_Wily3Part_Intro:
	;
	; During this intro, Act_Wily3 scrolls in from the right, offscreen.
	; Make sure to keep our X position syncronized.
	;
	
	; Only use base sprite
	ldh  a, [hActCur+iWily3PartSprMapId]
	ld   [wActCurSprMapBaseId], a
	
	; Syncronize our X position with Act_Wily3, this is the important bit.
	ldh  a, [hActCur+iWily3PartAnimPtr]	; Get pointer to iWily3AnimPart
	sub  iWily3AnimPart-iActX			; Seek back to X position
	ld   l, a							; Set as low byte
	ld   h, HIGH(wAct)					; Use standard high byte
	ld   a, [hl]						; Read out the X position
	ldh  [hActCur+iActX], a				; Copy it over, as-is
	
	; The intro is treated as "finished" here once we have moved into position.
	cp   OBJ_OFFSET_X+$80		; iActX != $88?
	ret  nz						; If so, keep waiting
	
	; Otherwise, we're ready. The X position won't change anymore.
	jp   ActS_IncRtnId
	
; =============== Act_Wily3Part_Spr0 ===============
; Use 1st sprite.
Act_Wily3Part_Spr0:
	; Set sprite #0 (wActCurSprMapBaseId)
	call Act_Wily3Part_GetProp		; HL = Ptr to iWily3AnimPart, A = iWily3PartSprMapId
	ld   [wActCurSprMapBaseId], a	; Confirm sprite #0
	
	;
	; Check if Act_Wily3 is requesting to animate a part.
	; To uniquely identify the two actor instances, iWily3AnimPart goes off by sprite ID.
	;
	sub  [hl]						; iWily3AnimPart == iWily3PartSprMapId?
	ret  nz							; If not, keep waiting for the signal
									; Otherwise...
									
	ld   [hl], a					; Reset the request signal (A will be 0, which is why it uses "sub" over "cp")
	ld   a, $20						; Display the second sprite for ~half a second
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_Wily3Part_Spr1 ===============
; Use 2nd sprite.
Act_Wily3Part_Spr1:
	; Set sprite #1 (iWily3PartSprMapId + 1)
	; This is always implicitly after iWily3PartSprMapId
	call Act_Wily3Part_GetProp
	inc  a
	ld   [wActCurSprMapBaseId], a
	
	; Show that for ~half a second
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Then go back to sprite #0
	jp   ActS_DecRtnId
	
; =============== Act_Wily3Part_GetProp ===============
; Gets some shared properties.
; OUT
; - HL: Ptr to iWily3AnimPart
; - A: iWily3PartSprMapId
Act_Wily3Part_GetProp:
	ldh  a, [hActCur+iWily3PartAnimPtr]
	ld   l, a
	ld   h, HIGH(wAct)
	
	ldh  a, [hActCur+iWily3PartSprMapId]
	
	ret
	
