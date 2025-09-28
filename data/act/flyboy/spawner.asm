; =============== Act_FlyBoySpawner ===============
; ID: ACT_FLYBOYSPAWN
; Fly Boy spawner.
Act_FlyBoySpawner:
	ldh  a, [hActCur+iActRtnId]
	rst  $00 ; DynJump
	dw Act_FlyBoySpawner_Init
	dw Act_FlyBoySpawner_Main

; =============== Act_FlyBoySpawner_Init ===============
Act_FlyBoySpawner_Init:
	; Wait ~3 seconds before spawning one in.
	; This is way too shot, making it easy to miss them in the only place they are used.
	ld   a, $C0
	ldh  [hActCur+iActTimer], a
	jp   ActS_IncRtnId
	
; =============== Act_FlyBoySpawner_Main ===============
Act_FlyBoySpawner_Main:
	; Wait until the delay elapses before spawning another one
	ldh  a, [hActCur+iActTimer]
	sub  $01
	ldh  [hActCur+iActTimer], a
	ret  nz
	
	; Set the same very long delay
	ld   a, $C0
	ldh  [hActCur+iActTimer], a
	
	; Max 2 Fly Boys on screen, otherwise try again after 3 seconds
	ld   a, ACT_FLYBOY
	call ActS_CountById
	ld   a, b
	cp   $02
	jp   nc, ActS_DecRtnId
	
	; Spawn directly on top of the spawner.
	; The spawner is set around the top of the screen, making these enemies fall in.
	ld   a, ACT_FLYBOY
	ld   bc, $0000
	call ActS_SpawnRel	; HL = Ptr to spawned Fly Boy
	ret  c				; Did it spawn? If not, return
	
	; Not necessary, this is already done by the Fly Boy's init code
	ld   a, l
	add  iActYSub
	ld   l, a
	xor  a
	ldi  [hl], a ; iActYSub
	ld   [hl], a ; iActY
	ret
	
