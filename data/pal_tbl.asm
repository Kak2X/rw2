	;  BG ,OBJ0,OBJ1, PAD
	db $E4, $E4, $E4, $00 ; GFXSET_TITLE
	db $E4, $1C, $C4, $00 ; GFXSET_STAGESEL
	db $E4, $1C, $C4, $00 ; GFXSET_PASSWORD
	db $E4, $1C, $C4, $00 ; GFXSET_LEVEL (Gets overwritten by Lvl_InitSettings / Lvl_PalTbl)
	db $E4, $E4, $E4, $00 ; GFXSET_GETWPN
	db $E4, $1C, $E4, $00 ; GFXSET_CASTLE
	db $E4, $1C, $E4, $00 ; GFXSET_STATION
	db $E4, $E4, $E4, $00 ; GFXSET_GAMEOVER
	db $1B, $1C, $E4, $00 ; GFXSET_SPACE