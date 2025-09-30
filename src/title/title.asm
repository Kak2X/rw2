; =============== Module_Title ===============
; Title screen module.
; OUT
; - Z Flag: If set, GAME START was selected. PASS WORD otherwise.
Module_Title:
	;
	; Load VRAM
	;
	xor  a ; GFXSET_TITLE
	call GFXSet_Load
	push af
		ld   a, BANK(TilemapDef_Title) ; BANK $04
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	ld   de, TilemapDef_Title
	call LoadTilemapDef
	
	push af
		ldh  a, [hROMBankLast]
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	call StartLCDOperation
	;--
	
	mPlayBGM BGM_TITLE
	
	;
	; Define the cursor sprite.
	; Its Y position also doubles as the selected option.
	;
	ld   hl, wCursorObj
	ld   a, $68		; Y Position
	ldi  [hl], a
	ld   a, $2E		; X Position
	ldi  [hl], a
	xor  a
	ldi  [hl], a	; Tile ID	
	ld   [hl], a	; Attribute
	
	; For some reason the selection change code is right here,
	; getting executed once before even making a choice.
	; This means that, to have GAME START selected by default,
	; the initial Y position from above actually points to PASS WORD.
	
.changeSel:
	; Switch between GAME START and PASS WORD
	; by alternating between Y positions $60 and $68
	ld   a, [wCursorObj+iObjY]
	xor  $08
	ld   [wCursorObj+iObjY], a
	
.loop:
	rst  $08 ; Wait Frame
	
	;--
	; This is 100% identical to the respective code in FlashBGPalLong.
	; 1/8 chance of flashing palette every 4 frames.
	ldh  a, [hTimer]
	and  $03
	jr   nz, .wait
	ld   b, $E4
	call Rand
	cp   $20
	jr   nc, .setPal
	ld   b, $C0
.setPal:
	ld   a, b
	ldh  [hBGP], a
.wait:
	;--
	
	; Animate the cursor every 4 frames
	; by cycling its tile ID from 0 to 7, then wrapping back.
	ldh  a, [hTimer]
	and  $1C			; iObjTileId = (hTimer / 4) % 8
	srl  a
	srl  a
	ld   [wCursorObj+iObjTileId], a
	
	; Check for player input
	call JoyKeys_Refresh
	ldh  a, [hJoyNewKeys]
	and  KEY_DOWN|KEY_UP|KEY_START|KEY_SELECT|KEY_A	; Pressed any of the keys that matter? 
	jr   z, .loop									; If not, loop
	and  KEY_DOWN|KEY_UP|KEY_SELECT					; Pressed any of the toggle keys?
	jr   z, .sel									; If not, we've definitely pressed A or START
	; Otherwise, toggle the selection
	mPlaySFX SFX_CURSORMOVE
	jr   .changeSel
.sel:
	; [POI] Disable the invulnerability cheat.
	;       Curiously, this address wasn't reset at boot, it only gets written to here.
	;       Presumably you could hold something to enable the cheat mode here?
IF CHEAT_ON
	ld   a, $01
ELSE
	xor  a
ENDC
	ldh  [hCheatMode], a
	
	; If GAME START is selected, the cursor's Y position will be $60.
	; As $60 & 8 is 0, it will return the Z flag.
	ld   a, [wCursorObj+iObjY]
	and  $08
	ret
	
