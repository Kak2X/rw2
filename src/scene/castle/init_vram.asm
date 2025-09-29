; =============== WilyCastle_LoadVRAM ===============
; Loads the Wily Castle scene, used for two cutscenes.
WilyCastle_LoadVRAM:
	ld   a, GFXSET_CASTLE
	call GFXSet_Load
	
	push af
		ld   a, BANK(TilemapDef_WilyCastle) ; BANK $04
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   de, TilemapDef_WilyCastle
	call LoadTilemapDef
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
; =============== WilyCastle_DrawRockman ===============
; Draws Rockman's sprite for the Wily Castle cutscene.
; Presumably because it's a fixed sprite that doesn't animate,
; it's defined as raw OBJ data rather than as a sprite mapping.
WilyCastle_DrawRockman:
	ld   hl, WilyCastle_RockmanSpr
	ld   de, wWorkOAM
	ld   bc, WilyCastle_RockmanSpr.end-WilyCastle_RockmanSpr
	jp   CopyMemory
; =============== WilyCastle_RockmanSpr ===============
WilyCastle_RockmanSpr: 
	INCLUDE "src/scene/castle/pl_rspr.asm"
.end:

