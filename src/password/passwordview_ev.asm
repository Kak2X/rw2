; =============== TilemapDef_PasswordKeyPrompt ===============
TilemapDef_PasswordKeyPrompt:
SETCHARMAP generic
.def00:
	wd $99E2
	db $00|(.eof-.start) ; $10
.start:
	db " PRESS A BUTTON "
.eof: db $00

TilemapDef_PasswordDotsTemplate: INCLUDE "src/password/dots_template_bg.asm"
.end:
TilemapDef_Password: INCLUDE "src/password/password_bg.asm"

