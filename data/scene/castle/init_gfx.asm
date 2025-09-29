; =============== LoadGFX_WilyCastle ===============
LoadGFX_WilyCastle:
	push af
		ld   a, BANK(GFX_SpaceOBJ) ; BANK $0C
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_SpaceOBJ
	ld   de, $8000
	ld   bc, $0800
	call CopyMemory
	
	ld   hl, GFX_WilyCastle
	ld   de, $8800
	ld   bc, $1000
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
