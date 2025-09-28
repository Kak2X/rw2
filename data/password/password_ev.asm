; =============== TilemapDef_PasswordError ===============
SETCHARMAP generic
TilemapDef_PasswordError:
.def00:
	wd $99E2
	db $00|(.eof-.start) ; $10
.start:
	db "PASS WORD ERROR!"
.eof: db $00

; =============== GfxDef_PasswordCursor ===============
GfxDef_PasswordCursor:
.def00:
	wd $8000
	db $00|(.eof-.start) ; TILESIZE
.start:
	INCBIN "data/password/cursor_gfx.bin"
.eof: db $00

