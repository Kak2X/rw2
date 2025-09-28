; =============== Act_NeedlePress ===============
; ID: ACT_NEEDLEPRESS
; Retractable needle obstacle.
Act_NeedlePress:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_NeedlePress_InitDelay
	dw Act_NeedlePress_WaitCycle
	dw Act_NeedlePress_InitMain
	dw Act_NeedlePress_Main
	DEF ACTRTN_NEEDLEPRESS_INITMAIN = $02

; =============== Act_NeedlePress_InitDelay ===============
Act_NeedlePress_InitDelay:
	; The needle starts out hidden on a ceiling
	ld   b, ACTCOLI_PASS
	call ActS_SetColiType
	; Adjust 1px down
	ld   hl, hActCur+iActX
	inc  [hl]
	
	;
	; Alternate between cycle timings for every Needle Press that spawns (see Act_NeedlePress_WaitCycle)
	;
	ld   a, [wActNePrLastCycleTarget]	; Toggle 0 and 1
	xor  $01
	ld   [wActNePrLastCycleTarget], a
	ldh  [hActCur+iActTimer], a			; Use new value as target
	
	jp   ActS_IncRtnId
	
; =============== Act_NeedlePress_WaitCycle ===============
; Waits until it's the turn for the needle to extend downwards from the ceiling.
Act_NeedlePress_WaitCycle:

	;
	; Wait until wGameTime % 2 == iActTimer to extend the spike.
	; This is mainly to avoid, after vertical transitions where multiple actors get spawned 
	; in the same frame, to have multiple onscreen spikes use the same cycle.
	;
	ld   a, [wGameTime]					; B = wGameTime % 2 (current timer)
	and  $01
	ld   b, a
	ldh  a, [hActCur+iActTimer]			; A = Target second
	cp   b								; Does it match with the current one?
	ret  nz								; If not, keep waiting
	
	jp   ActS_IncRtnId
	
; =============== Act_NeedlePress_InitMain ===============
Act_NeedlePress_InitMain:
	; Start from the first frame (reset cycle, start extending down)
	xor  a
	ldh  [hActCur+iNePrAnimOff], a
	; Delay for 12 frames before applying any changes
	ld   a, $0C
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_NeedlePress_Main ===============
; Main animation routine for the Needle Press.
; This is an involved process, because its animation involves the needle extending and retracting 
; from the ceiling, altering the collision as needed.
Act_NeedlePress_Main:

	;
	; Seek to the current entry of the frame table.
	; This defines the properties of the current frame.
	;
	
	; HL = Ptr to Act_NeedlePress_AnimTbl[iNePrAnimOff]
	ldh  a, [hActCur+iNePrAnimOff]
	ld   hl, Act_NeedlePress_AnimTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	
	;
	; Check if we're pointing to the end terminator.
	; If we are, reset the animation to the start by re-executing Act_NeedlePress_InitMain.
	;
	ld   a, [hl]							; A = byte0
	cp   $FF								; End terminator reached?
	jr   nz, .valOk							; If not, jump
	ld   a, ACTRTN_NEEDLEPRESS_INITMAIN
	ldh  [hActCur+iActRtnId], a
	ret
	
.valOk:
	;
	; Wait for the timer to elapse before continuing.
	; [POI] This should have been the first thing done in the subroutine, to avoid running the indexing code while waiting
	;       and to prevent the last animation entry from being skipped (iNePrAnimOff will point to the end terminator).
	;
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	;
	; COLLISION BOX
	;
	; Map the sprite ID (byte0) to its vertical collision radius.
	; It's not fixed to $0F since the spike is two blocks tall, while the ceiling it hangs from can be less than that.
	;
	; The horizontal one doesn't need to change, so it's always $03.
	;
	push hl
		; HL = Act_NeedlePress_ColiBoxVTbl[byte0]
		ld   a, [hl]	 		; Read byte0, the sprite ID
		ld   hl, Act_NeedlePress_ColiBoxVTbl
		ld   b, $00
		ld   c, a
		add  hl, bc
		ld   c, [hl]			; Read vert radius from entry
		ld   b, $03				; Use fixed horz radius
		call ActS_SetColiBox	; Update box
	pop  hl
	
	;
	; COLLISION TYPE
	;
	; While this actor generally reflects shots, there is a point where it's fully retracted.
	; The sprite it uses during that time is $00, so save some CPU time by making it intangible there.
	;
	push hl
		ld   b, ACTCOLI_ENEMYREFLECT	; Reflect shots by default
		ld   a, [hl]					; Read sprite ID [byte0]
		or   a							; SpriteId != 0?
		jr   nz, .setColi				; If so, jump (keep reflecting shots)
		ld   b, ACTCOLI_PASS			; Otherwise, make intangible
	.setColi:
		call ActS_SetColiType
	pop  hl
	
	;
	; SPRITE ID
	;
	; Copy it almost as-is from byte0 to iActSprMap.
	;
	ldi  a, [hl]	; Read byte0, seek to byte1
	sla  a			; >> 3 since iActSprMap's first 3 bits are for the animation timer
	sla  a
	sla  a
	ldh  [hActCur+iActSprMap], a
	
	;
	; Y POSITION
	;
	; This needs to be adjusted due to the spike extending from the ceiling while actor origins are at the bottom.
	; The animation table defines it as an offset relative to the current position.
	;
	ldh  a, [hActCur+iActY]	; iActY += byte1
	add  [hl]
	ldh  [hActCur+iActY], a
	
	; For next time, advance animation to next entry
	ldh  a, [hActCur+iNePrAnimOff]
	add  $02 ; 
	ldh  [hActCur+iNePrAnimOff], a
	
	; Show current data for 12 frames
	ld   a, $0C
	ldh  [hActCur+iActTimer], a
	ret
	
; =============== Act_NeedlePress_AnimTbl ===============
; Defines the animation for extending and retracting the needle.
; Each entry is two bytes long:
; - 0: Sprite ID
;      This is used for two other purposes:
;      - As index to Act_NeedlePress_ColiBoxVTbl to get the vertical radius for the sprite
;      - To determine the collision type (see Act_NeedlePress_Main)
; - 1: Vertical offset compared to previous entry
Act_NeedlePress_AnimTbl:
	;  SPR  Y DIFF
	db $00, +$00
	db $00, +$00
	db $00, +$00
	db $01, +$08
	db $02, +$08
	db $03, +$10
	db $03, +$00
	db $03, -$00
	db $02, -$10
	db $01, -$08
	db $00, -$08
	db $00, -$00
	db $FF ; Terminator, loop to start

; =============== Act_NeedlePress_ColiBoxVTbl ===============
; Maps each sprite to its respective vertical radius. (the horizontal one is fixed, so it's not here)
Act_NeedlePress_ColiBoxVTbl: 
	db $03 ; $00
	db $03 ; $01
	db $07 ; $02
	db $0F ; $03

