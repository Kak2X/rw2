; =============== LoadGFX_Space ===============
LoadGFX_Space:
	push af
		ld   a, BANK(Marker_GFX_Wpn) ; BANK $0B
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	; This copies $800 bytes starting from Marker_GFX_Wpn, to loads all weapon sets at once.
	; What we actually need though are some graphics scattered here and there:
	; - Rush Marine's sprite from GFX_Wpn_RcWdHa, which is reused as a spaceship...
	; - ...with a few altered tiles stored within GFX_Wpn_Rj.
	; - The explosion in GFX_Wpn_MeNe, which is also used when the ground explodes during
	;   the Wily Castle cutscene.
	ASSERT GFX_Wpn_RcWdHa-Marker_GFX_Wpn == $000, "GFX_Wpn_RcWdHa should at the same location as Marker_GFX_Wpn"
	ASSERT GFX_Wpn_Rm-Marker_GFX_Wpn     == $100, "GFX_Wpn_Rm should be $100 bytes from Marker_GFX_Wpn"
	ASSERT GFX_Wpn_MeNe-Marker_GFX_Wpn   == $700, "GFX_Wpn_MeNe should be $700 bytes from Marker_GFX_Wpn"
	ld   hl, Marker_GFX_Wpn
	ld   de, $8800
	ld   bc, $0800
	call CopyMemory
	
	push af
		ld   a, BANK(GFX_SpaceOBJ) ; BANK $0C
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   hl, GFX_SpaceOBJ
	ld   de, $8000
	ld   bc, $0800
	call CopyMemory
	
	ld   hl, GFX_Space
	ld   de, $9000
	ld   bc, $0800
	call CopyMemory
	
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
