; =============== LoadGFX_GameOver ===============
LoadGFX_GameOver:
	push af
		ld   a, BANK(GFX_NormalFont) ; BANK $0B
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_NormalFont
	ld   de, $8400
	ld   bc, $0200
	call CopyMemory
	
	ld   hl, GFX_NormalFont
	ld   de, $9400
	ld   bc, $0200
	call CopyMemory
	
	push af
		ld   a, BANK(GFX_Unused_HexFont) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; [TCRF] Why is this being loaded on the game over screen ... ?
	
	ld   hl, GFX_Unused_HexFont
	ld   de, $8600
	ld   bc, $0200
	call CopyMemory
	
	ld   hl, GFX_Unused_HexFont
	ld   de, $9600
	ld   bc, $0200
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
