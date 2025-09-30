; =============== Module_Game_InitScrOff ===============
; Initializes the level data while the screen is turned off.
Module_Game_InitScrOff:
	ld   a, GFXSET_LEVEL
	call GFXSet_Load		; Turns the screen off
	call Lvl_LoadData		; Load level data
	call Lvl_InitSettings	; Load settings
	call Lvl_DrawFullScreen ; Draw spawn screen
	call Pl_Init			; Initialize player
	call ActS_InitMemory		; Delete any remaining actors
	jp   ActS_SpawnRoom		; and write new ones for the current room
	
; =============== Module_Game_InitScrOn ===============
; Initializes the level data while the screen is turned on.
; Almost always called immediately after Module_Game_InitScrOff.
Module_Game_InitScrOn:
	call StartLCDOperation	; Turns the screen on
	call Pl_RunInitEv		; Finish up player spawn events
	
	; Finally, request playing the level's BGM
	ld   a, [wLvlId]		; hBGMSet = Lvl_BGMTbl[wLvlId]
	ld   hl, Lvl_BGMTbl
	ld   b, $00
	ld   c, a
	add  hl, bc
	ld   a, [hl]
	mPlayBGM a
	ret
	
