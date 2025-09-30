; =============== Act_GroundExpl ===============
; ID: ACT_GROUNDEXPL
; Weird-looking looping explosion used during the Wily Castle cutscene, when ground explodes 
; from under Rockman and he falls into the teleporter room.
;
; For some reason, the graphics associated with this actor are stored next to Needle Cannon
; and Metal Blade' shot graphics, and expect to be loaded in VRAM where weapon GFX load.
;
; This actor is only used to perform the animation and play the explosion sound. The blocks
; the player falls through are never solid, the cutscene merely writes blank blocks to the tilemap
; during the explosion to give the effect of the two blocks being gone.
Act_GroundExpl:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_GroundExpl_Init
	dw Act_GroundExpl_Play

; =============== Act_GroundExpl_Init ===============
Act_GroundExpl_Init:
	; Weird sound effect choice
	mPlaySFX SFX_ENEMYDEAD
	; Use sprites $00-$02 at 1/8 speed
	ld   de, ($00 << 8)|$02
	ld   c, $08
	call ActS_InitAnimRange
	jp   ActS_IncRtnId
	
; =============== Act_GroundExpl_Play ===============
Act_GroundExpl_Play:
	; Wait until the explosion is finished
	call ActS_PlayAnimRange
	ret  z
	; Then loop back the to the first routine, resetting the animation.
	; This actor never despawns on its own, it's the screen transition that does it.
	xor  a
	ldh  [hActCur+iActRtnId], a
	ret
	
