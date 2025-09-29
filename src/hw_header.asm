; =============== HW ENTRY POINT ===============
	nop  
	jp   EntryPoint
; =============== GAME HEADER ===============
	; logo
	db   $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	db   $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	db   $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E
	db   " ROCKMAN WORLD2"	; title
	db   $20	; DMG - classic gameboy
	dw   $0000	; new license
	db   $00	; SGB flag: not SGB capable
	db   $01	; cart type: MBC1
	db   $03	; ROM size: 256KiB
	db   $00	; RAM size: 0KiB
	db   $00	; destination code: Japanese
	db   $08	; old license: not SGB capable
	db   $00	; mask ROM version number
	db   $B6	; header check
	dw   $650E	; global check
	
