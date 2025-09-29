; =============== NonGame_DoFor ===============
; Runs the pseudo-gameplay loop for the specified amount of frames.
; IN
; - B: Number of frames
NonGame_DoFor:
	call NonGame_Do
	dec  b
	jr   nz, NonGame_DoFor
	ret
	
; =============== NonGame_Do ===============
; Pseudo-gameplay.
; Cut down version of the gameplay loop (Module_Game) with no player interaction that executes for a single frame.
; This makes it useful for in-engine cutscenes, as it lets the caller determine when to pause of exit out of "gameplay"
; rather than doing it indirectly through actors. Note that when doing so, whatever sprites set by the last call 
; to NonGame_Do stay on screen, which is useful for freeze pausing. 
;
; As it's meant for cutscene modes, this does not poll for player controls, typically they are faked by the caller.
; Note that when this subroutine isn't called, the previous sprites stay on screen.
NonGame_Do:
	push hl
	push de
	push bc
		rst  $08 ; Wait Frame
		
		; [BUG] This is forgetting to animate palettes.
		;       It's why defeating Metal Man stops the conveyor belt's animation.
		; [POI] Player-actor collision is ignored. Not needed during cutscenes anyway.
		
		; Prepare for drawing any sprites, overwriting what was there before.
		xor  a
		ldh  [hWorkOAMPos], a
		
		call Pl_Do				; Run gameplay
		call WpnS_Do ; BANK $01 ; Process on-screen shots 
		
		; Run actor code
		push af
			ld   a, BANK(ActS_Do); BANK $02
			ldh  [hRomBankLast], a
			ldh  [hRomBank], a
			ld   [MBC1RomBank], a
		pop  af
		call ActS_Do
		push af
			ld   a, $01
			ldh  [hRomBankLast], a
			ldh  [hRomBank], a
			ld   [MBC1RomBank], a
		pop  af
		
		call OAM_ClearRest	; Rest wait
		call Game_TickTime	; Tick gameplay clock & process refills
	pop  bc
	pop  de
	pop  hl
	ret
	
