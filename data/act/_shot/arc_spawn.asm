; =============== ActS_SpawnArcShot ===============
; Spawns a shot that follows a vertical arc.
; IN
; - A: Shot direction and sprite ID (iActSprMap)
; - B: Relative X pos
; - C: Relative Y pos
; - D: Vertical speed (px/frame)
; - E: Actor ID
;      This should point to a shot that respects gravity.
ActS_SpawnArcShot:
	; Save these two for later
	DEF tActSprMap = wTmpCFE6
	DEF tActSpdV = wTmpCFE7
	ld   [tActSprMap], a	; Save A
	ld   a, d
	ld   [tActSpdV], a		; Save D
	
	;
	; Attempt to spawn the shot actor
	;
	ld   a, e
	call ActS_SpawnRel		; HL = Ptr to spawned slot
	ret  c					; Could it spawn? If not, return
	
	;
	; Adjust the shot's properties.
	;
	push hl ; Save slot ptr
	
		;
		; HORIZONTAL SPEED
		; 
		; Adjusted to try homing into the player, by pick a different one depending on how far away the player is.
		; This is read off a table indexed by horizontal distance, in groups of 2 blocks.
		;
	
		; Index = (Distance / $10) & $0E
		call ActS_GetPlDistanceX	; Get distance in pixels
		swap a						; / $10 to get distance in blocks
		and  $0E					; Fix for above + remove the lowest bit.
									; The latter is because we're indexing a word table so offsets can't be odd,
									; but it also has the effect of each index being used for two blocks.
		; Index the table with that
		ld   hl, ActS_ArcShotSpdXTbl	; HL = Table base
		ld   b, $00			; BC = Index
		ld   c, a
		add  hl, bc			; Seek to entry
		; Read out to the registers expected by ActS_SetShotSpd
		ld   c, [hl]		; C = Horizontal speed (subpixels)
		inc  hl
		ld   b, [hl]		; B = Horizontal speed (pixels)
		
		;
		; VERTICAL SPEED
		;
		; Passed from this subroutine, in pixels.
		;
		ld   a, [tActSpdV]
		ld   d, a			; D = tActSpdV
		ld   e, $00			; E = $00
		
		;
		; SHOT DIRECTION / SPRITE ID
		;
		; Also passed from this subroutine.
		;
		ld   a, [tActSprMap] ; A = tActSprMap
		
	pop  hl ; HL = Ptr to spawned slot
	jp   ActS_SetShotSpd
	
; =============== ActS_ArcShotSpdXTbl ===============
; Horizontal shot speed based on the player's distance, in groups of 2 blocks.
ActS_ArcShotSpdXTbl:
	;  SPEED | px/frame | PLAYER DISTANCE
	dw $0080 ;     0.5  | $00-$1F
	dw $00C0 ;     0.75 | $20-$3F
	dw $0100 ;     1.0  | $40-$5F
	; [POI] The rest are too far away, and don't happen to get used
	dw $0180 ;     1.5  | $60-$7F
	dw $01C0 ;     1.75 | $80-$9F
	dw $0200 ;     2.0  | $A0-$BF
	dw $0280 ;     2.5  | $C0-$DF
	dw $0300 ;     3.0  | $E0-$FF


