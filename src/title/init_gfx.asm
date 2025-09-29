; =============== LoadGFX_Title ===============
LoadGFX_Title:
	push af
		ld   a, BANK(GFX_TitleCursor) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_TitleCursor	; HL = Source ptr
	ld   de, $8000				; DE = Destination ptr
	ld   bc, $0080				; BC = Bytes to copy
	call CopyMemory				; Go!
	
	ld   hl, GFX_Title
	ld   de, $9000
	ld   bc, $0800
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
