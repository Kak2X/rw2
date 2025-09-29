; =============== LoadGFX_Password ===============	
LoadGFX_Password:
	push af
		ld   a, BANK(GFX_Password) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; Loads in $100 bytes more than intended.
	; This makes it load GFX_TitleCursor, which isn't necessary.
	ld   hl, GFX_Password
	ld   de, $9000
	ld   bc, $0300
	call CopyMemory
	
	push af
		ld   a, BANK(GFX_SmallFont) ; BANK $09
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_SmallFont
	ld   de, $9400
	ld   bc, $0200
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
