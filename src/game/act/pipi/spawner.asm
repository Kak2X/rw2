; =============== Act_PipiSpawner ===============
; ID: ACT_PIPISPAWN
; Spawns Act_Pipi every ~1 second to the side of the screen.
Act_PipiSpawner:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_PipiSpawner_SetWait
	dw Act_PipiSpawner_Main
	DEF ACT_PIPISPAWN_SETWAIT = $00
	
; =============== Act_PipiSpawner_SetWait ===============
Act_PipiSpawner_SetWait:
	; Wait ~1 second before trying to spawn a Pipi.
	ld   a, $40
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_PipiSpawner_Main ===============
Act_PipiSpawner_Main:
	; Wait that ~1 second
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	; Regardless of the checks passing or failing, wait another second before trying to spawn another
	ld   a, ACT_PIPISPAWN_SETWAIT
	ldh  [hActCur+iActRtnId], a
	
	; If there's already a Pipi on-screen, don't spawn another one.
	ld   a, ACT_PIPI
	call ActS_CountById
	ld   a, b
	and  a
	ret  nz
	
	; Spawn the Pipi directly on top of the spawner...
	ld   a, ACT_PIPI
	ld   bc, $0000
	call ActS_SpawnRel
	; ...and immediately reposition it to the side of the screen the player is looking at.
	; This is how Pipi's work, except in this game the ladder climb animation makes the player turn, which is not good.
	ld   a, l			; Seek HL to Pipi's X position
	add  iActX
	ld   l, a
	; iActX = (wPlDirH << 7) + (wPlDirH << 6)
	; This results in...
	; [DIR]         | [X POS]
	; DIR_L ($00) | $00 (offscreen left)
	; DIR_R ($01) | $C0 (offscreen right)
	ld   a, [wPlDirH]	; A = Horizontal direction  | ($00 or $01)
	rrca 				; R>>1 bit0 to bit7         | ($00 or $80)
	ld   [hl], a		; Save this initial value
	rrca 				; R>>1 bit7 to bit6         | ($00 or $40)
	add  [hl]			; Merge with previous value | ($00 or $C0)
	ld   [hl], a		; Save back
	ret
	
