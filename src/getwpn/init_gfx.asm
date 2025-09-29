; =============== LoadGFX_GetWpn ===============
LoadGFX_GetWpn:
	push af
		ld   a, BANK(GFX_GetWpn) ; BANK $0B
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   hl, GFX_GetWpn
	ld   de, $9000
	ld   bc, $0800
	call CopyMemory
	
	push af
		ld   a, BANK(GFX_SmallFont) ; BANK $09
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   hl, GFX_SmallFont
	ld   de, $8C00
	ld   bc, $0200
	call CopyMemory
	
	push af
		ldh  a, [hROMBankLast]
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
