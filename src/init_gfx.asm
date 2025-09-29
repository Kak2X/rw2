; =============== GFXSet_Load ===============
; Loads a set of graphics and wipes the tilemaps clean.
;
; Each has a specific palette assigned, as well as custom code
; used for uploading graphics to VRAM.
;
; After calling the subroutine, typically you'd want to load in
; the tilemaps as needed (ie: passing them to LoadTilemapDef).
;
; IN
; - A: Set ID (GFXSET_*)
GFXSet_Load:
	;
	; Stop the screen first, since we're going to write a bunch to VRAM.
	;
	push af
		call OAM_ClearAll	; Start fresh, deleting any old sprites
		rst  $08 ; Wait Frame, to visually see the sprites being gone
		call StopLCDOperation ; Only then stop the screen
	pop  af
	
	;
	; Apply the color palette.
	;
	push af
		; Index .palTbl by scene ID
		add  a				; Each entry is 4 bytes long
		add  a
		ld   hl, .palTbl	; Seek to .palTbl[A]
		ld   b, $00
		ld   c, a
		add  hl, bc
		
		; Apply the entry's palettes
		ldi  a, [hl]	; byte0 - BG Palette
		ldh  [hBGP], a
		ldi  a, [hl]	; byte1 - OBJ Palette 0
		ldh  [hOBP0], a
		ldi  a, [hl]	; byte2 - OBJ Palette 1
		ldh  [hOBP1], a
	pop  af
	
	;
	; Run the set-specific GFX loader code
	;
	call .exec
	
	;
	; With the GFX loaded, clear the tilemaps using the first blank tile found.
	;
	jp   ClearTilemaps
	
; =============== .palTbl ===============
; Palettes associated with each set of graphics.	
.palTbl: INCLUDE "src/pal_tbl.asm"

; =============== .exec ===============
; Jump table to set-specific init code.
; IN
; - A: Set ID (GFXSET_*)
.exec:
	rst  $00 ; DynJump
	dw LoadGFX_Title       ; GFXSET_TITLE
	dw LoadGFX_StageSel    ; GFXSET_STAGESEL
	dw LoadGFX_Password    ; GFXSET_PASSWORD
	dw LoadGFX_Level       ; GFXSET_LEVEL
	dw LoadGFX_GetWpn      ; GFXSET_GETWPN
	dw LoadGFX_WilyCastle  ; GFXSET_CASTLE
	dw LoadGFX_WilyStation ; GFXSET_STATION
	dw LoadGFX_GameOver    ; GFXSET_GAMEOVER
	dw LoadGFX_Space       ; GFXSET_SPACE
	
