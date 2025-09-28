; =============== Act_MoleSpawner ===============
; ID: ACT_MOLESPAWN
; Spawns moles and sets some of their safe properties.
Act_MoleSpawner:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_MoleSpawner_Spawn
	dw Act_MoleSpawner_Wait

; =============== Act_MoleSpawner_Spawn ===============
Act_MoleSpawner_Spawn:
	; Immediately spawn a mole, without even checking if it could spawn.
	ld   a, ACT_MOLE
	ld   bc, $0000
	call ActS_SpawnRel
	
	; ~2 second delay before spawning another mole
	ld   a, $80
	ldh  [hActCur+iActTimer], a
	;--
	
	inc  hl ; iActRtnId
	inc  hl ; iActSprMap
	
	;
	; The mole is currently directly on top of the spawner.
	;
	; The horizontal position can't be changed here since we may have to
	; re-roll the dice in the next frame, in case we roll a position too close
	; to the player, which is not convenient to do inside the spawner.
	;
	; There are no such issues with randomizing the vertical position here, so do that.
	;
	
	; Randomize the vertical direction, without any mungling.
	call Rand		; A = Rand()
	and  ACTDIR_D	; Only keep the vertical direction flag (bit6)
	ld   b, a
		xor  [hl]		; This does nothing, iActRtnId is always 0 here
		ld   [hl], a	; Save udated directions
		
		;
		; The direction should also affect the mole's Y position, as:
		; - Moles that move up (ACTDIR_D clear, $00) should spawn on the bottom ($98)
		; - Those that move down (ACTDIR_D set, $40) should spawn on the top ($18)
		;
		; The Y position we want is quite close to the direction value we have 
		; (<< 1, then invert bit7, then offset by $18)
		;
		ld   de, iActY-iActSprMap	; Seek to Y position
		add  hl, de
	ld   a, b		; B = Vertical direction
	add  a			; << 1, to shift bit6 into bit7
	xor  (ACTDIR_D << 1) ; Invert that bit 7
	ld   b, a		; Save raw Y pos
		; Shift the spawning lines 24px below.
		; This avoids spawning the top ones off-screen and the bottom ones too high up.
		add  $18		; Y += $18 
		ld   [hl], a	; Save to iActY
		
		;
		; The mole uses two different animations depending on which direction it's travelling.
		; Both are made of 2 sprites, so toggle them through bit1.
		; $00-$01 => When digging down
		; $02-$03 => When digging up
		;
		add  hl, de 	; iActTimer-iActY
		inc  hl 		; iMoleSprMapBaseId
	ld   a, b		; Get base $00-$80 position
	rlca 			; bit7 to bit0
	rlca 			; bit0 to bit1
	ld   [hl], a	; Save to iMoleSprMapBaseId
	jp   ActS_IncRtnId
	
; =============== Act_MoleSpawner_Wait ===============
Act_MoleSpawner_Wait:
	; Wait those ~2 seconds before spawning another mole
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	jp   ActS_DecRtnId
	
