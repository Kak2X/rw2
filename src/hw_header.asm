; =============== HW ENTRY POINT ===============
	nop  
	jp   EntryPoint
; =============== GAME HEADER ===============
	; logo
	db   $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	db   $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	db   $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E
IF REV_VER == VER_JP
	db   " ROCKMAN WORLD2"	; title
	db   $20	; DMG - classic gameboy
ELSE
	db   "MEGA MAN 2",$00,$00,$00,$00,$00	; title
	db   $00	; DMG - classic gameboy
ENDC
	dw   $0000	; new license
	db   $00	; SGB flag: not SGB capable
	db   $01	; cart type: MBC1
	db   $03	; ROM size: 256KiB
	db   $00	; RAM size: 0KiB
IF REV_VER == VER_JP
	db   $00	; destination code: Japanese
ELSE
	db   $01	; destination code: non-Japanese
ENDC
	db   $08	; old license: not SGB capable
	db   $00	; mask ROM version number
IF REV_VER == VER_JP
	db   $B6	; header check
	dw   $650E	; global check
ELSE
	db   $72	; header check
	dw   $C4E6	; global check
ENDC