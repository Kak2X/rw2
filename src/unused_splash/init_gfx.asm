; =============== LoadGFX_Title ===============
; [TCRF] Art loading code for an unimplemented splash screen, likely similar to
;        the one in the European version of the first game.
;        This only exists in the European version.
LoadGFX_Unused_Splash:
	push af
		ld   a, BANK(GFX_Unused_SplashFont) ; BANK $0D
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af

	ld   hl, GFX_Unused_SplashFont		; HL = Source ptr
	ld   de, $9000						; DE = Destination ptr
	ld   bc, $0800						; BC = Bytes to copy
	call CopyMemory						; Go!
	
	push af
		ldh  a, [hROMBankLast]
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret