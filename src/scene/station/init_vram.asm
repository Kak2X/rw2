; =============== WilyStation_LoadVRAM ===============
; Loads the Wily Station scene.
WilyStation_LoadVRAM:
	ld   a, GFXSET_STATION
	call GFXSet_Load
	push af
		ld   a, BANK(TilemapDef_WilyStation) ; BANK $04
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   de, TilemapDef_WilyStation
	call LoadTilemapDef
	push af
		ldh  a, [hROMBankLast]
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
