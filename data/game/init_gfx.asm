; =============== LoadGFX_Level ===============
; GFX loader for levels.
; This is an unique one, as it needs to load different graphics depending on the current level.
LoadGFX_Level:
	
	;
	; First, load the player graphics.
	; These are always at GFX_Player, but for some reason, its pointer is defined 
	; in the actor art set table, as its first entry.
	;
	ld   hl, ActS_GFXSetTbl		; Seek to first table entry
	push af
		ldi  a, [hl]			; Read bank number ($0B), seek to high byte of art pointer
		ldh  [hRomBank], a		
		ld   [MBC1RomBank], a	; Bankswitch
	pop  af
	
	ld   a, [hl]				; HL = Source ptr (GFX_Player)
	ld   h, a
	ld   l, $00
	ld   de, $8000				; DE = Destination ptr (1st section)
	ld   bc, $0800				; BC = Bytes to copy
	call CopyMemory
	
	;
	; Load the level graphics.
	; These are defined in a separate table using the same format as ActS_GFXSetTbl,
	; except they are indexed by level ID and these graphics are $500 bytes long.
	;
	ld   hl, Lvl_GFXSetTbl		; HL = Table base ptr
	ld   a, [wLvlId]			; BC = wLvlId * 2
	sla  a
	ld   b, $00
	ld   c, a
	add  hl, bc					; Index it
	
	push af
		ldi  a, [hl]			; Read bank number (byte0)
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a	; Bankswitch
	pop  af
	
	ld   a, [hl]				; Read ptr high byte (byte1)
	ld   h, a
	ld   l, $00					; Low byte is hardcoded $00
	ld   de, $9000				; DE = Destination ptr (3rd section)
	ld   bc, $0500				; BC = Bytes to copy
	call CopyMemory
	
	;
	; Load shared graphics (status bar, ...)
	;
	push af
	ld   a, BANK(GFX_BgShared) ; BANK $0A
	ldh  [hRomBank], a
	ld   [MBC1RomBank], a
	pop  af
	ld   hl, GFX_BgShared
	ld   de, $9500
	ld   bc, $0300
	call CopyMemory
	
	; We're done, restore the default bank
	push af
		ldh  a, [hRomBankLast]
		ldh  [hRomBank], a
		ld   [MBC1RomBank], a
	pop  af
	ret
	
