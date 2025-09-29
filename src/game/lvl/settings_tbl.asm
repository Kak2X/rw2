; =============== Lvl_GFXSetTbl ===============
; Maps each stage to their graphics.
; These have a fixed size of $500 bytes, as the remaining $300 are taken up by GFX_BgShared.
Lvl_GFXSetTbl:
	mGfxDef2 GFX_LvlHard    ; $00 ; LVL_HARD
	mGfxDef2 GFX_LvlTop     ; $01 ; LVL_TOP
	mGfxDef2 GFX_LvlMagnet  ; $02 ; LVL_MAGNET
	mGfxDef2 GFX_LvlNeedle  ; $03 ; LVL_NEEDLE
	mGfxDef2 GFX_LvlCrash   ; $04 ; LVL_CRASH
	mGfxDef2 GFX_LvlMetal   ; $05 ; LVL_METAL
	mGfxDef2 GFX_LvlWood    ; $06 ; LVL_WOOD
	mGfxDef2 GFX_LvlAir     ; $07 ; LVL_AIR
	mGfxDef2 GFX_LvlCastle  ; $08 ; LVL_CASTLE
	mGfxDef2 GFX_LvlStation ; $09 ; LVL_STATION

; =============== StageSel_BossGfxTbl ===============
; Maps each stage to its boss graphics (entries to ActS_GFXSetTbl)
; [TCRF] This explicitly accounts for the second set of bosses being selected.
StageSel_BossGfxTbl:
	db ACTGFX_HARDMAN   ; LVL_HARD  
	db ACTGFX_TOPMAN    ; LVL_TOP   
	db ACTGFX_MAGNETMAN ; LVL_MAGNET
	db ACTGFX_NEEDLEMAN ; LVL_NEEDLE
	db ACTGFX_CRASHMAN  ; LVL_CRASH 
	db ACTGFX_METALMAN  ; LVL_METAL 
	db ACTGFX_WOODMAN   ; LVL_WOOD  
	db ACTGFX_AIRMAN    ; LVL_AIR   

; =============== Lvl_ClearBitTbl ===============
; Maps each stage to its own completion bit in wWpnUnlock0.
Lvl_ClearBitTbl: 
	db WPU_HA ; LVL_HARD
	db WPU_TP ; LVL_TOP
	db WPU_MG ; LVL_MAGNET
	db WPU_NE ; LVL_NEEDLE
	db WPU_CR ; LVL_CRASH
	db WPU_ME ; LVL_METAL
	db WPU_WD ; LVL_WOOD
	db WPU_AR ; LVL_AIR
	db $00    ; LVL_CASTLE (unselectable)
	db $00    ; LVL_STATION (unselectable)

; =============== Lvl_PalTbl ===============
; Palettes associated to each stage, see Lvl_InitSettings.
; Every stage has a 2-frame animated palette, most use the same one
; and repeat the same colors twice, disabling the animation.
Lvl_PalTbl:
	db $E4,$E4 ; LVL_HARD
	db $E4,$E4 ; LVL_TOP
	db $E4,$E4 ; LVL_MAGNET
	db $E4,$E4 ; LVL_NEEDLE
	db $E4,$E4 ; LVL_CRASH
	db $E0,$EC ; LVL_METAL
	db $E4,$E4 ; LVL_WOOD
	db $E1,$E1 ; LVL_AIR
	db $E4,$E4 ; LVL_CASTLE
	db $E4,$E4 ; LVL_STATION

; =============== Lvl_BGMTbl ===============
; Assigns music tracks to each level.
Lvl_BGMTbl:
	db BGM_HARDMAN    ; LVL_HARD   
	db BGM_TOPMAN     ; LVL_TOP    
	db BGM_MAGNETMAN  ; LVL_MAGNET 
	db BGM_NEEDLEMAN  ; LVL_NEEDLE 
	db BGM_CRASHMAN   ; LVL_CRASH  
	db BGM_METALMAN   ; LVL_METAL  
	db BGM_WOODMAN    ; LVL_WOOD   
	db BGM_AIRMAN     ; LVL_AIR    
	db BGM_WILYCASTLE ; LVL_CASTLE 
	db BGM_TITLE      ; LVL_STATION
	
; =============== Lvl_BGMTbl ===============
; Assigns checkpoints to each level, as room IDs.
; Each level has a fixed number of four checkpoints, which MUST be sequential.
; To have less checkpoints, entries are either duplicated or marked with $20, which is higher than the last reachable room ID.
Lvl_CheckpointTbl:
	db $01,$0B,$11,$15 ; LVL_HARD
	db $01,$0A,$10,$16 ; LVL_TOP
	db $01,$07,$0E,$16 ; LVL_MAGNET
	db $01,$06,$11,$17 ; LVL_NEEDLE
	db $01,$08,$0E,$17 ; LVL_CRASH
	db $01,$07,$12,$17 ; LVL_METAL
	db $01,$09,$10,$15 ; LVL_WOOD
	db $01,$09,$09,$16 ; LVL_AIR
	db $04,$20,$20,$20 ; LVL_CASTLE
	db $01,$0A,$0A,$16 ; LVL_STATION

; =============== Lvl_WaterFlagTbl ===============
; Marks which levels have water.
Lvl_WaterFlagTbl:
	db $00 ; LVL_HARD
	db $01 ; LVL_TOP
	db $00 ; LVL_MAGNET
	db $00 ; LVL_NEEDLE
	db $00 ; LVL_CRASH
	db $00 ; LVL_METAL
	db $01 ; LVL_WOOD
	db $00 ; LVL_AIR
	db $00 ; LVL_CASTLE
	db $01 ; LVL_STATION

