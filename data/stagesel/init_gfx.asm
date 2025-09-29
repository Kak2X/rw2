; =============== LoadGFX_StageSel ===============	
LoadGFX_StageSel:
	push af
		ld   a, BANK(GFX_Password) ; BANK $0A
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; This copies $800 bytes starting from GFX_Password.
	; This effectively loads:
	; - GFX_Password for the borders/backdrop
	; - GFX_Title_Dots & GFX_TitleCursor, which are useless but are in the way
	; - GFX_StageSel, containing the cursor and the boss portraits.
	ASSERT GFX_StageSel - GFX_Password == $300, "GFX_StageSel is required to be $300 bytes after GFX_Password"
	
	; On top of that, even though there's only one tile used for sprites before the boss loads in,
	; that whole set gets loaded twice for both OBJ and BG.

	ld   hl, GFX_Password
	ld   de, $8000			; For OBJ
	ld   bc, $0800
	call CopyMemory
	
	ld   hl, GFX_Password
	ld   de, $9000			; For BG
	ld   bc, $0800
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
