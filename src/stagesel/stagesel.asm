; =============== Module_StageSel ===============
; Stage Select screen.
Module_StageSel:
	;--
	;
	; Load VRAM
	;
	ld   a, GFXSET_STAGESEL
	call GFXSet_Load
	push af
		ld   a, BANK(TilemapDef_StageSel) ; BANK $04
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	ld   de, TilemapDef_StageSel
	call LoadTilemapDef
	push af
		ldh  a, [hROMBankLast]
		ldh  [hROMBank], a
		ld   [MBC1RomBank], a
	pop  af
	
	;
	; Clear portraits of defeated bosses
	;
	ld   a, [wWpnUnlock0]
	
	; We only want the completion status of the first set of bosses.
	; For some reason Top Man takes up bit0, with the first set of bosses coming next.
	rra						; Shift out Top Man
	
	; Shift the four bits one by one
	ld   c, a				; C = First set completion in low nybble
	ld   b, $04				; B = Remaining bits to check
.bossClrLoop:
	push bc					; Save count
		srl  c					; >> boss bit out to carry
		jr   nc, .bossNotDone	; Is the boss cleared? If not, skip
		
		; Otherwise, wipe the portrait
		ld   a, b			; A = Pic index
		dec  a
		call StageSel_MkEmptyPicTilemap		; Build the tilemap
		ld   de, wTilemapBuf
		call LoadTilemapDef	; Execute it immediately
.bossNotDone:
	pop  bc					; Restore count
	srl  c					; Redo this due to the pop
	dec  b					; Are we done?
	jr   nz, .bossClrLoop	; If not, loop
	
	; The lower half of the stage select is drawn on the WINDOW,
	; to allow the screen split effect when selecting a stage.
	ld   a, $07				; Left corner
	ldh  [hWinX], a
	ld   a, SCREEN_V/2		; Middle
	ldh  [hWinY], a
	
	ld   a, $01				; [POI] Useless line
	call StartLCDOperation
	;--
	
	ld   c, BGM_CHARSELECT
	mPlayBGM
	
	xor  a
	ld   [wStageSelCursor], a
.loop:
	;
	; MAIN LOOP
	;
	
	rst  $08 ; Wait Frame
	
	call StageSel_DrawCursor
	call JoyKeys_Refresh
	
	ldh  a, [hJoyNewKeys]
	ld   c, a				; C = hJoyNewKeys
	or   a					; Pressed any keys?
	jr   z, .loop			; If not, loop
	
	ld   a, [wStageSelCursor]
	ld   b, a				; B = wStageSelCursor
	
.chkStageSel:
	;
	; START or A -> Select a stage
	;
	ld   a, c
	and  KEY_START|KEY_A	; Pressing START or A?
	jr   z, .chkMoveH		; If not, skip
	
	; For whatever reason, the first set of bosses takes up level IDs $04-$07,
	; while the second set takes up $00-$03.
	; That's the other way around from the cursor position, so toggle bit2.
	; Other than that, this implies a requirement that the cursor positions
	; and level IDs should be consistent.
	ld   a, b				; wLvlId = wStageSelCursor ^ $04
	xor  %100
	ld   [wLvlId], a
	
	;
	; Prevent revisiting completed stages
	;
	
	; Find the completion bit to this stage
	; B = Lvl_ClearBitTbl[wLvlId]
	ld   hl, Lvl_ClearBitTbl
	ld   b, $00
	ld   c, a
	add  hl, bc	
	ld   b, [hl]
	; If it's set in our completion flags, disregard the selection and return
	ld   a, [wWpnUnlock0]
	and  b					; wWpnUnlock0 & B != 0?
	jr   nz, .loop			; If so, we've already beaten it
	
	jp   StageSel_BossIntro
.chkMoveH:
	;
	; LEFT/RIGHT -> Move cursor horizontally
	;
	ld   a, c
	and  KEY_LEFT|KEY_RIGHT	; Pressing L o R?
	jr   z, .chkMoveV		; If not, skip
	
	; The cursor is only able to move on a 2x2 grid.
	; Therefore, all we need here is toggling bit 0.
	ld   a, b
	xor  %01
	ld   [wStageSelCursor], a
	
	ld   c, SFX_CURSORMOVE
	mPlaySFX
	jr   .loop
	
.chkMoveV:
	;
	; UP/DOWN -> Move cursor vertically
	;
	ld   a, c
	and  KEY_DOWN|KEY_UP	; Pressing U or D?
	jr   z, .loop			; If not, nothing else to do
	
	; Like the one above, but with the other bit
	ld   a, b
	xor  %10
	ld   [wStageSelCursor], a
	
	ld   c, SFX_CURSORMOVE
	mPlaySFX
	jr   .loop
	
; =============== StageSel_DrawCursor ===============
; Draws the cursor sprite for the stage select.
StageSel_DrawCursor:
	; The sprites for the cursor are hardcoded for each position.
	; Since the cursor is made of 4 sprites, and each sprite takes up 4 bytes,
	; that's $10 bytes for each position.
	ld   a, [wStageSelCursor]
	and  $03				; Force valid range 0-3
	swap a					; * $10
	ld   hl, StageSel_CursorSprTbl
	ld   b, $00
	ld   c, a
	add  hl, bc				; Seek to entry we want
	
	ld   de, wWorkOAM		; Copy those $10 bytes over
	ld   bc, $0010
	call CopyMemory
	
	;
	; Thankfully the palette animation isn't hardcoded.
	; Every 8 frames, switch between OBP0 & OBP1.
	;
	
	; Turn hTimer into iObjAttr
	ldh  a, [hTimer]		
	sla  a
	and  SPR_OBP1 ; $10			; A = iObjAttr
	
	; Overwrite all flags with this
	ld   b, $04					; B = Sprites to edit
	ld   hl, wWorkOAM+iObjAttr	; HL = First sprite
.loop:
	ldi  [hl], a				; Set flags, seek to iObjY
	inc  l						; ...iObjX
	inc  l						; ...iObjTileId
	inc  l						; ...iObjAttr
	dec  b						; Are we there yet?
	jr   nz, .loop				; If not, loop
	
	xor  a	; Ok I guess
	ret
	
; =============== StageSel_CursorSprTbl ===============
StageSel_CursorSprTbl:
	INCLUDE "src/stagesel/cursor_rspr.asm"