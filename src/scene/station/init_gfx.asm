; =============== LoadGFX_WilyStation ===============
LoadGFX_WilyStation:
	push af
		ld   a, BANK(GFX_WilyStation) ; BANK $0C
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_WilyStation
	ld   de, $8800
	ld   bc, $1000
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
